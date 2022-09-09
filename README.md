# cargo-cult

Spins up an OCI Compute instance that it then clones a git repo into. This is very much a one repository to one compute
instance thing at the moment, though this may (or may not) change.

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

This will list VMs in **RUNNING** state along with the git repo you checked out to them

```shell
cargo-cult --list
```

## Open an Existing VM & repo in VS Code

```shell
cargo-cult --open <name-of-vm>
```

## Delete Config

This will get rid of any per VM ssh config files and also any files holding the URL of the git repo checked out to the VM

```shell
cargo-cult --nuke
```