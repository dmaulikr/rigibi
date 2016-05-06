//
//  RSGameZoneView.h
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSRoundedView.h"
#import "RSColorView.h"
#import "RSColorBlock.h"
#import "RSGameLevel.h"

@interface RSGameZoneView : RSRoundedView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <RSGameVCDelegate> delegate;
@property (strong, nonatomic) RSColorBlock *firstBlock;
@property (strong, nonatomic) RSColorBlock *secondBlock;
@property (strong, nonatomic) UIPanGestureRecognizer *panGR;
@property (strong, nonatomic) UIButton *okButton;

- (void)panGestureMove:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)mixBlock:(RSColorBlock *)firstBlock with:(RSColorBlock *)secondBlock;
- (void)setupWithGameLevel:(RSGameLevel *)gameLevel;
- (void)updateView;

@end
