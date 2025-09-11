//
//  ViewController.swift
//  WhetherApp
//
//  Created by MAC on 9/7/2025.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var WheatherMark: UILabel!
    @IBOutlet weak var whetherDegree: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityName: UILabel!
    private var presenter = WheatherPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading(true)
        presenter.delgate = self
    }
}


extension ViewController: WheatherPresenterProtocol {
    func updateWhetherDegree(_ degree: Double) {
        DispatchQueue.main.async {
            self.whetherDegree.text = "\(Int(degree))"
        }
    }
    
    func updateCityName(_ cityName: String) {
        DispatchQueue.main.async {
            self.cityName.text = cityName
        }
    }
    
    private func setContentVisible(_ visible: Bool) {
          cityName.isHidden = !visible
          whetherDegree.isHidden = !visible
          WheatherMark.isHidden = !visible
      }
    
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async {
            show ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            self.setContentVisible(!show)
        }
    }

}
