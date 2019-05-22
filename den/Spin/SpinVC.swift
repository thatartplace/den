//

import UIKit

class SpinVC: UIViewController {
    
    let trLayer = CATransformLayer()
    let shLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rotateY = CATransformLayer(rotatingFrom: 0,
                                       rotatingTo: 2 * CGFloat.pi,
                                       onAxis: (0, 1, 0),
                                       duration: 2,
                                       repeatCount: .infinity)
        let rotateX = CATransformLayer(rotatingFrom: 0,
                                       rotatingTo: 2 * CGFloat.pi,
                                       onAxis: (1, 0, 0),
                                       duration: 3,
                                       repeatCount: .infinity)
        let rotateZ = CATransformLayer(rotatingFrom: 0,
                                       rotatingTo: 2 * CGFloat.pi,
                                       onAxis: (0, 0, 1),
                                       duration: 4,
                                       repeatCount: .infinity)
        
        view.layer.addSublayer(trLayer)
        trLayer.addSublayer(rotateY)
        rotateY.addSublayer(rotateX)
        rotateX.addSublayer(rotateZ)
        rotateZ.addSublayer(shLayer)
        
        shLayer.lineWidth = 3
        shLayer.strokeColor = UIColor.cyan.cgColor
    }
    
    override func viewDidLayoutSubviews() {
        trLayer.fit(frame: view.layer.bounds)
        drawStar(layer: shLayer)
    }
    
    func drawStar(layer: CAShapeLayer) {
        let center = CGPoint(x: layer.bounds.width / 2, y: layer.bounds.height / 2)
        let radius = min(center.x, center.y)
        let offset = CGFloat.pi / 2
        
        let path = CGMutablePath()
        var prev: CGPoint?
        stride(from: offset, through: offset + 4 * CGFloat.pi, by: 4 / 5 * CGFloat.pi).forEach { rad in
            let next = CGPoint(x: center.x + radius * cos(rad), y: center.y - radius * sin(rad))
            
            if let prev = prev {
                path.move(to: prev)
                path.addLine(to: next)
            }
            prev = next
        }
        path.addLine(to: prev!)
        
        layer.path = path
    }
}
