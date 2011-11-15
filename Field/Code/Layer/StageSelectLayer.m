#import "StageSelectLayer.h"

@implementation StageSelectLayer

- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) onEnterTransitionDidFinish {
    CCSprite *background = [CCSprite spriteWithFile:FILE_STAGE_IMG];
    [self addChild:background];
    
    pZoom = [PinchZoomLayer initPinchZoom:background];
    [pZoom scaleToInit:1];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event allTouches] count] == 1) [pZoom ccTouchesMoved:touches withEvent:event];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    //NSLog(@"%f %f", location.x, location.y);
}

- (void) stageStart:(id)sender {
    [[commonValue sharedSingleton] setStageLevel:[sender tag]];
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}
@end
