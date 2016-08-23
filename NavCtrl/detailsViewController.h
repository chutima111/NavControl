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

@interface detailsViewController : UIViewController

@property (nonatomic, strong) NSString *productUrl;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) productClass *product;

@end
