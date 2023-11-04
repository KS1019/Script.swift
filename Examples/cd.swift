#!/usr/bin/swift sh

import ScriptSwift // KS1019/Script.swift ~> main

let currentDir = Script().exec("pwd").asString()

let d = Script()
    .cd(to: "../")
    .cd(to: currentDir)
    .exec("pwd")
    .match(currentDir)
    .exec("echo 'Test Success'")
    .stdout()
