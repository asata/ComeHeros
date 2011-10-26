//////////////////////////////////////////////////////////////////
// Trap에 관련된 Class                                            //
//////////////////////////////////////////////////////////////////
/***************************************************************** 
 Trap의 종류
    함정(TILE_TRAP_CLOSE, TILE_TRAP_OPEN), 보물상자(TILE_TREASURE), 
    폭발물(TILE_EXPLOSIVE)                                
 
 함정
    일정 지능 이하인 Warrior에 대해서 발동
    함정이 열리며 Warrior를 함정에 빠뜨림
 
 보물상자
    일정 거리 안에 있는 Warrior에 대해 Demage를 입힘
 
 폭발물
    일정 거리 안에 있는 Warrior에 대해 Demage를 입힘
    다른 폭발에게도 영향을 미쳐 폭발하게 만듬
*****************************************************************/

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Trap : NSObject {
@private
    NSInteger   trapNum;        // 트랩 고유 번호
    CGPoint     position;       // 현재 위치
    CGPoint     absPosition;    // 현재 위치
    NSInteger   trapType;       // 트랩 종류
    NSInteger   demage;         // 트랩 공격력
}

- (id) initTrap:(CGPoint)pos abs:(CGPoint)abs trapNum:(NSInteger)pNum trapType:(NSInteger)pType demage:(NSInteger)pDemage;

- (void) setTrapNum:(NSInteger)pNum;
- (void) setPosition:(CGPoint)pPosition;
- (void) setABSPosition:(CGPoint)pPosition;
- (void) setTrapType:(NSInteger)pType;
- (void) setDemage:(NSInteger)pDepDemagemage;

- (NSInteger) getTrapNum;
- (CGPoint) getPosition;
- (CGPoint) getABSPosition;
- (NSInteger) getTrapType;
- (NSInteger) getDemage;

@end
