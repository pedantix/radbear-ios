//
//  SimpleList.h
//  radbear-ios
//
//  Created by Gary Foster on 6/26/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBApp.h"
#import "RBSimpleCell.h"

@interface RBSimpleList : UITableViewController {
    RBApp *rbApp;
    NSArray *records;
    
    NSNumber *darkTheme;
    
    bool enableHome;
    bool enableAdd;
    bool hasSubText;
    bool enableRoundedImages;
    
    UIBarButtonItem *butHome;
}

- (void)reloadBaseData;
- (void)activityStart;
- (void)activityEnd;
- (void)goHome;
- (void)dataLoaded:(NSNotification *) notification;

@end
