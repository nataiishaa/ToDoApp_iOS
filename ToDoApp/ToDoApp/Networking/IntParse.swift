//
//  IntParse.swift
//  ToDoApp
//
//  Created by Наталья Захарова on 26.07.2024.
//

import Foundation

extension Int {

     init?(_ source: Double?) {
         guard let source else { return nil }
         self.init(source)
     }

 }
