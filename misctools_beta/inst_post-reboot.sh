#!/bin/sh

set -e

## commands to run after 'reboot' 
## - sourcing commentary in /usr/src/Makefile

## TO DO: Parameterize '/usr/src' in this script
##        and ensure $PWD is {THAT DIR} before 
##        running the primary shell command
##        sequence

THIS=$(basename $(readlink -f $0))

msg() {
 echo "$THIS: $@"
}

msg "Beginning Install / Merge"

## T.D: Check / is mounted ro before remount
## N.B: A directory on removable storage media 
## will be mounted (nullfs) as /usr/src

mount -o rw /
mount /usr/src
mergemaster -p
cd /usr/src
make installworld
mergemaster -iUF
true | make delete-old
pkg-static install -f pkg

# after reboot: subsq. to ensuring statically linked ports
# are rebuilt, make delete-old-libs in /usr/src
