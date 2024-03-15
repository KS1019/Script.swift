#!/usr/bin/swift sh

import Scripting // KS1019/Script.swift ~> main

Script()
    .exec(#"echo "testing""#)
    .stdout()
