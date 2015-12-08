//
//  RSCalcData0.m
//
//
//  Created by Roman Stasiv on 11/26/15.
//
//

#import <Foundation/Foundation.h>
#import "RSCalcData0.h"

typedef NS_OPTIONS(NSUInteger, opPrecedence)
{
    plusMinus = 1,
    multDivision = 2,
    power= 3,
    
    brackets = 0
};

@implementation RSCalcData1
RSCalcData1 *instance = nil;

+(NSNumber*) procedeOperation: (NSString*) expression
{
    if ( [(expression = [RSCalcData1 infixToRPN:expression]) isEqualToString:@"wrongInput"] )
    {
        return [NSNumber numberWithInt:-1];
    }
    NSMutableArray* stack = [NSMutableArray array];
    NSString *operationsBin = @"+-*/^";
    NSString *operationsUn = @"sctlLm";
    NSString *singleDigit = [[NSString alloc] init];
    for (int i = 0; i <= [expression length]-1; i++ )
    {
        NSLog(@"%@", stack) ;
        char c = [expression characterAtIndex:i];
        if (c == ';' )
        {
            [stack addObject:singleDigit];
            singleDigit = [[NSMutableString alloc] init];
        } else
            if( [operationsBin rangeOfString:[NSString stringWithFormat:@"%c",c]].location != NSNotFound)
            {
                if([stack count] >= 2)
                {
                    double b = [[stack lastObject] doubleValue]; [stack removeLastObject];
                    double a = [[stack lastObject] doubleValue]; [stack removeLastObject];
                    switch (c)
                    {
                        case '+': {a += b; } break;
                        case '-': {a -= b; } break;
                        case '*': {a *= b; } break;
                        case '/': {a /= b; } break;
                        case '^': {a = pow(a,b); } break;
                    }
                    [stack addObject:[NSString stringWithFormat:@"%f",a ]];
                }
            } else
            if( [operationsUn rangeOfString:[NSString stringWithFormat:@"%c",c]].location != NSNotFound)
            {
                if([stack count] >= 1 )
                {
                    double a = [[stack lastObject] doubleValue]; [stack removeLastObject];
                    switch (c)
                    {
                        case 's': {a = sin(a*(M_PI/180)); } break;
                        case 'c': {a = cos(a*(M_PI/180)); } break;
                        case 't': {a = tan(a*(M_PI/180)); } break;
                        case 'l': {a = log(a); } break;
                        case 'L': {a = log10(a); } break;
                        case 'm': {a = a*(-1); } break;
                            
                    }
                    [stack addObject:[NSString stringWithFormat:@"%f",a ]];
                }
            } else
            {
                singleDigit = [NSString stringWithFormat:@"%@%c",singleDigit,c];
            }
    }
    return [NSNumber numberWithDouble:[[stack objectAtIndex:[stack count]-1] doubleValue] ];
}

+(NSString*) infixToRPN: (NSString*) infixExpression
{
    NSString *RPNExpression = @"";
    NSString *operations = @"+-*/^sctlLm"; NSString *digits = @"0123456789.";
    NSString *singleDigit = [[NSString alloc] init];
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= [infixExpression length]-1; i++ )
    {
        char c = [infixExpression characterAtIndex:i];
        if ([operations rangeOfString:[NSString stringWithFormat:@"%c",c]].location != NSNotFound)
        {//if c is operation
            if ( ![singleDigit isEqualToString:@""] ) { RPNExpression = [NSString stringWithFormat:@"%@%@%c", RPNExpression, singleDigit, ';']; singleDigit = @""; } //digit to out
            while ( ([stack count] != 0) && [RSCalcData1 precedenceOf:[[stack lastObject] characterAtIndex:0] comparingTo:c] )
            {//if precedence of stack.top > c
                RPNExpression = [NSString stringWithFormat:@"%@%c", RPNExpression, [[stack lastObject] characterAtIndex:0] ];
                [stack removeLastObject];
            }
            [stack addObject:[NSString stringWithFormat: @"%c", c]];
            
        }
        if ([digits rangeOfString:[NSString stringWithFormat:@"%c",c]].location != NSNotFound)
        {//if c is a part of some digit then append it
            //nope
            singleDigit = [NSString stringWithFormat:@"%@%c", singleDigit, c];
        }
        
        if (c == '(') { [stack addObject:[NSString stringWithFormat:@"%c",c]];}
        if (c == ')')
        {
            if ( ![singleDigit isEqualToString:@""] ) { RPNExpression = [NSString stringWithFormat:@"%@%@%c", RPNExpression, singleDigit, ';']; singleDigit = @""; } // digit to out
            while ( ([stack count] != 0) && !([[stack lastObject] isEqualToString:@"("]) )
            {
                RPNExpression = [NSString stringWithFormat:@"%@%c", RPNExpression, [[stack lastObject] characterAtIndex:0] ];
                [stack removeLastObject];
            }
            [stack removeLastObject];
        }
    }
    
    if (![singleDigit isEqualToString:@""])
    {//moving last digit to output
        RPNExpression = [NSString stringWithFormat:@"%@%@%c", RPNExpression, singleDigit, ';']; singleDigit = @"";
    }
    while ( [stack count] != 0 )
    {//clearing stack
        RPNExpression = [NSString stringWithFormat:@"%@%c", RPNExpression, [[stack lastObject] characterAtIndex:0] ];
        [stack removeLastObject];
    }
    NSLog (RPNExpression);
    return RPNExpression;
}

+(BOOL) precedenceOf: (char)c comparingTo: (char) b
{
    opPrecedence stackedOp = 0;
    if (c == '+' || c == '-') { stackedOp = 1; }
    if (c == '*' || c == '/') { stackedOp = 2; }
    if (c == '^' || c == 's' || c == 'c' || c == 't' || c == 'l' || c == 'L' || c == 'm' ) { stackedOp = 3; }
    if (c == '(') { stackedOp = 0; }
    opPrecedence newOp = 0;
    if (b == '+' || b == '-') { newOp = 1; }
    if (b == '*' || b == '/') { newOp = 2; }
    if (b == '^' || b == 's' || b == 'c' || b == 't' || b == 'l' || b == 'L' || b == 'm') { newOp = 3; }
    if (b == '(') { newOp = 0; }
    
    return stackedOp > newOp;
}

+(BOOL) validateString:(NSString *)exp
{
    if ( [exp isEqualToString:@""] ) {return 0; }
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    for (int i = 0; i <= [exp length]-1; i++ )
    {
        char c = [exp characterAtIndex:i];
        if ( c == '(' ) { [stack addObject:[NSString stringWithFormat:@"%c",c ]]; }
        if ( c == ')' )
        {
            if ( [stack count] == 0 )
            {
                return 0;
            } else
            {
                [stack removeLastObject];
            }
        }
    }
    if ( [stack count] != 0 ) {return 0; }

    NSMutableString *expression = [exp mutableCopy];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[(]\\d+([.]\\d*)?[sctlLm]*([+*/\\-^]\\d+([.]\\d*)?[sctlLm]*)*[)]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];

    while ( [regex numberOfMatchesInString:expression options:0 range:NSMakeRange(0, [expression length])] != 0  )
    {
        [regex replaceMatchesInString:expression
                              options:0
                                range:NSMakeRange(0, [expression length])
                         withTemplate:@"1"];
    }
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"^\\d+([.]\\d*)?[sctlLm]*([+*/\\-^]\\d+([.]\\d*)?[sctlLm]*)*$"
                                                      options:NSRegularExpressionAnchorsMatchLines
                                                        error:nil];//н - небезпечність
    [regex replaceMatchesInString:expression
                          options:0
                            range:NSMakeRange(0, [expression length])
                     withTemplate:@"1"];
    if ([expression isEqualToString:@"1"]) { return 1;}
    else {return 0;}
    
}


@end
