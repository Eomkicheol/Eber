//
//  AppDelegate.swift
//  asdfasdfasfasdfasdf
//
//  Created by myung gi son on 18/09/2019.
//  Copyright © 2019 Myung Gi Son. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  
  private let dependency: AppDependency
  
  var window: UIWindow?
  
  private override init() {
    self.dependency = AppDependency.resolve()
    self.window = dependency.window
  }
  
  init(dependency: AppDependency) {
    self.dependency = dependency
  }
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return true
  }
}
