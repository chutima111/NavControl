//
//  CompanyTableViewCell.h
//  NavCtrl
//
//  Created by chutima mungmee on 9/6/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgCompany;
@property (retain, nonatomic) IBOutlet UILabel *lblCompanyName;
@property (retain, nonatomic) IBOutlet UILabel *lblStockPrice;

@end
