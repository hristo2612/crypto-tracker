import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("App Did Finish Launching")
        // This code will hide the app icon from the dock once the app finished launching
        NSApp.setActivationPolicy(.accessory)
    }
}
