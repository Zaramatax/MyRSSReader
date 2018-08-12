//
//  APPMasterViewController.h
//  MyRSSReader
//
//  Created by Agency33 on 10/1/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPCacheFeed.h"

@interface APPMasterViewController : UITableViewController <NSXMLParserDelegate>{
    NSMutableArray *_blogEntries; //Blogs for RSS feed
}

@property (retain) NSMutableArray *blogEntries;
@property NSInteger cacheCounter;
@property APPCacheFeed *cache;

-(void)refreshFeed;
-(void)cacheFeed;
-(void)refreshView;

@end
