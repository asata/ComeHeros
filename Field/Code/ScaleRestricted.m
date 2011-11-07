//
//  ScaleRestricted.m - to facilitate double tap zoom
//  pinchzoom
//
//  Created by Casey Broich on 5/17/10.
//  Copyright 2010 Pagex. All rights reserved.
//

#import "ScaleRestricted.h"

@implementation ScaleRestricted

+(id) actionWithDuration: (ccTime) t scale:(float) s position:(CGPoint)p target: (id) trg selector:(SEL) sel {
    return [[[self alloc] initWithDuration: t scale:s position:p target:trg selector:sel] autorelease];
};

-(id) initWithDuration: (ccTime) t scale:(float) s position:(CGPoint)p target: (id) trg selector:(SEL) sel {
	
    if( !(self=[super initWithDuration: t scale:s]) ) return nil;
    endPosition = p;
    targetCallback = [trg retain];
    selector = sel;
    return self;
}

-(id) copyWithZone: (NSZone*) zone {
    CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] 
                    scale:endScaleX_ 
                    position:endPosition 
                    target:targetCallback
                    selector:selector];
    return copy;
}

-(void) startWithTarget:(id)aTarget {
	
	[super startWithTarget:aTarget];
    startPosition = [aTarget position];
    delta = ccpSub( endPosition, startPosition );
}

-(void) update: (ccTime) t {
	[target_ setScaleX: (startScaleX_ + delta.x * t ) ];
	[target_ setScaleY: (startScaleY_ + delta.y * t ) ];
}

@end


