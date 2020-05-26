//
//  NodeCell.swift
//  CatalystOutlineView
//
//  Created by Vitaliy Podolskiy on 23.05.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import UIKit

public class NodeCell: UITableViewCell {
    var currentLevel: Int = -1
}

extension NodeCell: ExpandCollapseDisplaying {

    public func expand() {
        print("cell expanded now")
    }

    public func collapse() {
        print("cell collapsed now")
    }

}
