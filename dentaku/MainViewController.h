//
//  MainViewController.h
//  dentaku
//
//  Created by Kazunori OYA on 12/07/25.
//  Copyright (c) 2012年 oya3.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Key.h"
#import "Keyboard10.h"
#import "Calc.h"
#import "HistoryViewDelegate.h"
#import "GradientLabel.h"
#import "CalculatoEvent.h"
#import "CalcState.h"

#define GRDIENT_LABEL

@interface MainViewController : UIViewController <HistoryViewDelegate>
{
    @private
    KeyInfo keyInfo_[KEYTYPE_MAX];
    Calc *calc_;
    CalcMemory *data_;
    CalculatoEvent *event_;
#ifndef GRDIENT_LABEL
    UILabel *answerLabel_;
#else
    GradientLabel *answerLabel_;
#endif
    NSInteger selectedIndex_;
}

@property(nonatomic) NSInteger selectedIndex;

@end
