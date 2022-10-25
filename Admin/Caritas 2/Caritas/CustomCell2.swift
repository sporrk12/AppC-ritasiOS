//
//  CustomCell2.swift
//  Caritas
//
//  Created by Alumno on 15/10/22.
//

import UIKit

class CustomCell2: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var tlNombreUsuario: UILabel!
    
    @IBOutlet weak var imgUsuario: UIImageView!
    
    @IBOutlet weak var tlFecha: UILabel!
    
    @IBOutlet weak var tlNombreEvento: UILabel!
    
    @IBOutlet weak var tlHoras: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
