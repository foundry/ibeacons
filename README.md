ibeacons
========

ibeacons test app - compares [Radius Networks](http://www.radiusnetworks.com) [ProximityKit](https://github.com/RadiusNetworks/proximity-kit-ios-example)  with raw (wraperless) Core Location

Includes a build of [ibeacon-cli](https://github.com/RadiusNetworks/ibeacon-cli) for test broadcasting

To use:
- install ProximityKit from the included podFile using cocoaPods (`pod install`)
- set a test UUID and identifier in the .pch file
- set the class type (for Proximity Kit or Core Location) in the view controller's `viewDidLoad`

To use with ProximityKit: 
- open a (free) developer account at Radius Networks
- create a Kit and download the plist file
- replace `ProximityKit.plist` with your plist.
- ensure the pch file UUID agrees with your Kit UUID.



//TO DO  
Blog/wiki explanation  
Get local notifications to work  
