//
//  APPFeedEntry.m
//  MyRSSReader
//
//  Created by Agency33 on 10/1/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPFeedEntry.h"

@implementation APPFeedEntry

@synthesize blogTitle = _blogTitle;
@synthesize articleTitle = _articleTitle;
@synthesize articleUrl = _articleUrl;

-(NSAttributedString*)articlePreview //create article preview with desired appearance
{
    if (_articlePreview == nil) {
        NSDictionary* boldStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:16.0]}; //for title
        NSDictionary* normalStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16.0]}; //for description
        
        NSMutableAttributedString* articleAbstract = [[NSMutableAttributedString alloc] initWithString:self.articleTitle];
        
        //applying attributes
        [articleAbstract setAttributes:boldStyle
                                 range:NSMakeRange(0, self.articleTitle.length)];
        
        [articleAbstract appendAttributedString:
         [[NSAttributedString alloc] initWithString:@"\n\n"]
         ];
        
        int startIndex = [articleAbstract length];
        
        NSString* description = [NSString stringWithFormat:@"%@...", [self.articleText substringToIndex:100]]; //we need only 100 characters from the description to be visible
        description = [description gtm_stringByUnescapingFromHTML];
        
        [articleAbstract appendAttributedString:
         [[NSAttributedString alloc] initWithString: description]
         ];
        
        [articleAbstract setAttributes:normalStyle
                                 range:NSMakeRange(startIndex, articleAbstract.length - startIndex)];
        
        _articlePreview = articleAbstract;
        
    }
    
    return _articlePreview;
}

@end
