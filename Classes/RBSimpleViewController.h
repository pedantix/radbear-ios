//
//  SimpleView.h
//  radbear-ios
//
//  Created by Gary Foster on 6/26/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBApp.h"
#import "RBManagedObject.h"
#import "BButton.h"

@interface RBSimpleViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    RBApp *rbApp;
    
    UIBarButtonItem *butSaveDone;
    UIBarButtonItem *butHome;
    
    NSNumber *darkTheme;
    
    bool enableHome;
    bool enableEdit;
    bool enableSave;
    
    UIImagePickerController *imagePickerController;
    IBOutlet UIImageView *imgAvatar;
    IBOutlet BButton *butAvatar;
}

@property (nonatomic, retain) RBManagedObject *selectedItem;
@property BOOL hasPhoto;

- (void)activityStart;
- (void)activityEnd;
- (void)reloadBaseData;
- (BOOL)isModal;
- (void)doneTyping;
- (void)go;
- (void)launchMediaPicker;
- (IBAction)selectPhoto:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
