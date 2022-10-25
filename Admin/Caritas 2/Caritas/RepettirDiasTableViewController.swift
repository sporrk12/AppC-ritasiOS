//
//  RepettirDiasTableViewController.swift
//  Caritas
//
//  Created by Emmanuel  Granados on 15/10/22.
//

import UIKit

class RepettirDiasTableViewController: UITableViewController {

    var weekdays: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: Id.weekdaysUnwindIdentifier, sender: self)
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        for weekday in weekdays
        {
            if weekday == (indexPath.row + 1) {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        if let index = weekdays.firstIndex(of: (indexPath.row + 1)){
            weekdays.remove(at: index)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        else{
            //row index start from 0, weekdays index start from 1 (Sunday), so plus 1
            weekdays.append(indexPath.row + 1)
            cell.setSelected(true, animated: true)
            cell.setSelected(false, animated: true)
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            
        }
    }
}


extension RepettirDiasTableViewController {
    static func repeatText(weekdays: [Int]) -> String {
        if weekdays.count == 7 {
            return "Todos los días"
        }
        
        if weekdays.isEmpty {
            return "Nunca"
        }
        
        var ret = String()
        var weekdaysSorted:[Int] = [Int]()
        
        weekdaysSorted = weekdays.sorted(by: <)
        
        for day in weekdaysSorted {
            switch day{
            case 1:
                ret += "Lun "
            case 2:
                ret += "Mar "
            case 3:
                ret += "Mie "
            case 4:
                ret += "Jue "
            case 5:
                ret += "Vie "
            case 6:
                ret += "Sab "
            case 7:
                ret += "Dom "
            default:
                //throw
                break
            }
        }
        return ret
    }
}
