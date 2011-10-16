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
    //CCTMXLayer      *layer;             // 게임 레이어 정보 저장
    
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
    
    // 게임 진행에 관련된 변수
    NSInteger       stagePoint;         // 게임 점수
    NSInteger       stageMoney;         // 게임에 필요한 돈
    NSInteger       stageTime;          // 게임 시간
    NSInteger       stageLive;          // 생명
    
    // 게임 설정 - 사용자 선택 부분
    NSInteger       stageLevel;         // 게임 레벨
    NSInteger       stageDegree;        // 게임 난이도
    
    // 게임 설정 - 설정 파일에서 로드
    NSMutableDictionary *stageInfo;
    CGPoint         startPoint;         // 용사 시작지점
    CGPoint         destinationPoint;   // 용사 도착지점
    NSInteger       wCount;             // 해당 스테이지의 총 용사 수
    
    NSMutableArray  *idleAnimate;
    NSMutableArray  *idleSprite;
    NSMutableArray  *fightAniFrame;
    
    // 현재 진행중인 맵에 나타는 목록
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
- (void) loadTileMap;

// 이동 경로 계산 관련 함수
- (void) initMoveValue;                                     // 이동 방향 테이블 초기화
- (void) createMoveTable;                                   // 이동 방향 계산을 위한 테이블 생성
- (void) calcuationMoveValue:(int)x y:(int)y;               // 이동방향을 계산하여 저장
- (void) calcuatioDirection:(int)x y:(int)y;                // 지정된 타일의 이동 방향을 선택

// 화면을 터치하여 이동시 처리하는 함수
- (void) moveTouchMap:(CGPoint)currentPoint;                // 터치로 화면 이동시 맵 이동
- (void) moveTouchWarrior;                                  // 터치로 화면 이동시 용사 이동
- (CGPoint) checkMovePosition:(CGPoint)position;

// 용사 관련 함수
- (void) initWarrior;
- (void) loadWarriorData:(NSString *)path;
- (NSMutableArray*) getImageFrame:(NSDictionary*)wList imgList:(NSArray*)imgList; // 지정한캐릭터 이미지를 읽어들임
- (void) createWarrior:(NSInteger)warriorType;              // 용사 생성

- (void) createWarriorAtTime:(id) sender;                   // 일정 시간 간격으로 용사 생성
- (void) moveWarrior:(id) sender;                           // 일정 시간 간격으로 용사 이동
- (void) removeWarrior:(NSInteger)index;                    // 용사 제거
- (void) removeWarriorList:(NSMutableArray *)deleteList;    // 용사 제거
- (NSInteger) enmyFind:(Warrior*)pWarrior;                  // 적 탐지
- (BOOL) selectDirection:(Warrior *)pWarrior;               // 이동 방향 결정

// 트랩 관련 함수
- (void) initTrap;
- (void) printTrapList:(CGPoint)iPoint;
- (void) printTrap:(CGPoint)iPoint;
- (void) createTrap:(CGPoint)iPoint;                        // 트랩 설치
- (void) handlingTrap:(Warrior*)pWarrior;                   // 트랩 탐지 관련 처리
- (NSInteger) trapFind:(Warrior*)pWarrior;                  // 트랩 탐지
- (void) TreasureBox:(Warrior*)pWarrior;                    // 보물상자 처리
- (void) addTrap:(CGPoint)tPoint type:(NSInteger)tType;     // 트랩 목록에 트랩 추가

// 좌표값 변환
- (CGPoint) getAbsCoordinate:(CGPoint)cocos2d;
- (CGPoint) convertTileToMap:(CGPoint)tile;
- (CGPoint) convertTileToCocoa:(CGPoint)tile;
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d;

// 파일 처리 함수
- (NSString *) loadFilePath:(NSString *)fileName;
- (void) loadStageData:(NSString *)path;
- (NSDictionary *) loadWarriorInfo:(NSInteger)index;

// 기타 함수
- (CGFloat) calcuationMultiTouchLength:(NSArray *)touchArray;   // 터치한 두 좌표간의 거리를 계산하여 반환
- (CGFloat) lineLength:(CGPoint)point1 point2:(CGPoint)point2;  // 두 점 사이의 거리 계산
- (CGPoint) middlePoint:(NSArray *)touchArray;                  // 터치된 두 지점 사이의 좌표값을 구함
@end