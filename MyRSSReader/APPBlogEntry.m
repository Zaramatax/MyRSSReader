//
//  APPBlogEntry.m
//  MyRSSReader
//
//  Created by Agency33 on 10/2/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPBlogEntry.h"
#import "APPLoader.h"
#import "APPMasterViewController.h"

@implementation APPBlogEntry

@synthesize blogTitle = _blogTitle;
@synthesize blogURL = _blogURL;
@synthesize articles = _articles;

- (id)initWithBlogURL:(NSURL*)blogURL tableViewController:(APPMasterViewController*)tableViewController UITableVC:(UITableViewController*)UITableVC
{
    _blogURL = blogURL;
    
    //when RSS is fetched create blog title and articles and refresh views
    APPLoader *rss = [[APPLoader alloc] init];
    [rss fetchRssWithURL:blogURL
                complete:^(NSString *title, NSMutableArray *results) {
                    //completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _articles = results;
                        _blogTitle = title;
                        
                        if (tableViewController) {
                            [tableViewController cacheFeed]; //add blog to cache
                        }
                        [tableViewController.tableView reloadData];
                        
                        if (UITableVC != nil) {
                            [UITableVC.tableView reloadData];
                        }
                    });
                }];
    
    return self;
}

@end
