//
//  DayController.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 02.04.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import "DayController.h"
#import "Day.h"

NSMutableArray *graphArray;

@implementation DayController

- (id)init
{
    return self;
}

- (void)refresh
{
    int absoluteTime = (int)CFAbsoluteTimeGetCurrent();
    int currentTime = absoluteTime - absoluteTime % 86400;
    int latestTime = [self findLatestTime];
    
    if (currentTime > latestTime) {
        Day *day = [[Day alloc] init];
        day.time = currentTime;
        [graphArray addObject:day];
        dayIndex = [graphArray indexOfObject:day];
    }
}

- (int)findLatestTime
{
    int time = 0;
    for (Day *day in graphArray) {
        if (day.time > time) {
            time = day.time;
            dayIndex = [graphArray indexOfObject:day];
        }
    }
    
    return time;
}


- (void)incrementRightCount
{
    [self refresh];
    Day *tempDay = [graphArray objectAtIndex:dayIndex];
    tempDay.rightVocs++;
    [graphArray replaceObjectAtIndex:dayIndex withObject:tempDay];
}

- (void)incrementWrongCount
{
    [self refresh];
    Day *tempDay = [graphArray objectAtIndex:dayIndex];
    tempDay.wrongVocs++;
    [graphArray replaceObjectAtIndex:dayIndex withObject:tempDay];
}


@end
