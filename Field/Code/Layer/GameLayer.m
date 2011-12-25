//
//  GameLayer.m
//  Field
//
//  Created by 강 정훈 on 11. 11. 4..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

@class Warrior;
@implementation GameLayer

//////////////////////////////////////////////////////////////////////////
// 게임 초기화 Start                                                      //
//////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        pauseLayer = [[PauseLayer alloc] init];
        resultLayer = [[ResultLayer alloc] init];
        
        [pauseLayer createPause:self];
        [resultLayer createResult:self];
        [tutorialLayer createTutorial:self];
    }
    
    return self;
}

- (void) onEnterTransitionDidFinish {    
    // 필요한 항목 초기화
    [self initGame];
    
    // 튜토리얼이 필요한지 검사하여 필요할 경우 호출
    // tutorialLayer = [[TutorialLayer alloc] init];
    // [call TutorialLayer]
    
    // 일정한 간격으로 호출~
    [self schedule:@selector(moveAction:) interval:REFRESH_DISPLAY_TIME];
    [self schedule:@selector(createWarriorAtTime:) interval:CREATE_WARRIOR_TIME];
    [self schedule:@selector(createMonsterAtTime:) interval:CREATE_MONSTER_TIME];
}

- (void) dealloc {
    [self destoryGame];
    
    [file release];
    [function release];
    
    [warriorHandling release];
    [monsterHandling release];
    [trapHandling release];
    [houseHandling release];
    
    [labelTime release];
    [labelMoney release];
    [labelPoint release];
    
    [super dealloc];
}
- (void) initGame {
    self.isTouchEnabled = YES;
    
    chainFlameList = [[NSMutableArray alloc] init];
    file = [[File alloc] init];
    function = [[Function alloc] init];
    trapHandling = [[TrapHandling alloc] init];
    monsterHandling = [[MonsterHandling alloc] init];
    warriorHandling = [[WarriorHandling alloc] init];
    houseHandling  = [[HouseHandling alloc] init];
    trapMenuList = [[NSMutableArray alloc] init];
    
    [[commonValue sharedSingleton] setGamePlaying:YES];
    [[commonValue sharedSingleton] setGamePause:NO];
    [[commonValue sharedSingleton] initCommonValue];
    [[commonValue sharedSingleton] setViewScale:1];
    
    NSString *path = [file loadFilePath:FILE_STAGE_PLIST];
    [file loadStageData:path];
    
    NSLog(@"Stage Info Init");
    NSLog(@" StageLevel : %d", [[commonValue sharedSingleton] getStageLevel]);
    NSLog(@" MapName : %@", [[commonValue sharedSingleton] getMapName]);
    NSLog(@" Life : %d", [[commonValue sharedSingleton] getStageLife]);
    NSLog(@" Money : %d", [[commonValue sharedSingleton] getStageMoney]);
    NSString *stageNum = [NSString stringWithFormat:@"%d", [[commonValue sharedSingleton] getStageLevel]];
    NSMutableDictionary *stageData = [[[commonValue sharedSingleton] getGameData] objectForKey:stageNum];
    NSInteger   clearPoint  = [[stageData objectForKey:@"Point"] intValue];
    BOOL        isClear     = [[stageData objectForKey:@"isCleared"] boolValue];
    NSLog(@" Point : %d", clearPoint);
    NSLog(@" Clear : %@", (isClear ? @"YES" : @"NO"));
    NSLog(@" Money : %d", [[commonValue sharedSingleton] getStageMoney]);
    NSLog(@" Warrior Num : %d", [[commonValue sharedSingleton] getStageWarriorCount]);
    
    [self initMap]; 
    [self initMenu];
    [self initLabel];
    [self initTileSetupMenu];
}
- (void) initLabel {
    labelTime = [CCLabelAtlas labelWithString:[[commonValue sharedSingleton] getStageTimeString]
                                  charMapFile:FILE_NUMBER_IMG 
                                    itemWidth:32
                                   itemHeight:32
                                 startCharMap:'.'];
    labelTime.position = TIME_LABEL_POSITION;
    labelTime.scale = 0.5;
    [self addChild:labelTime z:kMainLabelLayer];
    
    labelMoney= [CCLabelAtlas labelWithString:[[commonValue sharedSingleton] getStageMoneyString]
                                  charMapFile:FILE_NUMBER_IMG 
                                    itemWidth:32
                                   itemHeight:32
                                 startCharMap:'.'];
    labelMoney.position = MONEY_LABEL_POSITION;
    labelMoney.scale = 0.5;
    [self addChild:labelMoney z:kMainLabelLayer];
    
    CCSprite *coinSprite = [CCSprite spriteWithFile:FILE_COIN_IIMG];
    coinSprite.position = COIN_IMG_POSITION;
    coinSprite.scale = 0.5;
    [self addChild:coinSprite z:kMainLabelLayer];
}
- (void) initMenu {
    CCMenuItem *pause = [CCMenuItemImage itemFromNormalImage:FILE_PAUSE_IMG 
                                               selectedImage:FILE_PAUSE_IMG 
                                                      target:self 
                                                    selector:@selector(gamePause:)];
    menuPause = [CCMenu menuWithItems:pause, nil];
    menuPause.position = PAUSE_MENU_POSITION;
    menuPause.visible = YES;
    
    [self addChild:menuPause z:kMainMenuLayer];
}
- (void) destoryGame {
    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        [self removeChild:[tWarrior getSprite] cleanup:YES];
    }
    
    for (Monster *tMonster in [[commonValue sharedSingleton] getMonsterList]) {
        [self removeChild:[tMonster getSprite] cleanup:YES];
    }
    
    for (CCSprite *tSprite in chainFlameList) {
        [tSprite setVisible:NO];
        [self removeChild:tSprite cleanup:YES];
    }
     
    //[[commonValue sharedSingleton] setTileMap:nil];
    [[commonValue sharedSingleton] setGamePause:NO];
    [[commonValue sharedSingleton] setGamePlaying:NO];
    
    [self removeChild:menu1 cleanup:YES];
    [self removeChild:menu2 cleanup:YES];
    [self removeChild:menu3 cleanup:YES];
    [self removeChild:menu4 cleanup:YES];
    [self removeChild:menuPause cleanup:YES];
    
    [self removeChild:labelMoney cleanup:YES];
    [self removeChild:labelTime cleanup:YES];
    [self removeChild:labelPoint cleanup:YES];
    
    [self unscheduleAllSelectors];
}
- (void) updateLabel {
    [labelTime setString:[[commonValue sharedSingleton] getStageTimeString]];
    [labelMoney setString:[[commonValue sharedSingleton] getStageMoneyString]];
    //[labelPoint setString:[[commonValue sharedSingleton] getStagePointString]];
}
- (void) gamePause:(id)sender {
    // 게임 일시 정지
    menuPause.visible = NO;
    [self onPause];   
}
- (void) onPause {
    self.isTouchEnabled = NO;
    
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_SOUND];
    
    [[commonValue sharedSingleton] setGamePause:YES];
    [[CCDirector sharedDirector] pause];
    [self addChild:pauseLayer z:kPauseLayer];
    
    // 버튼 비활성화
}
- (void) resume {
    [[commonValue sharedSingleton] setGamePause:NO];
    [self removeChild:pauseLayer cleanup:YES];
    self.isTouchEnabled = YES;
    
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_SOUND];
    
    // 버튼 활성화
    menuPause.visible = YES;
    
    [[CCDirector sharedDirector] resume];
}
- (void) Restart {
    [self destoryGame];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_SOUND];
    
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}
- (void) endRestart {
    [self destoryGame];
    [self removeChild:resultLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}
- (void) NextStage {
    [self destoryGame];
    [self removeChild:resultLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_SOUND];
    
    // 다음 스테이지가 있는지 검사
    NSDictionary *frames = [[[commonValue sharedSingleton] getGameData] objectForKey:@"frames"];
    NSDictionary *info = [frames objectForKey:@"Info"];
    NSInteger stageNum = [[info objectForKey:@"StageNum"] intValue];
    NSInteger nextStageNum = [[commonValue sharedSingleton] getStageLevel] + 1;
    
    if (nextStageNum <= stageNum) {
        [[commonValue sharedSingleton] setStageLevel:nextStageNum];
        [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
    }
}
- (void) Quit {
    [self removeChild:pauseLayer cleanup:YES];
    [self destoryGame];
    [[CCDirector sharedDirector] resume];
    
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_SOUND];
    
    //[(CCLayerMultiplex*)parent_ switchTo:MAIN_LAYER];
    [(CCLayerMultiplex*)parent_ switchTo:STAGE_LAYER];
}
- (void) endQuit {
    [self removeChild:resultLayer cleanup:YES];
    [self destoryGame];
    [[CCDirector sharedDirector] resume];
    [self unscheduleAllSelectors];    
    
    //[(CCLayerMultiplex*)parent_ switchTo:MAIN_LAYER];
    [(CCLayerMultiplex*)parent_ switchTo:STAGE_LAYER];
}
//////////////////////////////////////////////////////////////////////////
// 게임 초기화 End                                                        //
//////////////////////////////////////////////////////////////////////////
- (void) gameEnd:(BOOL)victory {
    [self stopAllActions];
    
    if (victory) {
        NSLog(@"Win");
    } else {
        NSLog(@"Lose");
    }
    
    [[commonValue sharedSingleton] setGamePause:YES];
    [[CCDirector sharedDirector] pause];
    self.isTouchEnabled = NO;
    menuPause.visible = NO;
    [resultLayer setVictory:victory];
    [self addChild:resultLayer z:kPauseLayer];
}


//////////////////////////////////////////////////////////////////////////
// 맵 처리 Start                                                         //
//////////////////////////////////////////////////////////////////////////
// 타일맵 등록
- (void) initMap {
    // 타일 맵 등록
    CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:[[commonValue sharedSingleton] getMapName]];
    //map.scale = MAP_SCALE;// * [[commonValue sharedSingleton] getViewScale];
    // 왼쪽 상단에 맵 왼쪽 상단이 위치하도록 설정(하지 않을 경우 왼쪽 하단에 맵 왼쪽 하단이 위치) 
    //map.anchorPoint = ccp(0, 0);
    //map.position = ccp(0, [[commonValue sharedSingleton]getDeviceSize].height - (TILE_NUM * TILE_SIZE));  
    //[map setScale:4.0f];
    [[commonValue sharedSingleton] setTileMap:map];
    mapSize = [map contentSize];
    mapSize = CGSizeMake([map contentSize].width, [map contentSize].height);
    [self addChild:map z:kBackgroundLayer];
    
    pZoom = [PinchZoomLayer initPinchZoom:map];
    [pZoom scaleToFit];
    
    // 타일 맵을 읽어 들임
    [self loadTileMap];
    
    // 이동 경로 탐색
    [warriorHandling createMoveTable];
}

// 타일맵에 있는 타일을 읽어들임
- (void) loadTileMap {
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    CCTMXLayer *layer1 = [map layerNamed:MAP_LAYER1];
    CCTMXLayer *layer2 = [map layerNamed:MAP_LAYER2];
    
    for(int i = 0; i < TILE_NUM; i++) {
        for(int j = 0; j < TILE_NUM; j++) {
            unsigned int tileType = [layer2 tileGIDAt:ccp(i, j)];
            
            // 타일맵에 위치한 타일 타입을 읽어들임
            if(tileType != TILE_NONE) {
                if(tileType == TILE_WALL10 || tileType == TILE_BLANK01) {
                    [[commonValue sharedSingleton] setMapInfo:i y:j tileType:TILE_WALL10];
                    
                    NSInteger r = arc4random() % 4;
                    if (r == 0) [layer2 setTileGID:TILE_WALL10 at:ccp(i, j)];
                    else if (r == 1) [layer2 setTileGID:TILE_WALL11 at:ccp(i, j)];
                    else if (r == 2) [layer2 setTileGID:TILE_WALL12 at:ccp(i, j)];
                    else [layer2 setTileGID:TILE_WALL13 at:ccp(i, j)];
                } else {
                    [[commonValue sharedSingleton] setMapInfo:i y:j tileType:tileType];
                }
            } else {
                tileType = [layer1 tileGIDAt:ccp(i, j)];
                
                [[commonValue sharedSingleton] setMapInfo:i y:j tileType:tileType];
            }
            
            // 타일 타입에 따라 이동이 가능한지 검사
            // 이동 불가일 경우 -1
            if(![trapHandling checkMoveTile:tileType])
                [[commonValue sharedSingleton] setMoveTable:i y:j direction:(-1)];
            else
                [[commonValue sharedSingleton] setMoveTable:i y:j direction:MoveNone];
            
            if([trapHandling checkObstacleTile:tileType]) {
                // 타일에 설치된 트랩이 있는지 확인
                [trapHandling addTrap:ccp(i, j) type:tileType];
            } else if ([trapHandling checkHouseTile:tileType]) {
                // 몬스터 집이 있는 경우
                [self addHouse:ccp(i, j) tType:tileType];
            } else if (tileType == TILE_START) {
                // 시작 지점인 경우
                [[commonValue sharedSingleton] setStartPoint:ccp(i, j)];
            } else if (tileType == TILE_END) {
                // 도착 지점인 경우
                [[commonValue sharedSingleton] setEndPoint:ccp(i, j)];
            }
        }
    }
}
//////////////////////////////////////////////////////////////////////////
// 맵 처리 End                                                           //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 용사 Start                                                            //
//////////////////////////////////////////////////////////////////////////
- (void) createWarriorAtTime:(id) sender {
    for (NSInteger i = [[commonValue sharedSingleton] getWarriorNum]; 
         i < [[commonValue sharedSingleton] getStageWarriorCount]; i++) {
        NSDictionary *wInfo = [file loadWarriorInfo:i];
        
        if([[wInfo objectForKey:@"Time"] intValue] == [[commonValue sharedSingleton] getStageTime]) {
            CCSprite *tSprite = [warriorHandling createWarrior:wInfo];
            [pZoom addChild:tSprite 
                         z:(kWarriorLayer - [[commonValue sharedSingleton] warriorListCount]) 
                       tag:[[commonValue sharedSingleton] getWarriorNum]];
        }
    }
    
    [[commonValue sharedSingleton] plusStageTime];
}
- (void) createWarrior {
    NSDictionary *wInfo = [file loadWarriorInfo:[[commonValue sharedSingleton] getWarriorNum]];
    CCSprite *tSprite = [warriorHandling createWarrior:wInfo];
    [self addChild:tSprite z:(kWarriorLayer - [[commonValue sharedSingleton] warriorListCount])];
}

- (void) moveAction:(id) sender {
    [self updateLabel];

    // 용사가 모두 죽었는지 검사
    if ([[commonValue sharedSingleton] getKillWarriorNum] == [[commonValue sharedSingleton] getStageWarriorCount]) {
        [self gameEnd:GAME_VICTORY];
    } else {
        // 잠시 애니메이션 효과 중단
        //[self pauseSchedulerAndActions];
        
        if (![warriorHandling moveWarrior]) {
            [self gameEnd:GAME_LOSE];
        }
        
        [monsterHandling moveMonster];
        
        // 묘비를 가장 아래로 내림
        for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
            if([tWarrior getDeath] == DEATH && [tWarrior getDeathReOrder]) {
                [pZoom reorderChild:[tWarrior getSprite] z:kTombstoneLayer];
                [tWarrior changeDeathOrder];
            }
        }
        
        // 폭발물 폭발시 불꽃을 삽입
        CCSprite *tFlame = [[commonValue sharedSingleton] popFlame];
        while (tFlame != nil) {
            CCAnimate *flameAnimate = [[CCAnimate alloc] initWithAnimation:[self loadFlameAnimation]
                                                      restoreOriginalFrame:YES];
            
            [tFlame runAction:[CCSequence actions:flameAnimate, nil]];
            [pZoom addChild:tFlame z:kFlameLayer];
            [chainFlameList addObject:tFlame];
            [tFlame release];
            tFlame = [[commonValue sharedSingleton] popFlame];
        }
        
        // 애니메이션 효과 재개
        //[self resumeSchedulerAndActions];
    }
}
- (CCAnimation*) loadFlameAnimation {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_FLAME_PLIST textureFile:FILE_FLAME_IMG];
    NSMutableArray* flamekImgList = [NSMutableArray array];
    
    for(NSInteger i = 1; i < 3; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"effect%04d.png", i]];
    
        [flamekImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:flamekImgList delay:BOMB_FLAME_TIME];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:FILE_FLAME_PLIST];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:FILE_FLAME_IMG];
    
    return animation;
}
//////////////////////////////////////////////////////////////////////////
// 용사 End                                                              //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 몬스터 Start                                                           //
//////////////////////////////////////////////////////////////////////////
- (void) createMonsterAtTime:(id)sender {
    for (House *tHouse in [[commonValue sharedSingleton] getHouseList]) {
        if([houseHandling checkCreateMonter:tHouse]) {
            // 집에서 최대치로 생산됐는지 검사
            CCSprite *tSprite = [monsterHandling createMonster:0 position:[tHouse getPosition] houseNum:[tHouse getHouseNum]];
            [tSprite setVisible:YES];
            
            [pZoom addChild:tSprite z:(kMonsterLayer - [[commonValue sharedSingleton] monsterListCount])];
            [tHouse pluseMadeNum];
        }
    }
}
//////////////////////////////////////////////////////////////////////////
// 몬스터 End                                                             //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// House Start                                                          //
//////////////////////////////////////////////////////////////////////////
- (void) addHouse:(CGPoint)point tType:(NSInteger)tType {
    [houseHandling addHouse:point type:tType];
    
    [trapHandling tileChange:point type:tType];
}
//////////////////////////////////////////////////////////////////////////
// House End                                                            //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// Trap Start                                                           //
//////////////////////////////////////////////////////////////////////////
- (void) addTrap:(CGPoint)point tType:(NSInteger)tType {
    [trapHandling addTrap:point type:tType]; 
    
    if(![trapHandling checkMoveTile:tType])
        [[commonValue sharedSingleton] setMoveTable:point.x y:point.y direction:(-1)];
    else
        [[commonValue sharedSingleton] setMoveTable:point.x y:point.y direction:MoveNone];
    
    // 이동 경로 재계산
    [warriorHandling createMoveTable];
}
- (void) initTileSetupMenu {
    CCMenuItemImage *tileItem1 = [CCMenuItemImage itemFromNormalImage:@"Tile/tile-object-1.png" 
                                                        selectedImage:@"Tile/tile-object-1.png" 
                                                               target:self 
                                                             selector:@selector(tileSetupExplosive:)];
    CCMenuItemImage *tileItem2 = [CCMenuItemImage itemFromNormalImage:@"Tile/tile-object-2.png" 
                                                        selectedImage:@"Tile/tile-object-2.png" 
                                                               target:self 
                                                             selector:@selector(tileSetupTreasure:)];
    CCMenuItemImage *tileItem3 = [CCMenuItemImage itemFromNormalImage:@"Tile/tile-object-3.png" 
                                                        selectedImage:@"Tile/tile-object-3.png" 
                                                               target:self 
                                                             selector:@selector(tileSetupTrap:)];
    CCMenuItemImage *tileItem4 = [CCMenuItemImage itemFromNormalImage:@"Tile/tile-floor-0.png" 
                                                        selectedImage:@"Tile/tile-floor-0.png" 
                                                               target:self 
                                                             selector:@selector(tileSetupMonsterHouse1:)];
    [tileItem1 setScale:CHAR_SCALE];
    [tileItem2 setScale:CHAR_SCALE];
    [tileItem3 setScale:CHAR_SCALE];
    [tileItem4 setScale:CHAR_SCALE];
    [trapMenuList addObject:tileItem1];
    [trapMenuList addObject:tileItem2];
    [trapMenuList addObject:tileItem3];
    [trapMenuList addObject:tileItem4];
    
    menu1 = [CCMenu menuWithItems:nil];
    menu2 = [CCMenu menuWithItems:nil];
    menu3 = [CCMenu menuWithItems:nil];
    menu4 = [CCMenu menuWithItems:nil];
    
    menuPrint = MenuNone;
    [menu1 alignItemsHorizontallyWithPadding:2];
    [menu2 alignItemsVerticallyWithPadding:2];
    [menu3 alignItemsVerticallyWithPadding:2];
    [menu4 alignItemsHorizontallyWithPadding:2];
    [self installTrapMenuVisible:NO];    
    
    [pZoom addChild:menu1 z:kTileMenuLayer];
    [pZoom addChild:menu2 z:kTileMenuLayer];
    [pZoom addChild:menu3 z:kTileMenuLayer];
    [pZoom addChild:menu4 z:kTileMenuLayer];
}

- (BOOL) installTileCheck:(NSInteger)tileType {
    Coordinate *coordinate = [[Coordinate alloc] init];
    CGPoint tPoint = [coordinate convertTileToMap:tileSetupPoint];
    
    // 해당 타일에 용사나 몬스터가 있는 경우
    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        CGPoint wPoint = [tWarrior getPosition];
        
        if (tPoint.x - TILE_SIZE < wPoint.x && tPoint.x + TILE_SIZE > wPoint.x && 
            tPoint.y - TILE_SIZE < wPoint.y && tPoint.y + TILE_SIZE > wPoint.y) return NO;    
    }
    
    for (Monster *tMonster in [[commonValue sharedSingleton] getMonsterList]) {
        CGPoint mPoint = [tMonster getPosition];
        
        if (tPoint.x - TILE_SIZE < mPoint.x && tPoint.x + TILE_SIZE > mPoint.x && 
            tPoint.y - TILE_SIZE < mPoint.y && tPoint.y + TILE_SIZE > mPoint.y) return NO;
    }
    
    // 목적지까지 가능 경로가 없을 경우
    NSInteger moveDirection = [[commonValue sharedSingleton] getMoveTable:tileSetupPoint.x y:tileSetupPoint.y];
    //[warriorHandling getMoveTable:tileSetupPoint.x y:tileSetupPoint.y];
    if (![trapHandling checkMoveTile:tileType]) {
        [[commonValue sharedSingleton] setMoveTable:tileSetupPoint.x y:tileSetupPoint.y direction:(-1)];
    }
    
    if(![warriorHandling checkConnectRoad]) {
        [[commonValue sharedSingleton] setMoveTable:tileSetupPoint.x y:tileSetupPoint.y direction:moveDirection]; 
        return NO;
    }
    
    return YES;
}
- (void) tileSetupExplosive:(id)sender {
    // 설치가능한 경로인지 검사
    if(![self installTileCheck:TILE_EXPLOSIVE]) return;
    if(![self installMoneyCheck:MONEY_EXPLOSIVE]) return;
    
    [[commonValue sharedSingleton] minusStageMoney:MONEY_EXPLOSIVE];
    [[commonValue sharedSingleton] plusStagePoint:POINT_MADE_OBSTACLE];
    [trapHandling addTrap:tileSetupPoint type:TILE_EXPLOSIVE];
    
    // 이동 경로 재계산
    [warriorHandling createMoveTable];
    
    [self installTrapMenuVisible:NO];
}
- (void) tileSetupTreasure:(id)sender {
    // 설치가능한 경로인지 검사
    if(![self installTileCheck:TILE_TREASURE]) return;
    if(![self installMoneyCheck:MONEY_TREASURE]) return;
    
    [[commonValue sharedSingleton] minusStageMoney:MONEY_TREASURE];
    [[commonValue sharedSingleton] plusStagePoint:POINT_MADE_OBSTACLE];
    [trapHandling addTrap:tileSetupPoint type:TILE_TREASURE];
    
    // 이동 경로 재계산
    [warriorHandling createMoveTable];
    
    [self installTrapMenuVisible:NO];
}
- (void) tileSetupTrap:(id)sender {
    // 설치가능한 경로인지 검사
    if(![self installTileCheck:TILE_TRAP_CLOSE]) return;
    if(![self installMoneyCheck:MONEY_TRAP]) return;
    
    [[commonValue sharedSingleton] minusStageMoney:MONEY_TRAP];
    [[commonValue sharedSingleton] plusStagePoint:POINT_MADE_OBSTACLE];
    [trapHandling addTrap:tileSetupPoint type:TILE_TRAP_CLOSE];
    
    [self installTrapMenuVisible:NO];
}
- (void) tileSetupMonsterHouse1:(id)sender {
    // 설치가능한 경로인지 검사
    if(![self installTileCheck:TILE_MONSTER_HOUSE1]) return;
    if(![self installMoneyCheck:MONEY_HOUSE]) return;
    
    [[commonValue sharedSingleton] minusStageMoney:MONEY_HOUSE];
    [[commonValue sharedSingleton] plusStagePoint:POINT_MADE_OBSTACLE];
    
    // monsterHandling에 addHouse 등록하여 처리가 필요
    [houseHandling addHouse:tileSetupPoint type:TILE_MONSTER_HOUSE1];
    [trapHandling tileChange:tileSetupPoint type:TILE_MONSTER_HOUSE1];
    //[trapHandling addTrap:tileSetupPoint type:TILE_MONSTER_HOUSE1];
    [self installTrapMenuVisible:NO];
}
- (void) installTrapMenuVisible:(BOOL)flag {
    if (!flag) {
        NSInteger num = 0;
        
        if (menuPrint == MenuNone) return;
        else if (menuPrint == MenuDefault) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu1 removeChild:item cleanup:YES];
                else if(num == 1) [menu4 removeChild:item cleanup:YES];
                else if(num == 2 || num == 4) [menu2 removeChild:item cleanup:YES];
                else if(num == 3 || num == 5) [menu3 removeChild:item cleanup:YES];      
                
                num++;
            }
        } else if (menuPrint == MenuRigtht) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu1 removeChild:item cleanup:YES];
                else if(num == 1) [menu4 removeChild:item cleanup:YES];
                else if(num == 2 || num == 3 || num == 4 || num == 5) [menu2 removeChild:item cleanup:YES];                    
                num++;
            }
        } else if (menuPrint == MenuLeft) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu1 removeChild:item cleanup:YES];
                else if(num == 1) [menu4 removeChild:item cleanup:YES];
                else if(num == 2 || num == 3 || num == 4 || num == 5) [menu3 removeChild:item cleanup:YES];                    
                num++;
            }
        } else if (menuPrint == MenuTop) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu2 removeChild:item cleanup:YES];
                else if(num == 1) [menu3 removeChild:item cleanup:YES];
                else if(num == 2 || num == 3 || num == 4 || num == 5) [menu4 removeChild:item cleanup:YES];                    
                num++;
            }
        } else if (menuPrint == MenuBottom) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu2 removeChild:item cleanup:YES];
                else if(num == 1) [menu3 removeChild:item cleanup:YES];
                else if(num == 2 || num == 3 || num == 4 || num == 5) [menu1 removeChild:item cleanup:YES];                    
                num++;
            }
        } else if (menuPrint == MenuLeftTop) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu4 removeChild:item cleanup:YES];
                else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu3 removeChild:item cleanup:YES];                    
                num++;
            }
        } else if (menuPrint == MenuLeftBottom) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu1 removeChild:item cleanup:YES];
                else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu3 removeChild:item cleanup:YES];                   
                num++;
            }
        } else if (menuPrint == MenuRightTop) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu4 removeChild:item cleanup:YES];
                else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu2 removeChild:item cleanup:YES];                    
                num++;
            }
        } else if (menuPrint == MenuRightBottom) {
            for (CCMenuItem *item in trapMenuList) {
                if (num == 0) [menu1 removeChild:item cleanup:YES];
                else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu2 removeChild:item cleanup:YES];                   
                num++;
            }
        }
        
        menuPrint = MenuNone;
    } else {
        [menu1 alignItemsHorizontallyWithPadding:2];
        [menu2 alignItemsVerticallyWithPadding:2];
        [menu3 alignItemsVerticallyWithPadding:2];
        [menu4 alignItemsHorizontallyWithPadding:2];
    }
    
    [menu1 setVisible:flag];
    [menu2 setVisible:flag];
    [menu3 setVisible:flag];
    [menu4 setVisible:flag];
}
- (BOOL) installMoneyCheck:(NSInteger)money {
    if ([[commonValue sharedSingleton] getStageMoney] < money) return NO;
    
    return YES;
}
//////////////////////////////////////////////////////////////////////////
// Trap End                                                             //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// Touch 처리 Start                                                      //
//////////////////////////////////////////////////////////////////////////
// 사용자가 터치를 할 경우 
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self installTrapMenuVisible:NO];
    
    // 멀티 터치가 아닌 경우 
    if([[event allTouches] count] == 1) touchType = TOUCH;
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([[event allTouches] count] == 1) touchType = TOUCH_MOVE;

    [pZoom ccTouchesMoved:touches withEvent:event];
}

// 사용자가 터치를 끝낼 경우
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {// YES일 경우 : 터치, NO일 경우 : 터치하여 이동
    if(touchType && [[event allTouches] count] == 1) {
        // 터치된 항목이 뭐인지에 따라서 처리가 필요
        // 빈 타일일 경우 트랩 설치 화면
        // 트랩 설치화면이 떠 있는 상태
        // 설치화면 터치시 트랩 설치
        // 다른곳 터치시 트랩 설치화면 닫음
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        // 클릭한 위치 확인
        Coordinate *coordinate = [[Coordinate alloc] init];
        CGPoint thisArea = [coordinate convertAbsCoordinateToTile:[pZoom convertTouchToNodeSpace:touch]];
        
        // 설치된 타일 확인
        unsigned int tType = [[commonValue sharedSingleton] getMapInfo:(int)thisArea.x y:(int)thisArea.y];
        if(tType == TILE_WALL10) {
            // 효과음 재생
            [[SimpleAudioEngine sharedEngine] playEffect:WALL_SOUND];
            
            [trapHandling addTrap:thisArea type:TILE_WALL01];
        } else if(tType == TILE_WALL01) {
            // 효과음 재생
            [[SimpleAudioEngine sharedEngine] playEffect:WALL_SOUND];
            [trapHandling addTrap:thisArea type:TILE_GROUND2];
            [[commonValue sharedSingleton] plusStageMoney:MONEY_DESTORY_WALL];
            [[commonValue sharedSingleton] plusStagePoint:POINT_DESTORY_WALL];
            
            // 이동 경로 재계산
            [[commonValue sharedSingleton] setMoveTable:(int)thisArea.x y:(int)thisArea.y direction:MoveNone];
            [warriorHandling createMoveTable];
        } else if(tType == TILE_GROUND1 || tType == TILE_GROUND2) {
            // 트랩 설치 화면 출력
            tileSetupPoint = thisArea;
                        
            CGFloat tileSize = TILE_SIZE * [pZoom getScale];
            NSInteger num = 0;
            if (convertedLocation.x - tileSize <= 0 && convertedLocation.y + tileSize >= DEVICE_HEIGHT) {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu4 addChild:item];
                    else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu3 addChild:item];      
                    
                    num++;
                }
                menuPrint = MenuLeftTop;
            } else if (convertedLocation.x - tileSize <= 0 && convertedLocation.y - tileSize <= 0) {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu1 addChild:item];
                    else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu3 addChild:item];      
                    
                    num++;
                }
                menuPrint = MenuLeftBottom;
            } else if (convertedLocation.x + (2 * tileSize) >= DEVICE_WIDTH && convertedLocation.y + tileSize >= DEVICE_HEIGHT) {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu4 addChild:item];
                    else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu2 addChild:item];      
                    
                    num++;
                }
                menuPrint = MenuRightTop;
            } else if (convertedLocation.x + tileSize >= DEVICE_WIDTH && convertedLocation.y - tileSize <= 0) {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu1 addChild:item];
                    else if(num == 1 || num == 2 || num == 3 || num == 4 || num == 5) [menu2 addChild:item];      
                    
                    num++;
                }
                menuPrint = MenuRightBottom;
            } else if (convertedLocation.x - tileSize <= 0) {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu1 addChild:item];
                    else if(num == 1) [menu4 addChild:item];
                    else if(num == 2 || num == 3 || num == 4 || num == 5) [menu3 addChild:item];      
                    
                    num++;
                }
                menuPrint = MenuLeft;
            } else if (convertedLocation.x + tileSize >= DEVICE_WIDTH) {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu1 addChild:item];
                    else if(num == 1) [menu4 addChild:item];
                    else if(num == 2 || num == 3 || num == 4 || num == 5) [menu2 addChild:item];
                    
                    num++;
                }
                menuPrint = MenuRigtht;
            } else if (convertedLocation.y - tileSize <= 0) { 
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu2 addChild:item];
                    else if(num == 1) [menu3 addChild:item];
                    else if(num == 2 || num == 3 || num == 4 || num == 5) [menu1 addChild:item];
                    
                    num++;
                }
                menuPrint = MenuBottom;
            } else if (convertedLocation.y + tileSize >= DEVICE_HEIGHT) {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu2 addChild:item];
                    else if(num == 1) [menu3 addChild:item];
                    else if(num == 2 || num == 3 || num == 4 || num == 5) [menu4 addChild:item];
                    
                    num++;
                }
                menuPrint = MenuTop;
            } else {
                for (CCMenuItem *item in trapMenuList) {
                    if (num == 0) [menu1 addChild:item];
                    else if(num == 1) [menu4 addChild:item];
                    else if(num == 2 || num == 4) [menu2 addChild:item];
                    else if(num == 3 || num == 5) [menu3 addChild:item];      
                    
                    num++;
                }
                menuPrint = MenuDefault;
            }
            
            CGPoint trapSetupPosition = [coordinate convertTileToMap:thisArea];
            [menu1 setPosition:ccp(trapSetupPosition.x, trapSetupPosition.y + TILE_SIZE)];
            [menu2 setPosition:ccp(trapSetupPosition.x - TILE_SIZE, trapSetupPosition.y)];
            [menu3 setPosition:ccp(trapSetupPosition.x + TILE_SIZE, trapSetupPosition.y)];
            [menu4 setPosition:ccp(trapSetupPosition.x, trapSetupPosition.y - TILE_SIZE)];
            
            if (menuPrint == MenuRightTop || menuPrint == MenuLeftTop) {
                if (menuPrint == MenuRightTop) {
                    [menu4 setPosition:ccp(trapSetupPosition.x, trapSetupPosition.y - (2 *TILE_SIZE))];
                }
                [menu2 setPosition:ccp(trapSetupPosition.x - TILE_SIZE, trapSetupPosition.y - TILE_SIZE - 5)];
                [menu3 setPosition:ccp(trapSetupPosition.x + TILE_SIZE, trapSetupPosition.y - TILE_SIZE - 5)];
            } else if (menuPrint == MenuLeftBottom || menuPrint == MenuRightBottom) {
                [menu2 setPosition:ccp(trapSetupPosition.x - TILE_SIZE, trapSetupPosition.y + TILE_SIZE + 5)];
                [menu3 setPosition:ccp(trapSetupPosition.x + TILE_SIZE, trapSetupPosition.y + TILE_SIZE + 5)];
            }
            
            [self installTrapMenuVisible:YES]; 
        }
        
        NSLog(@"Touch Position : %d %d", (int) thisArea.x, (int) thisArea.y);
    }
    
    // 멀티 터치는 처리하지 않음
    [pZoom ccTouchesEnded:touches withEvent:event];
}
//////////////////////////////////////////////////////////////////////////
// Touch 처리 End                                                        //
//////////////////////////////////////////////////////////////////////////
@end