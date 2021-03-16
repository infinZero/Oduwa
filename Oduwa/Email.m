//
//  Email.m
//  UnifyEarth
//
//  Created by Jayesh on 31/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "Email.h"
#import "Global.h"
#import "Home.h"

@interface Email ()
{
    Global *Glb;
    UITextField *textField;
}

@end

@implementation Email

- (void)viewDidLoad {
    [super viewDidLoad];
    Glb = [Global sharedInstance];
    [self SetCornerRaidus];
}

-(void)viewWillAppear:(BOOL)animated {
    btnSignIn.layer.cornerRadius = 6.0;
    btnSignIn.clipsToBounds = true;
    
    btnDontHaveAccount.layer.cornerRadius = 6.0;
    btnDontHaveAccount.clipsToBounds = true;
    
    txtEmail.layer.cornerRadius=6.0f;
    txtEmail.layer.masksToBounds=YES;
    txtEmail.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtEmail.layer.borderWidth= 0.5f;
    
    txtPassword.layer.cornerRadius=6.0f;
    txtPassword.layer.masksToBounds=YES;
    txtPassword.layer.borderColor=[[UIColor whiteColor]CGColor];
    txtPassword.layer.borderWidth= 0.5f;
    
    //[txtEmail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[txtPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    //txtEmail.leftView = paddingView;
    //txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    //txtPassword.leftView = paddingView;
    //txtPassword.leftViewMode = UITextFieldViewModeAlways;
    
    txtEmail.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    txtPassword.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Button Delegate

-(void)onClickBtn:(id)sender {
    if([sender tag] == 1) {
        if (![txtEmail.text isEqualToString:@""] && ![Glb IsValidEmail:txtEmail.text]) {
            [self ShowToastMessage:@"Invalid Email Address." InterVal:2];
            return;
        }
        [self CheckLogin];
    } else if([sender tag] == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verify Email Id" message:NSLocalizedString(@"", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(NSLocalizedString(@"Submit", nil), nil),nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].delegate = self;
        [alert textFieldAtIndex:0].placeholder = NSLocalizedString(@"Enter Emial Id", nil);
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
    } else if([sender tag] == 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message:NSLocalizedString(@"", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(NSLocalizedString(@"Submit", nil), nil),nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].delegate = self;
        [alert textFieldAtIndex:0].placeholder = NSLocalizedString(@"Enter Emial Id", nil);
        alert.delegate = self;
        alert.tag = 2;
        [alert show];
    } else if([sender tag] == 4) {
        SignUpViewController *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        [self.navigationController pushViewController:objView animated:YES];
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == 1) {
            [alertView textFieldAtIndex:0].text = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:
                                                   [NSCharacterSet whitespaceCharacterSet]];
            if(![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                if (![[alertView textFieldAtIndex:0].text isEqualToString:@""] && ![Glb IsValidEmail:[alertView textFieldAtIndex:0].text]) {
                    [self ShowToastMessage:@"Invalid Email Address." InterVal:2];
                    return;
                }
                [self VerifyEmail:[alertView textFieldAtIndex:0].text];
            }
        }
    } else if(alertView.tag == 2) {
        if (buttonIndex == 1) {
            [alertView textFieldAtIndex:0].text = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:
                                                   [NSCharacterSet whitespaceCharacterSet]];
            if(![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                if (![[alertView textFieldAtIndex:0].text isEqualToString:@""] && ![Glb IsValidEmail:[alertView textFieldAtIndex:0].text]) {
                    
                    [self ShowToastMessage:@"Invalid Email Address." InterVal:2];
                    return;
                }
                [self ForgotPassword:[alertView textFieldAtIndex:0].text];
            }
        }
    }
}

#pragma mark User Defined Delegate
-(void)SetCornerRaidus {
    btnSignIn.layer.cornerRadius = btnSignIn.frame.size.height / 5;
    txtEmail.layer.cornerRadius = txtEmail.frame.size.height / 5;
    txtPassword.layer.cornerRadius = txtPassword.frame.size.height / 5;
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

-(void)CheckLogin {
    @try {
        if (![Glb isNetworkAvailable]) {
        [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       txtEmail.text,Para_Email,
                                       txtPassword.text,Para_Password,
                                       nil];
    NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_CHECK_LOGIN];
    [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *writeError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&writeError];
        if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [kPref setValue:txtEmail.text forKey:Key_UserEmail];
            [kPref setValue:txtPassword.text forKey:Key_LoginPassword];
            
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_Label] forKey:Key_LabelName];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_API] forKey:Key_API];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_Password] forKey:Key_Password];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_FirstName] forKey:Key_FirstName];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_LastName] forKey:Key_LastName];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_MobileNo] forKey:Key_MobileNo];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_EmailVerify] forKey:Key_EmailVerify];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_Active] forKey:Key_Active];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_Address] forKey:Key_Address];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_MinimumTx] forKey:Key_MinimumTx];
            [kPref setValue:[[[[dic valueForKey:@"Result"] valueForKey:@"data"] objectAtIndex:0] valueForKey:Para_Fees] forKey:Key_FEES];
            
            //Pin *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"Pin"];
            //objView.isNewPin = YES;
            //[self.navigationController pushViewController:objView animated:YES];
            
            PatternViewController *patternVC = [[PatternViewController alloc] initWithMode:PatternModeModify delegate:self];
            [self.navigationController pushViewController:patternVC animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
    
    @catch (NSException *exception) {
    }
}

-(void)VerifyEmail:(NSString*)strEmail {
    @try {
        if (![Glb isNetworkAvailable]) {
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           strEmail,Para_Email,
                                           nil];
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_EMAIL_VERIFY];
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [kPref setValue:txtEmail.text forKey:Key_UserEmail];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } @catch (NSException *exception) {
    }
}

-(void)ForgotPassword:(NSString*)strEmail {
    @try {
        if (![Glb isNetworkAvailable]) {
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys: strEmail,Para_Email, nil];
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_RESET_PASSWORD];
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [kPref setValue:txtEmail.text forKey:Key_UserEmail];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    } @catch (NSException *exception) {
    }
}

@end
