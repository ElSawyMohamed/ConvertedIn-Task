//
//  PersonCollectionViewCell.swift
//  ConvertedinTask
//
//  Created by Mohamed El Sawy on 28/07/2023.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var knownFor: UILabel!
    @IBOutlet weak var personTitle: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
