//
//  YTKBaseRequest.m
//
//  Copyright (c) 2012-2014 YTKNetwork https://github.com/yuantiku
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "YTKBaseRequest.h"
#import "YTKNetworkAgent.h"
#import "YTKNetworkPrivate.h"
#import "AFHTTPSessionManager.h"

@implementation YTKBaseRequest

/// for subclasses to overwrite
- (void)requestCompleteFilter {
}

- (void)requestFailedFilter {
}

- (NSString *)requestUrl {
    return @"";
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (id)requestArgument {
    return nil;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGet;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
//    AFHTTPSessionManager* manger=[[AFHTTPSessionManager alloc]init];
//    NSMutableURLRequest *request = [manger.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:@"https://www.v2ex.com/api/topics/hot.json"] absoluteString] parameters:nil error:nil];
//    return request;
    return nil;
}

- (BOOL)useCDN {
    return NO;
}

- (id)jsonValidator {
    return nil;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}

- (NSString *)resumableDownloadPath {
    return nil;
}

- (AFDownloadProgressBlock)resumableDownloadProgressBlock {
    return nil;
}

/// append self to request queue
- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[YTKNetworkAgent sharedInstance] addRequest:self];
}

/// remove self from request queue
- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[YTKNetworkAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (BOOL)isExecuting {
    //NSURLSessionDataTask比AFHTTPRequestOperation的isExceting多几个状态
    if(self.requestTask.state==NSURLSessionTaskStateRunning)
    {
        return YES;
    }else
    {
        return NO;
    }
}

- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success
                                    failure:(YTKRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success
                              failure:(YTKRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (id)responseJSONObject {
    if(!_responseJSONObject)
    {
        if(self.responseData)
        {
            _responseJSONObject =[[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
        }else if(self.responseString){
            _responseJSONObject=self.responseString;
        }
    }
    return _responseJSONObject;
}

//
//- (NSData *)responseData {
//    userInfo[AFNetworkingTaskDidCompleteResponseSerializerKey] = manager.responseSerializer;
//    return self.requestTask.responseData;
//}
//

- (NSString *)responseString {
    if(!_responseString)
    {
        if(self.responseData)
        {
            _responseString =[[NSString alloc]initWithData:self.responseData encoding:NSUTF8StringEncoding];
        }
    }
    return _responseString;
}

- (NSInteger)responseStatusCode {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)self.requestTask.response;
    return httpResponse.statusCode;
}

- (NSDictionary *)responseHeaders {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)self.requestTask.response;
    return httpResponse.allHeaderFields;
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<YTKRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

@end
