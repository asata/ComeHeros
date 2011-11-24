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
    File *file = [[File alloc] init];
    NSString *path = [file loadFilePath:FILE_STAGE_PLIST];
    [file loadGameData:path];
    
    NSMutableDictionary *stageData  = [[[commonValue sharedSingleton] getGameData] objectForKey:@"Info"];
    NSInteger           stageNumber = [[stageData objectForKey:@"StageNum"] intValue];
    
    CCSprite *background = [CCSprite spriteWithFile:FILE_STAGE_IMG];
    [self addChild:background z:-1];
    
    pZoom = [PinchZoomLayer initPinchZoom:background];
    [pZoom scaleToInit:1];
    
    ccColor4B myColor = ccc4(76, 123, 23, 150);
    CCRibbon *ribbon = [CCRibbon ribbonWithWidth:10 image:@"green.png" length:10.0 color:myColor fade:1.0f];
    [pZoom addChild:ribbon z:8];
    
    for (NSInteger i = 1; i <= stageNumber; i++) {
        NSString *stageNum = [NSString stringWithFormat:@"%d", i];
        NSMutableDictionary *stageData = [[[commonValue sharedSingleton] getGameData] objectForKey:stageNum];
        BOOL isClear = [[stageData objectForKey:@"isCleared"] boolValue];
        NSInteger positionX = [[stageData objectForKey:@"PositionX"] intValue];
        NSInteger positionY = [[stageData objectForKey:@"PositionY"] intValue];
        
        CCSprite *stage;
        
        if (isClear) {
            stage = [CCSprite spriteWithFile:@"btn_stage_select_1.png"];
        } else {
            stage = [CCSprite spriteWithFile:@"btn_stage_select_2.png"];
        }
        
        [ribbon addPointAt:ccp(positionX, positionY - 20) width:3];
        
        [stage setPosition:ccp(positionX, positionY)];
        [stage setTag:i];
        [menuList addObject:stage];
        [pZoom addChild:stage z:10];
        [stage release];
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event allTouches] count] == 1) [pZoom ccTouchesMoved:touches withEvent:event];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [pZoom convertTouchToNodeSpace:touch];
    
    for (CCSprite *tSprite in menuList) {
        if (tSprite.position.x - 36 <= location.x && tSprite.position.x + 36 >= location.x &&
            tSprite.position.y - 36 <= location.y && tSprite.position.y + 36 >= location.y) {
            [[commonValue sharedSingleton] setStageLevel:[tSprite tag]];
            [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
        }
    }
    
    NSLog(@"%f %f", location.x, location.y);
}

- (void) stageStart:(id)sender {
}
@end
