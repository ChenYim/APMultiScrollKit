//
//  CourseAnalysisContentView.m
//  APKit
//
//  Created by ChenYim on 16/4/19.
//  Copyright © 2016年 __companyName__. All rights reserved.
//

#import "CourseAnalysisContentView.h"

#define CADEF_TEXTFONT1 (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? [UIFont systemFontOfSize:13.0] : [UIFont systemFontOfSize:9.0])
#define CADEF_TEXTFONT2 (([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad)? [UIFont systemFontOfSize:16.0] : [UIFont systemFontOfSize:11.0])

#define CADEF_TEXTCOLOR1 [UIColor colorWithRed:37/255.0 green:183/255.0 blue:188/255.0 alpha:1.0]
#define CADEF_TEXTCOLOR2 [UIColor blackColor]

#define CADEF_TEXTMARKPADDING  (3.0*[APUIKit sourceOfIPhone6Scale])
#define CADEF_OriginCoordinatePADDING  (5.0*[APUIKit sourceOfIPhone6Scale])

#define CADEF_BARCOLOR1 [UIColor colorWithRed:1/255.0 green:188/255.0 blue:205/255.0 alpha:1.0]
#define CADEF_BARCOLOR2 [UIColor colorWithRed:239/255.0 green:79/255.0 blue:118/255.0 alpha:1.0]
#define CADEF_BARCOLOR3 [UIColor colorWithRed:255/255.0 green:196/255.0 blue:62/255.0 alpha:1.0]
#define CADEF_BARCOLOR4 [UIColor colorWithRed:202/255.0 green:154/255.0 blue:233/255.0 alpha:1.0]
#define CADEF_BARCOLOR5 [UIColor colorWithRed:154/255.0 green:215/255.0 blue:211/255.0 alpha:1.0]
#define CADEF_BARCOLOR6 [UIColor colorWithRed:246/255.0 green:153/255.0 blue:61/255.0 alpha:1.0]
#define CADEF_BARCOLOR7 [UIColor colorWithRed:182/255.0 green:203/255.0 blue:152/255.0 alpha:1.0]
#define CADEF_BARCOLOR8 [UIColor colorWithRed:121/255.0 green:139/255.0 blue:201/255.0 alpha:1.0]
#define CADEF_BARCOLOR9 [UIColor colorWithRed:74/255.0 green:141/255.0 blue:219/255.0 alpha:1.0]

#define calculateTextSize(text, font) \
    [text sizeWithAttributes:@{NSFontAttributeName:font}]

#define drawText_CENTER_CLIPPING(text, textRect, font, color)\
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];\
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;\
        paragraphStyle.alignment = NSTextAlignmentCenter;\
        [text drawInRect:textRect withAttributes:@{\
                                    NSFontAttributeName:font,\
                                    NSForegroundColorAttributeName:color,\
                                    NSParagraphStyleAttributeName:paragraphStyle \
        }]

#pragma mark - CourseAnalysisDrawTool -
@interface CourseAnalysisDrawTool : NSObject

+ (void)drawPoint:(CGContextRef)context point:(CGPoint)point color:(UIColor *)color;
+ (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth;
+ (void)drawText:(CGContextRef)context text:(NSString*)text point:(CGPoint)point color:(UIColor *)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;
+ (void)drawText2:(CGContextRef)context text:(NSString*)text color:(UIColor *)color fontSize:(CGFloat)fontSize;
+ (void)drawDot:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color lineWidth:(CGFloat)lineWidth;
@end

@implementation CourseAnalysisDrawTool

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
    CGSize title1Size = calculateTextSize(text, font);
    CGRect titleRect = CGRectMake(point.x,
                                   point.y,
                                   title1Size.width,
                                   title1Size.height);
    drawText_CENTER_CLIPPING(text, titleRect, font, color);
}

+ (void)drawText2:(CGContextRef)context text:(NSString*)text color:(UIColor *)color fontSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGContextSelectFont(context, font.fontName.UTF8String, fontSize, kCGEncodingMacRoman);
#pragma clang diagnostic pop
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGAffineTransform xform = CGAffineTransformMake(
                                                    1.0,  0.0,
                                                    0.0, -1.0,
                                                    0.0,  0.0);
    CGContextSetTextMatrix(context, xform);
    const char* ctext = text.UTF8String;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGContextShowTextAtPoint(context, 10, 100, ctext, strlen(ctext));
#pragma clang diagnostic pop
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

#pragma mark - CourseAnalysisContentView -
@interface CourseAnalysisContentView()

@property (nonatomic, strong) NSArray *dataArry;
@property (nonatomic, strong) NSArray *colorArry;
@end

@implementation CourseAnalysisContentView

- (instancetype)initWithData:(NSArray *)dataArry
{
    self = [super init];
    if (self) {
        self.dataArry = dataArry;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colorArry = @[CADEF_BARCOLOR1, CADEF_BARCOLOR2, CADEF_BARCOLOR3, CADEF_BARCOLOR4, CADEF_BARCOLOR5, CADEF_BARCOLOR6, CADEF_BARCOLOR7, CADEF_BARCOLOR8, CADEF_BARCOLOR9];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat rectH = rect.size.height;
    
    CGFloat contentHeight = self.dataArry.count*CADEF_GRID_HEIGHT*2;
    // 纵隔线
    for (NSInteger i = 0 ; i < 11 ;i++) {
        [CourseAnalysisDrawTool drawLine:context
                              startPoint:CGPointMake(CADEF_PADDING_LEFT + CADEF_GRID_WIDTH * i + CADEF_GRIDLINE_WIDTH * i, CADEF_PADDING_TOP)
                                endPoint:CGPointMake(CADEF_PADDING_LEFT + CADEF_GRID_WIDTH * i + CADEF_GRIDLINE_WIDTH * i, CADEF_PADDING_TOP + contentHeight)
                               lineColor:CADEF_GRIDLINE_COLOR
                               lineWidth:CADEF_GRIDLINE_WIDTH];
    }
    
    
    NSInteger numOfHorizonBar = (rectH - CADEF_PADDING_TOP)/CADEF_GRID_HEIGHT;
    
    // 横隔线
    for (NSInteger i = 1 ; i < numOfHorizonBar ;i+=2) {
        [CourseAnalysisDrawTool drawLine:context
                              startPoint:CGPointMake(CADEF_PADDING_LEFT, CADEF_PADDING_TOP + CADEF_GRID_HEIGHT * i + CADEF_GRID_HEIGHT * 0.5)
                                endPoint:CGPointMake(CADEF_PADDING_LEFT + CADEF_GRID_WIDTH * 10 + CADEF_GRIDLINE_WIDTH * 10, CADEF_PADDING_TOP + CADEF_GRID_HEIGHT * i + CADEF_GRID_HEIGHT * 0.5)
                               lineColor:CADEF_GRIDLINE_COLOR
                               lineWidth:CADEF_GRID_HEIGHT];
    }
    
    // 纵坐标
    for (NSInteger i = 0 ; i < self.dataArry.count ;i++) {

        NSDictionary *barDic = _dataArry[i];
        NSString *text = barDic[@"subject"];
        CGSize textSize = calculateTextSize(text, CADEF_TEXTFONT2);
        CGRect textRect = CGRectMake( CADEF_PADDING_LEFT - textSize.width -  CADEF_TITLE_Y_PaddingRight, CADEF_PADDING_TOP + (2*i+1)* CADEF_GRID_HEIGHT + (CADEF_GRID_HEIGHT -textSize.height)/2, textSize.width, textSize.height);
        drawText_CENTER_CLIPPING(text, textRect, CADEF_TEXTFONT2, [UIColor blackColor]);
    }
    
    // 横坐标
    for (NSInteger i = 0 ; i < 11; i++) {
        
        NSString *text = [NSString stringWithFormat:@"%ld", (long)i*10];
        CGSize textSize = calculateTextSize(text, CADEF_TEXTFONT2);
        CGRect textRect = CGRectMake(CADEF_PADDING_LEFT + (CADEF_GRID_WIDTH + CADEF_GRIDLINE_WIDTH) * i - textSize.width/2.0, CADEF_PADDING_TOP - textSize.height - CADEF_TEXTMARKPADDING, textSize.width, textSize.height);
        drawText_CENTER_CLIPPING(text, textRect, CADEF_TEXTFONT2, [UIColor blackColor]);
    }
    
    // 原点标签
    NSString *text = @"科目/评分";
    CGSize textSize = calculateTextSize(text, CADEF_TEXTFONT1);
    CGRect textRect = CGRectMake(CADEF_PADDING_LEFT-textSize.width - CADEF_OriginCoordinatePADDING, CADEF_PADDING_TOP-textSize.height - CADEF_OriginCoordinatePADDING, textSize.width, textSize.height);
    drawText_CENTER_CLIPPING(text, textRect, CADEF_TEXTFONT1, CADEF_TEXTCOLOR1);
    
    // 画柱形
    [self drawBars:context];
}



- (void)drawBars:(CGContextRef)context
{
    for (NSInteger i = 1 ; i <= _dataArry.count ;i++) {
        
        NSDictionary *barDic = _dataArry[i-1];
        NSString *valueStr   = barDic[@"value"];
        NSInteger value   = [valueStr integerValue];
        
        CGPoint startPt = CGPointMake(CADEF_PADDING_LEFT, CADEF_PADDING_TOP + CADEF_GRID_HEIGHT * (2*i-1) + CADEF_GRID_HEIGHT * 0.5);
        CGPoint endPt = CGPointMake(CADEF_PADDING_LEFT + (10*CADEF_GRID_WIDTH + 11*CADEF_GRIDLINE_WIDTH)*(value/100.0), CADEF_PADDING_TOP + CADEF_GRID_HEIGHT * (2*i-1) + CADEF_GRID_HEIGHT * 0.5);
        UIColor *barColor = [self getColorForBarAtIndex:i];
        
        // 画柱形
        [CourseAnalysisDrawTool drawLine:context startPoint:startPt endPoint:endPt lineColor:barColor lineWidth:CADEF_GRID_HEIGHT];
        
        // 标记柱形值
        CGSize textSize = calculateTextSize(valueStr, CADEF_TEXTFONT1);
        CGRect textRect = CGRectMake(endPt.x + CADEF_TEXTMARKPADDING,endPt.y - textSize.height/2.0, textSize.width, textSize.height);
        drawText_CENTER_CLIPPING(valueStr, textRect, CADEF_TEXTFONT1, barColor);
    }
}

- (UIColor *)getColorForBarAtIndex:(NSInteger)idx
{
    NSInteger colorIdx = idx % 9;
    return self.colorArry[colorIdx];
}

@end
