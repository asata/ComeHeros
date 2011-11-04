//#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "File.h"
#import "commonValue.h"

@interface StageSelectLayer : CCLayer {
    NSMutableArray *menuList;
}

@property (retain, readwrite) NSMutableArray *menuList;

- (void) stageSelect:(NSInteger)stageNum;

@end
