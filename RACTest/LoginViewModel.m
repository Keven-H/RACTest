//
//  LoginViewModel.m
//  001--RAC映射
//
//  Created by H on 2017/4/28.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

-(instancetype)init{
    if (self = [super init]) {
        
        //初始化
        [self setUP];
        
    }
    return self;
}


-(void)setUP{
    //处理登录点击的信号
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id _Nullable(NSString * account,NSString * pwd){
        return @(account.length && pwd.length);
    }];
    
    
    //处理登录的命令
    //创建命令
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //处理事件密码加密
        NSLog(@"收到命令----");
        NSLog(@"拿到input信息：%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //发送请求&&获取登录结果!!
            NSLog(@"0=0==0=请求接口=0=0");
            [subscriber sendNext:@"请求登录的数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    //获取命令中信号源
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"--最后--%@",x);
    }];
    
    //监听命令执行过程!!
//    [_loginCommand.executing subscribeNext:^(NSNumber * _Nullable x) {
//        
//    }];
    [[_loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        
        if ([x boolValue]) {
            //正在执行
            NSLog(@"正在执行命令----显示菊花!!");
        }else{
            NSLog(@"干掉菊花!!");
        }
        
    }];
    
}

@end
