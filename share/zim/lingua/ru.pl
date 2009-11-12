# Russian translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Andrew Kuzminov (ru)
# Gofer (ru)
# Nikolay A. Fetisov (ru)
# Tverd (ru)
# Vladimir Sharshov (ru)
# Vyacheslav Kurenyshev (ru)
# X-Ander (ru)
# fido_max (ru)
# sanya (ru)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-11-11 14:55+0000
# Last-Translator: fido_max <Unknown>
# Language-Team: Russian <ru@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=3; plural=n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;
# X-Launchpad-Export-Date: 2008-11-12 17:32+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n%10==1 && $n%100!=11 ? 0 : $n%10>=2 && $n%10<=4 && ($n%100<10 || $n%100>=20) ? 1 : 2},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Удаление страницы</b>

Вы уверены, что хотите удалить
страницу \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Включить контроль текста</b>

Контроль текста не включен для этого блокнота.
Вы хотите включить его ?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Папка не существует</b>

Папка : {path}
не существует, хотите её сейчас создать?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Страница уже существует</b>

Страница \'{name}\'
уже существует.
Хотите перезаписать её?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Восстановить сохраненный текст страницы?</b>

Вы хотите восстановить сохраненный текст: {version} 
страницы: {page}?

Все несохраненные изменения будут потеряны!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Обновить страницы календаря до формата версии 0.24?</b>

Эта записная книга содержит страницы с датами в формате гггг_мм_дд.
С версии Zim 0.24 формат гггг:мм:дд используется по умолчанию,
создавая пространство имен каждый месяц.

Хотите ли вы преобразовать эту записную книгу в новый формат?
',
  'Add \'tearoff\' strips to the menus' => 'Добавить разделители в меню',
  'Application show two text files side by side' => 'Приложение показывает два текстовых файла рядом',
  'Application to compose email' => 'Почтовый клиент',
  'Application to edit text files' => 'Приложение для редактирования текстовых файлов',
  'Application to open directories' => 'Файловый браузер',
  'Application to open urls' => 'Веб браузер',
  'Attach _File|Attach external file' => 'Прикрепить _файл|Прикрепить внешний файл',
  'Attach external files' => 'Прикрепить внешний файл',
  'Auto-format entities' => 'Автоматически форматировать объекты',
  'Auto-increment numbered lists' => 'Автоматическая нумерация числовых списков',
  'Auto-link CamelCase' => '',
  'Auto-link files' => 'Автоматически создавать ссылку на файлы',
  'Auto-save version on close' => 'Автосохранение текста при закрытии',
  'Auto-select words' => 'Автоматический выбор слов',
  'Automatically increment items in a numbered list' => 'Автоматически нумеруйте элементы в числовых списке',
  'Automatically link file names when you type' => 'Автоматически ссылаться на файл после набора полного пути, включаещего его имя',
  'Automaticly link CamelCase words when you type' => 'Автоматически связывать CamelCase слова, когда вы вводите текст',
  'Automaticly select the current word when you toggle the format' => 'Автоматически выделить текущее слово когда вы переключаете формат',
  'Bold' => 'Жирный',
  'Calen_dar|Show calendar' => 'Кален_дарь|Показать календарь',
  'Calendar' => 'Календарь',
  'Can not find application "bzr"' => 'Не найдено приложение "bzr"',
  'Can not find application "{name}"' => 'Невозможно найти приложение "{name}"',
  'Can not save a version without comment' => 'Невозможно сохранить текст без комментария',
  'Can not save to page: {name}' => 'Невозможно сохранить на страницу: {name}',
  'Can\'t find {url}' => 'Адрес(url) {url} не найден',
  'Cha_nge' => 'Изме_нить',
  'Chars' => 'Символов',
  'Check _spelling|Spell check' => 'Проверка _орфографии|Проверка орфографии',
  'Check checkbox lists recursive' => '',
  'Checking a checkbox list item will also check any sub-items' => 'Проверка элемента выборного списка также автоматически проверит любой дочерний элемент',
  'Choose {app_type}' => 'Выбирете {app_type}',
  'Co_mpare Page...' => 'Страница ср_авнения',
  'Command' => 'Команда',
  'Comment' => 'Комментарий',
  'Compare this version with' => 'Сравнить этот текст с',
  'Copy Email Address' => 'Скопировать электронный адрес',
  'Copy Location|Copy location' => 'Скопировать местоположение|Скопировать местоположение',
  'Copy _Link' => 'Скопировать _ссылку',
  'Could not delete page: {name}' => 'Невозможно удалить страницу: {name}',
  'Could not get annotated source for page {page}' => 'Не удалось получить снабжённый комментариями источник для страницы {page}',
  'Could not get changes for page: {page}' => 'Не удалось получить изменения для страницы: {page}',
  'Could not get changes for this notebook' => 'Не удалось получить изменение для этой записной книги',
  'Could not get file for page: {page}' => 'Не удалось получить файл для страницы: {page}',
  'Could not get versions to compare' => 'Не удалось получить тексты для сравнения',
  'Could not initialize version control' => 'Невозможно инициализировать контроль текста',
  'Could not load page: {name}' => 'Невозможно загрузить страницу:  {name}',
  'Could not rename {from} to {to}' => 'Невозможно переименовать {from} в {to}',
  'Could not save page' => 'Невозможно сохранить страницу',
  'Could not save version' => 'Невозможно сохранить текст',
  'Creating a new link directly opens the page' => 'Создавать новую ссылку путем прямого открытия страницы',
  'Creation Date' => 'Дата создания',
  'Cu_t|Cut' => 'Выре_зать|Вырезать',
  'Current' => 'Текущая',
  'Customise' => 'Настройки',
  'Date' => 'Дата',
  'Default notebook' => 'Блокнот по умолчанию',
  'Details' => 'Подробнее',
  'Diff Editor' => 'Редактор различий',
  'Diff editor' => 'Редактор различий',
  'Directory' => 'Папка',
  'Document Root' => 'Корневая папка документа',
  'E_quation...|Insert equation' => 'Ф_ормула...|Вставить формулу',
  'E_xport...|Export' => 'Э_кспорт...|Экспорт',
  'E_xternal Link...|Insert external link' => 'Вне_шняя ссылка...|Вставка внешней ссылки',
  'Edit Image' => 'Редактировать изображение',
  'Edit Link' => 'Редактировать ссылку',
  'Edit Query' => 'Правка запроса',
  'Edit _Source|Open source' => 'Редактировать _',
  'Edit notebook' => 'Редактировать блокнот',
  'Edit text files "wiki style"' => 'Редактировать текстовые файлы в стиле "wiki"',
  'Editing' => 'Редактирование',
  'Email client' => 'Почтовый клиент',
  'Enabled' => 'Включён',
  'Equation Editor' => 'Редактор формул',
  'Equation Editor Log' => 'Журнал редактора формул',
  'Expand side pane' => 'Растянуть боковую панель',
  'Export page' => 'Экспортирование страницы',
  'Exporting page {number}' => 'Экспортировать страницу {number}',
  'Failed to cleanup SVN working copy.' => 'Неудалось очистить рабочую копию SVN',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Не удалось загрузить плагин SVN,
установлены ли утилиты subversion?',
  'Failed to load plugin: {name}' => 'Сбой загрузки плагина: {name}',
  'Failed update working copy.' => 'Не удалось обновить рабочую копию',
  'File browser' => 'Обозреватель файлов',
  'File is not a text file: {file}' => 'Файл не является текстовым: {file}',
  'Filter' => 'Фильтр',
  'Find' => 'Найти',
  'Find Ne_xt|Find next' => 'Найти следу_ющий|Найти следующий',
  'Find Pre_vious|Find previous' => 'Найти пре_дыдущий|Найти предыдущий',
  'Find and Replace' => 'Найти и заменить',
  'Find what' => 'Найти что',
  'Follow new link' => 'Перейти по новой ссылке',
  'For_mat|' => 'Фо_рмат|',
  'Format' => 'Формат',
  'General' => 'Общие',
  'Go to "{link}"' => 'Перейти к "{link}"',
  'H_idden|.' => 'С_крытые|.',
  'Head _1|Heading 1' => 'Заголовок _1|Заголовок 1',
  'Head _2|Heading 2' => 'Заголовок _2|Заголовок 2',
  'Head _3|Heading 3' => 'Заголовок _3|Заголовок 3',
  'Head _4|Heading 4' => 'Заголовок _4|Заголовок 4',
  'Head _5|Heading 5' => 'Заголовок _5|Заголовок 5',
  'Head1' => 'Заголовок1',
  'Head2' => 'Заголовок2',
  'Head3' => 'Заголовок3',
  'Head4' => 'Заголовок4',
  'Head5' => 'Заголовок5',
  'Height' => 'Высота',
  'Home Page' => 'Домашняя страница',
  'Icon' => 'Иконка',
  'Id' => 'Идентификатор',
  'Include all open checkboxes' => 'Добавить все непомеченные позиции для отметки',
  'Index page' => 'Индексная страница',
  'Initial version' => 'Исходный текст',
  'Insert Date' => 'Вставить дату',
  'Insert Image' => 'Вставка изображения',
  'Insert Link' => 'Вставить ссылку',
  'Insert from file' => 'Вставить из файла',
  'Interface' => 'Интерфейс',
  'Italic' => 'Курсив',
  'Jump to' => 'Быстрый переход к',
  'Jump to Page' => 'Быстрый переход к странице',
  'Lines' => 'Строк',
  'Links to' => 'Сослаться на',
  'Match c_ase' => '',
  'Media' => 'Медиа',
  'Modification Date' => 'Дата изменения',
  'Name' => 'Имя',
  'New notebook' => 'Новый блокнот',
  'New page' => 'Новая страница',
  'No such directory: {name}' => 'Папки: {name} не существует',
  'No such file or directory: {name}' => 'Нет такого файла или каталога: {name}',
  'No such file: {file}' => 'Нет такого файла: {file}',
  'No such notebook: {name}' => 'Блокнот {name} не найден.',
  'No such page: {page}' => 'Страница: {page} не найдена',
  'No such plugin: {name}' => 'Плагин не найден: {name}',
  'Normal' => 'Базовый',
  'Not Now' => 'Позже',
  'Not a valid page name: {name}' => 'Недопустимое имя страницы: {name}',
  'Not an url: {url}' => '{url} не является адресом(url)',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Помните, что ссылка на несуществующую страницу
автоматически создает новую страницу.',
  'Notebook' => 'Блокнот',
  'Notebooks' => 'Блокноты',
  'Open Document _Folder|Open document folder' => 'Открыть _папку с документами|Открыть папку с документами',
  'Open Document _Root|Open document root' => 'Открыть _корневую папку с документами|Открыть корневую папку с документами',
  'Open _Directory' => 'Открыть _директорию',
  'Open notebook' => 'Открыть блокнот',
  'Other...' => 'Другие...',
  'Output' => 'Выходные данные',
  'Output dir' => 'Каталог для результата',
  'P_athbar type|' => 'Тип а_дресной панели',
  'Page' => 'Страница',
  'Page Editable|Page editable' => 'Редактируемая Страница|Редактируемая страница',
  'Page name' => 'Имя страницы',
  'Pages' => 'Страницы',
  'Password' => 'Пароль',
  'Please enter a comment for this version' => 'Добавьте комментарий для этого текста',
  'Please enter a name to save a copy of page: {page}' => 'Введите название для сохранения копии страницы: {page}',
  'Please enter a {app_type}' => 'Введите, пожалуйста, {app_type}',
  'Please give a page first' => 'Сначала укажите страницу',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Укажите папку для хранения своих страниц.
Для нового блокнота это должна быть пустая папка.
Например, папка "Записки" в Вашем Домашнем Каталоге.',
  'Please provide the password for
{path}' => 'Введите пароль для
{path}',
  'Please select a notebook first' => 'Выберите сначала блокнот',
  'Please select a version first' => 'Выберите сначала текст',
  'Plugin already loaded: {name}' => 'Плагин уже загружен: {name}',
  'Plugins' => 'Дополнения',
  'Pr_eferences|Preferences dialog' => 'На_стройки|Страница настроек',
  'Preferences' => 'Настройки',
  'Prefix document root' => 'Префикс главной директории',
  'Print to Browser|Print to browser' => 'Печать в бразуер|Печать в браузер',
  'Prio' => 'Приоритет',
  'Proper_ties|Properties dialog' => 'Свойств_а|Окно свойств',
  'Properties' => 'Свойства',
  'Rank' => 'Ранг',
  'Re-build Index|Rebuild index' => 'Пересобрать индекс|Пересобрать индекс',
  'Recursive' => 'Рекурсивный',
  'Rename page' => 'Переименовать страницу',
  'Rename to' => 'Переименовать в',
  'Replace _all' => 'Заменить _все',
  'Replace with' => 'Заменить на',
  'SVN cleanup|Cleanup SVN working copy' => 'Очистить SVN|Очистить рабочую копию SVN',
  'SVN commit|Commit notebook to SVN repository' => 'Сохранить в SVN|Сохранить записную книжку в репозиторий SVN',
  'SVN update|Update notebook from SVN repository' => 'Обновить из SVN|Обновить записную книжку из репозитория SVN',
  'S_ave Version...|Save Version' => 'С_охранить версию...|Сохранить версию',
  'Save Copy' => 'Сохранить копию',
  'Save version' => 'Сохранить текст',
  'Scanning tree ...' => 'Просмотр дерева ...',
  'Search' => 'Поиск',
  'Search _Backlinks...|Search Back links' => 'Найти ссылающихся...|Найти ссылающихся',
  'Select File' => 'Выбор файла',
  'Select Folder' => 'Выбор папки',
  'Send To...' => 'Отправить...',
  'Show cursor for read-only' => 'Показывать курсор для страниц, открытых только для чтения',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Показывать курсор даже когда вы не можете редактировать страницу. Это полезно для просмотра с помощью клавиатуры.',
  'Slow file system' => 'Медленная файловая система',
  'Source' => 'Источник',
  'Source Format' => 'Формат источника',
  'Start the side pane with the whole tree expanded.' => 'Открыть боковую панель с полностью развернутой структурой дерева',
  'Stri_ke|Strike' => 'Вычёр_кивание|Вычёркивание',
  'Strike' => 'Зачеркивание',
  'TODO List' => 'TODO лист',
  'Task' => 'Задача',
  'Tearoff menus' => 'Разделенные меню',
  'Template' => 'Шаблон',
  'Text' => 'Текст',
  'Text Editor' => 'Редактор текста',
  'Text _From File...|Insert text from file' => 'Текст _из файла...|Вставка текста из файла',
  'Text editor' => 'Текстовый редактор',
  'The equation failed to compile. Do you want to save anyway?' => 'Уравнение составлено неправильно. Сохранить в любом случае?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'Уравнение для изображения: {path}
отсутствует. Редактировать уравнение невозможно.',
  'This notebook does not have a document root' => 'У этого блокнота нет корневой папки',
  'This page does not exist
404' => 'Страница не существует
404',
  'This page does not have a document folder' => 'У этой страницы нет своей папки',
  'This page does not have a source' => 'Эта страница не имеет источника',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Эта страница была обновлена в репозитории.
Пожалуйста обновите рабочую копию (Tools -> SVN update).',
  'To_day|Today' => 'Се_годня|Сегодня',
  'Toggle Checkbox \'V\'|Toggle checkbox' => '',
  'Toggle Checkbox \'X\'|Toggle checkbox' => '',
  'Underline' => 'Подчеркивание',
  'Updating links' => 'Обновить ссылки',
  'Updating links in {name}' => 'Обновить ссылки в {name}',
  'Updating..' => 'Обновление...',
  'Use "Backspace" to un-indent' => '',
  'Use "Ctrl-Space" to switch focus' => 'Использовать "Ctrl-Пробел" для переключения фокуса',
  'Use "Enter" to follow links' => 'Использование "Enter" для перехода по ссылкам',
  'Use autoformatting to type special characters' => 'Используйте автоформатирование для ввода специальных символов',
  'Use custom font' => 'Использовать выбранный шрифт',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => '',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Используйте сочетание клавиш "Ctrl-Пробел" для переключения фокуса между текстом и боковой панелью. Если эта опция отключена, вы можете использовать сочетание "Alt-Пробел".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Использование "Enter" для перехода по ссылкам. Если запрещено, все равно можно использовать "Alt-Enter"',
  'User' => 'Пользователь',
  'User name' => 'Имя пользователя',
  'Verbatim' => 'Стенография',
  'Versions' => 'Тексты',
  'View _Annotated...' => 'Показать _снабжённые комментариями',
  'View _Log' => 'Просмотреть _журнал',
  'Web browser' => 'Веб браузер',
  'Whole _word' => 'Всё _слово',
  'Width' => 'Ширина',
  'Word Count' => 'Статистика',
  'Words' => 'Слов',
  'You can add rules to your search query below' => 'Можете добавить правила для вашего поискового запроса ниже',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Вы можете выбрать <b>Bazaar</b> или <b>Subversion</b>, как системы контроля версий.
Нажмите "Справка", чтобы узнать о системных требованиях.',
  'You have no {app_type} configured' => 'Не настроен {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => 'Необходимо перезапустить приложение,
чтобы изменения, вносимый дополнениями, вступили в силу.',
  'Your name; this can be used in export templates' => 'Ваше имя; оно может быть использовано в экспортных шаблонах',
  'Zim Desktop Wiki' => 'Zim Desktop Wiki',
  '_About|About' => '_О программе|О программе',
  '_All' => '_Все',
  '_Back|Go page back' => '_Назад|На предыдущую страницу',
  '_Bold|Bold' => '_Жирный|Жирный',
  '_Browse...' => '_Обзор...',
  '_Bugs|Bugs' => '_Ошибки|Ошибки',
  '_Child|Go to child page' => '_Потомок|Перейти к странице потомка',
  '_Close|Close window' => '_Закрыть|Закрыть окно',
  '_Contents|Help contents' => '_Содержание|Справка',
  '_Copy Page...|Copy page' => '_Копировать страницу...|Копировать страницу',
  '_Copy|Copy' => '_Копировать|Копировать',
  '_Date and Time...|Insert date' => '_Дата и время...|Вставить дату',
  '_Delete Page|Delete page' => '_Удалить страницу|Удалить страницу',
  '_Delete|Delete' => '_Удалить|Удалить',
  '_Discard changes' => '_Отклонить изменения',
  '_Edit' => '_Правка',
  '_Edit Equation' => '_Редактировать формулу',
  '_Edit Link' => '_Редактировать ссылку',
  '_Edit Link...|Edit link' => '_Редактировать ссылку...|Редактирование ссылки',
  '_Edit|' => '_Правка|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_Файл|',
  '_Filter' => '_Фильтр',
  '_Find...|Find' => '_Найти...|Найти',
  '_Forward|Go page forward' => '_Вперед|На следующую страницу',
  '_Go|' => '_Переход',
  '_Help|' => '_Справка|',
  '_History|.' => '_История|.',
  '_Home|Go home' => '_Домашняя|К домашней',
  '_Image...|Insert image' => '_Изображение...|Вставка изображения',
  '_Index|Show index' => '_Индекс|Показать индекс',
  '_Insert' => '_Вставка',
  '_Insert|' => 'В_ставка|',
  '_Italic|Italic' => '_Курсив|Курсив',
  '_Jump To...|Jump to page' => '_Быстрый переход к...|Быстро перейти к странице',
  '_Keybindings|Key bindings' => '_Горячие клавиши|Горячие клавиши',
  '_Link' => '_Ссылка',
  '_Link to date' => '_Ссылка на дату',
  '_Link...|Insert link' => '_Ссылка...|Вставка ссылки',
  '_Link|Link' => '_Ссылка|Ссылка',
  '_Namespace|.' => '_Пространство имён|.',
  '_New Page|New page' => '_Новая страница|Новая страница',
  '_Next' => '_Следующее',
  '_Next in index|Go to next page' => '_Следующий в индексе|К следующей  странице',
  '_Normal|Normal' => '_Обычный|Обычный',
  '_Notebook Changes...' => '_Изменения блокнота...',
  '_Open Another Notebook...|Open notebook' => '_Открыть другой блокнот...|Открыть блокнот',
  '_Open link' => '_Открыть ссылку',
  '_Overwrite' => '_Перезаписать',
  '_Page' => '_Страница',
  '_Page Changes...' => '_Изменения страницы...',
  '_Parent|Go to parent page' => '_Родитель|На родительскую страницу',
  '_Paste|Paste' => '_Вставить|Вставить',
  '_Preview' => '_Предварительный просмотр',
  '_Previous' => '_Предыдущее',
  '_Previous in index|Go to previous page' => '_Предыдущий в индексе|К предыдущей странице',
  '_Properties' => '_Свойства',
  '_Quit|Quit' => '_Выход|Выход',
  '_Recent pages|.' => '_Недавние страницы|.',
  '_Redo|Redo' => '_Повторить|Повторить',
  '_Reload|Reload page' => '_Перезагрузить|Перезагрузить страницу',
  '_Rename' => '_Переименовать',
  '_Rename Page...|Rename page' => '_Переименовать страницу...|Переименовать страницу',
  '_Replace' => '_Заменить',
  '_Replace...|Find and Replace' => '_Заменить...|Найти и заменить',
  '_Reset' => '_Сбросить',
  '_Restore Version...' => '_Восстановить версию...',
  '_Save Copy' => '_Сохранить копию',
  '_Save a copy...' => '_Сохранить копию...',
  '_Save|Save page' => '_Сохранить|Сохранить страницу',
  '_Screenshot...|Insert screenshot' => '_Снимок экрана...|Вставить снимок экрана',
  '_Search...|Search' => '_Поиск...|Поиск',
  '_Search|' => '_Поиск|',
  '_Send To...|Mail page' => '_Отправить в...|Почтовая страница',
  '_Statusbar|Show statusbar' => '_Панель состояний|Показать панель состояний',
  '_TODO List...|Open TODO List' => '_TODO лист...|Открыть TODO лист',
  '_Today' => '_Сегодня',
  '_Toolbar|Show toolbar' => '_Панель инструментов|Показать панель инструментов',
  '_Tools|' => '_Сервис',
  '_Underline|Underline' => '_Подчёркивание|Подчёркивание',
  '_Undo|Undo' => '_Отменить|Отменить',
  '_Update links in this page' => '_Обновить ссылки на этой странице',
  '_Update {number} page linking here' => [
    '_Обновить связь страницы {number}',
    '_Обновить связи страницы {number}',
    '_Обновить связи страницы {number}'
  ],
  '_Verbatim|Verbatim' => '_Стенограмма|Стенограмма',
  '_Versions...|Versions' => '_Версии...|Версии',
  '_View|' => '_Вид|',
  '_Word Count|Word count' => '_Статистика|Статистика',
  'other...' => 'дополнительно...',
  '{name}_(Copy)' => '{name}_(Копировать)',
  '{number} _Back link' => [
    '{number} _Обратная ссылка',
    '{number} _Обратные ссылки',
    '{number} _Обратные ссылки'
  ],
  '{number} item total' => [
    '',
    ''
  ]
};
