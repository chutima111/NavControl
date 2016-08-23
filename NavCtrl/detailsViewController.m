//
//  detailsViewController.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/10/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "detailsViewController.h"
#import "EditProductViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the item for navigation bar
    // set the edit button on the right navigation bar
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProductInfo)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    
    // Set up WKWebview here

    self.view.frame = [[UIScreen mainScreen] bounds]; // set the view as the same size with screen
    NSURL *url = [NSURL URLWithString:self.product.productUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:theConfiguration];
    
    [_webView loadRequest:request];
//    _webView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editProductInfo
{
    // Create the new view controller
    EditProductViewController *editProductViewController = [[EditProductViewController alloc]initWithNibName:@"EditProductViewController" bundle:nil];
    
    // Create the product reference to the next view controller
    editProductViewController.product = self.product;

    
    [self.navigationController pushViewController:editProductViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
