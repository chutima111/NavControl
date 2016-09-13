//
//  AddNewProductViewController.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/18/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "AddNewProductViewController.h"
#import "productClass.h"
#import "DAO.h"

@interface AddNewProductViewController () <UITextFieldDelegate>

@end

@implementation AddNewProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set the tile
    self.title = @"New Product";
    
    // set the delegate to all my text fields
    self.txfProductName.delegate = self;
    self.txfProductURL.delegate = self;
    self.txfProductImageURL.delegate = self;
    
    // Set the items in the navigation bar
    // Add SAVE Button in navigation bar on the right side
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewProduct)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [saveButton release];
    
    // Add back button image on navigation bar on the left
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [backButton release];

    
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)backButtonPressed
{
    // Set transition between view controller
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveNewProduct
{
    
    [[DAO sharedInstance] addNewProductToList:self.txfProductName.text
                              productImageURL:self.txfProductImageURL.text
                                   productURL:self.txfProductURL.text
                                  companyInfo:self.company];
    
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
    [_company release];
    [super dealloc];
}
@end
