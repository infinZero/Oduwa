//
//  SignUpViewController.m
//  Oduwa
//
//  Created by Jayesh on 16/10/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
{
    Global *Glb;
}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Glb = [Global sharedInstance];
    [self SetCornerRaidus];
    scrlViewMain.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,btnAlreadyRegister.frame.origin.y + btnAlreadyRegister.frame.size.height + 10);
}

-(void)viewWillAppear:(BOOL)animated {
    btnSignUp.layer.cornerRadius = 6.0;
    btnSignUp.clipsToBounds = true;
    
    txtFirstName.layer.cornerRadius=6.0f;
    txtFirstName.layer.masksToBounds=YES;
    txtFirstName.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtFirstName.layer.borderWidth= 0.5f;
    
    txtLastName.layer.cornerRadius=6.0f;
    txtLastName.layer.masksToBounds=YES;
    txtLastName.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtLastName.layer.borderWidth= 0.5f;
    
    txtEmail.layer.cornerRadius=6.0f;
    txtEmail.layer.masksToBounds=YES;
    txtEmail.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtEmail.layer.borderWidth= 0.5f;
    
    txtMobile.layer.cornerRadius=6.0f;
    txtMobile.layer.masksToBounds=YES;
    txtMobile.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtMobile.layer.borderWidth= 0.5f;
    
    txtPassword.layer.cornerRadius=6.0f;
    txtPassword.layer.masksToBounds=YES;
    txtPassword.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtPassword.layer.borderWidth= 0.5f;
    
    txtConfirmPassword.layer.cornerRadius=6.0f;
    txtConfirmPassword.layer.masksToBounds=YES;
    txtConfirmPassword.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtConfirmPassword.layer.borderWidth= 0.5f;
    
    //[txtFirstName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[txtLastName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[txtEmail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[txtPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[txtConfirmPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[txtMobile setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    txtFirstName.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    txtLastName.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    txtConfirmPassword.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    txtMobile.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark User Defined Delegate
-(void)SetCornerRaidus {
    btnSignUp.layer.cornerRadius = btnSignUp.frame.size.height / 5;
    
    txtFirstName.layer.cornerRadius = txtFirstName.frame.size.height / 5;
    txtLastName.layer.cornerRadius = txtLastName.frame.size.height / 5;
    txtEmail.layer.cornerRadius = txtEmail.frame.size.height / 5;
    txtMobile.layer.cornerRadius = txtMobile.frame.size.height / 5;
    txtPassword.layer.cornerRadius = txtPassword.frame.size.height / 5;
    txtConfirmPassword.layer.cornerRadius = txtConfirmPassword.frame.size.height / 5;
}

-(void)ShowToastMessage:(NSString*)strToastMessage InterVal:(NSTimeInterval)Interval {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = strToastMessage;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.labelFont = [UIFont fontWithName:@"Helvetica" size:10];
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:Interval];
}

-(void)SignUp {
    @try {
        if (![Glb isNetworkAvailable]) {
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           txtFirstName.text,Para_FirstName,
                                           txtLastName.text,Para_LastName,
                                           txtEmail.text,Para_Email,
                                           txtMobile.text,Para_MobileNo,
                                           txtPassword.text,Para_Password,
                                           [kPref valueForKey:Key_MainPassword],Para_MainPassword,
                                           @"",Para_Device,
                                           nil];
        
        
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_USER_CREATE];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *writeError = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            
            if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"Account Created Successfully Check Your Mail." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                
                alert.tag = 1;
                [alert show];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
    @catch (NSException *exception) {
    }
}

#pragma mark Button Delegate
-(void)onClickBtn:(id)sender {
    if([sender tag] == 1) {
        if ([txtFirstName.text isEqualToString:@""]) {
            [self ShowToastMessage:@"First Name Required." InterVal:2];
            return;
        } else if ([txtLastName.text isEqualToString:@""]) {
            [self ShowToastMessage:@"Last Name Required." InterVal:2];
            return;
        } else if (![Glb IsValidEmail:txtEmail.text]) {
            [self ShowToastMessage:@"Email Address Not Valid." InterVal:2];
            return;
        } else if (txtMobile.text.length < 7) {
            [self ShowToastMessage:@"Atleast 7 Digit Mobile Number Required." InterVal:2];
            return;
        } else if ([txtPassword.text isEqualToString:@""]) {
            [self ShowToastMessage:@"Password Required." InterVal:2];
            return;
        } else if ([txtConfirmPassword.text isEqualToString:@""]) {
            [self ShowToastMessage:@"Confirm Password Required." InterVal:2];
            return;
        } else if (![txtPassword.text isEqualToString:txtConfirmPassword.text]) {
            [self ShowToastMessage:@"Password And Confirm Password Not Same." InterVal:2];
            return;
        }
        [self SignUp];
    } else if([sender tag] == 2) {
        Email *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"Email"];
        [self.navigationController pushViewController:objView animated:YES];
    } else if([sender tag] == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == 0) {
            Email *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"Email"];
            [self.navigationController pushViewController:objView animated:YES];
        }
    }
}

@end
