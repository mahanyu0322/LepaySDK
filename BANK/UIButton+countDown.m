//
//  UIButton+countDown.m
//  CountDownButtonDemo
//
//  Created by bear on 16/6/17.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "UIButton+countDown.h"
#import <objc/runtime.h>

// rgb color with hex
#define UICOLORRGB(hex)           [UIColor colorWithRed:(((hex) & 0xFF0000) >> 16)/255.0f green:(CGFloat) (((hex) & 0xFF00) >> 8)/255.0f blue:((hex) & 0xFF)/255.0f alpha:1]

@interface UIButton ()

@property (nonatomic, strong) CADisplayLink *displayLink;


@property (nonatomic, assign) NSTimeInterval leaveTime;
@end

@implementation UIButton (countDown)

  static NSString *displayLinkKey;
  static NSString *leaveTimeKey;
  static NSString *countDownFormatKey;

-(void)setDisplayLink:(CADisplayLink *)displayLink{
    
    objc_setAssociatedObject(self, &displayLinkKey, displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CADisplayLink *)displayLink{
    return  objc_getAssociatedObject(self, &displayLinkKey);
}


-(void)setLeaveTime:(NSTimeInterval)leaveTime{
    objc_setAssociatedObject(self, &leaveTimeKey, @(leaveTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSTimeInterval)leaveTime{
     return  [objc_getAssociatedObject(self, &leaveTimeKey) doubleValue];
}


-(void)setCountDownFormat:(NSString *)countDownFormat{
    objc_setAssociatedObject(self, &countDownFormatKey, countDownFormat, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)countDownFormat{
    
    return objc_getAssociatedObject(self, &countDownFormatKey);
    
}

-(void)countDownWithTimeInterval:(NSTimeInterval) duration{
    
    self.leaveTime = duration;
    
    self.enabled=NO;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(countDown)];
    self.displayLink.frameInterval=60;
    
    [self.displayLink  addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    
}

-(void)countDown{
    self.leaveTime--;
    
    if (!self.countDownFormat) {
        self.countDownFormat=@"剩余%d秒";
    }
    
    [self setTitle:[NSString stringWithFormat:self.countDownFormat,(int)self.leaveTime] forState:UIControlStateDisabled];
    self.backgroundColor = [UIColor lightGrayColor];
    if (self.leaveTime == 0) {
        self.backgroundColor = UICOLORRGB(0x62c455);
        [self.displayLink invalidate];
        self.displayLink=nil;
        self.enabled=YES;
    }
}
@end
