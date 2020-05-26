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

    @IBOutlet private(set) weak var back: UIView! {
        didSet {
            back.layer.cornerRadius = 10
            back.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
            back.layer.shadowOffset = .zero
            back.layer.shadowRadius = 10
            back.layer.shadowOpacity = 0.25
        }
    }

    @IBOutlet private(set) weak var outlineView: CatalystOutlineView! {
        didSet {
            outlineView.outlineDataSource = self
            outlineView.outlineDelegate = self

            // don't forget to register your custom cell class
            outlineView.register(BasicViewCell.self, forCellReuseIdentifier: String(describing: BasicViewCell.self))
            outlineView.separatorStyle = .none
        }
    }

    var contentNodes: [Node] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        #if targetEnvironment(macCatalyst)
        view.backgroundColor = .secondarySystemBackground
        outlineView.backgroundColor = .secondarySystemBackground
        back.backgroundColor = .secondarySystemBackground
        #endif

        var nodes: [Node] = []

        for index in 0 ... 9 {
            let node = Node(object: "Node witn index \(index)", level: 1)
            for _ in 0 ... 3 {
                let subnode = Node(object: "Subnode", level: 2)
                for i in 0 ... 5 {
                    let leaf = Node(object: "Leaf with index \(i)", level: 3)
                    subnode.children.append(leaf)
                }
                node.children.append(subnode)
            }
            nodes.append(node)
        }

        contentNodes = nodes
    }

}

extension ViewController: CatalystOutlineViewDataSource {

    func outlineView(_ outlineView: CatalystOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? Node {
            return item.children.count
        }
        return contentNodes.count
    }

    func outlineView(_ outlineView: CatalystOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? Node {
            return item.children[index]
        }
        return contentNodes[index]
    }

    func outlineView(_ outlineView: CatalystOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? Node {
            return !item.isLeaf
        }
        return false
    }

}

extension ViewController: CatalystOutlineViewDelegate {

    func outlineView(_ outlineView: CatalystOutlineView?, cellForItem item: Any?) -> UITableViewCell? {
        guard
            let item = item as? Node else {
            fatalError("Cannot create Node")
        }

        if let object = item.object as? String {
            let cell = BasicViewCell(currentLevel: item.level, style: .default, reuseIdentifier: String(describing: BasicViewCell.self))
            cell.configure(with: object)
            return cell
        }

        fatalError("Cell is nil")
    }

    func outlineView(_ outlineView: CatalystOutlineView?, shouldCollapseItem item: Any?) -> Bool {
        return true
    }

    func outlineView(_ outlineView: CatalystOutlineView?, didExpandItem item: Any?) {}

    func outlineView(_ outlineView: CatalystOutlineView?, didCollapseItem item: Any?) {}

    func view(forHeader outlineView: CatalystOutlineView?) -> UIView? { nil }

    func height(forHeader outlineView: CatalystOutlineView?) -> CGFloat { 0 }

    func height(forCell outlineView: CatalystOutlineView?, ofItem item: Any?) -> CGFloat {
        return 50
    }

    func contextMenuConfiguration(for item: Any?) -> UIContextMenuConfiguration? {
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            let action1 = UIAction(title: "First menu action", attributes: [.destructive], state: .on) { _ in
                print("menu action")
            }
            let action2 = UIAction(title: "Second menu action") { _ in
                print("menu action")
            }
            let action3 = UIAction(title: "Third menu action") { _ in
                print("menu action")
            }
            let actions = [action1, action2, action3]
            return UIMenu(title: "", children: actions)
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }

}
