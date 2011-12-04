#import "define.h"
#import "commonValue.h"
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import "GKAchievementHandler.h" //이건 노티를 위해서 임포트

@interface Function : NSObject

/////////////////Geunwon,Mo : GameCenter 추가 start /////////////
+ (BOOL) isGameCenterAvailable ; //게임센터가 사용가능하지 알아보는 메소드
+ (void) connectGameCenter; //게임센터에 접속하는 메소드
+(void) sendScoreToGameCenter:(int)_score; //게임센터서버에 점수 보내는 메소드
+ (void) sendAchievementWithIdentifier: (NSString*) identifier percentComplete: (float) percent;//게임센터서버에 목표달성 보내는 메소드
+ (void) resetAchievements; //테스트용으로 목표달성도를 리셋하는 메소드
/////////////////Geunwon,Mo : GameCenter 추가 end   /////////////

// 기타 함수
- (CGFloat) calcuationMultiTouchLength:(NSArray *)touchArray;   // 터치한 두 좌표간의 거리를 계산하여 반환
- (CGFloat) lineLength:(CGPoint)point1 point2:(CGPoint)point2;  // 두 점 사이의 거리 계산
- (CGPoint) middlePoint:(NSArray *)touchArray;                  // 터치된 두 지점 사이의 좌표값을 구함


- (BOOL) checkMoveTile:(NSInteger)x y:(NSInteger)y;
- (BOOL) positionSprite:(NSInteger)direction point1:(CGPoint)point1 point2:(CGPoint)point2;
- (BOOL) attackDirection:(CGPoint)point1 point2:(CGPoint)point2;
@end
