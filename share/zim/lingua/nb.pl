# Norwegian Bokmal translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Bjørn Olav Samdal (nb)
# kingu (nb)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-02-16 18:31+0000
# Last-Translator: Bjørn Olav Samdal <bjornsam@ulrik.uio.no>
# Language-Team: Norwegian Bokmal <nb@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=2; plural=n != 1;
# X-Launchpad-Export-Date: 2009-02-17 18:56+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n != 1},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Slett side</b>

er du sikker på å slette
siden \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Aktiver Versjonskontroll</b>

Versjonskontroll er ikke satt på for denne skissen.
Ønsker du å starte den?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Mappe ble ikke funnet.</b>

Mappenavn: {path}
finnes ikke, ønsker du å opprette mappen?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Side overskives?</b>

Valgt navn \'{name}\'
finnes allerede.
Ønsker du å skrive over eksisterende versjon?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Oppdatere kalender sider med 0.24 format?</b>

Notebook inneholder sider med datomerking som bruker format ååå_mm_dd.
Siden Zim 0.24 formatet er åååå:mm:dd blir dette brukt som standard, dette lager
namespaces for hver måned.

Ønsker du å oppdaterer notebook med den nye layouten?
',
  'Add \'tearoff\' strips to the menus' => '',
  'Application show two text files side by side' => '',
  'Application to compose email' => 'Velg applikasjon for å skrive epost',
  'Application to edit text files' => 'Applikasjon for å endre innhold av tekstfil',
  'Application to open directories' => 'Program for å åpne mapper',
  'Application to open urls' => 'Program til å åpne linker',
  'Attach _File|Attach external file' => 'Velg _Fil|Velg ekstern fil',
  'Attach external files' => 'Legg til eksterne sider',
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
  'Bold' => 'Fet',
  'Calen_dar|Show calendar' => '',
  'Calendar' => 'Kalender',
  'Can not find application "bzr"' => 'Finner ikke applikasjonen "brz"',
  'Can not find application "{name}"' => 'Finner ikke applikasjonen "{name}"',
  'Can not save a version without comment' => 'Kan ikke lagre versjonen uten kommentar',
  'Can not save to page: {name}' => 'Feil ved lagring av siden: {name}',
  'Can\'t find {url}' => 'Finner ikke {url}',
  'Cha_nge' => 'E_ndre',
  'Chars' => 'Bokstaver',
  'Check _spelling|Spell check' => '',
  'Check checkbox lists recursive' => '',
  'Checking a checkbox list item will also check any sub-items' => '',
  'Choose {app_type}' => 'Velg {app_type}',
  'Co_mpare Page...' => '',
  'Command' => 'Instruks',
  'Comment' => '',
  'Compare this version with' => '',
  'Copy Email Address' => 'Kopier e-postadresse',
  'Copy Location|Copy location' => 'Kopier sti|Kopier sti',
  'Copy _Link' => 'Kopier _Kobling',
  'Could not delete page: {name}' => 'Kunne ikke slette siden: {name}',
  'Could not get annotated source for page {page}' => '',
  'Could not get changes for page: {page}' => '',
  'Could not get changes for this notebook' => '',
  'Could not get file for page: {page}' => '',
  'Could not get versions to compare' => '',
  'Could not initialize version control' => 'Kunne ikke starte versjonskontrollen',
  'Could not load page: {name}' => 'Klarte ikke åpne siden: {name}',
  'Could not rename {from} to {to}' => 'Feil ved endring av navn fra {from} til {to}',
  'Could not save page' => 'Klarte ikke lagte siden',
  'Could not save version' => 'Kunne ikke lagre versjon',
  'Creating a new link directly opens the page' => '',
  'Creation Date' => '',
  'Cu_t|Cut' => 'Ku_tt|Kutt',
  'Current' => '',
  'Customise' => 'Tilpass',
  'Date' => '',
  'Default notebook' => 'Forvalgt notatblokk',
  'Details' => 'Detaljer',
  'Diff Editor' => '',
  'Diff editor' => '',
  'Directory' => '',
  'Document Root' => '',
  'E_quation...|Insert equation' => '',
  'E_xport...|Export' => 'E_ksport...|Eksport',
  'E_xternal Link...|Insert external link' => 'E_kstern Link...|Sett inn ekstern link',
  'Edit Image' => 'Rediger bilde',
  'Edit Link' => 'Rediger lenke',
  'Edit Query' => '',
  'Edit _Source|Open source' => 'Endre _Kilde|Åpen kildekode',
  'Edit notebook' => 'Endre notatblokk',
  'Edit text files "wiki style"' => 'Endre tekstfiler med "wiki oppsett"',
  'Editing' => '',
  'Email client' => 'E-postklient',
  'Enabled' => '',
  'Equation Editor' => 'Likningsredigering',
  'Equation Editor Log' => 'Sammenlignings Tabel Logg',
  'Expand side pane' => '',
  'Export page' => 'Eksporterside',
  'Exporting page {number}' => 'Eksporter side {number}',
  'Failed to cleanup SVN working copy.' => '',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Feil ved lasting av SVN tillegg,
har du installert subversjon verktøy?',
  'Failed to load plugin: {name}' => 'Feil ved lasting av tillegg: {name}',
  'Failed update working copy.' => '',
  'File browser' => 'Filleser',
  'File is not a text file: {file}' => 'Fil er ikke en tekstfil: {file}',
  'Filter' => '',
  'Find' => 'Finn',
  'Find Ne_xt|Find next' => 'Finn Ne_ste|Finn neste',
  'Find Pre_vious|Find previous' => 'Finn Forrige|Finn forrige',
  'Find and Replace' => 'Søk og erstatt',
  'Find what' => '',
  'Follow new link' => '',
  'For_mat|' => 'For_mat|',
  'Format' => 'Format',
  'General' => '',
  'Go to "{link}"' => 'Gå til "{link}"',
  'H_idden|.' => 'G_jemt|.',
  'Head _1|Heading 1' => 'Overskrift_1|Overskrift 1',
  'Head _2|Heading 2' => 'Overskrift_2|Overskrift 2',
  'Head _3|Heading 3' => 'Overskrift_3|Overskrift 3',
  'Head _4|Heading 4' => 'Overskrift_4|Overskrift 4',
  'Head _5|Heading 5' => 'Overskrift_5|Overskrift 5',
  'Head1' => 'Overskrift1',
  'Head2' => 'Overskrift2',
  'Head3' => 'Overskrift3',
  'Head4' => 'Overskrift4',
  'Head5' => 'Overskrift5',
  'Height' => 'Høyde',
  'Home Page' => '',
  'Icon' => '',
  'Id' => '',
  'Include all open checkboxes' => '',
  'Index page' => 'Registerside',
  'Initial version' => 'Første versjon',
  'Insert Date' => 'Sett inn dato',
  'Insert Image' => 'Sett inn bilde',
  'Insert Link' => 'Sett inn lenke',
  'Insert from file' => 'Sett inn fra fil',
  'Interface' => '',
  'Italic' => 'Kursiv',
  'Jump to' => 'Gå til',
  'Jump to Page' => 'Gå til Side',
  'Lines' => 'Linjer',
  'Links to' => 'Lenke til',
  'Match c_ase' => '',
  'Media' => 'Media',
  'Modification Date' => '',
  'Name' => '',
  'New notebook' => 'Ny notisblokk',
  'New page' => 'Ny side',
  'No such directory: {name}' => 'Inget slikt direktiv: {name}',
  'No such file or directory: {name}' => 'Ingen fil eller mappe: {name}',
  'No such file: {file}' => 'Ingen slik fil: {file}',
  'No such notebook: {name}' => 'Ingen valgt kladdebok: {name}',
  'No such page: {page}' => '',
  'No such plugin: {name}' => 'Ingen tillegg funnet: {name}',
  'Normal' => 'Normal',
  'Not Now' => 'Ikke nå',
  'Not a valid page name: {name}' => 'Ikke gyldig navn på siden: {name}',
  'Not an url: {url}' => 'Feil ved adresse {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Merk at ved linking til ikke eksisterende side
så opprettes den som en ny side.',
  'Notebook' => '',
  'Notebooks' => 'Notatblokker',
  'Open Document _Folder|Open document folder' => 'Åpne Dokument_mappe|Åpne dokumentmappe',
  'Open Document _Root|Open document root' => 'Åpne dokument _rot|Åpne dokument rot',
  'Open _Directory' => 'Åpne _Mappe',
  'Open notebook' => 'Åpne notatblokk',
  'Other...' => '',
  'Output' => 'Utdata',
  'Output dir' => 'Lagringsmappe',
  'P_athbar type|' => '',
  'Page' => 'Side',
  'Page Editable|Page editable' => '',
  'Page name' => 'Sidennavn',
  'Pages' => 'Sider',
  'Password' => 'Passord',
  'Please enter a comment for this version' => 'Vennligst legg til en kommentar til versjonen',
  'Please enter a name to save a copy of page: {page}' => 'Velg navn for å lagre kopien: {page}',
  'Please enter a {app_type}' => 'Legg til en {app_type}',
  'Please give a page first' => '',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Vennligst legg til en mappe for å lagre sidene.
For en ny notatblokk burde dette være en tom mappe.
For eksempel "Notater" katalogen i din hjemmemappe.',
  'Please provide the password for
{path}' => 'Vennligst legg inn passord for
{path}',
  'Please select a notebook first' => 'Vennligst legg til en notatblokk',
  'Please select a version first' => '',
  'Plugin already loaded: {name}' => 'Tillegg allerede åpnet: {name}',
  'Plugins' => '',
  'Pr_eferences|Preferences dialog' => 'Opps_ett|Oppsett valg',
  'Preferences' => '',
  'Prefix document root' => '',
  'Print to Browser|Print to browser' => '',
  'Prio' => '',
  'Proper_ties|Properties dialog' => 'Egenskaper|Egenskapsdialog',
  'Properties' => '',
  'Rank' => '',
  'Re-build Index|Rebuild index' => 'Gjennopprett Index|Gjennopprett index',
  'Recursive' => 'Rekursiv',
  'Rename page' => 'Endre sidenavn',
  'Rename to' => 'Endre til',
  'Replace _all' => 'Erstatt _alle',
  'Replace with' => 'Erstatt med',
  'SVN cleanup|Cleanup SVN working copy' => '',
  'SVN commit|Commit notebook to SVN repository' => '',
  'SVN update|Update notebook from SVN repository' => '',
  'S_ave Version...|Save Version' => 'L_agre Versjon...|Lagre Versjon',
  'Save Copy' => 'Lagre kopi',
  'Save version' => 'Lagre versjon',
  'Scanning tree ...' => '',
  'Search' => '',
  'Search _Backlinks...|Search Back links' => 'Søk _Bakover...|Søk linker bakover',
  'Select File' => 'Velg Fil',
  'Select Folder' => 'Velg Mappe',
  'Send To...' => 'Send til...',
  'Show cursor for read-only' => '',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => '',
  'Slow file system' => '',
  'Source' => 'Kilde',
  'Source Format' => '',
  'Start the side pane with the whole tree expanded.' => '',
  'Stri_ke|Strike' => 'Gjennomstre_ket|Gjennomstreket',
  'Strike' => 'Gjennomstreket',
  'TODO List' => '',
  'Task' => '',
  'Tearoff menus' => '',
  'Template' => 'Mal',
  'Text' => 'Tekst',
  'Text Editor' => 'Tekstredigering',
  'Text _From File...|Insert text from file' => 'Tekst _Fra Fil...|Sett inn tekst fra fil',
  'Text editor' => 'Tekstfelt',
  'The equation failed to compile. Do you want to save anyway?' => 'Sammenligningen klarte ikke kompilere rikitg. Ønsker du å lagre likevel?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'Sammenligning for bildet: {path}
mangler. Klarer ikke endre sammenligningsgrunnlag.',
  'This notebook does not have a document root' => 'Notebook har ikenge dokument rot.',
  'This page does not exist
404' => 'Denne siden finnes ikke
404',
  'This page does not have a document folder' => 'Siden har ikke noen dokumentmappe',
  'This page does not have a source' => 'Siden har ingen kilde',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => '',
  'To_day|Today' => '',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Velg avkryssingsboks \'V\'|Velg avkryssingsboks',
  'Toggle Chechbox \'X\'|Toggle checkbox' => '',
  'Underline' => 'Understreking',
  'Updating links' => 'Oppdater linker',
  'Updating links in {name}' => 'Oppdaterer linker i {name}',
  'Updating..' => 'Oppdaterer..',
  'Use "Backspace" to un-indent' => '',
  'Use "Ctrl-Space" to switch focus' => '',
  'Use "Enter" to follow links' => '',
  'Use autoformatting to type special characters' => '',
  'Use custom font' => '',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => '',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => '',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => '',
  'User' => '',
  'User name' => '',
  'Verbatim' => '',
  'Versions' => '',
  'View _Annotated...' => '',
  'View _Log' => 'Vis _logg',
  'Web browser' => 'Nettleser',
  'Whole _word' => 'Hele _ordet',
  'Width' => 'Bredde',
  'Word Count' => 'Ordtelling',
  'Words' => 'Ord',
  'You can add rules to your search query below' => '',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Du kan velge å bruke enten <b>Bazaar</b> eller <b>Subversjon</b> Versjons Kontroll Systemet.
Vennligst velg \'hjelp\' for å lese mer om system krav.',
  'You have no {app_type} configured' => 'Du har ingen {app_type} konfigurert',
  'You need to restart the application
for plugin changes to take effect.' => '',
  'Your name; this can be used in export templates' => '',
  'Zim Desktop Wiki' => 'Zim Skrivebords-wiki',
  '_About|About' => '_Om|Om',
  '_All' => '_Alt',
  '_Back|Go page back' => '_Tilbake|Gå tilbake side',
  '_Bold|Bold' => '_Fet|Fet',
  '_Browse...' => '_Bla gjennom...',
  '_Bugs|Bugs' => '_Feil|Feil',
  '_Child|Go to child page' => '_Barn|Gå til nedenforliggende side',
  '_Close|Close window' => '_Lukk|Lukk vindu',
  '_Contents|Help contents' => '_Innhold|Hjelpeinnhold',
  '_Copy Page...|Copy page' => '_Kopier Side...|Kopier side',
  '_Copy|Copy' => 'Ko_pier|Kopier',
  '_Date and Time...|Insert date' => '_Dato og Tid...|Sett inn dato',
  '_Delete Page|Delete page' => '_Slett side|Slett side',
  '_Delete|Delete' => '_Slett|Slett',
  '_Discard changes' => '_Forkast endringene',
  '_Edit' => '_Endre',
  '_Edit Equation' => '_Endre sammenligning',
  '_Edit Link' => '_Endre Kobling',
  '_Edit Link...|Edit link' => '_Endre Link|Endre stil',
  '_Edit|' => '_Endre|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_Fil|',
  '_Filter' => '',
  '_Find...|Find' => '_Finn...|Finn',
  '_Forward|Go page forward' => '_Vidresend|Send side videre',
  '_Go|' => '_Kjør|',
  '_Help|' => '_Hjelp|',
  '_History|.' => '_Historie|.',
  '_Home|Go home' => '_Hjem|Gå til hjemmekatalog',
  '_Image...|Insert image' => '_Bilde...|Sett inn bilde',
  '_Index|Show index' => '_Innhold|Vis innhold',
  '_Insert' => 'Sett _inn',
  '_Insert|' => '_Sett Inn|',
  '_Italic|Italic' => '_Kursiv|Kursiv',
  '_Jump To...|Jump to page' => '_Hopp Til...|Hopp til side',
  '_Keybindings|Key bindings' => '_Tastaturoppsett|Tastaturoppsett',
  '_Link' => '_Lenke',
  '_Link to date' => '_Link til dato',
  '_Link...|Insert link' => '_Link...|Sett inn link',
  '_Link|Link' => '_Link|Link',
  '_Namespace|.' => '_Navnplass|.',
  '_New Page|New page' => '_Ny side|Ny side',
  '_Next' => '_Neste',
  '_Next in index|Go to next page' => '_Neste i rekkefølgen|Gå til neste side',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => '_Notebook Endringer...',
  '_Open Another Notebook...|Open notebook' => '_Åpne en annen Notebook...|Åpne notebook',
  '_Open link' => '_Åpne lenke',
  '_Overwrite' => '_Overskriv',
  '_Page' => '_Side',
  '_Page Changes...' => '',
  '_Parent|Go to parent page' => '_Foreldre|Gå til overforliggende side',
  '_Paste|Paste' => '_Lim Inn|Lim inn',
  '_Preview' => '_Forhåndsvis',
  '_Previous' => '_Forrige',
  '_Previous in index|Go to previous page' => '_Forhåndsvis indexside|Gå til forrige side',
  '_Properties' => '_Egenskaper',
  '_Quit|Quit' => '_Avslutt|Avslutt',
  '_Recent pages|.' => '_Forrige sider|.',
  '_Redo|Redo' => 'E_ndre tilbake|Endre tilbake',
  '_Reload|Reload page' => '_Oppdater|Oppdater side',
  '_Rename' => '_Endre navn',
  '_Rename Page...|Rename page' => '_Endre sidenavn...|Endre sidenavn',
  '_Replace' => '_Erstatt',
  '_Replace...|Find and Replace' => '_erstatt...|Finn og Erstatt',
  '_Reset' => '_Tilbakestill',
  '_Restore Version...' => '',
  '_Save Copy' => '_Lagre kopi',
  '_Save a copy...' => '_Lagre en kopi...',
  '_Save|Save page' => '_Lagre|Lagre side',
  '_Screenshot...|Insert screenshot' => '',
  '_Search...|Search' => '_Søk...|Søk',
  '_Search|' => '_Søk|',
  '_Send To...|Mail page' => '_Send Til...|E-post side',
  '_Statusbar|Show statusbar' => '_Statuslinje|Vis statuslinje',
  '_TODO List...|Open TODO List' => '',
  '_Today' => '_Idag',
  '_Toolbar|Show toolbar' => '_Verktøylinje|Vis verktøylinje',
  '_Tools|' => '_Verktøy|',
  '_Underline|Underline' => '_Understreking|Understreking',
  '_Undo|Undo' => '_Endre|Endre',
  '_Update links in this page' => '_Oppdater linker i siden',
  '_Update {number} page linking here' => [
    '_Oppdater {number} side link her',
    '_Oppdater {number} side link her'
  ],
  '_Verbatim|Verbatim' => '',
  '_Versions...|Versions' => '_Versjoner...|Versjoner',
  '_View|' => '_Vis|',
  '_Word Count|Word count' => '_Tell Ord|Tell ord',
  'other...' => 'annen...',
  '{name}_(Copy)' => '{name}_(Kopi)',
  '{number} _Back link' => [
    '{number} _Tilbakesteg',
    '{number} _Tilbakesteg'
  ],
  '{number} item total' => [
    '',
    ''
  ]
};
