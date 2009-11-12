# Simplified Chinese translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Aron Xu (zh_CN)
# Cheese Lee (zh_CN)
# Junnan Wu (zh_CN)
# rainofchaos (zh_CN)
# 太和 (zh_CN)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-12-20 05:51+0000
# Last-Translator: Junnan Wu <Unknown>
# Language-Team: Simplified Chinese <zh_CN@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=1; plural=0;
# X-Launchpad-Export-Date: 2009-02-17 18:56+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; 0},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>删除页面</b>

确定删除页面 \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>启用版本控制</b>

此笔记本尚未开启版本控制.
是否启用?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>文件夹不存在。</b>

文件夹： {path}
不存在， 是否要创建它？',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>页面已经存在</b>

页面\'{name}\'
已经存在。
是否覆盖？',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>要回复到已保存的版本吗？</b>

要将页:{page}
回复到已保存版本:{version}吗？

上次保存版本以后的改动将会被丢弃！',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>将日历页升级到 0.24 格式?</b>

此记事本包含使用年_月_日格式的页面.
而 Zim 0.24 默认使用年:月:日格式, 这样没
月都可以有自己的名称空间.

是否使用升级此记事本，以使用新格式?
',
  'Add \'tearoff\' strips to the menus' => '为菜单增加剪切线',
  'Application show two text files side by side' => '同时显示两个文本文件的程序',
  'Application to compose email' => '创建邮件的程序',
  'Application to edit text files' => '编辑文本的程序',
  'Application to open directories' => '打开目录的程序',
  'Application to open urls' => '打开 URL 的程序',
  'Attach _File|Attach external file' => '附件(_F)|附加外部文件',
  'Attach external files' => '附加外部文件',
  'Auto-format entities' => '自动格式化标题',
  'Auto-increment numbered lists' => '自动增加数字列表中的项',
  'Auto-link CamelCase' => '自动链接首字母大写的短语',
  'Auto-link files' => '自动链接文件',
  'Auto-save version on close' => '关闭时自动保存版本',
  'Auto-select words' => '自动选择单词',
  'Automatically increment items in a numbered list' => '自动增加数字列表中的项',
  'Automatically link file names when you type' => '输入时自动链接文件名',
  'Automaticly link CamelCase words when you type' => '输入时自动链接首字母大写的词组',
  'Automaticly select the current word when you toggle the format' => '转换格式时自动选择当前单词',
  'Bold' => '粗体',
  'Calen_dar|Show calendar' => '日历(_D)|显示日历',
  'Calendar' => '日历',
  'Can not find application "bzr"' => '没有找到应用程序"bzr"',
  'Can not find application "{name}"' => '没有找到应用程序"{name}"',
  'Can not save a version without comment' => '无法保存没有注释的版本',
  'Can not save to page: {name}' => '无法保存到页面: {name}',
  'Can\'t find {url}' => '无法找到 {url}',
  'Cha_nge' => '更改(_N)',
  'Chars' => '字符',
  'Check _spelling|Spell check' => '拼写检查(_S)|拼写检查',
  'Check checkbox lists recursive' => '递归选中复选框序列',
  'Checking a checkbox list item will also check any sub-items' => '选中一个复选框时自动选中其子项',
  'Choose {app_type}' => '选择 {app_type}',
  'Co_mpare Page...' => '对比页面(_M)...',
  'Command' => '命令',
  'Comment' => '备注',
  'Compare this version with' => '对比版本：',
  'Copy Email Address' => '复制电子邮件地址',
  'Copy Location|Copy location' => '复制地址|复制地址',
  'Copy _Link' => '复制链接(_L)',
  'Could not delete page: {name}' => '无法删除页面: {name}',
  'Could not get annotated source for page {page}' => '无法找到页面 {page} 的注释源',
  'Could not get changes for page: {page}' => '无法找到页面 {page} 的修改',
  'Could not get changes for this notebook' => '无法获得此笔记本的改动',
  'Could not get file for page: {page}' => '无法找到页面 {page} 的文件',
  'Could not get versions to compare' => '无法找到对比版本',
  'Could not initialize version control' => '无法初始化版本控制',
  'Could not load page: {name}' => '无法载入页面:{name}',
  'Could not rename {from} to {to}' => '无法从{from} 重命名为 {to}',
  'Could not save page' => '无法保存页面',
  'Could not save version' => '无法保存版本',
  'Creating a new link directly opens the page' => '创建新链接是直接打开页面',
  'Creation Date' => '创建日期',
  'Cu_t|Cut' => '剪切(_T)|剪切',
  'Current' => '当前',
  'Customise' => '自定义',
  'Date' => '日期',
  'Default notebook' => '默认记事本',
  'Details' => '详细信息',
  'Diff Editor' => '差异编辑器',
  'Diff editor' => '查看差异(Diff)的编辑器',
  'Directory' => '目录',
  'Document Root' => '文档根目录',
  'E_quation...|Insert equation' => '公式(_Q)...|插入公式',
  'E_xport...|Export' => '导出(_X)...|导出',
  'E_xternal Link...|Insert external link' => '外部链接(_X)|插入外部链接',
  'Edit Image' => '编辑图像',
  'Edit Link' => '编辑链接',
  'Edit Query' => '编辑查询',
  'Edit _Source|Open source' => '编辑源文件(_S)|打开源文件',
  'Edit notebook' => '编辑记事本',
  'Edit text files "wiki style"' => '编辑文本文件“维基风格”',
  'Editing' => '编辑',
  'Email client' => '邮件客户端',
  'Enabled' => '已启用',
  'Equation Editor' => '公式编辑器',
  'Equation Editor Log' => '公式编辑器日志',
  'Expand side pane' => '扩展侧边栏',
  'Export page' => '导出页面',
  'Exporting page {number}' => '导出页面 {number}',
  'Failed to cleanup SVN working copy.' => '清除临时文件失败',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => '无法加载SVN插件，确认安装subversion工具了吗？',
  'Failed to load plugin: {name}' => '没有加载成功的插件:{name}',
  'Failed update working copy.' => '清除临时文件失败',
  'File browser' => '文件浏览器',
  'File is not a text file: {file}' => '不是文本文件: {file}',
  'Filter' => '过滤器',
  'Find' => '查找',
  'Find Ne_xt|Find next' => '查找下一个(_X)|查找下一个',
  'Find Pre_vious|Find previous' => '查找上一个(_V)|查找上一个',
  'Find and Replace' => '查找替换',
  'Find what' => '查找',
  'Follow new link' => '进入新链接',
  'For_mat|' => '格式(_M)|',
  'Format' => '格式',
  'General' => '常规',
  'Go to "{link}"' => '跳转到 "{link}"',
  'H_idden|.' => '隐藏(_H)|',
  'Head _1|Heading 1' => '标题 1( _1)|标题 1',
  'Head _2|Heading 2' => '标题 2( _2)|标题 2',
  'Head _3|Heading 3' => '标题 3( _3)|标题 3',
  'Head _4|Heading 4' => '标题 4( _4)|标题 4',
  'Head _5|Heading 5' => '标题 5( _5)|标题 5',
  'Head1' => '标题 1',
  'Head2' => '标题 2',
  'Head3' => '标题 3',
  'Head4' => '标题 4',
  'Head5' => '标题 5',
  'Height' => '高度',
  'Home Page' => '主页',
  'Icon' => '图标',
  'Id' => '编号',
  'Include all open checkboxes' => '加入所有打开的复选框',
  'Index page' => '索引页',
  'Initial version' => '初始版本',
  'Insert Date' => '插入日期',
  'Insert Image' => '插入图片',
  'Insert Link' => '插入链接',
  'Insert from file' => '从文件插入',
  'Interface' => '界面',
  'Italic' => '斜体',
  'Jump to' => '跳转到',
  'Jump to Page' => '跳转到页面',
  'Lines' => '行',
  'Links to' => '链接到',
  'Match c_ase' => '匹配大小写(_A)',
  'Media' => '媒体',
  'Modification Date' => '修改日期',
  'Name' => '名称',
  'New notebook' => '新建记事本',
  'New page' => '新页面',
  'No such directory: {name}' => '没有这个目录：{name}',
  'No such file or directory: {name}' => '没有这个文件或目录：{name}',
  'No such file: {file}' => '无此文件:{file}',
  'No such notebook: {name}' => '没有这个笔记本：{name}',
  'No such page: {page}' => '无此页:{page}',
  'No such plugin: {name}' => '没有的插件:{name}',
  'Normal' => '普通',
  'Not Now' => '以后再说',
  'Not a valid page name: {name}' => '页面名称不合法: {name}',
  'Not an url: {url}' => '这不是一个 url：{url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => '注意，如果链接到不存在的页面
将会自动创建一个新页。',
  'Notebook' => '记事本',
  'Notebooks' => '记事本',
  'Open Document _Folder|Open document folder' => '打开文档文件夹(_F)|打开文档文件夹',
  'Open Document _Root|Open document root' => '打开文档根目录(_R)|打开文档根目录',
  'Open _Directory' => '打开文件夹(_D)',
  'Open notebook' => '打开记事本',
  'Other...' => '其它...',
  'Output' => '输出',
  'Output dir' => '输出目录',
  'P_athbar type|' => '路径栏类型(_A)|',
  'Page' => '页面',
  'Page Editable|Page editable' => '页面可编辑|页面可编辑',
  'Page name' => '页面名称',
  'Pages' => '页面',
  'Password' => '密码',
  'Please enter a comment for this version' => '请为此版本添加一个注释',
  'Please enter a name to save a copy of page: {page}' => '请输入页面 {page} 的副本名称:',
  'Please enter a {app_type}' => '请输入一个 {app_type}',
  'Please give a page first' => '请先提供页面',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => '请至少为您的页面提供一个目录。
对于新的记事本来说应该是空目录。
例如在您的主目录中的 "记事本"目录。',
  'Please provide the password for
{path}' => '请输入{path}的密码',
  'Please select a notebook first' => '请先选择一个记事本',
  'Please select a version first' => '请先选择一个版本',
  'Plugin already loaded: {name}' => '已经加载的插件:{name}',
  'Plugins' => '插件',
  'Pr_eferences|Preferences dialog' => '首选项(_E)|首选项对话框',
  'Preferences' => '首选项',
  'Prefix document root' => '文档前缀',
  'Print to Browser|Print to browser' => '打印到浏览器|打印到浏览器',
  'Prio' => '优先级',
  'Proper_ties|Properties dialog' => '属性(_T)|属性对话框',
  'Properties' => '属性',
  'Rank' => '排名',
  'Re-build Index|Rebuild index' => '重建索引|重建索引',
  'Recursive' => '包含子页面',
  'Rename page' => '重命名页',
  'Rename to' => '重命名为',
  'Replace _all' => '全部替换(_A)',
  'Replace with' => '替换为',
  'SVN cleanup|Cleanup SVN working copy' => '清除SVN临时文件',
  'SVN commit|Commit notebook to SVN repository' => '读取SVN库',
  'SVN update|Update notebook from SVN repository' => 'SVN 更新|从SVN库更新笔记本',
  'S_ave Version...|Save Version' => '保存版本(_A)...|保存版本',
  'Save Copy' => '保存副本',
  'Save version' => '保存版本',
  'Scanning tree ...' => '扫描树...',
  'Search' => '查找',
  'Search _Backlinks...|Search Back links' => '查找链接(_B)...|查找链接',
  'Select File' => '选择文件',
  'Select Folder' => '选择文件夹',
  'Send To...' => '发送到...',
  'Show cursor for read-only' => '只读时仍然显示光标',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => '即使不能编辑页面，也显示光标。这样可以更好的用键盘浏览。',
  'Slow file system' => '慢文件系统',
  'Source' => '源代码',
  'Source Format' => '源格式',
  'Start the side pane with the whole tree expanded.' => '启动侧边栏时扩展整个树',
  'Stri_ke|Strike' => '划掉(_K)|划掉',
  'Strike' => '删除线',
  'TODO List' => '任务列表',
  'Task' => '任务',
  'Tearoff menus' => '剪切线',
  'Template' => '模板',
  'Text' => '文字',
  'Text Editor' => '文本编辑器',
  'Text _From File...|Insert text from file' => '从文件导入文字(_F)...|从文件导入文字',
  'Text editor' => '文本编辑器',
  'The equation failed to compile. Do you want to save anyway?' => '无法编译公式.仍然保存？',
  'The equation for image: {path}
is missing. Can not edit equation.' => '无法找到图像: {path}
的公式，无法编辑公式。',
  'This notebook does not have a document root' => '此笔记本无文档根目录',
  'This page does not exist
404' => '此页不存在
404',
  'This page does not have a document folder' => '此页面无文档文件夹',
  'This page does not have a source' => '此页面没有源代码',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => '请对文件进行更新（工具>更新SVN）',
  'To_day|Today' => '今天(_D)|今天',
  'Toggle Chechbox \'V\'|Toggle checkbox' => '选中复选框 \'V\'|切换复选框',
  'Toggle Chechbox \'X\'|Toggle checkbox' => '选中复选框 \'X\'|切换复选框',
  'Underline' => '下划线',
  'Updating links' => '更新链接',
  'Updating links in {name}' => '更新{name}中的链接',
  'Updating..' => '更新...',
  'Use "Backspace" to un-indent' => '用退格键取消自动缩进',
  'Use "Ctrl-Space" to switch focus' => '用 "Ctrl-Space" 转换焦点',
  'Use "Enter" to follow links' => '输入回车进入链接',
  'Use autoformatting to type special characters' => '输入特别的字符时自动格式化',
  'Use custom font' => '使用自定义字体',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => '用退格键取消圆球列表的自动缩进(和 "Shift-Tab" 相同)',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => '用 "Ctrl-Space" 组合键在文字和侧边栏之间转换焦点，如果禁用仍然可以使用"Alt-Space".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => '输入回车进入链接，如果禁用仍然可以使用"Alt-Enter"',
  'User' => '用户',
  'User name' => '用户名',
  'Verbatim' => '逐字',
  'Versions' => '版本',
  'View _Annotated...' => '查看注释(_A)...',
  'View _Log' => '查看日志(_L)',
  'Web browser' => '网页浏览器',
  'Whole _word' => '整词查找(_W)',
  'Width' => '宽度',
  'Word Count' => '字数统计',
  'Words' => '字',
  'You can add rules to your search query below' => '可以为查询添加规则',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => '你可以选择使用<b>Bazaar</b>或者<b>Subversion</b>版本控制系统
请点击“帮助”以了解系统要求',
  'You have no {app_type} configured' => '您没有配置 {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => '重启应用程序后
查检才会启用。',
  'Your name; this can be used in export templates' => '你的名字；将会用在导出模板中',
  'Zim Desktop Wiki' => 'Zim 桌面维基',
  '_About|About' => '关于(_A)|关于',
  '_All' => '全部(_A)',
  '_Back|Go page back' => '后退(_B)|回到上一页',
  '_Bold|Bold' => '加粗(_B)|加粗',
  '_Browse...' => '浏览(_B)...',
  '_Bugs|Bugs' => '程序漏洞(_B)|程序漏洞',
  '_Child|Go to child page' => '子页面(_C)|转到子页面',
  '_Close|Close window' => '关闭(_C)|关闭窗口',
  '_Contents|Help contents' => '内容(_C)|帮助内容',
  '_Copy Page...|Copy page' => '复制页面(_C)...|复制页面',
  '_Copy|Copy' => '复制(_C)|复制',
  '_Date and Time...|Insert date' => '日期时间(_D)...|插入日期',
  '_Delete Page|Delete page' => '删除页面(_D)|删除页面',
  '_Delete|Delete' => '删除(_D)|删除',
  '_Discard changes' => '放弃更改(_D)',
  '_Edit' => '编辑(_E)',
  '_Edit Equation' => '编辑公式(_E)',
  '_Edit Link' => '编辑链接(_E)',
  '_Edit Link...|Edit link' => '编辑链接(_E)|编辑链接',
  '_Edit|' => '编辑(_E)|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '文件(_F)|',
  '_Filter' => '过滤器(_F)',
  '_Find...|Find' => '查找(_F)...|查找',
  '_Forward|Go page forward' => '前进(_F)|到下一页',
  '_Go|' => '转到(_G)|',
  '_Help|' => '帮助(_H)|',
  '_History|.' => '历史(_H)|.',
  '_Home|Go home' => '主页面(_H)|转到主页面',
  '_Image...|Insert image' => '图像(_I)|插入图像',
  '_Index|Show index' => '索引(_I)|显示索引',
  '_Insert' => '插入(_I)',
  '_Insert|' => '插入(_I)|',
  '_Italic|Italic' => '斜体(_I)|斜体',
  '_Jump To...|Jump to page' => '跳转到(_J)...|跳转到页面',
  '_Keybindings|Key bindings' => '键绑定(_K)|键绑定',
  '_Link' => '链接(_L)',
  '_Link to date' => '链接到日期(_L)',
  '_Link...|Insert link' => '链接(_L)...|插入链接',
  '_Link|Link' => '链接(_L)|链接',
  '_Namespace|.' => '名称空间(_N)|.',
  '_New Page|New page' => '新建页面(_N)|新建页面',
  '_Next' => '下一个(_N)',
  '_Next in index|Go to next page' => '索引中的后一页(_N)|转到后一页',
  '_Normal|Normal' => '正常(_N)|正常',
  '_Notebook Changes...' => '笔记本更改(_N)...',
  '_Open Another Notebook...|Open notebook' => '打开另一个笔记本(_O)...|打开笔记本',
  '_Open link' => '打开连接(_O)',
  '_Overwrite' => '覆盖(_O)',
  '_Page' => '页面(_P)',
  '_Page Changes...' => '页面更改(_P)...',
  '_Parent|Go to parent page' => '向上(_P)|到上一级页面',
  '_Paste|Paste' => '粘贴(_P)|粘贴',
  '_Preview' => '预览(_P)',
  '_Previous' => '上一个（_P）',
  '_Previous in index|Go to previous page' => '索引中的前一页(_P)|转到前一页',
  '_Properties' => '属性(_P)',
  '_Quit|Quit' => '退出(_Q)|退出',
  '_Recent pages|.' => '最近打开的页面(_R)|.',
  '_Redo|Redo' => '重做(_R)|重做',
  '_Reload|Reload page' => '重新载入(_R)|重新载入页面',
  '_Rename' => '重命名(_R)',
  '_Rename Page...|Rename page' => '重命名页面(_R)...|重命名页面',
  '_Replace' => '替换(_R)',
  '_Replace...|Find and Replace' => '替换(_R)...｜查找与替换',
  '_Reset' => '重置(_R)',
  '_Restore Version...' => '恢复版本(_R)...',
  '_Save Copy' => '保存副本(_S)',
  '_Save a copy...' => '保存副本(_S)',
  '_Save|Save page' => '保存(_S)|保存页面',
  '_Screenshot...|Insert screenshot' => '截图(_S)...|插入截图',
  '_Search...|Search' => '搜索(_S)...|搜索',
  '_Search|' => '搜索(_S)|',
  '_Send To...|Mail page' => '发送到(_S)...|发送页面',
  '_Statusbar|Show statusbar' => '状态栏(_S)|显示状态栏',
  '_TODO List...|Open TODO List' => '任务列表(_T)...｜打开任务列表',
  '_Today' => '今天(_T)',
  '_Toolbar|Show toolbar' => '工具栏(_T)|显示工具栏',
  '_Tools|' => '工具(_T)|',
  '_Underline|Underline' => '下划线(_U)|下划线',
  '_Undo|Undo' => '撤销(_U)|撤销',
  '_Update links in this page' => '更新此页中的链接(_U)',
  '_Update {number} page linking here' => [
    '更新了 {number} 个页面链接'
  ],
  '_Verbatim|Verbatim' => '逐字(_V)|逐字',
  '_Versions...|Versions' => '版本(_V)...|版本',
  '_View|' => '查看(_V)|',
  '_Word Count|Word count' => '字数统计(_W)|字数统计',
  'other...' => '其它...',
  '{name}_(Copy)' => '{name}_(复制)',
  '{number} _Back link' => [
    '{number} 链接(_B)'
  ],
  '{number} item total' => [
    '共 {number} 项'
  ]
};
