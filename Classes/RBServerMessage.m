//
//  ServerMessage.m
//  radbear-ios
//
//  Created by Gary Foster on 6/27/12.
//  Copyright (c) 2012 Radical Bear LLC. All rights reserved.
//

#import "RBServerMessage.h"
#import "RBManagedObject.h"
#import "RBAppTools.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

NSString *const ERROR_MESSAGE_TITLE = @"We Have a Problem";

@implementation RBServerMessage

@synthesize content, title;

+ (void)msgWithError:(NSError *)error {
    RBServerMessage *message = [[RBServerMessage alloc] init];
    message.title = ERROR_MESSAGE_TITLE;
    message.content = [error localizedDescription];
    [message showMessage];
}

+ (void)msgWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error {
    if ([operation isKindOfClass:[AFJSONRequestOperation class]]) {
        id JSON = [(AFJSONRequestOperation *)operation responseJSON];
        [RBServerMessage msgwithJSON:JSON success:FALSE];
    } else if ([operation isKindOfClass:[AFHTTPRequestOperation class]]) {
        if (operation.responseData) {
            NSError *parseError = nil;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:&parseError];
            if (parseError)
                [RBServerMessage msgWithError:parseError];
            else
                [RBServerMessage msgwithJSON:JSON success:FALSE];
        } else {
            [RBServerMessage msgWithError:error];
        }
    } else {
        [RBServerMessage msgWithError:error];
    }
}

+ (void)msgWithOperation:(AFHTTPRequestOperation *)operation {
    if ([operation isKindOfClass:[AFJSONRequestOperation class]]) {
        id JSON = [(AFJSONRequestOperation *)operation responseJSON];
        [RBServerMessage msgwithJSON:JSON success:TRUE];
    } else if ([operation isKindOfClass:[AFHTTPRequestOperation class]]) {
        NSError *parseError = nil;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingAllowFragments error:&parseError];
        if (parseError)
            [RBServerMessage msgWithError:parseError];
        else
            [RBServerMessage msgwithJSON:JSON success:TRUE];
    } else {
        [RBServerMessage msgWithString:@"Unknown Error from Server"];
    }
}

+ (void)msgwithJSON:(id)JSON success:(BOOL)success {
    RBServerMessage *message = [[RBServerMessage alloc] init];
    
    if([JSON objectForKey:@"errors"]) {
        id items = [JSON objectForKey:@"errors"];
        NSMutableString *messages = [[NSMutableString alloc] init];
        for (NSString *key in items) {
            id item = [items objectForKey:key];
            [messages appendString:[[key stringByReplacingOccurrencesOfString:@"_" withString:@" "]  capitalizedString]];
            [messages appendString:@" "];
            [messages appendString:[item objectAtIndex:0]];
            [messages appendString:@"\n"];
        }
        message.title = ERROR_MESSAGE_TITLE;
        message.content = messages;
    } else if([JSON objectForKey:@"message"]) {
        if (success)
            message.title = @"Success";
        else
            message.title = ERROR_MESSAGE_TITLE;
        
        message.content = [JSON objectForKey:@"message"];
    } else {
        //parse this better as the need arises
        message.title = ERROR_MESSAGE_TITLE;
        //todo message.content = [response bodyAsString];
        message.content = @"Unknown Error from Server";
    }
    
    [message showMessage];
}

+ (void)msgWithString:(NSString *)string {
    RBServerMessage *message = [[RBServerMessage alloc] init];
    message.title = ERROR_MESSAGE_TITLE;
    message.content = string;
    [message showMessage];
}

+ (void)msgWithStringAndError:(NSString *)string error:(NSError *)error {
    RBServerMessage *message = [[RBServerMessage alloc] init];
    message.title = ERROR_MESSAGE_TITLE;
    message.content = [[string stringByAppendingString:@" "] stringByAppendingString:[error localizedDescription]];
    [message showMessage];
}

+ (void)msgWithObject:(id)object title:(NSString *)title {
    RBServerMessage *message = [[RBServerMessage alloc] init];
    
    if([object respondsToSelector:NSSelectorFromString(@"message")] && [object valueForKey:@"message"] != nil) {
        message.title = title;
        message.content = [object valueForKey:@"message"];
    } else {
        message.title = @"Success";
        message.content = title;
    }
    
    [message showMessage];
}

- (void)showMessage {
    if ([content rangeOfString:@"facebook authentication is invalid"].location != NSNotFound) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
    }
    
    [RBAppTools msgBox:content withTitle:title];
}

@end
