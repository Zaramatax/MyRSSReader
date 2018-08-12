//
//  APPLoader.h
//  MyRSSReader
//
//  Created by Agency33 on 10/1/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RSSLoaderCompleteBlock)(NSString* title, NSMutableArray* results);

@interface APPLoader : NSObject
- (void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)c;
@end
