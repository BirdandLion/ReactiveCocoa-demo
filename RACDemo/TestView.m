//
//  TestView.m
//  RACDemo
//
//  Created by Gandalf on 16/11/18.
//  Copyright © 2016年 Gandalf. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.btn = btn;
    }
    
    return self;
}

- (void)btnClick
{
    [self.delegate testViewDidClick:self];
}

@end
