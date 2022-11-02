#import "Header.h"
#import "Tweaks/YouTubeHeader/YTSettingsViewController.h"
#import "Tweaks/YouTubeHeader/YTSearchableSettingsViewController.h"
#import "Tweaks/YouTubeHeader/YTSettingsSectionItem.h"
#import "Tweaks/YouTubeHeader/YTSettingsSectionItemManager.h"
#import "Tweaks/YouTubeHeader/YTUIUtils.h"

@interface YTSettingsSectionItemManager (YouPiP)
- (void)updateCercubePlusSectionWithEntry:(id)entry;
@end

static const NSInteger CercubePlusSection = 500;

extern NSBundle *CercubePlusBundle();
extern BOOL hideHUD();
extern BOOL oled();
extern BOOL oledKB();
extern BOOL autoFullScreen();
extern BOOL hideHoverCard();
extern BOOL reExplore();
extern BOOL bigYTMiniPlayer();
extern BOOL hideCC();
extern BOOL hideAutoplaySwitch();
extern BOOL hideCercubeButton();
extern BOOL hideCercubePiP();
extern BOOL hideCercubeDownload();
extern BOOL hideCastButton();
extern BOOL hideWatermarks();
extern BOOL ytMiniPlayer();
extern BOOL hideShorts();
extern BOOL hidePreviousAndNextButton();
extern BOOL hidePaidPromotionCard();
extern BOOL hideNotificationButton();
extern BOOL fixGoogleSignIn();
extern BOOL replacePreviousAndNextButton();
extern BOOL dontEatMyContent();

// Settings
%hook YTAppSettingsPresentationData
+ (NSArray *)settingsCategoryOrder {
    NSArray *order = %orig;
    NSMutableArray *mutableOrder = [order mutableCopy];
    NSUInteger insertIndex = [order indexOfObject:@(1)];
    if (insertIndex != NSNotFound)
        [mutableOrder insertObject:@(CercubePlusSection) atIndex:insertIndex + 1];
    return mutableOrder;
}
%end

%hook YTSettingsViewController

- (void)loadWithModel:(id)model fromView:(UIView *)view {
    %orig;
    if ([[self valueForKey:@"_detailsCategoryID"] integerValue] == CercubePlusSection)
        MSHookIvar<BOOL>(self, "_shouldShowSearchBar") = YES;
}

- (void)setSectionControllers {
    %orig;
    if (MSHookIvar<BOOL>(self, "_shouldShowSearchBar")) {
        YTSettingsSectionController *settingsSectionController = [self settingsSectionControllers][[self valueForKey:@"_detailsCategoryID"]];
        YTSearchableSettingsViewController *searchableVC = [self valueForKey:@"_searchableSettingsViewController"];
        if (settingsSectionController)
            [searchableVC storeCollectionViewSections:@[settingsSectionController]];
    }
}

%end

%hook YTSettingsSectionItemManager
%new 
- (void)updateCercubePlusSectionWithEntry:(id)entry {
    YTSettingsViewController *delegate = [self valueForKey:@"_dataDelegate"];
    NSBundle *tweakBundle = CercubePlusBundle();

    YTSettingsSectionItem *version = [%c(YTSettingsSectionItem)
    itemWithTitle:[NSString stringWithFormat:LOC(@"VERSION"), @(OS_STRINGIFY(TWEAK_VERSION))]
    titleDescription:LOC(@"VERSION_CHECK")
    accessibilityIdentifier:nil
    detailTextBlock:nil
    selectBlock:^BOOL (YTSettingsCell *cell, NSUInteger arg1) {
        return [%c(YTUIUtils) openURL:[NSURL URLWithString:@"https://github.com/qnblackcat/CercubePlus/releases/latest"]];
    }];

    YTSettingsSectionItem *dontEatMyContent = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"DONT_EAT_MY_CONTENT") titleDescription:LOC(@"DONT_EAT_MY_CONTENT_DESC")];
    dontEatMyContent.hasSwitch = YES;
    dontEatMyContent.switchVisible = YES;
    dontEatMyContent.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"dontEatMyContent_enabled"];
    dontEatMyContent.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"dontEatMyContent_enabled"];
        return YES;
    };

    YTSettingsSectionItem *replacePreviousAndNextButton = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"REPLACE_PREVIOUS_NEXT_BUTTON") titleDescription:LOC(@"REPLACE_PREVIOUS_NEXT_BUTTON_DESC")];
    replacePreviousAndNextButton.hasSwitch = YES;
    replacePreviousAndNextButton.switchVisible = YES;
    replacePreviousAndNextButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"replacePreviousAndNextButton_enabled"];
    replacePreviousAndNextButton.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"replacePreviousAndNextButton_enabled"];
        return YES;
    };

    YTSettingsSectionItem *fixGoogleSignIn = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"FIX_GOOGLE_SIGNIN") titleDescription:LOC(@"FIX_GOOGLE_SIGNIN_DESC")];
    fixGoogleSignIn.hasSwitch = YES;
    fixGoogleSignIn.switchVisible = YES;
    fixGoogleSignIn.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"fixGoogleSignIn_enabled"];
    fixGoogleSignIn.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"fixGoogleSignIn_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideNotificationButton = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_NOTIFICATION_BUTTON") titleDescription:LOC(@"HIDE_NOTIFICATION_BUTTON_DESC")];
    hideNotificationButton.hasSwitch = YES;
    hideNotificationButton.switchVisible = YES;
    hideNotificationButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideNotificationButton_enabled"];
    hideNotificationButton.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideNotificationButton_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hidePaidPromotionCard = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_PAID_PROMOTION_CARDS") titleDescription:LOC(@"HIDE_PAID_PROMOTION_CARDS_DESC")];
    hidePaidPromotionCard.hasSwitch = YES;
    hidePaidPromotionCard.switchVisible = YES;
    hidePaidPromotionCard.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hidePaidPromotionCard_enabled"];
    hidePaidPromotionCard.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hidePaidPromotionCard_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hidePreviousAndNextButton = [[%c(YTSettingsSectionItem) alloc] initWithTitle:LOC(@"HIDE_PREVIOUS_AND_NEXT_BUTTON") titleDescription:LOC(@"HIDE_PREVIOUS_AND_NEXT_BUTTON_DESC")];
    hidePreviousAndNextButton.hasSwitch = YES;
    hidePreviousAndNextButton.switchVisible = YES;
    hidePreviousAndNextButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hidePreviousAndNextButton_enabled"];
    hidePreviousAndNextButton.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hidePreviousAndNextButton_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideShorts = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_SHORTS_VIDEOS") titleDescription:LOC(@"HIDE_SHORTS_VIDEOS_DESC")];
    hideShorts.hasSwitch = YES;
    hideShorts.switchVisible = YES;
    hideShorts.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideShorts_enabled"];
    hideShorts.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideShorts_enabled"];
        return YES;
    };

    YTSettingsSectionItem *ytMiniPlayer = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"YT_MINIPLAYER") titleDescription:LOC(@"YT_MINIPLAYER_DESC")];
    ytMiniPlayer.hasSwitch = YES;
    ytMiniPlayer.switchVisible = YES;
    ytMiniPlayer.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ytMiniPlayer_enabled"];
    ytMiniPlayer.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"ytMiniPlayer_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideCercubeButton = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_CERCUBE_BUTTON") titleDescription:LOC(@"")];
    hideCercubeButton.hasSwitch = YES;
    hideCercubeButton.switchVisible = YES;
    hideCercubeButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideCercubeButton_enabled"];
    hideCercubeButton.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideCercubeButton_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideCercubePiP = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_CERCUBE_PIP_BUTTON") titleDescription:LOC(@"HIDE_CERCUBE_PIP_BUTTON_DESC")];
    hideCercubePiP.hasSwitch = YES;
    hideCercubePiP.switchVisible = YES;
    hideCercubePiP.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideCercubePiP_enabled"];
    hideCercubePiP.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideCercubePiP_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideCercubeDownload = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_CERCUBE_DOWNLOAD_BUTTON") titleDescription:LOC(@"HIDE_CERCUBE_DOWNLOAD_BUTTON_DESC")];
    hideCercubeDownload.hasSwitch = YES;
    hideCercubeDownload.switchVisible = YES;
    hideCercubeDownload.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideCercubeDownload_enabled"];
    hideCercubeDownload.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideCercubeDownload_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideCastButton = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_CAST_BUTTON") titleDescription:LOC(@"HIDE_CAST_BUTTON_DESC")];
    hideCastButton.hasSwitch = YES;
    hideCastButton.switchVisible = YES;
    hideCastButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideCastButton_enabled"];
    hideCastButton.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideCastButton_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideWatermarks = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_WATERMARKS") titleDescription:LOC(@"HIDE_WATERMARKS_DESC")];
    hideWatermarks.hasSwitch = YES;
    hideWatermarks.switchVisible = YES;
    hideWatermarks.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideWatermarks_enabled"];
    hideWatermarks.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideWatermarks_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideHoverCard = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_HOVER_CARD") titleDescription:LOC(@"HIDE_HOVER_CARD_DESC")];
    hideHoverCard.hasSwitch = YES;
    hideHoverCard.switchVisible = YES;
    hideHoverCard.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideHoverCard_enabled"];
    hideHoverCard.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideHoverCard_enabled"];
        return YES;
    };

    YTSettingsSectionItem *bigYTMiniPlayer = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"NEW_MINIPLAYER_STYLE") titleDescription:LOC(@"NEW_MINIPLAYER_STYLE_DESC")];
    bigYTMiniPlayer.hasSwitch = YES;
    bigYTMiniPlayer.switchVisible = YES;
    bigYTMiniPlayer.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"bigYTMiniPlayer_enabled"];
    bigYTMiniPlayer.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"bigYTMiniPlayer_enabled"];
        return YES;
    };

    YTSettingsSectionItem *reExplore = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"YT_RE_EXPLORE") titleDescription:LOC(@"YT_RE_EXPLORE_DESC")];
    reExplore.hasSwitch = YES;
    reExplore.switchVisible = YES;
    reExplore.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"reExplore_enabled"];
    reExplore.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"reExplore_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideCC = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_SUBTITLES_BUTTON") titleDescription:LOC(@"HIDE_SUBTITLES_BUTTON_DESC")];
    hideCC.hasSwitch = YES;
    hideCC.switchVisible = YES;
    hideCC.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideCC_enabled"];
    hideCC.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideCC_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideAutoplaySwitch = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_AUTOPLAY_SWITCH") titleDescription:LOC(@"HIDE_AUTOPLAY_SWITCH_DESC")];
    hideAutoplaySwitch.hasSwitch = YES;
    hideAutoplaySwitch.switchVisible = YES;
    hideAutoplaySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideAutoplaySwitch_enabled"];
    hideAutoplaySwitch.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideAutoplaySwitch_enabled"];
        return YES;
    };

    YTSettingsSectionItem *autoFull = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"AUTO_FULLSCREEN") titleDescription:LOC(@"AUTO_FULLSCREEN_DESC")];
    autoFull.hasSwitch = YES;
    autoFull.switchVisible = YES;
    autoFull.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"autoFull_enabled"];
    autoFull.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"autoFull_enabled"];
        return YES;
    };

    YTSettingsSectionItem *hideHUD = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"HIDE_HUD_MESSAGES") titleDescription:LOC(@"HIDE_HUD_MESSAGES_DESC")];
    hideHUD.hasSwitch = YES;
    hideHUD.switchVisible = YES;
    hideHUD.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"hideHUD_enabled"];
    hideHUD.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"hideHUD_enabled"];
        return YES;
    };

    YTSettingsSectionItem *oledDarkMode = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"OLED_DARKMODE") titleDescription:LOC(@"OLED_DARKMODE_DESC")];
    oledDarkMode.hasSwitch = YES;
    oledDarkMode.switchVisible = YES;
    oledDarkMode.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"oled_enabled"];
    oledDarkMode.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"oled_enabled"];
        return YES;
    };

    YTSettingsSectionItem *oledKeyBoard = [[%c(YTSettingsSectionItem) alloc]initWithTitle:LOC(@"OLED_KEYBOARD") titleDescription:LOC(@"OLED_KEYBOARD_DESC")];
    oledKeyBoard.hasSwitch = YES;
    oledKeyBoard.switchVisible = YES;
    oledKeyBoard.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"oledKeyBoard_enabled"];
    oledKeyBoard.switchBlock = ^BOOL (YTSettingsCell *cell, BOOL enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:@"oledKeyBoard_enabled"];
        return YES;
    };
 
    NSMutableArray <YTSettingsSectionItem *> *sectionItems = [NSMutableArray arrayWithArray:@[version, autoFull, ytMiniPlayer, fixGoogleSignIn, hideAutoplaySwitch, hideCercubeButton, hideCercubePiP, hideCercubeDownload, hideCastButton, hideCC, hideHUD, hideHoverCard, hideNotificationButton, hideShorts, hidePaidPromotionCard, hidePreviousAndNextButton, hideWatermarks, bigYTMiniPlayer, oledDarkMode, oledKeyBoard, dontEatMyContent, replacePreviousAndNextButton, reExplore]];
    [delegate setSectionItems:sectionItems forCategory:CercubePlusSection title:@"CercubePlus" titleDescription:nil headerHidden:NO];
}

- (void)updateSectionForCategory:(NSUInteger)category withEntry:(id)entry {
    if (category == CercubePlusSection) {
        [self updateCercubePlusSectionWithEntry:entry];
        return;
    }
    %orig;
}
%end
