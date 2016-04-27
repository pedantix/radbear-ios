//
//  PickerButton.m
//  radbear-ios
//
//  Created by Gary Foster on 7/13/12.
//

#import "RBPickerButton.h"
#import "RBAppTools.h"

@implementation RBPickerButton

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:15]];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setChecked:FALSE];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    }
    
    return self;
}

- (void) setChecked:(BOOL)checked objectType:(NSString *)objectType {
    NSString *title;
    if (checked) {
        title = objectType;
    } else {
        title = [@"Choose " stringByAppendingString:objectType];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setChecked:checked];
}

- (void) setTitle:(RBManagedObject *)selectedItem colorMode:(BOOL)colorMode {
    NSString *title;
    BOOL checked;
    if (selectedItem) {
        title = @"Color";
        checked = TRUE;
    } else {
        title = @"Choose Color";
        checked = FALSE;
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    [self setChecked:checked];
}

- (void) setTitle:(id)selectedItem objectType:(NSString *)objectType {
    NSString *title;
    BOOL checked;
    if (selectedItem) {
        title = [selectedItem isKindOfClass:[RBManagedObject class]] ? [selectedItem getDisplayName] : selectedItem;
        checked = TRUE;
    } else {
        title = [@"Choose " stringByAppendingString:objectType];
        checked = FALSE;
    }
    
    NSString *label;
    
    if (title.length > 23)
        label = [[title substringToIndex:23] stringByAppendingString:@"..."];
    else
        label = title;
    
    [self setTitle:label forState:UIControlStateNormal];
    [self setChecked:checked];
}

- (void)setTitle:(NSDate *)selectedDate datePickerMode:(int)datePickerMode blankValue:(NSString *)blankValue {
    NSString *title;
    BOOL checked;
    if (selectedDate) {
        if (datePickerMode == UIDatePickerModeDateAndTime)
            title = [[[RBAppTools displayTime:selectedDate] stringByAppendingString:@" on "] stringByAppendingString:[RBAppTools displayDate:selectedDate]];
        else if (datePickerMode == UIDatePickerModeDate)
            title = [RBAppTools displayDate:selectedDate];
        else if (datePickerMode == UIDatePickerModeTime)
            title = [RBAppTools displayTime:selectedDate];
        else
            title = @"rb implement countdown";
        
        checked = TRUE;
    } else {
        title = blankValue;
        checked = FALSE;
    }
    
    NSString *label;
    
    if (title.length > 23)
        label = [[title substringToIndex:23] stringByAppendingString:@"..."];
    else
        label = title;
    
    [self setTitle:label forState:UIControlStateNormal];
    [self setChecked:checked];
}

- (void) setChecked:(bool)checked {
    NSString *half = self.frame.size.width == 138?  @"picker-half-" : @"picker-";
    NSString *imageOn;
    NSString *imageOff;
    
    if (checked) {
        imageOn = [half stringByAppendingString:@"enabled-and-checked.png"];
        imageOff = [half stringByAppendingString:@"disabled-and-checked.png"];
    } else {
        imageOn = [half stringByAppendingString:@"enabled-and-unchecked.png"];
        imageOff = [half stringByAppendingString:@"disabled-and-unchecked.png"];
    }
    
    [self setBackgroundImage:[UIImage imageNamed:imageOn] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:imageOff] forState:UIControlStateDisabled];
}

@end
