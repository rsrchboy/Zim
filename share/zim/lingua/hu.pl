# Hungarian translation for zim
# Copyright (c) 2009 Rosetta Contributors and Canonical Ltd 2009
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2009.
# 
# 
# TRANSLATORS:
# István Papp (hu)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-12-02 23:09+0000
# Last-Translator: István Papp <Unknown>
# Language-Team: Hungarian <hu@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=2; plural=n != 1;
# X-Launchpad-Export-Date: 2010-01-10 10:44+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n != 1},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%Y. %b. %e., %a',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Oldal törlése</b>

Biztos hogy törölni akarja
az oldalt: \'{name}\'?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Verziókövetés engedélyezése</b>
A verziókövetés jelenleg nincs engedélyezve erre a jegyzetfüzetre.
Engedélyezni akarja?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>A mappa nem létezik.</b>

A {path} mappa 
nem létezik, létre akarja hozni?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Az oldal már létezik</b>

\'{name}\' oldal
már létezik.
Felül kívánja írni?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Az oldal mentett verziójának visszaállítása</b>
Vissza akarja állítani az oldalt: {page}
a mentett {version}. verzióra?

A mentés óta történt minden módosítás elvész!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>A naptár oldalakat frissíteni akarja a 0.24-es formátumra?</b>

Ez a jegyzetfüzet oldal éééé_hh_nn formátumú dátumokat tartalmaz.
A Zim 0.24-es verzió óta az éééé:hh:nn az alapértelmezett formátum
havi névtér készítésekor.

Módosítani akarja ezt a jegyzetfüzetet erre az új formátumra?
',
  'Add \'tearoff\' strips to the menus' => 'Leválasztó vonal hozzáadása a menükhöz',
  'Application show two text files side by side' => 'Az alkalmazás oldalról oldalra mutatja a két szövegfájlt',
  'Application to compose email' => 'Levelező program',
  'Application to edit text files' => 'Szövegszerkesztő alkalmazás',
  'Application to open directories' => 'Fájlböngésző alkalmazás',
  'Application to open urls' => 'Böngésző alkalmazás',
  'Attach _File|Attach external file' => '_Fájl csatolása|Külső fájl csatolása',
  'Attach external files' => 'Külső fájlok csatolása',
  'Auto-format entities' => 'Bejegyzés automatikus formázása',
  'Auto-increment numbered lists' => 'Automatikus számozott lista',
  'Auto-link CamelCase' => 'Automatikus hivatkozás a WikiLink-re',
  'Auto-link files' => 'Automatikus hivatkozás fájlokra',
  'Auto-save version on close' => 'Automatikus verzió mentés kilépéskor',
  'Auto-select words' => 'Szavak automatikus kiválasztása',
  'Automatically increment items in a numbered list' => 'A tételek automatikusan növekvő számozása egy számozott listában',
  'Automatically link file names when you type' => 'Automatikus hivatkozása fájlnév beírásakor',
  'Automaticly link CamelCase words when you type' => 'Automatikus hivatkozás a WikiLink szavak beírásakor',
  'Automaticly select the current word when you toggle the format' => 'Az aktuális szó automatikus kijelölése a formátum váltásakor.',
  'Bold' => 'Félkövér',
  'Calen_dar|Show calendar' => '_Naptár|Naptár megjelenítése',
  'Calendar' => 'Naptár',
  'Can not find application "bzr"' => 'A "bzr" alkalmazás nem található',
  'Can not find application "{name}"' => 'Nem található az alkalmazás: "{name}"',
  'Can not save a version without comment' => 'A verzió megjegyzés nélkül nem menthető',
  'Can not save to page: {name}' => 'Nem lehet menteni az oldalt: {name}',
  'Can\'t find {url}' => 'Nem található az oldal: {url}',
  'Cha_nge' => 'Mó_dosítás',
  'Chars' => 'Karakter',
  'Check _spelling|Spell check' => '_Helyesírás ellenőrzése|Helyesírás ellenőrzése',
  'Check checkbox lists recursive' => 'Rekurzív checkbox bejelölés',
  'Checking a checkbox list item will also check any sub-items' => 'Egy checkbox lista elem bejelölése az alelemeket is bejelöli',
  'Choose {app_type}' => 'Válasszon {app_type} alkalmazást',
  'Co_mpare Page...' => 'Oldal összehasonlítása...',
  'Command' => 'Parancs',
  'Comment' => 'Megjegyzés',
  'Compare this version with' => 'Összehasonlítás ezzel a verzióval',
  'Copy Email Address' => 'E-mail cím _másolása',
  'Copy Location|Copy location' => '_Hivatkozás másolása|Hivatkozás másolása',
  'Copy _Link' => 'Hivatkozás _másolása',
  'Could not delete page: {name}' => 'Az {name} oldal nem törölhető.',
  'Could not get annotated source for page {page}' => 'A(z) {page} oldal annotált forrása nem olvasható.',
  'Could not get changes for page: {page}' => 'Az adott oldal nem változott: {page}',
  'Could not get changes for this notebook' => 'Ez a jegyzetfüzet nem változott',
  'Could not get file for page: {page}' => 'Az oldalhoz tartozó fájl nem található: {page}',
  'Could not get versions to compare' => 'Nincs összehasonlítható verzió',
  'Could not initialize version control' => 'A verziókövetés nem inicializálható',
  'Could not load page: {name}' => 'Az oldal nem tölthető be: {name}',
  'Could not rename {from} to {to}' => 'A {from} nem nevezhető át erre: {to}',
  'Could not save page' => 'Az oldalt nem lehet menteni',
  'Could not save version' => 'Nem menthető a verzió',
  'Creating a new link directly opens the page' => 'Az új hivatkozás készítése automatikusan megnyitja az oldalt',
  'Creation Date' => 'Létrehozás dátuma',
  'Cu_t|Cut' => '_Kivágás|Kivágás',
  'Current' => 'Jelenlegi',
  'Customise' => 'Testreszabás',
  'Date' => 'Dátum',
  'Default notebook' => 'Alapértelmezett jegyzetfüzet',
  'Details' => 'Részletek',
  'Diff Editor' => 'Diff szerkesztő',
  'Diff editor' => 'Diff szerkesztő',
  'Directory' => 'Könyvtár',
  'Document Root' => 'Dokumentum gyökérkönyvtára',
  'E_quation...|Insert equation' => '_Egyenlet...|Egyenlet beszúrása',
  'E_xport...|Export' => 'E_xportálás...|Exportálás',
  'E_xternal Link...|Insert external link' => 'Kü_lső hivatkozás...|Külső hivatkozás',
  'Edit Image' => 'Kép szerkesztése',
  'Edit Link' => 'Hivatkozás szerkesztése',
  'Edit Query' => 'Lekérdezés szerkesztése',
  'Edit _Source|Open source' => 'Forrá_s szerkesztése|Forrás megnyitása',
  'Edit notebook' => 'Jegyzetfüzet szerkesztése',
  'Edit text files "wiki style"' => 'Szövegfájlok szerkesztése „wiki” stílusban',
  'Editing' => 'Szerkesztés',
  'Email client' => 'E-mail-kliens',
  'Enabled' => 'Engedélyezve',
  'Equation Editor' => 'Egyenletszerkesztő',
  'Equation Editor Log' => 'Egyenletszerkesztő napló',
  'Expand side pane' => 'Oldalpanel megnyitása',
  'Export page' => 'Oldal exportálása',
  'Exporting page {number}' => '{number}. oldal exportálása',
  'Failed to cleanup SVN working copy.' => 'Sikertelen a munkapéldány tisztázása.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Az SVN bővítmény betöltése sikertelen,
telepítve van a subversion alkalmazás?',
  'Failed to load plugin: {name}' => 'A bővítménye betöltése sikertelen: {name}',
  'Failed update working copy.' => 'Sikertelen a munkapéldány frissítése.',
  'File browser' => 'Fájlböngésző',
  'File is not a text file: {file}' => 'Nem szövegfájl: {file}',
  'Filter' => 'Szűrő',
  'Find' => 'Keresés',
  'Find Ne_xt|Find next' => 'Kö_vetkező keresése|Következő keresése',
  'Find Pre_vious|Find previous' => 'Elő_ző keresése|Előző keresése',
  'Find and Replace' => 'Keresés és csere',
  'Find what' => 'Ezt keresse',
  'Follow new link' => 'Ugrás az új hivatkozásra',
  'For_mat|' => 'For_mátum|',
  'Format' => 'Formázás',
  'General' => 'Általános',
  'Go to "{link}"' => 'Ugrás: "{link}"',
  'H_idden|.' => 'E_lrejtés|.',
  'Head _1|Heading 1' => 'Fejléc _1|Fejléc 1',
  'Head _2|Heading 2' => 'Fejléc _2|Fejléc 2',
  'Head _3|Heading 3' => 'Fejléc _3|Fejléc 3',
  'Head _4|Heading 4' => 'Fejléc _4|Fejléc 4',
  'Head _5|Heading 5' => 'Fejléc _5|Fejléc 5',
  'Head1' => 'Fejléc 1',
  'Head2' => 'Fejléc 2',
  'Head3' => 'Fejléc 3',
  'Head4' => 'Fejléc 4',
  'Head5' => 'Fejléc 5',
  'Height' => 'Magasság',
  'Home Page' => 'Honlap',
  'Icon' => 'Ikon',
  'Id' => 'Azonosító',
  'Include all open checkboxes' => 'Az összes jelöletlen checkbox beillesztése',
  'Index page' => 'Indexoldal',
  'Initial version' => 'Első verzió',
  'Insert Date' => 'Dátum beszúrása',
  'Insert Image' => 'Kép beszúrása',
  'Insert Link' => 'Hivatkozás beszúrása',
  'Insert from file' => 'Beszúrás fájlból',
  'Interface' => 'Felhasználói felület',
  'Italic' => 'Dőlt',
  'Jump to' => '_Ugrás',
  'Jump to Page' => 'Ugrás erre az oldalra',
  'Lines' => 'Sor',
  'Links to' => 'Hivatkozás erre',
  'Match c_ase' => 'Na_gybetűérzékeny',
  'Media' => 'Média',
  'Modification Date' => 'Módosítás dátuma',
  'Name' => 'Név',
  'New notebook' => 'Új jegyzetfüzet',
  'New page' => 'Új oldal',
  'No such directory: {name}' => 'Nincs ilyen mappa: {name}',
  'No such file or directory: {name}' => 'Nincs ilyen fájl vagy könyvtár: {name}',
  'No such file: {file}' => 'Nincs ilyen fájl: {file}',
  'No such notebook: {name}' => 'Nincs ilyen jegyzetfüzet: {name}',
  'No such page: {page}' => 'Nincs ilyen oldal: {page}',
  'No such plugin: {name}' => 'Nincs ilyen bővítmény: {name}',
  'Normal' => 'Normál',
  'Not Now' => 'Most nem',
  'Not a valid page name: {name}' => '{name} nem érvényes oldalnév',
  'Not an url: {url}' => 'Nem érvényes url: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'A hivatkozás készítés egy nem létező oldalra
automatikusan létrehoz egy új oldalt.',
  'Notebook' => 'Jegyzetfüzet',
  'Notebooks' => 'Jegyzetfüzetek',
  'Open Document _Folder|Open document folder' => 'Dokumentum _könyvtár megnyitása| Dokumentum könyvtár megnyitása',
  'Open Document _Root|Open document root' => 'Dokumentum gyöké_rkönyvtár megnyitása|Dokumentum gyökérkönyvtár megnyitása',
  'Open _Directory' => 'Mappa megnyitása...',
  'Open notebook' => 'Jegyzetfüzet megnyitása',
  'Other...' => 'Egyéb…',
  'Output' => 'Kimenet',
  'Output dir' => 'Kimeneti mappa',
  'P_athbar type|' => 'Útvonalsáv típusa|',
  'Page' => 'Oldal',
  'Page Editable|Page editable' => 'Szerkeszthető oldal|Szerkeszthető oldal',
  'Page name' => 'Oldalnév',
  'Pages' => 'Oldalak',
  'Password' => 'Jelszó',
  'Please enter a comment for this version' => 'Adjon meg egy megjegyzést ehhez a verzióhoz',
  'Please enter a name to save a copy of page: {page}' => 'Írjon be egy nevet az oldal másolatának mentéséhez: {page}',
  'Please enter a {app_type}' => 'Adja meg a {app_type} alkalmazást',
  'Please give a page first' => 'Először adjon meg egy oldalt',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Legalább az oldalakat tároló könyvtára adja meg.
Egy új jegyzetfüzethez ennek egy üres könyvtárnak kell lennie.
Például a "Notes" könyvtár az ön könyvtárában.',
  'Please provide the password for
{path}' => 'Adja meg a jelszót a
{path} eléréséhez',
  'Please select a notebook first' => 'Először válasszon ki egy jegyzetfüzetet',
  'Please select a version first' => 'Először válasszon ki egy verziót',
  'Plugin already loaded: {name}' => 'A bővítmény már be van töltve: {name}',
  'Plugins' => 'Bővítmények',
  'Pr_eferences|Preferences dialog' => 'B_eállítások|Beállítások',
  'Preferences' => 'Beállítások',
  'Prefix document root' => 'Dokumentum gyökérkönyvtár prefixe',
  'Print to Browser|Print to browser' => 'Nyomtatás a böngészőbe|Nyomtatás a böngészőbe',
  'Prio' => 'Prio',
  'Proper_ties|Properties dialog' => '_Tulajdonságok|Tulajdonságok',
  'Properties' => 'Tulajdonságok',
  'Rank' => 'Rangsor',
  'Re-build Index|Rebuild index' => 'Index újraépítése|Index újraépítése',
  'Recursive' => 'Rekurzív',
  'Rename page' => 'Oldal átnevezése',
  'Rename to' => 'Átnevezés erre:',
  'Replace _all' => 'Ö_sszes cseréje',
  'Replace with' => 'Csere erre',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN tisztítás|A munkapéldány tisztítása az SVN tárolóban',
  'SVN commit|Commit notebook to SVN repository' => 'SVN kommit|A jegyzetfüzet tárolása az SVN tárolóban',
  'SVN update|Update notebook from SVN repository' => 'SVN frissítés|A jegyzetfüzet frissítése az SVN tárolóból',
  'S_ave Version...|Save Version' => 'Verzió mentése...|Verzió mentése',
  'Save Copy' => 'Másolat mentése',
  'Save version' => 'Verzió mentése',
  'Scanning tree ...' => 'Könyvtárfa ellenőrzése ...',
  'Search' => 'Keresés',
  'Search _Backlinks...|Search Back links' => '_Hivatkozó oldal keresése|Hivatkozó oldal keresése',
  'Select File' => 'Fájlválasztás',
  'Select Folder' => 'Mappa választása',
  'Send To...' => 'Küldés…',
  'Show cursor for read-only' => 'Kurzor mutatása csak olvasható módban',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Kurzor mutatása akkor is, ha nem lehet szerkeszteni az oldalt. Billentyű alapú böngészés közben használható.',
  'Slow file system' => 'Lassú fájlrendszer',
  'Source' => 'Forrás',
  'Source Format' => 'Forrás formátuma',
  'Start the side pane with the whole tree expanded.' => 'Az oldalpanel indítása nyitott faszerkezettel.',
  'Stri_ke|Strike' => 'Á_thúzott|Áthúzott',
  'Strike' => 'Áthúzott',
  'TODO List' => 'Teendőlista',
  'Task' => 'Feladat',
  'Tearoff menus' => 'Leválasztható menü',
  'Template' => 'Sablon',
  'Text' => 'Szöveg',
  'Text Editor' => 'Szövegszerkesztő',
  'Text _From File...|Insert text from file' => 'Beszúrás _fájlból...|Beszúrás fájlból',
  'Text editor' => 'Szövegszerkesztő',
  'The equation failed to compile. Do you want to save anyway?' => 'Sikertelen a képlet értelmezése. Mindenképpen menteni akarja?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'A kép tartozó képlet: {path}
hiányzik. A képletet nem lehet szerkeszteni.',
  'This notebook does not have a document root' => 'Ehhez a jegyzetfüzethez nem tartozik dokumentum gyökérkönyvtár',
  'This page does not exist
404' => 'Az oldal nem létezik
404',
  'This page does not have a document folder' => 'Ehhez az oldalhoz nem tartozik mappa',
  'This page does not have a source' => 'Az oldalnak nincs forrása',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Ennek az oldalnak újabb változata van a tárolóban.
Kérem frissítse a munkapéldányát (Eszközök -> SVN frissítés)',
  'To_day|Today' => '_Ma|Ugrás a mai napra',
  'Toggle Chechbox \'V\'|Toggle checkbox' => '\'V\' checkbox módosítása|Checkbox módosítása',
  'Toggle Chechbox \'X\'|Toggle checkbox' => '\'X\' checkbox módosítása|Checkbox módosítása',
  'Underline' => 'Aláhúzott',
  'Updating links' => 'Hivatkozások frissítése',
  'Updating links in {name}' => '{name} hivatkozásainak frissítése',
  'Updating..' => 'Frissítés…',
  'Use "Backspace" to un-indent' => 'Behúzás törlése "Backspace"-szel',
  'Use "Ctrl-Space" to switch focus' => '"Ctrl-Space" használat a fókusz váltására',
  'Use "Enter" to follow links' => '"Enter" használata a hivatkozáshoz ugráshoz',
  'Use autoformatting to type special characters' => 'Speciális karakterek gépelésekor automatikus formázás',
  'Use custom font' => 'Egyéni betűtípus használata',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'A "Backspace" billentyű használata egy felsorolt lista behúzásának megszüntetésére. (Ugyanaz mint a "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'A "Ctrl-Space" billentyűk használata a fókusz váltására a szöveg és az oldalpanel között. Ha tiltott, akkor használhatja az "Alt-Space"-t.',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => '"Enter" billentyű használata a hivatkozáshoz ugrásra. Ha tiltott, használhatja az "Alt-Enter"-t',
  'User' => 'Felhasználó',
  'User name' => 'Felhasználói név',
  'Verbatim' => 'Változatlan',
  'Versions' => 'Verziók',
  'View _Annotated...' => '_Módosítások megtekintése',
  'View _Log' => 'Nap_ló megtekintése',
  'Web browser' => 'Web böngésző',
  'Whole _word' => '_Teljes szó',
  'Width' => 'Szélesség',
  'Word Count' => 'Szavak száma',
  'Words' => 'Szó',
  'You can add rules to your search query below' => 'Az alábbi lekérdezéshez meg kell adni a keresési szabályokat',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Választhat a <b>Bazaar</b> és <b>Subversion</b> verziókövető rendszerek közül.
Kattintson a \'Sugó\'-ra, ha a rendszerkövetelményekre kíváncsi.',
  'You have no {app_type} configured' => 'Nincs beállítva a(z) {app_type} alkalmazás',
  'You need to restart the application
for plugin changes to take effect.' => 'Az alkalmazást újra kell indítani
a bővítmény változtatás érvényesítéséhez.',
  'Your name; this can be used in export templates' => 'A neve; ez az export sablonban lesz használva',
  'Zim Desktop Wiki' => 'Zim asztali Wiki',
  '_About|About' => '_Névjegy|Névjegy',
  '_All' => '_Mind',
  '_Back|Go page back' => '_Vissza|Ugrás az előző oldalra',
  '_Bold|Bold' => '_Félkövér|Félkövér',
  '_Browse...' => '_Tallózás…',
  '_Bugs|Bugs' => '_Hibák|Hibák',
  '_Child|Go to child page' => '_Gyermek|Ugrás a gyermek oldalhoz',
  '_Close|Close window' => 'A_blak bezárása|Ablak bezárása',
  '_Contents|Help contents' => '_Tartalom|Súgó tartalma',
  '_Copy Page...|Copy page' => 'Oldal _másolása...|Oldal másolása',
  '_Copy|Copy' => '_Másolás|Másolás',
  '_Date and Time...|Insert date' => '_Dátum és idő...|Dátum és idő beszúrása',
  '_Delete Page|Delete page' => 'Ol_dal törlése...|Oldal törlése',
  '_Delete|Delete' => '_Törlés|Törlés',
  '_Discard changes' => '_Változtatások eldobása',
  '_Edit' => 'S_zerkesztés',
  '_Edit Equation' => '_Egyenlet szerkesztése',
  '_Edit Link' => '_Hivatkozás szerkesztése',
  '_Edit Link...|Edit link' => '_Hivatkozás szerkesztése...|Hivatkozás szerkesztése',
  '_Edit|' => 'Sz_erkesztés|',
  '_FAQ|FAQ' => '_GYIK|GYIK',
  '_File|' => '_Fájl|',
  '_Filter' => '_Szűrő',
  '_Find...|Find' => '_Keresés...|Keresés',
  '_Forward|Go page forward' => '_Előre|Ugrás a következő oldalra',
  '_Go|' => '_Ugrás|',
  '_Help|' => '_Súgó|',
  '_History|.' => '_Előzmények',
  '_Home|Go home' => 'S_tart|Ugrás a kezdő lapra',
  '_Image...|Insert image' => '_Kép...|Kép beszúrása',
  '_Index|Show index' => '_Index|Index megjelenítése',
  '_Insert' => '_Beszúrás',
  '_Insert|' => '_Beszúrás|',
  '_Italic|Italic' => '_Dőlt|Dőlt',
  '_Jump To...|Jump to page' => '_Ugrás...|Adott oldalra ugrás',
  '_Keybindings|Key bindings' => 'Gyors_billentyűk|Gyorsbillentyűk',
  '_Link' => '_Hivatkozás',
  '_Link to date' => '_Dátum hivatkozás',
  '_Link...|Insert link' => '_Hivatkozás...|Hivatkozás beszúrása',
  '_Link|Link' => '_Hivatkozás|Hivatkozás',
  '_Namespace|.' => '_Névtér',
  '_New Page|New page' => '_Új oldal|Új oldal',
  '_Next' => '_Következő',
  '_Next in index|Go to next page' => '_Következő index|Ugrás a következő oldalra',
  '_Normal|Normal' => '_Normál|Normál',
  '_Notebook Changes...' => '_Jegyzetfüzet változásai...',
  '_Open Another Notebook...|Open notebook' => 'Másik _jegyzetfüzet megnyitása...|Jegyzetfüzet megnyitása',
  '_Open link' => 'Hi_vatkozás megnyitása',
  '_Overwrite' => '_Felülírás',
  '_Page' => '_Oldal',
  '_Page Changes...' => '_Oldal változásai...',
  '_Parent|Go to parent page' => '_Szülő|Ugrás a szülő oldalhoz',
  '_Paste|Paste' => '_Beillesztés|Beillesztés',
  '_Preview' => 'Elő_nézet',
  '_Previous' => '_Előző',
  '_Previous in index|Go to previous page' => 'E_lőző index|Ugrás az előző oldalra',
  '_Properties' => 'Tul_ajdonságok',
  '_Quit|Quit' => '_Kilépés|Kilépés',
  '_Recent pages|.' => '_Utóbbi oldalak|.',
  '_Redo|Redo' => 'Ú_jra|Újra',
  '_Reload|Reload page' => 'Új_raolvasás|Oldal újraolvasása',
  '_Rename' => 'Á_tnevezés',
  '_Rename Page...|Rename page' => 'Oldal át_nevezése...|Oldal átnevezése',
  '_Replace' => '_Csere',
  '_Replace...|Find and Replace' => '_Csere...|Keresés és csere',
  '_Reset' => '_Visszaállítás',
  '_Restore Version...' => '_Verzió visszaállítása...',
  '_Save Copy' => 'Másolat mentése',
  '_Save a copy...' => '_Másolat mentése...',
  '_Save|Save page' => 'Menté_s|Oldal mentése',
  '_Screenshot...|Insert screenshot' => 'Ké_pernyőkép|Képernyőkép beszúrása',
  '_Search...|Search' => 'Kere_sés...|Keresés',
  '_Search|' => '_Keresés|',
  '_Send To...|Mail page' => '_Küldés...|Küldés levélben',
  '_Statusbar|Show statusbar' => 'Á_llapotsor|Állapotsor megjelenítése',
  '_TODO List...|Open TODO List' => '_Teendők...|Teendők megnyitása',
  '_Today' => '_Ma',
  '_Toolbar|Show toolbar' => '_Eszköztár|Eszköztár megjelenítése',
  '_Tools|' => 'Es_zközök|',
  '_Underline|Underline' => '_Aláhúzott|Aláhúzott',
  '_Undo|Undo' => '_Visszavonás|Visszavonás',
  '_Update links in this page' => '_Hivatkozások frissítése ezen az oldalon',
  '_Update {number} page linking here' => [
    'A hivatkozott {number}. oldal _frissítése',
    'A hivatkozott {number}. oldal _frissítése'
  ],
  '_Verbatim|Verbatim' => '_Változatlan|Változatlan',
  '_Versions...|Versions' => '_Verziók...|Verziók',
  '_View|' => '_Nézet|',
  '_Word Count|Word count' => 'Sza_vak száma|Szavak száma',
  'other...' => 'más...',
  '{name}_(Copy)' => '{name} _(Másolat)',
  '{number} _Back link' => [
    '{number} _Hivatkozó oldal',
    '{number} _Hivatkozó oldal'
  ],
  '{number} item total' => [
    'Összesen {number} elem',
    'Összesen {number} elem'
  ]
};
