#import "cocos2d.h"
#import "define.h"
#import "Warrior.h"
#import "Trap.h"

CGSize deviceSize;

// 메인 화면
@interface MainLayer : CCLayer {
    
}

- (void) menuCallBack:(id) sender;
@end



// 게임 화면
@interface playMap : CCLayer {
    CCTMXTiledMap   *map;               // 타일 맵
    CCTexture2D     *texture;           // 용사 Image
    CCTMXLayer      *layer;             // 게임 레이어 정보 저장
    
    /////////////////////////////////////////////////////////
    // 게임 관련 변수 Start                                   //
    /////////////////////////////////////////////////////////
    CGSize          mapSize;            // 타일 맵 사이즈
    CGFloat         viewScale;          // 화면 확대/축소 비율
    
    // 터치 관련 변수
    CGPoint         prevPoint;          // 이전 터치 위치
    CGFloat         prevMultiLength;    // 이전 멀티 터치
    BOOL            touchType;          // 터치 상태(YES : 터치, NO : 이동)
    BOOL            gameFlag;           // 게임 진행 상황 (YES : 진행중, NO : 대기) - 현재 미사용
    
    CGPoint         startPoint;         // 용사 시작지점
    CGPoint         destinationPoint;   // 용사 도착지점
        
    NSMutableArray  *warriorList;       // 용사 목록 List
    NSMutableArray  *trapList;          // 트랩 List
    
    NSInteger       warriorNum;         // 게임 시작 후 나타난 용사의 수
    NSInteger       trapNum;            // 게임 시작 후 설치한 트랩의 수
    
    // 맵 관련 변수
    unsigned int    mapInfo[TILE_NUM][TILE_NUM];    // 타일맵에 설치된 타일 정보
    unsigned int    moveTable[TILE_NUM][TILE_NUM];  // 이동 경로를 저장한 배열
    unsigned int    tMoveValue[TILE_NUM][TILE_NUM]; // 이동 경로 계산을 위한 임시 테이블
    /////////////////////////////////////////////////////////
    // 게임 관련 변수 End                                     //
    /////////////////////////////////////////////////////////
}

@property (nonatomic, retain) CCTMXTiledMap *map;
@property (nonatomic, retain) CCTexture2D   *texture;
@property (nonatomic, retain) CCSprite      *sprite;
@property (nonatomic, retain) CCTMXLayer    *layer;

// 게임 초기화
- (id)init:(NSInteger)p_level degree:(NSInteger)p_degree;

// 맵 초기화
- (void) initMap;

// 이동 경로 관련 함수
- (void) initMoveValue;                             // 이동 방향 테이블 초기화
- (void) createMoveTable;                           // 이동 방향 계산을 위한 테이블 생성
- (BOOL) selectDirection:(Warrior *)pWarrior;       // 이동 방향 결정
- (void) calcuationMoveValue:(int)x y:(int)y;       // 이동방향을 계산하여 저장
- (void) choseDirection:(int)x y:(int)y;            // 지정된 타일의 이동 방향을 선택

// 좌표값 변환
- (CGPoint) convertMapToTile:(CGPoint)tile;
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d;
- (CGPoint) convertTileToCocoa:(CGPoint)tile;
- (CGPoint) getAbsCoordinate:(CGPoint)cocos2d;

// 화면을 터치하여 이동시 처리하는 함수
- (void) moveTouchMap:(CGPoint)currentPoint;        // 터치로 화면 이동시 맵 이동
- (void) moveTouchWarrior;                          // 터치로 화면 이동시 용사 이동
- (CGPoint) checkMovePosition:(CGPoint)position;

// 용사 관련 함수
- (void) createWarrior;                             // 용사 생성
- (void) createWarriorAtTime:(id) sender;           // 일정 시간 간격으로 용사 생성
- (void) moveWarrior:(id) sender;                   // 일정 시간 간격으로 용사 이동
- (void) removeWarrior:(NSInteger)index;            // 용사 제거
- (NSInteger) AttackEnmyFind:(Warrior*)pWarrior;    // 적 탐지

- (CGFloat) calcuationMultiTouchLength:(NSArray *)touchArray;
- (CGFloat) lineLength:(CGPoint)point1 point2:(CGPoint)point2;
- (CGPoint) middlePoint:(NSArray *)touchArray;

- (NSString *) createFilePath;
- (void) loadValueData:(NSString *)path;
//////////////////////////////////////////////
// 이하 테스트용 코드 => Temp.txt에 이동
//- (void) printSprite:(CGPoint)thisArea;
@end