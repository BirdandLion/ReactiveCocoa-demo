//
//  TestViewModel.h
//  RACDemo
//
//  Created by Gandalf on 16/11/8.
//  Copyright © 2016年 Gandalf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TestViewModel : NSObject

@property (nonatomic, strong) RACCommand *command;

@end
