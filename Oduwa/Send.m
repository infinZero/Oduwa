//
//  Send.m
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "Send.h"
#import "Global.h"
#define URL  @"https://api.coingecko.com/api/v3/coins/oduwa-coin"
#define NO_CONNECTION  @"No Connection"
#define NO_VALUES      @"Please enter parameter values"


@interface Send ()
{
    Global *Glb;
    double douBalanceAmount,douOduwaAmount,douDollorAmount,crncyValue,dividingNumber,douDollorTotalAmount,douTotalAmount,douMinTxAmt,douAmount,douFee;
    NSString *strBalance,*strMessage,*strLastAmount,*upperCase;
    NSTimer *timer;
    
    NSMutableArray *resultingArray;
    NSMutableDictionary *finalArgument;
    NSMutableDictionary *finalValue;
}
@end

@implementation Send
@synthesize type, savedValue, currentPrice;


- (void)viewDidLoad {
    [super viewDidLoad];
    _isReading = NO;
    
    _captureSession = nil;
    
    Glb = [Global sharedInstance];
    
    savedValue = [[NSUserDefaults standardUserDefaults]
    stringForKey:@"preferedCurrency"];
    if (!savedValue){
        savedValue = @"usd";
    }
 //   NSLog(@"Selected currency for %@", savedValue);
   // [self sendDataToServer : @"GET"];
    
    
    [self.txtAmount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txtCrcAmount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    douAmount = 0;
    douTotalAmount = 0;
    
    
    [self GetBalance];
    
    self.txtAddress.layer.borderWidth = 0.5f;
    self.txtAddress.layer.borderColor = RGBa(236, 186, 55, 1).CGColor;
    
    self.txtAmount.layer.borderWidth = 0.5f;
    self.txtAmount.layer.borderColor = RGBa(236, 186, 55, 1).CGColor;
    
    self.txtTotal.layer.borderWidth = 0.5f;
    self.txtTotal.layer.borderColor = RGBa(236, 186, 55, 1).CGColor;
    
    self.txtCrcAmount.layer.borderWidth = 0.5f;
    self.txtCrcAmount.layer.borderColor = RGBa(236, 186, 55, 1).CGColor;
    
    self.viewHeading.layer.cornerRadius = 5;
    
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

-(void)viewWillAppear:(BOOL)animated {
    douMinTxAmt = [[kPref valueForKey:Key_MinimumTx] doubleValue];
    savedValue = [[NSUserDefaults standardUserDefaults]
       stringForKey:@"preferedCurrency"];
       if (!savedValue){
           savedValue = @"usd";
       }
       NSLog(@"Selected currency for %@", savedValue);
      // [self sendDataToServer : @"GET"];
    [self GetBalance];

    if([kPref valueForKey:Key_FEES] != nil) {
        self.lblFees.text = @"Tx. Fee : ";
        douFee = [[kPref valueForKey:Key_FEES] doubleValue];
        self.lblFees.text = [self.lblFees.text stringByAppendingString:[NSString stringWithFormat:@"%.08f",douFee]];
        self.lblFees.text = [self.lblFees.text stringByAppendingString:@" OWC"];
    } else {
        douFee = 0;
        self.lblFees.text = @"Tx. Fee : 0.00000000 OWC";
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(GetBalance) userInfo:nil repeats:YES];
    
    _txtAddress.layer.cornerRadius=6.0f;
    _txtAddress.layer.masksToBounds=YES;
    _txtAddress.layer.borderColor=[[UIColor whiteColor]CGColor];
    _txtAddress.layer.borderWidth= 0.5f;
    
    _txtAmount.layer.cornerRadius=6.0f;
    _txtAmount.layer.masksToBounds=YES;
    _txtAmount.layer.borderColor=[[UIColor whiteColor]CGColor];
    _txtAmount.layer.borderWidth= 0.5f;
    
    _txtTotal.layer.cornerRadius=6.0f;
    _txtTotal.layer.masksToBounds=YES;
    _txtTotal.layer.borderColor=[[UIColor whiteColor]CGColor];
    _txtTotal.layer.borderWidth= 0.5f;
    
    _txtCrcAmount.layer.cornerRadius=6.0f;
       _txtCrcAmount.layer.masksToBounds=YES;
       _txtCrcAmount.layer.borderColor=[[UIColor whiteColor]CGColor];
       _txtCrcAmount.layer.borderWidth= 0.5f;
    
    //[_txtAmount setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[_txtAddress setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //[_txtTotal setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    _txtAmount.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    _txtAddress.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    _txtCrcAmount.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    _txtTotal.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)b:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark Qrcode Delegate
- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self.txtAddress performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
//            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;    
    [_videoPreviewLayer removeFromSuperlayer];
}

#pragma mark Button Delegate

-(void)onClickBtn:(id)sender {
    if([sender tag] == 1){
        //[self.txtAddress setText:[kPref valueForKey:Key_Address]];
        [self.txtAddress setText:[UIPasteboard generalPasteboard].string];
    } else if([sender tag] == 2) {
        [self startReading];
    } else if ([sender tag] == 3) {
        if(![self IsValid])
            return;
        if (![Glb isNetworkAvailable]) {
            
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        
        strMessage = @"Are you sure To Send ";
        strMessage = [strMessage stringByAppendingString:self.txtTotal.text];
        strMessage = [strMessage stringByAppendingString:@" OWC?"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Transaction" message:strMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        alert.delegate = self;
        [alert show];
        
        
    }
 
}

#pragma mark textFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if(textField == self.txtAmount)
    {
        self.lblTotalDollar.text = @"";
        NSUInteger count = 0, length = [textField.text length];
        NSRange range = NSMakeRange(0, length);
        while(range.location != NSNotFound)
        {
            range = [textField.text rangeOfString: @"." options:0 range:range];
            if(range.location != NSNotFound)
            {
                range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                count++;
            }
        }
    
        if(count <= 1 && textField.text.length < 11)
        {
            douAmount = [textField.text doubleValue];
           
            
//            douDollorTotalAmount = douDollorAmount * douTotalAmount;
//            self.lblTotalDollar.text = [NSString stringWithFormat:@"%.02f",douDollorTotalAmount];
//            self.lblTotalDollar.text = [self.lblTotalDollar.text stringByAppendingString:@" USD"];
          
            //douDollorAmount = [[currentPrice objectForKey:savedValue] doubleValue];

                NSLog(@"%f", crncyValue);
                
                //double oduwaCurrency = 4;
                //double valueForLabel = oduwaCurrency * douCurrency;
                douDollorTotalAmount = crncyValue * douAmount;
              
               NSLog(@"%f", douDollorTotalAmount);
                
             //   NSLog(@"%f %@",valueForLabel,savedValue);
                NSString *upperCase = [savedValue uppercaseString];
               // NSNumber *myDoubleNumber = [NSNumber numberWithDouble:valueForLabel];
               
                //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
               // NSString *myString = [formatter stringFromNumber:@(crncyValue)];
             // NSString * forlable =[NSString stringWithFormat:@"%f %@", crncyValue ,upperCase];
                
               self.lblTotalDollar.text = upperCase;
               self.txtCrcAmount.text =[NSString stringWithFormat:@"%f", douDollorTotalAmount];
            /*
               douDollorTotalAmount = douDollorAmount * douTotalAmount;
               self.lblTotalDollar.text = [NSString stringWithFormat:@"%.02f",douDollorTotalAmount];
               self.lblTotalDollar.text = [self.lblTotalDollar.text stringByAppendingString:@" USD"];
              */
            if(douAmount > 0){
                douTotalAmount = douAmount + douFee;
                self.txtTotal.text = [NSString stringWithFormat:@"%.08f", douTotalAmount];
            }else{
                self.txtTotal.text = @"";
            }
            
            strLastAmount = textField.text;
        }
        else
            textField.text = strLastAmount;
    }
    if(textField == self.txtCrcAmount)
       {
           self.lblTotalDollar.text = @"";
           //self.txtAmount.text = @"";
           NSUInteger count = 0, length = [textField.text length];
           NSRange range = NSMakeRange(0, length);
           while(range.location != NSNotFound)
           {
               range = [textField.text rangeOfString: @"." options:0 range:range];
               if(range.location != NSNotFound)
               {
                   range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
                   count++;
               }
           }

           if(count <= 1 && textField.text.length < 11)
           {
              // douAmount = [self.txtAmount.text doubleValue];
              // douTotalAmount = douAmount + douFee;
               
               douDollorTotalAmount = [textField.text doubleValue];
              
               
               //lblTotalDollar is our focus to change this label according to user selected
                //double douCurrency = [[currentPrice objectForKey:savedValue] doubleValue];
             //   douDollorAmount = [[currentPrice objectForKey:savedValue] doubleValue];

                NSLog(@"%f", crncyValue);
                
                //double oduwaCurrency = 4;
                //double valueForLabel = oduwaCurrency * douCurrency;
         //       douDollorTotalAmount = douDollorAmount * douTotalAmount;
              
        //       NSLog(@"%f", douDollorTotalAmount);
                
             //   NSLog(@"%f %@",valueForLabel,savedValue);
         
               NSString *upperCase = [savedValue uppercaseString];
               // NSNumber *myDoubleNumber = [NSNumber numberWithDouble:valueForLabel];
               
               // NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                //NSString *myString = [formatter stringFromNumber:@(douDollorTotalAmount)];
           //   NSString * forlable =[NSString stringWithFormat:@"%f %@", crncyValue ,upperCase];
                
               self.lblTotalDollar.text = upperCase;
       //      self.txtCrcAmount.text =[NSString stringWithFormat:@"%f", douDollorTotalAmount];
               douOduwaAmount = douDollorTotalAmount/crncyValue;
               douAmount= douOduwaAmount;
               self.txtAmount.text = [NSString stringWithFormat:@"%f", douAmount];
               
              
            /*
               douDollorTotalAmount = douDollorAmount * douTotalAmount;
               self.lblTotalDollar.text = [NSString stringWithFormat:@"%.02f",douDollorTotalAmount];
               self.lblTotalDollar.text = [self.lblTotalDollar.text stringByAppendingString:@" USD"];
              */
               //douOduwaAmount = self.txtAmount.text;
               if(douAmount > 0){
                   douTotalAmount = douAmount + douFee;
                   self.txtTotal.text = [NSString stringWithFormat:@"%.08f", douTotalAmount];
               }else{
                   self.txtTotal.text = @"";
               }
               strLastAmount = self.txtAmount.text;
           }
           else
               self.txtAmount.text = strLastAmount;
       }
}

#pragma mark User Defined Delegate
-(void)GetBalance
{
    @try {
        
        if (![Glb isNetworkAvailable]) {
            
            [AZNotification showNotificationWithTitle:@"There is no internet connection" controller:self notificationType:AZNotificationTypeError shouldShowNotificationUnderNavigationBar:NO];
            return;
        }
        
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [kPref valueForKey:Key_API],Para_API,
                                           nil];
    //    NSLog(@"Parameters are %@", parameters);
        
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_GET_BALANCE_V1];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *writeError = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            
         //   if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]])
           if ([[dic valueForKey:@"UserPIN"] isEqualToNumber:[NSNumber numberWithInt:1]])

            {
//                self->douBalanceAmount = [[[dic valueForKey:@"Result"] valueForKey:@"AMOUNT"]  doubleValue];
//               // NSLog(@"user's Balance Amount is = @%f", self->douBalanceAmount);
//                self->douDollorAmount = [[[dic valueForKey:@"Result"] valueForKey:@"OWC_PRICE"]  doubleValue];
               // NSLog(@"Dollar Price is = @%f", self->douDollorAmount);
                //NSLog(@"User Selected Currency is %@ and its rate is %f", self->savedValue, self->crncyValue);
                self->douBalanceAmount = [[dic valueForKey:@"Amount"]  doubleValue];
                            //   NSLog(@"Amount = %f", self->douBalanceAmount);
                               self->resultingArray = [dic valueForKey:@"currnecy"];
                            //   NSLog(@"resulting array %@", self->resultingArray);
                               for (NSDictionary *aDict in self->resultingArray) {
                                   if ([aDict objectForKey:@"Name"]  == self->savedValue) {
                                      // id was indeed 1, replace '1', with the id that you're looking for
                                       self->crncyValue = [[aDict valueForKey:@"Price"] doubleValue];
                                     //  NSLog(@"%@ = %f", self->savedValue, self->crncyValue);
                                  }
                               }
                               self->upperCase = [self->savedValue uppercaseString];

                             //  self->douDollorAmount = [[[dic valueForKey:@"Result"] valueForKey:@"OWC_PRICE"]  doubleValue];
                               self->douTotalAmount = self->douBalanceAmount * self->crncyValue;
                              
                self->douDollorTotalAmount = self->douBalanceAmount * self->crncyValue;
                
                self->strBalance = [NSString stringWithFormat:@"%.04f",self->douBalanceAmount];
                
                self->strBalance = [self->strBalance stringByAppendingString:@" OWC = "];
                
                self->strBalance = [self->strBalance stringByAppendingString:[NSString stringWithFormat:@"%.02f",self->douDollorTotalAmount]];
                NSString *upperCase = [self->savedValue uppercaseString];

                self->strBalance = [self->strBalance stringByAppendingString:@" "];
                self->strBalance = [self->strBalance stringByAppendingString:upperCase];

                [self.lblBalance setText:self->strBalance];
                
                
            }
            else
            {
                
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            }
            
            
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            
        }];
        
    }
    @catch (NSException *exception) {
        
        
    }
    
}

-(BOOL)IsValid
{

    if([self.txtAddress.text isEqualToString:@""])
    {
        [self ShowToastMessage:@"Address Required." InterVal:2];
        return NO;
    }
    else if(douAmount <= 0 || douTotalAmount == 0)
    {
        [self ShowToastMessage:@"Amount Required." InterVal:2];
        return NO;
    }
    else if(douTotalAmount > douBalanceAmount)
    {
        [self ShowToastMessage:@"Insufficeint Balance Amount." InterVal:2];
        return NO;
    }
    else if(douTotalAmount < douMinTxAmt)
    {
        [self ShowToastMessage:@"Minimum Transaction Amount Not FullFill." InterVal:2];
        return NO;
    }
    return YES;
}

-(void)SendData
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter PIN"
                                                               message:@"Please enter six Digit Pin Number"
                                                              preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                        //use alert.textFields[0].text
        [kPref setValue:alert.textFields[0].text forKey:Key_Pin];
        [self sendDatatoServer];
                           
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //cancel action
                                                          }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        // A block for configuring the text field prior to displaying the alert
        textField.placeholder = @"Enter Pin Here...";
        textField.secureTextEntry = YES;

    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    /*
    @try {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [kPref valueForKey:Key_UserEmail],Para_Email,
                                           [kPref valueForKey:Key_LoginPassword],Para_Password,
                                           self.txtAddress.text,Para_ToAddress,
                                           self.txtAmount.text,Para_Amount,
                                           [NSString stringWithFormat:@"%.08f",douFee],Para_Fees,[kPref valueForKey:Key_Pin],Para_pin,
                                           nil];
        
    //    [kPref valueForKey:Key_Pin],Para_pin,
        NSLog(@"Send Parameters are = %@", parameters);
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_TRANSACTION_SEND_V1];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *writeError = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            
            if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                
                douAmount = 0;
                douTotalAmount = 0;
                self.txtTotal.text = @"";
                self.txtAmount.text = @"";
                self.txtAddress.text = @"";
                
                [self ShowToastMessage:@"Coin Transfer Successfully." InterVal:2];
                
                [self GetBalance];
                
            }
            else
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    @catch (NSException *exception) {
    }
    
    */
}
-(void)sendDatatoServer {
    @try {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                           [kPref valueForKey:Key_UserEmail],Para_Email,
                                           [kPref valueForKey:Key_LoginPassword],Para_Password,
                                           self.txtAddress.text,Para_ToAddress,
                                           self.txtAmount.text,Para_Amount,
                                           [NSString stringWithFormat:@"%.08f",douFee],Para_Fees,[kPref valueForKey:Key_Pin],Para_pin,
                                           nil];
        
    //    [kPref valueForKey:Key_Pin],Para_pin,
        //NSLog(@"Send Parameters are = %@", parameters);
        NSString *setUrl = [NSString stringWithFormat:@"%@/%@",WS_Live_URL,EX_TRANSACTION_SEND_V1];
        
        [manager POST:setUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *writeError = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&writeError];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&writeError];
            
            if ([[dic valueForKey:@"Success"] isEqualToNumber:[NSNumber numberWithInt:1]])
            {
                
                douAmount = 0;
                douTotalAmount = 0;
                self.txtTotal.text = @"";
                self.txtAmount.text = @"";
                self.txtCrcAmount.text = @"";
                self.txtAddress.text = @"";
                
                [self ShowToastMessage:@"Coin Transfer Successfully." InterVal:2];
                
                [self GetBalance];
                
            }
            else
                [self ShowToastMessage:[[dic valueForKey:@"Result"] valueForKey:@"Message"] InterVal:2];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
    @catch (NSException *exception) {
    }
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

#pragma mark Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        [self SendData];
    }
}

#pragma mark Currency Value retrievel Delegate
-(void) sendDataToServer : (NSString *) method{

        
        NSURL *url = nil;
        NSMutableURLRequest *request = nil;
        
        // Only Difference between POST and GET is only in the way they send parameters
        
        if([method isEqualToString:@"GET"]){
            
            NSString *getURL = [NSString stringWithFormat:@"%@", URL];
            url = [NSURL URLWithString: getURL];
            request = [NSMutableURLRequest requestWithURL:url];
            NSLog(@"Request data  = %@", request);

            
        }
        else{  // POST
            
            
            
            NSString *parameter = [NSString stringWithFormat:@"%@", URL];
            NSData *parameterData = [parameter dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            url = [NSURL URLWithString: URL];
            request = [NSMutableURLRequest requestWithURL:url];
            NSLog(@"request Data = %@", request);
            [request setHTTPBody:parameterData];
            
        }
        
        [request setHTTPMethod:method];
        [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if( connection )
        {
            
            mutableData = [NSMutableData new];
            
        }else{
            
            [self showemntyAlert];
            
        }
        

    
}


#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", NO_CONNECTION);
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
    NSLog(@"Response from Server : %@", responseStringWithEncoded);
    NSString * receveiddata = responseStringWithEncoded;
    if ([receveiddata  isEqual: (@"null")]){
        NSLog(@"Plesae Check your internet Connection and the try again. . .");
       
    }else{
        [self getData:responseStringWithEncoded];
        
        
    }
    
}

-(void) getData:(NSString *) responseStringWithEncoded{
    
    NSData *data = [responseStringWithEncoded dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
    NSMutableDictionary *marketData = [json objectForKey:@"market_data"];
    
    currentPrice = [marketData objectForKey:@"current_price"];
    
  //  NSLog(@"API Data is %@", currentPrice);
   
    
    crncyValue = [[currentPrice objectForKey:savedValue] doubleValue];

    NSString *upperCase = [savedValue uppercaseString];
              // NSNumber *myDoubleNumber = [NSNumber numberWithDouble:valueForLabel];
               
            //  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            //   NSString *myString = [formatter stringFromNumber:@(crncyValue)];
        
    //NSString * forlable =[NSString stringWithFormat:@"%@ %@", myString ,upperCase];
 
    
             // self.txtCrcAmount.text = [NSString stringWithFormat:@"%f", crncyValue];;
               self.lblTotalDollar.text = upperCase;
    
        
}

-(void)showemntyAlert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Connection Problem"
                                                                   message:@"Please Check your internet Conneciton and then try again..."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Thank You" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

@end
