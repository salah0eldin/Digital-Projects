var qlcDesignQuality = "100.0";
var overallQualityImpacted = "0";
var moduleQuality = {
  "DFF": {
    "Nomenclature Style": 100,
    "Rtl Design Style": 100.0,
    "Simulation": 100,
    "Implementation": 100,
    "Score": 100.0,
    "Error Count": 0,
    "Warning Count": 0,
    "Info Count": 1,
    "QualityImpacted": 0
  },
  "DSP48A1": {
    "Nomenclature Style": 100,
    "Rtl Design Style": 100.0,
    "Simulation": 100,
    "Implementation": 100,
    "Score": 100.0,
    "Error Count": 0,
    "Warning Count": 0,
    "Info Count": 2,
    "QualityImpacted": 0
  }
};
var fileQuality = {
  "0": {
    "Nomenclature Style": 100,
    "Rtl Design Style": 100.0,
    "Simulation": 100,
    "Implementation": 100,
    "Score": 100.0,
    "Error Count": 0,
    "Warning Count": 0,
    "Info Count": 5,
    "QualityImpacted": 0
  },
  "1": {
    "Nomenclature Style": 100,
    "Rtl Design Style": 100.0,
    "Simulation": 100,
    "Implementation": 100,
    "Score": 100.0,
    "Error Count": 0,
    "Warning Count": 0,
    "Info Count": 1,
    "QualityImpacted": 0
  }
};
var categoryQuality = {
    "Rtl Design Style": 100.0,
    "Nomenclature Style": 100.0,
    "Simulation": 100.0,
    "Implementation": 100.0
};
var checksEnabledPercentage = {
  "Rtl Design Style": {
    "Enabled Checks": 66,
    "Disabled Checks": 193,
    "Percentage": 25
  },
  "Nomenclature Style": {
    "Enabled Checks": 3,
    "Disabled Checks": 43,
    "Percentage": 6
  },
  "Simulation": {
    "Enabled Checks": 10,
    "Disabled Checks": 36,
    "Percentage": 21
  },
  "Implementation": {
    "Enabled Checks": 21,
    "Disabled Checks": 148,
    "Percentage": 12
  }
};
var masterCategoryMap = {
    "Nomenclature Style": [
        "Nomenclature Style"
    ],
    "Rtl Design Style": [
        "Rtl Design Style"
    ],
    "Simulation": [
        "Simulation",
        "Testbench"
    ],
    "Implementation": [
        "Synthesis",
        "Connectivity",
        "Clock",
        "Reset"
    ]
};
