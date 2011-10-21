#import "Function.h"

@implementation Function
//////////////////////////////////////////////////////////////////////////
// 좌표 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 터치된 좌표 값을 타일맵 좌표로 변환
// [self convertCocos2dToTile:cocos2d]
// cocos2d : cocos2d 좌표값
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d {
    // 확대/축소에 따라 비율 조정이 필요
    CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    CGSize deviceSize = [[commonValue sharedSingleton] getDeviceSize];
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    
    CGPoint cocoa = [[CCDirector sharedDirector] convertToGL:cocos2d];
    CGFloat x = (cocoa.x - mapPosition.x) / (TILE_SIZE * viewScale);
    CGFloat y = ((TILE_SIZE * TILE_NUM * viewScale) - deviceSize.height + cocos2d.y + mapPosition.y) / (TILE_SIZE * viewScale);
    
    return CGPointMake(floorf(x), floorf(y));
}

- (CGPoint) convertTileToMap:(CGPoint)tile {
    CGFloat x = (TILE_SIZE * tile.x) + 16;
    CGFloat y = (TILE_SIZE * (TILE_NUM - tile.y - 1)) + 16;
    
    return CGPointMake(floorf(x), floorf(y));
}

// 타일맵 좌표값을 코코아 좌표로 변환
// [self convertTileToCocoa:tile];
// tile : 타일맵 좌표값
//- (CGPoint) getCocoaPostion:(CGPoint)tile {
- (CGPoint) convertTileToCocoa:(CGPoint)tile {
    CCTMXTiledMap *map = [[commonValue sharedSingleton] getTileMap];
    
    CGFloat x = (tile.x + 1) * TILE_SIZE + map.position.x - (TILE_SIZE / 2);
    CGFloat y = (12 - tile.y) * TILE_SIZE + map.position.y + (TILE_SIZE / 2);
    
    return CGPointMake(floorf(x), floorf(y));
}

// 절대 좌표값 반환 - 좌상단(0, 0) 기준
- (CGPoint) getAbsCoordinate:(CGPoint)cocos2d {
    CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    CGSize deviceSize = [[commonValue sharedSingleton] getDeviceSize];
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    
    CGFloat x = (cocos2d.x - mapPosition.x) / viewScale;
    CGFloat y = ((TILE_SIZE * TILE_NUM * viewScale) - deviceSize.height + mapPosition.y + cocos2d.y) / viewScale;
    
    
    return CGPointMake(x, y);
}

- (CGPoint) convertTileToAbsCoordinate:(CGPoint)abs {
    CGFloat x = floorf(abs.x / TILE_SIZE);
    CGFloat y = floorf(TILE_NUM - abs.y / TILE_SIZE);
    
    return CGPointMake(x, y);
}
//////////////////////////////////////////////////////////////////////////
// 좌표 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////



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
