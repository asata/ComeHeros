#import "Warrior.h"
#import "define.h"

@implementation Warrior
@synthesize sprite;

- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}

/*- (id) initWarrior:(CGPoint)pos strength:(NSInteger)streng speed:(NSInteger)pSpeed direction:(NSInteger)pDirection {
    if ((self = [super init])) {
        position = pos;
        strength = streng;
        moveSpeed = pSpeed;
        moveDirection = pDirection;
    }
    
    return self;
}*/
- (id) initWarrior:(CGPoint)pos 
        warriorNum:(NSInteger)p_num 
          strength:(NSInteger)pStrength 
             power:(NSInteger)pPower 
         intellect:(NSInteger)pIntellect 
           defense:(NSInteger)pDefense 
             speed:(NSInteger)pSpeed 
         direction:(NSInteger)pDirection 
       attackRange:(NSInteger)pAttackRange {
    if ((self = [super init])) {
        warriorNum = p_num;
        position = pos;//ccp(pos.x, //pos.y + 320 - (TILE_NUM * TILE_SIZE));
        strength = pStrength;
        power = pPower;
        intellect = pIntellect;
        defense = pDefense;
        
        moveLength = 0;
        moveSpeed = pSpeed;
        moveDirection = pDirection;
        attackRange = pAttackRange;
    }
    
    return self;
}

- (void) setWarriorNum:(NSInteger)p_num {
    warriorNum = p_num;
}
- (NSInteger) getWarriorNum {
    return warriorNum;
}

- (void) setSprite:(CCSprite *)p_sprite {
    sprite = p_sprite;
}
- (CCSprite *) getSprite {
    return sprite;
}

- (void) setPosition:(CGPoint)p_position {
    position = p_position;
}
- (CGPoint) getPosition {
    return position;
}

- (void) setStrength:(NSInteger)p_strength {
    strength = p_strength;
}
- (NSInteger) getStrength {
    return strength;
}

- (void) setPower:(NSInteger)p_power {
    power = p_power;
}
- (NSInteger) getPower {
    return power;
}

- (void) setIntellect:(NSInteger)p_intellect {
    intellect = p_intellect;
}
- (NSInteger) getIntellect {
    return intellect;
}

- (void) setDefense:(NSInteger)p_defense {
    defense = p_defense;
}
- (NSInteger) getDefense {
    return defense;
}

- (void) setMoveLength:(NSInteger)p_length {
    moveLength = p_length;
}
- (NSInteger) getMoveLength {
    return moveLength;
}

- (void) setMoveSpeed:(NSInteger)p_speed {
    moveSpeed = p_speed;
}
- (NSInteger) getMoveSpeed {
    return moveSpeed;
}

- (void) setMoveDriection:(NSInteger)p_direction {
    moveDirection = p_direction;
}
- (NSInteger) getMoveDriection {
    return moveDirection;
}

- (void) setAttackRange:(NSInteger)p_range {
    attackRange = p_range;
}
- (NSInteger) getAttackRange {
    return attackRange;
}

- (void) plusMoveLength {
    moveLength = moveLength + moveSpeed;
}
- (void) resetMoveLength {
    moveLength = 0;
}
@end
