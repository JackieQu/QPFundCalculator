//
//  Macro.h
//  QPTemplate
//
//  Created by JackieQu on 2020/10/12.
//

#ifndef Macro_h
#define Macro_h

/*      *********20*********        */
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define CONTENT_HEIGHT              (SCREEN_HEIGHT - STATUS_NAV_HEIGHT - TAB_BAR_HEIGHT)
#define CONTENT_TAB_HEIGHT          (SCREEN_HEIGHT - STATUS_NAV_HEIGHT)

#define STATUS_BAR_HEIGHT           [[UIApplication sharedApplication].windows.firstObject windowScene].statusBarManager.statusBarFrame.size.height
#define NAV_BAR_HEIGHT              44.f
#define STATUS_NAV_HEIGHT           (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)
#define TAB_BAR_HEIGHT              (49.f + SAFE_MARGIN_BOTTOM)

#define SAFE_MARGIN_TOP             (STATUS_BAR_HEIGHT > 20.f ? 24.f : 0.f)
#define SAFE_MARGIN_BOTTOM          (STATUS_BAR_HEIGHT > 20.f ? 34.f : 0.f)

#define STANDARD_WIDTH              375.f
#define SCALE(value)                roundf(value / STANDARD_WIDTH * SCREEN_WIDTH)

#define MARGIN                      20.f
#define PADDING                     20.f

#define isNullStr(str)              (str == nil || str == Nil || str == NULL || str.length == 0 || \
                                    [str isKindOfClass:[NSNull class]] || [str isEqualToString:@"<null>"])
#define isNullArr(arr)              (arr == nil || arr == Nil || arr == NULL || arr.count == 0 || \
                                    [arr isKindOfClass:[NSNull class]])
#define isNullDict(dict)            (dict == nil || dict == Nil || dict == NULL || dict.allKeys.count == 0 || \
                                    [dict isKindOfClass:[NSNull class]])

#define kFontSize(size)             [UIFont systemFontOfSize:size]
#define kFontSizeAndWeight(s,w)     [UIFont systemFontOfSize:s weight:w]

#define kColorRGBA(r,g,b,a)         [UIColor colorWithRed:(r) / 255.0f \
                                                    green:(g) / 255.0f \
                                                    blue:(b) / 255.0f \
                                                    alpha:(a)]
#define kColorRGB(r,g,b)            kColorRGBA(r,g,b,1)
#define kColorSameRGBA(value,a)     kColorRGBA(value,value,value,a)
#define kColorSameRGB(value)        kColorRGBA(value,value,value,1)
#define kColorWhiteAndAlpha(w,a)    [UIColor colorWithWhite:w alpha:a]

#define kMainColor                  kOrangeColor
#define kRandomColor                [UIColor randomColor]
#define kBlackColor                 [UIColor blackColor]       // 0.0 white
#define kDarkGrayColor              [UIColor darkGrayColor]    // 0.333 white
#define kLightGrayColor             [UIColor lightGrayColor]   // 0.667 white
#define kWhiteColor                 [UIColor whiteColor]       // 1.0 white
#define kGrayColor                  [UIColor grayColor]        // 0.5 white
#define kRedColor                   [UIColor redColor]         // 1.0, 0.0, 0.0 RGB
#define kGreenColor                 [UIColor greenColor]       // 0.0, 1.0, 0.0 RGB
#define kBlueColor                  [UIColor blueColor]        // 0.0, 0.0, 1.0 RGB
#define kCyanColor                  [UIColor cyanColor]        // 0.0, 1.0, 1.0 RGB
#define kYellowColor                [UIColor yellowColor]      // 1.0, 1.0, 0.0 RGB
#define kMagentaColor               [UIColor magentaColor]     // 1.0, 0.0, 1.0 RGB
#define kOrangeColor                [UIColor orangeColor]      // 1.0, 0.5, 0.0 RGB
#define kPurpleColor                [UIColor purpleColor]      // 0.5, 0.0, 0.5 RGB
#define kBrownColor                 [UIColor brownColor]       // 0.6, 0.4, 0.2 RGB
#define kClearColor                 [UIColor clearColor]       // 0.0 white, 0.0 alpha

#define isUnspecified               ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomUnspecified)
#define isPhone                     ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define isPad                       ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

#define iPhone_4                    (fabs([SCREEN_HEIGHT - 480.f) < FLT_EPSILON)
#define iPhone_5                    (fabs([SCREEN_HEIGHT - 568.f) < FLT_EPSILON)
#define iPhone_6                    (fabs([SCREEN_HEIGHT - 667.f) < FLT_EPSILON)
#define iPhone_6_Plus               (fabs([SCREEN_HEIGHT - 960.f) < FLT_EPSILON)
#define iPhone_8_Plus               (fabs([SCREEN_HEIGHT - 736.f) < FLT_EPSILON)
#define iPhone_X                    (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f)
#define iPhone_XS_Max               (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)
#define iPhone_12                   (SCREEN_WIDTH == 390.f && SCREEN_HEIGHT == 844.f)
#define iPhone_12_Pro_Max           (SCREEN_WIDTH == 428.f && SCREEN_HEIGHT == 926.f)
#define iPhone_12_mini              (SCREEN_WIDTH == 360.f && SCREEN_HEIGHT == 788.f)

#define iPhone_X_Later              (iPhone_X || iPhone_XS_Max || iPhone_12 || iPhone_12_Pro_Max || iPhone_12_mini)

#define BUNDLE_SHORT_VERSION        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUNDLE_VERSION              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define SYSTEM_VERSION              [UIDevice currentDevice].systemVersion.floatValue
#define iOS_13_Later                (floorf(SYSTEM_VERSION) >= 13.0)
#define iOS_14_Later                (floorf(SYSTEM_VERSION) >= 14.0)

#endif /* Macro_h */

#ifdef DEBUG

#define DLog(s, ...)               NSLog(@"<%@:(%d)> %@",  \
                                            [[NSString stringWithUTF8String:__FILE__] lastPathComponent],   \
                                            __LINE__,   \
                                            [NSString stringWithFormat:(s),##__VA_ARGS__]);
#define DLogFunction               DLog(@"%s", __FUNCTION__);

#else

#define DLog(s, ...)
#define DLogFunction

#endif

/* 型号                  屏幕尺寸     逻辑分辨率    设备分辨率     倍图
 * iPhone               3.5-inch    320x480     320x480      @1x
 * iPhone_3G            3.5-inch    320x480     320x480      @1x
 * iPhone_3GS           3.5-inch    320x480     320x480      @1x
 * iPhone_4             3.5-inch    320x480     640x960      @2x
 * iPhone_4S            3.5-inch    320x480     640x960      @2x
 * iPhone_5             4.0-inch    320x568     640x1136     @2x
 * iPhone_5C            4.0-inch    320x568     640x1136     @2x
 * iPhone_5S            4.0-inch    320x568     640x1136     @2x
 * iPhone_6             4.7-inch    375x667     750x1334     @2x
 * iPhone_6_Plus        5.5-inch    414x736     1080x1920    @3x
 * iPhone_6S            4.7-inch    375x667     750x1334     @2x
 * iPhone_6S_Plus       5.5-inch    414x736     1080x1920    @3x
 * iPhone_SE            4.0-inch    320x568     640x1136     @2x
 * iPhone_7             4.7-inch    375x667     750x1334     @2x
 * iPhone_7_Plus        5.5-inch    414x736     1080x1920    @3x
 * iPhone_8             4.7-inch    375x667     750x1334     @2x
 * iPhone_8_Plus        5.5-inch    414x736     1080x1920    @3x
 * iPhone_X             5.8-inch    375x812     1125x2436    @3x
 * iPhone_XR            6.1-inch    414x896     828x1792     @2x
 * iPhone_XS            5.8-inch    375x812     1125x2436    @3x
 * iPhone_XS_Max        6.5-inch    414x896     1242x2688    @3x
 * iPhone_11            6.1-inch    414x896     828x1792     @2x
 * iPhone_11_Pro        5.8-inch    375x812     1125x2436    @3x
 * iPhone_11_Pro_Max    6.5-inch    414x896     1242x2688    @3x
 * iPhone_SE2           4.7-inch    375x667     750x1334     @2x
 * iPhone_12            6.1-inch    390x844     1170x2532    @3x
 * iPhone_12_Pro        6.1-inch    390x844     1170x2532    @3x
 * iPhone_12_Pro_Max    6.7-inch    428x926     1284x2778    @3x
 * iPhone_12_mini       5.4-inch    360x780     1080x2340    @3x
 */
