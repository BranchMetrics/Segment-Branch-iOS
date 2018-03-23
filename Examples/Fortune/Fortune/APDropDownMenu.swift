//
//  APDropDownMenu.swift
//  Application UI Utitilties
//
//  Created by Edward Smith on 5/2/14.
//  Copyright (c) 2014 Edward Smith. All rights reserved.
//

import UIKit

struct APDropDownMenuPosition : OptionSet {
    let rawValue: UInt

    static let left     = APDropDownMenuPosition(rawValue: 0 << 0)
    static let right    = APDropDownMenuPosition(rawValue: 1 << 0)
    static let top      = APDropDownMenuPosition(rawValue: 0 << 1)
    static let bottom   = APDropDownMenuPosition(rawValue: 1 << 1)
}

private let kRowHeight: CGFloat = 38.0
private let kCellID = "DefaultCell"

class APDropDownMenu: UIView, UITableViewDataSource, UITableViewDelegate {
    var pickerItems = [Any]()
    var tableView: UITableView?
    var font: UIFont?
    var textColor: UIColor?
    private(set) var tableContainerView: UIView?
    private(set) var selectedItem: Int = 0
    var completionBlock: ((_ picker: APDropDownMenu, _ selectedItem: Int) -> Void)? = nil

    private var checkImage: UIImage?
    private var noImage: UIImage?

    init(
        view: UIView,
        position: APDropDownMenuPosition,
        items: [Any],
        selectedItem: Int,
        completion completionBlock: @escaping (_ picker: APDropDownMenu, _ selectedItem: Int) -> Void
    ) {
        let window: UIWindow = view.window!
        super.init(frame: window.bounds)
        self.selectedItem = selectedItem
        pickerItems = items
        self.completionBlock = completionBlock
        backgroundColor = UIColor.clear
        window.addSubview(self)
        let height: CGFloat = kRowHeight * CGFloat(items.count)
        let parentRect: CGRect = view.convert(view.bounds, to: nil)
        var frame = CGRect(
            x: parentRect.origin.x + 100.0,
            y: parentRect.origin.y - ((height - parentRect.size.height) / 2.0),
            width: 220.0,
            height: height
        )
        frame.origin.x = parentRect.origin.x
        frame.origin.y = parentRect.origin.y + parentRect.size.height
        if position.contains(.bottom) {
            frame.origin.y = parentRect.origin.y + parentRect.size.height
        }
        if position.contains(.right) {
            frame.origin.x = (parentRect.origin.x + parentRect.size.width) - frame.size.width
        }
        tableContainerView = UIView(frame: frame)
        tableContainerView?.backgroundColor = UIColor.white
        tableContainerView?.layer.cornerRadius = 2.00
        tableContainerView?.layer.masksToBounds = true
        tableContainerView?.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        tableContainerView?.alpha = 0.0
        UIView.animate(withDuration: 0.200, animations: {() -> Void in
            self.tableContainerView?.alpha = 1.0
            self.tableContainerView?.transform = .identity
        })
        addSubview(tableContainerView ?? UIView())
        tableView = UITableView(frame: tableContainerView?.bounds ?? CGRect.zero, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.isScrollEnabled = false
        tableView?.bounces = false
        tableView?.separatorColor = UIColor(white: 0.8, alpha: 0.5)
        tableView?.separatorStyle = .singleLine
        tableContainerView?.addSubview(tableView ?? UIView())
        let imageSize = CGSize(width: kRowHeight * 0.33, height: kRowHeight * 0.33)
        checkImage = UIImage(named: "Checkmark")?.imageWithAspectFit(size: imageSize)
        noImage = UIImage.imageWith(color: .clear, size: imageSize)
        layer.borderWidth = 0.50
        layer.borderColor = UIColor(white: 0.70, alpha: 1.0).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.00, height: 1.00)
        layer.shadowRadius = 2.00
        layer.shadowOpacity = 0.23
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        tableView?.delegate = nil
        tableView?.dataSource = nil
    }

    // MARK: - Table View Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier: kCellID)
            ?? UITableViewCell.init(style: .default, reuseIdentifier: kCellID)

        let item: Any = self.pickerItems[indexPath.row]
        if let itemString: String = item as? String {
            cell.imageView?.image = nil
            cell.textLabel?.text = itemString
        } else
        if let itemImage: UIImage = item as? UIImage {
            cell.textLabel?.text = nil;
            cell.imageView?.image = itemImage;
        }

        cell.imageView?.image =
            (indexPath.row == self.selectedItem)
            ? checkImage : noImage;

        if self.font != nil { cell.textLabel?.font = self.font }
        if self.textColor != nil { cell.textLabel?.textColor = self.textColor }
        return cell;
    }

    func dismiss() {
        if self.completionBlock != nil  {
            self.completionBlock?(self, self.selectedItem)
        }
        self.removeFromSuperview()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if event?.type == .touches {
            if let point: CGPoint = touches.first?.location(in: self) {
                if !(self.tableContainerView?.frame)!.contains(point) {
                    self.selectedItem = -1
                    self.dismiss()
                }
            }
        }
        super.touchesEnded(_: touches, with:event)
    }

    // MARK: - Table View Delegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear

        // Some of these may not be supported on all iOS versions:
        cell.separatorInset = .zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kRowHeight;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = self.tableView?.cellForRow(at: IndexPath(row: selectedItem, section: 0))
        cell?.imageView?.image = noImage

        selectedItem = indexPath.row
        cell = self.tableView?.cellForRow(at: indexPath)
        cell?.imageView?.image = checkImage

        self.tableView?.deselectRow(at:indexPath, animated:true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.20, execute: {
            self.dismiss()
        })
    }
}
