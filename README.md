# Wine Steam

Install Wine Steam on Linux without pain and hassle.

## Contents
1. [Prerequisites](#prerequisites)
2. [Usage](#usage)
3. [Tools](#tools)
   - [Adding as an App](#adding-as-an-app)
   - [4GB Patcher](#4gb-patcher)
   - [NEOTOKYO° 4GB patcher](#neotokyo-4gb-patcher)
3. [Install Location](#install-location)

## Prerequisites

- `wine` - used to Steam.
- `winetricks` - needed to create and set up the Steam wineprefix.
- `unzip` - used to unzip some Windows packages.

## Usage

Simply run `bash winesteam.sh`!

The utility starts Steam if the installation is complete or runs the setup if otherwise.

During setup a Wine configuration menu may appear. It is recommended that you enable `Graphics` -> `Emulate a virtual desktop` for better image quality in games and to always have an equivalent of windowed fullscreen mode regardless of game settings (Recommended setting for NEOTOKYO°). If you're unsure of what to change, just click `OK`.

If you're unable to log into Steam via QR code, try restarting and using manual log in instead. Sometimes it may take several tries to log in.

It is recommended to use `View` -> `Small Mode` in Steam to minimize crashes and bugs.

Read [Adding as an App](#adding-as-an-app) for adding Wine Steam to your applications launcher.

## Tools

### Adding as an App

If you wish to install Wine Steam into your app launcher, run `bash install_desktop.sh`. This will add the Wine Steam desktop launcher into your applications menu. You might need to restart your computer for the Wine Steam icon to cache.

### Prefix Configuration

Run `bash winesteamcfg.sh` to access the Wine configuration menu for your Wine Steam prefix.

### 4GB Patcher

32bit games and software often require more memory for better performance, but are limited to 2GB of RAM by default. To aid that, run `bash 4gbpatch.sh <executable path>` (without angle brackets) to patch the program.

The script is using the patch from https://ntcore.com/?page_id=371.

### NEOTOKYO° 4GB patcher

You can use `bash nt4gbpatch.sh` to apply 4GB patch to an existing [NEOTOKYO°](https://store.steampowered.com/app/244630/NEOTOKYO/) installation inside Wine Steam. You need to have Wine Steam set up and NEOTOKYO° installed in it for the patch to do its magic.

The script is using [`4gbpatch.sh`](#4gb-patcher).

## Install Location

After the setup, the prefix is located at `.winesteam/prefix` in your home directory.

#### Made with 💜 by Gleammer.
