Mac-OS-X-Software-Uninstaller
=============================

An AppleScript to provide a comfortable way for removing installed packages from the system.

## Description

On Mac OS X you can simply install applications doing _Drag & Drop_ of the application bundles into the application folder.
Also this simple is to remove these application bundles from your system by doing _Drag & Drop_ of them into the trash.

But many kind of software is distributed within a package bundle which needs to be installed on your system. 
The package installer spreads all the files across your system. 
Removing them afterwards is a little bit tricky.

The solution: Mac OS X provides the command line tool [pkgutil](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/10.6/man1/pkgutil.1.html?useVersion=10.6) to handle installed package bundles.
As described in the article [Uninstalling packages (.pkg files) on Mac OS X](https://wincent.com/wiki/Uninstalling_packages_%28.pkg_files%29_on_Mac_OS_X) this software acts as GUI Wrapper to _pkgutil_ for the _--unlink_ command which was present in Mac OS X 10.5 Leopard.

## Requirements

This software was succesfully tested on Mac OS X 10.6 Snow Leopard, Mac OS X 10.7 Lion and OS X 10.8 Mountain Lion respectively.

## Disclaimer

Use this software at your own risk!

## Related articles:

* [Uninstalling packages (.pkg files) on Mac OS X](https://wincent.com/wiki/Uninstalling_packages_%28.pkg_files%29_on_Mac_OS_X)

## Related software

* [UninstallPKG](http://www.corecode.at/uninstallpkg/index.html)
* [Pacifist](http://www.charlessoft.com/)
