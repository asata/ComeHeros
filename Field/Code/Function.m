#import "Function.h"

@implementation Function
//////////////////////////////////////////////////////////////////////////
// 기타 함수 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 터치한 두 좌표간의 거리를 계산하여 반환
- (CGFloat) calcuationMultiTouchLength:(NSArray *)touchArray {
    CGFloat result = 0;
    CGPoint point1;
    CGPoint point2;
    int i = 0;
    
    for (UITouch *touch in touchArray) {
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        if(i == 0) point1 = convertedLocation;
        else point2 = convertedLocation;
        
        i++;
    }
    
    result = [self lineLength:point2 point2:point1];
    
    return result;
}

// 터치된 두 지점 사이의 좌표값을 구함
- (CGPoint) middlePoint:(NSArray *)touchArray {
    CGPoint point1;
    CGPoint point2;
    int i = 0;
    
    for (UITouch *touch in touchArray) {
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        if(i == 0) point1 = convertedLocation;
        else point2 = convertedLocation;
        
        i++;
    }
    
    CGPoint result = ccp(ABS(point1.x + point2.x) / 2, ABS(point1.y + point2.y) / 2);
    
    return result;
}

// 두 점 사이의 거리 계산
- (CGFloat) lineLength:(CGPoint)point1 point2:(CGPoint)point2 {
    CGFloat x = 0;
    CGFloat y = 0;
    
    if(point1.x > point2.x) x = point1.x - point2.x;
    else x = point2.x - point1.x;
    
    if(point1.y > point2.y) y = point1.y - point2.y;
    else y = point2.y - point1.y;
    
    return (powf(x, 2) + powf(y, 2));
}
//////////////////////////////////////////////////////////////////////////
// 기타 함수 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
