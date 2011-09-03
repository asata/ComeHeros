#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Trap : NSObject {
@private
    NSInteger   trapNum;
    CGPoint     position;           // 현재 위치
    NSInteger   trapType;
    NSInteger   demage;
}

- (id) initTrap:(CGPoint)pos trapNum:(NSInteger)pNum trapType:(NSInteger)pType demage:(NSInteger)pDamage;

- (void) setTrapNum:(NSInteger)pNum;
- (void) setPosition:(CGPoint)pPosition;
- (void) setTrapType:(NSInteger)pType;
- (void) setDemage:(NSInteger)pDepDemagemage;

- (NSInteger) getTrapNum;
- (CGPoint) getPosition;
- (NSInteger) getTrapType;
- (NSInteger) getDemage;

@end
