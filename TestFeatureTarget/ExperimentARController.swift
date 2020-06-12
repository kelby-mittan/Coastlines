//
//  ExperimentARController.swift
//  TestFeatureTarget
//
//  Created by Kelby Mittan on 6/10/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ExperimentARController: UIViewController {
    
    lazy var arView = ARView(frame: view.frame)
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        arView.session.delegate = self
//
//        setupARView()
//
//        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
        let sceneAnchor = try! AnimationNYCmap.loadScene()
        arView.scene.addAnchor(sceneAnchor)
    }
    
    
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: arView)


        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)

        if let firstResult = results.first {
            let anchor = ARAnchor(name: "baseMapNYC-2", transform: firstResult.worldTransform)

            arView.session.add(anchor: anchor)

        } else {
            print("Object Placement Failed")
        }
        
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor) {
        let entity = try! ModelEntity.loadModel(named: "baseMapNYC-2")


        entity.generateCollisionShapes(recursive: true)

        arView.installGestures([.rotation, .translation], for: entity)

        let anchorEntity = AnchorEntity(anchor: anchor)

        anchorEntity.addChild(entity)

        arView.scene.addAnchor(anchorEntity)
    }
}

extension ExperimentARController: ARSessionDelegate {

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "baseMapNYC-2" {
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}
