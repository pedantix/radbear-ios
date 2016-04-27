//
//  PickerView.m
//  radbear-ios
//
//  Created by Gary Foster on 9/30/09.
//  Copyright 2010 Radical Bear, LLC. All rights reserved.
//

#import "RBPickerView.h"
#import "RBAppTools.h"

@implementation RBPickerView

@synthesize objects, selectedIndex, optionsView, selectionValue;

- (RBManagedObject *) currentSelection {
    if([objects count] > 0)
        return [objects objectAtIndex:[optionsView selectedRowInComponent:0]];
    else
        return nil;
}

- (void) initialSelection {
    if( objects ) {
        if( selectionValue )
            selectionValue.text = [[objects objectAtIndex:selectedIndex] getDisplayName];
        
        if( optionsView)
            [optionsView selectRow:selectedIndex inComponent:0 animated:YES];

    }
}

- (void) setPrompt:(NSString *)prompt {
    CGRect frame = lblPrompt.frame;
    lblPrompt.frame = CGRectMake(frame.origin.x, frame.origin.y, [RBAppTools screenWidth] - 40,  frame.size.height);
    [lblPrompt setText:prompt];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return [RBAppTools screenWidth] - 20;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [objects count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if( !objects || objects.count == 0 )
        selectionValue.text = @"";
	else {
        id object = [objects objectAtIndex:row];
        if ([object isKindOfClass:[RBManagedObject class]])
            selectionValue.text  = [object getDisplayName];
        else
            selectionValue.text = object;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    CGRect rectView = CGRectMake(0, 0, 300, 44);
    UIView *viewRow = [[UIView alloc] initWithFrame:rectView];
    
    NSString *rowTitle;
    id object;
    
    if( !objects || objects.count == 0)
        rowTitle = @"";
    else {
        object = [objects objectAtIndex:row];
        if ([object isKindOfClass:[RBManagedObject class]])
            rowTitle = [object getDisplayName];
        else
            rowTitle = object;
    }
    
    if (object) {
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 240, 44)];
        [lblTitle setText:rowTitle];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:17]];
        [lblTitle setTextAlignment:NSTextAlignmentLeft];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [lblTitle setTextColor:[UIColor blackColor]];
        [lblTitle setClipsToBounds:YES];
        [viewRow addSubview:lblTitle];
    }

    return viewRow;
}

@end
