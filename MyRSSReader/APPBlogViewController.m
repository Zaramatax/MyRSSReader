//
//  APPBlogViewController.m
//  MyRSSReader
//
//  Created by Agency33 on 10/3/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPBlogViewController.h"
#import "APPBlogEntry.h"
#import "APPMasterViewController.h"
#import "APPAddBlogController.h"

@interface APPBlogViewController () //view for list of blogs with options of editing

@end

@implementation APPBlogViewController

- (IBAction)done:(UIStoryboardSegue *)segue //done button pressed on Add Blog view
{
    APPAddBlogController *addBlogVC = segue.sourceViewController;
    
    NSURL *blogURL = [NSURL URLWithString:addBlogVC.blogURL];
    
    //create new blog from typed string URL and add it to feed
    APPBlogEntry *blog = [[APPBlogEntry alloc] initWithBlogURL:blogURL tableViewController:_parentVC UITableVC:self];
    [_blogs insertObject:blog atIndex:_blogs.count];
    
    [_storage saveBlogs:_blogs];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_parentVC != newDetailItem) {
        
        _parentVC = newDetailItem;
        _blogs = _parentVC.blogEntries;
    }
}

- (void)viewDidLoad
{
    _storage = [APPBlogStorage alloc];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_blogs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //add Delete button to every cell
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [deleteButton addTarget:self
                   action:@selector(deleteBlog:)
        forControlEvents:UIControlEventTouchUpInside];
        deleteButton.tag = indexPath.row;
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        deleteButton.frame = CGRectMake(250.0, 0.0, 50.0, 40.0);
        [cell addSubview:deleteButton];
    }
    
    APPBlogEntry *blogEntry = [_blogs objectAtIndex:indexPath.row];
    
    //set Blog title for cell label
    cell.textLabel.text = blogEntry.blogTitle;
    
    return cell;
}

- (void)deleteBlog:(id)sender //delete button pressed on one of the cells
{
    NSInteger index = ((UIControl *) sender).tag;
    
    //delete blog and remove it from view
    [_blogs removeObjectAtIndex:index];
    
    [self.tableView reloadData];
    [_storage saveBlogs:_blogs];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
