import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame

    // Configure window appearance to match professional software
    self.titleVisibility = .hidden  // Hide the title bar
    self.titlebarAppearsTransparent = true  // Make title bar transparent
    self.styleMask.insert(.fullSizeContentView)  // Extend content to full size

    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
