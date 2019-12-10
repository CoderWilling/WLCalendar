//
//  WLCalendarCollectionViewCell.m
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import "WLCalendarCollectionViewCell.h"
#import "WLCalendarItem.h"
@implementation WLCalendarCollectionViewCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.day.font = [UIFont systemFontOfSize:15];
    self.status.font = [UIFont systemFontOfSize:10];
    self.status.hidden = YES;
}

-(void)setChooseType:(NSInteger )chooseType{
    _chooseType = chooseType;
}

-(void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
}

-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
}

- (void)setItem:(WLCalendarItem *)item{
    _item = item;
    if (item.isHidden) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
        _day.text = [NSString stringWithFormat:@"%ld",(long)item.nubTitle];
    }
    
    if (item.isSelect) {//选中状态
        _day.backgroundColor = _selectedColor;
        if (_chooseType == 1) {//单选日期
            _day.layer.cornerRadius = 6;
            _day.layer.masksToBounds = YES;
        }else{//多选日期
            if (!item.isStartRadius && !item.isEndRadius && !item.isRadius) {//没有圆角
                CGRect rect = self.day.frame;
               UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(0, 0)];
               CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
               //设置大小
               maskLayer.frame = rect;
               //设置图形样子
               maskLayer.path = maskPath.CGPath;
               self.day.layer.mask = maskLayer;
            }else if (item.isStartRadius && !item.isEndRadius){//开始左圆角
                //绘制圆角 要设置的圆角 使用“|”来组合
                CGRect rect = self.day.frame;
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(6, 6)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                //设置大小
                maskLayer.frame = rect;
                //设置图形样子
                maskLayer.path = maskPath.CGPath;
                self.day.layer.mask = maskLayer;
            }else if (item.isEndRadius && !item.isStartRadius){//结束右圆角
                //绘制圆角 要设置的圆角 使用“|”来组合
                CGRect rect = self.day.frame;
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                //设置大小
                maskLayer.frame = rect;
                //设置图形样子
                maskLayer.path = maskPath.CGPath;
                self.day.layer.mask = maskLayer;
            }else if (item.isRadius){
                 CGRect rect = self.day.frame;
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                //设置大小
                maskLayer.frame = rect;
                //设置图形样子
                maskLayer.path = maskPath.CGPath;
                self.day.layer.mask = maskLayer;
            }
        }
    }else{
        _day.backgroundColor = _normalColor;
    }
}

@end
