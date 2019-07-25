//
//  IntroViewModel.swift
//  Translation Inspector
//
//  Created by Soner Yuksel on 2019-07-09.
//  Copyright © 2019 Inspector. All rights reserved.
//

import Foundation

struct IntroViewModel {
    let title: String
    let detail: String
    
    init(title: String = "Title", detail: String = "Detail") {
        self.title = title
        self.detail = detail
    }
}
