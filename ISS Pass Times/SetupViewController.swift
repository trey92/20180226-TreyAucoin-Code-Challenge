//
//  ViewController.swift
//  ISS Pass Times
//
//  Created by Trey Aucoin on 2/25/18.
//

import UIKit
import CoreLocation

class SetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let locationManager = CLLocationManager()

    @IBOutlet private weak var numberOfPassesPickerView: UIPickerView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var passTimeButton: UIButton!
    
    @IBAction private func getPassTimes() {
        callAPI()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        passTimeButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPassesPickerView.dataSource = self
        numberOfPassesPickerView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    private func callAPI() {
        //show activity indicator while waiting for response
        passTimeButton.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude,
            let altitude = locationManager.location?.altitude else {

                displayAlert(title: "Unable to get Location", message: "Please make sure Location Access is enabled in Settings")
                return
        }
        
        let number = numberOfPassesPickerView.selectedRow(inComponent: 0) + 1
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        if var urlComponents = URLComponents(string: "http://api.open-notify.org/iss-pass.json") {
            urlComponents.query = "lat=\(latitude)&lon=\(longitude)&alt=\(altitude)&n=\(number)"
            
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { dataTask = nil }
                
                if let data = data {
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseObject = try jsonDecoder.decode(PassTimeResponse.self, from: data)

                        OperationQueue.main.addOperation {
                            self.presentPassTimes(responseObject.response)
                            self.hideActivityIndicator()
                        }
                        
                    } catch { self.displayErrorAlert() }

                } else {
                    self.displayErrorAlert()
                }
            }
            
            dataTask?.resume()
        }
    }
    
    private func displayAlert(title: String?, message: String?, isErrorAlert: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        if isErrorAlert {
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { _ in
                self.callAPI()
            }
            alert.addAction(tryAgainAction)
        }
        
        OperationQueue.main.addOperation {
            self.present(alert, animated: true, completion: nil)
            self.hideActivityIndicator()
        }
    }
    
    private func displayErrorAlert() {
        displayAlert(title: "There was an error getting the Pass Time data.", message: nil, isErrorAlert: true)
    }
    
    private func presentPassTimes(_ passTimes: PassTimes) {
        let passTimesTVC = PassTimesTableViewController(passTimes: passTimes)
        
        navigationController?.pushViewController(passTimesTVC, animated: true)
    }

}
