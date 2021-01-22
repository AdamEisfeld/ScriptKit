//
//  MustacheVSCode.swift
//  scriptkit
//
//  Created by Adam Eisfeld on 2021-01-21.
//

import Foundation

public let mustacheVSCode: String =
"""
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es6",
    "checkJs" : true
  },
  "include": [
    {{# each(includePaths) }}"{{.}}" {{^ @last }}, {{/}}{{/}}
  ]
}
"""
