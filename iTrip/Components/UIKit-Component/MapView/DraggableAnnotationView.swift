//
//  DraggableAnnotationView.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/8/2.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//
import Mapbox

class DraggableAnnotationView: MGLAnnotationView {
    let movedCallBack: ((CLLocationCoordinate2D)->Void)?
    init(reuseIdentifier: String, size: CGFloat, callBack: @escaping (CLLocationCoordinate2D)->Void) {
        movedCallBack = callBack
        super.init(reuseIdentifier: reuseIdentifier)
 
// `isDraggable` is a property of MGLAnnotationView, disabled by default.
isDraggable = true
 
// This property prevents the annotation from changing size when the map is tilted.
scalesWithViewingDistance = false
 
// Begin setting up the view.
frame = CGRect(x: 0, y: 0, width: size, height: size)
 
backgroundColor = .systemRed
 
// Use CALayer’s corner radius to turn this view into a circle.
layer.cornerRadius = size / 2
layer.borderWidth = 1
layer.borderColor = UIColor.white.cgColor
layer.shadowColor = UIColor.black.cgColor
layer.shadowOpacity = 0.1
}
 
// These two initializers are forced upon us by Swift.
override init(frame: CGRect) {
    movedCallBack = nil
super.init(frame: frame)
}
 
required init?(coder aDecoder: NSCoder) {
fatalError("init(coder:) has not been implemented")
}
 
// Custom handler for changes in the annotation’s drag state.
override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
super.setDragState(dragState, animated: animated)
 
switch dragState {
case .starting:
print("Starting", terminator: "")
startDragging()
case .dragging:
print(".", terminator: "")
case .ending, .canceling:
    movedCallBack?(self.annotation!.coordinate)
print("Ending")
endDragging()
case .none:
break
@unknown default:
fatalError("Unknown drag state")
}
}
 
// When the user interacts with an annotation, animate opacity and scale changes.
func startDragging() {
UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
self.layer.opacity = 0.8
self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
}, completion: nil)
 
// Initialize haptic feedback generator and give the user a light thud.
if #available(iOS 10.0, *) {
let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
hapticFeedback.impactOccurred()
}
}
 
func endDragging() {
transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
self.layer.opacity = 1
self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
}, completion: nil)
 
// Give the user more haptic feedback when they drop the annotation.
if #available(iOS 10.0, *) {
let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
hapticFeedback.impactOccurred()
}
}
}
