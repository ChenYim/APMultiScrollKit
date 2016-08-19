//
//  CourseAnalysisContentView.m
//  APKit
//
//  Created by ChenYim on 16/4/18.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "StageAnalysisContentView.h"

#define SADEF_LINE_COLOR [UIColor colorWithWhite:0.0 alpha:0.1]

#define SADEF_PADDING_LEFT (50.0*[APUIKit sourceOfIPhone6Scale])

#define SADEF_TEXTCOLOR1 [UIColor colorWithRed:37/255.0 green:183/255.0 blue:188/255.0 alpha:1.0]
#define SADEF_TEXTCOLOR2 [UIColor blackColor]
#define SADEF_TEXTMARKPADDING  (3.0*[APUIKit sourceOfIPhone6Scale])

#define SADEF_DOT_RADIUS  (5.0*[APUIKit sourceOfIPhone6Scale])
#define SADEF_DOT_LINEWIDTH  (2.0*[APUIKit sourceOfIPhone6Scale])
#define SADEF_DOT_LINECOLOR [UIColor colorWithRed:37/255.0 green:183/255.0 blue:188/255.0 alpha:1.0]

#define SADEF_CHARTLINE_COLOR [UIColor colorWithRed:37/255.0 green:183/255.0 blue:188/255.0 alpha:1.0]
#define SADEF_CHARTLINE_WIDTH  (2.0*[APUIKit sourceOfIPhone6Scale])

#define SADEF_SHADOWLENGTH  (40.0*[APUIKit sourceOfIPhone6Scale])

#define calculateTextSize(text, font) \
[text sizeWithAttributes:@{NSFontAttributeName:font}]

#pragma mark - StageAnalysisDrawTool -
@interface StageAnalysisDrawTool : NSObject

+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color;
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;
+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;
+ (void)drawDot:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)lineWidth;
@end

@implementation StageAnalysisDrawTool

+ (void)drawTriangle:(CGContextRef)context points:(NSArray *)points
{
    //三角形三顶点（p2必须是顶点）
    CGPoint pt1 = CGPointFromString(points[0]);
    CGPoint pt2 = CGPointFromString(points[1]);
    CGPoint pt3 = CGPointFromString(points[2]);
    
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    // 画三角形
    UIBezierPath *myPath = [UIBezierPath bezierPath];
    [myPath moveToPoint:pt1];
    [myPath addLineToPoint:pt2];
    [myPath addLineToPoint:pt3];
    [myPath addLineToPoint:pt1];
    [myPath stroke];
    
    CGContextSaveGState(context);
    [myPath addClip];
    
    CGContextSetStrokeColorWithColor(context, SADEF_CHARTLINE_COLOR.CGColor);
    CGContextSetFillColorWithColor(context, SADEF_CHARTLINE_COLOR.CGColor);
    
    // 为三角形填充渐变
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {
        37.0/255.0,183.0/255.0,188.0/255.0,0.5,
        1.0,1.0,1.0,0.5
    };
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint startPoint = pt2;
    CGPoint endPoint = CGPointMake(pt2.x, MIN(pt1.y, pt3.y));

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    CGContextRestoreGState(context);
    
//    [StageAnalysisDrawTool drawDot:context center:endPoint radius:SADEF_DOT_RADIUS color:[UIColor redColor] lineWidth:SADEF_DOT_LINEWIDTH]; // 画出阴影结束点
}

+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Pointcolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Pointcolorspace1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, point.x,point.y);
    CGContextAddArc(context, point.x, point.y, 2, 0, 360, 0);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    CGColorSpaceRelease(Pointcolorspace1);
}
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth{
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}

+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment
{
    [color set];

    CGSize title1Size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect titleRect1 = CGRectMake(point.x,
                                   point.y,
                                   title1Size.width,
                                   title1Size.height);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = textAlignment;
    NSMutableDictionary *attributes = [@{  NSFontAttributeName: font,
                                           NSForegroundColorAttributeName: color,
                                           NSParagraphStyleAttributeName: paragraphStyle
                                           } mutableCopy];
    
    [text drawInRect:titleRect1 withAttributes:attributes];
}

+ (void)drawDot:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)lineWidth
{
    CGContextSetShouldAntialias(context, YES); //抗锯齿
    CGColorSpaceRef Pointcolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Pointcolorspace1);
    CGContextSetLineWidth(context, lineWidth);//线的宽度
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    CGColorSpaceRelease(Pointcolorspace1);
}

@end

#pragma mark - StageAnalysisContentView -
@interface StageAnalysisContentView()
@property (nonatomic, strong) NSArray *pointsArry;
@property (nonatomic, strong) NSArray *titleArry;
@property (nonatomic, strong) NSArray *dataArry;
@end

@implementation StageAnalysisContentView


- (instancetype)initWithData:(NSArray<NSNumber *> *)dataArry TitleArry:(NSArray<NSString *> *)titleArry
{
    self = [super init];
    if (self) {
        self.dataArry = dataArry;
        self.titleArry = titleArry;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableArray *points = [NSMutableArray new];
    for (NSInteger i = 0 ; i < self.dataArry.count ;i++) {
        CGPoint pt = [self pointForValue:[self.dataArry[i] integerValue] Index:i+1];
        [points addObject:NSStringFromCGPoint(pt)];
    }
    self.pointsArry = [points copy];
    
    // 横隔线
    for (NSInteger i = 0 ; i < 11 ;i++) {
        [StageAnalysisDrawTool drawLine:context
                             startPoint:CGPointMake(SADEF_PADDING_LEFT, SADEF_PADDING_TOP + SADEF_GRID_HEIGHT * i + SADEF_GRID_LINEWIDTH * i)
                               endPoint:CGPointMake(SADEF_PADDING_LEFT + SADEF_GRID_WIDTH * SADEF_GRID_ColumnNum + SADEF_GRID_LINEWIDTH * SADEF_GRID_ColumnNum, SADEF_PADDING_TOP + SADEF_GRID_HEIGHT * i + SADEF_GRID_LINEWIDTH * i)
                              lineColor:SADEF_LINE_COLOR
                              lineWidth:SADEF_GRID_LINEWIDTH];
    }
    
    // 纵隔线
    for (NSInteger i = 0 ; i < (SADEF_GRID_ColumnNum+1) ;i++) {
        [StageAnalysisDrawTool drawLine:context
                             startPoint:CGPointMake(SADEF_PADDING_LEFT + SADEF_GRID_WIDTH * i + SADEF_GRID_LINEWIDTH * i, SADEF_PADDING_TOP)
                               endPoint:CGPointMake(SADEF_PADDING_LEFT + SADEF_GRID_WIDTH * i + SADEF_GRID_LINEWIDTH * i, SADEF_PADDING_TOP + SADEF_GRID_HEIGHT * 10 + SADEF_GRID_LINEWIDTH * 10)
                              lineColor:SADEF_LINE_COLOR
                              lineWidth:SADEF_GRID_LINEWIDTH];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attributes = [@{
                                         NSFontAttributeName: SADEF_TEXTFONT2,
                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSParagraphStyleAttributeName: paragraphStyle
                                         }
                                       mutableCopy];
    
    // 纵坐标
    for (NSInteger i = 0 ; i < 11 ;i++) {
        
        NSString *text = [NSString stringWithFormat:@"%ld",(long)(10 - i)*10];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:SADEF_TEXTFONT2}];
        CGRect rect = CGRectMake(SADEF_PADDING_LEFT - textSize.width - SADEF_TITLE_Y_PaddingRight, SADEF_PADDING_TOP + (SADEF_GRID_HEIGHT+SADEF_GRID_LINEWIDTH) * i - textSize.height/2.0, textSize.width, textSize.height);
        [text drawInRect:rect withAttributes:attributes];
    }
    
    // 横坐标
    for (NSInteger i = 0 ; i < _titleArry.count; i++) {
        
        NSString *text = _titleArry[i];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:SADEF_TEXTFONT2}];
        CGRect rect = CGRectMake(SADEF_PADDING_LEFT + (SADEF_GRID_WIDTH + SADEF_GRID_LINEWIDTH) * (i+1) - textSize.width/2.0, SADEF_PADDING_TOP + (SADEF_GRID_HEIGHT + SADEF_GRID_LINEWIDTH)*10 + SADEF_GRID_LINEWIDTH + SADEF_TITLE_X_PaddingTop, textSize.width, textSize.height);
        [text drawInRect:rect withAttributes:attributes];
    }
    
    // 原点标签
    NSString *text = @"评分/时间";
    CGContextSetFillColorWithColor(context, SADEF_TEXTCOLOR1.CGColor);
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:SADEF_TEXTFONT1}];
    CGRect textRect = CGRectMake(SADEF_PADDING_LEFT-textSize.width/2 - SADEF_TITLE_Y_PaddingRight, SADEF_PADDING_TOP + (SADEF_GRID_HEIGHT + SADEF_GRID_LINEWIDTH)*10 + SADEF_GRID_LINEWIDTH + SADEF_TITLE_O_PaddingTop, textSize.width, textSize.height);
    attributes[NSFontAttributeName] = SADEF_TEXTFONT1;
    [text drawInRect:textRect withAttributes:attributes];
    
    
    // 画渐变效果
    [self drawShadow:context];
    
    // 画点
    [self drawPointsAndLines:context];
}

- (void)drawPointsAndLines:(CGContextRef)context
{
    // 画线
    for (NSInteger i = 0 ; i < _pointsArry.count-1 ;i++) {
        
        CGPoint pt = CGPointFromString(_pointsArry[i]);
        CGPoint nextPt = CGPointFromString(_pointsArry[i+1]);
        [StageAnalysisDrawTool drawLine:context startPoint:pt endPoint:nextPt lineColor:SADEF_CHARTLINE_COLOR lineWidth:SADEF_CHARTLINE_WIDTH];
    }
    
    
    for (NSInteger i = 0 ; i < _pointsArry.count ;i++) {
        
        CGPoint pt = CGPointFromString(_pointsArry[i]);
        NSInteger value = [_dataArry[i] integerValue];
        NSString *text = [NSString stringWithFormat:@"%ld",(long)value];
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:SADEF_TEXTFONT1}];
        
        // 画值
        BOOL markOnTheTop = YES;
        if (i == 0) {
            NSInteger value = [_dataArry[i] integerValue];
            NSInteger nextValue = [_dataArry[i+1] integerValue];
            if (nextValue > value) {
                markOnTheTop = NO;
            }
        }
        else if (i == _pointsArry.count-1){
            NSInteger value = [_dataArry[i] integerValue];
            NSInteger lastValue = [_dataArry[i-1] integerValue];
            if (value < lastValue) {
                markOnTheTop = NO;
            }
        }
        else{
            NSInteger value = [_dataArry[i] integerValue];
            NSInteger lastValue = [_dataArry[i-1] integerValue];
            NSInteger nextValue = [_dataArry[i+1] integerValue];
            if (lastValue > value && nextValue > value) {
                markOnTheTop = NO;
            }
        }
        CGPoint textMarkPoint = markOnTheTop ? CGPointMake(pt.x - textSize.width/2, pt.y - SADEF_DOT_RADIUS - textSize.height - SADEF_TEXTMARKPADDING) : CGPointMake(pt.x - textSize.width/2, pt.y + SADEF_DOT_RADIUS + SADEF_TEXTMARKPADDING);
        [StageAnalysisDrawTool drawText:context text:text point:textMarkPoint color:SADEF_TEXTCOLOR1 font:SADEF_TEXTFONT1 textAlignment:NSTextAlignmentCenter];
        // 画点
        [StageAnalysisDrawTool drawDot:context center:pt radius:SADEF_DOT_RADIUS color:SADEF_DOT_LINECOLOR lineWidth:SADEF_DOT_LINEWIDTH];
    }
}

- (void)drawShadow:(CGContextRef)context
{
    if (_pointsArry.count < 3) return;
    
    for (NSInteger i = 1 ; i < _pointsArry.count-1 ;i++) {
        CGPoint pt1 = CGPointFromString(_pointsArry[i-1]);
        CGPoint pt2 = CGPointFromString(_pointsArry[i]);
        CGPoint pt3 = CGPointFromString(_pointsArry[i+1]);
        
        if (pt2.y < pt1.y && pt2.y < pt3.y) { // 存在高点
            [StageAnalysisDrawTool drawTriangle:context points:@[NSStringFromCGPoint(pt1),
                                                                 NSStringFromCGPoint(pt2),
                                                                 NSStringFromCGPoint(pt3)
                                                                 ]];
        }
    }
}

- (CGPoint)pointForValue:(NSInteger)value Index:(NSInteger)idx
{
    CGFloat percent = 1.0 - value/100.0;
    CGFloat y = (SADEF_GRID_HEIGHT * 10 + SADEF_GRID_LINEWIDTH * 11) * percent;
    CGPoint pt = CGPointMake(SADEF_PADDING_LEFT + (SADEF_GRID_WIDTH + SADEF_GRID_LINEWIDTH) * idx, SADEF_PADDING_TOP + y);
    return pt;
}

@end
