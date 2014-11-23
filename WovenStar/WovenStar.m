//
//  WovenStar.m
//  WovenStar
//
//  Created by Sandy Lee on 10/16/14.
//  Copyright (c) 2014 iaomw. All rights reserved.
//

#import "WovenStar.h"

#define OuterRange (2*M_PI/3)
#define InnerRange (M_PI/3)

@interface WovenStar ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (strong, nonatomic) UIColor *foreColor;

@property (assign, nonatomic) CGFloat innerBaseAngle;
@property (assign, nonatomic) CGFloat outerBaseAngle;

@property (assign, nonatomic) CGFloat innerRadius;
@property (assign, nonatomic) CGFloat outerRadius;

@property (nonatomic, assign) CGFloat ratio;

@end

@implementation WovenStar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {}
    
    return self;
}

- (void)setForeColor:(UIColor *)foreColor andBackColor:(UIColor*)backColor {
    
    self.foreColor = foreColor;
    
    self.backgroundColor = backColor;
}

# pragma mark - Getter&Setter

- (void)setPaused:(BOOL)paused {
    
    [self.displayLink setPaused:paused];
}

- (CADisplayLink*)displayLink {
    
    if (!_displayLink) {
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return _displayLink;
}

- (CGFloat)duration {
    
    if (!_duration) {
        
        return 8;
    }
    
    return _duration;
}

- (UIColor*)foreColor {
    
    if (!_foreColor) {
        
        _foreColor = [UIColor whiteColor];
    }
    
    return _foreColor;
}

- (CGFloat)sideLength {
    
    if (!_sideLength) {
        
        _sideLength = 64;
    }
    
    return _sideLength;
}

- (CGFloat)outerBaseAngle {
    
    if (!_outerBaseAngle) {
        
        _outerBaseAngle = (M_PI/12);
    }
    
    return _outerBaseAngle;
}

- (CGFloat)innerBaseAngle {
    
    if (!_innerBaseAngle) {
        
        _innerBaseAngle = (M_PI/12)+(M_PI/2);
    }
    
    return _innerBaseAngle;
}

- (CGFloat)outerRadius {

    if (!_outerRadius) {
        
        _outerRadius = self.sideLength*pow(2, 1.0/2)/2;
    }
    
    return _outerRadius;
}

- (CGFloat)innerRadius {
    
    if (!_innerRadius) {
        
        _innerRadius = self.sideLength*pow(2, 1.0/2)/2;
    }
    
    return _innerRadius;
}

# pragma mark - Animation

- (void)update:(CADisplayLink *)displayLink
{
    NSTimeInterval duration = displayLink.duration;
    
    CGFloat ratio = duration/self.duration;
    
        self.ratio += ratio;
    
    if (self.ratio>1) {
        
        self.ratio = ratio;
        
        self.outerBaseAngle = 0;
        self.innerBaseAngle = 0;
    }
    
    self.outerBaseAngle += ratio*OuterRange;
    self.innerBaseAngle -= ratio*InnerRange;
    
    CGFloat wave = sin(self.ratio*(M_PI));
    
    self.innerRadius = (self.sideLength*pow(2, 1.0/2)/2)-wave*(self.sideLength/2);
    
    CGFloat differ = fabsf(self.innerBaseAngle - self.outerBaseAngle);
    
    CGFloat hh = sin(differ)*self.innerRadius;
    
    CGFloat oo = pow((pow(self.sideLength, 2)-pow(hh, 2)), 0.5);
    CGFloat ii = cos(differ)*self.innerRadius;
    
    self.outerRadius = oo+ii;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGPoint center = CGPointMake(width/2, height/2);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(contextRef);
    //CGContextClearRect(contextRef, rect);
    
    [self.foreColor setFill];
    [self.backgroundColor setStroke];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    for (int i =0; i<12; i++) {
        
        CGFloat innerAngle = self.innerBaseAngle + M_PI*(i/6.0);
        CGSize innerDelta = CGSizeMake(self.innerRadius*cos(innerAngle), self.innerRadius*sin(innerAngle));
        CGPoint innerPoint = CGPointMake(center.x+innerDelta.width, center.y+innerDelta.height);
        
        CGFloat outerAngle = self.outerBaseAngle + M_PI*(i/6.0);
        CGSize outerDelta = CGSizeMake(self.outerRadius*cos(outerAngle), self.outerRadius*sin(outerAngle));
        CGPoint outerPoint = CGPointMake(center.x+outerDelta.width, center.y+outerDelta.height);
        
        CGMutablePathRef rawPath = CGPathCreateMutable();
        CGPathMoveToPoint(rawPath, nil, innerPoint.x, innerPoint.y);
        CGPathAddLineToPoint(rawPath, nil, outerPoint.x, outerPoint.y);
        
        CGVector thisVector = CGVectorMake(outerPoint.x-innerPoint.x, outerPoint.y-innerPoint.y);
        CGVector thatVector = CGVectorMake(thisVector.dy, -thisVector.dx);
        
        CGFloat vectorLength = pow(pow(thatVector.dx, 2)+pow(thatVector.dy, 2), 0.5);
        
        CGFloat sinVector = thatVector.dy/vectorLength;
        CGFloat cosVector = thatVector.dx/vectorLength;
        
        CGAffineTransform trans = CGAffineTransformMakeTranslation(cosVector*4, sinVector*4);
        
        CGPathRef cookedPath = CGPathCreateCopyByStrokingPath(rawPath, &trans, 8,
                                                              kCGLineCapButt, kCGLineJoinMiter, 1);
    
        CGContextAddPath(contextRef, cookedPath);
        CGContextFillPath(contextRef);
        
        CGContextAddPath(contextRef, cookedPath);
        CGContextSetLineWidth(contextRef, 1);
        CGContextStrokePath(contextRef);
    }
    
    CGPathRef path = CGPathCreateCopyByStrokingPath(pathRef, nil, 8, kCGLineCapSquare, kCGLineJoinMiter, 1);
    
    CGContextAddPath(contextRef, path);
    CGContextFillPath(contextRef);
    
    CGContextAddPath(contextRef, path);
    CGContextStrokePath(contextRef);
    
    CGContextRestoreGState(contextRef);
}

@end
