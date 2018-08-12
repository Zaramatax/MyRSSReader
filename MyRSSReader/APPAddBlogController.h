//
//  APPAddBlogController.h
//  MyRSSReader
//
//  Created by Agency33 on 10/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPAddBlogController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (strong, nonatomic) IBOutlet UIView *addBlog;
@property (nonatomic, strong) NSString *blogURL;

@end
