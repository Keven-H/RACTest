//
//  LoginViewModel.h
//  001--RAC映射
//
//  Created by H on 2017/4/28.
//  Copyright © 2017年 TZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface LoginViewModel : NSObject

/** 账号&&密码  */
@property(nonatomic,strong)NSString * account;
@property(nonatomic,strong)NSString * pwd;

/**  处理登录按钮能否点击的信号 */
@property(nonatomic,strong)RACSignal * loginEnableSignal;

/** 登录按钮命令  */
@property(nonatomic,strong)RACCommand * loginCommand;

@end
