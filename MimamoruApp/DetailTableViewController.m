//
//  DetailTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/8.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DashBoardTableViewCell.h"
@interface DetailTableViewController ()
{
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
    
    NSMutableArray *contacts;
    NSMutableArray *message;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation DetailTableViewController


-(void)configUI:(NSIndexPath*)indexPath type:(int)styletype unit:(int)segmentunitnum day:(NSArray*)day week:(NSArray*)week month:(NSArray*)month year:(NSArray*)year{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.id;
    contacts = [[NSMutableArray alloc]initWithObjects:@"真纪",@"友美",@"安藤", nil];
    [self.tableView registerNib:[UINib nibWithNibName:@"DashBoardTableViewCell" bundle:nil] forCellReuseIdentifier:@"dashboardCell"];
    xNum = 0;
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self getPlistWithName:@"testdata1"];
    [self getPlistWithName:@"testdata2"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    long m;
    if (section == 0) {
        m = 1;
    }else if (section ==1){
        m = contacts.count;
    }else if (section ==2){
        m = 1;
    }
    return m;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (section==0) {
        title = self.id;
    }else if (section==1) {
        title = @"連絡先";
    }else if (section==2){
        title = @"しきい値（警戒値）";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section==0) {
        DashBoardTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"dashboardCell"];
        if (cell1 ==nil) {
            [[[NSBundle mainBundle]loadNibNamed:@"DashBoardTableViewCell" owner:nil options:nil]firstObject];
        }
        NSDictionary *tmp = [itemDict objectForKey:sectionArr[indexPath.section]];
        NSDictionary *item = [tmp valueForKey:tmp.allKeys[indexPath.row]];
        if (indexPath.row==0) {
            cell1.itemLabel.text = [item valueForKey:@"toolData"];
            [cell1 configUI:indexPath type:2 unit:xNum day:dayarray week:weekarray month:montharray];
        }else{
          
        }
        
        cell = cell1;
        
        
    }else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = contacts[indexPath.row];
        cell.detailTextLabel.text = @"xuhuan@163.com";
    }else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if ([self.id isEqualToString:@"電気使用量"]) {
            cell.textLabel.text = @"電気使用量正常";
        }else if ([self.id isEqualToString:@"照度"]){
            cell.textLabel.text = @"照度正常";
        }else if ([self.id isEqualToString:@"マット"]){
            cell.textLabel.text = @"マット正常";
        }else if ([self.id isEqualToString:@"ドア"]){
            cell.textLabel.text = @"ドア回数正常";
        }
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int m ;
    if (indexPath.section==0) {
        m = 170;
    }else if (indexPath.section ==1){
        m = 60;
    }else if(indexPath.section ==2){
        m = 60;
    }
    return m;
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
