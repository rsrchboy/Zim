# Danish translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Frederik 'Freso' S. Olesen (da)
# Jeppe Toustrup (da)
# nanker (da)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-12-13 12:25+0000
# Last-Translator: nanker <Unknown>
# Language-Team: Danish <da@li.org>
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
  '%a %b %e %Y' => '%a den %b. %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Slet side</b>

Er du sikker på at du vil slette
siden "{name}"?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Aktivér versions kontrol</b>

Versions kontrol er ikke aktiveret for denne notesblok lige nu.
Ønsker du at aktivere det?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Mappen eksisterer ikke.</b>

Mappen "{path}"
eksisterer ikke, vil du oprette den nu?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Siden eksisterer allerede</b>

Siden "{name}"
eksisterer allerede.
Ønsker du at overskrive den?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Opgradér kalender sider til 0.24 format?</b>

Denne notesblok indeholder sider for datoer, der bruger formatet åååå_mm_dd.
Fra og med Zim 0.24 bliver formatet åååå:mm:dd benyttet som standard, hvilket
opretter navnerum for hver måned.

Ønsker du at opgradere denne notesblok til det nye format?
',
  'Add \'tearoff\' strips to the menus' => 'Tilføj afrivningsstreger til menuerne',
  'Application show two text files side by side' => 'Et program til at sammelinge to tekstfiler side om side',
  'Application to compose email' => 'Program til at sende post',
  'Application to edit text files' => 'Program til at redigere tekstfiler',
  'Application to open directories' => 'Program til at åbne mapper',
  'Application to open urls' => 'Program til at åbne henvisninger',
  'Attach _File|Attach external file' => '_Vedhæft fil|Vedhæft en ekstern fil til notesblokken',
  'Attach external files' => 'Vedhæft eksterne filer',
  'Auto-format entities' => 'Auto-formatér specialtegn',
  'Auto-increment numbered lists' => 'Øg automatisk nummerede lister',
  'Auto-link CamelCase' => 'Auto-henvis CamelCase',
  'Auto-link files' => 'Auto-henvis filer',
  'Auto-save version on close' => 'Gem automatisk version ved lukning',
  'Auto-select words' => 'Markér automatisk ord',
  'Automatically increment items in a numbered list' => 'Læg automatisk til nummeret i en nummereret liste',
  'Automatically link file names when you type' => 'Opret automatisk henvisninger til filer når du skriver',
  'Automaticly link CamelCase words when you type' => 'Henvis automatisk CamelCase-ord når du skriver',
  'Automaticly select the current word when you toggle the format' => 'Markér automatisk det aktuelle ord når du ændrer formatet',
  'Bold' => 'Fed',
  'Calen_dar|Show calendar' => '_Kalender|Vis kalender',
  'Calendar' => 'Kalender',
  'Can not find application "bzr"' => 'Kan ikke finde applikation "bzr"',
  'Can not find application "{name}"' => 'Kan ikke finde applikation "{name}"',
  'Can not save a version without comment' => 'Det er ikke muligt at gemme uden en kommentar',
  'Can not save to page: {name}' => 'Siden "{name}" kan ikke gemmes',
  'Can\'t find {url}' => 'Adressen "{url}" kunne ikke findes',
  'Cha_nge' => '_Redigér',
  'Chars' => 'Tegn',
  'Check _spelling|Spell check' => 'Kontrollér stavemåder|Start kontrol af stavemåder',
  'Check checkbox lists recursive' => '',
  'Checking a checkbox list item will also check any sub-items' => '',
  'Choose {app_type}' => 'Vælg {app_type}',
  'Co_mpare Page...' => 'S_ammeling side',
  'Command' => 'Kommando',
  'Comment' => 'Kommentar',
  'Compare this version with' => 'Sammeling denne version med',
  'Copy Email Address' => 'Kopiér _post adresse',
  'Copy Location|Copy location' => 'Kopiér _placering|Kopiér adressen til den aktive side',
  'Copy _Link' => 'Kopiér _henvisning',
  'Could not delete page: {name}' => 'Siden "{name}" kunne ikke slettes',
  'Could not get annotated source for page {page}' => 'Det var ikke muligt at få en annoteret kilde for siden: {page}',
  'Could not get changes for page: {page}' => 'Det var ikke muligt at få ændringerne for siden: {page}',
  'Could not get changes for this notebook' => '',
  'Could not get file for page: {page}' => 'Det var ikke muligt at få filen for siden: {page}',
  'Could not get versions to compare' => 'Det var ikke muligt at få versionerne til sammelinging',
  'Could not initialize version control' => 'Det var ikke muligt at starte versions kontrollen',
  'Could not load page: {name}' => 'Siden "{name}" kunne ikke indlæses',
  'Could not rename {from} to {to}' => 'Det var ikke muligt at omdøbe fra {from} til {to}',
  'Could not save page' => 'Siden kunne ikke gemmes',
  'Could not save version' => 'Det var ikke muligt at gennem versionen',
  'Creating a new link directly opens the page' => 'Oprettelse af en ny henvisning åbner automatisk den nye side',
  'Creation Date' => 'Oprettelsesdato',
  'Cu_t|Cut' => '_Klip|Klip teksten til udklipsholderen',
  'Current' => 'Nuværende',
  'Customise' => 'Tilpas',
  'Date' => 'Dato',
  'Default notebook' => 'Standard notesblok',
  'Details' => 'Detaljer',
  'Diff Editor' => 'Diff program',
  'Diff editor' => 'Diff program',
  'Directory' => 'Mappe',
  'Document Root' => 'Dokumentrod',
  'E_quation...|Insert equation' => '_Ligning...|Indsæt en ligning',
  'E_xport...|Export' => '_Eksportér...|Eksportér siden eller hele notesblokken til et andet format',
  'E_xternal Link...|Insert external link' => '_Ekstern henvisning...|Indsæt en ekstern henvisning',
  'Edit Image' => 'Redigér billede',
  'Edit Link' => 'Redigér henvisning',
  'Edit Query' => 'Redigér forespørgsel',
  'Edit _Source|Open source' => 'R_edigér kildetekst|Åben siden til redigering i en ekstern tekstbehandler',
  'Edit notebook' => 'Redigér notesblok',
  'Edit text files "wiki style"' => 'Redigér tekst filer i "wikistil"',
  'Editing' => 'Redigering',
  'Email client' => 'Postprogram',
  'Enabled' => 'Aktivt',
  'Equation Editor' => 'Ligningsbehandler',
  'Equation Editor Log' => 'Ligningsbehandler log',
  'Expand side pane' => 'Udfold sidepanelet',
  'Export page' => 'Eksportér side',
  'Exporting page {number}' => 'Eksporterer side {number}',
  'Failed to cleanup SVN working copy.' => '',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => '',
  'Failed to load plugin: {name}' => 'Udvidelsesmodulet "{name}" kunne ikke indlæses',
  'Failed update working copy.' => 'Opdatering af arbejdskopi mislykkedes.',
  'File browser' => 'Filvælger',
  'File is not a text file: {file}' => 'Filen "{file}" er ikke en tekstfil',
  'Filter' => 'Filter',
  'Find' => 'Søg',
  'Find Ne_xt|Find next' => 'Find _næste|Find den næste tekst som matcher din søgning',
  'Find Pre_vious|Find previous' => 'Find f_orrige|Find den forrige tekst der matcher din søgning',
  'Find and Replace' => 'Søg og erstat',
  'Find what' => 'Søg efter',
  'Follow new link' => 'Følg ny henvisning',
  'For_mat|' => 'F_ormatér|Formatér din tekst som for eksempel en overskrift, fed eller kursiv tekst',
  'Format' => 'Format',
  'General' => 'Generelt',
  'Go to "{link}"' => 'Gå til "{link}"',
  'H_idden|.' => 'S_kjult|Skjul navigeringslinjen',
  'Head _1|Heading 1' => 'Overskrift _1|Overskrift af første niveau',
  'Head _2|Heading 2' => 'Overskrift _2|Overskrift af anden niveau',
  'Head _3|Heading 3' => 'Overskrift _3|Overskrift af tredje niveau',
  'Head _4|Heading 4' => 'Overskrift _4|Overskrift af fjerde niveau',
  'Head _5|Heading 5' => 'Overskrift _5|Overskrift af femte niveau',
  'Head1' => 'Overskrift1',
  'Head2' => 'Overskrift2',
  'Head3' => 'Overskrift3',
  'Head4' => 'Overskrift4',
  'Head5' => 'Overskrift5',
  'Height' => 'Højde',
  'Home Page' => 'Hjemmeside',
  'Icon' => 'Ikon',
  'Id' => 'Id',
  'Include all open checkboxes' => '',
  'Index page' => 'Indeksside',
  'Initial version' => 'Første version',
  'Insert Date' => 'Indsæt dato',
  'Insert Image' => 'Indsæt billede',
  'Insert Link' => 'Indsæt henvisning',
  'Insert from file' => 'Indsæt fra fil',
  'Interface' => 'Grænseflade',
  'Italic' => 'Kursiv',
  'Jump to' => 'Spring til',
  'Jump to Page' => 'Spring til side',
  'Lines' => 'Linjer',
  'Links to' => 'Henviser til',
  'Match c_ase' => '_Versalfølsom',
  'Media' => 'Medie',
  'Modification Date' => 'Ændringsdato',
  'Name' => 'Navn',
  'New notebook' => 'Ny notesblok',
  'New page' => 'Ny side',
  'No such directory: {name}' => 'Mappen "{name}" findes ikke',
  'No such file or directory: {name}' => 'Ikke sådan en fil eller mappe: {name}',
  'No such file: {file}' => 'Filen "{file}" kunne ikke findes',
  'No such notebook: {name}' => 'Notesbogen "{name}" findes ikke',
  'No such page: {page}' => 'Siden findes ikke: {page}',
  'No such plugin: {name}' => 'Udvidelsesmodulet "{name}" findes ikke',
  'Normal' => 'Normal',
  'Not Now' => '_Ikke nu',
  'Not a valid page name: {name}' => 'Navnet "{name}" er ikke et gyldigt side navn',
  'Not an url: {url}' => 'Adressen "{url}" er ikke en gyldig adresse',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Bemærk at hvis der henvises til en ikke eksisterende side,
bliver der også automatisk oprettet en ny side.',
  'Notebook' => 'Notesblok',
  'Notebooks' => 'Notesblokke',
  'Open Document _Folder|Open document folder' => 'Åben _sidens mappe|Åbner mappen hvor i den aktive side er placeret',
  'Open Document _Root|Open document root' => 'Åben _rodmappe|Åbner mappen som er roden til denne notesblok',
  'Open _Directory' => 'Åben _mappe',
  'Open notebook' => 'Åben notesblok',
  'Other...' => 'Anden...',
  'Output' => 'Uddata',
  'Output dir' => 'Destinationsmappe',
  'P_athbar type|' => '_Navigeringslinje type|Vælg funktionsmåden for navigeringslinjen',
  'Page' => 'Side',
  'Page Editable|Page editable' => 'Side redigerbar|Ændre på hvorvidt der er mulighed for at redigere siden',
  'Page name' => 'Sidenavn',
  'Pages' => 'Sider',
  'Password' => 'Adgangskode',
  'Please enter a comment for this version' => 'Indtast en kommentar til denne version',
  'Please enter a name to save a copy of page: {page}' => 'Indtast venligst et navn for at gemme en kopi af siden: {page}',
  'Please enter a {app_type}' => 'Indtast venligst en {app_type}',
  'Please give a page first' => 'Angiv venligst en side først',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Angiv som minimum en mappe til at gemme dine sider i.
Til en ny noteblok skal denne mappe være tom.
For eksempel en mappe "Noter" i din hjemmemappe.',
  'Please provide the password for
{path}' => 'Angiv venligst adgangskoden for
{path}',
  'Please select a notebook first' => 'Vælg venligst en notesblok først',
  'Please select a version first' => 'Angiv venligst en version først',
  'Plugin already loaded: {name}' => 'Udvidelsesmodulet "{name}" er allerede indlæst',
  'Plugins' => 'Udvidelsesmoduler',
  'Pr_eferences|Preferences dialog' => 'I_ndstillinger|Justér indstillinger vedrørende Zim',
  'Preferences' => 'Indstillinger',
  'Prefix document root' => 'Præfiks dokumentroden',
  'Print to Browser|Print to browser' => 'U_dskriv til browser|Åben den aktuelle side så du kan udskrive den',
  'Prio' => 'Prioritet',
  'Proper_ties|Properties dialog' => 'Egensk_aber|Redigér indstillinger for notesblokken',
  'Properties' => 'Egenskaber',
  'Rank' => 'Rangering',
  'Re-build Index|Rebuild index' => '_Genopbyg indeks|Indeksér alle sider forfra',
  'Recursive' => 'Rekursivt',
  'Rename page' => 'Omdøb side',
  'Rename to' => 'Omdøb til',
  'Replace _all' => 'Erstat _alt',
  'Replace with' => 'Erstat med',
  'SVN cleanup|Cleanup SVN working copy' => '',
  'SVN commit|Commit notebook to SVN repository' => '',
  'SVN update|Update notebook from SVN repository' => '',
  'S_ave Version...|Save Version' => 'Ge_m version...|Gem version',
  'Save Copy' => 'Gem kopi',
  'Save version' => 'Gem version',
  'Scanning tree ...' => 'Skanner træ...',
  'Search' => 'Søg',
  'Search _Backlinks...|Search Back links' => 'Søg efter _referencer...|Søg efter sider der henviser til en given side',
  'Select File' => 'Vælg fil',
  'Select Folder' => 'Vælg mappe',
  'Send To...' => 'Send til...',
  'Show cursor for read-only' => 'Vis markør i skrivebeskyttet tilstand',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Vis markøren selv om du ikke kan redigere siden. Dette kan bruges til tastaturbaseret læsning.',
  'Slow file system' => 'Langsomt filsystem',
  'Source' => 'Kildetekst',
  'Source Format' => 'Kilde format',
  'Start the side pane with the whole tree expanded.' => 'Start sidepanelet med hele træet udfoldet',
  'Stri_ke|Strike' => '_Gennemstreget|Gennemstreget tekst',
  'Strike' => 'Gennemstreg',
  'TODO List' => 'Opgaveliste',
  'Task' => 'Opgave',
  'Tearoff menus' => 'Afrivningsmenuer',
  'Template' => 'Skabelon',
  'Text' => 'Tekst',
  'Text Editor' => 'Tekstredigeringsprogram',
  'Text _From File...|Insert text from file' => '_Tekst fra fil...|Indsæt tekst fra en fil',
  'Text editor' => 'Tekstbehandler',
  'The equation failed to compile. Do you want to save anyway?' => 'Ligningen kunne ikke oversættes. Ønsker du at gemme alligevel?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'Ligningen for billedet {path}
mangler. Det er ikke muligt at redigere ligningen.',
  'This notebook does not have a document root' => 'Denne notesblok har ikke en dokumentrod',
  'This page does not exist
404' => 'Denne side eksisterer ikke
404',
  'This page does not have a document folder' => 'Denne side indeholder ikke en dokumentmappe',
  'This page does not have a source' => 'Denne side har ikke nogen kildetekst',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => '',
  'To_day|Today' => '_I dag|Gå til i dags dato',
  'Toggle Chechbox \'V\'|Toggle checkbox' => '',
  'Toggle Chechbox \'X\'|Toggle checkbox' => '',
  'Underline' => 'Understreg',
  'Updating links' => 'Opdaterer henvisninger',
  'Updating links in {name}' => 'Opdaterer henvisninger i {name}',
  'Updating..' => 'Opdaterer...',
  'Use "Backspace" to un-indent' => 'Brug tilbage-tasten til at fjerne indrykning',
  'Use "Ctrl-Space" to switch focus' => 'Brug Ctrl-Mellemrum for at skifte fokus',
  'Use "Enter" to follow links' => 'Benyt Enter for at følge henvisninger',
  'Use autoformatting to type special characters' => 'Benyt automatisk formatering til at indtaste specialtegn',
  'Use custom font' => 'Brug en selvvalgt skrifttype',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Brug tilbage-tasten til at fjerne indrykningen af punktlister (samme funktion som Shift-Tab)',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Brug Ctrl-Mellemrum tastekombinationen for at skifte fokus imellem teksten og sidepanelet. Hvis denne er deaktiveret kan du forsat benytte Alt-Mellemrum.',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Benyt knappen Enter til at følge en henvisning. Du kan stadig bruge Alt-Enter hvis du deaktiverer dette',
  'User' => 'Bruger',
  'User name' => 'Brugernavn',
  'Verbatim' => 'Ordret',
  'Versions' => 'Versioner',
  'View _Annotated...' => 'Vis _annoteret...',
  'View _Log' => '_Vis log',
  'Web browser' => 'Webbrowser',
  'Whole _word' => '_Hele ord',
  'Width' => 'Bredde',
  'Word Count' => 'Ordoptælling',
  'Words' => 'Ord',
  'You can add rules to your search query below' => 'Herunder kan du tilføje regler til din søgning',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => '',
  'You have no {app_type} configured' => 'Du har ikke nogen {app_type} konfigureret',
  'You need to restart the application
for plugin changes to take effect.' => 'Du bliver nød til at genstarte programmet for at
ændringer i udvidelsesmodulerne kan træde i kraft.',
  'Your name; this can be used in export templates' => 'Dit navn; dette kan blive brugt i eksportskabeloner',
  'Zim Desktop Wiki' => 'Zim Desktop Wiki',
  '_About|About' => 'O_m|Omkring Zim',
  '_All' => 'A_lle',
  '_Back|Go page back' => '_Tilbage|Gå én side tilbage',
  '_Bold|Bold' => '_Fed|Fed tekst',
  '_Browse...' => '_Gennemse...',
  '_Bugs|Bugs' => '_Fejl|Informationer omkring fejlrapporting og lignende',
  '_Child|Go to child page' => '_Ned|Gå til siden under den nuværende',
  '_Close|Close window' => 'L_uk|Luk vinduet',
  '_Contents|Help contents' => '_Indhold|Oversigt over hjælpesiderne',
  '_Copy Page...|Copy page' => '_Kopier side...|Kopier side',
  '_Copy|Copy' => 'Kop_iér|Kopiér teksten til udklipsholderen',
  '_Date and Time...|Insert date' => '_Dato og tid...|Indsæt tid og dato',
  '_Delete Page|Delete page' => '_Slet side|Slet den aktive side',
  '_Delete|Delete' => '_Slet|Slet tekst eller elementer',
  '_Discard changes' => 'For_kast ændringer',
  '_Edit' => 'R_edigér',
  '_Edit Equation' => '_Redigér ligning',
  '_Edit Link' => '_Redigér henvisning',
  '_Edit Link...|Edit link' => '_Redigér henvisning...|Redigér en eksisterende henvisning',
  '_Edit|' => 'R_edigér|Indstillinger for programmet samt muligheder for at redigere tekst og henvisninger',
  '_FAQ|FAQ' => '_OSS|Ofte Stillede Spørgsmål omkring Zim',
  '_File|' => '_Filer|Opret, gem, eksporter og udskiv noteblokke',
  '_Filter' => '_Filtrér',
  '_Find...|Find' => '_Find...|Find tekst på den aktuelle side',
  '_Forward|Go page forward' => '_Frem|Gå én side frem',
  '_Go|' => '_Gå|Navigér rundt i din notesblok',
  '_Help|' => '_Hjælp|Instruktionsbogen til Zim samt andre nyttige informationer',
  '_History|.' => '_Historik|En alternativ måde at få vist de sidst besøgte sider på',
  '_Home|Go home' => '_Hjem|Gå til forsiden',
  '_Image...|Insert image' => '_Billede...|Indsæt et billede',
  '_Index|Show index' => '_Oversigt|Vis oversigten',
  '_Insert' => '_Indsæt',
  '_Insert|' => '_Indsæt|Indsæt dato, billeder, eksterne tekstfiler og henvisninger i notesblokken',
  '_Italic|Italic' => '_Kursiv|Kursiv tekst',
  '_Jump To...|Jump to page' => '_Spring til...|Gå direkte til en given side',
  '_Keybindings|Key bindings' => '_Genvejstaster|Oversigt over hvilke genvejstaster der er til rådighed',
  '_Link' => '_Redigér',
  '_Link to date' => '_Opret henvisning til datoen',
  '_Link...|Insert link' => '_Henvisning...|Indsæt en henvisning',
  '_Link|Link' => '_Henvisning|En henvisning til en anden side eller til en ekstern lokation',
  '_Namespace|.' => '_Navnerum|Få vist en hierarkisk liste over ovenliggende sider til den nuværende',
  '_New Page|New page' => '_Ny side|Opret en ny side',
  '_Next' => '_Næste',
  '_Next in index|Go to next page' => 'N_æste i indeks|Gå til den næste side i indekset',
  '_Normal|Normal' => '_Normal|Normal brødtekst uden nogen speciel fremhævning',
  '_Notebook Changes...' => 'Notesblok ændringer...',
  '_Open Another Notebook...|Open notebook' => '_Åben notesblok...|Åben en anden notesblok',
  '_Open link' => '_Åben henvisning',
  '_Overwrite' => '_Overskriv',
  '_Page' => '_Side',
  '_Page Changes...' => '_Side ændringer',
  '_Parent|Go to parent page' => '_Op|Gå til den ovenliggende side',
  '_Paste|Paste' => 'Sæ_t ind|Indsæt teksten fra udklipsholderen',
  '_Preview' => '_Eksempel',
  '_Previous' => '_Forrige',
  '_Previous in index|Go to previous page' => 'Fo_rrige i indeks|Gå til den forrige side i indekset',
  '_Properties' => '_Egenskaber',
  '_Quit|Quit' => 'A_fslut|Afslut Zim',
  '_Recent pages|.' => '_Seneste sider|Få vist en oversigt over de sider du sidst har besøgt',
  '_Redo|Redo' => '_Omgør|Lav en ændring igen som du har fortrudt',
  '_Reload|Reload page' => '_Genindlæs|Indlæs siden forfra',
  '_Rename' => '_Omdøb',
  '_Rename Page...|Rename page' => '_Omdøb side...|Giv den aktive side et nyt navn',
  '_Replace' => '_Erstat',
  '_Replace...|Find and Replace' => '_Erstat...|Søg og erstat',
  '_Reset' => '_Nulstil',
  '_Restore Version...' => '_Genopret version...',
  '_Save Copy' => '_Gem kopi',
  '_Save a copy...' => '_Gem en kopi...',
  '_Save|Save page' => '_Gem|Gem siden',
  '_Screenshot...|Insert screenshot' => '_Skærmbillede...|Indsæt et skærmbillede',
  '_Search...|Search' => '_Søg...|Søg efter noget tekst i hele din notesblok',
  '_Search|' => '_Søg|Søg i din notesblok, eller lave søg-og-erstat søgninger',
  '_Send To...|Mail page' => 'Send _til...|Send siden som en e-mail',
  '_Statusbar|Show statusbar' => '_Statuslinje|Vis statuslinjen',
  '_TODO List...|Open TODO List' => 'O_pgaveliste...|Åben opgavelisten',
  '_Today' => '_I dag',
  '_Toolbar|Show toolbar' => '_Værktøjslinje|Vis værktøjslinjen',
  '_Tools|' => 'Vær_ktøjer|Muligheder for at redigere direkte i filerne Zim bruger samt optælling af ord',
  '_Underline|Underline' => '_Understreget|Understreget tekst',
  '_Undo|Undo' => '_Genskab|Fortryd den seneste ændring',
  '_Update links in this page' => 'Opdatér _henvisninger på denne side',
  '_Update {number} page linking here' => [
    'Opdatér {number} _side der henviser hertil',
    'Opdatér {number} _sider der henviser hertil'
  ],
  '_Verbatim|Verbatim' => '_Ordret|Tekst hvor alle bogstaver og tegn har samme bredde',
  '_Versions...|Versions' => 'Versioner...|Versioner',
  '_View|' => '_Vis|Indstillinger for hvilke objekter du ønsker vist i Zim samt kalender og opgaveliste',
  '_Word Count|Word count' => '_Tæl ord|Tæl antallet af ord, linjer og tegn',
  'other...' => 'Anden...',
  '{name}_(Copy)' => '{name}_(Kopi)',
  '{number} _Back link' => [
    '{number} _reference',
    '{number} _referencer'
  ],
  '{number} item total' => [
    '{number} opgave i alt',
    '{number} opgaver i alt'
  ]
};
