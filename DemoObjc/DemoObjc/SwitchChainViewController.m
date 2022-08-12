//
//  SwitchChainViewController.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "SwitchChainViewController.h"

@import ParticleNetworkBase;

@interface SwitchChainViewController()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation SwitchChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureData];
    [self configureTableView];
}

- (void)configureData {
    self.data = [[NSMutableArray alloc] init];
    NSMutableDictionary *solana = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *ethereum = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bsc = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *polygon = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *avalanche = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *fantom = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arbitrum = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *moonBeam = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *moonRiver = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *heco = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *aurora = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *harmony = [[NSMutableDictionary alloc] init];
    
    [solana setObject:@[@"mainnet", @"testnet", @"devnet"] forKey:@"Solana"];
    [ethereum setObject:@[@"mainnet", @"kovan"] forKey:@"Ethereum"];
    [bsc setObject:@[@"mainnet", @"testnet"] forKey:@"Bsc"];
    [polygon setObject:@[@"mainnet", @"testnet"] forKey:@"Polygon"];
    
    [avalanche setObject:@[@"mainnet", @"testnet"] forKey:@"Avalanche"];
    [fantom setObject:@[@"mainnet", @"testnet"] forKey:@"Fantom"];
    [arbitrum setObject:@[@"mainnet", @"testnet"] forKey:@"Arbitrum"];
    [moonBeam setObject:@[@"mainnet", @"testnet"] forKey:@"MoonBeam"];
    
    [moonRiver setObject:@[@"mainnet", @"testnet"] forKey:@"MoonRiver"];
    [heco setObject:@[@"mainnet", @"testnet"] forKey:@"Heco"];
    [aurora setObject:@[@"mainnet", @"testnet"] forKey:@"Aurora"];
    [harmony setObject:@[@"mainnet", @"testnet"] forKey:@"Harmony"];
    
    [self.data addObjectsFromArray:@[solana, ethereum, bsc, polygon, avalanche, fantom, arbitrum, moonBeam, moonRiver, heco, aurora, harmony]];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *dict = self.data[section];
    NSArray *array = dict.allValues.firstObject;
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dict = self.data[indexPath.section];
    NSArray *array = [[dict allValues] firstObject];
    NSString *network = array[indexPath.row];
    cell.textLabel.text = network;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableDictionary *dict = self.data[section];
    return [[dict allKeys] firstObject];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dict = self.data[indexPath.section];
    NSArray *array = [[dict allValues] firstObject];
    NSString *network = array[indexPath.row];
    NSString *name = [[dict allKeys] firstObject];
    
    NSLog(@"%@, %@", name, network);
    ChainInfo *chainInfo;
    if ([name  isEqual: @"Solana"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo solana:SolanaNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo solana:SolanaNetworkTestnet];
        } else if ([network  isEqual: @"devnet"]) {
            chainInfo = [ChainInfo solana:SolanaNetworkDevnet];
        }
    } else if ([name  isEqual: @"Ethereum"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo ethereum:EthereumNetworkMainnet];
        } else if ([network  isEqual: @"kovan"]) {
            chainInfo = [ChainInfo ethereum:EthereumNetworkKovan];
        }
    } else if ([name  isEqual: @"Bsc"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo bsc:BscNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo bsc:BscNetworkTestnet];
        }
    } else if ([name  isEqual: @"Polygon"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo polygon:PolygonNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo polygon:PolygonNetworkMumbai];
        }
    } else if ([name  isEqual: @"Avalanche"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo avalanche:AvalancheNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo avalanche:AvalancheNetworkTestnet];
        }
    } else if ([name  isEqual: @"Fantom"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo fantom:FantomNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo fantom:FantomNetworkTestnet];
        }
    } else if ([name  isEqual: @"Arbitrum"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo arbitrum:ArbitrumNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo arbitrum:ArbitrumNetworkTestnet];
        }
    } else if ([name  isEqual: @"MoonBeam"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo moonbeam:MoonbeamNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo moonbeam:MoonbeamNetworkTestnet];
        }
    } else if ([name  isEqual: @"MoonRiver"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo moonriver:MoonriverNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo moonriver:MoonriverNetworkTestnet];
        }
    } else if ([name  isEqual: @"Heco"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo heco:HecoNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo heco:HecoNetworkTestnet];
        }
    } else if ([name  isEqual: @"Aurora"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo aurora:AuroraNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo aurora:AuroraNetworkTestnet];
        }
    } else if ([name  isEqual: @"Harmony"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo harmony:HarmonyNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo harmony:HarmonyNetworkTestnet];
        }
    }
    [ParticleNetwork setChainInfo:chainInfo];
    
    NSString *message = [NSString stringWithFormat:@"current network is %@ - %@", name, network];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Switch network" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.selectHandler();
        [self dismissViewControllerAnimated:true completion:false];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([SwitchChainViewController class]));
}
@end
