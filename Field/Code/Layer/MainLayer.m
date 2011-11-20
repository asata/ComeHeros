#import "MainLayer.h"
#import "GameLayer.h"
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// 메인 화면
@implementation MainLayer

- (id)init {
    CGSize deviceSize = [[CCDirector sharedDirector] winSize];
    [[commonValue sharedSingleton] setDeviceSize:deviceSize];
    
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    
    File *file = [[File alloc] init];
    NSString *path = [file loadFilePath:FILE_STAGE_PLIST];
    [file loadGameData:path];
    /*
    if ((self = [super init])) {
        CCMenuItemToggle *techniqueItem1 = [CCMenuItemToggle 
                                            itemWithTarget:self
                                            selector:@selector(menuCallBack:)
                                            items:[CCMenuItemFont itemFromString:@"잉여잉여"], nil];
        CCMenuItemToggle *techniqueItem2 = [CCMenuItemToggle 
                                            itemWithTarget:self
                                            selector:@selector(stageSelectCallBack:)
                                            items:[CCMenuItemFont itemFromString:@"StageSelect"], nil];
        CCMenu *techniqueTrainingMenu = [CCMenu menuWithItems:techniqueItem1, techniqueItem2, nil];
        techniqueTrainingMenu.position = ccp(deviceSize.width / 2, deviceSize.height / 2);
        [techniqueTrainingMenu alignItemsVerticallyWithPadding:15];
        [self addChild:techniqueTrainingMenu];
    }*/
    
    return self;
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [(CCLayerMultiplex*)parent_ switchTo:STAGE_LAYER];
}

- (void) onEnterTransitionDidFinish {
    titleBackground = [CCSprite spriteWithFile:FILE_INTRO_IMG];
    [titleBackground setPosition:ccp([[commonValue sharedSingleton] getDeviceSize].width / 2,
                                     [[commonValue sharedSingleton] getDeviceSize].height / 2)];
    [self addChild:titleBackground];
}

/*- (void) menuCallBack:(id) sender {
    [[commonValue sharedSingleton] setStageLevel:1];
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}

- (void) stageSelectCallBack:(id)sender {
    [(CCLayerMultiplex*)parent_ switchTo:STAGE_LAYER];
}*/

@end
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
