# `can` 

`can` is a macOS command line utility that provides an alternative to the `rm` command. Instead of permanently deleting files and directories, `can` moves them to the user's Trash, allowing for easy recovery if needed.

## Installation

The application can be built from source by cloning the repository and running the following command which requires working versions of [Make](https://www.gnu.org/software/make/) and [Clang](https://clang.llvm.org) which come bundled with most macOS installations.

```shell
git clone https://github.com/tshakalekholoane/can && cd can
make
```
