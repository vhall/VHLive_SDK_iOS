//
//  VHActionSheet.m
//  VHActionSheet
//
//  Created by Leo on 2015/4/27.
//
//  Copyright (c) 2015-2019 Leo <leodaxia@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

//#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
    isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
isPhoneX;})

#define iPhoneXBottomMargin 10

#import "VHActionSheet.h"
#import "VHActionSheetCell.h"
#import "VHActionSheetViewController.h"
//#import "VUIBaseCore.h"

@interface VHActionSheet () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *otherButtonTitles;

@property (nonatomic, assign) CGSize titleTextSize;

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIVisualEffectView *blurEffectView;
@property (nonatomic, weak) UIView *darkView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *divisionView;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) UIView *whiteBgView;

@property (nonatomic, weak) UIView *lineView;

@property (nullable, nonatomic, strong) UIWindow *window;

@end

@implementation VHActionSheet

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sheetWithTitle:(NSString *)title delegate:(id<VHActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempOtherButtonTitles = nil;
    if (otherButtonTitles) {
        tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempOtherButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    return [[self alloc] initWithTitle:title
                              delegate:delegate
                     cancelButtonTitle:cancelButtonTitle
                 otherButtonTitleArray:tempOtherButtonTitles];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(VHActionSheetClickedHandler)clickedHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempOtherButtonTitles = nil;
    if (otherButtonTitles) {
        tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempOtherButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                               clicked:clickedHandler
                 otherButtonTitleArray:tempOtherButtonTitles];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle didDismiss:(VHActionSheetDidDismissHandler)didDismissHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempOtherButtonTitles = nil;
    if (otherButtonTitles) {
        tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempOtherButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                            didDismiss:didDismissHandler
                 otherButtonTitleArray:tempOtherButtonTitles];
}

+ (instancetype)sheetWithTitle:(NSString *)title delegate:(id<VHActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    
    return [[self alloc] initWithTitle:title
                              delegate:delegate
                     cancelButtonTitle:cancelButtonTitle
                 otherButtonTitleArray:otherButtonTitleArray];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(VHActionSheetClickedHandler)clickedHandler otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                               clicked:clickedHandler
                 otherButtonTitleArray:otherButtonTitleArray];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(nullable NSString *)cancelButtonTitle didDismiss:(nullable VHActionSheetDidDismissHandler)didDismissHandler otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray {
    
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                            didDismiss:didDismissHandler
                 otherButtonTitleArray:otherButtonTitleArray];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<VHActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        [self config:VHActionSheetConfig.config];
        
        id eachObject;
        va_list argumentList;
        NSMutableArray *tempOtherButtonTitles = nil;
        if (otherButtonTitles) {
            tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [tempOtherButtonTitles addObject:eachObject];
            }
            va_end(argumentList);
        }
        
        self.title             = title;
        self.delegate          = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = tempOtherButtonTitles;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(VHActionSheetClickedHandler)clickedHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        [self config:VHActionSheetConfig.config];
        
        id eachObject;
        va_list argumentList;
        NSMutableArray *tempOtherButtonTitles = nil;
        if (otherButtonTitles) {
            tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [tempOtherButtonTitles addObject:eachObject];
            }
            va_end(argumentList);
        }
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.clickedHandler    = clickedHandler;
        self.otherButtonTitles = tempOtherButtonTitles;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle didDismiss:(VHActionSheetDidDismissHandler)didDismissHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        [self config:VHActionSheetConfig.config];
        
        id eachObject;
        va_list argumentList;
        NSMutableArray *tempOtherButtonTitles = nil;
        if (otherButtonTitles) {
            tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [tempOtherButtonTitles addObject:eachObject];
            }
            va_end(argumentList);
        }
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.didDismissHandler = didDismissHandler;
        self.otherButtonTitles = tempOtherButtonTitles;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<VHActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    if (self = [super init]) {
        [self config:VHActionSheetConfig.config];
        
        self.title             = title;
        self.delegate          = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonTitleArray;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(VHActionSheetClickedHandler)clickedHandler otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    if (self = [super init]) {
        [self config:VHActionSheetConfig.config];
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.clickedHandler    = clickedHandler;
        self.otherButtonTitles = otherButtonTitleArray;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle didDismiss:(VHActionSheetDidDismissHandler)didDismissHandler otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    if (self = [super init]) {
        [self config:VHActionSheetConfig.config];
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.didDismissHandler = didDismissHandler;
        self.otherButtonTitles = otherButtonTitleArray;
        
        [self setupView];
    }
    return self;
}

- (instancetype)config:(VHActionSheetConfig *)config {
    _title                           = config.title;
    _cancelButtonTitle               = config.cancelButtonTitle;
    _destructiveButtonIndexSet       = config.destructiveButtonIndexSet;
    _destructiveButtonColor          = config.destructiveButtonColor;
    _titleColor                      = config.titleColor;
    _buttonColor                     = config.buttonColor;
    _titleFont                       = config.titleFont;
    _buttonFont                      = config.buttonFont;
    _buttonHeight                    = config.buttonHeight;
    _scrolling                       = config.canScrolling;
    _visibleButtonCount              = config.visibleButtonCount;
    _animationDuration               = config.animationDuration;
    _darkOpacity                     = config.darkOpacity;
    _darkViewNoTaped                 = config.darkViewNoTaped;
    _unBlur                          = config.unBlur;
    _blurEffectStyle                 = config.blurEffectStyle;
    _titleEdgeInsets                 = config.titleEdgeInsets;
//    _actionSheetEdgeInsets           = config.actionSheetEdgeInsets;
    _separatorColor                  = config.separatorColor;
    _blurBackgroundColor             = config.blurBackgroundColor;
    _autoHideWhenDeviceRotated       = config.autoHideWhenDeviceRotated;
    _disableAutoDismissAfterClicking = config.disableAutoDismissAfterClicking;
    _numberOfTitleLines              = config.numberOfTitleLines;

    _buttonEdgeInsets                = config.buttonEdgeInsets;
    _destructiveButtonBgColor        = config.destructiveButtonBgColor;
    _cancelButtonColor               = config.cancelButtonColor;
    _cancelButtonBgColor             = config.cancelButtonBgColor;
    _buttonBgColor                   = config.buttonBgColor;
    _buttonCornerRadius              = config.buttonCornerRadius;
    _topCornerRadius = 15; //默认15圆角

    return self;
}

- (void)setupView {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleDidChangeStatusBarOrientation)
                               name:UIApplicationDidChangeStatusBarOrientationNotification
                             object:nil];
    
    UIView *darkView                = [[UIView alloc] init];
    darkView.alpha                  = 0;
    darkView.userInteractionEnabled = NO;
    darkView.backgroundColor        = [UIColor blackColor];
    [self addSubview:darkView];
    [darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).priorityLow();
        make.bottom.equalTo(self);
    }];
    self.darkView = darkView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(darkViewClicked)];
    [darkView addGestureRecognizer:tap];
    
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        
        CGFloat height =
        (self.title.length > 0 ? self.titleTextSize.height + 2.0f + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom) : 0) +
        (self.otherButtonTitles.count > 0 ? (self.canScrolling ? MIN(self.visibleButtonCount, self.otherButtonTitles.count) : self.otherButtonTitles.count) * self.buttonHeight : 0) +
        (self.cancelButtonTitle.length > 0 ? 5.0f + self.buttonHeight : 0) + (isAlien ? iPhoneXBottomMargin : 0);
        
        make.height.equalTo(@(height));
        make.bottom.equalTo(self).offset(height);
    }];
    self.bottomView = bottomView;
    
    UIView *whiteBgView         = [[UIView alloc] init];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:whiteBgView];
    [whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomView);
    }];
    
    self.whiteBgView = whiteBgView;
    
    if (!self.unBlur) {
        [self blurBottomBgView];
    } else {
        whiteBgView.hidden = NO;
    }
    
    UILabel *titleLabel      = [[UILabel alloc] init];
    titleLabel.text          = self.title;
    titleLabel.font          = self.titleFont;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor     = self.titleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(self.title.length > 0 ? self.titleEdgeInsets.top : 0);
        make.left.equalTo(bottomView).offset(self.titleEdgeInsets.left);
        make.right.equalTo(bottomView).offset(-self.titleEdgeInsets.right);
        
        CGFloat height = self.title.length > 0 ? self.titleTextSize.height + 2.0f : 0;  // Prevent omit
        make.height.equalTo(@(height));
    }];
    self.titleLabel = titleLabel;
    
    UITableView *tableView    = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource      = self;
    tableView.delegate        = self;
    [bottomView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
        CGFloat height = self.otherButtonTitles.count * self.buttonHeight;
        make.height.equalTo(@(height));
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;

    UIView *lineView  = [[UIView alloc] init];
    lineView.backgroundColor = self.separatorColor;
    lineView.contentMode   = UIViewContentModeBottom;
    lineView.clipsToBounds = YES;
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.bottom.equalTo(tableView.mas_top);
        make.height.offset(1 / 3.0);
    }];
    self.lineView = lineView;
    
    self.lineView.hidden = !self.title || self.title.length == 0;
    
    
    UIView *divisionView         = [[UIView alloc] init];
    divisionView.alpha           = 0.3f;
    divisionView.backgroundColor = self.separatorColor;
    [bottomView addSubview:divisionView];
    [divisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(tableView.mas_bottom);
        
        CGFloat height = self.cancelButtonTitle.length > 0 ? 8.0f : 0;
        make.height.equalTo(@(height));
    }];
    self.divisionView = divisionView;

    UIButton *cancelButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = self.buttonFont;
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:self.cancelButtonColor forState:UIControlStateNormal];
    [cancelButton addTarget:self
                     action:@selector(cancelButtonClicked)
           forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.bottom.equalTo(bottomView).offset(isAlien ? -iPhoneXBottomMargin : 0);
        
        CGFloat height = self.cancelButtonTitle.length > 0 ? self.buttonHeight : 0;
        make.height.equalTo(@(height));
    }];
    self.cancelButton = cancelButton;
}

- (void)appendButtonsWithTitles:(NSString *)titles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempButtonTitles = nil;
    if (titles) {
        tempButtonTitles = [[NSMutableArray alloc] initWithObjects:titles, nil];
        va_start(argumentList, titles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    
    self.otherButtonTitles = [self.otherButtonTitles arrayByAddingObjectsFromArray:tempButtonTitles];
    
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
}

- (void)appendButtonWithTitle:(NSString *)title atIndex:(NSInteger)index {
#ifdef DEBUG
    NSAssert(index != 0, @"Index 0 is cancel button");
    NSAssert(index <= self.otherButtonTitles.count + 1, @"Index crossed");
#endif
    
    NSMutableArray<NSString *> *arrayM = [NSMutableArray arrayWithArray:self.otherButtonTitles];
    [arrayM insertObject:title atIndex:index - 1];
    self.otherButtonTitles = [NSArray arrayWithArray:arrayM];
    
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
}

- (void)appendButtonsWithTitles:(NSArray<NSString *> *)titles atIndexes:(NSIndexSet *)indexes {
#ifdef DEBUG
    NSAssert(titles.count == indexes.count, @"Count of titles differs from count of indexs");
#endif
    
    NSMutableIndexSet *indexSetM = [[NSMutableIndexSet alloc] init];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
#ifdef DEBUG
        NSAssert(idx != 0, @"Index 0 is cancel button");
        NSAssert(idx <= self.otherButtonTitles.count + indexes.count, @"Index crossed");
#endif
        
        [indexSetM addIndex:idx - 1];
    }];
    
    NSMutableArray<NSString *> *arrayM = [NSMutableArray arrayWithArray:self.otherButtonTitles];
    [arrayM insertObjects:titles atIndexes:indexSetM];
    self.otherButtonTitles = [NSArray arrayWithArray:arrayM];
    
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
}
    
- (void)handleDidChangeStatusBarOrientation {
    if (self.autoHideWhenDeviceRotated) {
        [self hideWithButtonIndex:self.cancelButtonIndex];
    }
}

- (void)blurBottomBgView {
    self.whiteBgView.hidden = YES;
    
    if (!self.blurEffectView) {
        UIBlurEffect *blurEffect           = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.backgroundColor     = self.blurBackgroundColor;
        [self.bottomView addSubview:blurEffectView];
        [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomView);
        }];
        self.blurEffectView = blurEffectView;
        
        [self.bottomView sendSubviewToBack:blurEffectView];
    }
}

- (void)unBlurBottomBgView {
    self.whiteBgView.hidden = NO;
    
    if (self.blurEffectView) {
        [self.blurEffectView removeFromSuperview];
        self.blurEffectView = nil;
    }
}

#pragma mark - Setter & Getter

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    self.titleLabel.text = title;
    
    [self updateTitleLabel];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
    }];
    
    self.lineView.hidden = !self.title || self.title.length == 0;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = [cancelButtonTitle copy];
    
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self updateCancelButton];
}

- (void)setDestructiveButtonIndexSet:(NSIndexSet *)destructiveButtonIndexSet {
    _destructiveButtonIndexSet = destructiveButtonIndexSet;
    [self.tableView reloadData];
}

- (void)setUnBlur:(BOOL)unBlur {
    _unBlur = unBlur;
    
    if (unBlur) {
        [self unBlurBottomBgView];
    } else {
        [self blurBottomBgView];
    }
}

- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    _blurEffectStyle = blurEffectStyle;
    
    [self unBlurBottomBgView];
    [self blurBottomBgView];
}

- (void)setTitleFont:(UIFont *)aTitleFont {
    _titleFont = aTitleFont;
    
    self.titleLabel.font = aTitleFont;
    [self updateBottomView];
    [self updateTitleLabel];
}

- (void)setButtonFont:(UIFont *)aButtonFont {
    _buttonFont = aButtonFont;
    
    self.cancelButton.titleLabel.font = aButtonFont;
    [self.tableView reloadData];
}

- (void)setDestructiveButtonColor:(UIColor *)aDestructiveButtonColor {
    _destructiveButtonColor = aDestructiveButtonColor;
    
    if ([self.destructiveButtonIndexSet containsIndex:0]) {
        [self.cancelButton setTitleColor:self.destructiveButtonColor forState:UIControlStateNormal];
    } else {
        [self.cancelButton setTitleColor:self.buttonColor forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}

- (void)setTitleColor:(UIColor *)aTitleColor {
    _titleColor = aTitleColor;
    
    self.titleLabel.textColor = aTitleColor;
}

- (void)setButtonColor:(UIColor *)aButtonColor {
    _buttonColor = aButtonColor;
    
    [self.cancelButton setTitleColor:aButtonColor forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)setCancelButtonColor:(UIColor *)aButtonColor {
    [self.cancelButton setTitleColor:aButtonColor forState:UIControlStateNormal];
}

- (void)setButtonHeight:(CGFloat)aButtonHeight {
    _buttonHeight = aButtonHeight;
    
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
    [self updateCancelButton];
}

- (NSInteger)cancelButtonIndex {
    return 0;
}

- (void)setScrolling:(BOOL)scrolling {
    _scrolling = scrolling;
    
    [self updateBottomView];
    [self updateTableView];
}

- (void)setVisibleButtonCount:(CGFloat)visibleButtonCount {
    _visibleButtonCount = visibleButtonCount;
    
    [self updateBottomView];
    [self updateTableView];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    _titleEdgeInsets = titleEdgeInsets;
    
    [self updateBottomView];
    [self updateTitleLabel];
    [self updateTableView];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    
    self.lineView.backgroundColor = separatorColor;
    self.divisionView.backgroundColor = separatorColor;
    [self.tableView reloadData];
}

- (void)setBlurBackgroundColor:(UIColor *)blurBackgroundColor {
    _blurBackgroundColor = blurBackgroundColor;
    
    self.blurEffectView.backgroundColor = blurBackgroundColor;
}

- (void)setNumberOfTitleLines:(NSInteger)numberOfTitleLines {
    _numberOfTitleLines = numberOfTitleLines;
    
    [self updateBottomView];
    [self updateTitleLabel];
    [self updateTableView];
}

- (CGSize)titleTextSize {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width -
                             (self.titleEdgeInsets.left + self.titleEdgeInsets.right),
                             MAXFLOAT);
    
    NSStringDrawingOptions opts =
    NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSDictionary *attrs = @{NSFontAttributeName : self.titleFont};
    
    _titleTextSize =
    [self.title boundingRectWithSize:size
                             options:opts
                          attributes:attrs
                             context:nil].size;
    if (self.numberOfTitleLines != 0) {
      // with no attribute string use 'lineHeight' to acquire single line height.
      _titleTextSize.height = MIN(_titleTextSize.height, self.titleFont.lineHeight * self.numberOfTitleLines);
    }
    return _titleTextSize;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    NSString *buttonTitle = nil;
    if (index == self.cancelButtonIndex) {
        buttonTitle = self.cancelButtonTitle;
    } else {
        buttonTitle = self.otherButtonTitles[index - 1];
    }
    return buttonTitle;
}

- (void)setButtonTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index < 0 || index - 1 >= self.otherButtonTitles.count) {
        return;
    }
    if (index == self.cancelButtonIndex) {
        self.cancelButtonTitle = title;
    } else {
        NSMutableArray<NSString *> *arrayM = self.otherButtonTitles.mutableCopy;
        arrayM[index - 1] = title;
        self.otherButtonTitles = arrayM.copy;
        [self.tableView reloadData];
        [self updateBottomView];
        [self updateTableView];
    }
}

#pragma mark - Update Views

- (void)updateBottomView {
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height =
        (self.title.length > 0 ? self.titleTextSize.height + 2.0f + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom) : 0) +
        (self.otherButtonTitles.count > 0 ? (self.canScrolling ? MIN(self.visibleButtonCount, self.otherButtonTitles.count) : self.otherButtonTitles.count) * self.buttonHeight : 0) +
        (self.cancelButtonTitle.length > 0 ? 5.0f + self.buttonHeight : 0) +
        (isAlien ? iPhoneXBottomMargin : 0);
        make.height.equalTo(@(height));
    }];
}

- (void)updateTitleLabel {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(self.title.length > 0 ? self.titleEdgeInsets.top : 0);
        make.left.equalTo(self.bottomView).offset(self.titleEdgeInsets.left);
        make.right.equalTo(self.bottomView).offset(-self.titleEdgeInsets.right);
        
        CGFloat height = self.title.length > 0 ? self.titleTextSize.height + 2.0f : 0;  // Prevent omit
        make.height.equalTo(@(height));
    }];
}

- (void)updateTableView {
    if (!self.canScrolling) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.otherButtonTitles.count * self.buttonHeight));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
        }];
    } else {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(MIN(self.visibleButtonCount, self.otherButtonTitles.count) * self.buttonHeight));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
        }];
    }
}

- (void)updateCancelButton {
    [self.divisionView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = self.cancelButtonTitle.length > 0 ? 5.0f : 0;
        make.height.equalTo(@(height));
    }];
    
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = self.cancelButtonTitle.length > 0 ? self.buttonHeight : 0;
        make.height.equalTo(@(height));
    }];
}

#pragma mark - Show & Hide

- (void)show {
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [self.delegate willPresentActionSheet:self];
    }
    
    if (self.willPresentHandler) {
        self.willPresentHandler(self);
    }
    
    VHActionSheetViewController *viewController = [[VHActionSheetViewController alloc] init];
    viewController.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    viewController.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([UIDevice currentDevice].systemVersion.intValue == 9) { // Fix bug for keyboard in iOS 9
        window.windowLevel = CGFLOAT_MAX;
    } else {
        window.windowLevel = UIWindowLevelAlert;
    }
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
    self.window = window;
    
    [viewController.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
    
    [self.window layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.darkView.alpha = strongSelf.darkOpacity;
        strongSelf.darkView.userInteractionEnabled = !strongSelf.darkViewNoTaped;
        
        [strongSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(strongSelf);
        }];
        
        [strongSelf layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
            [strongSelf.delegate didPresentActionSheet:strongSelf];
        }
        
        if (strongSelf.didPresentHandler) {
            strongSelf.didPresentHandler(strongSelf);
        }
    }];
    
    [self configUIRectCorner];
}

//设置圆角
- (void)configUIRectCorner {
    if(_topCornerRadius > 0) {
        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(_topCornerRadius, _topCornerRadius)];
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc]init];
        shapLayer.frame = self.bottomView.bounds;
        shapLayer.path = cornerPath.CGPath;
        self.bottomView.layer.mask = shapLayer;
    }
}

- (void)hideWithButtonIndex:(NSInteger)buttonIndex {
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
        [self.delegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
    }
    
    if (self.willDismissHandler) {
        self.willDismissHandler(self, buttonIndex);
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.darkView.alpha = 0;
        strongSelf.darkView.userInteractionEnabled = NO;
        
        [strongSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = (strongSelf.title.length > 0 ? strongSelf.titleTextSize.height + 2.0f + (strongSelf.titleEdgeInsets.top + strongSelf.titleEdgeInsets.bottom) : 0) + (strongSelf.otherButtonTitles.count > 0 ? (strongSelf.canScrolling ? MIN(strongSelf.visibleButtonCount, strongSelf.otherButtonTitles.count) : strongSelf.otherButtonTitles.count) * strongSelf.buttonHeight : 0) + (strongSelf.cancelButtonTitle.length > 0 ? 5.0f + strongSelf.buttonHeight : 0) + (isAlien ? iPhoneXBottomMargin : 0);
            make.bottom.equalTo(strongSelf).offset(height);
        }];
        
        [strongSelf layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf removeFromSuperview];
        
        strongSelf.window.rootViewController = nil;
        strongSelf.window.hidden = YES;
        strongSelf.window = nil;
        
        if ([strongSelf.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
            [strongSelf.delegate actionSheet:strongSelf didDismissWithButtonIndex:buttonIndex];
        }
        
        if (strongSelf.didDismissHandler) {
            strongSelf.didDismissHandler(strongSelf, buttonIndex);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScrolling) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - VHActionSheet & UITableView Delegate

- (void)darkViewClicked {
    [self cancelButtonClicked];
}

- (void)cancelButtonClicked {
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
    
    if (self.clickedHandler) {
        self.clickedHandler(self, 0);
    }
    
    [self hideWithButtonIndex:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row + 1];
    }
    
    if (self.clickedHandler) {
        self.clickedHandler(self, indexPath.row + 1);
    }

  if (!self.disableAutoDismissAfterClicking) {
    [self hideWithButtonIndex:indexPath.row + 1];
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherButtonTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"VHActionSheetCell";
    VHActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[VHActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellID];
    }

    [cell setButtonEdgeInsets:self.buttonEdgeInsets];
    cell.titleLabel.font      = self.buttonFont;
    cell.titleLabel.textColor = self.buttonColor;
    cell.titleLabel.backgroundColor = self.buttonBgColor;

    cell.titleLabel.text = self.otherButtonTitles[indexPath.row];
    cell.titleLabel.layer.cornerRadius = self.buttonCornerRadius;
    [cell.titleLabel.layer setMasksToBounds:YES];

    cell.cellSeparatorColor = self.separatorColor;
    
//    cell.lineView.hidden = indexPath.row == MAX(self.otherButtonTitles.count - 1, 0);
    
    if (indexPath.row == MAX(self.otherButtonTitles.count - 1, 0)) {
        cell.tag = LC_ACTION_SHEET_CELL_HIDDE_LINE_TAG;
    } else {
        cell.tag = LC_ACTION_SHEET_CELL_NO_HIDDE_LINE_TAG;
    }
    
    if (self.destructiveButtonIndexSet) {
        if ([self.destructiveButtonIndexSet containsIndex:indexPath.row + 1]) {
            cell.titleLabel.textColor = self.destructiveButtonColor;
            cell.titleLabel.backgroundColor = self.destructiveButtonBgColor;
        } else {
            cell.titleLabel.textColor = self.buttonColor;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.buttonHeight;
}

@end
