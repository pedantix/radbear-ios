//
//  PasswordResetViewController.m
//  radbear-ios
//
//  Created by Gary Foster on 7/9/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBPasswordResetViewController.h"
#import "RBAppTools.h"
#import "RBServerMessage.h"

static const int MARGIN = 20;

@implementation RBPasswordResetViewController
@synthesize mode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    butCancel.hidden = ![self isModal];
    [butAction setType:BButtonTypeSuccess];
    [butCancel setType:BButtonTypeGray];
    
    NSString *buttonTitle;
    NSString *pageTitle;
    if([self.mode isEqualToString:MODE_CONFIRMATION_RESEND]) {
        buttonTitle = @"Resend";
        pageTitle = @"Confirmation";
    } else {
        buttonTitle = @"Reset";
        pageTitle = @"Password";
    }
    
    [butAction setTitle:buttonTitle forState:UIControlStateNormal];
    
    if (![self isModal])
        self.title = pageTitle;
    else
        self.navigationItem.title = pageTitle;
    
    [self updateSize];
    [self updateDisplay];
    
    txtEmail.text = rbApp.registration.email;
}

- (void)updateSize {
    if ([RBAppTools isIpad]) {
        [RBAppTools doubleSize:imgLogo];
        [RBAppTools doubleSize:txtEmail];
        [RBAppTools doubleSize:butAction];
        [RBAppTools doubleSize:butCancel];
        
        UIFont *font = [UIFont systemFontOfSize:34];
        txtEmail.font = font;
        butAction.titleLabel.font = font;
        butCancel.titleLabel.font = font;
    }
}

- (void)updateDisplay {
    [RBAppTools centerHorizontal:imgLogo];
    [RBAppTools centerHorizontal:txtEmail];
    
    BOOL isShort = [RBAppTools screenHeightForOrientation] < 480;
    imgLogo.hidden = isShort;
    int topMargin = [self isModal] ? 30 : 80;
    
    imgLogo.frame = CGRectMake(imgLogo.frame.origin.x, topMargin, imgLogo.frame.size.width, imgLogo.frame.size.height);
    
    int leftEdge = txtEmail.frame.origin.x;
    int fieldMargin = MARGIN / 3;
    int txtWidth = txtEmail.frame.size.width;
    int txtHeight = txtEmail.frame.size.height;
    int startTop = isShort ? topMargin : imgLogo.frame.origin.y + imgLogo.frame.size.height + MARGIN;
    
    int emailY;
    if ([RBAppTools isIpad] && [self isModal])
        emailY = ([RBAppTools screenHeightForOrientation] - txtHeight - fieldMargin - txtHeight - MARGIN - butAction.frame.size.height) / 2;
    else
        emailY = startTop;
    
    txtEmail.frame = CGRectMake(leftEdge, emailY, txtWidth, txtHeight);
    butAction.frame = CGRectMake(leftEdge, txtEmail.frame.origin.y + txtHeight + MARGIN, [self isModal] ? butAction.frame.size.width : txtWidth, butAction.frame.size.height);
    butCancel.frame = CGRectMake(leftEdge + txtWidth - butAction.frame.size.width, butAction.frame.origin.y, butAction.frame.size.width, butAction.frame.size.height);
}

- (IBAction)action:(id)sender {
    if ([rbApp isNetworkReachable:FALSE]) {
        if([self.mode isEqualToString:MODE_CONFIRMATION_RESEND])
            [self confirmationResend:txtEmail.text];
        else
            [self passwordReset:txtEmail.text];
    }
}

- (void)passwordReset:(NSString *)email {
    [self activityStart];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: [NSDictionary dictionaryWithObjectsAndKeys: email, @"email", nil], @"user", nil];
    
    [rbApp.nonApiClient postPath:@"/users/password" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [RBAppTools msgSuccess:@"You will receive an email with instructions about how to reset your password in a few minutes."];
        
        if ([self isModal])
            [self dismissViewControllerAnimated:true completion:nil];
        else
            [self.navigationController popViewControllerAnimated:TRUE];
        
        [self activityEnd];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RBServerMessage msgWithOperation:operation error:error];
        [self activityEnd];
    }];
}

- (void)confirmationResend:(NSString *)email {
    [self activityStart];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: [NSDictionary dictionaryWithObjectsAndKeys: email, @"email", nil], @"user", nil];
    
    [rbApp.nonApiClient postPath:@"/users/confirmation" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [RBAppTools msgBox:@"You will receive an email with instructions about how to confirm your account in a few minutes." withTitle:@"Success"];
        [self dismissViewControllerAnimated:TRUE completion:nil];
        [self activityEnd];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [RBServerMessage msgWithOperation:operation error:error];
        [self activityEnd];
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self action:nil];
    return YES;
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
}

@end
