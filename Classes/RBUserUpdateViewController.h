//
//  UserUpdateViewController.h
//  radbear-ios
//
//  Created by Gary Foster on 7/24/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSimpleViewController.h"
#import "RBUser.h"

@interface RBUserUpdateViewController : RBSimpleViewController {
    IBOutlet UILabel *lblEmail;
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtMobilePhone;
    IBOutlet UITextField *txtUsername;
    RBUser *user;
}

@end
