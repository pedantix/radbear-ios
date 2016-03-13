//
//  SimpleCell.m
//  radbear-ios
//
//  Created by Gary Foster on 6/26/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBSimpleCell.h"
#import "UIImageView+WebCache.h"
#import "RBAppTools.h"

@implementation RBSimpleCell

- (void)changeCellStyle:(int)row cellText:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 highlight:(BOOL)highlight tableWidth:(int)tableWidth {
    [self changeCellStyle:row cellText:cellText sub1:sub1 sub2:sub1 sub3:nil highlight:highlight color:nil tableWidth:tableWidth addIndicator:FALSE];
}

- (void)changeCellStyle:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 sub3:(NSString *)sub3 highlight:(BOOL)highlight tableWidth:(int)tableWidth addIndicator:(BOOL)addIndicator {
    [self changeCellStyle:cellText sub1:sub1 sub2:sub2 sub3:sub3 highlight:highlight color:[UIColor clearColor] tableWidth:tableWidth addIndicator:addIndicator];
}

- (void)changeCellStyle:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 sub3:(NSString *)sub3 highlight:(BOOL)highlight color:(UIColor *)color tableWidth:(int)tableWidth addIndicator:(BOOL)addIndicator {
    [self changeCellStyle:-1 cellText:cellText sub1:sub1 sub2:sub2 sub3:sub3 highlight:highlight color:color tableWidth:tableWidth addIndicator:addIndicator];
}

- (void)changeCellStyle:(int)row cellText:(NSString *)cellText sub1:(NSString *)sub1 sub2:(NSString *)sub2 sub3:(NSString *)sub3 highlight:(BOOL)highlight color:(UIColor *)color tableWidth:(int)tableWidth addIndicator:(BOOL)addIndicator {
    if (color) {
        UITableViewCell *bgView = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = color;
        self.backgroundView=bgView;
        self.backgroundColor = color;
    } else {
        UIColor *evenColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"row-background-1-opaque.png"]];
        UIColor *oddColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"row-background-2-opaque.png"]];
        
        UITableViewCell *bgView = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor=row % 2? evenColor: oddColor;
        self.backgroundView=bgView;
    }
    
    int lblX = 17;
    int lblY = sub3 ? 5 : 11;
    int lblW = tableWidth - 70;
    int lblH = 21;
    int imageW = 60;
    int subW = [RBAppTools isIpad] ? 120 : 60;
    int rightMargin = 23;
    
    if ([RBAppTools isIpad]) {
        rightMargin = rightMargin * 2;
        subW = subW * 2;
    }
    
    int subX = tableWidth - subW - rightMargin;
    int subY = sub3 ? 5 : 0;
        
    if (self.imageView.image) {
        lblX = lblX + imageW;
        lblW = lblW - imageW;
    }
    
    if (sub1 || sub2) {
        lblW = lblW - 40;
        lblY = lblY - 6;
        lblH = lblH + 12;
    }
    
    UILabel *lbl = (UILabel *)[self viewWithTag:1];
    
    if (!lbl)
        lbl = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
    
    if (highlight)
        [lbl setTextColor:[UIColor redColor]];
    else
        [lbl setTextColor:(color == nil) ? [UIColor whiteColor] : [UIColor blackColor]];
    
    if (sub1 || sub2) {
        [lbl setNumberOfLines:2];
        [lbl setLineBreakMode:NSLineBreakByWordWrapping];
        [lbl setFont:[UIFont boldSystemFontOfSize:14]];
        [lbl setAdjustsFontSizeToFitWidth:TRUE];
    } else {
        [lbl setFont:[UIFont boldSystemFontOfSize:16]];
    }
    
    [lbl setText:cellText];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTag:1];
    [self.contentView addSubview:lbl];
    
    
    UILabel *lblSub1 = (UILabel *)[self viewWithTag:2];
    
    if (!lblSub1)
        lblSub1 = [[UILabel alloc]initWithFrame:CGRectMake(subX, subY, subW, 21)];
    
    [lblSub1 setFont:[UIFont systemFontOfSize:13]];
    [lblSub1 setTextColor:[UIColor darkGrayColor]];
    
    [lblSub1 setAdjustsFontSizeToFitWidth:FALSE];
    [lblSub1 setText:sub1];
    [lblSub1 setBackgroundColor:[UIColor clearColor]];
    [lblSub1 setTag:2];
    [lblSub1 setHidden:!sub1];
    [self.contentView addSubview:lblSub1];
    
    UILabel *lblSub2 = (UILabel *)[self viewWithTag:3];
    
    if (!lblSub2)
        lblSub2 = [[UILabel alloc]initWithFrame:CGRectMake(subX, 20, subW, 21)];
    
    [lblSub2 setFont:[UIFont systemFontOfSize:13]];
    [lblSub2 setTextColor:[UIColor darkGrayColor]];
    
    [lblSub2 setAdjustsFontSizeToFitWidth:FALSE];
    [lblSub2 setText:sub2];
    [lblSub2 setBackgroundColor:[UIColor clearColor]];
    [lblSub2 setTag:3];
    [lblSub2 setHidden:!sub2];
    [self.contentView addSubview:lblSub2];
    
   UILabel *lblSub3 = (UILabel *)[self viewWithTag:4];
    
   if (!lblSub3 )
       lblSub3 = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY + 22, tableWidth - lblX - 25, 40)];
   [lblSub3 setFont:[UIFont systemFontOfSize:12]];
   [lblSub3 setTextColor:[UIColor darkGrayColor]];
    
   [lblSub3 setAdjustsFontSizeToFitWidth:FALSE];
   [lblSub3 setText:sub3];
   [lblSub3 setBackgroundColor:[UIColor clearColor]];
   [lblSub3 setNumberOfLines:2];
   [lblSub3 setTag:4];
   [lblSub3 setHidden:!sub3];
   
   [self.contentView addSubview:lblSub3];
    
    UIView *circleView = (UIView *)[self viewWithTag:5];
    if(!circleView)
        circleView = [[UIView alloc] initWithFrame:CGRectMake(4,30,8,8)];
    [circleView setTag:5];
    circleView.layer.cornerRadius = 4;
    circleView.backgroundColor = [UIColor colorWithRed:55.0f/255.0f green:200.0f/255.0f blue:58.0f/255.0f alpha:1.0f];
    circleView.hidden = !addIndicator;

    [self.contentView addSubview:circleView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20,11,48,48);
}

@end
