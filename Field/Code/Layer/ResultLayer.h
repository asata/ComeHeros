#import "cocos2d.h"
#import "ResultDefine.h"
#import "commonValue.h"

@interface ResultLayer : CCLayer {
    id GameLayer_ID;
    
    CCLabelAtlas *labelTitle;
    
    CCLabelAtlas *labelPointTrap;
    CCLabelAtlas *labelPointMonster;
    CCLabelAtlas *labelPointHero;
    CCLabelAtlas *labelPointTime;
    
    CCLabelAtlas *labelScoreTrap;
    CCLabelAtlas *labelScoreMonster;
    CCLabelAtlas *labelScoreHero;
    CCLabelAtlas *labelScoreTime;
    
    CCLabelAtlas *labelScoreTotal;
}

- (void) createResult:(id)pLayer;

@end
