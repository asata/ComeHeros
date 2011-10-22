#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "File.h"
#import "TrapHandling.h"


@interface WarriorHandling : NSObject {
    NSMutableArray  *warriorList;       // 용사 목록 List
    NSInteger       warriorNum;         // 게임 시작 후 나타난 용사의 수
    
    CCTexture2D     *texture;
    NSMutableDictionary *charInfo;
    
    NSMutableArray  *idleAnimate;
    NSMutableArray  *idleSprite;
    NSMutableArray  *fightAniFrame;
    
    unsigned int    moveTable[TILE_NUM][TILE_NUM];  // 이동 경로를 저장한 배열
    unsigned int    tMoveValue[TILE_NUM][TILE_NUM]; // 이동 경로 계산을 위한 임시 테이블
    
    TrapHandling    *trapHandling;
}

@property (nonatomic, retain) CCTexture2D   *texture;

- (id) init:(TrapHandling*)p_trapHandling;

// 용사 관련 함수
- (void) initWarrior;
- (void) loadWarriorData:(NSString *)path;
- (NSMutableArray*) getImageFrame:(NSDictionary*)wList imgList:(NSArray*)imgList; // 지정한캐릭터 이미지를 읽어들임
- (CCSprite*) createWarrior:(NSInteger)warriorType;              // 용사 생성

- (void) moveWarrior;                           // 일정 시간 간격으로 용사 이동
- (void) removeWarrior:(NSInteger)index;                    // 용사 제거
- (void) removeWarriorList:(NSMutableArray *)deleteList;    // 용사 제거
- (NSInteger) enmyFind:(Warrior*)pWarrior;                  // 적 탐지
- (BOOL) selectDirection:(Warrior *)pWarrior;               // 이동 방향 결정

- (NSInteger) warriorCount;
- (NSInteger) warriorNum;
- (Warrior*) warriorInfo:(NSInteger)index;

// 이동 경로 계산 관련 함수
- (void) initMoveValue;                                     // 이동 방향 테이블 초기화
- (void) createMoveTable;                                   // 이동 방향 계산을 위한 테이블 생성
- (void) calcuationMoveValue:(int)x y:(int)y;               // 이동방향을 계산하여 저장
- (void) calcuatioDirection:(int)x y:(int)y;                // 지정된 타일의 이동 방향을 선택

- (void) setMoveTable:(NSInteger)x y:(NSInteger)y value:(NSInteger)value;
- (NSInteger) getMoveTable:(NSInteger)x y:(NSInteger)y;
@end
