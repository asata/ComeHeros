#import "cocos2d.h"
#import "define.h"
#import "Warrior.h"
#import "Trap.h"
#import "House.h"
#import "Monster.h"

@interface commonValue : NSObject {
} 

+ (commonValue *)sharedSingleton;
- (void) initCommonValue;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 스테이지 정보(시간, 점수, 돈, 생명)
- (void) setStageTime:(NSInteger)pTime;
- (void) plusStageTime;
- (NSInteger) getStageTime;
- (NSString*) getStageTimeString;

- (void) setStagePoint:(NSInteger)pPoint;
- (void) plusStagePoint:(NSInteger)pPoint;
- (NSInteger) getStagePoint;
- (NSString*) getStagePointString;

- (void) setStageMoney:(NSInteger)pMoney;
- (void) plusStageMoney:(NSInteger)pMoney;
- (void) minusStageMoney:(NSInteger)pMoney;
- (NSInteger) getStageMoney;
- (NSString*) getStageMoneyString;

- (void) setStageLife:(NSInteger)pLife;
- (NSInteger) getStageLife;

- (void) setStageLevel:(NSInteger)pLevel;
- (NSInteger) getStageLevel;

- (void) setKillWarriorNum:(NSInteger)pNum;
- (NSInteger) getKillWarriorNum;
- (void) plusKillWarriorNum;

- (void) setGamePause:(BOOL)flag;
- (BOOL) getGamePause;
- (void) setGamePlaying:(BOOL)flag;
- (BOOL) getGamePlaying;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 폭발 불꽃과 관련된 정보
- (void) pushFlame:(CCSprite*)pFlame;
- (CCSprite*) popFlame;
- (NSMutableArray*) getFlameList;
- (NSInteger) flameListCount;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 타일맵과 관련된 정보
- (void) setTileMap:(CCTMXTiledMap*)p_map;
- (CCTMXTiledMap*) getTileMap;
- (void) setMapPosition:(CGPoint)p_point;
- (CGPoint) getMapPosition;
- (CGSize) getMapSize;

- (void) initMapInfo:(unsigned int **)p_info;
- (void) setMapInfo:(NSInteger)x y:(NSInteger)y tileType:(NSInteger)tileType;
- (unsigned int) getMapInfo:(NSInteger)x y:(NSInteger)y;

- (void) initMoveTable:(unsigned int **)p_info;
- (void) setMoveTable:(NSInteger)x y:(NSInteger)y direction:(NSInteger)direction;
- (unsigned int) getMoveTable:(NSInteger)x y:(NSInteger)y;

- (void) setDeviceSize:(CGSize)p_deviceSize;
- (CGSize) getDeviceSize;

- (void) setViewScale:(CGFloat)p_scale;
- (CGFloat) getViewScale;

- (void) setStartPoint:(CGPoint)p_point;
- (CGPoint) getStartPoint;

- (void) setEndPoint:(CGPoint)p_point;
- (CGPoint) getEndPoint;

- (void) setStageWarriorCount:(NSInteger)count;
- (NSInteger) getStageWarriorCount;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 설치한 장애물 수 반환 및 증가
- (void) plusTrapNum;
- (void) plusWarriorNum;
- (void) plusMonsterNum;
- (void) plusHouseNum;
- (NSInteger) getTrapNum;
- (NSInteger) getWarriorNum;
- (NSInteger) getMonsterNum;
- (NSInteger) getHouseNum;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 용사 관련 정보
- (void) setWarriorList:(NSMutableArray*)pList;
- (void) addWarrior:(Warrior*)pWarrior;
- (void) replaceWarrior:(NSInteger)index pWarrior:(Warrior*)pWarrior;
- (NSMutableArray*) getWarriorList;
- (Warrior*) getWarriorListAtIndex:(NSInteger)index;
- (NSInteger) warriorListCount;
- (void) removeWarriorAtIndex:(NSInteger)index;
- (void) removeWarrior:(Warrior*)pWarrior;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 몬스터 관련 정보
- (void) setMonsterList:(NSMutableArray*)pList;
- (void) addMonster:(Monster*)pMonster;
- (NSMutableArray*) getMonsterList;
- (Monster*) getMonsterListAtIndex:(NSInteger)index;
- (NSInteger) monsterListCount;
- (void) removeMonster:(Monster*)pMonster;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 트랩 관련 정보
- (void) setTrapList:(NSMutableArray*)pList;
- (void) addTrap:(Trap*)pTrap;
- (NSMutableArray*) getTrapList;
- (Trap*) getTrapListAtIndex:(NSInteger)index;
- (NSInteger) trapListCount;
- (void) removeTrap:(Trap*)pTrap;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// 몬스터 집 관련 정보
- (void) setHouseList:(NSMutableArray*)pList;
- (NSMutableArray*) getHouseList;
- (void) addHouseList:(House*)pHouse;
- (NSInteger) houseListCount;
@end