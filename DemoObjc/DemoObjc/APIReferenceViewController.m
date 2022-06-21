//
//  APIReferenceViewController.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "APIReferenceViewController.h"

@import ParticleNetworkBase;
@import ParticleAuthService;
@import ParticleWalletAPI;

@interface APIReferenceViewController ()

@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) UIActivityIndicatorView *loading;

@end

@implementation APIReferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mask = [[UIView alloc] initWithFrame:self.view.bounds];
    self.loading = [[UIActivityIndicatorView alloc] init];
    self.loading.transform = CGAffineTransformMakeScale(3, 3);
    self.loading.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:self.mask];
    [self.mask addSubview: self.loading];
    
    self.mask.hidden = YES;
    self.loading.hidden = YES;
}

- (IBAction)signAndSendTransaction {
    switch([ParticleNetwork getChainName].name){
       case NameSolana:
            [self sendTransactionSolana];
          break;
       default :
            [self sendNativeEVM];
            break;
    }
}

- (void)sendTransactionSolana {
    NSString *transaction = @"87PYtzaf2kzTwVq1ckrGzYDEi47ThJTu4ycMth8M3yrAfs7DWWwxFGjWMy8Pr6GAgu21VsJSb8ipKLBguwGFRJPJ6E586MvJcVSo1u6UTYGodUqay8bYmUcb3hq6ezPKnUrAuKyzDoW5WT1R1K62yYR8XTwxttoWdu5Qx3AZL8qa3F7WobW5WDGRT4fS8TsXSxWbVYMfWgdu";
    
    [ParticleAuthService signAndSendTransaction:transaction successHandler:^(NSString * signature) {
        NSLog(@"%@", signature);
        } failureHandler:^(NSError * error) {
            NSLog(@"%@", error);
        }];
}

- (void)sendNativeEVM {
    [self showLoading];
    
    // firstly, make sure current user has some native token for test there methods
    // send 0.0001 native from self to receiver
    // 0.0001 native expressed as a hex string is "0x5AF3107A4000"
    NSString *sender = [ParticleAuthService getAddress];
    NSString *receiver = @"0xAC6d81182998EA5c196a4424EA6AB250C7eb175b";
    NSString *amount = @"0x5AF3107A4000";
    
    [[ParticleWalletAPI getEvmService] createTransactionFrom:sender to:receiver value:amount contractParams: nil type:@"0x2" nonce:@"0x0" gasFeeLevel:GasFeeLevelMedium action:ActionNormal successHandler:^(NSString * transaction) {
        NSLog(@"%@", transaction);
        
        [ParticleAuthService signAndSendTransaction:transaction successHandler:^(NSString * signature) {
            NSLog(@"%@", signature);
            } failureHandler:^(NSError * error) {
                NSLog(@"%@", error);
            }];
        
    } failureHandler:^(NSError * error) {
        NSLog(@"%@", error);
    }];
}


- (void)sendErc20Token {
    [self showLoading];
    
    
    // firstly, make sure current user has some native token and erc20 token for test there methods
    // send 0.0001 erc20 token from self to receiver
    // 0.0001 erc20 token expressed as a hex string is "0x5AF3107A4000", because the token decimals is 18.
    NSString *from = [ParticleAuthService getAddress];
    NSString *to = @"0xa36085F69e2889c224210F603D836748e7dC0088";
    NSString *amount = @"0x5AF3107A4000";
    NSString *contractAddress = @"0xa36085F69e2889c224210F603D836748e7dC0088";
    NSString *receiver = @"0xAC6d81182998EA5c196a4424EA6AB250C7eb175b";
    ContractParams *contractParams = [ContractParams erc20TransferWithContractAddress:contractAddress to:receiver amount:amount];
    
    // because you want to send erc20 token, interact with contact, 'to' should be the contract address.
    // and value could be nil.
    [[ParticleWalletAPI getEvmService] createTransactionFrom:from to:to value:nil contractParams:contractParams type:@"0x2" nonce:@"0x0" gasFeeLevel:GasFeeLevelMedium action:ActionNormal successHandler:^(NSString * transaction) {
            NSLog(@"%@", transaction);
            
            [ParticleAuthService signAndSendTransaction:transaction successHandler:^(NSString * signature) {
                NSLog(@"%@", signature);
                } failureHandler:^(NSError * error) {
                    NSLog(@"%@", error);
                }];
        } failureHandler:^(NSError * error) {
            NSLog(@"%@", error);
        }];
    
}

- (void)showLoading {
    self.mask.hidden = NO;
    [self.loading startAnimating];
}

- (void)hideLoading {
    self.mask.hidden = YES;
    [self.loading stopAnimating];
}
@end
