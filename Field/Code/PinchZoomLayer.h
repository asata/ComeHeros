//
//  PinchZoomLayer.h
//  pinchzoom
//
//  Created by Casey Broich on 5/17/10.
//  Copyright 2010 Pagex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PinchZoomLayer : CCLayer 
{	
	CGSize size;
    CCNode *contentNode;
    BOOL scalable;
	BOOL allowTapzoom;
	CCScaleTo *scaleAction;
}
@property(assign) CGSize size;
@property(assign) BOOL scalable;
@property(assign) BOOL allowTapzoom;
@property(readonly) CCNode *contentNode;

- (id) initWithNode:(CCNode*)node;
+ (id) initPinchZoom:(CCNode*)node;
- (CGFloat) getMidScale;
- (CGFloat) getMaxScale;
- (CGFloat) getMinScale;
- (void) zoomToCenterFit;
- (void) handleScrolling:(NSSet *)touches;
- (void) handlePitchZoom:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) handleZoomOnDoubleTap:(UITouch *)touch;
- (void) animatedZoomTo:(float)scale stillPoint:(CGPoint)stillPoint;
- (void) applyFrameLimits;
- (void) scaleToFit;
- (void) scaleToInit:(CGFloat)scale;

- (CGFloat) getScale;

@end

