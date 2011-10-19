#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Trap : NSObject {
@private
    NSInteger   trapNum;        // 트랩 고유 번호
    CGPoint     position;       // 현재 위치
    CGPoint     absPosition;    // 현재 위치
    NSInteger   trapType;       // 트랩 종류
    NSInteger   demage;         // 트랩 공격력
}

- (id) initTrap:(CGPoint)pos abs:(CGPoint)abs trapNum:(NSInteger)pNum trapType:(NSInteger)pType demage:(NSInteger)pDemage;

- (void) setTrapNum:(NSInteger)pNum;
- (void) setPosition:(CGPoint)pPosition;
- (void) setABSPosition:(CGPoint)pPosition;
- (void) setTrapType:(NSInteger)pType;
- (void) setDemage:(NSInteger)pDepDemagemage;

- (NSInteger) getTrapNum;
- (CGPoint) getPosition;
- (CGPoint) getABSPosition;
- (NSInteger) getTrapType;
- (NSInteger) getDemage;

@end
