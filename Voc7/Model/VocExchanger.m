//
//  VocExchanger.m
//  Vocabularious
//
//  Created by Maximilian Scheurer on 18.05.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "VocExchanger.h"
#import "Vokabel.h"
#import "Sammlung.h"
#import "Kategorie.h"

NSMutableArray *kategorieArray;
NSMutableArray *collectionArray;

@implementation VocExchanger

- (id)init {
    self = [super init];
    if (self) {
        _selectedCollection = NO;
    }
    return self;
}

- (void)exchangeVocWithOldVoc:(Vokabel *)oldVoc andNewVoc:(Vokabel *)newVoc
{
    if (!_selectedCollection) {
        for (Sammlung *collection in collectionArray)
        {
            for (int i = 0; i < [collection.vocArray count]; i++)
            {
                Vokabel *voc = [collection.vocArray objectAtIndex:i];
                
                if ([oldVoc.homeString isEqualToString:voc.homeString] && [oldVoc.foreignString isEqualToString:voc.foreignString] && [oldVoc.homeLanguage isEqualToString:voc.homeLanguage] && oldVoc.rightCount == voc.rightCount && oldVoc.falseGesamt == voc.falseGesamt && oldVoc.rightGesamt == voc.rightGesamt && [oldVoc.reminder isEqualToString:voc.reminder])
                {
                    [[collection vocArray] replaceObjectAtIndex:i withObject:newVoc];
                }
            }
        }
    }
    else if (_selectedCollection) {
        for (Kategorie *kategorie in kategorieArray)
        {
            for (int i = 0; i < [kategorie.vocArray count]; i++)
            {
                Vokabel *voc = [kategorie.vocArray objectAtIndex:i];
                
                if ([oldVoc.homeString isEqualToString:voc.homeString] && [oldVoc.foreignString isEqualToString:voc.foreignString] && [oldVoc.homeLanguage isEqualToString:voc.homeLanguage] && oldVoc.rightCount == voc.rightCount && oldVoc.falseGesamt == voc.falseGesamt && oldVoc.rightGesamt == voc.rightGesamt && [oldVoc.reminder isEqualToString:voc.reminder])
                {
                    [[kategorie vocArray] replaceObjectAtIndex:i withObject:newVoc];
                }
            }
        }
        
    }
    oldVoc = nil;
    newVoc = nil;
}


@end
