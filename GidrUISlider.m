//
//  GidrUISlider.m
//  Gidr
//
//  Created by Administrator on 01/04/2014.
//  Copyright (c) 2014 Gidr. All rights reserved.
//

#import "GidrUISlider.h"

@implementation GidrUISlider

// How many extra touchable pixels you want above and below the 23px slider
#define SIZE_EXTENSION_Y -10

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x, bounds.origin.y, self.bounds.size.width, 50);
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 0, SIZE_EXTENSION_Y);
    return CGRectContainsPoint(bounds, point);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
