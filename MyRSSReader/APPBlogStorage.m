//
//  APPBlogStorage.m
//  MyRSSReader
//
//  Created by Agency33 on 10/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "APPBlogStorage.h"
#import "GDataXMLNode.h"

@implementation APPBlogStorage //storage for blog entries

- (NSString *)dataFilePath:(BOOL)forSave {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"blogs_storage.xml"];
    if (forSave ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:@"blogs_storage" ofType:@"xml"];
    }
    
}

- (NSMutableArray*)loadBlogs { //get blogs from XML document
    NSString *xmlPath = [self dataFilePath:FALSE];
    
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:xmlPath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    if (doc == nil) {
        return nil;
    }
    
    NSArray *channels = [doc.rootElement elementsForName:@"link"];
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:channels.count];
    
    for (GDataXMLElement *channel in channels) {
        NSURL *link = [NSURL URLWithString: channel.stringValue];
        
        [result addObject: link];
    }
    
    return result;
}

- (void)saveBlogs:(NSMutableArray*)blogs { //save blogs to XML document
    NSString *xmlPath = [self dataFilePath:TRUE];
    
    GDataXMLElement * root = [GDataXMLNode elementWithName:@"channels"];
    
    for (APPBlogEntry* blog in blogs) {
        GDataXMLElement * linkElement =
        [GDataXMLNode elementWithName:@"link" stringValue:[blog.blogURL absoluteString]];
        
        [root addChild:linkElement];
    }
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                   initWithRootElement:root];
    NSData *xmlData = document.XMLData;
    [xmlData writeToFile:xmlPath atomically:YES];
}

@end
