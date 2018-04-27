//
//  FastWebViewController+JSBridge.m
//  FastWebView
//
//  Created byAllen on 2018/4/26.
//  Copyright © 2018年 taobao.com. All rights reserved.
//

#import "FastWebViewController+JSBridge.h"
#import "FastToast.h"
#import "FasterRoute.h"
static NSString * const kPasteboardJSBridge = @"pasteboardJSBridge";
static NSString * const kPasteboardText = @"pasteboardText";

static NSString * const kOpenNewWindow = @"openNewWindowJSBridge";
static NSString * const kURL = @"url";

static NSString * const kGoback = @"gobackJSBridge";
static NSString * const kControllerPop = @"controllerPopJSBridge";

@implementation FastWebViewController (JSBridge)
- (void)initWithJSBridge {
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    [self registBaseJSBridge];
}

- (void)registBaseJSBridge {
    [self registPasteboard];
    [self registOpenNewWindow];
    [self registWebGoBack];
    [self registControllerPop];
}

#pragma mark - 剪切板功能
- (void)registPasteboard {
    [self.bridge registerHandler:kPasteboardJSBridge handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *valueString = [data objectForKey:kPasteboardText];
        if (valueString != nil) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = valueString;
            [FastToast showToastSuccessMsg:@"复制成功"];
        }
    }];
}

#pragma mark - 打开一个新的web容器
- (void)registOpenNewWindow {
    [self.bridge registerHandler:kOpenNewWindow handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *url = [data objectForKey:kURL];
        if (url != nil) {
           [FasterRoute openURLString:[NSString stringWithFormat:@"faster://web/base?loadURLString=%@",url]];
        }
    }];
}

#pragma mark - 调用goback
- (void)registWebGoBack {
    __weak typeof(self)weakSelf = self;
    [self.bridge registerHandler:kGoback handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([weakSelf.webView canGoBack]) {
            [weakSelf.webView goBack];
        }

    }];
}

#pragma mark - 调用系统返回按钮
- (void)registControllerPop {
    __weak typeof(self)weakSelf = self;
    [self.bridge registerHandler:kControllerPop handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
}
@end
