//
//  APPCacheFeed.h
//  MyRSSReader
//
//  Created by Agency33 on 10/7/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPBlogEntry.h"
#import "APPFeedEntry.h"

@interface APPCacheFeed : NSObject
- (void) cacheFeed:(NSArray*)blogs;
- (NSMutableArray*)getFeedFromCache;
- (void)clearCache;
@end
