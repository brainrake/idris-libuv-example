Example code for hooking up a [libuv]() event loop based asynchronous runtime with the [Idris]() dependently typed programming language's C backend.

    > # set up build environment and start a shell in it
    > nix-shell

    $ # build the project
    $ build.sh

    $ # run it
    $ ./example1
    $ ./example2
    $ ./example3

The goal is to provide a simple [`nodejs`]()-like API for asynchronous programming, while reaping all the benefits of a dependently typed language _and_ having it compile to native code.

Since it can be cumbersome to install `Haskell` and its tools, `Idris`, and `libuv`, not to mention they can conflict with other installed versions, we use a wonderful [`nix` development environment]() to set up an immutable, reproducible, isolated environment for the project. All that is required is a few lines in [`default.nix`](default.nix).

You can see the how the build process works in [`build.sh`](build.sh)

In order to avoid setting up two Idris VMs, the `main()` function is in C. It sets up a `libuv` event loop and an Idris VM, and then calls `idris_main`.
