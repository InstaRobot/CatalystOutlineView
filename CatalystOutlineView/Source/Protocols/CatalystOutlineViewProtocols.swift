//
//  CatalystOutlineViewProtocols.swift
//  Easy Uninstaller
//
//  Created by Vitaliy Podolskiy on 24.05.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import UIKit

public protocol CatalystOutlineViewDataSource: class {
    func outlineView(_ outlineView: CatalystOutlineView, numberOfChildrenOfItem item: Any?) -> Int
    func outlineView(_ outlineView: CatalystOutlineView, child index: Int, ofItem item: Any?) -> Any
    func outlineView(_ outlineView: CatalystOutlineView, isItemExpandable item: Any) -> Bool
}

public protocol CatalystOutlineViewDelegate: class {
    func outlineView(_ outlineView: CatalystOutlineView?, cellForItem item: Any?) -> UITableViewCell?
    func outlineView(_ outlineView: CatalystOutlineView?, shouldCollapseItem item: Any?) -> Bool
    func outlineView(_ outlineView: CatalystOutlineView?, didExpandItem item: Any?)
    func outlineView(_ outlineView: CatalystOutlineView?, didCollapseItem item: Any?)
    func view(forHeader outlineView: CatalystOutlineView?) -> UIView?
    func height(forHeader outlineView: CatalystOutlineView?) -> CGFloat
    func height(forCell outlineView: CatalystOutlineView?, ofItem item: Any?) -> CGFloat

    func contextMenuConfiguration(for item: Any?) -> UIContextMenuConfiguration?
}

@objc public protocol ExpandCollapseDisplaying: class {
    func expand()
    func collapse()
}
