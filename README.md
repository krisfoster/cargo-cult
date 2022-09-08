# cargo-cult

Spins up an OCI Compute instance that it then clones a git repo into

## Pre-requisites

* OCI CLI
* jq
* git
* VS Code with the Remote SSH Extension
* Go - we use go to install the `naemgen` tool to generate unique names

## Install

```shell
bash <(curl -sL https://raw.githubusercontent.com/krisfoster/cargo-cult/main/cargo-cult) --install
```

Follow the instructions. Note, you should update your `~/.cargo-cult/config` with values needed to spin things up.

This requires that you have a compartment with a VCN in it that has an Internet gateway.

Sets up ssh config files for each instance that it spins up. These live under, `~/.ssh/config.d/`.

## Create an Instance

```shell
cargo-cult git@github.com:krisfoster/cargo-cult.git
```

If you have VS Code installed this will then open VS Code onto the repo in the new compute instance. This requires that you have the SSH Remote Extension installed in Code.

## See What Instnces You Have

```shell
cargo-cult --list
```