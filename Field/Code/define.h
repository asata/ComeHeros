// 타일 관련 정의
#define HALF_TILE_SIZE  24
#define TILE_SIZE       48
#define TILE_NUM        13

#define TILE_01         1
#define TILE_02         2
#define TILE_03         3
#define TILE_04         4
#define TILE_05         5
#define TILE_06         6

// 맵 관련 정의
#define MAP_SCALE       1

// 용사 관련 정의
#define WARRIOR_SIZE        64      // 용사 이미지 크기
#define WARRIOR_SCALE       0.75    // 용사 비율
#define WARRIOR_MOVE_ACTION 0.1f    // 이동 속도
#define WARRIOR_MOVE_RIGHT  YES     // 오른쪽
#define WARRIOR_MOVE_LEFT   NO      // 왼쪽

#define PLAY_MODE           YES     // 게임중
#define WAIT_MODE           NO      // 대기중

#define TOUCH               YES
#define TOUCH_MOVE          NO

#define REFRESH_DISPLAY     0.1

#define NotFound            -1

enum LayerIndex {
    kBackgroundLayer,

    kWarriorLayer
};

enum MoveDirection {
    None = 0,
    MoveLeft,
    MoveUp,
    MoveRight,
    MoveDown
};
