#import "cocos2d.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker {
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	CCDirector *director = [CCDirector sharedDirector];
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;

	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	[director setOpenGLView:glView];
	
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	[viewController setView:glView];
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	[self removeStartupFlicker];
	
    CCScene *scene = [CCScene node];
    
    playGame = [playMap node];
    CCLayerMultiplex *layer = [CCLayerMultiplex layerWithLayers:[MainLayer node], playGame, nil];
    [scene addChild:layer z:0];
    
    [[CCDirector sharedDirector] runWithScene:scene];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    if(![[commonValue sharedSingleton] getGamePause]) {
        [[CCDirector sharedDirector] pause];
        
        if([[commonValue sharedSingleton] getGamePlaying]) {
            [playGame onPause];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /* 홈버튼을 선택하여 나갈 경우 애니메이션이 중단된 후 다시 실행시 재개됨
     // 자동 재개가 아닌 재개여부를 선택하는 버튼을 두어 실행하도록 함 */
    if(![[commonValue sharedSingleton] getGamePause]) {
        [[CCDirector sharedDirector] resume];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	[[director openGLView] removeFromSuperview];
    
	[viewController release];
	[window release];
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
