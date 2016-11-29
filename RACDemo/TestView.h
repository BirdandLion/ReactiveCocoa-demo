//
//  TestView.h
//  RACDemo
//
//  Created by Gandalf on 16/11/18.
//  Copyright © 2016年 Gandalf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestView;

@protocol TestViewDelegate <NSObject>

- (void)testViewDidClick:(TestView*)testView;

@end

@interface TestView : UIView

@property (weak, nonatomic) UIButton *btn;

@property (weak, nonatomic) id delegate;

@end
