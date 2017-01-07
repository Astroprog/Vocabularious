//
//  Day.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 28.03.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "Day.h"

@implementation Day

- (id)init
{
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.time = [aDecoder decodeIntForKey:@"time"];
    self.wrongVocs = [aDecoder decodeIntForKey:@"wrongVocs"];
    self.rightVocs = [aDecoder decodeIntForKey:@"rightVocs"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.time forKey:@"time"];
    [aCoder encodeInt:self.wrongVocs forKey:@"wrongVocs"];
    [aCoder encodeInt:self.rightVocs forKey:@"rightVocs"];
}

@end
