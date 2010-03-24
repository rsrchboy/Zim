# translation of zim-cs.po to
# Vlastimil Ott <vlastimil@e-ott.info>, 2007.
# translation of zim.po to
# 
# TRANSLATORS:
# Vlastimil Ott (cs)
# Vlastimil Ott (cs)
# 
# Project-Id-Version: zim-cs
# Report-Msgid-Bugs-To: 
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-11-13 22:10+0000
# Last-Translator: Vlastimil Ott <linux@e-ott.info>
# Language-Team: <cs@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=3; plural=(n==1) ? 0 : (n>=2 && n<=4) ? 1 : 2;
# X-Launchpad-Export-Date: 2010-01-10 10:44+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; ($n==1) ? 0 : ($n>=2 && $n<=4) ? 1 : 2},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Smazat stránku</b>

Jste si jistí, že chcete smazat
stránku \'{name}\'?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Povolit správu verzí</b>

Pro aktuální sešit není správa verzí povolena.
Chcete ji povolit?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Složka neexistuje.</b>

Složka: {path}
neexistuje, chcete ji vytvořit?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Stránka již existuje</b>

Stránka \'{name}\'
již existuje.
Chcete ji přepsat?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Vrátit stránku k uložené verzi?</b>

Přejete si obnovit stránku {page}
na uloženou verzi {version}?

Všechny změny od poslední uložené verze budou ztraceny!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<p>Aktualizovat kalendář na formát 0.24?</p>

Tento sešit obsahuje stránky pro data ve formátu yyyy_mm_dd.
Od verze 0.24 používá Zim formát yyyy:mm:dd a vytváří 
jmenné prostory po měsících.

Chcete tento sešit aktualizovat na novou strukturu?
',
  'Add \'tearoff\' strips to the menus' => 'Připojí k nabídkám odtrhávací proužky',
  'Application show two text files side by side' => 'Aplikace zobrazuje dva textové soubory vedle sebe',
  'Application to compose email' => 'Aplikace pro odesílání e-mailů',
  'Application to edit text files' => 'Aplikace pro editování textových souborů',
  'Application to open directories' => 'Aplikace pro otevírání adresářů',
  'Application to open urls' => 'Aplikace pro otevírání URL',
  'Attach _File|Attach external file' => 'Připo_jit soubor|Připojit externí soubor',
  'Attach external files' => 'Připojit externí soubory',
  'Auto-format entities' => 'Automaticky formátovat entity',
  'Auto-increment numbered lists' => 'Automaticky číslovat seznamy',
  'Auto-link CamelCase' => 'Automaticky odkazovat na SpojenáSlova',
  'Auto-link files' => 'Automaticky odkazovat na soubory',
  'Auto-save version on close' => 'Automaticky uložit verzi při zavření',
  'Auto-select words' => 'Automaticky vybírat slova',
  'Automatically increment items in a numbered list' => 'Automaticky číslovat položky seznamu',
  'Automatically link file names when you type' => 'Automaticky vytváří odkazy na soubory, jakmile napíšete jejich název',
  'Automaticly link CamelCase words when you type' => 'Automaticky vytváří odkazy ze SpojenýchSlov, jakmile je napíšete',
  'Automaticly select the current word when you toggle the format' => 'Automaticky vybere aktuální slovo, pokud měníte formát',
  'Bold' => 'Tučné',
  'Calen_dar|Show calendar' => '_Kalendář|Zobrazit kalendář',
  'Calendar' => 'Kalendář',
  'Can not find application "bzr"' => 'Nelze najít aplikaci "bzr"',
  'Can not find application "{name}"' => 'Nelze najít aplikaci "{name}"',
  'Can not save a version without comment' => 'Bez komentáře nelze verzi uložit',
  'Can not save to page: {name}' => 'Nelze uložit stránku {name}',
  'Can\'t find {url}' => 'Nelze najít {url}',
  'Cha_nge' => 'Z_měnit',
  'Chars' => 'Znaků',
  'Check _spelling|Spell check' => '_Kontrola překlepů|Kontrola překlepů',
  'Check checkbox lists recursive' => 'Kontrolovat seznamy zaškrtávacích políček rekurzivně',
  'Checking a checkbox list item will also check any sub-items' => 'Kontrola seznamu zaškrtávacích políček zkontroluje také všechny podřízené položky',
  'Choose {app_type}' => 'Vybrat {app_type}',
  'Co_mpare Page...' => 'Po_rovnat stránku',
  'Command' => 'Příkaz',
  'Comment' => 'Komentář',
  'Compare this version with' => 'Porovnat tuto verzi se',
  'Copy Email Address' => 'Kopírovat e-mailovou adresu',
  'Copy Location|Copy location' => 'Kopírovat umístění|Kopírovat umístění',
  'Copy _Link' => 'Kopírovat _odkaz',
  'Could not delete page: {name}' => 'Stránku {name} nelze smazat',
  'Could not get annotated source for page {page}' => 'Nelze načíst komentovaný zdroj pro stránku {page}',
  'Could not get changes for page: {page}' => 'Nelze načíst změny pro stránku: {page}',
  'Could not get changes for this notebook' => 'Nelze načíst změny sešitu',
  'Could not get file for page: {page}' => 'Nelze načíst soubor pro stránku: {page}',
  'Could not get versions to compare' => 'Nelze načíst verze pro porovnání',
  'Could not initialize version control' => 'Správu verzí nelze aktivovat',
  'Could not load page: {name}' => 'Nelze načíst stránku {name}',
  'Could not rename {from} to {to}' => 'Nelze přejmenovat z {from} na {to}',
  'Could not save page' => 'Stránku nelze uložit',
  'Could not save version' => 'Nelze uložit verzi',
  'Creating a new link directly opens the page' => 'Vytvoření nového odkazu přímo otevře stránku',
  'Creation Date' => 'Datum vytvoření',
  'Cu_t|Cut' => 'V_yjmout|Vyjmout',
  'Current' => 'Současná',
  'Customise' => 'Přizpůsobit',
  'Date' => 'Datum',
  'Default notebook' => 'Výchozí sešit',
  'Details' => 'Detaily',
  'Diff Editor' => 'Editor rozdílů',
  'Diff editor' => 'Editor rozdílů',
  'Directory' => 'Adresář',
  'Document Root' => 'Kořen dokumentu',
  'E_quation...|Insert equation' => '_Rovnice...|Vložit rovnici',
  'E_xport...|Export' => 'E_xport...|Export',
  'E_xternal Link...|Insert external link' => 'E_xterní odkaz...|Vložit externí odkaz',
  'Edit Image' => 'Upravit obrázek',
  'Edit Link' => 'Upravit odkaz',
  'Edit Query' => 'Upravit dotaz',
  'Edit _Source|Open source' => '_Upravit zdroj|Otevřít zdrojový soubor',
  'Edit notebook' => 'Upravit sešit',
  'Edit text files "wiki style"' => 'Upravujte textové soubory jako wiki',
  'Editing' => 'Úpravy',
  'Email client' => 'E-mailový klient',
  'Enabled' => 'Povoleno',
  'Equation Editor' => 'Editor rovnic',
  'Equation Editor Log' => 'Záznam editoru rovnic',
  'Expand side pane' => 'Rozbalit boční panel',
  'Export page' => 'Exportovat stránku',
  'Exporting page {number}' => 'Exportuji stránku {number}',
  'Failed to cleanup SVN working copy.' => 'Nepodařilo se vyčistit pracovní kopii SVN.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Nepodařilo se načíst modul SVN,
máte nainstalovaný balík subversion?',
  'Failed to load plugin: {name}' => 'Nelze načíst zásuvný modul {name}',
  'Failed update working copy.' => 'Nepodařilo se aktualizovat pracovní kopii SVN.',
  'File browser' => 'Správce souborů',
  'File is not a text file: {file}' => 'Soubor {file} není textový soubor',
  'Filter' => 'Filtr',
  'Find' => 'Najít',
  'Find Ne_xt|Find next' => 'Najít _další|Najít další',
  'Find Pre_vious|Find previous' => 'Najít _předchozí|Najít předchozí',
  'Find and Replace' => 'Najít a zaměnit',
  'Find what' => 'Najít výraz',
  'Follow new link' => 'Následovat nový odkaz',
  'For_mat|' => '_Formát|',
  'Format' => 'Formát',
  'General' => 'Obecné',
  'Go to "{link}"' => 'Přejít na "{link}"',
  'H_idden|.' => '_Skrytý|.',
  'Head _1|Heading 1' => 'Nadpis_1|Nadpis 1',
  'Head _2|Heading 2' => 'Nadpis_2|Nadpis 2',
  'Head _3|Heading 3' => 'Nadpis_3|Nadpis 3',
  'Head _4|Heading 4' => 'Nadpis_4|Nadpis 4',
  'Head _5|Heading 5' => 'Nadpis_5|Nadpis 5',
  'Head1' => 'Nadpis1',
  'Head2' => 'Nadpis2',
  'Head3' => 'Nadpis3',
  'Head4' => 'Nadpis4',
  'Head5' => 'Nadpis5',
  'Height' => 'Výška',
  'Home Page' => 'Domovská stránka',
  'Icon' => 'Ikona',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Vložit všechna otevřená zaškrtávací políčka',
  'Index page' => 'Stránka s indexem',
  'Initial version' => 'Počáteční verze',
  'Insert Date' => 'Vložit datum',
  'Insert Image' => 'Vložit obrázek',
  'Insert Link' => 'Vložit odkaz',
  'Insert from file' => 'Vložit ze souboru',
  'Interface' => 'Rozhraní',
  'Italic' => 'Kurziva',
  'Jump to' => 'Skočit na',
  'Jump to Page' => 'Skočit na stránku',
  'Lines' => 'Řádků',
  'Links to' => 'Odkazuje na',
  'Match c_ase' => 'Rozlišovat ve_likost',
  'Media' => 'Média',
  'Modification Date' => 'Datum změny',
  'Name' => 'Název',
  'New notebook' => 'Nový sešit',
  'New page' => 'Nová stránka',
  'No such directory: {name}' => 'Adresář {name} neexistuje',
  'No such file or directory: {name}' => 'Soubor nebo adresář neexistuje: {name}',
  'No such file: {file}' => 'Soubor {file} neexistuje',
  'No such notebook: {name}' => 'Sešit neexistuje: {name}',
  'No such page: {page}' => 'Tato stránka neexistuje: {page}',
  'No such plugin: {name}' => 'Zásuvný modul {name} neexistuje',
  'Normal' => 'Normální',
  'Not Now' => 'Nyní ne',
  'Not a valid page name: {name}' => 'Název stránky {name} není platný',
  'Not an url: {url}' => 'Nejedná se o URL: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Nezapomeňte, že odkaz na neexistující stránku
ji automaticky vytvoří.',
  'Notebook' => 'Sešit',
  'Notebooks' => 'Sešity',
  'Open Document _Folder|Open document folder' => 'Otevřít _složku dokumentu|Otevřít složku dokumentu',
  'Open Document _Root|Open document root' => 'Otevřít _kořen dokumentu|Otevřít kořenovou složku dokumentu',
  'Open _Directory' => 'Otevřít _adresář',
  'Open notebook' => 'Otevřít sešit',
  'Other...' => 'Další...',
  'Output' => 'Výstup',
  'Output dir' => 'Výstupní adresář',
  'P_athbar type|' => '_Typ ukazatele struktury|',
  'Page' => 'Stránka',
  'Page Editable|Page editable' => 'Stránku lze upravovat|Stránku lze upravovat',
  'Page name' => 'Název stránky',
  'Pages' => 'Stránky',
  'Password' => 'Heslo',
  'Please enter a comment for this version' => 'Vložte prosím k této verzi komentář',
  'Please enter a name to save a copy of page: {page}' => 'Zadejte prosím název pro uložení kopie stránky {page}',
  'Please enter a {app_type}' => 'Zadejte prosím {app_type}',
  'Please give a page first' => 'Nejprve, prosím, zadejte stránku',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Zadejte prosím alespoň adresář, kde mají být stránky uloženy.
Nový sešit by měl mít vlastní prázdný adresář,
například "Poznámky" ve vašem domovském adresáři.',
  'Please provide the password for
{path}' => 'Zadejte prosím heslo pro
{path}',
  'Please select a notebook first' => 'Nejprve prosím vyberte sešit',
  'Please select a version first' => 'Vyberte, prosím, nejprve verzi',
  'Plugin already loaded: {name}' => 'Zásuvný modul {name} je již načtený',
  'Plugins' => 'Moduly',
  'Pr_eferences|Preferences dialog' => '_Nastavení|Dialog s nastavením',
  'Preferences' => 'Nastavení',
  'Prefix document root' => 'Prefix pro kořen dokumentu',
  'Print to Browser|Print to browser' => 'Náhled v prohlížeči|Prohlédnout v prohlížeči',
  'Prio' => 'Priorita',
  'Proper_ties|Properties dialog' => '_Vlastnosti|Nastavení vlastností',
  'Properties' => 'Vlastnosti',
  'Rank' => 'Řazení',
  'Re-build Index|Rebuild index' => 'Znovu _sestavit index|Znovu sestavit index',
  'Recursive' => 'Rekurzivně',
  'Rename page' => 'Přejmenovat stránku',
  'Rename to' => 'Přejmenovat na',
  'Replace _all' => 'Nahradit _vše',
  'Replace with' => 'Nahradit výrazem',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN cleanup|Vyčistit pracovní kopii SVN',
  'SVN commit|Commit notebook to SVN repository' => 'SVN commit|Commitnout sešit do SVN repozitáře',
  'SVN update|Update notebook from SVN repository' => 'SVN update|Aktualizovat sešit ze SVN repozitáře',
  'S_ave Version...|Save Version' => 'Uložit _verzi...|Uložit verzi',
  'Save Copy' => 'Uložit kopii',
  'Save version' => 'Uložit verzi',
  'Scanning tree ...' => 'Prohledávám strom...',
  'Search' => 'Hledat',
  'Search _Backlinks...|Search Back links' => 'Hledat _zpětné odkazy...|Hledat zpětné odkazy',
  'Select File' => 'Vybrat soubor',
  'Select Folder' => 'Vybrat složku',
  'Send To...' => 'Odeslat...',
  'Show cursor for read-only' => 'Zobrazovat kurzor v režimu jen pro čtení',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Zobrazí kurzor, i když stránku nelze editovat. Je to praktické při prohlížení jen pomocí klávesnice.',
  'Slow file system' => 'Pomalý souborový systém',
  'Source' => 'Zdroj',
  'Source Format' => 'Formát zdroje',
  'Start the side pane with the whole tree expanded.' => 'Při spuštění je strom v bočním panelu rozbalený.',
  'Stri_ke|Strike' => 'Proš_krtnuté|Proškrtnuté',
  'Strike' => 'Proškrtnuté',
  'TODO List' => 'Seznam úkolů',
  'Task' => 'Úkol',
  'Tearoff menus' => 'Odtrhávat nabídky',
  'Template' => 'Šablona',
  'Text' => 'Text',
  'Text Editor' => 'Textový wiki editor',
  'Text _From File...|Insert text from file' => 'Text ze _souboru|Vložit text ze souboru',
  'Text editor' => 'Textový editor',
  'The equation failed to compile. Do you want to save anyway?' => 'Rovnici se nepodařilo sestavit. Chcete ji přesto uložit?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'Rovnice pro obrázek: {path}
neexistuje. Rovnici či vzorec nelze upravit.',
  'This notebook does not have a document root' => 'Tento sešit nemá kořen dokumentu',
  'This page does not exist
404' => 'Tato stránka neexistuje.
404',
  'This page does not have a document folder' => 'Tato stránka nemá kořenovou složku',
  'This page does not have a source' => 'Tato stránka nemá zdroj',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Tato stránka byla v repozitáři aktualizována.
Aktualizujte, prosím, svou pracovní kopii (Nástroje | SVN update).',
  'To_day|Today' => '_Dnešek|Dnešní den',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Přepnout zaškrtávací pole \'V\'|Přepnout kladné zaškrtávací políčko',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Přepnout zaškrtávací pole \'X\'|Přepnout záporné zaškrtávací políčko',
  'Underline' => 'Podtržené',
  'Updating links' => 'Aktualizuji odkazy',
  'Updating links in {name}' => 'Aktualizuji odkazy v {name}',
  'Updating..' => 'Aktualizuji..',
  'Use "Backspace" to un-indent' => '"Backspace" smaže odsazení',
  'Use "Ctrl-Space" to switch focus' => '"Ctrl-Space" přepíná zaměření',
  'Use "Enter" to follow links' => '"Enter" následuje odkazy',
  'Use autoformatting to type special characters' => 'Pokud napíšete entitu, automaticky se přeformátuje',
  'Use custom font' => 'Použít vlastní písmo',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Klávesa "Backspace" zruší odsazení položek seznamu (stejně jako "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Klávesou "Ctrl-Space" se lze přepínat mezi textem a bočním panelem. Pokud je volba zakázána, můžete použít "Alt-Space".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Klávesu "Enter" použijte pro odskok na cíl odkazu. Pokud je tato volba zakázána, můžete použít "Alt-Enter"',
  'User' => 'Uživatel',
  'User name' => 'Uživatelské jméno',
  'Verbatim' => 'Strojopis',
  'Versions' => 'Verze',
  'View _Annotated...' => 'Zobrazit _komentované',
  'View _Log' => 'Zobrazit _záznam',
  'Web browser' => 'Webový prohlížeč',
  'Whole _word' => '_Celá slova',
  'Width' => 'Šířka',
  'Word Count' => 'Počet slov',
  'Words' => 'Slov',
  'You can add rules to your search query below' => 'Můžete přidat pravidla pro uvedený vyhledávací dotaz.',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Můžete si vybrat mezi dvěma systémy pro správu verzí: <b>Bazaar</b>, nebo <b>Subversion</b>.
Klepněte na tlačítko Nápověda, pokud vás zajímají jejich systémové požadavky.',
  'You have no {app_type} configured' => 'Není nastavena {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => 'Program je nutné znovu spustit, 
aby se změny v modulech projevily.',
  'Your name; this can be used in export templates' => 'Vaše jméno; používá se v šablonách pro export',
  'Zim Desktop Wiki' => 'Zim Desktop Wiki',
  '_About|About' => 'O _aplikaci|O programu',
  '_All' => '_Vše',
  '_Back|Go page back' => '_Zpět|O stranu zpět',
  '_Bold|Bold' => '_Tučné|Tučné',
  '_Browse...' => 'P_rohlížet...',
  '_Bugs|Bugs' => '_Chyby|Chyby',
  '_Child|Go to child page' => 'P_otomek|Přejít na podřízenou stránku',
  '_Close|Close window' => '_Zavřít|Zavřít okno',
  '_Contents|Help contents' => '_Obsah|Obsah nápovědy',
  '_Copy Page...|Copy page' => '_Kopírovat stránku...|Kopírovat stránku',
  '_Copy|Copy' => '_Kopírovat|Kopírovat',
  '_Date and Time...|Insert date' => '_Datum a čas...|Vložit datum',
  '_Delete Page|Delete page' => '_Smazat stránku|Smazat stránku',
  '_Delete|Delete' => '_Smazat|Smazat',
  '_Discard changes' => 'Za_hodit změny',
  '_Edit' => 'Ú_pravy',
  '_Edit Equation' => '_Upravit rovnici',
  '_Edit Link' => '_Upravit odkaz',
  '_Edit Link...|Edit link' => '_Upravit odkaz|Upravit odkaz',
  '_Edit|' => '_Upravit|',
  '_FAQ|FAQ' => '_FAQ|Často kladené otázky',
  '_File|' => '_Soubor|',
  '_Filter' => '_Filtr',
  '_Find...|Find' => '_Najít...|Najít',
  '_Forward|Go page forward' => '_Vpřed|O stranu vpřed',
  '_Go|' => '_Přejít|',
  '_Help|' => '_Nápověda|',
  '_History|.' => '_Historie|.',
  '_Home|Go home' => 'Do_mů|Přejít domů',
  '_Image...|Insert image' => 'O_brázek...|Vložit obrázek',
  '_Index|Show index' => '_Index|Zobrazit index',
  '_Insert' => '_Vložit',
  '_Insert|' => '_Vložit|',
  '_Italic|Italic' => '_Kurziva|Kurziva',
  '_Jump To...|Jump to page' => '_Skočit na...|Skočit na stránku',
  '_Keybindings|Key bindings' => '_Klávesové zkratky|Klávesové zkratky',
  '_Link' => '_Odkaz',
  '_Link to date' => '_Odkaz na datum',
  '_Link...|Insert link' => '_Odkaz...|Vložit odkaz',
  '_Link|Link' => '_Odkaz|Odkaz',
  '_Namespace|.' => '_Jmenný prostor|.',
  '_New Page|New page' => '_Nová stránka|Nová stránka',
  '_Next' => '_Další',
  '_Next in index|Go to next page' => '_Následující v indexu|Přejít na následující stránku stejné úrovně',
  '_Normal|Normal' => '_Normální|Normální',
  '_Notebook Changes...' => 'Z_měny v sešitu',
  '_Open Another Notebook...|Open notebook' => '_Otevřít jiný sešit...|Otevřít sešit',
  '_Open link' => '_Otevřít odkaz',
  '_Overwrite' => '_Přepsat',
  '_Page' => '_Stránku',
  '_Page Changes...' => 'Změny _stránky',
  '_Parent|Go to parent page' => '_Rodič|Přejít na rodičovskou stránku',
  '_Paste|Paste' => '_Vložit|Vložit',
  '_Preview' => '_Náhled',
  '_Previous' => '_Předchozí',
  '_Previous in index|Go to previous page' => '_Předchozí v indexu|Přejít na předcházející stránku stejné úrovně',
  '_Properties' => '_Vlastnosti',
  '_Quit|Quit' => '_Konec|Konec programu',
  '_Recent pages|.' => '_Poslední stránky|.',
  '_Redo|Redo' => 'Znov_u|Znovu',
  '_Reload|Reload page' => 'Zno_vu načíst stránku|Znovu načíst stránku',
  '_Rename' => '_Přejmenovat',
  '_Rename Page...|Rename page' => '_Přejmenovat stránku|Přejmenovat stránku',
  '_Replace' => '_Nahradit',
  '_Replace...|Find and Replace' => 'Za_měnit...|Najít a zaměnit',
  '_Reset' => '_Původní hodnoty',
  '_Restore Version...' => 'O_bnovit verzi',
  '_Save Copy' => 'Uložit _kopii',
  '_Save a copy...' => 'Uložit _kopii...',
  '_Save|Save page' => '_Uložit|Uložit stránku',
  '_Screenshot...|Insert screenshot' => '_Snímek obrazovky|Vložit snímek obrazovky',
  '_Search...|Search' => '_Hledat...|Hledat',
  '_Search|' => '_Hledat|',
  '_Send To...|Mail page' => 'O_deslat...|Odeslat stránku e-mailem',
  '_Statusbar|Show statusbar' => '_Stavový řádek|Zobrazit stavový řádek',
  '_TODO List...|Open TODO List' => 'Ú_koly...|Otevřít seznam úkolů',
  '_Today' => '_Dnes',
  '_Toolbar|Show toolbar' => '_Lišta nástrojů|Zobrazit lištu nástrojů',
  '_Tools|' => 'Nás_troje|',
  '_Underline|Underline' => '_Podtržené|Podtržené',
  '_Undo|Undo' => '_Zpět|Zpět',
  '_Update links in this page' => '_Aktualizovat odkazy na této stránce',
  '_Update {number} page linking here' => [
    '_Aktualizovat {number} stránku, která sem odkazuje',
    '_Aktualizovat {number} stránky, které sem odkazují',
    '_Aktualizovat {number} stránek, které sem odkazují'
  ],
  '_Verbatim|Verbatim' => '_Strojopis|Strojopis',
  '_Versions...|Versions' => 'V_erze...|Verze',
  '_View|' => '_Zobrazit|',
  '_Word Count|Word count' => 'Počet _slov|Počet slov',
  'other...' => 'jiná...',
  '{name}_(Copy)' => '{name}_(Kopie)',
  '{number} _Back link' => [
    '{number} _Zpětný odkaz',
    '{number} _Zpětné odkazy',
    '{number} _Zpětných odkazů'
  ],
  '{number} item total' => [
    '{number} položka',
    '{number} položky',
    '{number} položek'
  ]
};
