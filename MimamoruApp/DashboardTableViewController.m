//
//  DashboardTableViewController.m
//  Mimamoro
//
//  Created by totyu1 on 2015/12/15.
//  Copyright © 2015年 totyu1. All rights reserved.
//

#import "DashboardTableViewController.h"
#import "DashBoardTableViewCell.h"
#import "img2TableViewController.h"
@interface DashboardTableViewController (){
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
    NSMutableDictionary *itemDict;
    DashBoardTableViewCell *cell;
    //NSMutableArray*groupArr1;
    int graphtype;
    
    NSString*machNameself;
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_title2.text = _tempname;
    [self.tableView registerNib:[UINib nibWithNibName:@"DashBoardTableViewCell" bundle:nil] forCellReuseIdentifier:@"dashboardCell"];
    xNum = 0;
    //Get test data from plist files
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self getPlistWithName:@"testdata1"];
    [self getPlistWithName:@"testdata2"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getTaisetsuPeople];
    [self getServiceItem];
    
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
    [itemDict removeAllObjects];
    NSString * t1 = @"電気使用量";
    NSString * t2 = @"マット";
    NSString * t3 = @"ドア";
    [sectionArr addObject:t1];
    [sectionArr addObject:t2];
    [sectionArr addObject:t3];
    
//    NSMutableDictionary*machineuse3=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"machineuse"]];
//    NSArray* allkey2 = [machineuse3 allKeys];
//
//    for (int i = 0; i<allkey2.count; i++) {
//        NSArray *array = [allkey2[i] componentsSeparatedByString:@":"];
//        if([array[1]isEqualToString:_namee]){
//        NSDictionary *tempDict = [machineuse3 objectForKey:allkey2[i]];
//        
//        [sectionArr addObject:[tempDict valueForKey:@"machName"]];
//        }
//    }
    
    
    
    //NSDictionary *tempDict = [machineuse3 objectForKey:_namee];
    
    
//    [sectionArr addObject:@"2121"];
//    [sectionArr addObject:@"44"];
//    [sectionArr addObject:@"456"];
    //    [sectionArr addObject:t2];
    //    NSArray *temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"group8"];
    //    if (temp) {
    //        for (NSDictionary *tmp in temp) {
    //            [sectionArr addObject:[tmp valueForKey:@"groupname"]];
    //        }
    //    }
}

-(void)getServiceItem{
    NSDictionary *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:@"anybody"];
    if (tmp) {
        itemDict = [[NSMutableDictionary alloc]initWithDictionary:tmp];
        //NSLog(@"itemdict-> %@",itemDict);
    }
    [self.tableView reloadData];
}

-(void)getPlistWithName:(NSString*)name{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    if ([name isEqualToString:@"testdata1"]) {
        dayarray =[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
        weekarray = [[NSArray alloc]initWithArray:[dict objectForKey:@"week"]];
        montharray = [[NSArray alloc]initWithArray:[dict objectForKey:@"month"]];
        //yeararray = [[NSArray alloc]initWithArray:[dict objectForKey:@"year"]];
    }else if([name isEqualToString:@"testdata2"]){
        dayarray2=[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
        weekarray2 = [[NSArray alloc]initWithArray:[dict objectForKey:@"week"]];
        montharray2 = [[NSArray alloc]initWithArray:[dict objectForKey:@"month"]];
        //yeararray2 = [[NSArray alloc]initWithArray:[dict objectForKey:@"year"]];
        //NSLog(@"dayarr->%@",dayarray2);
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    NSDictionary *tmp = [itemDict objectForKey:sectionArr[section]];
    //    return tmp.allKeys.count;
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (tableView == _img2tableciew) {
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"dashboardCell"];
    if (cell ==nil) {
        [[[NSBundle mainBundle]loadNibNamed:@"DashBoardTableViewCell" owner:nil options:nil]firstObject];
    }
    cell.hhh = sectionArr[indexPath.section];
    if (indexPath.section == 2 ) {
        [cell configUI:indexPath type:2 unit:xNum day:dayarray2 week:weekarray2 month:montharray2];
        
    }else if (indexPath.section ==1){
        [cell configUI:indexPath type:2 unit:xNum day:dayarray2 week:weekarray2 month:montharray2];
    }else{
        [cell configUI:indexPath type:2 unit:xNum day:dayarray week:weekarray month:montharray];
    }
    cell.scoll.tag = indexPath.row;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subscribeBtnClicked:)];
    [cell.scoll addGestureRecognizer:singleTap1];
    
    if (xNum == 0) {
        cell.fff.text = @"今日";
    }else if(xNum == 1){
        cell.fff.text = @"今週";
    }else if(xNum == 2){
        cell.fff.text = @"今月";
    }
    
    return cell;
    
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
    //    label.text = section ?@"おばあちゃん - ベッド":@"おじいちゃん - 電気使用量";
    label.text = sectionArr[section];
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)segmentAction:(UISegmentedControl*)seg{
    if (seg.selectedSegmentIndex == 0){
        xNum = 0;
        
        [self.tableView reloadData];
    }else if(seg.selectedSegmentIndex == 1){
        xNum = 1;
   
        [self.tableView reloadData];
    }else if(seg.selectedSegmentIndex == 2){
        xNum = 2;
 
        [self.tableView reloadData];
    }

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"img2Push"])
    {
        img2TableViewController *editimg2TableView = segue.destinationViewController;
        editimg2TableView.tempname = machNameself;
        editimg2TableView.username = _namee;
    }
}

@end
