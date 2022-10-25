//
//  ViewControllerPersonas.swift
//  Caritas
//
//  Created by Emmanuel  Granados on 06/10/22.
//

import UIKit

class ViewControllerPersonas: UIViewController {
    
    @IBOutlet weak var personasTableView: UITableView!
    
    let personas = ["Juan", "Maria", "Carlos", "Martha", "Diego"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personasTableView.delegate = self
        personasTableView.dataSource = self
        personasTableView.allowsSelection = true
        
    }

}

extension ViewControllerPersonas: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personasTableView.dequeueReusableCell(withIdentifier: "PersonasCell")as! TableViewCellPersonas
        let persona = personas[indexPath.row]
        
        cell.personaImgView.image = UIImage(named: persona)
        cell.lbNombreView.text = persona
        cell.personaView.layer.cornerRadius = 20
        
        return cell
    }
        
        
}

