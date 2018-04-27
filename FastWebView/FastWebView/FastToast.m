//
//  AKToast.m
//  AKToast
//
//  Created by allen on 2017/7/13.
//  Copyright © 2017年 Alijk.com. All rights reserved.
//

#import "FastToast.h"
#import "MBProgressHUD.h"
static NSInteger const hudFontSize = 15;
@interface FastToast ()
@property (nonatomic, strong) MBProgressHUD  *hudView;
@end

@implementation FastToast
+(instancetype)shareinstance {
    static FastToast *toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[FastToast alloc] init];
    });
    return toast;
}

+ (void)showToastMsg:(NSString *)msg {
    [self showToastMsg:msg delay:1.8];
}

+ (void)showToastMsg:(NSString *)msg image:(UIImage *)image {
    [self showToastMsg:msg delay:1.8 yOffset:0 hudImage:image];
}

+ (void)showToastSuccessMsg:(NSString *)successMsg {
      UIImage *image = [UIImage imageNamed:[@"FastToast.bundle" stringByAppendingPathComponent:@"hudSuccess"]];
    [self showToastMsg:successMsg delay:1.8 yOffset:0 hudImage:image];
}
+ (void)showToastErrorMsg:(NSString *)errorMsg {
    UIImage *image = [UIImage imageNamed:[@"FastToast.bundle" stringByAppendingPathComponent:@"hudError"]];
    [self showToastMsg:errorMsg delay:1.8 yOffset:0 hudImage:image];
}


+ (void)showToastMsg:(NSString *)msg delay:(NSTimeInterval)delay {
    [self showToastMsg:msg delay:delay yOffset:0];
}

+ (void)showToastMsg:(NSString *)msg delay:(NSTimeInterval)delay yOffset:(float)yOffset  {
    [self showToastMsg:msg delay:delay yOffset:yOffset hudImage:nil];
}

+ (void)showToastMsg:(NSString *)msg delay:(NSTimeInterval)delay yOffset:(float)yOffset hudImage:(UIImage *)image {
    [self hideToast];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
        [FastToast shareinstance].hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
        [FastToast shareinstance].hudView.mode = MBProgressHUDModeCustomView;
        [FastToast shareinstance].hudView.labelFont = [UIFont systemFontOfSize:hudFontSize];
        if (image) {
            [FastToast shareinstance].hudView.customView = [[UIImageView alloc] initWithImage:image];
        }
        [FastToast shareinstance].hudView.removeFromSuperViewOnHide = YES;
        [FastToast shareinstance].hudView.yOffset = yOffset;
        [FastToast shareinstance].hudView.labelText = msg;
        [FastToast shareinstance].hudView.dimBackground = NO;
        [[FastToast shareinstance].hudView hide:YES afterDelay:delay];
    });

}

+ (void)showToastLoadingMsg:(NSString *)msg {
    [self showToastLoadingMsg:msg graceTime:0];
}

+ (void)showToastLoadingMsg:(NSString *)msg delay:(NSTimeInterval)delay {
    [self showToastLoadingMsg:msg delay:delay graceTime:0 dimBackground:NO mode:MBProgressHUDModeIndeterminate];
}

+ (void)showToastLoadingMsg:(NSString *)msg graceTime:(float)graceTime {
    [self showToastLoadingMsg:msg delay:30 graceTime:graceTime dimBackground:NO mode:MBProgressHUDModeIndeterminate];
}

+ (void)showToastLoadingMsg:(NSString *)msg graceTime:(float)graceTime dimBackground:(BOOL)dimBackground {
    [self showToastLoadingMsg:msg delay:30 graceTime:graceTime dimBackground:dimBackground mode:MBProgressHUDModeIndeterminate];
}

+ (void)showToastLoadingMsg:(NSString *)msg delay:(NSTimeInterval)delay graceTime:(float)graceTime dimBackground:(BOOL)dimBackground mode:(MBProgressHUDMode)mode  {
    [self hideToast];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
        [FastToast shareinstance].hudView = [MBProgressHUD showHUDAddedTo:view animated:YES];
        [FastToast shareinstance].hudView.labelFont = [UIFont systemFontOfSize:hudFontSize];
        [FastToast shareinstance].hudView.removeFromSuperViewOnHide = YES;
        [FastToast shareinstance].hudView.labelText = msg;
        [FastToast shareinstance].hudView.mode = mode;
        [FastToast shareinstance].hudView.dimBackground = dimBackground;
        [FastToast shareinstance].hudView.minShowTime = 0.3; //最少执行0.3 秒
        [FastToast shareinstance].hudView.graceTime = graceTime; //设置几秒后开始显示，用户体验更好;
        [[FastToast shareinstance].hudView hide:YES afterDelay:delay];
    });
}

+ (void)hideToast {
    if ([FastToast shareinstance].hudView != nil || ![FastToast shareinstance].hudView.isHidden) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[FastToast shareinstance].hudView hide:YES];
        });

    }
}

@end
