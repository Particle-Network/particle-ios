//
//  AppDelegate.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "AppDelegate.h"

@import ParticleNetworkBase;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // init ParticleNetwork
    ChainName *chainName = [ChainName ethereum:EthereumNetworkKovan];
    DevEnvironment devEnv = DevEnvironmentDebug;
    ParticleNetworkConfiguration *config = [[ParticleNetworkConfiguration alloc] initWithChainName:chainName devEnv:devEnv];
    [ParticleNetwork initializeWithConfig:config];
    
    UIViewController *rootVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _window.rootViewController = rootVC;
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
