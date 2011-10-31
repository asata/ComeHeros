#import "HouseHandling.h"

@implementation HouseHandling

- (id)init {
    /*if (self = [super init]) {
        // Initialization code here.
    }*/
    
    return self;
}

// 몬스터 생산 갯수 검사
- (BOOL) checkCreateMonter:(House*)tHouse {
    // 현재 출력된 몬스터의 갯수가 지정된 갯수가 초과되었는지
    // 집에서 생산 가능한 갯수가 초과 되었는지 검사
    if([tHouse getMadeMonsterNum] >= [tHouse getMaxiumMapNum] ||
       [tHouse getTotalMonsterNum] >= [tHouse getMaxiumTotalNum]) 
        return NO;
    
    return YES;
}

// 몬스터 집 추가
- (void) addHouse:(CGPoint)tPoint type:(NSInteger)tType {
    House *tHouse = [[House alloc] init:tPoint 
                               houseNum:[[commonValue sharedSingleton] getHouseNum] 
                              houseType:tType 
                           maxiumMapNum:1
                         maxiumTotalNum:7
                          moveDirection:MoveRight];
    
    [[commonValue sharedSingleton] addHouseList:tHouse];
    [[commonValue sharedSingleton] plusHouseNum];
}


@end
