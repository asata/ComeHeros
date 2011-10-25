//
//  MonsterHandling.m
//  Field
//
//  Created by Kang Jeonghun on 11. 10. 21..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "MonsterHandling.h"

@implementation MonsterHandling

- (id) init {
    if ((self = [super init])) {
        monsterList = [[NSMutableArray alloc] init];
        monsterNum = 0;
        
        idleSprite = [[NSMutableArray alloc] init];
        idleAnimate = [[NSMutableArray alloc] init];
        fightAniFrame = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) initMonster {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_MONSTER_PLIST textureFile:FILE_MONSTER_IMG];
    NSArray *warriorType = [NSArray arrayWithObjects: @"vampire", @"skeleton", @"spirite", nil];    
    
    for (NSString* type in warriorType) {
        NSMutableArray *walkFrame = [NSMutableArray array];
        NSMutableArray *fightFrame = [NSMutableArray array];

        NSInteger idx = 0;
        
        for(; idx < 2; idx++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                    spriteFrameByName:[NSString stringWithFormat:@"monster-%@%04d.png", type, idx]];
            [fightFrame addObject:frame];
        }
        for(; idx < 4; idx++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                    spriteFrameByName:[NSString stringWithFormat:@"monster-%@%04d.png", type, idx]];
            [walkFrame addObject:frame];
        }
        
        CCAnimation *animation = [CCAnimation animationWithFrames:walkFrame delay:WARRIOR_MOVE_ACTION];
        [idleAnimate addObject:[[CCAnimate alloc] initWithAnimation:animation restoreOriginalFrame:NO]];
        [idleSprite addObject:[CCSprite spriteWithSpriteFrame:(CCSpriteFrame*) [walkFrame objectAtIndex:0]]];
        
        // 공격 애니메이션용 이미지
        [fightAniFrame addObject:fightFrame];
    }
}

- (CCSprite*) createMonster:(NSInteger)monsterType position:(CGPoint)position {
    CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    Coordinate *coordinate = [[Coordinate alloc] init];
    
    // 용사 생성
    Warrior *tMonster = [[Warrior alloc] initWarrior:[coordinate convertTileToMap:position]
                                          warriorNum:monsterNum
                                            strength:100 
                                               power:10 
                                           intellect:40
                                             defense:10 
                                               speed:8   //[[wInfo objectForKey:@"speed"] intValue] 
                                           direction:MoveUp
                                         attackRange:2]; 
    
    // 나타난 용사 수 증가
    monsterNum++;
    
    CCSprite *tSprite = [idleSprite objectAtIndex:monsterType];
    tSprite.position = ccp((position.x * viewScale) + mapPosition.x, (position.y * viewScale) + mapPosition.y); 
    [tSprite setFlipX:WARRIOR_MOVE_RIGHT]; 
    [tSprite setScale:viewScale];
    [tSprite setVisible:YES];
    [tSprite runAction:[CCRepeatForever actionWithAction:[idleAnimate objectAtIndex:monsterType]]];
    [tSprite release];
    
    [tMonster setMoveLength:TILE_SIZE];
    [tMonster setSprite:tSprite];
    
    [monsterList addObject:tMonster];
    
    return tSprite;
}

@end
