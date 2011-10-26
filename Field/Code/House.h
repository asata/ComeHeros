//////////////////////////////////////////////////////////////////
// Monster가 나타나는 House에 관련된 Class                           //
//////////////////////////////////////////////////////////////////
/***************************************************************** 
 House의 종류 : TILE_MONSTER_HOUSE1                               
 
 기본 동작
    Monster를 생산 가능한 최대 수량 만큼 생산 가능
    최대치를 넘어설 경우 생산하지 않음
    House의 종류에 따라 Monster의 이동 방향이 결정됨
 *****************************************************************/
#import "cocos2d.h"
#import "define.h"
//#import "commonValue.h"

@interface House : NSObject {
@private
    CGPoint     position;       // 집의 위치
    NSInteger   houseNum;       // 집의 고유 번호
    NSInteger   houseType;      // 집의 종류
    NSInteger   madeMonsterNum; // 만든 Monster의 수
    NSInteger   moveDirection;  // 만든 Monster의 이동 방향
    NSInteger   maxiumMonsterNum;
}

- (id)init:(CGPoint)pos houseNum:(NSInteger)pNum houseType:(NSInteger)pType 
madeMonsterNum:(NSInteger)pMadeNum maxiumMonsterNum:(NSInteger)pMaxium moveDirection:(NSInteger)pDirection;

- (void) setPosition:(CGPoint)pos;
- (void) setHouseNum:(NSInteger)pNum;
- (void) setHouseType:(NSInteger)pType;
- (void) setMadeMonsterNum:(NSInteger)pMadeNum;
- (void) setMaxiumMonsterNum:(NSInteger)pMadeNum;
- (void) setMoveDirection:(NSInteger)pDirection;

- (CGPoint) getPosition;
- (NSInteger) getHouseNum;
- (NSInteger) getHouseType;
- (NSInteger) getMadeMonsterNum;
- (NSInteger) getMaxiumMonsterNum;
- (NSInteger) getMoveDirection;

- (void) pluseMadeNum;
@end
