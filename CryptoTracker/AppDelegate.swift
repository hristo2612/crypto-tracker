import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    let coinCapService = CoinCapPriceService()
    var statusItem: NSStatusItem?
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupCoinCapService()
        setupMenuBar()
        setupPopover()
    }
    
    func setupCoinCapService() {
        coinCapService.connect()
        coinCapService.startMonitorNetwork()
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
        if popover.isShown {
            popover.performClose(nil)
            return
        }
        
        popover.show(relativeTo: statusItem!.button!.bounds, of: statusItem!.button!, preferredEdge: .minY)
        
        // Close popover when user clicks outside of it
        NSApplication.shared.activate(ignoringOtherApps: true)
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { _ in
            self.popover.performClose(nil)
        }
    }
}

// MARK: - Popover

extension AppDelegate {
    func setupPopover() {
        let hostingController = NSHostingController(rootView: PopoverCoinView())
        popover.behavior = .transient
        popover.contentViewController = hostingController
        popover.contentSize = hostingController.view.fittingSize
    }
}
