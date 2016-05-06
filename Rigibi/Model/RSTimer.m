//
//  RSTimer.m
//  Rigibi
//
//  Created by Roman Silin on 28/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSTimer.h"

@implementation RSTimer

- (NSTimer *)timer {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)reset {
    
    [self pause];
    [self setSeconds:0];
}

- (void)start {
    
    [self timer];
}

- (void)pause {
    
    [self.timer invalidate];
    [self setTimer:nil];
}

- (void)tick {
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        self.seconds++;
    }
}

@end
