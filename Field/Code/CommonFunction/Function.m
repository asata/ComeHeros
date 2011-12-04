#import "Function.h"

@implementation Function
/////////////////Geunwon,Mo : GameCenter 추가 start /////////////
//GameCenter 사용 가능 단말인지 확인
+ (BOOL) isGameCenterAvailable { 
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

//GameCenter 로그인
+ (void) connectGameCenter{
    NSLog(@"connect... to gamecenter");
    if([GKLocalPlayer localPlayer].authenticated == NO) { //게임센터 로그인이 아직일때
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError* error){
            if(error == NULL){
                NSLog(@"게임센터 로그인 성공~");
            } else {
                NSLog(@"게임센터 로그인 에러. 별다른 처리는 하지 않는다.");
            }
        }];
    }
}

// 게임센터 서버로 점수를 보낸다.
+(void) sendScoreToGameCenter:(int)_score{
    GKScore* score = [[[GKScore alloc] initWithCategory:@"SFHerosTopPoint"]autorelease];
    // 위에서 kPoint 가 게임센터에서 설정한 Leaderboard ID
    score.value = _score;
    
    // 아래는 겜센터 스타일의 노티를 보여준다. 첫번째가 타이틀, 두번째가 표시할 메세지
    [[GKAchievementHandler defaultHandler] notifyAchievementTitle:@"NBank Point!"andMessage:[NSString stringWithFormat:@"NBank Point %d점을 기록하셨습니다.",_score]];
    
    // 실지로 게임센터 서버에 점수를 보낸다.
    [score reportScoreWithCompletionHandler:^(NSError* error){
        if(error != NULL){
            // Retain the score object and try again later (not shown).
            
        }
    }];
}

// 게임센터 서버로 목표달성도를 보낸다. 첫번째가 목표ID, 두번째가 달성도. 100%면 목표달성임
+ (void) sendAchievementWithIdentifier: (NSString*) identifier percentComplete: (float) percent{
    NSLog(@"--겜센터 : sendAchievementWithIdentifier %@ , %f",identifier,percent);
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier]autorelease];
    if (achievement)
    {
        achievement.percentComplete = percent;
        
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 
             }
         }];
        
        // 이 아래는 게임센터로부터 목표달성이 등록되면 실행되는 리스너(?)
        [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:
         ^(NSArray *descriptions, NSError *error) {
             if (error != nil){}
             // process the errors
             if (descriptions != nil){
                 
                 //목표달성이 등록되면 노티로 알려준다.
                 for (GKAchievementDescription *achievementDescription in descriptions){
                     if ([[achievementDescription identifier] isEqualToString:identifier]){
                         // 보낸 ID와 일치하면 달성도에 따라 노티를 보여준다.
                         if (percent >= 100.0f) { // 100%면 달성완료 노티를...
                             [[GKAchievementHandler defaultHandler]notifyAchievement:achievementDescription];   
                         } else { // 100%가 안되면 진행도를 노티.
                             //[[GKAchievementHandler defaultHandler]notifyAchievementTitle:achievementDescription.title andMessage:[NSStringstringWithFormat:@"%.0f%% 완료하셨습니다.",percent]];
                         }
                     }
                 }                           
             }                     
         }];    
    }
} 

// 테스트할때 현재까지 모든 진행도를 리셋하는 메소드.
+ (void) resetAchievements
{
    // Clear all progress saved on Game Center
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil){}
         // handle errors
     }];
}

/////////////////Geunwon,Mo : GameCenter 추가 end   ///////////// 



//////////////////////////////////////////////////////////////////////////
// 기타 함수 Start                                                        //
//////////////////////////////////////////////////////////////////////////
// 터치한 두 좌표간의 거리를 계산하여 반환
- (CGFloat) calcuationMultiTouchLength:(NSArray *)touchArray {
    CGFloat result = 0;
    CGPoint point1;
    CGPoint point2;
    int i = 0;
    
    for (UITouch *touch in touchArray) {
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        if(i == 0) point1 = convertedLocation;
        else point2 = convertedLocation;
        
        i++;
    }
    
    result = [self lineLength:point2 point2:point1];
    
    return result;
}

// 터치된 두 지점 사이의 좌표값을 구함
- (CGPoint) middlePoint:(NSArray *)touchArray {
    CGPoint point1;
    CGPoint point2;
    int i = 0;
    
    for (UITouch *touch in touchArray) {
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
        if(i == 0) point1 = convertedLocation;
        else point2 = convertedLocation;
        
        i++;
    }
    
    CGPoint result = ccp(ABS(point1.x + point2.x) / 2, ABS(point1.y + point2.y) / 2);
    
    return result;
}

// 두 점 사이의 거리 계산
- (CGFloat) lineLength:(CGPoint)point1 point2:(CGPoint)point2 {
    CGFloat x = 0;
    CGFloat y = 0;
    
    if(point1.x > point2.x) x = point1.x - point2.x;
    else x = point2.x - point1.x;
    
    if(point1.y > point2.y) y = point1.y - point2.y;
    else y = point2.y - point1.y;
    
    return (powf(x, 2) + powf(y, 2));
}

// 이동 가능한 경로인지 검사
- (BOOL) checkMoveTile:(NSInteger)x y:(NSInteger)y {
    if(x < 0) return NO;
    if(y < 0) return NO;
    if(x > TILE_NUM) return NO;
    if(y > TILE_NUM) return NO;
    
    if ([[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_WALL01 || 
        [[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_WALL10 || 
        [[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_TREASURE ||
        [[commonValue sharedSingleton] getMapInfo:x y:y] == TILE_EXPLOSIVE)
        return NO;
    
    return YES;
}

// 공격을 할 수 있는 대상인지 검사
// direction    : 공격자의 이동 방향
// point1       : 공격 대상의 위치
// point2       : 공격자 위치
- (BOOL) positionSprite:(NSInteger)direction point1:(CGPoint)point1 point2:(CGPoint)point2 {
    if (direction == MoveUp || direction == MoveDown) return YES;
    else if (direction == MoveLeft) {
        if (point1.x < point2.x) return YES;
        else return NO;
    } else if (direction == MoveRight) {
        if (point1.x > point2.x) return YES;
        else return NO;
    }

    return NO;
}

// point1       : 공격 대상의 위치
// point2       : 공격자 위치
- (BOOL) attackDirection:(CGPoint)point1 point2:(CGPoint)point2 {
    if(point1.x < point2.x) return WARRIOR_MOVE_LEFT;
    else return WARRIOR_MOVE_RIGHT;
    
    return WARRIOR_MOVE_RIGHT;
}
//////////////////////////////////////////////////////////////////////////
// 기타 함수 End                                                          //
//////////////////////////////////////////////////////////////////////////
@end
