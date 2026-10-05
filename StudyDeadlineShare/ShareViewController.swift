//
//  ShareViewController.swift
//  StudyDeadlineShare
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import UIKit
import Social
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    private let appGroup =
        "group.com.felixlina.StudyDeadline"

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {

        guard let extensionItem =
                extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {

            extensionContext?.completeRequest(
                returningItems: [],
                completionHandler: nil
            )
            return
        }

        for attachment in attachments {

            if attachment.hasItemConformingToTypeIdentifier(
                UTType.url.identifier
            ) {
                attachment.loadItem(
                    forTypeIdentifier: UTType.url.identifier,
                    options: nil
                ) { [weak self] item, error in

                    guard let self = self else {
                        return
                    }

                    if let url = item as? URL {
                        let defaults = UserDefaults(
                            suiteName: self.appGroup
                        )

                        defaults?.set(
                            url.absoluteString,
                            forKey: "sharedURL"
                        )
                    }

                    self.extensionContext?.completeRequest(
                        returningItems: [],
                        completionHandler: nil
                    )
                }

                return
            }
        }

        extensionContext?.completeRequest(
            returningItems: [],
            completionHandler: nil
        )
    }

    override func configurationItems() -> [Any]! {
        return []
    }
}
