//
//  RBFileResponse.m
//  radbear-ios
//
//  Created by Gary Foster on 2/8/14.
//  Copyright (c) 2014 Automotive Broadcasting Network. All rights reserved.
//

#import "RBFileResponse.h"

@implementation RBFileResponse

- (NSDictionary *)httpHeaders {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"Content-Type", nil];
}

@end
