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

@interface Warrior : NSObject {
@private
    NSInteger   warriorNum;
    CCSprite    *sprite;
    //CCAnimate   *walkAnimate;     // 공격 애니메이션
    CCAnimate   *attackAnimate;     // 공격 애니메이션
    //CCAnimate   *defenseAnimate;    // 방어 애니메이션
    CGPoint     position;           // 현재 위치
    
    BOOL        death;
    
    NSInteger   visibleNum;
    NSInteger   strength;           // 체력
    NSInteger   power;              // 힘
    NSInteger   intellect;          // 지능
    NSInteger   defense;            // 방어력
    NSInteger   moveLength;         // 이동 거리
    NSInteger   moveSpeed;          // 이동 속도
    NSInteger   moveDirection;      // 이동 방향
    NSInteger   attackRange;        // 공격범위
}

@property (nonatomic, retain) CCSprite *sprite;
//@property (nonatomic, retain) CCAnimate *walkAnimate;
@property (nonatomic, retain) CCAnimate *attackAnimate;
//@property (nonatomic, retain) CCAnimate *defenseAnimate;

- (id) initWarrior:(CGPoint)pos warriorNum:(NSInteger)p_num 
          strength:(NSInteger)pStrength power:(NSInteger)pPower 
         intellect:(NSInteger)pIntellect defense:(NSInteger)pDefense 
             speed:(NSInteger)pSpeed direction:(NSInteger)pDirection 
       attackRange:(NSInteger)pAttackRange;

- (void) setWarriorNum:(NSInteger)p_num;
- (void) setSprite:(CCSprite *)p_spriteh;
- (void) setPosition:(CGPoint)p_position;
- (void) setVisibleNum:(NSInteger)p_visible;
- (void) setStrength:(NSInteger)p_strength;
- (void) setPower:(NSInteger)p_power;
- (void) setIntellect:(NSInteger)p_intellect;
- (void) setDefense:(NSInteger)p_defense;
- (void) setMoveLength:(NSInteger)p_length;
- (void) setMoveSpeed:(NSInteger)p_speed;
- (void) setMoveDriection:(NSInteger)p_direction;
- (void) setAttackRange:(NSInteger)p_range;
//- (void) setWalkAnimate:(CCAnimate *)p_walkAnimate;
- (void) setAttackAnimate:(CCAnimate *)p_attackAnimate;
//- (void) setDefenseAnimate:(CCAnimate *)p_defenseAnimate;
- (void) setDeath:(BOOL)pDeath;

- (BOOL) getDeath;
- (NSInteger) getWarriorNum;
- (CCSprite *) getSprite;
- (CGPoint) getPosition;
- (NSInteger) getVisibleNum;
- (NSInteger) getStrength;
- (NSInteger) getPower;
- (NSInteger) getIntellect;
- (NSInteger) getDefense;
- (NSInteger) getMoveLength;
- (NSInteger) getMoveSpeed;
- (NSInteger) getMoveDriection;
- (NSInteger) getAttackRange;
//- (CCAnimate *) getWalkAnimate;
- (CCAnimate *) getAttackAnimate;
//- (CCAnimate *) getDefenseAnimate;

- (void) resetVisibleNum;
- (void) plusMoveLength;
- (void) resetMoveLength;
@end