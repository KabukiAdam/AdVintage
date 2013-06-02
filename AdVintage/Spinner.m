//
//  Spinner.m
//  advintage
//
//  Created by James White on 1/06/13.
//  Copyright (c) 2013 James White. All rights reserved.
//

#import "Spinner.h"

@interface Spinner ()

@property (nonatomic) int position;

@end



@implementation Spinner


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)animate {
    if (self.position < 8)
        self.position ++;
    else
        self.position = 1;
    
    [self setNeedsDisplay];
    [self performSelector:@selector(animate) withObject:nil afterDelay:0.2];
    
}


- (void)drawRect:(CGRect)rect
{
  
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* orange = [UIColor colorWithRed: 0.933 green: 0.514 blue: 0.208 alpha: 1];
    
    //// Shadow Declarations
    UIColor* shadow3 = strokeColor;
    CGSize shadow3Offset = CGSizeMake(self.size.height/4000, self.size.height/2000);
    CGFloat shadow3BlurRadius = self.size.height/20;
    
    //// Frames
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    
    
    ////stroke width
    
    float strokeWidth = self.size.height/50;
    
    
    if (self.position != 1) {
        //// pos1 Drawing
        UIBezierPath* pos1Path = [UIBezierPath bezierPath];
        [pos1Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.08250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34250 * CGRectGetHeight(frame))];
        [pos1Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.12250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.08250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36459 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.10041 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38250 * CGRectGetHeight(frame))];
        [pos1Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38250 * CGRectGetHeight(frame))];
        [pos1Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40709 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.38250 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.42500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.36459 * CGRectGetHeight(frame))];
        [pos1Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.42500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34250 * CGRectGetHeight(frame))];
        [pos1Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.38500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.42500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32041 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40709 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30250 * CGRectGetHeight(frame))];
        [pos1Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.12250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30250 * CGRectGetHeight(frame))];
        [pos1Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.08250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.10041 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30250 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.08250 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32041 * CGRectGetHeight(frame))];
        [pos1Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos1Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos1Path.lineWidth = strokeWidth;
        [pos1Path stroke];
        
        
    }
    
    if (self.position != 2) {
        //// pos 2 Drawing
        UIBezierPath* pos2Path = [UIBezierPath bezierPath];
        [pos2Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.09266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68359 * CGRectGetHeight(frame))];
        [pos2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.14923 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68359 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.10828 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.69921 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.13361 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.69921 * CGRectGetHeight(frame))];
        [pos2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33484 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49798 * CGRectGetHeight(frame))];
        [pos2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33484 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44141 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.35046 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.48236 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.35046 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.45703 * CGRectGetHeight(frame))];
        [pos2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.33484 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44141 * CGRectGetHeight(frame))];
        [pos2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.27827 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.44141 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.31922 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.42579 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.29389 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.42579 * CGRectGetHeight(frame))];
        [pos2Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.09266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62702 * CGRectGetHeight(frame))];
        [pos2Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.09266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68359 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.07704 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64264 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.07704 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66797 * CGRectGetHeight(frame))];
        [pos2Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos2Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos2Path.lineWidth = strokeWidth;
        [pos2Path stroke];
    }

    if (self.position != 3) {
        //// pos 3 Drawing
        UIBezierPath* pos3Path = [UIBezierPath bezierPath];
        [pos3Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90375 * CGRectGetHeight(frame))];
        [pos3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.86375 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.38584 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90375 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.40375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88584 * CGRectGetHeight(frame))];
        [pos3Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.40375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60125 * CGRectGetHeight(frame))];
        [pos3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56125 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.40375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57916 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.38584 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56125 * CGRectGetHeight(frame))];
        [pos3Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56125 * CGRectGetHeight(frame))];
        [pos3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.60125 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.34166 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.56125 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.32375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.57916 * CGRectGetHeight(frame))];
        [pos3Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.32375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.86375 * CGRectGetHeight(frame))];
        [pos3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.36375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90375 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.32375 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88584 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.34166 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90375 * CGRectGetHeight(frame))];
        [pos3Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos3Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos3Path.lineWidth = strokeWidth;
        [pos3Path stroke];

    }
    
    if (self.position != 4) {
        //// pos 4 Drawing
        UIBezierPath* pos4Path = [UIBezierPath bezierPath];
        [pos4Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45766 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64641 * CGRectGetHeight(frame))];
        [pos4Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45766 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.70298 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.44204 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.66203 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.44204 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.68736 * CGRectGetHeight(frame))];
        [pos4Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.64327 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88859 * CGRectGetHeight(frame))];
        [pos4Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88859 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.65889 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90421 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.68422 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.90421 * CGRectGetHeight(frame))];
        [pos4Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.88859 * CGRectGetHeight(frame))];
        [pos4Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.83202 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.71546 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.87297 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.71546 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.84764 * CGRectGetHeight(frame))];
        [pos4Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.51423 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64641 * CGRectGetHeight(frame))];
        [pos4Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.45766 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.64641 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.49861 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63079 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.47328 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63079 * CGRectGetHeight(frame))];
        [pos4Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos4Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos4Path.lineWidth = strokeWidth;
        [pos4Path stroke];

    }
    
    if (self.position != 5) {
        //// pos 5 Drawing
        UIBezierPath* pos5Path = [UIBezierPath bezierPath];
        [pos5Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63250 * CGRectGetHeight(frame))];
        [pos5Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.61750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.57750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65459 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59541 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67250 * CGRectGetHeight(frame))];
        [pos5Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.88000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67250 * CGRectGetHeight(frame))];
        [pos5Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.90209 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.67250 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.92000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.65459 * CGRectGetHeight(frame))];
        [pos5Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.92000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63250 * CGRectGetHeight(frame))];
        [pos5Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.88000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.92000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61041 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.90209 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59250 * CGRectGetHeight(frame))];
        [pos5Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.61750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59250 * CGRectGetHeight(frame))];
        [pos5Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.57750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.63250 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59541 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.59250 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.57750 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.61041 * CGRectGetHeight(frame))];
        [pos5Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos5Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos5Path.lineWidth = strokeWidth;
        [pos5Path stroke];

    }
    
       
    if (self.position != 6) {
        //// pos 6 Drawing
        UIBezierPath* pos6Path = [UIBezierPath bezierPath];
        [pos6Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.66766 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53359 * CGRectGetHeight(frame))];
        [pos6Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.72423 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53359 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.68328 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54921 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.70861 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.54921 * CGRectGetHeight(frame))];
        [pos6Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.90984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34798 * CGRectGetHeight(frame))];
        [pos6Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.90984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.29141 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.92546 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.33236 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.92546 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.30703 * CGRectGetHeight(frame))];
        [pos6Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.90984 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.29141 * CGRectGetHeight(frame))];
        [pos6Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.85327 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.29141 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.89422 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27579 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.86889 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27579 * CGRectGetHeight(frame))];
        [pos6Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.66766 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.47702 * CGRectGetHeight(frame))];
        [pos6Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.66766 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.53359 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.65204 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.49264 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.65204 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.51797 * CGRectGetHeight(frame))];
        [pos6Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos6Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos6Path.lineWidth = strokeWidth;
        [pos6Path stroke];
    }
       
    if (self.position != 7) {
        //// pos 7 Drawing
        UIBezierPath* pos7Path = [UIBezierPath bezierPath];
        [pos7Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41375 * CGRectGetHeight(frame))];
        [pos7Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37375 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.66084 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41375 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.67875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39584 * CGRectGetHeight(frame))];
        [pos7Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.67875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11125 * CGRectGetHeight(frame))];
        [pos7Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07125 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.67875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08916 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.66084 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07125 * CGRectGetHeight(frame))];
        [pos7Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07125 * CGRectGetHeight(frame))];
        [pos7Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.11125 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.61666 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07125 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.59875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08916 * CGRectGetHeight(frame))];
        [pos7Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.59875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37375 * CGRectGetHeight(frame))];
        [pos7Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.63875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41375 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.59875 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39584 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.61666 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.41375 * CGRectGetHeight(frame))];
        [pos7Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos7Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos7Path.lineWidth = strokeWidth;
        [pos7Path stroke];
    }
   
    if (self.position != 8) {
        //// pos 8 Drawing
        UIBezierPath* pos8Path = [UIBezierPath bezierPath];
        [pos8Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.30266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08641 * CGRectGetHeight(frame))];
        [pos8Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.30266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.14298 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.28704 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.10203 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.28704 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.12736 * CGRectGetHeight(frame))];
        [pos8Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.48827 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32859 * CGRectGetHeight(frame))];
        [pos8Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54484 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32859 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.50389 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34421 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.52922 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.34421 * CGRectGetHeight(frame))];
        [pos8Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54484 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.32859 * CGRectGetHeight(frame))];
        [pos8Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.54484 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.27202 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.56046 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.31297 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.56046 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.28764 * CGRectGetHeight(frame))];
        [pos8Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.35923 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08641 * CGRectGetHeight(frame))];
        [pos8Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.30266 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.08641 * CGRectGetHeight(frame)) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.34361 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07079 * CGRectGetHeight(frame)) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.31828 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.07079 * CGRectGetHeight(frame))];
        [pos8Path closePath];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow3Offset, shadow3BlurRadius, shadow3.CGColor);
        [orange setFill];
        [pos8Path fill];
        CGContextRestoreGState(context);
        
        [fillColor setStroke];
        pos8Path.lineWidth = strokeWidth;
        [pos8Path stroke];

    }
    
}


@end
