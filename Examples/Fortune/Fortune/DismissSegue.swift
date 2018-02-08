//
//  DismissSegue.swift
//  Fortune
//
//  Created by Edward on 2/7/18.
//  Copyright © 2018 Branch. All rights reserved.
//

import UIKit

class DismissSegue : UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
