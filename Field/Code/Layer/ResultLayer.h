#import "cocos2d.h"
#import "PauseDefine.h"

@interface ResultLayer : CCLayer {
    id GameLayer_ID;
}

- (void) createResult:(id)pLayer;

@end
