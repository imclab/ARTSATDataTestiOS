//
//  ARTSATDataGraphView.m
//  ARTSATDataTest
//
//  Created by Koichiro Mori on 2013/06/05.
//  Copyright (c) 2013年 ARTSAT.jp. All rights reserved.
//

#import "ARTSATDataGraphView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation ARTSATDataGraphView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawContext:UIGraphicsGetCurrentContext()];
}

-(void)drawContext:(CGContextRef)context {
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    
    CGContextMoveToPoint(context, 20.0, 50.0);
    CGContextAddLineToPoint(context, 300.0, 50.0);
    CGContextStrokePath(context);
}

@end
