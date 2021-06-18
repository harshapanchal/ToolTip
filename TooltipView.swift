import UIKit

class TooltipView : UIView
{
   var boxView = UIView()
    init(frame: CGRect, color: UIColor, shadowColor : UIColor) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        let triangleView = TriView(frame: CGRect(x: 20, y: 0, width: 17, height: 15), color: color, shadowColor: shadowColor)
        boxView = UIView(frame: CGRect(x: 5, y: triangleView.frame.height, width: frame.width-10, height: frame.height-triangleView.frame.height))
        boxView.backgroundColor = color
        boxView.roundCorner(radius: 8)
        boxView.dropShadow(color: shadowColor, opacity: 0.7, offSet: CGSize(width: 3, height: 3), radius: 3, scale: true)
        self.addSubview(triangleView)
        self.addSubview(boxView)
        self.bringSubviewToFront(triangleView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension UIView
{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius
      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func show(animated : Bool)
    {
        if let view = UIApplication.shared.keyWindow?.rootViewController?.view
        {
            view.addSubview(self)
            view.bringSubviewToFront(self)
            if animated{ self.moveIn()}
        }
    }
    
    func hide()
    {
        self.moveOut()
    }
    
    func moveIn() {
        //self.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.alpha = 0.0

        UIView.animate(withDuration: 0.24,delay: 0, options: .curveEaseIn,animations: {
            self.alpha = 1.0
        })
    }

    func moveOut() {
        UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        },completion: { _ in
            self.removeFromSuperview()
            print("View removed")
        })
    }
}

class TriView : UIView {
    var color : UIColor?
    var shadowColor : UIColor?
    init(frame: CGRect, color: UIColor, shadowColor : UIColor) {
        super.init(frame: frame)
        self.color = color
        self.shadowColor = shadowColor
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        context.setFillColor(self.color?.cgColor ?? UIColor.clear.cgColor)
        context.setShadow(offset: CGSize(width: 3, height: 3), blur: 0.7, color: self.shadowColor?.cgColor)
        context.fillPath()
    }
}
