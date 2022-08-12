//
//  AppDelegate.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "AppDelegate.h"
#import "DemoObjc-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ParticleConnectWrapper initParticleConnect];
    
    UIViewController *rootVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _window.rootViewController = rootVC;
    [_window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [ParticleConnectWrapper handleUrlWithUrl:url];
}

@end
