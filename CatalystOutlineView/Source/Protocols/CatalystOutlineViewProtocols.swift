//
//  CatalystOutlineViewProtocols.swift
//  CatalystOutlineView - https://github.com/InstaRobot/CatalystOutlineView
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
