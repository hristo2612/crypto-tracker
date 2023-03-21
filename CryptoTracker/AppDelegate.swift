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
            button.action = #selector(handleClick)
        }
    }
    
    @objc func handleClick() {
        let popover = NSPopover()
        let view = NSHostingView(rootView: PopoverCoinView())
        let hostingController = NSHostingController(rootView: PopoverCoinView())
        popover.behavior = .transient
        popover.contentViewController = hostingController
        popover.contentViewController?.view = hostingController.view
        popover.show(relativeTo: statusItem!.button!.bounds, of: statusItem!.button!, preferredEdge: .minY)
        popover.contentSize = hostingController.view.fittingSize
    }
}
