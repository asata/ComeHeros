#import "cocos2d.h"

@interface commonValue : NSObject {
} 

+ (commonValue *)sharedSingleton;


- (void) setTileMap:(CCTMXTiledMap*)p_map;
- (CCTMXTiledMap*) getTileMap;
- (void) setMapPosition:(CGPoint)p_point;
- (CGPoint) getMapPosition;

- (void) setDeviceSize:(CGSize)p_deviceSize;
- (CGSize) getDeviceSize;

- (void) setViewScale:(CGFloat)p_scale;
- (CGFloat) getViewScale;


@end