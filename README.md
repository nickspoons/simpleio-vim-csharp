# simpleio - a .NET Framework program for testing neovim stdio communication in Windows

The purpose of this repo is to provide a minimal environment to test and
demonstrate stdio communication between Windows builds of neovim and the .NET
Framework. Using the communication methods provided here, neovim **cannot
currently send messages over stdio to .NET Framework programs**.

## Build

Clone this repo to a Windows machine, and build it using `MSBuild.exe`.
Alternatively, open it in Visual Studio and compile from there.

## Usage

Start neovim with no other configuration, and source the `communicate.vim`
script:

```sh
nvim --clean -S communicate.vim
```

The `communicate.vim` script contains some simple functions and commands for
starting the server, sending messages to it, and outputting the response:

```vim
:StartServer
:SendMessage send this text to the server -
:SendMessage it will then be upper-cased and echoed back
:StopServer
```

The script contains both Vim and neovim handlers. Vim communication works using
these functions. neovim does not.
