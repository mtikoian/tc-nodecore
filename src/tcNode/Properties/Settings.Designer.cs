﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TradeControl.Node.Properties {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "16.4.0.0")]
    internal sealed partial class Settings : global::System.Configuration.ApplicationSettingsBase {
        
        private static Settings defaultInstance = ((Settings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new Settings())));
        
        public static Settings Default {
            get {
                return defaultInstance;
            }
        }
        
        [global::System.Configuration.UserScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("")]
        public string SqlServerName {
            get {
                return ((string)(this["SqlServerName"]));
            }
            set {
                this["SqlServerName"] = value;
            }
        }
        
        [global::System.Configuration.UserScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("")]
        public string SqlUserName {
            get {
                return ((string)(this["SqlUserName"]));
            }
            set {
                this["SqlUserName"] = value;
            }
        }
        
        [global::System.Configuration.UserScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("")]
        public string DatabaseName {
            get {
                return ((string)(this["DatabaseName"]));
            }
            set {
                this["DatabaseName"] = value;
            }
        }
        
        [global::System.Configuration.UserScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("0")]
        public int AuthenticationMode {
            get {
                return ((int)(this["AuthenticationMode"]));
            }
            set {
                this["AuthenticationMode"] = value;
            }
        }
        
        [global::System.Configuration.UserScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute(@"<?xml version=""1.0"" encoding=""utf-16""?>
<ArrayOfString xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"">
  <string>tc_upgrade_3_23_2</string>
  <string>tc_upgrade_3_24_1</string>
  <string>tc_upgrade_3_24_2</string>
  <string>tc_upgrade_3_24_3</string>
  <string>tc_upgrade_3_24_4</string>
  <string>tc_upgrade_3_24_5</string>
  <string>tc_upgrade_3_24_6</string>
  <string>tc_upgrade_3_25_1</string>
  <string>tc_upgrade_3_26_1</string>
  <string>tc_upgrade_3_27_1</string>
</ArrayOfString>")]
        public global::System.Collections.Specialized.StringCollection SqlUpgradeScripts {
            get {
                return ((global::System.Collections.Specialized.StringCollection)(this["SqlUpgradeScripts"]));
            }
            set {
                this["SqlUpgradeScripts"] = value;
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.SpecialSettingAttribute(global::System.Configuration.SpecialSetting.ConnectionString)]
        [global::System.Configuration.DefaultSettingValueAttribute("Data Source=IAM;Initial Catalog=tcNode;Integrated Security=True")]
        public string tcNodeConnectionString {
            get {
                return ((string)(this["tcNodeConnectionString"]));
            }
        }
    }
}
