//
//  ViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "ViewController.h"
#import "LeafNotification.h"
#import "AppDelegate.h"
@interface ViewController ()<UITextFieldDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *userID;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSString *type= [[NSUserDefaults standardUserDefaults]valueForKey:@"type"];
    if ([type isEqualToString:@"logout"]) {
        _passWord.text = @"";
        //return;
    }else{
        [self performSegueWithIdentifier:@"gotomain" sender:self];
    }

}
- (IBAction)loginAction:(id)sender {
    if ([_userID.text isEqual:@""]) {
        [LeafNotification showInController:self withText:@"ユーザーIDを入力してください"];
        return;
    }
    if ([_passWord.text isEqual:@""]) {
        [LeafNotification showInController:self withText:@"パスワードを入力してください"];
        return;
    }
    if ([_userID.text isEqual:@"123"] || [_passWord.text isEqual:@"123"]) {
        
        [self performSegueWithIdentifier:@"gotomain" sender:self];
    }else {
        [LeafNotification showInController:self withText:@"ユーザーID or パスワードエラー"];
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if (type ==1) {
//        [self performSegueWithIdentifier:@"gotomain" sender:self];
//    }
//    
//    
//}

@end
