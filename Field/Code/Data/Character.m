//////////////////////////////////////////////////////////////////
// Warrior에 관련된 Class                                         //
//////////////////////////////////////////////////////////////////
#import "Character.h"
#import "define.h"

@implementation Character
@synthesize sprite;
//@synthesize walkAnimate, defenseAnimate;
@synthesize attackAnimate, deathAnimate;


//////////////////////////////////////////////////////////////////////////
// 용사 초기화 Start                                                      //
//////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}
- (id) initCharacter:(CGPoint)pos 
                type:(NSInteger)pType
            strength:(NSInteger)pStrength 
               power:(NSInteger)pPower 
           intellect:(NSInteger)pIntellect 
             defense:(NSInteger)pDefense 
               speed:(NSInteger)pSpeed 
           direction:(NSInteger)pDirection 
         attackRange:(NSInteger)pAttackRange {
    if ((self = [super init])) {
        position = pos;
        type = pType;
        strength = pStrength;
        power = pPower;
        intellect = pIntellect;
        defense = pDefense;
        
        moveLength = 0;
        moveSpeed = pSpeed;
        moveDirection = pDirection;
        attackRange = pAttackRange;
        
        death = SURVIVAL;
        deathReOrder = YES;
    }
    
    return self;
}
//////////////////////////////////////////////////////////////////////////
// 용사 초기화 End                                                        //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 용사 기초 정보 Start                                                    //
//////////////////////////////////////////////////////////////////////////
/*- (void) setVisibleNum:(NSInteger)p_visible {
    visibleNum = p_visible;
}
- (void) resetVisibleNum { 
    visibleNum = 0;
}
- (NSInteger) getVisibleNum {
    return visibleNum;
}*/

// 용사 캐릭터 이미지
- (void) setSprite:(CCSprite *)p_sprite {
    sprite = p_sprite;
}
- (CCSprite *) getSprite {
    return sprite;
}

// 용사 절대 위치
- (void) setPosition:(CGPoint)p_position {
    position = p_position;
}
- (CGPoint) getPosition {
    return position;
}

// 용사 공격 애니메이션
- (void) setAttackAnimate:(CCAnimate *)p_attackAnimate {
    attackAnimate = p_attackAnimate;
}
- (CCAnimate *) getAttackAnimate {
    return attackAnimate;
}

- (void) setDeathAnimate:(CCAnimate *)pAnimate {
    deathAnimate = pAnimate;
}
- (CCAnimate*) getDeathAnimate {
    return deathAnimate;
}

- (void) setDeath:(BOOL)pDeath {
    death = pDeath;
}
- (BOOL) getDeath {
    return death;
}

- (void) setType:(NSInteger)pType {
    type = pType;
}
- (NSInteger) getType {
    return type;
}
//////////////////////////////////////////////////////////////////////////
// 용사 기초 정보 End                                                      //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 용사 기초 스탯 Start                                                    //
//////////////////////////////////////////////////////////////////////////
// 용사 체력
- (void) setStrength:(NSInteger)p_strength {
    strength = p_strength;
}
- (NSInteger) getStrength {
    return strength;
}

// 힘, 공격력
- (void) setPower:(NSInteger)p_power {
    power = p_power;
}
- (NSInteger) getPower {
    return power;
}

// 지능
- (void) setIntellect:(NSInteger)p_intellect {
    intellect = p_intellect;
}
- (NSInteger) getIntellect {
    return intellect;
}

// 방어력
- (void) setDefense:(NSInteger)p_defense {
    defense = p_defense;
}
- (NSInteger) getDefense {
    return defense;
}
//////////////////////////////////////////////////////////////////////////
// 용사 기초 스탯 End                                                      //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 용사 이동 관련 Start                                                    //
//////////////////////////////////////////////////////////////////////////
// 용사 총 이동 거리
- (void) setMoveLength:(NSInteger)p_length {
    moveLength = p_length;
}
- (NSInteger) getMoveLength {
    return moveLength;
}

// 용사 이동 속도
- (void) setMoveSpeed:(NSInteger)p_speed {
    moveSpeed = p_speed;
}
- (NSInteger) getMoveSpeed {
    return moveSpeed;
}

// 용사 이동 방향
- (void) setMoveDriection:(NSInteger)p_direction {
    moveDirection = p_direction;
}
- (NSInteger) getMoveDriection {
    return moveDirection;
}

// 이동 거리 변화 기록
- (void) plusMoveLength {
    moveLength = moveLength + moveSpeed;
}
- (void) resetMoveLength {
    moveLength = 0;
}
- (void) changeDeathOrder {
    deathReOrder = !deathReOrder;
}
- (BOOL) getDeathReOrder {
    return deathReOrder;
}
//////////////////////////////////////////////////////////////////////////
// 용사 이동 관련 End                                                      //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 용사 공격 및 방어 관련 Start                                             //
//////////////////////////////////////////////////////////////////////////
// 용사 공격 범위
- (void) setAttackRange:(NSInteger)p_range {
    attackRange = p_range;
}
- (NSInteger) getAttackRange {
    return attackRange;
}

// 공격을 당할 경우 처리
- (void) attackResult:(NSInteger)p_demage {
    NSInteger result = p_demage - defense;
    
    if(result < 0) return;
    strength -= result;
}
//////////////////////////////////////////////////////////////////////////
// 용사 공격 및 방어 관련 End                                               //
//////////////////////////////////////////////////////////////////////////

@end
