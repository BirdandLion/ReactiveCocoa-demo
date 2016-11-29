//
//  TestViewController.h
//  RACDemo
//
//  Created by Gandalf on 16/11/8.
//  Copyright © 2016年 Gandalf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TestViewController : UIViewController

@property (nonatomic, strong) RACSubject *subject;

@end
