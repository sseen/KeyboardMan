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

@interface KeyboardMan : NSObject

@end

@interface KeyboardInfo : NSObject

@property (nonatomic, assign) CGRect frameBegin;
@property (nonatomic, assign) CGRect frameEnd;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightIncrement;
@property (nonatomic, assign) Action action;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) UInt8 animationCurve;
@property (nonatomic, assign) BOOL isSameAction;

@end

@interface UIApplication (isNotInBackground)
+ (BOOL)isNotInBackground;
@end
