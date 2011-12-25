#import "cocos2d.h"
#import "commonValue.h"

// 메인 화면
@interface MainLayer : CCLayer {
    CCSprite        *titleBackground;
    NSMutableArray  *warriorList;
    NSMutableArray  *warriorName;
}

- (void) addWarrior;
- (void) titleWarrior:(id)sender;
- (void) moveWarrior:(id)sender;
- (CCSpriteFrame*) loadWarriorSprite:(NSString*)spriteName;
- (CCAnimation*) loadWarriorWalk:(NSString*)spriteName;

@end
