//////////////////////////////////////////////////////////////////
// Monster가 나타나는 House에 관련된 Class                           //
//////////////////////////////////////////////////////////////////

#import "House.h"

@implementation House

- (id)init {
    if (self = [super init]) {
        position = ccp(0, 0);       // 집의 위치
        houseNum = 0;               // 집의 고유 번호
        houseType = 0;              // 집의 종류
        madeMonsterNum = 0;         // 만든 Monster의 수
        maxiumMapNum = 0;
        maxiumTotalNum = 0;
        moveDirection = MoveNone;
    }
    
    return self;
}

- (id)init:(CGPoint)pos houseNum:(NSInteger)pNum houseType:(NSInteger)pType maxiumMapNum:(NSInteger)pMapMaxium 
maxiumTotalNum:(NSInteger)pTotalpMaxium moveDirection:(NSInteger)pDirection {
    if (self = [super init]) {
        position = pos;       // 집의 위치
        houseNum = pNum;       // 집의 고유 번호
        houseType = pType;      // 집의 종류
        maxiumMapNum = pMapMaxium;
        maxiumTotalNum = pTotalpMaxium;
        moveDirection = pDirection;
    }
    
    totalMonsterNum = 0;
    madeMonsterNum = 0;
    
    return self;
}

- (void) setPosition:(CGPoint)pos {
    position = pos;
}
- (void) setHouseNum:(NSInteger)pNum {
    houseNum = pNum;
}
- (void) setHouseType:(NSInteger)pType {
    houseType = pType;
}
- (void) setMadeMonsterNum:(NSInteger)pMadeNum {
    madeMonsterNum = pMadeNum;
}
- (void) setTotalMonsterNum:(NSInteger)pMadeNum {
    totalMonsterNum = pMadeNum;
}
- (void) setMaxiumMapNum:(NSInteger)pMadeNum {
    maxiumMapNum = pMadeNum;
}
- (void) setMaxiumTotalNum:(NSInteger)pMadeNum {
    maxiumTotalNum = pMadeNum;
}
- (void) setMoveDirection:(NSInteger)pDirection {
    moveDirection = pDirection;
}

- (CGPoint) getPosition {
    return position;
}
- (NSInteger) getHouseNum {
    return houseNum;
}
- (NSInteger) getHouseType {
    return houseType;
}
- (NSInteger) getMadeMonsterNum {
    return madeMonsterNum;
}
- (NSInteger) getTotalMonsterNum {
    return totalMonsterNum;
}
- (NSInteger) getMaxiumMapNum {
    return maxiumMapNum;
}
- (NSInteger) getMaxiumTotalNum {
    return maxiumTotalNum;
}
- (NSInteger) getMoveDirection {
    return moveDirection;
}

- (void) pluseMadeNum {
    madeMonsterNum += 1;
    totalMonsterNum += 1;
}
- (void) minusMadeNum {
    madeMonsterNum -= 1;
}
@end
