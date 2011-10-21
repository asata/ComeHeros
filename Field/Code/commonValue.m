#import "commonValue.h"

static CCTMXTiledMap    *map;               // 타일 맵
static CGSize           deviceSize;         // 디바이스의 크기
static CGFloat          viewScale;          // 화면 확대/축소 비율
static unsigned int     mapInfo[TILE_NUM][TILE_NUM];    // 타일맵에 설치된 타일 정보
static commonValue      * _globalTest = nil;

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

// 타일맵 관련
- (void) setTileMap:(CCTMXTiledMap*)p_map {
    map = p_map;
}
- (CCTMXTiledMap*) getTileMap {
    return map;
}
// 타일맵 좌표 관련
- (void) setMapPosition:(CGPoint)p_point {
    map.position = p_point;
}
- (CGPoint) getMapPosition {
    return map.position;
}
- (void) initMapInfo:(unsigned int **)p_info {
    int i, j;
    
    for(i = 0; i < TILE_NUM; i++) {
        for (j = 0; j < TILE_NUM; j++) {
            mapInfo[i][j] = p_info[i][j];
        }
    }
}
- (void) setMapInfo:(NSInteger)x y:(NSInteger)y tileType:(NSInteger)tileType {
    mapInfo[x][y] = tileType;
}
- (unsigned int) getMapInfo:(NSInteger)x y:(NSInteger)y {
    return mapInfo[x][y];
}

// 디바이스 크기 
- (void) setDeviceSize:(CGSize)p_deviceSize {
    deviceSize = p_deviceSize;
}
- (CGSize) getDeviceSize {
    return deviceSize;
}

// 확대/축소 비율
- (void) setViewScale:(CGFloat)p_scale {
    viewScale = p_scale;
}
- (CGFloat) getViewScale {
    return viewScale;
}

@end
