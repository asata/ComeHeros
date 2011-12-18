#import <UIKit/UIKit.h>
#import "MainLayer.h"
#import "GameLayer.h"
#import "StageSelectLayer.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
    GameLayer           *playGame;
	RootViewController	*viewController;
    
    NSTimer             *fadetime;
    NSInteger           ftime;
}

@property (nonatomic, retain) UIWindow *window;


- (CCSpriteFrame*) loadWarriorSprite:(NSString*)spriteName;
- (void) TimeCount;
@end
