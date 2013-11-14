//
//  Event.m
//  Gidr
//
//  Created by J.Sterling U1276062 on 14/11/2013.
//  Copyright (c) 2013 J.Sterling U1276062. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (NSDate*)dateAndTime{
    NSTimeInterval MY_EXTRA_TIME = 22 * 24 * 60 * 60; // 22 days
    NSDate *dateAndTime = [[NSDate date] dateByAddingTimeInterval:MY_EXTRA_TIME];
    return dateAndTime;
}

@end





