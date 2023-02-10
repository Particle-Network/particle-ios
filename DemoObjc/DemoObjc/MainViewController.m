//
//  MainViewController.m
//  DemoObjc
//
//  Created by link on 2022/6/21.
//

#import "MainViewController.h"
#import "SwitchChainViewController.h"
#import "APIReferenceViewController.h"

@import ParticleAuthService;
@import ParticleNetworkBase;
@import ParticleWalletGUI;
@import ParticleWalletAPI;

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *appleButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

@property (weak, nonatomic) IBOutlet UIButton *apiReferenceButton;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *openWalletButton;
@property (weak, nonatomic) IBOutlet UIButton *switchChainButton;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *welcomeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coreImageView;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ChainInfo *chainInfo = ParticleNetwork.getChainInfo;
    NSString *name = chainInfo.name;
    
    NSString *network = chainInfo.network;
    NSLog(@"%@, %@", name, network);
    
    [self showLogin:true];
    self.switchChainButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.switchChainButton.titleLabel.numberOfLines = 2;
    self.switchChainButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.switchChainButton.transform = CGAffineTransformMakeRotation(M_PI / 4);
    
    
    if ([ParticleAuthService isLogin]) {
        [self showLogin:NO];
    } else {
        [self showLogin:YES];
    }
    
    
    UserInfo *userInfo = [ParticleAuthService getUserInfo];
    NSArray *wallets = userInfo.wallets;
    NSString *uuid = userInfo.uuid;
    NSString *token = userInfo.token;
    
    
    NSLog(@"uuid = %@, token = %@, wallets = %@", uuid, token, wallets);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUI];
}


- (IBAction) loginWithEmail {
    [self login:LoginTypeEmail];
}

- (IBAction) loginWithPhone {
    [self login:LoginTypePhone];
}

- (IBAction) loginWithGoogle {
    [self login:LoginTypeGoogle];
}

- (IBAction) loginWithApple {
    [self login:LoginTypeApple];
}

- (IBAction) loginWithFacebook {
    [self login:LoginTypeFacebook];
}

- (void)login:(LoginType)type {
    
    NSArray *supportAuthTypes = @[[SupportAuthType google], [SupportAuthType facebook], [SupportAuthType apple]];
    [ParticleAuthService loginWithType:type account:nil supportAuthType:supportAuthTypes loginFormMode:NO socialLoginPrompt: SocialLoginPromptNull successHandler:^(UserInfo * userInfo) {
        NSLog(@"%@", userInfo);
        [self showLogin:NO];
    } failureHandler:^(NSError * error) {
        NSLog(@"%@", error);
    }];
}


- (IBAction)logout {
    [ParticleAuthService logoutWithSuccessHandler:^(NSString * result) {
        NSLog(@"%@", result);
        [self showLogin:YES];
    } failureHandler:^(NSError * error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)openWallet {
    [PNRouter navigatorWalletWithDisplay:DisplayToken hiddenBackButton:YES animated:YES];
}

- (IBAction)switchChainClick {
    SwitchChainViewController *vc = [[SwitchChainViewController alloc] init];
    __weak MainViewController *weakSelf = self;
    vc.selectHandler = ^{
        [weakSelf updateUI];
    };
    self.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:vc animated:true completion:nil];
}

- (void)erc20Transfer {
    NSString *contractAddress = @"";
    NSString *to = @"";
    NSString *amount = @"";
    [[ParticleWalletAPI getEvmService] erc20TransferWithContractAddress:contractAddress to:to amount:amount successHandler:^(NSString * result) {
            // handle result
    } failureHandler:^(NSError * error) {
        // handle error
    }];
}


- (void)erc20Approve {
    NSString *contractAddress = @"";
    NSString *spender = @"";
    NSString *amount = @"";
    [[ParticleWalletAPI getEvmService] erc20ApproveWithContractAddress:contractAddress spender:spender amount:amount successHandler:^(NSString * result) {
            // handle result
    } failureHandler:^(NSError * error) {
        // handle error
    }];
}

- (void)erc20TransferFrom {
    NSString *contractAddress = @"";
    NSString *from = @"";
    NSString *to = @"";
    NSString *amount = @"";
    
    [[ParticleWalletAPI getEvmService] erc20TransferFromContractAddress:contractAddress from:from to:to amount:amount successHandler:^(NSString * result) {
            // handle result
    } failureHandler:^(NSError * error) {
        // handle error
    }];
}

- (void)erc721SafeTransferFrom {
    NSString *contractAddress = @"";
    NSString *from = @"";
    NSString *to = @"";
    NSString *tokenId = @"";
    
    [[ParticleWalletAPI getEvmService] erc721SafeTransferFromContractAddress:contractAddress from:from to:to tokenId:tokenId successHandler:^(NSString * result) {
            // handle result
    } failureHandler:^(NSError * error) {
        // handle error
    }];
}

- (void)erc1155SafeTransferFrom {
    NSString *contractAddress = @"";
    NSString *from = @"";
    NSString *to = @"";
    NSString *tokenId = @"";
    NSString *amount = @"";
    NSArray *data = [[NSArray alloc] init];
    
    [[ParticleWalletAPI getEvmService] erc1155SafeTransferFromContractAddress:contractAddress from:from to:to id:tokenId amount:amount data:data successHandler:^(NSString * result) {
        // handle result
    } failureHandler:^(NSError * error) {
        // handle error
    }];
}


- (void)showLogin:(BOOL)isShow {
    
    self.stackView.hidden = !isShow;
    self.coreImageView.hidden = !isShow;
    self.logoutButton.hidden = isShow;
    self.openWalletButton.hidden = isShow;
    self.welcomeImageView.hidden = isShow;
    self.apiReferenceButton.hidden = isShow;
    
    if (isShow) {
        self.welcomeLabel.text = @"Sign in to \nParticle Wallet";
        self.welcomeLabel.numberOfLines = 2;
    } else {
        self.welcomeLabel.text = @"Welcome!";
    }
}

- (void)updateUI {
    NSString *name = [ParticleNetwork getChainInfo].name;
    NSString *network = [ParticleNetwork getChainInfo].network;
    
    NSString *title = [NSString stringWithFormat:@"%@ \n %@", name, network];
    [self.switchChainButton setTitle:title forState:UIControlStateNormal];
}



@end
