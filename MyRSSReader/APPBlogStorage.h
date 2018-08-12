//
//  APPBlogStorage.h
//  MyRSSReader
//
//  Created by Agency33 on 10/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APPBlogEntry.h"

@interface APPBlogStorage : NSObject

- (NSMutableArray*)loadBlogs;
- (void)saveBlogs:(NSMutableArray*)blogs;

@end
