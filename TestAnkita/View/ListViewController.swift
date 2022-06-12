//
//  ViewController.swift
//  TestAnkita
//
//  Created by ankita khare on 11/06/22.
//

import UIKit

class ListViewController: UIViewController, ListViewProtocol {
    private var tableView: UITableView?
    private var circularProgressBarView: CircularProgressBarView!
    private var circularViewDuration: TimeInterval = 10
    
    var presenter: PresenterProtocol?

    private func setupSwipeableView() {
        let colorq1 = hexStringToUIColor(hex: "#060932")
        swipeableView.backgroundColor = colorq1
        view.backgroundColor = colorq1
        let colorq12 = hexStringToUIColor(hex: "#F2F2F2")
        tableView?.backgroundView?.backgroundColor = colorq12//.black#F7F8FF
        view.addSubview(swipeableView)
        addLogoImage()
    }
    
    private func addLogoImage(){
        let imageName = "catchlogo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
       // imageView.frame = CGRect(x: view.frame.size.width  / 2, y: view.frame.size.height / 2, width: 132, height: 60)
        imageView.center = CGPoint(x: view.frame.size.width  / 2,
                                     y: view.frame.size.height / 2)
        imageView.sizeToFit()
        view.addSubview(imageView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwipeableView()
        self.presenter?.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.presenter?.getData()
    }
    
    private let swipeableView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: UIScreen.main.bounds.width, height: 120.0)))
        view.translatesAutoresizingMaskIntoConstraints = false
       
        return view
    }()
    
   private func showActivityIndicator(on parentView: UIView) {
        circularProgressBarView = CircularProgressBarView(frame: .zero)
        circularProgressBarView.center = swipeableView.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration, value: 1.0)
        swipeableView.addSubview(circularProgressBarView)
    }
   
    private func checkStates() {
        if self.presenter?.hasData ?? false {
            setupTableView()
        } else if let loadingState = self.presenter?.loadingState {
            switch loadingState {
            case .dataRefresh:
                self.view.backgroundColor = .yellow
                self.showActivityIndicator(on: self.view)
            case .dataLoad:
                let colorq = hexStringToUIColor(hex: "#eb1951")
                self.view.backgroundColor =  colorq//UIColor(red: 6.0, green: 9.0, blue: 50.0, alpha: 0)
                self.showActivityIndicator(on: self.view)
            case .none:
                break
                // none
            }
        } else if self.presenter?.isError ?? false {
            let errorMessage = self.presenter?.getErrorMessage()
            let alert = UIAlertController(title: "Alert!", message: errorMessage, preferredStyle: .alert)
            self.present(alert, animated: true)
        }
    }
    
    // for hexcolor string
   private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func reloadView() {
        self.checkStates()
    }
    
    private func setupTableView() {
        guard let tableView = self.tableView else {
            
            let tableBGColor = hexStringToUIColor(hex: "#F7F8FF")
            self.view.backgroundColor = tableBGColor
            tableView = UITableView()
            tableView?.delegate = self
            tableView?.dataSource = self
            self.view.addSubview(tableView ?? UITableView())
            tableView?.fillSuperview()
            tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            let refreshControl = BlackProgressView()
            tableView?.addSubview(refreshControl)
            refreshControl.tag = 1601
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            let colorq11 = hexStringToUIColor(hex: "#060932")
            refreshControl.backgroundColor = colorq11
            refreshControl.addTarget(self, action: #selector(self.refrshView), for: .valueChanged)
            
            return
        }
        
        tableView.reloadData()
        stopRefreshing()
    }
    
    private func stopRefreshing() {
        guard let rfcontrol = tableView?.viewWithTag(1601) as? BlackProgressView else{ return}
        rfcontrol.endRefreshing()
        let colorq11 = hexStringToUIColor(hex: "#F7F8FF")
        navigationController?.navigationBar.backgroundColor = colorq11
    }
    
    @objc private func refrshView() {
        guard let rfcontrol = tableView?.viewWithTag(1601) as? BlackProgressView else{ return}
        self.presenter?.getData()
        rfcontrol.beginRefreshing()
        navigationController?.navigationBar.isTranslucent = false
        let colorq11 = hexStringToUIColor(hex: "#060932")
        navigationController?.navigationBar.backgroundColor = colorq11
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.getNumberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        
        let viewModel = self.presenter?.getViewModel(for: indexPath.row)
        cell.textLabel?.text = viewModel?.title
        cell.detailTextLabel?.text = viewModel?.subTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.handleSelection(index: indexPath.row)
    }
}




