//
//  ContentView.swift
//  tree-builder
//
//  Created by Preston Mohr on 3/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var directoryPath = ""
    @State private var result = ""
    @State private var depth = 4
    @State private var showReset: Bool = false
    @State private var showHiddenFiles = false
    @State var isEditable: Bool = false
    @State private var treeStyle = 1
    @State private var trailingStyle = 2
    
    @State private var presentPopupDirectory: Bool = false
    @State private var presentPopupDepth: Bool = false
    @State private var presentPopupStyle: Bool = false
    @State private var presentPopupTrailing: Bool = false
    
    var body: some View {
        VStack {
            Text("Filetree Structure Generator")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
                .bold()
            
            Section {
                VStack {
                    HStack {
                        Text("Directory Path")
                            .font(.title2)
                            .bold()
                        Button(action: {
                            presentPopupDirectory = true
                        }){
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.blue)
                        .popover(isPresented: $presentPopupDirectory, arrowEdge: .trailing) {
                            Text("i.e. /Users/username/Documents")
                                .italic()
                                .font(.body)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("select or enter a directory path")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                    HStack {
                        Button(action: selectDirectory) {
                            Image(systemName: "folder")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        TextField("Enter directory path", text: $directoryPath)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            result = ""
                            generateFileTree(atPath: directoryPath, depth:
                                                depth, showHiddenFiles:
                                                showHiddenFiles, treeStyle: treeStyle)
                        }) {
                            Text("Generate File Tree")
                        }
                    }
                }
            }
            
            Section {
                VStack {
                    HStack {
                        Text("Depth")
                            .font(.title2)
                            .bold()
                        Button(action: {
                            presentPopupDepth = true
                        }){
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.blue)
                        .popover(isPresented: $presentPopupDepth, arrowEdge: .trailing) {
                            Text("depth of filetree structure")
                                .italic()
                                .font(.body)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("increase or decrease the filetree structure depth")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                    HStack {
                            Stepper(value: $depth, in: 1...99) {
                                Text("Depth: \(depth)")
                                    .frame(width: 70, alignment: .leading)
                            }
                            .onChange(of: depth) { newValue in
                                showReset = newValue != 4
                            }
                            
                        if showReset {
                                    Button(action: {
                                        depth = 4
                                        showReset = false
                                    }) {
                                        Text("reset to default")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.leading)
                                    .buttonStyle(PlainButtonStyle())
                                }
                        }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Section {
                VStack {
                    HStack {
                        Text("Tree Style")
                            .font(.title2)
                            .bold()
                        Button(action: {
                            presentPopupStyle = true
                        }){
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.blue)
                        .popover(isPresented: $presentPopupStyle, arrowEdge: .trailing) {
                            Text(styleExample()[treeStyle-1])
                                .font(.body)
                                .padding()
                                .multilineTextAlignment(.leading)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("choose the syntactic style of the filetree structure")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                    HStack {
                        Text("Style: ")
                        Button(action: {
                            treeStyle = 1
                        }) {
                            Text("style A")
                                .foregroundColor(treeStyle == 1 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                        
                        Button(action: {
                            treeStyle = 2
                        }) {
                            Text("style B")
                                .foregroundColor(treeStyle == 2 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                        
                        Button(action: {
                            treeStyle = 3
                        }) {
                            Text("style C")
                                .foregroundColor(treeStyle == 3 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                        
                        Button(action: {
                            treeStyle = 4
                        }) {
                            Text("style D")
                                .foregroundColor(treeStyle == 4 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Section {
                VStack {
                    HStack {
                        Text("Line Trailing")
                            .font(.title2)
                            .bold()
                        Button(action: {
                            presentPopupTrailing = true
                        }){
                            Image(systemName: "info.circle")
                        }
                        .foregroundColor(.blue)
                        .popover(isPresented: $presentPopupTrailing, arrowEdge: .trailing) {
                            Text("choose whether to display a character at the end of a directory line")
                                .italic()
                                .font(.body)
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("choose the trailing symbol to be printed for each directory line")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                    HStack {
                        Text("Trailing Style: ")
                        Button(action: {
                            trailingStyle = 1
                        }) {
                            Text("None")
                                .foregroundColor(trailingStyle == 1 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                        
                        Button(action: {
                            trailingStyle = 2
                        }) {
                            Text(" / ")
                                .foregroundColor(trailingStyle == 2 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                        
                        Button(action: {
                            trailingStyle = 3
                        }) {
                            Text(" : ")
                                .foregroundColor(trailingStyle == 3 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                        
                        Button(action: {
                            trailingStyle = 4
                        }) {
                            Text(" \\ ")
                                .foregroundColor(trailingStyle == 4 ? Color.blue : Color(NSColor.controlTextColor))
                        }
                        .background(Color(NSColor.windowBackgroundColor))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            Section {
                VStack {
                    HStack {
                        Text("Options")
                            .font(.title2)
                            .bold()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("configure various options")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .italic()
                    Toggle(isOn: $showHiddenFiles) {
                        Text("Show Hidden Files")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            /*
            Button(action: {
                result = ""
                generateFileTree(atPath: directoryPath, depth:
                                    depth, showHiddenFiles:
                                    showHiddenFiles, treeStyle: treeStyle)
            }) {
                Text("Generate File Tree")
                    .bold()
            }
            .padding(.top)
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
             */
            
            Divider()

            
            ScrollView {
                Text(result)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .onTapGesture {
                        self.isEditable.toggle()
                    }
                    .background(isEditable ? Color.blue : Color.clear)
                    .onDrag {
                        self.isEditable = true
                        return NSItemProvider(object: result as NSString)
                    }
                    .contextMenu {
                        Button("Copy") {
                            let pasteboard = NSPasteboard.general
                            pasteboard.clearContents()
                            pasteboard.setString(result, forType: .string)
                        }
                    }
            }
            HStack {
                Button(action: copyToClipboard) {
                    Text("Copy to Clipboard")
                }
                Button(action: {
                    openInTextEdit(result: result)
                }) {
                    Text("Open in TextEdit")
                }
            }
        }
        .frame(minWidth: 400, minHeight: 600)
        .padding()
    }

    func selectDirectory() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false

        if openPanel.runModal() == .OK {
            directoryPath = openPanel.url?.path ?? ""
        }
    }
    
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(result, forType: .string)
    }
    
    func openInTextEdit(result: String) {
        let text = result
        let tempDirectory = NSTemporaryDirectory()
        let fileName = "tree_\(UUID().uuidString).txt"
        let tempFile = tempDirectory.appending(fileName)
        
        do {
            try text.write(toFile: tempFile, atomically: true, encoding: .utf8)
            NSWorkspace.shared.openFile(tempFile, withApplication: "TextEdit")
        } catch {
            print("Error writing to temp file: \(error)")
        }
    }
    
    func generateFileTree(atPath path: String, prefix: String = "", depth: Int = 4, showHiddenFiles: Bool = false, treeStyle: Int) {
        guard depth > 0 else { return }
        
        var pipe = "│   "
        var tee = "├── "
        var elbow = "└── "
        
        var trail = ""
        
        if treeStyle == 2 {
            pipe = "¦   "
            tee = "+-- "
            elbow = "\\-- "
        }
        if treeStyle == 3 {
            pipe = "|   "
            tee = "|-- "
            elbow = "`-- "
        }
        if treeStyle == 4 {
            pipe = "    "
            tee = "    "
            elbow = "    "
        }
        
        if trailingStyle == 2 {
            trail = "/"
        }
        if trailingStyle == 3 {
            trail = ":"
        }
        if trailingStyle == 4 {
            trail = "\\"
        }

        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(atPath: path) else { return }
        
        if prefix.isEmpty {
            if path == "/" {
                result += "\(trail)\n"
            }
            else {
                result += "\(path.split(separator: "/")[path.split(separator: "/").count-1])\(trail)\n"
            }
        }

        let visibleFiles = showHiddenFiles ? files : files.filter { !$0.hasPrefix(".") && !$0.hasPrefix("~")}
        let sortedVisibleFiles = visibleFiles.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        for (index, file) in sortedVisibleFiles.enumerated() {
            let isLast = index == sortedVisibleFiles.count - 1

            let filePath = (path as NSString).appendingPathComponent(file)
            var isDirectory: ObjCBool = false
            fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory)

            if isDirectory.boolValue {
                result += "\(prefix)\(isLast ? elbow : tee)\(file)\(trail)\n"
                generateFileTree(atPath: filePath, prefix:
                                 "\(prefix)\(isLast ? "    " : pipe)",
                                 depth: depth - 1,
                                 showHiddenFiles:
                                    showHiddenFiles, treeStyle: treeStyle)
            } else {
                result += "\(prefix)\(isLast ? elbow : tee)\(file)\n"
            }
        }
    }
    
    
    func styleExample() -> [String] {
        let s1 = "Style A\n\nHome\n├── Desktop\n │  └── file1.txt\n└── Documents\n    ├── file1.txt\n    └── file2.txt"
        let s2 = "Style B\n\nHome\n+-- Desktop\n+   \\-- file1.txt\n\\-- Documents\n    +-- file1.txt\n    \\-- file2.txt"
        let s3 = "Style C\n\nHome\n|-- Desktop\n|   `-- file1.txt\n`-- Documents\n    |-- file1.txt\n    `-- file2.txt"
        let s4 = "Style D\n\nHome\n    Desktop\n        file1.txt\n    Documents\n        file1.txt\n        file2.txt"
        
        return [s1,s2,s3,s4];
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
