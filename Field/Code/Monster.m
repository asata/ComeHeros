//////////////////////////////////////////////////////////////////
// Monster에 관련된 Class                                         //
//////////////////////////////////////////////////////////////////
#import "Monster.h"

@implementation Monster

//////////////////////////////////////////////////////////////////////////
// 몬스터 초기화 Start                                                      //
//////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}
- (id) initMonster:(CGPoint)pos 
        monsterNum:(NSInteger)p_num 
          strength:(NSInteger)pStrength 
             power:(NSInteger)pPower 
         intellect:(NSInteger)pIntellect 
           defense:(NSInteger)pDefense 
             speed:(NSInteger)pSpeed 
         direction:(NSInteger)pDirection 
       attackRange:(NSInteger)pAttackRange 
          houseNum:(NSInteger)pHouse
{
    if ((self = [super init])) {
        [super initWarrior:pos 
                warriorNum:p_num 
                  strength:pStrength 
                     power:pPower 
                 intellect:pIntellect 
                   defense:pDefense
                     speed:pSpeed 
                 direction:pDirection 
               attackRange:pAttackRange];
        
        houseNum = pHouse;
    }
    
    return self;
}
//////////////////////////////////////////////////////////////////////////
// 몬스터 초기화 End                                                        //
//////////////////////////////////////////////////////////////////////////

@end
