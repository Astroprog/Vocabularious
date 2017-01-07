//
//  CustomCell.m
//  ProjectOmega
//
//  Created by Peter Rodenkirch on 16.07.12.
//  Copyright (c) 2012 Gambain. All rights reserved.
//

#import "CustomCell.h"
#import "CellBackground.h"
#import "CellBackgroundSelected.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    CellBackground *view = [[CellBackground alloc] init];
    CellBackgroundSelected *selectedView = [[CellBackgroundSelected alloc] init];
    self.selectedBackgroundView = selectedView;
    self.backgroundView = view;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textColor = [UIColor whiteColor];
    return self;
}

- (UIColor *)_multiselectBackgroundColor
{
    return [UIColor clearColor];
}

@end

