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
    
    [solana setObject:@[@(SolanaNetworkMainnet), @(SolanaNetworkTestnet), @(SolanaNetworkDevnet)] forKey:@(NameSolana)];
    [ethereum setObject:@[@(EthereumNetworkMainnet), @(EthereumNetworkKovan)] forKey:@(NameEthereum)];
    [bsc setObject:@[@(BscNetworkMainnet), @(BscNetworkTestnet)] forKey:@(NameBsc)];
    [polygon setObject:@[@(PolygonNetworkMainnet), @(PolygonNetworkTestnet)] forKey:@(NamePolygon)];
    
    [avalanche setObject:@[@(AvalancheNetworkMainnet), @(AvalancheNetworkTestnet)] forKey:@(NameAvalanche)];
    [fantom setObject:@[@(FantomNetworkMainnet), @(FantomNetworkTestnet)] forKey:@(NameFantom)];
    [arbitrum setObject:@[@(ArbitrumNetworkMainnet), @(ArbitrumNetworkTestnet)] forKey:@(NameArbitrum)];
    [moonBeam setObject:@[@(MoonBeamNetworkMainnet), @(MoonBeamNetworkTestnet)] forKey:@(NameMoonBeam)];
    
    [moonRiver setObject:@[@(MoonRiverNetworkMainnet), @(MoonRiverNetworkTestnet)] forKey:@(NameMoonRiver)];
    [heco setObject:@[@(HecoNetworkMainnet), @(HecoNetworkTestnet)] forKey:@(NameHeco)];
    [aurora setObject:@[@(AuroraNetworkMainnet), @(AuroraNetworkTestnet)] forKey:@(NameAurora)];
    [harmony setObject:@[@(HarmonyNetworkMainnet), @(HarmonyNetworkTestnet)] forKey:@(NameHarmony)];
    
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
    return dict.allValues.count;
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
    
}

@end
