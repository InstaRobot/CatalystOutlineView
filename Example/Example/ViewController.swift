//
//  ViewController.swift
//  Example
//
//  Created by Vitaliy Podolskiy on 26.05.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import UIKit
import CatalystOutlineView

class ViewController: UIViewController {

    @IBOutlet private(set) weak var outlineView: CatalystOutlineView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: CatalystOutlineViewDataSource {

    func outlineView(_ outlineView: CatalystOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        <#code#>
    }

    func outlineView(_ outlineView: CatalystOutlineView, child index: Int, ofItem item: Any?) -> Any {
        <#code#>
    }

    func outlineView(_ outlineView: CatalystOutlineView, isItemExpandable item: Any) -> Bool {
        <#code#>
    }

}

extension ViewController: CatalystOutlineViewDelegate {

    func outlineView(_ outlineView: CatalystOutlineView?, cellForItem item: Any?) -> UITableViewCell? {
        <#code#>
    }

    func outlineView(_ outlineView: CatalystOutlineView?, shouldCollapseItem item: Any?) -> Bool {
        <#code#>
    }

    func outlineView(_ outlineView: CatalystOutlineView?, didExpandItem item: Any?) {
        <#code#>
    }

    func outlineView(_ outlineView: CatalystOutlineView?, didCollapseItem item: Any?) {
        <#code#>
    }

    func view(forHeader outlineView: CatalystOutlineView?) -> UIView? {
        <#code#>
    }

    func height(forHeader outlineView: CatalystOutlineView?) -> CGFloat {
        <#code#>
    }

    func height(forCell outlineView: CatalystOutlineView?, ofItem item: Any?) -> CGFloat {
        <#code#>
    }

    func contextMenuConfiguration(for item: Any?) -> UIContextMenuConfiguration? {
        <#code#>
    }

}
