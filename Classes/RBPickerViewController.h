//
//  PickerViewController.h
//  radbear-ios
//
//  Created by Gary Foster on 9/29/10.
//  Copyright 2010 Radical Bear, LLC. All rights reserved.
//

#import "RBPickerViewable.h"
#import "RBPickerView.h"

@interface RBPickerViewController : UIViewController {
	NSObject *initialSelection;
    NSString *prompt;
	NSArray *objects;
    id<RBPickerViewable> __unsafe_unretained callback;
}

@property (unsafe_unretained) id<RBPickerViewable> callback;
@property (nonatomic, retain) NSObject *initialSelection;
@property (nonatomic, retain) NSString *prompt;
@property (nonatomic, retain) NSArray *objects;

- (void) cancelAction;
- (void) doneAction;

@end
