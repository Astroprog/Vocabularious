//
//  Vokabel.h
//  Vocabulary
//
//  Created by Peter Rodenkirch on 07.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vokabel : NSObject <NSCoding, NSCopying>
{
   
}

- (id)initWithGermanString:(NSString *)firstString andForeignString:(NSString *)secondString;

@property (strong) NSString *homeString;
@property (strong) NSString *foreignString;
@property (strong) NSString *foreignLanguage;
@property (strong) NSString *homeLanguage;
@property (strong) NSString *reminder;
@property (strong) UIImage *image;
@property (readwrite) int addDate;
@property (readwrite) int rightCount;
@property (readwrite) int rightGesamt;
@property (readwrite) int falseGesamt;
@end
