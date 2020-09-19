# Screenplay Demo App

## About

In this demo, we have an Xcode project called DemoApp which includes 2 targets:

- **DemoApp**: This looks like, and is structured like an app, but we've instructed Xcode to build it as a framework instead. More on why we did this later.
- **WrapperApp**: This does not look like, nor is it structured like an app, but we've instructed Xcode to build it as one.

When you build and run WrapperApp, it will load DemoApp at runtime (in a way which is supported by Apple, and the way you would normally load any other framework, such as those vended by CocoaPods and Carthage). Notice that even though the WrapperApp target doesn't seem to include any UI, it renders and behaves exactly what DemoApp would; this is because WrapperApp is just running DemoApp.

If you're unconviced, feel free to update DemoApp and rebuild WrapperApp to watch it change.

## Usages

One practical use of this is for rollbacks. By packaging many versions of your app together you can choose which (of the prepackaged apps) to load using a feature flag, an industry standard practice for shipping configs to mobile apps at runtime.

This allows you to release quickly without having to sacrifice software quality. Much how our web counter parts have been able to move to true CI/CD with the innovations of progressive rollouts, progressive rollbacks, canary, blue/green, etc.

## Technology

The magic largely happens in `./DemoApp/WrapperApp/main.swift`.

I've done my best to comment the code clearly there, but the tl;dr is we use the magic of dylibs. [Dylibs](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/UsingDynamicLibraries.html) are a way to package code such that they aren't included in the main executable, and are how Apple loads frameworks on both OSX and iOS. Dylibs allow us to package an inner app (or many inner apps) and later evaluate them at runtime without having to update their code.

## Limitations

If you wanted to use this in production, there are still a few things left to do. You would need to:

- Update callsites to get assets in DemoApp to account for the fact that many of them are probably trying to read assets off the mainBundle (and DemoApp is no longer the mainBundle if you package it alongside other apps)
- Merge the Info.plists
- Dedupe similar assets / frameworks / etc. (unless you want your appsize to increase by 2x assuming you're bundling two apps)
- Create and manage a feature flag system
- Implement caching mechanisms / build settings such that you don't affect cold start.

Alternatively, [Screenplay](https://screenplay.dev) does this all for you! If you're interested, please feel free to reach out.

## Copyright

Copyright Screenplay Studios Inc, 2020
