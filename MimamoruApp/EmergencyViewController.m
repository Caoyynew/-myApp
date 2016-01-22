//
//  EmergencyViewController.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "EmergencyViewController.h"
#import "ABFillButton.h"
#import "LeafNotification.h"
#import <MailCore/MailCore.h>
#import "AppDelegate.h"
@interface EmergencyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ABFillButtonDelegate>
{
    NSMutableArray *_currentArray;
    NSMutableDictionary *_contactDict;
    NSString *userEmail;
    NSString *password;
    NSString *hostname;
    int port;
    
    NSString *message;
    NSString *latitude;
    NSString *longitude;
    
    int flag;
}
@property (weak, nonatomic) IBOutlet ABFillButton *button;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation EmergencyViewController


-(void)viewDidLoad
{

    _button.delegate = self;
    [_button setFillPercent:1.0];
    [_button configureButtonWithHightlightedShadowAndZoom:YES];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    
    UIView *clear = [[UIView alloc]init];
    clear.backgroundColor = [UIColor clearColor];
    [self.tableview setTableFooterView:clear];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self reloadContact];
    [self settingEmail];
    [_button setEmptyButtonPressing:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)reloadContact{
    [_currentArray removeAllObjects];
    NSArray *arr = [[NSUserDefaults standardUserDefaults]valueForKey:@"content"];
    if (!arr) {
        [LeafNotification showInController:self withText:@"連絡人を追加してください"];
        return;
    }
    if (!arr) {
        _currentArray = [[NSMutableArray alloc]init];
    }else{
        _currentArray = [[NSMutableArray alloc]initWithArray:arr];
    }

    [_tableview reloadData];
}

-(void)settingEmail{
//    NSDictionary *temp = [[NSUserDefaults standardUserDefaults]objectForKey:@"userprofile"];
//    if (!temp) {
//        [LeafNotification showInController:self withText:@"自分のメールを設定してください"];
//        return;
//    }
    userEmail = @"yyl17173@163.com";
    password = @"581076";
    hostname = @"smtp.163.com";
    port = 465;
    //check email setting
//    if (userEmail ==nil ||[userEmail isEqualToString:@""]) {
//        [LeafNotification showInController:self withText:@"メールアドレス未設定"];
//        return;
//    }
//    if (password ==nil ||[password isEqualToString:@""]) {
//        [LeafNotification showInController:self withText:@"パスワード未設定"];
//        return;
//    }
//    if (hostname ==nil ||[hostname isEqualToString:@""]) {
//        [LeafNotification showInController:self withText:@"ホスト未設定"];
//        return;
//    }
//    if (!port) {
//        [LeafNotification showInController:self withText:@"サーバポート未設定"];
//        return;
//    }
    NSLog(@"useremail:%@ password:%@ hostname:%@ port:%d",userEmail,password,hostname,port);
}

-(void)sendEmail:(NSString*)mes{
    if (userEmail ==nil ||[userEmail isEqualToString:@""]) {
        [LeafNotification showInController:self withText:@"メールアドレス未設定"];
        return;
    }
    if (password ==nil ||[password isEqualToString:@""]) {
        [LeafNotification showInController:self withText:@"パスワード未設定"];
        return;
    }
    if (hostname ==nil ||[hostname isEqualToString:@""]) {
        [LeafNotification showInController:self withText:@"ホスト未設定"];
        return;
    }
    if (!port) {
        [LeafNotification showInController:self withText:@"サーバポート未設定"];
        return;
    }
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    latitude = myDelegate.latitude;
    longitude = myDelegate.longitude;

    MCOSMTPSession *session = [[MCOSMTPSession alloc]init];
    [session setHostname:hostname];
    [session setPort:port];
    [session setUsername:userEmail];
    [session setPassword:password];
    [session setConnectionType:MCOConnectionTypeTLS];

    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc]init];
    [[builder header]setFrom:[MCOAddress addressWithDisplayName:nil mailbox:userEmail]];
    //宛先
    NSMutableArray *to = [[NSMutableArray alloc]init];
    for (int i = 0; i<_currentArray.count; i++) {
        NSDictionary *toDict = [_currentArray objectAtIndex:i];
        NSString *toAddress = [toDict valueForKey:@"email"];
        MCOAddress *newAddress = [MCOAddress addressWithMailbox:toAddress];
        [to addObject:newAddress];
    }
    //测试数据
    NSString *tEmail = @"m18506823136@163.com";
    MCOAddress *tAdress = [MCOAddress addressWithMailbox:tEmail];
    NSMutableArray *tArr = [[NSMutableArray alloc]init];
    [tArr addObject:tAdress];
    [[builder header]setTo:tArr];
  //  [[builder header]setTo:to];

    //メールのタイトル
    [[builder header]setSubject:@"!!「見守りアプリ」の緊急通報メールです"];
    //メールの本体
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.loco.yahoo.co.jp/maps?lat=%@&%@&ei=utf-8&v=2&sc=3&datum=wgs&gov=13108.30#",latitude,longitude];
    [builder setTextBody:[NSString stringWithFormat:@"▼メッセージ:\n \n%@ \n \n▼送信者の位置情報はこちらで確認できる⇨\n　%@\n\n *.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.\n◎＜見守りアプリ＞で緊急ボタンが押されてメール送信しました。\n \n＊このメールには返信しないでください。\n\n＊このメールに覚えがない場合は、お手数ですが削除してください。",mes,urlStr]];

    //send mail
    NSData *rfc822Data=[builder data];
    MCOSMTPSendOperation *sendOperation = [session sendOperationWithData:rfc822Data];
    [sendOperation start:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sending email:%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [LeafNotification showInController:self withText:@"メール送信が失敗しました！"];

            });
        }else{
            NSLog(@"Successfully send email!");
//            static dispatch_once_t onceToken;
//            dispatch_once(&onceToken, ^{
//                
//            });
            dispatch_async(dispatch_get_main_queue(), ^{

                    [_button setEmptyButtonPressing:NO]; //设定id 判断是否进行第二次出发
                    [self pushview];

            });
            
            
        }
    }];

}
//换面跳转的方法
-(void)pushview{
    
    [self performSegueWithIdentifier:@"gotodetail" sender:self];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell3" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell3"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *cont = _currentArray[indexPath.row];
    cell.textLabel.text = [cont valueForKey:@"name"];
    cell.detailTextLabel.text = [cont valueForKey:@"email"];
    return cell;
}



#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btnAction:(id)sender {
    
    [_button setFillPercent:1.0];
    
}

-(void)buttonIsEmpty:(ABFillButton *)button{
    NSLog(@"button is pressedd");

    NSMutableDictionary *myInfo;
    NSDictionary *myDict = [[NSUserDefaults standardUserDefaults]valueForKey:@"personal"];
    if (myDict==nil) {
        myInfo = [[NSMutableDictionary alloc]init];
        [LeafNotification showInController:self withText:@"個人情報を入力してください" type:LeafNotificationTypeSuccess];
        return;
    }else{
        myInfo = [[NSMutableDictionary alloc]initWithDictionary:myDict];
    }
    NSString *name = [myInfo valueForKey:@"name"];
    NSString * sex = [myInfo valueForKey:@"sex"];
    NSString * birday = [myInfo valueForKey:@"birthday"];
    NSString *adress = [myInfo valueForKey:@"adress"];
    NSString *doctor = [myInfo valueForKey:@"doctor"];
    NSString *kusili = [myInfo valueForKey:@"kusili"];
    NSString *health = [myInfo valueForKey:@"health"];
    NSString *otherthing = [myInfo valueForKey:@"other"];
    NSString *contentFirst = [myInfo valueForKey:@"contentfirst"];
    message = [NSString stringWithFormat:@"   氏名：%@\n   性别：%@ \n   誕生日：%@\n   現住所：%@\n   かかりつけ医：%@\n   服薬情報：%@\n   健康診断結果情報：%@\n   その他お願い事項：%@\n   緊急通報メール宛先：%@\n",name,sex,birday,adress,doctor,kusili,health,otherthing,contentFirst];
    
   
    

        [self sendEmail:message];

}


@end

