//
//  Coordinate.m
//  Field
//
//  Created by Kang Jeonghun on 11. 10. 21..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate

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
@end