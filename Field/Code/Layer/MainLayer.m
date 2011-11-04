#import "MainLayer.h"
#import "GameLayer.h"
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// 메인 화면
@implementation MainLayer

- (id)init {
    if ((self = [super init])) {
        CGSize deviceSize = [[CCDirector sharedDirector] winSize];
        [[commonValue sharedSingleton]setDeviceSize:deviceSize];
        
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
    }
    
    return self;
}

- (void) menuCallBack:(id) sender {
    [[commonValue sharedSingleton] setStageLevel:1];
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}

- (void) stageSelectCallBack:(id)sender {
    [(CCLayerMultiplex*)parent_ switchTo:STAGE_LAYER];
}

@end
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
