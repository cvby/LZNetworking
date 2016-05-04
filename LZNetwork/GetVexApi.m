//
//  GetVexApi.m
//  YTKNetworkDemo
//
//  Created by admin on 16/5/3.
//  Copyright © 2016年 yuantiku.com. All rights reserved.
//

#import "GetVexApi.h"

@implementation GetVexApi

- (NSString *)requestUrl {
    return @"/api/topics/hot.json";
}

- (id)jsonValidator {
    return @[@{
                 @"title": [NSString class],
                 @"id": [NSNumber class]
                 }];
}

- (NSInteger)cacheTimeInSeconds {
    return 60 * 3;
}

@end
