# Traditional Chinese translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Henry Lee (zh_TW)
# cyberik (zh_TW)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-11-17 23:43+0000
# Last-Translator: Henry Lee <Unknown>
# Language-Team: Traditional Chinese <zh_TW@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=1; plural=0;
# X-Launchpad-Export-Date: 2010-01-10 10:44+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; 0},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>刪除書頁</b>

確定要刪除
\'{name}\' 這個書頁 ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>啟動版本控制</b>

尚未啟動此書冊的版本控制
是否要啟動?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>無此資料夾</b>

資料夾: {path} 不存在
是否現在建立?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>已有此書頁</b>

書頁 \'{name}\'
已存在
是否要覆寫?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>將書頁回復至已儲存的版本?</b>

要將此書頁: {page}
回復至已儲存的這個版本: {version} ?

將失去此儲存版本之後的所有修訂內容 !',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>更新日曆頁面至 0.24 版格式?</b>

此書冊包含使用 yyyy_mm_dd 日期格式的書頁
Zim 0.24 版之後預設使用 yyyy:mm:dd 格式
以分別為各月創建名稱標示

是否將此書冊更新至新格式?
',
  'Add \'tearoff\' strips to the menus' => '選單增添虛折線',
  'Application show two text files side by side' => '可並列顯示文字檔案的程式',
  'Application to compose email' => '撰寫電子郵件的程式',
  'Application to edit text files' => '編輯文字檔案的程式',
  'Application to open directories' => '開啟目錄的程式',
  'Application to open urls' => '開啟網址的程式',
  'Attach _File|Attach external file' => '附加檔案(_F)|增添外部檔案',
  'Attach external files' => '附加外部檔案',
  'Auto-format entities' => '自動格式字元',
  'Auto-increment numbered lists' => '自動遞增序列式條目',
  'Auto-link CamelCase' => 'CamelCase 格式自動連結',
  'Auto-link files' => '自動連結檔案',
  'Auto-save version on close' => '關閉時自動儲存版本',
  'Auto-select words' => '自動選擇單字',
  'Automatically increment items in a numbered list' => '自動遞增序列式條目裡的項目編號',
  'Automatically link file names when you type' => '鍵入檔案名稱時自動製作連結',
  'Automaticly link CamelCase words when you type' => '鍵入 CamelCase 字母時自動製作連結',
  'Automaticly select the current word when you toggle the format' => '轉換格式時自動選擇目前單字',
  'Bold' => '粗體字',
  'Calen_dar|Show calendar' => '日曆(_d)|顯示日曆',
  'Calendar' => '日曆',
  'Can not find application "bzr"' => '未發現應用程式 "bzr"',
  'Can not find application "{name}"' => '未發現應用程式 "{name}"',
  'Can not save a version without comment' => '無法儲存沒有評註的版本',
  'Can not save to page: {name}' => '無法存入書頁: {name}',
  'Can\'t find {url}' => '找不到網址 {url}',
  'Cha_nge' => '修改(_N)',
  'Chars' => '字元數',
  'Check _spelling|Spell check' => '拼字檢查(_s)|拼字檢查',
  'Check checkbox lists recursive' => '勾選框遞迴式列表',
  'Checking a checkbox list item will also check any sub-items' => '選擇勾選框列表項目將同時選擇所有子項目',
  'Choose {app_type}' => '選擇 {app_type}',
  'Co_mpare Page...' => '書頁比較(_m)...',
  'Command' => '指令',
  'Comment' => '註解',
  'Compare this version with' => '此版本的比較對象為',
  'Copy Email Address' => '複製電子郵址',
  'Copy Location|Copy location' => '複製目前位置|複製目前位置',
  'Copy _Link' => '複製連結(_L)',
  'Could not delete page: {name}' => '無法刪除書頁: {name}',
  'Could not get annotated source for page {page}' => '無法取得 {page} 這個書頁的註解原始碼',
  'Could not get changes for page: {page}' => '無法取得此書頁的修訂內容: {page}',
  'Could not get changes for this notebook' => '無法取得此書冊的修訂內容',
  'Could not get file for page: {page}' => '無法取得此書頁之檔案: {page}',
  'Could not get versions to compare' => '無法取得可進行比較的版本',
  'Could not initialize version control' => '無法初始化版本控制',
  'Could not load page: {name}' => '無法載入: {name}',
  'Could not rename {from} to {to}' => '無法將 {from} 更名為 {to}',
  'Could not save page' => '無法儲存書頁',
  'Could not save version' => '無法儲存版本',
  'Creating a new link directly opens the page' => '建立新連結即直接開啟連結',
  'Creation Date' => '建立時間',
  'Cu_t|Cut' => '剪下(_t)|剪下',
  'Current' => '現正使用的版本',
  'Customise' => '客製化',
  'Date' => '日期',
  'Default notebook' => '預設書冊',
  'Details' => '詳細資訊',
  'Diff Editor' => '差異比對編輯器',
  'Diff editor' => '差異比對編輯器',
  'Directory' => '書冊使用目錄',
  'Document Root' => '文件根目錄',
  'E_quation...|Insert equation' => '方程式(_q)...|加入方程式',
  'E_xport...|Export' => '匯出(_x)...|匯出',
  'E_xternal Link...|Insert external link' => '外部連結(_x)...|加入外部連結',
  'Edit Image' => '編修圖像',
  'Edit Link' => '編輯連結',
  'Edit Query' => '編輯查詢',
  'Edit _Source|Open source' => '編輯原始碼(_S)|開啟原始碼',
  'Edit notebook' => '編輯書冊',
  'Edit text files "wiki style"' => '以維基樣式編輯文字檔案',
  'Editing' => '編輯',
  'Email client' => '電子郵件程式',
  'Enabled' => '已啟用',
  'Equation Editor' => '方程式編輯器',
  'Equation Editor Log' => '方程式編輯器日誌',
  'Expand side pane' => '展開邊欄',
  'Export page' => '匯出書頁',
  'Exporting page {number}' => '匯出 {number} 頁書頁',
  'Failed to cleanup SVN working copy.' => '無法清理 SVN 工作副本.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => '無法載入 SVN 元件,
是否有安裝版本控制系統工具?',
  'Failed to load plugin: {name}' => '元件載入失敗: {name}',
  'Failed update working copy.' => '無法更新工作副本',
  'File browser' => '檔案瀏覽器',
  'File is not a text file: {file}' => '該檔非文字檔: {file}',
  'Filter' => '篩選',
  'Find' => '尋找',
  'Find Ne_xt|Find next' => '找下一個(_x)|找下一個',
  'Find Pre_vious|Find previous' => '找上一個(_v)|找上一個',
  'Find and Replace' => '尋找及代換',
  'Find what' => '找什麼',
  'Follow new link' => '立即連至新連結',
  'For_mat|' => '格式(_m)|',
  'Format' => '格式',
  'General' => '總類',
  'Go to "{link}"' => '至 "{link}"',
  'H_idden|.' => '隱藏(_i)|.',
  'Head _1|Heading 1' => '1號標題(_1)|1號標題',
  'Head _2|Heading 2' => '2號標題(_2)|2號標題',
  'Head _3|Heading 3' => '3號標題(_3)|3號標題',
  'Head _4|Heading 4' => '4號標題(_4)|4號標題',
  'Head _5|Heading 5' => '5號標題(_5)|5號標題',
  'Head1' => '1號標題',
  'Head2' => '2號標題',
  'Head3' => '3號標題',
  'Head4' => '4號標題',
  'Head5' => '5號標題',
  'Height' => '高',
  'Home Page' => '書冊首頁',
  'Icon' => '書冊圖示',
  'Id' => '編號',
  'Include all open checkboxes' => '包含所有開啟的勾選框',
  'Index page' => '設定索引頁',
  'Initial version' => '初始版本',
  'Insert Date' => '加入日期',
  'Insert Image' => '加入圖像',
  'Insert Link' => '加入連結',
  'Insert from file' => '從檔案加入',
  'Interface' => '界面',
  'Italic' => '斜體字',
  'Jump to' => '跳至',
  'Jump to Page' => '跳至書頁',
  'Lines' => '行數',
  'Links to' => '連結至',
  'Match c_ase' => '大小寫相符(_a)',
  'Media' => '媒體設定',
  'Modification Date' => '更新時間',
  'Name' => '書冊名稱',
  'New notebook' => '新書冊',
  'New page' => '新書頁',
  'No such directory: {name}' => '無此目錄: {name}',
  'No such file or directory: {name}' => '無此檔案或目錄: {name}',
  'No such file: {file}' => '無此檔案: {file}',
  'No such notebook: {name}' => '無此書冊: {name}',
  'No such page: {page}' => '無此書頁: {page}',
  'No such plugin: {name}' => '無此元件: {name}',
  'Normal' => '正體字',
  'Not Now' => '非此時',
  'Not a valid page name: {name}' => '此書頁名稱不合適: {name}',
  'Not an url: {url}' => '無此網址: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => '建立一個指向不存在書頁的連結
將自動建立新書頁',
  'Notebook' => '書冊',
  'Notebooks' => '書冊',
  'Open Document _Folder|Open document folder' => '開啟文件資料夾(_F)|開啟文件資料夾',
  'Open Document _Root|Open document root' => '開啟文件根目錄(_R)|開啟文件根目錄',
  'Open _Directory' => '開啟目錄(_D)',
  'Open notebook' => '開啟書冊',
  'Other...' => '其他...',
  'Output' => '輸出設定',
  'Output dir' => '匯出至目錄',
  'P_athbar type|' => '路徑列顯示方式(_a)|',
  'Page' => '書頁',
  'Page Editable|Page editable' => '可編輯書頁|可編輯書頁',
  'Page name' => '書頁名',
  'Pages' => '書頁設定',
  'Password' => '密碼',
  'Please enter a comment for this version' => '請評註這個版本',
  'Please enter a name to save a copy of page: {page}' => '請鍵入名稱以儲存書頁副本: {page}',
  'Please enter a {app_type}' => '請鍵入 {app_type}',
  'Please give a page first' => '請先點明書頁',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => '請至少安排一個目錄以儲存您的書頁
就新書冊而言，此目錄應該是空的
像是您的家目錄底下，稱之為 "Notes" 的目錄',
  'Please provide the password for
{path}' => '請提供存取這個路徑的密碼
{path}',
  'Please select a notebook first' => '請先選擇書冊',
  'Please select a version first' => '請先選擇版本',
  'Plugin already loaded: {name}' => '已載入元件: {name}',
  'Plugins' => '元件',
  'Pr_eferences|Preferences dialog' => '偏好設定(_e)|偏好設定互動框',
  'Preferences' => '偏好設定',
  'Prefix document root' => '文件根目錄前置標識符',
  'Print to Browser|Print to browser' => '列印至瀏覽器|列印至瀏覽器',
  'Prio' => '重要性',
  'Proper_ties|Properties dialog' => '屬性(_t)|屬性',
  'Properties' => '屬性',
  'Rank' => '相關性級數',
  'Re-build Index|Rebuild index' => '重建索引|重建索引',
  'Recursive' => '包含所有子目錄',
  'Rename page' => '書頁更名',
  'Rename to' => '更名為',
  'Replace _all' => '全部代換(_a)',
  'Replace with' => '代換為',
  'SVN cleanup|Cleanup SVN working copy' => '清理 SVN|清理 SVN 工作副本',
  'SVN commit|Commit notebook to SVN repository' => '紀錄 SVN|將書冊蒐藏於 SVN 儲庫',
  'SVN update|Update notebook from SVN repository' => '更新 SVN|自 SVN 儲庫更新書冊',
  'S_ave Version...|Save Version' => '版本存檔(_a)...|版本存檔',
  'Save Copy' => '儲存副本',
  'Save version' => '儲存版本',
  'Scanning tree ...' => '掃描樹狀結構 ...',
  'Search' => '搜尋',
  'Search _Backlinks...|Search Back links' => '搜尋反向連結(_B)...|搜尋反向連結',
  'Select File' => '選擇檔案',
  'Select Folder' => '選擇資料夾',
  'Send To...' => '傳送至...',
  'Show cursor for read-only' => '唯讀時顯示游標',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => '無法編輯書頁時仍顯示游標，此選項有助於以鍵盤進行瀏覽作業',
  'Slow file system' => '低速檔案系統的快取',
  'Source' => '來源',
  'Source Format' => '原始碼格式',
  'Start the side pane with the whole tree expanded.' => '開啟邊欄時完全展開樹狀結構',
  'Stri_ke|Strike' => '刪除線字(_k)|刪除線字',
  'Strike' => '刪除線字',
  'TODO List' => '待辦事項',
  'Task' => '工作',
  'Tearoff menus' => '虛折線選單',
  'Template' => '模板',
  'Text' => '顯示文字',
  'Text Editor' => '文字編輯器',
  'Text _From File...|Insert text from file' => '加入其他檔案的內容(_F)...|加入其他檔案的內容',
  'Text editor' => '文字編輯器',
  'The equation failed to compile. Do you want to save anyway?' => '方程式編譯失敗. 仍要儲存?',
  'The equation for image: {path}
is missing. Can not edit equation.' => '欠缺此圖像: {path} 的方程式
無法編輯方程式',
  'This notebook does not have a document root' => '此書冊無文件根目錄',
  'This page does not exist
404' => '無此網頁
404',
  'This page does not have a document folder' => '此書頁無文件資料夾',
  'This page does not have a source' => '此書頁無原始碼',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => '儲庫已更新此書頁.
請更新工作副本 (工具 -> 更新 SVN).',
  'To_day|Today' => '今天(_d)|今天',
  'Toggle Chechbox \'V\'|Toggle checkbox' => '切換勾選框 \'V\'|切換勾選框',
  'Toggle Chechbox \'X\'|Toggle checkbox' => '切換勾選框 \'V\'|切換勾選框',
  'Underline' => '底線字',
  'Updating links' => '更新連結',
  'Updating links in {name}' => '更新 {name} 內的連結',
  'Updating..' => '更新中..',
  'Use "Backspace" to un-indent' => '按 "Backspace" 鍵取消縮排',
  'Use "Ctrl-Space" to switch focus' => '按 "Ctrl-Space" 鍵轉換焦點',
  'Use "Enter" to follow links' => '按 "Enter" 鍵連至連結',
  'Use autoformatting to type special characters' => '以自動格式機能鍵入特殊字元',
  'Use custom font' => '自訂字型',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => '以 "Backspace" 鍵取消非序列式條目的縮排 (功能同 "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => '以 "Ctrl-Space" 組合鍵在文字與邊欄間轉換焦點，若取消此設定仍可使用 "Alt-Space" 組合鍵進行作業',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => '按 "Enter" 鍵立即連至連結，若取消此設定仍可使用 "Alt-Enter" 組合鍵進行作業',
  'User' => '使用者',
  'User name' => '使用者名稱',
  'Verbatim' => '無格式逐字',
  'Versions' => '版本',
  'View _Annotated...' => '檢視註解(_A)...',
  'View _Log' => '觀看日誌(_L)',
  'Web browser' => '網頁瀏覽器',
  'Whole _word' => '找完整單字(_w)',
  'Width' => '寬',
  'Word Count' => '統計字數',
  'Words' => '字數',
  'You can add rules to your search query below' => '您可在底下的搜尋查詢中加入條件',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => '版本控制系統可選擇 <b>Bazaar</b> 或 <b>Subversion</b>.
請按下 \'求助\' 以瞭解系統需求.',
  'You have no {app_type} configured' => '無設定過的 {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => '需重新啟動程式
以更新元件選擇',
  'Your name; this can be used in export templates' => '您的大名，可用於匯出模板',
  'Zim Desktop Wiki' => 'Zim 桌面維基',
  '_About|About' => '關於(_A)|關於',
  '_All' => '全部書頁(_A)',
  '_Back|Go page back' => '前一頁(_B)|到前一頁',
  '_Bold|Bold' => '粗體字(_B)|粗體字',
  '_Browse...' => '瀏覽(_B)...',
  '_Bugs|Bugs' => '問題回報(_B)|問題回報',
  '_Child|Go to child page' => '到下層(子)頁面(_C)|到下層(子)頁面',
  '_Close|Close window' => '關閉(_C)|關閉視窗',
  '_Contents|Help contents' => '內文(_C)|說明內文',
  '_Copy Page...|Copy page' => '複製書頁(_C)...|複製書頁',
  '_Copy|Copy' => '複製(_C)|複製',
  '_Date and Time...|Insert date' => '日期時間(_D)...|加入日期時間',
  '_Delete Page|Delete page' => '刪除書頁(_D)|刪除書頁',
  '_Delete|Delete' => '刪除(_D)|刪除',
  '_Discard changes' => '放棄修改(_D)',
  '_Edit' => '_編輯',
  '_Edit Equation' => '編輯方程式(_E)',
  '_Edit Link' => '編輯連結(_E)',
  '_Edit Link...|Edit link' => '編輯連結(_E)...|編輯連結',
  '_Edit|' => '編輯(_E)|',
  '_FAQ|FAQ' => '常見問題(_F)|常見問題',
  '_File|' => '檔案(_F)|',
  '_Filter' => '篩選條件(_F)',
  '_Find...|Find' => '尋找(_F)...|尋找',
  '_Forward|Go page forward' => '下一頁(_F)|到下一頁',
  '_Go|' => '到(_G)|',
  '_Help|' => '說明(_H)|',
  '_History|.' => '歷史紀錄(_H)|.',
  '_Home|Go home' => '書冊首頁(_H)|到書冊首頁',
  '_Image...|Insert image' => '圖像(_I)...|加入圖像',
  '_Index|Show index' => '索引(_I)|顯示索引',
  '_Insert' => '加入(_I)',
  '_Insert|' => '加入(_I)|',
  '_Italic|Italic' => '斜體字(_I)|斜體字',
  '_Jump To...|Jump to page' => '跳至(_J)...|跳至某頁',
  '_Keybindings|Key bindings' => '組合鍵(_K)|組合鍵',
  '_Link' => '連結(_L)',
  '_Link to date' => '日期連結(_L)',
  '_Link...|Insert link' => '連結(_L)...|加入連結',
  '_Link|Link' => '連結(_L)|連結',
  '_Namespace|.' => '名稱標示(_N)|.',
  '_New Page|New page' => '新書頁(_N)|新書頁',
  '_Next' => '下一個(_N)',
  '_Next in index|Go to next page' => '索引下一條(_N)|至索引下一條',
  '_Normal|Normal' => '正體字(_N)|正體字',
  '_Notebook Changes...' => '書冊修訂(_N)...',
  '_Open Another Notebook...|Open notebook' => '開啟其他書冊(_O)...|開啟書冊',
  '_Open link' => '開啟連結(_O)',
  '_Overwrite' => '覆寫(_O)',
  '_Page' => '個別書頁(_P)',
  '_Page Changes...' => '書頁修訂(_P)...',
  '_Parent|Go to parent page' => '上層(父)頁面(_P)|到上層(父)頁面',
  '_Paste|Paste' => '貼上(_P)|貼上',
  '_Preview' => '預覽(_P)',
  '_Previous' => '上一個(_P)',
  '_Previous in index|Go to previous page' => '索引上一條(_P)|至索引上一條',
  '_Properties' => '屬性(_P)',
  '_Quit|Quit' => '離開(_Q)|離開程式',
  '_Recent pages|.' => '最近使用頁面(_R)|.',
  '_Redo|Redo' => '放棄回復(_R)|放棄回復',
  '_Reload|Reload page' => '重新載入(_R)|重新載入書頁',
  '_Rename' => '更名(_R)',
  '_Rename Page...|Rename page' => '書頁更名(_R)...|更名書頁',
  '_Replace' => '代換(_R)',
  '_Replace...|Find and Replace' => '代換(_R)...|尋找及代換',
  '_Reset' => '重新設定(_R)',
  '_Restore Version...' => '版本回復(_R)...',
  '_Save Copy' => '儲存副本(_S)',
  '_Save a copy...' => '儲存副本(_S)...',
  '_Save|Save page' => '存檔(_S)|書頁存檔',
  '_Screenshot...|Insert screenshot' => '螢幕快照(_S)...|加入螢幕快照',
  '_Search...|Search' => '跨頁搜尋(_S)...|跨頁搜尋',
  '_Search|' => '搜尋(_S)|',
  '_Send To...|Mail page' => '郵寄至(_S)..|郵寄書頁',
  '_Statusbar|Show statusbar' => '狀態列(_S)|顯示狀態列',
  '_TODO List...|Open TODO List' => '待辦事項(_T)...|開啟待辦事項',
  '_Today' => '今天(_T)',
  '_Toolbar|Show toolbar' => '工具列(_T)|顯示工具列',
  '_Tools|' => '工具(_T)|',
  '_Underline|Underline' => '底線字(_U)|底線字',
  '_Undo|Undo' => '回復(_U)|回復',
  '_Update links in this page' => '更新此書頁之連結(_U)',
  '_Update {number} page linking here' => [
    '更新連結至此的  {number} 張書頁(_U)'
  ],
  '_Verbatim|Verbatim' => '無格式逐字(_V)|無格式逐字',
  '_Versions...|Versions' => '版本(_V)...|版本',
  '_View|' => '檢視(_V)|',
  '_Word Count|Word count' => '統計字數(_W)|統計字數',
  'other...' => '其他...',
  '{name}_(Copy)' => '{name}_(副本)',
  '{number} _Back link' => [
    '{number} 個_反向連結'
  ],
  '{number} item total' => [
    '共有 {number} 個事項'
  ]
};
