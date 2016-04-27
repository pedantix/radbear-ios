//
//  PickerView.h
//  radbear-ios
//
//  Created by Gary Foster on 9/30/09.
//  Copyright 2010 Radical Bear, LLC. All rights reserved.
//

#import "RBPickerViewable.h"

@interface RBPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource> {
	
@public
    NSArray *objects;
    NSUInteger selectedIndex;
    IBOutlet UILabel *lblPrompt;

@private
    IBOutlet UIPickerView *optionsView;
    IBOutlet UITextField *selectionValue;
    IBOutlet UILabel *lblMins;
    IBOutlet UILabel *lblSecs;
}

@property(nonatomic, retain) NSArray *objects;
@property(nonatomic) NSUInteger selectedIndex;
@property(nonatomic, readonly, retain) IBOutlet UIPickerView *optionsView;
@property(nonatomic, readonly, retain) IBOutlet UITextField *selectionValue;

- (void) initialSelection;
- (void) setPrompt:(NSString *)prompt;
- (RBManagedObject *) currentSelection;

@end
