//
//  PickerButton.h
//  radbear-ios
//
//  Created by Gary Foster on 7/13/12.
//

#import <UIKit/UIKit.h>
#import "RBManagedObject.h"

@interface RBPickerButton : UIButton

- (void) setChecked:(BOOL)checked objectType:(NSString *)objectType;
- (void) setTitle:(id)selectedItem objectType:(NSString *)objectType;
- (void) setTitle:(NSDate *)selectedDate datePickerMode:(int)datePickerMode blankValue:(NSString *)blankValue;
- (void) setTitle:(RBManagedObject *)selectedItem colorMode:(BOOL)colorMode;

@end
