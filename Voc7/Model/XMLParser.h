//
//  XMLParser.h
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 31.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>
{
    NSString *current;
    NSString *currentBefore;
    NSString *currentEnd;
    NSString *currentEndBefore;
    NSMutableArray *outArray;
    NSString *cellContent;
    NSString *safetyString;
    BOOL newRowFound;
    NSMutableArray *rowVoc;
    BOOL newCell;
}

- (void)parseXMLfile:(NSURL *)url;

@property (strong) NSMutableArray* completed;
@end
