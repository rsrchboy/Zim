# Italian translation for zim
# Copyright (c) 2007 Rosetta Contributors and Canonical Ltd 2007
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2007.
# 
# 
# TRANSLATORS:
# Davide Truffa (it)
# Jacopo Moronato (it)
# Matteo Ferrabone (it)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-12-13 15:25+0000
# Last-Translator: Davide Truffa <davide@catoblepa.org>
# Language-Team: Italian <it@li.org>
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
page \'{name}\' ?' => '<b>Elimina pagina</b>

Sei sicuro di voler eliminare
la pagina \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Attiva il Controllo di Versione</b>

Il controllo di versione non è attualmente in uso per questo blocco note.
Vuoi attivarlo?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>La cartella non esiste.</b>

La cartella {path}
non esiste, vuoi crearla ora?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>La pagina è già stata creata</b>

La pagina \'{name}\'
esiste già.
Vuoi sovrascriverla?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Aggiorna le pagine del calendario al formato 0.24?</b>

Questo notebook contiene date che usano il formato aaaa_mm_gg. 
Dalla versione 0.24 di Zim viene usato come default il formato aaaa:mm:gg, creando
namespaces per ogni mese. 

Vuoi aggiornare questo notebook al nuovo layout?
',
  'Add \'tearoff\' strips to the menus' => 'Aggiungi ancora di sganciamento ai menu',
  'Application show two text files side by side' => '',
  'Application to compose email' => 'Applicazione per comporre email',
  'Application to edit text files' => 'Applicazioni per editare testi',
  'Application to open directories' => 'Applicazione per aprire directory',
  'Application to open urls' => 'Applicazione per aprire url',
  'Attach _File|Attach external file' => 'Allega _File|Allega un file esterno',
  'Attach external files' => 'Allega files esterni',
  'Auto-format entities' => 'Auto-formatta entità',
  'Auto-increment numbered lists' => 'Auto-incrementa liste numerate',
  'Auto-link CamelCase' => 'Auto-linka Camelcase',
  'Auto-link files' => 'Auto-linka file',
  'Auto-save version on close' => 'Salva automaticamente la versione in chiusura',
  'Auto-select words' => 'Auto-seleziona parole',
  'Automatically increment items in a numbered list' => 'Incrementa automaticamente gli oggetti in una lista numerata',
  'Automatically link file names when you type' => 'Collega automaticamente nomi dei file quando scrivi',
  'Automaticly link CamelCase words when you type' => 'Collega automaticamente parole CamelCase quando scrivi',
  'Automaticly select the current word when you toggle the format' => 'Seleziona automaticamente la parola corrente quando cambi formato',
  'Bold' => 'Grassetto',
  'Calen_dar|Show calendar' => 'Calen_dario|Mostra il calendario',
  'Calendar' => 'Calendario',
  'Can not find application "bzr"' => 'Impossibile trovare l\'applicazione "bzr"',
  'Can not find application "{name}"' => '',
  'Can not save a version without comment' => 'Impossibile salvare una versione senza un commento',
  'Can not save to page: {name}' => 'Impossibile salvare la pagina {name}',
  'Can\'t find {url}' => 'Impossibile trovare {url}',
  'Cha_nge' => '_Modifica',
  'Chars' => 'Caratteri',
  'Check _spelling|Spell check' => 'Controllo Ortografico|Controllo ortografico',
  'Check checkbox lists recursive' => '',
  'Checking a checkbox list item will also check any sub-items' => '',
  'Choose {app_type}' => 'Scegli {app_type}',
  'Co_mpare Page...' => 'Co_nfronta Pagina...',
  'Command' => 'Comando',
  'Comment' => '',
  'Compare this version with' => 'Confronta questa versione con',
  'Copy Email Address' => 'Copia indirizzo di posta elettronica',
  'Copy Location|Copy location' => 'Copia Posizione|Copia posizione della pagina',
  'Copy _Link' => 'Copia _Collegamento',
  'Could not delete page: {name}' => 'Impossibile eliminare la pagina {name}',
  'Could not get annotated source for page {page}' => '',
  'Could not get changes for page: {page}' => 'Impossibile ottenere i cambiamenti per la pagina: {page}',
  'Could not get changes for this notebook' => '',
  'Could not get file for page: {page}' => 'Impossibile ottenere il file per la pagina: {page}',
  'Could not get versions to compare' => 'Impossibile ottenere le versioni da confrontare',
  'Could not initialize version control' => 'Impossibile inizializzare il controllo di versione',
  'Could not load page: {name}' => 'Impossibile caricare la pagina {name}',
  'Could not rename {from} to {to}' => 'Impossibile rinominare {from} con {to}',
  'Could not save page' => 'Impossibile salvare la pagina',
  'Could not save version' => 'Impossibile salvare versione',
  'Creating a new link directly opens the page' => 'Creando un nuovo collegamento verrà aperta direttamente la pagina',
  'Creation Date' => 'Data di Creazione',
  'Cu_t|Cut' => '_Taglia|Taglia',
  'Current' => 'Corrente',
  'Customise' => 'Personalizza',
  'Date' => 'Data',
  'Default notebook' => 'Blocco note di Default',
  'Details' => 'Dettagli',
  'Diff Editor' => '',
  'Diff editor' => '',
  'Directory' => 'Cartella',
  'Document Root' => 'Radice Documento',
  'E_quation...|Insert equation' => 'E_quazione...|Inserisci un\'equazione',
  'E_xport...|Export' => '_Esporta...|Esporta',
  'E_xternal Link...|Insert external link' => 'Link _Esterno...|Inserisci un link esterno',
  'Edit Image' => 'Modifica Immagine',
  'Edit Link' => 'Modifica Collegamento',
  'Edit Query' => 'Modifica ricerca',
  'Edit _Source|Open source' => 'Modifica _Sorgente|Apri sorgente',
  'Edit notebook' => 'Modifica notebook',
  'Edit text files "wiki style"' => 'Crea file di testo in stile "Wiki"',
  'Editing' => 'Editing',
  'Email client' => 'Client mail',
  'Enabled' => 'Attivo',
  'Equation Editor' => 'Editor Equazioni',
  'Equation Editor Log' => 'Log Editor Equazioni',
  'Expand side pane' => 'Espandi pannello laterale',
  'Export page' => 'Esporta pagina',
  'Exporting page {number}' => 'Esportazione pagina {number}',
  'Failed to cleanup SVN working copy.' => '',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Impossibile caricare il plugin SVN,
le utility di subversion sono installate?',
  'Failed to load plugin: {name}' => 'Impossibile caricare il Plugin {name}',
  'Failed update working copy.' => '',
  'File browser' => 'File browser',
  'File is not a text file: {file}' => '{file} non è un file di testo',
  'Filter' => 'Filtro',
  'Find' => 'Trova',
  'Find Ne_xt|Find next' => 'Cerca _Successivo|Cerca successivo',
  'Find Pre_vious|Find previous' => 'Cerca _Precedente|Cerca precedente',
  'Find and Replace' => 'Cerca e Sostituisci',
  'Find what' => 'Cerca qualcosa',
  'Follow new link' => 'Segui nuovo collegamento',
  'For_mat|' => 'For_mato|',
  'Format' => 'Formato',
  'General' => 'Generale',
  'Go to "{link}"' => 'Vai a "{link}"',
  'H_idden|.' => '_Nascosto|',
  'Head _1|Heading 1' => 'Titolo _1| Titolo 1',
  'Head _2|Heading 2' => 'Titolo _2|Titolo 2',
  'Head _3|Heading 3' => 'Titolo _3|Titolo 3',
  'Head _4|Heading 4' => 'Titolo _4|Titolo 4',
  'Head _5|Heading 5' => 'Titolo _5|Titolo 5',
  'Head1' => 'Titolo1',
  'Head2' => 'Titolo2',
  'Head3' => 'Titolo3',
  'Head4' => 'Titolo4',
  'Head5' => 'Titolo5',
  'Height' => 'Altezza',
  'Home Page' => 'Home Page',
  'Icon' => 'Icona',
  'Id' => 'Id',
  'Include all open checkboxes' => '',
  'Index page' => 'Indice',
  'Initial version' => 'Versione iniziale',
  'Insert Date' => 'Inserisci Data',
  'Insert Image' => 'Inserisci Immagine',
  'Insert Link' => 'Inserisci Collegamento',
  'Insert from file' => 'Inserisci da file',
  'Interface' => 'Interfaccia',
  'Italic' => 'Corsivo',
  'Jump to' => 'Salta a',
  'Jump to Page' => 'Salta a Pagina',
  'Lines' => 'Righe',
  'Links to' => 'Collega a',
  'Match c_ase' => 'M_aiuscole',
  'Media' => 'Media',
  'Modification Date' => 'Data di Modifica',
  'Name' => 'Nome',
  'New notebook' => 'Nuova repository',
  'New page' => 'Nuova pagina',
  'No such directory: {name}' => 'Nessuna directory: {name}',
  'No such file or directory: {name}' => 'Nessun file o directory: {name}',
  'No such file: {file}' => '{file} non esiste',
  'No such notebook: {name}' => 'Nessun contenitore: {name}',
  'No such page: {page}' => 'Nessuna pagina:{page}',
  'No such plugin: {name}' => 'Plugin {name} non trovato',
  'Normal' => 'Normale',
  'Not Now' => 'Non ora',
  'Not a valid page name: {name}' => '{name} non è un nome di pagina valido',
  'Not an url: {url}' => '{url} non è un Url valido',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Attenzione, creare un collegamento ad una pagina inesistente
comporta la creazione automatica di una nuova pagina.',
  'Notebook' => 'Repository',
  'Notebooks' => 'Blocchi note',
  'Open Document _Folder|Open document folder' => 'Apri _Cartella Documento|Apri cartella in cui è contenuto il documento',
  'Open Document _Root|Open document root' => 'Apri _Radice Documento|Apri la pagina principale del documento',
  'Open _Directory' => 'Apri _Directory',
  'Open notebook' => 'Apri repository',
  'Other...' => 'Altro...',
  'Output' => 'Risultato',
  'Output dir' => 'Cartella di destinazione',
  'P_athbar type|' => '_Pathbar|',
  'Page' => 'Pagina',
  'Page Editable|Page editable' => 'Pagina Modificabile|Pagina modificabile',
  'Page name' => 'Nome della pagina',
  'Pages' => 'Pagine',
  'Password' => '',
  'Please enter a comment for this version' => 'Inserisci un commento per questa versione',
  'Please enter a name to save a copy of page: {page}' => 'Inserire un nome per salvare una copia della pagina: {page}',
  'Please enter a {app_type}' => 'Inserisci un {app_type}',
  'Please give a page first' => 'Specificare la pagina',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Per favore specifica almeno una directory in cui salvare le tue pagine.
Se si tratta di un nuovo notebook, dovresti specificare una directory vuota. 
Per esempio una directory "Note" nell tua home directory.',
  'Please provide the password for
{path}' => '',
  'Please select a notebook first' => 'Prima scegliere un blocco note',
  'Please select a version first' => 'Selezionare una versione',
  'Plugin already loaded: {name}' => 'Plugin {name} già attivo',
  'Plugins' => 'Moduli',
  'Pr_eferences|Preferences dialog' => 'Pr_eferenze|Preferenze',
  'Preferences' => 'Preferenze',
  'Prefix document root' => 'Aggiungi prefisso alla pagina principale del documento',
  'Print to Browser|Print to browser' => 'Stampa su Browser|Stampa su browser',
  'Prio' => 'Priorità',
  'Proper_ties|Properties dialog' => 'Proprie_tà|Proprietà della pagina',
  'Properties' => 'Proprietà',
  'Rank' => 'Rank',
  'Re-build Index|Rebuild index' => 'Ricostruisci Indice|Ricostruisci l\'indice delle pagine',
  'Recursive' => 'Ricorsivo',
  'Rename page' => 'Rinomina pagina',
  'Rename to' => 'Rinomina come',
  'Replace _all' => 'Sostituisci _tutto',
  'Replace with' => 'Sostituisci con',
  'SVN cleanup|Cleanup SVN working copy' => '',
  'SVN commit|Commit notebook to SVN repository' => '',
  'SVN update|Update notebook from SVN repository' => '',
  'S_ave Version...|Save Version' => 'S_alva Versione...|Salva Versione',
  'Save Copy' => 'Salva Copia',
  'Save version' => 'Salva versione',
  'Scanning tree ...' => 'Scansione albero...',
  'Search' => 'Cerca',
  'Search _Backlinks...|Search Back links' => 'Cerca _Backlinks...|Cerca Backlinks',
  'Select File' => 'Seleziona File',
  'Select Folder' => 'Seleziona Cartella',
  'Send To...' => 'Invia a...',
  'Show cursor for read-only' => 'Mostra cursore per sola lettura',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Mostra il cursore anche se non puoi modificare la pagina. Questo è utile per il browsing basato sulla tastiera.',
  'Slow file system' => 'File System remoto',
  'Source' => 'Fonte',
  'Source Format' => 'Formato Sorgente',
  'Start the side pane with the whole tree expanded.' => 'Avvia il pannello laterale con l\'intero albero espanso',
  'Stri_ke|Strike' => '_Barrato|Barrato',
  'Strike' => 'Barrato',
  'TODO List' => 'TODO List',
  'Task' => 'Obiettivo',
  'Tearoff menus' => 'Sgancia menu',
  'Template' => 'Modello',
  'Text' => 'Testo',
  'Text Editor' => 'Editor di Testo',
  'Text _From File...|Insert text from file' => '_Testo da File...|Inserisci del testo da file',
  'Text editor' => 'Editor di testi',
  'The equation failed to compile. Do you want to save anyway?' => 'L\'equazione non è riuscita a compilare. Vuoi salvare comunque?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'L\'equazione per l\'immagine {path}
non è stata trovata. Impossibile modificare l\'equazione.',
  'This notebook does not have a document root' => 'Questo notebook non ha un documento radice',
  'This page does not exist
404' => 'La pagina non esiste
404',
  'This page does not have a document folder' => 'Questa pagina non ha una cartella che la contiene',
  'This page does not have a source' => 'Questa pagina non ha una sorgente',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => '',
  'To_day|Today' => '_Oggi|Crea una pagina con la data odierna',
  'Toggle Chechbox \'V\'|Toggle checkbox' => '',
  'Toggle Chechbox \'X\'|Toggle checkbox' => '',
  'Underline' => 'Sottolineato',
  'Updating links' => 'Aggiornamento link',
  'Updating links in {name}' => 'Aggiornamento link in {name}',
  'Updating..' => 'Aggiornamento..',
  'Use "Backspace" to un-indent' => 'Utilizza "Backspace" per eliminare l\'indentazione',
  'Use "Ctrl-Space" to switch focus' => 'Utilizza "Ctrl+Spazio" per cambiare focus',
  'Use "Enter" to follow links' => 'Utilizza "Invio" per seguire i link',
  'Use autoformatting to type special characters' => 'Utilizza l\'auto-formattazione per scrivere caratteri speciali',
  'Use custom font' => 'Utilizza font personalizzata',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Utilizza il tasto "Backspace" per eliminare l\'indentazione dalle liste (uguale a "Shift+Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Utilizza il tasto "Ctrl+Spazio" per cambiare focus tra testo e pannello laterale. Se disabilitato, puoi ancora usare "Alt+Spazio".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Utilizza il tasto "Invio" per seguire i link. Se disabilitato, puoi ancora usare "Alt+Invio"',
  'User' => 'Utente',
  'User name' => 'Nome utente',
  'Verbatim' => 'Verbatim',
  'Versions' => 'Versioni',
  'View _Annotated...' => '',
  'View _Log' => 'Mostra _Log',
  'Web browser' => 'Browser Web',
  'Whole _word' => 'Intera _parola',
  'Width' => 'Larghezza',
  'Word Count' => 'Conta Parole',
  'Words' => 'Parole',
  'You can add rules to your search query below' => 'Puoi aggiungere regole alla tua ricerca qui sotto',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => '',
  'You have no {app_type} configured' => 'Non hai {app_type} configurati',
  'You need to restart the application
for plugin changes to take effect.' => 'Riavvia l\'applicazione
affinchè i cambiamenti abbiano effetto.',
  'Your name; this can be used in export templates' => 'Il tuo nome; può essere utilizzato in templates da esportare',
  'Zim Desktop Wiki' => 'Zim Desktop Wiki',
  '_About|About' => '_Informazioni|Informazioni su Zim Desktop Wiki',
  '_All' => '_Tutto',
  '_Back|Go page back' => '_Indietro|Indietro',
  '_Bold|Bold' => '_Grassetto|Grassetto',
  '_Browse...' => '_Sfoglia...',
  '_Bugs|Bugs' => '_Bug|Segnalazione bug',
  '_Child|Go to child page' => '_Giù|Vai alla pagina figlia',
  '_Close|Close window' => '_Chiudi|Chiudi la finestra',
  '_Contents|Help contents' => '_Sommario|Guida di Zim Desktop Wiki',
  '_Copy Page...|Copy page' => '_Copia Pagina...|Copia Pagina',
  '_Copy|Copy' => '_Copia|Copia',
  '_Date and Time...|Insert date' => '_Data e Ora...|Inserisci la data e l\'ora',
  '_Delete Page|Delete page' => '_Elimina Pagina|Elimina la pagina',
  '_Delete|Delete' => '_Elimina|Elimina',
  '_Discard changes' => '_Scarta modifiche',
  '_Edit' => '',
  '_Edit Equation' => '_Modifica Equazione',
  '_Edit Link' => '_Modifica Link',
  '_Edit Link...|Edit link' => '_Modifica Collegamento...|Modifica il collegamento',
  '_Edit|' => '_Modifica|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_File|',
  '_Filter' => '_Filtro',
  '_Find...|Find' => '_Cerca...|Cerca',
  '_Forward|Go page forward' => '_Avanti|Avanti',
  '_Go|' => '_Vai|',
  '_Help|' => '_Aiuto|',
  '_History|.' => '_Cronologia|',
  '_Home|Go home' => '_Home|Vai alla homepage',
  '_Image...|Insert image' => '_Immagine...|Inserisci una immagine',
  '_Index|Show index' => '_Indice|Mostra l\'indice',
  '_Insert' => '_Inserisci',
  '_Insert|' => '_Inserisci|',
  '_Italic|Italic' => '_Corsivo|Corsivo',
  '_Jump To...|Jump to page' => '_Salta A...|Salta alla pagina',
  '_Keybindings|Key bindings' => '_Scorciatoie|Imposta scorciatoie da tastiera',
  '_Link' => '_Collegamento',
  '_Link to date' => '_Collegamento alla data',
  '_Link...|Insert link' => '_Collegamento...|Inserisci un collegamento',
  '_Link|Link' => '_Link|Link',
  '_Namespace|.' => '_Namespace|',
  '_New Page|New page' => '_Nuova Pagina|Crea una nuova pagina',
  '_Next' => '_Successivo',
  '_Next in index|Go to next page' => '_Successivo nell\'indice|Vai alla pagina successiva',
  '_Normal|Normal' => '_Normale|Normale',
  '_Notebook Changes...' => '_Mostra le modifiche...',
  '_Open Another Notebook...|Open notebook' => '_Apri Altro Contenitore...|Apri un contenitore per gli appunti',
  '_Open link' => 'Apri _Collegamento',
  '_Overwrite' => 'S_ovrascrivi',
  '_Page' => '_Pagina',
  '_Page Changes...' => '',
  '_Parent|Go to parent page' => '_Su|Vai alla pagina "madre"',
  '_Paste|Paste' => '_Incolla|Incolla',
  '_Preview' => '_Anteprima',
  '_Previous' => '_Precedente',
  '_Previous in index|Go to previous page' => '_Precedente nell\'indice|Vai alla pagina precedente',
  '_Properties' => '_Proprietà',
  '_Quit|Quit' => '_Esci|Esci da Zim',
  '_Recent pages|.' => 'Pagine _Recenti|Mostra le pagine utilizzate di recente',
  '_Redo|Redo' => '_Ripristina|Ripristina',
  '_Reload|Reload page' => '_Ricarica|Ricarica la pagina',
  '_Rename' => '_Rinomina',
  '_Rename Page...|Rename page' => '_Rinomina Pagina...|Rinomina la pagina',
  '_Replace' => 'S_ostituisci',
  '_Replace...|Find and Replace' => '_Sostituisci...|Cerca e Sostituisci',
  '_Reset' => 'A_zzera',
  '_Restore Version...' => '',
  '_Save Copy' => '_Salva Copia',
  '_Save a copy...' => '_Salva una copia...',
  '_Save|Save page' => '_Salva|Salva la pagina',
  '_Screenshot...|Insert screenshot' => '_Screenshot...|Inserisci uno screenshot',
  '_Search...|Search' => '_Cerca...|Cerca',
  '_Search|' => '_Cerca|',
  '_Send To...|Mail page' => '_Invia A...|Email',
  '_Statusbar|Show statusbar' => 'Barra di _Stato|Mostra la barra di stato',
  '_TODO List...|Open TODO List' => '_TODO List...|Apri TODO List',
  '_Today' => '_Oggi',
  '_Toolbar|Show toolbar' => '_Barra degli Strumenti|Mostra la barra degli strumenti',
  '_Tools|' => '_Strumenti|',
  '_Underline|Underline' => '_Sottolineato|Sottolineato',
  '_Undo|Undo' => '_Annulla|Annulla',
  '_Update links in this page' => '_Aggiorna link in questa pagina',
  '_Update {number} page linking here' => [
    '',
    ''
  ],
  '_Verbatim|Verbatim' => 'Font _Verbatim|Font Verbatim',
  '_Versions...|Versions' => '_Versioni...|Versioni',
  '_View|' => '_Visualizza|',
  '_Word Count|Word count' => '_Conteggio Parole|Conteggio parole',
  'other...' => 'altro...',
  '{name}_(Copy)' => '{name}_(Copy)',
  '{number} _Back link' => [
    '{number} _Backlink',
    '{number} _Backlink'
  ],
  '{number} item total' => [
    '{number} oggetto totale',
    '{number} oggetti totali'
  ]
};
