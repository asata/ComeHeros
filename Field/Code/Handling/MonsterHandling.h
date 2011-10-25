#import "define.h"
#import "commonValue.h"
#import "Warrior.h"
#import "File.h"

@interface MonsterHandling : NSObject{
    NSMutableArray      *monsterList;       // 용사 목록 List
    NSInteger           monsterNum;         // 게임 시작 후 나타난 용사의 수
    
    NSMutableArray      *idleAnimate;
    NSMutableArray      *idleSprite;
    NSMutableArray      *fightAniFrame;
}

- (void) initMonster;

- (CCSprite*) createMonster:(NSInteger)monsterType position:(CGPoint)position;

@end
