//
//  LifeViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/19.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "LifeViewController.h"
#import "UUChart.h"
@interface LifeViewController ()<UUChartDataSource,UIScrollViewDelegate>
{
    UUChart *chartview;
    
    NSArray *dayArr1;
    NSArray *weekArr1;
    NSArray *monthArr1;
    NSArray *dayArr2;
    NSArray *weekArr2;
    NSArray *monthArr2;

    
    int type;
    int xNum;
    
    NSString *t1Str;
    NSString *t2Str;
    NSString *t3Str;
}
@property (strong, nonatomic)UILabel *title;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


@end

@implementation LifeViewController
@synthesize scroll,title;


-(void)configtype:(int)styletype uNit:(int)num day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month
{
    if (scroll) {
        [chartview removeFromSuperview];
    }
    
    if (!title) {
        title = [[UILabel alloc]init];
    }
    for (int j = 0; j<1; j++) {
        for (int i =0 ; i<3; i++) {
           // NSLog(@"num = %d j=%d,i=%d",num,j,i);
           
            title = [[UILabel alloc]initWithFrame:CGRectMake(10 +i*[UIScreen mainScreen].bounds.size.width, 5+j*170, [UIScreen mainScreen].bounds.size.width-20, 30)];
            chartview = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10+i*[UIScreen mainScreen].bounds.size.width, 45 +j*170, [UIScreen mainScreen].bounds.size.width-20, 130) withSource:self withStyle:type==2?UUChartBarStyle:UUChartLineStyle];
            [scroll addSubview:title];
            [chartview showInView:scroll];
        }
        
    }
    //设置显示当前区域位置 2*width
    scroll.contentOffset =CGPointMake([UIScreen mainScreen].bounds.size.width*2, 0);
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    _segment.selectedSegmentIndex =0;
    xNum = 0;
    [self configtype:1 uNit:xNum day:dayArr1 week:weekArr1 month:monthArr1];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} forState:UIControlStateNormal];
    scroll.delegate = self;
    [scroll setShowsHorizontalScrollIndicator:NO];
    //[scroll setShowsVerticalScrollIndicator:NO];
    //设置可滑动的宽度 3*width
    scroll.contentSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)*3, 300);
    
    scroll.pagingEnabled =YES;
    [self getPlistWithName:@"testdata1"];
    [self getPlistWithName:@"testdata2"];

    
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    //today
    
    NSDate *pickerDate = [NSDate date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    t3Str = [pickerFormatter stringFromDate:pickerDate];
    
    //yesterday
    
    NSDate *pickerDate2 = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter *pickerFormatter2 = [[NSDateFormatter alloc] init];
    [pickerFormatter2 setDateFormat:@"yyyy年MM月dd日"];
    t2Str = [pickerFormatter2 stringFromDate:pickerDate2];
    
    //the day before yesterday
    
    NSDate *pickerDate3 = [NSDate dateWithTimeIntervalSinceNow:-(2*24*60*60)];
    NSDateFormatter *pickerFormatter3 = [[NSDateFormatter alloc] init];
    [pickerFormatter3 setDateFormat:@"yyyy年MM月dd日"];
    t1Str = [pickerFormatter3 stringFromDate:pickerDate3];
    
    
    
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    int i = (scroll.contentOffset.x)/scroll.bounds.size.width;
    NSLog(@"%d",i);
    if (xNum==0) {
        if (i==0) {
            title.text = t1Str;
        }else
            if (i==1) {
                title.text = t2Str;
            }else
                if (i==2) {
                    title.text = t3Str;
                }
    }
    if (xNum == 1) {
        
        if (i==0) {
            title.text = @"先先週";
        }else
            if (i==1) {
                title.text = @"先週";
            }else
                if (i==2) {
                    title.text = @"今週";
                }
    }
    if (xNum == 2) {
        
        if (i==0) {
            title.text = @"先先月";
        }else
            if (i==1) {
                title.text = @"先月";
            }else
                if (i==2) {
                    title.text = @"今月";
                }
    }
}



-(void)segmentAction:(UISegmentedControl*)seg{
    if (seg.selectedSegmentIndex == 0){
        xNum = 0;
        [self configtype:1 uNit:xNum day:dayArr1 week:weekArr1 month:monthArr1];
    }else if(seg.selectedSegmentIndex == 1){
        xNum = 1;
        [self configtype:1 uNit:xNum day:dayArr2 week:weekArr2 month:monthArr2];
    }else if(seg.selectedSegmentIndex == 2){
        xNum = 2;
        [self configtype:1 uNit:xNum day:dayArr2 week:weekArr2 month:monthArr2];
    }
    
}


-(void)getPlistWithName:(NSString*)name{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    if ([name isEqualToString:@"testdata1"]) {
        dayArr1 =[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
        weekArr1 = [[NSArray alloc]initWithArray:[dict objectForKey:@"week"]];
        monthArr1 = [[NSArray alloc]initWithArray:[dict objectForKey:@"month"]];
    }else if([name isEqualToString:@"testdata2"]){
        dayArr2=[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
        weekArr2 = [[NSArray alloc]initWithArray:[dict objectForKey:@"week"]];
        monthArr2 = [[NSArray alloc]initWithArray:[dict objectForKey:@"month"]];
    }
    
}


-(NSArray*)getXTitles:(int)num{
    NSMutableArray *xTitles = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i =1; i<=num; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
    
}

- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    
    switch (xNum) {
        case 0:
            return [self getXTitles:24];
        case 1:
            return [self getXTitles:7];
        case 2:
            return [self getXTitles:30];
            
        default:
            break;
    }
    
    return [self getXTitles:12];
}


- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    switch (xNum) {
        case 0:
            return @[dayArr1];
            
        case 1:
            return @[weekArr1];
            
        case 2:
            return @[monthArr1];
            
        default:
            break;
    }
    return @[dayArr1
             ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
