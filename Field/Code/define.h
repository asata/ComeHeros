// 타일 관련 정의
#define HALF_TILE_SIZE  16
#define TILE_SIZE       32
#define TILE_NUM        100

// 맵 관련 정의
#define MAP_SCALE       4

#define TOUCH           YES
#define TOUCH_MOVE      NO

#define MULTI_SCALE     0.05f

// 용사 관련 정의
#define ARCHER          0
#define FIGHTER         1
#define MAGE            2

#define WARRIOR_SIZE            28      // 용사 이미지 크기
#define WARRIOR_SCALE           3.5     // 용사 비율

#define WARRIOR_MOVE_ACTION     0.1f    // 이동 속도
#define WARRIOR_MOVE_RIGHT      NO      // 오른쪽
#define WARRIOR_MOVE_LEFT       YES     // 왼쪽

#define TILE_NONE       0
#define TILE_WALL1      148
#define TILE_WALL2      149
#define TILE_TRAP_OPEN  150
#define TILE_TRAP_CLOSE 151
#define TILE_TREASURE   152
#define TILE_EXPLOSIVE  153
#define TILE_GROUND1    154
#define TILE_GROUND2    155

#define PLAY_MODE               YES     // 게임중
#define WAIT_MODE               NO      // 대기중


#define REFRESH_DISPLAY_TIME    0.1
#define CREATE_WARRIOR_TIME     2

#define NotFound                -1

// 추후 게임 설정 파일 로드시 파일에서 읽어들임
#define StartPoint          ccp(17, 0)
#define EndPoint            ccp(11, 7)

enum LayerIndex {
    kBackgroundLayer,

    kWarriorLayer
};

enum MoveDirection {
    MoveNone = 0,
    MoveLeft,
    MoveUp,
    MoveRight,
    MoveDown
};

