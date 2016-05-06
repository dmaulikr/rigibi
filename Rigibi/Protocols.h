//
//  Protocols.h
//  Rigibi
//
//  Created by Roman Silin on 15.02.15.
//  Copyright (c) 2015 Roman Silin. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RSShades) {
  
    RSShadesRandom = 0,
    RSShadesEasy = 1,
    RSShadesMedium = 2,
    RSShadesHard = 3,
    RSShadesAllColors = 4,
};

typedef NS_ENUM(NSUInteger, RSDirection) {
    
    RSDirectionTop = 0,
    RSDirectionRight = 1,
    RSDirectionDown = 2,
    RSDirectionLeft = 3
};

@class RSGameLevel;
@class RSColorBlock;
@class RSMixButton;

@protocol RSGridSizeDelegate <NSObject>
@property (nonatomic) CGFloat gridSize;
@optional
@property (nonatomic) CGSize radiusOfBorder;
@property (nonatomic) CGSize radiusOfInside;
@end

@protocol RSRateAppDialogDelegate <NSObject, RSGridSizeDelegate>
- (void)playSound:(NSString *)soundName;
- (void)userChoose:(RSMixButton *)sender;
@end

@protocol RSGameVCDelegate <NSObject, RSGridSizeDelegate>
@property (strong, nonatomic) UIButton *okButton;
@property (strong, nonatomic) RSGameLevel *gameLevel;
@property (nonatomic) BOOL hexShowed;
@property (nonatomic) BOOL dev_unmixMode;
@property (nonatomic) BOOL dev_recSolutionMode;
@property (nonatomic) NSInteger currentLevel;
@property (nonatomic) NSInteger solutionStep;
@property (nonatomic) NSInteger keysCount;
@property (nonatomic) BOOL sharedFacebook;
@property (nonatomic) BOOL sharedTwitter;

- (void)rateApp;
- (void)hideDialog;
- (void)saveMixHistory;
- (void)updateUI;
- (void)saveUserDefaults;
- (BOOL)checkForSolve;
- (void)playSound:(NSString *)soundName;
- (void)dev_doubleTapOnBlock:(UITapGestureRecognizer *)gestureRecognizer;
- (void)dev_unmixColorBlock:(RSColorBlock *)firstBlock toColorBlock:(RSColorBlock *)secondBlock;
- (void)dev_recSolutionFrom:(RSColorBlock *)fromBlock to:(RSColorBlock *)toBlock;
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end

#define DEVMODE NO
#define AUTOLEVEL 0
#define AUTOKEYS 0
#define APP_STORE_ID 975493753
#define YANDEXMETRIKA_APIKEY @""
#define INFINITE_KEYS_PRODUCT_ID @"RS.Rigibi.allKeys"
#define FIVE_KEYS_PRODUCT_ID @"RS.Rigibi.fiveKeys"
#define FEEDBACK_EMAIL @"support@rigibiapp.com"
#define RIGIBI_URL @"rigibiapp.com"

#define FREEKEY_LEVELSCOUNT 10 // actual for 1.0 only
#define LEVEL_SHOWRATEDIALOG 44
#define LEVEL_TUTORIAL_SWIPE 1
#define LEVEL_TUTORIAL_BORDER 2
#define LEVEL_TUTORIAL_HEX 3

#define LEADEARBOARD_ID @"RigibiLevels"
#define ACH_30 @"NotABaby"
#define ACH_70 @"TimeToHard"
#define ACH_100 @"SuperBrain"
#define ACH_9KEYS @"WithoutKeys"

#define BLOCKS_IN_ROW 4
#define GRID_SIZE 64
#define RADIUS_OF_BORDER 16.f
#define DEV_BUTTON_SIZE 56
#define RGBSTEP 0.5

#define SCREEN_IPHONE45 320
#define SCREEN_IPHONE6 375
#define SCREEN_IPHONE6PLUS 414
#define SCREEN_IPAD 765

#define TAG_DEADZONE 1000
#define TAG_UNMIXCOUNTLABEL 1010
#define TAG_DIALOGCANCEL 1020

#define LEVELSFILE @"99levels.xml"
#define DIALOG_BACKGROUND @"404040"
#define DIALOG_FACEBOOK @"3B5998"
#define DIALOG_TWITTER @"55ACEE"
#define DIALOG_PURCHASE @"3B9841"
#define DIALOG_FACEBOOK_GRAY @"595959"
#define DIALOG_TWITTER_GRAY @"969696"

#define FONTFAMALY @"Avenir-Black";
#define kDevLevels @"Levels"
#define kKeysCount @"Keys Count"
#define kKeyUsedButNotPlayed @"Key Used But Not Played"
#define kSolvedCount @"Solved Count"
#define kCurrentLevel @"Current Level"
#define kFreeKeysRecieved @"Free Keys Recieved"
#define kDontShowRateDialog @"Don't Show Rate Dialog"
#define kSharedFacebook @"Share in Facebook bonus is used"
#define kSharedTwitter @"Shared in Twitter bonus is used"
#define kTimerSeconds @"Time tracker seconds"
#define kGameOver @"Game Over"

#define evSOLVED @"SOLVED LEVELS"
#define evTIME @"TIME FOR SOLVE"
#define evKEYUSED @"KEYS USING"
#define evLEVEL @"Level"

#define evLIKEORRATE @"LIKE AND RATE"
#define evLIKEANDRATE @"Like + Rate"
#define evLIKEANDIGNORE @"Like + Ignore"
#define evDISLIKEANDFEEDBACK @"Dislike + Feedback"
#define evDISLIKEANDIGNORE @"Dislike + Ignore"

#define evNOKEYS @"NEED FOR KEYS"
#define evFB @"Facebook"
#define evTW @"Twitter"
#define evBUYINAPP_ALLKEYS @"Purchase infinite keys"
#define evBUYINAPP_5KEYS @"Purchase 5 keys"

#define evWIN @"WIN"
#define evWINSHARE @"Share"
#define evWINRATE @"Rate"



