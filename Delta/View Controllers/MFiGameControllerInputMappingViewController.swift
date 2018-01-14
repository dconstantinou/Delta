//
//  MFiGameControllerInputMappingViewController.swift
//  Delta
//
//  Created by Dino Constantinou on 14/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit
import DeltaCore

final class MFiGameControllerInputMappingViewController: UIViewController, GameControllerReceiver {

    // MARK: - Init

    init(controller: MFiGameController, type: GameType) {
        self.type = type
        self.controller = controller
        self.inputMapping = GameControllerInputMapping(gameControllerInputType: .mfi)
        
        super.init(nibName: nil, bundle: nil)

        controller.addReceiver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(controllerView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewBounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)

        // Layout ControllerView
        if
            let controllerSkin = self.controllerView.controllerSkin,
            let traits = self.controllerView.controllerSkinTraits,
            let aspectRatio = controllerSkin.aspectRatio(for: traits)
        {
            var frame = AVMakeRect(aspectRatio: aspectRatio, insideRect: viewBounds)
            
            if self.view.bounds.height > self.view.bounds.width
            {
                // The CGRect returned by AVMakeRect is centered inside the parent frame.
                // This is fine for landscape, but when in portrait, we want controllerView to be pinned to the bottom of the parent frame instead.
                frame.origin.y = self.view.bounds.height - frame.height
                
                if #available(iOS 11.0, *)
                {
                    if let window = self.view.window, traits.device == .iphone, self.controllerView.overrideControllerSkinTraits == nil
                    {
                        let defaultTraits = ControllerSkin.Traits.defaults(for: window)
                        if defaultTraits.displayType == .edgeToEdge && traits.displayType == .standard
                        {
                            // This is a device with an edge-to-edge screen, but controllerView's controllerSkinTraits are for standard display types.
                            // This means that the controller skin we are using doesn't include edge-to-edge assets, and we're falling back to standard assets.
                            // As a result, we need to ensure controllerView respects safe area, otherwise we may have unwanted cutoffs due to rounded corners.
                            
                            frame.origin.y -= self.view.safeAreaInsets.bottom
                        }
                    }
                }
            }
            
            self.controllerView.frame = frame
        }
        else
        {
            self.controllerView.frame = CGRect.zero
        }
    }

    // MARK: - Private Methods
    
    @objc private func cancel() {
        
    }
    
    @objc private func save() {
        
    }
    
    func gameController(_ gameController: GameController, didActivate input: Input) {
        if gameController == controller {
            print("MFi \(input)")
        } else if gameController == controllerView {
            print("Controller View \(input)")
        }
    }
    
    func gameController(_ gameController: GameController, didDeactivate input: Input) {
        // nop
    }

    // MARK: - Views
    
    lazy private var controllerView: ControllerView = {
        let controllerView = ControllerView()
        controllerView.controllerSkin = ControllerSkin.standardControllerSkin(for: type)
        controllerView.addReceiver(self)

        return controllerView
    }()
    
    // MARK: - Stored Properties
    
    let type: GameType
    let controller: MFiGameController
    let inputMapping: GameControllerInputMapping

}
