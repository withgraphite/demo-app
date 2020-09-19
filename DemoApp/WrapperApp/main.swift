//
//  main.swift
//  WrapperApp
//
//  Created by Tomas Reimers on 9/19/20.
//  Copyright © 2020 Screenplay. All rights reserved.
//

import Foundation
import UIKit
import Darwin

/**
 * In the build settings we've gone ahead and marked WrapperApp as dependend on DemoApp, this includes
 * the output framework within the bundle and lets us call it.
 *
 * You could imagine updating this code to potentially open any one of N-many included apps.
 */
let handle = dlopen("Frameworks/DemoApp.framework/DemoApp", RTLD_NOW)

/**
 * Once we have a handle to the bundle, we can ahead and grab a pointer to the main function that is
 * included  in every Mach-O (OSX's  and iOS's executable format.
 */
let sym = dlsym(handle, "main")

/**
 * We can now call the main function in a manner similar to how iOS would call it when it sets up an
 * executable to be evaluted.
 */
typealias mainFunc = @convention(c) () -> CInt
let f = unsafeBitCast(sym, to: mainFunc.self)

exit(f())
