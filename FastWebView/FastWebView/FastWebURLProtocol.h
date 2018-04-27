//
//  FastWebURLProtocol.h
//  FastWebURLProtocol
//
//  Created by Allen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//   暂时没实现啥，如何需要重定向或者缓存图片支持web 可在此协议扩展。
#import <Foundation/Foundation.h>

@interface FastWebURLProtocol : NSURLProtocol

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client;

@end
