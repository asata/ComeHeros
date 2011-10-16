#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Warrior : NSObject {
@private
    NSInteger   warriorNum;
    CCSprite    *sprite;
    CCAnimate   *attackAnimate;     // 공격 애니메이션
    CCAnimate   *defenseAnimate;    // 방어 애니메이션
    CGPoint     position;           // 현재 위치
    
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
@property (nonatomic, retain) CCAnimate *attackAnimate;
@property (nonatomic, retain) CCAnimate *defenseAnimate;

- (id) initWarrior:(CGPoint)pos warriorNum:(NSInteger)p_num 
          strength:(NSInteger)pStrength power:(NSInteger)pPower 
         intellect:(NSInteger)pIntellect defense:(NSInteger)pDefense 
             speed:(NSInteger)pSpeed direction:(NSInteger)pDirection 
       attackRange:(NSInteger)pAttackRange;

- (void) setWarriorNum:(NSInteger)p_num;
- (void) setSprite:(CCSprite *)p_spriteh;
- (void) setPosition:(CGPoint)p_position;
- (void) setStrength:(NSInteger)p_strength;
- (void) setPower:(NSInteger)p_power;
- (void) setIntellect:(NSInteger)p_intellect;
- (void) setDefense:(NSInteger)p_defense;
- (void) setMoveLength:(NSInteger)p_length;
- (void) setMoveSpeed:(NSInteger)p_speed;
- (void) setMoveDriection:(NSInteger)p_direction;
- (void) setAttackRange:(NSInteger)p_range;
- (void) setAttackAnimate:(CCAnimate *)p_attackAnimate;
- (void) setDefenseAnimate:(CCAnimate *)p_defenseAnimate;

- (NSInteger) getWarriorNum;
- (CCSprite *) getSprite;
- (CGPoint) getPosition;
- (NSInteger) getStrength;
- (NSInteger) getPower;
- (NSInteger) getIntellect;
- (NSInteger) getDefense;
- (NSInteger) getMoveLength;
- (NSInteger) getMoveSpeed;
- (NSInteger) getMoveDriection;
- (NSInteger) getAttackRange;
- (CCAnimate *) getAttackAnimate;
- (CCAnimate *) getDefenseAnimate;

- (void) plusMoveLength;
- (void) resetMoveLength;
@end