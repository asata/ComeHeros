//////////////////////////////////////////////////////////////////
// Warrior에 관련된 Class                                         //
//////////////////////////////////////////////////////////////////
#import "Warrior.h"
#import "define.h"

@implementation Warrior

//////////////////////////////////////////////////////////////////////////
// 용사 초기화 Start                                                      //
//////////////////////////////////////////////////////////////////////////
- (id)init {
    if ((self = [super init])) {
    }
    
    return self;
}
- (id) initWarrior:(CGPoint)pos 
              type:(NSInteger)pType
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
                        type:pType
                    strength:pStrength 
                       power:pPower 
                   intellect:pIntellect 
                     defense:pDefense 
                       speed:pSpeed 
                   direction:pDirection 
                 attackRange:pAttackRange];
    }
    
    warriorNum  = p_num;
    moveList    = [[NSMutableArray alloc] init];
    
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

- (void) pushMoveList:(CGPoint)point {
    if ([moveList count] >= MOVE_LIST_ARRAY) {
        [self popMoveList];
    }
    
    CCSprite *temp = [[CCSprite alloc] init];
    [temp setPosition:point];
    
    [moveList addObject:temp];
}
- (CGPoint) popMoveList {
    if ([moveList count] <= 0) return ccp(-1, -1);
    
    CCSprite *temp = [moveList objectAtIndex:0];
    [moveList removeObjectAtIndex:0];
    
    return [temp position];
}
- (CGPoint) getMoveList:(NSInteger)index {
    if ([moveList count] <= 0 || index > MOVE_LIST_ARRAY) return ccp(-1, -1);

    CCSprite *temp = [moveList objectAtIndex:index];
    
    return [temp position];
}
- (NSInteger) valueOfMoveRoad:(CGPoint)point {
    NSInteger value = 0;
    NSInteger count = 0;
    NSInteger index = 0;
    
    for (CCSprite *temp in moveList) {
        if ([temp position].x == point.x && [temp position].y == point.y) {
            value = index;
            count++;
        }
        
        index++;
    }
    
    NSInteger result = 100;
    if (count != 0) {
        result = value / count;
    }
    
    return result;
}
- (NSInteger) countMoveList {
    return [moveList count];
}
- (void) removeAllMoveList {
    [moveList removeAllObjects];
}

@end
