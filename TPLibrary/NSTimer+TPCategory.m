//
//  NSTimer+TPCategory.m
//  LocationService
//
//  Created by aJia on 2014/1/13.
//  Copyright (c) 2014年 lz. All rights reserved.
//

#import "NSTimer+TPCategory.h"
NSString *kIsPausedKey = @"IsPaused Key";
NSString *kRemainingTimeIntervalKey = @"RemainingTimeInterval Key";

@implementation NSTimer (TPCategory)
-(void)pauseTimer{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]]; //如果给我一个期限，我希望是4001-01-01 00:00:00 +0000
}
-(void)resumeTimer{
    if (![self isValid]) {
        return ;
    }
    //[self setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self setFireDate:[NSDate date]];
}

- (NSMutableDictionary *)pauseDictionary {
    static NSMutableDictionary *globalDictionary = nil;
    
    if(!globalDictionary)
        globalDictionary = [[NSMutableDictionary alloc] init];
    
    if(![globalDictionary objectForKey:[NSNumber numberWithInt:(int)self]]) {
        NSMutableDictionary *localDictionary = [[[NSMutableDictionary alloc] init] autorelease];
        [globalDictionary setObject:localDictionary forKey:[NSNumber numberWithInt:(int)self]];
    }
    
    return [globalDictionary objectForKey:[NSNumber numberWithInt:(int)self]];
}

- (void)pause {
    if(![self isValid])
        return;
    
    NSNumber *isPausedNumber = [[self pauseDictionary] objectForKey:kIsPausedKey];
    if(isPausedNumber && YES == [isPausedNumber boolValue])
        return;
    
    NSDate *now = [NSDate date];
    NSDate *then = [self fireDate];
    NSTimeInterval remainingTimeInterval = [then timeIntervalSinceDate:now];
    
    [[self pauseDictionary] setObject:[NSNumber numberWithDouble:remainingTimeInterval] forKey:kRemainingTimeIntervalKey];
    
    [self setFireDate:[NSDate distantFuture]];
    [[self pauseDictionary] setObject:[NSNumber numberWithBool:YES] forKey:kIsPausedKey];
}

- (void)resume {
    if(![self isValid])
        return;
    
    NSNumber *isPausedNumber = [[self pauseDictionary] objectForKey:kIsPausedKey];
    if(!isPausedNumber || NO == [isPausedNumber boolValue])
        return;
    
    NSTimeInterval remainingTimeInterval = [[[self pauseDictionary] objectForKey:kRemainingTimeIntervalKey] doubleValue];
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:remainingTimeInterval];
    
    [self setFireDate:fireDate];
    [[self pauseDictionary] setObject:[NSNumber numberWithBool:NO] forKey:kIsPausedKey];
}
@end
