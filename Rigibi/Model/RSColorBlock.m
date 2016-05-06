//
//  RSColorBlock.m
//  Rigibi
//
//  Created by Roman Silin on 17.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSColorBlock.h"

@implementation RSColorBlock

- (NSMutableArray *)mutualColorGroup {
    
    if (_mutualColorGroup == nil) {
        _mutualColorGroup = [[NSMutableArray alloc] init];
    }
    if ([_mutualColorGroup count] == 0) {
        [_mutualColorGroup addObject:[NSValue valueWithCGPoint:self.position]];
    }
    return _mutualColorGroup;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeCGPoint:self.position forKey:@"position"];
    [encoder encodeObject:self.color forKey:@"color"];
    [encoder encodeObject:self.mutualColorGroup forKey:@"mutualGroup"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self = [super init];
    if (self != nil)
    {
        self.position = [decoder decodeCGPointForKey:@"position"];
        self.color = [decoder decodeObjectForKey:@"color"];
        self.mutualColorGroup = [decoder decodeObjectForKey:@"mutualGroup"];
    }
    return self;
}

@end
