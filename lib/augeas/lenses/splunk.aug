(*
* Splunk module for Agueas
* Author: Tim Brigham
* Heavily based on inifile.aug by Raphael Pinson
* and mysql.aug by Tim Stoop.
* This file is licensed under the LGPLv2+, like the rest of Augeas.
*)

module Splunk =
autoload xfm

let comment  = IniFile.comment IniFile.comment_re IniFile.comment_default
let sep      = IniFile.sep IniFile.sep_re IniFile.sep_default
let empty    = IniFile.empty

let setting   = IniFile.entry_re
let title   =  IniFile.indented_title_label "target" IniFile.record_label_re
let entry    = [ key IniFile.entry_re . sep . IniFile.sto_to_comment . (comment|IniFile.eol) ] |
               [ key IniFile.entry_re . store // . (comment|IniFile.eol) ] |
               [ key /\![A-Za-z][A-Za-z0-9\._-]+/ . del / / " " . store /\/[A-Za-z0-9\.\/_-]+/ . (comment|IniFile.eol) ] |
               comment

let record    = IniFile.record title entry
let record_anon = [ label ".anon" . ( entry | empty )+ ]

let lns       = record_anon | record*

let filter    = incl "/opt/splunk/etc/system/local/*.conf"
              . incl "/opt/splunk/etc/apps/*/local/*.conf"
let xfm       = transform lns filter
