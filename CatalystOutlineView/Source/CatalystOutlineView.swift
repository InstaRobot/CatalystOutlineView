//
//  CatalystOutlineView.swift
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

public class CatalystOutlineView: UITableView {

    public weak var outlineDataSource: CatalystOutlineViewDataSource?
    public weak var outlineDelegate: CatalystOutlineViewDelegate?

    public var contentNode: Node!
    public var orderedContentArray: [Node] = []

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    public override func reloadData() {
        contentNode = Node(level: 0)
        orderedContentArray = []
        createContentNode(with: contentNode, from: nil)
        rebuildContent()

        super.reloadData()
    }

}

extension CatalystOutlineView: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderedContentArray.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = outlineDelegate?.outlineView(self, cellForItem: orderedContentArray[indexPath.row].object) else {
            fatalError("Cannot create cell")
        }
        if cell is NodeCell {
            (cell as! NodeCell).currentLevel = orderedContentArray[indexPath.row].level
        }
        return cell
    }

}

extension CatalystOutlineView: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let node = orderedContentArray[indexPath.row]
        if node.isLeaf {
            return
        }
        node.isCollapsed = !node.isCollapsed
        rebuildContent()

        var indexPaths: [IndexPath] = []

        if node.isCollapsed {
            let copied = node.copy() as! Node
            for i in 0 ..< copied.expandedCount {
                indexPaths.append(IndexPath(row: indexPath.row + i + 1, section: 0))
            }
            deleteRows(at: indexPaths, with: .fade)
            node.resetChildren()
            outlineDelegate?.outlineView(self, didCollapseItem: node.object)
        }
        else {
            for i in 0 ..< node.children.count {
                indexPaths.append(IndexPath(row: indexPath.row + i + 1, section: 0))
            }
            insertRows(at: indexPaths, with: .fade)
            outlineDelegate?.outlineView(self, didExpandItem: node.object)
        }
        // we can inform cell for its current state
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.conforms(to: ExpandCollapseDisplaying.self) {
                /* print("cell conforms to expand and collapse displaying protocol") */
            }
            if node.isCollapsed, cell.responds(to: NSSelectorFromString("collapse")) {
                cell.perform(NSSelectorFromString("collapse"))
            }
            else if cell.responds(to: NSSelectorFromString("expand")) {
                cell.perform(NSSelectorFromString("expand"))
            }
        }
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let node = orderedContentArray[indexPath.row]
        if node.isLeaf {
            return false
        }
        return true
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.item(at: indexPath)
        let height = outlineDelegate?.height(forCell: self, ofItem: item.object)
        return height ?? UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return outlineDelegate?.height(forHeader: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return outlineDelegate?.view(forHeader: self)
    }

    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return outlineDelegate?.contextMenuConfiguration(for: self.item(at: indexPath))
    }

}

// MARK: - Private Section

extension CatalystOutlineView {

    private func configure() {
        dataSource = self
        delegate = self
    }

    /// Rebuild all nodes
    private func rebuildContent() {
        let childrenInOrder = contentNode.getChildrenInOrder
        orderedContentArray = childrenInOrder
    }

    /// Get current node item for indexPath
    /// - Parameter indexPath: indexPath
    /// - Returns: current node from array
    private func item(at indexPath: IndexPath) -> Node {
        return orderedContentArray[indexPath.row]
    }

    /// Create content Node
    /// - Parameters:
    ///   - parent: parent node or nil
    ///   - item: current node or nil
    private func createContentNode(with parent: Node?, from item: Any?) {
        guard
            let outlineDataSource = outlineDataSource,
            let outlineDelegate = outlineDelegate else {
            return
        }
        let count = outlineDataSource.outlineView(self, numberOfChildrenOfItem: item)
        for index in 0 ..< count {
            let object = outlineDataSource.outlineView(self, child: index, ofItem: item)
            var level = parent?.level ?? 0
            level += 1
            let newNode = Node(level: level)
            newNode.object = object
            newNode.isCollapsed = outlineDelegate.outlineView(self, shouldCollapseItem: object)
            parent?.children.append(newNode)
            createContentNode(with: newNode, from: object)
        }
    }

}
