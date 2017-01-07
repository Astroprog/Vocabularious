//
//  VocExchanger.h
//  Vocabularious
//
//  Created by Maximilian Scheurer on 18.05.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vokabel;

@interface VocExchanger : NSObject
{

}
- (void)exchangeVocWithOldVoc:(Vokabel *)oldVoc andNewVoc:(Vokabel *)newVoc;

@property (readwrite) BOOL selectedCollection;
@end
