//
//  img2TableViewController.m
//  mimamorugawaApp
//
//  Created by totyu2 on 2016/01/08.
//  Copyright © 2016年 totyu2. All rights reserved.
//

#import "img2TableViewController.h"
#import "img2TableViewCell.h"
#import "imgg1TableViewCell.h"
#import "DataBaseTool2.h"
@interface img2TableViewController ()
{
    imgg1TableViewCell*cell2;

    
    
    int xNum;//0:1~24時 1:1~7日 2:１〜３０日 　3:１〜１２月

    NSMutableArray *sectionArr;
    NSMutableArray *img1Arr;
    NSMutableArray *img2Arr;
    
    
    NSMutableDictionary*daydata;
    NSMutableDictionary*weekdata;
    NSMutableDictionary*monthdata;
    NSMutableArray *sensordata;
    NSMutableArray *sensordata2;
    NSMutableArray *sensordata3;
    NSString *alldayvalue;
    
    
    
    
    
    NSMutableArray*weekarr;
    NSMutableArray*weekarr2;
    NSMutableArray*weekarr3;
    NSString*weekdateString;
    NSString*weekdateString2;
    
    NSString*weekdateString3;
    NSString*sennweekdateString;
    NSString*sennweekdateString2;
    NSString*sennweekdateString3;
    NSString*sennsennweekdateString;
    NSString*sennsennweekdateString2;
    NSString*sennsennweekdateString3;
    NSArray *weekarray;
    NSArray *weekarray2;
    NSArray *weekarray3;
    NSArray *weekarray4;
    NSArray *weekarray5;
    NSArray *weekarray6;
    NSArray *weekarray7;
    NSArray *weekarray8;
    NSArray *weekarray9;
    NSArray *weekarray10;
    NSArray *weekarray11;
    NSArray *weekarray12;
    
    NSString*daydateString;
    NSString*senndaydateString;
    NSString*sennsenndaydateString;
    NSArray *dayarray;
    NSArray *dayarray2;
    NSArray *dayarray3;
    NSArray *dayarray4;
    NSArray *dayarray5;
    NSArray *dayarray6;
    NSArray *dayarray7;
    NSArray *dayarray8;
    NSArray *dayarray9;
    NSArray *dayarray10;
    NSArray *dayarray11;
    NSArray *dayarray12;
    
    NSMutableArray*montharr;
    NSMutableArray*montharr2;
    NSMutableArray*montharr3;
    NSString*monthdateString;
    NSString*sennmonthdateString;
    NSString*sennsennmonthdateString;
    NSArray *montharray;
    NSArray *montharray2;
    NSArray *montharray3;
    NSArray *montharray4;
    NSArray *montharray5;
    NSArray *montharray6;
    NSArray *montharray7;
    NSArray *montharray8;
    NSArray *montharray9;
    NSArray *montharray10;
    NSArray *montharray11;
    NSArray *montharray12;
    
    
    NSString*mouthnumm;
    NSString*mouthnumm2;
    NSString*mouthnumm3;
    
    NSArray*fff;
    NSArray*ggg;
    NSString*kkk;
    NSString*img2dateString;
    NSMutableDictionary *itemDict;
    
    int graphtype;

}

@end

@implementation img2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"img2TableViewCell" bundle:nil] forCellReuseIdentifier:@"dashboardCell2"];
    [self.tableView registerNib:[UINib nibWithNibName:@"imgg1TableViewCell" bundle:nil] forCellReuseIdentifier:@"imgg1Cell"];

    xNum = 0;

    [self getPlistWithName:@"000002001"];
    [self getPlistWithName2:@"000002002"];
    [self getPlistWithName3:@"000001002"];
    [self getPlistWithName4:@"000001001"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSDate *pickerDate = [NSDate date];
    
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    img2dateString = [pickerFormatter stringFromDate:pickerDate];
    [self getTaisetsuPeople];
    [self getList1];
     self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getList1{
    img1Arr = [[NSMutableArray alloc]initWithArray:[[DataBaseTool2 sharedDb]getL_EmergencyContacts1:_iuserid0]];


}

-(void)getTaisetsuPeople{
    if (!sectionArr) {
        sectionArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [sectionArr removeAllObjects];
    [itemDict removeAllObjects];
    NSString * t1 = _iname;
    NSString * t2 = @"通知先";

    [sectionArr addObject:t1];
    [sectionArr addObject:t2];

    

}
-(NSMutableArray*)dayArr:(NSString*)daytime :daysensorid{
    
    sensordata=[[NSMutableArray alloc]initWithArray:[[DataBaseTool2 sharedDb]getTodaySensorData:_iuserid0 :daysensorid :daytime]];
    NSMutableArray *stringArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",sensordata);
    daydata = [[NSMutableDictionary alloc]initWithCapacity:24];
    [daydata setValue:@"0" forKey:@"00:00:00"];
    [daydata setValue:@"0" forKey:@"01:00:00"];
    [daydata setValue:@"0" forKey:@"02:00:00"];
    [daydata setValue:@"0" forKey:@"03:00:00"];
    [daydata setValue:@"0" forKey:@"04:00:00"];
    [daydata setValue:@"0" forKey:@"05:00:00"];
    [daydata setValue:@"0" forKey:@"06:00:00"];
    [daydata setValue:@"0" forKey:@"07:00:00"];
    [daydata setValue:@"0" forKey:@"08:00:00"];
    [daydata setValue:@"0" forKey:@"09:00:00"];
    [daydata setValue:@"0" forKey:@"10:00:00"];
    [daydata setValue:@"0" forKey:@"11:00:00"];
    [daydata setValue:@"0" forKey:@"12:00:00"];
    [daydata setValue:@"0" forKey:@"13:00:00"];
    [daydata setValue:@"0" forKey:@"14:00:00"];
    [daydata setValue:@"0" forKey:@"15:00:00"];
    [daydata setValue:@"0" forKey:@"16:00:00"];
    [daydata setValue:@"0" forKey:@"17:00:00"];
    [daydata setValue:@"0" forKey:@"18:00:00"];
    [daydata setValue:@"0" forKey:@"19:00:00"];
    [daydata setValue:@"0" forKey:@"20:00:00"];
    [daydata setValue:@"0" forKey:@"21:00:00"];
    [daydata setValue:@"0" forKey:@"22:00:00"];
    [daydata setValue:@"0" forKey:@"23:00:00"];
    [stringArray addObject: @"00:00:00"];
    [stringArray addObject: @"01:00:00"];
    [stringArray addObject: @"02:00:00"];
    [stringArray addObject: @"03:00:00"];
    [stringArray addObject: @"04:00:00"];
    [stringArray addObject: @"05:00:00"];
    [stringArray addObject: @"06:00:00"];
    [stringArray addObject: @"07:00:00"];
    [stringArray addObject: @"08:00:00"];
    [stringArray addObject: @"09:00:00"];
    [stringArray addObject: @"10:00:00"];
    [stringArray addObject: @"11:00:00"];
    [stringArray addObject: @"12:00:00"];
    [stringArray addObject: @"13:00:00"];
    [stringArray addObject: @"14:00:00"];
    [stringArray addObject: @"15:00:00"];
    [stringArray addObject: @"16:00:00"];
    [stringArray addObject: @"17:00:00"];
    [stringArray addObject: @"18:00:00"];
    [stringArray addObject: @"19:00:00"];
    [stringArray addObject: @"20:00:00"];
    [stringArray addObject: @"21:00:00"];
    [stringArray addObject: @"22:00:00"];
    [stringArray addObject: @"23:00:00"];
    
    NSArray*keyy = [daydata allKeys];
    for (int t = 0; t<sensordata.count; t++) {
        NSMutableDictionary*day2 = [[NSMutableDictionary alloc]initWithDictionary:sensordata[t]];
        for (int i = 0; i<keyy.count; i++) {
            if ([keyy[i]isEqualToString:[day2 valueForKey:@"time"]]) {
                [daydata setValue:[day2 valueForKey:@"value"] forKey:keyy[i]];
            }
        }
    }
    
    
    for (int i = 0; i<stringArray.count; i++) {
        
        NSUInteger ii = [stringArray indexOfObject:keyy[i]];
        
        [stringArray setObject: [daydata valueForKey:keyy[i]] atIndexedSubscript:ii];
        
    }
    return stringArray;
}

-(NSMutableArray*)weekArr:(NSString*)weektime :weeksensorid{
    weekarr=[[NSMutableArray alloc]init];
    //本周
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];

    NSDate *weekdate = [format dateFromString:weektime];
    
    weekdateString = [format stringFromDate:weekdate];
    
    NSInteger year,month,week,day;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:weekdate];
    
    year = [comps year];
    
    week = [comps weekday];
    
    day = [comps day];
    
    month = [comps month];
    
    if (week == 1) {
        week = 8;
    }
    week = week -1;
    
    NSDate *weekdate1 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([weekdate timeIntervalSinceReferenceDate] - (week-1)*24*3600)];
    weekdateString3 = [format stringFromDate:weekdate1];
    
    
    for (int i = 0; i< 7; i++) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];

        NSDate *date2 = [format dateFromString:weekdateString3];
        NSDate *newDate2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date2 timeIntervalSinceReferenceDate] + i*24*3600)];
        weekdateString2 = [format stringFromDate:newDate2];
        
        sensordata2=[[NSMutableArray alloc]initWithArray:[[DataBaseTool2 sharedDb]getTodaySensorData:_iuserid0 :weeksensorid :weekdateString2]];
        
        int allvalues = 0;
        for (int i = 0; i< sensordata2.count; i++) {
            allvalues  =  allvalues+[[sensordata2[i] valueForKey:@"value"]intValue];
        }
        
        [weekarr addObject:[NSString stringWithFormat:@"%d",allvalues]];
        
    }
    
    NSLog(@"weekarr%@",weekarr);
    return weekarr;
}
-(NSMutableArray*)monthArr:(NSString*)monthtime :monthsensorid{
    montharr=[[NSMutableArray alloc]init];
    //本月
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date7 = [format dateFromString:monthtime];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date7];
    NSUInteger Month = range.length;
    NSLog(@"Month%lu",(unsigned long)Month);
    //NSLog(@"day%lu",(unsigned long)day);
    mouthnumm = [NSString stringWithFormat:@"%lu",(unsigned long)Month];
    
    for (int u = 0; u<Month; u++) {
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comps2 = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date7];
        //comps2.day = 1;
        NSDate *firstDay = [cal dateFromComponents:comps2];
        
        NSDateFormatter *format9 = [[NSDateFormatter alloc] init];
        [format9 setDateFormat:@"yyyy-MM-dd"];

        NSDate *newDate2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([firstDay timeIntervalSinceReferenceDate] + u*24*3600)];
        monthdateString = [format9 stringFromDate:newDate2];
        
        sensordata3=[[NSMutableArray alloc]initWithArray:[[DataBaseTool2 sharedDb]getTodaySensorData:_iuserid0 :monthsensorid :monthdateString]];
        int monthallvalues = 0;
        for (int i = 0; i< sensordata3.count; i++) {
            monthallvalues  =  monthallvalues+[[sensordata3[i] valueForKey:@"value"]intValue];
        }
        NSLog(@"monthallvalues%d",monthallvalues);
        [montharr addObject:[NSString stringWithFormat:@"%d",monthallvalues]];
    }
    
    
    return montharr;
}

-(NSString*)monthday:(NSString*)monthtime :monthsensorid{
    montharr=[[NSMutableArray alloc]init];
    //本月
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date7 = [format dateFromString:monthtime];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date7];
    NSUInteger Month = range.length;
    
    NSString*kday = [NSString stringWithFormat:@"%lu",(unsigned long)Month];
    
    
    return kday;
}

-(void)getPlistWithName:(NSString*)sensorid{
    
    if ([sensorid isEqualToString:@"000002001"]) {
        
        dayarray =[[NSArray alloc]initWithArray:[self dayArr:_nowTime :sensorid] ];
        
        weekarray = [[NSArray alloc]initWithArray:[self weekArr:_nowTime :sensorid]];
        
        montharray = [[NSArray alloc]initWithArray:[self monthArr:_nowTime :sensorid]];
        
        mouthnumm = [self monthday:_nowTime :sensorid];

    }
    
}
-(void)getPlistWithName2:(NSString*)sensorid{
    
    if ([sensorid isEqualToString:@"000002002"]) {
        
        dayarray4 =[[NSArray alloc]initWithArray:[self dayArr:_nowTime :sensorid] ];

        weekarray4 = [[NSArray alloc]initWithArray:[self weekArr:_nowTime :sensorid]];
        
        montharray4 = [[NSArray alloc]initWithArray:[self monthArr:_nowTime :sensorid]];
        
        mouthnumm = [self monthday:_nowTime :sensorid];
    
    }
}
-(void)getPlistWithName3:(NSString*)sensorid{
    
    if ([sensorid isEqualToString:@"000001002"]) {
        
        dayarray7 =[[NSArray alloc]initWithArray:[self dayArr:_nowTime :sensorid] ];
        
        weekarray7 = [[NSArray alloc]initWithArray:[self weekArr:_nowTime :sensorid]];
        
        montharray7 = [[NSArray alloc]initWithArray:[self monthArr:_nowTime :sensorid]];
        
        mouthnumm = [self monthday:_nowTime :sensorid];
        
    }
}
-(void)getPlistWithName4:(NSString*)sensorid{
    
    if ([sensorid isEqualToString:@"000001001"]) {
        
        dayarray10 =[[NSArray alloc]initWithArray:[self dayArr:_nowTime :sensorid] ];
        
        weekarray10 = [[NSArray alloc]initWithArray:[self weekArr:_nowTime :sensorid]];
        
        montharray10 = [[NSArray alloc]initWithArray:[self monthArr:_nowTime :sensorid]];
        
        mouthnumm = [self monthday:_nowTime :sensorid];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
     return 1;
    }else{
     return img1Arr.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sectionArr.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    //对齐方式
    
    if (section ==0) {
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _iname;
    }else if (section == 1){
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"◆通知先";
    }
    
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    if (indexPath.section == 0) {
        height = 150;
    }else if (indexPath.section == 1) {
        height = 60;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (indexPath.section == 0) {
        
    
    img2TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"dashboardCell2"];
    if (cell ==nil) {
        [[[NSBundle mainBundle]loadNibNamed:@"img2TableViewCell" owner:nil options:nil]firstObject];
    }
   
        cell.ppp = _iname;
        cell.nowtime.text = img2dateString;
        if ([_iname isEqualToString:@"電気"]) {
            
            cell.iii = [[DataBaseTool2 sharedDb]getL_ShiKiiMaster2:_iuserid0  :@"000002001"];
            
            cell.unitname.text = [[DataBaseTool2 sharedDb]getL_SensorMaster3:@"000002001"];
            
            [cell configUI:indexPath type:2  unit:xNum day:dayarray week:weekarray month:montharray];
            
        }else if ([ _iname isEqualToString:@"照度"]) {
            
            cell.iii = [[DataBaseTool2 sharedDb]getL_ShiKiiMaster2:_iuserid0  :@"000002002"];
            
            cell.unitname.text = [[DataBaseTool2 sharedDb]getL_SensorMaster3:@"000002002"];
            
            [cell configUI:indexPath type:2  unit:xNum day:dayarray4 week:weekarray4 month:montharray4];
            
        }else if ([_iname isEqualToString:@"マット"]){
            
            cell.iii = [[DataBaseTool2 sharedDb]getL_ShiKiiMaster2:_iuserid0  :@"000001002"];
            
            cell.unitname.text = [[DataBaseTool2 sharedDb]getL_SensorMaster3:@"000001002"];
            
            [cell configUI:indexPath type:2  unit:xNum day:dayarray7 week:weekarray7 month:montharray7];
        }else if ([_iname isEqualToString:@"ドア"]){
            
            cell.iii = [[DataBaseTool2 sharedDb]getL_ShiKiiMaster2:_iuserid0  :@"000001001"];
            
            cell.unitname.text = [[DataBaseTool2 sharedDb]getL_SensorMaster3:@"000001001"];
            
            [cell configUI:indexPath type:2  unit:xNum day:dayarray10 week:weekarray10 month:montharray10];
        }
 
    
    return cell;
    }else{
        cell2 = [self.tableView dequeueReusableCellWithIdentifier:@"imgg1Cell"];
        if (cell2 ==nil) {
            [[[NSBundle mainBundle]loadNibNamed:@"imgg1TableViewCell" owner:nil options:nil]firstObject];
        }

        //cell2 = [self.tableView dequeueReusableCellWithIdentifier:@"imgg1Cell" forIndexPath:indexPath];
        NSMutableDictionary*temp8 = [[NSMutableDictionary alloc]initWithDictionary:[img1Arr objectAtIndex:indexPath.row]];
        
        cell2.tutiName.text = [temp8 valueForKey:@"nickname"];
        cell2.tutiEmail.text = [temp8 valueForKey:@"contact"];
        
        return cell2;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        
        [self performSegueWithIdentifier:@"emergencyPush3" sender:self];
        
        
    }

}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"emergencyPush3"]){
//        sakiemergencyTableViewController *editExceptionTableView = segue.destinationViewController;
//        editExceptionTableView.mimamoUser2 = _iuserid0;
//    }
//}







@end
