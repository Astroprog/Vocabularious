//
//  CSVWriter.m
//  ProjectOmega
//
//  Created by Maximilian Scheurer on 24.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "CSVWriter.h"
#import "Kategorie.h"
#import "Vokabel.h"

@implementation CSVWriter

- (NSString *)convertStringToCSV:(NSMutableArray *)anArray

{
    NSMutableArray *conversionVocArray = anArray;
    NSString* resultString = @"";
    for (int i = 0; i<[conversionVocArray count]; i++) {
        Vokabel *voc = [conversionVocArray objectAtIndex:i];
        NSString *newString = [NSString stringWithFormat:@"%@;%@\n",voc.homeString,voc.foreignString];
        resultString = [resultString stringByAppendingString:newString];
    }
    

    return resultString;
    
}

@end
