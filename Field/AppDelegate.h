#import <UIKit/UIKit.h>
#import "MainLayer.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
    playMap             *playGame;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@end
