#import "MainLayer.h"
#import "GameLayer.h"
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

// 메인 화면
@implementation MainLayer


- (id)init {
    CGSize deviceSize = [[CCDirector sharedDirector] winSize];
    [[commonValue sharedSingleton] setDeviceSize:deviceSize];
    
    if ((self = [super init])) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_CHARATER_PLIST textureFile:FILE_CHARATER_IMG];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_TOMBSTONE_PLIST textureFile:FILE_TOMBSTONE_IMG];
        
        self.isTouchEnabled = NO;
    }
    
    File *file = [[File alloc] init];
    NSString *path = [file loadFilePath:FILE_STAGE_PLIST];
    [file loadGameData:path]; 
    
    warriorList = [[NSMutableArray alloc] init];
    warriorName = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects: @"acher0", @"fighter0", @"mage0", 
                                                         @"acher1", @"fighter1", @"mage1", 
                                                         @"acher2", @"fighter2", @"mage2", 
                                                         @"acher3", @"fighter3", @"mage3", 
                                                         @"fighter4", nil]];
    
    return self;
}

- (void) dealloc {
    for (CCSprite *tSprite in warriorList) {
        [tSprite dealloc];
    }
    
    [warriorList dealloc];
    [super dealloc];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [(CCLayerMultiplex*)parent_ switchTo:STAGE_LAYER];
}

- (void) onEnterTransitionDidFinish {
    self.isTouchEnabled = YES;
    
    titleBackground = [CCSprite spriteWithFile:FILE_INTRO_IMG];
    [titleBackground setPosition:ccp([[commonValue sharedSingleton] getDeviceSize].width / 2,
                                     [[commonValue sharedSingleton] getDeviceSize].height / 2)];
    [self addChild:titleBackground];
    
    // 로고 표시
    CCLabelAtlas *label_title = [CCLabelAtlas labelWithString:@"COME HEROS"
                                                  charMapFile:FILE_NUMBER_IMG 
                                                    itemWidth:32 
                                                   itemHeight:32 
                                                 startCharMap:'.'];
    [label_title setScale:1.3f];
    [label_title setPosition:ccp(30, 230)];
    [self addChild:label_title];
    
    CCLabelAtlas *label_touch = [CCLabelAtlas labelWithString:@"TOUCH SCREEN..."
                                                  charMapFile:FILE_NUMBER_IMG 
                                                    itemWidth:32 
                                                   itemHeight:32 
                                                 startCharMap:'.'];
    [label_touch setScale:0.5f];
    [label_touch setPosition:ccp(150, 30)];
    [self addChild:label_touch];
    
    // 일정 시간 간격으로 용사 등장~~~~
    [self addWarrior];
    [self schedule:@selector(moveWarrior:) interval:0.2f];
    [self schedule:@selector(titleWarrior:) interval:3.0f];
}

- (void) titleWarrior:(id)sender {
    [self addWarrior];
}

- (void) addWarrior {
    // 새로운 용사 등록
    NSInteger randNum = random() % [warriorName count];
    
    CCSprite *tSprite = [CCSprite spriteWithSpriteFrame:[self loadWarriorSprite:[warriorName objectAtIndex:randNum]]];
    CCAnimate *walkAnimate = [[CCAnimate alloc] initWithAnimation:[self loadWarriorWalk:[warriorName objectAtIndex:randNum]]
                                             restoreOriginalFrame:NO];
    [tSprite runAction:[CCRepeatForever actionWithAction:walkAnimate]];  
    tSprite.position = ccp(0, 90); 
    [tSprite setVisible:YES];
    
    [self addChild:tSprite];
    [warriorList addObject:tSprite];
}

- (void) moveWarrior:(id)sender {
    // 기존 용사 이동
    for (CCSprite *sprite in warriorList) {
        if(sprite.position.x > 480) continue;
        [sprite setPosition:ccp(sprite.position.x + 10, sprite.position.y)];
    }
}

- (CCSpriteFrame*) loadWarriorSprite:(NSString*)spriteName {
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                            spriteFrameByName:[NSString stringWithFormat:@"%@000.png", spriteName]];
    
    return frame;
}
- (CCAnimation*) loadWarriorWalk:(NSString*)spriteName {
    NSMutableArray* walkImgList = [NSMutableArray array];
    
    for(NSInteger i = 2; i < 4; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"%@00%d.png", spriteName, i]];
        
        [walkImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkImgList delay:WARRIOR_MOVE_ACTION];
    
    return animation;
}

@end
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
