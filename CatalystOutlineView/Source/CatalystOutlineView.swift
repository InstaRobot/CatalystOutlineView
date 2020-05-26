//
//  CatalystOutlineView.swift
//  CatalystOutlineView
//
//  Created by Vitaliy Podolskiy on 22.05.2020.
//  Copyright © 2020 DEVLAB Studio LLC. All rights reserved.
//

import UIKit

public class CatalystOutlineView: UITableView {

    internal weak var outlineDataSource: CatalystOutlineViewDataSource?
    internal weak var outlineDelegate: CatalystOutlineViewDelegate?

    var contentNode: Node!
    var orderedContentArray: [Node] = []

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
        // we can inform cell fot its current state
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.conforms(to: ExpandCollapseDisplaying.self) {
                /* Log.debug("cell conforms to expand and collapse displaying protocol") */
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
