//
//  DetailTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/13.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DetailTableViewCell.h"

@interface DetailTableViewController ()
{
    int xNum;//0:1~24時 1:1~7日 2:１〜３０日 　3:１〜１２月
    NSArray *dayarray;
    NSArray *dayarray2;


    NSMutableArray * contactsArr; //联系人
   
}

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *clear = [[UIView alloc]init];
    clear.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:clear];
    contactsArr = [[NSMutableArray alloc]init];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailcell"];
    [self getPlistWithName:@"testdata1"];
    [self getPlistWithName:@"testdata2"];
}


-(void)getPlistWithName:(NSString*)name{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:name ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    if ([name isEqualToString:@"testdata1"]) {
        dayarray =[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
        
    }else if([name isEqualToString:@"testdata2"]){
        dayarray2=[[NSArray alloc]initWithArray:[dict objectForKey:@"day"]];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if (indexPath.section == 0 ) {
        
        DetailTableViewCell* cell1 = [tableView dequeueReusableCellWithIdentifier:@"detailcell" forIndexPath:indexPath];
        cell1.selectionStyle = UITableViewCellEditingStyleNone;
        [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:nil options:nil]firstObject];
        if ([self.titlename isEqualToString:@"電気使用量"]) {
            [cell1 configUI:indexPath type:1 day:dayarray];
        }else{
            [cell1 configUI:indexPath type:2 day:dayarray2];
        }
        cell = cell1;
    }
    if (indexPath.section ==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.textLabel.text = @"山田";
        cell.detailTextLabel.text = @"mytell@163.com";
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:18];
    label.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    label.textColor = [UIColor colorWithRed:0.257 green:0.650 blue:0.478 alpha:1.000];
    //对齐方式
    label.textAlignment = NSTextAlignmentLeft;
    if (section ==0) {
        label.text = [NSString stringWithFormat:@"◆今日%@",self.titlename];
    }else if (section == 1){
        label.text = @"◆通知先";
    }
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    if (indexPath.section == 0) {
        height = 180;
    }else{
        height = 60;
    }
    return height;
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
