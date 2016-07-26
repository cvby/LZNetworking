//
//  ViewController.m
//  LZNetwork
//
//  Created by admin on 16/5/4.
//  Copyright © 2016年 李政. All rights reserved.
//

#import "ViewController.h"
#import "GetVexApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadVexApi];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)loadVexApi{
    GetVexApi* api =[[GetVexApi alloc] init];
    if ([api cacheJson]) {
        NSDictionary *json = [api cacheJson];
        NSLog(@"json = %@", json);
        // show cached data
    }
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"%@",request.responseString);
    } failure:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"%@",request.responseString);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
