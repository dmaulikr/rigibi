//
//  RSGameLevel.h
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSColorBlock.h"
#import "RSPalette.h"

@interface RSGameLevel : NSObject

@property (nonatomic) CGSize size;
@property (strong, nonatomic) RSPalette *palette;
@property (strong, nonatomic) UIColor *targetColor;
@property (strong, nonatomic) NSMutableArray *blocks; // array of RSColorBlock
@property (strong, nonatomic) NSArray *solutionSteps; // array of NSArray (CGPoint from, CGPoint to)
@property (nonatomic) BOOL justNowSolved;

+ (RSGameLevel *)emptyLevelWithSize:(CGSize )size pallete:(RSPalette *)palette andTargetColor:(UIColor *)targetColor;
+ (RSGameLevel *)generateLevelwithSize:(CGSize )size pallete:(RSPalette *)palette andTargetColor:(UIColor *)targetColor;
+ (RSGameLevel *)copyGameLevel:(RSGameLevel *)gameLevel;
+ (NSMutableArray *)copyMutualColorGroup:(NSMutableArray *)mutualColorGroup;

- (void)updateMutualBlocks;
- (BOOL)isSovledRight;
- (BOOL)isSovled;
- (void)solveLevel;
- (RSColorBlock *)blockOnPosition:(CGPoint)position;

@end