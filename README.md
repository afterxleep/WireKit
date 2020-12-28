

# WireKit

![Swift](https://github.com/afterxleep/WireKit/workflows/Swift/badge.svg?branch=main)

A simple networking library based on Combine, Codable and URLSession publishers.

WireKit is designed to facilitate consumption of RestFul APIs and takes care of fetching and decoding JSON data, gracefully handling errors so you can focus on what's important in your app.



## Features
- Super simple configuration
- Simple REST API consumption
- Automatic JSON encoding/decoding via Codable
- Combine backed async requests
- Easy error handling

## Requirements
- iOS 13+ / macOS 10.15+ / tvOS 13.0+ / watchOS 5.0+
- Xcode 12+
- Swift 5.3+

## Installation

### Swift Package Manager  

The fastest way to install is via SPM.  Just add a new package using this repo URL and point it to the current Major Version

Versioning and support for other package managers (Cocoapods & Carthage) coming soon.

## Sample App
The sample application is a simple Todo List app that leverages Wirekit to easily manage items.

It's available [in this Repo](https://github.com/afterxleep/WireKitSample).

## Usage

Check out the Quick Start guide [here](docs/quickStart.md)

## WKRequest

Futher documentation on WKRequest is available [here](docs/wkrequest.md)
