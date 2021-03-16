//
//  Pin.m
//  UnifyEarth
//
//  Created by Jayesh on 31/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "Pin.h"
#import "Global.h"
#import "Home.h"
//#import "RearTableViewController.h"

@interface Pin () {
    Global *Glb;
    NSString *strNewPin,*strConfirmPin;
}
@end

@implementation Pin

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Glb = [Global sharedInstance];
    
    [self.textField1 resignFirstResponder];
    
    if(self.isChangePin == YES) {
        self.btnBack.hidden = NO;
    } else {
        self.btnBack.hidden = YES;
    }
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark User Defined Delegate
-(void)ClearPin {
    [self.textField1 setText:@""];
    [self.textField2 setText:@""];
    [self.textField3 setText:@""];
    [self.textField4 setText:@""];
}

-(void)CheckPin {
    if(self.isNewPin == YES) {
        strNewPin = [NSString stringWithFormat:@"%@%@%@%@", self.textField1.text ,self.textField2.text,self.textField3.text,self.textField4.text];
        [self ClearPin];
        self.isNewPin = NO;
        self.isConfirmPin = YES;
        [self.lblPinTitle setText:@"Confirm Pin"];
    } else if(self.isConfirmPin == YES) {
        strConfirmPin = [NSString stringWithFormat:@"%@%@%@%@", self.textField1.text ,self.textField2.text,self.textField3.text,self.textField4.text];
        
        if([strNewPin isEqualToString:strConfirmPin]) {
            [kPref setValue:strNewPin forKey:Key_PinNo];
            //ParentTab *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"ParentTab"];
            //[self.navigationController pushViewController:objView animated:YES];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            Home *controller = (Home *)[sb instantiateViewControllerWithIdentifier:@"Home"];
            RearViewController *rearViewController = [[RearViewController alloc] init];
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:controller];
            revealController.delegate = self;
            [self.navigationController pushViewController:revealController animated:YES];
        } else {
            [self ClearPin];
        }
    } else if(self.isCheckPin == YES) {
        strConfirmPin = [NSString stringWithFormat:@"%@%@%@%@", self.textField1.text ,self.textField2.text,self.textField3.text,self.textField4.text];
        
        if([[kPref valueForKey:Key_PinNo] isEqualToString:strConfirmPin]) {
            //ParentTab *objView = [self.storyboard instantiateViewControllerWithIdentifier:@"ParentTab"];
            //[self.navigationController pushViewController:objView animated:YES];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            Home *controller = (Home *)[sb instantiateViewControllerWithIdentifier:@"Home"];
            RearViewController *rearViewController = [[RearViewController alloc] init];
            SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:controller];
            revealController.delegate = self;
            [self.navigationController pushViewController:revealController animated:YES];
        } else {
            [self ClearPin];
        }
    }
}

-(void)SetTextFieldBorder :(UITextField *)textField {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor blackColor].CGColor;
    border.frame = CGRectMake(0, textField.frame.size.height - borderWidth, textField.frame.size.width, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.masksToBounds = YES;
}

#pragma mark Button Delegate
-(void)onClickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onClickBtn:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if([btn tag] == 11) {
        [self ClearPin];
        [self.textField1 becomeFirstResponder];
    } else if([btn tag] == 12) {
        if(![self.textField4.text isEqualToString:@""])
            [self.textField4 setText:@""];
        else if(![self.textField3.text isEqualToString:@""])
            [self.textField3 setText:@""];
        else if(![self.textField2.text isEqualToString:@""])
            [self.textField2 setText:@""];
        else if(![self.textField1.text isEqualToString:@""])
            [self.textField1 setText:@""];
    } else {
        if([self.textField1.text isEqualToString:@""])
            [self.textField1 setText:btn.titleLabel.text];
        else if([self.textField2.text isEqualToString:@""])
            [self.textField2 setText:btn.titleLabel.text];
        else if([self.textField3.text isEqualToString:@""])
            [self.textField3 setText:btn.titleLabel.text];
        else if([self.textField4.text isEqualToString:@""]) {
            [self.textField4 setText:btn.titleLabel.text];
            [self CheckPin];
        }
    }
}

@end
