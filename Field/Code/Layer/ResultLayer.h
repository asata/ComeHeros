#import "cocos2d.h"
#import "define.h"
#import "ResultDefine.h"
#import "commonValue.h"
#import "File.h"

@interface ResultLayer : CCLayer {
    id GameLayer_ID;
    
    BOOL            victory;
    
    CCSprite        *background;
        
    CCLabelAtlas    *labelTitle;
    CCLabelAtlas    *labelResult;
    CCLabelAtlas    *labelScore;
    
    CCLabelAtlas    *labelTrap;
    CCLabelAtlas    *labelMonster;
    CCLabelAtlas    *labelHero;
    CCLabelAtlas    *labelTime;
    
    CCLabelAtlas    *labelPointTrap;
    CCLabelAtlas    *labelPointMonster;
    CCLabelAtlas    *labelPointHero;
    CCLabelAtlas    *labelPointTime;
    
    CCLabelAtlas    *labelScoreTrap;
    CCLabelAtlas    *labelScoreMonster;
    CCLabelAtlas    *labelScoreHero;
    CCLabelAtlas    *labelScoreTime;
    
    CCLabelAtlas    *labelTotal;
    CCLabelAtlas    *labelScoreTotal;
    
    CCMenu          *menu;
}

- (void) clearDisplay;
- (void) setVictory:(BOOL)flag;
- (void) createResult:(id)pLayer;

@end
