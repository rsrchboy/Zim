# Japanese translation for zim
# Copyright (c) 2007 Rosetta Contributors and Canonical Ltd 2007
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2007.
# 
# 
# TRANSLATORS:
# Akihiro Nishimura (ja)
# Katz Kawai (ja)
# orz.inc (ja)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-11-17 20:24+0000
# Last-Translator: Akihiro Nishimura <nimu.zh3@zoho.com>
# Language-Team: Japanese <ja@li.org>
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
page \'{name}\' ?' => '<b>ページの削除</b>

本当に
\'{name}\' を削除しますか？',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>フォルダーは存在しません。</b>

フォルダー: {path}
は存在しません。作成しますか？',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>ページは既に存在します</b>

\'{name}\' は既に存在します。
上書きしますか？',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>カレンダーのページをバージョン0.24のフォーマットに更新しますか？</b>

このノートブックには、yyyy_mm_ddという日付フォーマットが含まれています。
Zim 0.24からの、ディフォルトのフォーマットはyyyy:mm:ddが使われており、
ネームスペースは月ごとになりました。

新しいレイアウトにアップグレードしますか？
',
  'Add \'tearoff\' strips to the menus' => '',
  'Application show two text files side by side' => '',
  'Application to compose email' => 'メールを作成するアプリケーション',
  'Application to edit text files' => 'テキストファイルを編集するアプリケーション',
  'Application to open directories' => 'ディレクトリを開くアプリケーション',
  'Application to open urls' => 'URLを開くアプリケーション',
  'Attach _File|Attach external file' => 'ファイルを添付(_A)|外部ファイルを添付する',
  'Attach external files' => '外部ファイルを添付',
  'Auto-format entities' => '',
  'Auto-increment numbered lists' => '',
  'Auto-link CamelCase' => '',
  'Auto-link files' => '',
  'Auto-save version on close' => '',
  'Auto-select words' => '',
  'Automatically increment items in a numbered list' => '',
  'Automatically link file names when you type' => '',
  'Automaticly link CamelCase words when you type' => '',
  'Automaticly select the current word when you toggle the format' => '',
  'Bold' => '太字',
  'Calen_dar|Show calendar' => 'カレンダー(_D)|カレンダーを表示',
  'Calendar' => 'カレンダー',
  'Can not find application "bzr"' => '"bzr"というアプリケーションが見つかりません。',
  'Can not find application "{name}"' => '',
  'Can not save a version without comment' => '',
  'Can not save to page: {name}' => 'ページに保存できません: {name}',
  'Can\'t find {url}' => '{url} が見つかりません',
  'Cha_nge' => '変更(_N)',
  'Chars' => '文字数',
  'Check _spelling|Spell check' => 'スペルチェック(_S)|スペルチェック',
  'Check checkbox lists recursive' => '',
  'Checking a checkbox list item will also check any sub-items' => '',
  'Choose {app_type}' => '選択 {app_type}',
  'Co_mpare Page...' => '',
  'Command' => 'コマンド',
  'Comment' => '',
  'Compare this version with' => '',
  'Copy Email Address' => '',
  'Copy Location|Copy location' => '場所をコピー|場所をコピー',
  'Copy _Link' => 'リンクをコピー',
  'Could not delete page: {name}' => 'ページを削除できません: {name}',
  'Could not get annotated source for page {page}' => '',
  'Could not get changes for page: {page}' => '',
  'Could not get changes for this notebook' => '',
  'Could not get file for page: {page}' => '',
  'Could not get versions to compare' => '',
  'Could not initialize version control' => 'バージョン管理を初期化できませんでした',
  'Could not load page: {name}' => 'ページをロードできません: {name}',
  'Could not rename {from} to {to}' => '{from} から {to} へ名前を変更できません',
  'Could not save page' => 'ページが保存できません',
  'Could not save version' => 'バージョンを保存できません',
  'Creating a new link directly opens the page' => '',
  'Creation Date' => '作成日時',
  'Cu_t|Cut' => '切り取り(_T)|切り取り',
  'Current' => '',
  'Customise' => '',
  'Date' => '日付',
  'Default notebook' => 'ディフォルトのノートブック',
  'Details' => '詳細情報',
  'Diff Editor' => '',
  'Diff editor' => 'Diffエディタ',
  'Directory' => '',
  'Document Root' => '',
  'E_quation...|Insert equation' => '数式(_Q)...|数式を挿入',
  'E_xport...|Export' => 'エクスポート(_X)|エクスポート',
  'E_xternal Link...|Insert external link' => '外部リンク(_X)...|外部リンクの挿入',
  'Edit Image' => '',
  'Edit Link' => 'リンクの編集',
  'Edit Query' => '',
  'Edit _Source|Open source' => 'ソースを編集(_S)|ソースを開く',
  'Edit notebook' => 'ノートブックの編集',
  'Edit text files "wiki style"' => '"ウィキ形式"の文書を作成します',
  'Editing' => '編集',
  'Email client' => 'メールクライアント',
  'Enabled' => '有効化',
  'Equation Editor' => '数式エディタ',
  'Equation Editor Log' => '数式エディターログ',
  'Expand side pane' => '',
  'Export page' => 'ページのエクスポート',
  'Exporting page {number}' => 'ページをエクスポート {number}',
  'Failed to cleanup SVN working copy.' => '',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'SVNプラグインをロードするのに失敗しました。subversion utilsはインストールしましたか？',
  'Failed to load plugin: {name}' => 'プラグインのロードに失敗しました: {name}',
  'Failed update working copy.' => '',
  'File browser' => 'ファイル・ブラウザ',
  'File is not a text file: {file}' => 'テキストファイルではありません:{file}',
  'Filter' => 'フィルタ',
  'Find' => '',
  'Find Ne_xt|Find next' => '',
  'Find Pre_vious|Find previous' => '前へ(_V)|前へ',
  'Find and Replace' => '検索と置換',
  'Find what' => '検索',
  'Follow new link' => '',
  'For_mat|' => '書式(_M)',
  'Format' => '書式',
  'General' => '全般',
  'Go to "{link}"' => '',
  'H_idden|.' => '隠す(_I)|.',
  'Head _1|Heading 1' => '',
  'Head _2|Heading 2' => '',
  'Head _3|Heading 3' => '',
  'Head _4|Heading 4' => '',
  'Head _5|Heading 5' => '',
  'Head1' => '',
  'Head2' => '見出し2',
  'Head3' => '',
  'Head4' => '',
  'Head5' => '',
  'Height' => '',
  'Home Page' => '',
  'Icon' => 'アイコン',
  'Id' => '',
  'Include all open checkboxes' => '',
  'Index page' => '',
  'Initial version' => '初版',
  'Insert Date' => '日時の挿入',
  'Insert Image' => '画像を挿入',
  'Insert Link' => 'リンクの挿入',
  'Insert from file' => 'ファイルから挿入',
  'Interface' => 'インタフェース',
  'Italic' => 'イタリック体',
  'Jump to' => '',
  'Jump to Page' => '',
  'Lines' => '行数',
  'Links to' => '',
  'Match c_ase' => '',
  'Media' => 'メディア',
  'Modification Date' => '修正日時',
  'Name' => '名前',
  'New notebook' => '新しいノートブック',
  'New page' => '新しいページ',
  'No such directory: {name}' => 'そのようなディレクトリはありません: {name}',
  'No such file or directory: {name}' => 'そのようなファイルもしくはディレクトリはありません:{name}',
  'No such file: {file}' => 'そのようなファイルはありません:{file}',
  'No such notebook: {name}' => 'そのようなノートブックはありません:{name}',
  'No such page: {page}' => 'そのようなページはありません:{page}',
  'No such plugin: {name}' => 'そのプラグインは存在しません: {name}',
  'Normal' => '',
  'Not Now' => '後で',
  'Not a valid page name: {name}' => '不正なページ名: {name}',
  'Not an url: {url}' => 'urlではありません: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => '',
  'Notebook' => '',
  'Notebooks' => 'ノートブック',
  'Open Document _Folder|Open document folder' => 'ドキュメントフォルダを開く(_F)|ドキュメントフォルダを開く',
  'Open Document _Root|Open document root' => 'ドキュメントルートを開く(_R)|ドキュメントルートを開く',
  'Open _Directory' => '',
  'Open notebook' => 'ノートブックを開く',
  'Other...' => '',
  'Output' => '出力',
  'Output dir' => '出力ディレクトリ',
  'P_athbar type|' => 'パスバー形式(_A)|',
  'Page' => 'ページ',
  'Page Editable|Page editable' => '',
  'Page name' => 'ページ名',
  'Pages' => 'ページ',
  'Password' => 'パスワード',
  'Please enter a comment for this version' => 'このバージョンにコメントを入力してください',
  'Please enter a name to save a copy of page: {page}' => '保存したいページを入力してください: {page}',
  'Please enter a {app_type}' => '{app_type} を入力してください',
  'Please give a page first' => '',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => '',
  'Please provide the password for
{path}' => '',
  'Please select a notebook first' => '最初にノートブックを選んでください',
  'Please select a version first' => '',
  'Plugin already loaded: {name}' => 'プラグインは既にロードされています:{name}',
  'Plugins' => 'プラグイン',
  'Pr_eferences|Preferences dialog' => '設定(_E)|設定ダイアログ',
  'Preferences' => '',
  'Prefix document root' => 'ドキュメントルーツの接頭辞',
  'Print to Browser|Print to browser' => '',
  'Prio' => '優先度',
  'Proper_ties|Properties dialog' => 'プロパティ(_T)|プロパティ・ダイアログ',
  'Properties' => 'プロパティ',
  'Rank' => '',
  'Re-build Index|Rebuild index' => 'インデックスを再構築|インデックスを再構築',
  'Recursive' => '',
  'Rename page' => 'ページをリネーム',
  'Rename to' => '名前の変更',
  'Replace _all' => '全て置換(_A)',
  'Replace with' => '置換テキスト',
  'SVN cleanup|Cleanup SVN working copy' => '',
  'SVN commit|Commit notebook to SVN repository' => '',
  'SVN update|Update notebook from SVN repository' => '',
  'S_ave Version...|Save Version' => '',
  'Save Copy' => 'コピーを保存する',
  'Save version' => '',
  'Scanning tree ...' => '',
  'Search' => 'ノートブック内の検索',
  'Search _Backlinks...|Search Back links' => 'リンク元を検索(_B)...|リンク元を検索',
  'Select File' => 'ファイルの選択',
  'Select Folder' => 'フォルダの選択',
  'Send To...' => '送る...',
  'Show cursor for read-only' => '',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => '',
  'Slow file system' => '',
  'Source' => '',
  'Source Format' => 'フォーマット',
  'Start the side pane with the whole tree expanded.' => '',
  'Stri_ke|Strike' => '打ち消し(_K)|打ち消し',
  'Strike' => '取り消し線',
  'TODO List' => 'TODOリスト',
  'Task' => 'タスク名',
  'Tearoff menus' => '',
  'Template' => 'テンプレート',
  'Text' => 'テキスト',
  'Text Editor' => 'テキスト・エディタ',
  'Text _From File...|Insert text from file' => 'ファイルのテキスト(_F)...|ファイルのテキストを挿入',
  'Text editor' => 'テキストエディタ',
  'The equation failed to compile. Do you want to save anyway?' => '数式のコンパイルに失敗しました。それでも保存しますか？',
  'The equation for image: {path}
is missing. Can not edit equation.' => '',
  'This notebook does not have a document root' => 'このノートブックにはドキュメント・ルートがありません',
  'This page does not exist
404' => 'このページは存在しません
404',
  'This page does not have a document folder' => 'このページにはドキュメントフォルダがありません',
  'This page does not have a source' => '',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => '',
  'To_day|Today' => '今日付けのページ(_D)|今日のページ',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'トルグチェックボックス \'V\'|トルグチェックボックス',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'トルグチェックボックス \'X\'|トルグチェックボックス',
  'Underline' => '下線',
  'Updating links' => 'リンクの更新k',
  'Updating links in {name}' => '{name} のリンクを更新',
  'Updating..' => '更新…',
  'Use "Backspace" to un-indent' => '',
  'Use "Ctrl-Space" to switch focus' => '',
  'Use "Enter" to follow links' => '',
  'Use autoformatting to type special characters' => '',
  'Use custom font' => 'カスタムフォントの使用',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => '',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => '',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => '',
  'User' => '',
  'User name' => 'ユーザ名',
  'Verbatim' => '',
  'Versions' => '',
  'View _Annotated...' => '',
  'View _Log' => 'ログの表示(_L)',
  'Web browser' => 'ウェブブラウザ',
  'Whole _word' => '',
  'Width' => '',
  'Word Count' => '',
  'Words' => '単語数',
  'You can add rules to your search query below' => '',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => '',
  'You have no {app_type} configured' => '{app_type} が設定されていません',
  'You need to restart the application
for plugin changes to take effect.' => 'プラグインの変更を反映させるにはこのアプリケーションの再起動が必要です。',
  'Your name; this can be used in export templates' => '',
  'Zim Desktop Wiki' => 'Zim デスクトップ・ウィキ',
  '_About|About' => '情報(_A)|情報',
  '_All' => '全て(_A)',
  '_Back|Go page back' => '戻る(_B)|戻る',
  '_Bold|Bold' => '太字(_B)|太字',
  '_Browse...' => 'ブラウズ(_B)...',
  '_Bugs|Bugs' => 'バグ(_B)|バグ',
  '_Child|Go to child page' => '子ページ(_C)|子ページに進む',
  '_Close|Close window' => '閉じる(_C)|ウインドウを閉じる',
  '_Contents|Help contents' => '目次(_C)|目次',
  '_Copy Page...|Copy page' => 'ページをコピー(_C)|ページをコピー',
  '_Copy|Copy' => 'コピー(_C)|コピー',
  '_Date and Time...|Insert date' => '日時(_D)...|日時の挿入',
  '_Delete Page|Delete page' => 'ページを削除(_D)|ページを削除',
  '_Delete|Delete' => '削除(_D)|削除',
  '_Discard changes' => '変更を破棄する(_D)',
  '_Edit' => '編集(_E)',
  '_Edit Equation' => '数式の編集(_E)',
  '_Edit Link' => 'リンクの編集',
  '_Edit Link...|Edit link' => 'リンクの編集(_E)...|リンクの編集',
  '_Edit|' => '編集(_E)',
  '_FAQ|FAQ' => 'FAQ(_F)|FAQ',
  '_File|' => 'ファイル(_F)',
  '_Filter' => 'フィルタ(_F)',
  '_Find...|Find' => 'ページ内検索(_F)...|ページ内検索',
  '_Forward|Go page forward' => '進む(_F)|進む',
  '_Go|' => '移動(_G)|',
  '_Help|' => 'ヘルプ(_H)|',
  '_History|.' => '履歴(_H)|.',
  '_Home|Go home' => 'ホーム(_H)|ホームへ',
  '_Image...|Insert image' => 'イメージ(_I)...|イメージの挿入',
  '_Index|Show index' => '',
  '_Insert' => '',
  '_Insert|' => '挿入(_I)',
  '_Italic|Italic' => 'イタリック(_I)|イタリック',
  '_Jump To...|Jump to page' => '進む(_J)|ページに進む',
  '_Keybindings|Key bindings' => 'キーバインド(_K)|キーバインド',
  '_Link' => '',
  '_Link to date' => '日時のページへのリンク',
  '_Link...|Insert link' => 'リンク(_L)...|リンクの挿入',
  '_Link|Link' => 'リンク(_L)|リンク',
  '_Namespace|.' => 'ネームスペース(_N)|.',
  '_New Page|New page' => '新しいページ(_N)|新しいページ',
  '_Next' => '次へ(_N)',
  '_Next in index|Go to next page' => '',
  '_Normal|Normal' => '通常(_N)|通常',
  '_Notebook Changes...' => 'ノートブックの変更(_N)',
  '_Open Another Notebook...|Open notebook' => '他のノートブックを開く(_O)...|ノートブックを開く',
  '_Open link' => '',
  '_Overwrite' => '上書きする(_O)',
  '_Page' => 'ページ(_P)',
  '_Page Changes...' => '',
  '_Parent|Go to parent page' => '親ページ(_P)|親ページに進む',
  '_Paste|Paste' => '貼り付け(_P)|貼り付け',
  '_Preview' => 'プレビュー(_P)',
  '_Previous' => '前へ(_P)',
  '_Previous in index|Go to previous page' => '',
  '_Properties' => '',
  '_Quit|Quit' => '終了(_Q)|終了',
  '_Recent pages|.' => '',
  '_Redo|Redo' => 'やり直す(_R)|やり直す',
  '_Reload|Reload page' => '更新(_R)|ページを更新',
  '_Rename' => '名前の変更(_R)',
  '_Rename Page...|Rename page' => 'ページの名前を変更...(_R)|ページの名前を変更',
  '_Replace' => '置換(_R)',
  '_Replace...|Find and Replace' => '置換(_R)...|検索して置換',
  '_Reset' => '',
  '_Restore Version...' => '',
  '_Save Copy' => 'コピーを保存(_S)',
  '_Save a copy...' => 'コピーを保存する…(_S)',
  '_Save|Save page' => '保存(_S)|ページを保存',
  '_Screenshot...|Insert screenshot' => 'スクリーンショット(_S)...|スクリーンショットを挿入',
  '_Search...|Search' => '検索...(_S)|検索',
  '_Search|' => '検索(_S)',
  '_Send To...|Mail page' => '送る(_S)|メールページ',
  '_Statusbar|Show statusbar' => 'ステイタスバー(_S)|ステイタスバーを表示',
  '_TODO List...|Open TODO List' => 'TODOリスト(_T)...|TODOリストを開く',
  '_Today' => '今日(_T)',
  '_Toolbar|Show toolbar' => 'ツールバー(_T)|ツールバーを表示',
  '_Tools|' => 'ツール(_T)',
  '_Underline|Underline' => '下線(_U)|下線',
  '_Undo|Undo' => '元に戻す(_U)|元に戻す',
  '_Update links in this page' => 'このページのリンクを更新する(_U)',
  '_Update {number} page linking here' => [
    '{number} ページへのリンクを更新する(_U)'
  ],
  '_Verbatim|Verbatim' => '整形済み(_V)|整形済み',
  '_Versions...|Versions' => '',
  '_View|' => '編集(_V)',
  '_Word Count|Word count' => '',
  'other...' => 'その他…',
  '{name}_(Copy)' => '{name}コピー(_C)',
  '{number} _Back link' => [
    '',
    ''
  ],
  '{number} item total' => [
    '合計 {number} 個'
  ]
};
