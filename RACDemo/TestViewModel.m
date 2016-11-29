//
//  TestViewModel.m
//  RACDemo
//
//  Created by Gandalf on 16/11/8.
//  Copyright © 2016年 Gandalf. All rights reserved.
//

#import "TestViewModel.h"

@implementation TestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        self.command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            NSLog(@"signalBlock input: %@", input);
            
            return [self loadData];
        }];
    }
    
    return self;
}

- (RACSignal *)loadData
{
    return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"loadData");
        
        if (YES) {
            [subscriber sendNext:@"Smile"];
            [subscriber sendCompleted];
        } else {
            NSError *error = [NSError errorWithDomain:@"Network Failed!" code:1 userInfo:@{@"error": @"emulatorError"}];
            [subscriber sendError:error];
        }
        
        return nil;
    }] doNext:^(id x) {
        NSLog(@"Next");
    }] doCompleted:^{
        NSLog(@"Complete");
    }] doError:^(NSError *error) {
        NSLog(@"Error");
    }];
}

@end
