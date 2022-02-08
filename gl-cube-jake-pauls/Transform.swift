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
}
