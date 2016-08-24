//
//  AddNewCompanyViewController.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface AddNewCompanyViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *txfCompanyName;
@property (retain, nonatomic) IBOutlet UITextField *txfCompanyImageUrl;
@property (retain, nonatomic) IBOutlet UITextField *txfCompanyTicker;


@end
