//
//  MessageViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "MessageViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "LeafNotification.h"
@interface MessageViewController ()<UITableViewDataSource,UITabBarDelegate,CNContactPickerDelegate>
{
    UITableViewCell *cell;
    NSString *name;
    NSString *email;
    NSMutableArray *contentArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MessageViewController

- (IBAction)addAction:(id)sender {
    NSLog(@"click me!");
    CNContactStore *cstore = [[CNContactStore alloc]init];
    [cstore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Granted Permission");
        }else{
            NSLog(@"Denied Permission");
        }
        if (error) {
            NSLog(@"Error");
        }
    }];
    
    CNContactPickerViewController *cvc = [[CNContactPickerViewController alloc]init];
    cvc.displayedPropertyKeys = @[CNContactPhoneNumbersKey,CNContactEmailAddressesKey];
    [cvc setDelegate:self];
    [self presentViewController:cvc animated:YES completion:nil];
    
}
- (IBAction)saveAction:(id)sender {
    
    [LeafNotification showInController:self withText:@"保存完了!" type:LeafNotificationTypeSuccess];
    [[NSUserDefaults standardUserDefaults]setObject:contentArr forKey:@"content"];
    
}

#pragma mark - iphone add content
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    name =[NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
    email = [NSString stringWithFormat:@"%@",[contact.emailAddresses firstObject].value];
    NSMutableDictionary *addContent = [[NSMutableDictionary alloc]init];
    [addContent setValue:name forKey:@"name"];
    [addContent setValue:email forKey:@"email"];
    [contentArr addObject:addContent];
     NSLog(@"the arr is:%@",contentArr);
    [self.tableview reloadData];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!contentArr) {
        NSArray *defArr = [[NSUserDefaults standardUserDefaults]objectForKey:@"content"];
        NSLog(@"arr =%@",defArr);
        if (defArr == nil) {
            contentArr = [[NSMutableArray alloc]init];
        }else{
            contentArr = [[NSMutableArray alloc]initWithArray:defArr];
        }
    }

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tableView dequeueReusableCellWithIdentifier:@"mycell3" forIndexPath:indexPath];
    NSDictionary *cellDict = contentArr[indexPath.row];
    cell.textLabel.text = [cellDict valueForKey:@"name"];
    cell.detailTextLabel.text = [cellDict valueForKey:@"email"];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [contentArr removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:contentArr forKey:@"content"];
    [self.tableview reloadData];
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
