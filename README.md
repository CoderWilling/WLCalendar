# WLCalendar
日历 自定义日历 支持单选日期多选日期，跨月选择  <br>
## 使用方法<br>
* 1.导入头文件：<br>
#import "WLChooseDateAlertView.h"
* 2.声明属性：<br>
@interface ViewController ()<br>
/** 选择日期弹框 */<br>
@property (nonatomic, strong) WLChooseDateAlertView *alertDateView;<br>
@property (nonatomic, strong) UILabel *startTime;<br>
@property (nonatomic, strong) UILabel *endTime;<br>
@end
* 3.初始化日历：<br>
-(void)chooseDate:(NSInteger)nub{//1代表单选日期，2代表多选日期<br>
        ac_WeakSelf<br>
        WLChooseDateAlertView *alertView = [[WLChooseDateAlertView alloc]initWithMainColor:[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1] SelectedColor:[UIColor colorWithRed:252/255.0 green:66/255.0 blue:108/255.0 alpha:1] ChooseType:nub];<br><br>
        alertView.frame = CGRectMake(0, 0, WLScreenW, WLScreenH);<br>
        alertView.backgroundColor = [UIColor clearColor];<br>
        _alertDateView = alertView;<br>
        [UIView animateWithDuration:0.5 animations:^{<br>
            alertView.center = CGPointMake(WLScreenW/2, WLScreenH/2);<br>
            [self.view addSubview:alertView];<br>
        }];<br>
        
        [alertView showHintStr:^{//提示请选择日期
            NSLog(@"请选择日期");
        }];
                
        [alertView getTimeData:^(NSArray * _Nonnull firstDay, NSArray * _Nonnull lastDay, NSMutableArray * _Nonnull recordArr) {//选完日期block回调
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.alertDateView.center = CGPointMake(WLScreenW/2, WLScreenH*2);<br>
            }];
            NSString *startStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)[firstDay[0] integerValue], (long)[firstDay[1] integerValue], (long)[firstDay[2] integerValue]];
            NSString *endStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)[lastDay[0] integerValue], (long)[lastDay[1] integerValue], (long)[lastDay[2] integerValue]];
            weakSelf.startTime.text = [NSString stringWithFormat:@"选好的开始时间:%@",startStr];
            weakSelf.endTime.text = [NSString stringWithFormat:@"选好的结束时间:%@",endStr];
        }];
}
