//
//  APMSTitleView.m
//  APKit
//
//  Created by ChenYim on 16/4/14.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "APMSTitleView.h"

@interface UIColor(APMSTitleView)
- (float)APMS_R;
- (float)APMS_G;
- (float)APMS_B;
- (float)APMS_A;
- (NSArray<NSNumber *> *)APMS_RGBAValues;
@end

@implementation UIColor(APMSTitleView)

- (void)getRGBComponents:(CGFloat [3])components forColor:( UIColor *)color {
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

- (NSArray<NSNumber *> *)APMS_RGBAValues
{
    CGFloat R, G, B, A;
    
    CGColorRef colorRef = [self CGColor];
    unsigned long numComponents = CGColorGetNumberOfComponents(colorRef);
    const CGFloat *components = CGColorGetComponents(colorRef);
    if (numComponents == 4)
    {
        R = components[0];
        G = components[1];
        B = components[2];
        A = components[3];
    }
    else if (numComponents == 2) {
        R = components[0];
        G = components[0];
        B = components[0];
        A = components[1];
    }
    return @[@(R), @(G), @(B), @(A)];
}

- (float)APMS_R
{
    NSNumber *red = [[self APMS_RGBAValues] objectAtIndex:0];
    return [red floatValue];
}

- (float)APMS_G
{
    NSNumber *green = [[self APMS_RGBAValues] objectAtIndex:1];
    return [green floatValue];
}

- (float)APMS_B
{
    NSNumber *blue = [[self APMS_RGBAValues] objectAtIndex:2];
    return [blue floatValue];
}

- (float)APMS_A
{
    NSNumber *alpha = [[self APMS_RGBAValues] objectAtIndex:3];
    return [alpha floatValue];
}

@end

static const NSInteger kTitleBtnBaseTag = 10000;
static const NSTimeInterval kIndicatorViewAnimationDuration = 0.15;

#define SPACE_LEADING   (self.leadingSpace  == 0.0 ? 0.0 : self.leadingSpace)
#define SPACE_TRAILING  (self.trailingSpace == 0.0 ? 0.0 : self.trailingSpace)
#define SPACE_INTERVAL  (self.intervalSpace == 0.0 ? 0.0 : self.intervalSpace)
#define IndicateViewHeight (self.indicateViewHegiht == 0.0 ? 3.0  : self.indicateViewHegiht)
#define IndicateViewWidth  (self.indicateViewWidth == 0.0  ? 70.0 : self.indicateViewWidth)

@interface APMSTitleView()
{
    
}
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, assign) NSInteger currSelectedIdx;
@property (nonatomic, strong) NSMutableArray *buttonsArray;

@property (nonatomic, assign) BOOL ifFullFill;
@property (nonatomic, assign) BOOL ifNeedDefaultSelectAnimation;
@property (nonatomic, assign) CGFloat leadingSpace;
@property (nonatomic, assign) CGFloat trailingSpace;
@property (nonatomic, assign) CGFloat intervalSpace;

@property (nonatomic, strong) UIView *indicateView;
@property (nonatomic, assign) BOOL ifSetIndicatorWidthToFlexible;
@property (nonatomic, assign) CGFloat indicateViewWidth;
@property (nonatomic, assign) CGFloat indicateViewHegiht;
@end

@implementation APMSTitleView

#pragma mark - Wrapper

- (void)setCurrSelectedIdx:(NSInteger)currSelectedIdx
{
    if (currSelectedIdx >= 0 && currSelectedIdx < self.titlesArray.count)
    {
        CGRect toRect = [self getIndicatorViewFrameAtIndex:currSelectedIdx];
        self.indicateView.frame = toRect;

        [self callDidChangeIndicateView];
    }
    
    _currSelectedIdx = currSelectedIdx;
}

- (UIView *)indicateView
{
    if (_indicateView == nil)
    {
        CGRect frame = [self getIndicatorViewFrameAtIndex:0];
        _indicateView = [[UIView alloc] initWithFrame:frame];
        _indicateView.backgroundColor = [UIColor colorWithRed:37/255.0 green:183/255.0 blue:188/255.0 alpha:1.0];
        [self callDidChangeIndicateView];
    }
    return _indicateView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    self.scrollEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.currSelectedIdx = -1;
    self.buttonsArray = [NSMutableArray new];
    
    self.ifFullFill = NO;
    self.ifNeedDefaultSelectAnimation = NO;
    self.leadingSpace = 0.0;
    self.trailingSpace = 0.0;
    
    self.ifSetIndicatorWidthToFlexible = NO;
    self.indicateViewWidth = 0.0;
    self.indicateViewHegiht = 0.0;
}

#pragma mark - Public Method

-(void)setupDefaultSelectAnimation:(BOOL)ifNeedSelectAnimation
{
    self.ifNeedDefaultSelectAnimation = ifNeedSelectAnimation;
}

-(void)setupLeadingSpace:(CGFloat)leadingSpace trailingSpace:(CGFloat)trailingSpace intervalSpeace:(CGFloat)intervalSpace
{
    self.leadingSpace = leadingSpace;
    self.trailingSpace = trailingSpace;
    self.intervalSpace = intervalSpace;
}

-(void)setupIndicateViewWidth:(CGFloat)width Height:(CGFloat)height
{
    self.ifSetIndicatorWidthToFlexible = NO;
    self.indicateViewWidth = width;
    self.indicateViewHegiht = height;
}

- (void)setupIndicateViewToFlexibleWidth
{
    self.ifSetIndicatorWidthToFlexible = YES;
}

- (void)loadData
{
    // remove title buttons
    for(UIView *subView in self.subviews){
        [subView removeFromSuperview];
    }
    [self.buttonsArray removeAllObjects];
    
    // init indicateView
    [self addSubview:self.indicateView];
    
    // Add title buttons
    self.titlesArray = [self requestTitlesForMSTitleView];
    if (_titlesArray.count > 0){
        for(NSInteger i = 0; i < _titlesArray.count; i++){
            [self addTitleButton:_titlesArray[i] atIndex:i];
        }
    }
    
    // Set contentSize
    UIButton *lastButton = [_buttonsArray lastObject];
    CGSize cSize = CGSizeMake(CGRectGetMaxX(lastButton.frame) + SPACE_TRAILING, 1.0);
    _ifFullFill = (CGRectGetMaxX(lastButton.frame)+SPACE_TRAILING) > CGRectGetWidth(self.frame) ? NO : YES;

    if (_ifFullFill) {
        
        CGFloat blankSpace = self.bounds.size.width - CGRectGetMaxX(lastButton.frame) - SPACE_TRAILING;
        CGFloat intervalBlankSpace = blankSpace / (_buttonsArray.count + 1);

        for (UIButton *btn in _buttonsArray) {
            CGRect frame = btn.frame;
            if ([_buttonsArray indexOfObject:btn] == 0) {
                btn.frame = CGRectMake(intervalBlankSpace, frame.origin.y, frame.size.width, frame.size.height);
            }
            else{
                UIButton *lastBtn = [_buttonsArray objectAtIndex:([_buttonsArray indexOfObject:btn] - 1)];
                CGRect lastBtnFrame = lastBtn.frame;
                btn.frame = CGRectMake(CGRectGetMaxX(lastBtnFrame)+intervalBlankSpace, frame.origin.y, frame.size.width, frame.size.height);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentSize = self.frame.size;
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contentSize = cSize;
        });
    }
    

    
    [self selectTitleAtIndex:0];
}

- (void)selectTitleAtIndex:(NSInteger)index
{
    [self titleButtonClick:[self buttonWithIndex:index]];
}

- (void)willSelectTitleFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex percent:(CGFloat)percent
{
    if (percent > 1)
    {
        int deltaIndex = percent;
        percent = percent - deltaIndex;
        
        if (fromIndex > toIndex)
        {
            fromIndex -= deltaIndex;
            toIndex -=  deltaIndex;
        }
        else
        {
            fromIndex += deltaIndex;
            toIndex += deltaIndex;
        }
    }
    
    if (toIndex < 0 || toIndex >= self.titlesArray.count)
    {
        return;
    }
    
    CGRect fromRect = [self getIndicatorViewFrameAtIndex:fromIndex];
    CGRect toRect = [self getIndicatorViewFrameAtIndex:toIndex];

    CGRect indicatorRect = fromRect;
    indicatorRect.origin.x = fromRect.origin.x + (toRect.origin.x - fromRect.origin.x) * percent;
    indicatorRect.size.width = fromRect.size.width + (toRect.size.width - fromRect.size.width) * percent;
    self.indicateView.frame = indicatorRect;
//    Make contentView synchronous move.
//    UIButton *btn = [self.buttonsArray objectAtIndex:toIndex];
//    CGFloat btnCenterX = btn.center.x;
//    CGFloat halfFrameW = self.frame.size.width * 0.5;
//    CGFloat leftLimit  = halfFrameW;
//    CGFloat rightLimit = self.contentSize.width - halfFrameW;
//    if (btn.center.x>= leftLimit && btn.center.x <= rightLimit) {
//        [self setContentOffset:CGPointMake(btnCenterX - halfFrameW, 0) animated:YES];
//    }
//    else{
//        CGFloat edgeOffsetX = btn.center.x < leftLimit ? 0 : (self.contentSize.width - self.frame.size.width);
//        [self setContentOffset:CGPointMake(edgeOffsetX, 0) animated:YES];
//    }
    
    if (_ifNeedDefaultSelectAnimation) {
        
        if (percent == 0.0 || toIndex == _currSelectedIdx) {
            return;
        }
//        NSLog(@"%@",@(percent));
        [self modifyButtonInWillSelectDurationFrom:fromIndex toIndex:toIndex percent:percent];
    }
}

#pragma mark - Request data

- (NSArray<NSString *> *)requestTitlesForMSTitleView
{
    NSArray *titles;
    if ([self.titleViewDataSource respondsToSelector:@selector(titlesForMSTitleView:)]){
        titles = [self.titleViewDataSource titlesForMSTitleView:self];
    }
    return titles;
}

- (CGFloat)requestNormalFontSizeAtIndex:(NSInteger)index
{
    CGFloat normalFontSize = self.frame.size.height/2.0;
    if ([self.titleViewDataSource respondsToSelector:@selector(msTitleView:normalFontSizeAtIndex:)]){
        normalFontSize = [self.titleViewDataSource msTitleView:self normalFontSizeAtIndex:index];
    }
    return normalFontSize;
}

- (CGFloat)requestSelectedFontSizeAtIndex:(NSInteger)index
{
    CGFloat selectedFontSize = self.frame.size.height/2.0;
    if ([self.titleViewDataSource respondsToSelector:@selector(msTitleView:selectedFontSizeAtIndex:)]){
        selectedFontSize = [self.titleViewDataSource msTitleView:self selectedFontSizeAtIndex:index];
    }
    return selectedFontSize;
}

- (UIColor *)requestNormalFontColorAtIndex:(NSInteger)index
{
    UIColor *normalColor = [UIColor blackColor];
    if ([self.titleViewDataSource respondsToSelector:@selector(msTitleView:normalFontColorAtIndex:)]){
        normalColor = [self.titleViewDataSource msTitleView:self normalFontColorAtIndex:index];
    }
    
    return normalColor;
}

- (UIColor *)requestSelectedFontColorAtIndex:(NSInteger)index
{
    UIColor *selectedColor = [UIColor redColor];
    if ([self.titleViewDataSource respondsToSelector:@selector(msTitleView:selectedFontColorAtIndex:)]){
        selectedColor = [self.titleViewDataSource msTitleView:self selectedFontColorAtIndex:index];
    }
    
    return selectedColor;
}

- (UIImage *)requestNormalImageAtIndex:(NSInteger)index
{
    UIImage *normalImage = nil;
    if ([self.titleViewDataSource respondsToSelector:@selector(msTitleView:normalImageAtIndex:)]){
        normalImage = [self.titleViewDataSource msTitleView:self normalImageAtIndex:index];
    }
    
    return normalImage;
}

- (UIImage *)requestSelectedImageAtIndex:(NSInteger)index
{
    UIImage *selectedImage = nil;
    if ([self.titleViewDataSource respondsToSelector:@selector(msTitleView:selectImageAtIndex:)]){
        selectedImage = [self.titleViewDataSource msTitleView:self selectImageAtIndex:index];
    }
    
    return selectedImage;
}

#pragma mark - Call delegate method
- (void)callDidSelectIndex:(NSInteger)index
{
    if ([self.titleViewDelegate respondsToSelector:@selector(msTitleView:didSelectIndex:)])
    {
        [self.titleViewDelegate msTitleView:self didSelectIndex:index];
    }
}

- (void)callDidChangeIndicateView
{
    if ([self.titleViewDelegate respondsToSelector:@selector(msTitleView:didChangeIndicateView:)])
    {
        [self.titleViewDelegate msTitleView:self didChangeIndicateView:_indicateView];
    }
}

#pragma mark - Private Method

- (void)modifyButtonInWillSelectDurationFrom:(NSInteger)fromIdx toIndex:(NSInteger)toIdx percent:(CGFloat)percent
{
    UIButton *fromButton = [self buttonWithIndex:fromIdx];
    UIButton *toButton = [self buttonWithIndex:toIdx];
    
    for (UIButton *titleButton in _buttonsArray) {
        titleButton.selected = titleButton==toButton ? YES : NO;
    }
//    NSLog(@"%@-->%@  %.2f",fromButton.titleLabel.text,toButton.titleLabel.text,percent);
    [toButton.titleLabel setFont:[UIFont systemFontOfSize:[self titleFontSizeInWillSelectDuration:toIdx percent:percent]]];
    [toButton setTitleColor:[self titleColorInWillSelectDurationAtIndex:toIdx percent:percent] forState:UIControlStateSelected];
    [fromButton.titleLabel setFont:[UIFont systemFontOfSize:[self titleFontSizeInWillSelectDuration:fromIdx percent:(1-percent)]]];
    [fromButton setTitleColor:[self titleColorInWillSelectDurationAtIndex:fromIdx percent:(1.0-percent)] forState:UIControlStateNormal];
    NSLog(@"%@",[self titleColorInWillSelectDurationAtIndex:fromIdx percent:(1.0-percent)]);
}

- (UIColor *)titleColorInWillSelectDurationAtIndex:(NSInteger)idx percent:(CGFloat)percent
{
    UIColor *normalColor = [self requestNormalFontColorAtIndex:idx];
    UIColor *selectColor = [self requestSelectedFontColorAtIndex:idx];

    NSArray *normalColorValues = [normalColor APMS_RGBAValues];
    NSArray *selectedColorValues = [selectColor APMS_RGBAValues];
    CGFloat R,G,B,A;
    R = [normalColorValues[0] floatValue] + ([selectedColorValues[0] floatValue] - [normalColorValues[0] floatValue])*percent;
    G = [normalColorValues[1] floatValue] + ([selectedColorValues[1] floatValue] - [normalColorValues[1] floatValue])*percent;
    B = [normalColorValues[2] floatValue] + ([selectedColorValues[2] floatValue] - [normalColorValues[2] floatValue])*percent;
    A = [normalColorValues[3] floatValue] + ([selectedColorValues[3] floatValue] - [normalColorValues[3] floatValue])*percent;
//    NSLog(@"%@ %@ %@",@(R), @(G), @(B));
    return [UIColor colorWithRed:R green:G blue:B alpha:A];
}

- (float)titleFontSizeInWillSelectDuration:(NSInteger)idx percent:(CGFloat)percent
{
    CGFloat normalFontSize   = [self requestNormalFontSizeAtIndex:idx];
    CGFloat selectedFontSize = [self requestSelectedFontSizeAtIndex:idx];
    CGFloat fontSize = normalFontSize + (selectedFontSize - normalFontSize)*percent;
    return fontSize;
}

- (UIButton *)addTitleButton:(NSString *)title atIndex:(NSInteger)index
{
    UIFont *tmpNormalFont   = [UIFont systemFontOfSize:[self requestNormalFontSizeAtIndex:index]];
    UIFont *tmpSelectedFont = [UIFont systemFontOfSize:[self requestSelectedFontSizeAtIndex:index]];
    UIColor *tmpNormalColor = [self requestNormalFontColorAtIndex:index];
    UIColor *tmpSelectColor = [self requestSelectedFontColorAtIndex:index];
    UIImage *tmpNormalImage = [self requestNormalImageAtIndex:index];
    UIImage *tmpSelectImage = [self requestSelectedImageAtIndex:index];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:tmpNormalColor forState:UIControlStateNormal];
    [button setTitleColor:tmpSelectColor forState:UIControlStateSelected];
    [button.titleLabel setFont:tmpSelectedFont];
    button.tag = kTitleBtnBaseTag + index;

    if (tmpNormalImage) {
        [button setImage:tmpNormalImage forState:UIControlStateNormal];
    }
    if (tmpSelectImage) {
        [button setImage:tmpSelectImage forState:UIControlStateNormal];
    }
    
    [button sizeToFit];
    
    CGPoint buttonOrigin;
    if (index == 0){
        buttonOrigin = CGPointMake(SPACE_LEADING, 0);
    }
    else{
        UIButton *lastButton = _buttonsArray[index - 1];
        buttonOrigin = CGPointMake(CGRectGetMaxX(lastButton.frame) + SPACE_INTERVAL, 0);
    }
    CGSize buttonSize = CGSizeMake(button.bounds.size.width, self.bounds.size.height);
    button.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    
    [self addSubview:button];
    [self.buttonsArray addObject:button];
    
    [button.titleLabel setFont:tmpNormalFont];
    
    return button;
}

- (void)titleButtonClick:(id)sender
{
    // selected Font/image
    for (UIButton *titleButton in _buttonsArray) {
        titleButton.selected = titleButton==sender ? YES : NO;
        NSInteger titleButtonIdx = [self indexOfButton:titleButton];
        
        CGFloat fontSize = titleButton == sender ? [self requestSelectedFontSizeAtIndex:titleButtonIdx]:[self requestNormalFontSizeAtIndex:titleButtonIdx];
        [titleButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [titleButton setTitleColor:[self requestNormalFontColorAtIndex:titleButtonIdx] forState:UIControlStateNormal];
        [titleButton setTitleColor:[self requestSelectedFontColorAtIndex:titleButtonIdx] forState:UIControlStateSelected];
    }
    
    NSInteger selectedIndex = [self indexOfButton:sender];
    
    if (selectedIndex != self.currSelectedIdx){
        [self setIndicatorSelectIndex:selectedIndex];
        [self callDidSelectIndex:selectedIndex];
    }
}

- (void)setIndicatorSelectIndex:(NSInteger)index
{
    UIButton *btn = [self.buttonsArray objectAtIndex:index];
    CGFloat btnCenterX = btn.center.x;
    CGFloat halfFrameW = self.frame.size.width * 0.5;
    CGFloat leftLimit  = halfFrameW;
    CGFloat rightLimit = self.contentSize.width - halfFrameW;
    if (!_ifFullFill) {
        if (btn.center.x>= leftLimit && btn.center.x <= rightLimit) {
            [self setContentOffset:CGPointMake(btnCenterX - halfFrameW, 0) animated:YES];
        }
        else{
            CGFloat edgeOffsetX = btn.center.x < leftLimit ? 0 : (self.contentSize.width - self.frame.size.width);
            [self setContentOffset:CGPointMake(edgeOffsetX, 0) animated:YES];
        }
    }
    
    [UIView animateWithDuration:kIndicatorViewAnimationDuration animations:^{
        self.currSelectedIdx = index;
    }];
}


- (CGRect)getIndicatorViewFrameAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.titlesArray.count){ // index is wrong
        
        return CGRectMake(SPACE_LEADING, self.bounds.size.height - IndicateViewHeight, SPACE_LEADING, IndicateViewHeight);
    }
    else{
        UIButton *button = self.buttonsArray[index];
        CGRect frame;
        CGFloat indicatorW = _ifSetIndicatorWidthToFlexible ? CGRectGetWidth(button.frame):IndicateViewWidth;
        frame.origin.x = button.frame.origin.x + (button.frame.size.width - indicatorW)/2.0;
        frame.origin.y = self.bounds.size.height - IndicateViewHeight;
        frame.size.width = indicatorW;
        frame.size.height = IndicateViewHeight;
        
        return frame;
    }
}

- (UIButton *)buttonWithIndex:(NSInteger)idx
{
    UIButton *button = (UIButton *)[self viewWithTag:(idx + kTitleBtnBaseTag)];
    return button;
}

- (NSInteger)indexOfButton:(UIButton *)button
{
    NSInteger idx = button.tag - kTitleBtnBaseTag;
    return idx;
}

@end

