// 게임 설명을 표시할 레이어
// 게임 시작 이전에 표시
// 구성시 skip을 할 수 있는 버튼을 두고, 터치시 다음 설명으로 넘어감
// 다 표시하면 다시 게임으로 돌아감
#import "TutorialLayer.h"

@implementation TutorialLayer

- (id)init {
    if (self = [super init]) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

// 결과화면 준비
- (void) createTutorial:(id)pLayer {
    if(GameLayer_ID == nil) GameLayer_ID = pLayer;
    
    /*CCSprite *temp = [CCSprite spriteWithFile:FILE_PAUSE_IMG];
    temp.position = ccp(240, 180);
    temp.scale = 10;
    [self addChild:temp z:pBackgroundLayer];
    
    *//*CCMenuItemImage *resume = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
     selectedImage:FILE_RESUME_IMG 
     target:self 
     selector:@selector(onResume:)];
     CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
     selectedImage:FILE_RESUME_IMG 
     target:self 
     selector:@selector(onRestart:)];
     CCMenuItemImage *quit = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
     selectedImage:FILE_RESUME_IMG 
     target:self 
     selector:@selector(onQuit:)];
     CCMenu *menu = [CCMenu menuWithItems:resume, restart, quit, nil];
     menu.position = ccp(240, 50);
     [menu alignItemsVerticallyWithPadding:5.0f];
     [self addChild:menu z:pMainMenuLayer];*/
}



@end
