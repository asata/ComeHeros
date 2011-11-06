#import "MapDefine.h"

// 트랩의 공격 범위
#define RANGE_TREASURE      3
#define RANGE_EXPLOSIVE     2
#define DETECT_EXPLOSIVE    1

// 트랩 데미지
#define DEMAGE_TRAP         10
#define DEMAGE_BOMB         999

// 타일 설치 및 파괴시 필요한 금액
#define MONEY_DESTORY_WALL  5
#define MONEY_WARRIOR_KILL  50
#define MONEY_TRAP          50
#define MONEY_TREASURE      50
#define MONEY_EXPLOSIVE     50
#define MONEY_HOUSE         100

//#define POINT_TRAP          5
//#define POINT_TREASURE      5
//#define POINT_EXPLOSIVE     5
//#define POINT_HOUSE         1
#define POINT_MONSTER       1
#define POINT_WARRIOR_KILL  5
#define POINT_MADE_OBSTACLE 1
#define POINT_DESTORY_WALL  5

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// File Name
//#define FILE_TILE_MAP               @"sample.tmx"

#define FILE_STAGE_PLIST            @"Stage_test18.plist"
#define FILE_CHARATER_PLIST         @"coordinates-character4.plist"
#define FILE_MONSTER_PLIST          @"coordinates-monster.plist"
#define FILE_DEATH_MONSTER_PLIST    @"monster.plist"
#define FILE_TOMBSTONE_PLIST        @"dead.plist"
#define FILE_TILE_PLIST             @"tile-wall.plist"

#define FILE_CHARATER_IMG           @"texture-character.png"
#define FILE_MONSTER_IMG            @"texture-monster.png"
#define FILE_DEATH_MONSTER_IMG      @"monster.png"
#define FILE_TOMBSTONE_IMG          @"dead.png"
#define FILE_TILE_IMG               @"tile-wall.png"

#define FILE_NUMBER_IMG             @"num_and_alpa.png"
#define FILE_PAUSE_IMG              @"interface_object0001.png"
#define FILE_RESUME_IMG             @"Tile/tile-object-3.png"
#define FILE_COIN_IIMG              @"interface_object0002.png"

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 용사/몬스터 관련 정의
#define ARCHER                  0
#define FIGHTER                 1
#define MAGE                    2

#define PASS_TRAP_INTELLECT     60      // 트랩 통과 최소 지능 
#define MOVE_INTELLECT          80      // 최단 이동 경로를 선정하는데 필요한 최소 지능

#define SURVIVAL                YES
#define DEATH                   NO  

#define GAME_VICTORY            YES
#define GAME_LOSE               NO

#define WARRIOR_SIZE            32      // 용사 이미지 크기

#define REFRESH_DISPLAY_TIME    0.20f   // 화면 갱신 속도
#define WARRIOR_MOVE_ACTION     0.15f   // Sprite 이미지 전환 속도
#define CREATE_WARRIOR_TIME     1.00f   // 캐릭터 생성 속도
#define CREATE_MONSTER_TIME     3.00f   // 몬스터 생성 속도
#define DEATH_MONSTER_TIME      0.30f   // 몬스터의 죽는 애니메이션 재생 속도
#define INSTALL_TOMBSTONE_TIME  0.20f   // 묘비 설치시 애니메이션 재생 속도
#define BEAT_ENEMY_TIME         0.10f   // 공격 당할 경우
#define BOMB_FLAME_TIME         0.10f

#define WARRIOR_MOVE_LEFT       YES     // 왼쪽
#define WARRIOR_MOVE_RIGHT      NO      // 오른쪽

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 게임 화면 관련
#define MAIN_LAYER              0    
#define STAGE_LAYER             1
#define GAME_LAYER              2    
#define SCORE_LAYER             3
#define PAUSE_LAYER             4

#define PAUSE_MENU_POSITION     ccp(460, 300)   // 일시정지/재개
#define TIME_LABEL_POSITION     ccp(220, 300)   // 게임 진행 시간 표시
#define MONEY_LABEL_POSITION    ccp(20, 300)     // 현재 소지금 표시
#define COIN_IMG_POSITION       ccp(10, 307)
#define POINT_LABEL_POSITION    ccp(20, 280)     // 게임 점수 표시

#define MULTI_SCALE             0.05f           // 확대/축소 비율
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 터치 관련 정보
#define TOUCH               YES     
#define TOUCH_MOVE          NO


#define PLAY_MODE           YES     // 게임중
#define WAIT_MODE           NO      // 대기중

#define NotFound            -1

// 화면 표시 순서
enum LayerIndex {
    kBackgroundLayer    = 1,
    kTombstoneLayer     = 2,

    kMonsterLayer       = 100,
    kWarriorLayer       = 200,
    kFlameLayer         = 300,
    
    kTileMenuLayer      = 999,
    kMainMenuLayer,
    kMainLabelLayer,
    kPauseLayer,
    kResultLayer,
    kMainLayer
};

// 이동 방향 
enum MoveDirection {
    MoveNone = 0,
    MoveLeft,
    MoveUp,
    MoveRight,
    MoveDown
};

enum Direction {
    None = 0,
    Left,
    Up,
    Right,
    Down
};

enum TrapMenuDirection {
    MenuNone = 0,
    MenuDefault,
    MenuLeft,
    MenuRigtht,
    MenuUp,
    MenuDown
} TrapMenuDirection;