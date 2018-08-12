//
//  APPBlogViewController.h
//  MyRSSReader
//
//  Created by Agency33 on 10/3/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPBlogStorage.h"
#import "APPMasterViewController.h"

@interface APPBlogViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (strong, nonatomic) NSMutableArray *blogs; //blog elements
@property (strong, nonatomic) APPBlogStorage *storage; //storage for blog elements on disc
@property (strong, nonatomic) APPMasterViewController *parentVC;

@end
