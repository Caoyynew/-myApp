//
//  AddTableViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/18.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "AddTableViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "LeafNotification.h"
@interface AddTableViewController ()<CNContactPickerDelegate,UITextFieldDelegate>
{
    NSString *name;
    NSString *email;
    NSMutableArray *root;
}
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *eamilText;

@end

@implementation AddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];

}
- (IBAction)saveAction:(id)sender {
    
    name = self.nameText.text;
    email = self.eamilText.text;
    if (![self.nameText.text isEqualToString:@""] && ![self.eamilText.text isEqualToString:@""]) {
        NSMutableDictionary *contact = [[NSMutableDictionary alloc]init];
        [contact setValue:name forKey:@"name"];
        [contact setValue:email forKey:@"email"];
        NSArray *contArr = [[NSUserDefaults standardUserDefaults]valueForKey:@"content"];
        if (!contArr) {
            root = [[NSMutableArray alloc]init];
        }else{
            root = [[NSMutableArray alloc]initWithArray:contArr];
        }
        [root addObject:contact];
        [[NSUserDefaults standardUserDefaults]setObject:root forKey:@"content"];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{
        [LeafNotification showInController:self withText:@"fix your name and email"];
        return;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addFromIphone:(id)sender {
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

#pragma mark - iphone add content
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    self.nameText.text =[NSString stringWithFormat:@"%@ %@",contact.familyName,contact.givenName];
     self.eamilText.text = [NSString stringWithFormat:@"%@",[contact.emailAddresses firstObject].value];
    
    NSMutableDictionary *addContent = [[NSMutableDictionary alloc]init];
    [addContent setValue:name forKey:@"name"];
    [addContent setValue:email forKey:@"email"];
    
//    [contentArr addObject:addContent];
//    NSLog(@"the arr is:%@",contentArr);
//    [self.tableview reloadData];
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
