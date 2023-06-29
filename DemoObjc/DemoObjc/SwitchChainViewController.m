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
    NSMutableDictionary *kcc = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *platon = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *optimism = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *tron = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *okc = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *thunderCore = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *cronos = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *oasisEmerald = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *gnosis = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *celo = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *klaytn = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *scroll = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *zkSync = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *metis = [[NSMutableDictionary alloc] init];
    
    [solana setObject:@[@"mainnet", @"testnet", @"devnet"] forKey:@"solana"];
    [ethereum setObject:@[@"mainnet", @"goerli"] forKey:@"ethereum"];
    [bsc setObject:@[@"mainnet", @"testnet"] forKey:@"bsc"];
    [polygon setObject:@[@"mainnet", @"mumbai"] forKey:@"polygon"];
    
    [avalanche setObject:@[@"mainnet", @"testnet"] forKey:@"avalanche"];
    [fantom setObject:@[@"mainnet", @"testnet"] forKey:@"fantom"];
    [arbitrum setObject:@[@"one", @"nova", @"goerli"] forKey:@"arbitrum"];
    [moonBeam setObject:@[@"mainnet", @"testnet"] forKey:@"moonbeam"];
    
    [moonRiver setObject:@[@"mainnet", @"testnet"] forKey:@"moonriver"];
    [heco setObject:@[@"mainnet", @"testnet"] forKey:@"heco"];
    [aurora setObject:@[@"mainnet", @"testnet"] forKey:@"aurora"];
    [harmony setObject:@[@"mainnet", @"testnet"] forKey:@"harmony"];
    
    [kcc setObject:@[@"mainnet", @"testnet"] forKey:@"kcc"];
    [platon setObject:@[@"mainnet", @"testnet"] forKey:@"platon"];
    [optimism setObject:@[@"mainnet", @"goerli"] forKey:@"optimism"];
    [tron setObject:@[@"mainnet", @"shasta", @"nile"] forKey:@"tron"];
    
    [okc setObject:@[@"mainnet", @"testnet"] forKey:@"okc"];
    [thunderCore setObject:@[@"mainnet", @"testnet"] forKey:@"thunderCore"];
    [cronos setObject:@[@"mainnet", @"testnet"] forKey:@"cronos"];
    [oasisEmerald setObject:@[@"mainnet", @"testnet"] forKey:@"oasisEmerald"];
    [gnosis setObject:@[@"mainnet", @"testnet"] forKey:@"gnosis"];
    [celo setObject:@[@"mainnet", @"testnet"] forKey:@"celo"];
    [klaytn setObject:@[@"mainnet", @"testnet"] forKey:@"klaytn"];
    [scroll setObject:@[@"testnetL1", @"testnetL2"] forKey:@"scroll"];
    [zkSync setObject:@[@"mainnet", @"testnet"] forKey:@"zkSync"];
    [metis setObject:@[@"mainnet", @"goerli"] forKey:@"metis"];
    
    [self.data addObjectsFromArray:@[solana, ethereum, bsc, polygon, avalanche, fantom, arbitrum, moonBeam, moonRiver, heco, aurora, harmony, kcc, platon, optimism, tron]];
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
    NSString *network = [array[indexPath.row] lowercaseString];
    NSString *name = [[[dict allKeys] firstObject] lowercaseString];
    
    NSLog(@"%@, %@", name, network);
    ChainInfo *chainInfo;
    if ([name  isEqual: @"solana"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo solana:SolanaNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo solana:SolanaNetworkTestnet];
        } else if ([network  isEqual: @"devnet"]) {
            chainInfo = [ChainInfo solana:SolanaNetworkDevnet];
        }
    } else if ([name  isEqual: @"ethereum"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo ethereum:EthereumNetworkMainnet];
        } else if ([network  isEqual: @"goerli"]) {
            chainInfo = [ChainInfo ethereum:EthereumNetworkGoerli];
        }
    } else if ([name  isEqual: @"bsc"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo bsc:BscNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo bsc:BscNetworkTestnet];
        }
    } else if ([name  isEqual: @"polygon"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo polygon:PolygonNetworkMainnet];
        } else if ([network  isEqual: @"mumbai"]) {
            chainInfo = [ChainInfo polygon:PolygonNetworkMumbai];
        }
    } else if ([name  isEqual: @"avalanche"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo avalanche:AvalancheNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo avalanche:AvalancheNetworkTestnet];
        }
    } else if ([name  isEqual: @"fantom"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo fantom:FantomNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo fantom:FantomNetworkTestnet];
        }
    } else if ([name  isEqual: @"arbitrum"]) {
        if ([network  isEqual: @"one"]) {
            chainInfo = [ChainInfo arbitrum:ArbitrumNetworkOne];
        } else if ([network  isEqual: @"nova"]) {
            chainInfo = [ChainInfo arbitrum:ArbitrumNetworkNova];
        } else if ([network  isEqual: @"goerli"]) {
            chainInfo = [ChainInfo arbitrum:ArbitrumNetworkGoerli];
        }
    } else if ([name  isEqual: @"moonbeam"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo moonbeam:MoonbeamNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo moonbeam:MoonbeamNetworkTestnet];
        }
    } else if ([name  isEqual: @"moonriver"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo moonriver:MoonriverNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo moonriver:MoonriverNetworkTestnet];
        }
    } else if ([name  isEqual: @"heco"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo heco:HecoNetworkMainnet];
        }
    } else if ([name  isEqual: @"aurora"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo aurora:AuroraNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo aurora:AuroraNetworkTestnet];
        }
    } else if ([name  isEqual: @"harmony"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo harmony:HarmonyNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo harmony:HarmonyNetworkTestnet];
        }
    } else if ([name  isEqual: @"platon"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo platON:PlatONNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo platON:PlatONNetworkTestnet];
        }
    } else if ([name  isEqual: @"kcc"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo kcc:KccNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo kcc:KccNetworkTestnet];
        }
    } else if ([name  isEqual: @"optimism"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo optimism:OptimismNetworkMainnet];
        } else if ([network  isEqual: @"goerli"]) {
            chainInfo = [ChainInfo optimism:OptimismNetworkGoerli];
        }
    } else if ([name  isEqual:@"tron"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo tron:TronNetworkMainnet];
        } else if ([network  isEqual: @"shasta"]) {
            chainInfo = [ChainInfo tron:TronNetworkShasta];
        } else if ([network  isEqual: @"nile"]) {
            chainInfo = [ChainInfo tron:TronNetworkNile];
        }
    } else if ([name  isEqual: @"okc"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo okc:OKCNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo okc:OKCNetworkTestnet];
        }
    } else if ([name  isEqual: @"thunderCore"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo thunderCore:ThunderCoreNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo thunderCore:ThunderCoreNetworkTestnet];
        }
    } else if ([name  isEqual: @"cronos"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo cronos:CronosNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo cronos:CronosNetworkTestnet];
        }
    } else if ([name  isEqual: @"oasisEmerald"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo oasisEmerald:OasisEmeraldNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo oasisEmerald:OasisEmeraldNetworkTestnet];
        }
    } else if ([name  isEqual: @"gnosis"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo gnosis:GnosisNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo gnosis:GnosisNetworkTestnet];
        }
    } else if ([name  isEqual: @"celo"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo celo:CeloNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo celo:CeloNetworkTestnet];
        }
    } else if ([name  isEqual: @"klaytn"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo klaytn:KlaytnNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo klaytn:KlaytnNetworkTestnet];
        }
    } else if ([name  isEqual: @"scroll"]) {
        if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo scroll:ScrollNetworkTestnet];
        }
    } else if ([name  isEqual: @"zkSync"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo zkSync:ZkSyncNetworkMainnet];
        } else if ([network  isEqual: @"testnet"]) {
            chainInfo = [ChainInfo zkSync:ZkSyncNetworkTestnet];
        }
    } else if ([name  isEqual: @"metis"]) {
        if ([network  isEqual: @"mainnet"]) {
            chainInfo = [ChainInfo metis:MetisNetworkMainnet];
        } else if ([network  isEqual: @"goerli"]) {
            chainInfo = [ChainInfo metis:MetisNetworkGoerli];
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
