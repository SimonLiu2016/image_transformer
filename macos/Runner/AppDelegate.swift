import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var statusBarItem: NSStatusItem?

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    setupStatusBarItem()
    super.applicationDidFinishLaunching(notification)
  }

  private func setupStatusBarItem() {
    statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    if let button = statusBarItem?.button {
      button.image = NSImage(named: "StatusBarItemIcon")
      button.action = #selector(statusBarButtonClicked)
      button.target = self
    }

    // Create menu
    let menu = NSMenu()
    menu.addItem(
      NSMenuItem(title: "Open Image Transformer", action: #selector(openApp), keyEquivalent: ""))
    menu.addItem(
      NSMenuItem(title: "Preferences", action: #selector(openPreferences), keyEquivalent: ","))
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

    statusBarItem?.menu = menu
  }

  @objc private func statusBarButtonClicked() {
    NSApp.activate(ignoringOtherApps: true)
  }

  @objc private func openApp() {
    NSApp.activate(ignoringOtherApps: true)
  }

  @objc private func openPreferences() {
    NSApp.activate(ignoringOtherApps: true)
    // Navigate to settings page via method channel
  }

  @objc private func quitApp() {
    NSApp.terminate(self)
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
