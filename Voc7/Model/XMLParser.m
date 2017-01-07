//
//  XMLParser.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 31.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser


- (void)parseXMLfile:(NSURL *)url;
{
        newRowFound = NO;
        newCell = YES;
        outArray = [[NSMutableArray alloc] init];
        rowVoc = [[NSMutableArray alloc] init];
    	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        self.completed = [[NSMutableArray alloc] init];
        [self.completed addObject:@""];
    	[parser setDelegate: self];
        [parser parse];
}

-(void) parserDidEndDocument: (NSXMLParser *)parser {
    self.completed = outArray;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    currentBefore = current;
    if (qName) elementName = qName;
	if (elementName) current = [NSString stringWithString:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    currentEndBefore = currentEnd;
	if (qName) elementName = qName;
    if (elementName) currentEnd = [NSString stringWithString:elementName];
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    BOOL space = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];  
    
    if (!current) return;
	if ([current isEqualToString:@"Row"])
    {
        newRowFound = YES;
    }
    else if ([currentEnd isEqualToString:@"Row"] && [currentEndBefore isEqualToString:@"Cell"]) {
        newRowFound = NO;
        NSMutableArray *anArray = [[NSMutableArray alloc] init];
        NSString *first = [rowVoc objectAtIndex:0];
        NSString *second = [rowVoc objectAtIndex:1];
        [anArray addObject:first];
        [anArray addObject:second];
        [outArray addObject:anArray];
        [rowVoc removeAllObjects];
        currentBefore = @"";
        currentEndBefore = @"";
        currentEnd = @"";
        current = @"";
    }
    
    else if ([current isEqualToString:@"Data"] && [currentBefore isEqualToString:@"Cell"] && newRowFound == YES && ![string isEqualToString:@""] && [string rangeOfString:@"\n"].location == NSNotFound && [string rangeOfString:@"\""].location == NSNotFound && space)
    {
        if (newCell) {
            safetyString = string;
            [rowVoc addObject:string];
            currentEnd = @"";
            newCell = NO;
        }
        else if (!newCell)
        {
            safetyString = [safetyString stringByAppendingString:string];
            [rowVoc replaceObjectAtIndex:[rowVoc count]-1 withObject:safetyString];
            safetyString = @"";
        }
    }
    
    else if ([currentEnd isEqualToString:@"Cell"])
    {
        newCell = YES;
    }
    
    
    
}

@end
