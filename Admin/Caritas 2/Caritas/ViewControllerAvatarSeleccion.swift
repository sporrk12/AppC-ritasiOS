//
//  ViewControllerAvatarSeleccion.swift
//  Caritas
//
//  Created by Alberto  Guajardo on 10/18/22.
//

import UIKit

class ViewControllerAvatarSeleccion: UIViewController {
    
    
    
    @IBAction func btnAvatar1(_ sender: Any) {
        let parentView = presentingViewController as! DemoViewController
        parentView.avatarID = 1
        parentView.updateAvatar()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAvatar2(_ sender: Any) {
        let parentView = presentingViewController as! DemoViewController
        parentView.avatarID = 2
        parentView.updateAvatar()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAvatar3(_ sender: Any) {
        let parentView = presentingViewController as! DemoViewController
        parentView.avatarID = 3
        parentView.updateAvatar()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnAvatar4(_ sender: Any) {
        let parentView = presentingViewController as! DemoViewController
        parentView.avatarID = 4
        parentView.updateAvatar()
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
