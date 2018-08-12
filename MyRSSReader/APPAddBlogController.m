//
//  APPAddBlogController.m
//  MyRSSReader
//
//  Created by Agency33 on 10/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPAddBlogController.h"

@interface APPAddBlogController ()

@end

@implementation APPAddBlogController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"doneSegue"]) //Done button pressed
    {
        self.blogURL = self.addTextField.text;
    }
}


@end
