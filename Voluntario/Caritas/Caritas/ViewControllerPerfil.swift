//
//  ViewControllerPerfil.swift
//  Caritas
//
//  Created by Alumno on 06/10/22.
//

import UIKit

class ViewControllerPerfil: UIViewController {
    let singleton = UserDefaults.standard
    var cards = [eventosHoras]()
    var cardsOperations = [eventosHoras]()
    var refreshControl = UIRefreshControl()
    var avatarFoto = 0
    
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var imgFotoAvatar: UIImageView!
    
    @IBOutlet weak var eventosHorasView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarFoto = singleton.integer(forKey: "foto")
        
        lbNombre.text = "¡Hola, " + singleton.string(forKey: "nombre")! + "!"
        
        imgFotoAvatar.image = UIImage(named: "avatar\(avatarFoto)")
        
        eventosHorasView.dataSource = self
        eventosHorasView.delegate = self
//        refresh
        eventosHorasView.allowsMultipleSelection = true //maybe remove
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        eventosHorasView.addSubview(refreshControl)
//        refresh
        llamadaAlAPI()
        
        //var h = eventosHoras(eventoid: 0, userid: 0, //fecha: "", status: 0, name: "", horas: 1.0)
        //var names = [String]()
        
        
        txName.text = singleton.string(forKey: "usuario")
        // Do any additional setup after loading the view.
    
        
    }
    
    func llamadaAlAPI(){
        let iduser = self.singleton.integer(forKey: "iduser")
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/get/approvedHours?userid=\(iduser)") else{
                return
            }
    
        let grupo = DispatchGroup()
        grupo.enter()
    
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([eventosHoras].self, from: data)
                    if (!tasks.isEmpty){
                        tasks.forEach{ i in
                            self.cards.append(i)
                        }
                    }else{
                        print("error")
                    }
                }catch{
                    print(error)
                }
            }
            grupo.leave()
        }
        task.resume()
        grupo.wait()
    }
    
    @IBOutlet weak var txName: UILabel!
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewControllerPerfil : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell4 = eventosHorasView.dequeueReusableCell(withIdentifier: "customCell4") as! CustomCell4
        
       //declaration of cell elements
        //let nameUser = cards[indexPath.row].nombreUsuario
        let eventoName = cards[indexPath.row].name
        let horasName = cards[indexPath.row].horas
        
        //assigning cell elements to actual cell
        //cell2.tlNombreUsuario.text = nameUser
        cell4.txEventoName.text = eventoName
        cell4.txHoras.text = "Horas: \(horasName)"
        
        
        //beautifying cell
        cell4.viewBackground.layer.cornerRadius = cell4.layer.frame.height/12
        cell4.viewBackground.layer.masksToBounds = true
        
        return cell4
    }
    //    refresh function
        @objc func refresh(send: UIRefreshControl){
            DispatchQueue.main.async {
    //            removes existing stuff
                self.cards.removeAll()
    //            calls api
                self.llamadaAlAPI()
    //            reload data
                self.eventosHorasView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
}

