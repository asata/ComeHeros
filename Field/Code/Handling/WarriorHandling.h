#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "File.h"
#import "TrapHandling.h"

@interface WarriorHandling : NSObject {
    unsigned int    moveTable[TILE_NUM][TILE_NUM];  // 이동 경로를 저장한 배열
    unsigned int    tMoveValue[TILE_NUM][TILE_NUM]; // 이동 경로 계산을 위한 임시 테이블
    
    TrapHandling    *trapHandling;
}

@property (nonatomic, retain) CCTexture2D   *texture;

- (id) init:(TrapHandling*)p_trapHandling;

// 용사 관련 함수
- (CCSprite*) createWarrior:(NSDictionary*)wInfo;           // 용사 생성

- (CCSpriteFrame*) loadWarriorSprite:(NSString*)spriteName;
- (CCAnimation*) loadWarriorWalk:(NSString*)spriteName;
- (CCAnimation*) loadWarriorAttack:(NSString*)spriteName;

- (void) moveWarrior;                                       // 일정 시간 간격으로 용사 이동
- (void) attackCompleteHandler;
- (void) removeWarrior:(NSInteger)index;                    // 용사 제거
- (void) removeWarriorList:(NSMutableArray *)deleteList;    // 용사 제거
- (NSInteger) enmyFind:(Warrior*)pWarrior;                  // 적 탐지

- (BOOL) selectShortDirection:(Warrior *)pWarrior;          // 이동 방향 결정
- (BOOL) selectDirection:(Warrior *)pWarrior;               // 이동 방향 결정

// 이동 경로 계산 관련 함수
- (void) initMoveValue;                                     // 이동 방향 테이블 초기화
- (BOOL) checkConnectRoad;
- (void) createMoveTable;                                   // 이동 방향 계산을 위한 테이블 생성
- (void) calcuationMoveValue:(int)x y:(int)y;               // 이동방향을 계산하여 저장
- (void) calcuatioDirection:(int)x y:(int)y;                // 지정된 타일의 이동 방향을 선택

- (void) setMoveTable:(NSInteger)x y:(NSInteger)y value:(NSInteger)value;
- (NSInteger) getMoveTable:(NSInteger)x y:(NSInteger)y;
@end
