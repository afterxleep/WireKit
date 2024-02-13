

# WireKit

![Swift](https://github.com/afterxleep/WireKit/workflows/Swift/badge.svg?branch=main)

A simple networking library using modern async/await and URLSession.

WireKit is designed to facilitate consumption of RestFul APIs and takes care of fetching and decoding JSON data, gracefully handling errors so you can focus on what's important in your app.


## Features
- Super simple configuration
- Simple REST API consumption
- Automatic JSON encoding/decoding via Codable
- Combine backed async requests
- Easy error handling

## Requirements
- iOS 15+ / macOS 10.15+ / tvOS 13.0+ / watchOS 5.0+
- Xcode 14+
- Swift 5.5+

## Installation

### Swift Package Manager  

The fastest way to install is via SPM.  Just add a new package using this repo URL and point it to the current Major Version

Versioning and support for other package managers (Cocoapods & Carthage) coming soon.

## Sample App
The [Example application](docs/ExampleApp) is a simple Todo List app that leverages Wirekit to easily fetch and manage items.

## Usage

Check out the [Quick Start guide](docs/quickStart.md)

## WKRequest

Futher documentation for advanced use of WKRequest is [also available.](docs/wkrequest.md)
