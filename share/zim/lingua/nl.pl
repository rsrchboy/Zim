# Translation of Zim - a desktop wiki.
# Copyright (C) 2007 Jaap Karssenberg, TRANSLATOR(S)
# This data is part of a free software application;
# you can redistribute it and/or modify it under the
# the same terms as Perl.
# 
# 
# 
# TRANSLATORS:
# Balaam's Miracle (nl)
# Bart (nl)
# Frits Salomons (nl)
# Jaap Karssenberg (nl)
# Mathijs (nl)
# cumulus007 (nl)
# 
# Project-Id-Version: Zim 0.23
# Report-Msgid-Bugs-To: 
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-08-14 10:09+0000
# Last-Translator: Bart <Unknown>
# Language-Team: 
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
  '%a %b %e %Y' => '%a %e %b %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Pagina verwijderen</b>

Weet u zeker dat u de pagina
\'{name}\' wilt verwijderen ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Versie beheer inschakelen</b>

Dit notitieboek maakt nog geen gebruik van versie beheer.
Wilt u versie beheer inschakelen?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Folder bestaat niet.</b>

De folder: {path}
bestaat niet, wilt u deze nu creëeren?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Pagina bestaat al</b>

De pagina \'{name}\'
bestaat al. Wilt u deze overschrijven?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Vorige versie herstellen?</b>

Wilt u de pagina: {page}
herstellen naar versie: {version} ?

Alle wijzigingen sinds de laatste opgeslagen versie zullen verloren gaan!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Kalender formaat overzetten naar 0.24?</b>

Dit notitieboek bevat paginas voor data met het formaat jjjj_mm_dd.
Sinds Zim 0.24 wordt standaard het format jjjj:mm:dd gebruikt,
dit resulteert in een aparte hierarchie per maand.

Wilt u dit notitieboek omzetten naar het nieuwe formaat ?
',
  'Add \'tearoff\' strips to the menus' => 'Zet afscheurstrips boven de menus',
  'Application show two text files side by side' => 'Applicatie om twee tekst files te vergelijken',
  'Application to compose email' => 'Programma om email te versturen',
  'Application to edit text files' => 'Programma om tekst files te bewerken',
  'Application to open directories' => 'Programma om mappen te openen',
  'Application to open urls' => 'Programma om internet locaties te openen',
  'Attach _File|Attach external file' => 'Bestand _Aanhechten|Bestand aanhechten',
  'Attach external files' => 'Externe bestanden mee kopiëren',
  'Auto-format entities' => 'Auto-format HTML entiteiten',
  'Auto-increment numbered lists' => 'Automatisch nummers invoegen in lijsten',
  'Auto-link CamelCase' => 'Auto-link CamelCase',
  'Auto-link files' => 'Auto-link bestanden',
  'Auto-save version on close' => 'Automatisch versie op slaan bij het afsluiten',
  'Auto-select words' => 'Woorden automatisch selecteren',
  'Automatically increment items in a numbered list' => 'Automatisch nummers invoegen in lijsten waar de regel mt een nummer begint',
  'Automatically link file names when you type' => 'Link bestandsnamen automatisch tijdens het typen',
  'Automaticly link CamelCase words when you type' => 'Link woorden in CamelCase automatisch tijdens het typen',
  'Automaticly select the current word when you toggle the format' => 'Woorden automatisch selecteren wanneer een ander formaat wordt gebruikt',
  'Bold' => 'Vet',
  'Calen_dar|Show calendar' => 'Kalen_der|Kalender tonen',
  'Calendar' => 'Calender',
  'Can not find application "bzr"' => 'Kan applicatie "bzr" niet vinden',
  'Can not find application "{name}"' => 'Kan applicatie "{name}" niet vinden',
  'Can not save a version without comment' => 'Kan geen versie opslaan zonder omschrijving',
  'Can not save to page: {name}' => 'Kan niet opslaan naar: {name}',
  'Can\'t find {url}' => 'Kan {url} niet vinden',
  'Cha_nge' => '_Wijzigen',
  'Chars' => 'Letters',
  'Check _spelling|Spell check' => '_Spelling controlleren|Spelling controlleren',
  'Check checkbox lists recursive' => 'Markeer checkbox lists recursief',
  'Checking a checkbox list item will also check any sub-items' => 'Wanneer u een checkbox markeert worden ook alle sub-items gemarkeerd',
  'Choose {app_type}' => 'Kies {app_type}',
  'Co_mpare Page...' => '_Vergelijk pagina...',
  'Command' => 'Programma',
  'Comment' => 'Beschrijving',
  'Compare this version with' => 'Deze versie vergelijken met',
  'Copy Email Address' => 'Email Adres Kopiëren',
  'Copy Location|Copy location' => 'Locatie kopieren|Locatie kopieren',
  'Copy _Link' => '_Link Kopiëren',
  'Could not delete page: {name}' => 'Kan pagina niet verwijderen: {name}',
  'Could not get annotated source for page {page}' => 'Kan aantekeningen niet vinden voor pagina: {page}',
  'Could not get changes for page: {page}' => 'Kan geen veranderingen vinden voor pagina: {page}',
  'Could not get changes for this notebook' => 'Kan veranderingen voor dit notitieboek niet vinden',
  'Could not get file for page: {page}' => 'Kan geen bestand vinden voor pagina: {page}',
  'Could not get versions to compare' => 'Kan de versies om te vergelijken niet vinden',
  'Could not initialize version control' => 'Kan versie beheer niet inschakelen',
  'Could not load page: {name}' => 'Kan pagina niet laden: {name}',
  'Could not rename {from} to {to}' => 'Kan {from} niet hernoemen naar {to}',
  'Could not save page' => 'Kan de pagina niet opslaan',
  'Could not save version' => 'Versie kan niet opgeslagen worden',
  'Creating a new link directly opens the page' => 'Open de nieuwe pagina direct na het creeëren van de link',
  'Creation Date' => 'Aanmaakdatum',
  'Cu_t|Cut' => '_Knippen|Knippen',
  'Current' => 'Huidige',
  'Customise' => 'Wijzigen',
  'Date' => 'Datum',
  'Default notebook' => 'Standaard notitieboek',
  'Details' => 'Details',
  'Diff Editor' => 'Diff applicatie',
  'Diff editor' => 'Diff applicatie',
  'Directory' => 'Map',
  'Document Root' => 'Bestanden map',
  'E_quation...|Insert equation' => 'Vergelijking...|Vergelijking invoegen',
  'E_xport...|Export' => 'E_xporteren...|Exporteren',
  'E_xternal Link...|Insert external link' => 'E_xterne Link...|Externe link invoegen',
  'Edit Image' => 'Afbeelding Bewerken',
  'Edit Link' => 'Link Bewerken',
  'Edit Query' => 'Zoekterm bewerken',
  'Edit _Source|Open source' => 'Brontekst Bewerken|Brontekst bewerken',
  'Edit notebook' => 'Notitieboek wijzigen',
  'Edit text files "wiki style"' => 'Bewerk tekstbestanden ""wiki style"\'',
  'Editing' => 'Bewerken',
  'Email client' => 'Email programma',
  'Enabled' => 'In gebruik',
  'Equation Editor' => 'Formule Bewerken',
  'Equation Editor Log' => 'Formule Log',
  'Expand side pane' => 'Zij-paneel uitklappen',
  'Export page' => 'Pagina Exporteren',
  'Exporting page {number}' => 'Pagina {number} aan het exporteren',
  'Failed to cleanup SVN working copy.' => 'Opschonen van SVN copie mislukt.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Laden van de SVN plugin mislukt,
heeft u de subversion applicatie geinstalleerd?',
  'Failed to load plugin: {name}' => 'Kan plugin niet laden: {name}',
  'Failed update working copy.' => 'Update uit archief mislukt',
  'File browser' => 'Bestandsbrowser',
  'File is not a text file: {file}' => 'Bestand is geen tekst bestand: {file}',
  'Filter' => 'Filter',
  'Find' => 'Zoek',
  'Find Ne_xt|Find next' => 'Vindt _Volgende|Vindt volgende',
  'Find Pre_vious|Find previous' => 'Vindt Vor_ige|Vindt vorige',
  'Find and Replace' => 'Zoeken en vervange',
  'Find what' => 'Zoek deze',
  'Follow new link' => 'Nieuwe links volgen',
  'For_mat|' => '_Opmaak',
  'Format' => 'Opmaak',
  'General' => 'Algemeen',
  'Go to "{link}"' => 'Ga naar "{link}"',
  'H_idden|.' => '_Verbergen',
  'Head _1|Heading 1' => 'Kop _1|Kop 1',
  'Head _2|Heading 2' => 'Kop _2|Kop 2',
  'Head _3|Heading 3' => 'Kop _3|Kop 3',
  'Head _4|Heading 4' => 'Kop _4|Kop 4',
  'Head _5|Heading 5' => 'Kop _5|Kop 5',
  'Head1' => 'Kop1',
  'Head2' => 'Kop2',
  'Head3' => 'Kop3',
  'Head4' => 'Kop4',
  'Head5' => 'Kop5',
  'Height' => 'Hoogte',
  'Home Page' => 'Start Pagina',
  'Icon' => 'Pictogram',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Laat alle open checkboxes zien',
  'Index page' => 'Index pagina',
  'Initial version' => 'Eerste versie',
  'Insert Date' => 'Datum invoegen',
  'Insert Image' => 'Afbeelding invoegen',
  'Insert Link' => 'Link invoegen',
  'Insert from file' => 'Uit bestand invoegen',
  'Interface' => 'Bediening',
  'Italic' => 'Schuingedrukt',
  'Jump to' => 'Ga naar',
  'Jump to Page' => 'Ga naar pagina',
  'Lines' => 'Regels',
  'Links to' => 'Link naar',
  'Match c_ase' => 'Hoofdletter gevoelig',
  'Media' => 'Bestanden',
  'Modification Date' => 'Wijzigingsdatum',
  'Name' => 'Naam',
  'New notebook' => 'Nieuw notitieboek',
  'New page' => 'Nieuwe pagina',
  'No such directory: {name}' => 'Map bestaat niet: {name}',
  'No such file or directory: {name}' => 'Bestand of folder bestaat niet: {name}',
  'No such file: {file}' => 'Bestand niet gevonden: {file}',
  'No such notebook: {name}' => 'Notitieboek niet gevonden: {name}',
  'No such page: {page}' => 'Pagina bestaat niet: {page}',
  'No such plugin: {name}' => 'Plugin niet gevonden: {name}',
  'Normal' => 'Normaal',
  'Not Now' => 'Niet Nu',
  'Not a valid page name: {name}' => 'Ongeldige pagina naam: {name}',
  'Not an url: {url}' => 'Geen geldige web locatie: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Door te linken naar een niet-bestaande pagina
kunt u ook een nieuwe pagina aanmaken.',
  'Notebook' => 'Notitieboek',
  'Notebooks' => 'Notitieboeken',
  'Open Document _Folder|Open document folder' => 'Open Documenten _Folder|Open documenten folder',
  'Open Document _Root|Open document root' => 'Open Documenten _Root|Open documenten root',
  'Open _Directory' => 'Open _Map',
  'Open notebook' => 'Notitieboek openen',
  'Other...' => 'Overige...',
  'Output' => 'Formaat',
  'Output dir' => 'Map',
  'P_athbar type|' => 'Locatiebalk',
  'Page' => 'Pagina',
  'Page Editable|Page editable' => 'Pagina te wijzigen|Pagina te wijzigen',
  'Page name' => 'Pagina naam',
  'Pages' => 'Pagina\'s',
  'Password' => 'Wachtwoord',
  'Please enter a comment for this version' => 'Geef een korte omschrijving voor deze versie',
  'Please enter a name to save a copy of page: {page}' => 'Geef een naam op om een kopie op te slaan van: {page}',
  'Please enter a {app_type}' => 'Geef een commando om een {app_type} te starten',
  'Please give a page first' => 'Geef eerst een pagina op',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'U dient een map aan te geven om uw notities op te slaan.
Voor een nieuw notitieboek dien dit een lege map te zijn.
Bijvoorbeeld een map "Notes" in uw persoonlijke map.',
  'Please provide the password for
{path}' => 'Geef wachtwoord voor:
{path}',
  'Please select a notebook first' => 'Selecteer eerst een notitieboek',
  'Please select a version first' => 'Geef eerst een versie op',
  'Plugin already loaded: {name}' => 'Plugin is al geladen: {name}',
  'Plugins' => 'Plugins',
  'Pr_eferences|Preferences dialog' => '_Voorkeuren|Voorkeuren wijzigen',
  'Preferences' => 'Voorkeuren',
  'Prefix document root' => 'Voorvoegsel documentenroot',
  'Print to Browser|Print to browser' => 'Print naar Browser|Print naar browser',
  'Prio' => 'Prio',
  'Proper_ties|Properties dialog' => 'Ei_genschappen...|Eigenschappen',
  'Properties' => 'Eigenschappen',
  'Rank' => 'Rang',
  'Re-build Index|Rebuild index' => 'Index Aanmaken|Index aanmaken',
  'Recursive' => 'Recursief',
  'Rename page' => 'Pagina hernoemen',
  'Rename to' => 'Hernoemen naar',
  'Replace _all' => '_Alles vervangen',
  'Replace with' => 'Vervang door',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN cleanup|Cleanup SVN archief kopie',
  'SVN commit|Commit notebook to SVN repository' => 'SVN commit|Commit notitieboek naar het SVN archief',
  'SVN update|Update notebook from SVN repository' => 'SVN update|Update notitieboek uit het SVN archief',
  'S_ave Version...|Save Version' => 'V_ersie Opslaan...|Versie opslaan',
  'Save Copy' => 'Kopie Opslaan',
  'Save version' => 'Versie opslaan',
  'Scanning tree ...' => 'Index aan het opbouwen ...',
  'Search' => 'Zoeken',
  'Search _Backlinks...|Search Back links' => 'Zoek Verwijzingen|Zoek verwijzingen',
  'Select File' => 'Bestand selecteren',
  'Select Folder' => 'Selecteer Map',
  'Send To...' => 'Zenden naar...',
  'Show cursor for read-only' => 'Laat cursor zien in read-only mode',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Laat de cursor zien ook wanneer de pagina niet gewijzigd kan worden.Dit is nuttig voor navigatie met het toetsenbord',
  'Slow file system' => 'Langzaam bestands systeen',
  'Source' => 'Bron',
  'Source Format' => 'Bronformaat',
  'Start the side pane with the whole tree expanded.' => 'Start met alle items in het zij-paneel uitgeklapt.',
  'Stri_ke|Strike' => '_Doorhalen|Doorhalen',
  'Strike' => 'Doorgehaald',
  'TODO List' => 'Taken lijst',
  'Task' => 'Taak',
  'Tearoff menus' => 'Afscheurbare menus',
  'Template' => 'Template',
  'Text' => 'Tekst',
  'Text Editor' => 'Tekst Editor',
  'Text _From File...|Insert text from file' => 'Tekst Uit _Bestand|Tekst uit bestand invoegen',
  'Text editor' => 'Tekst verwerker',
  'The equation failed to compile. Do you want to save anyway?' => 'De formule kan niet worden weergegeven. Wilt u toch opslaan?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'De formule voor het bestand: {path}
mist. Kan de formule niet wijzigen.',
  'This notebook does not have a document root' => 'Dit notitieboek heeft geen documentenroot.',
  'This page does not exist
404' => 'Deze pagina bestaat niet
404',
  'This page does not have a document folder' => 'Deze pagina heeft geen documenten folder',
  'This page does not have a source' => 'Deze pagina heeft geen bron tekst',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Deze pagina is veranderd in het archief.
U dient uw kopie to updaten (Tools -> SVN update).',
  'To_day|Today' => 'Van_daag|Vandaag',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Markeer checkbox "V"|Markeer checkbox "V"',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Markeer checkbox "V"|Markeer checkbox "V"',
  'Underline' => 'Onderstreept',
  'Updating links' => 'Links aanpassen',
  'Updating links in {name}' => 'Links aan het aanpassen in {name}',
  'Updating..' => 'Aanpassen..',
  'Use "Backspace" to un-indent' => 'Gebruik "Backspace" om inspringen ongedaan te maken',
  'Use "Ctrl-Space" to switch focus' => 'Gebruik "Ctrl-Spatie" om focus te switchen',
  'Use "Enter" to follow links' => 'Gebruik "Enter" om links te volgen',
  'Use autoformatting to type special characters' => 'Zet HTML entiteiten automatisch om in utf8 karakters',
  'Use custom font' => 'Wijzig lettertype',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Gebruik de "Backspace" toets om het inspringen van een aantal regels ongedaan te maken. (Gelijk aan "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Gebruik de "Ctrl-Spatie" toetscombinatie om de focus te verspringen tussen de tekst en het zij-paneel. Als deze optie uitstaat, kunt u nog steeds"Alt-Spatie" gebruiken.',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Gebruik de "Enter" toets om links te volgen. Wanneer deze optie uit staatkunt u nog steeds "Alt-Enter" gebruiken voor navigatie"',
  'User' => 'Gebruiker',
  'User name' => 'Gebruiker naam',
  'Verbatim' => 'Letterlijk',
  'Versions' => 'Versies',
  'View _Annotated...' => 'Bekijk _Aantekeningen...',
  'View _Log' => 'Bekijk _Log',
  'Web browser' => 'Webbrowser',
  'Whole _word' => 'Hele woord',
  'Width' => 'Breedte',
  'Word Count' => 'Woorden Tellen',
  'Words' => 'Woorden',
  'You can add rules to your search query below' => 'U kunt hieronder regels toevoegen aan de zoekterm',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'U kunt kiezen tussen de <b>Bazaar</b> en <b>Subversion</b> Versie Beheer Systemen.
Klik op \'hulp\' voor meer informatie over de systeem eisen.',
  'You have no {app_type} configured' => 'Geen {app_type} ingesteld',
  'You need to restart the application
for plugin changes to take effect.' => 'U dient dit programma opnieuw te starten
voordat nieuwe plugins geladen worden.',
  'Your name; this can be used in export templates' => 'Uw naam; dit kan worden gebruikt bij het uitdraaien van data',
  'Zim Desktop Wiki' => 'Zim Desktop Wiki',
  '_About|About' => 'In_fo|Info',
  '_All' => '_Alle',
  '_Back|Go page back' => '_Terug|Ga pagina terug',
  '_Bold|Bold' => '_Vet|Vet',
  '_Browse...' => '_Bladeren...',
  '_Bugs|Bugs' => '_Bugs|Bugs',
  '_Child|Go to child page' => 'Om_laag|Ga pagina omlaag',
  '_Close|Close window' => 'Sl_uiten|Venster sluiten',
  '_Contents|Help contents' => 'I_nhoud|Hulp inhoud',
  '_Copy Page...|Copy page' => 'Pagina _Kopiëren|Pagina kopiëren',
  '_Copy|Copy' => 'K_opiëren|Kopiëren',
  '_Date and Time...|Insert date' => '_Datum en Tijd|Datum en tijd invoegen',
  '_Delete Page|Delete page' => 'Pagina Verwijderen|Pagina verwijderen',
  '_Delete|Delete' => '_Wissen|Wissen',
  '_Discard changes' => 'Wijzigingen _vergeten',
  '_Edit' => '_Bewerken',
  '_Edit Equation' => 'Formule Be_werken',
  '_Edit Link' => 'Link be_werken',
  '_Edit Link...|Edit link' => 'Link _Wijzigen|Link wijzigen',
  '_Edit|' => 'Be_werken',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_Bestand',
  '_Filter' => '_Filteren',
  '_Find...|Find' => '_Vinden...|Vinden',
  '_Forward|Go page forward' => '_Vooruit|Ga pagina vooruit',
  '_Go|' => '_Ga Naar',
  '_Help|' => '_Hulp',
  '_History|.' => '_Geschiedenis',
  '_Home|Go home' => '_Start|Ga naar start',
  '_Image...|Insert image' => '_Afbeelding...|Afbeelding invoegen',
  '_Index|Show index' => '_Index|Index tonen',
  '_Insert' => '_Invoegen',
  '_Insert|' => '_Invoegen',
  '_Italic|Italic' => '_Schuingedrukt|Schuingedrukt',
  '_Jump To...|Jump to page' => 'Pagina...|Ga naar pagina',
  '_Keybindings|Key bindings' => '_Toetsen|Toetsen',
  '_Link' => '_Link',
  '_Link to date' => '_Link datum',
  '_Link...|Insert link' => '_Link...|Link invoegen',
  '_Link|Link' => '_link|Link',
  '_Namespace|.' => '_Hierarchie',
  '_New Page|New page' => '_Nieuwe Pagina|Nieuwe pagina',
  '_Next' => 'V_olgende',
  '_Next in index|Go to next page' => 'Vo_lgende in de index|Ga naar de volgende pagina',
  '_Normal|Normal' => '_Normaal|Normaal',
  '_Notebook Changes...' => 'Veranderingen _Notitieboek...',
  '_Open Another Notebook...|Open notebook' => '_Open ander notitieboek...|Open notitieboek',
  '_Open link' => '_Open link',
  '_Overwrite' => '_Overschrijven',
  '_Page' => '_Pagina',
  '_Page Changes...' => 'Veranderingen _Pagina...',
  '_Parent|Go to parent page' => '_Omhoog|Ga pagina omhoog',
  '_Paste|Paste' => '_Plakken|Plakken',
  '_Preview' => '_Tonen',
  '_Previous' => 'Vor_ige',
  '_Previous in index|Go to previous page' => 'Vor_ige in de index|Ga naar de vorige pagina',
  '_Properties' => '_Eigenschappen',
  '_Quit|Quit' => '_Afsluiten|Afsluiten',
  '_Recent pages|.' => '_Recente paginas',
  '_Redo|Redo' => 'O_pnieuw|Opnieuw',
  '_Reload|Reload page' => '_Herladen|Pagina herladen',
  '_Rename' => '_Hernoemen',
  '_Rename Page...|Rename page' => 'Pagina _hernoemen...|pagina hernoemen',
  '_Replace' => '_Vervangen',
  '_Replace...|Find and Replace' => '_Vervangen...|Zoeken en vervangen',
  '_Reset' => '_Herstellen',
  '_Restore Version...' => 'Versie _Herstellen...',
  '_Save Copy' => 'Kopie _Opslaan',
  '_Save a copy...' => '_Kopie opslaan...',
  '_Save|Save page' => '_Opslaan|Pagina opslaan',
  '_Screenshot...|Insert screenshot' => '_Schermafdruk...|Schermafdruk invoegen',
  '_Search...|Search' => '_Zoeken...|zoeken',
  '_Search|' => '_Zoeken',
  '_Send To...|Mail page' => '_Versturen...|Pagina versturen',
  '_Statusbar|Show statusbar' => '_Statusbalk|Statusbalk tonen',
  '_TODO List...|Open TODO List' => '_Taken lijst...|Open taken lijst',
  '_Today' => '_Vandaag',
  '_Toolbar|Show toolbar' => '_Werkbalk|Werkbalk tonen',
  '_Tools|' => 'E_xtra',
  '_Underline|Underline' => '_Onderstrepen|Onderstrepen',
  '_Undo|Undo' => '_Ongedaan maken|Ongedaan maken',
  '_Update links in this page' => 'Links in deze pagina _aanpassen',
  '_Update {number} page linking here' => [
    '{number} link naar deze pagina aanpassen',
    '{number} links naar deze pagina aanpassen'
  ],
  '_Verbatim|Verbatim' => '_Letterlijk|Letterlijk',
  '_Versions...|Versions' => '_Versies...|Versies',
  '_View|' => 'Beel_d',
  '_Word Count|Word count' => '_Woorden Tellen|Woorden tellen',
  'other...' => 'anders...',
  '{name}_(Copy)' => '{name}_(Kopie)',
  '{number} _Back link' => [
    '{number} _Referentie',
    '{number} _Referenties'
  ],
  '{number} item total' => [
    '{number} taak',
    '{number} taken'
  ]
};
