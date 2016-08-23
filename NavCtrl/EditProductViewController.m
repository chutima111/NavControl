//
//  EditProductViewController.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/22/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditProductViewController.h"

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
    
    // set cancel button on the left
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // Set up the text field
    self.txfProductName.text = self.product.productName;
    self.txfProductURL.text = self.product.productUrl;
    self.txfProductImageURL.text = self.product.productImage;
    
    // set the delegate to text fields
    self.txfProductName.delegate = self;
    self.txfProductURL.delegate = self;
    self.txfProductImageURL.delegate = self;
    
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyBoardWillShow:(NSNotification *)aNotification
{
    // Move the text field up
    NSDictionary *userInfo = [aNotification userInfo];
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    [self.txfProductImageURL setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.txfProductImageURL.frame = CGRectMake(self.txfProductImageURL.frame.origin.x,
                                           keyboardSize.height - 20,
                                           self.txfProductImageURL.frame.size.width,
                                           self.txfProductImageURL.frame.size.height);
    
}

-(void)keyBoardWillHide
{
    // Move the text fileds back up
    self.txfProductImageURL.frame = CGRectMake(self.txfProductImageURL.frame.origin.x,
                                               self.view.frame.size.height /2,
                                               self.txfProductImageURL.frame.size.width,
                                               self.txfProductImageURL.frame.size.height);
    

}

-(void)cancelButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveProductInfo
{
    [self updateProductInfo:self.txfProductName.text
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
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
    [downloadImageTask resume];

    
    
}

-(void)updateProductInfo:(NSString *)productName
        updateProductURL:(NSString *)productURL
   updateProductImageURL:(NSString *)productImageURL
             productInfo:(productClass *)productInfo
{
    productInfo.productName = productName;
    productInfo.productUrl = productURL;
    productInfo.productImage = productImageURL;
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
    [super dealloc];
}
@end
