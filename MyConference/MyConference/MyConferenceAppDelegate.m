//
//  MyConferenceAppDelegate.m
//  MyConference
//
//  Created by Pedro Morgado on 07/02/14.
//  Copyright (c) 2014 MyConference. All rights reserved.
//

#import "MyConferenceAppDelegate.h"

@implementation MyConferenceAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Save application ID for Heroku Dev
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"application_id_heroku_dev"] == NULL){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"0bbee9ee-3956-4651-ac44-0f3b1935198a" forKey:@"application_id_heroku_dev"];
        [ud synchronize];
    }
    NSLog(@"APPLICATION ID: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"application_id_heroku_dev"]);
    
    //Generate UUID if not exits
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"] == NULL){
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        NSString *deviceID = (NSString *) CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:deviceID forKey:@"device_id"];
        [ud synchronize];
    }
    NSLog(@"DEVICE ID: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"device_id"]);
    
    //Log tokens
    NSLog(@"ACCESS TOKEN: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]);
    NSLog(@"ACCESS TOKEN EXPIRES: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token_expires"]);
    NSLog(@"REFRESH TOKEN: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token"]);
    NSLog(@"REFRESH TOKEN EXPIRES: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_token_expires"]);
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
