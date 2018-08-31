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

#pragma mark - actions
- (void)handleKeyboard:(NSNotification *)notification action: (Action)ac {
    if (!notification.userInfo) {
        return;
    }
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval animationDuration = [(NSNumber *)userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    uint animationCurve = [(NSNumber *)userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntValue];
    CGRect frameBegin = [(NSValue *)userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [(NSValue *)userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat currentHeight = frameEnd.size.height;
    CGFloat previousHeight = self.keyboardInfo.height;
    CGFloat heightIncrement = currentHeight - previousHeight;
    BOOL isSameAction;
    if (self.keyboardInfo.action) {
        isSameAction = (ac == self.keyboardInfo.action);
    } else {
        isSameAction = false;
    }
    self.keyboardInfo = [[KeyboardInfo alloc] initWithAnimationDuration:animationDuration
                                                     animationCurve:animationCurve
                                                         frameBegin:frameBegin
                                                           frameEnd:frameEnd
                                                    heightIncrement:heightIncrement
                                                             action:ac isSameAction:isSameAction];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if ([UIApplication isNotInBackground]) {
        [self handleKeyboard:notification action:show];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if ([UIApplication isNotInBackground]) {
        if (_keyboardInfo && _keyboardInfo.action == show) {
            [self handleKeyboard:notification action:show];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if ([UIApplication isNotInBackground]) {
        [self handleKeyboard:notification action:hide];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if ([UIApplication isNotInBackground]) {
        _keyboardInfo = nil;
    }
}

#pragma mark - setter

- (void)setKeyboardObserver:(NSNotificationCenter *)keyboardObserver {
    _keyboardObserver = keyboardObserver;
    [_keyboardObserver removeObserver:self];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_keyboardObserver addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)setKeyboardObserveEnabled:(BOOL)keyboardObserveEnabled {
    if (keyboardObserveEnabled != _keyboardObserveEnabled) {
        if (keyboardObserveEnabled) {
            self.keyboardObserver = [NSNotificationCenter defaultCenter];
        }
    }
}

- (void)setKeyboardInfo:(KeyboardInfo *)keyboardInfo {
    _keyboardInfo = keyboardInfo;
    
    if (![UIApplication isNotInBackground]) {
        return;
    }
    if (!keyboardInfo) {
        return;
    }
    if (!keyboardInfo.isSameAction || keyboardInfo.heightIncrement != 0) {
        NSTimeInterval duration = keyboardInfo.animationDuration;
        uint curve = keyboardInfo.animationCurve;
        UIViewAnimationOptions options = curve << 16 | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction;
        [UIView animateWithDuration:duration
                              delay:0
                            options:options
                         animations:^{
                             switch (keyboardInfo.action) {
                                 case show:
                                     self.animateWhenKeyboardAppear(self.appearPostIndex, keyboardInfo.height, keyboardInfo.heightIncrement);
                                     self.appearPostIndex += 1;
                                     break;
                                 case hide:
                                     self.animateWhenKeyboardDisappear(keyboardInfo.height);
                                     self.appearPostIndex += 0;
                                     break;
                                 default:
                                     break;
                             }
                         } completion:nil];
        _postKeyboardInfo(self, keyboardInfo);
    }
}

- (void)setAnimateWhenKeyboardAppear:(void (^)(NSInteger, CGFloat, CGFloat))animateWhenKeyboardAppear{
    _animateWhenKeyboardAppear = animateWhenKeyboardAppear;
    self.keyboardObserveEnabled = true;
}

- (void)setAnimateWhenKeyboardDisappear:(void (^)(CGFloat))animateWhenKeyboardDisappear {
    _animateWhenKeyboardDisappear = animateWhenKeyboardDisappear;
    self.keyboardObserveEnabled = true;
}

- (void)setPostKeyboardInfo:(void (^)(KeyboardMan *, KeyboardInfo *))postKeyboardInfo {
    _postKeyboardInfo = postKeyboardInfo;
    self.keyboardObserveEnabled = true;
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
                 animationCurve:(uint)ac
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
    self.height = fe.size.height;
    
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
