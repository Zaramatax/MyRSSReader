//
//  APPFeedEntry.h
//  MyRSSReader
//
//  Created by Agency33 on 10/1/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTMNSString+HTML.h"

@interface APPFeedEntry : NSObject {
    NSString *_blogTitle;
    NSString *_articleTitle;
    NSString *_articleUrl;
    NSString *_articleText;
    NSString *_publishDate; //publish date needed for caching and not displayed
    NSAttributedString* _articlePreview;
}

@property (copy) NSString *blogTitle;
@property (copy) NSString *articleTitle;
@property (copy) NSString *articleUrl;
@property (copy) NSString *publishDate;
@property (strong, nonatomic) NSString* articleText;
@property (strong, nonatomic) NSAttributedString* articlePreview;

@end
