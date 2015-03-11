Incognito
=========

### System requirements

- iOS8.0+
- Xcode 6.2
- [cocoapods 0.36.0-rc1](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/)
- Passcode should be set (to securely stores OAuth2 tokens in your iOS keychain, we chosen to use ```WhenPasscodeSet``` policy) 

### Google Account Setup

- Create a project by going through [Google Console Registration instructions](docs/Google.md) and copy the client id.

- In [Incognito/ViewController.swift](https://github.com/corinnekrych/Incognito/blob/master/Incognito%2FViewController.swift#L84), paste your client id.

```swift
        let googleConfig = GoogleConfig(
            clientId: "<client id>",
            scopes:["https://www.googleapis.com/auth/drive"])
```

### Run it in Xcode

On the root directory of the project run:

```bash
pod install
```
and double click on the generated .xcworkspace to open in Xcode.

### UI Flow
- select an image

![photo](docs/cat_alone.JPG)

- add accessories

![photo with accessories](docs/cat_hat_mustache_glasses.JPG)

- share to google drive