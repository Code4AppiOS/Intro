//
//  IntroViewController.swift
//  Pods
//
//  Created by Nurdaulet Bolatov on 12/22/16.
//
//

import UIKit

final class IntroViewController: UIViewController {

    var items: [(String, UIImage)]!
    var closeTitle: String!
    var didClose: (() -> Void)? = nil

    fileprivate var prevIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    fileprivate let flowLayout = UICollectionViewFlowLayout()
    fileprivate var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = UIRectEdge()
        configureFlowLayout()
        configureCollectionView()
    }

    fileprivate func configureFlowLayout() {
        flowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }

    fileprivate func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        guard let collectionView = collectionView else { return }
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(IntroRotateCollectionViewCell.self, forCellWithReuseIdentifier: IntroRotateCollectionViewCell.identifier)
        view.addSubview(collectionView)

        let top = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal,
                                     toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal,
                                      toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal,
                                        toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal,
                                       toItem: view, attribute: .right, multiplier: 1, constant: 0)
        view.addConstraints([top, left, bottom, right])
    }

    @objc fileprivate func close() {
        dismiss(animated: true) {
            self.didClose?()
        }
    }

}

extension IntroViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            IntroRotateCollectionViewCell.identifier, for: indexPath)
            as! IntroRotateCollectionViewCell
        cell.textLabel.text = items[indexPath.item].0
        cell.imageView.image = items[indexPath.item].1
        cell.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        cell.isCloseButtonHidden = (indexPath.item != items.count - 1)
        return cell
    }

}

extension IntroViewController: UICollectionViewDelegate, UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidth = flowLayout.estimatedItemSize.width
        let progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: cellWidth) / cellWidth * 100
        prevIndexPath.row = Int(scrollView.contentOffset.x) / Int(cellWidth)
        if let cell = collectionView?.cellForItem(at: prevIndexPath) as? IntroRotateCollectionViewCell {
            cell.animateLeft(progress: progress)
        }
        let nextIndexPath = IndexPath(item: prevIndexPath.item + 1, section: prevIndexPath.section)
        if let cell = collectionView?.cellForItem(at: nextIndexPath) as? IntroRotateCollectionViewCell {
            cell.animateRight(progress: progress)
        }
    }
    
}