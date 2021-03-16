//
//  AppDelegate.m
//  UnifyEarth
//
//  Created by Jayesh on 30/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "Constant.h"
#import "Home.h"
#import "ParentTab.h"
#import "Pin.h"
#import "Email.h"

@interface AppDelegate ()
{
     UIStoryboard *storyboard;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = true;
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController;
    navController = nil;
    
    [kPref setValue:@"MAIN@PASSWORD$" forKey:Key_MainPassword];
    
    if([kPref valueForKey:Key_PinNo] != nil && ![[kPref valueForKey:Key_PinNo] isEqualToString:@""]) {
        //Pin *objView = [storyboard instantiateViewControllerWithIdentifier:@"Pin"];
        //objView.isCheckPin = YES;
        //objView.isNewPin = NO;
        //objView.isConfirmPin = NO;
        //self.window.rootViewController = objView;
        //navController = [[UINavigationController alloc] initWithRootViewController:objView];
        
        PatternViewController *patternVC = [[PatternViewController alloc] initWithMode:PatternModeValidation delegate:self];
        navController = [[UINavigationController alloc] initWithRootViewController:patternVC];
    } else {
        Email *objView = [storyboard instantiateViewControllerWithIdentifier:@"Email"];
        self.window.rootViewController = objView;
        navController = [[UINavigationController alloc] initWithRootViewController:objView];
    }
    [navController setNavigationBarHidden:YES];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
