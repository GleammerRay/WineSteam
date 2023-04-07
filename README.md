# Wine Steam
**THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND**
Install Wine Steam on Linux without pain and hassle.

> Works great with NEOTOKYO.
> <br>&emsp;&emsp;- Dalem_master

## Contents
1. [Prerequisites](#prerequisites)
2. [Usage](#usage)
3. [To apply patches or not? ](to-apply-patches-or-not)
4. [Tools](#tools)
   - [Adding as an App](#adding-as-an-app)
   - [Winetricks](#winetricks)
   - [Prefix Configuration](#prefix-configuration)
   - [4GB Patcher](#4gb-patcher)
   - [DXVK Patch](#dxvk-patch)
   - [Visual C++ Runtimes Installer](#visual-c-runtimes-installer)
   - [NEOTOKYO° 4GB patcher](#neotokyo-4gb-patcher)
5. [Install Location](#install-location)
6. [Known issues](#known-issues)
   - [NEOTOKYO° issues](#neotokyo-issues)

## Prerequisites

- `wine` - used to Steam. 💨
- `winetricks` - needed to create and set up the Steam wineprefix. 🪄
- `unzip` - used to unzip some Windows packages. 📦

## Usage

Simply run `bash winesteam.sh` or  `bash altwinesteam.sh` (to know wich one to run read  [To apply patches or not? ](to-apply-patches-or-not))

The utility starts Steam if the installation is complete or runs the setup if otherwise.

During setup a Wine configuration menu may appear. It is recommended that you enable `Graphics` -> `Emulate a virtual desktop` for better image quality in games and to always have an equivalent of windowed fullscreen mode regardless of game settings (recommended setting for NEOTOKYO°). If you're unsure of what to change, just click `OK`.

If you're unable to log into Steam via QR code, try restarting and using manual log in instead. Sometimes it may take several tries to log in.

It is recommended to use `View` -> `Small Mode` in Steam to minimize crashes and bugs.  [Known issues](#known-issues)

Read [Adding as an App](#adding-as-an-app) for adding Wine Steam to your applications launcher.

## To apply patches or not?
This script includes two patches ([1](#dxvk-patch) [2](#visual-c-runtimes-installer) ) that are either required to even launch steam or might break your entire wine prefix!

What seems to cuase (or not) issues is driver in use, proprietary nvida drivers for newer cards (10 series and up) seem to not need the patches, it will probably break your prefix. (use `winesteam.sh` and continue as normal)

Nouveau open source driver as well as proprietary nvida driver for older cards (tested on GTX 750 ti) and possibly amd drivers? (not tested) seem to not even launch steam without the patches (use `altwinesteam.sh` or run normal setup and apply patches manually)

Great way to check if you need patches or not is to run NEOTOKYO with proton using native steam (if you can play local maps then run the patches)

## Tools

### Adding as an App

If you wish to install Wine Steam into your app launcher, run `bash install_desktop.sh`. This will add the Wine Steam desktop launcher into your applications menu. You might need to restart your computer for the Wine Steam icon to cache.

### Winetricks

To get access to the various winetricks tools and utilities for your Wine Steam prefix, run `bash winetricks.sh` and choose `Select the default wineprefix`.

### Prefix Configuration

Run `bash winesteamcfg.sh` to access the Wine configuration menu for your Wine Steam prefix.

### 4GB Patcher

32bit games and software often require more memory for better performance, but are limited to 2GB of RAM by default. To aid that, run `bash 4gbpatch.sh <executable path>` (without angle brackets) to patch the program.

The script is using the patch from https://ntcore.com/?page_id=371.

### DXVK Patch

Direct3D is part of directx APIs that allows 3d graphics on windows, this patch applies transition layer from Direct3D to Vulkan.

Some people don't need this patch, if your games work without it, **DON'T APPLY IT**.

It is strongly recommended that, if you need DXVK for some games, you **try using Proton** in native Steam for these games first.

To apply the DXVK patch, run `bash dxvkpatch.sh`.

Package source: https://github.com/doitsujin/dxvk/releases/tag/v2.0.

### Visual C++ Runtimes Installer

Visual C++ runtimes are no longer installed by default as they tend to break Wine Steam installations. If you have tried using Wine Steam before this notice appeared and it did not work, do try again.

Only run `bash vcruntimes.sh` if your desired game doesn't work. This may fix or create bugs and crashes in your Wine Steam games and applications.

### NEOTOKYO° 4GB patcher

You can use `bash nt4gbpatch.sh` to apply 4GB patch to an existing [NEOTOKYO°](https://store.steampowered.com/app/244630/NEOTOKYO/) installation inside Wine Steam. You need to have Wine Steam set up and NEOTOKYO° installed in it for the patch to do its magic.

*NOTE: the patch is not actually 4GB in size.*

The script is using [`4gbpatch.sh`](#4gb-patcher).

## Install Location

After the setup, the prefix is located at `.winesteam/prefix` in your home directory.

## Uninstall
To uninstall winesteam simply run `rm -dir .winesteam/` in your home directory.
*NOTE: this will remove everything from prefix and will be impossible to recover*

## Known issues

- Steam client is laggy.
   - Use Steam small mode (click on `View` -> `Small Mode` in the Steam client for a more basic, yet more stable UI).
- Log in using QR code is buggy and doesn't always work.
   - Using manual sign in often works better.

### NEOTOKYO° issues
- Wine program error `The program hl2.exe has encuntered a serious problem and needs to close`.
   - Fixed by using the [4GB Patcher](#4gb-patcher) or lowering texture quality.
- While sending client info, `Microsoft Visual C++ Runtime error` appears.
   - Fixed by applying the [DXVK patch](#dxvk-patch).
- Broken font.
   - Are you sure you didn't skip font installation by accident?
- While running command `!motd` on BonAHNSa server, game crashes with C++ runtime error (will fix the crash but window will not display anything, you can read it on BonAHNSa's website)
   - Fixed by running the [Visual C++ Runtimes Installer](#visual-c-runtimes-installer). **This installer is known to break NEOTOKYO° online games entirely on some systems, make sure to back up your prefix before using it** ([To apply patches or not? ](to-apply-patches-or-not)).
- While changing maps error "Couldn't CRC map `map name.bsp` disconnecting." This error appears on windows as well as on linux in some source games. To fix it download the map manually and put it inside`NEOTOKTO` -> `NeotokyoSource` -> `maps` (for quick acces to game file click on game properties and on "browse local files"), if asked to replace file say yes.
if playing on BonAHNSa template for map file download would look like this:`https://bonahnsa.site.nfoservers.com/neotokyo/maps/nt_map_name_ctg.bsp`.

#### Made with 💜 by Gleammer.
