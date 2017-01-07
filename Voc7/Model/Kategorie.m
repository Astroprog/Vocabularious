//
//  Kategorie.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 20.05.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "Kategorie.h"

@implementation Kategorie

- (id)initWithKategorieName:(NSString *)name date:(NSDate *)date andLanguage:(NSString *)language
{
    self = [super init];
    if (self) {
    self.rightGesamt = 0;
    self.falseGesamt = 0;
    self.foreignLanguage = language;
    self.kategorieName = name;
    int currentTime = (int)CFAbsoluteTimeGetCurrent();
    self.date = currentTime - currentTime % 86400;
    self.vocArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithKategorieName:(NSString *)name array:(NSMutableArray *)tempArray
{
    self = [super init];
    if (self) {
    self.vocArray = [[NSMutableArray alloc] initWithArray:tempArray];
    self.kategorieName = name;
    }
    return self;
}

- (id)initWithKategorie:(Kategorie *)tempKategorie
{
    self = [super init];
    if (self) {
    self.rightGesamt = tempKategorie.rightGesamt;
    self.falseGesamt = tempKategorie.falseGesamt;
    self.foreignLanguage = tempKategorie.foreignLanguage;
    self.kategorieName = tempKategorie.kategorieName;
    self.date = tempKategorie.date;
    self.vocArray = [[NSMutableArray alloc] initWithArray:tempKategorie.vocArray];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
    self.vocArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.foreignLanguage forKey:@"foreignLanguage"];
    [aCoder encodeObject:self.homeLanguage forKey:@"homeLanguage"];
    [aCoder encodeObject:self.kategorieName forKey:@"kategorieName"];
    [aCoder encodeInt:self.date forKey:@"date"];
    [aCoder encodeInt:self.rightGesamt forKey:@"rightGesamt"];
    [aCoder encodeInt:self.falseGesamt forKey:@"falseGesamt"];
    [aCoder encodeInt:self.schuljahr forKey:@"schulJahr"];
    [aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:self.vocArray] forKey:@"vocArray"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
    self.foreignLanguage = [aDecoder decodeObjectForKey:@"foreignLanguage"];
    self.homeLanguage = [aDecoder decodeObjectForKey:@"homeLanguage"];
    self.kategorieName = [aDecoder decodeObjectForKey:@"kategorieName"];
//    self.date = [aDecoder decodeIntForKey:@"date"];
    self.rightGesamt = [aDecoder decodeIntForKey:@"rightGesamt"];
    self.falseGesamt = [aDecoder decodeIntForKey:@"falseGesamt"];
    self.schuljahr = [aDecoder decodeIntForKey:@"schulJahr"];
    self.vocArray = [[NSMutableArray alloc] init];
    self.vocArray = [NSKeyedUnarchiver unarchiveObjectWithData:[aDecoder decodeObjectForKey:@"vocArray"]];
    }
    return self;    
}

@end
