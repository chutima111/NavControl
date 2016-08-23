//
//  EditProductViewController.h
//  NavCtrl
//
//  Created by chutima mungmee on 8/22/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productClass.h"

@interface EditProductViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *txfProductName;
@property (retain, nonatomic) IBOutlet UITextField *txfProductURL;
@property (retain, nonatomic) IBOutlet UITextField *txfProductImageURL;

@property (nonatomic, strong) productClass *product;

@end
