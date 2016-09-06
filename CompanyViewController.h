//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ProductViewController;
@class AddNewCompanyViewController;

@interface CompanyViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *companies;

@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;

@property (retain, nonatomic) IBOutlet UIButton *btnUndo;
@property (retain, nonatomic) IBOutlet UIButton *btnRedo;
- (IBAction)undoButtonPressed:(id)sender;
- (IBAction)redoButtonPressed:(id)sender;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
