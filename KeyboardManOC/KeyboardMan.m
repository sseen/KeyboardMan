//
//  KeyboardMan.m
//  KeyboardManOC
//
//  Created by sunxuiMac on 2018/8/30.
//  Copyright © 2018年 nixWork. All rights reserved.
//

#import "KeyboardMan.h"
@interface KeyboardMan()
@property (nonatomic, strong) NSNotificationCenter *keyboardObserver;
@property (nonatomic, assign) BOOL keyboardObserveEnabled;

@property (nonatomic, assign) NSInteger appearPostIndex;
@property (nonatomic, strong) KeyboardInfo *keyboardInfo;
@end

@implementation KeyboardMan

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self) {
        self.keyboardObserveEnabled = false;
    }
    
    return self;
}

- (void)setKeyboardObserver:(NSNotificationCenter *)keyboardObserver {
    [_keyboardObserver removeObserver:self];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)setKeyboardObserveEnabled:(BOOL)keyboardObserveEnabled {
    if (keyboardObserveEnabled != _keyboardObserveEnabled) {
        if (_keyboardObserveEnabled) {
            _keyboardObserver = [NSNotificationCenter defaultCenter];
        }
    }
}

- (void)setKeyboardInfo:(KeyboardInfo *)keyboardInfo {
    
}
@end



@implementation KeyboardInfo
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithAnimationDuration:(NSTimeInterval )ad
                 animationCurve:(UInt8)ac
                     frameBegin:(CGRect)fb
                       frameEnd:(CGRect)fe
                heightIncrement:(CGFloat)hi
                         action:(Action)at isSameAction:(BOOL)isSame {
    self = [self init];
    self.animationCurve = ac;
    self.animationDuration = ad;
    self.frameBegin = fb;
    self.frameEnd = fe;
    self.action = at;
    self.isSameAction = isSame;
    
    return self;
}
@end

@implementation  UIApplication (isNotInBackground)

+ (UIApplication *)shareOrNil {
    SEL selector = NSSelectorFromString(@"sharedApplication");
    if ([UIApplication respondsToSelector:selector]) {
        UIApplication *application = [UIApplication performSelector:selector];
        if (application.delegate) {
            return nil;
        } else {
            return application;
        }
    } else {
        return nil;
    }
}

+ (BOOL)isNotInBackground {
    return [[self shareOrNil] applicationState] != UIApplicationStateBackground;
}
@end
