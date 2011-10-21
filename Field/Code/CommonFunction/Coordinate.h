#import "define.h"
#import "commonValue.h"
#import "cocos2d.h"

@interface Coordinate : NSObject
// 좌표값 변환
- (CGPoint) getAbsCoordinate:(CGPoint)cocos2d;
- (CGPoint) convertTileToMap:(CGPoint)tile;
- (CGPoint) convertTileToCocoa:(CGPoint)tile;
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d;
- (CGPoint) convertTileToAbsCoordinate:(CGPoint)abs;

@end
