//
//  TestButton.m
//  AVCaptureDevice
//
//  Created by mac on 2018/11/19.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "TestButton.h"

@implementation TestButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 5);
    CGRect rect1 = CGRectInset(rect, 3, 3);
    CGContextStrokeEllipseInRect(context, rect1);
}


@end
