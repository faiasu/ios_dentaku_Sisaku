//
//  CalcTest.m
//  dentaku
//
//  Created by Kazunori OYA on 12/08/03.
//  Copyright (c) 2012年 oya3.net. All rights reserved.
//

#import "CalcTest.h"

@implementation CalcTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    calc_ = [[Calc alloc]init];
}

- (void)tearDown
{
    // Tear-down code here.
    [calc_ release];
    
    [super tearDown];
}

- (void)testExample
{
    
    typedef struct {
        int digit;
        double value;
        NSString *string;
    }_TestCase;
    
    _TestCase cases[] = {
        // 少数部
        {   10,     0,              @"0" },         // 0
        {   10,     0.0,            @"0" },         // 1
        {   10,     0.00,           @"0" },         // 2
        {   10,     0.1,            @"0.1" },       // 3
        {   10,     0.01,           @"0.01" },      // 4
        {   10,     0.10,           @"0.1" },       // 5
        {   10,     0.100,          @"0.1" },       // 6
        {   10,     0.101,          @"0.101"},      // 7
        {   10,     0.1010,         @"0.101"},      // 8
        {   10,     0.1000000000,   @"0.1"},        // 9
        {   10,     0.1000000001,   @"0.1000000001"}, // 10
        {   10,     0.00000000005,  @"0.0000000001"}, // 11
        {   10,     0.00000000004,  @"0"},          // 12
        // 整数部
        {   10,       1,        @"1" }, // 13
        {   10,      10,       @"10" }, // 14
        {   10,     100,      @"100" }, // 15
        {   10,    1000,    @"1,000" }, // 16
        {   10,   10000,   @"10,000" }, // 17
        {   10,  100000,  @"100,000" }, // 18
        {   10, 1000000,@"1,000,000" }, // 19
        
    };

    
    // 試験実施
    for (int i=0; i<(sizeof(cases)/sizeof(_TestCase)); i++) {
        _TestCase *tcp = &cases[i];
        NSString *valueString = [[calc_ doubleToNSString:tcp->value digit:tcp->digit]autorelease];
        STAssertTrue([valueString isEqualToString:tcp->string],@"[%03d] digit[%d] value[%f] string[%@] reslut[%@]", i, tcp->digit, tcp->value, tcp->string, valueString);
    }
    
    
//    STFail(@"Unit tests are not implemented yet in dentakuTests");
//    STAssertEquals(0, 0,@"0==0");
}



@end
