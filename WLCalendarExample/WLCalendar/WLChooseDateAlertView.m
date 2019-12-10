//
//  WLChooseDateAlertView.m
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import "WLChooseDateAlertView.h"
#import "WLCalendarHeadView.h"
#import "WLCalendarReusableView.h"
#import "WLCalendarCollectionViewCell.h"
#import "WLCalendarItem.h"

@interface WLChooseDateAlertView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) WLCalendarChooseType chooseType;//日历返回类型
@property (nonatomic, strong) NSDate * nowDate; //当前的时间
@property (nonatomic, strong) NSTimeZone * timeZone; //当地时区
@property (nonatomic, strong) NSCalendar * calendar; //当前日历
@property (nonatomic, strong) NSDateComponents * components; //当前日期的零件
@property (nonatomic, strong) NSDateFormatter * formatter; //时间书写格式
@property (nonatomic, strong) NSArray * weekdays; //日历星期格式
@property(nonatomic,strong)NSMutableArray<WLCalendarItem *> *monthArr;
@property (nonatomic, strong) WLCalendarItem *startItem;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger endIndex;
@property(nonatomic,copy)getTimeBlock block;
@property(nonatomic,copy)showHintBlock showblock;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, strong) UIColor * mainColor;//主色
@property (nonatomic, strong) UIColor * selectedColor;//选中色

@end
@implementation WLChooseDateAlertView
- (instancetype)initWithMainColor:(UIColor *)mainColor SelectedColor:(UIColor *)selectedColor ChooseType:(WLCalendarChooseType)chooseType{
    if (self == [super init]) {
        self.mainColor = mainColor;
        self.selectedColor = selectedColor;
        self.chooseType = chooseType;
        [self setupUI];
    }
    return self;
}



 - (void)getTimeData:(getTimeBlock)block{
     self.block = block;
 }


 - (void)showHintStr:(showHintBlock)showblock{
     self.showblock = showblock;
 }


 #pragma mark lazy load
 - (NSTimeZone *)timeZone {
     //时区为中国上海
     if (!_timeZone) {
         _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
     }
     return _timeZone;
 }

 - (NSCalendar *)calendar {
     if (!_calendar) {
         _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
     }
     return _calendar;
 }

 - (NSDateComponents *)components {
     if (!_components) {
         _components = [[NSDateComponents alloc] init];
     }
     return _components;
 }

 - (NSDateFormatter *)formatter {
     if (!_formatter) {
         _formatter = [[NSDateFormatter alloc] init];
         _formatter.dateFormat = @"yyyy-MM-dd";
     }
     return _formatter;
 }

 - (NSArray *)weekdays {
     //苹果日历每周第一天是周一，修改日历格式
     if (!_weekdays) {
         _weekdays = @[[NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6"];
     }
     return _weekdays;
 }


 #pragma mark 获取时间方法
 /**根据当前时间获取当前和以后各有多少个月，0为当前月*/
 - (NSDate *)getEarlierAndLaterDaysFromDate:(NSDate *)date withMonth:(NSInteger)month {
     [self.components setMonth:month];
     //返回各月份的当前日期，如：2019-11-11，2019-12-12
     NSDate * ndate = [self.calendar dateByAddingComponents:self.components toDate:date options:0];
     return ndate;
 }

 /**获取每个单位内开始时间*/
 - (NSString *)getBeginTimeInMonth:(NSDate *)date {
     NSTimeInterval count = 0;
     NSDate * beginDate = nil;
     NSCalendar * calendar = [NSCalendar currentCalendar];
     //返回日历每个月份的开始时间，类型是unitMonth
     BOOL findFirstTime = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&count forDate:date];
     if (findFirstTime) {
         //日历设置为当前时区
         [self.calendar setTimeZone:self.timeZone];
         //标识为星期
         NSCalendarUnit unitFlags = NSCalendarUnitWeekday;
         //返回每个月第一天是周几
         NSDateComponents * com = [self.calendar components:unitFlags fromDate:beginDate];
         //更换为新的星期格式
         NSString * weekday = [self.weekdays objectAtIndex:[com weekday]];
         return weekday;
     }else {
         return @"";
     }
 }

 /**获取每个月多少天*/
 - (NSInteger)getTotalDaysInMonth:(NSDate *)date {
     NSCalendar * calendar = [NSCalendar currentCalendar];
     //标识为day的单位在标识为month的单位中的格式，返回range
     NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
     return range.length;
 }

 /**获取当前日期格式*/
 - (NSArray *)getTimeFormatArrayWithDate:(NSDate *)date andMonth:(NSInteger)month {
     NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:month];
     NSString * stringFormat = [self.formatter stringFromDate:dateTime];
     //通过“-”拆分日期格式
     return [stringFormat componentsSeparatedByString:@"-"];
 }

 /**获取当前日期零件*/
 - (NSDateComponents *)getCurrentComponentWithDate:(NSDate *)dateTime {
     NSCalendar * calendar = [NSCalendar currentCalendar];
     //日期拆分类型
     NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
     return [calendar components:unitFlags fromDate:dateTime];
 }


// -(void)setYearArr:(NSMutableArray<NSMutableArray<WLCalendarItem *> *> *)yearArr{
//     _yearArr = yearArr;
// }

 //-(void)setChooseType:(ACCalendarChooseType)chooseType{
 //    _chooseType = chooseType;
 //    if (chooseType == ACCalendarChooseDouble) {//多选时间显示确定按钮
 //        self.rightBtn.hidden = NO;
 //    }else{
 //        self.rightBtn.hidden = YES;
 //    }
 //}

 -(void)setupUI{
 //    ac_WeakSelf
 //      UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 //      dismissBtn.backgroundColor = [UIColor clearColor];
 //      dismissBtn.frame = self.frame;
 //      [dismissBtn addTarget:self action:@selector(clickDidBtn) forControlEvents:UIControlEventTouchUpInside];
 //      [self addSubview:dismissBtn];
     
     UIView  *contentV = [[UIView alloc]init];
     contentV.frame = CGRectMake(0, 300, WLScreenW, WLScreenH-300);
     contentV.backgroundColor = [UIColor clearColor];
     [self addSubview:contentV];
           
     UIView *topView = [[UIView alloc]init];
     topView.backgroundColor = self.mainColor;
     topView.frame = CGRectMake(0, 0, WLScreenW, 46);
     [contentV addSubview:topView];
      CGRect rect = CGRectMake(0, 0, WLScreenW, 46);
     UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
     //设置大小
     maskLayer.frame = rect;
     //设置图形样子
     maskLayer.path = maskPath.CGPath;
     topView.layer.mask = maskLayer;
         
         
     UILabel *titleLab = [[UILabel alloc]init];
     titleLab.frame = CGRectMake(WLScreenW/2-60, 10, 120, 26);
     titleLab.text = @"选择日期";
     titleLab.textAlignment = NSTextAlignmentCenter;
     titleLab.textColor = [UIColor whiteColor];
     titleLab.font = [UIFont boldSystemFontOfSize:16];
     [topView addSubview:titleLab];
   
      
     UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     // 创建渐变色图层
     CAGradientLayer *gradientLayer= [CAGradientLayer layer];
     gradientLayer.frame  = CGRectMake(0, 0, 60, 32);
     gradientLayer.colors = @[
                              (id)[UIColor colorWithRed:252/255.0 green:39/255.0 blue:136/255.0 alpha:1].CGColor,
                              (id)[UIColor colorWithRed:252/255.0 green:78/255.0 blue:98/255.0 alpha:1].CGColor
                              ];
     // 设置渐变方向(0~1)
     gradientLayer.startPoint = CGPointMake(1, 0);
     gradientLayer.endPoint = CGPointMake(0, 0);
     // 设置渐变色的起始位置和终止位置(颜色的分割点)
     gradientLayer.locations = @[@(0.5f),@(1.0f)];
     gradientLayer.cornerRadius = 15;
     gradientLayer.masksToBounds = YES;
     // 添加图层
     [rightBtn.layer addSublayer:gradientLayer];
     rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
     [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
     [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     //rightBtn.hidden = YES;
     [rightBtn addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
     rightBtn.frame = CGRectMake(WLScreenW-12-60, 7, 60, 32);
     _rightBtn = rightBtn;
     [topView addSubview:rightBtn];
     
     WLCalendarHeadView *headView = [WLCalendarHeadView viewForXib];
     headView.frame = CGRectMake(0, 46, WLScreenW, 55);
     headView.backgroundColor = self.mainColor;
     headView.nub1.backgroundColor = headView.nub2.backgroundColor = headView.nub3.backgroundColor = headView.nub4.backgroundColor = headView.nub5.backgroundColor = headView.nub6.backgroundColor = headView.nub7.backgroundColor = self.mainColor;
     [contentV addSubview:headView];
 
     self.nowDate = [NSDate date];
         
     //设置布局
     UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
     flowLayout.itemSize = CGSizeMake(WLScreenW / 7.0, WLScreenW / 7.0);//item大小
     flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
     flowLayout.headerReferenceSize = CGSizeMake(WLScreenW,60);//header大小
//     flowLayout.minimumLineSpacing = 3;
//     flowLayout.minimumInteritemSpacing = 0;
     _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), WLScreenW, WLScreenH-300-46-55) collectionViewLayout:flowLayout];
     _collectionView.backgroundColor = self.mainColor;
     _collectionView.delegate = self;
     _collectionView.dataSource = self;
     _collectionView.showsHorizontalScrollIndicator = NO;
     _collectionView.showsVerticalScrollIndicator = NO;
     _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
     [contentV addSubview:_collectionView];
     
     
     //注册
     [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WLCalendarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WLCalendarCollectionViewCell class])];
     [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WLCalendarReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WLCalendarReusableView class])];
     
         if (self.yearArr.count == 0) {
         self.yearArr = [NSMutableArray array];
         for (int i = 0; i < 6; i++) {
             NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:i];
             NSDateComponents * components = [self getCurrentComponentWithDate:dateTime];
             NSInteger year = [[NSNumber numberWithInteger:[components year]] integerValue];//年
             NSArray *dateArr = [self getTimeFormatArrayWithDate:self.nowDate andMonth:i];//月
             NSInteger month = [dateArr[1] integerValue];
             
             NSString * firstTime = [self getBeginTimeInMonth:dateTime];
             NSInteger startDay = [firstTime integerValue];//开始时间，同样表示这个月开始前几天是空白
             NSInteger totalDays = [self getTotalDaysInMonth:dateTime];//某个月总天数
             NSInteger totalNub = startDay+totalDays;//总个数
             NSMutableArray *monthArr = [NSMutableArray array];
             for (int j = 0; j < totalNub; j++) {
                 if (j < startDay) {//创建空模型
                     WLCalendarItem *item = [[WLCalendarItem alloc]init];
                     item.isHidden = YES;
                     item = [self judgeWeekend:item Index:j];
                     [monthArr addObject:item];
                 }else{
                     WLCalendarItem *item = [[WLCalendarItem alloc]init];
                     item.nubTitle = j-startDay+1;
                     item.nubYear = year;
                     item.nubMonth = month;
                     item = [self judgeWeekend:item Index:j];
                     [monthArr addObject:item];
                 }
             }
             [self.yearArr addObject:monthArr];
//             NSLog(@"月数组=%@",monthArr);
//             NSLog(@"年数组=%@",self.yearArr);
          }
             [self.collectionView reloadData];
         }else{
             [self.collectionView reloadData];
         }
 }

  
-(WLCalendarItem *)judgeWeekend:(WLCalendarItem *)item Index:(NSInteger )index{
    if (index == 0 || index == 6 || index == 7 || index == 13 || index == 14 || index == 20 || index == 21 || index == 27 || index == 28 || index == 34 || index == 35 || index == 41) {
        item.isWeekend = YES;
    }
    return item;
}

 

 #pragma mark DataSource && Delegate
 // headerView的size
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
     return CGSizeMake(WLScreenW, 40);
 }

 // section的个数
 - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
     return self.yearArr.count;
 }

 // item的个数
 - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return self.yearArr[section].count;
 }

 // cell代理方法
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     WLCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WLCalendarCollectionViewCell class]) forIndexPath:indexPath];
     cell.chooseType = self.chooseType;
     cell.normalColor = self.mainColor;
     cell.selectedColor = self.selectedColor;
     WLCalendarItem *item = self.yearArr[indexPath.section][indexPath.row];
     cell.item = item;
     
     //获取当前时间年月日
     NSDate *now = [NSDate date];
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
     NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
     NSInteger year1 = [dateComponent year];
     NSInteger month1 = [dateComponent month];
     NSInteger day = [dateComponent day];

     NSArray *dateArr = [self getTimeFormatArrayWithDate:self.nowDate andMonth:indexPath.section];
     NSInteger monthNub = [dateArr[1] integerValue];

     if (item.nubTitle == day && month1 == monthNub) {
         cell.status.text = @"今天";
         cell.status.hidden = NO;
         cell.status.textColor = [UIColor whiteColor];
     }else{
         cell.status.hidden = YES;
     }
     
     NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:indexPath.section];
     NSDateComponents * components = [self getCurrentComponentWithDate:dateTime];
     NSInteger yearNub = [[NSNumber numberWithInteger:[components year]] integerValue];
     if (yearNub == year1 && monthNub <= month1 && item.nubTitle < day) {//设置不可点击样式
          cell.day.textColor = [UIColor grayColor];
     }else{
         if (item.isWeekend) {//周末
             if (item.isSelect) {
                 cell.day.textColor = [UIColor whiteColor];
             }else{
                 cell.day.textColor = _selectedColor;
             }
         }else{
             cell.day.textColor = [UIColor whiteColor];
         }
     }
     return cell;
 }

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


 // 点击代理方法
 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     WLCalendarItem *item = self.yearArr[indexPath.section][indexPath.row];

     //获取当前时间年月日
     NSDate *now = [NSDate date];
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
     NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
     NSInteger year1 = [dateComponent year];
     NSInteger month1 = [dateComponent month];
     NSInteger day1 = [dateComponent day];
     
     if (item.nubYear == year1 && item.nubMonth <= month1 && item.nubTitle < day1) {//设置不可点击样式
     
     }else{
     //判断选择类型，单个类型选中后直接返回，否则选中两次返回
     if (self.chooseType == WLCalendarChooseSingle) {
             for (int i = 0; i < self.yearArr.count; i++) {
                 NSArray *monthArr = self.yearArr[i];
                 for (int j = 0; j < monthArr.count; j++) {
                     WLCalendarItem *item = monthArr[j];
                     item.isSelect = NO;
                 }
             }
         //年份和月份是通过section查找到，天数是通过row查到
         self.lastDay = @[[NSNumber numberWithInteger:item.nubYear],[NSNumber numberWithInteger:item.nubMonth],[NSNumber numberWithInteger:item.nubTitle]];
         item.isSelect = YES;
         //由于单个选择直接刷新列表并返回
         [self.collectionView reloadData];
         [self goback];
     }
     
     if (self.chooseType == WLCalendarChooseDouble) {
         if (self.lastDay.count != 0) {//重置选中状态
             self.firstDay = nil;
             self.lastDay = nil;
             for (int i = 0; i < self.yearArr.count; i++) {
                 NSArray *monthArr = self.yearArr[i];
                 for (int j = 0; j < monthArr.count; j++) {
                     WLCalendarItem *item = monthArr[j];
                     item.isSelect = NO;
                     item.isStartRadius = NO;
                     item.isEndRadius = NO;
                     item.isRadius = NO;
                 }
             }
         }
         
         //只选择一项时值只刷新列表,全部选择时刷新并返回
         if (self.firstDay.count == 0) {//******选择开始时间******
                 self.firstDay = @[[NSNumber numberWithInteger:item.nubYear],[NSNumber numberWithInteger:item.nubMonth],[NSNumber numberWithInteger:item.nubTitle]];
                 self.startIndex = indexPath.section;
                 item.isSelect = YES;
                 item.isRadius = YES;//设置圆角
                 self.startItem = item;//记录开始模型
                 [self.collectionView reloadData];
         }else {//******选择结束时间******
             if (indexPath.section < self.startIndex) {//小于开始月
                 self.firstDay = @[[NSNumber numberWithInteger:item.nubYear],[NSNumber numberWithInteger:item.nubMonth],[NSNumber numberWithInteger:item.nubTitle]];
                 self.startIndex = indexPath.section;
                 item.isSelect = YES;
                 item.isRadius = YES;
                 self.startItem.isSelect = NO;//重置开始时间
                 self.startItem.isStartRadius = NO;//重置开始圆角
                 self.startItem.isRadius = NO;//重置圆角
                 self.startItem = item;//记录开始模型
                 [self.collectionView reloadData];
             }else if (indexPath.section == self.startIndex && item.nubTitle <= [self.firstDay[2] integerValue]){//等于开始月小于等于开始天
                 if (self.lastDay.count == 0) {
                     self.startItem.isSelect = NO;//重置开始时间
                     self.startItem.isStartRadius = NO;//重置开始圆角
                     self.startItem.isRadius = NO;//重置圆角
                     self.firstDay = @[[NSNumber numberWithInteger:item.nubYear],[NSNumber numberWithInteger:item.nubMonth],[NSNumber numberWithInteger:item.nubTitle]];
                     self.startIndex = indexPath.section;
                     item.isSelect = YES;
                     item.isRadius = YES;
                     self.startItem = item;//记录开始模型
                     [self.collectionView reloadData];
                 }
             }else{//正常连接
             self.lastDay = @[[NSNumber numberWithInteger:item.nubYear],[NSNumber numberWithInteger:item.nubMonth],[NSNumber numberWithInteger:item.nubTitle]];
             self.endIndex = indexPath.section;
             item.isSelect = YES;
             item.isEndRadius = YES;//设置结束圆角
             self.startItem.isStartRadius = YES;//设置开始圆角
             self.startItem.isRadius = NO;//重置圆角
                 
             //遍历每个月每一天
             for (int i = 0; i < self.yearArr.count; i++) {
                 NSArray *monthArr = self.yearArr[i];
                 if (self.startIndex == self.endIndex) {//开始结束同月
                     if (i == self.startIndex) {
                         for (int j = 0; j < monthArr.count; j++) {
                             WLCalendarItem *item = monthArr[j];
                             if (item.nubTitle > [self.firstDay[2] integerValue] && item.nubTitle < [self.lastDay[2] integerValue]) {
                                 item.isSelect = YES;
                             }
                         }
                     }
                 }else{
                     if (i == self.startIndex) {//开始月
                         for (int j = 0; j < monthArr.count; j++) {
                             WLCalendarItem *item = monthArr[j];
                             if (item.nubTitle > [self.firstDay[2] integerValue]) {
                                 item.isSelect = YES;
                             }
                         }
                     }else if (i == self.endIndex){//结束月
                         for (int j = 0; j < monthArr.count; j++) {
                             WLCalendarItem *item = monthArr[j];
                             if (item.nubTitle < [self.lastDay[2] integerValue]) {
                                 item.isSelect = YES;
                             }
                         }
                     }else if (i > self.startIndex && i < self.endIndex){//中间月
                     for (int j = 0; j < monthArr.count; j++) {
                         WLCalendarItem *item = monthArr[j];
                         item.isSelect = YES;
                         }
                     }else{
                     }
                 }
             }
    
             [self.collectionView reloadData];
         }
     }
                 
     }
   }
 }

 // header代理方法
 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
         WLCalendarReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WLCalendarReusableView class]) forIndexPath:indexPath];
         headerView.backgroundColor = self.mainColor;
         //设置headerView的title
         [headerView showTimeLabelWithArray:(NSArray *)[self getTimeFormatArrayWithDate:self.nowDate andMonth:indexPath.section]];
         return headerView;
     }
     return nil;
 }
     
  
 -(void)clickConfirm{//确定
     if (self.chooseType == WLCalendarChooseDouble) {//多选日期
         if(self.firstDay.count == 0) {//请选择日期
             if (self.showblock) {
                 self.showblock();
             }
             return;
         }else if (self.lastDay.count == 0) {
             self.lastDay = self.firstDay;
              //获取当前时间年月日
              NSDate *now = [NSDate date];
              NSCalendar *calendar = [NSCalendar currentCalendar];
              NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
              NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
              NSInteger year1 = [dateComponent year];
              NSInteger month1 = [dateComponent month];
              NSInteger day1 = [dateComponent day];
              self.firstDay = @[[NSNumber numberWithInteger:year1],[NSNumber numberWithInteger:month1],[NSNumber numberWithInteger:day1]];
             if (self.block) {
                 self.block(self.firstDay, self.lastDay,self.yearArr);
             }
         }else{
             if (self.block) {
              self.block(self.firstDay, self.lastDay,self.yearArr);
             }
         }
     }else{//单选日期
         if (self.firstDay.count == 0) {//请选择日期
             if (self.showblock) {
                 self.showblock();
             }
         }else{
           [self goback];
       }
    }
 }
      

 #pragma mark 返回
 - (void)goback{
     //将两个时间返回
      //获取当前时间年月日
      NSDate *now = [NSDate date];
      NSCalendar *calendar = [NSCalendar currentCalendar];
      NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
      NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
      NSInteger year1 = [dateComponent year];
      NSInteger month1 = [dateComponent month];
      NSInteger day1 = [dateComponent day];
      self.firstDay = @[[NSNumber numberWithInteger:year1],[NSNumber numberWithInteger:month1],[NSNumber numberWithInteger:day1]];
     if (self.block) {
         self.block(self.firstDay, self.lastDay,self.yearArr);
     }
 }

@end
