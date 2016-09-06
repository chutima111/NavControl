//
//  CompanyTableViewCell.m
//  NavCtrl
//
//  Created by chutima mungmee on 9/6/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "CompanyTableViewCell.h"

@implementation CompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imgCompany release];
    [_lblCompanyName release];
    [_lblStockPrice release];
    [super dealloc];
}
@end
