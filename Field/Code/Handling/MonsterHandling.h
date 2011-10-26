#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "File.h"

@interface MonsterHandling : NSObject{
}

- (CCSprite*) createMonster:(NSInteger)monsterType position:(CGPoint)position houseNum:(NSInteger)pHouse;

- (CCSpriteFrame*) loadMonsterSprite:(NSString*)spriteName;
- (CCAnimation*) loadMonsterWalk:(NSString*)spriteName;

- (void) moveMonster;
- (BOOL) selectDirection:(Monster *)pMonster;
@end
