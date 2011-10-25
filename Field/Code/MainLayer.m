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
    [(CCLayerMultiplex*)parent_ switchTo:1];
}

@end


//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////


// 게임 화면
@class Warrior;
@implementation playMap
@synthesize sprite;
@synthesize function, trapHandling, warriorHandling;
@synthesize layer;

//////////////////////////////////////////////////////////////////////////
// 게임 초기화 Start                                                      //
//////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (id)init:(NSInteger)p_level degree:(NSInteger)p_degree {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        stageLevel = p_level;
        stageDegree = p_degree;
    }
    
    return self;
}

- (void) onEnterTransitionDidFinish {    
    // 필요한 항목 초기화
    file = [[File alloc] init];
    function = [[Function alloc] init];
    trapHandling = [[TrapHandling alloc] init];
    monsterHandling = [[MonsterHandling alloc] init];
    warriorHandling = [[WarriorHandling alloc] init:trapHandling];
    
    [[commonValue sharedSingleton] setViewScale:1];
    
    NSString *path = [file loadFilePath:@"Stage150.plist"];
    [file loadStageData:path];
    
    [self initMap];
    //[monsterHandling initMonster];
    //[warriorHandling initWarrior];
    
    [self addTrap:ccp(7, 2) tType:TILE_TREASURE];
    
    [self createMonster];

    // 일정한 간격으로 호출~
    //[self schedule:@selector(moveWarrior:) interval:REFRESH_DISPLAY_TIME];
    //[self schedule:@selector(createWarriorAtTime:) interval:CREATE_WARRIOR_TIME];
    //[self schedule:@selector(removeWarrior:) interval:3];
    }

- (void) dealloc {
    [super dealloc];
}
//////////////////////////////////////////////////////////////////////////
// 게임 초기화 End                                                        //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 맵 처리 Start                                                         //
//////////////////////////////////////////////////////////////////////////
// 타일맵 등록
- (void) initMap {
    // 타일 맵 등록
    CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:FILE_TILE_MAP];
    map.scale = MAP_SCALE * [[commonValue sharedSingleton] getViewScale];
    // 왼쪽 상단에 맵 왼쪽 상단이 위치하도록 설정(하지 않을 경우 왼쪽 하단에 맵 왼쪽 하단이 위치) 
    map.position = ccp(0, [[commonValue sharedSingleton]getDeviceSize].height - (TILE_NUM * TILE_SIZE));  
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
    Coordinate *coordinate = [[Coordinate alloc] init];
    
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    CCTMXLayer *layer1 = [map layerNamed:MAP_LAYER1];
    CCTMXLayer *layer2 = [map layerNamed:MAP_LAYER2];
    
    for(int i = 0; i < TILE_NUM; i++) {
        for(int j = 0; j < TILE_NUM; j++) {
            // 타일맵에 위치한 타일 타입을 읽어들임
            if([layer2 tileGIDAt:ccp(i, j)] != TILE_NONE) 
                [[commonValue sharedSingleton] setMapInfo:i y:j tileType:[layer2 tileGIDAt:ccp(i, j)]];
            else
                [[commonValue sharedSingleton] setMapInfo:i y:j tileType:[layer1 tileGIDAt:ccp(i, j)]];
            
            unsigned int tileType = [[commonValue sharedSingleton] getMapInfo:i y:j];
            // 타일 타입에 따라 이동이 가능한지 검사
            if(tileType == TILE_NONE || 
               tileType == TILE_WALL1 || tileType == TILE_WALL2 || 
               tileType == TILE_TREASURE || tileType == TILE_EXPLOSIVE)
                [warriorHandling setMoveTable:i y:j value:-1];
            else
                [warriorHandling setMoveTable:i y:j value:MoveNone];
            
            // 타일에 설치된 트랩이 있는지 확인
            if(tileType == TILE_TRAP_OPEN || tileType == TILE_TRAP_CLOSE ||
               tileType == TILE_TREASURE || tileType == TILE_EXPLOSIVE)
            {
                [trapHandling addTrap:ccp(i, j) abs:[coordinate convertTileToMap:ccp(i, j)] type:tileType];
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
    if([[commonValue sharedSingleton] getStageWarriorCount] > [warriorHandling warriorNum]) {
        NSDictionary *wInfo = [file loadWarriorInfo:[warriorHandling warriorNum]];
        
        CCSprite *tSprite = [warriorHandling createWarrior:wInfo];
        [self addChild:tSprite z:kWarriorLayer];
    }
}

- (void) moveWarrior:(id) sender {
    // 잠시 애니메이션 효과 중단
    [self pauseSchedulerAndActions];
    
    [warriorHandling moveWarrior];
    
    // 애니메이션 효과 재개
    [self resumeSchedulerAndActions];
}
//////////////////////////////////////////////////////////////////////////
// 용사 End                                                              //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 몬스터 Start                                                           //
//////////////////////////////////////////////////////////////////////////
- (void) createMonster {
    CCSprite *tSprite = [monsterHandling createMonster:1 position:ccp(0, 0)];
    [self addChild:tSprite z:kWarriorLayer];
    
    NSLog(@"Add Monster");
}
//////////////////////////////////////////////////////////////////////////
// 몬스터 End                                                             //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// Trap Start                                                           //
//////////////////////////////////////////////////////////////////////////
- (void) addTrap:(CGPoint)point tType:(NSInteger)tType {
    Coordinate *coordinate = [[Coordinate alloc] init];
    
    [trapHandling addTrap:point abs:[coordinate convertTileToMap:point] type:tType];
    [[commonValue sharedSingleton] setMapInfo:point.x y:point.y tileType:tType];
    
    if(tType == TILE_NONE || 
       tType == TILE_WALL1 || tType == TILE_WALL2 || 
       tType == TILE_TREASURE || tType == TILE_EXPLOSIVE)
        [warriorHandling setMoveTable:point.x y:point.y value:-1];
    else
        [warriorHandling setMoveTable:point.x y:point.y value:MoveNone];
    
    // 이동 경로 재계산
    [warriorHandling createMoveTable];
}
//////////////////////////////////////////////////////////////////////////
// Trap End                                                             //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// Touch 처리 Start                                                      //
//////////////////////////////////////////////////////////////////////////
// 사용자가 터치를 할 경우 
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 터치만 처리
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

// 사용자가 터치로 이동할 경우
- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {  
    if([[event allTouches] count] == 1) {
        // 멀티 터치가 아닌 경우   
        touchType = TOUCH_MOVE;
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        // 맵과 기타 잡것들 옮기기 전에 일시 정지 시킴
        [self pauseSchedulerAndActions];
        
        [self moveTouchMap:convertedLocation];
        [self moveTouchWarrior];
        
        // 일시 정지 해제
        [self resumeSchedulerAndActions];
    } else if([[event allTouches] count] == 2) {
        // 멀티 터치
        // 확대/축소시 map.position의 위치를 지정부분 수정 필요
        CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
        CGSize deviceSize = [[commonValue sharedSingleton] getDeviceSize];
        CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
        
        NSArray *touchArray = [[event allTouches] allObjects];
        CGFloat length = [function calcuationMultiTouchLength:touchArray];
        CGFloat changeScale;
        
        // prevMultiLength 와 length 비교 - 늘어나면 확대, 줄어들면 축소
        // 확대/축소 비율에 따라 조정 - 0.8 ~ 1.2내외로 설정  
        
        // 확대/축소 범위가 작을 경우 무시?
        if(ABS(prevMultiLength - length) < 0.5) return;
        
        if(prevMultiLength > length) {
            if(viewScale <= 0.8f) return;
            
            changeScale = -MULTI_SCALE;
        } else {
            if(viewScale >= 1.2f) return;
            
            changeScale = MULTI_SCALE;
        }
        
        
        // 맵과 기타 잡것들 옮기기 전에 일시 정지 시킴
        [self pauseSchedulerAndActions];
        
        // 맵 비율 조정 및 위치 조정
        viewScale = viewScale + changeScale;
        map.scale = MAP_SCALE * viewScale;
        map.position = [self checkMovePosition:ccp(map.position.x - (deviceSize.width * changeScale), 
                                                   map.position.y + (deviceSize.height * changeScale))];
        
        // 용사 비율 조정
        for(int i = 0; i < [warriorHandling warriorCount]; i++) {
            Warrior *tWarrior = [warriorHandling warriorInfo:i];
            CCSprite *tSprite = [tWarrior getSprite];
            tSprite.scale = viewScale;
            tSprite.position = ccp(map.position.x + ([tWarrior getPosition].x * viewScale), 
                                   map.position.y + ([tWarrior getPosition].y * viewScale));
        }
        
        [[commonValue sharedSingleton] setViewScale:viewScale];
        [[commonValue sharedSingleton] setTileMap:map];
        prevMultiLength = length;
        
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
        // 트랩 설치화면이 떠 있는 상태
        // 설치화면 터치시 트랩 설치
        // 다른곳 터치시 트랩 설치화면 닫음
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        
        // 클릭한 위치 확인
        Coordinate *coordinate = [[Coordinate alloc] init];
        CGPoint thisArea = [coordinate convertCocos2dToTile:location];
        NSLog(@"%f %f", thisArea.x, thisArea.y);
        
        //[self printTrapList:thisArea];
    }
    
    // 멀티 터치는 처리하지 않음
}

// 화면 터치로 이동시 맵타일 이동
- (void) moveTouchMap:(CGPoint)currentPoint {
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    
    CGPoint movePoint = CGPointMake(currentPoint.x - prevPoint.x, currentPoint.y - prevPoint.y);
    CGPoint mapMove = [self checkMovePosition:CGPointMake(mapPosition.x + movePoint.x, mapPosition.y + movePoint.y)];
    
    prevPoint = currentPoint;
    [[commonValue sharedSingleton] setMapPosition:CGPointMake(mapMove.x, mapMove.y)];
}

// 화면 터치로 이동시 용사 이동~
- (void) moveTouchWarrior {
    CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    
    for (int i = 0; i < [warriorHandling warriorCount]; i++) {
        // 현재 위치 및 정보를 가져옴
        Warrior *tWarrior = [warriorHandling warriorInfo:i];//[warriorList objectAtIndex:i];
        CCSprite *tSprite = [tWarrior getSprite];
        CGPoint position = [tWarrior getPosition];
        
        tSprite.position = ccp(mapPosition.x + (position.x * viewScale), 
                               mapPosition.y + (position.y * viewScale));
    }
}

// 터치로 화면 이동시 맵 밖으로 이동 못하게 차단
- (CGPoint) checkMovePosition:(CGPoint)position {
    CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    CGSize deviceSize = [[commonValue sharedSingleton] getDeviceSize];
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    
    if (position.x > 0 && 
        position.y < -(mapSize.height * viewScale - deviceSize.height)) {
        // 좌상단
        position = ccp(0, -(mapSize.height * viewScale - deviceSize.height)); 
    } else if (mapPosition.y < -(mapSize.height * viewScale - deviceSize.height)) {
        // 상단        
        position = ccp(position.x, -(mapSize.height * viewScale - deviceSize.height));
    } else if (position.x < -(mapSize.width * viewScale - deviceSize.width) && 
               position.y < -(mapSize.height * viewScale - deviceSize.height)) {
        // 우상단
        position = ccp(-(mapSize.width * viewScale - deviceSize.width), 
                       -(mapSize.height * viewScale - deviceSize.height));
    } else if (mapPosition.x < -(mapSize.width * viewScale - deviceSize.width)) {
        // 오른쪽
        position = ccp(-(mapSize.width * viewScale - deviceSize.width), position.y);
    } else if(mapPosition.x < -(mapSize.width * viewScale - deviceSize.width) && 
              position.y > 0) {
        // 우하단
        position = ccp(-(mapSize.width * viewScale - deviceSize.width), 0);
    } else if (position.x > 0) {
        // 왼쪽
        position = ccp(0, position.y);
    } else if (position.y > 0) {
        // 아래
        position = ccp(position.x, 0);
    } else if (position.x > 0 && position.y > 0) {
        // 좌하단
        position = ccp(0, 0);
    }
    
    return position;
}
//////////////////////////////////////////////////////////////////////////
// Touch 처리 End                                                        //
//////////////////////////////////////////////////////////////////////////
@end