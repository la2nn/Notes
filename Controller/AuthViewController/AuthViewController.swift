//
//  AuthViewController.swift
//  Notes
//
//  Created by Николай Спиридонов on 10/08/2019.
//  Copyright © 2019 nnick. All rights reserved
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate: class {
    func handleTokenChanged(newToken: String)
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let webView = WKWebView()
    private let clientId = "0839daeadfe2f84523c8"
    private let client_secret = "6015cd5a8befb5a92d27db88c83bd7e869af583c"
    private let sсheme = "login"
    private var authCode = ""
    
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "scope", value: "gist")
        ]
        let request = URLRequest(url: urlComponents!.url!)
        webView.load(request)
        webView.navigationDelegate = self
        
        
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        /*
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating() */
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }
    
    private var tokenGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: "https://github.com/login/oauth/access_token") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(clientId)"),
            URLQueryItem(name: "client_secret", value: "\(client_secret)"),
            URLQueryItem(name: "code", value: "\(authCode)")
        ]
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        return request
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == self.sсheme {
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
                authCode = code
                guard let request = tokenGetRequest else { return }
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] else { return }
                    guard let newToken = json["access_token"] as? String else { return }
                    token = newToken
                    //self.delegate?.handleTokenChanged(newToken: newToken)
                    self.completion!()
                    
                   
                    }.resume()
            }
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            self.present(sb.instantiateInitialViewController()!, animated: false)
           
          //  dismiss(animated: true, completion: nil)
        }
        do {
            decisionHandler(.allow)
        }
    }
}
