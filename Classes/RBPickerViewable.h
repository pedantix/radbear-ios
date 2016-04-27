//
//  PickerViewable.h
//  radbear-ios
//
//  Created by Gary Foster on 9/30/09.
//  Copyright 2010 Radical Bear, LLC. All rights reserved.
//

#import "RBManagedObject.h"

@protocol RBPickerViewable

@required

- (void) selectedValue:(RBManagedObject *)value;

@end
