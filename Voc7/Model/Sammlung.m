//
//  Sammlung.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 05.08.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "Sammlung.h"

@implementation Sammlung

- (id)init
{
    self = [super init];
    if (self) {
    self.vocArray = [[NSMutableArray alloc] init];
    self.kategorieNames = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
    self.vocArray = [[NSMutableArray alloc] init];
    self.vocArray = [aDecoder decodeObjectForKey:@"vocArray"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.kategorieNames = [[NSMutableArray alloc] init];
    self.kategorieNames = [aDecoder decodeObjectForKey:@"kategorieNames"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.vocArray forKey:@"vocArray"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.kategorieNames forKey:@"kategorieNames"];
}

@end
