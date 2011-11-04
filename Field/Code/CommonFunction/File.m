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
// 지정된 plist 파일을 읽어들임
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

// 스테이지 정보를 읽어 전역 변수에 저장
- (void) loadGameData:(NSString *)path {
    [[commonValue sharedSingleton] setGameData:[[NSMutableDictionary alloc] initWithContentsOfFile: path]];
}
- (void) loadStageData:(NSString *)path {
    NSDictionary *fList = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    stageInfo = [fList objectForKey:[NSString stringWithFormat:@"%d", [[commonValue sharedSingleton] getStageLevel]]];
    [[commonValue sharedSingleton] setMapName:[stageInfo objectForKey:@"MapName"]];
    [[commonValue sharedSingleton] setStageLife:[[stageInfo objectForKey:@"Life"] intValue]];
    [[commonValue sharedSingleton] setStageMoney:[[stageInfo objectForKey:@"Money"] intValue]];
    
    NSDictionary *tList = [stageInfo objectForKey:@"WarriorList"];
    [[commonValue sharedSingleton] setStageWarriorCount:[tList count]];
}

// 캐릭터 정보를 읽어들임
- (NSDictionary *) loadWarriorInfo:(NSInteger)index {
    NSDictionary *tList = [stageInfo objectForKey:@"WarriorList"];
    NSDictionary *data = [tList objectForKey:[NSString stringWithFormat:@"%d", index]];
    
    return data;
}
//////////////////////////////////////////////////////////////////////////
// 파일 처리 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
