//
//  SVGView.swift
//  SVGView
//
//  Created by Alisa Mylnikova on 20/08/2020.
//

import SwiftUI

public struct SVGView: View {

    @State private var svg: SVGNode? = nil
    private let url: URL?
    private let data: Data?
    private let string: String?
    private let stream: InputStream?

    public init(contentsOf url: URL) {
        self.url = url
        self.data = nil
        self.string = nil
        self.stream = nil
    }

    public init(data: Data) {
        self.url = nil
        self.data = data
        self.string = nil
        self.stream = nil
    }

    public init(string: String) {
        self.url = nil
        self.data = nil
        self.string = string
        self.stream = nil
    }

    public init(stream: InputStream) {
        self.url = nil
        self.data = nil
        self.string = nil
        self.stream = stream
    }

    public var body: some View {
        Group {
            if let svg = svg {
                svg.toSwiftUI()
            } else {
                ProgressView() // Show a loading indicator while parsing
            }
        }
        .onAppear {
            loadSVG()
        }
    }

    private func loadSVG() {
        DispatchQueue.global(qos: .background).async {
            let parsedSVG: SVGNode?
            if let url = url {
                parsedSVG = SVGParser.parse(contentsOf: url)
            } else if let data = data {
                parsedSVG = SVGParser.parse(data: data)
            } else if let string = string {
                parsedSVG = SVGParser.parse(string: string)
            } else if let stream = stream {
                parsedSVG = SVGParser.parse(stream: stream)
            } else {
                parsedSVG = nil
            }

            // Update the state on the main thread
            DispatchQueue.main.async {
                self.svg = parsedSVG
            }
        }
    }
}
