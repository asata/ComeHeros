//
//  File.m
//  Field
//
//  Created by Kang Jeonghun on 11. 10. 21..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "File.h"

@implementation File


//////////////////////////////////////////////////////////////////////////
// 파일 처리 Start                                                        //
//////////////////////////////////////////////////////////////////////////
- (NSString *) loadFilePath:(NSString *)fileName {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray* sName = [fileName componentsSeparatedByString:@"."];
    if (![fileManager fileExistsAtPath: path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:[sName objectAtIndex:0] ofType:[sName objectAtIndex:1]];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    return path;
}

/*- (NSString *) loadFilePath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Stage097.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if (![fileManager fileExistsAtPath: path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Stage097" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    return path;
}*/

- (void) loadStageData:(NSString *)path {
    stageInfo = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    //load from savedStock example int value
    //int StageLevel = [[savedStock objectForKey:@"StageLevel"] intValue];
    
    CGPoint sPoint = CGPointMake([[stageInfo objectForKey:@"StartPointX"] intValue], 
                                 [[stageInfo objectForKey:@"StartPointY"] intValue]);
    CGPoint dPoint = CGPointMake([[stageInfo objectForKey:@"EndPointX"] intValue], 
                                 [[stageInfo objectForKey:@"EndPointY"] intValue]);
    [[commonValue sharedSingleton] setStartPoint:sPoint];
    [[commonValue sharedSingleton] setEndPoint:dPoint];
    
    // map.tmx의 경우 문자열을 조합하여 불러들임 - 요걸로 하니 에러가 발생 ㅠㅠ 
    //[savedStock objectForKey:@"MapName"];
    NSDictionary *tList = [stageInfo objectForKey:@"WarriorList"];
    [[commonValue sharedSingleton] setStageWarriorCount:[tList count]];
}

- (NSDictionary *) loadWarriorInfo:(NSInteger)index {
    NSDictionary *tList = [stageInfo objectForKey:@"WarriorList"];
    NSDictionary *data = [tList objectForKey:[NSString stringWithFormat:@"%d", index]];
    
    return data;
}
//////////////////////////////////////////////////////////////////////////
// 파일 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
