//
//  ViewController.m
//  TouchIDAndFaceIDDemo
//
//  Created by 贺文杰 on 2019/7/15.
//  Copyright © 2019 贺文杰. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self verifyIsTouchIDOrFaceID];
}

- (void)verifyIsTouchIDOrFaceID
{
    ///使用Touch ID和Face ID必须确保app处于活动状态
    if(@available(iOS 8.0, *)){
        LAContext *context = [LAContext new];
        NSError *error = nil;
        LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
        if (@available(iOS 9.0, *)) {
            policy = LAPolicyDeviceOwnerAuthentication;
        }
        BOOL isCanEvaluatePolicy = [context canEvaluatePolicy:(policy) error:&error];
        if (error) {
            NSLog(@"error = %@", error);
        }else{
            if (isCanEvaluatePolicy) {
                if (context.biometryType == LABiometryTypeNone) {
                    NSLog(@"调用不起");
                    return;
                }
                if (@available(iOS 11.0, *)) {
                    [self getTouchIDOrFaceIDStatus:context isTouchID:NO];
                }else{
                    [self getTouchIDOrFaceIDStatus:context isTouchID:YES];
                }
            }
        }
    }

}

- (void)getTouchIDOrFaceIDStatus:(LAContext *)context isTouchID:(BOOL)isTouchID
{
    context.localizedFallbackTitle = @"另一种方式验证";
    /*
     LAPolicyDeviceOwnerAuthenticationWithBiometrics 生物识别
     LAPolicyDeviceOwnerAuthentication 生物识别+密码认证
     */
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    if (@available(iOS 9.0, *)) {
        policy = LAPolicyDeviceOwnerAuthentication;
    }
    ///如果超出尝试次数，这里的block不会执行
    [context evaluatePolicy:policy localizedReason:NSLocalizedString(@"通过验证指纹解锁", nil) reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"验证成功");
        }else{
            if (error.code == kLAErrorUserFallback) {
                NSLog(@"用户选择了另一种方式");
            }else if (error.code == kLAErrorUserCancel){
                NSLog(@"用户取消");
            }else if (error.code == kLAErrorSystemCancel){
                NSLog(@"切换前台被取消");
            }else if (error.code == kLAErrorPasscodeNotSet){
                NSLog(@"未设置系统密码");
            }else if (error.code == kLAErrorBiometryLockout){
                NSLog(@"生物识别被锁住，指TouchID或FaceID识别次数达到最大次数(5次)");
            }else if (error.code == kLAErrorTouchIDNotAvailable){
                NSLog(@"TouchID不可用");
            }else if (error.code == kLAErrorTouchIDNotEnrolled){
                NSLog(@"未设置TouchID");
            }else if (error.code == kLAErrorTouchIDLockout){
                NSLog(@"TouchID被锁住 建议判断LAErrorBiometryLockout即可");
            }else if (error.code == kLAErrorAuthenticationFailed){
                NSLog(@"身份验证不成功，因为用户无法提供有效的凭据。");
            }else if (error.code == kLAErrorAppCancel){
                NSLog(@"应用程序取消了身份验证");
            }
            else{
                NSLog(@"验证失败");
            }
        }
    }];
}

@end
