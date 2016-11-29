//
//  ViewController.m
//  RACDemo
//
//  Created by Gandalf on 16/11/4.
//  Copyright © 2016年 Gandalf. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TestViewController.h"
#import "TestViewModel.h"

#import "TestView.h"

@interface ViewController ()
@property (weak, nonatomic) TestViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self testRACCommand];
//    [self testRACReplaySubject];
    
//    TestView *testView = [[TestView alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
//    [self.view addSubview:testView];
//    testView.delegate = self;
//    [[self rac_signalForSelector:@selector(testViewDidClick:)] subscribeNext:^(id x) {
//        NSLog(@"rac btn click");
//    }];
    
}

- (void)testMultiConnection
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        return nil;
    }];

#if 1
    // RACMulticastConnection
    RACMulticastConnection *connect = [signal publish];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"connect 第一次订阅信号: %@", x);
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"connect 第二次订阅信号: %@", x);
    }];
    
    [connect connect];
    
#else
    
    // 普通订阅
    [signal subscribeNext:^(id x) {
        NSLog(@"第一次订阅信号");
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"第二次订阅信号");
    }];
#endif
}

- (void)testLogin
{
    // username
    RACSignal *validUsernameSignal = [self.usernameTF.rac_textSignal map:^id(NSString *username) {
        return @([self isValidUsername:username]);
    }];
    // password
    RACSignal *validPasswordSignal = [self.passwordTF.rac_textSignal map:^id(NSString *password) {
        return @([self isValidPassword:password]);
    }];
    
    RAC(self.usernameTF, backgroundColor) = [validUsernameSignal map:^id(NSNumber *value) {
        return [value boolValue] ? [UIColor whiteColor] : [UIColor yellowColor];
    }];
    
    RAC(self.passwordTF, backgroundColor) = [validPasswordSignal map:^id(NSNumber *value) {
        return [value boolValue] ? [UIColor whiteColor] : [UIColor yellowColor];
    }];
    
    // loginBtn
    [[RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                       reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                           return @([usernameValid boolValue] && [passwordValid boolValue]);
                       }]
                subscribeNext:^(NSNumber *signUpActive) {
                           self.loginBtn.enabled = [signUpActive boolValue];
                       }];
    
    [[[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x) {
           NSLog(@"next");
       }]
       flattenMap:^RACStream *(id value) {
           return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   if ([self.usernameTF.text isEqualToString:@"kelvin"]) {
                       [subscriber sendNext:@(YES)];
                   } else {
                       [subscriber sendNext:@(NO)];
                   }
                   [subscriber sendCompleted];
               });
               
               return [RACDisposable disposableWithBlock:^{
                   NSLog(@"按钮点击事件执行完成");
               }];
           }];
       }]
       subscribeNext:^(id x) {
           NSLog(@"%@", x);
       } error:^(NSError *error) {
           NSLog(@"%@", error);
       }];
}

- (BOOL)isValidUsername:(NSString*)username
{
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString*)password
{
    return password.length > 3;
}

- (void)testTextSignal
{
//    [[self.textField.rac_textSignal filter:^BOOL(id value) {
//        return ((NSString*)value).length > 2;
//    }] subscribeNext:^(id x) {
//        NSLog(@"filter: %@", x);
//    }];
//    
//    [[[self.textField.rac_textSignal map:^id(id value) {
//        return @(((NSString*)value).length > 2);
//    }] skip:1] subscribeNext:^(id x) {
//        NSLog(@"map: %@", x);
//    }];
}

- (void)testRACSignal
{
    // RACSignal
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"ReactiveCocoa"];
        
        return nil;
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"接收到数据：%@", x);
    }];
}

- (void)testRACSubject
{
    RACSubject *subject = [RACSubject subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者：%@", x);
    }];
    
    [subject sendNext:@"1"];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者：%@", x);
    }];
}

- (void)testRACCommand
{
#if 0
    TestViewModel *viewModel = [[TestViewModel alloc] init];
    self.viewModel = viewModel;

    [[viewModel.command execute:nil] subscribeNext:^(id x) {
        NSLog(@"Command Data: %@", x);
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"VC Completed");
    }];
#elif 0
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"Smile everyday"];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    // 4.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        NSLog(@"executionSignals: %@", x);
        [x subscribeNext:^(id x) {
            NSLog(@"executionSignals data: %@",x);
        }];
    }];
    
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"switchToLatest: %@",x);
    }];
    
    // 5.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:0] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行: %@", x);
            
        }else{
            // 执行完成
            NSLog(@"执行完成: %@", x);
        }
    }];
    
    // 3.执行命令
    [[command execute:@1] subscribeNext:^(id x) {
        NSLog(@"receive data: %@", x);
    } error:^(NSError *error) {
        NSLog(@"execute: %@", error);
    } completed:^{
        NSLog(@"execute complete");
    }];
    
    /* log
     执行完成: 0
     signalBlock input: 1
     正在执行: 1
     executionSignals: <RACDynamicSignal: 0x600000036680> name:
     loadData
     Next
     executionSignals: Smile
     switchToLatest: Smile
     Complete
     执行完成: 0
    */
#else
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"create command");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSLog(@"create signal");
            
            if (/* DISABLES CODE */ (YES)) {
                [subscriber sendNext:@"Smile"];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:@"Network failed" code:0005 userInfo:nil]];
            }
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号被销魂了");
            }];
        }];
    }];
    
    id subscriber = [command execute:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [subscriber subscribeNext:^(id x) {
            NSLog(@"receive data: %@", x);
        }];
    });
    
    
    
//    [[command execute:nil] subscribeNext:^(id x) {
//        NSLog(@"receive data: %@", x);
//    }];
    
#endif
}

- (void)testRACReplaySubject
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    // 第一次订阅
    [subject subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    
    [subject sendNext:@"1"];
    
    // 第一次订阅
    [subject subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self testRACCommand];
//    [[self.viewModel.command execute:nil] subscribeNext:^(id x) {
//        NSLog(@"Command Data: %@", x);
//    } error:^(NSError *error) {
//        NSLog(@"%@", error);
//    } completed:^{
//        NSLog(@"VC Completed");
//    }];
    
//    [self testMultiConnection];
    [self testRACCommand];
}

#pragma mark - TestViewDelegate
//- (void)testViewDidClick:(TestView *)testView
//{
//    NSLog(@"TestView 按钮点击了。。。");
//}

@end
