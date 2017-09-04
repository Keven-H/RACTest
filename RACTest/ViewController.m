//
//  ViewController.m
//  RACTest
//
//  Created by Admin on 2017/8/29.
//  Copyright © 2017年 MYF. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RACReturnSignal.h"
#import "LoginViewModel.h"
@interface ViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnTest;
@property (nonatomic, strong) RACDisposable *loadingDispose;


/** VM  */
@property(nonatomic,strong) LoginViewModel * loginVM;

@end
///Users/admin/Xcode Demo/RACTest/Pods/ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h

@implementation ViewController
-(LoginViewModel *)loginVM
{
    //有效避免出错!!
    if (nil == _loginVM) {
        _loginVM = [[LoginViewModel alloc]init];
        
    }
    return _loginVM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNewViews];
//    [self demo1];
//    [self demo2];
//    [self demo3];
//    [self demo4];
//    [self mapDemo];
//    [self flattenMapDemo];
//    [self demo5];// 映射信号
//    [self demo6]; //组合!!
//    [self showLoading];
    [self demoLogin];
}
- (void) demoLogin{
    //1.给模型的账号&&密码绑定信号!!
    RAC(self.loginVM,account) = _textField.rac_textSignal;
    RAC(self.loginVM,pwd) = _textField.rac_textSignal;
//    //2.设置按钮
    RAC(_btnTest,enabled) = self.loginVM.loginEnableSignal;
    //3.监听登录按钮的点击
    [[_btnTest rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //处理登录事件 执行登陆的命令
        [self.loginVM.loginCommand execute:@"执行登陆的命令"];
    }];
}
- (void)showLoading {
    
    [self.loadingDispose dispose];//上次信号还没处理，取消它(距离上次生成还不到1秒)
    @weakify(self);
    self.loadingDispose = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendCompleted];
        NSLog(@"==1111111111=== ");
        return nil;
    }] delay:1] subscribeCompleted:^{
                               @strongify(self);
                               self.loadingDispose = nil;
        NSLog(@"==2222222222=== ");
                           }];
//    [self.loadingDispose dispose];
    
//    RACSignal *loggingSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {//BLOCK_1
//        [subscriber sendNext:@"mytest"];
//        [subscriber sendCompleted];
//        return nil;
//    }];
//    
//    loggingSignal = [loggingSignal delay:10];
//    
//    self.loadingDispose = [loggingSignal subscribeNext:^(NSString* x){//BLOCK_2
//        NSLog(@"%@",x);
//        NSLog(@"subscription %u", subscriptions);
//    }];
//    
//    self.loadingDispose = [loggingSignal subscribeCompleted:^{//BLOCK_3
//        NSLog(@"subscription %u", subscriptions);
//    }];
}
- (void) demo6{
        //组合!!
        //创建信号!!
        RACSignal * signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"发送请求A");
            //发送数据
            [subscriber sendNext:@"数据A"];
            //哥么结束了!!
            [subscriber sendCompleted];
            //        [subscriber sendError:nil]; 这哥么不行!
            
            return nil;
        }];
        
        RACSignal * signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"发送请求B");
            //发送数据
            [subscriber sendNext:@"数据B"];
            [subscriber sendCompleted];
            return nil;
        }];
        
        RACSignal * signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"发送请求C");
            //发送数据
            [subscriber sendNext:@"数据C"];
            
            return nil;
        }];
        
        //concat:按顺序组合!!
        //创建组合信号!!
        //    RACSignal * concatSignal = [[signalA concat:signalB] concat:signalC];
        
        RACSignal * concatSignal = [RACSignal concat:@[signalA,signalB,signalC]];
        
        //订阅组合信号
        [concatSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    
        
}
- (void) demo5{
    //flattenMap 一般用于信号中的信号
    RACSubject * signalOfSignal = [RACSubject subject];
    RACSubject * signal = [RACSubject subject];
    
    //订阅信号
    //    [signalOfSignal subscribeNext:^(RACSignal * x) {
    //        [x subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"%@",x);
    //        }];
    //    }];
    
    //    [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
    [[signalOfSignal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
    
        NSLog(@"value %@",value);
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"22%@",x);
    }];
    
    //    [bindSignal subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
    //发送信号
    [signalOfSignal sendNext:signal];
    [signal sendNext:@"123"];
}
-(void)mapDemo{
    //创建信号
    RACSubject * subject = [RACSubject subject];
    
    //绑定
    [[subject map:^id _Nullable(id  _Nullable value) {
        //返回的数据就是需要处理的数据
        return [NSString stringWithFormat:@"处理数据%@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"111%@",x);
    }];
    
    //发送数据
    [subject sendNext:@"123"];
    [subject sendNext:@"321"];
    
}

-(void)flattenMapDemo{
    //创建信号
    RACSubject * subject = [RACSubject subject];
    
    //绑定信号
    RACSignal * bindSignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        //block:只要源信号发送内容就会调用
        //value:就是源信号发送的内容
        value = [NSString stringWithFormat:@"处理数据:%@",value];
        
        //返回信号用来包装修改过的内容
        return [RACReturnSignal return:value];
    }];
    
    //订阅绑定信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //发送数据
    [subject sendNext:@"123"];
    
}
- (void) demo4{
    //RACCommand 命令
    //1.创建命令
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"111%@",input);
        //input:指令
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //发送数据
            [subscriber sendNext:@"3333执行完命令之后产生的数据"];
            
            //因为监听了事件状态 需要调用 发送完成
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    //监听事件有没有执行完毕
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        if([x boolValue]){ //正在执行!!
            NSLog(@"2222正在执行!!");
        }else{
            NSLog(@"已经结束咯&&还没开始做!");
        }
    }];
    
    
    RACSignal * signal =  [command execute:@"000 执行!!"];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"4444接受到数据了!!%@",x);
    }];
}
- (void) demo3{
        //RACCommand 命令
        //1.创建命令
        RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            NSLog(@"input%@",input);
            //input:指令
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                //发送数据
                [subscriber sendNext:@"执行完命令之后产生的数据"];
                
                return nil;
            }];
        }];
        
        //订阅信号
        //executionSignals:信号源!!,发送信号的信号!
        //    [command.executionSignals subscribeNext:^(RACSignal * x) {
        //        [x subscribeNext:^(id  _Nullable x) {
        //            NSLog(@"%@",x);
        //        }];
        //        NSLog(@"%@",x);
        //    }];
        
        //switchToLatest 获取最新发送的信号.
        [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            NSLog(@"最新发送的信号%@",x);
        }];
        //2.执行命令
        [command execute:@"执行命令!!"];
}
- (void) demo2{
    //1.创建信号
    RACSubject * subject = [RACSubject subject];
    //2.绑定信号
    RACSignal * bindSignal = [subject bind:^RACStreamBindBlock _Nonnull{
        return ^RACSignal * (id value, BOOL *stop){
            //block调用:只要源信号发送数据,就会调用bindBlock
            //block作用（使用场景）:处理原信号内容
            //value:源信号发送的内容
            value = [NSString stringWithFormat:@"修改了 %@",value];
            //返回信号,不能传nil , 返回空信号 :[RACSignal empty]
            
            NSLog(@"%@",value);
            return [RACReturnSignal return:value];
        };
    }];
    
    //3.订阅信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"绑定接收到!==! %@",x);
    }];
    
    //4.发送
    [subject sendNext:@"发送原始的数据100"];
}
- (void) demo1{
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        [_btnTest setTitle:x forState:UIControlStateNormal];
        [_btnTest sizeToFit];
        CGFloat width = _btnTest.frame.size.width;
        
        if (width < [UIScreen mainScreen].bounds.size.width - 2 * 100) {
            _btnTest.frame = CGRectMake(100, 50, width, _btnTest.bounds.size.height);
        }else{
            _btnTest.frame = CGRectMake(100, 50, [UIScreen mainScreen].bounds.size.width - 2 * 100, _btnTest.bounds.size.height);
        }
    }];
    
    [[_btnTest rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"frame  =-=%@",x);
    }];
    [[_btnTest rac_valuesForKeyPath:@"backgroundColor" observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"backgroundColor  =-=%@",x);
    }];
}
- (void) addNewViews{
    _btnTest = [[UIButton alloc] initWithFrame:CGRectMake(100, 50, 100, 30)];
    _btnTest.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_btnTest];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    _textField.placeholder = @"请输入内容";
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];
    
    
//    [[_btnTest rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"======= %@",x);
//        UIButton *btn = (UIButton *)x;
//        btn.selected = !btn.selected;
//        if (btn.selected) {
//            btn.backgroundColor = [UIColor redColor];
//        }else{
//            btn.backgroundColor = [UIColor orangeColor];
//        }
//    }];
}
- (void) btnClick{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"发送信号....."];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}
@end
