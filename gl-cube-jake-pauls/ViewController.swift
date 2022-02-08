//
// ViewController.swift
// Created by Jake Pauls
//

import GLKit

extension ViewController: GLKViewControllerDelegate {
    func glkViewControllerUpdate(_ viewController: GLKViewController) {
        viewRenderer.update()
        self.updateUILabels()
    }
}

class ViewController: GLKViewController {
    private var context: EAGLContext?
    private var viewRenderer: ViewRenderer!
    private var referencePoint: CGPoint!
    private var gestureSet: GestureSet!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var rotationLabel: UILabel!
    
    @IBAction func onResetPress(_ sender: UIButton) {
        viewRenderer.transform.reset()
    }
    
    func updateUILabels() {
        let rotX = String(format: "%.2f", viewRenderer.transform.rotX)
        let rotY = String(format: "%.2f", viewRenderer.transform.rotY)
        
        let rotString = "Rot: (\(rotX), \(rotY), 0.0)"
        rotationLabel.text = rotString
        
        let posX = String(format: "%.2f", viewRenderer.transform.posX)
        let posY = String(format: "%.2f", viewRenderer.transform.posY)
        
        let posString = "Pos: (\(posX), \(posY), 0.0)"
        positionLabel.text = posString
    }
    
    private func setupGLView() {
        context = EAGLContext(api: .openGLES3)
        EAGLContext.setCurrent(context)
        
        if let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = (self as GLKViewControllerDelegate)
                        
            // Setup and load view renderer
            viewRenderer = ViewRenderer()
            viewRenderer.setup(view)
            viewRenderer.load()
            
            // Initialize gesture set
            gestureSet = GestureSet(viewRenderer: viewRenderer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGLView()
        
        // Setup gesture recognizers for the UIView
        gestureSet.setupGestureRecognizers(view: view)
        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        viewRenderer.draw(rect)
    }
}
