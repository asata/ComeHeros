#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "Trap.h"
#import "Function.h"
#import "Coordinate.h"

@interface TrapHandling : NSObject {
}

- (BOOL) checkMoveTile:(NSInteger)tileType;
- (BOOL) checkObstacleTile:(NSInteger)tileType;
- (BOOL) checkHouseTile:(NSInteger)tileType;

// 트랩 관련 함수
- (BOOL) handlingTrap:(Warrior*)pWarrior;                   // 트랩 탐지 관련 처리
- (void) addTrap:(CGPoint)tPoint type:(NSInteger)tType;     // 트랩 목록에 트랩 추가

- (void) tileChange:(CGPoint)tPoint type:(NSInteger)tType;
- (NSInteger) trapCheckWarrior:(Warrior*)pWarrior; 
- (void) trapOpen:(Warrior*)pWarrior tTrap:(Trap*)tTrap; 
- (void) trapClose:(Warrior*)pWarrior tTrap:(Trap*)tTrap; 
- (void) trapDemage:(Warrior*)pWarrior;

@end
