//
//  FastWebViewController.m
//  FastWebView
//
//  Created byAllen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//

#import "FastWebViewController.h"

#import "FastWebViewController+JSBridge.h"
#import "UIViewController+BackButtonHandler.h"
#define kWebWidth [UIScreen mainScreen].bounds.size.width
#define kWebHeight [UIScreen mainScreen].bounds.size.height
static NSString *const kTitle = @"title";
static NSString *const kEstimatedProgress = @"estimatedProgress";
@interface FastWebViewController ()

@property (nonatomic, assign) BOOL isUseCookie;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation FastWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUseCookie = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self initWithJSBridge];
    [self initWithProgressView];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCookieString:(NSString *)cookieString {
    _cookieString = cookieString;
    if (_cookieString.length == 0) {
         self.isUseCookie = NO;
    } else {
        self.isUseCookie = YES;
    }
}

- (BOOL)navigationShouldPopOnBackButton{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 进度条设置
- (void)initWithProgressView {
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame),5)];
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
}

- (void)setProgressColor:(UIColor *)progressColor {
    self.progressView.progressTintColor = progressColor;
}

- (void)setProgressMarginTop:(CGFloat)marginTop {
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0,
                                                                        64,
                                                                        CGRectGetWidth(self.view.frame),
                                                                        5)];
}


- (void)setIsOpenRefreshControl:(BOOL)isOpenRefreshControl {
    if (_isOpenRefreshControl != isOpenRefreshControl) {
        self.webView.isOpenRefreshControl = isOpenRefreshControl;
       
    }
}

- (void)setLocalHTMLName:(NSString *)localHTMLName {
    if (localHTMLName.length > 0) {
        [self.webView loadLocalHTMLWithFileName:localHTMLName];
    }
}

- (void)setWebScrollEnded:(BOOL)webScrollEnded {
    [self.webView.scrollView setScrollEnabled:webScrollEnded];
}

- (void)setUserAgent:(NSString *)userAgent {
    if (userAgent.length == 0) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        __weak typeof(self)weakSelf = self;
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSString *userAgentResult = result;
            NSString *newUserAgent = [userAgentResult stringByAppendingString:userAgent];
            if (@available(iOS 9.0, *)) {
                [strongSelf.webView setCustomUserAgent:newUserAgent];
            } else {
                // Fallback on earlier versions
            }
            NSLog(@"UserAgent = %@",[[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"]);
        }];
    } else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *newUserAgent = [userAgent stringByAppendingString:userAgent];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }

}

#pragma mark - Web
- (FastWebView *)webView {
    if (!_webView) {
        _webView = [[FastWebView alloc] initWithFrame:CGRectMake(0, 0,kWebWidth, kWebHeight) cookie:self.cookieString];
        [_webView addObserver:self forKeyPath:kTitle options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:kEstimatedProgress options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    }
    
    return _webView;
}

- (void)setLoadURLString:(NSString *)loadURLString {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadURLString]];
    if (self.isUseCookie) {
        [request addValue:self.cookieString forHTTPHeaderField:@"Cookie"];
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
         request.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
    }

    [self.webView loadRequest:request];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:kEstimatedProgress] && object == _webView) {
           if (self.webView.estimatedProgress <= 0) {
                return;
            }
        
            NSLog(@"progress==%f",self.webView.estimatedProgress);
        
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
            if(self.webView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3
                                      delay:0.3
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        
        } else if ([keyPath isEqualToString:kTitle]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:kEstimatedProgress];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_webView removeObserver:self forKeyPath:kTitle];
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
