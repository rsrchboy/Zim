# Ukrainian translation for zim
# Copyright (c) 2009 Rosetta Contributors and Canonical Ltd 2009
# This file is distributed under the same license as the zim package.
# Yevgen Gorshkov <ye.gorshkov@gmail.com>, 2009.
# 
# 
# TRANSLATORS:
# atany (uk)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-10-10 23:11+0000
# Last-Translator: atany <Unknown>
# Language-Team: Ukrainian <uk@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=3; plural=n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;
# X-Launchpad-Export-Date: 2010-01-10 10:44+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n%10==1 && $n%100!=11 ? 0 : $n%10>=2 && $n%10<=4 && ($n%100<10 || $n%100>=20) ? 1 : 2},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%A, %e %b %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Видалити сторінку</b>

Ви справді хочете видалити
сторінку \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Увімкнути контроль версій</b>

Контроль версій наразі не увімкнено для цього зошита.
Увімкнути?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Тека не існує </b>

Тека: {path}
ще не існує. Створити її зараз?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Сторінка вже існує</b>

Сторінка \'{name}\'
вже існує.
Перезаписати її?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Відновити сторінку до збереженої версії?</b>

Чи ви бажаєте відновити сторінку: {page}
до збереженої версії: {version} ?

Всі зміни після останньої збереженої версії буде втрачено!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Перетворити сторінки календаря до формату 0.24?</b>

Цей зошит містить сторінки для дат в форматі рррр_мм_дд.
З версії Zim 0.24 типовий формат сторінок: рррр:мм:дд,
та сторінки об’єднані в простори імен за місяцями.

Чи ви бажаєте перетворити цей зошит до нового розміщення?
',
  'Add \'tearoff\' strips to the menus' => 'Додати смужки „відриву“ до меню',
  'Application show two text files side by side' => 'Програма, що показує різницю між двома файлами',
  'Application to compose email' => 'Програма для складання електронних листів',
  'Application to edit text files' => 'Програма для редагування текстових файлів',
  'Application to open directories' => 'Програма для перегляду тек',
  'Application to open urls' => 'Програма для відкриття інтернет адрес',
  'Attach _File|Attach external file' => 'Прикріпити _файл|Прикріпити зовнішній файл',
  'Attach external files' => 'Прикріпити зовнішній файл',
  'Auto-format entities' => 'Авто-перетворення HTML кодів в символи',
  'Auto-increment numbered lists' => 'Авто-приріст для нумерованих списків',
  'Auto-link CamelCase' => 'Авто-перетворення „CamelCase“ в посилання',
  'Auto-link files' => 'Авто-перетворення адрес (файлів) в посилання',
  'Auto-save version on close' => 'Авто-збереження версії при закритті',
  'Auto-select words' => 'Автоматично виділяти слова',
  'Automatically increment items in a numbered list' => 'Автоматично перетворювати послідовні числа в нумеровані списки.',
  'Automatically link file names when you type' => 'Автоматично перетворювати адреси файлів в посилання під час написання',
  'Automaticly link CamelCase words when you type' => 'Автоматично перетворювати „CamelCase“ слова в посилання під час написання',
  'Automaticly select the current word when you toggle the format' => 'Автоматично виділяти поточне слово при застосуванні форматування.',
  'Bold' => 'Жирний',
  'Calen_dar|Show calendar' => '_Календар|Відобразити чи сховати календар',
  'Calendar' => 'Календар',
  'Can not find application "bzr"' => 'Не вдається запустити програму „bzr“',
  'Can not find application "{name}"' => 'Не вдається знайти програму „{name}“',
  'Can not save a version without comment' => 'Для збереження версії потрібний коментар',
  'Can not save to page: {name}' => 'Не вдається зберегти в сторінку: {name}',
  'Can\'t find {url}' => 'Не вдається знайти {url}',
  'Cha_nge' => 'За_мінити',
  'Chars' => 'Символів',
  'Check _spelling|Spell check' => 'Перевірка _орфографії|Перевірка орфографії',
  'Check checkbox lists recursive' => 'Відмічати прапорці рекурсивно',
  'Checking a checkbox list item will also check any sub-items' => 'Встановлення прапорця змінює стан прапорців для всіх нащадків.',
  'Choose {app_type}' => 'Виберіть {app_type}',
  'Co_mpare Page...' => '_Порівняти сторінку…',
  'Command' => 'Команда',
  'Comment' => 'Коментар',
  'Compare this version with' => 'Порівняти цю версію з',
  'Copy Email Address' => 'Копіювати адресу електронної пошти',
  'Copy Location|Copy location' => 'Копіювати адресу|Копіювати адресу сторінки',
  'Copy _Link' => '_Копіювати посилання',
  'Could not delete page: {name}' => 'Неможливо видалити сторінку: {name}',
  'Could not get annotated source for page {page}' => 'Не вдається отримати анотоване джерело для сторінки {page}',
  'Could not get changes for page: {page}' => 'Не вдається знайти зміни для сторінки: {page}',
  'Could not get changes for this notebook' => 'Не вдається знайти зміни для зошита',
  'Could not get file for page: {page}' => 'Не вдається знайти файл для сторінки: {page}',
  'Could not get versions to compare' => 'Не вдається отримати версії для порівняння',
  'Could not initialize version control' => 'Не вдається ініціалізувати систему контролю версій',
  'Could not load page: {name}' => 'Неможливо зберегти сторінку: {name}',
  'Could not rename {from} to {to}' => 'Не вдається перейменувати {from} у {to}',
  'Could not save page' => 'Не вдається зберегти сторінку',
  'Could not save version' => 'Не вдається зберегти версію',
  'Creating a new link directly opens the page' => 'Одразу відкривати сторінку при створенні нового посилання',
  'Creation Date' => 'Дата створення',
  'Cu_t|Cut' => '_Вирізати|Вирізати',
  'Current' => 'Поточний',
  'Customise' => 'Налаштувати',
  'Date' => 'Дата',
  'Default notebook' => 'Типовий зошит',
  'Details' => 'Деталі',
  'Diff Editor' => 'Редактор змін',
  'Diff editor' => 'Програма порівняння файлів',
  'Directory' => 'Тека',
  'Document Root' => 'Тека документів',
  'E_quation...|Insert equation' => '_Формула…|Вставити формулу',
  'E_xport...|Export' => '_Експортувати…|Експортувати',
  'E_xternal Link...|Insert external link' => '_Зовнішнє посилання…|Вставити зовнішнє посилання',
  'Edit Image' => 'Редагувати зображення',
  'Edit Link' => 'Редагувати посилання',
  'Edit Query' => 'Редагувати запит',
  'Edit _Source|Open source' => 'Редагувати д_жерело|Відкрити джерело сторінки в текстовому редакторі',
  'Edit notebook' => 'Редагувати зошит',
  'Edit text files "wiki style"' => 'Редагування текстових файлів в „стилі вікі“',
  'Editing' => 'Редагування',
  'Email client' => 'Клієнт електронної пошти',
  'Enabled' => 'Увімкнено',
  'Equation Editor' => 'Редактор формул',
  'Equation Editor Log' => 'Журнал редактора формул',
  'Expand side pane' => 'Розкрити дерево в бічній панелі',
  'Export page' => 'Експортувати сторінку',
  'Exporting page {number}' => 'Експортування сторінки {number}',
  'Failed to cleanup SVN working copy.' => 'Не вдається очистити робочу копію SVN.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Не вдалося завантажити модуль SVN,
переконайтеся, що subversion встановлено.',
  'Failed to load plugin: {name}' => 'Не вдається завантажити модуль: {name}',
  'Failed update working copy.' => 'Не вдається оновити робочу копію SVN.',
  'File browser' => 'Переглядач файлів',
  'File is not a text file: {file}' => 'Файл не є текстовим: {file}',
  'Filter' => 'Фільтр',
  'Find' => 'Знайти',
  'Find Ne_xt|Find next' => 'Зна_йти далі|Знайти далі',
  'Find Pre_vious|Find previous' => 'Знайти _попередній|Знайти попередній',
  'Find and Replace' => 'Знайти та замінити',
  'Find what' => 'Знайти',
  'Follow new link' => 'Відкривати нове посилання при створенні',
  'For_mat|' => 'Фор_мат|',
  'Format' => 'Формат',
  'General' => 'Загальні',
  'Go to "{link}"' => 'Перейти на „{link}“',
  'H_idden|.' => '_Сховати|',
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
  'Height' => 'Висота',
  'Home Page' => 'Головна сторінка',
  'Icon' => 'Значок',
  'Id' => 'Ідентифікатор',
  'Include all open checkboxes' => 'Включати всі відкриті прапорці',
  'Index page' => 'Назва початкової сторінки',
  'Initial version' => 'Початкова версія',
  'Insert Date' => 'Вставити дату й час',
  'Insert Image' => 'Вставити зображення',
  'Insert Link' => 'Вставити посилання',
  'Insert from file' => 'Вставити з файлу',
  'Interface' => 'Інтерфейс',
  'Italic' => 'Курсив',
  'Jump to' => 'Перейти до',
  'Jump to Page' => 'Перейти до сторінки',
  'Lines' => 'Рядків',
  'Links to' => 'Посилання на',
  'Match c_ase' => 'Збігається _регістр',
  'Media' => 'Носії',
  'Modification Date' => 'Дата зміни',
  'Name' => 'Назва',
  'New notebook' => 'Створити зошит',
  'New page' => 'Створити сторінку',
  'No such directory: {name}' => 'Немає такої теки: {name}',
  'No such file or directory: {name}' => 'Немає такого файлу чи теки: {name}',
  'No such file: {file}' => 'Немає такого файлу: {file}',
  'No such notebook: {name}' => 'Немає такого зашита: {name}',
  'No such page: {page}' => 'Немає такої сторінки: {page}',
  'No such plugin: {name}' => 'Немає такого модуля: {name}',
  'Normal' => 'Звичайний',
  'Not Now' => 'Не зараз',
  'Not a valid page name: {name}' => 'Неправильна назва сторінки {name}',
  'Not an url: {url}' => 'Неприпустима адреса: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Зауважте, що посилання на неіснуючу сторінку
автоматично створює нову сторінку.',
  'Notebook' => 'Зошит',
  'Notebooks' => 'Зошити',
  'Open Document _Folder|Open document folder' => 'Відкрити теку _документів|Відкрити теку документів поточної сторінки',
  'Open Document _Root|Open document root' => 'Відкрити _кореневу теку документів|Відкрити кореневу теку документів',
  'Open _Directory' => 'Відкрити _теку',
  'Open notebook' => 'Відкрити зошит',
  'Other...' => 'Інший…',
  'Output' => 'Вивід',
  'Output dir' => 'Вихідна тека',
  'P_athbar type|' => 'Р_ядок шляху|',
  'Page' => 'Сторінка',
  'Page Editable|Page editable' => 'Сторінка може редагуватися|Сторінка може редагуватися',
  'Page name' => 'Назва сторінки',
  'Pages' => 'Сторінки',
  'Password' => 'Пароль',
  'Please enter a comment for this version' => 'Будь ласка, введіть коментар для цієї версії',
  'Please enter a name to save a copy of page: {page}' => 'Введіть ім’я для копії сторінки: {page}',
  'Please enter a {app_type}' => 'Будь ласка, введіть {app_type}',
  'Please give a page first' => 'Спочатку виберіть сторінку',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Вкажіть принаймні теку для збереження ваших документів.
Для нового зошита це повинна бути пуста тека.
Наприклад, тека „Замітки“ в вашій домашній теці.',
  'Please provide the password for
{path}' => 'Вкажіть пароль для
{path}',
  'Please select a notebook first' => 'Спочатку виберіть зошит',
  'Please select a version first' => 'Спочатку виберіть версію',
  'Plugin already loaded: {name}' => 'Модуль вже завантажено: {name}',
  'Plugins' => 'Модулі',
  'Pr_eferences|Preferences dialog' => '_Параметри|Налаштувати програму',
  'Preferences' => 'Параметри',
  'Prefix document root' => 'Відкрити теку документів',
  'Print to Browser|Print to browser' => 'Друкувати до веб-переглядача|Друкувати до веб-переглядача',
  'Prio' => 'Пріоритет',
  'Proper_ties|Properties dialog' => '_Параметри зошита|Налаштувати параметри зошита',
  'Properties' => 'Параметри',
  'Rank' => 'Ранг',
  'Re-build Index|Rebuild index' => 'Перебудувати _індекс|Перебудувати індекс',
  'Recursive' => 'Рекурсивно',
  'Rename page' => 'Перейменувати сторінку',
  'Rename to' => 'Перейменувати в',
  'Replace _all' => 'Замінити _все',
  'Replace with' => 'Замінити на',
  'SVN cleanup|Cleanup SVN working copy' => 'Очищення SVN|Очистити робочої копії SVN',
  'SVN commit|Commit notebook to SVN repository' => 'Фіксування змін в SVN|Зафіксувати зміни зошита в репозиторій SVN (commit)',
  'SVN update|Update notebook from SVN repository' => 'Оновлення з SVN|Оновити зошит з репозиторія SVN (update)',
  'S_ave Version...|Save Version' => 'Зберегти _версію…|Зберегти версію',
  'Save Copy' => 'Зберегти копію',
  'Save version' => 'Зберегти версію',
  'Scanning tree ...' => 'Сканування дерева…',
  'Search' => 'Знайти',
  'Search _Backlinks...|Search Back links' => 'Знайти з_воротні посилання…|Знайти зворотні посилання',
  'Select File' => 'Вибрати файл',
  'Select Folder' => 'Вибрати теку',
  'Send To...' => 'Надіслати до…',
  'Show cursor for read-only' => 'Показувати курсор для сторінок в режимі тільки для читання',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Показувати курсор навіть коли редагування сторінки заборонено. Корисно для перегляду та переміщення за допомогою клавіатури.',
  'Slow file system' => 'Повільна файлова система',
  'Source' => 'Джерело',
  'Source Format' => 'Формат джерела',
  'Start the side pane with the whole tree expanded.' => 'Починати зі розвиненого дерева сторінок в бічній панелі.',
  'Stri_ke|Strike' => '_Закреслений|Закреслений',
  'Strike' => 'Викреслений',
  'TODO List' => 'Список завдань',
  'Task' => 'Завдання',
  'Tearoff menus' => 'Меню можна від\'єднувати',
  'Template' => 'Шаблон',
  'Text' => 'Текст',
  'Text Editor' => 'Текстовий редактор',
  'Text _From File...|Insert text from file' => '_Текст із файлу…|Вставити текст із файлу',
  'Text editor' => 'Текстовий редактор',
  'The equation failed to compile. Do you want to save anyway?' => 'Не вдається скомпілювати формулу. Все одно зберегти?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'Відсутня формула для зображення: {path}.
Редагування формули неможливе.',
  'This notebook does not have a document root' => 'Цей зошит не має кореневої теки для прикріплень',
  'This page does not exist
404' => 'Ця сторінка не існує
404',
  'This page does not have a document folder' => 'Ця сторінка не має теки для прикріплень',
  'This page does not have a source' => 'Ця сторінка не має джерела',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Ця сторінка була оновлена в репозиторії.
Оновіть вашу робочу копію (Сервіс -> Оновлення SVN)',
  'To_day|Today' => 'С_ьогодні|Сьогодні',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Встановити прапорець|Встановити прапорець',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Зняти прапорець|Зняти прапорець',
  'Underline' => 'Підкреслений',
  'Updating links' => 'Оновлення посилань',
  'Updating links in {name}' => 'Оновити посилання в {name}',
  'Updating..' => 'Оновлення…',
  'Use "Backspace" to un-indent' => 'Клавіша „Backspace“ змінює відступ за табуляцією',
  'Use "Ctrl-Space" to switch focus' => 'Зміна фокусу за допомогою „Ctrl-Space“',
  'Use "Enter" to follow links' => 'Перехід за посиланням клавішею „Enter“',
  'Use autoformatting to type special characters' => 'Автоматично перетворювати HTML коди (entity) в відповідні символи під час написання',
  'Use custom font' => 'Використовувати інший шрифт',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Клавіша „Backspace“ змінює відступ списків за табуляцією (те саме, що „Shift-Tab“).',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Комбінація клавіш „Ctrl-Пробіл“ перемикає фокус до бічної панелі і навпаки. Якщо деактивовано, використовуйте „Alt-Пробіл“.',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Переходити за посиланнями при натисканні клавіші „Enter“. Якщо вимкнено, використовуйте „Alt-Enter“.',
  'User' => 'Користувач',
  'User name' => 'Ім\'я користувача',
  'Verbatim' => 'Дослівний режим',
  'Versions' => 'Версії',
  'View _Annotated...' => 'Переглянути _анотовані…',
  'View _Log' => 'Переглянути _журнал',
  'Web browser' => 'Веб-переглядач',
  'Whole _word' => 'Збігається _ціле слово',
  'Width' => 'Ширина',
  'Word Count' => 'Статистика',
  'Words' => 'Слів',
  'You can add rules to your search query below' => 'Ви можете додавати правила до пошукового запиту',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Ви можете обрати систему контролю версій <b>Bazaar</b> або <b>Subversion</b>.
Натисніть кнопку \'Допомога\', щоб переглянути інформацію про системні вимоги.',
  'You have no {app_type} configured' => '{app_type} не налаштовано',
  'You need to restart the application
for plugin changes to take effect.' => 'потрібно перезапустити програму,
щоб зміни модулів набрали чинності.',
  'Your name; this can be used in export templates' => 'Ваше ім’я; може використовуватись в шаблонах для експорту',
  'Zim Desktop Wiki' => 'Вікі для робочого стола',
  '_About|About' => '_Про програму|Про програму',
  '_All' => '_Усе',
  '_Back|Go page back' => '_Назад|На сторінку назад',
  '_Bold|Bold' => '_Жирний|Жирний',
  '_Browse...' => 'О_гляд…',
  '_Bugs|Bugs' => 'П_омилки|Як сповістити про помилку',
  '_Child|Go to child page' => 'Вни_з|На сторінку вниз',
  '_Close|Close window' => '_Закрити|Закрити вікно',
  '_Contents|Help contents' => '_Зміст|Відкрити посібник з Zim',
  '_Copy Page...|Copy page' => '_Копіювати сторінку…|Копіювати сторінку',
  '_Copy|Copy' => '_Копіювати|Копіювати',
  '_Date and Time...|Insert date' => '_Дата й час…|Вставити дату й час',
  '_Delete Page|Delete page' => 'В_идалити сторінку|Видалити сторінку',
  '_Delete|Delete' => 'В_идалити|Видалити',
  '_Discard changes' => '_Відкинути зміни',
  '_Edit' => '_Правка',
  '_Edit Equation' => 'Редагувати _формулу',
  '_Edit Link' => '_Редагувати посилання',
  '_Edit Link...|Edit link' => '_Редагувати посилання…|Редагувати посилання',
  '_Edit|' => '_Правка|',
  '_FAQ|FAQ' => '_Часті питання|Часті питання Zim',
  '_File|' => '_Файл|',
  '_Filter' => '_Фільтрувати',
  '_Find...|Find' => 'З_найти…|Знайти',
  '_Forward|Go page forward' => '_Вперед|На сторінку вперед',
  '_Go|' => 'Пере_йти|',
  '_Help|' => '_Довідка|',
  '_History|.' => '_Історія|',
  '_Home|Go home' => 'Го_ловна|На головну',
  '_Image...|Insert image' => '_Зображення…|Вставити зображення',
  '_Index|Show index' => '_Бічна панель|Відобразити чи сховати панель індексу',
  '_Insert' => 'Вст_авити',
  '_Insert|' => 'Вст_авити|',
  '_Italic|Italic' => '_Курсив|Курсив',
  '_Jump To...|Jump to page' => 'Перейти _до…|Перейти до сторінки',
  '_Keybindings|Key bindings' => '_Комбінації клавіш|Комбінації клавіш Zim',
  '_Link' => '_Гаразд',
  '_Link to date' => 'Посилання _на дату',
  '_Link...|Insert link' => '_Посилання…|Вставити посилання',
  '_Link|Link' => 'Створити _посилання|Створити посилання',
  '_Namespace|.' => '_Простір імен|',
  '_New Page|New page' => '_Створити сторінку|Створити сторінку',
  '_Next' => 'Нас_тупний',
  '_Next in index|Go to next page' => 'Н_аступна в індексі|На наступну сторінку',
  '_Normal|Normal' => '_Звичайний|Звичайний',
  '_Notebook Changes...' => '_Зміни зошита…',
  '_Open Another Notebook...|Open notebook' => '_Відкрити інший зошит…|Відкрити зошит',
  '_Open link' => 'Відкрити _посилання',
  '_Overwrite' => '_Перезаписати',
  '_Page' => '_Сторінка',
  '_Page Changes...' => '_Зміни сторінки…',
  '_Parent|Go to parent page' => 'В_гору|На сторінку вгору',
  '_Paste|Paste' => 'Вст_авити|Вставити',
  '_Preview' => '_Попередній перегляд',
  '_Previous' => 'П_опередій',
  '_Previous in index|Go to previous page' => 'П_опередня в індексі|На попередню сторінку',
  '_Properties' => 'В_ластивості',
  '_Quit|Quit' => 'Ви_йти|Вийти',
  '_Recent pages|.' => '_Недавні сторінки',
  '_Redo|Redo' => 'Пов_торити|Повторити',
  '_Reload|Reload page' => 'Пере_завантажити|Перезавантажити сторінку',
  '_Rename' => 'Перей_менувати',
  '_Rename Page...|Rename page' => 'Пере_йменувати сторінку…|Перейменувати сторінку',
  '_Replace' => 'За_мінити',
  '_Replace...|Find and Replace' => 'Знайти та за_мінити…|Знайти та замінити',
  '_Reset' => '_Скинути',
  '_Restore Version...' => 'Від_новити версію…',
  '_Save Copy' => 'Зберегти _копію',
  '_Save a copy...' => 'Зберегти _копію…',
  '_Save|Save page' => 'З_берегти|Зберегти сторінку',
  '_Screenshot...|Insert screenshot' => '_Знімок екрану…|Вставити знімок екрану',
  '_Search...|Search' => 'З_найти…|Знайти',
  '_Search|' => 'З_найти|',
  '_Send To...|Mail page' => 'Надіслати _до…|Надіслати сторінку поштою',
  '_Statusbar|Show statusbar' => '_Рядок стану|Відобразити чи сховати рядок стану',
  '_TODO List...|Open TODO List' => 'Список _завдань…|Відкрити список завдань',
  '_Today' => '_Сьогодні',
  '_Toolbar|Show toolbar' => 'Панель _інструментів|Відобразити чи сховати панель інструментів',
  '_Tools|' => 'С_ервіс|',
  '_Underline|Underline' => '_Підкреслений|Підкреслений',
  '_Undo|Undo' => 'В_ернути|Вернути',
  '_Update links in this page' => 'Оновити _посилання до цієї сторінки',
  '_Update {number} page linking here' => [
    '_Оновити {number} сторінку, що посилається сюди',
    '_Оновити {number} сторінки, що посилаються сюди',
    '_Оновити {number} сторінок, що посилаються сюди'
  ],
  '_Verbatim|Verbatim' => '_Дослівний блок|Дослівний блок',
  '_Versions...|Versions' => 'Ве_рсії…|Версії',
  '_View|' => '_Вигляд|',
  '_Word Count|Word count' => 'Кількість _слів|Кількість слів',
  'other...' => 'інший…',
  '{name}_(Copy)' => '{name}_(Копія)',
  '{number} _Back link' => [
    '{number} зв_оротнє посиланя',
    '{number} зв_оротних посиланя',
    '{number} зв_оротних посилань'
  ],
  '{number} item total' => [
    'усього {number} елемент',
    'усього {number} елемента',
    'усього {number} елементів'
  ]
};
