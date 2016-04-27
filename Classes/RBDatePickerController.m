//
//  DatePickerController.m
//  radbear-ios
//
//  Created by Gary Foster on 7/15/12.
//

#import "RBDatePickerController.h"
#import "RBAppTools.h"
#import "BButton.h"
#import "RBApp.h"

@implementation RBDatePickerController

@synthesize datePicker, delegate, prompt, callingButton, datePickerMode, initialDate, initialDuration;

- (void) loadView {
    RBApp *rbApp = [RBApp sharedInstance];
    UIColor *backgroundColor = rbApp.environment.darkTheme ? [UIColor lightGrayColor] : [UIColor whiteColor];
    
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = backgroundColor;
    int margin = 20;
    int y = 0;
    int labelHeight = 52;
    int pickerHeight = 162;
    
    y = y + margin;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(margin, y, [RBAppTools screenWidth] - (margin * 2), labelHeight)];
    [lbl setText:[self prompt]];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setFont:[UIFont systemFontOfSize:19]];
    [lbl setNumberOfLines:2];
    [lbl setLineBreakMode:NSLineBreakByWordWrapping];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lbl];

    y = y + margin + labelHeight;
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, y, [RBAppTools screenHeight], pickerHeight)];
    [self.datePicker setDatePickerMode:datePickerMode];
    self.datePicker.backgroundColor = backgroundColor;
    
    if(self.datePickerMode == UIDatePickerModeCountDownTimer)
        [self.datePicker setCountDownDuration:initialDuration];
    else {
        if (initialDate)
            [self.datePicker setDate:initialDate];
    }
    
    [self.view addSubview:self.datePicker];
    
    int buttonHeight = 30;
    y = [RBAppTools screenHeight] - margin - buttonHeight;
    int buttonWidth = ([RBAppTools screenWidth] / 2) - (margin * 2);
    
    BButton *butCancel = [[BButton alloc] initWithFrame:CGRectMake(margin, y, buttonWidth, buttonHeight)];
    [butCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [butCancel setType:BButtonTypeGray];
    [butCancel addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:butCancel];
    
    BButton *butOk = [[BButton alloc] initWithFrame:CGRectMake(margin + buttonWidth + margin + margin, y, buttonWidth, buttonHeight)];
    [butOk setTitle:@"OK" forState:UIControlStateNormal];
    butOk.accessibilityLabel = @"okButton";
    [butOk setType:BButtonTypeSuccess];
    [butOk addTarget:self action:@selector(ok) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:butOk];
}

- (void) ok {
    if(self.datePickerMode == UIDatePickerModeCountDownTimer)
        [delegate datePickerController:self didPickCountdown:datePicker.countDownDuration];
    else
        [delegate datePickerController:self didPickDate:[RBAppTools noSeconds:datePicker.date]];
}

- (void) cancel {
    if(self.datePickerMode == UIDatePickerModeCountDownTimer)
        [delegate datePickerController:self didPickCountdown:0];
    else
        [delegate datePickerController:self didPickDate:nil];
}

@end
