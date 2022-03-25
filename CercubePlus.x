#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// NOYTPremium: https://github.com/PoomSmart/NoYTPremium

%hook YTCommerceEventGroupHandler
- (void)addEventHandlers {}
%end

%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers {}
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial { return YES; }
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return NO; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)frequencyCap { return NO; }
%end

%hook YTSurveyController
- (void)showSurveyWithRenderer:(id)arg1 surveyParentResponder:(id)arg2 {}
%end


// YTABGoodies: https://poomsmart.github.io/repo/depictions/ytabgoodies.html
// YouAreThere

%hook YTColdConfig
- (BOOL)enableYouthereCommandsOnIos {
    return NO;
}
%end

%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt {
    return NO;
}
%end

// YTSystemAppearance: https://poomsmart.github.io/repo/depictions/ytsystemappearance.html

%hook YTColdConfig
- (BOOL)shouldUseAppThemeSetting {
    return YES;
}
%end