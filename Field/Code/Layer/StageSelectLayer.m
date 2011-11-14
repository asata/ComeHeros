#import "StageSelectLayer.h"

@implementation StageSelectLayer

- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) onEnterTransitionDidFinish {
    CCSprite *background = [CCSprite spriteWithFile:@"Default2.png"];
    background.position = ccp(240, 160);
    background.scaleX = 2.0f;
    background.scaleY = 0.5f;
    [self addChild:background];
    
    pZoom= [PinchZoomLayer initPinchZoom:background];
    [pZoom scaleToFit];
    //[self addChild:pZoom];
    /*NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
     NSArray* languages = [defs objectForKey:@"AppleLanguages"];
     NSString* preferredLang = [languages objectAtIndex:0];
     NSLog(@"Language : %@", preferredLang);
     NSLocale *locale = [NSLocale currentLocale];
     NSString* conCode = [locale objectForKey:NSLocaleCountryCode];
     NSString* conName = [locale displayNameForKey:NSLocaleCountryCode value:conCode];
     NSLog(@"Country Code : %@, %@, %@", conName, NSLocalizedString(@"Greeting", @"H1"), NSLocalizedString(@"GameName", @"H1"));*/
    /*if([preferredLang isEqualToString:@"ko"]) {
     } else if([preferredLang isEqualToString:@"en"]) {
     }*/
    
    /*NSDictionary *info = [[[commonValue sharedSingleton] getGameData] objectForKey:@"Info"];
     NSInteger stageNum = [[info objectForKey:@"StageNum"] intValue];
     NSLog(@"Stage total number : %d", stageNum);
     for (NSInteger i = 1; i <= stageNum; i++) {
     NSDictionary *temp = [[[commonValue sharedSingleton] getGameData] objectForKey:[NSString stringWithFormat:@"%d", i]];
     NSLog(@"Stage %d", i);
     NSLog(@" - Point : %d", [[temp objectForKey:@"Point"] intValue]);
     NSLog(@" - Life : %d", [[temp objectForKey:@"Life"] intValue]);
     NSLog(@" - Money : %d", [[temp objectForKey:@"Money"] intValue]);
     
     CCSprite *tMenu = [CCSprite spriteWithFile:@"fire.png" rect:CGRectMake(0, 0, 32, 32)];
     tMenu.position  = ccp(i * 30 + 30, 50);
     tMenu.visible   = YES;
     tMenu.tag       = i;
     
     [menuList addObject:tMenu];
     [self addChild:tMenu];
     }*/
    /*CCLayer *pageOne = [[CCLayer alloc] init];
    CCMenuItemImage *stage1 = [CCMenuItemImage itemFromNormalImage:@"fire.png"
                                                     selectedImage:@"fire.png"
                                                            target:self 
                                                          selector:@selector(stageStart:)];
    CCMenuItemImage *stage2 = [CCMenuItemImage itemFromNormalImage:@"fire.png"
                                                     selectedImage:@"fire.png"
                                                            target:self 
                                                          selector:@selector(stageStart:)];
    CCMenuItemImage *stage3 = [CCMenuItemImage itemFromNormalImage:@"fire.png"
                                                     selectedImage:@"fire.png"
                                                            target:self 
                                                          selector:@selector(stageStart:)];
    [stage1 setTag:1];
    [stage2 setTag:2]; 
    [stage3 setTag:3]; 
    CCMenu *stageMenu1 = [CCMenu menuWithItems:stage1, stage2, stage3, nil];
    [stageMenu1 setPosition:ccp(100, 200)];
    [stageMenu1 alignItemsVerticallyWithPadding:10.0f];
    [pageOne addChild:stageMenu1];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    CCLayer *pageTwo = [[CCLayer alloc] init];
    CCMenuItemImage *stage12 = [CCMenuItemImage itemFromNormalImage:@"fire.png"
                                                      selectedImage:@"fire.png"
                                                             target:self 
                                                           selector:@selector(stageStart:)];
    [stage12 setTag:2]; 
    CCMenu *stageMenu2 = [CCMenu menuWithItems:stage12, nil];
    [pageTwo addChild:stageMenu2];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    CCLayer *pageThree = [[CCLayer alloc] init];
    CCMenuItemImage *stage13 = [CCMenuItemImage itemFromNormalImage:@"fire.png"
                                                      selectedImage:@"fire.png"
                                                             target:self 
                                                           selector:@selector(stageStart:)];
    [stage13 setTag:3];  
    CCMenu *stageMenu3 = [CCMenu menuWithItems:stage13, nil];
    [pageThree addChild:stageMenu3];
    
    CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects:pageOne, pageTwo, pageThree, nil]  widthOffset:1];
    [scroller selectPage:1];
    [self addChild:scroller];*/
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"%f %f", location.x, location.y);
}

- (void) stageStart:(id)sender {
    [[commonValue sharedSingleton] setStageLevel:[sender tag]];
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}
@end
