//
//  RSWinnerDialogView.h
//  Rigibi
//
//  Created by Roman Silin on 26/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSWinnerDialogView : UIView

@property (weak, nonatomic) id <RSGameVCDelegate> delegate;
@property (strong, nonatomic) NSTimer *twinkleTimer;
@property (strong, nonatomic) UIButton *rateButton;
@property (strong, nonatomic) UIButton *shareButton;


- (void)setup;

@end
