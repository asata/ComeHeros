#import "define.h"
#import "commonValue.h"
#import "House.h"

@interface HouseHandling : NSObject {
}

- (void) addHouse:(CGPoint)tPoint type:(NSInteger)tType;   
- (BOOL) checkCreateMonter:(House*)tHouse;

@end
