//
//  RSTimer.h
//  Rigibi
//
//  Created by Roman Silin on 28/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSTimer : NSObject

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger seconds;

- (void)reset;
- (void)start;
- (void)pause;

@end
