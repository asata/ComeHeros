#import "MainLayer.h"

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// 메인 화면
@implementation MainLayer

- (id)init {
    if ((self = [super init])) {
        deviceSize = [[CCDirector sharedDirector] winSize];
        
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
@synthesize map, texture, sprite;
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
    warriorList = [[NSMutableArray alloc] init];
    trapList = [[NSMutableArray alloc] init];
    idleSprite = [[NSMutableArray alloc] init];
    idleAnimate = [[NSMutableArray alloc] init];
    texture = [[CCTextureCache sharedTextureCache] addImage:@"texture-character.png"];
    
    warriorNum = 0;
    trapNum = 0;
    
    viewScale = 1;
    
    startPoint = [self convertTileToMap:StartPoint];
    destinationPoint = [self convertTileToMap:EndPoint];
    
    [self initMap];
    [self initWarrior];
    
    [self createWarrior:ARCHER];
    //[self createWarrior:FIGHTER];
    //[self createWarrior:MAGE];

    // 일정한 간격으로 호출~
    [self schedule:@selector(moveWarrior:) interval:REFRESH_DISPLAY_TIME];
    //[self schedule:@selector(createWarriorAtTime:) interval:CREATE_WARRIOR_TIME];
    //[self schedule:@selector(removeWarrior:) interval:3];
}

- (void) dealloc {
    [stageInfo release];
    
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
    map = [CCTMXTiledMap tiledMapWithTMXFile:@"sample.tmx"];
    map.scale = MAP_SCALE * viewScale;
    // 왼쪽 상단에 맵 왼쪽 상단이 위치하도록 설정(하지 않을 경우 왼쪽 하단에 맵 왼쪽 하단이 위치) 
    map.position = ccp(0, deviceSize.height - (TILE_NUM * TILE_SIZE));  
    mapSize = [map contentSize];
    mapSize = CGSizeMake([map contentSize].width * MAP_SCALE, [map contentSize].height * MAP_SCALE);
    [self addChild:map z:kBackgroundLayer];
    
    // 타일 맵을 읽어 들임
    [self loadTileMap];
    
    // 이동 경로 탐색
    [self createMoveTable];
}

// 타일맵에 있는 타일을 읽어들임
- (void) loadTileMap {
    CCTMXLayer *layer1 = [map layerNamed:@"Layer 1"];
    CCTMXLayer *layer2 = [map layerNamed:@"New Layer"];
    
    for(int i = 0; i < TILE_NUM; i++) {
        for(int j = 0; j < TILE_NUM; j++) {
            // 타일맵에 위치한 타일 타입을 읽어들임
            if([layer2 tileGIDAt:ccp(i, j)] != TILE_NONE) 
                mapInfo[i][j] = [layer2 tileGIDAt:ccp(i, j)];
            else
                mapInfo[i][j] = [layer1 tileGIDAt:ccp(i, j)]; 
            
            // 타일 타입에 따라 이동이 가능한지 검사
            if(mapInfo[i][j] == TILE_NONE || 
               mapInfo[i][j] == TILE_WALL1 || mapInfo[i][j] == TILE_WALL2 || 
               mapInfo[i][j] == TILE_TREASURE || mapInfo[i][j] == TILE_EXPLOSIVE)
                moveTable[i][j] = -1;
            else
                moveTable[i][j] = MoveNone;
            
            // 타일에 설치된 트랩이 있는지 확인
            if(mapInfo[i][j] == TILE_TRAP_OPEN || mapInfo[i][j] == TILE_TRAP_CLOSE ||
               mapInfo[i][j] == TILE_TREASURE || mapInfo[i][j] == TILE_EXPLOSIVE)
            {
                [self addTrap:[self convertTileToMap:ccp(i, j)] type:mapInfo[i][j]];
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
- (void) initWarrior {
    NSString* path = [self loadFilePath:@"coordinates-character1.plist"];
    
    [self loadWarriorData:path];
}

// 파일로부터 캐릭터 이미지를 읽어들임
- (void) loadWarriorData:(NSString *)path {
    NSArray *warriorType = [NSArray arrayWithObjects: @"acher", @"fighter", @"mage", nil];
    
    stageInfo = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSDictionary *tList = [stageInfo objectForKey:@"frames"];
    
    for (NSString* type in warriorType) {
        NSArray *warriorIdle = [NSArray arrayWithObjects: 
                                [NSString stringWithFormat:@"%@%@%@", @"character-", type, @"-idle-1.png"],
                                [NSString stringWithFormat:@"%@%@%@", @"character-", type, @"-idle-2.png"], 
                                nil];
        
        NSArray *warriorAttack = [NSArray arrayWithObjects:     
                                  [NSString stringWithFormat:@"%@%@%@", @"character-", type, @"-attack-1.png"],
                                  [NSString stringWithFormat:@"%@%@%@", @"character-", type, @"-attack-2.png"], 
                                  nil];
        
        NSDictionary *wList = [tList objectForKey:type];
        
        // 이동 이미지를 읽어들임
        NSMutableArray *aniIdleFrames = [self getImageFrame:wList imgList:warriorIdle];
        CCAnimation *animation = [CCAnimation animationWithFrames:aniIdleFrames delay:WARRIOR_MOVE_ACTION];
        [idleAnimate addObject:[[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:NO]];
        [idleSprite addObject:[CCSprite spriteWithSpriteFrame:(CCSpriteFrame*) [aniIdleFrames objectAtIndex:0]]];
        
        // 공격 애니메이션용 이미지를 읽어들여 저장
        [fightAniFrame addObject:[self getImageFrame:wList imgList:warriorAttack]];
    }
}

// 각 캐릭터별로 필요한 이미지 파일을 읽어들임
- (NSMutableArray*) getImageFrame:(NSDictionary*)wList imgList:(NSArray*)imgList {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString* imgName in imgList) {
        NSDictionary *spliteInfo = [wList objectForKey:imgName];
        NSInteger x = [[spliteInfo objectForKey:@"x"] intValue];
        NSInteger y = [[spliteInfo objectForKey:@"y"] intValue];
        NSInteger width = [[spliteInfo objectForKey:@"width"] intValue];
        NSInteger height = [[spliteInfo objectForKey:@"height"] intValue];
        
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture
                                                          rect:CGRectMake(x, y, width, height)];
        [result addObject:frame];
    }

    return result;
}

- (void) createWarrior:(NSInteger)warriorType {
    // 용사 생성
    Warrior *tWarrior = [[Warrior alloc] initWarrior:ccp(startPoint.x, startPoint.y)
                                          warriorNum:warriorNum
                                            strength:100 
                                               power:10 
                                           intellect:10 
                                             defense:10 
                                               speed:2   //[[wInfo objectForKey:@"speed"] intValue] 
                                           direction:MoveDown
                                         attackRange:2]; 
    
    // 나타난 용사 수 증가
    warriorNum++;
    
    CCSprite *tSprite = [idleSprite objectAtIndex:warriorType];
    tSprite.position = ccp((startPoint.x * viewScale) + map.position.x, (startPoint.y * viewScale) + map.position.y); 
    tSprite.scale = 3.5;
    tSprite.flipX = WARRIOR_MOVE_RIGHT;
    [tSprite setVisible:YES];
    [tSprite runAction:[CCRepeatForever actionWithAction:[idleAnimate objectAtIndex:warriorType]]];
    [tSprite release];
        
    [tWarrior setSprite:tSprite];
    
    [self addChild:tSprite z:kWarriorLayer];
    [warriorList addObject:tWarrior];
}

// 일정 간격으로 호출됨
// 용사 이동 및 기타 처리를 하도록 함
- (void) moveWarrior:(id) sender {
    NSMutableArray *deleteList = [[NSMutableArray alloc] init];
    // 잠시 애니메이션 효과 중단
    [self pauseSchedulerAndActions];
    
    for (int i = 0; i < [warriorList count]; i++) {
        // 현재 위치 및 정보를 가져옴
        Warrior *tWarrior = [warriorList objectAtIndex:i];
        CCSprite *tSprite = [tWarrior getSprite];
        NSInteger direction = [tWarrior getMoveDriection];
        CGPoint movePosition = [tWarrior getPosition];
        
        // 공격 대상 탐색
        //[self handlingTrap:tWarrior];
        NSInteger attackEnmy = [self enmyFind:tWarrior];
        if(attackEnmy != -1) NSLog(@"Found Enmy!!!(Warrior Num : %d, Trap Num : %d)", [tWarrior getWarriorNum], attackEnmy);
        
        // 생존 여부 확인 후 소멸 여부 처리
        
        // 이동 및 기타 체크 처리
        if(direction == MoveLeft) {
            movePosition = ccp(movePosition.x - [tWarrior getMoveSpeed], movePosition.y);
        } else if(direction == MoveUp) {
            movePosition = ccp(movePosition.x, movePosition.y + [tWarrior getMoveSpeed]);
        } else if(direction == MoveRight) {
            movePosition = ccp(movePosition.x + [tWarrior getMoveSpeed], movePosition.y);
        } else if(direction == MoveDown) {
            movePosition = ccp(movePosition.x, movePosition.y - [tWarrior getMoveSpeed]);
        }   
        tSprite.position = ccp(map.position.x + (movePosition.x * viewScale), map.position.y + (movePosition.y * viewScale));
        [tWarrior setSprite:tSprite];
        
        [tWarrior plusMoveLength];
        [tWarrior setPosition:movePosition];
        
        // 다음 이동 방향 검사 - 추가적인 테스트 필요
        // 이동 거리 설정시 24의 약수로 지정해야 함 : 안 그럴 경우 타일 중앙에 위치를 하는 경우가 없어 제멋대로 이동함
        // 1, 2, 3, 4, 6, 8, 12
        BOOL endFlag = [self selectDirection:tWarrior];
        
        if(endFlag) {
            [deleteList addObject:tWarrior];
        }
        
        [warriorList replaceObjectAtIndex:i withObject:tWarrior];
    }
    
    // 용사 삭제
    //[self removeWarriorList:deleteList];
    
    // 애니메이션 효과 재개
    [self resumeSchedulerAndActions];
}

// 일정거리 안에 적이 있는지 탐지
// 현재 트랩으로 지정됨 - 적으로 변경 필요
- (NSInteger) enmyFind:(Warrior*)pWarrior {
    CGPoint wPoint = [pWarrior getPosition];
    NSInteger wAttack = [pWarrior getAttackRange];
    
    for(int i = 0; i < [trapList count]; i++) {
        Trap *tTrap = [trapList objectAtIndex:i];
        CGPoint tPoint = [tTrap getPosition];
        CGFloat distance = [self lineLength:tPoint point2:wPoint];
        
        if(distance <= powf(wAttack * TILE_SIZE, 2)) {
            return [tTrap getTrapNum];
        }
    }
    
    return NotFound;
}

// 이동 방향 설정
// 현재 용사가 있는 위치를 파악하여 해당 타일의 이동 방향으로 용사가 이동하도록 수정
// 이동 경로를 별도의 테이블에 저장
- (BOOL) selectDirection:(Warrior *)pWarrior {
    CCSprite *tSprite = [pWarrior getSprite];
    
    if([pWarrior getMoveLength] == TILE_SIZE) {
        // 이동 테이블에서 이동 방향을 확인
        CGPoint point = [pWarrior getPosition];
        int x = ((int) point.x - HALF_TILE_SIZE) / TILE_SIZE;
        int y = TILE_NUM - ((int) point.y - HALF_TILE_SIZE) / TILE_SIZE - 1;
        
        NSInteger direction = moveTable[x][y];
        
        if(direction == MoveRight) {
            [pWarrior setMoveDriection:MoveRight];
            tSprite.flipX = WARRIOR_MOVE_RIGHT;
        } else if(direction == MoveDown) {
            [pWarrior setMoveDriection:MoveDown];
            tSprite.flipX = WARRIOR_MOVE_RIGHT;
        } else if(direction == MoveLeft) {
            [pWarrior setMoveDriection:MoveLeft];
            tSprite.flipX = WARRIOR_MOVE_LEFT;
        } else {
            [pWarrior setMoveDriection:MoveUp];
            tSprite.flipX = WARRIOR_MOVE_LEFT;
        }
        
        // 목적지일 경우
        if(x == EndPoint.x && y == EndPoint.y) {
            [pWarrior setMoveDriection:MoveNone];
            
            return YES;
        }
        
        [pWarrior resetMoveLength];
    }
    
    return NO;
}
//////////////////////////////////////////////////////////////////////////
// 용사 End                                                              //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 트랩 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
- (void) initTrap {
    // 설치 가능한 트랩 종류 확인 및 그에 대한 처리?
    
    // 설치 가능한 트랩 출력 화면 표시
    /* 버튼으로 처리
     CCSprite *tSprite = [CCSprite spriteWithFile:@"texture.png" rect:CGRectMake(0, 0, 48, 48)];
     
     tSprite.position = [self convertTileToCocoa:iPoint];
     tSprite.scale = 0.75;
     tSprite.visible = YES;
     [self addChild:tSprite];
     */
}

- (void) printTrapList:(CGPoint)iPoint {
    int x = (int) iPoint.x;
    int y = (int) iPoint.y;
    
    // 터치한 위치에 트랩이 설치가 가능한지 검사
    // 이미 트랩이 있는지, 설치가 불가능한 곳인지를....
    // 돈이 있는지 등을 검사
    // mapInfo[x][y] = 설치된 타일 타입
    
    // 개봉된 함정이나 보물상자가 있는 경우 설치 불가
    if(mapInfo[x][y] == TILE_TREASURE || mapInfo[x][y] == TILE_TRAP_OPEN) return;
    
    // 설치가 가능한 트랩을 화면에 출력
    [self printTrap:iPoint];
    
    // 이동 경로 재계산 필요 - 트랩이 설치된 경우
    [self createMoveTable];
    
    // 표시된 화면 닫음
}

- (void) createTrap:(CGPoint)iPoint {
    // 트랩을 설치
}

// 설치 가능한 트랩 출력
- (void) printTrap:(CGPoint)iPoint {
    // visible => YES
    // position => [self convertTileToCocoa:iPoint]
    // 
}

// 탐지한 트랩에 따라 처리
- (void) handlingTrap:(Warrior*)pWarrior {
    NSInteger trapType = [self trapFind:pWarrior];
    if(trapType == NotFound) return;
    
    if(trapType == TILE_TRAP_CLOSE) {
        // 닫힌 함정일 경우
        
    } else if(trapType == TILE_TRAP_OPEN) {
        // 열린 함정일 경우
        
    } else if(trapType == TILE_TREASURE) {
        // 보물상자일 경우
        
        [self TreasureBox:pWarrior];
    }
}

// 근처에 트랩이 있는지 탐지
// 트램의 경우 해당 타일에 위치할 경우 발동이 되므로 수정 필요
- (NSInteger) trapFind:(Warrior*)pWarrior {
    CGPoint wPoint = [pWarrior getPosition];
    NSInteger wAttack = [pWarrior getAttackRange];
    
    for(int i = 0; i < [trapList count]; i++) {
        Trap *tTrap = [trapList objectAtIndex:i];
        CGPoint tPoint = [tTrap getPosition];
        CGFloat distance = [self lineLength:tPoint point2:wPoint];
        
        if(distance <= powf(wAttack * TILE_SIZE, 1)) {
            return [tTrap getTrapNum];
        }
    }
    
    return NotFound;
}

// 보물 상자일 경우
- (void) TreasureBox:(Warrior*)pWarrior {
    
}

// 트랩 목록에 트랙 추가
- (void) addTrap:(CGPoint)tPoint type:(NSInteger)tType {
    Trap *tTrap = [[Trap alloc] initTrap:tPoint trapNum:trapNum trapType:tType demage:0];
    
    [trapList addObject:tTrap];
}
//////////////////////////////////////////////////////////////////////////
// 트랩 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 이동 경로 계산 Start                                                   //
//////////////////////////////////////////////////////////////////////////
// 이동 경로를 계산하여 별도의 테이블에 저장
// 맵 초기화 및 중간에 장애물 설치시 이동 경로 재계산 필요
- (void) createMoveTable {
    [self initMoveValue];
    
    // 시작 지점의 가중치를 0로 둠
    tMoveValue[(int) StartPoint.x][(int) StartPoint.y] = 0;
    
    // 최단 거리 계산을 위한 테이블을 작성
    [self calcuationMoveValue:StartPoint.x y:StartPoint.y];
    
    // 작성한 테이블을 기준으로 이동 테이블 작성 - 종료지점에서 역으로 시작 지점을 탐색
    // 경로 테이블 작성 이전에 가능한 경로인지 체크 - 불가일 경우 게임 시작 불가처리
    if(tMoveValue[(int) EndPoint.x][(int) EndPoint.y] == 999) return;
    
    [self calcuatioDirection:EndPoint.x y:EndPoint.y];
}

- (void) initMoveValue {
    for(int i = 0; i < TILE_NUM; i++) {
        for(int j = 0; j < TILE_NUM; j++) {
            tMoveValue[i][j] = 999;
        }
    }
}

- (void) calcuationMoveValue:(int)x y:(int)y {
    if(x == EndPoint.x && y == EndPoint.y) return;
    
    if (y > 0 && moveTable[x][y - 1] != -1) {
        // 상단 탐색    
        if(tMoveValue[x][y - 1] == 999) {
            tMoveValue[x][y - 1] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:x y:(y - 1)];
        }
    }
    
    if(x < (TILE_NUM - 1) && moveTable[x + 1][y] != -1) {
        // 오른쪽 탐색
        if(tMoveValue[x + 1][y] == 999) {
            tMoveValue[x + 1][y] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:(x + 1) y:y];
        }
    } 
    
    if(x > 0 && moveTable[x - 1][y] != -1) {
        // 왼쪽 탐색
        if(tMoveValue[x - 1][y] == 999) {
            tMoveValue[x - 1][y] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:(x - 1) y:y];
        }
    } 
    
    if (y < (TILE_NUM - 1) && moveTable[x][y + 1] != -1) {
        // 아래 탐색    
        if(tMoveValue[x][y + 1] == 999) {
            tMoveValue[x][y + 1] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:x y:(y + 1)];
        }
    }
}

- (void) calcuatioDirection:(int)x y:(int)y {
    if(x == StartPoint.x && y == StartPoint.y) return;
    
    if(tMoveValue[x][y] > tMoveValue[x][y - 1]) {
        moveTable[x][y - 1] = MoveDown;
        [self calcuatioDirection:x y:(y - 1)];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x][y + 1]) {
        moveTable[x][y + 1] = MoveUp;
        [self calcuatioDirection:x y:(y + 1)];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x - 1][y]) {
        moveTable[x - 1][y] = MoveRight;
        [self calcuatioDirection:(x - 1) y:y];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x + 1][y]) {
        moveTable[x + 1][y] = MoveLeft;
        [self calcuatioDirection:(x + 1) y:y];
    }
}
//////////////////////////////////////////////////////////////////////////
// 이동 경로 계산 End                                                     //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 파일 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
- (NSString *) loadFilePath:(NSString *)fileName {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray* sName = [fileName componentsSeparatedByString:@"."];
    if (![fileManager fileExistsAtPath: path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:[sName objectAtIndex:0] ofType:[sName objectAtIndex:1]];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    return path;
}
//////////////////////////////////////////////////////////////////////////
// 파일 처리 End                                                          //
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
        prevMultiLength = [self calcuationMultiTouchLength:touchArray];        
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
        NSArray *touchArray = [[event allTouches] allObjects];
        CGFloat length = [self calcuationMultiTouchLength:touchArray];
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
        /*for(int i = 0; i < [warriorList count]; i++) {
            Warrior *tWarrior = [warriorList objectAtIndex:i];
            CCSprite *tSprite = [tWarrior getSprite];
            tSprite.scale = WARRIOR_SCALE * viewScale;
            tSprite.position = ccp(map.position.x + ([tWarrior getPosition].x * viewScale), 
                                   map.position.y + ([tWarrior getPosition].y * viewScale));
        }*/
        
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
        CGPoint thisArea = [self convertCocos2dToTile:location];

        //[self printTrapList:thisArea];
    }
    
    // 멀티 터치는 처리하지 않음
}

// 화면 터치로 이동시 맵타일 이동
- (void) moveTouchMap:(CGPoint)currentPoint {
    CGPoint movePoint = CGPointMake(currentPoint.x - prevPoint.x, currentPoint.y - prevPoint.y);
    CGPoint mapMove = [self checkMovePosition:CGPointMake(map.position.x + movePoint.x, map.position.y + movePoint.y)];
    
    prevPoint = currentPoint;
    map.position = CGPointMake(mapMove.x, mapMove.y);
}

// 화면 터치로 이동시 용사 이동~
- (void) moveTouchWarrior {
    for (int i = 0; i < [warriorList count]; i++) {
        // 현재 위치 및 정보를 가져옴
        Warrior *tWarrior = [warriorList objectAtIndex:i];
        CCSprite *tSprite = [tWarrior getSprite];
        CGPoint position = [tWarrior getPosition];
        
        tSprite.position = ccp(map.position.x + (position.x * viewScale), 
                               map.position.y + (position.y * viewScale));
    }
}

// 터치로 화면 이동시 맵 밖으로 이동 못하게 차단
- (CGPoint) checkMovePosition:(CGPoint)position {
    if (position.x > 0 && 
        position.y < -(mapSize.height * viewScale - deviceSize.height)) {
        // 좌상단
        position = ccp(0, -(mapSize.height * viewScale - deviceSize.height)); 
    } else if (map.position.y < -(mapSize.height * viewScale - deviceSize.height)) {
        // 상단        
        position = ccp(position.x, -(mapSize.height * viewScale - deviceSize.height));
    } else if (position.x < -(mapSize.width * viewScale - deviceSize.width) && 
               position.y < -(mapSize.height * viewScale - deviceSize.height)) {
        // 우상단
        position = ccp(-(mapSize.width * viewScale - deviceSize.width), 
                       -(mapSize.height * viewScale - deviceSize.height));
    } else if (map.position.x < -(mapSize.width * viewScale - deviceSize.width)) {
        // 오른쪽
        position = ccp(-(mapSize.width * viewScale - deviceSize.width), position.y);
    } else if(map.position.x < -(mapSize.width * viewScale - deviceSize.width) && 
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



//////////////////////////////////////////////////////////////////////////
// 좌표 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 터치된 좌표 값을 타일맵 좌표로 변환
// [self convertCocos2dToTile:cocos2d]
// cocos2d : cocos2d 좌표값
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d {
    // 확대/축소에 따라 비율 조정이 필요
    CGPoint cocoa = [[CCDirector sharedDirector] convertToGL:cocos2d];
    CGFloat x = (cocoa.x - map.position.x) / (TILE_SIZE * viewScale);
    CGFloat y = ((TILE_SIZE * TILE_NUM * viewScale) - deviceSize.height + cocos2d.y + map.position.y) / (TILE_SIZE * viewScale);
    
    return CGPointMake(floorf(x), floorf(y));
}

- (CGPoint) convertTileToMap:(CGPoint)tile {
    CGFloat x = (TILE_SIZE * tile.x) + 16;
    CGFloat y = (TILE_SIZE * (TILE_NUM - tile.y - 1)) + 16;
    
    return CGPointMake(floorf(x), floorf(y));
}

// 타일맵 좌표값을 코코아 좌표로 변환
// [self convertTileToCocoa:tile];
// tile : 타일맵 좌표값
//- (CGPoint) getCocoaPostion:(CGPoint)tile {
- (CGPoint) convertTileToCocoa:(CGPoint)tile {
    CGFloat x = (tile.x + 1) * TILE_SIZE + map.position.x - (TILE_SIZE / 2);
    CGFloat y = (12 - tile.y) * TILE_SIZE + map.position.y + (TILE_SIZE / 2);
    
    return CGPointMake(floorf(x), floorf(y));
}

// 절대 좌표값 반환 - 좌상단(0, 0) 기준
- (CGPoint) getAbsCoordinate:(CGPoint)cocos2d {
    CGFloat x = (cocos2d.x - map.position.x) / viewScale;
    CGFloat y = ((TILE_SIZE * TILE_NUM * viewScale) - deviceSize.height + map.position.y + cocos2d.y) / viewScale;
    
    
    return CGPointMake(x, y);
}
//////////////////////////////////////////////////////////////////////////
// 좌표 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 기타 함수 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 터치한 두 좌표간의 거리를 계산하여 반환
- (CGFloat) calcuationMultiTouchLength:(NSArray *)touchArray {
    CGFloat result = 0;
    CGPoint point1;
    CGPoint point2;
    int i = 0;
    
    for (UITouch *touch in touchArray) {
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        if(i == 0) point1 = convertedLocation;
        else point2 = convertedLocation;
        
        i++;
    }
    
    result = [self lineLength:point2 point2:point1];
    
    return result;
}

// 터치된 두 지점 사이의 좌표값을 구함
- (CGPoint) middlePoint:(NSArray *)touchArray {
    CGPoint point1;
    CGPoint point2;
    int i = 0;
    
    for (UITouch *touch in touchArray) {
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        if(i == 0) point1 = convertedLocation;
        else point2 = convertedLocation;
        
        i++;
    }
    
    CGPoint result = ccp(ABS(point1.x + point2.x) / 2, ABS(point1.y + point2.y) / 2);
    
    return result;
}

// 두 점 사이의 거리 계산
- (CGFloat) lineLength:(CGPoint)point1 point2:(CGPoint)point2 {
    CGFloat result = powf((point2.x - point1.x), 2) + powf((point2.y - point2.y), 2);
    
    return result;
}
//////////////////////////////////////////////////////////////////////////
// 기타 함수 End                                                          //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 파일 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
- (NSString *) loadFilePath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Stage097.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if (![fileManager fileExistsAtPath: path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Stage097" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    return path;
}

- (void) loadStageData:(NSString *)path {
    //NSMutableDictionary *
    stageInfo = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //load from savedStock example int value
    //int StageLevel = [[savedStock objectForKey:@"StageLevel"] intValue];
    
    CGPoint sPoint = CGPointMake([[stageInfo objectForKey:@"StartPointX"] intValue], 
                                 [[stageInfo objectForKey:@"StartPointY"] intValue]);
    CGPoint dPoint = CGPointMake([[stageInfo objectForKey:@"EndPointX"] intValue], 
                                 [[stageInfo objectForKey:@"EndPointY"] intValue]);
    
    startPoint = [self convertTileToMap:sPoint];
    destinationPoint = [self convertTileToMap:dPoint];
    
    // map.tmx의 경우 문자열을 조합하여 불러들임 - 요걸로 하니 에러가 발생 ㅠㅠ 
    //[savedStock objectForKey:@"MapName"];
    NSDictionary *tList = [stageInfo objectForKey:@"WarriorList"];
    wCount = [tList count];
}

- (NSDictionary *) loadWarriorInfo:(NSInteger)index {
    NSDictionary *tList = [stageInfo objectForKey:@"WarriorList"];
    NSDictionary *data = [tList objectForKey:[NSString stringWithFormat:@"%d", index]];
    
    return data;
}
//////////////////////////////////////////////////////////////////////////
// 파일 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end