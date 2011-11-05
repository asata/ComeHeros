// 게임 결과를 표시할 레이어
#import "ResultLayer.h"

@implementation ResultLayer

- (id)init {
    NSLog(@"init Result");
    if (self = [super init]) {
        self.isTouchEnabled = YES;
    }
    
    
    return self;
}

// 결과화면 준비
- (void) createResult:(id)pLayer {
    if(GameLayer_ID == nil) GameLayer_ID = pLayer;
}

- (void) onEnterTransitionDidFinish {
    CCSprite *background = [CCSprite spriteWithFile:FILE_RESULT_BACKGROUND];
    [background setPosition:ccp([[commonValue sharedSingleton] getDeviceSize].width / 2,
                                [[commonValue sharedSingleton] getDeviceSize].height / 2)];
    [self addChild:background z:rBackgroundLayer];
    
    
    NSString *resultTitle = [NSString stringWithFormat:@"STAGE%d RESULT", [[commonValue sharedSingleton] getStageLevel]];
    labelTitle = [CCLabelAtlas labelWithString:resultTitle
                                                 charMapFile:FILE_NUMBER_IMG 
                                                   itemWidth:32
                                                  itemHeight:32
                                                startCharMap:'.'];
    labelResult = [CCLabelAtlas labelWithString:@"RESULT"
                                                  charMapFile:FILE_NUMBER_IMG 
                                                    itemWidth:32
                                                   itemHeight:32
                                                 startCharMap:'.'];
    labelScore = [CCLabelAtlas labelWithString:@"SCORE"
                                                 charMapFile:FILE_NUMBER_IMG 
                                                   itemWidth:32
                                                  itemHeight:32
                                                startCharMap:'.'];
    labelTitle.position = ccp(65, 270);
    labelResult.position = ccp(200, 220);
    labelScore.position = ccp(330, 220);
    labelResult.scale = 0.5;
    labelScore.scale = 0.5;
    labelTitle.scale = 0.8;
    [self addChild:labelTitle z:rMainLabelLayer];
    [self addChild:labelResult z:rMainLabelLayer];
    [self addChild:labelScore z:rMainLabelLayer];
    
    
    labelTrap = [CCLabelAtlas labelWithString:@"TRAP"
                                                charMapFile:FILE_NUMBER_IMG 
                                                  itemWidth:32
                                                 itemHeight:32
                                               startCharMap:'.'];
    labelMonster = [CCLabelAtlas labelWithString:@"MONSTER"
                                                   charMapFile:FILE_NUMBER_IMG 
                                                     itemWidth:32
                                                    itemHeight:32
                                                  startCharMap:'.'];
    labelHero = [CCLabelAtlas labelWithString:@"HERO"
                                                charMapFile:FILE_NUMBER_IMG 
                                                  itemWidth:32
                                                 itemHeight:32
                                               startCharMap:'.'];
    labelTime = [CCLabelAtlas labelWithString:@"TIME"
                                                charMapFile:FILE_NUMBER_IMG 
                                                  itemWidth:32
                                                 itemHeight:32
                                               startCharMap:'.'];
    labelTrap.position = ccp(60, 190);
    labelMonster.position = ccp(60, 160);
    labelHero.position = ccp(60, 130);
    labelTime.position = ccp(60, 100);
    labelTrap.scale = 0.5;
    labelMonster.scale = 0.5;
    labelHero.scale = 0.5;
    labelTime.scale = 0.5;
    [self addChild:labelTrap z:rMainLabelLayer];
    [self addChild:labelMonster z:rMainLabelLayer];
    [self addChild:labelHero z:rMainLabelLayer];
    [self addChild:labelTime z:rMainLabelLayer];
    
    
    
    NSInteger pointTrap = [[commonValue sharedSingleton] getUseObstacleNum];
    NSInteger totalTrap = [[commonValue sharedSingleton] getObstacleNum];
    NSInteger pointMonster = [[commonValue sharedSingleton] getDieMonsterNum];
    NSInteger totalMonster = [[commonValue sharedSingleton] getMonsterNum];
    NSInteger pointHero = [[commonValue sharedSingleton] getKillWarriorNum];
    NSInteger totalHero = [[commonValue sharedSingleton] getStageWarriorCount];
    NSInteger pointTime = [[commonValue sharedSingleton] getStageTime];
    labelPointTrap = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/%d", pointTrap, totalTrap]
                                                     charMapFile:FILE_NUMBER_IMG 
                                                       itemWidth:32
                                                      itemHeight:32
                                                    startCharMap:'.'];
    labelPointMonster = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/%d", pointMonster, totalMonster]
                                                        charMapFile:FILE_NUMBER_IMG 
                                                          itemWidth:32
                                                         itemHeight:32
                                                       startCharMap:'.'];
    labelPointHero = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/%d", pointHero, totalHero]
                                                     charMapFile:FILE_NUMBER_IMG 
                                                       itemWidth:32
                                                      itemHeight:32
                                                    startCharMap:'.'];
    labelPointTime = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d:%d", pointTime / 60, pointTime % 60]
                                                     charMapFile:FILE_NUMBER_IMG 
                                                       itemWidth:32
                                                      itemHeight:32
                                                    startCharMap:'.'];  
    labelPointTrap.position = ccp(250, 190);
    labelPointMonster.position = ccp(250, 160);
    labelPointHero.position = ccp(250, 130);
    labelPointTime.position = ccp(250, 100);
    labelPointTrap.anchorPoint = ccp(0.5, 0);
    labelPointMonster.anchorPoint = ccp(0.5, 0);
    labelPointHero.anchorPoint = ccp(0.5, 0);
    labelPointTime.anchorPoint = ccp(0.5, 0);
    labelPointTrap.scale = 0.5;
    labelPointMonster.scale = 0.5;
    labelPointHero.scale = 0.5;
    labelPointTime.scale = 0.5;
    [self addChild:labelPointTrap z:rMainLabelLayer];
    [self addChild:labelPointMonster z:rMainLabelLayer];
    [self addChild:labelPointHero z:rMainLabelLayer];
    [self addChild:labelPointTime z:rMainLabelLayer];

    
    NSInteger scoreTrap = 10;
    NSInteger scoreMonster = 160;
    NSInteger scoreHero = 1780;
    NSInteger scoreTime = 1340;
    labelScoreTrap = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", scoreTrap]
                                                     charMapFile:FILE_NUMBER_IMG 
                                                       itemWidth:32
                                                      itemHeight:32
                                                    startCharMap:'.'];
    labelScoreMonster = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", scoreMonster]
                                                        charMapFile:FILE_NUMBER_IMG 
                                                          itemWidth:32
                                                         itemHeight:32
                                                       startCharMap:'.'];
    labelScoreHero = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", scoreHero]
                                                     charMapFile:FILE_NUMBER_IMG 
                                                       itemWidth:32
                                                      itemHeight:32
                                                    startCharMap:'.'];
    labelScoreTime = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", scoreTime]
                                                     charMapFile:FILE_NUMBER_IMG 
                                                       itemWidth:32
                                                      itemHeight:32
                                                    startCharMap:'.'];  
    labelScoreTrap.position = ccp(410, 190);
    labelScoreMonster.position = ccp(410, 160);
    labelScoreHero.position = ccp(410, 130);
    labelScoreTime.position = ccp(410, 100);
    labelScoreTrap.anchorPoint = ccp(1, 0);
    labelScoreMonster.anchorPoint = ccp(1, 0);
    labelScoreHero.anchorPoint = ccp(1, 0);
    labelScoreTime.anchorPoint = ccp(1, 0);
    labelScoreTrap.scale = 0.5;
    labelScoreMonster.scale = 0.5;
    labelScoreHero.scale = 0.5;
    labelScoreTime.scale = 0.5;
    [self addChild:labelScoreTrap z:rMainLabelLayer];
    [self addChild:labelScoreMonster z:rMainLabelLayer];
    [self addChild:labelScoreHero z:rMainLabelLayer];
    [self addChild:labelScoreTime z:rMainLabelLayer]; 
    
    NSInteger scoreTotal = scoreTrap + scoreMonster + scoreHero + scoreTime;
    CCLabelAtlas *labelTotal = [CCLabelAtlas labelWithString:@"TOTAL"
                                                 charMapFile:FILE_NUMBER_IMG 
                                                   itemWidth:32
                                                  itemHeight:32
                                                startCharMap:'.']; 
    labelScoreTotal = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d", scoreTotal]
                                                 charMapFile:FILE_NUMBER_IMG 
                                                   itemWidth:32
                                                  itemHeight:32
                                                     startCharMap:'.']; 
    labelTotal.position = ccp(200, 70);
    labelScoreTotal.position = ccp(410, 70);
    labelScoreTotal.anchorPoint = ccp(1, 0);
    labelTotal.scale = 0.6;
    labelScoreTotal.scale = 0.6;
    [self addChild:labelTotal z:rMainLabelLayer];
    [self addChild:labelScoreTotal z:rMainLabelLayer];
    
    CCMenuItemImage *quit = [CCMenuItemImage itemFromNormalImage:FILE_RESUME1_IMG
                                                   selectedImage:FILE_RESUME1_IMG 
                                                          target:self 
                                                        selector:@selector(onQuit:)];
    CCMenu *menu = [CCMenu menuWithItems: quit, nil];
    menu.position = ccp(20, 20);
    [menu alignItemsVerticallyWithPadding:5.0f];
    [self addChild:menu z:rMainMenuLayer];
}

- (void) onQuit:(id)sender {
    [self removeChild:labelTitle cleanup:YES];
    [self removeChild:labelResult cleanup:YES];
    [self removeChild:labelScore cleanup:YES];
    
    [self removeChild:labelTrap cleanup:YES];
    [self removeChild:labelMonster cleanup:YES];
    [self removeChild:labelHero cleanup:YES];
    [self removeChild:labelTime cleanup:YES];
    
    [self removeChild:labelPointTrap cleanup:YES];
    [self removeChild:labelPointMonster cleanup:YES];
    [self removeChild:labelPointHero cleanup:YES];
    [self removeChild:labelPointTime cleanup:YES];
    
    [self removeChild:labelScoreTrap cleanup:YES];
    [self removeChild:labelScoreMonster cleanup:YES];
    [self removeChild:labelScoreHero cleanup:YES];
    [self removeChild:labelScoreTime cleanup:YES];
    
    [self removeChild:labelScoreTotal cleanup:YES];
    
    [GameLayer_ID endQuit];
}

@end
