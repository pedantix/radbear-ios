//
//  PasswordResetViewController.h
//  radbear-ios
//
//  Created by Gary Foster on 7/9/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSimpleViewController.h"
#import "BButton.h"

#define MODE_PASSWORD_RESET @"modePasswordReset"
#define MODE_CONFIRMATION_RESEND @"modeConfirmationResend"

@interface RBPasswordResetViewController : RBSimpleViewController <UITextFieldDelegate> {
    IBOutlet UIImageView *imgLogo;
    IBOutlet UITextField *txtEmail;
    IBOutlet BButton *butCancel;
    IBOutlet BButton *butAction;
}

@property (nonatomic, strong) NSString *mode;

- (IBAction)cancel:(id)sender;
- (IBAction)action:(id)sender;

@end
