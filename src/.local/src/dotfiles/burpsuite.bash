#!/bin/bash

export _JAVA_AWT_WM_NONREPARENTING=1
export JAVA_HOME=/usr/lib/jvm/java-20-openjdk

/usr/bin/burpsuite "$@"
