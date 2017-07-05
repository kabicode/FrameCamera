//
//  DrawingView.swift
//  Weike
//
//  Created by yake on 2017/1/10.
//  Copyright © 2017年 Kuaizai. All rights reserved.
//

import UIKit

class Line: NSCoding {
    var points: [CGPoint] = []
    var color: UIColor
    var width: CGFloat
    
    init(points: [CGPoint], color: UIColor, width: CGFloat) {
        self.points = points
        self.color = color
        self.width = width
    }
    
    func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard points.count > 0 else { return }
        let startPoint = points[0]
        context.move(to: startPoint)
        
        for i in 1..<points.count {
            let endPoint = points[i]
            context.addLine(to: endPoint)
        }
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(width)
        context.strokePath()
    }
    
    public func  encode(with aCoder: NSCoder) {
        aCoder.encode(points, forKey: "points")
        aCoder.encode(color, forKey: "color")
        aCoder.encode(width, forKey: "width")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        points = aDecoder.decodeObject(forKey: "points") as! [CGPoint]
        color = aDecoder.decodeObject(forKey: "color") as! UIColor
        width = CGFloat(aDecoder.decodeFloat(forKey: "width"))
    }
}

class DrawingView: UIView {
    static let defaultColor = UIColor.red
    static let defaultWidth: CGFloat = 3.0
    
    var lineColor: UIColor = DrawingView.defaultColor {
        didSet {
            drawingLine.color = lineColor
        }
    }
    var lineWidth: CGFloat = DrawingView.defaultWidth {
        didSet {
            drawingLine.width = lineWidth
        }
    }
    
    var lines: [Line] = []
    var deletedLines: [Line] = []
    var drawingLine = Line(points: [], color: defaultColor, width: defaultWidth)
    
    // has new difference since generate image last time
    var hasNewDifference = false
    var generatedImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(lineWidth)
        context.setLineJoin(.round)
        context.setLineCap(.round)

        for line in lines {
            line.draw()
        }
        drawingLine.draw()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        drawingLine.points.append(point)
        setNeedsDisplay()
        hasNewDifference = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endDrawingLine()
    }
    
    private func endDrawingLine() {
        drawingLine.width = lineWidth
        drawingLine.color = lineColor
        lines.append(drawingLine)
        drawingLine = Line(points: [], color: lineColor, width: lineWidth)
    }
    
    func undo() {
        guard !lines.isEmpty else { return }
        let line = lines.removeLast()
        deletedLines.append(line)
        setNeedsDisplay()
        hasNewDifference = true
    }
    
    func redo() {
        guard !deletedLines.isEmpty else { return }
        let line = deletedLines.removeLast()
        lines.append(line)
        setNeedsDisplay()
        hasNewDifference = true
    }
    
    func clear() {
        lines.removeAll()
        deletedLines.removeAll()
        drawingLine = Line(points: [], color: lineColor, width: lineWidth)
        setNeedsDisplay()
        hasNewDifference = true
    }
    
    func getImage() -> (changed: Bool, image: UIImage?) {
        if !hasNewDifference {
            return (false, generatedImage)
        }
        UIGraphicsBeginImageContext(bounds.size)
        // get current context after beginning image context, 
        // otherwise UIGraphicsGetCurrentContext() return nil
        guard let context = UIGraphicsGetCurrentContext() else {
            return (false, nil)
        }
        layer.render(in: context)
        generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        hasNewDifference = false

        return (true, generatedImage)
    }
}
