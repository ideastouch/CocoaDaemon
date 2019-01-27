# CocoaDaemon [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CocoaDaemon.svg)](https://img.shields.io/cocoapods/v/CocoaDaemon.svg.svg)


`CocoaDaemon` Daemon Kit to manage background closures to be called each set period of time


## Features
- Three properties, name, time and status to each closures.
- Option to update any of the properties.
- Shared object implementation.
- Option to instantiate a custom object instead of used the shared object.

## How to install
### CocoaPods

1. Make sure `use_frameworks!` is added to your `Podfile`.

2. Include the following in your `Podfile`:
  ```
  pod 'CocoaDaemon'
  ```
3. Run `pod install`

## How to use
Work with this Daemon is easy, most of the time the only thing you should be
worry about will be to submit your closures and remove them as well.

Your closure must receive one parameter, this parameter will be a block that
should be called if you want your closure to be scheduled for another call.

If you submit your block as inactive (active equal to false), it wouldn't be
called and his status will be checked again on an on until the status change
to active and in this time it will be called.
```Swift
Daemon.sharedInstance.submitBlock("YourBlockName",
	block: { (completion: @escaping () -> Void) in
    	// Do your work here.
    	// Call completion if you want your block be scheduled again.
        completion()
  	},
  	active: true, seconds: 0.2)

```


