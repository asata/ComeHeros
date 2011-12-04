//#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "File.h"
#import "Function.h"
#import "commonValue.h"
#import "PinchZoomLayer.h"
//#import "CCScrollLayer.h"

@interface StageSelectLayer : CCLayer {
    PinchZoomLayer  *pZoom;
    NSMutableArray  *menuList;
}

- (void) stageStart:(id)sender;

@end
