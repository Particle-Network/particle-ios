//
//  AppDelegate.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "AppDelegate.h"

@import ParticleNetworkBase;
@import ParticleAuthService;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // init ParticleNetwork
    // select a network
    ChainName *chainName = [ChainName ethereum:EthereumNetworkMainnet];
    // and also and you can custom your evm network
//    ChainName *chainName = [ChainName customEvmNetworkWithFullName:@"Ethereum" network:@"kovan" chainId:42 explorePath:@"https://kovan.etherscan.io/" symbol:@"ETH" isSupportEIP1159:YES];
       
//    ChainName *chainName = [ChainName customEvmNetworkWithFullName:@"Ethereum" network:@"rinkeby" chainId:4 explorePath:@"https://rinkeby.etherscan.io/" symbol:@"ETH" isSupportEIP1159:YES];

    DevEnvironment devEnv = DevEnvironmentDebug;
    ParticleNetworkConfiguration *config = [[ParticleNetworkConfiguration alloc] initWithChainName:chainName devEnv:devEnv];
    [ParticleNetwork initializeWithConfig:config];
    
    UIViewController *rootVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _window.rootViewController = rootVC;
    [_window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [ParticleAuthService handleUrl:url];
}

@end
