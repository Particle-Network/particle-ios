# Particle iOS

[![Swift](https://img.shields.io/badge/Swift-5-orange)](https://img.shields.io/badge/Swift-5-orange)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen)](https://img.shields.io/badge/Platforms-iOS-Green)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ParticleWalletGUI.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![License](https://img.shields.io/github/license/Particle-Network/particle-ios)](https://github.com/Particle-Network/particle-ios/blob/main/LICENSE.txt)

This repository contains sample source code for [Auth Service](https://developers.particle.network/api-reference/auth/mobile-sdks/ios) and [Wallet Service](https://developers.particle.network/api-reference/wallet/mobile/ios). It supports Solana and all EVM-compatible chains. Learn more at [Particle Network](https://developers.particle.network/).

![ConnectKit Mobile](/images/connectkit-mobile.svg)

---

## Prerequisites

- **iOS 15.6 or higher**

> **Note:** The AuthCore SDKs only support `ios-arm64` (physical iOS devices). Intel chip simulators (`ios-x86_64-simulator`) and M-series chip simulators (`ios-arm64-simulator`) are not supported.

### SDK Versions

| Package                         | Version |
| ------------------------------- | ------- |
| ParticleConnectKit              | 2.0.8   |
| ParticleNetworkBase             | 2.0.9   |
| ParticleWalletAPI               | 2.0.9   |
| ParticleWalletGUI               | 2.0.9   |
| ParticleWalletConnect           | 2.0.9   |
| ParticleAA                      | 2.0.9   |
| ParticleAuthCore                | 2.0.8   |
| ParticleMPCCore                 | 2.0.8   |
| AuthCoreAdapter                 | 2.0.8   |
| Thresh                          | 2.0.8   |
| ParticleAuthService *(deprecated)* | —    |

---

## Apple Privacy Manifests

From version 1.4.0, all SDKs are adapted to Apple's privacy requirements. The following third-party dependencies require specific versions:

```ruby
pod 'SwiftyUserDefaults', :git => 'https://github.com/SunZhiC/SwiftyUserDefaults.git', :branch => 'master'
# Required if using ParticleWalletConnect
pod 'WalletConnectSwiftV2', :git => 'https://github.com/SunZhiC/WalletConnectSwiftV2.git', :branch => 'particle'
# Required if using ParticleAuthCore or ParticleWalletGUI
pod 'SkeletonView', :git => 'https://github.com/SunZhiC/SkeletonView.git', :branch => 'main'
```

### WalletConnect v2

WalletConnect v2 is supported from version 0.14.0.

### Podfile Setup

Add the following to your `Podfile` if using `ParticleWalletGUI`:

```ruby
pod 'SkeletonView', :git => 'https://github.com/SunZhiC/SkeletonView.git', :branch => 'main'
```

From version 0.8.6, SDKs are built as XCFrameworks. Add the following `post_install` block to your `Podfile`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```

---

## Getting Started

1. Clone the repository and open the `Demo` folder.
2. Replace the contents of `ParticleNetwork.info` with your project credentials from the [Dashboard](https://dashboard.particle.network/#/login):

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

3. Configure your app's URL scheme. In your app target, go to **Info → URL Types** and add a new entry. The scheme should be `pn` followed by your Project App UUID.

    For example, if your Project App UUID is `63bfa427-cf5f-4742-9ff1-e8f5a1b9826f`, the URL scheme is `pn63bfa427-cf5f-4742-9ff1-e8f5a1b9826f`.

    ![URL Scheme setup](https://user-images.githubusercontent.com/18244874/168455432-f25796b0-3a6a-4fa7-8ec6-adc5f8a0c46e.png)

4. Add `Privacy - Camera Usage Description` to your `Info.plist`.

### Build

```bash
pod install --repo-update
```

---

## Other Demos

- **GuideSeries** — Step-by-step guide following the [iOS Quickstart](https://developers.particle.network/guides/wallet-as-a-service/waas/mobile-quickstart) to add Particle SDK to your project.
- **ParticleWalletConnectDemo** — Demonstrates integrating `ParticleWalletConnect`, using `ParticleAuthService` to handle requests from a dApp.
- **ParticleAuthDemo_deprecated** — Shows how to integrate `ParticleAuthService` with minimal code.
- **ParticleAuthDemo_Scene_deprecated** — Shows how to integrate `ParticleAuthService` when the app starts from `SceneDelegate.swift`.

---

## Features

- Login with email, phone, Google, Facebook, Apple, and more
- Logout
- Open Wallet
- Change Chain ID

---

## Documentation

- [Connect SDK — iOS](https://developers.particle.network/api-reference/connect/mobile/ios)
- [Auth Service — iOS](https://developers.particle.network/api-reference/auth/mobile-sdks/ios)
- [Wallet Service — iOS](https://developers.particle.network/api-reference/wallet/mobile/ios)
- [AA SDK — iOS](https://developers.particle.network/api-reference/aa/sdks/mobile/ios)

---

## Feedback

Report bugs or issues on the [GitHub Issues](https://github.com/Particle-Network/particle-ios/issues) page, or join the community on [Discord](https://discord.gg/2y44qr6CR2).
