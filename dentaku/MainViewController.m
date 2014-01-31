
//
//  MainViewController.m
//  dentaku
//
//  Created by Kazunori OYA on 12/07/25.
//  Copyright (c) 2012年 oya3.net. All rights reserved.
//

#import "MainViewController.h"
#import "HistoryViewController.h"
#import "CalculatoEvent.h"
#import "GradientButton.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize selectedIndex = selectedIndex_;

- (void)dealloc
{
    [calc_ release];
    [answerLabel_ release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 親の画面サイズを取得
        CGRect screenRect = [[UIScreen mainScreen]bounds]; // このサイズを基点に表示位置を計算できそう。。。
        NSLog(@"screenRect x(%f),y(%f),w(%f),h(%f)", 
              screenRect.origin.x, screenRect.origin.y,
              screenRect.size.width, screenRect.size.height);
        
        
        // 初期化
        [self setSelectedIndex:-1];
        calc_ = [[Calc alloc]init];

        event_ = [[CalculatoEvent alloc]init];
        data_ = [CalcMemory sharedInstance];

        // key 情報の初期化(今後ib側の設定を利用するべきか、計算ですべてやるべきかは考え中)
        // 数字
        int i = 0;
        for (; i<= KEYTYPE_9; i++) {
            KeyInfo *pKeyInfo = &keyInfo_[i];
            pKeyInfo->pos = CGPointMake(screenRect.origin.x + 100 + ((i%3) * 60),
                                        screenRect.origin.y + 100 + ((i/3) * 60));
            //NSLog(@"(%d) : pos.x(%f), pos.y(%f)", i, pKeyInfo->pos.x, pKeyInfo->pos.y);
            pKeyInfo->string = [[NSString alloc]initWithFormat:@"%d", i];
            pKeyInfo->keyType = (KEYTYPE)i;
            pKeyInfo->style = @"useBlackActionSheetStyle";
        }

        // その他
        // KEYTYPE_DOT, KEYTYPE_ADD, KEYTYPE_SUB, KEYTYPE_MUL, KEYTYPE_DIV, KEYTYPE_EQ,KEYTYPE_AC,KEYTYPE_C,
        NSArray *arrayString = 
        [NSArray arrayWithObjects:@".", @"+", @"-", @"x", @"/", @"=", @"AC", @"C", nil];
        NSArray *arrayStyle = [NSArray arrayWithObjects:
                               @"useBlackActionSheetStyle", // .
                               @"useAlertStyle", // +
                               @"useAlertStyle", // -
                               @"useAlertStyle", // x
                               @"useAlertStyle", // /
                               @"useSimpleOrangeStyle", // =
                               @"useRedDeleteStyle", // ac
                               @"useRedDeleteStyle", //c
                               nil];


        for (; i<=KEYTYPE_C; i++) {
            KeyInfo *pKeyInfo = &keyInfo_[i];
            int index = i - KEYTYPE_DOT;
            id obj = [arrayString objectAtIndex:index];
            id objStyle = [arrayStyle objectAtIndex:index];
            pKeyInfo->pos = CGPointMake(screenRect.origin.x + 50 + ((i%3) * 80),
                                        screenRect.origin.y + 100 + ((i/3) * 60));
            pKeyInfo->string = [[NSString alloc]initWithFormat:@"%@",obj];
            pKeyInfo->style = [[NSString alloc]initWithFormat:@"%@",objStyle];
            pKeyInfo->keyType = (KEYTYPE)i;
            pKeyInfo++;
        }

        self.navigationItem.title = @"履歴電卓";
        UIBarButtonItem *history = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(historyDidPush)];
                                    
        self.navigationItem.leftBarButtonItem = history;
        //self.navigationItem.rightBarButtonItem = history;
    }
    return self;
}

- (void)historyDidPush
{
    id viewController = [[[HistoryViewController alloc]init]autorelease];
    if( viewController ){
//        [viewController setHistory:[calc_ getCalcHistory]];
        [viewController setHistory:[data_ getHistory]];
        [viewController setHistoryViewDelegate:self];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    
    //[[UILabel appearance] setOnTintColor:[UIColor grayColor]];
    
    NSLog(@"viewDidLoad");
//    answerString_ = [[NSString alloc] initWithFormat:@"0"];
//    numberString_ = [[NSString alloc] initWithFormat:@"0"];

    // Button 配置
    for (int i=0; i<KEYTYPE_MAX; i++) {
        KeyInfo *pKeyInfo = &keyInfo_[i];
        NSString *name = [NSString stringWithFormat:@"%@",pKeyInfo->string];
        //GradientButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //GradientButton *button = [GradientButton buttonWithType:UIButtonTypeRoundedRect];
        CGRect rect = CGRectMake(0, 0, 70, 40);
        GradientButton *button = [[GradientButton alloc]initWithFrame:rect];

        button.tag = i;
        [button setTitle:name forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        //[button sizeToFit];
        button.center = CGPointMake(pKeyInfo->pos.x, pKeyInfo->pos.y);
        if ([pKeyInfo->style isEqualToString:@"useBlackActionSheetStyle"]) {
            [button useBlackActionSheetStyle];
        }
        
        else if ([pKeyInfo->style isEqualToString:@"useAlertStyle"]) {
            [button useAlertStyle];
        }
        
        if ([pKeyInfo->style isEqualToString:@"useSimpleOrangeStyle"]) {
            [button useSimpleOrangeStyle];
        }
        
        if ([pKeyInfo->style isEqualToString:@"useRedDeleteStyle"]) {
            [button useRedDeleteStyle];
        }
                 
        button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [button addTarget:self action:@selector(buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
//        [button useBlackActionSheetStyle];
        [self.view addSubview:button];
        //[button useBlackActionSheetStyle];
    }
//    // 結果表示
#ifndef GRDIENT_LABEL
    answerLabel_ = [[UILabel alloc]initWithFrame:CGRectZero];
    answerLabel_.backgroundColor = [UIColor blackColor];
    answerLabel_.numberOfLines = 2;
#else
    answerLabel_ = [[GradientLabel alloc]initWithFrame:CGRectZero];
    answerLabel_.backgroundColor = [UIColor blackColor];
    //    answerLabel_.numberOfLines = 2;
#endif

    answerLabel_.textColor = [UIColor whiteColor];
    answerLabel_.textAlignment = UITextAlignmentRight;

    //answerLabel_.text = [[NSString alloc] initWithFormat:@"%d",number_];

    answerLabel_.frame = CGRectMake( 10, 10, 300, 50);

    
#ifndef GRDIENT_LABEL
    // 外線
    answerLabel_.layer.borderColor = [[UIColor grayColor] CGColor];  //ボーダー色（白）
    answerLabel_.layer.borderWidth = 2.0;  //ボーダー幅（２ピクセル）
    answerLabel_.layer.cornerRadius = 10.0;  //角丸半径（10ピクセル）
    answerLabel_.layer.masksToBounds = YES;
#else
    [answerLabel_ setBorder:[UIColor grayColor] width:2 radius:10];
#endif
    
    answerLabel_.text = [[NSString alloc] initWithFormat:@"0\n---test--"];
    
    [self.view addSubview:answerLabel_];
    
    
#if 0
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = answerLabel_.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor blackColor] CGColor],
                       (id)[[UIColor darkGrayColor] CGColor], nil];
    //[answerLabel_.layer insertSublayer:gradient above:0];
    [answerLabel_.layer insertSublayer:gradient atIndex:1];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = answerLabel_.bounds;
    textLayer.string = (id)answerLabel_.text;
    [answerLabel_.layer insertSublayer:textLayer atIndex:0];
    //CATextLayer *textLayer = [[CATextLayer alloc]initWithLayer:answerLabel_.text];
    //[answerLabel_.layer insertSublayer:textLayer above:0];
    //answerLabel_.textLayer = [CATextLayer layer];
    //self.textLayer.string = self.text;
#endif

//    [[UILabel appearance] setOnTintColor:[UIColor greenColor]];
}

- (void)buttonDidPush: (id)sender
{
    
    
    NSLog(@"buttonDidPush tag(%d)", [sender tag]); // どのボタンイベントかが判断できればなんとかなりそう。
    
    KEYTYPE key = [sender tag];
   
    // 入力＆計算
//    [calc_ inputKey:key];
    [event_ inputKey:key];
    

    // 画面更新
    [self updateAnswerLabel];
}

// 表示エリアを更新する
- (void)updateAnswerLabel
{
    // 入力履歴も表示できるようにする
//    NSString *buffer = [NSString stringWithFormat:@"%@\n%@", calc_.displayString, calc_.displayString2];
    
//    NSString *buffer = [NSString stringWithFormat:@"%@\n%@", calc_.displayString, calc_.formulaString];
    NSString *buffer = [[NSString alloc]initWithFormat:@"%@\n%@", event_.displayString, event_.formulaString];
    answerLabel_.text = buffer;

#if 0 // プロパティを使ったムリムリ通知
    NSLog(@"selectedIndex[%d]", selectedIndex_);
    if( selectedIndex_ != -1 ){
        [calc_ selectedCalcHistoryIndex: selectedIndex_];
        // 画面更新
        [self updateAnswerLabel];
    }
#endif
}

- (void)selectedHistoryIndex:(int)index
{
    if( index != -1 ){
//        [calc_ selectedCalcHistoryIndex: index];
        [event_ selectedCalcHistoryIndex: index];
        // 画面更新
        [self updateAnswerLabel];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
