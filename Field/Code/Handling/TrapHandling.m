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

- (BOOL) checkMoveTile:(NSInteger)tileType {
    if(tileType == TILE_NONE ||  tileType == TILE_WALL01 || tileType == TILE_WALL10 || 
       tileType == TILE_WALL11 || tileType == TILE_WALL12 || tileType == TILE_WALL13 || 
       tileType == TILE_TREASURE || tileType == TILE_EXPLOSIVE)
        return NO;
    
    return YES;
}

- (BOOL) checkObstacleTile:(NSInteger)tileType {
    if(tileType == TILE_TRAP_OPEN || tileType == TILE_TRAP_CLOSE ||
       tileType == TILE_TREASURE || tileType == TILE_EXPLOSIVE)
        return YES;
    
    return NO;
}
- (BOOL) checkHouseTile:(NSInteger)tileType {
    if(tileType == TILE_MONSTER_HOUSE1)
        return YES;
    
    return NO;
}
- (BOOL) adjacentTrap:(CGPoint)tPoint point:(CGPoint)point range:(NSInteger)range {
    if (tPoint.x + range >= point.x && point.x >= tPoint.x - range &&
        point.y <= tPoint.y + range && point.y >= tPoint.y - range) {
        return YES;
    }
    
    return NO;
}
// 지정된 용사와 동일한 위치에 존재하는 용사가 있는지 검사
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
// 지정된 위치의 타일 변경
- (void) tileChange:(CGPoint)tPoint type:(NSInteger)tType {
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    CCTMXLayer *layer2 = [map layerNamed:MAP_LAYER2];
    [layer2 setTileGID:tType at:tPoint];
    
    [[commonValue sharedSingleton] setMapInfo:tPoint.x y:tPoint.y tileType:tType];
}
- (void) removeTrap:(Trap*)pTrap {
    if([pTrap getTrapType] == TILE_TREASURE || [pTrap getTrapType] == TILE_EXPLOSIVE) {
        [self tileChange:[pTrap getPosition] type:TILE_GROUND2];
    }
        
    [[commonValue sharedSingleton] removeTrap:pTrap];
}


//////////////////////////////////////////////////////////////////////////
// 트랩 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 탐지한 트랩에 따라 처리
- (BOOL) handlingTrap:(Warrior*)pWarrior {
    // 캐릭터의 현재 위치
    //Function *function = [[Function alloc] init];
    Coordinate *coordinate = [[Coordinate alloc] init];
    CGPoint wPoint = [coordinate convertTileToAbsCoordinate:[pWarrior getPosition]];   
    CGPoint wPoint1 = [pWarrior getPosition];
    
    for(int i = 0; i < [[commonValue sharedSingleton] trapListCount]; i++) {
        Trap *tTrap = [[commonValue sharedSingleton] getTrapListAtIndex:i]; 
        CGPoint tPoint = [tTrap getPosition];
        CGPoint tPoint1 = [tTrap getABSPosition];
        NSInteger trapType = [tTrap getTrapType];
        //CGFloat distance = [function lineLength:wPoint1 point2:tPoint1];
        
        if(trapType == TILE_TRAP_CLOSE) {
            // 닫힌 함정일 경우
            if(tPoint1.x == wPoint1.x && tPoint1.y == wPoint1.y && [pWarrior getIntellect] < PASS_TRAP_INTELLECT) {
                // 캐릭터의 지능에 따라 통과 여부 결정
                [self trapOpen:pWarrior tTrap:tTrap];
                    
                // 트랩 데미지를 입힘
                [self trapDemage:pWarrior];
            }
        } else if(trapType == TILE_TRAP_OPEN) {
            // 열린 함정일 경우
            // 캐릭터의 지능에 따라 통과 여부 결정
            if(tPoint1.x == wPoint1.x && tPoint1.y == wPoint1.y && [pWarrior getIntellect] < PASS_TRAP_INTELLECT) {
                // 트랩 데미지를 입힘
                [self trapDemage:pWarrior];
                
                // 죽을 경우 트랩 닫기
                if([pWarrior getStrength] == 0) {
                    // 트랩에 다른 적이 있는지 확인~~~
                    NSInteger tOnWarrior = [self trapCheckWarrior:pWarrior];
                    if(tOnWarrior == 0) {
                        [self trapClose:pWarrior tTrap:tTrap];
                        [self removeTrap:tTrap];
                    }
                }
            }
        } else if(trapType == TILE_TREASURE) {
            // 보물상자일 경우
            //if(distance < powf((2 * TILE_SIZE), 2)) {
            if ([self adjacentTrap:tPoint point:wPoint range:RANGE_TREASURE] && [pWarrior getStrength] > 0) {
                [self bombTreasure:tTrap];
            }
            
            if([pWarrior getStrength] < 0) return DEATH;
        } else if(trapType == TILE_EXPLOSIVE) {
            // 폭발물일 경우
            if ([self adjacentTrap:tPoint point:wPoint range:RANGE_EXPLOSIVE] && [pWarrior getStrength] > 0) {
                fineTrapList = [[NSMutableArray alloc] init];
                
                // 연쇄 폭발할 폭발물 검색(검색시 보물상자는 제외시킴)
                [self findExplosive:tTrap];
                for (Trap *fTrap in fineTrapList) {
                    [self bombExplosive:fTrap];
                }
                
            }
            
            if([pWarrior getStrength] < 0) return DEATH;
        }
    }
    
    return SURVIVAL;
}


/********************************************************/
/* 폭발물 처리 부분 시작                                     */
/********************************************************/
// 연쇄 폭발할 폭발물 검색
- (void) findExplosive:(Trap*)pTrap {
    [fineTrapList addObject:pTrap];
    
    for (Trap *tTrap in [[commonValue sharedSingleton] getTrapList]) {
        if ([tTrap getTrapType] != TILE_EXPLOSIVE) continue;
        if ([pTrap getTrapNum] == [tTrap getTrapNum]) continue;
        if ([self existExplosiveList:tTrap]) continue;
        if (![self adjacentTrap:[pTrap getPosition] point:[tTrap getPosition] range:RANGE_EXPLOSIVE]) continue;
        
        [self findExplosive:tTrap];
    }
}
// 이전에 찾은 폭발물인지 검사
- (BOOL) existExplosiveList:(Trap*)pTrap {
    for (Trap *tTrap in fineTrapList) {
        if ([pTrap getTrapNum] == [tTrap getTrapNum]) return YES;
    }
    
    return NO;
}
// 폭발물 폭파
- (void) bombExplosive:(Trap*)pTrap {
    // 일정 범위에 있는 용사들의 읽어들여 데미지를 입힘
    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        Coordinate *coordinate = [[Coordinate alloc] init];
        CGPoint wPoint = [coordinate convertTileToAbsCoordinate:[tWarrior getPosition]];
        
        if([self adjacentTrap:[pTrap getPosition] point:wPoint range:RANGE_EXPLOSIVE]) {
            [tWarrior setStrength:[tWarrior getStrength] - DEMAGE_BOMB];   
        }
    }
    
    // 일정 범위에 대한 파티클 효과 적용
    /*id particleSystem = [[CCParticleFire alloc] init];
     [particleSystem setStartSize:0];
     [particleSystem setEndSize:40];
     
     [self addChild:particleSystem];*/
    [[commonValue sharedSingleton] setMoveTable:[pTrap getPosition].x y:[pTrap getPosition].y direction:MoveNone];
    [self removeTrap:pTrap];    
}
/********************************************************/
/* 폭발물 처리 부분 끝                                      */
/********************************************************/



/********************************************************/
/* 함정 처리 부분 시작                                      */
/********************************************************/
// 함정에 대한 데미지 처리
- (void) trapDemage:(Warrior*)pWarrior{
    CCSprite *tSprite = [pWarrior getSprite];
    
    tSprite.flipX = !tSprite.flipX;
    tSprite.scale = tSprite.scale * 0.9;
    [pWarrior setMoveSpeed:0];
    [pWarrior setPower:0];
    [pWarrior setStrength:[pWarrior getStrength] - DEMAGE_TRAP];
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
/********************************************************/
/* 함정 처리 부분 끝                                        */
/********************************************************/


/********************************************************/
/* 보물상자 처리 부분 시작                                    */
/********************************************************/
- (void) bombTreasure:(Trap*)pTrap {
    // 일정 범위에 있는 용사들의 읽어들여 데미지를 입힘
    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        Coordinate *coordinate = [[Coordinate alloc] init];
        CGPoint wPoint = [coordinate convertTileToAbsCoordinate:[tWarrior getPosition]];
        
        if([self adjacentTrap:[pTrap getPosition] point:wPoint range:RANGE_TREASURE]) {
            [tWarrior setStrength:[tWarrior getStrength] - [pTrap getDemage]];
        }
    }
    
    // 일정 범위에 대한 파티클 효과 적용
    /*id particleSystem = [[CCParticleFire alloc] init];
     [particleSystem setStartSize:0];
     [particleSystem setEndSize:40];
     
     [self addChild:particleSystem];*/
    
    [[commonValue sharedSingleton] setMoveTable:[pTrap getPosition].x y:[pTrap getPosition].y direction:MoveNone];
    [self removeTrap:pTrap];
}
/********************************************************/
/* 보물상자 처리 부분 끝                                     */
/********************************************************/


// 트랩 목록에 트랙 추가
- (void) addTrap:(CGPoint)tPoint type:(NSInteger)tType {
    Coordinate *coordinate = [[Coordinate alloc] init];
    [self tileChange:tPoint type:tType];
    
    Trap *tTrap = [[Trap alloc] initTrap:tPoint 
                                     abs:[coordinate convertTileToMap:tPoint] 
                                 trapNum:[[commonValue sharedSingleton] getTrapNum] 
                                trapType:tType 
                                  demage:100];
    
    [[commonValue sharedSingleton] plusTrapNum];
    [[commonValue sharedSingleton] addTrap:tTrap];
}

/*- (void) addHouse:(CGPoint)tPoint abs:(CGPoint)abs type:(NSInteger)tType {
    [[commonValue sharedSingleton] plusTrapNum];
    
    //[[commonValue sharedSingleton] addHouse:tTrap];
}*/
//////////////////////////////////////////////////////////////////////////
// 트랩 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
