//
//  PauseLayer.h
//  Field
//
//  Created by 강 정훈 on 11. 11. 2..
//  Copyright 2011년 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PauseDefine.h"
#import "commonValue.h"

@interface PauseLayer : CCLayer {
    id GameLayer_ID;
}

- (void) createPause:(id)pLayer;
- (void) onRestart:(id)sender;
- (void) onResume:(id)sender;
- (void) onQuit:(id)sender;

@end
