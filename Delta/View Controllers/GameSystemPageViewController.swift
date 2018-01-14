//
//  GameSystemPageViewController.swift
//  Delta
//
//  Created by Dino Constantinou on 14/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DeltaCore
import GBADeltaCore
import GBCDeltaCore
import SNESDeltaCore

final class GameSystemPageViewController: UIViewController {

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        
        scrollView.pinToSuperviewEdges()

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        configureChildViewControllers(controllers: [
            try! GameCollectionViewController(systemID: "openemu.system.gba", core: GBA.core),
            try! GameCollectionViewController(systemID: "openemu.system.gb", core: GBC.core),
            try! GameCollectionViewController(systemID: "openemu.system.snes", core: SNES.core)
        ])
        
        scrollView.rx.contentOffset.subscribe(onNext: { [weak self] forContentOffset in
            self?.configurePageControl(forContentOffset: forContentOffset)
        }).disposed(by: bag)
        
        pageControl.rx.controlEvent(.valueChanged).subscribe({ [weak self] event in
            switch event {
            case .next:
                self?.configureScrollViewContentOffsetForPageControlCurrentPage()
            default:
                break
            }
            
        }).disposed(by: bag)
        
        configureTitle()
    }

    private func configureChildViewControllers(controllers: [UIViewController]) {
        controllers.forEach { (controller) in
            addChildViewController(controller)
            contentView.addArrangedSubview(controller.view)
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            controller.didMove(toParentViewController: self)
        }
        
        pageControl.numberOfPages = controllers.count
    }
    
    private func configurePageControl(forContentOffset contentOffset: CGPoint) {
        guard scrollView.isDragging == true && scrollView.contentSize.width > contentOffset.x else {
            return
        }
        
        let count = CGFloat(childViewControllers.count)
        let progress = contentOffset.x / scrollView.contentSize.width
        let index = Int(round(count * progress))

        pageControl.currentPage = index
        
        configureTitle()
    }
    
    private func configureScrollViewContentOffsetForPageControlCurrentPage() {
        let index = pageControl.currentPage

        guard index < childViewControllers.count, scrollView.contentSize.width > 0 else {
            return
        }
        
        scrollView.setContentOffset(
            CGPoint(
                x: (scrollView.contentSize.width / CGFloat(childViewControllers.count)) * CGFloat(index),
                y: scrollView.contentOffset.y
            ),
            animated: true
        )
        
        configureTitle()
    }
    
    private func configureTitle() {
        title = childViewControllers[pageControl.currentPage].title
    }

    // MARK: - Stored Properties
    
    private let bag = DisposeBag()
    
    // MARK: - Views

    lazy private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        
        contentView.pinToSuperviewEdges()
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        return scrollView
    }()
    
    lazy private var contentView: UIStackView = {
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .horizontal
        
        return contentView
    }()

    lazy private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.3)

        return pageControl
    }()
    
}
