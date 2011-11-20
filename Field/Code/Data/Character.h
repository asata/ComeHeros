//////////////////////////////////////////////////////////////////
// Warrior에 관련된 Class                                         //
//////////////////////////////////////////////////////////////////
/***************************************************************** 
 Warrior 및 Monster 기초 정보
 *****************************************************************/
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Character : NSObject {
@private
    CCSprite    *sprite;
    CCAnimate   *attackAnimate;     // 공격 애니메이션
    CCAnimate   *deathAnimate;      // 죽는 애니메이션
    CGPoint     position;           // 현재 위치
    
    NSInteger   type;
    
    BOOL        death;
    BOOL        deathReOrder;
    
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
@property (nonatomic, retain) CCAnimate *deathAnimate;

- (id) initCharacter:(CGPoint)pos           type:(NSInteger)pType
            strength:(NSInteger)pStrength   power:(NSInteger)pPower 
           intellect:(NSInteger)pIntellect  defense:(NSInteger)pDefense 
               speed:(NSInteger)pSpeed      direction:(NSInteger)pDirection 
         attackRange:(NSInteger)pAttackRange;

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
- (void) setDeathAnimate:(CCAnimate*)pAnimate;
- (void) setDeath:(BOOL)pDeath;
- (void) setType:(NSInteger)pType;

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
- (CCAnimate*) getAttackAnimate;
- (CCAnimate*) getDeathAnimate;
- (BOOL) getDeath;
- (BOOL) getDeathReOrder;
- (NSInteger) getType;

- (void) plusMoveLength;
- (void) resetMoveLength;
- (void) changeDeathOrder;
@end