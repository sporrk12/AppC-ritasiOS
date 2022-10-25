//
//  CustomCell3.swift
//  Caritas
//
//  Created by Emmanuel  Granados on 17/10/22.
//

import UIKit

class CustomCell3: UITableViewCell {

    @IBOutlet weak var usuarioPersona: UILabel!
    @IBOutlet weak var fotoPersona: UIImageView!
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var nombrePersona: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
