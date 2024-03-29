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

### Set the created and modified file date for all files & folders to current date

```bash
find . -exec touch '{}' \;
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

### Remove Cocoapods from a project

```bash
pod deintegrate 
```

### Remove cached version of a specific pod

```bash
pod cache clean <POD_NAME> 
```

### Remove cached version of all pods

```bash
pod cache clean --all 
```

### Lint a pod

```bash
pod lib lint 
```

### Lint a private pod

```bash
pod lib lint --sources=trunk,<REPO_NAME>
```

### Update local podspec repo

```bash
pod repo update
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

## git

### Squash commits on current branch

```bash
git checkout branchToSquash
git reset $(git merge-base main $(git branch --show-current))
git add -A
git commit -m "squashed branch"
```

### Delete local branches that have been merged on remote

```bash
git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
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
