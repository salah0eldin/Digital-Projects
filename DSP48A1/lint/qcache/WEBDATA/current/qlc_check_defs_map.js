var setupInfo = { "setupInfo" : [
{ "HOME_0IN" : "C:/QFT_2021.1/QFT_2021.1/QFT/V2021.1/win64" },{ "QHOME" : "C:/QFT_2021.1/QFT_2021.1/QFT/V2021.1/win64" },{ "ZSH" : "" },{ "ZI_RTLD_LIB" : "" }]};
var category = { "category" : [
{ "categoryId" : "0" , "categoryName":"Rtl Design Style" },
{ "categoryId" : "1" , "categoryName":"Simulation" },
{ "categoryId" : "2" , "categoryName":"Synthesis" },
{ "categoryId" : "3" , "categoryName":"Connectivity" },
{ "categoryId" : "4" , "categoryName":"Reset" },
{ "categoryId" : "5" , "categoryName":"Clock" },
{ "categoryId" : "6" , "categoryName":"Testbench" },
{ "categoryId" : "7" , "categoryName":"Nomenclature Style" },
{ "categoryId" : "8" , "categoryName":"Setup Checks" }]};
var severity = { "severity" : [
{ "severityId" : "0" , "severityName":"Error" },
{ "severityId" : "1" , "severityName":"Warning" },
{ "severityId" : "2" , "severityName":"Info" }]};
var statusObj = { "status" : [
{ "statusId" : "0" , "statusName":"uninspected" },
{ "statusId" : "1" , "statusName":"pending" },
{ "statusId" : "2" , "statusName":"waived" },
{ "statusId" : "3" , "statusName":"bug" },
{ "statusId" : "4" , "statusName":"fixed" },
{ "statusId" : "5" , "statusName":"verified" }]} ;
var checks = { "checks":[
{ "checksId":"0", "checksName":"condition_const","severityId":"2","categoryId":"0"},
{ "checksId":"1", "checksName":"parameter_name_duplicate","severityId":"2","categoryId":"7"},
{ "checksId":"2", "checksName":"comment_not_in_english","severityId":"2","categoryId":"7"},
{ "checksId":"3", "checksName":"line_char_large","severityId":"2","categoryId":"0"},
{ "checksId":"4", "checksName":" ","severityId":"3","categoryId":"9"}]};
var schematicStatus = {  
"condition_const" : "off",
"parameter_name_duplicate" : "off",
"comment_not_in_english" : "off",
"line_char_large" : "off"};
var adaptiveModeStatus = {  
"condition_const" : "off",
"parameter_name_duplicate" : "on",
"comment_not_in_english" : "off",
"line_char_large" : "off"};
var checkAliasMap = { };
var argMap = {  
"1":"module",
"2":"file",
"3":"line",
"4":"parameter",
"5":"count",
"6":"module1",
"7":"file1",
"8":"line1",
"9":"module2",
"10":"file2",
"11":"line2",
"12":"limit"};
