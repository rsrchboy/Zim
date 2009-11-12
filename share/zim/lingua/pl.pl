# Polish translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Krzysztof Tataradziński (pl)
# Lucif (pl)
# warlock24 (pl)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-12-12 22:07+0000
# Last-Translator: Lucif <Unknown>
# Language-Team: Polish <pl@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=3; plural=n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;
# X-Launchpad-Export-Date: 2009-02-17 18:56+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n==1 ? 0 : $n%10>=2 && $n%10<=4 && ($n%100<10 || $n%100>=20) ? 1 : 2},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Kasowanie strony</b>

Czy napewno skasować
stronę \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Uruchom Kontrolę Wersji</b>
Dla tego notatnika została wyłączona Kontrola wersji
Chcesz ją włączyć ?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Katalog nie istnieje.</b>

Katalog: {path}
nie istnieje, chcesz go utworzyć?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Strona już istnieje</b>

Strona \'{name}\'
już istnieje.
Czy chcesz ją nadpisać?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Przywrócić zapisaną wersję Strony?</b>

Czy chcesz przywrócić stronę: {page}
w wersji: {version} ?

Wszystkie zmiany od momentu zapisania zostaną utracone !',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Nowy format daty w kalendarzu?</b>

Ten notes zawiera strony z datami w starym formacie "rrrr_mm_dd".
Od wersji 0.24 zmienił się domyślny format daty (na "rrrr:mm:dd)"

Czy chcesz zaktualizować notes do nowego formatu?\\n
',
  'Add \'tearoff\' strips to the menus' => '',
  'Application show two text files side by side' => 'Pokazuje dwa pliki tekstowe obok siebie.',
  'Application to compose email' => 'Aplikacja do wysyłania poczty',
  'Application to edit text files' => 'Aplikacja do edycji tekstu',
  'Application to open directories' => 'Aplikacja otwierająca katalogi',
  'Application to open urls' => 'Aplikacja otwierająca łącza',
  'Attach _File|Attach external file' => 'Załącz _plik|Dodaj plik',
  'Attach external files' => 'Załącz plik',
  'Auto-format entities' => '',
  'Auto-increment numbered lists' => 'Automatycznie zwiększaj numerację',
  'Auto-link CamelCase' => 'Używaj CamelCase',
  'Auto-link files' => 'Automatycznie twórz łącza',
  'Auto-save version on close' => 'Zapisz wersję przy wyłączaniu',
  'Auto-select words' => 'Zaznaczaj całe słowa',
  'Automatically increment items in a numbered list' => 'Automatycznie dodaje pozycje do listy ponumerowanej.',
  'Automatically link file names when you type' => 'Tworzy łącza do plików podczas pisania.',
  'Automaticly link CamelCase words when you type' => 'Twórz łącza CamelCase podczas pisania',
  'Automaticly select the current word when you toggle the format' => 'Zaznacz aktualny wyraz kiedy przełączasz format',
  'Bold' => 'Pogrubienie',
  'Calen_dar|Show calendar' => '_Kalendarz|Pokaż kalendarz',
  'Calendar' => 'Kalendarz',
  'Can not find application "bzr"' => 'Nie można znaleźć aplikacji "bzr"',
  'Can not find application "{name}"' => 'Nie można znaleźć aplikacji "{name}"',
  'Can not save a version without comment' => 'Nie można zapisać wersji bez komentarza',
  'Can not save to page: {name}' => 'Nie można zapisać jako: {name}',
  'Can\'t find {url}' => 'Nie można odnaleźć {url}',
  'Cha_nge' => '_Zmień',
  'Chars' => 'Znaki',
  'Check _spelling|Spell check' => 'Sprawdź pisownię|Sprawdź pisownię',
  'Check checkbox lists recursive' => '',
  'Checking a checkbox list item will also check any sub-items' => '',
  'Choose {app_type}' => 'Wybierz {app_type}',
  'Co_mpare Page...' => 'Porównaj strony',
  'Command' => 'Polecenie',
  'Comment' => 'Komentarz',
  'Compare this version with' => 'Porównaj tą wersję z',
  'Copy Email Address' => 'Kopiuj adres E-mail',
  'Copy Location|Copy location' => 'Kopiuj Lokację|Kopiuj Lokację',
  'Copy _Link' => 'Kopiuj Łącze',
  'Could not delete page: {name}' => 'Nie można usunąć strony: {name}',
  'Could not get annotated source for page {page}' => '',
  'Could not get changes for page: {page}' => 'Nie można znaleźć zmian dla strony: {page}',
  'Could not get changes for this notebook' => 'Nie można znaleźć zmian dla tego notesu',
  'Could not get file for page: {page}' => 'Nie można znaleźć pliku dla strony: {page}',
  'Could not get versions to compare' => 'Brak wersji do porównania',
  'Could not initialize version control' => 'Kontrola wersji nie została uruchomiona',
  'Could not load page: {name}' => 'Nie można załadować strony: {name}',
  'Could not rename {from} to {to}' => 'Nie można zmienić nazwy z {from} na {to}',
  'Could not save page' => 'Nie można zapisać strony',
  'Could not save version' => 'Nie można zapisać wersji',
  'Creating a new link directly opens the page' => 'Tworzenie nowego łącza otwiera jego stronę',
  'Creation Date' => 'Data utworzenia',
  'Cu_t|Cut' => '_Wytnij|Wytnij',
  'Current' => 'Bieżąca',
  'Customise' => 'Dostosuj',
  'Date' => 'Data',
  'Default notebook' => 'Domyślny notes',
  'Details' => 'Szczegóły',
  'Diff Editor' => 'Edytor Diff',
  'Diff editor' => 'Edytor plików Diff',
  'Directory' => 'Katalog',
  'Document Root' => 'Katalog główny',
  'E_quation...|Insert equation' => 'Równanie...|Wstaw równanie',
  'E_xport...|Export' => 'E_ksport...|Eksport',
  'E_xternal Link...|Insert external link' => 'Łąc_ze zewnętrzne...|Wstaw łącze zewnętrzne',
  'Edit Image' => 'Edytuj obrazek',
  'Edit Link' => 'Edytuj łącze',
  'Edit Query' => 'Edytuj kwerendę',
  'Edit _Source|Open source' => 'Edytuj _Źródło|Edytuj źródło',
  'Edit notebook' => 'Edytuj notes',
  'Edit text files "wiki style"' => 'Edytor plików w stylu Wiki',
  'Editing' => 'Edycja',
  'Email client' => 'Klient email',
  'Enabled' => 'Włączony',
  'Equation Editor' => 'Edytor równań',
  'Equation Editor Log' => 'Dziennik edytor wyrażeń',
  'Expand side pane' => 'Rozszerz panel boczny',
  'Export page' => 'Eksportuj stronę',
  'Exporting page {number}' => 'Eksportowanie strony {number}',
  'Failed to cleanup SVN working copy.' => 'Błąd oczyszczania roboczych kopii w SVN.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Nie załadowano wtyczki SVN,
czy subversion jest prawidłowo zainstalowane?',
  'Failed to load plugin: {name}' => 'Nie można załadować wtyczki: {name}',
  'Failed update working copy.' => 'Błąd uaktualniania bierzącej kopii.',
  'File browser' => 'Przeglądarka plików',
  'File is not a text file: {file}' => 'Plik {file} nie jest plikiem tekstowym.',
  'Filter' => 'Filtr',
  'Find' => 'Znajdź',
  'Find Ne_xt|Find next' => 'Znajdź Następny|Następny',
  'Find Pre_vious|Find previous' => 'Znajdź Poprzedni|Poprzedni',
  'Find and Replace' => 'Znajdź i zamień',
  'Find what' => 'Znajdź:',
  'Follow new link' => 'Podążaj za nowym łączem',
  'For_mat|' => 'For_mat|',
  'Format' => 'Format',
  'General' => 'Ogólne',
  'Go to "{link}"' => 'Idź do "{link}"',
  'H_idden|.' => '_Ukryty|',
  'Head _1|Heading 1' => 'Nagłówek _1|Nagłówek 1',
  'Head _2|Heading 2' => 'Nagłówek _2|Nagłówek 2',
  'Head _3|Heading 3' => 'Nagłówek _3|Nagłówek 3',
  'Head _4|Heading 4' => 'Nagłówek _4|Nagłówek 4',
  'Head _5|Heading 5' => 'Nagłówek _5|Nagłówek 5',
  'Head1' => 'Nagłówek1',
  'Head2' => 'Nagłówek2',
  'Head3' => 'Nagłówek3',
  'Head4' => 'Nagłówek4',
  'Head5' => 'Nagłówek5',
  'Height' => 'Wysokość',
  'Home Page' => 'Strona główna',
  'Icon' => 'Ikonka',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Załącz nieodznaczone pola wyboru',
  'Index page' => 'Strona startowa',
  'Initial version' => 'Wersja początkowa',
  'Insert Date' => 'Wstaw datę',
  'Insert Image' => 'Wstaw obrazek',
  'Insert Link' => 'Wstaw łącze',
  'Insert from file' => 'Wstaw z pliku',
  'Interface' => 'Interfejs',
  'Italic' => 'Kursywa',
  'Jump to' => 'Skocz do',
  'Jump to Page' => 'Skocz do strony',
  'Lines' => 'Wiersze',
  'Links to' => 'Prowadzi do',
  'Match c_ase' => 'Rozróżniaj małe i wielkie litery',
  'Media' => 'Media',
  'Modification Date' => 'Data zmiany',
  'Name' => 'Nazwa',
  'New notebook' => 'Nowy notes',
  'New page' => 'Nowa strona',
  'No such directory: {name}' => 'Katalog o podanej nazwie nie istnieje: {name}',
  'No such file or directory: {name}' => 'Brak pliku lub katalogu: {name}',
  'No such file: {file}' => 'Brak pliku: {file}',
  'No such notebook: {name}' => 'Brak notesu: {name}',
  'No such page: {page}' => 'Brak strony: {page}',
  'No such plugin: {name}' => 'Brak wtyczki: {name}',
  'Normal' => 'Normalny',
  'Not Now' => 'Nie teraz',
  'Not a valid page name: {name}' => 'Nieprawidłowa nazwa strony: {name}',
  'Not an url: {url}' => 'Nieprawidłowy adres: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Zauważ że kliknięcie w link prowadzący do nieistniejącej strony utworzy ją.',
  'Notebook' => 'Notes',
  'Notebooks' => 'Notesy',
  'Open Document _Folder|Open document folder' => 'Otwórz _katalog|Otwórz katalog',
  'Open Document _Root|Open document root' => 'Otwó_rz katalog główny|Otwórz katalog główny',
  'Open _Directory' => 'Otwórz _Folder',
  'Open notebook' => 'Otwórz notes',
  'Other...' => 'Inny...',
  'Output' => 'Wyjście',
  'Output dir' => 'Katalog wyjściowy',
  'P_athbar type|' => 'P_asek adresu',
  'Page' => 'Strona',
  'Page Editable|Page editable' => '',
  'Page name' => 'Nazwa strony',
  'Pages' => 'Strony',
  'Password' => 'Hasło',
  'Please enter a comment for this version' => 'Proszę wpisać komentarz do tej wersji',
  'Please enter a name to save a copy of page: {page}' => 'Proszę wpisać nazwę kopii strony: {page}',
  'Please enter a {app_type}' => 'Proszę wybrać {app_type}',
  'Please give a page first' => 'Proszę najpierw podać stronę',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Proszę chociaż podać katalog do zapisywania stron.
Dla nowych notesów niech to będzie pusty katalog.
Np. katalog o nazwie "Notes" w katalogu domowym.',
  'Please provide the password for
{path}' => 'Proszę wprowadzić hasło dla
{path}',
  'Please select a notebook first' => 'Najpierw wybierz notes',
  'Please select a version first' => 'Proszę najpierw wybrać wersję',
  'Plugin already loaded: {name}' => 'Wtyczka została już zainstalowana: {name}',
  'Plugins' => 'Wtyczki',
  'Pr_eferences|Preferences dialog' => 'Ustawi_enia|Ustawienia',
  'Preferences' => 'Ustawienia',
  'Prefix document root' => 'Prefix katalogu głównego',
  'Print to Browser|Print to browser' => '',
  'Prio' => 'Ważn',
  'Proper_ties|Properties dialog' => 'Us_tawienia|Okno ustawień',
  'Properties' => 'Właściwości',
  'Rank' => 'Ranga',
  'Re-build Index|Rebuild index' => 'Odbuduj Spis|Odbuduj Indeks',
  'Recursive' => 'Rekursywnie',
  'Rename page' => 'Zmień nazwę strony',
  'Rename to' => 'Zmień nazwę na',
  'Replace _all' => 'Zastąp _wszystkie',
  'Replace with' => 'Zamień na',
  'SVN cleanup|Cleanup SVN working copy' => 'Czyszczenie SVN|Czyszczenie kopii roboczych w SVN',
  'SVN commit|Commit notebook to SVN repository' => 'SVN commit|Wyślij Notes do repozytorium SVN',
  'SVN update|Update notebook from SVN repository' => 'SVN update|Uaktualnij Notes z repozytorium SVN',
  'S_ave Version...|Save Version' => 'Z_apisz Wersję...|Zapisz Wersję',
  'Save Copy' => 'Zapisz Kopię',
  'Save version' => 'Zapisz wersję',
  'Scanning tree ...' => 'Skanowanie drzewa...',
  'Search' => 'Znajdź',
  'Search _Backlinks...|Search Back links' => 'Szukaj o_dwołań...|Szukaj odwołań...',
  'Select File' => 'Wybierz plik',
  'Select Folder' => 'Wybierz katalog',
  'Send To...' => 'Wyślij Do...',
  'Show cursor for read-only' => 'Pokazuj kursor dla tylko do odczytu.',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Pokazuje kursor na stronie, której nie możesz edytować. Ułątwia to pracę gdy korzystasz tylko z klawiatury.',
  'Slow file system' => 'Wolniejszy system plików',
  'Source' => 'Źródło',
  'Source Format' => 'Format źródłowy',
  'Start the side pane with the whole tree expanded.' => 'Rozwinięty panel boczny przy starcie',
  'Stri_ke|Strike' => 'P_rzekreślenie|Przekreślenie',
  'Strike' => 'Przekreślenie',
  'TODO List' => 'Lista TODO',
  'Task' => 'Zadanie',
  'Tearoff menus' => 'Oderwane menu.',
  'Template' => 'Szablon',
  'Text' => 'Tekst',
  'Text Editor' => 'Edytor tekstowy',
  'Text _From File...|Insert text from file' => 'Tekst z pliku...|Wstaw tekst z pliku',
  'Text editor' => 'Edytor tekstu',
  'The equation failed to compile. Do you want to save anyway?' => 'Błąd kompilacji równania. Czy zapisać mimo to?',
  'The equation for image: {path}
is missing. Can not edit equation.' => '',
  'This notebook does not have a document root' => 'Ten Notes nie posiada katalogu głównego.',
  'This page does not exist
404' => 'Strona nie istnieje
404',
  'This page does not have a document folder' => 'Ta strona nie znajduje się w katalogu',
  'This page does not have a source' => 'Ta strona nie posiada źródła',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Ta strona została zmienia w repozytorium.
Proszę uaktualnić swoją kopię(Tools -> SVN update).',
  'To_day|Today' => '_Dzisiaj|Dzisiaj',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Ustaw \'V\' w Polu wyboru|Przełącza wartość pola wyboru',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Ustaw \'X\' w Polu wyboru|Przełącza wartość pola wyboru',
  'Underline' => 'Podkreślenie',
  'Updating links' => 'Odśwież łącza',
  'Updating links in {name}' => 'Odświeżanie linków w {name}',
  'Updating..' => 'Odświeżanie',
  'Use "Backspace" to un-indent' => '',
  'Use "Ctrl-Space" to switch focus' => 'Użyj "Ctr-Spacja" do zmiany paneli',
  'Use "Enter" to follow links' => 'Użyj Entera by podązać za łączami',
  'Use autoformatting to type special characters' => '',
  'Use custom font' => 'Użyj wybranej czcionki',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => '',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Użyj kombinacji "Ctrl-Spacja" aby przełączać się między panelami. Jeśli wyłączone wciąż możesz używać kombinacji "Alt-Spacja".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Użyj klawisza "Enter" by podążać za łączami. Gdy wyłączone możesz korzystać z kombinacji "Alt-Enter".',
  'User' => 'Użytkownik',
  'User name' => 'Nazwa użytkownika',
  'Verbatim' => 'Wyjustowanie',
  'Versions' => 'Wersje',
  'View _Annotated...' => '',
  'View _Log' => 'Wyświet_l dziennik zdarzeń',
  'Web browser' => 'Przeglądarka WWW',
  'Whole _word' => 'Tylko całe słowa',
  'Width' => 'Szerokość',
  'Word Count' => 'Licznik słów',
  'Words' => 'Słowa',
  'You can add rules to your search query below' => 'Możesz dodawać złożone warunki do twojego zapytania',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Ustaw <b>Bazaar</b> lub <b>Subversion</b> jako System Kontroli Wersji.
Kliknij \'Pomoc\' by przeczytać o wymaganiach systemowych.',
  'You have no {app_type} configured' => 'Nie skonfigurowano aplikacji {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => 'Musisz ponownie uruchomić aplikację
żeby zadziałały zmiany we wtyczkach.',
  'Your name; this can be used in export templates' => 'Twoje imie; można wykorzystać w szablonach eksportu',
  'Zim Desktop Wiki' => 'Zim - Domowa Wiki',
  '_About|About' => '_O programie|O programie',
  '_All' => '_Wszystko',
  '_Back|Go page back' => '_Wstecz|Cofnij do poprzedniej strony',
  '_Bold|Bold' => '_Pogrubienie|Pogrubienie',
  '_Browse...' => '_Przeglądaj...',
  '_Bugs|Bugs' => '_Błędy|Błędy',
  '_Child|Go to child page' => '_Podrzędna|Idź do strony podrzędnej',
  '_Close|Close window' => '_Zamknij|Zamknij okno',
  '_Contents|Help contents' => '_Zawartość|Zawartość Pomocy',
  '_Copy Page...|Copy page' => '_Kopiuj Stronę...|Kopiuj stronę',
  '_Copy|Copy' => 'Kopiuj|Kopiuj',
  '_Date and Time...|Insert date' => '_Data i Czas...|Wstaw datę',
  '_Delete Page|Delete page' => '_Usuń Stronę|Usuń stronę',
  '_Delete|Delete' => '_Skasuj|Skasuj',
  '_Discard changes' => '_Porzuć zmiany',
  '_Edit' => '_Edycja',
  '_Edit Equation' => '_Edytuj wyrażenie',
  '_Edit Link' => '_Edytuj Łącze',
  '_Edit Link...|Edit link' => '_Edytuj Łącze...|Edytuj Łącze',
  '_Edit|' => '_Edycja|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_Plik|',
  '_Filter' => '_Filtr',
  '_Find...|Find' => '_Znajdź...|Znajdź',
  '_Forward|Go page forward' => '_Naprzód|Idź do następnej strony',
  '_Go|' => '_Idź',
  '_Help|' => '_Pomoc|',
  '_History|.' => '_Historia|',
  '_Home|Go home' => '_Strona główna|Idź do strony głównej',
  '_Image...|Insert image' => '_Obraz...|Wstaw obraz',
  '_Index|Show index' => 'Sp_is|Pokaż spis',
  '_Insert' => '_Wstaw',
  '_Insert|' => '_Wstaw|',
  '_Italic|Italic' => '_Kursywa|Kursywa',
  '_Jump To...|Jump to page' => '_Skocz do...|Skok do strony',
  '_Keybindings|Key bindings' => '_Klawisze skrótów|Klawisze skrótów',
  '_Link' => 'Łą_cze',
  '_Link to date' => 'Łacze do daty',
  '_Link...|Insert link' => 'Łą_cze...|Wstaw łącze',
  '_Link|Link' => 'Łącze|Łącze',
  '_Namespace|.' => '_Przestrzeń nazw',
  '_New Page|New page' => '_Nowa Zakładka|Nowa zakładka',
  '_Next' => '_Następny',
  '_Next in index|Go to next page' => '_Następna w spisie|Idź do następnej w spisie',
  '_Normal|Normal' => 'Normalny',
  '_Notebook Changes...' => 'Zmia_ny Notesu',
  '_Open Another Notebook...|Open notebook' => '_Otwórz kolejny notes...|Otwiera inny notes',
  '_Open link' => '_Otwórz Łącze',
  '_Overwrite' => '_Nadpisz',
  '_Page' => '_Strona',
  '_Page Changes...' => 'Strona zmieniona',
  '_Parent|Go to parent page' => '_Nadrzędna|Idź do strony nadrzędnej',
  '_Paste|Paste' => 'Wkl_ej|Wklej',
  '_Preview' => '_Podgląd',
  '_Previous' => '_Poprzedni',
  '_Previous in index|Go to previous page' => '_Poprzednia w spisie|Idź do poprzedniej w spisie',
  '_Properties' => 'P_referencje',
  '_Quit|Quit' => '_Zakończ|Zakończ',
  '_Recent pages|.' => '_Ostatnie strony|',
  '_Redo|Redo' => '_Powtórz|Powtórz',
  '_Reload|Reload page' => 'Odśwież st_ronę|Odśwież stronę',
  '_Rename' => '_Zmień nazwę',
  '_Rename Page...|Rename page' => '_Zmień Nazwę Strony|Zmień nazwę',
  '_Replace' => '_Zastąp',
  '_Replace...|Find and Replace' => '_Zastąp...|Znajdź i zastąp',
  '_Reset' => '_Zresetuj',
  '_Restore Version...' => 'Odtwó_rz wersję',
  '_Save Copy' => '_Zapisz Kopię',
  '_Save a copy...' => '_Zapisz kopię...',
  '_Save|Save page' => '_Zapisz|Zapisz zakładkę',
  '_Screenshot...|Insert screenshot' => '_Zrzut ekranu...|Wstawia zrzut ekranu',
  '_Search...|Search' => '_Znajdź...|Znajdź',
  '_Search|' => '_Znajdź|',
  '_Send To...|Mail page' => '_Wyślij Do...|Wyślij stronę przez e-mail',
  '_Statusbar|Show statusbar' => '_Pasek stanu|Pokaż pasek stanu',
  '_TODO List...|Open TODO List' => 'Lista _TODO|Otwórz listę TODO',
  '_Today' => '_Dziś',
  '_Toolbar|Show toolbar' => '_Pasek narzędzi|Pokaż pasek narzędzi',
  '_Tools|' => '_Narzędzia|',
  '_Underline|Underline' => 'P_odkreślenie|Podkreślenie',
  '_Undo|Undo' => '_Cofnij|Cofnij',
  '_Update links in this page' => 'Odśwież łącza na tej stronie',
  '_Update {number} page linking here' => [
    '_Aktualizuj {number} stronę prowadzącą tutaj.',
    '_Aktualizuj {number} strony prowadzące tutaj.',
    '_Aktualizuj {number} stron prowadzących tutaj.'
  ],
  '_Verbatim|Verbatim' => '_Wyjustuj|Wyjustowanie',
  '_Versions...|Versions' => '_Wersje...|Wersje',
  '_View|' => '_Widok|',
  '_Word Count|Word count' => '_Licz sło_wa|Licz sło_wa',
  'other...' => 'inne...',
  '{name}_(Copy)' => '{name}_(Kopia)',
  '{number} _Back link' => [
    '{number} Odwołanie',
    '{number} Odwołania',
    '{number} Odwołań'
  ],
  '{number} item total' => [
    'Łącznie {number}',
    'Łącznie {number}',
    'Łącznie {number}'
  ]
};
