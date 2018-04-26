//
//  FastWebURLProtocol.h
//  FastWebURLProtocol
//
//  Created by Allen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface FastWebURLProtocol : NSURLProtocol

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client;

@end
