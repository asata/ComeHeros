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
    
	//로고 페이드 인   
//    UIImage* backImage=[UIImage imageNamed:@"bg-title.png"];   //로고  
//    UIView* backView=[[UIImageView alloc] initWithImage:backImage]; 
//    fadetime = [NSTimer scheduledTimerWithTimeInterval:1.0 
//                                                target:self 
//                                              selector:@selector(TimeCount) 
//                                              userInfo:nil 
//                                               repeats:YES];
//    [backView setFrame:CGRectMake(0, 0, 320, 480)];            //로고 위치 
//    [window addSubview:backView]; //로고를 뷰에 띄운다. 
//    [UIView beginAnimations:@"CWFadeIn" context:(void*)backView]; //로고 페이드인 애니메이션 
//    [UIView setAnimationDelegate:self]; 
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)]; 
//    [UIView setAnimationDuration:3.0f]; //로고 페이드인 애니메이션 시간 설정 
//    backView.alpha = 0; //로고를 투명으로 
//    [UIView commitAnimations];     
//    // Override point for customization after application launch
//    [window makeKeyAndVisible]; 
//    ftime = 0; //페이드타임 초기화 
    
    CCScene *scene = [CCScene node];
    playGame = [GameLayer node];
    CCLayerMultiplex *layer = [CCLayerMultiplex layerWithLayers:[MainLayer node], 
                               [StageSelectLayer node],
                               playGame, 
                               nil];
    [scene addChild:layer z:0];
    
    [[CCDirector sharedDirector] runWithScene:scene]; 
}

//페이드 인 효과를 위한 함수 
-(void) TimeCount { 
    ftime += 1; //1초마다 페이드 타임 1씩증가 
    
    // 시간에 맞춰 용사 등록
    //NSArray *warriorName = [NSArray arrayWithObjects: @"acher", @"fighter", @"mage", nil];
    //CCSprite *tSprite = [CCSprite spriteWithSpriteFrame:[self loadWarriorSprite:[warriorName objectAtIndex:ftime % 3]]];
    //tSprite.position = ccp(20, 0); 
    // 용사 출력
    
    // 용사 목록 배열에 기록
    
    // 용사 이동
    
    if(ftime == 3) { 
        // 3이 되면 로고 사운드 멈추고 메인화면으로 뷰이동
        NSLog(@"Fade In"); 
        [window addSubview: viewController.view]; 
        
        // 등록된 용사 제거 
    } 
}

- (CCSpriteFrame*) loadWarriorSprite:(NSString*)spriteName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_CHARATER_PLIST textureFile:FILE_CHARATER_IMG];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                            spriteFrameByName:[NSString stringWithFormat:@"character-%@-idle-1.png", spriteName]];
    
    return frame;
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
