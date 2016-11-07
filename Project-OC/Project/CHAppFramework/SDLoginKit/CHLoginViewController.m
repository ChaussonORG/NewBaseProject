//
//  CHLoginViewController.m
//
//  Created by Chausson on 15/11/4.
//  Copyright © Chausson. All rights reserved.
//

#import "CHLoginViewController.h"
#import "CHLoginModalController.h"
#import "SDLoginAPI.h"
#import <CHProgressHUD/CHProgressHUD.h>
#define UINAVGATIONHEIGHT 64
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CHLoginViewController ()

@end

@implementation CHLoginViewController{
   
}
#pragma mark init

#pragma mark Activity
- (void)viewDidLoad {
    [super viewDidLoad];
    [CHProgressHUD setTextDuration:0.8];
    [self regisetButtonAction];
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setHidden:TRUE];

 
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:FALSE];
}
#pragma mark Private
- (void)regisetButtonAction{
    
    if (self.registerBtn) {
        [self.registerBtn addTarget:self action:@selector(regisetAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    if (self.backBtn) {
        self.backBtn.hidden = !self.loginModalViewController.needBackButton;
        [self.backBtn addTarget:self action:@selector(backForword:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    if (self.forgetBtn) {
        [self.forgetBtn addTarget:self action:@selector(resetPassword:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    [self.username addTarget:self action:@selector(textChange:) forControlEvents:(UIControlEventEditingChanged)];
    [self.passWordText addTarget:self action:@selector(textChange:) forControlEvents:(UIControlEventEditingChanged)];
    self.loginBtn.backgroundColor = kUIColorFromRGB(0xb2b2b2);
    
    if (self.loginBtn) {
        [self.loginBtn addTarget:self action:@selector(login) forControlEvents:(UIControlEventTouchUpInside)];
    }
}
- (void)textChange:(UITextField *)textField{
    if (self.username.text.length >= 11 && self.passWordText.text.length >= 6) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = kUIColorFromRGB(0x01a1ff);
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = kUIColorFromRGB(0xb2b2b2);
    }
    
}

// 登录响应事件
- (void)login{
    [CHProgressHUD show:YES];
    SDLoginAPI *login = [[SDLoginAPI alloc]initWithAccount:self.username.text password:self.passWordText.text];
    [login startWithSuccessBlock:^(__kindof SDLoginAPI *request) {
        if (request.baseResponse.code == 200 ) {
            [CHProgressHUD hide:YES];
            if (self.loginModalViewController) {
                if ([self.loginModalViewController.delegate respondsToSelector:@selector(ch_willCompletionWithSuccess:)]) {
                    [self.loginModalViewController.delegate ch_willCompletionWithSuccess:request.baseResponse.data];
                }
                [self.loginModalViewController dismissViewControllerAnimated:YES completion:^{
                    if ([self.loginModalViewController.delegate respondsToSelector:@selector(ch_completionLoginWithSuccessful:)]) {
                        [self.loginModalViewController.delegate ch_completionLoginWithSuccessful:request.baseResponse.data];
                    }
                }];
            }
        }else{
            NSString *message = request.baseResponse.message;

            [CHProgressHUD hideWithText:message animated:YES];
            CHLLog(@"Login Message = %@",message);
            NSError *failureError = [[NSError alloc]initWithDomain:[NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__] code:request.baseResponse.code userInfo:@{@"message":message}];
            if ([self.loginModalViewController.delegate respondsToSelector:@selector(ch_completionLoginWithFailur:)]) {
                [self.loginModalViewController.delegate ch_completionLoginWithFailur:failureError];
            }

        }
    } failureBlock:^(__kindof CHBaseRequest *request) {
        [CHProgressHUD hideWithText:@"网络链接失败,请重新尝试" animated:YES];
        if ([self.loginModalViewController.delegate respondsToSelector:@selector(ch_completionLoginWithFailur:)]) {
            [self.loginModalViewController.delegate ch_completionLoginWithFailur:request.response.error];
        }
    }];
    
}
#pragma mark IBAction
- (void)backForword:(UIButton *)sender {

    [self.loginModalViewController dismissViewControllerAnimated:YES completion:^{
        if ([self.loginModalViewController.delegate respondsToSelector:@selector(ch_completionLoginWithCancel)]) {
            [self.loginModalViewController.delegate ch_completionLoginWithCancel];
        }
   //     self.loginModalViewController = nil;
    }];

}
- (void)regisetAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}
- (void)resetPassword:(UIButton *)sender {
    [self performSegueWithIdentifier:@"reset" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    if ([segue.identifier isEqualToString:@"register"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        if (self.loginModalViewController) {
        [segue.destinationViewController setValue:self.loginModalViewController forKey:@"loginModalViewController"];
        [segue.destinationViewController setValue:self.loginModalViewController.registerPathURL forKey:@"registerPathURL"];
        [segue.destinationViewController setValue:self.loginModalViewController.checkCodePathURL forKey:@"checkCodePathURL"];
        }
    }else{
        if (self.loginModalViewController) {
            [segue.destinationViewController setValue:self.loginModalViewController forKey:@"loginModalViewController"];
            [segue.destinationViewController setValue:self.loginModalViewController.resetPathURL forKey:@"resetPathURL"];
            [segue.destinationViewController setValue:self.loginModalViewController.checkCodePathURL forKey:@"checkCodePathURL"];
        }
    }
}
- (void)dealloc{
    
}
@end
