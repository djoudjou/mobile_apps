#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
// [START auth_import]
@import Firebase;
// [END auth_import]

// [START google_import]
@import GoogleSignIn;
// [END google_import]

// [START google_maps]
@import GoogleMaps;
// [END google_maps]

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // [START firebase_configure]
    // Use Firebase library to configure APIs
    [FIRApp configure];
    // [END firebase_configure]

    [GMSServices provideAPIKey:@"AIzaSyBkJ6yT6dM5I3aMeJyZZOszA3rb808k3j4"];
    [GeneratedPluginRegistrant registerWithRegistry:self];

  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
