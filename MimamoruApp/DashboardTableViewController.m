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
    
    int graphtype;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *type = @"login";
    [[NSUserDefaults standardUserDefaults]setObject:type forKey:@"type"];
    
    //self.segmentControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DashBoardTableViewCell" bundle:nil] forCellReuseIdentifier:@"dashboardCell"];
    xNum = 0;
    //Get test data from plist files
    [_segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self getPlistWithName:@"testdata1"];
    [self getPlistWithName:@"testdata2"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getTaisetsuPeople];
  //  [self getServiceItem];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)getTaisetsuPeople{
    if (!sectionArr) {
        sectionArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [sectionArr removeAllObjects];
    [itemDict removeAllObjects];
    NSString * n1 = @"電気使用量";
    NSString * n2 = @"照度";
    [sectionArr addObject:n1];
    [sectionArr addObject:n2];
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
       // yeararray = [[NSArray alloc]initWithArray:[dict objectForKey:@"year"]];
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
    DashBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dashboardCell"];
    if (cell ==nil) {
        [[[NSBundle mainBundle]loadNibNamed:@"DashBoardTableViewCell" owner:nil options:nil]firstObject];
    }
    NSDictionary *tmp = [itemDict objectForKey:sectionArr[indexPath.section]];
    NSDictionary *item = [tmp valueForKey:tmp.allKeys[indexPath.row]];
    cell.itemLabel.text = [item valueForKey:@"toolData"];
    [cell configUI:indexPath type:2 unit:xNum day:dayarray week:weekarray month:montharray year:yeararray];

//    if (indexPath.section == 0) {
//        [cell configUI:indexPath type:1 unit:xNum day:dayarray week:weekarray month:montharray year:yeararray];
//    }else if (indexPath.section == 1){
//        [cell configUI:indexPath type:2 unit:xNum day:dayarray2 week:weekarray2 month:montharray2 year:yeararray2];
//    }
    
    return cell;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailTableViewController *detail = [main instantiateViewControllerWithIdentifier:@"detail"];
    detail.id = sectionArr[indexPath.section];
    [self.navigationController pushViewController:detail animated:YES];
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


@end
