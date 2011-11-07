//
//  ScaleRestricted.h - to facilitate double tap zoom
//  pinchzoom
//
//  Created by Casey Broich on 5/17/10.
//  Copyright 2010 Pagex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScaleRestricted : CCScaleTo {
    CGPoint endPosition;
    CGPoint startPosition;
    CGPoint delta;
    id targetCallback;
    SEL selector;
}

+(id) actionWithDuration: (ccTime) t scale:(float) s position:(CGPoint)p target: (id) trg selector:(SEL) s;
-(id) initWithDuration: (ccTime) t scale:(float) s position:(CGPoint)p target: (id) trg selector:(SEL) s;

@end


