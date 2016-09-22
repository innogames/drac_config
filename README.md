# drac_config
Collection of shell scripts for managing iDRACs.

# How to use
* Start by copying config.sample to config and put your desired configuration there.
* Use drac_config script in the main directory with desired action and hostname(s) of DRAC(s) you want to configure.

# Supported actions
## Power management
* powerup - power on
* powerdown - power off
* hardreset - hard reset
* racreset - restart DRAC

## Log
* clrsel - clear DRAC sel
* getsel - display DRAC sel

## KVM
* view - connect to KVM

## RAID
* createraid - build a RAID1 of 2 first disks
* deleteraid - delete any existing RAIDs

## SSL (not yet supported)
* deployssl - deploy ssl certs and settings

## User management
* monuser - deploy user with limited permissions for monitoring

