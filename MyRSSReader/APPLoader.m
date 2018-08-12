//
//  APPLoader.m
//  MyRSSReader
//
//  Created by Agency33 on 10/1/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPLoader.h"

#import "APPFeedEntry.h"
#import "GDataXMLNode.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation APPLoader

-(void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)c
{
    dispatch_async(kBgQueue, ^{
        
        //work in the background
        
        NSData *xmlData = [[NSMutableData alloc] initWithContentsOfURL:url];
        NSError *error;
        
        //create XML document
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                               options:0 error:&error];
        if (doc == nil) {
            return;
        }
        
        //get blog title an list of articles
        GDataXMLElement *channel = [[doc.rootElement elementsForName:@"channel"] objectAtIndex:0];
        GDataXMLElement *channelTitle = [[channel elementsForName:@"title"] objectAtIndex:0];
        NSString * title = channelTitle.stringValue;
        NSArray * items = [channel elementsForName:@"item"];
        
        NSMutableArray* result = [NSMutableArray arrayWithCapacity:items.count];
        
        for (GDataXMLElement *e in items) { //iterate over the articles
            //get article details
            
            APPFeedEntry* entry = [[APPFeedEntry alloc] init];
            
            GDataXMLElement * articleTitleElement = [[e elementsForName:@"title"] objectAtIndex:0];
            entry.articleTitle = articleTitleElement.stringValue;
            
            GDataXMLElement * articleTextElement = [[e elementsForName:@"description"] objectAtIndex:0];
            entry.articleText = articleTextElement.stringValue;
            
            GDataXMLElement * articleURLElement = [[e elementsForName:@"link"] objectAtIndex:0];
            entry.articleUrl = articleURLElement.stringValue;
            
            GDataXMLElement * publishDateElement = [[e elementsForName:@"pubDate"] objectAtIndex:0]; //publish date needed for caching and not displayed
            entry.publishDate = publishDateElement.stringValue;
    
            [result addObject: entry];
        }
        
        c(title, result);
    });
    
}
@end
