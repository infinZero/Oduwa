//
//  Global.m
//  SNJ
//
//  Created by peacock on 08/07/16.
//  Copyright © 2016 peacock. All rights reserved.
//

#import "Global.h"


@implementation Global
@synthesize arr_Mast;
@synthesize arr_LooseStockMast;

+ (Global *)sharedInstance {
    
    static dispatch_once_t onceToken;
    static Global *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Global alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "microsoft.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        NSLog(@"-> connection established!\n");
        return YES;
    }
}
-(void)ShowAlertWithMessage:(NSString*)strMessage Title:(NSString*)strTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
    [alert show];
    

}

-(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)IsValidEmailAddress:(NSString *)strEmail
{
    BOOL isValidEmail = YES;
    NSArray* arr_Email = [strEmail componentsSeparatedByString: @","];
    for (int i = 0; i < [arr_Email count]; i++)
    {
        if(![self IsValidEmail:[arr_Email objectAtIndex: i]])
        {
            isValidEmail = NO;
            break;
        }
    }
    
    if(!isValidEmail)
    {
        [self ShowAlertWithMessage:@"Invalid Email Address" Title:Message_Title];
        return NO;
    }
    
    return YES;
}

    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
