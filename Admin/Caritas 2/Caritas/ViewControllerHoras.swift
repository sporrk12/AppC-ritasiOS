//
//  ViewControllerHoras.swift
//  Caritas
//
//  Created by Alumno on 15/10/22.
//

import UIKit

class ViewControllerHoras: UIViewController {
    
    @IBOutlet weak var horasView: UITableView!
    
    var cards = [horasAprob]()
    
    let singleton = UserDefaults.standard
    
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        refresh
                refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
                horasView.addSubview(refreshControl)
        //        refresh
        
        llamadaAlAPI()
        
        horasView.delegate = self
        horasView.dataSource = self
        
        /*let card1 = horasAprob(nombreEvento: "Banco Alimentos", nombreUsuario: "Jessica", fecha: "dd/mm/yyyy", horas: 5, foto: "Maria")
        let card2 = horasAprob(nombreEvento: "Banco Alimentos", nombreUsuario: "Juanita", fecha: "dd/mm/yyyy", horas: 5, foto: "Martha")
        let card3 = horasAprob(nombreEvento: "Banco de Sangre", nombreUsuario: "Juan", fecha: "dd/mm/yyyy", horas: 7, foto: "Diego")
        cards.append(card1)
        cards.append(card2)
        cards.append(card3)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "aprobacion"){
            let vistaDestino = segue.destination as! ViewControllerAprobacionHoras
            let renglonSeleccionado = horasView.indexPathForSelectedRow!
            vistaDestino.hora = cards[renglonSeleccionado.row]
        }
    }
    
    func llamadaAlAPI(){
        let iduser = self.singleton.integer(forKey: "iduser")
        guard let url = URL(string:"https://equipo03.tc2007b.tec.mx:10202/get/tarjetas") else{
                return
            }
    
        let grupo = DispatchGroup()
        grupo.enter()
    
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([horasAprob].self, from: data)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewControllerHoras : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 186
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell2 = horasView.dequeueReusableCell(withIdentifier: "customCell2") as! CustomCell2
        
       //declaration of cell elements
        let nameUser = cards[indexPath.row].nombreUsuario
        let nameEvent = cards[indexPath.row].nombreEvento
        let date = cards[indexPath.row].fecha
        let hours = cards[indexPath.row].horas
        let picture = String(cards[indexPath.row].foto)
        
        //assigning cell elements to actual cell
        cell2.tlNombreUsuario.text = nameUser
        cell2.tlNombreEvento.text = nameEvent
        cell2.tlFecha.text = date
        cell2.tlHoras.text = "Horas: \(hours)"
        
        cell2.imgUsuario.image = UIImage(named: "avatar\(picture)")
        
        //beautifying cell
        cell2.viewBackground.layer.cornerRadius = cell2.layer.frame.height/12
        cell2.viewBackground.layer.masksToBounds = true
        
        return cell2
    }
    //    refresh function
        @objc func refresh(send: UIRefreshControl){
            DispatchQueue.main.async {
    //            removes existing stuff
                self.cards.removeAll()
    //            calls api
                self.llamadaAlAPI()
    //            reload data
                self.horasView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
}
