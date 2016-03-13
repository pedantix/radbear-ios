//
//  SimpleCell.h
//  radbear-ios
//
//  Created by Gary Foster on 6/26/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBSimpleCell : UITableViewCell

- (void)changeCellStyle:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 sub3:(NSString *)sub3 highlight:(BOOL)highlight tableWidth:(int)tableWidth addIndicator:(BOOL)addIndicator;

- (void)changeCellStyle:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 sub3:(NSString *)sub3 highlight:(BOOL)highlight color:(UIColor *)color tableWidth:(int)tableWidth addIndicator:(BOOL)addIndicator;

- (void)changeCellStyle:(int)row cellText:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 sub3:(NSString *)sub3 highlight:(BOOL)highlight color:(UIColor *)color tableWidth:(int)tableWidth addIndicator:(BOOL)addIndicator;

- (void)changeCellStyle:(int)row cellText:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 highlight:(BOOL)highlight tableWidth:(int)tableWidth;

@end
