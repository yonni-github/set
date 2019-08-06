//
//  SetCardView.swift
//  Set
//
//  Created by Yonas on 3/6/18.
//  Copyright © 2018 SJSU. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    @IBInspectable
    var shapeInt: Int = 1 { didSet {
        switch shapeInt {
        case 1: shape = .squiggle
        case 2: shape = .oval
        case 3: shape = .diamond
        default: break
        }
        }}
    
    var shape: Shape = .oval { didSet { setNeedsDisplay(); setNeedsLayout()} }
    enum Shape {
        case squiggle
        case oval
        case diamond
    }
    
    @IBInspectable
    var shadingInt: Int = 1 { didSet {
        switch shadingInt {
        case 1: shade = .solid
        case 2: shade = .empty
        case 3: shade = .striped
        default: break
        }
        }}
    
    var shade: Shade = .solid { didSet { setNeedsDisplay(); setNeedsLayout()} }
    enum Shade {
        case solid
        case striped
        case empty
    }
    
    @IBInspectable
    var color = #colorLiteral(red: 0.06621866511, green: 0.1674839614, blue: 0.8549019694, alpha: 1)  { didSet { setNeedsDisplay(); setNeedsLayout()} }
    
    @IBInspectable
    var count: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout()} }
    
    @IBInspectable
    var selected = false { didSet { setNeedsDisplay(); setNeedsLayout()}}
    
    @IBInspectable
    var matched = false { didSet { setNeedsDisplay() }}
    
    @IBInspectable
    var misMatched = false { didSet { setNeedsDisplay() }}
    
    
    override func draw(_ rect: CGRect) {
        isOpaque = false
        let cardBackground = UIBezierPath(rect: bounds)
        UIColor.cyan.setFill()
        cardBackground.fill()
        //backgroundColor = UIColor.clear
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.black.setStroke()
        cardBackground.stroke()
        roundedRect.addClip()
        UIColor.white.setFill()
        if selected {
            UIColor.green.setFill()
        }
        if matched {
            UIColor.lightGray.setFill()
        }
        if misMatched {
            UIColor.magenta.setFill()
        }
        roundedRect.fill()
        
        drawShapes(shape, count: count)
        
    }
    
    
    private func drawShapes(_ shape: Shape, count: Int) {
        let size = CGFloat(bounds.maxX / 1.8)
        let spacing = CGFloat(0.0)
        var paths = [UIBezierPath]()
        var getPath: (CGPoint, CGFloat) -> UIBezierPath
       
        switch shape {
        case .diamond: getPath = getDiamondPath
        case .oval: getPath = getOvalPath
        case .squiggle: getPath = getSquigglePath
        }
        
        switch count {
        case 1:
            paths.append(getPath(CGPoint(x: bounds.midX, y: bounds.midY), size))
        case 2:
            paths.append(getPath(CGPoint(x: bounds.midX-(size/4+spacing), y: bounds.midY), size))
            paths.append(getPath(CGPoint(x: bounds.midX+(size/4+spacing), y: bounds.midY), size))
        case 3:
            paths.append(getPath(CGPoint(x: bounds.midX-((size/4+spacing)*2), y: bounds.midY), size))
            paths.append(getPath(CGPoint(x: bounds.midX, y: bounds.midY), size))
            paths.append(getPath(CGPoint(x: bounds.midX+((size/4+spacing)*2), y: bounds.midY), size))
        default:
            break
        }
        
        for path in paths {
            switch shade {
            case .empty:
                path.lineWidth = 3.0
                color.setStroke()
                path.stroke()
            case .solid:
                color.setFill()
                path.fill()
            case .striped:
                path.lineWidth = 3.0
                color.setStroke()
                path.stroke()
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                path.addClip()
                path.lineWidth = 3.0
                for i in stride(from: 0, to: bounds.maxY, by: 8) {
                    path.move(to: CGPoint(x: 0, y: i))
                    path.addLine(to: CGPoint(x: bounds.maxX, y: i))
                }
                path.stroke()
                context?.restoreGState()
            }
        }
    }
    
    
    private func getDiamondPath(withCenter center: CGPoint, andSize size: CGFloat) -> UIBezierPath {
        
        let width = size / 5
        let halfHeight = size / 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: center.x, y: center.y - halfHeight))    // top
        path.addLine(to: CGPoint(x: center.x + width, y: center.y)) // right
        path.addLine(to: CGPoint(x: center.x, y: center.y + halfHeight)) // bottom
        path.addLine(to: CGPoint(x: center.x - width, y: center.y)) // left
        path.close()
        return path
    }
    
    
    private func getOvalPath(withCenter center: CGPoint, andSize size: CGFloat) -> UIBezierPath {
        
        let radius = size / 6
        let height = size / 5
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: center.x, y: center.y+height), radius: radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        path.addArc(withCenter: CGPoint(x: center.x, y: center.y-height), radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        path.close()
        return path
    }
    
    private func getSquigglePath(withCenter center: CGPoint, andSize size: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        let sf = size / 100    // scale factor
        let dx = center.x - (70*sf/2) // shift x
        let dy = center.y - (size/2)    // shift y
        
        path.move(to: CGPoint(x: 17*sf+dx, y: 102*sf+dy))
        path.addCurve(to: CGPoint(x: 54*sf+dx, y: 63*sf+dy), controlPoint1: CGPoint(x: 37*sf+dx, y: 112*sf+dy),
                      controlPoint2: CGPoint(x: 60.8*sf+dx, y: 90*sf+dy))
        path.addCurve(to: CGPoint(x: 53*sf+dx, y: 27*sf+dy), controlPoint1: CGPoint(x: 51.3*sf+dx, y: 52*sf+dy),
                      controlPoint2: CGPoint(x: 42*sf+dx, y: 42*sf+dy))
        path.addCurve(to: CGPoint(x: 40*sf+dx, y: 5*sf+dy), controlPoint1: CGPoint(x: 65.6*sf+dx, y: 9.6*sf+dy),
                      controlPoint2: CGPoint(x: 58.3*sf+dx, y: 5.4*sf+dy))
        path.addCurve(to: CGPoint(x: 12*sf+dx, y: 36*sf+dy), controlPoint1: CGPoint(x: 22*sf+dx, y: 5*sf+dy),
                      controlPoint2: CGPoint(x: 19.1*sf+dx, y: 9.7*sf+dy))
        path.addCurve(to: CGPoint(x: 14*sf+dx, y: 89*sf+dy), controlPoint1: CGPoint(x: 15.2*sf+dx, y: 59*sf+dy),
                      controlPoint2: CGPoint(x: 31.5*sf+dx, y: 61.9*sf+dy))
        path.addCurve(to: CGPoint(x: 15*sf+dx, y: 104*sf+dy), controlPoint1: CGPoint(x: 10*sf+dx, y: 95*sf+dy),
                      controlPoint2: CGPoint(x: 6.9*sf+dx, y: 101*sf+dy))
        
        return path
        
    }
    
    func  createPathRotatedAroundBoundingBoxCenter(path: CGPath, radians: CGFloat) -> CGPath {
        let bounds = path.boundingBoxOfPath
        var transform = CGAffineTransform.identity
          
        .translatedBy(x: bounds.midX, y: bounds.midY)
        .translatedBy(x: -200, y: -200)
        return path.copy(using: &transform)!
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

extension SetCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.09
        static let cornerRadiusToBoundsHeight: CGFloat = 0.09
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to sie: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
