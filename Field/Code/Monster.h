#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Monster : NSObject {
@private
    NSInteger   monsterNum;
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

@end
