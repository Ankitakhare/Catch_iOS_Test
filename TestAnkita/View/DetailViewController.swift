//
//  DetailViewController.swift
//  TestAnkita
//
//  Created by ankita khare on 12/06/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var viewModel: ListviewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = viewModel?.title
        setUpView()
    }
    
    func setUpView() {
        let textView = UITextView()
        textView.text = viewModel?.content
        textView.isEditable = false
        self.view.addSubview(textView)
        
        textView.pinTop(0)
        textView.pinLeft(12)
        textView.pinRight(-12)
        textView.pinBottom(20)
    }
}
