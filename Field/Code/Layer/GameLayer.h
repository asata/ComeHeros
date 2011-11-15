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

#import "MainLayer.h"
#import "PauseLayer.h"
#import "ResultLayer.h"
#import "TutorialLayer.h"

#import "PinchZoomLayer.h"

// 게임 화면
@interface GameLayer : CCLayer {
    File            *file;
    Function        *function;
    TrapHandling    *trapHandling;
    WarriorHandling *warriorHandling;
    MonsterHandling *monsterHandling;
    HouseHandling   *houseHandling;
    
    PauseLayer      *pauseLayer;
    ResultLayer     *resultLayer;
    TutorialLayer   *tutorialLayer;
    
    CCMenu          *menu1;
    CCMenu          *menu2;
    CCMenu          *menu3;  
    CCMenu          *menu4;    
    NSInteger       menuPrint;
    CCMenu          *menuPause;
    
    NSMutableArray  *trapMenuList;
    
    CCLabelAtlas    *labelTime;
    CCLabelAtlas    *labelMoney;
    CCLabelAtlas    *labelPoint;
    
    PinchZoomLayer  *pZoom;
    
    CGPoint         tileSetupPoint;     // 타일 설치 위치
    NSMutableArray  *chainFlameList;
    
    /////////////////////////////////////////////////////////
    // 게임 관련 변수 Start                                   //
    /////////////////////////////////////////////////////////
    CGSize          mapSize;            // 타일 맵 사이즈
    
    // 터치 관련 변수
    BOOL            touchType;          // 터치 상태(YES : 터치, NO : 이동)
    
    /////////////////////////////////////////////////////////
    // 게임 관련 변수 End                                     //
    /////////////////////////////////////////////////////////
}

- (void) initGame;
- (void) destoryGame;
- (void) initLabel;
- (void) updateLabel;
- (void) initMenu;
- (void) gamePause:(id)sender;
- (void) onPause;
- (void) resume;
- (void) Restart;
- (void) endRestart;
- (void) Quit;
- (void) endQuit;
- (void) gameEnd:(BOOL)victory;

// 맵 초기화
- (void) initMap;
- (void) loadTileMap;


// 화면을 터치하여 이동시 처리하는 함수
//- (void) moveTouchMap:(CGPoint)currentPoint;                // 터치로 화면 이동시 맵 이동
//- (void) moveTouchWarrior;                                  // 터치로 화면 이동시 용사 이동
//- (void) moveTouchMonster;
//- (CGPoint) checkMovePosition:(CGPoint)position;

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
- (void) installTrapMenuVisible:(BOOL)flag;
- (BOOL) installTileCheck:(NSInteger)tileType;
- (BOOL) installMoneyCheck:(NSInteger)money;
- (void) tileSetupExplosive:(id)sender;
- (void) tileSetupTreasure:(id)sender;
- (void) tileSetupTrap:(id)sender;
- (void) tileSetupMonsterHouse1:(id)sender;

- (CCAnimation*) loadFlameAnimation;
@end