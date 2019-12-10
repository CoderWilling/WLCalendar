//
//  WLChooseDateAlertView.h
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^getTimeBlock)(NSArray * _Nullable firstDay, NSArray * _Nullable lastDay, NSMutableArray * _Nonnull recordArr);//选中回调
typedef void(^showHintBlock)(void);
NS_ASSUME_NONNULL_BEGIN
@class WLCalendarItem;
typedef NS_ENUM(NSInteger, WLCalendarChooseType) {
    WLCalendarChooseSingle = 1,//选择一个时间
    WLCalendarChooseDouble = 2,//选择两个时间
};
@interface WLChooseDateAlertView : UIView
@property (nonatomic, strong) NSArray * firstDay;//开始时间
@property (nonatomic, strong) NSArray * lastDay;//结束时间
@property(nonatomic,strong)NSMutableArray<NSMutableArray<WLCalendarItem*>*> *yearArr;
- (void)getTimeData:(getTimeBlock)block;
- (void)showHintStr:(showHintBlock)showblock;
/// 初始化方法
/// @param mainColor 主色
/// @param selectedColor 选中色
/// @param chooseType 日历返回类型
- (instancetype)initWithMainColor:(UIColor *)mainColor SelectedColor:(UIColor *)selectedColor ChooseType:(WLCalendarChooseType)chooseType;
@end

NS_ASSUME_NONNULL_END
