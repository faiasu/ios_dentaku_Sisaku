//
//  GradientLabel.h
//  dentaku
//
//  Created by Kazunori OYA on 12/08/06.
//  Copyright (c) 2012年 oya3.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientLabel : UIView
{
    //NSString *text_; この宣言はあっても無くてもいいらしい。。。
}

@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, retain) NSString* text;
@property(nonatomic) UITextAlignment textAlignment;

- (void)setBorder:(UIColor *)color width:(float)width radius:(float)radius;

@end
