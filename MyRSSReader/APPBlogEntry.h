//
//  APPBlogEntry.h
//  MyRSSReader
//
//  Created by Agency33 on 10/2/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPBlogEntry : NSObject {
    NSString *_blogTitle;
    NSURL    *_blogURL;
    NSMutableArray  *_articles;
}

@property (copy) NSString *blogTitle;
@property (copy) NSURL    *blogURL;
@property (copy) NSMutableArray  *articles;

- (id)initWithBlogURL:(NSURL*)blogURL tableViewController:(UITableViewController*)tableViewController UITableVC:(UITableViewController*)UITableVC;

@end
