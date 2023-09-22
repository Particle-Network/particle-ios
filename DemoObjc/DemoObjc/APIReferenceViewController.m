//
//  APIReferenceViewController.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "APIReferenceViewController.h"
#import "NSData+Extensions.h"

@import ParticleNetworkBase;
@import ParticleAuthService;
@import ParticleWalletAPI;
@import ParticleWalletGUI;

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
    Chain *chain = [ParticleNetwork getChainInfo].chain;
    if (chain == [Chain solana]) {
        [self sendTransactionSolana];
    } else {
        // [self sendNativeEVM];
        [self sendErc20Token];
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
    __weak APIReferenceViewController *weakSelf = self;
    
    [[ParticleWalletAPI getEvmService] createTransactionFrom:sender to:receiver value:amount contractParams: nil type:@"0x2" gasFeeLevel:GasFeeLevelMedium action:ActionNormal successHandler:^(NSString * transaction) {
        NSLog(@"%@", transaction);
        
        [ParticleAuthService signAndSendTransaction:transaction successHandler:^(NSString * signature) {
            NSLog(@"%@", signature);
            [weakSelf hideLoading];
            } failureHandler:^(NSError * error) {
                NSLog(@"%@", error);
                [weakSelf hideLoading];
            }];
        
    } failureHandler:^(NSError * error) {
        NSLog(@"%@", error);
        [weakSelf hideLoading];
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
    __weak APIReferenceViewController *weakSelf = self;
    [[ParticleWalletAPI getEvmService] createTransactionFrom:from to:to value:nil contractParams:contractParams type:@"0x2" gasFeeLevel:GasFeeLevelMedium action:ActionNormal successHandler:^(NSString * transaction) {
            NSLog(@"%@", transaction);
            [ParticleAuthService signAndSendTransaction:transaction successHandler:^(NSString * signature) {
                NSLog(@"%@", signature);
                [weakSelf hideLoading];
                } failureHandler:^(NSError * error) {
                    NSLog(@"%@", error);
                    [weakSelf hideLoading];
                }];
        } failureHandler:^(NSError * error) {
            NSLog(@"%@", error);
            [weakSelf hideLoading];
        }];
    
}

- (IBAction)signTransaction {
    NSString *transaction;
    
    Chain *chain = [ParticleNetwork getChainInfo].chain;
    if (chain == [Chain solana]) {
        transaction = @"87PYtzaf2kzTwVq1ckrGzYDEi47ThJTu4ycMth8M3yrAfs7DWWwxFGjWMy8Pr6GAgu21VsJSb8ipKLBguwGFRJPJ6E586MvJcVSo1u6UTYGodUqay8bYmUcb3hq6ezPKnUrAuKyzDoW5WT1R1K62yYR8XTwxttoWdu5Qx3AZL8qa3F7WobW5WDGRT4fS8TsXSxWbVYMfWgdu";
        
    } else {
        transaction = @"0x0";
        
    }
    
    if ([transaction isEqualToString: @""]) { return; }
    
    [ParticleAuthService signTransaction:transaction successHandler:^(NSString * signedTransaction) {
        NSLog(@"%@", signedTransaction);
        } failureHandler:^(NSError * error) {
            NSLog(@"%@", error);
        }];
}

- (IBAction)signMessage {
    NSString *message;
    NSString *hello;
    
    Chain *chain = [ParticleNetwork getChainInfo].chain;
    if (chain == [Chain solana]) {
        message = @"87PYtzaf2kzTwVq1ckrGzYDEi47ThJTu4ycMth8M3yrAfs7DWWwxFGjWMy8Pr6GAgu21VsJSb8ipKLBguwGFRJPJ6E586MvJcVSo1u6UTYGodUqay8bYmUcb3hq6ezPKnUrAuKyzDoW5WT1R1K62yYR8XTwxttoWdu5Qx3AZL8qa3F7WobW5WDGRT4fS8TsXSxWbVYMfWgdu";
        
    } else {
        hello = @"Hello world !";
        NSData *encoded = [NSJSONSerialization dataWithJSONObject:hello options:NSJSONWritingFragmentsAllowed error:nil];
        message = [@"0x" stringByAppendingString:[encoded hexString]];
        
    }
    
    
    
    if ([message isEqualToString: @""]) { return; }
    
    [ParticleAuthService signMessage:message successHandler:^(NSString * signedMessage) {
        NSLog(@"%@", signedMessage);
        } failureHandler:^(NSError * error) {
            NSLog(@"%@", error);
        }];
}

- (IBAction)signTypedData {
    NSString *message;
    
    NSArray *dataArray = @[@{
        @"type": @"string",
        @"name": @"fullName",
        @"value": @"John Doe",
    }, @{
        @"type": @"uint64",
        @"name": @"Name",
        @"value": @"Doe",
    }];
    
    NSData *encoded = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingFragmentsAllowed error:nil];
    
    
    Chain *chain = [ParticleNetwork getChainInfo].chain;
    if (chain == [Chain solana]) {
        message = @"";
        
    } else {
        message = [@"0x" stringByAppendingString:[encoded hexString]];
        
    }
   
    
    if ([message isEqualToString: @""]) { return; }
    
    [ParticleAuthService signMessage:message successHandler:^(NSString * signedMessage) {
        NSLog(@"%@", signedMessage);
        } failureHandler:^(NSError * error) {
            NSLog(@"%@", error);
        }];
}
    

- (IBAction)openWallet {
    [PNRouter navigatorWalletWithDisplay:DisplayToken hiddenBackButton:YES animated:YES];
}

- (IBAction)openSendToken {
    TokenSendConfig *config = [[TokenSendConfig alloc] initWithTokenAddress:nil toAddress:nil amountString:nil];
    [PNRouter navigatorTokenSendWithTokenSendConfig:config modalStyle: ParticleGUIModalStylePageSheet];
}

- (IBAction)openReceiveToken {
    TokenReceiveConfig *config = [[TokenReceiveConfig alloc] initWithTokenAddress:nil];
    [PNRouter navigatorTokenReceiveWithTokenReceiveConfig:config];
}

- (IBAction)openTransactionRecords {
    NSString *tokenAddress = @"";
    TokenTransactionRecordsConfig *config = [[TokenTransactionRecordsConfig alloc] initWithTokenAddress:tokenAddress];
    [PNRouter navigatorTokenTransactionRecordsWithTokenTransactionRecordsConfig:config];
}

- (IBAction)openNFTDetail {
    NSString *mintAddress = @"";
    NSString *tokenId = @"";
    NFTDetailsConfig *config = [[NFTDetailsConfig alloc] initWithAddress:mintAddress tokenId:tokenId];
    [PNRouter navigatorNFTDetailsWithNftDetailsConfig:config];
}

- (IBAction)openNFTSend {
    NSString *mintAddress = @"";
    NSString *toAddress = @"";
    NSString *tokenId = @"";
    NSString *amount = @"1";
    NFTSendConfig *config = [[NFTSendConfig alloc] initWithAddress:mintAddress toAddress:toAddress tokenId:tokenId amountString:amount];
    [PNRouter navigatorNFTSendWithNftSendConfig:config];
}

- (void)showLoading {
    self.mask.hidden = NO;
    [self.loading startAnimating];
}

- (void)hideLoading {
    self.mask.hidden = YES;
    [self.loading stopAnimating];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([APIReferenceViewController class]));
}

@end
