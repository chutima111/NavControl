//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailsViewController.h"


@interface ProductViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableArray *productImages;
@property (nonatomic, retain) NSMutableArray *productUrlsArray;
@end
