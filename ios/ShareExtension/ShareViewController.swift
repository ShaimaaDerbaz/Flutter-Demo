import UIKit
import Social
import MobileCoreServices
import Photos
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    let appGroupId  = "group.com.example.flutter_demo"
    let userDefaultsKey = "SharedMedia"

    override func isContentValid() -> Bool { true }

    override func didSelectPost() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
            done(); return
        }

        let group = DispatchGroup()
        var sharedFiles: [[String: String]] = []

        for item in items {
            for provider in (item.attachments ?? []) {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    group.enter()
                    saveImage(provider: provider) { entry in
                        if let e = entry { sharedFiles.append(e) }
                        group.leave()
                    }
                } else if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) {
                    group.enter()
                    saveFile(provider: provider, typeId: UTType.pdf.identifier) { entry in
                        if let e = entry { sharedFiles.append(e) }
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if let defaults = UserDefaults(suiteName: self.appGroupId) {
                let encoded = try? JSONEncoder().encode(sharedFiles)
                defaults.set(encoded, forKey: self.userDefaultsKey)
                defaults.synchronize()
            }
            self.done()
        }
    }

    // MARK: - Helpers

    private func done() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    private func containerURL() -> URL? {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupId
        )?.appendingPathComponent("ShareExtension", isDirectory: true)
    }

    private func saveImage(provider: NSItemProvider, completion: @escaping ([String: String]?) -> Void) {
        provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] item, _ in
            guard let self = self else { completion(nil); return }
            var sourceURL: URL?

            if let url = item as? URL {
                sourceURL = url
            } else if let image = item as? UIImage {
                sourceURL = self.save(image: image)
            } else if let data = item as? Data, let image = UIImage(data: data) {
                sourceURL = self.save(image: image)
            }

            guard let src = sourceURL,
                  let dest = self.copyToContainer(from: src, mimeType: "image/jpeg") else {
                completion(nil); return
            }
            completion(["path": dest.path, "mimeType": "image/jpeg", "type": "image"])
        }
    }

    private func saveFile(provider: NSItemProvider, typeId: String, completion: @escaping ([String: String]?) -> Void) {
        provider.loadItem(forTypeIdentifier: typeId, options: nil) { [weak self] item, _ in
            guard let self = self, let src = item as? URL,
                  let dest = self.copyToContainer(from: src, mimeType: "application/pdf") else {
                completion(nil); return
            }
            completion(["path": dest.path, "mimeType": "application/pdf", "type": "file"])
        }
    }

    private func save(image: UIImage) -> URL? {
        guard let dir = containerURL() else { return nil }
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let url = dir.appendingPathComponent(UUID().uuidString + ".jpg")
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        try? data.write(to: url)
        return url
    }

    private func copyToContainer(from src: URL, mimeType: String) -> URL? {
        guard let dir = containerURL() else { return nil }
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let dest = dir.appendingPathComponent(src.lastPathComponent)
        try? FileManager.default.copyItem(at: src, to: dest)
        return dest
    }

    override func configurationItems() -> [Any]! { [] }
}
