//
//  EditCompanyViewController.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/22/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "companyInfoClass.h"

@interface EditCompanyViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *txfCompanyName;
@property (retain, nonatomic) IBOutlet UITextField *txfCompanyImageURL;

@property (retain, nonatomic) IBOutlet UITextField *txfCompanyTicker;
@property (nonatomic, strong) companyInfoClass *company;

@end
