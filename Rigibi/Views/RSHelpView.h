//
//  RSHelpView.h
//  Rigibi
//
//  Created by Roman Silin on 04/05/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSHexLabel.h"
#import "RSPalette.h"
#import "FXBlurView.h"
#import "UIView+Blur.h"

@interface RSHelpView : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <RSGameVCDelegate> delegate;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) RSHexLabel *resultSquare;

@property (strong, nonatomic) UISlider *redSlider;
@property (strong, nonatomic) UISlider *greenSlider;
@property (strong, nonatomic) UISlider *blueSlider;

@property (strong, nonatomic) UILabel *redValue;
@property (strong, nonatomic) UILabel *greenValue;
@property (strong, nonatomic) UILabel *blueValue;


+ (RSHelpView *)initWithSetupWithFrame:(CGRect)frame andDelegate:(id <RSGameVCDelegate>)delegate;

@end
