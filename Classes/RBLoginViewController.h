//
//  LoginViewController.h
//  radbear-ios
//
//  Created by Gary Foster on 5/31/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBSimpleViewController.h"
#import "BButton.h"
#import "RBRegistration.h"
#import <Accounts/Accounts.h>
#import <CoreLocation/CoreLocation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

typedef enum {
    LoginDisplayModeLogin,
    LoginDisplayModeSignup,
    LoginDisplayModeEmail,
} LoginDisplayMode;

@interface RBLoginViewController : RBSimpleViewController <CLLocationManagerDelegate> {
    RBRegistration *registration;
    ACAccountStore *accountStore;
    BOOL hasAppSettings;
    
    IBOutlet UIImageView *imgLogo;
    IBOutlet UIButton *butHelp;
    IBOutlet BButton *butFacebookSignIn;
    IBOutlet BButton *butAutoSignIn;
    IBOutlet BButton *butEmailSignIn;
    IBOutlet BButton *butSignInSignUp;
    
    IBOutlet BButton *butShowEmailForm;
    IBOutlet BButton *butHideEmailForm;
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtPasswordConfirmation;
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
            
    BOOL logonAttempted;
    
    CLLocationManager *locationManager;
	CLLocation *currentLocation;
}

- (IBAction)about:(id)sender;
- (IBAction)emailSignIn:(id)sender;
- (IBAction)autoSignIn:(id)sender;
- (IBAction)showEmailForm:(id)sender;
- (IBAction)hideEmailForm:(id)sender;
- (IBAction)signInSignUp:(id)sender;

- (NSDictionary *)getEmailParams:(NSString *)email password:(NSString *)password;
- (NSDictionary *)getSignupParams:(NSString *)email password:(NSString *)password passwordConfirmation:(NSString *)passwordConfirmation firstName:(NSString *)firstName lastName:(NSString *)lastName;
-(void)doLogin:(RegistrationMethod)registrationMethod params:(NSDictionary *)params;
    
@end
