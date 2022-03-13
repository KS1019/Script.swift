#!/usr/bin/swift sh

import ScriptSwift // KS1019/Script.swift ~> main

Script()
    .exec(#"echo "testing""#)
    .stdout()
