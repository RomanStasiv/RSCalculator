//
//  RSCalcBrain.m
//  
//
//  Created by Roman Stasiv on 11/25/15.
//
//

#import <Foundation/Foundation.h>
#import "RSCalcBrain.h"

@implementation CalcData
double bufferedDigit = 0;
int  operation = 0;

@synthesize readyToCalc;

CalcData *SharedInstance = nil;
-(void) clear
{
    bufferedDigit = 0;
    operation = 0;
    readyToCalc = 0;
}

-(void) setOperation: (int) op rememberValue:(double) value
{
    
    operation = op;
    bufferedDigit = value;
    readyToCalc = 1;
    NSLog(@"%d/%f", operation, bufferedDigit);
}

-(NSNumber *) procedeOperation: (double) b
{
    switch(operation)
    {
            case 1001:
            {
                bufferedDigit = bufferedDigit + b;
            }break;
            case 1002:
            {
                bufferedDigit = bufferedDigit - b;
            }break;
            case 1003:
            {
                bufferedDigit = bufferedDigit * b;
            }break;
            case 1004:
            {
                bufferedDigit = bufferedDigit / b;
            }break;
            case 1105:
            {
                bufferedDigit = sqrt(b);
            }break;
            case 1106:
            {
                bufferedDigit = b / 100;
            }break;
            case 1107:
            {
                bufferedDigit = b * (-1);
            }break;
            
    }
    readyToCalc = 0;
    return [NSNumber numberWithDouble: bufferedDigit];
}



+(CalcData *)CreateInstance
{
    if (!SharedInstance)
    {
        SharedInstance = [[self alloc] init];
    }
    return SharedInstance;
}

@end
