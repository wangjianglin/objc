//
//  ViewController.m
//  demo
//
//  Created by lin on 1/15/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import "ViewController.h"
#import "TestHttpPackage.h"
#import "LinClient/client.h"

@interface ViewController ()

@end

@implementation ViewController


- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName{
    if ([hostName hasSuffix:@"feicuibaba.com"]) {
        return FALSE;
    }
    return TRUE;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [HttpCommunicate setCommUrl:@"http://s.feicuibaba.com"];
    
    
    id<HttpDNS> dns = [[AliHttpDNS alloc] initWithAccount:@"172280"];
    
    [dns setPreResolveHosts:@[@"s.feicuibaba.com"]];
//    [dns setDelegate:self];
    dns.delegate = self;
    
    [HttpCommunicate setHttpDNS:dns];
    
}
-(IBAction)http:(NSObject*)_{
    
    TestHttpPackage * pack = [[TestHttpPackage alloc] init];
    
//    [pack setData:@"测试数据"];
    [pack setData:@"test data!"];
    
    [HttpCommunicate request:pack result:^(NSObject *obj, NSArray *warning) {
        NSLog(@"%@",obj);
    } fault:^(HttpError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
