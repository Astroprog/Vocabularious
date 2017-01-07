//
//  DayController.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 02.04.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Day;

@interface DayController : NSObject
{
    Day *currentDay;
    int dayIndex;
}

- (void)incrementRightCount;
- (void)incrementWrongCount;

@end
