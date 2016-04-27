//
//  DatePickerController.h
//  radbear-ios
//
//  Created by Gary Foster on 7/15/12.
//

#import <UIKit/UIKit.h>

@class RBDatePickerController;
@protocol RBDatePickerControllerDelegate
    - (void) datePickerController:(RBDatePickerController *)controller didPickDate:(NSDate *)date;
    - (void) datePickerController:(RBDatePickerController *)controller didPickCountdown:(NSTimeInterval)countdown;
@end


@interface RBDatePickerController : UIViewController {
    UIDatePicker *datePicker;
    NSObject <RBDatePickerControllerDelegate> __unsafe_unretained *delegate;
}

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, assign) NSObject <RBDatePickerControllerDelegate> *delegate;
@property (nonatomic, retain) NSString *prompt;
@property (nonatomic, retain) UIButton *callingButton;
@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *initialDate;
@property (nonatomic) NSTimeInterval initialDuration;

@end
