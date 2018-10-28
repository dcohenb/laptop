Laptop
======

Laptop is a script to set up an macOS laptop for my own personal environment.
It can be run multiple times on the same machine safely.


Install
-------

Download the script:

```sh
curl --remote-name https://raw.githubusercontent.com/dcohenb/laptop/master/mac
```

Review the script (avoid running scripts you haven't read!):

```sh
less mac
```

Execute the downloaded script:

```sh
sh mac 2>&1 | tee ~/laptop.log
```

review the log:

```sh
less ~/laptop.log
```


What it sets up
---------------

macOS tools:

* [Homebrew] for managing operating system libraries.

[Homebrew]: http://brew.sh/

Tools:

* [Google Chrome] for Surfing the web
* [Visual Studio Code] for Project code editing
* [Sublime Text] for general text file editing
* [Spectacle] for moving windows around easily
* [Alfred] for productivity
* [iTerm2] for improved terminal capabilities
* [Zsh] as your shell

[Google Chrome]: https://www.google.com/chrome/
[Visual Studio Code]: https://code.visualstudio.com/
[Sublime Text]: https://www.sublimetext.com/
[Spectacle]: https://www.spectacleapp.com/
[Alfred]: https://www.alfredapp.com/
[iTerm2]: https://www.iterm2.com/
[Zsh]: http://www.zsh.org/

Programming languages, package managers, and configuration:

* [Docker] for development
* [Node.js] and [NPM], for running apps and installing JavaScript packages

[Docker]: https://www.docker.com/
[Node.js]: http://nodejs.org/
[NPM]: https://www.npmjs.org/

Global Node.js packages:

* [n] for managing node.js versions
* [http-server] for serving static files
* [nodemon] for node development hot reload

[n]: https://www.npmjs.com/package/n
[http-server]: https://www.npmjs.com/package/http-server
[nodemon]: https://www.npmjs.com/package/nodemon

It should take less than 10 minutes to install (depends on your machine).


Default settings & setup
------------------------

1. Change the keyboard repeat speed to minimum allowed for faster response time

2. Create a new ssh key

