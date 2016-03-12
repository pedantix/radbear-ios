//
//  SimpleView.m
//  radbear-ios
//
//  Created by Gary Foster on 6/26/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBSimpleViewController.h"
#import "RBAppTools.h"
#import "DejalActivityView.h"
#import "RBServerMessage.h"

@implementation RBSimpleViewController

@synthesize selectedItem, hasPhoto;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return [darkTheme boolValue] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [self setNeedsStatusBarAppearanceUpdate];
    
    rbApp = [RBApp sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded:) name:NOTIFICATION_REFRESH object:nil];
    
    if (darkTheme == nil)
        darkTheme = [NSNumber numberWithBool:rbApp.environment.darkTheme];
    
    if (enableHome) {
        UIImage *imgHome = [RBAppTools getFontAwesomeIcon:[FAKFontAwesome homeIconWithSize:30]];
        butHome = [[UIBarButtonItem alloc] initWithImage:imgHome landscapeImagePhone:imgHome style:UIBarButtonItemStylePlain target:self action:@selector(goHome)];
        [[self navigationItem] setRightBarButtonItem:butHome];
    }
    
    butSaveDone = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(go)];
    [butSaveDone setTintColor:RBAppTools.greenColor];
    if (enableSave)
        [self.navigationItem setRightBarButtonItem:butSaveDone];
    
    if ([RBAppTools hasBackgroundImage:self] && ![[self.class description] isEqualToString:@"RBAboutViewController"]) {
        UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
        backgroundImageView.image = [RBAppTools getBackgroundImage:self];
        [self.view insertSubview:backgroundImageView atIndex:0];
    } else
        self.view.backgroundColor = [darkTheme boolValue] ? [UIColor blackColor] : [UIColor whiteColor];
    
    [self setTitle];
    
    if (enableEdit) {
        UIBarButtonItem *butEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
        [[self navigationItem] setRightBarButtonItem:butEdit];
    }
    
    [butAvatar setType:BButtonTypeInfo];
}

- (void)setTitle {
    NSString *className = [self.class description];

    NSString *objectType;    
    if ([className rangeOfString:@"UpdateViewController"].location != NSNotFound)
        objectType = [[className componentsSeparatedByString:@"UpdateViewController"] objectAtIndex:0];
    else
        objectType = [[className componentsSeparatedByString:@"ViewController"] objectAtIndex:0];
    
    if (enableSave) {
        if(self.selectedItem) {
            [[self navigationItem] setTitle:[@"Update " stringByAppendingString:objectType]];
        } else {
            [[self navigationItem] setTitle:[@"Add " stringByAppendingString:objectType]];
        }
    } else {
        if (self.selectedItem) {
            [[self navigationItem] setTitle:[selectedItem valueForKey:@"display_name"]];
        } else {
            [[self navigationItem] setTitle:[RBAppTools camelCaseToWords:objectType]];
        }
    }
}

-(void)textViewDidBeginEditing:(UITextField *)sender {
    butSaveDone.title = @"Done";
    butSaveDone.action = @selector(doneTyping);
    
    if (!enableSave)
        [self.navigationItem setRightBarButtonItem:butSaveDone];
}

-(void)textViewDidEndEditing:(UITextView *)sender {
    butSaveDone.title = @"Save";
    butSaveDone.action = @selector(go);
    
    if (!enableSave)
        [self.navigationItem setRightBarButtonItem:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)sender {
    butSaveDone.title = @"Done";
    butSaveDone.action = @selector(doneTyping);
    
    if (!enableSave)
        [self.navigationItem setRightBarButtonItem:butSaveDone];
}

-(void)textFieldDidEndEditing:(UITextField *)sender {
    butSaveDone.title = @"Save";
    butSaveDone.action = @selector(go);
    
    if (!enableSave)
        [self.navigationItem setRightBarButtonItem:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)go {
    //implment in subclasses
}

- (void)doneTyping {
    [self.view endEditing:YES];
}

- (IBAction)backgroundTapped:(id)sender {
    [self doneTyping];
}

- (BOOL)isModal {
    return self.parentViewController == nil;
}

- (void)reloadBaseData {
    if ([rbApp isNetworkReachable:FALSE]) {
        [self activityStart];
        [rbApp.objectManager getObjectsAtPath:@"users" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            if ([rbApp handleUsersLoaded:[mappingResult array] silent:FALSE]) {
                [self activityEnd];
            } else {
                [self activityEnd];
            }
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [RBServerMessage msgWithError:error];
            [self activityEnd];
        }];
    }
}

- (void)dataLoaded:(NSNotification *) notification {
    //let the sub classes handle this for now unless a pattern materializes
}

- (void)edit {
    [self performSegueWithIdentifier:@"Edit" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Edit"]) {
        UIViewController *vc = [segue destinationViewController];
        [vc setValue:self.selectedItem forKey:@"selectedItem"];
    }
}

- (void)goHome {
    [[rbApp tabBarController] setSelectedIndex:0];
}

- (void)activityStart {
    [DejalBezelActivityView activityViewForView:self.view];
}

- (void)activityEnd {
    [DejalBezelActivityView removeViewAnimated:YES];
}

-(void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)selectPhoto:(id)sender {
    [self launchMediaPicker];
}

- (void)launchMediaPicker {
    if([RBAppTools isCameraAvailable]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        
        [message addButtonWithTitle:@"Take Photo"];
        [message addButtonWithTitle:@"Choose From Library"];
        
        [message show];
    } else
        [self choosePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
	if([title isEqualToString:@"Take Photo"])
		[self choosePhoto:UIImagePickerControllerSourceTypeCamera];
	else if([title isEqualToString:@"Choose From Library"])
		[self choosePhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)choosePhoto:(UIImagePickerControllerSourceType)sourceType {
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    
    if (self.navigationController == nil)
        [self presentViewController:imagePickerController animated:YES completion:nil];
    else
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    imagePickerController.view.hidden = YES;
    
    NSString *mediaType = [info valueForKey:@"UIImagePickerControllerMediaType"];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        imgAvatar.image = image;
        self.hasPhoto = TRUE;
    } else {
        [RBServerMessage msgWithString:[@"Invalid media type: " stringByAppendingString:mediaType]];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissViewControllerAnimated:YES completion:nil];
}

@end
