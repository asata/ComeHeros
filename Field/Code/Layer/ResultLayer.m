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
- (void) setVictory:(BOOL)flag {
    victory = flag;
}

- (void) onEnterTransitionDidFinish {
    background = [CCSprite spriteWithFile:FILE_RESULT_BACKGROUND];
    [background setPosition:ccp([[commonValue sharedSingleton] getDeviceSize].width / 2,
                                [[commonValue sharedSingleton] getDeviceSize].height / 2)];
    [self addChild:background z:rBackgroundLayer];
    
    CCSprite *titleground = [CCSprite spriteWithFile:FILE_RESULT_TITLE_BACKGROUND];
    [titleground setPosition:ccp([[commonValue sharedSingleton] getDeviceSize].width / 2,
                                [[commonValue sharedSingleton] getDeviceSize].height / 2)];
    [self addChild:titleground z:rBackgroundLayer];
    
    NSString *stageNum = [NSString stringWithFormat:@"%d", [[commonValue sharedSingleton] getStageLevel]];
    NSMutableDictionary *metadata = [[[commonValue sharedSingleton] getGameData] objectForKey:@"metadata"];
    NSMutableDictionary *stageData = [metadata objectForKey:stageNum];
    NSInteger   clearPoint  = [[stageData objectForKey:@"Point"] intValue];
    BOOL        isClear     = [[stageData objectForKey:@"isCleared"] boolValue];
    
    NSString *victoryTitle = @"WIN";
    if(!victory) victoryTitle = @"LOSE";
    
    NSString *resultTitle = [NSString stringWithFormat:@"%d", [[commonValue sharedSingleton] getStageLevel]];
    labelTitle = [CCLabelAtlas labelWithString:resultTitle
                                   charMapFile:FILE_NUMBER_IMG 
                                     itemWidth:32
                                    itemHeight:32
                                  startCharMap:'.'];
    labelTitle.position = ccp(225, 275);
    labelTitle.anchorPoint = ccp(0.5, 0.5);
    labelTitle.scale = 0.65;
    [self addChild:labelTitle z:rMainLabelLayer];
    
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
    labelTotal = [CCLabelAtlas labelWithString:@"TOTAL"
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
    
    CCLabelAtlas *label_menu = [CCLabelAtlas labelWithString:@"MENU"
                                                 charMapFile:FILE_NUMBER_IMG 
                                                   itemWidth:32 
                                                  itemHeight:32 
                                                startCharMap:'.'];
    CCLabelAtlas *label_retry = [CCLabelAtlas labelWithString:@"RETRY"
                                                  charMapFile:FILE_NUMBER_IMG 
                                                    itemWidth:32 
                                                   itemHeight:32 
                                                 startCharMap:'.'];
    NSString *victoryString = @"";
    if(victory) {
        // 다음 스테이지가 있는지 검사
        NSDictionary *frames = [[[commonValue sharedSingleton] getGameData] objectForKey:@"frames"];
        NSDictionary *info = [frames objectForKey:@"Info"];
        NSInteger totalStageNum = [[info objectForKey:@"StageNum"] intValue];
        
        if ([[commonValue sharedSingleton] getStageLevel] + 1 <= totalStageNum) victoryString = @"NEXT";
        
        NSLog(@"111 %@ %d %d", victoryString, [[commonValue sharedSingleton] getStageLevel], totalStageNum);
    }
    CCLabelAtlas *label_next = [CCLabelAtlas labelWithString:victoryString
                                                 charMapFile:FILE_NUMBER_IMG 
                                                   itemWidth:32 
                                                  itemHeight:32 
                                                startCharMap:'.'];
    [label_menu setScale:0.7];
    [label_retry setScale:0.7];
    [label_next setScale:0.7];
    
    CCMenuItem *menu_menu = [CCMenuItemLabel itemWithLabel:label_menu 
                                                    target:self 
                                                  selector:@selector(onQuit:)]; 
    CCMenuItem *menu_retry = [CCMenuItemLabel itemWithLabel:label_retry 
                                                     target:self 
                                                   selector:@selector(onRetry:)]; 
    CCMenuItem *menu_next = [CCMenuItemLabel itemWithLabel:label_next 
                                                    target:self 
                                                  selector:@selector(onNext:)]; 
    
    menu = [CCMenu menuWithItems: menu_menu, menu_retry, menu_next, nil];
    menu.position = ccp(240, 40);
    menu.anchorPoint = ccp(0.5, 0.5);
    [menu alignItemsHorizontallyWithPadding:5.0f];
    [self addChild:menu z:rMainMenuLayer];
    
    // 승리시 게임 결과를 기록
    if (victory) {
        clearPoint = scoreTotal;
        isClear = YES;
        
        [stageData setObject:[NSNumber numberWithInt:clearPoint] forKey:@"Point"];
        [stageData setObject:[NSNumber numberWithBool:isClear] forKey:@"isCleared"];
        
        // 변경 사항을 저장
        File *file = [[File alloc] init];
        NSString *path = [file loadFilePath:FILE_STAGE_PLIST];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [data setObject:metadata forKey:@"metadata"];
        [data writeToFile:path atomically:YES];
        [data release];
        
        NSLog(@"Stage Result Save");
        NSLog(@" - Point : %d", clearPoint);
        NSLog(@" - Clear : %@", (isClear ? @"YES" : @"NO"));
    }
}
- (void) onRetry:(id)sender {
    [self clearDisplay];
    
    [GameLayer_ID endRestart];
}
- (void) onNext:(id)sender {
    [self clearDisplay];
    
    [GameLayer_ID NextStage];
}

- (void) onQuit:(id)sender {
    [self clearDisplay];
    
    [GameLayer_ID endQuit];
}

- (void) clearDisplay {
    [self removeChild:background cleanup:YES];
    
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
    
    [self removeChild:labelTotal cleanup:YES];
    [self removeChild:labelScoreTotal cleanup:YES];
    
    [self removeChild:menu cleanup:YES];
}

@end
