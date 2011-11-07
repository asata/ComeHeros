//
//  PinchZoomLayer.m
//  pinchzoom
//
//  Created by Casey Broich on 5/17/10.
//  Copyright 2010 Pagex. All rights reserved.
//


// TO DO... maybe a subtle tween effect that 
// slowly comes to a stop when I flick the screen


static const float MIN_SCALE = 0.666667;
static const float MAX_SCALE = 5.0;
static const unsigned int WINDOW_HEIGHT = 320;
static const unsigned int WINDOW_WIDTH = 480;

#import "ScaleRestricted.h"
#import "PinchZoomLayer.h"


@implementation PinchZoomLayer

@synthesize size, contentNode, scalable, allowTapzoom;



- (id) init {
	self = [super init];
	if (self != nil) {
		[self zoomToCenterFit];
		
	}
	return self;
}


+(id) initPinchZoom:(CCNode*)node{
	return [[self alloc] initWithNode:node];
}

-(id) initWithNode:(CCNode*)node {
	if ((self = [super init])){
		
		self.isTouchEnabled = YES;
		contentNode = node;
		size = CGSizeMake(WINDOW_WIDTH,WINDOW_HEIGHT);
		[contentNode addChild:self z:9999];
		// [self loadLabel];
		[self zoomToCenterFit];
		
	}
	return self;
}

- (void)onEnter {
	
	[super onEnter];
	allowTapzoom = YES;
	scalable = YES;
}
- (void)onExit {
	[super onExit];
}


- (void) dealloc {
	[contentNode release];
	[super dealloc];
}

- (CGPoint)convertPoint:(CGPoint)point fromNode:(CCNode *)node {
    return [self convertToNodeSpace:[node convertToWorldSpace:point]];
};


- (float) getScaleToFit {
	CGSize screenSize = [self contentSize];
    	
	// scale to fit screen 
	
	float scaleWidth1 =  (float)(screenSize.width / size.width) * 1.0;
	float scaleHeight1 =  (float)(screenSize.height / size.height) * 1.0;
	float scale1 = MIN(scaleWidth1, scaleHeight1);
	
    return scale1;
};

- (void)animatedZoomTo:(float)newScale stillPoint:(CGPoint)stillPoint {
	
    CGPoint stillPointInParentNodeSpace = [self convertPoint:stillPoint fromNode:contentNode];
    
    // temporary set scale to calculate delta
    float currentScale = contentNode.scale;
    contentNode.scale = newScale;
    
    CGPoint newStillPointInParentNodeSpace = [self convertPoint:stillPoint fromNode:contentNode];
    CGPoint delta = ccpSub(newStillPointInParentNodeSpace, stillPointInParentNodeSpace);    
    CGPoint newPosition = ccpSub(contentNode.position, delta);
    
    // restore scale
    contentNode.scale = currentScale;
    
    [contentNode runAction: [ScaleRestricted actionWithDuration:0.2 
                                                          scale:newScale 
                                                       position:newPosition 
                                                         target:self
                                                       selector:@selector(applyFrameLimits)]];
}

- (void) scaleToFit {
	CGFloat minScale = [self getMinScale];
	contentNode.scale = minScale;
    //contentNode.anchorPoint = ccp(0, 0.867f);
}

- (float)percent:(float)a of:(float)b {
	float c = a / b;
	float d = c * 1.0;
	return (float)d;
}

- (CGFloat)getMidScale {
	// between min and max
	float maxScale = [self getMaxScale];
	float midScale = (maxScale / 3) * 2;
	return midScale;
}

- (CGFloat)getMaxScale {
	float minScale = [self getMinScale];
	float maxScale = minScale * 2;
	return maxScale;
}

- (CGFloat)getMinScale {
	CGSize sz = [contentNode contentSize];
	
	float percentW = [self percent:WINDOW_WIDTH of:sz.width];
	float percentH = [self percent:WINDOW_HEIGHT of:sz.height];
	
	// This probably should be MIN
	// but I changed it to MAX due fix a 
	// quick bug on startup when calling the scaleToFit method
	float scale1 = MAX(percentW, percentH);
	
	return scale1;
}

- (void)handleZoomOnDoubleTap:(UITouch *)touch {
    
	if (!scalable) { return; }
	CGFloat minScale = [self getMinScale];
	CGFloat maxScale = [self getMaxScale];
	// float minScale = maxScale/2;
	
    float newScale = contentNode.scale < maxScale ? maxScale : [self getScaleToFit];
    
    CGPoint stillPoint = [contentNode convertTouchToNodeSpace:touch];
	

    if (newScale < minScale) {
		// calculate center point between two touches
		// CGPoint centerPoint = ccpMidpoint(touch1Location, touch2Location);
		newScale = minScale;
	}	
	// NSLog(@"handleZoomOnDoubleTap newScale %f", newScale);

    [self animatedZoomTo:newScale stillPoint:stillPoint];
};

- (void)handlePitchZoom:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!scalable) { return; }
    
	//NSSet *allTouches = [event allTouches];

	
    UITouch* touch1 = [[[event allTouches] allObjects] objectAtIndex:0];
    UITouch* touch2 = [[[event allTouches] allObjects] objectAtIndex:1];
    
    // calculate scale value
    double prevDistance = ccpDistance([touch1 previousLocationInView:[touch1 view]], [touch2 previousLocationInView:[touch2 view]]); 
    double newDistance  = ccpDistance([touch1 locationInView:[touch1 view]], [touch2 locationInView:[touch2 view]]); 
    
    CGFloat relation = newDistance / prevDistance;
    CGFloat newScale = contentNode.scale * relation;
	
	
	CGFloat minScale = [self getMinScale]; // MIN_SCALE
	CGFloat maxScale = [self getMaxScale]; // MAX_SCALE
	
	
    if ((newScale >= minScale) && (newScale <= maxScale)) {
		
        CGPoint touch1Location = [contentNode convertTouchToNodeSpace:touch1];
        CGPoint touch2Location = [contentNode convertTouchToNodeSpace:touch2];
		
        // calculate center point between two touches
        CGPoint centerPoint = ccpMidpoint(touch1Location, touch2Location);
        
		// store center point location (ScrollableView space)
        CGPoint centerPointInParentNodeSpace = [self convertPoint:centerPoint fromNode:contentNode];
		
		CGPoint oldPoint = ccp(centerPointInParentNodeSpace.x * (contentNode.scale), centerPointInParentNodeSpace.y * (contentNode.scale)); 
		
		contentNode.scale = newScale;
		
		CGPoint newPoint = ccp(centerPointInParentNodeSpace.x * (contentNode.scale), centerPointInParentNodeSpace.y * (contentNode.scale)); 
		
		CGPoint diff = ccp(oldPoint.x - newPoint.x , oldPoint.y - newPoint.y);
		
		contentNode.position = ccp(contentNode.position.x + diff.x, contentNode.position.y + diff.y); 
    }
	
	[self zoomToCenterFit];

	// [self updateLabelText];

};



-(void) zoomToCenterFit {
	
	// I'm not sure why I even have this here
	
	// NSLog(@"size %@", NSStringFromCGSize(size));

}


-(void) applyFrameLimits {
	

    if (!scalable) { return; }
	
	
	// simsize
	CGSize contentSize = [contentNode contentSize];		
	CGFloat simWidth = (contentNode.scale)*contentSize.width;
	CGFloat simHeight = (contentNode.scale)*contentSize.height;

	CGRect frameRect = CGRectMake(0, 0, size.width, size.height);
	CGSize contentSizeInSelfSpace = CGSizeMake(simWidth,simHeight);
	CGRect contentRect = CGRectMake(contentNode.position.x, contentNode.position.y, contentSizeInSelfSpace.width, contentSizeInSelfSpace.height);

	[self zoomToCenterFit];
	
	CGFloat posX = contentNode.position.x;
	CGFloat posY = contentNode.position.y;
	
	
    if (CGRectGetMinX(contentRect) > CGRectGetMinX(frameRect)) { // check x
		posX = frameRect.origin.x;
		contentNode.position = ccp(posX, posY);
		
    } else if (CGRectGetMaxX(contentRect) < CGRectGetMaxX(frameRect)){
		posX = CGRectGetMaxX(frameRect) - CGRectGetWidth(contentRect);
		contentNode.position = ccp(posX, posY);
    }
    if (CGRectGetMinY(contentRect) > CGRectGetMinY(frameRect)) { // check y
		posY = frameRect.origin.y;
		contentNode.position = ccp(posX, posY);
		
    } else if (CGRectGetMaxY(contentRect) < CGRectGetMaxY(frameRect)) {
		posY = CGRectGetMaxY(frameRect) - CGRectGetHeight(contentRect);
		contentNode.position = ccp(posX, posY);
    }
	
    if (CGRectGetWidth(contentRect) < CGRectGetWidth(frameRect)) { // check width

		contentNode.scale = CGRectGetWidth(frameRect) / contentSize.width;
        /////// contentNode.scale = CGRectGetWidth(frameRect) / contentSize.width;
		posX = frameRect.origin.x;
		contentNode.position = ccp(posX, posY);
    }
    if (CGRectGetHeight(contentRect) < CGRectGetHeight(frameRect)) { // check height
        contentNode.scale = CGRectGetHeight(frameRect) / contentSize.height;
		posY = frameRect.origin.y;
		contentNode.position = ccp(posX, posY);
    }

}
- (CGPoint)convertPreviousTouchToNodeSpace:(UITouch *)touch {
	 CGPoint point = [touch previousLocationInView: [touch view]];
	 point = [[CCDirector sharedDirector] convertToGL: point];
	 return [self convertToNodeSpace:point];
	
}

- (void) handleScrolling:(NSSet *)touches {
	//CGFloat minScale = [self getMinScale]; 

	//if(contentNode.scale > minScale){
		UITouch *touch = [touches anyObject];
		
		CGPoint touchLocation = [touch locationInView: [touch view]];	
		CGPoint prevLocation = [touch previousLocationInView: [touch view]];
		touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
		prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
		
		// subtract
		CGPoint diff = ccpSub(touchLocation,prevLocation);
		
		// add
		CGPoint newpos = ccpAdd(contentNode.position, diff);
		
		[contentNode setPosition: newpos];
	//}
}
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([[event allTouches] count] == 1 && [[touches anyObject] tapCount] >= 2) {
		if(self.allowTapzoom){
			[self handleZoomOnDoubleTap:[touches anyObject]];
		}
    }
};

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    // TO DO: get touches for CCNode

    switch ([[event allTouches] count]) {
        case 1:
            // do scroll
            [self handleScrolling:touches];
            break;
        case 2:
            // do zoom
            [self handlePitchZoom:touches withEvent:event];
            break;
    }
    
    [self applyFrameLimits];
    
};

- (CGFloat) getScale {
    return contentNode.scale;
}


@end



