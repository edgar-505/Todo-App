//
//  ThemeSettings.swift
//  Todo App
//
//  Created by abdullah irianda on 24/02/21.
//

import SwiftUI

class ThemeSettings: ObservableObject {
  @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme"){
    didSet{
      UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
    }
  }
  
  private init(){}
  public static let shared = ThemeSettings()
}
