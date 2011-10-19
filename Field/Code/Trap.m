#import "Trap.h"

@implementation Trap

- (id) initTrap:(CGPoint)pos abs:(CGPoint)abs trapNum:(NSInteger)pNum trapType:(NSInteger)pType demage:(NSInteger)pDemage {
    if (self = [super init]) {
        trapNum = pNum;
        position = pos;
        absPosition = abs;
        trapType = pType;
        demage = pDemage;
    }
    
    return self;
}

- (void) setTrapNum:(NSInteger)pNum {
    trapNum = pNum;
}
- (NSInteger) getTrapNum {
    return trapNum;
}

- (void) setPosition:(CGPoint)pPosition {
    position = pPosition;
}
- (CGPoint) getPosition {
    return position;
}
- (void) setABSPosition:(CGPoint)pPosition {
    absPosition = pPosition;
}
- (CGPoint) getABSPosition {
    return absPosition;
}

- (void) setTrapType:(NSInteger)pType {
    trapType = pType;
}
- (NSInteger) getTrapType {
    return trapType;
}

- (void) setDemage:(NSInteger)pDemage {
    demage = pDemage;
}
- (NSInteger) getDemage {
    return demage;
}

@end
