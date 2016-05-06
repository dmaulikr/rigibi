//
//  RSMixButton.h
//  Rigibi
//
//  Created by Roman Silin on 27/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSRoundedView.h"

@interface RSMixButton : RSRoundedView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <RSRateAppDialogDelegate> delegate;

@property (strong, nonatomic) RSRoundedView *insideView;
@property (strong, nonatomic) UIColor *topColor;
@property (strong, nonatomic) UIColor *bottomColor;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *okButton;
@property (nonatomic) BOOL enabled;

@property (strong, nonatomic) UIPanGestureRecognizer *panGR;
@property (weak, nonatomic) UIView *startPanView;

- (void)setup;

@end
