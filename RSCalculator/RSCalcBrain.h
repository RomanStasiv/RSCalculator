//
//  RSCalcBrain.h
//  RSCalculator
//
//  Created by Roman Stasiv on 11/25/15.
//  Copyright (c) 2015 Roman Stasiv. All rights reserved.
//

#ifndef RSCalculator_RSCalcBrain_h
#define RSCalculator_RSCalcBrain_h
@interface CalcData: NSObject

@property (readonly) BOOL readyToCalc;

-(void) setOperation: (int) s rememberValue:(double) value;
-(NSNumber*) procedeOperation: (double) b;
-(void) clear;


+(CalcData*) CreateInstance;

@end

#endif
