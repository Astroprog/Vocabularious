//
//  Day.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 28.03.13.
//  Copyright (c) 2013 Gambain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject <NSCoding>
{
    
}

@property (readwrite) int time;
@property (readwrite) int wrongVocs;
@property (readwrite) int rightVocs;
@end
