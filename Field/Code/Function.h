#import "define.h"
#import "commonValue.h"
#import "cocos2d.h"

@interface Function : NSObject
// 기타 함수
- (CGFloat) calcuationMultiTouchLength:(NSArray *)touchArray;   // 터치한 두 좌표간의 거리를 계산하여 반환
- (CGFloat) lineLength:(CGPoint)point1 point2:(CGPoint)point2;  // 두 점 사이의 거리 계산
- (CGPoint) middlePoint:(NSArray *)touchArray;                  // 터치된 두 지점 사이의 좌표값을 구함


- (BOOL) checkMoveTile:(NSInteger)x y:(NSInteger)y;
- (BOOL) positionSprite:(NSInteger)direction point1:(CGPoint)point1 point2:(CGPoint)point2;
@end
