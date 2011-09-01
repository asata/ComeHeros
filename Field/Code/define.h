// 타일 사이즈
#define HALF_TILE_SIZE  24
#define TILE_SIZE       48
#define TILE_NUM        13

#define WARRIOR_SIZE    64

// NPC 비율
#define NPC_SCALE 0.75
#define MAP_SCALE 1

#define NPC_MOVE_ACTION 0.1f

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
