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
        removeSpriteList = [[NSMutableArray alloc] init];
    }
    
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
- (CCAnimation*) loadMonsterAttack:(NSString*)spriteName {
    NSMutableArray* attackImgList = [NSMutableArray array];
    for(NSInteger i = 2; i < 4; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"monster-%@%04d.png", spriteName, i]];
        
        [attackImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:attackImgList delay:WARRIOR_MOVE_ACTION];
    
    return animation;
}
- (CCAnimation*) loadMonsterDeath:(NSString*)spriteName {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:FILE_DEATH_MONSTER_PLIST textureFile:FILE_DEATH_MONSTER_IMG];
    
    NSMutableArray* walkImgList = [NSMutableArray array];
    for(NSInteger i = 0; i < 8; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:[NSString stringWithFormat:@"monster-%@%04d.png", spriteName, i]];
        
        [walkImgList addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:walkImgList delay:DEATH_MONSTER_TIME];
    
    return animation;
}
- (CCSprite*) createMonster:(NSInteger)monsterType position:(CGPoint)position houseNum:(NSInteger)pHouse {
    //CGFloat viewScale = [[commonValue sharedSingleton] getViewScale];
    //CGPoint mapPosition = [[commonValue sharedSingleton] getMapPosition];
    Coordinate *coordinate = [[Coordinate alloc] init];
    File *file = [[File alloc] init];
    
    NSArray *monsterName = [NSArray arrayWithObjects: @"vampire", @"skeleton", @"spirite", nil]; 
    
    NSString *path = [file loadFilePath:@"ChareaterInfo.plist"];
    NSDictionary *chareterList = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    NSDictionary *warriorList = [chareterList objectForKey:@"Monster"];
    NSDictionary *data = [warriorList objectForKey:[monsterName objectAtIndex:monsterType]];
    
    CGPoint startABSPoint = [coordinate convertTileToMap:position];
    // 몬스터 생성
    Monster *tMonster = [[Monster alloc] initMonster:startABSPoint
                                          monsterNum:[[commonValue sharedSingleton] getMonsterNum]
                                            strength:[[data objectForKey:@"strength"] intValue] 
                                               power:[[data objectForKey:@"power"] intValue] 
                                           intellect:[[data objectForKey:@"intellect"] intValue]
                                             defense:[[data objectForKey:@"defense"] intValue] 
                                               speed:[[data objectForKey:@"speed"] intValue]
                                           direction:MoveUp
                                         attackRange:[[data objectForKey:@"range"] intValue] 
                                            houseNum:pHouse]; 
    
    CCSprite *tSprite = [CCSprite spriteWithSpriteFrame:[self loadMonsterSprite:[monsterName objectAtIndex:monsterType]]];
    tSprite.position = startABSPoint; 
    [tSprite setFlipX:WARRIOR_MOVE_RIGHT]; 
    [tSprite setScale:CHAR_SCALE];
    [tSprite setVisible:YES];
    [tSprite runAction:[CCRepeatForever actionWithAction:
                        [[CCAnimate alloc] initWithAnimation:[self loadMonsterWalk:[monsterName objectAtIndex:monsterType]] restoreOriginalFrame:NO]]];
    [tMonster setAttackAnimate:[[CCAnimate alloc] initWithAnimation:[self loadMonsterAttack:[monsterName objectAtIndex:monsterType]] restoreOriginalFrame:NO]];
    [tMonster setDeathAnimate:[[CCAnimate alloc] initWithAnimation:[self loadMonsterDeath:[monsterName objectAtIndex:monsterType]] restoreOriginalFrame:YES]];
    [tMonster setMoveLength:TILE_SIZE];
    [tMonster setSprite:tSprite];
    NSLog(@"Create Monster");
    
    // 나타난 몬스터 수 증가
    [[commonValue sharedSingleton] plusMonsterNum];
    [[commonValue sharedSingleton] addMonster:tMonster];
    
    return tSprite;
}

- (void) moveMonster {
    NSMutableArray *deleteMonster = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[commonValue sharedSingleton] monsterListCount]; i++) {
        // 현재 위치 및 정보를 가져옴
        Monster *tMonster = [[commonValue sharedSingleton] getMonsterListAtIndex:i];
        
        if ([tMonster getDeath] == DEATH) continue;
        CCSprite *tSprite = [tMonster getSprite];
        CGPoint movePosition = [tMonster getPosition];
        
        if ([tMonster getMoveLength] == TILE_SIZE) {
            [self selectDirection:tMonster];
        }
        
        NSInteger attackEnmy = [self enmyFind:tMonster];
        if(attackEnmy != -1) {
            [tSprite runAction:[CCSequence actions:[tMonster getAttackAnimate], 
                                [CCCallFunc actionWithTarget:self selector:@selector(attackCompleteHandler)], 
                                nil]];
        } else {
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
            
            tSprite.position = movePosition;
            [tMonster setSprite:tSprite];
            
            [tMonster plusMoveLength];
            [tMonster setPosition:movePosition];
        }
        
        if ([tMonster getStrength] < 0 && [tMonster getDeath] == SURVIVAL) {
            // 소멸 처리
            [deleteMonster addObject:tMonster];
        }
    }
    
    if([deleteMonster count] != 0) [self removeMonster:deleteMonster];
}

- (BOOL) selectDirection:(Monster *)pMonster {
    if([pMonster getMoveLength] != TILE_SIZE) return NO;
    
    Function *function = [[Function alloc] init];
    CGPoint point = [pMonster getPosition];
    CCSprite *tSprite = [pMonster getSprite];
    int x = ((int) point.x - HALF_TILE_SIZE) / TILE_SIZE;
    int y = TILE_NUM - ((int) point.y - HALF_TILE_SIZE) / TILE_SIZE - 1;
    
    // 이동 방향 결정
    NSInteger direction = [pMonster getMoveDriection];
    if([pMonster getMoveDriection] == MoveUp) {
        if(![function checkMoveTile:x y:(y - 1)] && ![function checkMoveTile:x y:(y + 1)]) direction = MoveNone;
        else if(![function checkMoveTile:x y:(y - 1)]) direction = MoveDown;
        else direction = MoveUp;
    } else if([pMonster getMoveDriection] == MoveDown) {
        if(![function checkMoveTile:x y:(y - 1)] && ![function checkMoveTile:x y:(y + 1)]) direction = MoveNone;
        else if(![function checkMoveTile:x y:(y + 1)]) direction = MoveUp;
        else direction = MoveDown;
    } else if([pMonster getMoveDriection] == MoveLeft) {
        if(![function checkMoveTile:(x - 1) y:y] && ![function checkMoveTile:(x + 1) y:y]) direction = MoveNone;
        else if(![function checkMoveTile:(x - 1) y:y]) direction = MoveRight;
        else direction = MoveLeft;
    } else if([pMonster getMoveDriection] == MoveRight) {
        if(![function checkMoveTile:(x - 1) y:y] && ![function checkMoveTile:(x + 1) y:y]) direction = MoveNone;
        else if(![function checkMoveTile:(x + 1) y:y]) direction = MoveLeft;
        else direction = MoveRight;
    } else {
        if([function checkMoveTile:x y:(y - 1)]) direction = MoveUp;
        else if([function checkMoveTile:x y:(y + 1)]) direction = MoveDown;
        else if([function checkMoveTile:(x + 1) y:y]) direction = MoveRight;
        else if([function checkMoveTile:(x - 1) y:y]) direction = MoveLeft;
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

- (void) attackCompleteHandler {
    // 에러 발생시 걷기 애니메이션을 상단에서 중단하였다가 이곳에서 재개하는 방향으로 구현
    //NSLog(@"Warrior Start Walk");
}
- (void) deathCompleteHandler:(id)sender {
    if ([removeSpriteList count] == 0) return;

    Monster *rMonster = [[[removeSpriteList objectAtIndex:0] retain] autorelease];
    CCSprite *rSprite = [rMonster getSprite];
    [[commonValue sharedSingleton] removeMonster:rMonster];
    rSprite.visible = NO;
    [rSprite release];
    [removeSpriteList removeObjectAtIndex:0];
}
- (void) removeMonster:(NSMutableArray*)dMonstList {
    for (Monster *tMonster in dMonstList) {        
        CCSprite *tSprite = [tMonster getSprite];
        
        [[commonValue sharedSingleton] plusDieMonsterNum];
        [tSprite runAction:[CCSequence actions:[tMonster getDeathAnimate], 
                            [CCCallFunc actionWithTarget:self selector:@selector(deathCompleteHandler:)], 
                            nil]];
        
        [tMonster setDeath:DEATH];
        [removeSpriteList addObject:tMonster];
        
        for (House *tHouse in [[commonValue sharedSingleton] getHouseList]) {
            if([tHouse getHouseNum] == [tMonster getHouseNum]) [tHouse minusMadeNum];
        }
    }
} 

- (NSInteger) enmyFind:(Monster*)pMonster {
    CGPoint mPoint = [pMonster getPosition];
    NSInteger wAttack = [pMonster getAttackRange];
    Function *function = [[Function alloc] init];
    
    for(int i = 0; i < [[commonValue sharedSingleton] warriorListCount]; i++) {
        Warrior *tWarrior = [[commonValue sharedSingleton] getWarriorListAtIndex:i];
        if ([tWarrior getDeath] == DEATH) continue;
        CGPoint wPoint = [tWarrior getPosition];
        CGFloat distance = [function lineLength:wPoint point2:mPoint];
        
        if(distance <= powf(wAttack * TILE_SIZE, 2)) {
            // 뒤에 있는 적은 공격을 못함
            if (![function positionSprite:[pMonster getMoveDriection] point1:wPoint point2:mPoint]) continue;
            [[pMonster getSprite] setFlipX:[function attackDirection:wPoint point2:mPoint]];
            
            NSInteger demage = [pMonster getPower] - [tWarrior getDefense];
            if(demage > 0) {
                CCSprite *tSprite = [tWarrior getSprite];
                [tSprite runAction:[CCFadeIn actionWithDuration:BEAT_ENEMY_TIME]];
                
                [tWarrior setStrength:[tWarrior getStrength] - demage];
            }
            
            return [tWarrior getWarriorNum];
        }
    }
    
    return NotFound;
}
@end
