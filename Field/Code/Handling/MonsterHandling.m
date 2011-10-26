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
    /*if ((self = [super init])) {
        monsterNum = 0;
    }*/
    
    return self;
}

- (CCSpriteFrame*) loadMonsterSprite:(NSString*)spriteName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_MONSTER_PLIST textureFile:FILE_MONSTER_IMG];
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                            spriteFrameByName:[NSString stringWithFormat:@"monster-%@0000.png", spriteName]];
    
    return frame;
}

- (CCAnimation*) loadMonsterWalk:(NSString*)spriteName {
    NSMutableArray* walkImgList = [NSMutableArray array];
    for(NSInteger i = 0; i < 2; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"monster-%@%04d.png", spriteName, i]];
        
        [walkImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkImgList delay:WARRIOR_MOVE_ACTION];
    
    return animation;
}

- (CCSprite*) createMonster:(NSInteger)monsterType position:(CGPoint)position houseNum:(NSInteger)pHouse {
    CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    Coordinate *coordinate = [[Coordinate alloc] init];
    
    // 용사 생성
    Monster *tMonster = [[Monster alloc] initMonster:[coordinate convertTileToMap:position]
                                          monsterNum:[[commonValue sharedSingleton] getMonsterNum]
                                            strength:100 
                                               power:10 
                                           intellect:40
                                             defense:10 
                                               speed:8   //[[wInfo objectForKey:@"speed"] intValue] 
                                           direction:MoveUp
                                         attackRange:2 
                                            houseNum:pHouse]; 
    
    // 나타난 용사 수 증가
    [[commonValue sharedSingleton] plusMonsterNum];
    
    NSArray *monsterName = [NSArray arrayWithObjects: @"vampire", @"skeleton", @"spirite", nil]; 
    CCSprite *tSprite = [CCSprite spriteWithSpriteFrame:[self loadMonsterSprite:[monsterName objectAtIndex:monsterType]]];
    tSprite.position = ccp((position.x * viewScale) + mapPosition.x, (position.y * viewScale) + mapPosition.y); 
    [tSprite setFlipX:WARRIOR_MOVE_RIGHT]; 
    [tSprite setScale:viewScale];
    [tSprite setVisible:YES];
    [tSprite runAction:[CCRepeatForever actionWithAction:
                        [[CCAnimate alloc] initWithAnimation:[self loadMonsterWalk:[monsterName objectAtIndex:monsterType]] restoreOriginalFrame:NO]]];
    
    [tMonster setMoveLength:TILE_SIZE];
    [tMonster setSprite:tSprite];
    
    [[commonValue sharedSingleton] addMonster:tMonster];
    
    return tSprite;
}

- (void) moveMonster {
    for (int i = 0; i < [[commonValue sharedSingleton] monsterListCount]; i++) {
        // 현재 위치 및 정보를 가져옴
        Monster *tMonster = [[commonValue sharedSingleton] getMonsterListAtIndex:i];
        CCSprite *tSprite = [tMonster getSprite];
        CGPoint movePosition = [tMonster getPosition];
        
        CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
        CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
        
        if ([tMonster getMoveLength] == TILE_SIZE) {
            [self selectDirection:tMonster];
        }
        
        NSInteger direction = [tMonster getMoveDriection];
        // 이동 및 기타 체크 처리
        if(direction == MoveLeft) {
            movePosition = ccp(movePosition.x - [tMonster getMoveSpeed], movePosition.y);
        } else if(direction == MoveUp) {
            movePosition = ccp(movePosition.x, movePosition.y + [tMonster getMoveSpeed]);
        } else if(direction == MoveRight) {
            movePosition = ccp(movePosition.x + [tMonster getMoveSpeed], movePosition.y);
        } else if(direction == MoveDown) {
            movePosition = ccp(movePosition.x, movePosition.y - [tMonster getMoveSpeed]);
        }   
        tSprite.position = ccp(mapPosition.x + (movePosition.x * viewScale), mapPosition.y + (movePosition.y * viewScale));
        [tMonster setSprite:tSprite];
        
        [tMonster plusMoveLength];
        [tMonster setPosition:movePosition];
    }
}

- (BOOL) selectDirection:(Monster *)pMonster {
    if([pMonster getMoveLength] != TILE_SIZE) return NO;
    
    Function *function = [[Function alloc] init];
    CGPoint point = [pMonster getPosition];
    CCSprite *tSprite = [pMonster getSprite];
    int x = ((int) point.x - HALF_TILE_SIZE) / TILE_SIZE;
    int y = TILE_NUM - ((int) point.y - HALF_TILE_SIZE) / TILE_SIZE - 1;
    
    // 집에 도착시
    
    NSInteger direction = [pMonster getMoveDriection];
    if([pMonster getMoveDriection] == MoveUp) {
        if(![function checkMoveTile:x y:(y - 1)]) direction = MoveDown;
    } else if([pMonster getMoveDriection] == MoveDown) {
        if(![function checkMoveTile:x y:(y + 1)]) direction = MoveUp;
    }  else if([pMonster getMoveDriection] == MoveLeft) {
        if(![function checkMoveTile:(x - 1) y:y]) direction = MoveRight;
    }  else if([pMonster getMoveDriection] == MoveRight) {
        if(![function checkMoveTile:(x + 1) y:y]) direction = MoveLeft;
    } 
    
    [pMonster setMoveDriection:direction];
    if(direction == MoveRight || direction == MoveDown) {
        tSprite.flipX = WARRIOR_MOVE_RIGHT;
    } else if(direction == MoveLeft || direction == MoveUp) {
        tSprite.flipX = WARRIOR_MOVE_LEFT;
    }
    
    [pMonster resetMoveLength];
    
    return NO;
}
@end
