//
//  PassTimesTableViewController.swift
//  ISS Pass Times
//
//  Created by Trey Aucoin on 2/25/18.
//

import UIKit
import CoreLocation

class PassTimesTableViewController: UITableViewController {
    
    private let passTimes: PassTimes
    private let dateFormatter: DateFormatter = DateFormatter()
    
    init(passTimes: PassTimes) {
        self.passTimes = passTimes
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        passTimes = []
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Upcoming ISS Pass Times"
        
        tableView.register(PassTimeTableViewCell.self, forCellReuseIdentifier: PassTimeTableViewCell.reuseIdentifier)

        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .long
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passTimes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PassTimeTableViewCell.reuseIdentifier, for: indexPath)
        
            let pass = passTimes[indexPath.row]
            let duration = pass["duration"] ?? 0
            let risetime = pass["risetime"] ?? 0
            
            let dateOfPass = Date(timeIntervalSince1970: risetime)
            let formattedDate = dateFormatter.string(from: dateOfPass)
            
            cell.textLabel?.text = "Passes for \(Int(duration)) seconds"
            cell.detailTextLabel?.text = formattedDate

        return cell
    }

}
