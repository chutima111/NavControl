//
//  EditCompanyViewController.m
//  NavCtrl
//
//  Created by chutima mungmee on 8/22/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditCompanyViewController.h"
#import "DAO.h"

@interface EditCompanyViewController ()

@end

@implementation EditCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txfCompanyName.text = self.company.companyName;
    self.txfCompanyImageURL.text = self.company.companyImageName;
    self.txfCompanyTicker.text = self.company.companyTicker;
    
    // set the title for navigation controller
    self.title = @"Edit Company";
    
    // Add the save button on the right side of navigation bar
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCompany)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    // Add the cancle button on the left
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    
    self.navigationItem.leftBarButtonItem = cancleButton;
    [cancleButton release];
    
    
    // set the delegate to my text fields
    self.txfCompanyName.delegate = self;
    self.txfCompanyImageURL.delegate = self;
    self.txfCompanyTicker.delegate = self;
    
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

-(void)keyBoardWillShow:(NSNotification *)aNotification
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

-(void)saveCompany
{
    
    [[DAO sharedInstance] updateCompanyInfo:self.txfCompanyName.text
                      updateCompanyImageURL:self.txfCompanyImageURL.text
                        updateCompanyTicker:self.txfCompanyTicker.text
                                    company:self.company];
    
    // Save the image from URL to temp directory
    // Using NSURLSessionDownloadTask
    
    NSString *urlString = self.txfCompanyImageURL.text;
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    [_txfCompanyName release];
    [_txfCompanyImageURL release];
    [_txfCompanyTicker release];
  
    [super dealloc];
}
@end
