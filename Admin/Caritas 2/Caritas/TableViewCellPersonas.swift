//
//  TableViewCellPersonas.swift
//  Caritas
//
//  Created by Emmanuel  Granados on 06/10/22.
//

import UIKit

class TableViewCellPersonas: UITableViewCell {

    @IBOutlet weak var personaView: UIView!
    
    @IBOutlet weak var personaImgView: UIImageView!
    
    @IBOutlet weak var lbNombreView: UILabel!
    
    @IBOutlet weak var lbUsuarioView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
