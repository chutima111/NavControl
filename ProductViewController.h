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
#import "DAO.h"


@interface ProductViewController : UIViewController

@property (nonatomic, strong) companyInfoClass *company;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIImageView *imgCompany;
@property (retain, nonatomic) IBOutlet UILabel *lblNameAndTicker;
- (IBAction)addButtonPressed:(id)sender;

@end
