#import "StageSelectLayer.h"

@implementation StageSelectLayer
@synthesize menuList;

- (id)init {
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        menuList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc {
    [menuList release];
    
    [super dealloc];
}

- (void) onEnterTransitionDidFinish {
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
    CCLayer *pageOne = [[CCLayer alloc] init];
    CCSprite *stage1 = [CCSprite spriteWithFile:@"fire.png" rect:CGRectMake(0, 0, 32, 32)];
    stage1.position = ccp(100, 200);
    [pageOne addChild:stage1];
    
    CCLayer *pageTwo = [[CCLayer alloc] init];
    CCSprite *stage2 = [CCSprite spriteWithFile:@"fire.png" rect:CGRectMake(0, 0, 32, 32)];
    stage2.position = ccp(120, 200);
    [pageTwo addChild:stage2];
    
    CCLayer *pageThree = [[CCLayer alloc] init];
    CCSprite *stage3 = [CCSprite spriteWithFile:@"fire.png" rect:CGRectMake(0, 0, 32, 32)];
    stage3.position = ccp(120, 200);
    [pageThree addChild:stage3];
    
    CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects:pageOne, pageTwo, pageThree, nil]  widthOffset:1];
    [scroller selectPage:1];
    [self addChild:scroller];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"%f %f", location.x, location.y);
    
    for (CCSprite *tMenu in menuList) {
        float minX = [tMenu position].x - 16;
        float maxX = [tMenu position].x + 16;
        float minY = [tMenu position].y - 16;
        float maxY = [tMenu position].y + 16;
        
        if (minX <= location.x && maxX >= location.x && 
            minY <= location.y && maxY >= location.y) {
            // Call Stage
            [self stageSelect:[tMenu tag]];
            break;
        }
    }
}

- (void) stageSelect:(NSInteger)stageNum {
    NSLog(@"Stage Num : %d", stageNum);
    [[commonValue sharedSingleton] setStageLevel:stageNum];
    [(CCLayerMultiplex*)parent_ switchTo:GAME_LAYER];
}
@end
