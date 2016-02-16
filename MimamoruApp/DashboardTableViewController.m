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
    

    int xNum;//0:1~24時 1:1~7日 2:１〜３０日 　3:１〜１２月
    NSArray *dayarray;
    NSArray *weekarray;
    NSArray *montharray;
    NSArray *yeararray;
    NSArray *dayarray2;
    NSArray *weekarray2;
    NSArray *montharray2;
    NSArray *yeararray2;
    NSMutableArray *sectionArr;
    NSMutableArray *sectionArr2;
    NSString*dateString;
    NSString*dateString2;
    NSString*dateString3;
    
    NSMutableDictionary *itemDict;
    
    int graphtype;
    NSString*dateString4;
    NSString*machNameself;
    
    NSArray* visibleCells;
    
}
@property (strong, nonatomic) DashBoardTableViewCell *dashcell;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //刷新数据
    [[DataBaseTool sharedDB]openDB];
    

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
    
    
    [self getPlistWithName:@"testdata1"];
    [self getPlistWithName:@"testdata2"];
    
}




-(void)viewWillAppear:(BOOL)animated{
    NSDate *pickerDate = [NSDate date];
    
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    
    [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    dateString = [pickerFormatter stringFromDate:pickerDate];
    NSLog(@"%@",dateString);
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    // NSString *reportDate = [format stringFromDate:dateString];
    NSDate *date = [format dateFromString:dateString];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 24*3600)];
    dateString2 = [format stringFromDate:newDate];
    NSLog(@"%@",dateString2);
    
    NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
    [format2 setDateFormat:@"yyyy年MM月dd日"];
    // NSString *reportDate = [format stringFromDate:dateString];
    NSDate *date2 = [format dateFromString:dateString];
    NSDate *newDate2 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date2 timeIntervalSinceReferenceDate] - 48*3600)];
    dateString3 = [format stringFromDate:newDate2];
    NSLog(@"%@",dateString3);
    
    [self getTaisetsuPeople];
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

-(void)getTaisetsuPeople{
    if (!sectionArr) {
        sectionArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [sectionArr removeAllObjects];
 //   [itemDict removeAllObjects];
    NSString * t1 = @"電気使用量";
    NSString * t2 = @"マット";
    NSString * t3 = @"ドア";
    [sectionArr addObject:t1];
    [sectionArr addObject:t2];
    [sectionArr addObject:t3];
}

-(void)getPlistWithName:(NSString*)name{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    if ([name isEqualToString:@"testdata1"]) {
        dayarray =[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
        weekarray = [[NSArray alloc]initWithArray:[dict objectForKey:@"week"]];
        montharray = [[NSArray alloc]initWithArray:[dict objectForKey:@"month"]];
    }else if([name isEqualToString:@"testdata2"]){
        dayarray2=[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
        weekarray2 = [[NSArray alloc]initWithArray:[dict objectForKey:@"week"]];
        montharray2 = [[NSArray alloc]initWithArray:[dict objectForKey:@"month"]];
    }
    
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
    cell.rrr = sectionArr2[indexPath.section];
    if ([sectionArr[indexPath.section]isEqualToString:@"電気使用量"]) {
        if (xNum == 0) {
            cell.danwei.text = @"wh";
        }else if(xNum == 1){
            cell.danwei.text = @"kwh";
        }else if(xNum == 2){
            cell.danwei.text = @"kwh";
        }
        [cell configUI:indexPath type:2 unit:xNum day:dayarray week:weekarray month:montharray ];
        
    }else if ([sectionArr[indexPath.section]isEqualToString:@"照度"]) {
        
        cell.danwei.text = @"lux";
        
        [cell configUI:indexPath type:2 unit:xNum day:dayarray week:weekarray month:montharray ];
        
    }else{
        cell.danwei.text = @"回数";
        [cell configUI:indexPath type:2 unit:xNum day:dayarray2 week:weekarray2 month:montharray2 ];
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
        detail.titlename = machNameself;
    }
}

@end
