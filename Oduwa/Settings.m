//
//  Settings.m
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "Settings.h"
#import "Global.h"
#import "Countries.h"

@interface Settings ()
{
    Global *Glb;
    NSMutableArray* arrayData;
    NSString* tableCellIdentifier,*strOldPassword,*strNewPassword,*strOldPin,*strNewPin;
}
@end

@implementation Settings

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Glb = [Global sharedInstance];
    
    self.tblViewSettings.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [_btnMenu addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated {
    arrayData=[[NSMutableArray alloc] initWithObjects:@"Change Password",@"Change Pin",@"Change Currency",@"Change Confirmation Pin",@"Log Out",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableCellIdentifier = @"SettingCell";
    CustomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if(cell==nil) {
        cell=(CustomeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"CustomeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.lblTitle.text = [arrayData objectAtIndex:indexPath.row];
    cell.lblTitle.textColor = UIColor.whiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
        UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(10,0,252,35)];
        textField1.borderStyle = UITextBorderStyleRoundedRect;
        textField1.placeholder = @"Enter Old Password";
        textField1.keyboardAppearance = UIKeyboardAppearanceAlert;
        textField1.secureTextEntry = YES;
        textField1.delegate = self;
        textField1.tag = 1;
        
        [textField1 addTarget:self action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
        [v addSubview:textField1];

        UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(10,45,252,35)];
        textField2.placeholder = @"Enter New Password";
        textField2.borderStyle = UITextBorderStyleRoundedRect;
        textField2.keyboardAppearance = UIKeyboardAppearanceAlert;
        textField2.secureTextEntry = YES;
        textField2.tag = 2;
        textField2.delegate = self;

        [textField2 addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
        
        [v addSubview:textField2];


        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Change Password" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [av setValue:v  forKey:@"accessoryView"];
        av.delegate = self;
        av.tag = 1;
        
        [av show];
        
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Change Password"
//                                              message:@""
//                                              preferredStyle:UIAlertControllerStyleAlert];
//
//
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
//         {
//             textField.placeholder = NSLocalizedString(@"LoginPlaceholder", @"Login");
//             textField.secureTextEntry = YES;
//         }];
//
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
//         {
//             textField.placeholder = NSLocalizedString(@"PasswordPlaceholder", @"Password");
//             textField.secureTextEntry = YES;
//         }];
//
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
//                                       style:UIAlertActionStyleCancel
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           NSLog(@"Cancel action");
//                                       }];
//
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       NSLog(@"OK action");
//                                   }];
//
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//
//        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if(indexPath.row == 1) {
        //Pin *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"Pin"];
        //objView.isNewPin = YES;
        //objView.isChangePin = YES;
        //[self.navigationController pushViewController:objView animated:YES];
        PatternViewController *patternVC = [[PatternViewController alloc] initWithMode:PatternModeModify delegate:self];
        [self presentViewController:patternVC animated:YES completion:^{
            
        }];
    } else if(indexPath.row == 2){
       Countries *myVController = (Countries *)[self.storyboard instantiateViewControllerWithIdentifier:@"show_Countries"];
        [self.navigationController pushViewController:myVController animated:YES];

    }else if(indexPath.row == 3) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
            UITextField *textField3 = [[UITextField alloc] initWithFrame:CGRectMake(10,0,252,35)];
            textField3.borderStyle = UITextBorderStyleRoundedRect;
            textField3.placeholder = @"Enter Old 6 Digit Pin";
            textField3.keyboardAppearance = UIKeyboardAppearanceAlert;
            textField3.secureTextEntry = YES;
            textField3.delegate = self;
            textField3.tag = 3;
            
            [textField3 addTarget:self action:@selector(textFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
            [v addSubview:textField3];

            UITextField *textField4 = [[UITextField alloc] initWithFrame:CGRectMake(10,45,252,35)];
            textField4.placeholder = @"Enter New 6 Digit Pin";
            textField4.borderStyle = UITextBorderStyleRoundedRect;
            textField4.keyboardAppearance = UIKeyboardAppearanceAlert;
            textField4.secureTextEntry = YES;
            textField4.tag = 4;
            textField4.delegate = self;

            [textField4 addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
            
            [v addSubview:textField4];


            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Change Pin" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [av setValue:v  forKey:@"accessoryView"];
            av.delegate = self;
            av.tag = 3;
            
            [av show];
            
    //        UIAlertController *alertController = [UIAlertController
    //                                              alertControllerWithTitle:@"Change Password"
    //                                              message:@""
    //                                              preferredStyle:UIAlertControllerStyleAlert];
    //
    //
    //        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
    //         {
    //             textField.placeholder = NSLocalizedString(@"LoginPlaceholder", @"Login");
    //             textField.secureTextEntry = YES;
    //         }];
    //
    //        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
    //         {
    //             textField.placeholder = NSLocalizedString(@"PasswordPlaceholder", @"Password");
    //             textField.secureTextEntry = YES;
    //         }];
    //
    //        UIAlertAction *cancelAction = [UIAlertAction
    //                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
    //                                       style:UIAlertActionStyleCancel
    //                                       handler:^(UIAlertAction *action)
    //                                       {
    //                                           NSLog(@"Cancel action");
    //                                       }];
    //
    //        UIAlertAction *okAction = [UIAlertAction
    //                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
    //                                   style:UIAlertActionStyleDefault
    //                                   handler:^(UIAlertAction *action)
    //                                   {
    //                                       NSLog(@"OK action");
    //                                   }];
    //
    //        [alertController addAction:cancelAction];
    //        [alertController addAction:okAction];
    //
    //        [self presentViewController:alertController animated:YES completion:nil];
            
        }else if(indexPath.row == 4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are You Sure To Logout?" message:NSLocalizedString(@"Logout", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(NSLocalizedString(@"Yes", nil), nil),nil];
        alert.tag = 2;
        alert.delegate = self;
        [alert show];
    }
}

#pragma mark - TextField Delegate
-(void)textFieldDidChange:(UITextField *)textField {
    if(textField.tag == 1) {
        strOldPassword = textField.text;
    } else if(textField.tag == 2) {
        strNewPassword = textField.text;
    } else if(textField.tag == 3){
        strOldPin = textField.text;
    } else if(textField.tag == 4){
        strNewPin = textField.text;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == 1) {
            if([strOldPassword isEqualToString:@""]) {
                [self ShowToastMessage:@"Old Password Required." InterVal:2];
                return;
            } else if([strNewPassword isEqualToString:@""]) {
                [self ShowToastMessage:@"New Password Required." InterVal:2];
                return;
            } else if (![strOldPassword isEqualToString:[kPref valueForKey:Key_LoginPassword]]) {
                [self ShowToastMessage:@"Old Password Is Not Match With Current Password." InterVal:2];
                return;
            } else if ([strOldPassword isEqualToString:strNewPassword]) {
                [self ShowToastMessage:@"Both Password Same." InterVal:2];
                return;
            }
            [self ChangePassword];
        }
    } else if(alertView.tag == 2) {
        if(buttonIndex == 1) {
            [kPref setValue:@"" forKey:Key_PinNo];
            [kPref setValue:@"" forKey:Key_UserEmail];
            [kPref setValue:@"" forKey:Key_LoginPassword];
            
            Email *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"Email"];
            [self.navigationController pushViewController:objView animated:YES];
        }
    } else if (alertView.tag == 3){
        if(buttonIndex == 1) {
                   if([strOldPin isEqualToString:@""]) {
                       [self ShowToastMessage:@"6 Digit Old Pin Required." InterVal:2];
                       return;
                   } else if([strNewPin isEqualToString:@""]) {
                       [self ShowToastMessage:@"6 Digit New Pin Required." InterVal:2];
                       return;
                   } else if (![strOldPin isEqualToString:[kPref valueForKey:Key_Pin]]) {
                       [self ShowToastMessage:@"Old Pin Does not match with the Pin you entered" InterVal:2];
                       return;
                   } else if ([strOldPin isEqualToString:strNewPin]) {
                       [self ShowToastMessage:@"Both Pin Same." InterVal:2];
                       return;
                   }else if (!([strNewPin length] == 6) ){
                       [self ShowToastMessage:@"Pin must be 6 digit length" InterVal:2];
                       return;
                   }
            
                   [self ChangePin];
               }
        
    }
}

#pragma mark User Defined Delegate
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

-(void)ChangePassword {
    @try {
        if (![Glb isNetworkAvailable]) {
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [kPref valueForKey:Key_API],Para_API,
                                           strOldPassword,@"OLD_PASSWORD",
                                           strNewPassword,@"NEW_PASSWORD",
                                           nil];
        
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_CHANGE_PASSWORD];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            
            if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [kPref setValue:self->strNewPassword forKey:Key_Password];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    @catch (NSException *exception) {
    }
}

-(void)ChangePin {
    @try {
        if (![Glb isNetworkAvailable]) {
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys: [kPref valueForKey:Key_UserEmail],Para_Email,[kPref valueForKey:Key_LoginPassword],Para_Password,
        strOldPin,@"OLD_PIN",
        strNewPin,@"NEW_PIN",
        nil];
        
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_CHANGE_PIN];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *writeError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            
            if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [kPref setValue:self->strNewPin forKey:Key_Pin];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    @catch (NSException *exception) {
    }
}
@end
