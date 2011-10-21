//
//  WarriorHandling.m
//  Field
//
//  Created by Kang Jeonghun on 11. 10. 21..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "WarriorHandling.h"

@implementation WarriorHandling
@synthesize texture;

- (id) init {
    if ((self = [super init])) {
        warriorList = [[NSMutableArray alloc] init];
        warriorNum = 0;
        
        idleSprite = [[NSMutableArray alloc] init];
        idleAnimate = [[NSMutableArray alloc] init];
        
        texture = [[CCTextureCache sharedTextureCache] addImage:@"texture-character.png"];
    }
    
    return self;
}

//////////////////////////////////////////////////////////////////////////
// 용사 Start                                                            //
//////////////////////////////////////////////////////////////////////////
- (void) initWarrior {
    File *file = [[File alloc] init];
    NSString* path = [file loadFilePath:@"coordinates-character5.plist"];
    
    [self loadWarriorData:path];
}

// 파일로부터 캐릭터 이미지를 읽어들임
- (void) loadWarriorData:(NSString *)path {
    NSArray *warriorType = [NSArray arrayWithObjects: @"acher", @"fighter", @"mage", nil];
    
    charInfo = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSDictionary *tList = [charInfo objectForKey:@"frames"];
    
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

- (CCSprite*) createWarrior:(NSInteger)warriorType {
    CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    CGPoint sPoint = [[commonValue sharedSingleton] getStartPoint];
    
    NSLog(@"Create");
    
    // 용사 생성
    Warrior *tWarrior = [[Warrior alloc] initWarrior:sPoint
                                          warriorNum:warriorNum
                                            strength:100 
                                               power:10 
                                           intellect:10 
                                             defense:10 
                                               speed:2   //[[wInfo objectForKey:@"speed"] intValue] 
                                           direction:MoveUp
                                         attackRange:2]; 
    
    // 나타난 용사 수 증가
    warriorNum++;
    
    CCSprite *tSprite = [idleSprite objectAtIndex:warriorType];
    tSprite.position = ccp((sPoint.x * viewScale) + mapPosition.x, (sPoint.y * viewScale) + mapPosition.y); 
    [tSprite setFlipX:WARRIOR_MOVE_RIGHT];
    [tSprite setScale:viewScale];
    [tSprite setVisible:YES];
    [tSprite runAction:[CCRepeatForever actionWithAction:[idleAnimate objectAtIndex:warriorType]]];
    [tSprite release];
    
    [tWarrior setMoveLength:TILE_SIZE];
    [tWarrior setSprite:tSprite];
    
    [warriorList addObject:tWarrior];
    
    return tSprite;
}

// 일정 간격으로 호출됨
// 용사 이동 및 기타 처리를 하도록 함
- (void) moveWarrior:(TrapHandling*) trapHandling {
    NSMutableArray *deleteList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [warriorList count]; i++) {
        // 현재 위치 및 정보를 가져옴
        Warrior *tWarrior = [warriorList objectAtIndex:i];
        CCSprite *tSprite = [tWarrior getSprite];
        CGPoint movePosition = [tWarrior getPosition];
        
        // 다음 이동 방향 검사 - 추가적인 테스트 필요
        // 이동 거리 설정시 32의 약수로 지정해야 함 : 안 그럴 경우 타일 중앙에 위치를 하는 경우가 없어 제멋대로 이동함
        // 1, 2, 4, 8, 16, 32
        BOOL endFlag = [self selectDirection:tWarrior];
        
        if(endFlag) {
            // 목적지에 도달한 경우
            [deleteList addObject:tWarrior];
            
            continue;
        }
        
        // 목적지에 도달하지 않은 경우
        // 이동 방향 확인 
        // 일정 지능 이상일 경우 최단 경로
        //         이하일 경우 랜덤한 경로
        NSInteger direction = [tWarrior getMoveDriection];
        
        // 공격 대상 탐색
        // 트랩 탐지 및 처리
        BOOL survivalFlag = [trapHandling handlingTrap:tWarrior];   
        if(!survivalFlag) {
            [deleteList addObject:tWarrior];
            continue;
        }
        
        // 적 유닛 확인 및 처리
        NSInteger attackEnmy = [self enmyFind:tWarrior];
        if(attackEnmy != -1) NSLog(@"Found Enmy!!!(Warrior Num : %d, Trap Num : %d)", [tWarrior getWarriorNum], attackEnmy);
        
        // 생존 여부 확인 후 소멸 여부 처리
        if([tWarrior getStrength] <= 0) {
            [deleteList addObject:tWarrior];
            continue;
        }
        
        CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
        CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
        
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
        tSprite.position = ccp(mapPosition.x + (movePosition.x * viewScale), mapPosition.y + (movePosition.y * viewScale));
        [tWarrior setSprite:tSprite];
        
        [tWarrior plusMoveLength];
        [tWarrior setPosition:movePosition];
        
        
        [warriorList replaceObjectAtIndex:i withObject:tWarrior];
    }
    
    // 용사 삭제
    [self removeWarriorList:deleteList];

}

// 지정된 용사 제거
- (void) removeWarrior:(NSInteger)index {
    [warriorList removeObjectAtIndex:index];
}

- (void) removeWarriorList:(NSMutableArray *)deleteList {
    for(int i = [deleteList count]; i > 0; i--) {
        Warrior *tWarrior = [deleteList objectAtIndex:(i - 1)];
        [[tWarrior getSprite] setVisible:NO];
        [warriorList removeObject:tWarrior];
    }
}

// 일정거리 안에 적이 있는지 탐지
// 현재 트랩으로 지정됨 - 적으로 변경 필요
- (NSInteger) enmyFind:(Warrior*)pWarrior {
    //CGPoint wPoint = [pWarrior getPosition];
    //NSInteger wAttack = [pWarrior getAttackRange];
    
    /*for(int i = 0; i < [trapList count]; i++) {
     Trap *tTrap = [trapList objectAtIndex:i];
     CGPoint tPoint = [tTrap getPosition];
     CGFloat distance = [self lineLength:tPoint point2:wPoint];
     
     if(distance <= powf(wAttack * TILE_SIZE, 2)) {
     return [tTrap getTrapNum];
     }
     }*/
    
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

- (NSInteger) warriorCount {
    return [warriorList count];
}
- (Warrior*) warriorInfo:(NSInteger)index {
    return [warriorList objectAtIndex:index];
}
//////////////////////////////////////////////////////////////////////////
// 용사 End                                                              //
//////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////
// 최단 이동 경로 계산 Start                                                 //
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
    
    NSInteger nextValue = tMoveValue[x][y] + 1;
    if (y > 0 && moveTable[x][y - 1] != -1) {
        // 상단 탐색    
        if(tMoveValue[x][y - 1] > nextValue) {
            tMoveValue[x][y - 1] = nextValue;
            [self calcuationMoveValue:x y:(y - 1)];
        }
    }
    
    if(x < (TILE_NUM - 1) && moveTable[x + 1][y] != -1) {
        // 오른쪽 탐색
        if(tMoveValue[x + 1][y] > nextValue) {
            tMoveValue[x + 1][y] = nextValue;
            [self calcuationMoveValue:(x + 1) y:y];
        }
    } 
    
    if(x > 0 && moveTable[x - 1][y] != -1) {
        // 왼쪽 탐색
        if(tMoveValue[x - 1][y] > nextValue) {
            tMoveValue[x - 1][y] = nextValue;
            [self calcuationMoveValue:(x - 1) y:y];
        }
    } 
    
    if (y < (TILE_NUM - 1) && moveTable[x][y + 1] != -1) {
        // 아래 탐색    
        if(tMoveValue[x][y + 1] > nextValue) {
            tMoveValue[x][y + 1] = nextValue;
            [self calcuationMoveValue:x y:(y + 1)];
        }
    }
}

- (void) calcuatioDirection:(int)x y:(int)y {
    if(x == StartPoint.x && y == StartPoint.y) {
        if(moveTable[x][y - 1] == MoveUp) moveTable[x][y] = MoveUp;
        else if(moveTable[x][y + 1] == MoveDown) moveTable[x][y] = MoveDown;
        else if(moveTable[x - 1][y] == MoveLeft) moveTable[x][y] = MoveLeft;
        else if(moveTable[x + 1][y] == MoveRight) moveTable[x][y] = MoveRight;
        
        return;       
    }
    
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

- (void) setMoveTable:(NSInteger)x y:(NSInteger)y value:(NSInteger)value {
    moveTable[x][y] = value;
}
- (NSInteger) getMoveTable:(NSInteger)x y:(NSInteger)y {
    return moveTable[x][y];
}
//////////////////////////////////////////////////////////////////////////
// 이동 경로 계산 End                                                     //
//////////////////////////////////////////////////////////////////////////
@end
