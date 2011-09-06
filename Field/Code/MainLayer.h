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
    CCTMXTiledMap *map;             // 타일 맵
    CCTexture2D *texture;           // 용사 Image
    
    CCTMXLayer *layer;
    
    NSInteger warriorNum;
    NSInteger trapNum;
    
    ////////////////////////////
    NSMutableArray  *warriorList;   // 용사 목록 List
    NSMutableArray  *trapList;      // 트랩 List
    ////////////////////////////
    
    CGSize mapSize;                 // 타일 맵 사이즈
    CGPoint prevPoint;              // 이전 터치 위치
    
    BOOL touchType;                 // 터치 상태(YES : 터치, NO : 이동)
    BOOL gameFlag;                  // 게임 진행 상황 (YES : 진행중, NO : 대기)
    
    unsigned int mapInfo[TILE_NUM][TILE_NUM];
    unsigned int moveTable[TILE_NUM][TILE_NUM];
    
    unsigned int tMoveValue[TILE_NUM][TILE_NUM];
    
    CGPoint startPoint;
    CGPoint destinationPoint;
}

@property (nonatomic, retain) CCTMXTiledMap *map;
@property (nonatomic, retain) CCTexture2D *texture;
@property (nonatomic, retain) CCSprite *sprite;

- (id)init:(NSInteger)p_level degree:(NSInteger)p_degree;

// 맵 초기화
- (void) initMap;

// 이동 경로 관련 함수
- (void) initMoveValue;
- (void) createMoveTable;
- (void) selectDirection:(Warrior *)pWarrior;
- (void) calcuationMoveValue:(int)x y:(int)y;
- (void) choseDirection:(int)x y:(int)y;

// 좌표값 변환
- (CGPoint) convertMapToTile:(CGPoint)tile;
- (CGPoint) convertCocos2dToTile:(CGPoint)cocos2d;
- (CGPoint) convertTileToCocoa:(CGPoint)tile;

// 화면을 터치하여 이동시 처리하는 함수
- (void) moveTouchMap:(CGPoint)currentPoint;
- (void) moveTouchWarrior;

// 용사 관련 함수
- (void) createWarrior;
- (void) moveWarrior:(id) sender;
- (void) removeWarrior:(NSInteger)index;
- (NSInteger) AttackEnmyFind:(Warrior*)pWarrior;    // 적 탐지


//////////////////////////////////////////////
// 이하 테스트용 코드 => Temp.txt에 이동
//- (void) printSprite:(CGPoint)thisArea;

- (void) createWarriorAtTime:(id) sender;

@property (nonatomic, retain) CCTMXLayer *layer;

@end