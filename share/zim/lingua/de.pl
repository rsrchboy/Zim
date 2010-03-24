# German translation for zim
# Copyright (c) 2007 Rosetta Contributors and Canonical Ltd 2007
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2007.
# 
# 
# TRANSLATORS:
# BBO (de)
# Fabian Affolter (de)
# Hokey (de)
# Jaap Karssenberg (de)
# Klaus Vormweg (de)
# Matthias Mailänder (de)
# Nikolaus Klumpp (de)
# René 'Necoro' Neumann (de)
# Vinzenz Vietzke (de)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-11-13 22:11+0000
# Last-Translator: BBO <Unknown>
# Language-Team: German <de@li.org>
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
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Seite löschen</b>

Sind Sie sicher, dass sie die Seite
\'{name}\' löschen wollen?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Versionskontrolle einschalten</b>

Versionskontrolle ist für dieses Notizbuch nicht aktiviert.
Wollen Sie sie einschalten?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Verzeichnis existiert nicht.</b>

Das Verzeichnis: {path}
gibt es noch nicht. Wollen Sie es anlegen?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Seite existiert schon</b>

Die Seite \'{name}\'
exisitiert schon. Wollen Sie
sie überschreiben?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Seite durch eine ältere Version ersetzen!</b>

Wollsen Sie die Seite: {page}
durch die Version {version} ersetzen?

Alle Änderungen nach dieser Version gehen verloren!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Kalenderseiten in das Format der Version 0.24 umwandeln?</b>

Diese Verzeichnis enthält Seiten für Tage im  Format yyyy_mm_dd.
Ab Zim 0.24 wird das Format yyyy:mm:dd benutzt. Das erzeugt
einen Namensraum pro Monat.

Wollen Sie Ihre Sammlung in das neue Layout umwandeln?
',
  'Add \'tearoff\' strips to the menus' => 'Menüs \'abreißbar\' machen',
  'Application show two text files side by side' => 'Programm, um zwei Textdateien nebeneinander darzustellen',
  'Application to compose email' => 'Mailprogramm',
  'Application to edit text files' => 'Anwendung zum Bearbeiten von Text-Dateien',
  'Application to open directories' => 'Dateibrowser',
  'Application to open urls' => 'Anwendung um URLs zu öffnen',
  'Attach _File|Attach external file' => 'Anhang hinzu_fügen|Eine externe Datei hinzufügen',
  'Attach external files' => 'Externe Dateien anhängen',
  'Auto-format entities' => 'Automatische Umsetzung von Sonderzeichen',
  'Auto-increment numbered lists' => 'Automatisches Hochzählen numerierter Listen',
  'Auto-link CamelCase' => 'KamelSchreibWeise automatisch verlinken',
  'Auto-link files' => 'Dateien automatisch verlinken',
  'Auto-save version on close' => 'Automatisches Speichern der Version beim Schließen',
  'Auto-select words' => 'Worte automatisch markieren',
  'Automatically increment items in a numbered list' => 'Zählt automatisch die Einträge einer numerierten Liste',
  'Automatically link file names when you type' => 'Dateien während der Eingabe automatisch verlinken',
  'Automaticly link CamelCase words when you type' => 'Worte in KamelSchreibWeise während der Eingabe automatisch verlinken',
  'Automaticly select the current word when you toggle the format' => 'Markiert das aktuelle Wort automatisch, wenn Sie die Formatierung ändern',
  'Bold' => 'Fett',
  'Calen_dar|Show calendar' => '_Kalender|Öffne Kalenderfenster',
  'Calendar' => 'Kalender',
  'Can not find application "bzr"' => 'Kann das Programm "bzr" nicht finden',
  'Can not find application "{name}"' => 'Kann die Anwendung "{name}" nicht finden',
  'Can not save a version without comment' => 'Fassungen ohne Beschreibung können nicht gespeichert werden',
  'Can not save to page: {name}' => 'Kann Seite {name} nicht speichern',
  'Can\'t find {url}' => '{url} konnte nicht gefunden werden',
  'Cha_nge' => 'Ä_ndern',
  'Chars' => 'Zeichen',
  'Check _spelling|Spell check' => '_Rechtschreibprüfung|Rechtschreibprüfung',
  'Check checkbox lists recursive' => 'Ankreuzlisten rekursiv ankreuzen',
  'Checking a checkbox list item will also check any sub-items' => 'Ankreuzen eines Ankreuzfelds wird auch alle darunter liegenden Felder ankreuzen',
  'Choose {app_type}' => '{app_type} wählen',
  'Co_mpare Page...' => '_Vergleiche Seite...',
  'Command' => 'Befehl',
  'Comment' => 'Kommentar',
  'Compare this version with' => 'Diese Fassung vergleichen mit',
  'Copy Email Address' => 'E-Mail-Adresse kopieren',
  'Copy Location|Copy location' => 'Kopiere Seiten_adresse|Adresse der Wikiseite in die Zwischenablage kopieren',
  'Copy _Link' => '_Verknüpfung kopieren',
  'Could not delete page: {name}' => 'Konnte Seite {name} nicht löschen',
  'Could not get annotated source for page {page}' => 'Konnte den Quelltext mit Anmerkungen für die Seite {page} nicht laden',
  'Could not get changes for page: {page}' => 'Kann auf die Änderungen für die Seite "{page}" nicht zugreifen',
  'Could not get changes for this notebook' => 'Konnte Änderungen für dieses Notizbuch nicht lesen',
  'Could not get file for page: {page}' => 'Kann auf die Datei für die Seite "{page}" nicht zugreifen',
  'Could not get versions to compare' => 'Kann auf die zu vergleichenden Fassungen nicht zugreifen',
  'Could not initialize version control' => 'Die Versionskontrolle konnte nicht initialisiert werden.',
  'Could not load page: {name}' => 'Seite {name} konnte nicht öffnen werden',
  'Could not rename {from} to {to}' => 'Umbenennen von {from} nach {to} ist gescheitert',
  'Could not save page' => 'Speichern der Seite fehlgeschlagen',
  'Could not save version' => 'Konnte Fassung nicht speichern',
  'Creating a new link directly opens the page' => 'Wenn Sie einen neuen Link erzeugen, öffnen Sie damit eine neue Seite',
  'Creation Date' => 'Erstellungsdatum',
  'Cu_t|Cut' => 'Aus_schneiden|Ausschneiden',
  'Current' => 'Aktuell',
  'Customise' => 'Anpassen',
  'Date' => 'Datum',
  'Default notebook' => 'Standard-Notizbuch',
  'Details' => 'Details',
  'Diff Editor' => 'Diff-Editor',
  'Diff editor' => 'Diff-Editor',
  'Directory' => 'Verzeichnis',
  'Document Root' => 'Zim-Startverzeichnis',
  'E_quation...|Insert equation' => '_Formel...|Formel einfügen',
  'E_xport...|Export' => 'E_xportieren...|Exportieren',
  'E_xternal Link...|Insert external link' => 'E_xterner Link|Externen Link einfügen',
  'Edit Image' => 'Bild bearbeiten',
  'Edit Link' => 'Verknüpfung bearbeiten',
  'Edit Query' => 'Abfrage bearbeiten',
  'Edit _Source|Open source' => '_Quelltext bearbeiten|Quelltext der Seite mit externem Editor bearbeiten',
  'Edit notebook' => 'Editiere Notizbuch',
  'Edit text files "wiki style"' => 'Textdateien im \'Wiki-Stil\' bearbeiten',
  'Editing' => 'Bearbeiten',
  'Email client' => 'E-Mail-Programm',
  'Enabled' => 'Aktiviert',
  'Equation Editor' => 'Formel-Editor',
  'Equation Editor Log' => 'Formel-Editor Protokoll',
  'Expand side pane' => 'Seitenleiste erweitern',
  'Export page' => 'Exportiere Seite',
  'Exporting page {number}' => 'Seite {number} exportieren',
  'Failed to cleanup SVN working copy.' => 'Entsperren der Arbeitskopie fehlgeschlagen',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'SVN-Plugin konnte nicht geladen werden,
haben Sie die Subversion-Werkzeuge installiert?',
  'Failed to load plugin: {name}' => 'Plugin {name} konnte nicht aktiviert werden',
  'Failed update working copy.' => 'Erneuern der Arbeitskopie fehlgeschlagen',
  'File browser' => 'Dateibrowser',
  'File is not a text file: {file}' => 'Datei {file} ist keine Textdatei',
  'Filter' => 'Filter',
  'Find' => 'Suchen',
  'Find Ne_xt|Find next' => '_Vorwärts Suchen|Vorwärts Suchen',
  'Find Pre_vious|Find previous' => '_Rückwärts Suchen|Rückwärts Suchen',
  'Find and Replace' => 'Suchen und Ersetzen',
  'Find what' => 'Suche was',
  'Follow new link' => 'Folge neuem Link',
  'For_mat|' => 'For_matierung|Formatierung',
  'Format' => 'Formatierung',
  'General' => 'Allgemein',
  'Go to "{link}"' => 'Gehe zu "{link}"',
  'H_idden|.' => 'V_ersteckt|Versteckt',
  'Head _1|Heading 1' => 'Überschrift _1|Überschrift 1',
  'Head _2|Heading 2' => 'Überschrift _2|Überschrift 2',
  'Head _3|Heading 3' => 'Überschrift _3|Überschrift 3',
  'Head _4|Heading 4' => 'Überschrift _4|Überschrift 4',
  'Head _5|Heading 5' => 'Überschrift _5|Überschrift 5',
  'Head1' => 'Überschrift1',
  'Head2' => 'Überschrift2',
  'Head3' => 'Überschrift3',
  'Head4' => 'Überschrift4',
  'Head5' => 'Überschrift5',
  'Height' => 'Höhe',
  'Home Page' => 'Startseite',
  'Icon' => 'Symbol',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Alle offenen Ankreuzfelder einschließen',
  'Index page' => 'Indexseite',
  'Initial version' => 'Startversion',
  'Insert Date' => 'Datum einfügen',
  'Insert Image' => 'Bild einfügen',
  'Insert Link' => 'Verknüpfung einfügen',
  'Insert from file' => 'Aus Datei einfügen',
  'Interface' => 'Erscheinungsbild',
  'Italic' => 'Kursiv',
  'Jump to' => 'Springe zu',
  'Jump to Page' => 'Springe zu Seite',
  'Lines' => 'Zeilen',
  'Links to' => 'Verweist auf',
  'Match c_ase' => '_Groß- und Kleinschreibung beachten',
  'Media' => 'Medien',
  'Modification Date' => 'Änderungsdatum',
  'Name' => 'Name',
  'New notebook' => 'Neues Notizbuch',
  'New page' => 'Neue Seite anlegen',
  'No such directory: {name}' => 'Verzeichnis {name} existiert nicht',
  'No such file or directory: {name}' => 'Datei oder Verzeichnis "{name}" nicht gefunden',
  'No such file: {file}' => 'Datei {file} existiert nicht',
  'No such notebook: {name}' => 'Notizbuch "{name}" existiert nicht',
  'No such page: {page}' => 'Seite existiert nicht: {page}',
  'No such plugin: {name}' => 'Plugin {name} existiert nicht',
  'Normal' => 'Standard',
  'Not Now' => 'Jetzt nicht',
  'Not a valid page name: {name}' => 'Kein gültiger Seitenname: {name}',
  'Not an url: {url}' => 'Keine URL: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Bitte beachten Sie, dass der Link auf eine
nicht existierende Seite automatisch eine
neue, leere Seite erzeugt',
  'Notebook' => 'Notizbuch',
  'Notebooks' => 'Notizbücher',
  'Open Document _Folder|Open document folder' => 'Dokumentverzeichnis _öffnen|Dokumentverzeichnis öffnen',
  'Open Document _Root|Open document root' => '_Zim-Wurzelverzeichnis öffnen|Zim-Wurzelverzeichnis öffnen',
  'Open _Directory' => '_Verzeichnis öffnen',
  'Open notebook' => 'Notizbuch öffnen',
  'Other...' => 'Andere…',
  'Output' => 'Ausgabe',
  'Output dir' => 'Ausgabeverzeichnis',
  'P_athbar type|' => 'Pf_adleisten-Stil|Pfadleisten-Stil',
  'Page' => 'Seite',
  'Page Editable|Page editable' => 'Seite editierbar|Seite editierbar',
  'Page name' => 'Seitenname',
  'Pages' => 'Seiten',
  'Password' => 'Passwort',
  'Please enter a comment for this version' => 'Bitte geben Sie eine Beschreibung für diese Fassung ein',
  'Please enter a name to save a copy of page: {page}' => 'Bitte geben Sie einen Namen ein, um eine Kopie der Seite {page} zu speichern.',
  'Please enter a {app_type}' => 'Bitte geben Sie ein: {app_type}',
  'Please give a page first' => 'Bitte zuerst eine Seite angeben',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Bitte mindestens ein Verzeichnis zum Abspeichern von Seiten angeben.
Für ein neues Notizbuch sollte dies ein leeres Verzeichnis sein.
Zum Beispiel ein Verzeichnis "Notizen" im Persönlichen Ordner.',
  'Please provide the password for
{path}' => 'Bitte geben Sie das Passwort für
{path} ein',
  'Please select a notebook first' => 'Bitte wählen Sie zuerst ein Notizbuch aus',
  'Please select a version first' => 'Bitte zuerst eine Fassung wählen',
  'Plugin already loaded: {name}' => 'Plugin {name} ist schon aktiv',
  'Plugins' => 'Plugins',
  'Pr_eferences|Preferences dialog' => '_Einstellungen|Einstellungen',
  'Preferences' => 'Einstellungen',
  'Prefix document root' => 'Präfix für Wurzelverzeichnis',
  'Print to Browser|Print to browser' => 'In HTML drucken|In HTML drucken',
  'Prio' => 'Prio',
  'Proper_ties|Properties dialog' => '_Eigenschaften|Eigenschaften',
  'Properties' => 'Eigenschaften',
  'Rank' => 'Rang',
  'Re-build Index|Rebuild index' => 'Index erneuern|Index löschen und neu erstellen',
  'Recursive' => 'Rekursiv',
  'Rename page' => 'Seite umbenennen',
  'Rename to' => 'Umbenennen in',
  'Replace _all' => '_Alles ersetzen',
  'Replace with' => 'Ersetzen durch',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN cleanup|SVN Arbeitskopie entsperren',
  'SVN commit|Commit notebook to SVN repository' => 'SVN commit|Notizbuch ins SVN Archive einchecken',
  'SVN update|Update notebook from SVN repository' => 'SVN update|Notizbuch aus dem SVN Archiv erneuern',
  'S_ave Version...|Save Version' => 'Fassung s_peichern|Fassung speichern',
  'Save Copy' => 'Kopie speichern',
  'Save version' => 'Fassung speichern',
  'Scanning tree ...' => 'Durchsuche Baum...',
  'Search' => 'Suche',
  'Search _Backlinks...|Search Back links' => 'Suche nach _Backlinks ...|Suche nach Backlinks ...',
  'Select File' => 'Datei auswählen',
  'Select Folder' => 'Verzeichnis auswählen',
  'Send To...' => 'Senden an …',
  'Show cursor for read-only' => 'Zeige Cursor bei schreibgeschützten Seiten',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Zeige den Cursor, auch wenn die Seite schreibgeschützt ist. Das ist nützlich, wenn Sie sich mit Hilfe der Tastatur durch die Seiten bewegen',
  'Slow file system' => 'Langsames Dateisystem',
  'Source' => 'Quelle',
  'Source Format' => 'Quellformat',
  'Start the side pane with the whole tree expanded.' => 'Zeige expandierten Seitenbaum in der Seitenleiste',
  'Stri_ke|Strike' => '_Durchgestrichen|Durchgestrichen',
  'Strike' => 'Durchgestrichen',
  'TODO List' => 'Aufgabenliste',
  'Task' => 'Aufgabe',
  'Tearoff menus' => 'Abreißbare Menüs',
  'Template' => 'Vorlage',
  'Text' => 'Text',
  'Text Editor' => 'Texteditor',
  'Text _From File...|Insert text from file' => 'Text aus Datei ein_fügen...|Text aus einer Datei einfügen',
  'Text editor' => 'Texteditor',
  'The equation failed to compile. Do you want to save anyway?' => 'Die Formel war fehlerhaft. Trotzdem speichern?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'Die Formel für das Bild: {path}
fehlt. Die Formel kann nicht
bearbeitet werden.',
  'This notebook does not have a document root' => 'Diese Notizbuch besitzt kein übergeordnetes Dokumentverzeichnis',
  'This page does not exist
404' => 'Die Seite gibt es nicht
404',
  'This page does not have a document folder' => 'Diese Seite gehört zu keinem Dokumentverzeichnis',
  'This page does not have a source' => 'Diese Seite hat keine Quelle',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Diese Seite wurde im SVN Archiv geändert.
Bitte erneuern sie Ihre Arbeitskopie (Werkzeuge -> SVN update).',
  'To_day|Today' => '_Heute|Erzeuge eine neue Seite für heute',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Ankreuzfeld \'V\' umschalten|Ankreuzfeld umschalten',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Ankreuzfeld \'X\' umschalten|Ankreuzfeld umschalten',
  'Underline' => 'Unterstrichen',
  'Updating links' => 'Links anpassen',
  'Updating links in {name}' => 'Passe Links in {name} an',
  'Updating..' => 'Passe an...',
  'Use "Backspace" to un-indent' => 'Ausrücken mit der \'Zurück\'-Taste',
  'Use "Ctrl-Space" to switch focus' => '\'Strg-Leertaste\' wechselt Fokus',
  'Use "Enter" to follow links' => '\'Eingabe\'-Taste folgt Links',
  'Use autoformatting to type special characters' => 'Automatische Umsetzung von Sonderzeichen',
  'Use custom font' => 'Benutze eigene Schriftart',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => '\'Zurück(Backspace)\'-Taste verkleinert Einzug von unsortierten Listen (oder \'Hochstell-Tabulator\')',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => '\'Strg-Leertaste\' wechselt den Fokus zwischen Textfenster und Seitenleiste. Sollte das abgestellt sein, benutzen Sie bitte \'Alt-Leertaste\'',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => '\'Eingabe\'-Taste folgt Links. Sollte das abgestellt sein, benutzen Sie bitte \'Alt-Eingabe\'',
  'User' => 'Benutzer',
  'User name' => 'Benutzername',
  'Verbatim' => 'Vorformatiert',
  'Versions' => 'Versionen',
  'View _Annotated...' => 'Ansicht mit _Anmerkungen',
  'View _Log' => '_Protokoll anzeigen',
  'Web browser' => 'Web-Browser',
  'Whole _word' => 'Ganzes _Wort',
  'Width' => 'Breite',
  'Word Count' => 'Wortanzahl',
  'Words' => 'Worte',
  'You can add rules to your search query below' => 'Unten können Regeln zur Suchabfrage hinzugefügt werden',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Sie können entweder das Versionskontrollsystem <b>Bazaar</b> oder <b>Subversion</b> verwenden.
In der Hilfe finden Sie die Systemanforderungen.',
  'You have no {app_type} configured' => 'Es wurde kein {app_type} konfiguriert',
  'You need to restart the application
for plugin changes to take effect.' => 'Sie müssen Zim neustarten, damit Änderungen
der Plugin-Einstellungen wirksam werden',
  'Your name; this can be used in export templates' => 'Ihr Name (wird benutzt in Export-Templates)',
  'Zim Desktop Wiki' => 'Zim Desktop-Wiki',
  '_About|About' => '_Über|Über Zim',
  '_All' => '_Alle',
  '_Back|Go page back' => '_Zurück|Eine Seite zurück',
  '_Bold|Bold' => '_Fett|Fett',
  '_Browse...' => '_Durchsuchen …',
  '_Bugs|Bugs' => '_Fehlermeldungen|Fehlermeldungen',
  '_Child|Go to child page' => '_Untergeordnet|Zur untergeordneten Seite gehen',
  '_Close|Close window' => '_Schließen|Fenster schließen',
  '_Contents|Help contents' => '_Inhalt|Inhalt der Hilfe',
  '_Copy Page...|Copy page' => '_Kopiere Seite...|Kopiere Seite',
  '_Copy|Copy' => '_Kopieren|Kopieren',
  '_Date and Time...|Insert date' => '_Datum und Zeit...|Datum und Uhrzeit einfügen',
  '_Delete Page|Delete page' => '_Löschen|Lösche Seite',
  '_Delete|Delete' => '_Löschen|Löschen',
  '_Discard changes' => 'Änderungen _verwerfen',
  '_Edit' => 'B_earbeiten',
  '_Edit Equation' => 'Formel b_earbeiten',
  '_Edit Link' => 'Link _bearbeiten',
  '_Edit Link...|Edit link' => 'Link _bearbeiten|Link bearbeiten',
  '_Edit|' => '_Bearbeiten|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_Datei|',
  '_Filter' => '_Filter',
  '_Find...|Find' => '_Suchen|Suchen',
  '_Forward|Go page forward' => '_Vorwärts|Eine Seite vorwärts',
  '_Go|' => '_Gehe|Gehe',
  '_Help|' => '_Hilfe|Hilfe',
  '_History|.' => '_Verlauf|Verlauf',
  '_Home|Go home' => '_Startseite|Gehe zur Startseite',
  '_Image...|Insert image' => '_Bild...|Bild einfügen',
  '_Index|Show index' => '_Index|Index anzeigen',
  '_Insert' => 'E_infügen',
  '_Insert|' => '_Einfügen|Einfügen',
  '_Italic|Italic' => '_Kursiv|Kursiv',
  '_Jump To...|Jump to page' => 'S_pringe zu ...|Zu Seite springen',
  '_Keybindings|Key bindings' => '_Tastenkombinationen|Tastenkombinationen',
  '_Link' => '_Link',
  '_Link to date' => 'Ver_linke datum',
  '_Link...|Insert link' => '_Link...|Link einfügen',
  '_Link|Link' => '_Link|Link',
  '_Namespace|.' => '_Namensraum|Namensraum',
  '_New Page|New page' => '_Neue Seite|Neue Seite',
  '_Next' => '_Nächstes',
  '_Next in index|Go to next page' => '_Nächste Seite im Index|Zur nächsten Seite im Index gehen',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => 'Änderungsprotokoll _Notizbuch ...',
  '_Open Another Notebook...|Open notebook' => 'Ein weiteres N_otizbuch öffnen ...|Notizbuch öffnen',
  '_Open link' => 'Verknüpfung öf_fnen',
  '_Overwrite' => '_Überschreiben',
  '_Page' => '_Seite',
  '_Page Changes...' => '_Änderungen an der Seite...',
  '_Parent|Go to parent page' => '_Übergeordnet|Zur übergeordneten Seite gehen',
  '_Paste|Paste' => '_Einfügen|Einfügen',
  '_Preview' => '_Vorschau',
  '_Previous' => '_Vorheriges',
  '_Previous in index|Go to previous page' => '_Vorherige Seite im Index|Zur vorherigen Seite im Index gehen',
  '_Properties' => '_Eigenschaften',
  '_Quit|Quit' => '_Beenden|Programm Beenden',
  '_Recent pages|.' => 'Kü_rzlich besuchte Seiten|Kürzlich besuchte Seiten',
  '_Redo|Redo' => '_Wiederholen|Wiederholen',
  '_Reload|Reload page' => '_Neu laden|Seite neu laden',
  '_Rename' => '_Umbennenen',
  '_Rename Page...|Rename page' => '_Umbenennen| Seite umbenennen',
  '_Replace' => '_Ersetzen',
  '_Replace...|Find and Replace' => '_Ersetzen|Suchen und Ersetzen',
  '_Reset' => '_Zurücksetzen',
  '_Restore Version...' => 'Ve_rsion wiederherstellen...',
  '_Save Copy' => '_Kopie speichern',
  '_Save a copy...' => '_Speichern unter',
  '_Save|Save page' => '_Speichern|Seite speichern',
  '_Screenshot...|Insert screenshot' => '_Bildschirmfoto|Bildschirmfoto einfügen',
  '_Search...|Search' => '_Suchen...|Suchen',
  '_Search|' => '_Suchen|Suchen',
  '_Send To...|Mail page' => '_Senden an...|Per E-Mail versenden',
  '_Statusbar|Show statusbar' => '_Statuszeile|SStatuszeile an- oder abschalten',
  '_TODO List...|Open TODO List' => '_Aufgabenliste...|Öffne Aufgabenliste',
  '_Today' => '_Heute',
  '_Toolbar|Show toolbar' => 'Werkzeugleis_te|Werkzeugleiste zeigen',
  '_Tools|' => '_Werkzeuge|Werkzeuge',
  '_Underline|Underline' => '_Unterstrichen|Unterstrichen',
  '_Undo|Undo' => '_Rückgängig|Rückgängig',
  '_Update links in this page' => '_Links in dieser Seite anpassen',
  '_Update {number} page linking here' => [
    '{number} Link auf diese Seite akt_ualisieren',
    '{number} Links auf diese Seite akt_ualisieren'
  ],
  '_Verbatim|Verbatim' => '_Vorformatiert|Vorformatiert',
  '_Versions...|Versions' => '_Fassungen...|Fassungen',
  '_View|' => '_Ansicht|Ansicht',
  '_Word Count|Word count' => '_Worte zählen|Worte zählen',
  'other...' => 'andere...',
  '{name}_(Copy)' => '{name}_(Kopie)',
  '{number} _Back link' => [
    '{number} Rückverweis',
    '{number} Rückverweise'
  ],
  '{number} item total' => [
    'insgesamt {number} Eintrag',
    'insgesamt {number} Einträge'
  ]
};
