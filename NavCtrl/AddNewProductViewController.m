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
    
    // Add back button image on navigation bar on the left
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = backButton;

    
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

- (void)keyBoardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self.txfProductURL setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    // set the frame for text field
    self.txfProductURL.frame = CGRectMake(self.txfProductURL.frame.origin.x,
                                          keyboardSize.height -20,
                                          self.txfProductURL.frame.size.width,
                                          self.txfProductURL.frame.size.height);
    
}

-(void)keyBoardWillHide
{
    // Move the text field back up
    self.txfProductURL.frame = CGRectMake(self.txfProductURL.frame.origin.x,
                                          self.view.frame.size.height / 2,
                                          self.txfProductURL.frame.size.width,
                                          self.txfProductURL.frame.size.height);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)backButtonPressed
{
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
    [_txfProductName release];
    [_txfProductImageURL release];
    [super dealloc];
}
@end
