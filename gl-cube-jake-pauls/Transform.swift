//
// Transform.swift
// Created by Jake Pauls
//

import Foundation

@objc class Transform : NSObject {
    /**
     * Position
     */
    @objc var posX: CGFloat = 0.0
    @objc var posY: CGFloat = 0.0
    
    /**
     * Rotation
     */
    @objc var rotX: CGFloat = 0.0
    @objc var rotY: CGFloat = 0.0
    @objc var isRotating: Bool = false
    
    /**
     * Scaling (constant)
     */
    @objc var scale: CGFloat = 1.0
    
    /**
     * Resets transform to default position
     */
    @objc func reset() {
        self.posX = 0.0
        self.posY = 0.0
        
        self.rotX = 0.0
        self.rotY = 0.0
        self.isRotating = false
        
        self.scale = 1.0
    }
}
