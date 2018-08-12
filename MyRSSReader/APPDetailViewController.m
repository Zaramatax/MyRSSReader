//
//  APPDetailViewController.m
//  MyRSSReader
//
//  Created by Agency33 on 10/1/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPDetailViewController.h"
#import "APPFeedEntry.h"

@interface APPDetailViewController () {
    IBOutlet UIWebView* webView;
}
- (void)configureView;
@end

@implementation APPDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    APPFeedEntry* item = (APPFeedEntry*)self.detailItem;
    self.title = item.articleTitle;
    webView.delegate = self;
    
    //retrieve article and show it
    NSURLRequest* articleRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:item.articleUrl]];
    webView.backgroundColor = [UIColor clearColor];
    [webView loadRequest: articleRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
