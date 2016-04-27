//
//  PickerViewController.m
//  radbear-ios
//
//  Created by Gary Foster on 1/4/11.
//  Copyright 2011 Radical Bear, LLC. All rights reserved.
//

#import "RBPickerViewController.h"
#import "RBPickerView.h"
#import "RBAppTools.h"
#import "BButton.h"
#import "RBApp.h"

@implementation RBPickerViewController

@synthesize objects, initialSelection, callback, prompt;

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
    RBPickerView *picker = ((RBPickerView *) self.view);
    RBApp *rbApp = [RBApp sharedInstance];
    self.view.backgroundColor = rbApp.environment.darkTheme ? [UIColor lightGrayColor] : [UIColor whiteColor];
    
    int margin = 20;
    
    int buttonHeight = 30;
    int y = [RBAppTools screenHeight] - margin - buttonHeight;
    int buttonWidth = ([RBAppTools screenWidth] / 2) - (margin * 2);
    
    BButton *butCancel = [[BButton alloc] initWithFrame:CGRectMake(margin, y, buttonWidth, buttonHeight)];
    [butCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [butCancel setType:BButtonTypeGray];
    [butCancel addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:butCancel];
    
    BButton *butOk = [[BButton alloc] initWithFrame:CGRectMake(margin + buttonWidth + margin + margin, y, buttonWidth, buttonHeight)];
    [butOk setTitle:@"OK" forState:UIControlStateNormal];
    butOk.accessibilityLabel = @"okButton";
    [butOk setType:BButtonTypeSuccess];
    [butOk addTarget:self action:@selector(doneAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:butOk];
	
    picker.objects = objects;
    BOOL anyObjects = (objects && objects.count > 0);

    CGRect frame = picker.optionsView.frame;
    picker.optionsView.frame = CGRectMake(frame.origin.x, frame.origin.y, [RBAppTools screenWidth], frame.size.height);
    
    if (!(anyObjects))
        [picker.optionsView setUserInteractionEnabled:FALSE];
    
    if (prompt) {
        [picker setPrompt:prompt];
    } else {
        if (anyObjects) {
            NSString *class = [[[[objects objectAtIndex:0] class] description] lowercaseString];
            [picker setPrompt:[[@"Please select a " stringByAppendingString:class] stringByAppendingString:@"."]];
        }
    }
        
    if([objects count] > 0 && self.initialSelection) {    
        int counter;
        
        for(counter = 0; counter <= [objects count] -1; counter++) {
            bool isMatch;
            id object = [objects objectAtIndex:counter];
            
            if ([self.initialSelection isKindOfClass:[RBManagedObject class]]) {
                id idField = [self.initialSelection valueForKey:@"itemId"];
                NSString *type = [[idField class] description];
                
                if ([type isEqualToString:@"__NSCFNumber"])
                    isMatch = [[object valueForKey:@"itemId"] isEqualToNumber:idField];
                else if ([type isEqualToString:@"__NSCFString"])
                    isMatch= [[object valueForKey:@"itemId"] isEqualToString:idField];
                else
                    isMatch = FALSE;
            } else {
                isMatch = [(NSString *)self.initialSelection isEqualToString:object];
            }
            
            if(isMatch) {
                [picker.optionsView selectRow:counter inComponent:0 animated:NO];
                break;
            }
        }
    }
}

- (void) goHome {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)doneAction {
    [callback selectedValue:[(RBPickerView *)self.view currentSelection]];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
