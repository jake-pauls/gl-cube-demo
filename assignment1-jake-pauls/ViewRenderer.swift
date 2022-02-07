//
// ViewRenderer.swift
// Created by Jake Pauls
//

import Foundation
import GLKit

enum UniformData: Int {
    case UNIFORM_MVP_MATRIX = 0
    case NUM_UNIFORMS = 1
    
    func val() -> Int {
        return self.rawValue
    }
}

// Initialize this with NUM_UNIFORMS?
var uniforms = [GLint]()
