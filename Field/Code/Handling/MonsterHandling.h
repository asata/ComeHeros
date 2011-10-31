#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "File.h"

@interface MonsterHandling : NSObject{
    NSMutableArray *removeSpriteList;
}

- (CCSprite*) createMonster:(NSInteger)monsterType position:(CGPoint)position houseNum:(NSInteger)pHouse;

- (CCSpriteFrame*) loadMonsterSprite:(NSString*)spriteName;
- (CCAnimation*) loadMonsterWalk:(NSString*)spriteName;
- (CCAnimation*) loadMonsterAttack:(NSString*)spriteName;
- (CCAnimation*) loadMonsterDeath:(NSString*)spriteName;

- (void) moveMonster;
- (BOOL) selectDirection:(Monster *)pMonster;
- (void) removeMonster:(NSMutableArray*)dMonstList;

- (void) attackCompleteHandler;
- (void) deathCompleteHandler:(id)sender;

- (NSInteger) enmyFind:(Monster*)pMonster;
@end
