//
//  APPCacheFeed.m
//  MyRSSReader
//
//  Created by Agency33 on 10/7/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPCacheFeed.h"
#import "GDataXMLNode.h"

@implementation APPCacheFeed

- (NSString *)dataFilePath:(BOOL)forSave {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"cache.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"xml"];
    }
    
}

- (void)clearCache
{
    NSString *xmlPath = [self dataFilePath:FALSE];
    [[NSFileManager defaultManager] createFileAtPath:xmlPath contents:[NSData data] attributes:nil];
}

- (void) cacheFeed:(NSArray*)blogs
{
    [self clearCache];
    
    NSString *xmlPath = [self dataFilePath:TRUE];
    
    //create XML document and save feed
    GDataXMLElement * root = [GDataXMLNode elementWithName:@"blogs"];
    
    for (APPBlogEntry* blog in blogs) {
        //cache blog tag and title
    
        GDataXMLElement * blogElement =
        [GDataXMLNode elementWithName:@"blog"];
        
        GDataXMLElement * blogTitleElement =
        [GDataXMLNode elementWithName:@"title" stringValue:blog.blogTitle];
        [blogElement addChild:blogTitleElement];
        
        for (APPFeedEntry *feedEntry in blog.articles) {
            //cache articles
            
            if (blogElement.childCount > 10) { //we neen only 10 elements to be shown
                break;
            }
            
            //cache news newer than 24 hours ago
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
            NSDate *publishDate = [dateFormatter dateFromString:feedEntry.publishDate];
            
            NSTimeInterval secondsPerDay = 24 * 60 * 60;
            NSDate *yesterday = [[NSDate alloc]
                                 initWithTimeIntervalSinceNow:-secondsPerDay];
            
            if ([publishDate compare:yesterday] == NSOrderedAscending) {
                continue;
            }
            
            GDataXMLElement * articleElement =
            [GDataXMLNode elementWithName:@"article"];
            
            GDataXMLElement * titleElement =
            [GDataXMLNode elementWithName:@"title" stringValue:feedEntry.articleTitle];
            [articleElement addChild:titleElement];
            
            GDataXMLElement * textElement =
            [GDataXMLNode elementWithName:@"text" stringValue:feedEntry.articleText];
            [articleElement addChild:textElement];
            
            [blogElement addChild:articleElement];
        }
        
        [root addChild:blogElement];
    }
    
    //save XML document
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                  initWithRootElement:root];
    NSData *xmlData = document.XMLData;
    [xmlData writeToFile:xmlPath atomically:YES];
}

- (NSMutableArray*)getFeedFromCache //get atricles from cache
{
    NSString *xmlPath = [self dataFilePath:FALSE];
    
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:xmlPath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    
    //get blogs
    NSArray *blogs = [doc.rootElement elementsForName:@"blog"];
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:blogs.count];
    
    for (GDataXMLElement *blog in blogs) {
        APPBlogEntry * blogEntry = [[APPBlogEntry alloc] init];
        
        GDataXMLElement * blogTitleElement = [[blog elementsForName:@"title"] objectAtIndex:0];
        blogEntry.blogTitle = blogTitleElement.stringValue;
        
        //get articles
        NSArray * articles = [blog elementsForName:@"article"];
        
        NSMutableArray * blogArticles = [[NSMutableArray alloc] init];
        
        for (GDataXMLElement *article in articles) {
            APPFeedEntry *feedEntry = [APPFeedEntry alloc];
            
            GDataXMLElement * articleTitleElement = [[article elementsForName:@"title"] objectAtIndex:0];
            feedEntry.articleTitle = articleTitleElement.stringValue;
            
            GDataXMLElement * articleTextElement = [[article elementsForName:@"text"] objectAtIndex:0];
            feedEntry.articleText = articleTextElement.stringValue;
            
            [blogArticles addObject:feedEntry];
        }
        
        blogEntry.articles = blogArticles;
        [result addObject: blogEntry];
    }
    
    return result;
}

@end
