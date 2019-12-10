//
//  ViewController.m
//  WLCalendarExample
//
//  Created by 尹玉林 on 2019/12/9.
//  Copyright © 2019 尹玉林. All rights reserved.
//

#import "ViewController.h"
#import "WLChooseDateAlertView.h"
@interface ViewController ()
/** 选择日期弹框 */
@property (nonatomic, strong) WLChooseDateAlertView *alertDateView;
@property (nonatomic, strong) UILabel *startTime;
@property (nonatomic, strong) UILabel *endTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *startTime = [[UILabel alloc]init];
    startTime.text = @"开始日期";
    startTime.textAlignment = NSTextAlignmentCenter;
    startTime.frame = CGRectMake(0, 230, WLScreenW, 30);
    startTime.font = [UIFont boldSystemFontOfSize:18];
    startTime.textColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1];
    _startTime = startTime;
    [self.view addSubview:startTime];
    
    UILabel *endTime = [[UILabel alloc]init];
    endTime.text = @"结束日期";
    endTime.textAlignment = NSTextAlignmentCenter;
    endTime.frame = CGRectMake(0, 270, WLScreenW, 30);
    endTime.font = [UIFont boldSystemFontOfSize:18];
    endTime.textColor = [UIColor colorWithRed:252/255.0 green:66/255.0 blue:108/255.0 alpha:1];
    _endTime = endTime;
    [self.view addSubview:endTime];
        
    UIButton *singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singleBtn.frame = CGRectMake(WLScreenW/2-100, 350, 200, 50);
    singleBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1];
    [singleBtn setTitle:@"单选日期" forState:UIControlStateNormal];
    singleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [singleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    singleBtn.layer.cornerRadius = 23;
    singleBtn.layer.masksToBounds = YES;
    [singleBtn addTarget:self action:@selector(clickSingleBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:singleBtn];
            
    UIButton *doubleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doubleBtn.frame = CGRectMake(WLScreenW/2-100, 420, 200, 50);
    doubleBtn.backgroundColor = [UIColor colorWithRed:138/255.0 green:43/255.0 blue:226/255.0 alpha:1];
    [doubleBtn setTitle:@"多选日期" forState:UIControlStateNormal];
    doubleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [doubleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    doubleBtn.layer.cornerRadius = 23;
    doubleBtn.layer.masksToBounds = YES;
    [doubleBtn addTarget:self action:@selector(clickDoubleBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doubleBtn];
}
 
//单选
-(void)clickSingleBtn{
    [self chooseDate:1];
}

//多选
-(void)clickDoubleBtn{
    [self chooseDate:2];
}


-(void)chooseDate:(NSInteger)nub{//1代表单选日期，2代表多选日期
    ac_WeakSelf
//    if (self.alertDateView) {
//        [UIView animateWithDuration:0.5 animations:^{
//             weakSelf.alertDateView.center = CGPointMake(WLScreenW/2, WLScreenH/2);
//         }];
//    }else{
        WLChooseDateAlertView *alertView = [[WLChooseDateAlertView alloc]initWithMainColor:[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1] SelectedColor:[UIColor colorWithRed:252/255.0 green:66/255.0 blue:108/255.0 alpha:1] ChooseType:nub];
        alertView.frame = CGRectMake(0, 0, WLScreenW, WLScreenH);
        alertView.backgroundColor = [UIColor clearColor];
        _alertDateView = alertView;
        [UIView animateWithDuration:0.5 animations:^{
            alertView.center = CGPointMake(WLScreenW/2, WLScreenH/2);
            [self.view addSubview:alertView];
        }];
        
        [alertView showHintStr:^{//提示请选择日期
            NSLog(@"请选择日期");
        }];
                
        [alertView getTimeData:^(NSArray * _Nonnull firstDay, NSArray * _Nonnull lastDay, NSMutableArray * _Nonnull recordArr) {//选完日期block回调
            [UIView animateWithDuration:0.4 animations:^{
                weakSelf.alertDateView.center = CGPointMake(WLScreenW/2, WLScreenH*2);
            }];
            NSString *startStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld", (long)[firstDay[0] integerValue], (long)[firstDay[1] integerValue], (long)[firstDay[2] integerValue]];
            NSString *endStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)[lastDay[0] integerValue], (long)[lastDay[1] integerValue], (long)[lastDay[2] integerValue]];
            weakSelf.startTime.text = [NSString stringWithFormat:@"选好的开始时间:%@",startStr];
            weakSelf.endTime.text = [NSString stringWithFormat:@"选好的结束时间:%@",endStr];
        }];
    }
//}
@end
