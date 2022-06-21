//
//  ViewController.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "ViewController.h"
@import ParticleNetworkBase;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ChainName *chainName = ParticleNetwork.getChainName;
    NSString *nameString = chainName.nameString;
    Name name = chainName.name;
    NSString *network = chainName.network;
    NSLog(@"%@, %@", nameString, network);
    
    
}


@end
