//
//  KeyboardMan.h
//  KeyboardManOC
//
//  Created by sunxuiMac on 2018/8/30.
//  Copyright © 2018年 nixWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    show,
    hide
} Action;

@class KeyboardInfo;

@interface KeyboardMan : NSObject

@property (nonatomic, copy, nullable) void (^animateWhenKeyboardAppear)(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) ;
@property (nonatomic, copy, nullable) void (^animateWhenKeyboardDisappear)(CGFloat keyboardHeight);
@property (nonatomic, copy, nullable) void (^postKeyboardInfo)(KeyboardMan *keyboardMan, KeyboardInfo *keyboardInfo);


@end

@interface KeyboardInfo : NSObject

@property (nonatomic, assign) CGRect frameBegin;
@property (nonatomic, assign) CGRect frameEnd;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightIncrement;
@property (nonatomic, assign) Action action;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) uint animationCurve;
@property (nonatomic, assign) BOOL isSameAction;

- (id)initWithAnimationDuration:(NSTimeInterval )ad
                 animationCurve:(uint)ac
                     frameBegin:(CGRect)fb
                       frameEnd:(CGRect)fe
                heightIncrement:(CGFloat)hi
                         action:(Action)at isSameAction:(BOOL)isSame ;

@end

@interface UIApplication (isNotInBackground)
+ (BOOL)isNotInBackground;
@end
