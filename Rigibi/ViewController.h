//
//  ViewController.h
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

#import "SoundManager.h"
#import "RSGameLevel.h"
#import "RSGameZoneView.h"
#import "RSColorView.h"
#import "RSNoKeysDialogView.h"
#import "RSRateAppDialogView.h"
#import "RSWinnerDialogView.h"
#import "RSHelpView.h"
#import "RSTimer.h"

@interface ViewController : UIViewController <RSGameVCDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

// Model
@property (strong, nonatomic) RSGameLevel *gameLevel;
@property (strong, nonatomic) NSMutableArray *allLevels;
@property (strong, nonatomic) NSMutableArray *mixHistory; //array of arrays of RSColorBlock
@property (nonatomic) NSInteger solvedCount;
@property (nonatomic) NSInteger currentLevel;
@property (nonatomic) CGFloat gridSize;
@property (nonatomic) CGSize radiusOfBorder;
@property (nonatomic) CGSize radiusOfInside;
@property (nonatomic) NSInteger solutionStep;
@property (nonatomic) BOOL hexShowed;
@property (nonatomic) BOOL soundOn;
@property (nonatomic) NSInteger keysCount;
@property (nonatomic) BOOL keyUsedButNotPlayed;
@property (nonatomic) BOOL lastLevelAvailableButNotOpened;
@property (nonatomic) BOOL sharedFacebook;
@property (nonatomic) BOOL sharedTwitter;
@property (nonatomic) BOOL gameOver;

@property (nonatomic) BOOL gameCenterEnabled;
@property (strong, nonatomic) NSString *leaderboardIdentifier;
@property (strong, nonatomic) RSTimer *timer;

// Views
@property (strong, nonatomic) UIButton *prevButton;
@property (strong, nonatomic) UILabel *levelLabel;
@property (strong, nonatomic) UIButton *nextButton;

@property (strong, nonatomic) RSGameZoneView *gameZoneView;
@property (strong, nonatomic) UIButton *okButton;
@property (strong, nonatomic) RSNoKeysDialogView *noKeysDialogView;
@property (strong, nonatomic) RSRateAppDialogView *rateAppDialogView;
@property (strong, nonatomic) RSWinnerDialogView *winnerDialogView;
@property (strong, nonatomic) RSHelpView *helpView;

@property (strong, nonatomic) UIButton *showHexButton;
@property (strong, nonatomic) UIButton *soundButton;
@property (strong, nonatomic) UILabel *hexLabel;
@property (strong, nonatomic) UILabel *tutorialLabel;
@property (strong, nonatomic) UIButton *restartButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *keyButton;
@property (strong, nonatomic) UILabel *keysCountLabel;
@property (strong, nonatomic) UIButton *tutorialMiniButton;
@property (strong, nonatomic) UIView *snapshotTutorialView;

//DevMode
@property (strong, nonatomic) UIButton *devButton_switchDevMode;
@property (strong, nonatomic) UIButton *devButton_switchMoveLevelMode;
@property (strong, nonatomic) UIButton *devButton_generatePuzzle;
@property (strong, nonatomic) UIButton *devButton_changeSize;
@property (strong, nonatomic) UIButton *devButton_setTargetColor;
@property (strong, nonatomic) UIButton *devButton_saveLevels;
@property (strong, nonatomic) UIButton *devButton_recSolution;
@property (strong, nonatomic) UIButton *devButton_unmixMode;
@property (strong, nonatomic) UICollectionView *devCollectionView_palette;
@property (strong, nonatomic) UIView *dev_deadZoneView;
@property (strong, nonatomic) RSColorBlock *dev_unmixFirstBlock;
@property (strong, nonatomic) RSColorBlock *dev_unmixSecondBlock;
@property (strong, nonatomic) NSArray *dev_unmixPares;
@property (strong, nonatomic) RSColorBlock *dev_editBlock;
@property (strong, nonatomic) NSMutableArray *dev_recSolutionsArray;
@property (nonatomic) BOOL devModeSelected;
@property (nonatomic) BOOL dev_moveLevelMode;
@property (nonatomic) BOOL dev_unmixMode;
@property (nonatomic) BOOL dev_recSolutionMode;

- (void)rateApp;
- (void)playSound:(NSString *)soundName;
- (void)saveUserDefaults;
- (void)saveMixHistory;
- (void)updateUI;
- (BOOL)checkForSolve;
- (void)hideDialog;
- (void)dev_doubleTapOnBlock:(UITapGestureRecognizer *)gestureRecognizer;
- (void)dev_unmixColorBlock:(RSColorBlock *)firstBlock toColorBlock:(RSColorBlock *)secondBlock;
- (void)dev_recSolutionFrom:(RSColorBlock *)fromBlock to:(RSColorBlock *)toBlock;

@end

