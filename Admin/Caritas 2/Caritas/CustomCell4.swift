//
//  CustomCell4.swift
//  Caritas
//
//  Created by Alberto  Guajardo on 10/18/22.
//

import UIKit

class CustomCell4: UITableViewCell {

    @IBOutlet weak var txHoras: UILabel!
    
    @IBOutlet weak var txEventoName: UILabel!
    
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
