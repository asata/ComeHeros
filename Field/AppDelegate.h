#import <UIKit/UIKit.h>
#import "MainLayer.h"
#import "GameLayer.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
    GameLayer           *playGame;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@end
