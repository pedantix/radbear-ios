//
//  AboutViewController.m
//  radbear-ios
//
//  Created by Gary Foster on 7/10/12.
///  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBAboutViewController.h"
#import "RBAppTools.h"
#import "RBPasswordResetViewController.h"

@implementation RBAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *titleColor = rbApp.environment.darkTheme ? [UIColor whiteColor] : [UIColor blackColor];
    lblVersion.textColor = titleColor;
    lblVerify.textColor = titleColor;
    lblPassword.textColor = titleColor;
    lblConfirmation.textColor = titleColor;
    
    UIColor *descColor = rbApp.environment.darkTheme ? [UIColor lightGrayColor] : [UIColor darkGrayColor];
    lblVerifyDesc.textColor = descColor;
    lblPasswordDesc.textColor = descColor;
    lblConfirmationDesc.textColor = descColor;
    
    [butClose setType:BButtonTypeGray];
    [butPassword setType:BButtonTypeSuccess];
    [butConfirmation setType:BButtonTypeSuccess];
    [butSupportEmail setType:BButtonTypePrimary];
    [butWebsite setType:BButtonTypePrimary];
    
    if ([RBAppTools hasBackgroundImage:self]) {
        UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
        backgroundImageView.image = [RBAppTools getBackgroundImage:self];
        [myScrollView insertSubview:backgroundImageView atIndex:0];
    }
    
    if (rbApp.environment.enableFacebook)
        lblVerifyDesc.text = @"Verify your account with your social media accounts or your email address to access the best features. This will allow you to access your account on any device or if you have to reinstall the app.";
    else
        lblVerifyDesc.text = @"Verify your account with your email address to access the best features. This will allow you to access your account on any device or if you have to reinstall the app.";
    
    NSString *year = [RBAppTools displaySystemDate:@"yyyy"];
    NSString *copyright = [[[@"Copyright " stringByAppendingString:year] stringByAppendingString:@" - "] stringByAppendingString:rbApp.environment.companyName];
    
    NSString *fontSize = [RBAppTools isIpad] ? @"small" : @"x-small";
    NSString *lineHeight = [RBAppTools isIpad] ? @"12px" : @"6px";
    NSString *html1 = [NSString stringWithFormat:@"<html><head><title>Legal Notice</title></head><body><div style='color:#000000;font-size:%@;line-height:%@;font-family:helvetica'><p>", fontSize, lineHeight];
    
    NSString *html2 = @"</p><p>Includes software from <a href='http://restkit.org/'>RestKit.org</a> and <a href='http://www.dejal.com/developer/'>Dejal</a>.</p></div></body></html>";
    NSString *html = [[html1 stringByAppendingString:copyright] stringByAppendingString:html2];
    
    [webThirdParty loadHTMLString:html baseURL:nil];
    
    [lblVersion setText:[@"Version " stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    
    [self updateSize];
    [self updateDisplay];
}

- (void)updateSize {
    if ([RBAppTools isIpad]) {
        [RBAppTools doubleSize:imgAvatar];
        [RBAppTools doubleSize:butClose];
        [RBAppTools doubleSize:butPassword];
        [RBAppTools doubleSize:butConfirmation];
        [RBAppTools doubleSize:butSupportEmail];
        [RBAppTools doubleSize:butWebsite];
        [RBAppTools doubleSize:lblPassword];
        [RBAppTools doubleSize:lblPasswordDesc];
        [RBAppTools doubleSize:lblConfirmation];
        [RBAppTools doubleSize:lblConfirmationDesc];
        [RBAppTools doubleSize:webThirdParty];
        [RBAppTools doubleSize:lblVersion];
        
        UIFont *font = [UIFont systemFontOfSize:34];
        butPassword.titleLabel.font = font;
        butConfirmation.titleLabel.font = font;
        butSupportEmail.titleLabel.font = font;
        butWebsite.titleLabel.font = font;
        
        UIFont *boldFont = [UIFont boldSystemFontOfSize:34];
        lblConfirmation.font = boldFont;
        lblPassword.font = boldFont;
        
        UIFont *descFont = [UIFont systemFontOfSize:23];
        lblConfirmationDesc.font = descFont;
        lblPasswordDesc.font = descFont;
        
        lblVersion.font = [UIFont systemFontOfSize:20];
    }
}

- (void)updateDisplay {
    int screenHeight;
    
    if([self isModal]) {
        butClose.hidden = FALSE;
        screenHeight = [RBAppTools screenHeightForOrientation];
    } else {
        self.navigationItem.title = [@"About " stringByAppendingString:[RBAppTools appName]];
        butClose.hidden = TRUE;
        screenHeight = [RBAppTools screenHeightForOrientation] - 100; //just guessing what the height of nav and footer is
    }
    
    int padding = 8;
    int frameMargin = 20;
    int screenWidth = [RBAppTools screenWidthForOrientation];
    [RBAppTools changeHorizontalPosition:butClose position:screenWidth - butClose.frame.size.width - frameMargin];
    lblVersion.frame = CGRectMake(butClose.frame.origin.x, butClose.frame.origin.y + butClose.frame.size.height + frameMargin, lblVersion.frame.size.width, lblVersion.frame.size.height);
    
    int descWidth = screenWidth - frameMargin - frameMargin;
    [RBAppTools changeWidth:lblVerifyDesc width:descWidth];
    [RBAppTools changeWidth:lblPasswordDesc width:descWidth];
    [RBAppTools changeWidth:lblConfirmationDesc width:descWidth];
    [RBAppTools changeWidth:webThirdParty width:descWidth];
    
    int buttonWidth = (screenWidth - (frameMargin * 3)) / 2;
    [RBAppTools changeWidth:butSupportEmail width:buttonWidth];
    [RBAppTools changeWidth:butWebsite width:buttonWidth];
    [RBAppTools changeHorizontalPosition:butWebsite position:butSupportEmail.frame.origin.x + butSupportEmail.frame.size.width + frameMargin];
    
    [RBAppTools changeHeight:lblVerifyDesc height:[RBAppTools textHeight:lblVerifyDesc] + padding];
    [RBAppTools changeHeight:lblPasswordDesc height:[RBAppTools textHeight:lblPasswordDesc] + padding];
    [RBAppTools changeHeight:lblConfirmationDesc height:[RBAppTools textHeight:lblConfirmationDesc] + padding];
    
    int y = frameMargin + imgAvatar.frame.size.height + padding;
    
    lblVerify.hidden = !rbApp.environment.enableFrictionless;
    lblVerifyDesc.hidden = !rbApp.environment.enableFrictionless;
    
    if (rbApp.environment.enableFrictionless)
        y = y + lblVerify.frame.size.height + padding + lblVerifyDesc.frame.size.height + padding;
    
    [RBAppTools changeVerticalPosition:lblPassword position:y];
    [RBAppTools changeVerticalPosition:butPassword position:y];
    y = y + lblPassword.frame.size.height + padding;
    [RBAppTools changeVerticalPosition:lblPasswordDesc position:y];
    y = y + lblPasswordDesc.frame.size.height + padding;
    
    [RBAppTools changeHorizontalPosition:butPassword position:lblPassword.frame.origin.x + lblPassword.frame.size.width + frameMargin];
    [RBAppTools changeHorizontalPosition:butConfirmation position:lblConfirmation.frame.origin.x + lblConfirmation.frame.size.width + frameMargin];
    
    lblConfirmation.hidden = !rbApp.environment.enableConfirmation;
    lblConfirmationDesc.hidden = !rbApp.environment.enableConfirmation;
    butConfirmation.hidden = !rbApp.environment.enableConfirmation;
    
    if (rbApp.environment.enableConfirmation) {
        [RBAppTools changeVerticalPosition:lblConfirmation position:y];
        [RBAppTools changeVerticalPosition:butConfirmation position:y];
        y = y + lblConfirmation.frame.size.height + padding;
        [RBAppTools changeVerticalPosition:lblConfirmationDesc position:y];
        y = y + lblConfirmationDesc.frame.size.height + padding;
    }
    
    //add padding to take up extra space
    int contentHeight = y + butSupportEmail.frame.size.height + padding;
    contentHeight = contentHeight + webThirdParty.frame.size.height + padding;
    if (contentHeight < screenHeight)
        y = y + (screenHeight - contentHeight) - frameMargin;
    
    [RBAppTools changeVerticalPosition:butSupportEmail position:y];
    [RBAppTools changeVerticalPosition:butWebsite position:y];
    y = y + butSupportEmail.frame.size.height + padding;
    
    [RBAppTools changeVerticalPosition:webThirdParty position:y];
    y = y + webThirdParty.frame.size.height + padding;
    
    int scrollHeight = y;
    
    int rawScreenWidth = [RBAppTools screenWidthForOrientation];
    int rawScreenHeight = [RBAppTools screenHeightForOrientation];
    
    //really
    int scrollY = 0;
    if ([RBAppTools isIos8]) {
        scrollY = 0;
    } else {
        if (rawScreenWidth > rawScreenHeight) {
            if (rawScreenWidth == 480)
                scrollY = 160;
            else if (rawScreenWidth == 568)
                scrollY = 240;
            else
                scrollY = 280;
        }
    }

    myScrollView.frame = CGRectMake(0, scrollY, screenWidth, screenHeight);
    
    [myScrollView setContentSize:CGSizeMake(screenWidth, scrollHeight)];
}

- (IBAction)confirmation:(id)sender {
    [self performSegueWithIdentifier:@"ConfirmationResend" sender:self];
}

- (IBAction)password:(id)sender {
    [self performSegueWithIdentifier:@"PasswordReset" sender:self];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (IBAction)supportEmail:(id)sender {
    [RBAppTools contactEmail:rbApp.environment.companyEmail];
}

- (IBAction)launchWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rbApp.environment.companyWebsite]];
}

- (IBAction)close:(id)sender {
    if ([self isModal])
        [self dismissViewControllerAnimated:true completion:nil];
    else
        [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PasswordReset"]) {
        RBPasswordResetViewController *vc = [segue destinationViewController];
        [vc setMode:MODE_PASSWORD_RESET];
    } else if ([[segue identifier] isEqualToString:@"ConfirmationResend"]) {
        RBPasswordResetViewController *vc = [segue destinationViewController];
        [vc setMode:MODE_CONFIRMATION_RESEND];
    }
}

@end
