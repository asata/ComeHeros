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

// 이동 가능한 경로인지 검사
- (BOOL) checkMoveTile:(NSInteger)x y:(NSInteger)y {
    if(x < 0) return NO;
    if(y < 0) return NO;
    if(x > TILE_NUM) return NO;
    if(y > TILE_NUM) return NO;
    
    if ([[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_WALL01 || 
        [[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_WALL10 || 
        [[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_TREASURE ||
        [[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_EXPLOSIVE)
        return NO;
    
    return YES;
}

// 공격을 할 수 있는 대상인지 검사
// direction    : 공격자의 이동 방향
// point1       : 공격 대상의 위치
// point2       : 공격자 위치
- (BOOL) positionSprite:(NSInteger)direction point1:(CGPoint)point1 point2:(CGPoint)point2 {
    if (direction == MoveUp || direction == MoveDown) return YES;
    else if (direction == MoveLeft) {
        if (point1.x < point2.x) return YES;
        else return NO;
    } else if (direction == MoveRight) {
        if (point1.x > point2.x) return YES;
        else return NO;
    }

    return NO;
}

// point1       : 공격 대상의 위치
// point2       : 공격자 위치
- (BOOL) attackDirection:(CGPoint)point1 point2:(CGPoint)point2 {
    if(point1.x < point2.x) return WARRIOR_MOVE_LEFT;
    else return WARRIOR_MOVE_RIGHT;
    
    return WARRIOR_MOVE_RIGHT;
}
//////////////////////////////////////////////////////////////////////////
// 기타 함수 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
