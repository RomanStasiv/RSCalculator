//
//  ViewController.m
//  RSCalculator
//
//  Created by Roman Stasiv on 11/23/15.
//  Copyright (c) 2015 Roman Stasiv. All rights reserved.
//

#import "ViewController.h"
#import "math.h"
#import "RSCalcBrain.h"
#import "RSCalcData0.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *screen;
@property (weak, nonatomic) IBOutlet UILabel *fakeExp;
@end

@implementation ViewController
bool userTyping = 0;
bool operationExpected = 0;
NSString* expression;


- (void)viewDidLoad
{
    [super viewDidLoad];
    expression = @"";
// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}

- (IBAction)digitPressed:(UIButton *)sender
{//updating screen
    if (userTyping == 0)
    {
        _screen.text = [NSString stringWithFormat:@"%ld" , sender.tag];
        userTyping = 1;
    }else
    {
        _screen.text = [NSString stringWithFormat:@"%@%@",_screen.text, [NSString stringWithFormat:@"%ld" , sender.tag]] ;
    }
}
- (IBAction)FloatPressed:(UIButton *)sender
{
    if ( [_screen.text rangeOfString:@"."].location == NSNotFound && userTyping)
    {
        _screen.text = [NSString stringWithFormat:@"%@%@",_screen.text, @"." ];
    }else if ( [_screen.text rangeOfString:@"."].location == NSNotFound )
    {
        _screen.text = [NSString stringWithFormat:@"%@", @"0."];
        userTyping = 1;
    }
}

- (IBAction)clear:(UIButton *)sender
{//screen clearing
    _screen.text = @"0";
    userTyping = 0;
    expression = @"";
    _fakeExp.text = @"";
    operationExpected = 0;
}

- (IBAction)changeSign
{
    double temp = [_screen.text doubleValue];
    temp = temp * (-1);
    if( temp != (-0) ) _screen.text = [[NSNumber numberWithDouble:temp] stringValue];
    else _screen.text = @"0";
}

- (IBAction)insertValue:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 801:
            _screen.text = @"2.71828"; userTyping = 0;
            break;
        case 802:
            _screen.text = @"3.14159"; userTyping = 0;
            break;
        case 803:
            _screen.text = [[NSNumber numberWithDouble: rand()] stringValue]; userTyping = 0;
            break;
            
        default:
            break;
    }
}

- (IBAction)operationInvoked:(UIButton *)sender
{
    NSString *value = _screen.text;
    if ([value hasPrefix:@"-"])
    {
        value = [NSString stringWithFormat:@"%@%@", [value substringFromIndex:1], @"m" ];
    }
    
    if ( operationExpected == true && ( sender.tag == 1001 || sender.tag == 1002 ) )
    {
        _fakeExp.text = [NSString stringWithFormat:@"%@%@", _fakeExp.text, sender.currentTitle ];
        expression = [NSString stringWithFormat:@"%@%@", expression, sender.currentTitle ];
        switch (sender.tag )
        {
            case 1001: operationExpected = 0; break;
            case 1002: operationExpected = 1; break;
        }
        userTyping = 0;
    }else
    if ( operationExpected == 0 )
    {
        switch (sender.tag )
        {
            case 1002: // +-*/^
            {
                operationExpected = 1;
            }
            case 1001: // ^2 ^3 ^(1/2) ^(1/3)
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@%@", _fakeExp.text, _screen.text, sender.currentTitle ];
                expression = [NSString stringWithFormat:@"%@%@%@", expression, value, sender.currentTitle ];
            }   break;
            case 1003:
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@%@", _fakeExp.text, @"1/", _screen.text ];
                expression = [NSString stringWithFormat:@"%@%@%@", expression, @"1/", value ];
                operationExpected = 1;
            }   break;
            case 1004:
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@%@", _fakeExp.text, @"ln", _screen.text ];
                expression = [NSString stringWithFormat:@"%@%@%@", expression, value, @"l" ];
                operationExpected = 1;
            }   break;
            case 1005:
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@%@", _fakeExp.text, @"log₁₀", _screen.text ];
                expression = [NSString stringWithFormat:@"%@%@%@", expression, value, @"L" ];
                operationExpected = 1;
            }   break;
            case 1006:
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@%@", _fakeExp.text, @"sin", _screen.text ];
                expression = [NSString stringWithFormat:@"%@%@%@", expression, value, @"s" ];
                operationExpected = 1;
            }   break;
            case 1007:
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@%@", _fakeExp.text, @"cos", _screen.text ];
                expression = [NSString stringWithFormat:@"%@%@%@", expression, value, @"c" ];
                operationExpected = 1;
            }   break;
            case 1008:
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@%@", _fakeExp.text, @"tan", _screen.text ];
                expression = [NSString stringWithFormat:@"%@%@%@", expression, value, @"t" ];
                operationExpected = 1;
            }   break;
        }
        if (sender.tag != 1102) { userTyping = 0; }
    }
    if (sender.tag == 1101 && (operationExpected == 0) )
    {
        _fakeExp.text = [NSString stringWithFormat:@"%@%@", _fakeExp.text, @"("];
        expression = [NSString stringWithFormat:@"%@%@", expression, @"(" ];
        operationExpected = 0;
    }
    if (sender.tag == 1102 && ( [_fakeExp.text rangeOfString:@"("].location != NSNotFound ))
    {
        NSRegularExpression *regexOpBreckets = [NSRegularExpression regularExpressionWithPattern:@"[(]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *regexClosingBreckets = [NSRegularExpression regularExpressionWithPattern:@"[)]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger opBrecketsCount = [regexOpBreckets numberOfMatchesInString:expression options:0 range:NSMakeRange(0, [expression length])];
        NSUInteger clBrecketsCount = [regexClosingBreckets numberOfMatchesInString:expression options:0 range:NSMakeRange(0, [expression length])];
        if ( opBrecketsCount == ( ++clBrecketsCount ) )
        {
            if (userTyping == 1)
            {
                _fakeExp.text = [NSString stringWithFormat:@"%@%@", _fakeExp.text, _screen.text];
                expression = [NSString stringWithFormat:@"%@%@", expression, value];
            }
            _fakeExp.text = [NSString stringWithFormat:@"%@%@", _fakeExp.text, @")"];
            expression = [NSString stringWithFormat:@"%@%@", expression, @")" ];
            operationExpected = 1; userTyping = 0;
        }
    }
}

- (IBAction)resPressed:(id)sender
{
    if (userTyping == 1){ expression = [NSString stringWithFormat:@"%@%@", expression, _screen.text]; }
    if ([RSCalcData1 validateString:expression])
    {
        _screen.text = [[RSCalcData1 procedeOperation:expression] stringValue];
        userTyping = 0; operationExpected = 0;
        NSLog(expression); NSLog(@"exp is ok");
        expression = @"";
        _fakeExp.text = @"";
    }
    else
    {
        NSLog(@"%@%@", @"String isnt valid: ", expression);
        userTyping = 0;
    }
}

@end
