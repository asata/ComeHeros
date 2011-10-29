#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "File.h"

@interface MonsterHandling : NSObject{
}

- (CCSprite*) createMonster:(NSInteger)monsterType position:(CGPoint)position houseNum:(NSInteger)pHouse;

- (CCSpriteFrame*) loadMonsterSprite:(NSString*)spriteName;
- (CCAnimation*) loadMonsterWalk:(NSString*)spriteName;
- (CCAnimation*) loadMonsterAttack:(NSString*)spriteName;

- (void) moveMonster;
- (void) attackCompleteHandler;
- (BOOL) selectDirection:(Monster *)pMonster;
- (void) removeMonster:(NSMutableArray*)dMonstList;

- (NSInteger) enmyFind:(Monster*)pMonster;
@end
