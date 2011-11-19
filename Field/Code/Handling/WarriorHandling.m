#import "WarriorHandling.h"

@implementation WarriorHandling

- (id) init {
    self = [super init];
    //if ((self = [super init])) {
    //}
    
    return self;
}

//////////////////////////////////////////////////////////////////////////
// 용사 Start                                                            //
//////////////////////////////////////////////////////////////////////////
- (CCSpriteFrame*) loadWarriorSprite:(NSString*)spriteName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_CHARATER_PLIST textureFile:FILE_CHARATER_IMG];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                            spriteFrameByName:[NSString stringWithFormat:@"character-%@-idle-1.png", spriteName]];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:FILE_CHARATER_PLIST];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:FILE_CHARATER_IMG];
    
    return frame;
}

- (CCAnimation*) loadWarriorWalk:(NSString*)spriteName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_CHARATER_PLIST textureFile:FILE_CHARATER_IMG];
    NSMutableArray* walkImgList = [NSMutableArray array];
    
    for(NSInteger i = 1; i < 3; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"character-%@-idle-%d.png", spriteName, i]];
        
        [walkImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkImgList delay:WARRIOR_MOVE_ACTION];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:FILE_CHARATER_PLIST];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:FILE_CHARATER_IMG];
    
    return animation;
}

- (CCAnimation*) loadWarriorAttack:(NSString*)spriteName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_CHARATER_PLIST textureFile:FILE_CHARATER_IMG];
    NSMutableArray* attackImgList = [NSMutableArray array];
    
    for(NSInteger i = 1; i < 3; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"character-%@-attack-%d.png", spriteName, i]];
        
        [attackImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:attackImgList delay:WARRIOR_MOVE_ACTION];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:FILE_CHARATER_PLIST];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:FILE_CHARATER_IMG];
    
    return animation;
}
- (CCSpriteFrame*) loadWarriorTombstone {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_TOMBSTONE_PLIST textureFile:FILE_TOMBSTONE_IMG];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                            spriteFrameByName:[NSString stringWithFormat:@"dead0003.png"]];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:FILE_TOMBSTONE_PLIST];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:FILE_TOMBSTONE_IMG];
    
    return frame;
}
- (CCAnimation*) loadWarriorTombstoneAnimation {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_TOMBSTONE_PLIST textureFile:FILE_TOMBSTONE_IMG];
    NSMutableArray* tombstoneImgList = [NSMutableArray array];
    for(NSInteger i = 0; i < 4; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"dead%04d.png", i]];
        
        [tombstoneImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:tombstoneImgList delay:INSTALL_TOMBSTONE_TIME];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:FILE_TOMBSTONE_PLIST];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:FILE_TOMBSTONE_IMG];
    
    return animation;
}

- (CCSprite*) createWarrior:(NSDictionary*)wInfo {
    //CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    //CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    CGPoint sPoint = [[commonValue sharedSingleton] getStartPoint];
    Coordinate *coordinate = [[Coordinate alloc] init];
    File *file = [[File alloc] init];
    
    
    NSInteger warriorType = [[wInfo objectForKey:@"Type"] intValue];
    NSArray *warriorName = [NSArray arrayWithObjects: @"acher", @"fighter", @"mage", nil];
    
    NSString *path = [file loadFilePath:@"ChareaterInfo.plist"];
    NSDictionary *chareterList = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSDictionary *warriorList = [chareterList objectForKey:@"Warrior"];
    NSDictionary *data = [warriorList objectForKey:[warriorName objectAtIndex:warriorType]];
    
    CGPoint startABSPoint = [coordinate convertTileToMap:sPoint];
    // 용사 생성
    Warrior *tWarrior = [[Warrior alloc] initWarrior:startABSPoint
                                          warriorNum:[[commonValue sharedSingleton] getWarriorNum]
                                            strength:[[data objectForKey:@"strength"] intValue]
                                               power:[[data objectForKey:@"power"] intValue]
                                           intellect:[[data objectForKey:@"intellect"] intValue]
                                             defense:[[data objectForKey:@"defense"] intValue] 
                                               speed:[[data objectForKey:@"speed"] intValue] 
                                           direction:MoveUp
                                         attackRange:[[data objectForKey:@"range"] intValue]]; 
    
    // 나타난 용사 수 증가
    [[commonValue sharedSingleton] plusWarriorNum];
    CCSprite *tSprite = [CCSprite spriteWithSpriteFrame:[self loadWarriorSprite:[warriorName objectAtIndex:warriorType]]];
    tSprite.position = startABSPoint; 
    [tSprite setFlipX:WARRIOR_MOVE_RIGHT];
    [tSprite setScale:CHAR_SCALE];
    [tSprite setVisible:YES];
    
    CCAnimate *walkAnimate = [[CCAnimate alloc] initWithAnimation:[self loadWarriorWalk:[warriorName objectAtIndex:warriorType]]
                                             restoreOriginalFrame:NO];
    CCAnimate *attackAnimate = [[CCAnimate alloc] initWithAnimation:[self loadWarriorAttack:[warriorName objectAtIndex:warriorType]]
                                               restoreOriginalFrame:NO];
    CCAnimate *tombstoneAnimate = [[CCAnimate alloc] initWithAnimation:[self loadWarriorTombstoneAnimation]
                                                  restoreOriginalFrame:NO];
    [tSprite runAction:[CCRepeatForever actionWithAction:walkAnimate]];
    
    [tWarrior setAttackAnimate:attackAnimate];
    [tWarrior setDeathAnimate:tombstoneAnimate];
    [tWarrior setMoveLength:TILE_SIZE];
    [tWarrior setSprite:tSprite];
    NSLog(@"Create Warrior Type : %d", warriorType);
    
    [[commonValue sharedSingleton] addWarrior:tWarrior];
    
    return tSprite;
}

// 일정 간격으로 호출됨
// 용사 이동 및 기타 처리를 하도록 함
- (BOOL) moveWarrior {
    NSMutableArray *deleteList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[commonValue sharedSingleton] warriorListCount]; i++) {
        // 현재 위치 및 정보를 가져옴
        Warrior *tWarrior = [[commonValue sharedSingleton] getWarriorListAtIndex:i];
        
        if ([tWarrior getDeath] == DEATH) continue;
        CCSprite *tSprite = [tWarrior getSprite];
        CGPoint movePosition = [tWarrior getPosition];
        
        if([tWarrior getStrength] <= 0 && [tWarrior getDeath] == SURVIVAL) {
            [deleteList addObject:tWarrior];
            continue;
        }
        
        // 다음 이동 방향 검사 - 추가적인 테스트 필요
        // 이동 거리 설정시 32의 약수로 지정해야 함 : 안 그럴 경우 타일 중앙에 위치를 하는 경우가 없어 제멋대로 이동함
        // 1, 2, 4, 8, 16, 32
        BOOL endFlag = NO;
        if ([tWarrior getMoveLength] == TILE_SIZE) {
            if(MOVE_INTELLECT <= [tWarrior getIntellect]) {
                // 최단 경로
                endFlag = [self selectShortDirection:tWarrior];
            } else {
                 // 무작위 경로
                endFlag = [self selectDirection:tWarrior];
            }
            
            int x = ((int) movePosition.x - HALF_TILE_SIZE) / TILE_SIZE;
            int y = TILE_NUM - ((int) movePosition.y - HALF_TILE_SIZE) / TILE_SIZE - 1;
            [tWarrior pushMoveList:ccp(x, y)];
        }
        
        if(endFlag) {
            // 목적지에 도달한 경우
            // 목적지 도착시 처리가 필요
            // 게임 종료 or Life 감소
            [tWarrior setMoveSpeed:0];
            [tWarrior setDefense:9999];
            [tWarrior setStrength:9999];
            
            return NO;
        } else {
            // 일정 지능 이상일 경우 최단 경로
            //         이하일 경우 랜덤한 경로
            NSInteger direction = [tWarrior getMoveDriection];
            
            // 공격 대상 탐색
            // 트랩 탐지 및 처리
            TrapHandling *trapHandling = [[TrapHandling alloc] init];
            BOOL survivalFlag = [trapHandling handlingTrap:tWarrior];
            if(!survivalFlag) {
                [deleteList addObject:tWarrior];
                continue;
            }
            
            // 적 유닛 확인 및 처리
            NSInteger attackEnmy = [self enmyFind:tWarrior];
            if(attackEnmy != -1) {
                //[tSprite stopAllActions];
                [tSprite runAction:[CCSequence actions:[tWarrior getAttackAnimate], 
                                    [CCCallFunc actionWithTarget:self selector:@selector(attackCompleteHandler)], 
                                    nil]];
            } else {
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
                tSprite.position = movePosition;
                [tWarrior setSprite:tSprite];
                
                [tWarrior plusMoveLength];
                [tWarrior setPosition:movePosition];
            }
            
            // 생존 여부 확인 후 소멸 여부 처리
            if([tWarrior getStrength] <= 0 && [tWarrior getDeath] == SURVIVAL) {
                [deleteList addObject:tWarrior];
                continue;
            }
        }
    }
    
    // 용사 삭제
    [self removeWarriorList:deleteList];
    
    return YES;
}

- (void) attackCompleteHandler {
    // 에러 발생시 걷기 애니메이션을 상단에서 중단하였다가 이곳에서 재개하는 방향으로 구현
    //NSLog(@"Warrior Start Walk");
    //[self resumeSchedulerAndActions];
}

// 지정된 용사 제거
- (void) removeWarrior:(NSInteger)index {
    [[commonValue sharedSingleton] removeWarriorAtIndex:index];
}
- (void) removeWarriorList:(NSMutableArray *)deleteList {
    for (Warrior *tWarrior in deleteList) {
        CCSprite *tSprite = [tWarrior getSprite]; 
        
        if ([tSprite scale] != CHAR_SCALE) {
            [[commonValue sharedSingleton] removeWarrior:tWarrior];
            [tSprite setVisible:NO];
            [tSprite release];
        } else {
            [tSprite stopAllActions];
            
            [tSprite runAction:[CCSequence actions:[tWarrior getDeathAnimate], 
                                [CCCallFunc actionWithTarget:self selector:@selector(tombstoneCompleteHandler:)], 
                                nil]];
            [tWarrior setDeath:DEATH];     
        }
        
        [[commonValue sharedSingleton] plusStagePoint:POINT_WARRIOR_KILL];
        [[commonValue sharedSingleton] plusStageMoney:MONEY_WARRIOR_KILL];
    }
}
- (void) tombstoneCompleteHandler:(id)sender {
    [[commonValue sharedSingleton] plusKillWarriorNum];
}
// 일정거리 안에 적이 있는지 탐지
// 현재 트랩으로 지정됨 - 적으로 변경 필요
- (NSInteger) enmyFind:(Warrior*)pWarrior {
    CGPoint wPoint = [pWarrior getPosition];
    NSInteger wAttack = [pWarrior getAttackRange];
    Function *function = [[Function alloc] init];
    
    for(int i = 0; i < [[commonValue sharedSingleton] monsterListCount]; i++) {
        Monster *tMonster = [[commonValue sharedSingleton] getMonsterListAtIndex:i];
        if ([tMonster getDeath] == DEATH) continue;
        CGPoint mPoint = [tMonster getPosition];
        CGFloat distance = [function lineLength:mPoint point2:wPoint];
        
        if(distance <= powf(wAttack * TILE_SIZE, 2)) {
            if (![function positionSprite:[pWarrior getMoveDriection] point1:mPoint point2:wPoint]) continue;
            [[pWarrior getSprite] setFlipX:[function attackDirection:mPoint point2:wPoint]];
            
            NSInteger demage = [pWarrior getPower] - [tMonster getDefense];
            if(demage > 0) {
                CCSprite *tSprite = [tMonster getSprite];
                
                [tSprite runAction:[CCFadeIn actionWithDuration:BEAT_ENEMY_TIME]];
                [tMonster setStrength:[tMonster getStrength] - demage];
            }
            
            return [tMonster getMonsterNum];
        }
    }
    
    return NotFound;
}
//////////////////////////////////////////////////////////////////////////
// 용사 End                                                              //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
//  용사 이동 방향 결정 Start                                               //
//////////////////////////////////////////////////////////////////////////
// 무작위 경로
- (BOOL) selectDirection:(Warrior *)pWarrior {
    if([pWarrior getMoveLength] != TILE_SIZE) return NO;
    Function *function = [[Function alloc] init];
    
    CGPoint point = [pWarrior getPosition];
    int x = ((int) point.x - HALF_TILE_SIZE) / TILE_SIZE;
    int y = TILE_NUM - ((int) point.y - HALF_TILE_SIZE) / TILE_SIZE - 1;
    
    // 종료 지점일 경우
    CGPoint ePoint = [[commonValue sharedSingleton] getEndPoint];
    if(x == ePoint.x && y == ePoint.y) {
        [pWarrior setMoveDriection:MoveNone];
        
        return YES;
    }
    
    NSMutableArray *choseDirection = [[NSMutableArray alloc] init];
    CCSprite *tSprite = [pWarrior getSprite];
    
    NSInteger preDirection = [pWarrior getMoveDriection];
    NSInteger direction = MoveNone;
    
    // 최단 경로로 가는 길이 있는지 검사
    if ([[commonValue sharedSingleton] getMoveTable:x y:y] != MoveNone) {
        if ([pWarrior getIntellect] >= MOVE_INTELLECT / 2) {
            // 최단 경로를 선택할 확률 증가
            [choseDirection addObject:[NSNumber numberWithInt:[[commonValue sharedSingleton] getMoveTable:x y:y]]];
        }
    
        [choseDirection addObject:[NSNumber numberWithInt:[[commonValue sharedSingleton] getMoveTable:x y:y]]];
    } else {
        // 최단 경로가 가는 길이 없을 경우 가장 가중치가 높은 길을 선택
        NSInteger minValue = 100;
        NSInteger value = 0;
        
        if ([function checkMoveTile:x y:(y - 1)] && preDirection != MoveDown) {
            value = [pWarrior valueOfMoveRoad:ccp(x, y - 1)];
            if (minValue > value) {
                minValue = value;
                direction = MoveUp;
            }
        }
        if ([function checkMoveTile:x y:(y + 1)] && preDirection != MoveUp) {
            value = [pWarrior valueOfMoveRoad:ccp(x, y + 1)];
            if (minValue > value) {
                minValue = value;
                direction = MoveDown;
            }
        }
        if ([function checkMoveTile:(x - 1) y:y] && preDirection != MoveRight) {
            value = [pWarrior valueOfMoveRoad:ccp(x - 1, y)];
            if (minValue > value) {
                minValue = value;
                direction = MoveLeft;
            }
        }
        if ([function checkMoveTile:(x + 1) y:y] && preDirection != MoveLeft) {
            value = [pWarrior valueOfMoveRoad:ccp(x + 1, y)];
            if (minValue > value) {
                minValue = value;
                direction = MoveRight;
            }
        }
    }
    
    if (direction == MoveNone) {
        // 이동해온 방향을 제외하고 이동이 가능한 경로가 있는지 검사하여 있을 경우 배열에 저장    
        if([function checkMoveTile:x y:(y - 1)] && preDirection != MoveDown) {
            [choseDirection addObject:[NSNumber numberWithInt:MoveUp]];
        }
        if([function checkMoveTile:x y:(y + 1)] && preDirection != MoveUp) {
            [choseDirection addObject:[NSNumber numberWithInt:MoveDown]];
        }
        if([function checkMoveTile:(x - 1) y:y] && preDirection != MoveRight) {
            [choseDirection addObject:[NSNumber numberWithInt:MoveLeft]];
        }
        if([function checkMoveTile:(x + 1) y:y] && preDirection != MoveLeft) {
            [choseDirection addObject:[NSNumber numberWithInt:MoveRight]];
        }    
        
        // 이동 가능한 경로에서 랜덤하게 선택
        if([choseDirection count] != 0) {
            NSInteger r = arc4random() % [choseDirection count];
            direction = [[choseDirection objectAtIndex:r] intValue];
        } else {
            if(preDirection == MoveUp)
                direction = MoveDown;
            else if(preDirection == MoveDown)
                direction = MoveUp;
            else if(preDirection == MoveLeft) 
                direction = MoveRight;
            else if(preDirection == MoveRight)
                direction = MoveLeft;  
        }
    }
    
    // 선택된 방향으로 이동
    [pWarrior setMoveDriection:direction];
    if(direction == MoveRight || direction == MoveDown) {
        tSprite.flipX = WARRIOR_MOVE_RIGHT;
    } else if(direction == MoveLeft || direction == MoveUp) {
        tSprite.flipX = WARRIOR_MOVE_LEFT;
    }
    
    // 필요 없는 항목 해제
    [pWarrior resetMoveLength];
    [choseDirection removeAllObjects];
    [choseDirection release];
    
    return NO;
}
// 최단 경로
- (BOOL) selectShortDirection:(Warrior *)pWarrior {
    if([pWarrior getMoveLength] != TILE_SIZE) return NO;
    
    // 이동 테이블에서 이동 방향을 확인
    CCSprite *tSprite = [pWarrior getSprite];
    CGPoint point = [pWarrior getPosition];
    int x = ((int) point.x - HALF_TILE_SIZE) / TILE_SIZE;
    int y = TILE_NUM - ((int) point.y - HALF_TILE_SIZE) / TILE_SIZE - 1;
    
    // 목적지일 경우
    CGPoint ePoint = [[commonValue sharedSingleton] getEndPoint];
    if(x == ePoint.x && y == ePoint.y) {
        [pWarrior setMoveDriection:MoveNone];
        
        return YES;
    }
    
    // 최단 경로가 있는지 검사
    NSInteger direction = [[commonValue sharedSingleton] getMoveTable:x y:y];
    [pWarrior setMoveDriection:direction];
    if(direction == MoveRight || direction == MoveDown) {
        tSprite.flipX = WARRIOR_MOVE_RIGHT;
    } else if(direction == MoveLeft || direction == MoveUp) {
        tSprite.flipX = WARRIOR_MOVE_LEFT;
    }
    
    [pWarrior resetMoveLength];
    
    return NO;
}
//////////////////////////////////////////////////////////////////////////
//  용사 이동 방향 결정 End                                                 //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 최단 이동 경로 계산 Start                                                 //
//////////////////////////////////////////////////////////////////////////
// 이동 경로를 계산하여 별도의 테이블에 저장
// 맵 초기화 및 중간에 장애물 설치시 이동 경로 재계산 필요
- (void) createMoveTable {
    CGPoint sPoint = [[commonValue sharedSingleton] getStartPoint];
    CGPoint ePoint = [[commonValue sharedSingleton] getEndPoint];
    
    [self initMoveValue];
    
    // 시작 지점의 가중치를 0로 둠
    tMoveValue[(int) sPoint.x][(int) sPoint.y] = 0;
    
    // 최단 거리 계산을 위한 테이블을 작성
    [self calcuationMoveValue:sPoint.x y:sPoint.y];
    
    // 작성한 테이블을 기준으로 이동 테이블 작성 - 종료지점에서 역으로 시작 지점을 탐색
    // 경로 테이블 작성 이전에 가능한 경로인지 체크 - 불가일 경우 게임 시작 불가처리
    if(tMoveValue[(int) ePoint.x][(int) ePoint.y] == 999) return;
    
    [self calcuatioDirection:ePoint.x y:ePoint.y];
}
- (BOOL) checkConnectRoad {
    CGPoint sPoint = [[commonValue sharedSingleton] getStartPoint];
    CGPoint ePoint = [[commonValue sharedSingleton] getEndPoint];
    
    [self initMoveValue];
    
    // 시작 지점의 가중치를 0로 둠
    tMoveValue[(int) sPoint.x][(int) sPoint.y] = 0;
    
    // 최단 거리 계산을 위한 테이블을 작성
    [self calcuationMoveValue:sPoint.x y:sPoint.y];
    
    // 작성한 테이블을 기준으로 이동 테이블 작성 - 종료지점에서 역으로 시작 지점을 탐색
    // 경로 테이블 작성 이전에 가능한 경로인지 체크 - 불가일 경우 게임 시작 불가처리
    if(tMoveValue[(int) ePoint.x][(int) ePoint.y] == 999) return NO;
    
    return YES;
}

- (void) initMoveValue {
    for(int i = 0; i < TILE_NUM; i++) {
        for(int j = 0; j < TILE_NUM; j++) {
            tMoveValue[i][j] = 999;
        }
    }
}

- (void) calcuationMoveValue:(int)x y:(int)y {
    CGPoint ePoint = [[commonValue sharedSingleton] getEndPoint];
    
    if(x == ePoint.x && y == ePoint.y) return;
    
    NSInteger nextValue = tMoveValue[x][y] + 1;
    if (y > 0 && [[commonValue sharedSingleton] getMoveTable:x y:(y - 1)] != -1) {
        // 상단 탐색    
        if(tMoveValue[x][y - 1] > nextValue) {
            tMoveValue[x][y - 1] = nextValue;
            [self calcuationMoveValue:x y:(y - 1)];
        }
    }
    
    if(x < (TILE_NUM - 1) && [[commonValue sharedSingleton] getMoveTable:(x + 1) y:y] != -1) {
        // 오른쪽 탐색
        if(tMoveValue[x + 1][y] > nextValue) {
            tMoveValue[x + 1][y] = nextValue;
            [self calcuationMoveValue:(x + 1) y:y];
        }
    } 
    
    if(x > 0 && [[commonValue sharedSingleton] getMoveTable:(x - 1) y:y] != -1) {
        // 왼쪽 탐색
        if(tMoveValue[x - 1][y] > nextValue) {
            tMoveValue[x - 1][y] = nextValue;
            [self calcuationMoveValue:(x - 1) y:y];
        }
    } 
    
    if (y < (TILE_NUM - 1) && [[commonValue sharedSingleton] getMoveTable:x y:(y + 1)] != -1) {
        // 아래 탐색    
        if(tMoveValue[x][y + 1] > nextValue) {
            tMoveValue[x][y + 1] = nextValue;
            [self calcuationMoveValue:x y:(y + 1)];
        }
    }
}

- (void) calcuatioDirection:(int)x y:(int)y {
    CGPoint sPoint = [[commonValue sharedSingleton] getStartPoint];
    
    if(x == sPoint.x && y == sPoint.y) {
        if([[commonValue sharedSingleton] getMoveTable:x y:(y - 1)] == MoveUp) 
            [[commonValue sharedSingleton] setMoveTable:x y:y direction:MoveUp];
        else if([[commonValue sharedSingleton] getMoveTable:x y:(y + 1)] == MoveDown)
            [[commonValue sharedSingleton] setMoveTable:x y:y direction:MoveDown];
        else if([[commonValue sharedSingleton] getMoveTable:(x - 1) y:y] == MoveLeft)
            [[commonValue sharedSingleton] setMoveTable:x y:y direction:MoveDown];
        else if([[commonValue sharedSingleton] getMoveTable:(x + 1) y:y] == MoveRight)
            [[commonValue sharedSingleton] setMoveTable:x y:y direction:MoveRight];
        
        return;       
    }
    
    if(tMoveValue[x][y] > tMoveValue[x][y - 1]) {
        [[commonValue sharedSingleton] setMoveTable:x y:(y - 1) direction:MoveDown];
        [self calcuatioDirection:x y:(y - 1)];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x][y + 1]) {
        [[commonValue sharedSingleton] setMoveTable:x y:(y + 1) direction:MoveUp];
        [self calcuatioDirection:x y:(y + 1)];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x - 1][y]) {
        [[commonValue sharedSingleton] setMoveTable:(x - 1) y:y direction:MoveRight];
        [self calcuatioDirection:(x - 1) y:y];
    }
    
    if(tMoveValue[x][y] > tMoveValue[x + 1][y]) {
        [[commonValue sharedSingleton] setMoveTable:(x + 1) y:y direction:MoveLeft];
        [self calcuatioDirection:(x + 1) y:y];
    }
}

/*- (void) setMoveTable:(NSInteger)x y:(NSInteger)y value:(NSInteger)value {
    moveTable[x][y] = value;
}
- (NSInteger) getMoveTable:(NSInteger)x y:(NSInteger)y {
    return moveTable[x][y];
}*/
//////////////////////////////////////////////////////////////////////////
// 이동 경로 계산 End                                                     //
//////////////////////////////////////////////////////////////////////////
@end
