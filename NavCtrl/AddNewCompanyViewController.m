//
//  AddNewCompanyViewController.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/16/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "AddNewCompanyViewController.h"
#import "companyInfoClass.h"
#import "DAO.h"


@interface AddNewCompanyViewController () <UITextFieldDelegate>

@end

@implementation AddNewCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.title = @"New Company";
    
    // Add SAVE Button in navigation bar on the right side
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewCompany)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Add CANCEL Button in navigation bar on the left side
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Set delegate to my text fields
    self.txfCompanyName.delegate = self;
    self.txfCompanyImageUrl.delegate = self;
    
}

-(void) keyboardWillShow:(NSNotification *)aNotification
{
    // Move the text field up
    NSDictionary *userInfo = [aNotification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    

    [self.txfCompanyName setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.txfCompanyName.frame = CGRectMake(self.txfCompanyName.frame.origin.x,
                                           keyboardSize.height - 20,
                                           self.txfCompanyName.frame.size.width,
                                           self.txfCompanyName.frame.size.height);
    
        
}

-(void)keyboardWillHide
{
    // Move the text fileds back up
    self.txfCompanyName.frame = CGRectMake(self.txfCompanyName.frame.origin.x,
                                           self.view.frame.size.height / 2,
                                           self.txfCompanyName.frame.size.width,
                                           self.txfCompanyName.frame.size.height);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    // overide the edit navigationItem
    [super setEditing:editing animated:animated];
}

-(void)saveNewCompany
{
    [[DAO sharedInstance] addNewCompanyToList:self.txfCompanyName.text
                                 companyImage:self.txfCompanyImageUrl.text
                                productsArray:[NSMutableArray array]];
    
    
    // Save the image from URL to temp directory
    // Using NSURLSessionDownloadTask
    
    NSString *urlString = self.txfCompanyImageUrl.text;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *downloadImageTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        UIImage *downloadImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
    
        // move the file form temp directory to document directory
        if (downloadImage != nil) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:self.txfCompanyName.text];
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

-(void)cancelButtonPressed
{
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [_txfCompanyName release];
    [_txfCompanyImageUrl release];
    [super dealloc];
}
@end