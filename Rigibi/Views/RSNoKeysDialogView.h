//
//  RSNoKeysDialogView.h
//  Rigibi
//
//  Created by Roman Silin on 14.03.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import <Social/Social.h>
#import "RSRoundedView.h"
#import "RSGameLevel.h"
#import "RSPalette.h"
#import "RMStore.h"
#import "RSProcessButton.h"

@interface RSNoKeysDialogView : UIView <UIGestureRecognizerDelegate, RSGridSizeDelegate>

@property (weak, nonatomic) id <RSGameVCDelegate> delegate;
@property (nonatomic) CGFloat gridSize;
@property (strong, nonatomic) RSRoundedView *bordersDialog;
@property (strong, nonatomic) RSRoundedView *insideDialog;
@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) RSProcessButton *rightButton;
@property (strong, nonatomic) RSProcessButton *leftButton;
@property (strong, nonatomic) RSProcessButton *bottomButton;
@property (strong, nonatomic) UIButton *outsideButton;
@property (strong, nonatomic) UIButton *buttonOfClose;
@property (strong, nonatomic) UIImage *snapshotOfPuzzle;
@property (nonatomic) BOOL blockUI;
@property (nonatomic) BOOL isStoreAvailable;

- (void)setup;
- (void)getInAppProducts;

@end
