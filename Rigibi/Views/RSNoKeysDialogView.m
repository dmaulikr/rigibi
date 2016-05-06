//
//  RSNoKeysDialogView.m
//  Rigibi
//
//  Created by Roman Silin on 14.03.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "RSNoKeysDialogView.h"

@implementation RSNoKeysDialogView

- (CGFloat)gridSize {
    
    CGFloat gridSize = [self.delegate gridSize];
    if (self.frame.size.width > SCREEN_IPHONE6PLUS) {
        gridSize = GRID_SIZE + GRID_SIZE/8;
    }
    return gridSize;
}

- (void)setup {
    
    [self setBackgroundColor:[UIColor blackColor]];
    CGFloat borderWidth = self.delegate.gridSize/4;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(hideDialog)];
    [tapGR setDelegate:self];
    [self addGestureRecognizer:tapGR];
    
    CGRect frameOfDialog = CGRectZero;
    frameOfDialog.size.width = self.gridSize * BLOCKS_IN_ROW + borderWidth*2;
    frameOfDialog.size.height = frameOfDialog.size.width;
    frameOfDialog.origin.x = (self.frame.size.width - frameOfDialog.size.width) / 2;
    frameOfDialog.origin.y = (self.frame.size.height - frameOfDialog.size.height) / 2;
    self.bordersDialog = [[RSRoundedView alloc] initWithFrame:frameOfDialog];
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    [self.bordersDialog setRadius:[self.delegate radiusOfBorder]];
    [self.bordersDialog setCorners:corners];
    [self.bordersDialog setBackgroundColor:[UIColor colorWithWhite:0.15 alpha:1]];
    [self addSubview:self.bordersDialog];
    
    CGRect insideFrame = frameOfDialog;
    insideFrame.origin.x = borderWidth;
    insideFrame.origin.y = borderWidth;
    insideFrame.size.width -= borderWidth*2;
    insideFrame.size.height -= borderWidth*2;
    self.insideDialog = [[RSRoundedView alloc] initWithFrame:insideFrame];
    corners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    [self.insideDialog setRadius:[self.delegate radiusOfInside]];
    [self.insideDialog setCorners:corners];
    [self.bordersDialog addSubview:self.insideDialog];
    
    CGRect frameOfTop = insideFrame;
    frameOfTop.origin = CGPointZero;
    frameOfTop.size.height = insideFrame.size.height/2;
    self.topLabel = [[UILabel alloc] initWithFrame:frameOfTop];
    self.topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.topLabel.numberOfLines = 0;
    [self.topLabel setBackgroundColor:[UIColor colorFromHex:DIALOG_BACKGROUND]];
    [self.topLabel setTextAlignment:NSTextAlignmentCenter];
    [self.topLabel setTextColor:[UIColor whiteColor]];
    [self.topLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    NSString *noKeysMessage = NSLocalizedString(@"DIALOG_KEYS", nil);
    noKeysMessage = [noKeysMessage stringByReplacingOccurrencesOfString:@"*FREEKEY_LEVELSCOUNT*" withString:[NSString stringWithFormat:@"%i",FREEKEY_LEVELSCOUNT]];
    [self.topLabel setText:noKeysMessage];

    [self.insideDialog addSubview:self.topLabel];
    
    CGRect frameOfLeft = frameOfTop;
    frameOfLeft.size.height = frameOfTop.size.height/2;
    frameOfLeft.size.width = frameOfTop.size.width/2;
    frameOfLeft.origin.y += frameOfTop.size.height;
    self.leftButton = [RSProcessButton buttonWithType:UIButtonTypeSystem];
    [self.leftButton setDelegate:self];
    [self.leftButton setFrame:frameOfLeft];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor whiteColor]];
    [self.leftButton setBackgroundColor:[UIColor colorFromHex:DIALOG_FACEBOOK]];
    [self.leftButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [self.leftButton addTarget:self action:@selector(shareFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.insideDialog addSubview:self.leftButton];
    
    CGRect frameOfRight = frameOfLeft;
    frameOfRight.origin.x += frameOfLeft.size.width;
    self.rightButton = [RSProcessButton buttonWithType:UIButtonTypeSystem];
    [self.rightButton setDelegate:self];
    [self.rightButton setFrame:frameOfRight];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [self.rightButton setTintColor:[UIColor whiteColor]];
    [self.rightButton setBackgroundColor:[UIColor colorFromHex:DIALOG_TWITTER]];
    [self.rightButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [self.rightButton addTarget:self action:@selector(shareTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.insideDialog addSubview:self.rightButton];
    
    CGRect frameOfBottom = frameOfTop;
    frameOfBottom.size.height = frameOfLeft.size.height;
    frameOfBottom.origin.y += frameOfLeft.size.height*3;
    self.bottomButton = [RSProcessButton buttonWithType:UIButtonTypeSystem];
    [self.bottomButton setDelegate:self];
    [self.bottomButton setFrame:frameOfBottom];
    [self.bottomButton setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    [self.bottomButton setTintColor:[UIColor whiteColor]];
    [self.bottomButton setBackgroundColor:[UIColor colorFromHex:DIALOG_PURCHASE]];
    [self.bottomButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [self.bottomButton addTarget:self action:@selector(makePurchase) forControlEvents:UIControlEventTouchUpInside];
    [self.insideDialog addSubview:self.bottomButton];
    
    CGRect frameOfOutside = frameOfBottom;
    frameOfOutside.size.width = self.frame.size.width/2;
    frameOfOutside.origin.y = (self.frame.size.height-self.bordersDialog.frame.origin.y) + 0.5*self.bordersDialog.frame.origin.y - 0.5*frameOfOutside.size.height;
    self.outsideButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.outsideButton setFrame:frameOfOutside];
    self.outsideButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.outsideButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.outsideButton.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [self.outsideButton setTitleEdgeInsets:UIEdgeInsetsMake(0, self.bordersDialog.frame.origin.x, 0, 0)];
    [self.outsideButton addTarget:self action:@selector(restorePurchase) forControlEvents:UIControlEventTouchUpInside];
    [self.outsideButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState: UIControlStateNormal];
    [self.outsideButton setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState: UIControlStateHighlighted];
    [self.outsideButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
    [self addSubview:self.outsideButton];
    
    CGRect frameOfClose = frameOfOutside;
    frameOfClose.origin.x = frameOfOutside.size.width;
    self.buttonOfClose = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.buttonOfClose setFrame:frameOfClose];
    self.buttonOfClose.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.buttonOfClose.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.buttonOfClose.titleLabel setFont:[UIFont fontWithName:@"Avenir" size:18]];
    [self.buttonOfClose setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];
    [self.buttonOfClose setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, self.bordersDialog.frame.origin.x)];
    [self.buttonOfClose setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState: UIControlStateNormal];
    [self.buttonOfClose setTitleColor:[UIColor colorWithWhite:1 alpha:1.0] forState: UIControlStateHighlighted];
    [self.buttonOfClose setTitle:NSLocalizedString(@"DIALOG_BACK", nil) forState:UIControlStateNormal];
    [self.buttonOfClose addTarget:self.delegate action:@selector(hideDialog) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.buttonOfClose];

    [self updateUI];
}

- (void)updateUI {
    
    [self.leftButton setEnabled:!([self.delegate sharedFacebook] || self.blockUI || self.leftButton.process)];
    [self.leftButton setBackgroundColor:([self.delegate sharedFacebook])?[UIColor colorFromHex:DIALOG_FACEBOOK_GRAY]:[UIColor colorFromHex:DIALOG_FACEBOOK]];
    [self.leftButton setImage:([self.delegate sharedFacebook])?[[UIImage imageNamed:@"facebook_used"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]:[[UIImage imageNamed:@"facebook_one"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.rightButton setEnabled:!([self.delegate sharedTwitter] || self.blockUI || self.rightButton.process)];
    [self.rightButton setBackgroundColor:([self.delegate sharedTwitter])?[UIColor colorFromHex:DIALOG_TWITTER_GRAY]:[UIColor colorFromHex:DIALOG_TWITTER]];
    [self.rightButton setImage:([self.delegate sharedTwitter])?[[UIImage imageNamed:@"twitter_used"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]:[[UIImage imageNamed:@"twitter_one"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [self.bottomButton setImage:[[UIImage imageNamed:@"key_five"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.bottomButton setEnabled:!([self.delegate keysCount] < 0 || self.blockUI) || self.bottomButton.process];
    if ([self.delegate keysCount] < 0) {
        [self.bottomButton setImage:[[UIImage imageNamed:@"key_infinity"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.bottomButton setTitle:NSLocalizedString(@"DIALOG_PURCHASED", nil) forState:UIControlStateNormal];
    } else if (!self.isStoreAvailable) {
        [self.bottomButton setImage:nil forState:UIControlStateNormal];
        [self.bottomButton setTitle:(!self.bottomButton.process)?NSLocalizedString(@"DIALOG_STOREUNAVAILABLE", nil):@"" forState:UIControlStateNormal];
    }
    
    if (([self.delegate keysCount] < 0) || self.bottomButton.process) {
        [self.outsideButton setTitle:@" " forState:UIControlStateNormal];
        [self.outsideButton setEnabled:NO];
    } else {
        [self.outsideButton setEnabled:!(self.blockUI)];
        if (!self.isStoreAvailable) {
            [self.outsideButton setTitle:NSLocalizedString(@"DIALOG_TRYCONNECT", nil) forState:UIControlStateNormal];
        }
    }

}

- (void)setBlockUI:(BOOL)block {

    _blockUI = block;
    [self.leftButton setEnabled:!block];
    [self.rightButton setEnabled:!block];
    [self.bottomButton setEnabled:!block];
    [self.outsideButton setEnabled:!block];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    CGPoint pointInView = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.bordersDialog.frame, pointInView) || (CGRectContainsPoint(self.outsideButton.frame, pointInView) && [self.delegate keysCount]!=-1)) {
        return NO;
    }
    return YES;
}



#pragma mark SHARE SERVICES

- (void)shareFacebook {
    
    [self.leftButton setProcess:YES];
    [self setBlockUI:YES];
    [self shareWithService:SLServiceTypeFacebook];
}

- (void)shareTwitter {

    [self.rightButton setProcess:YES];
    [self setBlockUI:YES];
    [self shareWithService:SLServiceTypeTwitter];
}

- (void)shareWithService:(NSString *)serviceType {
    
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [shareSheet setInitialText:NSLocalizedString(@"SHARE_HELP", nil)];
        [shareSheet addURL:[NSURL URLWithString:RIGIBI_URL]];
        [shareSheet addImage:self.snapshotOfPuzzle];
        
        [shareSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            if (result == SLComposeViewControllerResultDone) {
                NSString *currentLevel = [NSString stringWithFormat:@"%@ %02i", evLEVEL, (int)[self.delegate currentLevel]+1];
                if (serviceType == SLServiceTypeFacebook) {
                    [self.delegate setSharedFacebook:YES];
                    [YMMYandexMetrica reportEvent:evNOKEYS parameters:@{evFB:currentLevel} onFailure:nil];
                } else if (serviceType == SLServiceTypeTwitter) {
                    [self.delegate setSharedTwitter:YES];
                    [YMMYandexMetrica reportEvent:evNOKEYS parameters:@{evTW:currentLevel} onFailure:nil];
                }
                if ([self.delegate keysCount] != -1) {
                    [self.delegate setKeysCount:[self.delegate keysCount]+1];
                }
                [self.delegate playSound:@"key"];
                [self.delegate saveUserDefaults];
            }
            [self.leftButton setProcess:NO];
            [self.rightButton setProcess:NO];
            [self setBlockUI:NO];
            [self updateUI];
        }];
        [self.delegate presentViewController:shareSheet animated:YES completion:nil];
        
    } else {
        
        NSString *errorTitle;
        NSString *errorMessage;
        if (serviceType == SLServiceTypeFacebook) {
            errorTitle = NSLocalizedString(@"ERROR_TITLE", nil);
            errorMessage = NSLocalizedString(@"ERROR_FACEBOOK", nil);
        } else if (serviceType == SLServiceTypeTwitter) {
            errorTitle = NSLocalizedString(@"ERROR_TITLE", nil);
            errorMessage = NSLocalizedString(@"ERROR_TWITTER", nil);
        }
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle: errorTitle
                                  message:errorMessage
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [self.leftButton setProcess:NO];
        [self.rightButton setProcess:NO];
        [self setBlockUI:NO];
    }
}

- (void)setInfiniteKeys {
    
    // actual or Rigibi 1.0 only
    [self.delegate setKeysCount:-1];
    [self.delegate playSound:@"key"];
    [self updateUI];
    [self.delegate saveUserDefaults];
}

- (void)addPurchasedKeys:(int)count {
    
    [self.delegate setKeysCount:[self.delegate keysCount] + count];
    [self.delegate playSound:@"key"];
    [self updateUI];
    [self.delegate saveUserDefaults];
}



#pragma mark IN-APP PURCHASES

- (void)getInAppProducts {
    
    if (self.isStoreAvailable || [self.bottomButton process]) {
        return;
    }
    [self.bottomButton setProcess:YES];
    [self.bottomButton setEnabled:NO];
    [self.outsideButton setTitle:@" " forState:UIControlStateNormal];
    [self.outsideButton setEnabled:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSSet *requestProducts = [NSSet setWithArray:@[INFINITE_KEYS_PRODUCT_ID, FIVE_KEYS_PRODUCT_ID]];
        [[RMStore defaultStore] requestProducts:requestProducts success:^(NSArray *products, NSArray *invalidProductIdentifiers) {

            dispatch_async(dispatch_get_main_queue(), ^{

                if (products.count > 0) {
                    [self setIsStoreAvailable:YES];
                    [self.bottomButton setProcess:NO];
                    
                    for (SKProduct *product in products) {
                        if ([product.productIdentifier isEqual:FIVE_KEYS_PRODUCT_ID]) {
                            
                            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                            [numberFormatter setLocale:product.priceLocale];
                            NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
                            formattedPrice = [NSString stringWithFormat:@"  %@ %@", NSLocalizedString(@"DIALOG_PRICEDEVIDER", nil), formattedPrice];

                            [self.bottomButton setTitle:([self.delegate keysCount] < 0)?NSLocalizedString(@"DIALOG_PURCHASED", nil):formattedPrice forState:UIControlStateNormal];
                            [self.outsideButton setTitle:NSLocalizedString(@"DIALOG_RESTORE_PURCHASES", nil) forState:UIControlStateNormal];
                        }
                    }
                    [self updateUI];
                } else {
                    NSLog(@", but products.count = 0");
                }
                
            });
            
        } failure:^(NSError *error) {
            
            [self setIsStoreAvailable:NO];
            [self.bottomButton setProcess:NO];
            [self updateUI];
        }];
        
    });
}

- (void)makePurchase {
    
    if (!self.isStoreAvailable) {
        [self getInAppProducts];
        return;
    }
    
    [self.bottomButton setProcess:YES];
    [self.outsideButton setTitle:@" " forState:UIControlStateNormal];
    [self.outsideButton setEnabled:NO];
    [self setBlockUI:YES];
    [[RMStore defaultStore] addPayment:FIVE_KEYS_PRODUCT_ID success:^(SKPaymentTransaction *transaction) {
        [self.bottomButton setProcess:NO];
        [self setBlockUI:NO];
        //[self setInfiniteKeys]; // in Rigibi 1.0
        [self addPurchasedKeys:5];
        NSString *currentLevel = [NSString stringWithFormat:@"%@ %02i",evLEVEL,(int)[self.delegate currentLevel]+1];
        [YMMYandexMetrica reportEvent:evNOKEYS parameters:@{evBUYINAPP_5KEYS:currentLevel} onFailure:nil];
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        if (error.code != SKErrorPaymentCancelled) { // Если не отменял, но не подключиться к магазину
            [self setIsStoreAvailable:NO];
        }
        [self setBlockUI:NO];
        [self.bottomButton setProcess:NO];
        [self.outsideButton setTitle:NSLocalizedString(@"DIALOG_RESTORE_PURCHASES", nil) forState:UIControlStateNormal];
        [self updateUI];
    }];
}

- (void)restorePurchase {

    if (!self.isStoreAvailable) {
        [self getInAppProducts];
        return;
    }
    
    [self.bottomButton setProcess:YES];
    [self.outsideButton setTitle:NSLocalizedString(@"DIALOG_RESTORING", nil) forState:UIControlStateNormal];
    [self setBlockUI:YES];
    
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
        [self setBlockUI:NO];
        if (transactions.count > 0) {
            [self setInfiniteKeys];
        } else {
            [self.outsideButton setTitle:NSLocalizedString(@"DIALOG_NOTRESTORED", nil) forState:UIControlStateNormal];
        }
        [self.bottomButton setProcess:NO];
        [self updateUI];
    } failure:^(NSError *error) {
        if (error.code != SKErrorPaymentCancelled) { // Если не отменял, но не подключиться к магазину
            [self setIsStoreAvailable:NO];
        }
        [self.outsideButton setTitle:NSLocalizedString(@"DIALOG_RESTORE_PURCHASES", nil) forState:UIControlStateNormal];
        [self setBlockUI:NO];
        [self.bottomButton setProcess:NO];
        [self updateUI];
    }];
}

@end
