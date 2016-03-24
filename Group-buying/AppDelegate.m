//
//  AppDelegate.m
//  Group-buying
//
//  Created by 叶杨杨 on 15/5/19.
//  Copyright (c) 2015年 叶杨杨. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*! @brief WXApi的成员函数，向微信终端程序注册第三方应用。
     *
     * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
     * @see registerApp
     * @param appid 微信开发者ID
     * @param appdesc 应用附加信息，长度不超过1024字节
     * @return 成功返回YES，失败返回NO。
     */

    //向微信注册
    
    [WXApi registerApp:@"wx1e3a88220215b0fa" withDescription:@"SHARE_WX"];
    
    
    /*
     NSUserDefaults类为和默认的系统进行交互提供了一个系统编程接口。默认的系统允许一个应用来定制它的行为以适应用户的喜好。例如，你可以允许用户去决定你的应用程序显示什么样的计量单位或者文件多少时间自动保存。应用程序在用户默认的数据库里分配记录的参数值。这些参数被作为默认值，因为他们通常用于确定一个用用程序在启动时的默认状态或者默认状态的作用方式。
     
     在运行时，你可以使用NSUserDefaults对象读取你的应用程序的从一个用户默认数据库使用的默认数据
     
     SUserDefaults用于存储数据量小的数据，例如用户配置。并不是所有的东西都能往里放的，只支持：NSString,NSNumber, NSDate, NSArray, NSDictionary，详细方法可以查看类文件。
     
     NSUserDefaultsstandardUserDefaults用来记录一下永久保留的数据非常方便，不需要读写文件，而是保留到一个NSDictionary字典里，由系统保存到文件里，系统会保存到该应用下的/Library/Preferences/gongcheng.plist文件中。需要注意的是如果程序意外退出，NSUserDefaultsstandardUserDefaults数据不会被系统写入到该文件，不过可以使用［[NSUserDefaultsstandardUserDefaults] synchronize］命令直接同步到文件里，来避免数据的丢失。
    
     */
    
    //他是一个单例
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    

    
   // 返回一个和defaultName关联的bool值，如果不存在defaultName的话返回NO
    BOOL isVisibled = [UD boolForKey:@"isVisibled"];
    
    
    //为了保证第一次登录时  显示欢迎界面
    
    if (!isVisibled) {
        
        /*instantiateViewControllerWithIdentifier  调转到故事版中的 欢迎界面那个视图  而且只加载一次 welcomevc
         3>此方法表示通过控制器的identifier获取到此控制器，新版本的Xcode用Storyboard ID来表示某个控制器的identifier
         - (id)instantiateViewControllerWithIdentifier:(NSString *)identifier;
         
        获取Storyboard中单独的控制器了
         */
        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"welcomevc"];
    }
    
//练习
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    BOOL isVisibled = [ud boolForKey:@"isVisibled"];
//    
//    
//    if (!isVisibled) {
//        
//        
//        self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"welcomevc"];
//        
//    }
    
    
       
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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

@end
