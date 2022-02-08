//
//  GestureSet.swift
//  Created by Jake Pauls
//

import Foundation

class GestureSet {
    private var viewRenderer: ViewRenderer
    private var referencePoint: CGPoint
    
    init(viewRenderer: ViewRenderer) {
        self.viewRenderer = viewRenderer
        self.referencePoint = CGPoint(x: 0.0, y: 0.0)
    }
    
    /**
     * Helper function to set the initial reference CGPoint
     */
    private func setReferencePoint(x: CGFloat, y: CGFloat) {
        self.referencePoint = CGPoint(x: x, y: y)
    }
    
    /**
     * Helper function to setup gesture recognizers
     */
    func setupGestureRecognizers(view: UIView) {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGesture(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.singlePanGesture(_:)))
        pan.maximumNumberOfTouches = 2
        view.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(_:)))
        view.addGestureRecognizer(pinch)
    }
    
    /**
     * Handling double-tap gesture
     * Toggles rotation
     */
    @objc func doubleTapGesture(_ recognizer: UITapGestureRecognizer) {
        viewRenderer.transform.isRotating = !viewRenderer.transform.isRotating
    }
    
    /**
     * Handling pan gestures
     * Note: Inverted the transform manipulations for a more natural control in the UI
     */
    @objc func singlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else { return }
        
        if !viewRenderer.transform.isRotating {
            let touch = recognizer.location(in: recognizer.view!)
            
            // Initialize the starting point
            if recognizer.state == .began {
                self.setReferencePoint(x: touch.x, y: touch.y)
            }
            
            // Single pan gesture (rotation) and double pan gesture (translation)
            if recognizer.numberOfTouches == 1 {
                viewRenderer.transform.rotX += (touch.y - referencePoint.y) / 100
                viewRenderer.transform.rotY += (touch.x - referencePoint.x) / 100
                
                self.setReferencePoint(x: touch.x, y: touch.y)
            } else if recognizer.numberOfTouches == 2 {
                viewRenderer.transform.posX += (touch.x - referencePoint.x) / 100
                viewRenderer.transform.posY += (touch.y - referencePoint.y) * -1 / 100
                
                self.setReferencePoint(x: touch.x, y: touch.y)
            }
        }
    }
    
    /**
     * Handling pinch gestures
     */
    @objc func pinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        guard recognizer.view != nil else { return }
        
        if !viewRenderer.transform.isRotating && recognizer.numberOfTouches == 2 {
            viewRenderer.transform.scale = recognizer.scale
        }
    }
}
