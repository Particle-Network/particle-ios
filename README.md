# Particle iOS
[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://img.shields.io/badge/Swift-5-orange)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen)](https://img.shields.io/badge/Platforms-iOS-Green)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ParticleWalletGUI.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![License](https://img.shields.io/github/license/Particle-Network/particle-ios)](https://github.com/Particle-Network/particle-ios/blob/main/LICENSE.txt)


This repository contains [Auth Service](https://docs.particle.network/auth-service/introduction) and [Wallet Service](https://docs.particle.network/wallet-service/introduction) sample source. It supports Solana and all EVM-compatiable chains now, more chains and more features coming soon! Learn more visit [Particle Network](https://docs.particle.network/).

# Prerequisites
Install the following:

Xcode 13.3.1 or higher


| Xcode version                | 13.3.1 ~ 14.1 | 
|------------------------------|---------------|
| ParticleNetworkBase          | 0.8.9         |
| ParticleAuthService          | 0.8.9         |
| ParticleWalletAPI            | 0.8.9         |
| ParticleWalletGUI            | 0.8.9         |
| ParticleWalletConnect        | 0.8.9         | 

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

Make sure that your project meets the following requirements:

Your project must target these platform versions or later:

iOS 13


## 🔧 Getting Started

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

* Add Privacy - Camera Usage Description in your info.plist file

## 💿 Build
```
pod install --repo-update
```

## 🚴‍♂️ Other Demo
`ParticleAuthDemo` show how to integrate ParticleAuthService with a few code.

`ParticleAuthDemo_Scene` start from SceneDelegate.swift, show how to integrate ParticleAuthService when app start from SceneDelagate.swift with a few code.

`ParticleWalletConnectDemo` show how to integrate with ParticleWalletConnect, it use ParticleAuthService to handle request from dapp.
## 🔬 Features

1. Auth login with email, phone, facebook, google, apple etc.
2. Logout.
3. Open Wallet.
4. Change Chain Id.
5. Check our official dev docs: https://docs.particle.network/

## 📄 Docs
1. https://docs.particle.network/auth-service/sdks/ios
2. https://docs.particle.network/wallet-service/sdks/ios


2. Run Xcode with Rosetta.

## 💼 Give Feedback
Please report bugs or issues to [particle-ios/issues](https://github.com/Particle-Network/particle-ios/issues)

You can also join our [Discord](https://discord.gg/2y44qr6CR2).





