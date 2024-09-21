# SwiftUI WidgetKit Demo
Demos for using [WidgetKit](https://developer.apple.com/documentation/widgetkit/) with SwiftUI.

- [Basic Static Widget](#basic-static-widget)
- [Widget with Deep Link](#widget-with-deep-link)
- [Interactive Widget](#interactive-widget)




## Basic Static Widget
[Demo](./SFStaticWidget/) for static widget, a type that doesn't need any configuration by the user.

This demo also includes the following.

- Static vs dynamic timeline entries
- Widget contents based on widget size ([WidgetFamily](https://developer.apple.com/documentation/widgetkit/widgetfamily))



For more details, please check out [Static Widgets with WidgetKit]().


![StaticWidget](./ReadmeAsset/StaticWidget.gif)


## Widget with Deep Link
[Demo](./DeepLinkWidget/) for passing data and linking to specific view from widgets using Deep Link.

Specially, deep linking with

- [widgetUrl](https://developer.apple.com/documentation/swiftui/view/widgeturl(_:))
- [Link](https://developer.apple.com/documentation/swiftui/link)

For more details, please check out [Pass Data and Link to Specific View from Widgets]().


![](./ReadmeAsset/DeepLinkWidget.gif)




## Interactive Widget
[Counter Demo](./InteractiveWidget/) for an interactive widget.

This example also shows how we can share and sync data (the counter value) between widget(s) and the main app using `App Group` and `UserDefaults`.

For more details, please check out [Add Controls (Interactivity) to Widgets]().

![](./ReadmeAsset/InteractiveWidget.gif)
