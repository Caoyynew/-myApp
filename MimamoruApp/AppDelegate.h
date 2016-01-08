//
//  AppDelegate.h
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *latitude;
    NSString *longitude;
    NSString *span;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)NSString *latitude;
@property (nonatomic, strong)NSString *longitude;
@property (nonatomic, strong)NSString *span;

@property (nonatomic, strong) NSString * type;
@end

