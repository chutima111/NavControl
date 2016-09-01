//
//  detailsViewController.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/10/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "productClass.h"
#import "companyInfoClass.h"

@interface detailsViewController : UIViewController

@property (nonatomic, strong) NSString *productUrl;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) productClass *product;
@property (nonatomic, strong) companyInfoClass *company;


@end
