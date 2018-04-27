//  FastWebURLProtocol.m
//  FastWebURLProtocol
//
//  Created by Allen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//
#import "FastWebURLProtocol.h"

static NSString* const kHandledKey = @"HandledKey";
@interface FastWebURLProtocol ()

@end

@implementation FastWebURLProtocol
 //如果你需要对自己关注的请求进行处理则返回YES
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
      NSString *ua = [request valueForHTTPHeaderField:@"User-Agent"];
      NSLog(@"ua===%@",ua);
//    if ([NSURLProtocol propertyForKey:kHandledKey inRequest:request]) {
//        return NO;
//    }

    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSLog(@"%s %@", __func__, [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"%s %@", __func__, [request valueForHTTPHeaderField:@"field"]);

    return request;
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if ( self ) {

    }
    return self;
}

//请求发起
- (void)startLoading {
//    NSMutableURLRequest* request = self.request.mutableCopy;
//    [NSURLProtocol setProperty:@YES forKey:kHandledKey inRequest:request];
}

//请求结束
- (void)stopLoading {
    //[self.connection cancel];
}

@end
