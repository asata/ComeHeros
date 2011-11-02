//
//  PauseLayer.m
//  Field
//
//  Created by 강 정훈 on 11. 11. 2..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "PauseLayer.h"

@implementation PauseLayer

- (id)init {
    if (self = [super init]) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

- (void) createPause:(id)pLayer {
    if(GameLayer_ID == nil) GameLayer_ID = pLayer;
    
    CCSprite *temp = [CCSprite spriteWithFile:FILE_PAUSE_IMG];
    temp.position = ccp(240, 180);
    temp.scale = 10;
    [self addChild:temp z:pBackgroundLayer];
    
    CCMenuItemImage *resume = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
                                                     selectedImage:FILE_RESUME_IMG 
                                                            target:self 
                                                          selector:@selector(onResume:)];
    CCMenuItemImage *restart = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
                                                     selectedImage:FILE_RESUME_IMG 
                                                            target:self 
                                                          selector:@selector(onRestart:)];
    CCMenuItemImage *quit = [CCMenuItemImage itemFromNormalImage:FILE_RESUME_IMG
                                                     selectedImage:FILE_RESUME_IMG 
                                                            target:self 
                                                          selector:@selector(onQuit:)];
    CCMenu *menu = [CCMenu menuWithItems:resume, restart, quit, nil];
    menu.position = ccp(240, 50);
    [menu alignItemsVerticallyWithPadding:5.0f];
    [self addChild:menu z:pMainMenuLayer];
}

- (void) onRestart:(id)sender {
    [GameLayer_ID Restart];
}
- (void) onResume:(id)sender {
    [GameLayer_ID resume];
}
- (void) onQuit:(id)sender {
    [GameLayer_ID Quit];
}

@end
