#  TestLaunch

### 1. demonstrate the operation of a NetworkMonitor

`class NetworkMonitor` uses `NWPathMonitor()` from Apple's `Network` kit.

`NetworkMonitor` is a singleton, providing the `isConnected` status to any of the app's
view controllers.

`NetworkMonitor.shared` usage in a ViewController:

 1. get the current state when you need it

```
print(NetworkMonitor.shared.connected ? "is connected" : "is disconnected"
```
 2. add a handler to get a notification when the connectivity changed

```
     NetworkMonitor.shared.handler = { isConnected in
         print(isConnected ? "is connected" : "is disconnected")
     }
```
 3. if the handler references the view controller's self, it must declare `[weak self]`
    to avoid memory retention cycles

```
     NetworkMonitor.shared.handler = { [weak self] isConnected in
         DispatchQueue.main.async {
             self?.connectedLabel.text = isConnected ? "connected" : "disconnected"
         }
     }
```

See also:

[Network Framework in iOS: How to Monitor Network Status Changes](https://www.appcoda.com/network-framework/)

[What Is a Singleton and How To Create One In Swift](https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift)

[Weak self and unowned self explained in Swift](https://www.avanderlee.com/swift/weak-self/)


Notes:
1. The app consists of several ViewControllers which use Show segues to present siblings and unwind segues to return to the controller that presented them.
    The app contains a NetworkMonitor.shared which runs its monitoring while the app is running.

2. The app may go into the background and later come back from background.

3. Each ViewController shall have a Network StatusLabel just underneath the Status Bar.
StatusLabel shall be invisible (hidden) whenever the device is connected to the internet, and visible with text "∆ No Network" when disconnected.

StatusLabel shall be updated or kept up to date:
3.1 when a presented ViewController appears on the screen (hiding the presenting VC)
3.2 when a presented ViewController disappears from the screen (unhiding the presenting VC)
3.3 when the connectivity changes
3.4 when the app comes back from the background

Current concepts and principles:
- NetworkMonitor.shared is static, therefore it is initialized on the first access after the app start.
- NetworkMonitor monitors the network connection status until the app exits.
- ViewControllers wishing to display the connection status must install a handler.
- NetworkMonitor will call the handler upon its installation and when the connection status changes.
- Only one client's handler can be instaled at a time.

