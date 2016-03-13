//
//  UserUpdateViewController.m
//  radbear-ios
//
//  Created by Gary Foster on 7/24/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBUserUpdateViewController.h"
#import "RBServerMessage.h"
#import "UIImageView+WebCache.h"
#import "RBAppTools.h"

@implementation RBUserUpdateViewController

@synthesize hasPhoto;

- (void)viewDidLoad {
    enableSave = TRUE;
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"My Profile";
    
    self.selectedItem = rbApp.meUser;
    user = rbApp.meUser;
    
    [self updateSize];
    [self updateDisplay];
    
    lblEmail.text = user.email;
    txtUsername.text = user.username;
    txtFirstName.text = user.first_name;
    txtLastName.text = user.last_name;
    txtMobilePhone.text = user.mobile_phone;
    
    if (rbApp.environment.useAvatar)
        [imgAvatar sd_setImageWithURL:[NSURL URLWithString:user.avatar.normal] placeholderImage:[UIImage imageNamed:@"photo-icon.png"]];
}

- (void)updateSize {
    if ([RBAppTools isIpad]) {
        [RBAppTools doubleSize:lblEmail];
        [RBAppTools doubleSize:imgAvatar];
        [RBAppTools doubleSize:txtUsername];
        [RBAppTools doubleSize:txtFirstName];
        [RBAppTools doubleSize:txtLastName];
        [RBAppTools doubleSize:txtMobilePhone];
        [RBAppTools doubleSize:butAvatar];
        
        UIFont *font = [UIFont systemFontOfSize:34];
        lblEmail.font = font;
        txtUsername.font = font;
        txtFirstName.font = font;
        txtLastName.font = font;
        txtMobilePhone.font = font;
        butAvatar.titleLabel.font = font;
    }
}

- (void)updateDisplay {
    UIColor *labelColor = rbApp.environment.darkTheme ? [UIColor whiteColor] : [UIColor blackColor];
    lblEmail.textColor = labelColor;
    
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    
    if (rbApp.environment.useUsername)
        [fields addObject:txtUsername];
    
    if (rbApp.environment.useFirstName)
        [fields addObject:txtFirstName];
    
    if (rbApp.environment.useLastName)
        [fields addObject:txtLastName];
    
    if (rbApp.environment.useMobilePhone)
        [fields addObject:txtMobilePhone];
    
    [RBAppTools centerHorizontal:lblEmail];
    int leftEdge = lblEmail.frame.origin.x;
    int fieldSpacing = 10;
    lblEmail.frame = CGRectMake(leftEdge, 80, lblEmail.frame.size.width, lblEmail.frame.size.height);
    
    int yPos = lblEmail.frame.origin.y + lblEmail.frame.size.height + fieldSpacing;
    
    for (UIView *field in fields) {
        field.hidden = FALSE;
        field.frame = CGRectMake(leftEdge, yPos, field.frame.size.width, field.frame.size.height);
        yPos = yPos + field.frame.size.height + fieldSpacing;
    }
    
    //image picker doesn't work in landscape mode that I could see although there are some cryptic solutions available
    if (rbApp.environment.useAvatar && [RBAppTools screenWidthForOrientation] < [RBAppTools screenHeightForOrientation]) {
        imgAvatar.frame = CGRectMake(leftEdge, yPos, imgAvatar.frame.size.width, imgAvatar.frame.size.height);
        butAvatar.frame = CGRectMake(imgAvatar.frame.origin.x + imgAvatar.frame.size.width + fieldSpacing, yPos, butAvatar.frame.size.width, butAvatar.frame.size.height);
        
        imgAvatar.hidden = FALSE;
        butAvatar.hidden = FALSE;
        
        yPos = yPos + butAvatar.frame.size.height + fieldSpacing;
    }
    
    //todo fix keyboard handling on iPhone in landscape - it's currently covering all the fields
    
    /* todo redo when the time comes
    if ([RBUser additionalProfileFields]) {
        int counter = 0;
        for (NSString *field in [RBUser additionalProfileFields]) {
            int initial = counter == 0 ? 55 : 0;
            counter ++;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, nextControl.frame.origin.y + FIELD_SPACING + initial, 223, FIELD_HEIGHT)];
            lbl.textColor = labelColor;
            lbl.text = [RBAppTools underscoreToWords:field];
            
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(251, nextControl.frame.origin.y +FIELD_SPACING + initial, 51, FIELD_HEIGHT)];
            [sw setOn:[[user valueForKey:field] boolValue]];
            sw.tag = counter;
            
            [self.view addSubview:lbl];
            [self.view addSubview:sw];
            nextControl = sw;
        }
    }*/
}

-(void)go {
    [super go];
    
    if ([rbApp isNetworkReachable:FALSE]) {
        if (user) {
            [self setFields];
            [self activityStart];
            
            NSString *url = [@"users/" stringByAppendingString:[user.itemId stringValue]];
            
            NSMutableURLRequest *request =
            [rbApp.objectManager multipartFormRequestWithObject:user method:RKRequestMethodPUT path:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if (hasPhoto) {
                    NSData *imageData = [RBAppTools compressImage:imgAvatar.image];
                    [formData appendPartWithFileData:imageData name:@"user[avatar]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                }
            }];
            
            RKObjectRequestOperation *operation = [rbApp.objectManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [rbApp handleUsersLoaded:[mappingResult array] silent:FALSE];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH object:nil];
                [self activityEnd];
                [[self navigationController] popViewControllerAnimated:YES];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                [RBServerMessage msgWithError:error];
                [self activityEnd];
            }];
            
            [rbApp.objectManager enqueueObjectRequestOperation:operation];
        }
    }
}

-(void)setFields {
    user.first_name = txtFirstName.text;
    user.last_name = txtLastName.text;
    user.mobile_phone = txtMobilePhone.text;
    user.username = txtUsername.text;
    
    if ([RBUser additionalProfileFields]) {
        int counter = 0;
        for (NSString *field in [RBUser additionalProfileFields]) {
            counter ++;
            UISwitch *sw = (UISwitch *)[self.view viewWithTag:counter];
            [user setValue:[NSNumber numberWithBool:sw.isOn] forKey:field];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == txtFirstName) {
        [txtLastName becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    if (textField == txtLastName) { 
        [self go];
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [txtFirstName resignFirstResponder];
    [txtFirstName resignFirstResponder];
}

@end
