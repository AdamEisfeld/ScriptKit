#!/usr/bin/swift

import Foundation

var terminal = Terminal()

// Decode the input from the command line

let input: TerminalInput
do {
    input = try JSON.decode(terminal.arguments, to: TerminalInput.self)
} catch {
    terminal.signalError("Unable to decode input - \(error)")
}

terminal.logLevel = input.verbosity ?? .all

// Decode the config file

let configURL = URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/\(input.configPath)")

let config: Config
do {
    config = try JSON.decode(configURL, to: Config.self)
} catch {
    terminal.signalError("Unable to decode config file - \(error)")
}

// All subsequent paths are based on the config file's location, so we extract it

let configDirectory: String = configURL.deletingLastPathComponent().path

// Iterate over each target, generating the appropriate source

for target in config.targets {
    
    terminal.log(.fluff, "--------------------------------")
    terminal.log(.message, "Building Target\(target.name != nil ? " \(target.name!)" : "")...")
    
    for schema in target.input.schemas {
        
        for url in schema.urlsForBase(configDirectory) {
            
            let classAST: ClassAST
            do {
                classAST = try JSON.decode(url, to: ClassAST.self)
            } catch {
                terminal.signalError("Unable to decode json AST from \(url) - \(error)")
            }
            
            terminal.log(.fluff, "-> Reading schema for \(classAST.className).")
            
            // Generate the swift interface for this class if specified
            
            if let outputPath = target.output.swift {
                
                terminal.log(.fluff, "--> Generating \(classAST.className) swift interface.")
                
                let outputDirectory = "\(configDirectory)/\(outputPath)"
                
                let formatter = SwiftLanguageFormatter()
                let formattedAST = formatter.format(classAST)
                let templateString: String
                do {
                    let fallback: String = ""
                        .byAppendingLine(MustacheSwift.header)
                        .byAppendingLine(MustacheSwift.classStart)
                        .byAppendingLine(MustacheSwift.classProperties, if: formattedAST.classProperties?.isNotEmpty == true)
                        .byAppendingLine(MustacheSwift.instanceProperties, if: formattedAST.instanceProperties?.isNotEmpty == true)
                        .byAppendingLine(MustacheSwift.classFunctions, if: formattedAST.classFunctions?.isNotEmpty == true)
                        .byAppendingLine(MustacheSwift.instanceFunctions, if: formattedAST.instanceFunctions?.isNotEmpty == true)
                        .byAppendingLine(MustacheSwift.classEnd)
                    
                    templateString = try TemplateEngine.templateStringFromFile(target.input.swiftTemplatePath, base: configDirectory, fallback: fallback)
                } catch {
                    terminal.signalError("Unable to construct template file for \(outputPath)")
                }
                let source = TemplateEngine.serialize(formattedAST, templateString: templateString)
                
                let outputName = "\(formattedAST.className).swift"
                do {
                    try FileIO.write(source, to: outputDirectory, named: outputName)
                } catch {
                    terminal.signalError("Unable to write output file - \(error)")
                }
            }
            
            // Generate the javascript interface for this class if specified
            
            if let outputPath = target.output.javascript {
                
                terminal.log(.fluff, "--> Generating \(classAST.className) javascript interface.")
                
                let outputDirectory = "\(configDirectory)/\(outputPath)"
                
                let formatter = JavascriptLanguageFormatter()
                let formattedAST = formatter.format(classAST)
                let templateString: String
                do {
                    let fallback: String = ""
                        .byAppendingLine(MustacheJS.header)
                        .byAppendingLine(MustacheJS.classDefinition)
                        .byAppendingLine(MustacheJS.classProperties, if: formattedAST.classProperties?.isNotEmpty == true)
                        .byAppendingLine(MustacheJS.instanceProperties, if: formattedAST.instanceProperties?.isNotEmpty == true)
                        .byAppendingLine(MustacheJS.classFunctions, if: formattedAST.classFunctions?.isNotEmpty == true)
                        .byAppendingLine(MustacheJS.instanceFunctions, if: formattedAST.instanceFunctions?.isNotEmpty == true)
                    
                    templateString = try TemplateEngine.templateStringFromFile(target.input.javascriptTemplatePath, base: configDirectory, fallback: fallback)
                } catch {
                    terminal.signalError("Unable to construct template file for \(outputPath)")
                }
                let source = TemplateEngine.serialize(formattedAST, templateString: templateString)
                
                let outputName = "\(formattedAST.className).js"
                do {
                    try FileIO.write(source, to: outputDirectory, named: outputName)
                } catch {
                    terminal.signalError("Unable to write output file - \(error)")
                }
            }
            
        }
        
    }
    
    // Generate the vscode interface for this target if specified
    
    if let outputPath = target.output.vscode, let javascriptPath = target.output.javascript {
        
        terminal.log(.fluff, "-> Generating vscode interface.")
        
        let outputDirectory = "\(configDirectory)/\(outputPath)"
        
        // We need to create a relative path going from the place we're saving the jsconfig file,
        // to the place we saved the javascript file
        
        let pathToCreatedVSCodeFile = URL(fileURLWithPath: "\(configDirectory)/\(outputPath)", isDirectory: true)
        let pathToCreatedJavascriptFiles = URL(fileURLWithPath: "\(configDirectory)/\(javascriptPath)", isDirectory: true)
        let relativePathFromVSCodeToJavascript = pathToCreatedJavascriptFiles.relativePathFrom(pathToCreatedVSCodeFile)
        
        let templateData = VSCodeConfig(includePaths: ["*.js", "\(relativePathFromVSCodeToJavascript)/*.js"])
        let templateString: String
        do {
            templateString = try TemplateEngine.templateStringFromFile(target.input.vscodeTemplatePath, base: configDirectory, fallback: mustacheVSCode)
        } catch {
            terminal.signalError("Unable to construct template file for \(outputPath)")
        }
        let source = TemplateEngine.serialize(templateData, templateString: templateString)
        
        let outputName = "jsconfig.json"
        do {
            try FileIO.write(source, to: outputDirectory, named: outputName)
        } catch {
            terminal.signalError("Unable to write output file - \(error)")
        }
    }
    
}

public extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

public extension String {
    func byAppendingLine(_ value: String) -> String {
        return "\(self)\n\(value)"
    }
    func byAppendingLine(_ value: String, if condition: Bool) -> String {
        return condition ? byAppendingLine(value) : self
    }
}

terminal.log(.message, "Done.")
terminal.log(.fluff, "--------------------------------")
