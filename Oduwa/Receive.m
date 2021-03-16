//
//  Receive.m
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "Receive.h"
#import "QRCodeGenerator.h"

@interface Receive ()

@end

@implementation Receive
@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnAddress.layer.borderWidth = 1;
    btnAddress.layer.borderColor = RGBa(0, 128, 255, 1).CGColor;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    [_btnMenu addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    if([type isEqualToString:@"Menu"]){
        _btnMenu.hidden = false;
        _btnClose.hidden = true;
    } else {
        _btnMenu.hidden = true;
        _btnClose.hidden = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    NSString *str = [kPref valueForKey:Key_Address];
    [btnAddress setTitle:[kPref valueForKey:Key_Address] forState:UIControlStateNormal];
        
    [self CreateQrCodeImage:btnAddress.titleLabel.text];
    
    btnAddress.layer.cornerRadius = 6.0;
    btnAddress.clipsToBounds = true;
}

- (IBAction)b:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark User Defined Delegate
//-(void)CreateQrCodeImage:(NSString *)qrString {
//    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
//    
//    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    [qrFilter setValue:stringData forKey:@"inputMessage"];
//    
//    [imgViewQr setImage:[[UIImage alloc] initWithCIImage:qrFilter.outputImage]];
//}
-(void)CreateQrCodeImage:(NSString *)qrString {
    imgViewQr.image = [[[QRCodeGenerator alloc] initWithString:qrString] getImage];
}

#pragma mark Button Delegate
-(void)onClickBtn:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if([btn tag] == 1) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = btn.titleLabel.text;
        
        [kPref setValue:btn.titleLabel.text forKey:Key_CopiedAddress];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Address has been copied to the clipboard...!!!";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.labelFont = [UIFont fontWithName:@"Helvetica" size:10];
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
    }
}
@end
