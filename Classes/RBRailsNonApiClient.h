//
//  AFRailsNonApiClient.h
//  radbear-ios
//
//  Created by Gary Foster on 3/8/13.
//  Copyright (c) 2013 Radical Bear LLC. All rights reserved.
//

#import "AFHTTPClient.h"

@interface RBRailsNonApiClient : AFHTTPClient

+ (RBRailsNonApiClient *)sharedClient;

@end
