//
//  Vokabel.m
//  Vocabulary
//
//  Created by Peter Rodenkirch on 07.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "Vokabel.h"

@implementation Vokabel

- (id)initWithGermanString:(NSString *)firstString andForeignString:(NSString *)secondString
{
    self.homeString = firstString;
    self.foreignString = secondString;
    int currentTime = CFAbsoluteTimeGetCurrent();
    self.addDate = currentTime - currentTime % 86400;
    self.rightCount = 0;
    self.rightGesamt = 0;
    self.falseGesamt = 0;
    return self;
}

- (id)init
{
    int currentTime = CFAbsoluteTimeGetCurrent();
    self.addDate = currentTime - currentTime % 86400;
    self.rightCount = 0;
    self.rightGesamt = 0;
    self.falseGesamt = 0;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.homeString forKey:@"homeString"];
    [aCoder encodeObject:self.foreignString forKey:@"foreignString"];
    [aCoder encodeObject:self.foreignLanguage forKey:@"foreignLanguage"];
    [aCoder encodeObject:self.homeLanguage forKey:@"homeLanguage"];
    [aCoder encodeObject:self.reminder forKey:@"reminder"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeInt:self.rightCount forKey:@"rightCount"];
    [aCoder encodeInt:self.rightGesamt forKey:@"rightGesamt"];
    [aCoder encodeInt:self.falseGesamt forKey:@"falseGesamt"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.homeString = [aDecoder decodeObjectForKey:@"homeString"];
    self.foreignString = [aDecoder decodeObjectForKey:@"foreignString"];
    self.foreignLanguage = [aDecoder decodeObjectForKey:@"foreignLanguage"];
    self.homeLanguage = [aDecoder decodeObjectForKey:@"homeLanguage"];
    self.reminder = [aDecoder decodeObjectForKey:@"reminder"];
    self.image = [aDecoder decodeObjectForKey:@"image"];
    self.rightCount = [aDecoder decodeIntForKey:@"rightCount"];
    self.rightGesamt = [aDecoder decodeIntForKey:@"rightGesamt"];
    self.falseGesamt = [aDecoder decodeIntForKey:@"falseGesamt"];

    return self;    
}

- (id)copyWithZone:(NSZone *)zone
{
    Vokabel *voc = [[Vokabel alloc] init];
    voc.homeString = [self.homeString copyWithZone:zone];
    voc.foreignString = [self.foreignString copyWithZone:zone];
    voc.foreignLanguage = [self.foreignLanguage copyWithZone:zone];
    voc.homeLanguage = [self.homeLanguage copyWithZone:zone];
    voc.reminder = [self.reminder copyWithZone:zone];
    voc.image = [[UIImage allocWithZone:zone] initWithCGImage:self.image.CGImage];
    voc.rightCount = self.rightCount;
    voc.rightGesamt = self.rightGesamt;
    voc.falseGesamt = self.falseGesamt;
    
    return voc;
}



@end
