//
//  String.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 16/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import Foundation


extension String {
    
    var stubData: Data {
        if let filePath = Bundle.main.path(forResource: self, ofType: "json") {
            do {
                let text = try String(contentsOfFile: filePath)
                return text.data(using: .utf8)!
            } catch { print("wasn't able to find the stub")}
        }
        return "failure".data(using: .utf8)!
    }
    
    func containsIgnoringCase(_ text: String) -> Bool {
       return self.range(of: text, options: .caseInsensitive) != nil
    }
}
