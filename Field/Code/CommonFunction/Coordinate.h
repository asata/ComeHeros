#import "define.h"
#import "commonValue.h"
#import "cocos2d.h"

@interface Coordinate : NSObject
- (CGPoint) convertTileToMap:(CGPoint)tile;
- (CGPoint) convertAbsCoordinateToTile:(CGPoint)abs;
// 좌표값 변환
- (CGPoint) getAbsCoordinate:(CGPoint)cocos2d;
- (CGPoint) convertTileToCocoa:(CGPoint)tile;
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d;
- (CGPoint) convertTileToCocos2d:(CGPoint)tile;

@end
