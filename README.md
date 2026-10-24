<h1 align="center">Motion Tracker</h1>

Bluetooth widgets are boring, so I decided to make one that is themed around Halo for KDE Plasma 6!

<p align="center">
<img src="https://github.com/user-attachments/assets/09ea7a42-e5a0-49b1-9cef-36ffa6428f68" width="45%" />
<img src="https://github.com/user-attachments/assets/6dc66c37-6f34-4a39-ab16-213d43349c0a" width="45%" />
<img src="https://github.com/user-attachments/assets/a12a3771-07bc-4d1c-abbb-29fa266c0f34" width="45%" />
</p>

## Features

- Full Bluetooth functionality for connecting, discovering, pairing, trusting, forgetting, and blocking Bluetooth devices
- Animated motion tracker that 'tracks' each device as a randomly moving blip like you would see in the game. The blip is a different colour depending on its status, which includes discovered but not paired, paired but not connected, and connected
- An initial state with the Motion Tracker larger and giving instructions on how to start, which occurs if you have no devices connected yet
- Devices with batteries will have live update of battery status with a colour changing icon
- Widget icon changes colour depending on status, such as BT off, idle, scanning, and device connected
- Clicking on the motion tracker starts discovering nearby devices, which is set on a 60 second timer that recharges the shield, in Halo 2 style
- Clicking on the device name drops down a list that shows the type of device, MAC address, alias so you can name a device, and icons for trust, forget and block
- Messages that display when attempting to pair / connect that show when failure occurs
- Can turn Bluetooth off, which displays an animated Fog skull (since Fog turns off the motion tracker in game)

## Installation
This is a widget for KDE Plasma 6, and tested on CachyOS. It uses packages that will not work on Plasma 5, and since I haven't tested this on other distros, I might not be aware of issues for that platform, so be warned.

The Bluetooth functionality uses the bluez-qt module, so this must be installed on your system (make sure to check what package manager you use):

Arch:
```bash
sudo pacman -S bluez-qt
```
Fedora:
```bash
sudo dnf install kf6-bluez-qt
```
Debian / Ubuntu / Kubuntu:
```bash
sudo apt install qml6-module-org-kde-bluezqt
```
Make sure that your bluetooth service is running (look for active(running)):
```bash 
systemctl status bluetooth
```

If it isn't running, use the following command to enable it:
```bash
sudo systemctl enable --now bluetooth
```
Download motion-tracker.plasmoid from the releases page, right click desktop and go into edit mode, click add or manage widgets, click get new, and then install from local file

OR:
```bash
curl -LO https://github.com/FlamingPixelz/motion-tracker/releases/latest/download/motion-tracker.plasmoid
kpackagetool6 -t Plasma/Applet --install motion-tracker.plasmoid
```
And go into edit mode, add or manage widgets, and search for Motion-Tracker.

Enjoy :)

## Update / Uninstall

To update, download the latest release
```bash
curl -LO https://github.com/FlamingPixelz/motion-tracker/releases/latest/download/motion-tracker.plasmoid
kpackagetool6 -t Plasma/Applet --upgrade motion-tracker.plasmoid
```
If the old version still shows, restart Plasma
```bash
plasmashell --replace &
```
To uninstall:
```bash
kpackagetool6 -t Plasma/Applet --remove com.flamingpixelz.motionTracker
```

## Plans For Future Features

- A full settings menu that will allow you to change the colours of everything to match your own desktop, and tweak other aspects of the widget
- Being able to individually colour your connected blips from the main screen
- Add an animated star scape in the background, and a matrix-like scan effect for scanning using forerunner symbols, because animation is cool
- Add more error handling, such as limiting input for the alias name and truncating really long Bluetooth names

## Why I Made This
I'm a Software Engineering student who loves UI, programming, design, and Linux. Halo has been my favourite game series since I was 4 years old. This year I discovered the joys of Arch Linux and Linux ricing, and decided that I wanted a fully custom setup themed around Halo. I have experience using JavaScript and web design, so I was able to pick up QML very quickly. This is the first widget that I have made from scratch, and I plan to make more in a similar theme. As an engineer, I wanted to make the widget as feature complete as possible, so I plan to keep improving on it over time.

## Disclaimer
This is a fan project. I am not affiliated with Halo, Microsoft, or Halo Studies (rip) in any way. All of the icons in this widget were recreated by me using vector tools (Inkscape).
