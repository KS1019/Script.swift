#!/usr/bin/swift sh

import Scripting // KS1019/Script.swift ~> main

Script()
    .stdin()
    .map { "Received input: \($0). Test is working. Yay." }
    .stdout()