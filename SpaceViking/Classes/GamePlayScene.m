//
//  GamePlay.m
//  SpaceViking
//
//  Created by Sampanweng on 14-4-6.
//  Copyright 2014年 Mine. All rights reserved.
//

#import "GamePlayScene.h"
#import "AppDelegate.h"

#import "SneakyButton.h"
#import "SneakyJoystick.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyJoystickSkinnedBase.h"


@implementation GamePlayScene
{
    CCSprite *_backGroundSprite;
    CCSprite *_playerSprite;
    
    SneakyJoystick *_leftJoystick;
    SneakyButton *_jumpButton;
    SneakyButton *_attackButton;
}

+ (id)scene
{
    return [[GamePlayScene alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
            _backGroundSprite = [CCSprite spriteWithImageNamed:@"background.png"];
        } else {
            _backGroundSprite = [CCSprite spriteWithImageNamed:@"backgroundiPhone.png"];
        }
        _backGroundSprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
        [self addChild:_backGroundSprite];
        
        _playerSprite = [CCSprite spriteWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"sv_anim_1.png"]];
        _playerSprite.position = ccp(self.contentSize.width/2, self.contentSize.height * 0.17f);
        [UIAppDelegate.sprteBatchNode addChild:_playerSprite];
        [self addChild:UIAppDelegate.sprteBatchNode];
        
        [self _initJoystickAndButtons];
//        [self schedule:@selector(update:) interval:1/60.f];
    }
    
    return self;
}

- (void)update:(CCTime)delta
{
    [self _applyJoystick:_leftJoystick toNode:_playerSprite forTimeDelta:delta];
}

#pragma mark - Private methods

- (void)_initJoystickAndButtons
{
    CGSize screenSize = self.contentSize;
    CGRect joystickBaseDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect jumpButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect attackButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGPoint joystickBasePosition;
    CGPoint jumpButtonPosition;
    CGPoint attackButtonPosition;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // The device is an iPad running iPhone 3.2 or later.
        CCLOG(@"Positioning Joystick and Buttons for iPad");
        joystickBasePosition = ccp(screenSize.width*0.0625f, screenSize.height*0.052f);
        jumpButtonPosition = ccp(screenSize.width*0.946f, screenSize.height*0.052f);
        attackButtonPosition = ccp(screenSize.width*0.947f, screenSize.height*0.169f);
    } else {
        // The device is an iPhone or iPod touch.
        CCLOG(@"Positioning Joystick and Buttons for iPhone");
        joystickBasePosition = ccp(screenSize.width*0.11f, screenSize.height*0.11f);
        jumpButtonPosition = ccp(screenSize.width*0.93f, screenSize.height*0.11f);
        attackButtonPosition = ccp(screenSize.width*0.93f, screenSize.height*0.35f);
    }
    
    SneakyJoystickSkinnedBase *joystickBase = [[SneakyJoystickSkinnedBase alloc] init];
    joystickBase.position = joystickBasePosition;
    
    CCSprite *joystickBgSprite = [CCSprite spriteWithImageNamed:@"dpadDown.png"];
    joystickBase.backgroundSprite = joystickBgSprite;
    
    CCSprite *joystickThumbSprite = [CCSprite spriteWithImageNamed:@"joystickDown.png"];
    joystickBase.thumbSprite = joystickThumbSprite;
    
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:joystickBaseDimensions];
    _leftJoystick = joystickBase.joystick;
    [self addChild:joystickBase];

    SneakyButtonSkinnedBase *jumpButtonBase = [[SneakyButtonSkinnedBase alloc] init];
    jumpButtonBase.position = jumpButtonPosition;                 // 13
    jumpButtonBase.defaultSprite = [CCSprite spriteWithImageNamed:@"jumpUp.png"];
    jumpButtonBase.activatedSprite = [CCSprite spriteWithImageNamed:@"jumpDown.png"];
    jumpButtonBase.pressSprite = [CCSprite spriteWithImageNamed:@"jumpDown.png"];
    jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonDimensions];
    _jumpButton = jumpButtonBase.button;
    _jumpButton.isToggleable = NO;                                 // 19
    [self addChild:jumpButtonBase];                               // 20
    
    SneakyButtonSkinnedBase *attackButtonBase = [[SneakyButtonSkinnedBase alloc] init];             // 21
    attackButtonBase.position = attackButtonPosition;             // 22
    attackButtonBase.defaultSprite = [CCSprite spriteWithImageNamed:@"handUp.png"];                                    // 23
    attackButtonBase.activatedSprite = [CCSprite spriteWithImageNamed:@"handDown.png"];                                  // 24
    attackButtonBase.pressSprite = [CCSprite spriteWithImageNamed:@"handDown.png"];                                  // 25
    attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonDimensions];                             // 26
    _attackButton = attackButtonBase.button;              // 27
    _attackButton.isToggleable = NO;                               // 28
    [self addChild:attackButtonBase];
}

- (void)_applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode*)tempNode forTimeDelta:(float)deltaTime
{
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1024.0f : 960.f);
    
    CGPoint nezPosition = ccp(tempNode.position.x + scaledVelocity.x * deltaTime, tempNode.position.y);
    if (nezPosition.x < _playerSprite.contentSize.width / 2) {
        nezPosition.x = _playerSprite.contentSize.width/2;
    }
    if (nezPosition.x > self.contentSize.width - _playerSprite.contentSize.width/2) {
        nezPosition.x = self.contentSize.width - _playerSprite.contentSize.width/2;
    }
    
    tempNode.position = nezPosition;
    
    if (_jumpButton.active == YES) {
        CCLOG(@"Jump button is pressed.");
    }
    if (_attackButton.active == YES) {
        CCLOG(@"Attack button is pressed.");
    }
}

@end
