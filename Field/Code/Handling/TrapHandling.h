#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "Trap.h"
#import "Function.h"

@interface TrapHandling : NSObject {
    NSMutableArray  *trapList;          // 트랩 List
    NSInteger       trapNum;            // 게임 시작 후 설치한 트랩의 수
}

// 트랩 관련 함수
- (void) initTrap;
- (void) printTrapList:(CGPoint)iPoint;
- (void) printTrap:(CGPoint)iPoint;
- (void) createTrap:(CGPoint)iPoint;                        // 트랩 설치
- (BOOL) handlingTrap:(Warrior*)pWarrior;                   // 트랩 탐지 관련 처리
- (void) addTrap:(CGPoint)tPoint abs:(CGPoint)abs type:(NSInteger)tType;     // 트랩 목록에 트랩 추가

- (NSInteger) trapCheckWarrior:(Warrior*)pWarrior;
- (void) trapOpen:(Warrior*)pWarrior; 
- (void) trapClose:(Warrior*)pWarrior tTrap:(Trap*)tTrap; 
- (void) trapDemage:(Warrior*)pWarrior;


@end
