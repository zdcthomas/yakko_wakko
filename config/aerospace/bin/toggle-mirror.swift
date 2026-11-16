// Toggle display mirroring between the built-in display and the first external one.
// Bound in aerospace.toml. Run by hand with: swift toggle-mirror.swift [status]
import CoreGraphics
import Foundation

var count: UInt32 = 0
var ids = [CGDirectDisplayID](repeating: 0, count: 16)
guard CGGetOnlineDisplayList(16, &ids, &count) == .success else {
    FileHandle.standardError.write("cannot list displays\n".data(using: .utf8)!)
    exit(1)
}
let displays = Array(ids.prefix(Int(count)))
let mirrored = displays.filter { CGDisplayIsInMirrorSet($0) != 0 }

if CommandLine.arguments.dropFirst().first == "status" {
    print(mirrored.isEmpty ? "off" : "on")
    exit(0)
}

var config: CGDisplayConfigRef?
guard CGBeginDisplayConfiguration(&config) == .success else { exit(1) }

if !mirrored.isEmpty {
    for display in displays {
        CGConfigureDisplayMirrorOfDisplay(config, display, kCGNullDirectDisplay)
    }
    print("mirror off")
} else {
    guard let builtin = displays.first(where: { CGDisplayIsBuiltin($0) != 0 }),
          let external = displays.first(where: { CGDisplayIsBuiltin($0) == 0 })
    else {
        CGCancelDisplayConfiguration(config)
        FileHandle.standardError.write("need a built-in and an external display\n".data(using: .utf8)!)
        exit(1)
    }
    // The built-in display copies the external one, so the glasses keep their native mode.
    CGConfigureDisplayMirrorOfDisplay(config, builtin, external)
    print("mirror on")
}

let result = CGCompleteDisplayConfiguration(config, .forSession)
if result != .success {
    FileHandle.standardError.write("display configuration failed: \(result.rawValue)\n".data(using: .utf8)!)
    exit(1)
}
