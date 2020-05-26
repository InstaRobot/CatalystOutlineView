//
//  Node.swift
//  CHIOTPField - https://github.com/InstaRobot/CatalystOutlineView
//
//  Copyright © 2020 DEBLAB. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
