#import "commonValue.h"

static CCTMXTiledMap    *map;               // 타일 맵
static CGSize           deviceSize;         // 디바이스의 크기
static CGFloat          viewScale;          // 화면 확대/축소 비율

static commonValue * _globalTest = nil;

@implementation commonValue

+(commonValue *)sharedSingleton
{
    @synchronized([commonValue class])
    {
        if (!_globalTest)        
            [[self alloc] init];
        
        return _globalTest;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([commonValue class])
    {
        NSAssert(_globalTest == nil, @"Attempted to allocate a second instance of a singleton.");
        _globalTest = [super alloc];
        return _globalTest;
    }
    
    return nil;
}

- (void) setTileMap:(CCTMXTiledMap*)p_map {
    map = p_map;
}
- (CCTMXTiledMap*) getTileMap {
    return map;
}
- (void) setMapPosition:(CGPoint)p_point {
    map.position = p_point;
}
- (CGPoint) getMapPosition {
    return map.position;
}

- (void) setDeviceSize:(CGSize)p_deviceSize {
    deviceSize = p_deviceSize;
}
- (CGSize) getDeviceSize {
    return deviceSize;
}

- (void) setViewScale:(CGFloat)p_scale {
    viewScale = p_scale;
}
- (CGFloat) getViewScale {
    return viewScale;
}

@end
