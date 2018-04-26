//
//  FastWebView.m
//  FastWebView
//
//  Created byAllen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//

#import "FastWebView.h"
#import "NSURLProtocol+WebKitSupport.h"
#import "FastWebURLProtocol.h"
@interface FastWebView ()
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation FastWebView

- (instancetype)initWithFrame:(CGRect)frame cookie:(NSString *)cookie {
    WKUserContentController* userContentController = WKUserContentController.new;
    if (cookie.length > 0) {
        NSString *source = [NSString stringWithFormat:@"document.cookie = 'Cookie = %@' ",cookie];
        
        WKUserScript *cookieScript = [[WKUserScript alloc]
                                      initWithSource:source
                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
    }
    
 
    [self openURLProtocol];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    configuration.allowsInlineMediaPlayback = YES;
////    NSString *related = [NSString stringWithFormat:@"%@%@%@",@"_setRe", @"latedWe", @"bView:"];
////    SEL relatedSel = NSSelectorFromString(related);
////    if([configuration respondsToSelector:relatedSel]){
////        [configuration performSelector:relatedSel withObject:self];
////    }
   
    configuration.userContentController = userContentController;
    WKPreferences *preferences = [WKPreferences new];
    //是否支持JavaScript
    preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    configuration.selectionGranularity = YES;
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        //侧滑返回上一页
        self.allowsBackForwardNavigationGestures = YES;
        self.UIDelegate = self;
        self.navigationDelegate = self;
    }
    return self;
}

- (void)openURLProtocol {
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    [NSURLProtocol registerClass:[FastWebURLProtocol class]];
}

- (void)setIsOpenRefreshControl:(BOOL)isOpenRefreshControl {
    if (_isOpenRefreshControl != isOpenRefreshControl) {
        _isOpenRefreshControl = isOpenRefreshControl;
         [self.scrollView addSubview:self.refreshControl];
    }
}

-(void)refreshAction:(UIRefreshControl *)refreshs {
    if (refreshs.refreshing) {
        refreshs.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新..."];
    }
    [self reload];
}

- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [self loadHTMLString:htmlCont baseURL:baseURL];
}
#pragma mark - WKNavigationDelegate
/* 页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.isOpenRefreshControl) {
        [self.refreshControl endRefreshing];
    }
    
    NSLog(@"web 加载完成");
}

/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"web 加载失败");
}

/* 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

/* 在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

#pragma mark - 刷新控件
- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

@end
