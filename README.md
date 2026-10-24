Bluetooth widgets are boring, so I decided to make one that is themed around Halo! 

This is a personal project built fully in QML for KDE Plasma on Linux, with all of the icons made using Inkscape. 

## Features:

- Full Bluetooth functionality for connecting discovering, pairing, trusting, forgetting, and blocking Bluetooth devices
- Animated motion tracker that 'tracks' each device as a randomly moving blip like you would see in the game. The blip is a different colour depending on its status, which includes discovered but not paired, paired but not connected, and connected
- An initial state with the Motion Tracker larger and giving instructions on how to start, which occurs if you have no devices connected yet
- Devices with batteries will have live update of battery status with a colour changing icon
- Widget icon changes colour depending on status, such as BT off, idle, scanning, and device connected
- Clicking on the motion tracker starts discovering nearby devices, which is set on a 60 second timer that recharges the shield, in Halo 2 style
- Clicking on the device name drops down a list that shows the type of device, MAC address, alias so you can name a device, and icons for trust, forget and block
- Messages that display when attempting to pair / connect that show when failure occurs
- Can turn Bluetooth off, which displays an animated Fog skull (since Fog turns off the motion tracker in game)

## Installation
This is a widget for KDE Plasma 6, and tested on CachyOS. It uses packages that will not work on lower versions, and since I haven't tested this on other distros, I might not be aware of issues for that platform, so be warned.

The Bluetooth functionality uses the blue-qt module, so this must be installed on your system (make sure to check what package manager you use):

Arch:
> sudo pacman -S bluez-qt

Fedora:
> sudo dnf install kf6-bluez-qt

Debian / Ubuntu / Kubuntu
> sudo apt install qnl6-module-org-kde-bluezqt

Make sure that your bluetooth service is running using (look for active(running)):
> systemctl status bluetooth

If it isn't running, use the following command to enable it:
> sudo systemctl enable --now bluetooth

Download motion-tracker.plasmoid from the releases page, right click desktop and go into edit mode, click add or manage widgets, click get new, and then install from local file

OR:
> curl -LO https://github.com/FlamingPixelz/<repo>/releases/latest/download/motion-tracker.plasmoid
> kpackagetool6 -t Plasma/Applet --install motion-tracker.plasmoid

And go into edit mode, add or manage widgets, and search for Motion-Tracker.

Enjoy :)

## Plans For Future Features

- A full settings menu that will allow you to change the colours of everything to match your own desktop, and tweak other aspects of the widget
- Being able to individually colour your connected blips from the main screen
- Add an animated star scape in the background, and a matrix-like scan effect for scanning using forerunner symbols, because animation is cool
- Add more error handling, such as limiting input for the alias name and truncating really long Bluetooth names
