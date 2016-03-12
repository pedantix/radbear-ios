//
//  TabBarViewController.m
//  radbear-ios
//
//  Created by Gary Foster on 7/24/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBTabBarViewController.h"
#import "RBApp.h"
#import "RBAppTools.h"

@implementation RBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RBApp *rbApp = [RBApp sharedInstance];
    [rbApp setTabBarController:self];
    
    //this is kind of a hack, to trigger the update badges
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH object:nil];
    
    if (rbApp.meUser.upgrade_notice) {
        if (rbApp.meUser.upgrade_url) {
            UIAlertView* alert =  [[UIAlertView alloc] initWithTitle:@"Update Available" message:rbApp.meUser.upgrade_notice delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Yes Please", nil];
            [alert show];
        } else {
            [RBAppTools msgBox:rbApp.meUser.upgrade_notice withTitle:@"Update Available"];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes Please"]) {
        RBApp *rbApp = [RBApp sharedInstance];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rbApp.meUser.upgrade_url]];
    }
}

- (void)assignIcon:(int)tabItem icon:(FAKFontAwesome *)icon {
    UITabBarItem *item = [self.tabBar.items objectAtIndex:tabItem];
    [item setImage:[RBAppTools getFontAwesomeIcon:icon]];
}

@end
