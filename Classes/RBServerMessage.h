//
//  ServerMessage.h
//  radbear-ios
//
//  Created by Gary Foster on 6/27/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RBServerMessage : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;

+ (void)msgWithError:(NSError *)error;
+ (void)msgwithJSON:(id)JSON success:(BOOL)success;
+ (void)msgWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error;
+ (void)msgWithOperation:(AFHTTPRequestOperation *)operation;
+ (void)msgWithString:(NSString *)string;
+ (void)msgWithStringAndError:(NSString *)string error:(NSError *)error;
+ (void)msgWithObject:(id)object title:(NSString *)title;

@end
