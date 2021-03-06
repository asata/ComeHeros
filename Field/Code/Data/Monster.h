//////////////////////////////////////////////////////////////////
// Monster에 관련된 Class                                         //
//////////////////////////////////////////////////////////////////
/*****************************************************************
 * Warrior를 상속하여 구성
 Monster의 종류 : Vampire, Skeleton, Spirite                                
 
 기본 동작
     Monster House에 나와 일정한 방향으로 이동을 하며 이동 중 발견한  Warrior에
    대해서 공격을 할 수 있다. 이동 중에 자신이 나온 집에 도착을 할 경우 휴식 후 다시 
    나오게 된다.
 
 이동 방향
    좌우, 상하로만 이동
 
 Vampire    :
 Skeleton   :
 Spirite    :
 *****************************************************************/

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Character.h"

@interface Monster : Character {
@private
    NSInteger   monsterNum;
    NSInteger   houseNum;
}

- (id) initMonster:(CGPoint)pos             type:(NSInteger)pType
        monsterNum:(NSInteger)p_num         strength:(NSInteger)pStrength     
             power:(NSInteger)pPower        intellect:(NSInteger)pIntellect    
           defense:(NSInteger)pDefense      speed:(NSInteger)pSpeed     
         direction:(NSInteger)pDirection    attackRange:(NSInteger)pAttackRange  
          houseNum:(NSInteger)pHouse;

- (void) setMonsterNum:(NSInteger)pNum;
- (void) setHouseNum:(NSInteger)pHouseNum;

- (NSInteger) getMonsterNum;
- (NSInteger) getHouseNum;
@end
