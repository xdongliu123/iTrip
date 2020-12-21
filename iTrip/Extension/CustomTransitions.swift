//
//  CustomTransitions.swift
//  iTrip
//
//  Created by Zoe Liu on 2020/7/8.
//  Copyright © 2020 iTrip Studio. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var flightDetailsTransition: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).combined(with: .opacity)
        let removal = AnyTransition.scale(scale: 1.0).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static func scaleDetailsTransition(anchor: UnitPoint) -> AnyTransition {
        return .modifier(active: ScaleTransition(scale: 0.1), identity: ScaleTransition(scale: 1))
    }
    
    static var opacityTransition: AnyTransition {
        let insertion = AnyTransition.scale(scale: 0.1).combined(with: .opacity)
        let removal = AnyTransition.scale(scale: 1.0).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var fly: AnyTransition {
        .modifier(active: FlyTransition(pct: 0), identity: FlyTransition(pct: 1))
    }
}

struct FlyTransition: GeometryEffect {
    var pct: Double
    
    var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotationPercent = pct
        let a = CGFloat(Angle(degrees: 90 * (1-rotationPercent)).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform1 = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        let affineTransform2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(pct * 2), y: CGFloat(pct * 2)))
        
        if pct <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }
}

struct ScaleTransition: GeometryEffect {
    var scale: CGFloat
    
    var animatableData: CGFloat {
        get { scale }
        set { scale = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        print("xxxx\(size)")
        let a = CGFloat(Angle(degrees: 90 * (1-1)).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, 1, 0, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform1 = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        let affineTransform2 = ProjectionTransform(CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale)))
        return ProjectionTransform(transform3d)
            .concatenating(affineTransform2).concatenating(affineTransform1)
            //.concatenating(affineTransform1)
        if scale <= 0.5 {
            return ProjectionTransform(transform3d).concatenating(affineTransform2).concatenating(affineTransform1)
        } else {
            return ProjectionTransform(transform3d).concatenating(affineTransform1)
        }
    }
}
