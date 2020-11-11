//
//  ViewController.swift
//  Project25
//
//  Created by diayan siat on 19/10/2020.
//  Copyright © 2020 Diayan Siat. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)//gets the name of the current device
    
    //session and advertiser assistant are optional, that code creates the MCPeerID up front using the name of the current device, which will usually be something like "Diayan's iPhone" they don't have to be optional
    var mcSession: MCSession?
    var mcAdvatiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        
        let importPictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        
        let composeMessageButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeMessage))
        
        let connectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        let connectedPeersButton = UIBarButtonItem(title: "Peers", style: .plain, target: self, action: #selector(showConnectedPeers))
        
        navigationItem.leftBarButtonItems = [connectionButton, connectedPeersButton]
        navigationItem.rightBarButtonItems = [composeMessageButton, importPictureButton]
        
        //initialiaze mcsession so that I can make connections
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
    }
    
    @objc func showConnectedPeers() {
        var connectedPeers = ""
        
        var availablePeers = false
        
        if let mcSession = mcSession {
            if mcSession.connectedPeers.count > 0 {
                availablePeers = true
                
                for peer in mcSession.connectedPeers {
                    connectedPeers += "\n\(peer.displayName)"
                }
            }
        }
        
        if !availablePeers {
            connectedPeers += "\nNo peers connected"
        }
        
        let ac = UIAlertController(title: "Connected Peers", message: connectedPeers, preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func composeMessage() {
        let ac = UIAlertController(title: "Compose message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                self?.sendMessage(text)
            }
        }))
        
        present(ac, animated: true)
    }
    
    func sendMessage(_ text: String) {
        //convert text into a data object
        let data = Data(text.utf8)
        sendData(data)
    }
    
    func sendData(_ data: Data) {
        //share data with peer
        
        //1. Check if we have an active session we can use.
        guard let mcSession = mcSession else { return }
        
        //2. Check if there are any peers to send to.
        if mcSession.connectedPeers.count > 0 {
            
            //Send it to all peers, ensuring it gets delivered.
            do {
                //.reliable ensures that data gets sent intact to all peers
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            }catch {
                //Show an error message if there's a problem.
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            
        }
    }
    
    func sendImage(_ image: UIImage) {
        if let imageData = image.pngData() {
            sendData(imageData)
        }
    }
    
    func startHosting(action: UIAlertAction) {
        //all multipeer services on iOS must declare a service type, which is a 15-digit string that uniquely identify your service. Those 15 digits can contain only the letters A-Z, numbers and hyphens, and it's usually preferred to include your company in there somehow
        guard let mcSession = mcSession else { return }
        mcAdvatiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvatiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @objc func importPicture() {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        //share data with peer
        sendImage(image)
        
        
        //The following lines have been moved into the send data function
        /*
         1. Check if we have an active session we can use.
         
         guard let mcSession = mcSession else { return }
         //2. Check if there are any peers to send to.
         if mcSession.connectedPeers.count > 0 {
         
         //3. Convert the new image to a Data object.
         if let imageData = image.pngData() {
         //Send it to all peers, ensuring it gets delivered.
         do {
         //.reliable ensures that data gets sent intact to all peers
         try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
         }catch {
         //Show an error message if there's a problem.
         let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "OK", style: .default))
         present(ac, animated: true)
         }
         }
         }
         */
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        
        ac.addAction((UIAlertAction(title: "Join a session", style: .default, handler: joinSession)))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected \(peerID.displayName)")
        case .connecting:
            print("Connecting to \(peerID.displayName)")
        case .notConnected:
            print("Not Connected \(peerID.displayName)")
            disconnectedAlert(displayName: peerID.displayName)
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //do UI work in the main thread
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
            else {
                let text = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "Message Received", message: "\n\(text)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }
    
    func disconnectedAlert(displayName: String) {
        let ac = UIAlertController(title: "Disconnected", message: "\(displayName) has disconnected", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

