public struct AttributesConfiguration: SeverityBasedRuleConfiguration, Equatable {
    public var severityConfiguration = SeverityConfiguration(.warning)
    private(set) var alwaysOnSameLine = Set<String>()
    private(set) var alwaysOnNewLine = Set<String>()

    public var consoleDescription: String {
        return severityConfiguration.consoleDescription +
            ", always_on_same_line: \(alwaysOnSameLine.sorted())" +
            ", always_on_line_above: \(alwaysOnNewLine.sorted())"
    }

    public init(alwaysOnSameLine: [String] = ["@IBAction", "@NSManaged"],
                alwaysInNewLine: [String] = []) {
        self.alwaysOnSameLine = Set(alwaysOnSameLine)
        self.alwaysOnNewLine = Set(alwaysOnNewLine)
    }

    public mutating func apply(configuration: Any) throws {
        guard let configuration = configuration as? [String: Any] else {
            throw ConfigurationError.unknownConfiguration
        }

        if let alwaysOnSameLine = configuration["always_on_same_line"] as? [String] {
            self.alwaysOnSameLine = Set(alwaysOnSameLine)
        }

        if let alwaysOnNewLine = configuration["always_on_line_above"] as? [String] {
            self.alwaysOnNewLine = Set(alwaysOnNewLine)
        }

        if let severityString = configuration["severity"] as? String {
            try severityConfiguration.apply(configuration: severityString)
        }
    }
}
