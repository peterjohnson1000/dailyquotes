//
//  DataService.swift
//  dailyquoteswidgetExtension
//
//  Created by Peter Johnson on 3/12/24.
//

import Foundation
import SwiftUI


struct DataService {
    @AppStorage("userCategorySelection", store: UserDefaults(suiteName: "group.de.test.dailyquotes")) var userCategorySelection: String = "Motivational"
    
    func cat() -> String {
        return userCategorySelection
    }
}
