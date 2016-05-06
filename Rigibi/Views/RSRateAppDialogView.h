//
//  RSRateAppDialogView.h
//  Rigibi
//
//  Created by Roman Silin on 26/04/15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RSMixButton.h"

typedef NS_ENUM(NSUInteger, RSRateAppDialogType) {
    
    RSDialogEnjoying = 0,
    RSDialogAppStore = 1,
    RSDialogFeedback = 2
};

@interface RSRateAppDialogView : UIView <RSRateAppDialogDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) id <RSGameVCDelegate> delegate;
@property (nonatomic) RSRateAppDialogType dialogType;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *yesLabel;
@property (strong, nonatomic) UILabel *noLabel;
@property (strong, nonatomic) RSMixButton *yesButton;
@property (strong, nonatomic) RSMixButton *noButton;
@property (nonatomic) CGFloat gridSize;
@property (nonatomic) CGSize radiusOfBorder;
@property (nonatomic) CGSize radiusOfInside;
@property (nonatomic) BOOL dialogResult;

- (void)setup;
- (void)playSound:(NSString *)soundName;
- (void)userChoose:(RSMixButton *)sender;

@end
