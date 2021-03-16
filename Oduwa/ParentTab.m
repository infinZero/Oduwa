//
//  ParentTab.m
//  UnifyEarth
//
//  Created by Jayesh on 31/05/18.
//  Copyright © 2018 Jayesh. All rights reserved.
//

#import "ParentTab.h"

@interface ParentTab ()

@end

@implementation ParentTab

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarController *tabBarController = (UITabBarController *)self;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.title = @"Dashboard";
    tabBarItem2.title = @"Send";
    tabBarItem3.title = @"Receive";
    tabBarItem4.title = @"Settings";
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"Home_Select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Home_UnSelect.png"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"Send_Select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Send_UnSelect.png"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"QrCode_Select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"QrCode_UnSelect.png"]];
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"Settings_Select.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Settings_UnSelect.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
