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
// 타일맵 좌표를 맵 좌표로 변환
- (CGPoint) convertTileToMap:(CGPoint)tile {
    CGFloat x = (TILE_SIZE * tile.x) + HALF_TILE_SIZE;
    CGFloat y = (TILE_SIZE * TILE_NUM) - (TILE_SIZE * tile.y) - HALF_TILE_SIZE;
    
    return CGPointMake(floorf(x), floorf(y));
}
// 절대 좌표 값을 타일맵 좌표로 변환
- (CGPoint) convertAbsCoordinateToTile:(CGPoint)abs {
    CGFloat x = floorf(abs.x / TILE_SIZE);
    CGFloat y = floorf(TILE_NUM - abs.y / TILE_SIZE);
    
    return CGPointMake(x, y);
}
//////////////////////////////////////////////////////////////////////////
// 좌표 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
