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
        moveDirection = MoveNone;
    }
    
    return self;
}

- (id)init:(CGPoint)pos houseNum:(NSInteger)pNum houseType:(NSInteger)pType 
madeMonsterNum:(NSInteger)pMadeNum maxiumMonsterNum:(NSInteger)pMaxium moveDirection:(NSInteger)pDirection {
    if (self = [super init]) {
        position = pos;       // 집의 위치
        houseNum = pNum;       // 집의 고유 번호
        houseType = pType;      // 집의 종류
        madeMonsterNum = pMadeNum; // 만든 Monster의 수
        maxiumMonsterNum = pMaxium;
        moveDirection = pDirection;
    }
    
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
- (void) setMaxiumMonsterNum:(NSInteger)pMadeNum {
    maxiumMonsterNum = pMadeNum;
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
- (NSInteger) getMaxiumMonsterNum {
    return maxiumMonsterNum;
}
- (NSInteger) getMoveDirection {
    return moveDirection;
}

- (void) pluseMadeNum {
    madeMonsterNum += 1;
}
- (void) minusMadeNum {
    madeMonsterNum -= 1;
}
@end
