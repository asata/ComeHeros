#import "cocos2d.h"
#import "define.h"
#import "Warrior.h"
#import "Trap.h"
#import "House.h"
#import "Monster.h"

@interface commonValue : NSObject {
} 

+ (commonValue *)sharedSingleton;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) initCommonValue;

- (void) setStageTime:(NSInteger)pTime;
- (void) plusStageTime;
- (NSInteger) getStageTime;

- (void) setStagePoint:(NSInteger)pPoint;
- (void) plusStagePoint:(NSInteger)pPoint;
- (NSInteger) getStagePoint;

- (void) setStageMoney:(NSInteger)pMoney;
- (void) plusStageMoney:(NSInteger)pMoney;
- (void) minusStageMoney:(NSInteger)pMoney;
- (NSInteger) getStageMoney;

- (void) setStageLife:(NSInteger)pLife;
- (NSInteger) getStageLife;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

- (void) setTileMap:(CCTMXTiledMap*)p_map;
- (CCTMXTiledMap*) getTileMap;
- (void) setMapPosition:(CGPoint)p_point;
- (CGPoint) getMapPosition;

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
- (void) setMonsterList:(NSMutableArray*)pList;
- (void) addMonster:(Monster*)pMonster;
- (NSMutableArray*) getMonsterList;
- (Monster*) getMonsterListAtIndex:(NSInteger)index;
- (NSInteger) monsterListCount;
- (void) removeMonster:(Monster*)pMonster;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) setTrapList:(NSMutableArray*)pList;
- (void) addTrap:(Trap*)pTrap;
- (NSMutableArray*) getTrapList;
- (Trap*) getTrapListAtIndex:(NSInteger)index;
- (NSInteger) trapListCount;
- (void) removeTrap:(Trap*)pTrap;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void) setHouseList:(NSMutableArray*)pList;
- (NSMutableArray*) getHouseList;
- (void) addHouseList:(House*)pHouse;
- (NSInteger) houseListCount;
@end