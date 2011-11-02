// 게임 결과를 표시할 레이어
#import "ResultLayer.h"

@implementation ResultLayer

- (id)init {
    if (self = [super init]) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

// 결과화면 준비
- (void) createResult:(id)pLayer {
    if(GameLayer_ID == nil) GameLayer_ID = pLayer;
    
    CCSprite *temp = [CCSprite spriteWithFile:FILE_PAUSE_IMG];
    temp.position = ccp(240, 180);
    temp.scale = 10;
    [self addChild:temp z:pBackgroundLayer];
    
    /*CCMenuItemImage *resume = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
                                                     selectedImage:FILE_RESUME_IMG 
                                                            target:self 
                                                          selector:@selector(onResume:)];
    CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
                                                      selectedImage:FILE_RESUME_IMG 
                                                             target:self 
                                                           selector:@selector(onRestart:)];
    */CCMenuItemImage *quit = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
                                                   selectedImage:FILE_RESUME_IMG 
                                                          target:self 
                                                        selector:@selector(onQuit:)];
    CCMenu *menu = [CCMenu menuWithItems: quit, nil];
    menu.position = ccp(240, 50);
    [menu alignItemsVerticallyWithPadding:5.0f];
    [self addChild:menu z:pMainMenuLayer];
}
- (void) onQuit:(id)sender {
    [GameLayer_ID Quit];
}

@end
