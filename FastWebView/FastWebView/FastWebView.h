//
//  FastWebView.h
//  FastWebView
//
//  Created by Allen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface FastWebView :WKWebView<WKUIDelegate,WKNavigationDelegate>

- (instancetype)initWithFrame:(CGRect)frame cookie:(NSString *)cookie;
/**
 是否开启下拉刷新控件 默认NO
 */
@property (nonatomic, assign) BOOL isOpenRefreshControl;

/**
 加载本地HTML

 @param htmlName HTML名称
 */
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName;

@end
