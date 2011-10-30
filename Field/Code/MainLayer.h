#import "cocos2d.h"
#import "commonValue.h"
#import "define.h"
#import "Function.h"
#import "Coordinate.h"
#import "House.h"
#import "Warrior.h"
#import "TrapHandling.h"
#import "WarriorHandling.h"
#import "MonsterHandling.h"
#import "HouseHandling.h"

// 메인 화면
@interface MainLayer : CCLayer {
    
}

- (void) menuCallBack:(id) sender;
@end



// 게임 화면
@interface playMap : CCLayer {
    File            *file;
    Function        *function;
    TrapHandling    *trapHandling;
    WarriorHandling *warriorHandling;
    MonsterHandling *monsterHandling;
    HouseHandling   *houseHandling;
    
    CCMenu          *menu1;
    CCMenu          *menu2;
    CCMenu          *menu3;
    
    CGPoint         tileSetupPoint;
    
    //CCTMXLayer      *layer;             // 게임 레이어 정보 저장
    
    /////////////////////////////////////////////////////////
    // 게임 관련 변수 Start                                   //
    /////////////////////////////////////////////////////////
    CGSize          mapSize;            // 타일 맵 사이즈
    
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
    
    /////////////////////////////////////////////////////////
    // 게임 관련 변수 End                                     //
    /////////////////////////////////////////////////////////
}

//@property (nonatomic, retain) CCTMXTiledMap *map;
@property (nonatomic, retain) Function          *function;
@property (nonatomic, retain) TrapHandling      *trapHandling;
@property (nonatomic, retain) WarriorHandling   *warriorHandling;
@property (nonatomic, retain) CCSprite          *sprite;
@property (nonatomic, retain) CCTMXLayer        *layer;

// 게임 초기화
- (id)init:(NSInteger)p_level degree:(NSInteger)p_degree;

// 맵 초기화
- (void) initMap;
- (void) loadTileMap;


// 화면을 터치하여 이동시 처리하는 함수
- (void) moveTouchMap:(CGPoint)currentPoint;                // 터치로 화면 이동시 맵 이동
- (void) moveTouchWarrior;                                  // 터치로 화면 이동시 용사 이동
- (void) moveTouchMonster;
- (CGPoint) checkMovePosition:(CGPoint)position;

// 용사 관련 함수
- (void) createWarrior;
- (void) createWarriorAtTime:(id) sender;
- (void) moveAction:(id) sender;

// Trap 관련 함수
- (void) addTrap:(CGPoint)point tType:(NSInteger)tType;

//
- (void) addHouse:(CGPoint)point tType:(NSInteger)tType;

// 몬스터 관련 함수
- (void) createMonsterAtTime:(id)sender;

// 트랩 설치 관련 메뉴
- (void) initTileSetupMenu;
- (BOOL) installTileCheck:(NSInteger)tileType;
- (void) tileSetupExplosive:(id)sender;
- (void) tileSetupTreasure:(id)sender;
- (void) tileSetupTrap:(id)sender;
- (void) tileSetupMonsterHouse1:(id)sender;
@end