//
//  SVGView.swift
//  SVGView
//
//  Created by Alisa Mylnikova on 20/08/2020.
//

import SwiftUI

public struct SVGView: View {

    @State public var svg: SVGNode?

    public init(contentsOf url: URL) {
        asyncLoad(url)
    }

    private func asyncLoad(_ url: URL) {
        Task {
            let intermediateSVG = SVGParser.parse(contentsOf: url)
            await MainActor.run {
                self.svg = intermediateSVG
            }
        }
    }

    @available(*, deprecated, message: "Use (contentsOf:) initializer instead")
    public init(fileURL: URL) {
        self.svg = SVGParser.parse(contentsOf: fileURL)
    }

    public init(data: Data) {
        self.svg = SVGParser.parse(data: data)
    }

    public init(string: String) {
        self.svg = SVGParser.parse(string: string)
    }

    public init(stream: InputStream) {
        self.svg = SVGParser.parse(stream: stream)
    }

    public init(xml: XMLElement) {
        self.svg = SVGParser.parse(xml: xml)
    }

    public init(svg: SVGNode) {
        self.svg = svg
    }

    public func getNode(byId id: String) -> SVGNode? {
        return svg?.getNode(byId: id)
    }

    public var body: some View {
        svg?.toSwiftUI()
    }

}
