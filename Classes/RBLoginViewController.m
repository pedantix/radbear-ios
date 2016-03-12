//
//  LoginViewController.m
///  radbear-ios
//
//  Created by Gary Foster on 5/31/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBLoginViewController.h"
#import "UIImageView+WebCache.h"
#import "RBAppTools.h"
#import "RBServerMessage.h"
#import "GetMacAddress.h"
#import "Reachability.h"
#import <Social/Social.h>
@import SafariServices;

//todo handle use_first_name and use_last_name in signup flow

static const int MARGIN = 20;

@implementation RBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    accountStore = [[ACAccountStore alloc] init];
    
    [butHelp setImage:[RBAppTools getFontAwesomeIcon:[FAKFontAwesome questionCircleIconWithSize:[RBAppTools isIpad] ? 80 : 40] darkTheme:rbApp.environment.darkTheme dim:TRUE] forState:UIControlStateNormal];
    
    registration = rbApp.registration;
    
    [butFacebookSignIn setType:BButtonTypeFacebook];
    [butShowEmailForm setType:BButtonTypeDefault];
    [butAutoSignIn setType:BButtonTypeSuccess];
    [butEmailSignIn setType:BButtonTypeSuccess];
    [butHideEmailForm setType:BButtonTypeGray];
    [butSignInSignUp setType:BButtonTypeDefault];
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach) {
        [self reachabilityChanged];
    };
    [reach startNotifier];
    
    [self updateSize];
    [self updateDisplay:LoginDisplayModeLogin];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (rbApp.environment.runningKifTests) {
        [rbApp.environment loadAppSettings:nil];    //todo read from mock file
        [self applyAppSettings];
    }
}

- (void)reachabilityChanged {
    //kif doesn't handle this well so I load the settings in viewDidAppear
    
    if (!rbApp.environment.runningKifTests)
        [self loadAppSettings];
}


- (void)updateSize {
    if ([RBAppTools isIpad]) {
        [RBAppTools doubleSize:butHelp];
        [RBAppTools doubleSize:imgLogo];
        [RBAppTools doubleSize:txtEmail];
        [RBAppTools doubleSize:txtPassword];
        [RBAppTools doubleSize:txtPasswordConfirmation];
        [RBAppTools doubleSize:txtFirstName];
        [RBAppTools doubleSize:txtLastName];
        [RBAppTools doubleSize:butEmailSignIn];
        [RBAppTools doubleSize:butShowEmailForm];
        [RBAppTools doubleSize:butHideEmailForm];
        [RBAppTools doubleSize:butFacebookSignIn];
        [RBAppTools doubleSize:butAutoSignIn];
        
        UIFont *font = [UIFont systemFontOfSize:34];
        txtEmail.font = font;
        txtPassword.font = font;
        txtPasswordConfirmation.font = font;
        txtFirstName.font = font;
        txtLastName.font = font;
        butEmailSignIn.titleLabel.font = font;
        butHideEmailForm.titleLabel.font = font;
        butFacebookSignIn.titleLabel.font = font;
        butSignInSignUp.titleLabel.font = font;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)loadAppSettings {
    if (!hasAppSettings) {
        [self activityStart];
        
        [rbApp.objectManager.HTTPClient getPath:@"app_settings" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = nil;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                [RBServerMessage msgWithError:error];
            } else {
                [rbApp.environment loadAppSettings:JSON];
                
                [self applyAppSettings];
                
                if (!logonAttempted) {
                    logonAttempted = TRUE;
                    if (!registration.loggedOut && !rbApp.environment.runningKifTests)
                        [self autoSignIn:nil];
                }
            }
            
            [self activityEnd];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [RBServerMessage msgWithError:error];
            [self activityEnd];
        }];
    }
}

- (void)applyAppSettings {
    hasAppSettings = TRUE;
    
    if (rbApp.environment.enableLocation && !rbApp.environment.runningKifTests) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 200;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            [locationManager requestAlwaysAuthorization];
            
        [locationManager startUpdatingLocation];
        currentLocation = locationManager.location;        
    }
    
    [self updateDisplay:LoginDisplayModeLogin];
}

-(IBAction)facebookButtonClicked:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    //todo allow these permissions to be configured per project, same thing with rails counterpart
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday", @"user_location", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             [RBAppTools msgBox:error.localizedDescription withTitle:@"Facebook error"];
         } else if (result.isCancelled) {
             //just chill
         } else {
             [self facebookSignin:result.token.tokenString];
         }
     }];
}

- (IBAction)autoSignIn:(id)sender {
    [self updateDisplay:LoginDisplayModeLogin];
    
    if (registration.lastRegistrationMethod == RegistrationMethodDevice && rbApp.environment.enableFrictionless) {
        [self doLogin:registration.lastRegistrationMethod params:[self getDeviceParams]];
    } else if (registration.lastRegistrationMethod == RegistrationMethodFacebook) {
        if ([FBSDKAccessToken currentAccessToken])
            [self facebookSignin:[[FBSDKAccessToken currentAccessToken] tokenString]];
        else
            [self facebookButtonClicked:self];
    } else if (registration.lastRegistrationMethod == RegistrationMethodEmail) {
        txtEmail.text = registration.email;
        [self doLogin:registration.lastRegistrationMethod params:[self getEmailParams:registration.email password:registration.password]];
    }
}

- (NSDictionary *)getDeviceParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[GetMacAddress getMacAddress], @"mac_address",
                                                                              registration.deviceId, @"device_id",
                                                                              [self getDeviceType], @"device_type",
                                                                              @"iOS", @"platform", [[[NSBundle mainBundle] infoDictionary]
                                                                              objectForKey:@"CFBundleShortVersionString"], @"version", nil];
    
    if (rbApp.environment.enableLocation && currentLocation) {
        [params setObject:[NSNumber numberWithDouble:currentLocation.coordinate.longitude] forKey:@"longitude"];
        [params setObject:[NSNumber numberWithDouble:currentLocation.coordinate.latitude] forKey:@"latitude"];
    }
    
    return params;
}

- (NSDictionary *)getFacebookParams:(NSString *)accessToken {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: accessToken, @"facebook_access_token", nil];
    [params addEntriesFromDictionary:[self getDeviceParams]];
    return params;
}

- (NSDictionary *)getEmailParams:(NSString *)email password:(NSString *)password {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: email, @"email", password, @"password", nil];
    [params addEntriesFromDictionary:[self getDeviceParams]];
    return params;
}

- (NSDictionary *)getSignupParams:(NSString *)email password:(NSString *)password passwordConfirmation:(NSString *)passwordConfirmation firstName:(NSString *)firstName lastName:(NSString *)lastName {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: email, @"email", password, @"password", passwordConfirmation, @"password_confirmation", firstName, @"first_name", lastName, @"last_name", nil];
    [params addEntriesFromDictionary:[self getDeviceParams]];
    return params;
}

- (NSString *)getDeviceType {
    UIDevice *device = [UIDevice currentDevice];
    return [[[[[device model] stringByAppendingString:@" - "] stringByAppendingString:[device systemName]] stringByAppendingString:@" "] stringByAppendingString:[device systemVersion]];
}

-(void)doLogin:(RegistrationMethod)registrationMethod params:(NSDictionary *)params {
    if ([rbApp isNetworkReachable:FALSE]) {
        [self enableFields:FALSE];
        [self activityStart];
        
        [rbApp.objectManager postObject:nil path:@"tokens" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            if ([rbApp handleUsersLoaded:[mappingResult array] silent:FALSE]) {
                if (registrationMethod == RegistrationMethodEmail)
                    registration.password = [params valueForKey:@"password"];
                
                registration.email = rbApp.meUser.email;
                registration.lastRegistrationMethod = registrationMethod;
                registration.loggedOut = FALSE;
                registration.loggedOn = TRUE;
                [registration persist];
                
                [rbApp maybePostDevice];
                
                [self proceedToApp];
            }
            
            [self activityEnd];
            [self enableFields:TRUE];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            if ([error.localizedDescription isEqualToString:@"You have to confirm your account before continuing"] && [self signingUp]) {
                txtPasswordConfirmation.text = nil;
                txtFirstName.text = nil;
                txtLastName.text = nil;
                [self updateDisplay:LoginDisplayModeEmail];
                [RBAppTools msgBox:@"Please check your email and confirm your account, then log in." withTitle:@"Success"];
            } else {
                [self updateDisplay:[self signingUp] ? LoginDisplayModeSignup : registrationMethod == RegistrationMethodEmail ? LoginDisplayModeEmail : LoginDisplayModeLogin];
                [RBServerMessage msgWithOperation:[operation HTTPRequestOperation] error:error];
            }
            [self activityEnd];
            [self enableFields:TRUE];
        }];
    }
}

- (void)enableFields:(BOOL)enabled {
    butFacebookSignIn.enabled = enabled;
    butShowEmailForm.enabled = enabled;
    butAutoSignIn.enabled = enabled;
    
    [butFacebookSignIn setType:enabled ? BButtonTypeFacebook : BButtonTypeDefault];
    [butAutoSignIn setType:enabled ? BButtonTypeSuccess : BButtonTypeDefault];
}

- (void)facebookSignin:(NSString *)accessToken {
    [self updateDisplay:LoginDisplayModeLogin];
    [self doLogin:RegistrationMethodFacebook params:[self getFacebookParams:accessToken]];
}

- (IBAction)emailSignIn:(id)sender {
    if ([self signingUp]) {
        if ([txtEmail.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""] || [txtPasswordConfirmation.text isEqualToString:@""]|| txtEmail.text == nil || txtPassword.text == nil || txtPasswordConfirmation.text == nil)
            [RBServerMessage msgWithString:@"Please enter the required fields."];
        else
            [self doLogin:RegistrationMethodEmail params:[self getSignupParams:txtEmail.text password:txtPassword.text passwordConfirmation:txtPasswordConfirmation.text firstName:txtFirstName.text lastName:txtLastName.text]];
    } else {
        if ([txtEmail.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""] || txtEmail.text == nil || txtPassword.text == nil)
            [RBServerMessage msgWithString:@"Please enter an email address and password."];
        else
            [self doLogin:RegistrationMethodEmail params:[self getEmailParams:txtEmail.text password:txtPassword.text]];
    }
}

- (IBAction)showEmailForm:(id)sender {
    [self updateDisplay:LoginDisplayModeEmail];
}

- (IBAction)hideEmailForm:(id)sender {
    [self updateDisplay:LoginDisplayModeLogin];
}

- (void)updateDisplay:(LoginDisplayMode)displayMode {
    butAutoSignIn.hidden = !hasAppSettings;
    butEmailSignIn.hidden = !hasAppSettings;
    butFacebookSignIn.hidden = !hasAppSettings;
    butHideEmailForm.hidden = !hasAppSettings;
    butShowEmailForm.hidden = !hasAppSettings;
    txtEmail.hidden = !hasAppSettings;
    txtPassword.hidden = !hasAppSettings;
    txtPasswordConfirmation.hidden = !hasAppSettings;
    txtFirstName.hidden = !hasAppSettings;
    txtLastName.hidden = !hasAppSettings;
    butHelp.enabled = hasAppSettings;
    BOOL emailOnly = TRUE;
    
    [RBAppTools moveUpperRight:butHelp];
    [RBAppTools centerHorizontal:imgLogo];
    
    BOOL isShort = [RBAppTools screenHeightForOrientation] < 480;
    imgLogo.hidden = isShort || displayMode == LoginDisplayModeSignup;
    
    if (hasAppSettings) {
        butEmailSignIn.enabled = TRUE;
        butHelp.enabled = TRUE;
        butAutoSignIn.hidden = !rbApp.environment.enableFrictionless;
        
        if (displayMode == LoginDisplayModeSignup) {
            [butEmailSignIn setTitle:@"Sign Up" forState:UIControlStateNormal];
            [butSignInSignUp setTitle:@"Sign In" forState:UIControlStateNormal];
        } else {
            [butEmailSignIn setTitle:@"Sign In" forState:UIControlStateNormal];
            [butSignInSignUp setTitle:@"Sign Up" forState:UIControlStateNormal];
        }
        
        emailOnly = !rbApp.environment.enableFacebook && !rbApp.environment.enableFrictionless;
        
        if (emailOnly) {
            butShowEmailForm.hidden = TRUE;
            
            if (displayMode != LoginDisplayModeSignup)
                displayMode = LoginDisplayModeEmail;
        }
        
        butSignInSignUp.hidden = (rbApp.environment.signupMode == SignupModeNone);
        
        txtEmail.hidden = !(displayMode == LoginDisplayModeEmail || displayMode == LoginDisplayModeSignup);
        txtPassword.hidden = !(displayMode == LoginDisplayModeEmail || displayMode == LoginDisplayModeSignup);
        txtPasswordConfirmation.hidden = !(displayMode == LoginDisplayModeSignup);
        txtFirstName.hidden = !(displayMode == LoginDisplayModeSignup);
        txtLastName.hidden = !(displayMode == LoginDisplayModeSignup);
        butEmailSignIn.hidden = !(displayMode == LoginDisplayModeEmail || displayMode == LoginDisplayModeSignup);
        butHideEmailForm.hidden = !(displayMode == LoginDisplayModeEmail) || emailOnly;
        
        BOOL autoHide = displayMode == LoginDisplayModeEmail && isShort;
        butAutoSignIn.hidden = autoHide || !rbApp.environment.enableFrictionless;
        butShowEmailForm.hidden = autoHide || emailOnly;
        
        [butFacebookSignIn setHidden:autoHide || !rbApp.environment.enableFacebook];

        if (displayMode == LoginDisplayModeLogin) {
            butShowEmailForm.enabled = TRUE;
        } else if (displayMode == LoginDisplayModeEmail) {
            butShowEmailForm.enabled = FALSE;
            [txtEmail setReturnKeyType:UIReturnKeyNext];
        } else if (displayMode == LoginDisplayModeSignup) {
            butShowEmailForm.enabled = FALSE;
            [txtEmail setReturnKeyType:UIReturnKeyNext];
            [txtPassword setReturnKeyType:UIReturnKeyNext];
            
            if (rbApp.environment.useFirstName)
                [txtPasswordConfirmation setReturnKeyType:UIReturnKeyNext];
            
            if (rbApp.environment.useLastName)
                [txtFirstName setReturnKeyType:UIReturnKeyNext];
        }
        
        [RBAppTools centerHorizontal:txtEmail];
        [RBAppTools centerHorizontal:txtPassword];
        [RBAppTools centerHorizontal:txtPasswordConfirmation];
        [RBAppTools centerHorizontal:txtFirstName];
        [RBAppTools centerHorizontal:txtLastName];
        
        int leftEdge = txtEmail.frame.origin.x;
        int fieldMargin = MARGIN / 3;
        int txtWidth = txtEmail.frame.size.width;
        int txtHeight = txtEmail.frame.size.height;
        int startTop = isShort ? MARGIN : imgLogo.frame.origin.y + imgLogo.frame.size.height + MARGIN;
        
        int emailY;
        if (emailOnly && [RBAppTools isIpad]) {
            emailY = ([RBAppTools screenHeightForOrientation] - txtHeight - fieldMargin - txtHeight - MARGIN - butEmailSignIn.frame.size.height) / 2;
            if (displayMode == LoginDisplayModeSignup)
                emailY = emailY - (txtHeight * 3) - (fieldMargin * 2);
        } else
            emailY = startTop;
        
        txtEmail.frame = CGRectMake(leftEdge, emailY, txtWidth, txtHeight);
        txtPassword.frame = CGRectMake(leftEdge, txtEmail.frame.origin.y + txtHeight + fieldMargin, txtWidth, txtHeight);
        txtPasswordConfirmation.frame = CGRectMake(leftEdge, txtPassword.frame.origin.y + txtHeight + fieldMargin, txtWidth, txtHeight);
        txtFirstName.frame = CGRectMake(leftEdge, txtPasswordConfirmation.frame.origin.y + txtHeight + fieldMargin, txtWidth, txtHeight);
        txtLastName.frame = CGRectMake(leftEdge, txtFirstName.frame.origin.y + txtHeight + fieldMargin, txtWidth, txtHeight);
        
        UIView *belowThis;
        if (!txtLastName.hidden)
            belowThis = txtLastName;
        else if (!txtFirstName.hidden)
            belowThis = txtFirstName;
        else if (!txtPasswordConfirmation.hidden)
            belowThis = txtPasswordConfirmation;
        else
            belowThis = txtPassword;
        
        butEmailSignIn.frame = CGRectMake(leftEdge, belowThis.frame.origin.y + txtHeight + MARGIN, butEmailSignIn.frame.size.width, butEmailSignIn.frame.size.height);
        
        if (rbApp.environment.signupMode == SignupModeStandard)
            butSignInSignUp.frame = CGRectMake(leftEdge + txtWidth - butEmailSignIn.frame.size.width, butEmailSignIn.frame.origin.y, butEmailSignIn.frame.size.width, butEmailSignIn.frame.size.height);
        
        butHideEmailForm.frame = CGRectMake(leftEdge + txtWidth - butEmailSignIn.frame.size.width, butEmailSignIn.frame.origin.y, butEmailSignIn.frame.size.width, butEmailSignIn.frame.size.height);
        
        if(rbApp.environment.signupMode == SignupModeWeb)
            butSignInSignUp.frame = butShowEmailForm.frame;
        
        int buttonMargin = MARGIN / 4;
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        
        if (rbApp.environment.signupMode == SignupModeWeb)
            [buttons addObject:butSignInSignUp];
        
        if (!butAutoSignIn.hidden)
            [buttons addObject:butAutoSignIn];
        
        if (!butShowEmailForm.hidden)
            [buttons addObject:butShowEmailForm];
        
        if (!butFacebookSignIn.hidden)
            [buttons addObject:butFacebookSignIn];
        
        int yPos = [RBAppTools screenHeightForOrientation] - buttonMargin;
        
        for (UIView *button in buttons) {
            yPos = yPos - button.frame.size.height - buttonMargin;
            button.frame = CGRectMake(leftEdge, yPos, button.frame.size.width, button.frame.size.height);
        }
    }
}

- (void)proceedToApp {
    txtPassword.text = nil;
    txtPasswordConfirmation.text = nil;
    txtFirstName.text = nil;
    txtLastName.text = nil;
    
    if ([self signingUp])
        [self updateDisplay:LoginDisplayModeLogin];
    
    UIStoryboard *app = [UIStoryboard storyboardWithName:@"AppMain" bundle:nil];
    UIViewController *vc = [app instantiateInitialViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:TRUE completion:nil];
}

- (IBAction)about:(id)sender {
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"RBMain" bundle:nil];
    UIViewController *vc = [main instantiateViewControllerWithIdentifier:@"About"];
    [self presentViewController:vc animated:TRUE completion:nil];
}

- (IBAction)signInSignUp:(id)sender {
    if (rbApp.environment.signupMode == SignupModeWeb) {
        SFSafariViewController *safariVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:[rbApp.environment.baseURL stringByAppendingString:@"/users/sign_up"]] entersReaderIfAvailable:NO];
        safariVC.delegate = self;
        [self presentViewController:safariVC animated:NO completion:nil];
    } else {
        if ([self signingUp])
            [self updateDisplay:LoginDisplayModeLogin];
        else
            [self updateDisplay:LoginDisplayModeSignup];
    }
}

- (BOOL)signingUp {
    return [butSignInSignUp.titleLabel.text isEqualToString:@"Sign In"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //todo handle case when first name and last name are not enabled
    if(textField == txtEmail) {
        [txtPassword becomeFirstResponder];
    } else if(textField == txtPassword) {
        if ([self signingUp])
            [txtPasswordConfirmation becomeFirstResponder];
        else
            [textField resignFirstResponder];
    } else if(textField == txtFirstName) {
        [txtLastName becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    BOOL isLastField;
    if ([self signingUp]) {
        if (rbApp.environment.useLastName && textField == txtLastName)
            isLastField = TRUE;
        else if (rbApp.environment.useFirstName && textField == txtFirstName)
            isLastField = TRUE;
        else
            isLastField = (textField == txtPasswordConfirmation);
    } else {
        isLastField = (textField == txtPassword);
    }
    
    if (isLastField) {
        [self emailSignIn:nil];
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtPasswordConfirmation resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
}

@end
