#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "Trap.h"
#import "Function.h"
#import "Coordinate.h"

@interface TrapHandling : CCLayer {
    NSMutableArray *chainTrapList;
}

// 이동 불가 타일인지 검사 
- (BOOL) checkMoveTile:(NSInteger)tileType;
// 해당 타일이 트랩인지 검사
- (BOOL) checkObstacleTile:(NSInteger)tileType;
// 해당 타일이 몬스터를 생산을 할 수 있는 타일인지 검사
- (BOOL) checkHouseTile:(NSInteger)tileType;
// 해당 타일이 길인지 검사
- (BOOL) checkRoadTile:(NSInteger)tileType;
// 지정된 용사와 동일한 위치에 존재하는 용사가 있는지 검사
- (NSInteger) trapCheckWarrior:(Warrior*)pWarrior; 
// tPoint의 지정된 범위에 point가 존재하는지 검사
- (BOOL) adjacentTrap:(CGPoint)pPoint point:(CGPoint)point range:(NSInteger)range;


// 트랩 목록에 트랩 추가
- (void) addTrap:(CGPoint)tPoint type:(NSInteger)tType;   
// 지정된 위치의 타일 변경
- (void) tileChange:(CGPoint)tPoint type:(NSInteger)tType;
// 지정된 타일을 제거
- (void) removeTrap:(Trap*)pTrap;

// 탐지한 트랩에 따라 처리
- (BOOL) handlingTrap:(Warrior*)pWarrior;  

// 함정 처리 함수
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
