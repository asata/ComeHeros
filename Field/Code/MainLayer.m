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
                                                                      items:[CCMenuItemFont itemFromString:@"때리기"], nil];
        CCMenu *techniqueTrainingMenu = [CCMenu menuWithItems:techniqueItem1, nil];
        techniqueTrainingMenu.position = ccp(360, 160);
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

- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void) onEnterTransitionDidFinish {    
    [self initMap];
    
    // 필요한 항목 초기화
    warriorList = [[NSMutableArray alloc] init];
    texture = [[CCTextureCache sharedTextureCache] addImage:@"npc.png"];
    
    [self createWarrior];
    
    // 일정한 간격으로 호출~
    [self schedule:@selector(moveWarrior:) interval:0.1];
    [self schedule:@selector(createWarriorAtTime:) interval:5];
    //[self schedule:@selector(removeWarrior:) interval:3];
    //[warriorList addObject:t_warrior];
    //[self initSprite];
}

// 타일맵 등록
- (void) initMap {
    // 타일 맵 등록
    map = [CCTMXTiledMap tiledMapWithTMXFile:@"sample-field.tmx"];
    map.scale = MAP_SCALE;
    mapSize = [map contentSize];
    [self addChild:map z:kBackgroundLayer];
    
    layer = [map layerNamed:@"Tile Layer 2"];
    
    for(int i = 0; i < TILE_NUM; i++) {
        for(int j = 0; j < TILE_NUM; j++) {
            if([layer tileGIDAt:ccp(i, j)] == 1) {
                mapInfo[i][j] = [layer tileGIDAt:ccp(i, j)];
                moveTable[i][j] = -1;
            }
            else {
                mapInfo[i][j] = -1;
                moveTable[i][j] = None;
            }
        }
    }
    
    startPoint = [self getCocoaPostion:ccp(0, 12)];
    // 이동 경로 탐색
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

// 사용자가 터치를 할 경우 
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchType = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    prevPoint = [[CCDirector sharedDirector] convertToGL:location];
}

// 사용자가 터치로 이동할 경우
- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {    
    touchType = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
    // 맵과 기타 잡것들 옮기기 전에 일시 정지 시킴
    [self pauseSchedulerAndActions];
    
    [self moveTouchMap:convertedLocation];
    [self moveTouchWarrior];
    
    // 일시 정지 해제
    [self resumeSchedulerAndActions];
}

// 사용자가 터치를 끝낼 경우
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // YES일 경우 : 터치
    // NO일 경우 : 터치하여 이동
    if(touchType) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        
        // 클릭한 위치 확인
        CGPoint thisArea = [self getTilePostion:location];
        [layer setTileGID:1 at:thisArea];
        
        // 어떠한 물건을 설치할지 검사
        
        // 설치시 이동 경로 재 탐색
        
        
        // 터치시 좌우 변경
        for (int i = 0; i < [warriorList count]; i++) {
            // 현재 위치 및 정보를 가져옴
            Warrior *tWarrior = [warriorList objectAtIndex:i];
            //CCSprite *leftSprite = [tWarrior getLeftSprite];
            CCSprite *tSprite = [tWarrior getSprite];
            
            if([tWarrior getMoveDriection] == MoveLeft) {
                [tWarrior setMoveDriection:MoveRight];
                tSprite.flipX = NO;
            } else if([tWarrior getMoveDriection] == MoveRight) {
                [tWarrior setMoveDriection:MoveLeft];
                tSprite.flipX = YES;
            }
            
            [warriorList replaceObjectAtIndex:i withObject:tWarrior];
        }
    }
}

- (void) createWarrior {
    Warrior *tWarrior = [[Warrior alloc] initWarrior:startPoint 
                                            strength:100
                                               speed:1 
                                           direction:MoveRight]; 
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSMutableArray *aniLeftFrames = [NSMutableArray array];
    for(NSInteger i = 0; i < 2; i++) {
        CCSpriteFrame *leftFrame = [CCSpriteFrame frameWithTexture:texture
                                                              rect:CGRectMake(WARRIOR_SIZE * i, WARRIOR_SIZE, WARRIOR_SIZE, WARRIOR_SIZE)];
        [aniLeftFrames addObject:leftFrame];
    }
    CCAnimation *leftAnimation = [CCAnimation animationWithFrames:aniLeftFrames delay:NPC_MOVE_ACTION];
    CCAnimate *leftAnimate = [[CCAnimate alloc] initWithAnimation:leftAnimation restoreOriginalFrame:NO];
    CCSprite *tSprite = [CCSprite spriteWithSpriteFrame:(CCSpriteFrame*) [aniLeftFrames objectAtIndex:0]];
    tSprite.position = startPoint;
    tSprite.scale = NPC_SCALE;
    tSprite.flipX = YES;
    [tSprite setVisible:YES];
    [tSprite runAction:[CCRepeatForever actionWithAction:leftAnimate]];
    [tSprite release];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
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
        
        // 이동 방향을 결정 하여 이동~
        
        //direction += 1;
        //if(direction > MoveDown) direction = MoveLeft;
        //[tWarrior setMoveDriection:direction];  
        
        //direction = [self selectDirection:tSprite pDirection:direction];
        
        // 이동 및 기타 체크 처리
        if(direction == MoveLeft) {
            movePosition = ccp(movePosition.x - [tWarrior getMoveSpeed], movePosition.y);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];
            //NSLog(@"MoveLeft");
        } else if(direction == MoveUp) {
            movePosition = ccp(movePosition.x, movePosition.y + [tWarrior getMoveSpeed]);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];
            //NSLog(@"MoveUp");
        } else if(direction == MoveRight) {
            movePosition = ccp(movePosition.x + [tWarrior getMoveSpeed], movePosition.y);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];
            //NSLog(@"MoveRight");
        } else if(direction == MoveDown) {
            movePosition = ccp(movePosition.x, movePosition.y - [tWarrior getMoveSpeed]);
            tSprite.position = ccp(map.position.x + movePosition.x, map.position.y + movePosition.y);
            [tWarrior setSprite:tSprite];
            //NSLog(@"MoveDown");
        }   
        
        [tWarrior setPosition:movePosition];
        
        // 화면에서 사라질 경우 보이지 않게함
        //if(tSprite.position.x > 480) {
        //    NSLog(@"Hide");
        //    [tSprite setVisible:NO];
        //} else if(tSprite.position.x > 320) {
        //}
        //[tSprite setVisible:![tSprite visible]];
        
        // 맵에서 나갈 경우 제거
        
        [warriorList replaceObjectAtIndex:i withObject:tWarrior];
    }
}

// 이동 경로를 계산하여 별도의 테이블에 저장
// 맵 초기화 및 중간에 장애물 설치시 이동 경로 재계산
// 재계산시 최단 경로가 아닐 경우 연산을 하지 않도록 구성
// 경로 탐색 알고리즘은 생각중

// 이동 방향 설정
// 현재 용사가 있는 위치를 파악하여 해당 타일의 이동 방향으로 용사가 이동하도록 수정
// 이동 경로를 별도의 테이블에 저장
- (NSInteger) selectDirection:(CCSprite *)pSprite pDirection:(NSInteger)pDirection {
    CGFloat x1 = pSprite.position.x - HALF_TILE_SIZE;
    CGFloat x2 = pSprite.position.x + HALF_TILE_SIZE;
    CGFloat y1 = pSprite.position.y - HALF_TILE_SIZE;
    CGFloat y2 = pSprite.position.y + HALF_TILE_SIZE;
    
    if(pDirection == MoveRight) {
        CGPoint tile = [self getTilePostion:ccp(x2, y2)];
        if(tile.x == TILE_NUM) return MoveUp;
        unsigned int num = [layer tileGIDAt:tile];
        if(num == 0) return MoveRight;
        
        // 방향 전환
        return MoveUp;
    }
    
    return pDirection;
}

// 지정된 용사 제거
- (void) removeWarrior:(NSInteger)index {
    [warriorList removeObjectAtIndex:index];
}

// 터치된 좌표 값을 타일맵 좌표로 변환
// [self getTilePostion:cocos2d]
// location : cocos2d 좌표값
- (CGPoint) getTilePostion:(CGPoint)cocos2d {
    CGPoint cocoa = [[CCDirector sharedDirector] convertToGL:cocos2d];
    CGFloat x = (cocoa.x - map.position.x) / TILE_SIZE;
    CGFloat y = ((TILE_SIZE * TILE_NUM) - deviceSize.height + cocos2d.y + map.position.y) / TILE_SIZE;
    
    return CGPointMake(floorf(x), floorf(y));
}

// 타일맵 좌표값을 코코아 좌표로 변환
// [self getCocoaPostion:tile];
// tile : 타일맵 좌표값
- (CGPoint) getCocoaPostion:(CGPoint)tile {
    CGFloat x = (tile.x + 1) * TILE_SIZE + map.position.x - (TILE_SIZE / 2);
    CGFloat y = (12 - tile.y) * TILE_SIZE + map.position.y + (TILE_SIZE / 2);
    
    return CGPointMake(floorf(x), floorf(y));
}

@end