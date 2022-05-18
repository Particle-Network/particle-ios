# Particle iOS

This repository contains [Auth Service](https://docs.particle.network/auth-service/introduction) and [Wallet Service](https://docs.particle.network/wallet-service/introduction) sample source. It supports Solana now, more chains and more features coming soon! Learn more visit [Particle Network](https://docs.particle.network/).

# Prerequisites
Install the following:

Xcode 13.3.1

Make sure that your project meets the following requirements:

Your project must target these platform versions or later:

iOS 12


## Getting Started

* Clone the repo.
* Open Appdelegate.swift
* Add below particle sdk config.   

```
let projectUuid: String = "xxx"
let projectClientKey: String = "xxx"
let projectAppUuid: String = "xxx"
```
Replace `xxx` with the new values created in the [Dashboard](https://particle.network/#/login).

Config your app scheme url, select your app target, in the info section, click add URL Type, past your scheme in URL Schemes. 
your scheme url should be "pn" + your project app id.

for example, if you project app id is "63bfa427-cf5f-4742-9ff1-e8f5a1b9828f", you scheme url is "pn63bfa427-cf5f-4742-9ff1-e8f5a1b9828f".
![image](https://user-images.githubusercontent.com/18244874/168455432-f25796b0-3a6a-4fa7-8ec6-adc5f8a0c46e.png)

Add Privacy - Camera Usage Description in your info.plist file

## Build
```
pod install --repo-update
```

## Features

1. Auth login with email or phone.
2. Logout.
3. Open Wallet.
4. Change Chain Id.

## Give Feedback
Please report bugs or issues to [particle-ios/issues](https://github.com/Particle-Network/particle-ios/issues)

You can also join our [Discord](https://discord.com/invite/qwysge6cgF).





