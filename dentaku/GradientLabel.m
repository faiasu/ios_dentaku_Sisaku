//
//  GradientLabel.m
//  dentaku
//
//  Created by Kazunori OYA on 12/08/06.
//  Copyright (c) 2012年 oya3.net. All rights reserved.
//

#import "GradientLabel.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS   5.0


@interface GradientLabel()
@property (nonatomic, assign) CAGradientLayer* gradientLayer;
@property (nonatomic, assign) CATextLayer* textLayer;
@end

#define PADDING_X     10.0

@implementation GradientLabel

@synthesize gradientLayer = gradientLayer_;
@synthesize textLayer = textLayer_;
@synthesize textColor = textColor_;
@synthesize text = text_;
@synthesize textAlignment = textAlignment_;

- (void)_setup
{
    // setup basics
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor blackColor];
    
#if 0
    // setup base layer
    self.layer.cornerRadius = CORNER_RADIUS;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.75].CGColor;
    self.layer.borderWidth = 1.0;
#endif
    
    // setup gradient layer
    self.textAlignment = UITextAlignmentCenter;
    
    self.gradientLayer = [CAGradientLayer layer];

    self.gradientLayer.colors =
    [NSArray arrayWithObjects:
     (id)[UIColor colorWithWhite:1.0 alpha:0.4].CGColor,
     (id)[UIColor colorWithWhite:1.0 alpha:0.2].CGColor,
     (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
     nil];
    
    
    [self.layer addSublayer:self.gradientLayer];
    
    // setup text layer
    self.textLayer = [CATextLayer layer];
//    self.textLayer.frame = self.bounds;
    self.textLayer.string = self.text;
    self.textLayer.fontSize = 20;
    self.textLayer.truncationMode = kCATruncationEnd;
    [self.layer addSublayer:self.textLayer];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.textLayer.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
    self.textLayer.foregroundColor = self.textColor.CGColor;
    self.textLayer.foregroundColor = self.textColor.CGColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self _setup];        
    }
    return self;
}

- (void)dealloc {
    self.textColor = nil;
    self.text = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Properties
- (void)setText:(NSString *)text
{
    if (text_) {
        [text_ release];
    }
    text_ = text; //tmp;
    self.textLayer.string = text_;
    
    float r = self.layer.cornerRadius;
    float b = self.layer.borderWidth;
    self.textLayer.frame = CGRectMake(r,
                                      b,
                                      self.frame.size.width  - (r*2),
                                      self.frame.size.height - (b*2)
                                      );
    
#if 0   
    //CGSize textSize = [text_ sizeWithFont:[self _font]];
    self.textLayer.frame = CGRectMake(PADDING_X,
                                      (self.frame.size.height - textSize.height)/2.0 + 2,
                                      self.frame.size.width - PADDING_X*2,
                                      textSize.height);
#endif
}


- (void)setTextAlignment:(UITextAlignment)textAlignment
{
    textAlignment_ = textAlignment;
    switch (textAlignment) {
        case UITextAlignmentLeft:
            self.textLayer.alignmentMode = kCAAlignmentLeft;
            break;
        case UITextAlignmentRight:
            self.textLayer.alignmentMode = kCAAlignmentRight;
            break;
        case UITextAlignmentCenter:
            self.textLayer.alignmentMode = kCAAlignmentLeft;
        default:
            break;
    }
}


- (void)setBorder:(UIColor *)color width:(float)width radius:(float)radius
{
    // 外線
    self.layer.borderColor = [color CGColor];  //ボーダー色（白）
    self.layer.borderWidth = width;  //ボーダー幅（２ピクセル）
    self.layer.cornerRadius = radius;  //角丸半径（10ピクセル）
    self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
