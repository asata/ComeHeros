// 맵 관련 정의
#define MAP_SCALE           4

#define MAP_LAYER1          @"Layer 1"
#define MAP_LAYER2          @"New Layer"

// 타일 관련 정의
#define HALF_TILE_SIZE      16
#define TILE_SIZE           32
#define TILE_NUM            100

#define TILE_NONE           0
#define TILE_WALL1          1
#define TILE_WALL2          2
#define TILE_TRAP_OPEN      3
#define TILE_TRAP_CLOSE     4
#define TILE_TREASURE       5
#define TILE_EXPLOSIVE      6
#define TILE_GROUND1        7
#define TILE_GROUND2        8
#define TILE_MONSTER_HOUSE1 9


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

// File Name
#define FILE_TILE_MAP           @"sample.tmx"
#define FILE_CHARATER_PLIST     @"coordinates-character4.plist"
#define FILE_MONSTER_PLIST      @"coordinates-monster.plist"
#define FILE_TILE_PLIST         @"coordinates-tile.plist"

#define FILE_CHARATER_IMG       @"texture-character.png"
#define FILE_MONSTER_IMG        @"texture-monster.png"
#define FILE_TILE_IMG           @"texture-tile.png"

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 용사 관련 정의
#define ARCHER              0
#define FIGHTER             1
#define MAGE                2

#define PASS_TRAP_INTELLECT 50
#define MOVE_INTELLECT      80

#define SURVIVAL            YES
#define DEATH               NO  

#define WARRIOR_SIZE        32      // 용사 이미지 크기

#define REFRESH_DISPLAY_TIME    0.20f    // 화면 갱신 속도
#define WARRIOR_MOVE_ACTION     0.08f    // Sprite 이미지 전환 속도
#define CREATE_WARRIOR_TIME     3.00f    // 캐릭터 생성 속도
#define CREATE_MONSTER_TIME     5.00f

#define WARRIOR_MOVE_LEFT       YES     // 왼쪽
#define WARRIOR_MOVE_RIGHT      NO      // 오른쪽

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
// 게임 화면 관련
#define MAIN_LAYER          0
#define GAME_LAYER          1


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////
#define TOUCH               YES
#define TOUCH_MOVE          NO

#define MULTI_SCALE         0.05f   // 확대/축소 비율

#define PLAY_MODE           YES     // 게임중
#define WAIT_MODE           NO      // 대기중



#define NotFound            -1


enum LayerIndex {
    kBackgroundLayer    = 1,

    kMonsterLayer       = 500,
    kWarriorLayer,
    
    kTileMenuLayer      = 999
};

enum MoveDirection {
    MoveNone = 0,
    MoveLeft,
    MoveUp,
    MoveRight,
    MoveDown
};


