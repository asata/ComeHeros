// 게임 설명을 표시할 레이어
// 게임 시작 이전에 표시
// 구성시 skip을 할 수 있는 버튼을 두고, 터치시 다음 설명으로 넘어감
// 다 표시하면 다시 게임으로 돌아감
#import "TutorialLayer.h"

@implementation TutorialLayer

- (id)init {
    if (self = [super init]) {
        self.isTouchEnabled = YES;
    }
    
    return self;
}

@end
