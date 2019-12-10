//
//  WLCalendarHeadView.m
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import "WLCalendarHeadView.h"
@interface WLCalendarHeadView ()
@property (weak, nonatomic) IBOutlet UIView *contentV;
@end
@implementation WLCalendarHeadView

 -(void)awakeFromNib{
     [super awakeFromNib];
     _nub1.font = _nub2.font = _nub3.font = _nub4.font = _nub5.font = _nub6.font = _nub7.font = [UIFont
                                                                                                 systemFontOfSize:15];
     
     CALayer *lineTop = [CALayer layer];
     lineTop.backgroundColor = [UIColor grayColor].CGColor;
     lineTop.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
     [_contentV.layer addSublayer:lineTop];
             
     CALayer *lineBottom = [CALayer layer];
     lineBottom.backgroundColor = [UIColor grayColor].CGColor;
     lineBottom.frame = CGRectMake(0, 54.5, [UIScreen mainScreen].bounds.size.width, 0.3);
     [_contentV.layer addSublayer:lineBottom];
 }
 
 + (instancetype)viewForXib{
     return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
 }

@end
