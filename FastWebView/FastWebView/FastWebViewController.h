//
//  FastWebViewController.h
//  FastWebView
//
//  Created byAllen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastWebViewController : UIViewController

/**
 加载Web 页面 URL
 */
@property (nonatomic, strong, nonnull) NSString *loadURLString;

/**
 设置userAgent
 */
@property (nonatomic, strong, nonnull) NSString *userAgent;

/**
 手动注入cookie
 */
@property (nonatomic, strong, nonnull) NSString *cookieString;

/**
 进度条顶部间距
 */
@property (nonatomic, assign) CGFloat progressMarginTop;

/**
 进度条颜色
 */
@property (nonatomic, strong, nonnull) UIColor *progressColor;

/**
 是否禁止Web滚动 默认NO
 */
@property (nonatomic, assign) BOOL webScrollEnded;

/**
 是否开启下拉刷新控件 默认NO
 */
@property (nonatomic, assign) BOOL isOpenRefreshControl;

/**
 加载本地HTLM
 */
@property (nonatomic, strong, nonnull) NSString *localHTMLName;

@end
