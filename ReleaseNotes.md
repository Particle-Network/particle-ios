## Release Notes

### 0.8.8
Fix bugs

### 0.8.6
Particle SDKs from 0.8.6 and Connect SDKs from 0.1.32, built with XCFramework, you don’t need to specify version for different Xcode.
Benefit from XCFramework, you could test with simulator in both M1(arm64) and Inter(x86_64)

But you need to add some code in Podfile

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
   end

| Xcode version                | 13.3.1~14.1|
|------------------------------|---------------|
| ParticleNetworkBase          | 0.8.6         |
| ParticleAuthService          | 0.8.6         |
| ParticleWalletAPI            | 0.8.6         |
| ParticleWalletGUI            | 0.8.6         | 
| ParticleWalletConnect        | 0.8.6         |
| ConnectCommon                | 0.1.32        |
| ParticleConnect              | 0.1.32        |
| ConnectWalletConnectAdapter  | 0.1.32        | 
| ConnectEVMConnectAdapter     | 0.1.32        |
| ConnectPhantomConnectAdapter | 0.1.32        |
| ConnectSolanaConnectAdapter  | 0.1.32        |

### 0.8.5
We have released new SDK,  `ParticleWalletConnect`, that support wallet connect as a wallet, we provider a demo in github, show how to integrate with `ParticleWalletConnect`, scan qrcode and handle request from dapp.
https://github.com/Particle-Network/particle-ios/tree/main/ParticleWalletConnectDemo

If you also use `ParticleWalletGUI`, it has embeded `ParticleWalletConnect`, default enable.

```
// call to disable this feature if needed.
ParticleWalletGUI.supportWalletConnect(false)
```

And ParticleWalletConnect need initialize, example 
```swift
ParticleWalletConnect.initialize(
            WalletMetaData(name: "Particle Wallet",
                           icon: URL(string: "https://connect.particle.network/icons/512.png")!,
                           url: URL(string: "https://particle.network")!,
                           description: “Particle wallet demo”))
```

And let GUI  handle url 
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if ParticleWalletGUI.handleWalletConnectUrl(url, withScheme: "particlewallet") {
            return true
        } else {
            return ParticleConnect.handleUrl(url)
        }
    }
```

Now we start to support Xcode 14.1.
| Xcode version                | 13.3.1~13.4.1 | 14.0~14.0.1 | 14.1  |
|------------------------------|---------------|----------|----------|
| ParticleNetworkBase          | 0.8.5         | 0.8.5.1  | 0.8.5.2  |
| ParticleAuthService          | 0.8.5         | 0.8.5.1  | 0.8.5.2  |
| ParticleWalletAPI            | 0.8.5         | 0.8.5.1  | 0.8.5.2  |
| ParticleWalletGUI            | 0.8.5         | 0.8.5.1  | 0.8.5.2  |
| ParticleWalletConnect        | 0.8.5         | 0.8.5.1  | 0.8.5.2  |
| ConnectCommon                | 0.1.31        | 0.1.30.1 | 0.1.30.2 |
| ParticleConnect              | 0.1.31        | 0.1.30.1 | 0.1.30.2 |
| ConnectWalletConnectAdapter  | 0.1.31        | 0.1.30.1 | 0.1.30.2 |
| ConnectEVMConnectAdapter     | 0.1.31        | 0.1.30.1 | 0.1.30.2 |
| ConnectPhantomConnectAdapter | 0.1.31        | 0.1.30.1 | 0.1.30.2 |
| ConnectSolanaConnectAdapter  | 0.1.31        | 0.1.30.1 | 0.1.30.2 |
