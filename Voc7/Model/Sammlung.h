//
//  Sammlung.h
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 05.08.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sammlung : NSObject <NSCoding>
{
    
}

@property (strong) NSMutableArray *vocArray;
@property (strong) NSString *name;
@property (strong) NSMutableArray *kategorieNames;
@end
