#import "Monster.h"

@implementation Monster
@synthesize sprite;
@synthesize attackAnimate, defenseAnimate;

//////////////////////////////////////////////////////////////////////////
// 몬스터 초기화 Start                                                      //
//////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}
- (id) initWarrior:(CGPoint)pos 
        monsterNum:(NSInteger)p_num 
          strength:(NSInteger)pStrength 
             power:(NSInteger)pPower 
         intellect:(NSInteger)pIntellect 
           defense:(NSInteger)pDefense 
             speed:(NSInteger)pSpeed 
         direction:(NSInteger)pDirection 
       attackRange:(NSInteger)pAttackRange {
    if ((self = [super init])) {
        monsterNum = p_num;
        position = pos;
        strength = pStrength;
        power = pPower;
        intellect = pIntellect;
        defense = pDefense;
        
        moveLength = 0;
        moveSpeed = pSpeed;
        moveDirection = pDirection;
        attackRange = pAttackRange;
    }
    
    return self;
}
//////////////////////////////////////////////////////////////////////////
// 몬스터 초기화 End                                                        //
//////////////////////////////////////////////////////////////////////////

@end
