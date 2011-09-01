#import "Warrior.h"

@implementation Warrior
@synthesize sprite;

- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}

- (id) initWarrior:(CGPoint)pos strength:(NSInteger)streng speed:(NSInteger)pSpeed direction:(NSInteger)pDirection {
    if ((self = [super init])) {
        position = pos;
        strength = streng;
        moveSpeed = pSpeed;
        moveDirection = pDirection;
    }
    
    return self;
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

@end
