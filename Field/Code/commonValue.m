#import "commonValue.h"

static CCTMXTiledMap    *map;                           // 타일 맵
static CGSize           deviceSize;                     // 디바이스의 크기
static CGFloat          viewScale;                      // 화면 확대/축소 비율
static unsigned int     mapInfo[TILE_NUM][TILE_NUM];    // 타일맵에 설치된 타일 정보
static unsigned int     moveTable[TILE_NUM][TILE_NUM];  // 이동 경로를 저장한 배열

static CGPoint          startPoint;                      // 용사 시작지점
static CGPoint          destinationPoint;                // 용사 도착지점

static NSInteger        stageWarriorCount;

static NSMutableArray   *trapList;          // 트랩 List
static NSInteger        trapNum;            // 게임 시작 후 설치한 트랩의 수
static NSMutableArray   *warriorList;       // 용사 목록 List
static NSInteger        warriorNum;         // 게임 시작 후 나타난 용사의 수
static NSMutableArray   *monsterList;       // 몬스터 목록 List
static NSInteger        monsterNum;         // 게임 시작 후 나타난 몬스터의 수
static NSMutableArray   *houseList;         // 용사 집 List
static NSInteger        houseNum;           // 게임 시작 후 나타난 잡의 수

static NSMutableArray   *flameList;         // 폭발물 폭발 후 나타날 불꽃

// 게임 진행에 관련된 변수
static NSInteger        stagePoint;          // 게임 점수
static NSInteger        stageMoney;          // 게임에 필요한 돈
static NSInteger        stageTime;           // 게임 시간
static NSInteger        stageLife;           // 생명
static NSInteger        stageLevel;          // 게임 레벨
static NSString         *mapName;
static NSDictionary     *gameData;
static NSInteger        killWarriorNum;      // 죽인 용사 수
static NSInteger        killMonsterNum;
static NSInteger        useObstacle;

static BOOL             gamePause;
static BOOL             gamePlaying;

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
    flameList   = [[NSMutableArray alloc] init];
    
    trapNum     = 0;
    warriorNum  = 0;
    monsterNum  = 0;
    houseNum    = 0;
    
    stageTime = 0;
    stagePoint = 0;
    stageMoney = 100;
    stageLife = 1;
    killWarriorNum = 0;
    killMonsterNum = 0;
    useObstacle = 0;
    
    gamePause = NO;
    gamePlaying = YES;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 게임 설정과 관련된 부분
- (void) setStageTime:(NSInteger)pTime {
    stageTime = pTime;
}
- (void) plusStageTime {
    stageTime++;
}
- (NSInteger) getStageTime {
    return stageTime;
}
- (NSString*) getStageTimeString {
    return [NSString stringWithFormat:@"%d:%d", stageTime / 60, stageTime % 60];
}

- (void) setStagePoint:(NSInteger)pPoint {
    stagePoint = pPoint;
}
- (void) plusStagePoint:(NSInteger)pPoint {
    stagePoint += pPoint;
}
- (NSInteger) getStagePoint {
    return stagePoint;
}
- (NSString*) getStagePointString {
    return [NSString stringWithFormat:@"%d", stagePoint];
}

- (void) setStageMoney:(NSInteger)pMoney {
    stageMoney = pMoney;
}
- (void) plusStageMoney:(NSInteger)pMoney {
    stageMoney += pMoney;
}
- (void) minusStageMoney:(NSInteger)pMoney {
    stageMoney -= pMoney;    
}
- (NSInteger) getStageMoney {
    return stageMoney;
}
- (NSString*) getStageMoneyString {
    return [NSString stringWithFormat:@"%d", stageMoney];
}

- (void) setStageLife:(NSInteger)pLife {
    stageLife = pLife;
}
- (NSInteger) getStageLife {
    return stageLife;
}

- (void) setStageLevel:(NSInteger)pLevel {
    stageLevel = pLevel;
}
- (NSInteger) getStageLevel {
    return stageLevel;
}

- (void) setKillWarriorNum:(NSInteger)pNum {
    killWarriorNum = pNum;
}
- (NSInteger) getKillWarriorNum {
    return killWarriorNum;
}
- (void) plusKillWarriorNum {
    killWarriorNum++;
}

- (void) setMapName:(NSString*)pName {
    mapName = pName;
}
- (NSString*) getMapName {
    return mapName;
}
- (void) setGameData:(NSDictionary*)pData {
    gameData = pData;
}
- (NSDictionary*) getGameData {
    return gameData;
}
- (void) initGameData {
    gameData = [[NSMutableDictionary alloc] init];
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
- (void) removeMonster:(Monster*)pMonster {
    [monsterList removeObject:pMonster];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) setTrapList:(NSMutableArray*)pList {
    trapList = pList;
}
- (void) addTrap:(Trap*)pTrap {
    //trapNum++;
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
- (void) removeTrap:(Trap*)pTrap {
    [trapList removeObject:pTrap];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) pushFlame:(CCSprite*)pFlame {
    [flameList addObject:pFlame];
}
- (CCSprite*) popFlame {
    if ([flameList count] <= 0) return nil;
    
    CCSprite *tSprite = [flameList objectAtIndex:0];
    [flameList removeObjectAtIndex:0];
    
    return tSprite;
}
- (NSMutableArray*) getFlameList {
    return flameList;
}
- (NSInteger) flameListCount {
    return [flameList count];
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
    //houseNum++;
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
- (void) releaseTileMap {
    [map release];
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

- (void) initMoveTable:(unsigned int **)p_info {
    int i, j;
    
    for(i = 0; i < TILE_NUM; i++) {
        for (j = 0; j < TILE_NUM; j++) {
            moveTable[i][j] = p_info[i][j];
        }
    }
}
- (void) setMoveTable:(NSInteger)x y:(NSInteger)y direction:(NSInteger)direction {
    moveTable[x][y] = direction;
}
- (unsigned int) getMoveTable:(NSInteger)x y:(NSInteger)y {
    return moveTable[x][y];
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

- (void) setGamePause:(BOOL)flag {
    gamePause = flag;
}
- (BOOL) getGamePause {
    return gamePause;
}
- (void) setGamePlaying:(BOOL)flag {
    gamePlaying = flag;
}
- (BOOL) getGamePlaying {
    return gamePlaying;
}


- (void) plusTrapNum {
    trapNum++;
}
- (void) plusWarriorNum {
    warriorNum++;
}
- (void) plusMonsterNum {
    monsterNum++;
}
- (void) plusHouseNum {
    houseNum++;
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
- (NSInteger) getObstacleNum {
    return (trapNum + houseNum);
}
- (void) plusUseObstacleNum {
    useObstacle++;
}
- (void) plusDieMonsterNum {
    killMonsterNum++;
}
- (NSInteger) getUseObstacleNum {
    return useObstacle;
}
- (NSInteger) getDieMonsterNum {
    return killMonsterNum;
}

@end
