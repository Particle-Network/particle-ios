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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginWithEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *loginWithPhoneButton;
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
    
    [self showLogin:true];
    self.switchChainButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.switchChainButton.titleLabel.numberOfLines = 2;
    self.switchChainButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.switchChainButton.transform = CGAffineTransformMakeRotation(M_PI / 4);
    
    
    if ([ParticleAuthService isUserLoggedIn]) {
        [self showLogin:NO];
    } else {
        [self showLogin:YES];
    }
    
    NSString *name = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newUserInfo:) name:name object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)dealloc {
    NSString *name = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}


- (void)newUserInfo:(NSNotification *)notification {
    
}

- (IBAction)loginWithEmail {
    [ParticleAuthService loginWithType:LoginTypeEmail successHandler:^(UserInfo * userInfo) {
        NSLog(@"%@", userInfo);
    } failureHandler:^(NSError * error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)loginWithPhone {
    [ParticleAuthService loginWithType:LoginTypePhone successHandler:^(UserInfo * userInfo) {
        NSLog(@"%@", userInfo);
    } failureHandler:^(NSError * error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)logout {
    [ParticleAuthService logoutWithSuccessHandler:^(NSString * result) {
        NSLog(@"%@", result);
    } failureHandler:^(NSError * error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)openWallet {
    [PNRouter navigatorWalletWithDisplay:DisplayToken];
}

- (IBAction)switchChainClick {
    SwitchChainViewController *vc = [[SwitchChainViewController alloc] init];
    __weak MainViewController *weakSelf = self;
    vc.selectHandler = ^{
        [weakSelf updateUI];
    };
}


- (void)showLogin:(BOOL)isShow {
    self.loginWithEmailButton.hidden = !isShow;
    self.loginWithPhoneButton.hidden = !isShow;
    self.coreImageView.hidden = !isShow;
    
    self.logoutButton.hidden = isShow;
    self.openWalletButton.hidden = isShow;
    self.welcomeImageView.hidden = isShow;
    self.welcomeLabel.hidden = isShow;
}

- (void)updateUI {
    NSString *name = [ParticleNetwork getChainName].nameString;
    NSString *network = [ParticleNetwork getChainName].network;
    
    NSString *title = [NSString stringWithFormat:@"%@ \n %@", name, network];
    [self.switchChainButton setTitle:title forState:UIControlStateNormal];
}

@end
