//
//  APPMasterViewController.h
//  MyRSSReader
//
//  Created by Agency33 on 10/1/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPMasterViewController.h"

#import "APPDetailViewController.h"

#import "APPFeedEntry.h"
#import "APPLoader.h"
#import "APPBlogEntry.h"
#import "APPBlogViewController.h"
#import "APPBlogStorage.h"
#import "Reachability.h"

@interface APPMasterViewController () {
    NSMutableArray *_objects;
    __weak IBOutlet UIButton *editButton;
}
@end

@implementation APPMasterViewController

@synthesize blogEntries = _blogEntries;

-(void)refreshFeed
{
    APPBlogStorage * storage = [APPBlogStorage alloc];
    
    NSArray * feeds;
    feeds = [storage loadBlogs]; //load blogs from storage
    if ([feeds count] == 0) { //and if there no blogs stored, add default blog
        feeds = [NSArray arrayWithObjects: [NSURL URLWithString:@"http://news.yandex.ru/computers.rss"],
                  [NSURL URLWithString:@"http://news.yandex.ru/hardware.rss"], nil];
    }
    
    for (NSURL *feed in feeds) { //load blogs and add them to list
        
        APPBlogEntry *blogEntry = [[APPBlogEntry alloc] initWithBlogURL:feed
                                                    tableViewController:self UITableVC:nil];
        [_blogEntries insertObject:blogEntry atIndex:0];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cacheCounter = 0;
    
    self.blogEntries = [NSMutableArray array];
    
    _cache = [APPCacheFeed alloc];
    
    //Check for internet connection
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable) { //retrieve feed from internet server and cache it local
        [_cache clearCache];
        [self refreshFeed];
    }
    else { //show alert and retrieve feed from cache
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                        message:@"No internet connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        _blogEntries = [_cache getFeedFromCache];
        
        [self.tableView reloadData];
    }
}

-(void)cacheFeed
{
    ++_cacheCounter;
    
    if (_cacheCounter == _blogEntries.count) { //when all blog entries are downloaded and parsed, save them
        [_cache cacheFeed:_blogEntries];
        _cacheCounter = 0;
    }
}

-(void)refreshView
{
    [self.tableView reloadData];
    [self cacheFeed];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { //sections count is number of blogs
    return _blogEntries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { //rows number is feed cound in each blog
    APPBlogEntry *blogEntry = [_blogEntries objectAtIndex:section];
    return  MIN(blogEntry.articles.count, 10);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section //format our cell view to get title and short description
{
    //making a view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    
    APPBlogEntry *blogEntry = [_blogEntries objectAtIndex:section];
    NSString *string = blogEntry.blogTitle;
    
    //set our feed entry for created view
    [label setText:string];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { //get cell view
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    APPBlogEntry *blogEntry = [_blogEntries objectAtIndex:indexPath.section];
    APPFeedEntry *feedEntry = [blogEntry.articles objectAtIndex:indexPath.row];
    
    cell.textLabel.attributedText = feedEntry.articlePreview;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath //change height of a cell to fit deisirable appearance
{
    APPBlogEntry *blogEntry = [_blogEntries objectAtIndex:indexPath.section];
    APPFeedEntry *feedEntry = [blogEntry.articles objectAtIndex:indexPath.row];
    
    CGRect cellMessageRect = [feedEntry.articlePreview boundingRectWithSize:CGSizeMake(200,10000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    return cellMessageRect.size.height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) { //user tapped on cell to open article
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        APPBlogEntry *blogEntry = [_blogEntries objectAtIndex:indexPath.section];
        APPFeedEntry *feedEntry = [blogEntry.articles objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setDetailItem:feedEntry]; //pass article information to detail view
    }
    
    if ([[segue identifier] isEqualToString:@"editBlogs"]) { //user tapped on edit button
        
        [[segue destinationViewController] setDetailItem:self]; 
    }
}

@end
