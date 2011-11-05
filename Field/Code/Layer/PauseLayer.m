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
    
    CCSprite *temp = [CCSprite spriteWithFile:FILE_BACKGROUND_IMG];
    temp.position = ccp(240, 160);
    [self addChild:temp z:pBackgroundLayer];
    
    CCLabelAtlas *label_resume = [CCLabelAtlas labelWithString:@"CONTINUE"
                                                   charMapFile:FILE_NUMBER_IMG 
                                                     itemWidth:32 
                                                    itemHeight:32 
                                                  startCharMap:'.'];
    CCLabelAtlas *label_restart = [CCLabelAtlas labelWithString:@"RESTART"
                                                   charMapFile:FILE_NUMBER_IMG 
                                                     itemWidth:32 
                                                    itemHeight:32 
                                                  startCharMap:'.'];
    CCLabelAtlas *label_quit = [CCLabelAtlas labelWithString:@"MAIN MENU"
                                                   charMapFile:FILE_NUMBER_IMG 
                                                     itemWidth:32 
                                                    itemHeight:32 
                                                startCharMap:'.'];
    [label_resume setScale:0.7];
    [label_restart setScale:0.7];
    [label_quit setScale:0.7];
    
    CCMenuItem *menu_resume = [CCMenuItemLabel itemWithLabel:label_resume 
                                                      target:self 
                                                    selector:@selector(onResume:)]; 
    CCMenuItem *menu_restart = [CCMenuItemLabel itemWithLabel:label_restart 
                                                      target:self 
                                                    selector:@selector(onRestart:)]; 
    CCMenuItem *menu_quit = [CCMenuItemLabel itemWithLabel:label_quit 
                                                      target:self 
                                                    selector:@selector(onQuit:)]; 
    
    CCMenu *menu = [CCMenu menuWithItems:menu_resume, menu_restart, menu_quit, nil];
    menu.position = ccp(270, 160);
    [menu alignItemsVerticallyWithPadding:15.0f];
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
