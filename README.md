# Wine Steam

Install Wine Steam on Linux without pain and hassle.

> Works great with NEOTOKYO.
> <br>&emsp;&emsp;- Dalem_master

## Contents
1. [Prerequisites](#prerequisites)
2. [Usage](#usage)
3. [Uninstalling](#uninstalling)
4. [Tools](#tools)
   - [Adding as an App](#adding-as-an-app)
   - [Winetricks](#winetricks)
   - [Prefix Configuration](#prefix-configuration)
   - [4GB Patcher](#4gb-patcher)
   - [DXVK Patch](#dxvk-patch)
   - [Visual C++ Runtimes Installer](#visual-c-runtimes-installer)
5. [Install Location](#install-location)
6. [Known issues](#known-issues)
   - [NEOTOKYO° issues](#neotokyo-issues)

## Prerequisites

- `winetricks` - needed to create and set up the Steam wineprefix. 🪄
- `util-linux` - used for network namespaces. 🌐
- (optional) `zenity` or `kdialog` - GUI frontends. ✨

## Usage

Simply run `bash winesteam.sh`!

The utility starts Steam if the installation is complete or runs the setup if otherwise.

You will be asked a few questions at the start of the setup via your terminal or via GUI if you have `zenity` or `kdialog` installed.

During setup a Wine configuration menu may appear. It is recommended that you enable `Graphics` -> `Emulate a virtual desktop` for better image quality in games and to always have an equivalent of windowed fullscreen mode regardless of game settings (recommended setting for NEOTOKYO°). If you're unsure of what to change, just click `OK`.

If you're unable to log into Steam via QR code, try restarting and using manual log in instead. Sometimes it may take several tries to log in.

It is recommended to use `View` -> `Small Mode` in Steam to minimize crashes and bugs.

Read [Adding as an App](#adding-as-an-app) for adding Wine Steam to your applications launcher.

## Uninstalling

To uninstall WineSteam, run `bash uninstall.sh` and enter "y" to confirm.  
You will be able to install it again by running `bash winesteam.sh`.

## Tools

### Adding as an App

If you wish to install Wine Steam into your app launcher, run `bash install_desktop.sh`. This will add the Wine Steam desktop launcher into your applications menu. You might need to restart your computer for the Wine Steam icon to cache.

### Winetricks

To get access to the various winetricks tools and utilities for your Wine Steam prefix, run `bash winetricks.sh` and choose `Select the default wineprefix`.

### Prefix Configuration

Run `bash winesteamcfg.sh` to access the Wine configuration menu for your Wine Steam prefix.

### 4GB Patcher

WineSteam is now using `WINE_LARGE_ADDRESS_AWARE=1` with Wine GE, so **the 4GB Patcher is no longer required**. It is kept here for archiving purposes.

32bit games and software often require more memory for better performance, but are limited to 2GB of RAM by default. To aid that, run `bash 4gbpatch.sh <executable path>` (without angle brackets) to patch the program.

The script is using the patch from https://ntcore.com/?page_id=371.

### DXVK Patch

Direct3D is part of directx APIs that allows 3d graphics on windows, this patch applies transition layer from Direct3D to Vulkan.

Some people don't need this patch, if your games work without it, **DON'T APPLY IT**.

It is strongly recommended that, if you need DXVK for some games, you **try using Proton** in native Steam for these games first.

To apply the DXVK patch, run `bash dxvkpatch.sh`.

### Visual C++ Runtimes Installer

Visual C++ runtimes are no longer installed by default as they tend to break Wine Steam installations. If you have tried using Wine Steam before this notice appeared and it did not work, do try again.

Only run `bash vcruntimes.sh` if your desired game doesn't work. This may fix or create bugs and crashes in your Wine Steam games and applications.

## Install Location

After the setup, the prefix is located at `.winesteam/prefix` in your home directory.

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
- While running command `!motd` on BonAHNSa server, game crashes with C++ runtime error.
   - Fixed by running the [Visual C++ Runtimes Installer](#visual-c-runtimes-installer). **This installer is known to break NEOTOKYO° online games entirely on some systems, make sure to back up your prefix before using it**.

#### Made with 💜 by Gleammer.
