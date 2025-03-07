var qlcDesignQuality = "100.0";
var overallQualityImpacted = "0";
var moduleQuality = {};
var fileQuality = {};
var categoryQuality = {
    "Nomenclature Style": 100.0,
    "Rtl Design Style": 100.0,
    "Simulation": 100.0,
    "Implementation": 100.0
};
var checksEnabledPercentage = {
  "Nomenclature Style": {
    "Enabled Checks": 3,
    "Disabled Checks": 43,
    "Percentage": 6
  },
  "Rtl Design Style": {
    "Enabled Checks": 66,
    "Disabled Checks": 193,
    "Percentage": 25
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
