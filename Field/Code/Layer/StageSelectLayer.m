#import "StageSelectLayer.h"

@implementation StageSelectLayer

- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        menuList = [[NSMutableArray alloc] init];
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
    
    CCSprite *stage1 = [CCSprite spriteWithFile:@"fire.png"];
    [stage1 setPosition:ccp(200, 200)];
    [stage1 setTag:1];
    [menuList addObject:stage1];
    [pZoom addChild:stage1];
    
    CCSprite *stage2 = [CCSprite spriteWithFile:@"fire.png"];
    [stage2 setPosition:ccp(400, 200)];
    [stage2 setTag:2];
    [menuList addObject:stage2];
    [pZoom addChild:stage2];
    
    CCSprite *stage3 = [CCSprite spriteWithFile:@"fire.png"];
    [stage3 setPosition:ccp(600, 200)];
    [stage3 setTag:3];
    [menuList addObject:stage3];
    [pZoom addChild:stage3];
    
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event allTouches] count] == 1) [pZoom ccTouchesMoved:touches withEvent:event];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [pZoom convertTouchToNodeSpace:touch];
    
    for (CCSprite *tSprite in menuList) {
        if (tSprite.position.x - 16 <= location.x && tSprite.position.x + 16 >= location.x &&
            tSprite.position.y - 16 <= location.y && tSprite.position.y + 16 >= location.y) {
            [[commonValue sharedSingleton] setStageLevel:[tSprite tag]];
            [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
        }
    }
}

- (void) stageStart:(id)sender {
}
@end
