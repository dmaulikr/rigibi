//
//  ViewController.m
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark LAZY

- (RSHelpView *)helpView {
    
    if (!_helpView) {
        _helpView = [RSHelpView initWithSetupWithFrame:self.view.frame andDelegate:self];
        [_helpView setHidden:YES];
        [self.view addSubview:_helpView];
    }
    return _helpView;
}

- (RSNoKeysDialogView *)noKeysDialogView {
    
    if (!_noKeysDialogView) {
        _noKeysDialogView = [[RSNoKeysDialogView alloc] initWithFrame:self.view.frame];
        [_noKeysDialogView setDelegate:self];
        [_noKeysDialogView setup];
        [_noKeysDialogView setHidden:YES];
        [self.view addSubview:self.noKeysDialogView];
    }
    return _noKeysDialogView;
}

- (RSTimer *)timer {
    
    if (!_timer) {
        _timer = [[RSTimer alloc] init];
    }
    return _timer;
}

- (NSMutableArray *)allLevels {
    
    if (_allLevels == nil) {
        _allLevels = [[NSMutableArray alloc] init];
    }
    return _allLevels;
}

- (RSGameLevel *)gameLevel {
    
    if (_gameLevel == nil) {
        _gameLevel = [RSGameLevel copyGameLevel:(RSGameLevel *)[self.allLevels objectAtIndex:self.currentLevel]];
    }
    return _gameLevel;
}

- (RSGameZoneView *)gameZoneView {
    
    if (_gameZoneView == nil) {
        
        // Вычисление размера игровой зоны
        CGRect frameOfGameZone = CGRectZero;
        frameOfGameZone.size.width = self.gridSize * self.gameLevel.size.width + self.gridSize/4*2;
        frameOfGameZone.size.height = self.gridSize * self.gameLevel.size.height + self.gridSize/4*2;
        frameOfGameZone.origin.x = (self.view.frame.size.width - frameOfGameZone.size.width) / 2;
        frameOfGameZone.origin.y = (self.view.frame.size.height - frameOfGameZone.size.height) / 2;
        _gameZoneView = [[RSGameZoneView alloc] initWithFrame:frameOfGameZone];
        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
        [_gameZoneView setCorners:corners];
        [_gameZoneView setRadius:[self radiusOfBorder]];
        // Добавляем детектор прикосновений
        _gameZoneView.panGR = [[UIPanGestureRecognizer alloc] initWithTarget:_gameZoneView action:@selector(panGestureMove:)];
        [_gameZoneView.panGR setDelegate:_gameZoneView];
        [_gameZoneView.panGR setMinimumNumberOfTouches:1];
        [_gameZoneView.panGR setMaximumNumberOfTouches:1];
        [_gameZoneView addGestureRecognizer:_gameZoneView.panGR];
        
        [_gameZoneView setDelegate:self];
        [self.view addSubview:_gameZoneView];
    }
    return _gameZoneView;
}

- (UILabel *)hexLabel {
    
    if (!_hexLabel) {
        CGRect hexFrame = self.gameZoneView.frame;
        CGFloat borderWidth = self.gridSize/4;
        hexFrame.origin.y -= 1.5*borderWidth;
        hexFrame.size.height = borderWidth;
        _hexLabel = [[UILabel alloc] initWithFrame:hexFrame];
        [_hexLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:12]];
        [_hexLabel setTextAlignment:NSTextAlignmentCenter];
        [_hexLabel setAlpha:(DEVMODE)?self.hexShowed:0];
        [self.view addSubview:_hexLabel];
    }
    return _hexLabel;
}

- (UILabel *)tutorialLabel {
    
    if (!_tutorialLabel) {
        CGRect tutorialFrame = self.gameZoneView.frame;
        tutorialFrame.size.width = self.view.bounds.size.width;
        if (tutorialFrame.size.width > self.gridSize*(BLOCKS_IN_ROW+1)) {
            tutorialFrame.size.width = self.gridSize*(BLOCKS_IN_ROW+1);
        }
        tutorialFrame.size.height = (self.restartButton.frame.origin.y + self.restartButton.imageView.frame.origin.y) - (self.gameZoneView.frame.origin.y + self.gameZoneView.frame.size.height);
        tutorialFrame.origin.x = self.view.frame.size.width/2 - tutorialFrame.size.width/2;
        tutorialFrame.origin.y = (self.gameZoneView.frame.origin.y + self.gameZoneView.frame.size.height);
        _tutorialLabel = [[UILabel alloc] initWithFrame:tutorialFrame];
        [_tutorialLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:18]];
        [_tutorialLabel setTextColor:[UIColor whiteColor]];
        [_tutorialLabel setTextAlignment:NSTextAlignmentCenter];
        [_tutorialLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_tutorialLabel setNumberOfLines:0];
        [_tutorialLabel setAlpha:0];
        [self.view addSubview:_tutorialLabel];
    }
    return _tutorialLabel;
}

- (CGFloat)gridSize {
    
    // Размер одного блока в точках
    if (_gridSize == 0) {
        
        CGFloat screenWidth = self.view.frame.size.width;
        CGFloat grid = GRID_SIZE;
        //      _gridSize = floor(screenWidth/(BLOCKS_IN_ROW+1)); // добавим 1, чтобы было место для рамки
        
        if (screenWidth < SCREEN_IPHONE6) {
            _gridSize = grid;           // =64pt for iPhone 4S,5,5S
            
        } else if (screenWidth >= SCREEN_IPHONE6 && screenWidth < SCREEN_IPAD) {
            _gridSize = grid + grid/8;  // =72pt for iPhone 6,6+
            
        } else if (screenWidth >= SCREEN_IPAD) {
            _gridSize = grid + grid/2;  // =96pt for iPad
        }
        
    }
    return _gridSize;
}

- (CGSize)radiusOfBorder {
    
    if (_radiusOfBorder.height == 0 && _radiusOfBorder.width == 0) {
        _radiusOfBorder = CGSizeMake(self.gridSize/4, self.gridSize/4);
    }
    return _radiusOfBorder;
    
}

- (CGSize)radiusOfInside{
    
    if (_radiusOfInside.height == 0 && _radiusOfInside.width == 0) {
        _radiusOfInside = CGSizeMake(floor(self.radiusOfBorder.width/2), floor(self.radiusOfBorder.height/2));
    }
    return _radiusOfInside;
}


- (NSMutableArray *)mixHistory {
    
    if (_mixHistory == nil) {
        _mixHistory = [[NSMutableArray alloc] init];
    }
    return _mixHistory;
}



#pragma mark PUZZLE

- (void)restartLevel {
    
    if ([self.gameZoneView.panGR numberOfTouches] || self.mixHistory.count == 0) { return; }
    
    // Восстановление уровня в пероначальное состояние
    [self.gameLevel setBlocks:[self.mixHistory firstObject]];
    [self setMixHistory:nil];
    [self setSolutionStep:0];
    [self.gameZoneView setupWithGameLevel:self.gameLevel];
    [self.gameLevel setJustNowSolved:NO];
    [self updateUI];
    [self.gameZoneView updateView];
    [self playSound:@"rewind"]; //@"restart"
    if (DEVMODE && self.dev_recSolutionMode) {
        [self setDev_recSolutionsArray:nil];
    }
}

- (void)saveMixHistory {
    
    // Сохранение состояния для истории
    NSMutableArray *copyBlocks = [[NSMutableArray alloc] init];
    
    for (RSColorBlock *block in self.gameLevel.blocks) {
        RSColorBlock *copyBlock = [[RSColorBlock alloc] init];
        [copyBlock setPosition:block.position];
        [copyBlock setColor:block.color];
        [copyBlock setMutualColorGroup:[RSGameLevel copyMutualColorGroup:block.mutualColorGroup]];
        [copyBlocks addObject:copyBlock];
    }
    [self.mixHistory addObject:copyBlocks];
}


- (void)loadMixHistory {
    
    if ([self.gameZoneView.panGR numberOfTouches] || self.mixHistory.count == 0) { return; }
    
    // Отмена последнего действия
    [self.gameLevel setBlocks:[self.mixHistory lastObject]];
    [self.mixHistory removeObject:[self.mixHistory lastObject]];
    [self.gameZoneView setupWithGameLevel:self.gameLevel];
    [self.gameLevel setJustNowSolved:NO];
    if (self.solutionStep > 0) {
        self.solutionStep--;
    }
    if (DEVMODE && self.dev_recSolutionMode) {
        [self.dev_recSolutionsArray removeObject:[self.dev_recSolutionsArray lastObject]];
    }
    [self updateUI];
    [self.gameZoneView updateView];
    [self playSound:@"rewind"];
}

- (void)prevLevel {
    
    if ([self.gameZoneView.panGR numberOfTouches]) { return; }
    
    // Перемещение уровня в режиме разработчика
    if (DEVMODE && self.dev_moveLevelMode) {
        RSGameLevel *curLevel = (RSGameLevel *)self.allLevels[self.currentLevel];
        RSGameLevel *prevLevel = (RSGameLevel *)self.allLevels[self.currentLevel-1];
        [self.allLevels replaceObjectAtIndex:self.currentLevel withObject:prevLevel];
        [self.allLevels replaceObjectAtIndex:self.currentLevel-1 withObject:curLevel];
    }
    
    // Предыдущий уровень
    if (self.currentLevel > 0) {
        self.currentLevel--;
        [self animatedChangeLevel:-1];
    }
}

- (void)nextLevel {
    
    if ([self.gameZoneView.panGR numberOfTouches]) { return; }
    
    // Перемещение уровня в режиме разработчика
    if (DEVMODE && self.dev_moveLevelMode) {
        RSGameLevel *curLevel = (RSGameLevel *)self.allLevels[self.currentLevel];
        RSGameLevel *prevLevel = (RSGameLevel *)self.allLevels[self.currentLevel+1];
        [self.allLevels replaceObjectAtIndex:self.currentLevel withObject:prevLevel];
        [self.allLevels replaceObjectAtIndex:self.currentLevel+1 withObject:curLevel];
    }
    
    // Следующий уровень
    if (self.currentLevel < self.solvedCount) {
        self.currentLevel++;
        
        if (self.lastLevelAvailableButNotOpened && self.currentLevel == self.solvedCount && self.currentLevel == LEVEL_SHOWRATEDIALOG) {
            [self showRateAppDialog];
        } else {
            [self animatedChangeLevel:+1];
        }
        
    } else if (self.currentLevel == [self.allLevels indexOfObject:[self.allLevels lastObject]]) {
        // Решен последний уровень
        if (!self.gameOver) {
            [YMMYandexMetrica reportEvent:evWIN onFailure:nil];
            [self reportAchievement:ACH_100];
            if (self.keysCount == 9) {
                [self reportAchievement:ACH_9KEYS];
            }
            [self setGameOver:YES];
        }
        [self showWinnerDialog];
    }
}

- (void)animatedChangeLevel:(float)delta {
    
    if (self.currentLevel+1 == LEVEL_TUTORIAL_HEX) {
        [self setHexShowed:NO];
    }
    [self.levelLabel setText:[NSString stringWithFormat:@"%i", (int)(self.currentLevel+1)]];
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.gameZoneView setAlpha:0.0];
        [self.hexLabel setAlpha:0.0];
        [self.okButton setAlpha:0.0];
        [self.tutorialLabel setAlpha:0.0];
        
    } completion:^(BOOL finished){
        
        [self.okButton setHidden:YES];
        
        if (self.currentLevel+1 != LEVEL_TUTORIAL_HEX) {
            [self.showHexButton.layer removeAllAnimations];
            [self.tutorialMiniButton.layer removeAllAnimations];
        }
        if (self.keyUsedButNotPlayed && self.currentLevel == self.solvedCount) {
            [self scaleAnimation:self.keyButton repeat:YES scale:1.2];
        } else if ([self.keyButton.layer animationKeys].count) {
            [self.keyButton.layer removeAllAnimations];
        }
        [self loadLevel:self.currentLevel];
        [self.gameZoneView setAlpha:0.0];  // т.к. loadlevel удаляет их и ставить 1.0
        [self.hexLabel setAlpha:0.0];      // т.к. loadlevel удаляет их и ставить 1.0
        [self.tutorialLabel setAlpha:0.0]; // т.к. loadlevel удаляет их и ставить 1.0
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.gameZoneView setAlpha:1.0];
            [self.hexLabel setAlpha:(self.hexShowed)?1:0];
            [self.tutorialLabel setAlpha:[self currentLevelIsTutorial]?1:0];
            [self.view bringSubviewToFront:self.okButton];
        }];
    }];
}

- (void)loadLevel:(NSInteger)levelIndex {
    
    // Загрузка игрового уровня
    for (UIView *view in [self.gameZoneView subviews]) {
        [view removeFromSuperview];
    }
    [self.gameZoneView removeFromSuperview];
    [self.hexLabel removeFromSuperview];
    [self.tutorialLabel removeFromSuperview];
    [self setGameZoneView:nil];
    [self setHexLabel:nil];
    [self setMixHistory:nil];
    [self setTutorialLabel:nil];
    [self setSolutionStep:0];
    [self setGameLevel:[RSGameLevel copyGameLevel:(RSGameLevel *)[self.allLevels objectAtIndex:self.currentLevel]]];
    [self.gameZoneView setupWithGameLevel:self.gameLevel];
    
//  not actual for Rigibi 1.1
//    if (!((self.currentLevel+1) % FREEKEY_LEVELSCOUNT) &&
//            self.currentLevel == self.solvedCount &&
//            self.lastLevelAvailableButNotOpened &&
//            self.keysCount != -1) {
//        self.keysCount ++;
//        [self playSound:@"key"];
//    }

    if (self.currentLevel == self.solvedCount && !self.gameOver) {
        if (self.lastLevelAvailableButNotOpened) {
            [self.timer reset];
            [self.timer start];
            [self setLastLevelAvailableButNotOpened:NO];
        } else {
            [self.timer start];
        }
    } else if (!self.gameOver) {
        [self.timer pause];
    }
    [self updateUI];
    [self saveUserDefaults];
}

- (void)helpPlease {
    
    if ([self.gameZoneView.panGR numberOfTouches]) { return; }
    
    if (self.currentLevel == self.solvedCount && !self.keyUsedButNotPlayed && !self.gameOver) {
        if (self.keysCount == 0) {
            [self showNoKeysDialog];
            return;
        } else if (self.keysCount !=-1) {
            self.keysCount--;
            [self playSound:@"unlock"];
            [self setKeyUsedButNotPlayed:YES];
            [self restartLevel];
            [self updateUI];
            [self scaleAnimation:self.keyButton repeat:YES scale:1.2];
            return;
        }
    }
    
    if (self.gameLevel.solutionSteps.count) {
        
        if (!self.solutionStep && self.mixHistory.count) {
            
            // Если мы не на старте,
            // то сначала надо сбросить уровень на старт
            [self restartLevel];
            
        } else {
            
            if ([self.keyButton.layer animationKeys].count) {
                [self.keyButton.layer removeAllAnimations];
            }
            // Берем текущий шаг решения загадки и выполняем его за игрока
            NSArray *solutionPositions = [self.gameLevel.solutionSteps objectAtIndex:self.solutionStep];
            CGPoint firstPosition = [(NSValue *)[solutionPositions firstObject] CGPointValue];
            CGPoint secondPosition = [(NSValue *)[solutionPositions lastObject] CGPointValue];
            RSColorBlock *firstBlock = [self.gameLevel blockOnPosition:firstPosition];
            RSColorBlock *secondBlock = [self.gameLevel blockOnPosition:secondPosition];
            self.solutionStep++;
            [self saveMixHistory];
            [self.gameZoneView mixBlock:firstBlock with:secondBlock];
        }
    } else {
        
        // Автоматическое решение уровня
        [self saveMixHistory];
        [self.gameLevel solveLevel];
        [self.gameZoneView updateView];
        [self checkForSolve];
    }
    [self updateUI];
}

- (BOOL)checkForSolve {
    
    // Не решен ли часом наш уровень?
    if ([self.gameLevel isSovledRight]) {
        
        [self playSound:@"win"];
        if (self.currentLevel == self.solvedCount) {
            
            [self reportScore];
            if (self.solvedCount+2 == 30) {
                [self reportAchievement:ACH_30];
            } else if (self.solvedCount+2 == 70) {
                [self reportAchievement:ACH_70];
            }
            
            NSString *time = [self stringFromDuration:self.timer.seconds];
            NSString *level = [NSString stringWithFormat:@"%@ %02i", evLEVEL, (int)self.solvedCount+1];
            [YMMYandexMetrica reportEvent:evTIME parameters:@{time:level} onFailure:nil];
            [YMMYandexMetrica reportEvent:evSOLVED parameters:@{level:@""} onFailure:nil];
            if (self.keyUsedButNotPlayed) {
                [YMMYandexMetrica reportEvent:evKEYUSED parameters:@{level:@""} onFailure:nil];
            }
            if (self.currentLevel != [self.allLevels indexOfObject:[self.allLevels lastObject]]) {
                self.solvedCount ++;
                [self.gameLevel setJustNowSolved:YES];
                [self setLastLevelAvailableButNotOpened:YES];
                [self saveUserDefaults];
            }
            [self setKeyUsedButNotPlayed:NO];
            if ([self.keyButton.layer animationKeys].count) {
                [self.keyButton.layer removeAllAnimations];
            }
            [self.timer reset];
        }
        [self updateUI];
        return YES;
    }
    return NO;
}

- (BOOL)currentLevelIsTutorial {
    
    NSMutableArray *tutorialStrings = [[NSMutableArray alloc] init];
    [tutorialStrings addObject:[[NSString stringWithFormat:@"%i%@", LEVEL_TUTORIAL_SWIPE, @"%"] stringByAppendingString:NSLocalizedString(@"TUTORIAL_SWIPE", nil)]];
    [tutorialStrings addObject:[[NSString stringWithFormat:@"%i%@", LEVEL_TUTORIAL_BORDER, @"%"]  stringByAppendingString:NSLocalizedString(@"TUTORIAL_BORDER", nil)]];
    
    if (self.hexShowed) {
        [tutorialStrings addObject:[[NSString stringWithFormat:@"%i%@", LEVEL_TUTORIAL_HEX, @"%"]  stringByAppendingString:NSLocalizedString(@"TUTORIAL_HEX_2", nil)]];
    } else {
        [tutorialStrings addObject:[[NSString stringWithFormat:@"%i%@", LEVEL_TUTORIAL_HEX, @"%"]  stringByAppendingString:NSLocalizedString(@"TUTORIAL_HEX_1", nil)]];
    }
    
//    Not actual for Rigibi 1.1
//    NSString *tutorialFreeKey = NSLocalizedString(@"TUTORIAL_FREEKEY", nil);
//    tutorialFreeKey = [tutorialFreeKey stringByReplacingOccurrencesOfString:@"*FREEKEY_LEVELSCOUNT*" withString:[NSString stringWithFormat:@"%i", FREEKEY_LEVELSCOUNT]];
//    [tutorialStrings addObject:[@"10%" stringByAppendingString:tutorialFreeKey]];
    
    for (NSString *tutorialString in tutorialStrings) {
        NSArray *components = [tutorialString componentsSeparatedByString:@"%"];
        if ([(NSString *)components[0] integerValue] == self.currentLevel+1) {
            [self.tutorialLabel setText:(NSString *)components[1]];
            return YES;
        }
    }
    [self.tutorialLabel setText:nil];
    return NO;
}


#pragma mark VIEWCONTROLLER

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadLevelsData];
    [self loadUserDefaults];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.gameZoneView setupWithGameLevel:self.gameLevel];
    [self setupUI];
    [[SoundManager sharedManager] prepareToPlay];
    [self authenticateLocalPlayer];
    
    [self.helpView setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.noKeysDialogView getInAppProducts];
    
    if (self.currentLevel+1 == LEVEL_TUTORIAL_HEX) {
        [self scaleAnimation:self.showHexButton repeat:YES scale:1.4];
    }
    [self.timer start];
}

- (void)authenticateLocalPlayer{
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            if (viewController) {
                [self presentViewController:viewController animated:YES completion:nil];
            } else {
                self.gameCenterEnabled = [GKLocalPlayer localPlayer].authenticated;
            }
        }
    };
}

- (void)reportScore {
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:LEADEARBOARD_ID];
    score.value = self.solvedCount+1;
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)reportAchievement:(NSString *)identifier {
    
    GKAchievement *levelAchievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    levelAchievement.percentComplete = 100.0;
    levelAchievement.showsCompletionBanner = YES;
    [GKAchievementDescription placeholderCompletedAchievementImage];
    [GKAchievement reportAchievements:@[levelAchievement] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)resetAchievements {
    
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void)showRateAppDialog {
    
    CGRect frameOfRateDialog = self.view.frame;
    self.rateAppDialogView = [[RSRateAppDialogView alloc] initWithFrame:frameOfRateDialog];
    [self.rateAppDialogView setDelegate:self];
    [self.rateAppDialogView setup];
    [self.timer pause];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setAlpha:0.0];
    } completion:^(BOOL finished){
        [self.view addSubview:self.rateAppDialogView];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setAlpha:1.0];
        }];
    }];
}

- (void)showWinnerDialog {
    
    CGRect frameOfWinnerDialog = self.view.frame;
    self.winnerDialogView = [[RSWinnerDialogView alloc] initWithFrame:frameOfWinnerDialog];
    [self.winnerDialogView setDelegate:self];
    [self.winnerDialogView setup];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setAlpha:0.0];
    } completion:^(BOOL finished){
        [self.view addSubview:self.winnerDialogView];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setAlpha:1.0];
            [self playSound:@"gameover"];
        }];
    }];
}

- (void)showNoKeysDialog {
    
    // Делаем скриншот головоломки для FB & TW
    CGRect rectOfSnapshot = CGRectMake(0, -(self.view.bounds.size.height/2 - self.view.bounds.size.width/2), self.view.bounds.size.width, self.view.bounds.size.height);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width), NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:rectOfSnapshot afterScreenUpdates:YES];
    UIImage *shareImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.noKeysDialogView setSnapshotOfPuzzle:shareImage];
    [self.timer pause];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.noKeysDialogView getInAppProducts];
        [self.noKeysDialogView setHidden:NO];
        [self.view bringSubviewToFront:self.noKeysDialogView];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setAlpha:1.0];
        }];
    }];
}

- (void)hideDialog {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.view setAlpha:0.0];
        
    } completion:^(BOOL finished){
        
        if (self.rateAppDialogView) {
            [self loadLevel:self.currentLevel];
            [self.rateAppDialogView removeFromSuperview];
            [self setRateAppDialogView:nil];
            [self.timer start];
        } else if (self.winnerDialogView) {
            [self.winnerDialogView removeFromSuperview];
            [self setWinnerDialogView:nil];
            [self restartLevel];
        } else { // NoKeysDialog or HelpView
            self.noKeysDialogView.hidden = YES;
            self.helpView.hidden = YES;
            [self.timer start];
        }
        [self.view bringSubviewToFront:self.okButton];
        [self updateUI];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setAlpha:1.0];
        } completion:^(BOOL finished){
            [self updateUI];
        }];
    }];
}

- (void)switchSound {
    
    [self setSoundOn:!self.soundOn];
    [self updateUI];
}

- (void)showOrHideHex {
    
    [self setHexShowed:!self.hexShowed];
    [self.gameZoneView updateView];
    [UIView animateWithDuration:0.3 animations:^{
        [self.hexLabel setAlpha:(self.hexShowed)?1:0];
    }];
    [self updateUI];
}

- (void)longPressOnEye:(UIGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self showHexView];
    }
}

- (void)showHexView {
    [self.timer pause];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.helpView setHidden:NO];
        [self.helpView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [self.view bringSubviewToFront:self.helpView];
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setAlpha:1.0];
        }];
    }];
}

- (void)scaleAnimation:(UIView *)sender repeat:(BOOL)repeat scale:(float)scale {
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = .5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:scale];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = (repeat)?FLT_MAX:1;
    [sender.layer addAnimation:pulseAnimation forKey:@"scale"];
}


- (void)updateUI {
    
    // Обновление внешнего вида интерфейса
    BOOL levelIsSolvedRight = [self.gameLevel isSovledRight];
    BOOL levelIsSolved = [self.gameLevel isSovled];
    [self.restartButton setEnabled:[self.mixHistory count]];
    [self.backButton setEnabled:[self.mixHistory count]];
    [self.keyButton setEnabled:(levelIsSolvedRight || (self.gameLevel.solutionSteps.count > 0 && self.solutionStep == self.gameLevel.solutionSteps.count))?NO:YES];
    [self.keysCountLabel setEnabled:self.keyButton.isEnabled];
    [self.levelLabel setText:[NSString stringWithFormat:@"%i", (int)(self.currentLevel+1)]];
    [self.prevButton setHidden:(self.currentLevel == 0)?YES:NO];
    [self.nextButton setHidden:(self.currentLevel == self.solvedCount || self.currentLevel == [self.allLevels indexOfObject:[self.allLevels lastObject]])?YES:NO];
    [self.hexLabel setAlpha:(self.hexShowed)?1:0];
    [self.hexLabel setText:[NSString stringWithFormat:@"%@",self.gameLevel.targetColor.hexFromColor]];
    [self.hexLabel setTextColor:self.gameLevel.targetColor];
    [self.soundButton setImage:[UIImage imageNamed:(self.soundOn)?@"sound_on":@"sound_off"] forState:UIControlStateNormal];
    [self.showHexButton setImage:[UIImage imageNamed:(self.hexShowed)?@"eye_full":@"eye"] forState:UIControlStateNormal];
    
    
    if (levelIsSolvedRight && [self.okButton isHidden]) {
        [self.okButton setImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
        [self.okButton removeTarget:self action:@selector(restartLevel) forControlEvents:UIControlEventTouchUpInside];
        [self.okButton addTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];
        [self.okButton setHidden:NO];
        [self scaleAnimation:self.okButton repeat:YES scale:1.2];
        [UIView animateWithDuration:0.3 animations:^{
            [self.okButton setAlpha:1.0];
        }];
    } else if (levelIsSolved && !levelIsSolvedRight && [self.okButton isHidden]) {
        [self.okButton setImage:[UIImage imageNamed:@"recycle"] forState:UIControlStateNormal];
        [self.okButton removeTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];
        [self.okButton addTarget:self action:@selector(restartLevel) forControlEvents:UIControlEventTouchUpInside];
        [self.okButton setHidden:NO];
        [self.okButton setAlpha:0.0];
        [UIView animateWithDuration:0.3 animations:^{
            [self.okButton setAlpha:1.0];
        }];
    } else if (!levelIsSolved && ![self.okButton isHidden]) {
        [self.okButton setAlpha:0.0];
        [self.okButton setHidden:YES];
        [self.okButton.layer removeAllAnimations];
    }
    if ([self.okButton isHidden]) {
        [self.okButton.layer removeAllAnimations];
    }
    
    NSInteger keysCountChange = self.keysCount - [self.keysCountLabel.text integerValue];
    
    if (keysCountChange > 0 && self.currentLevel == self.solvedCount) {
        
        [self.keyButton setImage:[UIImage imageNamed:@"key"] forState:UIControlStateNormal];
        [self.keysCountLabel setHidden:NO];
        [self scaleAnimation:self.keyButton repeat:NO scale:1.4];
        [UIView animateWithDuration:0.3 animations:^{
            [self.keysCountLabel setAlpha:0.0];
        } completion:^(BOOL finished){
            [self.keysCountLabel setText:[NSString stringWithFormat:@"%i", (int)(self.keysCount)]];
            [UIView animateWithDuration:0.3 animations:^{
                [self.keysCountLabel setAlpha:1.0];
            }];
        }];
        
    } else if (keysCountChange < 0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.keyButton setAlpha:0.0];
            [self.keysCountLabel setAlpha:0.0];
        } completion:^(BOOL finished){
            [self.keysCountLabel setText:[NSString stringWithFormat:@"%i", (int)(self.keysCount)]];
            [self.keyButton setImage:[UIImage imageNamed:@"wizard"] forState:UIControlStateNormal];
            [self.keysCountLabel setHidden:YES];
            [self.keysCountLabel setAlpha:1.0];
            [UIView animateWithDuration:0.2 animations:^{
                [self.keyButton setAlpha:1.0];
            }];
        }];
        
    } else if (self.gameLevel.justNowSolved == NO) {
        
        [self.keysCountLabel setText:[NSString stringWithFormat:@"%i", (int)(self.keysCount)]];
        
        if (self.keysCount == -1 || self.currentLevel != self.solvedCount || (self.keyUsedButNotPlayed && self.currentLevel == self.solvedCount) || self.gameOver) {
            
            if (![self.keysCountLabel isHidden]) {
                [UIView animateWithDuration:0.2 animations:^{
                    [self.keyButton setAlpha:0.0];
                    [self.keysCountLabel setAlpha:0.0];
                } completion:^(BOOL finished){
                    [self.keyButton setImage:[UIImage imageNamed:@"wizard"] forState:UIControlStateNormal];
                    [self.keysCountLabel setHidden:YES];
                    [self.keysCountLabel setAlpha:1.0];
                    [UIView animateWithDuration:0.2 animations:^{
                        [self.keyButton setAlpha:1.0];
                    }];
                }];
            }
            
        } else if ([self.keysCountLabel isHidden]) {
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.keyButton setAlpha:0.0];
            } completion:^(BOOL finished){
                [self.keyButton setImage:[UIImage imageNamed:@"key"] forState:UIControlStateNormal];
                [self.keysCountLabel setHidden:NO];
                [self.keysCountLabel setAlpha:0.0];
                [UIView animateWithDuration:0.2 animations:^{
                    [self.keyButton setAlpha:1.0];
                    [self.keysCountLabel setAlpha:1.0];
                }];
            }];
        }
    }
    
    if (self.currentLevel+1 == LEVEL_TUTORIAL_HEX) {
        
        if (!self.hexShowed && ![self.tutorialLabel.text isEqual:NSLocalizedString(@"TUTORIAL_HEX_1", nil)]) {
            
            [self makeSnapshotOfTutorialLabel];
            [self scaleAnimation:self.showHexButton repeat:YES scale:1.4];
            [self currentLevelIsTutorial];
            [self showCircleOnView:self.showHexButton];
            [UIView animateWithDuration:0.3 animations:^{
                [self.snapshotTutorialView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [self.snapshotTutorialView removeFromSuperview];
                [self setSnapshotTutorialView:nil];
            }];
            
        } else if (self.hexShowed && ![self.tutorialLabel.text isEqual:NSLocalizedString(@"TUTORIAL_HEX_2", nil)]) {
            
            [self makeSnapshotOfTutorialLabel];
            [self.showHexButton.layer removeAllAnimations];
            [self currentLevelIsTutorial];
            [self scaleAnimation:self.tutorialMiniButton repeat:YES scale:1.4];
            [self showCircleOnView:self.tutorialMiniButton];
            [UIView animateWithDuration:0.3 animations:^{
                [self.snapshotTutorialView setAlpha:0.0];
            } completion:^(BOOL finished) {
                [self.snapshotTutorialView removeFromSuperview];
                [self setSnapshotTutorialView:nil];
            }];
        }
    }
    
    if (self.hexShowed && [self.tutorialMiniButton isHidden]) {
        
        [self.tutorialMiniButton setHidden:NO];
        [self.tutorialMiniButton setAlpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            [self.soundButton setAlpha:0];
            [self.tutorialMiniButton setAlpha:1];
        } completion:^(BOOL finished){
            [self.soundButton setHidden:YES];
        }];
        
    } else if (!self.hexShowed && [self.soundButton isHidden]) {
        
        [self.soundButton setHidden:NO];
        [self.soundButton setAlpha:0];
        [UIView animateWithDuration:0.3 animations:^{
            [self.tutorialMiniButton setAlpha:0];
            [self.soundButton setAlpha:1];
        } completion:^(BOOL finished){
            [self.tutorialMiniButton setHidden:YES];
        }];
    }

    
    if (DEVMODE) {
        [self.soundButton setHidden:YES];
        [self.devButton_switchDevMode setImage:[UIImage imageNamed:(self.devModeSelected)?@"play":@"mixer"] forState:UIControlStateNormal];
        [self.devButton_unmixMode setImage:[UIImage imageNamed:(self.dev_unmixMode)?@"unmix":@"mix"] forState:UIControlStateNormal];
        [self.devButton_recSolution setImage:[UIImage imageNamed:(self.dev_recSolutionMode)?@"key_recon":(self.gameLevel.solutionSteps.count)?@"key_recoff":@"key_recempty"] forState:UIControlStateNormal];
        [self.devButton_changeSize setHidden:!self.devModeSelected||self.dev_recSolutionMode];
        [self.devButton_generatePuzzle setHidden:!self.devModeSelected||self.dev_recSolutionMode];
        [self.devButton_saveLevels setHidden:!self.devModeSelected||self.dev_recSolutionMode];
        [self.devButton_setTargetColor setHidden:!self.devModeSelected||self.dev_recSolutionMode];
        [self.devButton_unmixMode setHidden:!self.devModeSelected||self.dev_recSolutionMode];
        [self.devButton_recSolution setHidden:!self.devModeSelected];
        [self.restartButton setHidden:self.devModeSelected && !self.dev_recSolutionMode];
        [self.backButton setHidden:self.devModeSelected && !self.dev_recSolutionMode];
        [self.keyButton setHidden:self.devModeSelected];
        [self.okButton setHidden:self.devModeSelected];
        [self.okButton setHidden:self.devModeSelected];
        
        [self.devButton_switchDevMode setHidden:self.dev_recSolutionMode];
        [self.nextButton setHidden:self.dev_recSolutionMode || self.currentLevel == [self.allLevels indexOfObject:[self.allLevels lastObject]]];
        [self.nextButton setBackgroundColor:(self.dev_moveLevelMode)?[UIColor redColor]:[UIColor clearColor]];
        [self.prevButton setHidden:(self.dev_recSolutionMode || self.currentLevel == 0)];
        [self.prevButton setBackgroundColor:(self.dev_moveLevelMode)?[UIColor redColor]:[UIColor clearColor]];
    }
}

- (void)showCircleOnView:(UIView *)view {
    
    CGRect circleRect = view.frame;
    circleRect.origin.x -= circleRect.size.width;
    circleRect.origin.y -= circleRect.size.height;
    circleRect.size.height *=3;
    circleRect.size.width *=3;
    UIView *circleView = [[UIView alloc] initWithFrame:circleRect];
    circleView.layer.cornerRadius = circleRect.size.width/2;
    circleView.alpha = 0;
    circleView.tag = 666;
    circleView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self.view insertSubview:circleView atIndex:0];
    [self scaleAnimation:circleView repeat:YES scale:1.4];
    
    [UIView animateWithDuration:0.6 animations:^{
        [circleView setAlpha:1.0];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.6 animations:^{
            [circleView setAlpha:0.0];
        } completion:^(BOOL finished){
            [circleView removeFromSuperview];
        }];
    }];
}

- (void)makeSnapshotOfTutorialLabel {
    
    [self.tutorialLabel setBackgroundColor:[UIColor blackColor]];
    UIGraphicsBeginImageContextWithOptions(self.tutorialLabel.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.tutorialLabel.layer renderInContext:context];
    [self.tutorialLabel setBackgroundColor:[UIColor clearColor]];
    self.snapshotTutorialView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    [self.snapshotTutorialView setFrame:self.tutorialLabel.frame];
    [self.view addSubview:self.snapshotTutorialView];
}

- (void)setupUI {
    
    CGFloat screenSize = self.view.frame.size.width;
    
    // Кнопка рестарта уровня
    CGRect frameOfRestartButton = CGRectZero;
    frameOfRestartButton.size = CGSizeMake(self.gridSize, self.gridSize);
    frameOfRestartButton.origin.x = (self.view.frame.size.width - self.gridSize*4)/2;
    frameOfRestartButton.origin.y = (self.view.frame.size.height/2 + (self.gridSize*(BLOCKS_IN_ROW+1))/2) + (self.view.frame.size.height - (self.view.frame.size.height/2 + (self.gridSize*(BLOCKS_IN_ROW+1))/2)) /2 - (self.gridSize + self.gridSize/4)/2;
    self.restartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.restartButton setFrame:frameOfRestartButton];
    [self.restartButton setImage:[UIImage imageNamed:@"recycle"] forState:UIControlStateNormal];
    [self.restartButton setTintColor:[UIColor whiteColor]];
    [self.restartButton addTarget:self action:@selector(restartLevel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.restartButton];
    
    // Кнопка отмены действия
    CGRect frameOfBackButton = CGRectZero;
    frameOfBackButton.size = CGSizeMake(self.gridSize, self.gridSize);
    frameOfBackButton.origin.x = frameOfRestartButton.origin.x + self.gridSize*1.5;
    frameOfBackButton.origin.y = frameOfRestartButton.origin.y;
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setFrame:frameOfBackButton];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton setTintColor:[UIColor whiteColor]];
    [self.backButton addTarget:self action:@selector(loadMixHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setEnabled:NO];
    [self.view addSubview:self.backButton];
    
    // Кнопка решения уровня
    CGRect frameOfKeyButton = CGRectZero;
    frameOfKeyButton.size = CGSizeMake(self.gridSize, self.gridSize);
    frameOfKeyButton.origin.x = frameOfBackButton.origin.x + self.gridSize*1.5;
    frameOfKeyButton.origin.y = frameOfBackButton.origin.y;
    self.keyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.keyButton setFrame:frameOfKeyButton];
    [self.keyButton setImage:[UIImage imageNamed:(self.keysCount < 0)?@"wizard":@"key"] forState:UIControlStateNormal];
    [self.keyButton setTintColor:[UIColor whiteColor]];
    [self.keyButton addTarget:self action:@selector(helpPlease) forControlEvents:UIControlEventTouchUpInside];
    [self.keyButton setClipsToBounds:NO];
    [self.view addSubview:self.keyButton];
    
    // Количество ключей
    self.keysCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.keysCountLabel setTextAlignment:NSTextAlignmentRight];
    [self.keysCountLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:12]];
    [self.keysCountLabel setTextColor:[UIColor whiteColor]];
    [self.keysCountLabel setText:[NSString stringWithFormat:@"%i",(int)self.keysCount]];
    self.keysCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.keysCountLabel.numberOfLines = 0;
    [self.keysCountLabel sizeToFit];
    CGRect frameOfKeysCountLabel = self.keysCountLabel.frame;
    frameOfKeysCountLabel.size.width = self.keyButton.imageView.frame.size.width/2;
    frameOfKeysCountLabel.origin.x = self.keyButton.imageView.frame.origin.x + self.keyButton.imageView.frame.size.width - frameOfKeysCountLabel.size.width;
    frameOfKeysCountLabel.origin.y = 4+self.keyButton.imageView.frame.origin.y + self.keyButton.imageView.frame.size.height - frameOfKeysCountLabel.size.height;;
    [self.keysCountLabel setFrame:frameOfKeysCountLabel];
    [self.keysCountLabel setHidden:(self.keysCount < 0)];
    [self.keyButton addSubview:self.keysCountLabel];
    
    // Кнопка предыдущего уровня
    CGRect frameOfPrevButton = CGRectZero;
    frameOfPrevButton.size = CGSizeMake(self.gridSize, self.gridSize);
    frameOfPrevButton.origin.x = self.view.frame.size.width/2 - self.gridSize*3/2;
    frameOfPrevButton.origin.y = (self.view.frame.size.height/2 - (self.gridSize*(BLOCKS_IN_ROW+1))/2)/2 - (self.gridSize-self.gridSize/4)/2;
    if (screenSize >= SCREEN_IPAD) {
        frameOfPrevButton.origin.y = 0;
    }
    self.prevButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.prevButton setFrame:frameOfPrevButton];
    [self.prevButton setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [self.prevButton setTintColor:[UIColor whiteColor]];
    [self.prevButton addTarget:self action:@selector(prevLevel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.prevButton];
    
    // Кнопка следующего уровня
    CGRect frameOfNextButton = CGRectZero;
    frameOfNextButton.size = CGSizeMake(self.gridSize, self.gridSize);
    frameOfNextButton.origin.x = self.view.frame.size.width/2 - self.gridSize*3/2 + self.gridSize*2;
    frameOfNextButton.origin.y = frameOfPrevButton.origin.y;
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextButton setFrame:frameOfNextButton];
    [self.nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self.nextButton setTintColor:[UIColor whiteColor]];
    [self.nextButton addTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    // Номер текущего уровня
    CGRect frameOfLevelLabel = CGRectZero;
    frameOfLevelLabel.size = CGSizeMake(self.gridSize, self.gridSize);
    frameOfLevelLabel.origin.x = self.view.frame.size.width/2 - self.gridSize*3/2 + self.gridSize;
    frameOfLevelLabel.origin.y = frameOfPrevButton.origin.y;
    self.levelLabel = [[UILabel alloc] initWithFrame:frameOfLevelLabel];
    [self.levelLabel setTextAlignment:NSTextAlignmentCenter];
    [self.levelLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:16]];
    [self.levelLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.levelLabel];
    
    // Кнопка вкл./выкл. звука
    CGRect frameOfSoundButton = CGRectZero;
    frameOfSoundButton.origin.x = 0;
    frameOfSoundButton.origin.y = 0;
    if (screenSize < SCREEN_IPHONE6) {
        frameOfSoundButton.size = CGSizeMake(self.gridSize/1.5, self.gridSize/1.5);
    } else if (screenSize >= SCREEN_IPHONE6) {
        frameOfSoundButton.size = CGSizeMake(self.gridSize, self.gridSize);
    }
    self.soundButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.soundButton setFrame:frameOfSoundButton];
    [self.soundButton setImage:[UIImage imageNamed:@"sound_on"] forState:UIControlStateNormal];
    [self.soundButton setTintColor:[UIColor whiteColor]];
    [self.soundButton addTarget:self action:@selector(switchSound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.soundButton];
    [self setSoundOn:YES];
    
    // Кнопка подсказок с HEX кодами цветов
    CGRect frameOfHexButton = CGRectZero;
    frameOfHexButton.size = frameOfSoundButton.size;
    frameOfHexButton.origin.x = self.view.frame.size.width - frameOfHexButton.size.width;
    frameOfHexButton.origin.y = frameOfSoundButton.origin.y;
    self.showHexButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showHexButton setFrame:frameOfHexButton];
    [self.showHexButton setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [self.showHexButton setTintColor:[UIColor whiteColor]];
    [self.showHexButton addTarget:self action:@selector(showOrHideHex) forControlEvents:
     UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnEye:)];
    [self.showHexButton addGestureRecognizer:longPress];
    [self.view addSubview:self.showHexButton];
    
    // Кнопка помощи по HEX кодам
    CGRect frameOfHelpButton = frameOfHexButton;
    frameOfHelpButton.origin.x -= frameOfHelpButton.size.width;
    self.tutorialMiniButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.tutorialMiniButton setFrame:frameOfSoundButton];
    [self.tutorialMiniButton setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [self.tutorialMiniButton setTintColor:[UIColor whiteColor]];
    [self.tutorialMiniButton addTarget:self action:@selector(showHexView) forControlEvents:UIControlEventTouchUpInside];
    [self.tutorialMiniButton setHidden:YES];
    [self.view addSubview:self.tutorialMiniButton];
    
    
    // Кнопка успешного прохождения уровня
    CGRect frameOfOkButton = CGRectMake(self.view.frame.size.width/2 - self.gridSize*2/2, self.view.frame.size.height/2 - self.gridSize*2/2, self.gridSize*2, self.gridSize*2);
    self.okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.okButton setFrame:frameOfOkButton];
    [self.okButton setTintColor:[UIColor whiteColor]];
    [self.okButton setHidden:YES];
    [self.view addSubview:self.okButton];
    
    if (DEVMODE) {
        [self dev_setup];
    }
    
    [self.tutorialLabel setAlpha:[self currentLevelIsTutorial]?1:0];
    [self updateUI];
}

- (void)saveUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (DEVMODE) {
        [userDefaults setInteger:self.currentLevel forKey:kCurrentLevel];
    } else {
        [userDefaults setInteger:self.solvedCount forKey:kSolvedCount];
        [userDefaults setInteger:self.keysCount forKey:kKeysCount];
        [userDefaults setInteger:self.timer.seconds forKey:kTimerSeconds];
        [userDefaults setBool:self.keyUsedButNotPlayed forKey:kKeyUsedButNotPlayed];
        [userDefaults setBool:self.sharedFacebook forKey:kSharedFacebook];
        [userDefaults setBool:self.sharedTwitter forKey:kSharedTwitter];
        [userDefaults setBool:self.gameOver forKey:kGameOver];
    }
    [userDefaults synchronize];
}

- (void)loadUserDefaults {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (DEVMODE) {
        [self setKeysCount:-1];
        [self setSolvedCount:self.allLevels.count-1];
        [self setCurrentLevel:[userDefaults integerForKey:kCurrentLevel]];
    } else {
        [self setSolvedCount:(AUTOLEVEL)?AUTOLEVEL-1:[userDefaults integerForKey:kSolvedCount]];
        [self setCurrentLevel:self.solvedCount];
        [self setKeysCount:(AUTOKEYS)?AUTOKEYS:[userDefaults integerForKey:kKeysCount]];
        [self setKeyUsedButNotPlayed:[userDefaults boolForKey:kKeyUsedButNotPlayed]];
        [self setSharedFacebook:[userDefaults boolForKey:kSharedFacebook]];
        [self setSharedTwitter:[userDefaults boolForKey:kSharedTwitter]];
        [self setGameOver:[userDefaults boolForKey:kGameOver]];
        [self.timer setSeconds:[userDefaults integerForKey:kTimerSeconds]];
    }
}

- (void)loadLevelsData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [userDefaults objectForKey:kDevLevels];
    if (myEncodedObject) {
        [self setAllLevels:[[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject] mutableCopy]];
        
    } else {
        myEncodedObject = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]
                                                          stringByAppendingPathComponent:LEVELSFILE]];
        if (!myEncodedObject) {
            NSLog(@"99levels.xml not found");
        }
        [self setAllLevels:[[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject] mutableCopy]];
        [self saveLevelsData];
    }
}

- (void)saveLevelsData {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.allLevels];
    [userDefaults setObject:myEncodedObject forKey:kDevLevels];
    [userDefaults synchronize];
    if (DEVMODE) {
        [self dev_exportLevelsToXML];
    }
}

- (void)playSound:(NSString *)soundName {
    
    if (self.soundOn) {
        soundName = [soundName stringByAppendingString:@".mp3"];
        [[SoundManager sharedManager] playSound:soundName looping:NO];
    }
}

- (void)rateApp {
    NSString *rateUrl = [NSString stringWithFormat:  @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%i&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", APP_STORE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateUrl]];
}

- (NSString *)stringFromDuration:(NSInteger)duration {
    
    NSString *durationString = @"0s";
    
    if (duration < 5) {
        durationString = @"< 5s";
    } else if (duration < 30) {
        durationString = @"5s - 30s";
    } else if (duration < 60) {
        durationString = @"30s - 1m";
    } else if (duration < 60*2) {
        durationString = @"1m - 2m";
    } else if (duration < 60*5) {
        durationString = @"2m - 5m";
    } else if (duration < 60*10) {
        durationString = @"5m - 10m";
    } else if (duration < 60*15) {
        durationString = @"10m - 15m";
    } else if (duration < 60*30) {
        durationString = @"15m - 30m";
    } else {
        durationString = @"30m - ...";
    }
    return durationString;
}


#pragma mark DEVMODE

// Режим разработчика для создания уровней

- (NSMutableArray *)dev_recSolutionsArray {
    
    if (!_dev_recSolutionsArray) {
        _dev_recSolutionsArray = [[NSMutableArray alloc] init];
    }
    return _dev_recSolutionsArray;
}

- (void)dev_setup {
    
    // Кнопка переключения из игрового режима в режим разработки
    CGRect frameOfDevModeButton = self.soundButton.frame;
    self.devButton_switchDevMode = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_switchDevMode setFrame:frameOfDevModeButton];
    [self.devButton_switchDevMode setImage:[UIImage imageNamed:@"mixer"] forState:UIControlStateNormal];
    [self.devButton_switchDevMode setTintColor:[UIColor whiteColor]];
    [self.devButton_switchDevMode addTarget:self action:@selector(dev_switchDevMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_switchDevMode];
    
    // Кнопка режима перемещения уровня
    CGRect frameOfMoveLevelButton = self.levelLabel.frame;
    self.devButton_switchMoveLevelMode = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_switchMoveLevelMode setFrame:frameOfMoveLevelButton];
    [self.devButton_switchMoveLevelMode addTarget:self action:@selector(dev_switchMoveLevelMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_switchMoveLevelMode];
    
    // Кнопка генерации болванки уровня
    CGRect frameOfGenerateButton = CGRectZero;
    frameOfGenerateButton.size = CGSizeMake(DEV_BUTTON_SIZE, DEV_BUTTON_SIZE);
    frameOfGenerateButton.origin.x = (self.view.frame.size.width - DEV_BUTTON_SIZE*6)/2;
    frameOfGenerateButton.origin.y = (self.view.frame.size.height/2 + self.view.frame.size.width /2) + (self.view.frame.size.height - (self.view.frame.size.height/2 + self.view.frame.size.width /2)) /2 - DEV_BUTTON_SIZE/2;;
    self.devButton_generatePuzzle = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_generatePuzzle setFrame:frameOfGenerateButton];
    [self.devButton_generatePuzzle setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    [self.devButton_generatePuzzle setTintColor:[UIColor whiteColor]];
    [self.devButton_generatePuzzle addTarget:self action:@selector(dev_generate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_generatePuzzle];
    
    // Кнопка изменения размера уровня
    CGRect frameOfSizeButton = CGRectZero;
    frameOfSizeButton.size = CGSizeMake(DEV_BUTTON_SIZE, DEV_BUTTON_SIZE);
    frameOfSizeButton.origin.x = frameOfGenerateButton.origin.x + DEV_BUTTON_SIZE;
    frameOfSizeButton.origin.y = frameOfGenerateButton.origin.y;
    self.devButton_changeSize = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_changeSize setFrame:frameOfSizeButton];
    [self.devButton_changeSize setImage:[UIImage imageNamed:@"size"] forState:UIControlStateNormal];
    [self.devButton_changeSize setTintColor:[UIColor whiteColor]];
    [self.devButton_changeSize addTarget:self action:@selector(dev_changeSize) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_changeSize];
    
    // Переключатель режима смешивания: смешивать или раскладывать цвет
    CGRect frameOfUnmixButton = CGRectZero;
    frameOfUnmixButton.size = CGSizeMake(DEV_BUTTON_SIZE, DEV_BUTTON_SIZE);
    frameOfUnmixButton.origin.x = frameOfGenerateButton.origin.x + DEV_BUTTON_SIZE*2;
    frameOfUnmixButton.origin.y = frameOfGenerateButton.origin.y;
    self.devButton_unmixMode = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_unmixMode setFrame:frameOfUnmixButton];
    [self.devButton_unmixMode setImage:[UIImage imageNamed:@"mix"] forState:UIControlStateNormal];
    [self.devButton_unmixMode setTintColor:[UIColor whiteColor]];
    [self.devButton_unmixMode addTarget:self action:@selector(dev_switchUnmixMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_unmixMode];
    
    // Кнопка установки целевого цвеа уровня
    CGRect frameOfTargetButton = CGRectZero;
    frameOfTargetButton.size = CGSizeMake(DEV_BUTTON_SIZE, DEV_BUTTON_SIZE);
    frameOfTargetButton.origin.x = frameOfGenerateButton.origin.x + DEV_BUTTON_SIZE*3;
    frameOfTargetButton.origin.y = frameOfGenerateButton.origin.y;
    self.devButton_setTargetColor = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_setTargetColor setFrame:frameOfTargetButton];
    [self.devButton_setTargetColor setImage:[UIImage imageNamed:@"target"] forState:UIControlStateNormal];
    [self.devButton_setTargetColor setTintColor:[UIColor whiteColor]];
    [self.devButton_setTargetColor addTarget:self action:@selector(dev_setTargetColor) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_setTargetColor];
    
    // Кнопка записи решения уровня
    CGRect frameOfRecButton = CGRectZero;
    frameOfRecButton.size = CGSizeMake(DEV_BUTTON_SIZE, DEV_BUTTON_SIZE);
    frameOfRecButton.origin.x = frameOfGenerateButton.origin.x + DEV_BUTTON_SIZE*4;
    frameOfRecButton.origin.y = frameOfGenerateButton.origin.y;
    self.devButton_recSolution = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_recSolution setFrame:frameOfRecButton];
    [self.devButton_recSolution setImage:[UIImage imageNamed:@"key_recempty"] forState:UIControlStateNormal];
    [self.devButton_recSolution setTintColor:[UIColor whiteColor]];
    [self.devButton_recSolution addTarget:self action:@selector(dev_recSolution) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_recSolution];
    
    // Кнопка сохранения уровней
    CGRect frameOfSaveButton = CGRectZero;
    frameOfSaveButton.size = CGSizeMake(DEV_BUTTON_SIZE, DEV_BUTTON_SIZE);
    frameOfSaveButton.origin.x = frameOfGenerateButton.origin.x + DEV_BUTTON_SIZE*5;
    frameOfSaveButton.origin.y = frameOfGenerateButton.origin.y;
    self.devButton_saveLevels = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.devButton_saveLevels setFrame:frameOfSaveButton];
    [self.devButton_saveLevels setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
    [self.devButton_saveLevels setTintColor:[UIColor whiteColor]];
    [self.devButton_saveLevels addTarget:self action:@selector(saveLevelsData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.devButton_saveLevels];
    
    // Палитра цветов / сочетаний цветов
    CGRect frameOfPalette = CGRectZero;
    frameOfPalette.size = CGSizeMake(self.view.frame.size.width, self.gridSize);
    frameOfPalette.origin.x = 0;
    frameOfPalette.origin.y = 0;
    UICollectionViewFlowLayout *layoutPalette = [[UICollectionViewFlowLayout alloc] init];
    [layoutPalette setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.devCollectionView_palette = [[UICollectionView alloc] initWithFrame:frameOfPalette collectionViewLayout:layoutPalette];
    [self.devCollectionView_palette setHidden:YES];
    [self.devCollectionView_palette setDataSource:self];
    [self.devCollectionView_palette setDelegate:self];
    [self.devCollectionView_palette setAlwaysBounceHorizontal:YES];
    [self.devCollectionView_palette registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"paletteCell"];
    [self.devCollectionView_palette registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"unmixCell"];
    [self.devCollectionView_palette setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [self.view addSubview:self.devCollectionView_palette];
    
    // Зона отмены выбора цвета
    CGRect deadZoneFrame = self.view.frame;
    deadZoneFrame.origin.y = self.devCollectionView_palette.frame.size.height;
    deadZoneFrame.size.height = self.view.frame.size.height - deadZoneFrame.origin.y;
    self.dev_deadZoneView = [[UIView alloc] initWithFrame:deadZoneFrame];
    [self.dev_deadZoneView setBackgroundColor:[UIColor clearColor]];
    [self.dev_deadZoneView setHidden:YES];
    UITapGestureRecognizer *cancelGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dev_exitColors)];
    [self.dev_deadZoneView addGestureRecognizer:cancelGR];
    [self.view addSubview:self.dev_deadZoneView];
}

- (void)dev_switchDevMode {
    
    [self setDevModeSelected:!self.devModeSelected];
    [self setDev_unmixMode:NO];
    [self updateUI];
}

- (void)dev_switchMoveLevelMode {
    [self setDev_moveLevelMode:!self.dev_moveLevelMode];
    [self updateUI];
}

- (void)dev_switchUnmixMode {
    
    [self setDev_unmixMode:!self.dev_unmixMode];
    [self updateUI];
}

- (void)dev_setTargetColor {
    
    [self.gameLevel setTargetColor:[[self.gameLevel.blocks objectAtIndex:0] color]];
    [self restartLevel];
    [self.allLevels replaceObjectAtIndex:self.currentLevel withObject:self.gameLevel];
    [self loadLevel:self.currentLevel];
}

- (void)dev_recSolution {
    
    [self setDev_recSolutionMode:!self.dev_recSolutionMode];
    if (self.dev_recSolutionMode) {
        [self setDev_recSolutionsArray:nil];
        [self setDev_unmixMode:NO];
    } else {
        [self restartLevel];
        [self.gameLevel setSolutionSteps:self.dev_recSolutionsArray];
        [self.allLevels replaceObjectAtIndex:self.currentLevel withObject:self.gameLevel];
        [self loadLevel:self.currentLevel];
    }
    [self updateUI];
}

- (void)dev_recSolutionFrom:(RSColorBlock *)fromBlock to:(RSColorBlock *)toBlock {
    
    [self.dev_recSolutionsArray addObject:@[[NSValue valueWithCGPoint:fromBlock.position],[NSValue valueWithCGPoint:toBlock.position]]];
}

- (void)dev_changeSize {
    
    CGSize newSize = self.gameLevel.size;
    newSize.width++;
    if (newSize.width > BLOCKS_IN_ROW) {
        newSize.width = 1;
        newSize.height++;
    }
    if (newSize.height > BLOCKS_IN_ROW) {
        newSize.height = 1;
        newSize.width = 2;
    }
    [self.gameLevel setSize:newSize];
    [self dev_generate];
}

- (void)dev_generate {
    
    RSGameLevel *newGameLevel = [RSGameLevel generateLevelwithSize:self.gameLevel.size pallete:nil andTargetColor:nil];
    [self.allLevels replaceObjectAtIndex:self.currentLevel withObject:newGameLevel];
    [self loadLevel:self.currentLevel];
}

- (void)dev_doubleTapOnBlock:(UITapGestureRecognizer *)gestureRecognizer {
    
    // Двойной щелчок по блоку
    self.dev_editBlock = [self.gameLevel.blocks objectAtIndex:gestureRecognizer.view.tag-1];
    self.dev_unmixFirstBlock = nil;
    self.dev_unmixSecondBlock = nil;
    [self dev_showPalette];
}

- (void)dev_unmixColorBlock:(RSColorBlock *)firstBlock toColorBlock:(RSColorBlock *)secondBlock {
    
    self.dev_editBlock = nil;
    self.dev_unmixFirstBlock = firstBlock;
    self.dev_unmixSecondBlock = secondBlock;
    [self dev_showPalette];
}

- (NSArray *)dev_unmixPares {
    
    if (self.dev_unmixFirstBlock) {
        if (!_dev_unmixPares) {
            _dev_unmixPares = [self.gameLevel.palette unmixColor:self.dev_unmixFirstBlock.color];
        }
    } else {
        _dev_unmixPares = nil;
    }
    return _dev_unmixPares;
}

- (void)dev_showPalette {
    
    [self.devCollectionView_palette setHidden:NO];
    [self.dev_deadZoneView setHidden:NO];
    [self.devCollectionView_palette reloadData];
}

- (void)dev_exitColors {
    
    [self.dev_deadZoneView setHidden:YES];
    [self.devCollectionView_palette setHidden:YES];
    [self setDev_editBlock:nil];
    [self setDev_unmixFirstBlock:nil];
    [self setDev_unmixSecondBlock:nil];
    [self setDev_unmixPares:nil];
}

- (void)dev_singleTapOnColor:(UITapGestureRecognizer *)gestureRecognizer {
    
    // Выбрали цвет или сочетание цветов из палитры
    UICollectionViewCell *cell = (UICollectionViewCell *)gestureRecognizer.view;
    NSInteger index = [self.devCollectionView_palette indexPathForCell:cell].row;
    
    if (self.dev_editBlock) {
        UIColor *selectedColor = cell.backgroundColor;
        [self.dev_editBlock setColor:selectedColor];
        
    } else if (self.dev_unmixPares) {
        UIColor *firstColor = [(NSArray *)[self.dev_unmixPares objectAtIndex:index] firstObject];
        UIColor *secondColor = [(NSArray *)[self.dev_unmixPares objectAtIndex:index] lastObject];
        [self.dev_unmixFirstBlock setColor:firstColor];
        [self.dev_unmixSecondBlock setColor:secondColor];
    }
    
    [self.gameLevel updateMutualBlocks];
    [self.allLevels replaceObjectAtIndex:self.currentLevel withObject:self.gameLevel];
    [self loadLevel:self.currentLevel];
    [self dev_exitColors];
}

- (void)dev_exportLevelsToXML {
    
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.allLevels];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [myEncodedObject writeToFile:[documentsDirectory stringByAppendingPathComponent:LEVELSFILE] atomically:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    if (self.dev_editBlock) {
        count = self.gameLevel.palette.colors.count;
    } else if (self.dev_unmixPares) {
        count = self.dev_unmixPares.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    if (self.dev_editBlock) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"paletteCell" forIndexPath:indexPath];
        cell.backgroundColor = [self.gameLevel.palette.colors objectAtIndex:indexPath.row];
        
        // Разместим на цвете количество вариаций его разложения
        UILabel *unmixCountLabel = (UILabel *)[cell viewWithTag:TAG_UNMIXCOUNTLABEL];
        if (!unmixCountLabel) {
            CGRect unmixCountFrame = cell.frame;
            unmixCountFrame.origin = CGPointZero;
            unmixCountLabel = [[UILabel alloc] initWithFrame:unmixCountFrame];
            [unmixCountLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:12]];
            [unmixCountLabel setTag:TAG_UNMIXCOUNTLABEL];
            [unmixCountLabel setTextAlignment:NSTextAlignmentCenter];
            [cell addSubview:unmixCountLabel];
        }
        [unmixCountLabel setText:[NSString stringWithFormat:@"%i",(int)([self.gameLevel.palette unmixColor:cell.backgroundColor].count-1)/2]];
        
    } else if (self.dev_unmixPares) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"unmixCell" forIndexPath:indexPath];
        CGRect topFrame = CGRectMake(0, 0, self.gridSize, self.gridSize/2);
        CGRect bottomFrame = CGRectMake(0, self.gridSize/2, self.gridSize, self.gridSize/2);
        UIView *topView = [[UIView alloc] initWithFrame:topFrame];
        UIView *bottomView = [[UIView alloc] initWithFrame:bottomFrame];
        [topView setBackgroundColor:[[self.dev_unmixPares objectAtIndex:indexPath.row] firstObject]];
        [bottomView setBackgroundColor:[[self.dev_unmixPares objectAtIndex:indexPath.row] lastObject]];
        [cell addSubview:topView];
        [cell addSubview:bottomView];
        
    } else {
        return nil;
    }
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(dev_singleTapOnColor:)];
    singleTap.numberOfTapsRequired = 1;
    [cell addGestureRecognizer:singleTap];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.gridSize, self.gridSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark SYSTEM

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end