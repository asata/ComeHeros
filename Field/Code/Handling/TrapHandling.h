#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "Trap.h"
#import "Function.h"
#import "Coordinate.h"

@interface TrapHandling : CCLayer {
    NSMutableArray *chainTrapList;
}

- (BOOL) checkMoveTile:(NSInteger)tileType;
- (BOOL) checkObstacleTile:(NSInteger)tileType;
- (BOOL) checkHouseTile:(NSInteger)tileType;
- (BOOL) checkRoadTile:(NSInteger)tileType;
- (NSInteger) trapCheckWarrior:(Warrior*)pWarrior; 
- (void) removeTrap:(Trap*)pTrap;
- (BOOL) adjacentTrap:(CGPoint)pPoint point:(CGPoint)point range:(NSInteger)range;

// 트랩 관련 함수
- (BOOL) handlingTrap:(Warrior*)pWarrior;                   // 트랩 탐지 관련 처리
- (void) addTrap:(CGPoint)tPoint type:(NSInteger)tType;     // 트랩 목록에 트랩 추가

// 함정 처리 함수
- (void) tileChange:(CGPoint)tPoint type:(NSInteger)tType;
- (void) trapOpen:(Warrior*)pWarrior tTrap:(Trap*)tTrap; 
- (void) trapClose:(Warrior*)pWarrior tTrap:(Trap*)tTrap; 
- (BOOL) trapDemage:(Warrior*)pWarrior;

// 보물상자 처리 함수
- (void) bombTreasure:(Trap*)pTrap direction:(NSInteger)direction;
- (NSInteger) findRangeTreasure:(CGPoint)trapPotin direction:(NSInteger)direction;
- (BOOL) warriorInTreasureBombRange:(CGPoint)warriorPoint minPoint:(CGPoint)minPoint maxPoint:(CGPoint)maxPoint; 
- (void) rangeBombTreasure:(CGPoint)minPoint maxPoint:(CGPoint)maxPoint;

// 폭발물 처리 함수
- (void) findExplosive:(Trap*)pTrap;
- (BOOL) existExplosiveList:(Trap*)pTrap;
- (void) bombExplosive:(Trap*)pTrap;
- (void) rangeBombExplosive:(CGPoint)bombPoint;  
@end
