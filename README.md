# Particle iOS

This repository contains [Auth Service](https://docs.particle.network/auth-service/introduction) and [Wallet Service](https://docs.particle.network/wallet-service/introduction) sample source. It supports Solana now, more chains and more features coming soon! Learn more visit [Particle Network](https://docs.particle.network/).

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





