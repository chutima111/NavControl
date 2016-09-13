//
//  EditProductViewController.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/22/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditProductViewController.h"
#import "DAO.h"

@interface EditProductViewController () <UITextFieldDelegate>

@end

@implementation EditProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // set tile for navigation view controller
    self.title = @"Edit Product";
    
    // set save button on the right side of the navigation bar
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveProductInfo)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [saveButton release];
    
    // set cancel button on the left
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [cancelButton release];
    
    // Set up the text field
    self.txfProductName.text = self.product.productName;
    self.txfProductURL.text = self.product.productUrl;
    self.txfProductImageURL.text = self.product.productImage;
    
    // set the delegate to text fields
    self.txfProductName.delegate = self;
    self.txfProductURL.delegate = self;
    self.txfProductImageURL.delegate = self;
    
    
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    return YES;
}


- (void)keyBoardWillShow:(NSNotification *)aNotification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
    
}

-(void)keyBoardWillHide:(NSNotification *)aNotification
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}


-(void)cancelButtonPressed
{
    // Set transition between view controller
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveProductInfo
{
    [[DAO sharedInstance] updateProductInfo:self.txfProductName.text
                           updateProductURL:self.txfProductURL.text
                      updateProductImageURL:self.txfProductImageURL.text
                                productInfo:self.product];
    
    //Save the image from URL to temp directory
    // Using NSURLSessionDownloadTask
    
    NSString *urlString = self.txfProductImageURL.text;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *downloadImageTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        UIImage *downloadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        // move the file form temp directory to document directory
        if (downloadImage != nil) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:self.txfProductName.text];
            NSData *data = UIImagePNGRepresentation(downloadImage);
            [data writeToFile:path atomically:YES];
        }
        
        // Get the main thred to show something in UI
        // Because downloading the image from URL is doing in the background thred
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Set transition between view controller
            CATransition* transition = [CATransition animation];
            transition.duration = 0.5;
            transition.type = @"oglFlip";
            transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            
            [self.navigationController.view.layer addAnimation:transition forKey:nil];

            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
    [downloadImageTask resume];

    
    
}

- (void)UITextFieldClearAll
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.text = @"";
        }
    }
}
- (IBAction)deleteButtonPressed:(id)sender {
    
    [self UITextFieldClearAll];
    [[DAO sharedInstance] deleteProduct:self.product];
    [self.company.productsArray removeObject:self.product];
    
    // Set transition between view controller
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_txfProductName release];
    [_txfProductURL release];
    [_txfProductImageURL release];
    [_product release];
    [_company release];
    [super dealloc];
}
@end
