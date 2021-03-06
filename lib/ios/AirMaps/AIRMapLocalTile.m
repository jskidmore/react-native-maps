//
//  AIRMapLocalTile.m
//  AirMaps
//
//  Created by Peter Zavadsky on 01/12/2017.
//  Copyright © 2017 Christopher. All rights reserved.
//

#import "AIRMapLocalTile.h"
#import <React/UIView+React.h>
#import "AIRMapLocalTileOverlay.h"

@implementation AIRMapLocalTile {
    BOOL _pathTemplateSet;
    BOOL _tileSizeSet;
}

- (void)setShouldReplaceMapContent:(BOOL)shouldReplaceMapContent
{
  _shouldReplaceMapContent = shouldReplaceMapContent;
  if(self.tileOverlay) {
    self.tileOverlay.canReplaceMapContent = _shouldReplaceMapContent;
  }
  [self update];
}

- (void)setFlipY:(BOOL)flipY
{
  _flipY = flipY;
  if (self.tileOverlay) {
    self.tileOverlay.geometryFlipped = _flipY;
  }
  [self update];
}

- (void)setPathTemplate:(NSString *)pathTemplate{
    _pathTemplate = pathTemplate;
    _pathTemplateSet = YES;
    [self createTileOverlayAndRendererIfPossible];
    [self update];
}

- (void)setTileSize:(CGFloat)tileSize{
    _tileSize = tileSize;
    _tileSizeSet = YES;
    [self createTileOverlayAndRendererIfPossible];
    [self update];
}

- (void)setOverlayOpacity:(CGFloat)overlayOpacity{
    _overlayOpacity = overlayOpacity;
    if (self.renderer) {
      self.renderer.alpha = _overlayOpacity;
    }
    [self update];
}

- (void)setOverzoomEnabled:(BOOL)overzoomEnabled
{
    _overzoomEnabled = overzoomEnabled;
    if(self.tileOverlay) {
        self.tileOverlay.overzoomEnabled = _overzoomEnabled;
    }
    [self update];
}

- (void)setOverzoomThreshold:(NSInteger)overzoomThreshold
{
    _overzoomThreshold = overzoomThreshold;
    if(self.tileOverlay) {
        self.tileOverlay.overzoomThreshold = overzoomThreshold;
    }
    [self update];
}

- (void) createTileOverlayAndRendererIfPossible
{
    if (!_pathTemplateSet || !_tileSizeSet) return;
    self.tileOverlay = [[AIRMapLocalTileOverlay alloc] initWithURLTemplate:self.pathTemplate];
    self.tileOverlay.canReplaceMapContent = self.shouldReplaceMapContent;
    self.tileOverlay.tileSize = CGSizeMake(_tileSize, _tileSize);

    if (self.flipY) {
        self.tileOverlay.geometryFlipped = self.flipY;
    }
    if (self.overzoomEnabled) {
        self.tileOverlay.overzoomEnabled = self.overzoomEnabled;
    }
    if (self.overzoomThreshold) {
        self.tileOverlay.overzoomThreshold = self.overzoomThreshold;
    }

    self.renderer = [[MKTileOverlayRenderer alloc] initWithTileOverlay:self.tileOverlay];
    self.renderer.alpha = self.overlayOpacity;
}

- (void) update
{
    if (!_renderer) return;

    if (_map == nil) return;
    [_map removeOverlay:self];
    [_map addOverlay:self level:MKOverlayLevelAboveLabels];
}

#pragma mark MKOverlay implementation

- (CLLocationCoordinate2D) coordinate
{
    return self.tileOverlay.coordinate;
}

- (MKMapRect) boundingMapRect
{
    return self.tileOverlay.boundingMapRect;
}

- (BOOL)canReplaceMapContent
{
    return self.tileOverlay.canReplaceMapContent;
}

@end
