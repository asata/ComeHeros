#import "commonValue.h"
#import "Function.h"
#import "Coordinate.h"

@interface File : NSObject {
    NSMutableDictionary *stageInfo;
}

// 파일 처리 함수
- (NSString *) loadFilePath:(NSString *)fileName;
- (void) loadStageData:(NSString *)path;
- (NSDictionary *) loadWarriorInfo:(NSInteger)index;

@end
