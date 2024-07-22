//
//  ShakeEffect.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/10.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                amount * sin(animatableData * .pi * shakesPerUnit), y: 0))
    }
}

