#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Warrior : NSObject {
@private
    CCSprite    *leftSprite;
    CCSprite    *rightSprite;
    CGPoint     position;
    NSInteger   strength;         // 체력
    NSInteger   moveSpeed;        // 이동 속도
    NSInteger   moveDirection;    // 이동 방향
}

@property (nonatomic, retain) CCSprite *leftSprite;
@property (nonatomic, retain) CCSprite *rightSprite;

- (void) setLeftSprite:(CCSprite *)p_spriteh;
- (void) setRightSprite:(CCSprite *)p_spriteh;
- (void) setPosition:(CGPoint)p_position;
- (void) setStrength:(NSInteger)p_strength;
- (void) setMoveSpeed:(NSInteger)p_speed;
- (void) setMoveDriection:(NSInteger)p_direction;

- (CCSprite *) getLeftSprite;
- (CCSprite *) getRightSprite;
- (CGPoint) getPosition;
- (NSInteger) getStrength;
- (NSInteger) getMoveSpeed;
- (NSInteger) getMoveDriection;
@end