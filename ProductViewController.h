//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailsViewController.h"
#import "companyInfoClass.h"


@interface ProductViewController : UITableViewController

@property (nonatomic, strong) companyInfoClass *company;

@end
