//
//  ViewController.m
//  FastWebView
//
//  Created byAllen on 2018/4/25.
//  Copyright © 2018年 taobao.com. All rights reserved.
//

#import "ViewController.h"
#import "ShopWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)pushWebAction:(id)sender {
    ShopWebViewController *web = [[ShopWebViewController alloc] init];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
