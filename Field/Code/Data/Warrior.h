//////////////////////////////////////////////////////////////////
// Warrior에 관련된 Class                                         //
//////////////////////////////////////////////////////////////////
/***************************************************************** 
 Warrior의 종류 : Acher, Fighter, Mage                               
 
 기본 동작
     일정한 시작 지점에서 나와 도착 지점까지 이동
     이동하는 동안 만나는 Monster에게 공격을 할 수 있으며, 지능에 따라 Trap을 
    무시할 수도 있다.
 
 이동 방향 결정
    Warrior의 지능에 따라 최단 경로 또는 무작위 경로를 선택을 한다.
    
    - 최단 경로  : 목적지까지 가장 가까운 길로 이동한다.
    - 무작위 경로 : 갈림길이 있을 경우 랜덤하게 선택하여 이동을 한다.
 
 Acher      :
 Fighter    :
 Mage       :
 *****************************************************************/
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Character.h"

@interface Warrior : Character {
@private
    NSInteger       warriorNum;
    
    // 이동한 경로를 기록할 큐를 만듬
    NSMutableArray  *moveList;
    
}

// 이동한 경로를 기록할 CGPoint NSMutableArray를 생성하고, 
// 이를 이용할 함수 생성
// 각 캐릭터마다 사용

- (id) initWarrior:(CGPoint)pos warriorNum:(NSInteger)p_num 
          strength:(NSInteger)pStrength power:(NSInteger)pPower 
         intellect:(NSInteger)pIntellect defense:(NSInteger)pDefense 
             speed:(NSInteger)pSpeed direction:(NSInteger)pDirection 
       attackRange:(NSInteger)pAttackRange;

- (void) setWarriorNum:(NSInteger)p_num;
- (NSInteger) getWarriorNum;

- (void) pushMoveList:(CGPoint)point;
- (CGPoint) popMoveList;
- (CGPoint) getMoveList:(NSInteger)index;
- (NSInteger) valueOfMoveRoad:(CGPoint)point;
- (NSInteger) countMoveList;
- (void) removeAllMoveList;

@end