# Useful Commands

The following is a list of useful commands for various aspects of iOS development.

## File System

### Delete derived data

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Delete Xcode archives

```bash
rm -rf ~/Library/Developer/Xcode/Archives
```

## General Commands

### Generate a UUID

```bash
uuidgen
```

### Generate a UUID with lowercase letters

```bash
uuidgen | tr ][:upper:]' '[:lower:]'
```

## Cocoapods

### Lint a pod

```bash
pod lib lint 
```

### Lint a private pod

```bash
pod lib lint --sources=trunk,<REPO_NAME>
```

## Simulator

### List all simulators

```bash
xcrun simctl list
```

### Erase all simulators

```bash
xcrun simctl erase all
```

### Delete old simulators

```bash
xcrun simctl delete unavailable
```

### Delete app by bundle id

```bash
xcrun simctl uninstall booted <BUNDLE_IDENTIFIER>
```

### Record a video

```bash
xcrun simctl io booted recordVideo --codec=h264 --mask=black --force output.mov
```

## FFmpeg

### Preview sizes for App Store videos (sizes in portrait)
 - 750 x 1334 iPhone
 - 886 x 1920 iPhone Pro Max
 - 900 x 1200 iPad 9.7
 - 1080 x 1920 iPhone Plus
 - 1200 x 1600 iPad Pro 12.9

### Resize a video

```bash
ffmpeg -i input.mp4 -s <WIDTH>x<HEIGHT> -c:a copy ouput.mp4
```

### Resize a video to precise dimensions

```bash
ffmpeg -i input.mp4 -strict -2 -vf scale=<WIDTH>x<HEIGHT> -aspect 1.779 output.mp4
```

### Rotate a video, right by 90 degrees

```bash
ffmpeg -i input.mp4 -vf "transpose=1" output.mp4
```
