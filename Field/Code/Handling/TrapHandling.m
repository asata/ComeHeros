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
    //if ((self = [super init])) {
    //}
    
    return self;
}

//////////////////////////////////////////////////////////////////////////
// 트랩 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 탐지한 트랩에 따라 처리
- (BOOL) handlingTrap:(Warrior*)pWarrior {
    // 캐릭터의 현재 위치
    Function *function = [[Function alloc] init];
    Coordinate *coordinate = [[Coordinate alloc] init];
    CGPoint sPoint = [coordinate convertTileToAbsCoordinate:[pWarrior getPosition]];   
    CGPoint sPoint1 = [pWarrior getPosition];
    
    for(int i = 0; i < [[commonValue sharedSingleton] trapListCount]; i++) {
        Trap *tTrap = [[commonValue sharedSingleton] getTrapListAtIndex:i]; 
        CGPoint tPoint = [tTrap getPosition];
        CGPoint tPoint1 = [tTrap getABSPosition];
        NSInteger trapType = [tTrap getTrapType];
        CGFloat distance = [function lineLength:sPoint1 point2:tPoint1];
        
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
                    NSInteger tOnWarrior = [self trapCheckWarrior:pWarrior];// wList:warriorList];
                    if(tOnWarrior == 0) [self trapClose:pWarrior tTrap:tTrap];
                }
            }
        } else if(trapType == TILE_TREASURE) {
            // 보물상자일 경우
            if(distance < powf(TILE_SIZE, 2)) {
                //[pWarrior setStrength:[pWarrior getStrength] - [tTrap getDemage]];
                
                NSLog(@"%f %f %f %f %f", distance, tPoint.x, tPoint.y, sPoint.x, sPoint.y);
                NSLog(@"Find Treasure Box");
             }
            
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

- (NSInteger) trapCheckWarrior:(Warrior*)pWarrior { 
    NSInteger result = 0;

    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        if(tWarrior == pWarrior) continue;
        
        if([pWarrior getPosition].x == [tWarrior getPosition].x &&
           [pWarrior getPosition].y == [tWarrior getPosition].y &&
           [tWarrior getStrength] > 0)
            result++;
    }
    
    return result;
}

// 트랩 목록에 트랙 추가
- (void) addTrap:(CGPoint)tPoint type:(NSInteger)tType {
    Coordinate *coordinate = [[Coordinate alloc] init];
    [self tileChange:tPoint type:tType];
    
    Trap *tTrap = [[Trap alloc] initTrap:tPoint 
                                     abs:[coordinate convertTileToMap:tPoint] 
                                 trapNum:[[commonValue sharedSingleton] getTrapNum] 
                                trapType:tType 
                                  demage:10];
    
    [[commonValue sharedSingleton] plusTrapNum];
    [[commonValue sharedSingleton] addTrap:tTrap];
}

- (void) tileChange:(CGPoint)tPoint type:(NSInteger)tType {
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    CCTMXLayer *layer2 = [map layerNamed:MAP_LAYER2];
    [layer2 setTileGID:tType at:tPoint];
    
    [[commonValue sharedSingleton] setMapInfo:tPoint.x y:tPoint.y tileType:tType];
}

- (void) addHouse:(CGPoint)tPoint abs:(CGPoint)abs type:(NSInteger)tType {
    [[commonValue sharedSingleton] plusTrapNum];
    
    //[[commonValue sharedSingleton] addHouse:tTrap];
}
//////////////////////////////////////////////////////////////////////////
// 트랩 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
