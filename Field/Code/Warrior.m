#import "Warrior.h"

@implementation Warrior
@synthesize leftSprite, rightSprite;

- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}

- (void) setLeftSprite:(CCSprite *)p_sprite {
    leftSprite = p_sprite;
}

- (CCSprite *) getLeftSprite {
    return leftSprite;
}

- (void) setRightSprite:(CCSprite *)p_sprite {
    rightSprite = p_sprite;
}

- (CCSprite *) getRightSprite {
    return rightSprite;
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
