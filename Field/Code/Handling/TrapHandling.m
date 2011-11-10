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

// 이동 불가 타일인지 검사 
// 이동 불가일 경우 NO 반환
- (BOOL) checkMoveTile:(NSInteger)tileType {
    if(tileType == TILE_NONE ||  tileType == TILE_WALL01 || tileType == TILE_WALL10 || 
       tileType == TILE_WALL11 || tileType == TILE_WALL12 || tileType == TILE_WALL13 || 
       tileType == TILE_TREASURE || tileType == TILE_EXPLOSIVE)
        return NO;
    
    return YES;
}
// 해당 타일이 트랩인지 검사
- (BOOL) checkObstacleTile:(NSInteger)tileType {
    if(tileType == TILE_TRAP_OPEN || tileType == TILE_TRAP_CLOSE ||
       tileType == TILE_TREASURE || tileType == TILE_EXPLOSIVE)
        return YES;
    
    return NO;
}
// 해당 타일이 몬스터를 생산을 할 수 있는 타일인지 검사
- (BOOL) checkHouseTile:(NSInteger)tileType {
    if(tileType == TILE_MONSTER_HOUSE1)
        return YES;
    
    return NO;
}
// 해당 타일이 길인지 검사
- (BOOL) checkRoadTile:(NSInteger)tileType {
    if(tileType == TILE_GROUND1 || tileType == TILE_GROUND2)
        return YES;
    
    return NO;
}
// tPoint의 지정된 범위에 point가 존재하는지 검사
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
        if ([tWarrior getDeath] == DEATH) continue;
        if (tWarrior == pWarrior) continue;
        
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
// 지정된 타일을 제거
- (void) removeTrap:(Trap*)pTrap {
    if([pTrap getTrapType] == TILE_TREASURE || [pTrap getTrapType] == TILE_EXPLOSIVE) {
        [self tileChange:[pTrap getPosition] type:TILE_GROUND2];
    }
        
    [[commonValue sharedSingleton] plusUseObstacleNum];
    [[commonValue sharedSingleton] removeTrap:pTrap];
}
//////////////////////////////////////////////////////////////////////////
// 트랩 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 탐지한 트랩에 따라 처리
- (BOOL) handlingTrap:(Warrior*)pWarrior {
    // 캐릭터의 현재 위치
    Coordinate *coordinate = [[Coordinate alloc] init];
    CGPoint wPoint = [coordinate convertAbsCoordinateToTile:[pWarrior getPosition]];   
    CGPoint wPoint1 = [pWarrior getPosition];
    
    for(int i = 0; i < [[commonValue sharedSingleton] trapListCount]; i++) {
        Trap *tTrap = [[commonValue sharedSingleton] getTrapListAtIndex:i]; 
        CGPoint tPoint = [tTrap getPosition];
        CGPoint tPoint1 = [tTrap getABSPosition];
        NSInteger trapType = [tTrap getTrapType];
        
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
                if (![self trapDemage:pWarrior]) {
                    // 트랩에 다른 적이 있는지 확인하여 있을 경우 트랩 동작을 계속 진행하도록 함
                    NSInteger tOnWarrior = [self trapCheckWarrior:pWarrior];
                    if(tOnWarrior == 0) {
                        [self trapClose:pWarrior tTrap:tTrap];
                        [self removeTrap:tTrap];
                    }
                }
            }
        } else if(trapType == TILE_TREASURE) {
            // 보물상자일 경우
            if ([pWarrior getStrength] > 0) {
                if (tPoint1.x == (wPoint1.x - TILE_SIZE) && tPoint1.y == wPoint1.y) {
                    // Warrior Position : Right  
                    [self bombTreasure:tTrap direction:Right];
                } else if (tPoint1.x == (wPoint1.x + TILE_SIZE) && tPoint1.y == wPoint1.y) { 
                    // Warrior Position : Left
                    [self bombTreasure:tTrap direction:Left];   
                } else if (tPoint1.x == wPoint1.x && tPoint1.y == (wPoint1.y - TILE_SIZE)) {
                    // Warrior Position : Up
                    [self bombTreasure:tTrap direction:Up];
                } else if (tPoint1.x == wPoint1.x && tPoint1.y == (wPoint1.y + TILE_SIZE)) {
                    // Warrior Position : Down
                    [self bombTreasure:tTrap direction:Down];
                }
            }
            
            if([pWarrior getStrength] < 0) return DEATH;
        } else if(trapType == TILE_EXPLOSIVE) {
            // 폭발물일 경우
            if ([self adjacentTrap:tPoint point:wPoint range:DETECT_EXPLOSIVE] && [pWarrior getStrength] > 0) {
                chainTrapList = [[NSMutableArray alloc] init];
                
                // 연쇄 폭발할 폭발물 검색(검색시 보물상자는 제외시킴)
                [self findExplosive:tTrap];
                for (Trap *fTrap in chainTrapList) {
                    [self bombExplosive:fTrap];
                }
            }
            
            if([pWarrior getStrength] < 0) return DEATH;
        }
    }
    
    return SURVIVAL;
}


/********************************************************/
/* 보물상자 처리 부분 시작                                    */
/********************************************************/
- (void) bombTreasure:(Trap*)pTrap direction:(NSInteger)direction {
    Coordinate *coordinate = [[Coordinate alloc] init];
    CGPoint trapPoint = [pTrap getPosition];
    
    CGPoint minPoint;
    CGPoint maxPoint;
    
    // 영향을 미치는 범위를 구함 
    // left, right : y 값 동일
    // up, down : x 값 동일
    if (direction == Left) {
        minPoint = ccp([self findRangeTreasure:trapPoint direction:direction], trapPoint.y);
        maxPoint = ccp(trapPoint.x, trapPoint.y);
    } else if (direction == Right) {
        minPoint = ccp(trapPoint.x, trapPoint.y);
        maxPoint = ccp([self findRangeTreasure:trapPoint direction:direction], trapPoint.y);
    } else if (direction == Up) {
        minPoint = ccp(trapPoint.x, [self findRangeTreasure:trapPoint direction:direction]);
        maxPoint = ccp(trapPoint.x, trapPoint.y);
    } else if (direction == Down) {
        minPoint = ccp(trapPoint.x, trapPoint.y);
        maxPoint = ccp(trapPoint.x, [self findRangeTreasure:trapPoint direction:direction]);
    }
    
    // 효과음 재생
    [[SimpleAudioEngine sharedEngine] playEffect:@"bomb_trap.wav"];
    
    // 일정 범위에 있는 용사들의 읽어들여 데미지를 입힘
    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        if ([tWarrior getDeath] == DEATH) continue;
        CGPoint wPoint = [coordinate convertAbsCoordinateToTile:[tWarrior getPosition]];
        
        if([self warriorInTreasureBombRange:wPoint minPoint:minPoint maxPoint:maxPoint]) {
            [tWarrior setStrength:[tWarrior getStrength] - [pTrap getDemage]];
        }
    }
    
    [self rangeBombTreasure:minPoint maxPoint:maxPoint];
    
    [[commonValue sharedSingleton] setMoveTable:[pTrap getPosition].x y:[pTrap getPosition].y direction:MoveNone];
    [self removeTrap:pTrap];
}
// 보물상자의 폭발 범위를 확인
- (NSInteger) findRangeTreasure:(CGPoint)trapPotint direction:(NSInteger)direction {
    NSInteger x = trapPotint.x;
    NSInteger y = trapPotint.y;
    NSInteger num = 0;
    
    if (direction == Left) {
        do {
            if (num == RANGE_TREASURE)  break;
            x--;
            num++;
        } while ([self checkRoadTile:[[commonValue sharedSingleton] getMapInfo:x y:y]]);
        x++;
        
        return x;
    } else if (direction == Right) {
        do {
            if (num == RANGE_TREASURE)  break;
            x++;
            num++;
        } while ([self checkRoadTile:[[commonValue sharedSingleton] getMapInfo:x y:y]]);
        x--;
        
        return x;
    } else if (direction == Up) {
        do {
            if (num == RANGE_TREASURE)  break;
            y--;
            num++;
        } while ([self checkRoadTile:[[commonValue sharedSingleton] getMapInfo:x y:y]]);
        y++;
        
        return y;
    } else if (direction == Down) {
        do {
            if (num == RANGE_TREASURE)  break;
            y++;
            num++;
        } while ([self checkRoadTile:[[commonValue sharedSingleton] getMapInfo:x y:y]]);
        y--;
        
        return y;
    }  

    return -1;
}

- (BOOL) warriorInTreasureBombRange:(CGPoint)warriorPoint minPoint:(CGPoint)minPoint maxPoint:(CGPoint)maxPoint {
    if(minPoint.x <= warriorPoint.x && maxPoint.x >= warriorPoint.x &&
       minPoint.y <= warriorPoint.y && maxPoint.y >= warriorPoint.y) return YES;
    
    return NO;
}
- (void) rangeBombTreasure:(CGPoint)minPoint maxPoint:(CGPoint)maxPoint {
    Coordinate *coordinate = [[Coordinate alloc] init];
    
    for (NSInteger i = minPoint.x; i <= maxPoint.x; i++) {
        for (NSInteger j = minPoint.y; j <= maxPoint.y; j++) {
            CCSprite *tFlame = [CCSprite spriteWithFile:@"fire.png" rect:CGRectMake(0,0,32,32)];
            [tFlame setPosition:[coordinate convertTileToMap:ccp(i, j)]];
            [tFlame setVisible:YES];
            [tFlame setScale:1.0f];
            [[commonValue sharedSingleton] pushFlame:tFlame]; 
        }
    }
}
/********************************************************/
/* 보물상자 처리 부분 끝                                     */
/********************************************************/



/********************************************************/
/* 폭발물 처리 부분 시작                                     */
/********************************************************/
// 연쇄 폭발할 폭발물 검색
- (void) findExplosive:(Trap*)pTrap {
    [chainTrapList addObject:pTrap];
    
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
    for (Trap *tTrap in chainTrapList) {
        if ([pTrap getTrapNum] == [tTrap getTrapNum]) return YES;
    }
    
    return NO;
}
// 폭발물 폭파
- (void) bombExplosive:(Trap*)pTrap {
    Coordinate *coordinate = [[Coordinate alloc] init];
    
    // 효과음 재생
    [[SimpleAudioEngine sharedEngine] playEffect:@"bomb_trap.wav"];
    
    // 일정 범위에 있는 용사들의 읽어들여 데미지를 입힘
    for (Warrior *tWarrior in [[commonValue sharedSingleton] getWarriorList]) {
        CGPoint wPoint = [coordinate convertAbsCoordinateToTile:[tWarrior getPosition]];
        
        if([self adjacentTrap:[pTrap getPosition] point:wPoint range:RANGE_EXPLOSIVE]) {
            [tWarrior setStrength:[tWarrior getStrength] - DEMAGE_BOMB];   
        }
    }
    
    [[commonValue sharedSingleton] setMoveTable:[pTrap getPosition].x y:[pTrap getPosition].y direction:MoveNone];
    [self removeTrap:pTrap];    
    
    [self rangeBombExplosive:[pTrap getPosition]];
}
- (void) rangeBombExplosive:(CGPoint)bombPoint {
    Coordinate *coordinate = [[Coordinate alloc] init];
    for (NSInteger i = bombPoint.x - RANGE_EXPLOSIVE; i < bombPoint.x + RANGE_EXPLOSIVE + 1; i++) {
        for (NSInteger j = bombPoint.y - RANGE_EXPLOSIVE; j < bombPoint.y + RANGE_EXPLOSIVE + 1; j++) {
            NSInteger tileType = [[commonValue sharedSingleton] getMapInfo:i y:j] ;
            if (![self checkMoveTile:tileType]) continue;
            
            CCSprite *tFlame = [CCSprite spriteWithFile:@"fire.png" rect:CGRectMake(0, 0, 32, 32)];
            [tFlame setPosition:[coordinate convertTileToCocoa:ccp(i, j)]];
            [tFlame setVisible:YES];
            [[commonValue sharedSingleton] pushFlame:tFlame];
        }
    }
}
/********************************************************/
/* 폭발물 처리 부분 끝                                      */
/********************************************************/



/********************************************************/
/* 함정 처리 부분 시작                                      */
/********************************************************/
// 함정에 대한 데미지 처리
- (BOOL) trapDemage:(Warrior*)pWarrior{
    CCSprite *tSprite = [pWarrior getSprite];
    
    if ([tSprite scale] >= DEATH_TRAP_SCALE) {
        tSprite.flipX = !tSprite.flipX;
        tSprite.scale = tSprite.scale * 0.9;
        [pWarrior setMoveSpeed:0];
        [pWarrior setPower:0];
        [pWarrior setDefense:999];
        
        return YES;
    } else {
        [pWarrior setDeath:DEATH];
        [[commonValue sharedSingleton] plusKillWarriorNum];
        [[commonValue sharedSingleton] plusStagePoint:POINT_WARRIOR_KILL];
        [[commonValue sharedSingleton] plusStageMoney:MONEY_WARRIOR_KILL];
        
        return NO;
    }
    
    return YES;
}

// 닫힌 함정을 오픈
- (void) trapOpen:(Warrior*)pWarrior tTrap:(Trap*)tTrap {
    CGPoint tPoint = [tTrap getPosition];
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    
    // 효과음 재생
    [[SimpleAudioEngine sharedEngine] playEffect:@"trap_on.wav"];
    
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
    [layer2 setTileGID:TILE_TRAP_OPEN at:tPoint];
    [[commonValue sharedSingleton] setMapInfo:(NSInteger) tPoint.x y:(NSInteger) tPoint.y tileType:TILE_TRAP_CLOSE];
    [tTrap setTrapType:TILE_TRAP_CLOSE];
}
/********************************************************/
/* 함정 처리 부분 끝                                        */
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
    
    if (tType == TILE_TREASURE || tType == TILE_TRAP_CLOSE || tType == TILE_TRAP_OPEN || tType == TILE_EXPLOSIVE) {
        [[commonValue sharedSingleton] plusTrapNum];
    }
    [[commonValue sharedSingleton] addTrap:tTrap];
}
//////////////////////////////////////////////////////////////////////////
// 트랩 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
