# cargo-cult

Spins up an OCI Compute instance that it then clones a git repo into

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

## See What Instnces You Have

```shell
cargo-cult --list
```