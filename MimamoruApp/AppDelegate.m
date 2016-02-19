//
//  AppDelegate.m
//  MimamoruApp
//
//  Created by totyu3 on 16/1/7.
//  Copyright © 2016年 totyu3. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate
@synthesize latitude,longitude,span,type;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:161.0/255.0 green:199.0/255.0 blue:166.0/255.0 alpha:1]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
                      
//    BOOL islogin;
//    NSString *typea = [[NSUserDefaults standardUserDefaults]valueForKey:@"types"];
//    if ([typea isEqualToString:@"logout"]) {
//        islogin = NO;
//    }else{
//        islogin = YES;
//    }
//    NSString *segueId = islogin ? @"tablebar" : @"login";
//    
//    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:segueId];
    
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 50.0f;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
   
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currLocation = [locations lastObject];
    latitude = [NSString stringWithFormat:@"%3.6f",currLocation.coordinate.latitude];
    longitude = [NSString stringWithFormat:@"%3.6f",currLocation.coordinate.longitude];
    
}

@end
