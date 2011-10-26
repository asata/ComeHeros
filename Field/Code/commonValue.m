#import "commonValue.h"

static CCTMXTiledMap    *map;                           // 타일 맵
static CGSize           deviceSize;                     // 디바이스의 크기
static CGFloat          viewScale;                      // 화면 확대/축소 비율
static unsigned int     mapInfo[TILE_NUM][TILE_NUM];    // 타일맵에 설치된 타일 정보

static CGPoint         startPoint;                      // 용사 시작지점
static CGPoint         destinationPoint;                // 용사 도착지점

static NSInteger        stageWarriorCount;

static NSMutableArray   *trapList;          // 트랩 List
static NSInteger        trapNum;            // 게임 시작 후 설치한 트랩의 수
static NSMutableArray   *warriorList;       // 용사 목록 List
static NSInteger        warriorNum;         // 게임 시작 후 나타난 용사의 수
static NSMutableArray   *monsterList;       // 몬스터 목록 List
static NSInteger        monsterNum;         // 게임 시작 후 나타난 몬스터의 수
static NSMutableArray   *houseList;         // 용사 집 List
static NSInteger        houseNum;           // 게임 시작 후 나타난 잡의 수


static commonValue      * _globalTest = nil;

@implementation commonValue

+(commonValue *)sharedSingleton
{
    @synchronized([commonValue class])
    {
        if (!_globalTest)        
            [[self alloc] init];
        
        return _globalTest;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([commonValue class])
    {
        NSAssert(_globalTest == nil, @"Attempted to allocate a second instance of a singleton.");
        _globalTest = [super alloc];
        return _globalTest;
    }
    
    return nil;
}

- (void) initCommonValue {
    trapList    = [[NSMutableArray alloc] init];
    warriorList = [[NSMutableArray alloc] init];
    monsterList = [[NSMutableArray alloc] init];
    houseList   = [[NSMutableArray alloc] init];   
    
    trapNum     = 0;
    warriorNum  = 0;
    monsterNum  = 0;
    houseNum    = 0;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) setWarriorList:(NSMutableArray*)pList {
    warriorList = pList;
}
- (void) addWarrior:(Warrior*)pWarrior {
    [warriorList addObject:pWarrior];
}
- (void) replaceWarrior:(NSInteger)index pWarrior:(Warrior*)pWarrior {
    [warriorList replaceObjectAtIndex:index withObject:pWarrior];
}
- (NSMutableArray*) getWarriorList {
    return warriorList;
}
- (Warrior*) getWarriorListAtIndex:(NSInteger)index {
    return [warriorList objectAtIndex:index];
}
- (NSInteger) warriorListCount {
    return [warriorList count];
}
- (void) removeWarriorAtIndex:(NSInteger)index {
    [warriorList removeObjectAtIndex:index];
}
- (void) removeWarrior:(Warrior*)pWarrior {
    [warriorList removeObject:pWarrior];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) setMonsterList:(NSMutableArray*)pList {
    monsterList = pList;
}
- (void) addMonster:(Monster*)pMonster {
    [monsterList addObject:pMonster];
}
- (NSMutableArray*) getMonsterList {
    return monsterList;
}
- (Monster*) getMonsterListAtIndex:(NSInteger)index {
    return [monsterList objectAtIndex:index];
}
- (NSInteger) monsterListCount {
    return [monsterList count];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) setTrapList:(NSMutableArray*)pList {
    trapList = pList;
}
- (void) addTrap:(Trap*)pTrap {
    [trapList addObject:pTrap];
}
- (NSMutableArray*) getTrapList {
    return trapList;
}
- (Trap*) getTrapListAtIndex:(NSInteger)index {
    return [trapList objectAtIndex:index];
}
- (NSInteger) trapListCount {
    return [trapList count];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) setHouseList:(NSMutableArray*)pList {
    houseList = pList;
}
- (NSMutableArray*) getHouseList {
    return houseList;
}
- (void) addHouseList:(House*)pHouse {
    [houseList addObject:pHouse];
}
- (NSInteger) houseListCount {
    return [houseList count];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 타일맵 관련
- (void) setTileMap:(CCTMXTiledMap*)p_map {
    map = p_map;
}
- (CCTMXTiledMap*) getTileMap {
    return map;
}
// 타일맵 좌표 관련
- (void) setMapPosition:(CGPoint)p_point {
    map.position = p_point;
}
- (CGPoint) getMapPosition {
    return map.position;
}
- (void) initMapInfo:(unsigned int **)p_info {
    int i, j;
    
    for(i = 0; i < TILE_NUM; i++) {
        for (j = 0; j < TILE_NUM; j++) {
            mapInfo[i][j] = p_info[i][j];
        }
    }
}
- (void) setMapInfo:(NSInteger)x y:(NSInteger)y tileType:(NSInteger)tileType {
    mapInfo[x][y] = tileType;
}
- (unsigned int) getMapInfo:(NSInteger)x y:(NSInteger)y {
    return mapInfo[x][y];
}

// 디바이스 크기 
- (void) setDeviceSize:(CGSize)p_deviceSize {
    deviceSize = p_deviceSize;
}
- (CGSize) getDeviceSize {
    return deviceSize;
}

// 확대/축소 비율
- (void) setViewScale:(CGFloat)p_scale {
    viewScale = p_scale;
}
- (CGFloat) getViewScale {
    return viewScale;
}

// 시작 지점 좌표
- (void) setStartPoint:(CGPoint)p_point {
    startPoint = p_point;
}
- (CGPoint) getStartPoint {
    return startPoint;
}

// 도착 지점 좌표
- (void) setEndPoint:(CGPoint)p_point {
    destinationPoint = p_point;
}
- (CGPoint) getEndPoint {
    return destinationPoint;
}

// 스테이지에 나올 총 캐릭터 수
- (void) setStageWarriorCount:(NSInteger)count {
    stageWarriorCount = count;
}
- (NSInteger) getStageWarriorCount {
    return stageWarriorCount;
}


- (void) plusTrapNum {
    trapNum += 1;
}
- (void) plusWarriorNum {
    warriorNum += 1;
}
- (void) plusMonsterNum {
    monsterNum += 1;
}
- (void) plusHouseNum {
    houseNum += 1;
}
- (NSInteger) getTrapNum {
    return trapNum;
}
- (NSInteger) getWarriorNum {
    return warriorNum;
}
- (NSInteger) getMonsterNum {
    return monsterNum;
}
- (NSInteger) getHouseNum {
    return houseNum;
}

@end
