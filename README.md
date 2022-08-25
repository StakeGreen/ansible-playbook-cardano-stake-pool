## Overview

## Overview

The [Ansible cardano-node](https://github.com/moaipool/ansible-cardano-node) repository contains an [Ansible](https://www.ansible.com/) playbook for provisioning secure, optimized Cardano nodes for Stake Pool Operators (SPOs). 
It was originally developed by the [MOAI Pool](https://moaipool.com/) (Ticker: **MOAI**) operators. 

Further improved and extended by [Stake Green Pool](https://www.stakegreen.com/) (Ticker: **STKGR**)

This setup is originally created for a setup with 2 relays, 1 block producer and 1 monitoring node but can easily be changed to fit your needs.

The following is handled out of the box:
* Basic Linux security (SSH hardening, firewall setup, etc.)
* Installation of a cardano-node (compiled from IOHK source)
* Base configuration for block producer, relay nodes and monitoring nodes
* Setup of administration & monitoring tools (cncli, gLiveView, etc.)

## Changes and improvements we have added 
- Added monitoring with Grafana and Prometheus
- Added Chrony for more actual time sync and less missed scheduled leader checks
- Added more scripts for easy maintenance and transactions 
- Added swap configuration and setup to the playbook
- Cardano node was being killed forcefully now killing gracefully which results in quicker restarts
- Optimised Cardano run with the addition of some RTS parameters
- Disabled ipv6 network configuration
- Removed the usage of ansible Vault for now. For secret ssh credentials we are using the [ssh agent](https://www.ssh.com/academy/ssh/add-command) instead.

## Contents

- [User setup](#user-setup)
- [Running a playbook](#running-a-playbook)
- [Base configuration](#base-configuration)
- [Pro tips](#pro-tips)

### User setup

We enhance security and ease of use by requiring public key authentication for our user accounts. Thereafter, Ansible
only interacts via the **deploy** account.

1. Start by creating the **deploy** user:

   ```
   useradd deploy
   mkdir /home/deploy
   mkdir /home/deploy/.ssh
   chmod 700 /home/deploy/.ssh
   chown -R deploy:deploy /home/deploy
   ```

Set a strong password for the new user: `passwd deploy`. You'll use this once when adding your public key in the next
step. Thereafter passwords won't be needed by Ansible.

2. Securely copy the public key from your workstation to the remote host (relay1.mypool.com, in this example):

   ```
   ssh-copy-id -i ~/.ssh/id_rsa.pub deploy@relay1.mypool.com
   
   The authenticity of host 'relay1.mypool.com (<no hostip for proxy command>)' can't be established.
   ECDSA key fingerprint is SHA256:HRTSF5/nHJDKEiNDvHAA6OhxF9whXl4o7O1KwuW6Fbd0.
   Are you sure you want to continue connecting (yes/no)? yes
   /usr/local/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
   /usr/local/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
   deploy@relay1.mypool.com's password:
   
   Number of key(s) added: 1
   ```

Now try logging into the machine with `ssh deploy@relay1.mypool.com` to verify that the key was added successfully.

3. Use visudo to grant sudo access to the deploy user and don't require a password each time:

```
visudo
```

Comment all existing user/group grant lines and add:

```
# User privilege specification
root    ALL=(ALL:ALL) ALL
deploy  ALL=(ALL) NOPASSWD:ALL
	
# Allow members of group sudo to execute any command
%sudo  ALL=(ALL:ALL) NOPASSWD:ALL

```

Login as the deploy user and verify that you have sudo access with the -v (validate) option:

```
sudo -v
```

You will probably want to change the default shell to bash:

```
sudo chsh -s /bin/bash deploy
```

### Base configuration

A set of known-good base settings are provided in this playbook. Where applicable, under each role you will find a file
called `/defaults/main.yml`. These files contain default values for variables and should be modified prior to
provisioning a live host. For example, the `ssh` role applies several Linux security best practices to harden secure
shell access to your nodes. The file `ssh/defaults/main.yml` should be modified to match your remote administration IP
address (that is, the machine you execute Ansible from):

The placeholder values for the relay nodes above must agree with your real relay host IP addresses, else they will not
be able to communicate with the block producer or each other.

Complete list of files that need to be modified:
- group_vars/all.yml
- inventories/block-producer/group_vars/node.yml
- inventories/block-producer/inventory
- inventories/monitor/group_vars/node.yml
- inventories/monitor/inventory
- inventories/relay-node/inventory
- roles/cardano-node/files/cardano-producer-files/payment.addr
- roles/cardano-node/files/cardano-producer-files/stakepoolid.txt
- roles/ssh/defaults/main.yml
- roles/ufw/defaults/main.yml

### Running the playbook

An example playbook execution is shown below. This playbook targets the `relay-node`.
The optional `--tags` specify tasks tagged as "configuration" settings. Finally the `--check` mode is a "dry run" option
that does not make any changes on remote systems:

```
ansible-playbook provision.yml -i inventories/relay-node --tags "install" --check
```

The process above includes downloading and compiling `cardano-node` from source, along with the latest dependencies, if
needed.

### Version control
If you would like to keep your modified playbook also in version control it's possible create a private for of a public repo. This [guide](https://junyonglee.me/github/How-to-make-forked-private-repository/) explains it clearly. That way you will be able to receive updates from our repository. 
Unfortunately Github doesn't support forking a public repository privately by default.   
