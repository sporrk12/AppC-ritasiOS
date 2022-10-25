//
//  CustomCell5.swift
//  Caritas
//
//  Created by Alberto  Guajardo on 10/18/22.
//

import UIKit

class CustomCell5: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var lbEventoName: UIView!
    
    @IBOutlet weak var lbEventoNameActual: UILabel!
    
    
    
    @IBOutlet weak var imgImageEvento: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
