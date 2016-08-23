//
//  AddNewProductViewController.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/18/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyInfoClass.h"


@interface AddNewProductViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *txfProductURL;
@property (retain, nonatomic) IBOutlet UITextField *txfProductName;
@property (retain, nonatomic) IBOutlet UITextField *txfProductImageURL;

@property (nonatomic, strong) companyInfoClass *company;

@end
