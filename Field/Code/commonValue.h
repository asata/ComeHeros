#import "cocos2d.h"
#import "define.h"

@interface commonValue : NSObject {
} 

+ (commonValue *)sharedSingleton;


- (void) setTileMap:(CCTMXTiledMap*)p_map;
- (CCTMXTiledMap*) getTileMap;
- (void) setMapPosition:(CGPoint)p_point;
- (CGPoint) getMapPosition;
- (void) initMapInfo:(unsigned int **)p_info;
- (void) setMapInfo:(NSInteger)x y:(NSInteger)y tileType:(NSInteger)tileType;
- (unsigned int) getMapInfo:(NSInteger)x y:(NSInteger)y;

- (void) setDeviceSize:(CGSize)p_deviceSize;
- (CGSize) getDeviceSize;

- (void) setViewScale:(CGFloat)p_scale;
- (CGFloat) getViewScale;

- (void) setStartPoint:(CGPoint)p_point;
- (CGPoint) getStartPoint;

- (void) setEndPoint:(CGPoint)p_point;
- (CGPoint) getEndPoint;

- (void) setStageWarriorCount:(NSInteger)count;
- (NSInteger) getStageWarriorCount;
@end