//
//  DashboardTableViewController.m
//  Mimamoro
//
//  Created by totyu1 on 2015/12/15.
//  Copyright © 2015年 totyu1. All rights reserved.
//

#import "DashboardTableViewController.h"
#import "DashBoardTableViewCell.h"
#import "DetailTableViewController.h"
#import "DataBaseTool.h"
@interface DashboardTableViewController() <UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    
    
    NSString *userid0;
    //显示传感器个数和图表显示类型
    NSMutableArray * sensorArr;
    //显示section标题
    NSMutableArray *sectionArr;
    int xNum;//0:1~24時 1:1~7日 2:１〜３０日 　3:１〜１２月
    //当月 上月 上上月 天数
    int backmonth;
    int backbackmonth;
    int nowmonth;
    //1:今天，这周，这月
    //2:昨天，上周，上月
    //3:前天，上上周，上上月
    NSArray *dayArr1;
    NSArray *dayArr2;
    NSArray *dayArr3;
    NSMutableArray *weekArr1;
    NSMutableArray *weekArr2;
    NSMutableArray *weekArr3;
    NSMutableArray *monthArr1;
    NSMutableArray *monthArr2;
    NSMutableArray *monthArr3;
    
    
    NSString*dateString;
    NSString*dateString2;
    NSString*dateString3;
    
    NSMutableDictionary *itemDict;
    //
    NSString*machNameself;
    NSString *sensor;
    NSArray* visibleCells;
    
}
@property (strong, nonatomic) DashBoardTableViewCell *dashcell;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新数据
    
    
    NSString * login = @"login";
    [[NSUserDefaults standardUserDefaults]setObject:login forKey:@"type"];

    
    _dashcell = [[DashBoardTableViewCell alloc]init];
    _dashcell.currentNo = 2;
    [self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} forState:UIControlStateNormal];
    CGRect farme = self.segmentControl.frame;
    farme.size.height = 40;
    self.segmentControl.frame = farme;
   
    [self.tableView registerNib:[UINib nibWithNibName:@"DashBoardTableViewCell" bundle:nil] forCellReuseIdentifier:@"dashboardCell"];
    xNum = 0;
    //Get test data from plist files
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
}
#pragma mark - 刷新数据
-(void)reloadDataSensorid:(NSString*)sensorid{
    
    //日数据
    NSArray *dayArr = [[DataBaseTool sharedDB]selectL_SensorDayData:userid0 Sensorid:sensorid];
    
    dayArr1 = [[NSArray alloc]initWithArray:dayArr[0]];
    dayArr2 = [[NSArray alloc]initWithArray:dayArr[1]];
    dayArr3 = [[NSArray alloc]initWithArray:dayArr[2]];
   
    //周数据
    weekArr1 = [[NSMutableArray alloc]init];
    weekArr2 = [[NSMutableArray alloc]init];
    weekArr3 = [[NSMutableArray alloc]init];
    NSMutableArray* weekArr10 = [[NSMutableArray alloc]init];
    NSMutableArray* weekArr20 = [[NSMutableArray alloc]init];
    NSMutableArray* weekArr30 = [[NSMutableArray alloc]init];
    NSArray *weekArr = [[DataBaseTool sharedDB]selectL_SensorWeekData:userid0 Sensorid:sensorid];
    int m =0;
    m = [weekArr[0]intValue];
    for (int i=1; i<weekArr.count; i++) {
        NSString *day = [weekArr objectAtIndex:i];
        if (i< 8-m) {
            [weekArr10 addObject:day];
        }
        if (i>(7-m) && i<(15-m)) {
            [weekArr20 addObject:day];
        }
        if (i>(14-m)) {
            [weekArr30 addObject:day];
        }
    }
    //先周 先先周 反序输出
    for (NSString *str in [weekArr10 reverseObjectEnumerator]) {
        [weekArr1 addObject:str];
    }
    for (NSString *str in [weekArr20 reverseObjectEnumerator]) {
        [weekArr2 addObject:str];
    }
    for (NSString *str in [weekArr30 reverseObjectEnumerator]) {
        [weekArr3 addObject:str];
    }
    //月数据
    monthArr1 = [[NSMutableArray alloc]init];
    monthArr2 = [[NSMutableArray alloc]init];
    monthArr3 = [[NSMutableArray alloc]init];
    NSMutableArray* monthArr10 = [[NSMutableArray alloc]init];
    NSMutableArray* monthArr20 = [[NSMutableArray alloc]init];
    NSMutableArray* monthArr30 = [[NSMutableArray alloc]init];
    NSArray *monthArr = [[DataBaseTool sharedDB]selectL_SensorMounthData:userid0 Sensorid:sensorid];
    int monthday = 0;
    int dayInt = 0;
    int yearInt = 0;
    dayInt = [monthArr[1]intValue]; //当天日期
    monthday = [monthArr[0]intValue];//当月月数
    yearInt = [monthArr[2]intValue];//当年年份
    //当月 上月 上上月 天数
    nowmonth = 0;
    backmonth = 0;
    backbackmonth = 0;
    
    for (int i = 3; i<monthArr.count; i++) {
        NSString *day = [monthArr objectAtIndex:i];
        if (i<dayInt+3) {
            [monthArr10 addObject:day];
        }
        if (monthday==1) {
            nowmonth = 31;
            backmonth = 31;
            backbackmonth = 30;
        }
        if (monthday==2) {
            if (yearInt%4==0) {
                nowmonth = 29;
            }else{
                nowmonth = 28;
            }
            backmonth = 31;
            backbackmonth = 31;
        }
        if (monthday==3) {
            nowmonth = 31;
            if (yearInt%4==0) {
                backmonth = 29;
            }else{
                backmonth = 28;
            }
            backbackmonth = 31;
        }
        if (monthday==4) {
            nowmonth = 30;
            backmonth = 31;
            if (yearInt%4==0) {
                backbackmonth = 29;
            }else{
                backbackmonth = 28;
            }
        }
        if (monthday==5) {
            nowmonth = 31;
            backmonth =30;
            backbackmonth = 31;
        }
        if (monthday==6) {
            nowmonth = 30;
            backmonth = 31;
            backbackmonth = 30;
        }
        if (monthday==7) {
            nowmonth = 31;
            backmonth = 30;
            backbackmonth = 31;
        }
        if (monthday==8) {
            nowmonth = 31;
            backmonth = 31;
            backbackmonth = 30;
        }
        if (monthday==9) {
            nowmonth = 30;
            backmonth = 31;
            backbackmonth = 31;
        }
        if (monthday==10) {
            nowmonth = 31;
            backmonth = 30;
            backbackmonth = 31;
        }
        if (monthday==11) {
            nowmonth = 30;
            backmonth = 31;
            backbackmonth = 30;
        }
        if (monthday==12) {
            nowmonth = 31;
            backmonth = 30;
            backbackmonth =31;
        }
        
        if (i>dayInt+2 && i <dayInt+backmonth+3) {
            [monthArr20 addObject:day];
        }
        if (i>dayInt+backmonth+2 && i < dayInt+backmonth+3+backbackmonth) {
            [monthArr30 addObject:day];
        }
    }
    //先月 先先月反序输出
    for (NSString *str in [monthArr10 reverseObjectEnumerator]) {
        [monthArr1 addObject:str];
    }
    for (NSString *str in [monthArr20 reverseObjectEnumerator]) {
        [monthArr2 addObject:str];
    }
    for (NSString *str in [monthArr30 reverseObjectEnumerator]) {
        [monthArr3 addObject:str];
    }
    //NSLog(@"1=%@ 2=%@ 3=%@",monthArr1,monthArr2,monthArr3);
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    userid0 = [[NSUserDefaults standardUserDefaults]valueForKey:@"userid0"];
    
    //从服务器下载数据
    //[[DataBaseTool sharedDB]openDB];
    //获取传感器个数类型
    [self getTaisetsuPeople];
    //从本地刷新数据
    
    NSDate *pickerDate = [NSDate date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    dateString = [pickerFormatter stringFromDate:pickerDate];
   // NSLog(@"%@",dateString);
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    // NSString *reportDate = [format stringFromDate:dateString];
    NSDate *date = [format dateFromString:dateString];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 24*3600)];
    dateString2 = [format stringFromDate:newDate];
   // NSLog(@"%@",dateString2);
    
    NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
    [format2 setDateFormat:@"yyyy年MM月dd日"];
    // NSString *reportDate = [format stringFromDate:dateString];
    NSDate *date2 = [format dateFromString:dateString];
    NSDate *newDate2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date2 timeIntervalSinceReferenceDate] - 48*3600)];
    dateString3 = [format stringFromDate:newDate2];
   // NSLog(@"%@",dateString3);
    
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"view touch began");
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"view touch ended");
}
-(void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event whichView:(id)scrollView{
    NSLog(@"scrollView  touch ended");
    
}

#pragma mark - 获取本地L_SensorMaster

-(void)getTaisetsuPeople{
    //打开数据库
    [[DataBaseTool sharedDB]openDB];
    //传感器个数和图表显示类型
    sensorArr = [[DataBaseTool sharedDB]selectL_SensorMaster:userid0];
    if (sensorArr.count == 0) {
        sensorArr = [[NSMutableArray alloc]init];
    }

    if (!sectionArr) {
        sectionArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [sectionArr removeAllObjects];
    
    for (int i = 0 ; i< sensorArr.count; i++) {
        NSDictionary *sensorDic = [[NSDictionary alloc]init];
        sensorDic = [sensorArr objectAtIndex:i];
        NSString *sensorid = [sensorDic valueForKey:@"sensorid"];
       // NSString *sensorname = [sensorDic valueForKey:@"sensorname"];
        if ([sensorid isEqualToString:@"000002001"]) {
            NSString * t1 = @"電気使用量";
            [sectionArr addObject:t1];
        }
        if ([sensorid isEqualToString:@"000001002"]) {
            NSString * t2 = @"マット";
            [sectionArr addObject:t2];
        }
        if ([sensorid isEqualToString:@"000001001"]) {
            NSString * t3 = @"ドア";
            [sectionArr addObject:t3];
        }
        if ([sensorid isEqualToString:@"000002002"]) {
            NSString *t4 = @"照度";
            [sectionArr addObject:t4];
        }
    }
    NSLog(@"sectionArr=%@",sectionArr);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(NSArray *)cellsForTableView:(UITableView *)tableView
{
    NSInteger sections = tableView.numberOfSections;
    NSMutableArray *cells = [[NSMutableArray alloc]  init];
    for (int section = 0; section < sections; section++) {
        NSInteger rows =  [tableView numberOfRowsInSection:section];
        for (int row = 0; row < rows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [cells addObject:[tableView cellForRowAtIndexPath:indexPath]];
        }
    }
    return cells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    DashBoardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"dashboardCell"];
    cell.hhh = sectionArr[indexPath.section];
    NSLog(@"%@",sectionArr[indexPath.section]);
    for (int i =0; i<sectionArr.count; i++) {
        NSString *titleName = [sectionArr objectAtIndex:i];
        if ([titleName isEqualToString:@"電気使用量"]) {
            cell.rrr = @"0";
            if (xNum == 0) {
                cell.danwei.text = @"wh";
            }else if(xNum == 1){
                cell.danwei.text = @"kwh";
            }else if(xNum == 2){
                cell.danwei.text = @"kwh";
            }
            [self reloadDataSensorid:@"000002001"];
            [cell configUI:indexPath type:2 unit:xNum day1:dayArr3 week1:weekArr3 month1:monthArr3 day2:dayArr2 week2:weekArr2 month2:monthArr2 day3:dayArr1 week3:weekArr1 month3:monthArr1 sendNmonth:nowmonth Bmonth:backmonth BBmonth:backbackmonth];
        }
        if ([titleName isEqualToString:@"照度"]) {
            cell.rrr = @"0";
            cell.danwei.text = @"lux";
            [self reloadDataSensorid:@"000002002"];
            [cell configUI:indexPath type:2 unit:xNum day1:dayArr3 week1:weekArr3 month1:monthArr3 day2:dayArr2 week2:weekArr2 month2:monthArr2 day3:dayArr1 week3:weekArr1 month3:monthArr1 sendNmonth:nowmonth Bmonth:backmonth BBmonth:backbackmonth];
        }
        if ([titleName isEqualToString:@"マット"]) {
            cell.rrr = @"1";
            cell.danwei.text = @"回数";
            [self reloadDataSensorid:@"000001002"];
            [cell configUI:indexPath type:2 unit:xNum day1:dayArr3 week1:weekArr3 month1:monthArr3 day2:dayArr2 week2:weekArr2 month2:monthArr2 day3:dayArr1 week3:weekArr1 month3:monthArr1 sendNmonth:nowmonth Bmonth:backmonth BBmonth:backbackmonth];
        }
        if ([titleName isEqualToString:@"ドア"]) {
            cell.rrr = @"1";
            cell.danwei.text = @"回数";
            [self reloadDataSensorid:@"000001001"];
            [cell configUI:indexPath type:2 unit:xNum day1:dayArr3 week1:weekArr3 month1:monthArr3 day2:dayArr2 week2:weekArr2 month2:monthArr2 day3:dayArr1 week3:weekArr1 month3:monthArr1 sendNmonth:nowmonth Bmonth:backmonth BBmonth:backbackmonth];
        }
    }

    cell.scoll.tag = indexPath.row;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subscribeBtnClicked:)];
    
    [cell.scoll addGestureRecognizer:singleTap1];
    
    if (xNum == 0){
        cell.fff.text = dateString;
    }else if(xNum == 1){
        cell.fff.text = @"今週";
    }else if(xNum == 2){
        cell.fff.text = @"今月";
    }
    cell.scoll.delegate = self;
    
    return cell;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(DashBoardTableViewCell *)[[scrollView superview] superview]];
    
    DashBoardTableViewCell*cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    int currentPage = (cell.scoll.contentOffset.x - cell.scoll.frame.size.width
                       
                       / (5)) / cell.scoll.frame.size.width + 1;
    
    
    if (currentPage==0) {
        
        if (xNum == 0) {
            cell.fff.text = dateString3;
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }else if(xNum == 1){
            cell.fff.text = @"先先週";
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }else if(xNum == 2){
            cell.fff.text = @"先先月";
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }
        
    }else if (currentPage== 1) {
        
        if (xNum == 0) {
            cell.fff.text = dateString2;
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }else if(xNum == 1){
            cell.fff.text = @"先週";
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }else if(xNum == 2){
            cell.fff.text = @"先月";
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }
        
    }else if (currentPage== 2) {
        
        if (xNum == 0) {
            cell.fff.text = dateString;
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"key"];
        }else if(xNum == 1){
            cell.fff.text = @"今週";
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }else if(xNum == 2){
            cell.fff.text = @"今月";
            visibleCells = self.tableView.visibleCells;
            
            for(DashBoardTableViewCell *cell1 in visibleCells){
                
                if (scrollView == cell.scoll) {
                    cell1.fff.text = cell.fff.text;
                }else{
                    cell.fff.text = cell1.fff.text;
                }
                
            }
        }
    }
}

#pragma mark - scrollview 点击事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(DashBoardTableViewCell *)[[scrollView superview] superview]];
    
    DashBoardTableViewCell*cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    visibleCells = self.tableView.visibleCells;
    
    for(DashBoardTableViewCell *cell1 in visibleCells){
        if (scrollView == cell.scoll) {
            [cell1.scoll setContentOffset:cell.scoll.contentOffset];
        }else{
            
            [cell.scoll setContentOffset:cell1.scoll.contentOffset];
        }
    }
}
- (void)subscribeBtnClicked:(UITapGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    //这里获得了indexpath.row
    machNameself = sectionArr[indexPath.section];
    NSString *sensorId = sectionArr[indexPath.section];
    if ([sensorId isEqualToString:@"電気使用量"]) {
        sensor = @"000002001";
    }
    if ([sensorId isEqualToString:@"マット"]) {
        sensor = @"000001002";
    }
    if ([sensorId isEqualToString:@"ドア"]) {
        sensor = @"000001001";
    }
    if ([sensorId isEqualToString:@"照度"]) {
        sensor = @"000002002";
    }
    [self performSegueWithIdentifier:@"img2Push" sender:self];
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    label.text = sectionArr[section];
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)segmentAction:(UISegmentedControl*)seg{
    if (seg.selectedSegmentIndex == 0){
        xNum = 0;
    }else if(seg.selectedSegmentIndex == 1){
        xNum = 1;
    }else if(seg.selectedSegmentIndex == 2){
        xNum = 2;
    }
    [self.tableView reloadData];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"img2Push"])
    {
        DetailTableViewController *detail = segue.destinationViewController;
        detail.sensorid = sensor;
        detail.titlename = machNameself;
    }
}

@end
