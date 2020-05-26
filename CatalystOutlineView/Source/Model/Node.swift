//
//  Node.swift
//  CatalystOutlineView
//
//  Created by Vitaliy Podolskiy on 23.05.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import Foundation

public class Node: NSObject, NSCopying {

    var object: Any?
    var isCollapsed = false
    var children: [Node]

    // optional: for detecting offset for child cell
    var level: Int

    init(object: Any? = nil, children: [Node] = [], level: Int = 0) {
        self.object = object
        self.children = children
        self.level = level
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = Node(object: object, children: children, level: level)
        return copy
    }

    var isLeaf: Bool {
        return children.isEmpty
    }

    /// expanded nodes count for main node
    var expandedCount: Int {
        var count = 0
        if isCollapsed || children.isEmpty {
            return count
        }
        count += children.count
        for child in children {
            count += child.expandedCount
        }
        return count
    }

    var getChildrenInOrder: [Node] {
        if object != nil && (children.isEmpty || isCollapsed) {
            return [self]
        }
        var subChildren: [Node] = []
        for child in children {
            subChildren += child.getChildrenInOrder
        }
        if object != nil {
            return [self] + subChildren
        }
        else {
            return subChildren
        }
    }

    /// reset all children nodes
    func resetChildren() {
        for child in children {
            child.isCollapsed = true
            child.resetChildren()
        }
    }

}
