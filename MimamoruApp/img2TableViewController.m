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
#import "imgg2TableViewCell.h"
@interface img2TableViewController ()
{
    imgg1TableViewCell*cell2;
    imgg2TableViewCell*cell3;
    
    
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
    
    NSMutableArray *img1Arr;
    NSMutableArray *img2Arr;
    
    NSArray*fff;
    NSArray*ggg;
    
    NSMutableDictionary *itemDict;
    
    int graphtype;

}
@property (strong, nonatomic) IBOutlet UILabel *title2;
@property (strong, nonatomic) IBOutlet UITableView *img2tableciew;
@property (weak, nonatomic) IBOutlet UITableView *imgg1TableView;
@property (weak, nonatomic) IBOutlet UITableView *imgg2TableView;

@end

@implementation img2TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _title2.text = _tempname;
    [self.img2tableciew registerNib:[UINib nibWithNibName:@"img2TableViewCell" bundle:nil] forCellReuseIdentifier:@"dashboardCell2"];
    xNum = 0;
    //Get test data from plist files

    [self getPlistWithName:@"testdata1"];
    [self getPlistWithName:@"testdata2"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self getTaisetsuPeople];
    [self getList1];
    [self getServiceItem];
    [_imgg1TableView reloadData];
    NSLog(@"%@",_tempname);
   // [_imgg2TableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)getList1{
    NSMutableDictionary*machineuse4=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"machineuse"]];
    NSArray* allkey2 =[[NSArray alloc]initWithArray: [machineuse4 allKeys]];
    img1Arr = [[NSMutableArray alloc]init];
    img2Arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<allkey2.count; i++) {
        NSArray *array = [allkey2[i] componentsSeparatedByString:@":"];
        if([array[0]isEqualToString:_tempname]&&[array[1]isEqualToString:_username]){
            NSDictionary *tempDict = [[NSDictionary alloc]initWithDictionary: [machineuse4 objectForKey:allkey2[i]]];
            NSDictionary *tempDict2 =[[NSDictionary alloc]initWithDictionary: [tempDict objectForKey:@"exceptionemail"]];
            NSArray* allkey3 = [tempDict2 allKeys];
            for (int i = 0; i<allkey3.count; i++) {
                NSDictionary *tempDict4 = [tempDict2 objectForKey:allkey3[i]];
                [img1Arr addObject:tempDict4];
            }
            fff = [[NSArray alloc]initWithArray:[tempDict valueForKey:@"setayi1"]];
            ggg = [[NSArray alloc]initWithArray:[tempDict valueForKey:@"setayi2"]];
            if (![fff[0]isEqualToString:@"-"]&&![fff[1]isEqualToString:@"-"]) {
                [img2Arr addObject:fff];
            }
            if (![ggg[0]isEqualToString:@"-"]&&![ggg[1]isEqualToString:@"-"]) {
                [img2Arr addObject:ggg];
            }
        }
    }
}

-(void)getTaisetsuPeople{
    if (!sectionArr) {
        sectionArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    [sectionArr removeAllObjects];
    [itemDict removeAllObjects];
    NSString * t1 = _tempname;

    [sectionArr addObject:t1];

}

-(void)getServiceItem{
    NSDictionary *tmp = [[NSUserDefaults standardUserDefaults]objectForKey:@"anybody"];
    if (tmp) {
        itemDict = [[NSMutableDictionary alloc]initWithDictionary:tmp];
        //NSLog(@"itemdict-> %@",itemDict);
    }
    [self.img2tableciew reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _img2tableciew) {
        return sectionArr.count;
    }else if (tableView == _imgg1TableView){
        return 1;
    }else{
        return 1;
    }
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//    return 1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (tableView == _img2tableciew) {
        
        img2TableViewCell *cell = [_img2tableciew dequeueReusableCellWithIdentifier:@"dashboardCell2"];
        if (cell ==nil) {
            [[[NSBundle mainBundle]loadNibNamed:@"img2TableViewCell" owner:nil options:nil]firstObject];
        }
        cell.ppp = _tempname;
        if ([_tempname isEqualToString:@"電気使用量"]) {
            [cell configUI:indexPath type:2 unit:xNum day:dayarray week:weekarray month:montharray];
            
        }else{
            [cell configUI:indexPath type:2 unit:xNum day:dayarray2 week:weekarray2 month:montharray2];
        }
        return cell;
    }else if (tableView == _imgg1TableView){
        
        cell2 = [_imgg1TableView dequeueReusableCellWithIdentifier:@"imgg1Cell" forIndexPath:indexPath];
        cell2.tutiName.text = @"すが";
        cell2.tutiEmail.text = @"kokawad@163.com";
        return cell2;
    }else{
        cell3 = [_imgg2TableView dequeueReusableCellWithIdentifier:@"imgg2Cell" forIndexPath:indexPath];
        NSMutableArray * ss = [[NSMutableArray alloc]initWithObjects:@"2",@"使用なし", nil];
        
        cell3.hours.text = [NSString stringWithFormat:@"%@h",ss[0]];
        
        cell3.hoursType.text = ss[1];
        
        
        return cell3;
    }
}









@end
