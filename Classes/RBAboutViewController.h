//
//  AboutViewController.h
//  radbear-ios
//
//  Created by Gary Foster on 7/10/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSimpleViewController.h"
#import "BButton.h"

@interface RBAboutViewController : RBSimpleViewController {
    IBOutlet UIScrollView *myScrollView;
    
    IBOutlet BButton *butClose;
    IBOutlet UILabel *lblVersion;
    
    IBOutlet UILabel *lblVerify;
    IBOutlet UILabel *lblVerifyDesc;
    
    IBOutlet UILabel *lblPassword;
    IBOutlet UILabel *lblPasswordDesc;
    IBOutlet BButton *butPassword;
    
    IBOutlet UILabel *lblConfirmation;
    IBOutlet UILabel *lblConfirmationDesc;
    IBOutlet BButton *butConfirmation;
    
    IBOutlet BButton *butSupportEmail;
    IBOutlet BButton *butWebsite;
    IBOutlet UIWebView *webThirdParty;
}

- (IBAction)close:(id)sender;
- (IBAction)password:(id)sender;
- (IBAction)confirmation:(id)sender;
- (IBAction)supportEmail:(id)sender;
- (IBAction)launchWebsite:(id)sender;

@end
