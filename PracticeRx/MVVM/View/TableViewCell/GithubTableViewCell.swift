//
//  GithubTableViewCell.swift
//  PracticeRx
//
//  Created by 三浦　登哉 on 2021/06/12.
//

import UIKit

final class GithubTableViewCell: UITableViewCell {

    @IBOutlet private weak var fullNameLabel: UILabel!
    
    func configure(model: GithubModel) {
        fullNameLabel.text = model.fullName
    }
}
