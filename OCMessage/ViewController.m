//
//  ViewController.m
//  OCMessage
//
//  Created by Jasmine on 2018/8/31.
//  Copyright © 2018年 nixWork. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardManOC.h"

@interface ViewController ()
@property (nonatomic, strong) KeyboardMan *keyboardMan;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.keyboardMan = [KeyboardMan new];
    __weak ViewController* weakself = self;
    _keyboardMan.animateWhenKeyboardAppear = ^(NSInteger appearPostIndex, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
        NSLog(@"%f", keyboardHeight);
        weakself.tf.frame = CGRectOffset(weakself.tf.frame, 0, -keyboardHeight);
    };
    _keyboardMan.animateWhenKeyboardDisappear = ^(CGFloat keyboardHeight) {
        weakself.tf.frame = CGRectOffset(weakself.tf.frame, 0, keyboardHeight);
    };
    _keyboardMan.postKeyboardInfo = ^(KeyboardMan *keyboardMan, KeyboardInfo *keyboardInfo) {
        
    };
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(grClick:)];
    gr.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gr];
}

- (void)grClick:(UITapGestureRecognizer *)gr {
    [self.view endEditing:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
