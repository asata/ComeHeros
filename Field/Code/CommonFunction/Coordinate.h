#import "define.h"
#import "commonValue.h"
#import "cocos2d.h"

@interface Coordinate : NSObject
- (CGPoint) convertTileToMap:(CGPoint)tile;
- (CGPoint) convertAbsCoordinateToTile:(CGPoint)abs;
@end
