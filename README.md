# Particle iOS
[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://img.shields.io/badge/Swift-5-orange)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen)](https://img.shields.io/badge/Platforms-iOS-Green)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ParticleWalletGUI.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![License](https://img.shields.io/github/license/Particle-Network/particle-ios)](https://github.com/Particle-Network/particle-ios/blob/main/LICENSE.txt)


This repository contains [Auth Service](https://docs.particle.network/auth-service/introduction) and [Wallet Service](https://docs.particle.network/wallet-service/introduction) sample source. It supports Solana and all EVM-compatiable chains now, more chains and more features coming soon! Learn more visit [Particle Network](https://docs.particle.network/).

#### Note
Please note that the AuthCore SDKs only support `ios-arm64` (iOS devices). We currently do not support `ios-x86_64-simulator` (Intel chip simulators) and  `ios-arm64-simulator` (M-series chip simulators).


# Prerequisites
Install the following:

Xcode 15.0 or higher
iOS 14 or higher


| Xcode version                | 15.0 or higher | 
|------------------------------|---------------|
| ParticleNetworkBase          | 1.4.2        |
| ParticleWalletAPI            | 1.4.2        |
| ParticleWalletGUI            | 1.4.2        |
| ParticleWalletConnect        | 1.4.2        | 
| ParticleAA                   | 1.4.2        | 
| ParticleAuthCore             | 1.4.2          |
| ParticleMPCCore              | 1.4.2          |
| AuthCoreAdapter              | 1.4.2          |
| Thresh                       | 1.4.2          |
| ParticleAuthService(deprecated)         | 1.4.2        |

## 🎯 Support Apple Privacy Manifests
From version 1.4.0, all SDKs have been adapted to Apple's privacy requirements.

The following third-party SDKs require the use of specific versions.
```ruby
pod 'SwiftyUserDefaults', :git => 'https://github.com/SunZhiC/SwiftyUserDefaults.git', :branch => 'master'
# if you need ParticleWalletConnect, you should add this line.
pod 'WalletConnectSwiftV2', :git => 'https://github.com/SunZhiC/WalletConnectSwiftV2.git', :branch => 'particle'
# if you need ParticleAuthCore or ParticleWalletGUI, you should add this line.
pod 'SkeletonView', :git => 'https://github.com/SunZhiC/SkeletonView.git', :branch => 'main'
```

### Migrating to WalletConnect v2
Starting from version 0.14.0, WalletConnectV2 is supported.

### 🔌 Podfile request
From 0.9.12, you should add more in Podfile
If you use PartcleWalletGUI, you need add this one.
```ruby
pod 'SkeletonView', :git => 'https://github.com/SunZhiC/SkeletonView.git', :branch => 'main'
```

###  🧂 Update Podfile
From 0.8.6, we start to build SDK with XCFramework, that request copy the following text into Podfile.

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
   end
```


# 🔧 Getting Started

* Clone the repo. open Demo folder.
* Replace ParticelNetwork.info with your project info in the [Dashboard](https://dashboard.particle.network/#/login).
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PROJECT_UUID</key>
	<string>YOUR_PROJECT_UUID</string>
	<key>PROJECT_CLIENT_KEY</key>
	<string>YOUR_PROJECT_CLIENT_KEY</string>
	<key>PROJECT_APP_UUID</key>
	<string>YOUR_PROJECT_APP_UUID</string>
</dict>
</plist>

```
* Config your app scheme url, select your app target, in the info section, click add URL Type, past your scheme in URL Schemes. 
your scheme url should be "pn" + your project app id.

    for example, if you project app id is "63bfa427-cf5f-4742-9ff1-e8f5a1b9826f", you scheme url is "pn63bfa427-cf5f-4742-9ff1-e8f5a1b9826f".
![image](https://user-images.githubusercontent.com/18244874/168455432-f25796b0-3a6a-4fa7-8ec6-adc5f8a0c46e.png)

* Add Privacy - Camera Usage Description to your info.plist file

## 💿 Build
```
pod install --repo-update
```

## 🚴‍♂️ Other Demo

- **GuideSeries:** follow [iOS Guide](https://docs.particle.network/getting-started/platform-specific-guides/ios/social-login-+-embeded-wallet) step to step, add ParticleSDK to your project.
  
- **ParticleWalletConnectDemo** show how to integrate with ParticleWalletConnect, it use ParticleAuthService to handle request from dapp.
- **ParticleAuthDemo_deprecated** show how to integrate ParticleAuthService with a few code.
  
- **ParticleAuthDemo_Scene_deprecated** start from SceneDelegate.swift, show how to integrate ParticleAuthService when app start from SceneDelagate.swift with a few code.
  

## 🔬 Features

1. Login with email, phone, facebook, google, apple etc.
2. Logout.
3. Open Wallet.
4. Change Chain Id.
5. Check our official dev docs: https://developers.particle.network/

## 📄 Docs
1. https://developers.particle.network/reference/auth-ios
2. https://developers.particle.network/reference/wallet-ios
3. https://developers.particle.network/reference/aa-ios

## 💼 Give Feedback
Please report bugs or issues to [particle-ios/issues](https://github.com/Particle-Network/particle-ios/issues)

You can also join our [Discord](https://discord.gg/2y44qr6CR2).





