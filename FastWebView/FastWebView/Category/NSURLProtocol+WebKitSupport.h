
//
//   NSURLProtocol+WebKitSupport.h
//   NSURLProtocol+WebKitSupport
//
//  Created byAllen on 2018/4/26.
//  Copyright © 2018年 taobao.com. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSURLProtocol (WebKitSupport)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end
