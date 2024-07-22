//
//  TriggerViewModel.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/14.
//

import Foundation

class TriggerViewModel: ObservableObject {
    @Published var trigger: Bool = false

    func updateView() {
        trigger.toggle()
    }
}
