#import "HouseHandling.h"

@implementation HouseHandling

- (id)init {
    /*if (self = [super init]) {
        // Initialization code here.
    }*/
    
    return self;
}

- (void) addHouse:(CGPoint)tPoint type:(NSInteger)tType {
    House *tHouse = [[House alloc] init:tPoint 
                               houseNum:[[commonValue sharedSingleton] getHouseNum] 
                              houseType:tType 
                         madeMonsterNum:0 
                       maxiumMonsterNum:10
                          moveDirection:MoveRight];
    
    [[commonValue sharedSingleton] addHouseList:tHouse];
    [[commonValue sharedSingleton] plusHouseNum];
}

@end
