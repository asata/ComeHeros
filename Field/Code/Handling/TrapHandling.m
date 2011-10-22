//
//  TrapHandling.m
//  Field
//
//  Created by Kang Jeonghun on 11. 10. 21..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "TrapHandling.h"

@implementation TrapHandling

- (id)init {
    if ((self = [super init])) {
        trapList = [[NSMutableArray alloc] init];
        trapNum = 0;
    }
    
    return self;
}

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
    unsigned int tileType = [[commonValue sharedSingleton] getMapInfo:x y:y];
    if(tileType == TILE_TREASURE || tileType == TILE_TRAP_OPEN) return;
    
    // 설치가 가능한 트랩을 화면에 출력
    [self printTrap:iPoint];
    
    // 이동 경로 재계산 필요 - 트랩이 설치된 경우
    //[self createMoveTable];
    
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
- (BOOL) handlingTrap:(Warrior*)pWarrior wList:(NSMutableArray*)warriorList{
    // 캐릭터의 현재 위치
    //Function *function = [[Function alloc] init];
    //CGPoint sPoint = [function convertTileToAbsCoordinate:[pWarrior getPosition]];   
    CGPoint sPoint1 = [pWarrior getPosition];
    
    for(int i = 0; i < [trapList count]; i++) {
        Trap *tTrap = [trapList objectAtIndex:i];
        //CGPoint tPoint = [tTrap getPosition];
        CGPoint tPoint1 = [tTrap getABSPosition];
        NSInteger trapType = [tTrap getTrapType];
        //CGFloat distance = [function lineLength:sPoint1 point2:tPoint1];
        
        if(trapType == TILE_TRAP_CLOSE) {
            // 닫힌 함정일 경우
            if(tPoint1.x == sPoint1.x && tPoint1.y == sPoint1.y && [pWarrior getIntellect] < PASS_TRAP_INTELLECT) {
                // 캐릭터의 지능에 따라 통과 여부 결정
                    [self trapOpen:pWarrior tTrap:tTrap];
                    
                    // 트랩 데미지를 입힘
                    [self trapDemage:pWarrior];
                
            }
        } else if(trapType == TILE_TRAP_OPEN) {
            // 열린 함정일 경우
            // 캐릭터의 지능에 따라 통과 여부 결정
            if(tPoint1.x == sPoint1.x && tPoint1.y == sPoint1.y && [pWarrior getIntellect] < PASS_TRAP_INTELLECT) {
                // 트랩 데미지를 입힘
                [self trapDemage:pWarrior];
                
                // 죽을 경우 트랩 닫기
                if([pWarrior getStrength] == 0) {
                    
                    // 트랩에 다른 적이 있는지 확인~~~
                    NSInteger tOnWarrior = [self trapCheckWarrior:pWarrior wList:warriorList];
                    if(tOnWarrior == 0) [self trapClose:pWarrior tTrap:tTrap];
                }
            }
        } else if(trapType == TILE_TREASURE) {
            // 보물상자일 경우
            
            /*if(distance < powf(TILE_SIZE, 2)) {
             [pWarrior setStrength:[pWarrior getStrength] - [tTrap getDemage]];
             
             NSLog(@"%f %f %f %f", tPoint.x, tPoint.y, sPoint.x, sPoint.y);
             NSLog(@"Find Treasure Box");
             }*/
            
            if([pWarrior getStrength] < 0) return DEATH;
        } else if(trapType == TILE_EXPLOSIVE) {
            // 폭발물일 경우
        }
    }
    
    return SURVIVAL;
}

- (void) trapDemage:(Warrior*)pWarrior{
    CCSprite *tSprite = [pWarrior getSprite];
    
    tSprite.flipX = !tSprite.flipX;
    tSprite.scale = tSprite.scale * 0.9;
    [pWarrior setMoveSpeed:0];
    [pWarrior setStrength:[pWarrior getStrength] - 10];
}

// 닫힌 함정을 오픈
- (void) trapOpen:(Warrior*)pWarrior tTrap:(Trap*)tTrap {
    CGPoint tPoint = [tTrap getPosition];
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    
    // 닫힌 함정을 오픈                        
    CCTMXLayer *layer2 = [map layerNamed:MAP_LAYER2];
    [layer2 setTileGID:TILE_TRAP_OPEN at:tPoint];
    [[commonValue sharedSingleton] setMapInfo:(NSInteger) tPoint.x y:(NSInteger) tPoint.y tileType:TILE_TRAP_OPEN];
    [tTrap setTrapType:TILE_TRAP_OPEN];
}

// 열린 함정을 닫음
- (void) trapClose:(Warrior*)pWarrior tTrap:(Trap*)tTrap  {
    CGPoint tPoint = [tTrap getPosition];
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    
    CCTMXLayer *layer2 = [map layerNamed:MAP_LAYER2];
    [layer2 setTileGID:TILE_TRAP_CLOSE at:tPoint];
    [[commonValue sharedSingleton] setMapInfo:(NSInteger) tPoint.x y:(NSInteger) tPoint.y tileType:TILE_TRAP_CLOSE];
    [tTrap setTrapType:TILE_TRAP_CLOSE];
}

- (NSInteger) trapCheckWarrior:(Warrior*)pWarrior wList:(NSMutableArray*)warriorList{
    NSInteger result = 0;

    for (Warrior *tWarrior in warriorList) {
        if(tWarrior == pWarrior) continue;
        
        if([pWarrior getPosition].x == [tWarrior getPosition].x &&
           [pWarrior getPosition].y == [tWarrior getPosition].y &&
           [tWarrior getStrength] > 0)
            result++;
    }
    
    return result;
}

// 트랩 목록에 트랙 추가
- (void) addTrap:(CGPoint)tPoint abs:(CGPoint)abs type:(NSInteger)tType {
    Trap *tTrap = [[Trap alloc] initTrap:tPoint abs:abs trapNum:trapNum trapType:tType demage:10];
    
    [trapList addObject:tTrap];
}
//////////////////////////////////////////////////////////////////////////
// 트랩 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
