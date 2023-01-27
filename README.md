# Wine Steam

Install Wine Steam on Linux without pain and hassle.

## Contents
1. [Prerequisites](#prerequisites)
2. [Usage](#usage)
3. [Install Location](#install-location)
4. [Adding as an App](#adding-as-an-app)

## Prerequisites

- `wine` - used to Steam.
- `winetricks` - needed to create and set up the Steam wineprefix.
- `unzip` - used to unzip some Windows packages.

## Usage

Simply run `bash winesteam.sh`!

The utility starts Steam if the installation is complete or runs the setup if otherwise.

During setup a Wine configuration menu may appear. If you're unsure of what to change, just click `OK`.

If you're unable to log into Steam via QR code, try restarting and using manual log in instead. Sometimes it may take several tries to log in.

It is recommended to use `View` -> `Small Mode` in Steam to minimize crashes and bugs.

If you wish to launch Wine Steam from your Linux Steam installation, simply add `winesteam.sh` as a Non-Steam Game.

## Install Location

After the setup, the prefix is located at `.winesteam/prefix` in your home directory.

## Adding as an App

If you wish to install Wine Steam into your app launcher, run `bash install_desktop.sh`. This will add the Wine Steam desktop launcher into your applications menu. You might need to restart your computer for the Wine Steam icon to cache.

#### Made with 💜 by Gleammer.
