import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupMenuBar()
    }
}

// MARK: - Menu Bar

extension AppDelegate {
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "bitcoinsign.circle", accessibilityDescription: "Bitcoin")
        }
    }
}

