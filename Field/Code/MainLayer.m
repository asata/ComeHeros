#import "MainLayer.h"


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 메인 화면
@implementation MainLayer

- (id)init {
    if ((self = [super init])) {
        deviceSize = [[CCDirector sharedDirector] winSize];
        
        CCMenuItemToggle *techniqueItem1 = [CCMenuItemToggle itemWithTarget:self
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// 게임 화면
@class Warrior;
@implementation playMap
@synthesize map, texture, sprite;
@synthesize layer;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 게임 초기화 Start                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (id)init:(NSInteger)p_level degree:(NSInteger)p_degree {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void) onEnterTransitionDidFinish {    
    [self initMap];
    
    // 필요한 항목 초기화
    warriorList = [[NSMutableArray alloc] init];
    trapList = [[NSMutableArray alloc] init];
    texture = [[CCTextureCache sharedTextureCache] addImage:@"npc.png"];
    
    warriorNum = 0;
    trapNum = 0;
    
    [self createWarrior];
    
    ///////////////////////////////////////////////////////////////////////////////////
    Trap *tTrap = [[Trap alloc] initTrap:[self convertMapToTile:ccp(3, 2)]
                                 trapNum:trapNum 
                                trapType:TILE_06 
                                  demage:0];
    trapNum++;
    //Trap *tTrap1 = [[Trap alloc] initTrap:[self getCocoaPostion:ccp(5, 11)]
    //                             trapNum:trapNum 
    ///                            trapType:TILE_06 
    //                               demage:0];
    [trapList addObject:tTrap];
    //[trapList addObject:tTrap1];
    
    // 일정한 간격으로 호출~
    [self schedule:@selector(moveWarrior:) interval:REFRESH_DISPLAY];
    //[self schedule:@selector(createWarriorAtTime:) interval:5];
    //[self schedule:@selector(removeWarrior:) interval:3];
    //[warriorList addObject:t_warrior];
    //[self initSprite];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 게임 초기화 End                                                                                         //
///////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 맵 처리 Start                                                                                          //
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 타일맵 등록
- (void) initMap {
    // 타일 맵 등록
    map = [CCTMXTiledMap tiledMapWithTMXFile:@"sample-field.tmx"];
    map.scale = MAP_SCALE;
    // 왼쪽 상단에 맵 왼쪽 상단이 위치하도록 설정(하지 않을 경우 왼쪽 하단에 맵 왼쪽 하단이 위치) 
    map.position = ccp(0, deviceSize.height - (TILE_NUM * TILE_SIZE));  
    mapSize = [map contentSize];
    [self addChild:map z:kBackgroundLayer];
    
    layer = [map layerNamed:@"Tile Layer 2"];
    
    // 타일 맵을 읽어 들임
    for(int i = 0; i < TILE_NUM; i++) {
        for(int j = 0; j < TILE_NUM; j++) {
            if([layer tileGIDAt:ccp(i, j)] == TILE_ROAD) {
                // 길일 경우
                mapInfo[i][j] = [layer tileGIDAt:ccp(i, j)];    // 타일에 위치한 타일 정보 기록
                moveTable[i][j] = MoveNone;                     // 이동 경로
            } else {
                // 돌일 경우
                mapInfo[i][j] = -1;
                moveTable[i][j] = -1;
            }
        }
    }
    
    startPoint = [self convertMapToTile:StartPoint];
    destinationPoint = [self convertMapToTile:EndPoint];
    
    // 이동 경로 탐색
    [self createMoveTable];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 맵 처리 End                                                                                            //
///////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Touch 처리 Start                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 사용자가 터치를 할 경우 
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 터치만 처리
    if([[event allTouches] count] == 1) {
        // 멀티 터치가 아닌 경우 
        touchType = TOUCH;
        
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        prevPoint = [[CCDirector sharedDirector] convertToGL:location];
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
        NSLog(@"Multi Touch");
    }
}

// 사용자가 터치를 끝낼 경우
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // YES일 경우 : 터치
    // NO일 경우 : 터치하여 이동
    // 멀티 터치는 처리하지 않음
    if(touchType && [[event allTouches] count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        
        // 클릭한 위치 확인
        CGPoint thisArea = [self convertCocos2dToTile:location];
        NSLog(@"%f %f", thisArea.x, thisArea.y);
        //[layer setTileGID:TILE_03 at:thisArea];
                
        // 터치시 좌우 변경
        /*for (int i = 0; i < [warriorList count]; i++) {
            // 현재 위치 및 정보를 가져옴
            Warrior *tWarrior = [warriorList objectAtIndex:i];
            CCSprite *tSprite = [tWarrior getSprite];
            
            if([tWarrior getMoveDriection] == MoveLeft) {
                [tWarrior setMoveDriection:MoveRight];
                tSprite.flipX = WARRIOR_MOVE_RIGHT;
            } else if([tWarrior getMoveDriection] == MoveRight) {
                [tWarrior setMoveDriection:MoveLeft];
                tSprite.flipX = WARRIOR_MOVE_LEFT;
            }
            
            [warriorList replaceObjectAtIndex:i withObject:tWarrior];
        }*/
    }
}

// 화면 터치로 이동시 맵타일 이동
- (void) moveTouchMap:(CGPoint)currentPoint {
    CGPoint movePoint = CGPointMake(currentPoint.x - prevPoint.x, currentPoint.y - prevPoint.y);
    CGPoint mapMove = CGPointMake(map.position.x + movePoint.x, map.position.y + movePoint.y);
    
    // 이동 가능한지 검사~~~
    if (mapMove.x > 0 && mapMove.y > 0) {
        mapMove = ccp(0, 0);
    } else if (mapMove.x > 0) {
        mapMove = ccp(0, mapMove.y);
    } else if (mapMove.y > 0) {
        mapMove = ccp(mapMove.x, 0);
    } else if (mapMove.x < -(mapSize.width - deviceSize.width)) {
        mapMove = ccp(-(mapSize.width - deviceSize.width), mapMove.y);
    } else if (mapMove.y < -(mapSize.height - deviceSize.height)) {
        mapMove = ccp(mapMove.x, -(mapSize.height - deviceSize.height));
    } else if (mapMove.x < -(mapSize.width - deviceSize.width) && mapMove.y < -(mapSize.height - deviceSize.height)) {
        mapMove = ccp(-(mapSize.width - deviceSize.width), -(mapSize.height - deviceSize.height));
    }
    
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
        
        tSprite.position = ccp(map.position.x + position.x, map.position.y + position.y);
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Touch 처리 End                                                                                         //
///////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 용사 Start                                                                                             //
///////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) createWarrior {
    Warrior *tWarrior = [[Warrior alloc] initWarrior:ccp(startPoint.x, startPoint.y)
                                          warriorNum:warriorNum
                                            strength:100 
                                               power:10 
                                           intellect:10 
                                             defense:10 
                                               speed:1 
                                           direction:MoveDown
                                        attackRange:2]; 
    warriorNum++;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSInteger tNum = warriorNum % 3;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSMutableArray *aniFrames = [NSMutableArray array];
    for(NSInteger i = 0; i < 2; i++) {
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture
                                                          rect:CGRectMake(WARRIOR_SIZE * i, WARRIOR_SIZE * tNum, WARRIOR_SIZE, WARRIOR_SIZE)];
        [aniFrames addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithFrames:aniFrames delay:WARRIOR_MOVE_ACTION];
    CCAnimate *animate = [[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:NO];
    CCSprite *tSprite = [CCSprite spriteWithSpriteFrame:(CCSpriteFrame*) [aniFrames objectAtIndex:0]];
    tSprite.position = ccp(startPoint.x + map.position.x, startPoint.y + map.position.y);
    tSprite.scale = WARRIOR_SCALE;
    tSprite.flipX = WARRIOR_MOVE_RIGHT;
    [tSprite setVisible:YES];
    [tSprite runAction:[CCRepeatForever actionWithAction:animate]];
    [tSprite release];
    
    [tWarrior setSprite:tSprite];
    
    [self addChild:tSprite z:kWarriorLayer];
    [warriorList addObject:tWarrior];
}

- (void) createWarriorAtTime:(id) sender {
    [self createWarrior];
}

// 일정 간격으로 호출됨
// 용사 이동 및 기타 처리를 하도록 함
- (void) moveWarrior:(id) sender {
    for (int i = 0; i < [warriorList count]; i++) {
        // 현재 위치 및 정보를 가져옴
        Warrior *tWarrior = [warriorList objectAtIndex:i];
        CCSprite *tSprite = [tWarrior getSprite];
        NSInteger direction = [tWarrior getMoveDriection];
        CGPoint movePosition = [tWarrior getPosition];
        
        // 공격 대상 탐색
        NSInteger attackEnmy = [self AttackEnmyFind:tWarrior];
        //if(attackEnmy != -1) NSLog(@"Found Enmy!!!(Warrior Num : %d, Trap Num : %d)", [tWarrior getWarriorNum], attackEnmy);
        
        // 이동 및 기타 체크 처리
        if(direction == MoveLeft) {
            movePosition = ccp(movePosition.x - [tWarrior getMoveSpeed], movePosition.y);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];
        } else if(direction == MoveUp) {
            movePosition = ccp(movePosition.x, movePosition.y + [tWarrior getMoveSpeed]);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];       
        } else if(direction == MoveRight) {
            movePosition = ccp(movePosition.x + [tWarrior getMoveSpeed], movePosition.y);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];
        } else if(direction == MoveDown) {
            movePosition = ccp(movePosition.x, movePosition.y - [tWarrior getMoveSpeed]);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];
        }   
        
        [tWarrior plusMoveLength];
        [tWarrior setPosition:movePosition];
        
        // 다음 이동 방향 검사 - 추가적인 테스트 필요
        // 이동 거리 설정시 24의 약수로 지정해야 함 : 안 그럴 경우 타일 중앙에 위치를 하는 경우가 없어 제멋대로 이동함
        [self selectDirection:tWarrior];
        
        [warriorList replaceObjectAtIndex:i withObject:tWarrior];
    }
}

// 임시로 트랩으로 처리
// 트랩은 해당 타일에 위치시 발동이 되도록 설정???
- (NSInteger) AttackEnmyFind:(Warrior*)pWarrior {
    CGPoint wPoint = [pWarrior getPosition];
    NSInteger wAttack = [pWarrior getAttackRange];
    
    for(int i = 0; i < [trapList count]; i++) {
        Trap *tTrap = [trapList objectAtIndex:i];
        CGPoint tPoint = [tTrap getPosition];
        CGFloat distance = powf((wPoint.x - tPoint.x), 2) + powf((wPoint.y - tPoint.y), 2);
        
        if(distance <= powf(wAttack * TILE_SIZE, 2)) {
            return [tTrap getTrapNum];
        }
    }
    
    return NotFound;
}

// 지정된 용사 제거
- (void) removeWarrior:(NSInteger)index {
    [warriorList removeObjectAtIndex:index];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 용사 End                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 이동 경로 계산 Start                                                                                     //
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 이동 경로를 계산하여 별도의 테이블에 저장
// 맵 초기화 및 중간에 장애물 설치시 이동 경로 재계산
// 재계산시 최단 경로가 아닐 경우 연산을 하지 않도록 구성
// 경로 탐색 알고리즘은 생각중

- (void) createMoveTable {
    [self initMoveValue];
    
    // 시작 지점의 가중치를 0로 둠
    tMoveValue[(int) StartPoint.x][(int) StartPoint.y] = 0;
    
    // 최단 거리 계산을 위한 테이블을 작성
    [self calcuationMoveValue:StartPoint.x y:StartPoint.y];
    
    // 작성한 테이블을 기준으로 이동 테이블 작성
    // 재귀 호출로 작성
    // 종료지점에서 역으로 시작 지점을 탐색
    // tMoveValue[(int) EndPoint.x][(int) EndPoint.y] == 999 일 경우 없긔~
    // 경로 테이블 작성 이전에 가능한 경로인지 체크
    if(tMoveValue[(int) EndPoint.x][(int) EndPoint.y] == 999) return;
    
    [self choseDirection:EndPoint.x y:EndPoint.y];
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
    
    if (y > 0 && mapInfo[x][y - 1] != -1) {
        // 상단 탐색    
        if(tMoveValue[x][y - 1] == 999) {
            tMoveValue[x][y - 1] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:x y:(y - 1)];
        }
    }
    
    if(x < (TILE_NUM - 1) && mapInfo[x + 1][y] != -1) {
        // 오른쪽 탐색
        if(tMoveValue[x + 1][y] == 999) {
            tMoveValue[x + 1][y] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:(x + 1) y:y];
        }
    } 
    
    if(x > 0 && mapInfo[x - 1][y] != -1) {
        // 왼쪽 탐색
        if(tMoveValue[x - 1][y] == 999) {
            tMoveValue[x - 1][y] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:(x - 1) y:y];
        }
    } 
    
    if (y < (TILE_NUM - 1) && mapInfo[x][y + 1] != -1) {
        // 아래 탐색    
        if(tMoveValue[x][y + 1] == 999) {
            tMoveValue[x][y + 1] = tMoveValue[x][y] + 1;
            [self calcuationMoveValue:x y:(y + 1)];
        }
    }
}

- (void) choseDirection:(int)x y:(int)y {
    if(x == StartPoint.x && y == StartPoint.y) return;
    
    if(tMoveValue[x][y] > tMoveValue[x][y - 1]) {
        moveTable[x][y - 1] = MoveDown;
        [self choseDirection:x y:(y - 1)];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x][y + 1]) {
        moveTable[x][y + 1] = MoveUp;
        [self choseDirection:x y:(y + 1)];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x - 1][y]) {
        moveTable[x - 1][y] = MoveRight;
        [self choseDirection:(x - 1) y:y];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x + 1][y]) {
        moveTable[x + 1][y] = MoveLeft;
        [self choseDirection:(x + 1) y:y];
    }
}

// 이동 방향 설정
// 현재 용사가 있는 위치를 파악하여 해당 타일의 이동 방향으로 용사가 이동하도록 수정
// 이동 경로를 별도의 테이블에 저장
- (void) selectDirection:(Warrior *)pWarrior {
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
            
            NSLog(@"Move Right");
        } else if(direction == MoveDown) {
            [pWarrior setMoveDriection:MoveDown];
            tSprite.flipX = WARRIOR_MOVE_RIGHT;
            
            NSLog(@"Move Down");
        } else if(direction == MoveLeft) {
            [pWarrior setMoveDriection:MoveLeft];
            tSprite.flipX = WARRIOR_MOVE_LEFT;
            
            NSLog(@"Move Left");
        } else {
            [pWarrior setMoveDriection:MoveUp];
            tSprite.flipX = WARRIOR_MOVE_LEFT;
            
            NSLog(@"Move Up");
        }
        
        // 목적지일 경우
        if(x == EndPoint.x && y == EndPoint.y) {
            [pWarrior setMoveDriection:MoveNone];
            [tSprite stopAllActions];
        }
        
        [pWarrior resetMoveLength];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 이동 경로 계산 End                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 좌표 처리 Start                                                                                         //
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 터치된 좌표 값을 타일맵 좌표로 변환
// [self convertCocos2dToTile:cocos2d]
// location : cocos2d 좌표값
//- (CGPoint) getTilePostion:(CGPoint)cocos2d {
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d {
    CGPoint cocoa = [[CCDirector sharedDirector] convertToGL:cocos2d];
    CGFloat x = (cocoa.x - map.position.x) / TILE_SIZE;
    CGFloat y = ((TILE_SIZE * TILE_NUM) - deviceSize.height + cocos2d.y + map.position.y) / TILE_SIZE;
    
    return CGPointMake(floorf(x), floorf(y));
}

- (CGPoint) convertMapToTile:(CGPoint)tile {
    CGFloat x = (TILE_SIZE * tile.x) + 24;
    CGFloat y = (TILE_SIZE * (TILE_NUM - tile.y - 1)) + 24;
    
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
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 좌표 처리 End                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////

@end