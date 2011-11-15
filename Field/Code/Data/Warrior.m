//////////////////////////////////////////////////////////////////
// Warrior에 관련된 Class                                         //
//////////////////////////////////////////////////////////////////
#import "Warrior.h"
#import "define.h"

@implementation Warrior
@synthesize tombstone;

//////////////////////////////////////////////////////////////////////////
// 용사 초기화 Start                                                      //
//////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}
- (id) initWarrior:(CGPoint)pos 
        warriorNum:(NSInteger)p_num 
          strength:(NSInteger)pStrength 
             power:(NSInteger)pPower 
         intellect:(NSInteger)pIntellect 
           defense:(NSInteger)pDefense 
             speed:(NSInteger)pSpeed 
         direction:(NSInteger)pDirection 
       attackRange:(NSInteger)pAttackRange {
    if ((self = [super init])) {
        [super initCharacter:pos 
                    strength:pStrength 
                       power:pPower 
                   intellect:pIntellect 
                     defense:pDefense 
                       speed:pSpeed 
                   direction:pDirection 
                 attackRange:pAttackRange];
    }
    warriorNum = p_num;
    
    return self;
}
//////////////////////////////////////////////////////////////////////////
// 용사 초기화 End                                                        //
//////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////
// 용사 기초 정보 Start                                                    //
//////////////////////////////////////////////////////////////////////////
// 용사 고유 번호
- (void) setWarriorNum:(NSInteger)p_num {
    warriorNum = p_num;
}
- (NSInteger) getWarriorNum {
    return warriorNum;
}
//////////////////////////////////////////////////////////////////////////
// 용사 기초 정보 End                                                      //
//////////////////////////////////////////////////////////////////////////
@end
