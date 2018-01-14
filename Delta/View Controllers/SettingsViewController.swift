//
//  SettingsViewController.swift
//  Delta
//
//  Created by Dino Constantinou on 14/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit
import FormKit

final class SettingsViewController: FormViewController {
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Settings", comment: "Settings")
        navigationItem.rightBarButtonItem = UIBarButtonItem(type: .done, target: self, action: #selector(self.done))
        
        let row = FormRow()
        row.title = NSLocalizedString("Player 1", comment: "Player 1")
        row.configureCell = { cell in
            cell.accessoryType = .disclosureIndicator
        }

        let section = FormSection()
        section.header = FormSectionHeaderFooter(title: NSLocalizedString("Controllers", comment: "Controllers").uppercased())
        section.appendFormRow(row)
        
        let form = Form()
        form.appendFormSection(section)

        self.form = form
    }
    
    // MARK: - Private Methods
    
    @objc private func done() {
        dismiss(animated: true, completion: nil)
    }
    
}
