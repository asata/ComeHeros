#import "MainLayer.h"

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
        CCMenu *techniqueTrainingMenu = [CCMenu menuWithItems:techniqueItem1, nil];
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

@end
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////


// 게임 화면
@class Warrior;
@implementation playMap

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
    
    PinchZoomLayer *pZoom = [PinchZoomLayer initPinchZoom:self];
    
    // zoom out all the way
    [pZoom scaleToFit];
    
    return self;
}

- (void) onEnterTransitionDidFinish {    
    // 필요한 항목 초기화
    [self initGame];
    
    Coordinate *coordinate = [[Coordinate alloc] init];
    CGPoint sPoint = [[commonValue sharedSingleton] getStartPoint];
    CGPoint temp = [coordinate convertTileToCocoa:ccp(sPoint.x, sPoint.y + 4)];
    _position = temp;

    //[self setViewpointCenter:temp];
    
    // 튜토리얼이 필요한지 검사하여 필요할 경우 호출
    // tutorialLayer = [[TutorialLayer alloc] init];
    // [call TutorialLayer]
    
    // 일정한 간격으로 호출~
    //[self schedule:@selector(moveAction:) interval:REFRESH_DISPLAY_TIME];
    //[self schedule:@selector(createWarriorAtTime:) interval:CREATE_WARRIOR_TIME];
    //[self schedule:@selector(createMonsterAtTime:) interval:CREATE_MONSTER_TIME];
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
    
    [[commonValue sharedSingleton] setGamePlaying:YES];
    [[commonValue sharedSingleton] initCommonValue];
    [[commonValue sharedSingleton] setViewScale:1];
    
    NSString *path = [file loadFilePath:FILE_STAGE_PLIST];
    [file loadStageData:path];
    
    [self initMap]; 
    [self initMenu];
    [self initLabel];
    [self initTileSetupMenu];
}
- (void) initLabel {
    labelTime = [CCLabelAtlas labelWithString:[[commonValue sharedSingleton] getStageTimeString]
                                  charMapFile:FILE_NUMBER_IMG 
                                    itemWidth:16
                                   itemHeight:20
                                 startCharMap:'.'];
    labelTime.position = TIME_LABEL_POSITION;
    [self addChild:labelTime z:kMainLabelLayer];
    
    labelMoney= [CCLabelAtlas labelWithString:[[commonValue sharedSingleton] getStageMoneyString]
                                  charMapFile:FILE_NUMBER_IMG 
                                    itemWidth:16
                                   itemHeight:20
                                 startCharMap:'.'];
    labelMoney.position = MONEY_LABEL_POSITION;
    [self addChild:labelMoney z:kMainLabelLayer];
    
    labelPoint = [CCLabelAtlas labelWithString:[[commonValue sharedSingleton] getStagePointString]
                                  charMapFile:FILE_NUMBER_IMG 
                                    itemWidth:16
                                   itemHeight:20
                                 startCharMap:'.'];
    labelPoint.position = POINT_LABEL_POSITION;
    [self addChild:labelPoint z:kMainLabelLayer];
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
    [[commonValue sharedSingleton] setGamePause:NO];
    [[commonValue sharedSingleton] setGamePlaying:NO];
    
    [self removeChild:menu1 cleanup:YES];
    [self removeChild:menu2 cleanup:YES];
    [self removeChild:menu3 cleanup:YES];
    [self removeChild:menuPause cleanup:YES];
    
    [self removeChild:labelMoney cleanup:YES];
    [self removeChild:labelTime cleanup:YES];
    [self removeChild:labelPoint cleanup:YES];
    
    
    for (CCSprite *tSprite in chainFlameList) {
        [tSprite setVisible:NO];
        [self removeChild:tSprite cleanup:YES];
    }
    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        [self removeChild:[tWarrior getSprite] cleanup:YES];
    }
    
    for (Monster *tMonster in [[commonValue sharedSingleton] getMonsterList]) {
        [self removeChild:[tMonster getSprite] cleanup:YES];
    }
    
    [self removeChild:pauseLayer cleanup:YES];
    [self removeChild:resultLayer cleanup:YES];
    [self unscheduleAllSelectors];
}
- (void) updateLabel {
    [labelTime setString:[[commonValue sharedSingleton] getStageTimeString]];
    [labelMoney setString:[[commonValue sharedSingleton] getStageMoneyString]];
    [labelPoint setString:[[commonValue sharedSingleton] getStagePointString]];
}
- (void) gamePause:(id)sender {
    // 게임 일시 정지
    [self onPause];   
}
- (void) onPause {
    [[commonValue sharedSingleton] setGamePause:YES];
    [[CCDirector sharedDirector] pause];
    [self addChild:pauseLayer z:kPauseLayer];
    self.isTouchEnabled = NO;
    
    // 버튼 비활성화
}
- (void) resume {
    [[commonValue sharedSingleton] setGamePause:NO];
    [self removeChild:pauseLayer cleanup:YES];
    self.isTouchEnabled = YES;
    
    // 버튼 활성화
    
    [[CCDirector sharedDirector] resume];
}
- (void) Restart {
    [self destoryGame];
    [[CCDirector sharedDirector] resume];
    
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}
- (void) Quit {
    [self destoryGame];
    [[CCDirector sharedDirector] resume];
    
    [(CCLayerMultiplex*)parent_ switchTo:MAIN_LAYER];
}
//////////////////////////////////////////////////////////////////////////
// 게임 초기화 End                                                        //
//////////////////////////////////////////////////////////////////////////
- (void) gameEnd:(BOOL)victory {
    [self unscheduleAllSelectors];
    
    if (victory) {
        NSLog(@"Win");
    } else {
        NSLog(@"Lose");
    }
    
    [self addChild:resultLayer z:kPauseLayer];
    self.isTouchEnabled = NO;
}


//////////////////////////////////////////////////////////////////////////
// 맵 처리 Start                                                         //
//////////////////////////////////////////////////////////////////////////
// 타일맵 등록
- (void) initMap {
    // 타일 맵 등록
    CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:FILE_TILE_MAP];
    map.scale = MAP_SCALE * [[commonValue sharedSingleton] getViewScale];
    // 왼쪽 상단에 맵 왼쪽 상단이 위치하도록 설정(하지 않을 경우 왼쪽 하단에 맵 왼쪽 하단이 위치) 
    map.anchorPoint = CGPointZero;
    //map.position = ccp(0, [[commonValue sharedSingleton]getDeviceSize].height - (TILE_NUM * TILE_SIZE));  
    //map.anchorPoint = ccp(0, -1);
    [[commonValue sharedSingleton] setTileMap:map];
    mapSize = [map contentSize];
    mapSize = CGSizeMake([map contentSize].width * MAP_SCALE, [map contentSize].height * MAP_SCALE);
    [self addChild:map z:kBackgroundLayer];
    
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
                if(tileType == TILE_WALL10) {
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
            
            if([trapHandling checkObstacleTile:tileType])
                // 타일에 설치된 트랩이 있는지 확인
                [trapHandling addTrap:ccp(i, j) type:tileType];
            else if ([trapHandling checkHouseTile:tileType]) 
                // 몬스터 집이 있는 경우
                [self addHouse:ccp(i, j) tType:tileType];
            else if (tileType == TILE_START) 
                // 시작 지점인 경우
                [[commonValue sharedSingleton] setStartPoint:ccp(i, j)];
            else if (tileType == TILE_END)
                // 도착 지점인 경우
                [[commonValue sharedSingleton] setEndPoint:ccp(i, j)];
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
    [[commonValue sharedSingleton] plusStageTime];
    
    if ([[commonValue sharedSingleton] getStageTime] / 5 != [[commonValue sharedSingleton] getWarriorNum]) return;
    if ([[commonValue sharedSingleton] getStageWarriorCount] / 5 > [[commonValue sharedSingleton] getWarriorNum]) {
        NSDictionary *wInfo = [file loadWarriorInfo:[[commonValue sharedSingleton] getWarriorNum]];
        
        CCSprite *tSprite = [warriorHandling createWarrior:wInfo];
        [self addChild:tSprite 
                     z:(kWarriorLayer - [[commonValue sharedSingleton] warriorListCount]) 
                   tag:[[commonValue sharedSingleton] getWarriorNum]];
    }
}
- (void) createWarrior {
    NSDictionary *wInfo = [file loadWarriorInfo:[[commonValue sharedSingleton] getWarriorNum]];
    CCSprite *tSprite = [warriorHandling createWarrior:wInfo];
    [self addChild:tSprite z:(kWarriorLayer - [[commonValue sharedSingleton] warriorListCount])];
}

- (void) moveAction:(id) sender {
    [self updateLabel];
    
    // 용사가 모두 죽었는지 검사
    if ([[commonValue sharedSingleton] getKillWarriorNum] == [[commonValue sharedSingleton] getStageWarriorCount] / 5) {
        [self gameEnd:GAME_VICTORY];
    } else {
        // 잠시 애니메이션 효과 중단
        [self pauseSchedulerAndActions];
        
        // 폭발시 생성된 불꽃 제거
        while ([chainFlameList count] > 0) {
            CCSprite *dFlame = [chainFlameList objectAtIndex:0];
            [dFlame setVisible:NO];
            [chainFlameList removeObject:dFlame];
        }
        
        if (![warriorHandling moveWarrior]) {
            [self gameEnd:GAME_LOSE];
        }
        
        [monsterHandling moveMonster];
        
        // 묘비를 가장 아래로 내림
        for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
            if([tWarrior getDeath] == DEATH && [tWarrior getDeathReOrder]) {
                [self reorderChild:[tWarrior getSprite] z:kTombstoneLayer];
                [tWarrior changeDeathOrder];
            }
        }
        
        // 폭발물 폭발시 불꽃을 삽입
        CCSprite *tFlame = [[commonValue sharedSingleton] popFlame];
        while (tFlame != nil) {
            [tFlame setScale:[[commonValue sharedSingleton] getViewScale]];
            [self addChild:tFlame z:kFlameLayer];
            [chainFlameList addObject:tFlame];
            tFlame = [[commonValue sharedSingleton] popFlame];
        }
        
        // 애니메이션 효과 재개
        [self resumeSchedulerAndActions];
    }
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
            
            [self addChild:tSprite z:(kMonsterLayer - [[commonValue sharedSingleton] monsterListCount])];
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
    
    menu1 = [CCMenu menuWithItems:tileItem1, tileItem2, nil];
    menu2 = [CCMenu menuWithItems:nil];
    menu3 = [CCMenu menuWithItems:tileItem3, tileItem4, nil];
    [menu1 alignItemsVerticallyWithPadding:5];
    [menu2 alignItemsVerticallyWithPadding:5];
    [menu3 alignItemsVerticallyWithPadding:5];
    [self installTrapMenuVisible:NO];    
    
    [self addChild:menu1 z:kTileMenuLayer];
    [self addChild:menu2 z:kTileMenuLayer];
    [self addChild:menu3 z:kTileMenuLayer];
    
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
    [trapHandling addTrap:tileSetupPoint type:TILE_MONSTER_HOUSE1];
    [self installTrapMenuVisible:NO];
}
- (void) installTrapMenuVisible:(BOOL)flag {
    [menu1 setVisible:flag];
    [menu2 setVisible:flag];
    [menu3 setVisible:flag];
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
/*- (void) setViewpointCenter:(CGPoint)point {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(point.x, winSize.width / 2);
    int y = MAX(point.y, winSize.height / 2);
    x = MIN(x, ([[commonValue sharedSingleton] getMapSize].width * TILE_SIZE) - winSize.width / 2);
    y = MIN(y, ([[commonValue sharedSingleton] getMapSize].height * TILE_SIZE) - winSize.height / 2);
    
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(winSize.width / 2, winSize.height / 2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
}
-(void)setPlayerPosition:(CGPoint)position {
	_position = position;
}

// 사용자가 터치를 할 경우 
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self installTrapMenuVisible:NO];
    
    if([[event allTouches] count] == 1) {
        // 멀티 터치가 아닌 경우 
        touchType = TOUCH;
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        prevPoint = [[CCDirector sharedDirector] convertToGL:location];
    } else if([[event allTouches] count] == 2) {
        // 멀티 터치
        NSArray *touchArray = [[event allTouches] allObjects];
        prevMultiLength = [function calcuationMultiTouchLength:touchArray];        
    }
}
- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {  
    if([[event allTouches] count] == 1) {
        // 멀티 터치가 아닌 경우   
        touchType = TOUCH_MOVE;
        
        // 맵과 기타 잡것들 옮기기 전에 일시 정지 시킴
        [self pauseSchedulerAndActions];
        
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInView: [touch view]];		
        touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];
        
        CGPoint playerPos = _position;
        CGPoint diff = ccpSub(touchLocation, playerPos);
        if (abs(diff.x) > abs(diff.y)) {
            if (diff.x > 0) {
                playerPos.x += TILE_SIZE;
            } else {
                playerPos.x -= TILE_SIZE; 
            }    
        } else {
            if (diff.y > 0) {
                playerPos.y += TILE_SIZE;
            } else {
                playerPos.y -= TILE_SIZE;
            }
        }
        
        if (playerPos.x <= ([[commonValue sharedSingleton] getMapSize].width * TILE_SIZE) &&
            playerPos.y <= ([[commonValue sharedSingleton] getMapSize].height * TILE_SIZE) &&
            playerPos.y >= 0 &&
            playerPos.x >= 0 ) {
            [self setPlayerPosition:playerPos];
        }
        
        [self setViewpointCenter:_position];
        
        // 일시 정지 해제
        [self resumeSchedulerAndActions];
    }
}

// 사용자가 터치를 끝낼 경우
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // YES일 경우 : 터치, NO일 경우 : 터치하여 이동
    if(touchType && [[event allTouches] count] == 1) {
        // 터치된 항목이 뭐인지에 따라서 처리가 필요
        // 빈 타일일 경우 트랩 설치 화면
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        //CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        // 클릭한 위치 확인
        Coordinate *coordinate = [[Coordinate alloc] init];
        CGPoint thisArea = [coordinate convertCocos2dToTile:location];
        
        // 설치된 타일 확인
        unsigned int tType = [[commonValue sharedSingleton] getMapInfo:(int)thisArea.x y:(int)thisArea.y];
        if(tType == TILE_WALL10) {
            [trapHandling addTrap:thisArea type:TILE_WALL01];
        } else if(tType == TILE_WALL01) {
            [trapHandling addTrap:thisArea type:TILE_GROUND2];
            [[commonValue sharedSingleton] plusStageMoney:MONEY_DESTORY_WALL];
            [[commonValue sharedSingleton] plusStagePoint:POINT_DESTORY_WALL];
            
            // 이동 경로 재계산
            [[commonValue sharedSingleton] setMoveTable:(int)thisArea.x y:(int)thisArea.y direction:MoveNone];
            [warriorHandling createMoveTable];
        } else if(tType == TILE_GROUND1 || tType == TILE_GROUND2) {
            // 트랩 설치 화면 출력
            tileSetupPoint = thisArea;
            
            CGPoint point = [coordinate convertTileToCocoa:thisArea];
            [menu1 setPosition:ccp(point.x - TILE_SIZE, point.y)];
            [menu2 setPosition:ccp(point.x, point.y)];
            [menu3 setPosition:ccp(point.x + TILE_SIZE, point.y)];
            
            [self installTrapMenuVisible:YES]; 
        }
        
        NSLog(@"Touch Position : %d %d", (int) thisArea.x, (int) thisArea.y);
    }
    
    // 멀티 터치는 처리하지 않음
}*/
//////////////////////////////////////////////////////////////////////////
// Touch 처리 End                                                        //
//////////////////////////////////////////////////////////////////////////
@end