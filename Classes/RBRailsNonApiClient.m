//
//  AFRailsNonApiClient.m
//  radbear-ios
//
//  Created by Gary Foster on 3/8/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "RBRailsNonApiClient.h"
#import "AFJSONRequestOperation.h"
#import "RBEnvironment.h"

@implementation RBRailsNonApiClient

+ (RBRailsNonApiClient *)sharedClient {
    RBEnvironment *myEnvironment = [RBEnvironment sharedInstance];
    
    static RBRailsNonApiClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[RBRailsNonApiClient alloc] initWithBaseURL:[NSURL URLWithString:myEnvironment.baseURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}


@end
