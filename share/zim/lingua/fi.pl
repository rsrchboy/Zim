# Finnish translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Juhana Uuttu (fi)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: pardus@cpan.org
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-02-07 21:04+0000
# Last-Translator: Juhana Uuttu <Unknown>
# Language-Team: Finnish <fi@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=2; plural=n != 1;
# X-Launchpad-Export-Date: 2009-02-17 18:56+0000
# X-Generator: Launchpad (build Unknown)
# X-Poedit-Country: FINLAND
# X-Poedit-Language: Finnish
# X-Poedit-Basepath: /home/cthulhu/paketointi/zim/Zim-0.26
# X-Poedit-Bookmarks: 29,-1,-1,-1,-1,-1,-1,-1,-1,-1

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n != 1},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %e %b %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Poista sivu</b>

Oletko varma että haluat poistaa
sivun \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Käynnistä versionhallinta?</b>

Versionhallintaa ei ole tälle vihkolle.
Haluatko käynnistää sen ?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Kansiota ei ole olemassa.</b>

Kansio: {path}
ei ole olemassa, haluatko luoda sen nyt?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Sivu on jo olemassa</b>

Sivu \'{name}\'
on jo olemassa.
Haluatko kirjoittaa sen yli?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Palauta sivu tallennettuun versioon?</b>

Haluatko palauttaa sivun: {page}
versioon: {version} ?

Kaikki viime tallenuksesta lähtien tehdyt muutokset menetetään!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Päivitä kalenterisivut 0.24-formaattiin?</b>

Tämä vihko sisältää sivuja päivämääriin jotka käyttävät formaattia vvvv_kk_pp.
Zim 0.24 lähtien formaatti on vvvv:kk:dd, luoden nimiavaruuksia joka kuukausi.

Haluatko päivittää muistivihkoosi käyttämään uutta pohjaa?
',
  'Add \'tearoff\' strips to the menus' => 'Lisää \'leikkausraidat\' valikkoihin',
  'Application show two text files side by side' => 'Sovellus näyttää kaksi tekstitiedostoa vierekkäin',
  'Application to compose email' => 'Sovellus sähköpostin kirjoittamiseen',
  'Application to edit text files' => 'Sovellus tekstitiedostojen muokkaamiseen',
  'Application to open directories' => 'Sovellus hakemistoille',
  'Application to open urls' => 'Sovellus URL-osoitteille',
  'Attach _File|Attach external file' => 'Liitä _tiedosto|Liitä ulkoinen tiedosto',
  'Attach external files' => 'Liitä ulkoisia tiedostoja',
  'Auto-format entities' => 'Muotoile erikoismerkit',
  'Auto-increment numbered lists' => 'Nosta numeroiduissa listoissa',
  'Auto-link CamelCase' => 'Liitä KyttyräKirjoitus',
  'Auto-link files' => 'Liitä tiedostot',
  'Auto-save version on close' => 'Tallenna versio suljettaessa',
  'Auto-select words' => 'Valitse sanat',
  'Automatically increment items in a numbered list' => 'Nosta numeroa jatkaessasi numeroitua listaa',
  'Automatically link file names when you type' => 'Automaattisesti liittää tiedostoihin kirjoittaessasi',
  'Automaticly link CamelCase words when you type' => 'Automaattisesti liitä kamelityylillä varustetut sanat',
  'Automaticly select the current word when you toggle the format' => 'Automaattisesti valitse nykyinen sana kun vaihdat formaattia',
  'Bold' => 'Lihavoitus',
  'Calen_dar|Show calendar' => 'Kalenteri|Näytä kalenteri',
  'Calendar' => 'Kalenteri',
  'Can not find application "bzr"' => 'En löydä ohjelmaa "bzr"',
  'Can not find application "{name}"' => 'En löydä sovellusta "{name}"',
  'Can not save a version without comment' => 'En pysty tallentamaan versiota ilman kommenttia',
  'Can not save to page: {name}' => 'En pysty tallentamaan sivulle: {name}',
  'Can\'t find {url}' => 'En löydä {url}',
  'Cha_nge' => 'M_uuta',
  'Chars' => 'Kirjaimia',
  'Check _spelling|Spell check' => 'Oikolue|Oikoluku',
  'Check checkbox lists recursive' => 'Vaihda rastiruutulista rekursiivisesti',
  'Checking a checkbox list item will also check any sub-items' => 'Rastiruudun muokkaus muuttaa myös sen alla olevat rastit',
  'Choose {app_type}' => 'Valitse {app_type}',
  'Co_mpare Page...' => 'Vertaa sivu...',
  'Command' => 'Komento',
  'Comment' => 'Kommentti',
  'Compare this version with' => 'Vertaa tämä versio toiseen',
  'Copy Email Address' => 'Kopioi sähköpostiosoite',
  'Copy Location|Copy location' => 'Kopioi sijainti|Kopioi sijainti',
  'Copy _Link' => 'Kopioi _linkki',
  'Could not delete page: {name}' => 'En pysty poistamaan sivua: {name}',
  'Could not get annotated source for page {page}' => 'En saanut lisähuomautettua lähdettä sivulle {page}',
  'Could not get changes for page: {page}' => 'En pysty hakemaan muutoksia sivulle: {page}',
  'Could not get changes for this notebook' => 'En pysty hakemaan muutoksia tälle vihkolle',
  'Could not get file for page: {page}' => 'En saanut tiedostoa sivulle: {page}',
  'Could not get versions to compare' => 'En saanut versioita verrattaviksi',
  'Could not initialize version control' => 'En pysty käynnistämään versionhallintaa',
  'Could not load page: {name}' => 'En pysty lataamaan sivua: {name}',
  'Could not rename {from} to {to}' => 'En pysty nimeämään {from} muotoon {to}',
  'Could not save page' => 'En pysty tallentamaan sivua',
  'Could not save version' => 'En pysty tallentamaan versiota',
  'Creating a new link directly opens the page' => 'Uuden linkin luominen avaa uuden sivun',
  'Creation Date' => 'Luotu',
  'Cu_t|Cut' => 'Le_ikkaa|Leikkaa',
  'Current' => 'Nykyinen',
  'Customise' => 'Muokkaa',
  'Date' => 'Päivämäärä',
  'Default notebook' => 'Vakiovihko',
  'Details' => 'Yksityiskohdat',
  'Diff Editor' => 'Diff-editori',
  'Diff editor' => 'Diff-editori',
  'Directory' => 'Hakemisto',
  'Document Root' => 'Juurihakemisto',
  'E_quation...|Insert equation' => '_Yhtälö|Lisää yhtälö',
  'E_xport...|Export' => 'Vi_e...|Vie',
  'E_xternal Link...|Insert external link' => '_Ulkoinen linkki...|Lisää ulkoinen linkki',
  'Edit Image' => 'Muokkaa kuva',
  'Edit Link' => 'Muokkaa linkkiä',
  'Edit Query' => 'Muokkaa tiedustelua',
  'Edit _Source|Open source' => 'Muokkaa _lähdettä|Avaa lähde',
  'Edit notebook' => 'Muokkaa vihkoa',
  'Edit text files "wiki style"' => 'Muokkaa tekstitiedostoja "wiki-tyylillä"',
  'Editing' => 'Muokkaus',
  'Email client' => 'Sähköposti-ohjelma',
  'Enabled' => 'Päällä',
  'Equation Editor' => 'Yhtälöeditori',
  'Equation Editor Log' => 'Yhtälöeditorin loki',
  'Expand side pane' => 'Avaa sivupaneeli',
  'Export page' => 'Vie sivu',
  'Exporting page {number}' => 'Viedään sivua {number}',
  'Failed to cleanup SVN working copy.' => 'En onnistunut siivoamaan SVN-työkopiota.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'SVN-lisäosan lataus epäonnistui.
Onko sinulla subversion-työkalut asennettuna?',
  'Failed to load plugin: {name}' => 'Lisäosan lataus epäonnistui: {name}',
  'Failed update working copy.' => 'Kopion päivitys epäonnistui.',
  'File browser' => 'Tiedostoselain',
  'File is not a text file: {file}' => 'Tiedosto ei sisällä tekstiä: {file}',
  'Filter' => 'Suodatin',
  'Find' => 'Etsi',
  'Find Ne_xt|Find next' => 'Etsi seuraava|Etsi seuraava',
  'Find Pre_vious|Find previous' => 'Etsi edellinen|Etsi edellinen',
  'Find and Replace' => 'Etsi ja korvaa',
  'Find what' => 'Etsi mitä',
  'Follow new link' => 'Seuraa luotua linkkiä',
  'For_mat|' => 'M_uoto|',
  'Format' => 'Formaatti',
  'General' => 'Yleinen',
  'Go to "{link}"' => 'Mene sivulle "{link}"',
  'H_idden|.' => 'Piilotettu|.',
  'Head _1|Heading 1' => 'Otsikko _1|Otsikko 1',
  'Head _2|Heading 2' => 'Otsikko _2|Otsikko 2',
  'Head _3|Heading 3' => 'Otsikko _3|Otsikko 3',
  'Head _4|Heading 4' => 'Otsikko _4|Otsikko 4',
  'Head _5|Heading 5' => 'Otsikko _5|Otsikko 5',
  'Head1' => 'Otsikko1',
  'Head2' => 'Otsikko2',
  'Head3' => 'Otsikko3',
  'Head4' => 'Otsikko4',
  'Head5' => 'Otsikko5',
  'Height' => 'Korkeus',
  'Home Page' => 'Kotisivu',
  'Icon' => 'Ikoni',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Lisää mukaan kaikki avoimet valintaruudut',
  'Index page' => 'Indeksisivu',
  'Initial version' => 'Ensiversio',
  'Insert Date' => 'Lisää päivämäärä',
  'Insert Image' => 'Lisää kuva',
  'Insert Link' => 'Lisää linkki',
  'Insert from file' => 'Lisää tiedostosta',
  'Interface' => 'Käyttöliittymä',
  'Italic' => 'Kursiivi',
  'Jump to' => 'Hyppää',
  'Jump to Page' => 'Hyppää sivulle',
  'Lines' => 'Rivejä',
  'Links to' => 'Liittää',
  'Match c_ase' => 'Sama _kirjainkoko',
  'Media' => 'Media',
  'Modification Date' => 'Muokkauspäivämäärän',
  'Name' => 'Nimi',
  'New notebook' => 'Uusi muistivihko',
  'New page' => 'Uusi sivu',
  'No such directory: {name}' => 'Hakemisto ei olemassa: {name}',
  'No such file or directory: {name}' => 'Tiedosto/hakemisto ei olemassa: {name}',
  'No such file: {file}' => 'Tiedosto ei olemassa: {file}',
  'No such notebook: {name}' => 'Vihko ei olemassa: {name}',
  'No such page: {page}' => 'Sivu ei olemassa: {page}',
  'No such plugin: {name}' => 'Ei löytynyt lisäosaa: {name}',
  'Normal' => 'Normaali',
  'Not Now' => 'Ei nyt',
  'Not a valid page name: {name}' => 'Ei laillinen sivun nimi: {name}',
  'Not an url: {url}' => 'Ei ole url: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Huomaa että olemattomaan sivuun viittaaminen
automaattisesti luo uuden sivun',
  'Notebook' => 'Muistivihko',
  'Notebooks' => 'Muistivihkot',
  'Open Document _Folder|Open document folder' => 'Avaa sivun _kansio|Avaa sivun kansion',
  'Open Document _Root|Open document root' => 'Avaa _juurihakemisto|Avaa juurihakemisto',
  'Open _Directory' => 'Avaa _hakemisto',
  'Open notebook' => 'Avaa vihko',
  'Other...' => 'Muu...',
  'Output' => 'Ulostulo',
  'Output dir' => 'Tulostuskansio',
  'P_athbar type|' => '_Polkupalkin tyyppi|',
  'Page' => 'Sivu',
  'Page Editable|Page editable' => 'Sivu muokattavissa|Sivu muokattavissa',
  'Page name' => 'Sivun nimi',
  'Pages' => 'Sivut',
  'Password' => 'Salasana',
  'Please enter a comment for this version' => 'Lisää kommentti versioon',
  'Please enter a name to save a copy of page: {page}' => 'Anna nimi tallentaaksesi kopion sivusta: {page}',
  'Please enter a {app_type}' => 'Valitse {app_type}',
  'Please give a page first' => 'Valitse sivu ensiksi',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Anna vähintään yksi hakemisto sivujen tallentamiseen.
Uudelle muistivihkolle sen pitäisi olla tyhjä hakemisto.
Esimerkiksi "Ruokareseptit"-kansio kotihakemistossasi.',
  'Please provide the password for
{path}' => 'Anna salasana hakemistolle:
{path}',
  'Please select a notebook first' => 'Valitse muistivihko ensin',
  'Please select a version first' => 'Valitse versio ensiksi',
  'Plugin already loaded: {name}' => 'Lisäosa jo ladattu: {name}',
  'Plugins' => 'Lisäosat',
  'Pr_eferences|Preferences dialog' => 'Asetukset|Asetukset',
  'Preferences' => 'Asetukset',
  'Prefix document root' => 'Juurihakemiston etuliite',
  'Print to Browser|Print to browser' => 'Tulosta selaimelle|Tulosta selaimelle',
  'Prio' => 'Prio',
  'Proper_ties|Properties dialog' => '_Ominaisuudet|Ominaisuudet',
  'Properties' => 'Ominaisuudet',
  'Rank' => 'Arvo',
  'Re-build Index|Rebuild index' => 'Uudista indeksi|Uudelleenrakenna indeksi',
  'Recursive' => 'Rekursiivinen',
  'Rename page' => 'Muuta sivun nimeä',
  'Rename to' => 'Nimeä muotoon',
  'Replace _all' => 'Korvaa ka_ikki',
  'Replace with' => 'Korvaa',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN siivous|Siivoa SVN-työkopio',
  'SVN commit|Commit notebook to SVN repository' => 'SVN-merkintä|Merkitse vihko SVN-varastoon',
  'SVN update|Update notebook from SVN repository' => 'SVN-päivitys|Päivitä vihko SVN-varastosta',
  'S_ave Version...|Save Version' => 'Tallenna ve_rsio...|Tallenna versio',
  'Save Copy' => 'Tallenna kopio',
  'Save version' => 'Tallenna versio',
  'Scanning tree ...' => 'Luetaan puuta...',
  'Search' => 'Etsi',
  'Search _Backlinks...|Search Back links' => 'Etsi _viitelinkkejä...|Etsi viitelinkkejä',
  'Select File' => 'Valitse tiedosto',
  'Select Folder' => 'Valitse kansio',
  'Send To...' => 'Lähetä...',
  'Show cursor for read-only' => 'Näytä kohdistin kirjoitussuojassa',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Näytä kohdistin vaikka et pystyisi kirjoittamaan sivulle. Hyödyllinen näppäimistö-pohjaisille selailuille.',
  'Slow file system' => 'Hidas tiedostojärjestelmä',
  'Source' => 'Lähde',
  'Source Format' => 'Lähdemuoto',
  'Start the side pane with the whole tree expanded.' => 'Avaa sivupaneeli koko hakemistopuu avattuna.',
  'Stri_ke|Strike' => '_Yliviivaus|Yliviivaus',
  'Strike' => 'Yliviivaus',
  'TODO List' => 'TODO-lista',
  'Task' => 'Tehtävä',
  'Tearoff menus' => 'Irrotettavat valikot',
  'Template' => 'Malli',
  'Text' => 'Teksti',
  'Text Editor' => 'Tekstieditori',
  'Text _From File...|Insert text from file' => '_Teksti tiedostosta...|Lisää tekstiä tiedostosta',
  'Text editor' => 'Tekstieditori',
  'The equation failed to compile. Do you want to save anyway?' => 'Yhtälö epäonnistui. Haluatko kuitenkin tallentaa?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'Yhtälö kuvalle: {path}
puuttuu. Ei voi muokata yhtälöä.',
  'This notebook does not have a document root' => 'Tällä vihkolla ei ole juurihakemistoa',
  'This page does not exist
404' => 'Tämä sivu ei olemassa
404',
  'This page does not have a document folder' => 'Tällä sivulla ei ole asiakirjakansiota',
  'This page does not have a source' => 'Tällä sivulla ei ole lähdettä',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Tästä sivusta on päivitys varastossa.
Ole hyvä ja päivitä kopiosi (Työkalut -> SVN päivitys).',
  'To_day|Today' => 'Tänään|Tänään',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Vaihda rastiruutuun \'V\'|Vaihda rasti',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Vaihda rastiruutuun \'X\'|Vaihda rasti',
  'Underline' => 'Alleviivaus',
  'Updating links' => 'Päivitetään linkit',
  'Updating links in {name}' => 'Päivitetään linkit kohteesta {name}',
  'Updating..' => 'Päivitetään...',
  'Use "Backspace" to un-indent' => 'Käytä askelpalautinta epä-sisennykseen',
  'Use "Ctrl-Space" to switch focus' => 'Käytä "Ctrl-Space" vaihtaakseen fokusta',
  'Use "Enter" to follow links' => 'Käytä "Enter"iä seurataksesi linkkejä',
  'Use autoformatting to type special characters' => 'Käytä automaattista muotoilua erikoismerkkien luomisessa',
  'Use custom font' => 'Käytä omaa fonttia',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Käytä askelpalautinta poistaaksesi sisennyksen listasta (Sama kuin "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Käytä "Ctrl-Space" näppäinyhdistelmää vaihtaakseen fokusta tekstin ja sivupaneelin välillä. Voit käyttää myös yhdistelmää "Alt-Space".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Käytä "Enter"-näppäintä seurataksesi linkkejä. Vaihtoehtoisesti voit käyttää "Alt-Enter"iä',
  'User' => 'Käyttäjä',
  'User name' => 'Käyttäjänimi',
  'Verbatim' => 'Tasavälinen',
  'Versions' => 'Versiot',
  'View _Annotated...' => 'Katso lisä_huomautetut...',
  'View _Log' => 'Näytä _loki',
  'Web browser' => 'Nettiselain',
  'Whole _word' => 'K_oko sana',
  'Width' => 'Laajuus',
  'Word Count' => 'Sanamäärä',
  'Words' => 'Sanoja',
  'You can add rules to your search query below' => 'Voit lisätä alapuolelle omia sääntöjä tiedusteluusi',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Voit joko valita <b>Bazaar</b> tai <b>Subversion</b> versionhallintajärjestelmän.
Valitse \'Ohje\' lukeaksesi järjestelmävaatimuksista.',
  'You have no {app_type} configured' => 'Sinulla ei ole {app_type} valittuna',
  'You need to restart the application
for plugin changes to take effect.' => 'Sinun on käynnistettävä ohjelma
uudestaan että lisäosat vaikuttaisivat.',
  'Your name; this can be used in export templates' => 'Sinun nimesi; tätä voidaan käyttää mallien viennissä',
  'Zim Desktop Wiki' => 'Zim työpöytä-wiki',
  '_About|About' => '_Tietoja|Tietoja',
  '_All' => 'K_aikki',
  '_Back|Go page back' => '_Takaisin|Mene sivun taakse',
  '_Bold|Bold' => 'Li_havoitus|Lihavoitus',
  '_Browse...' => '_Selaa',
  '_Bugs|Bugs' => '_Bugit|Bugit',
  '_Child|Go to child page' => '_Ala|Mene alasivulle',
  '_Close|Close window' => '_Sulje|Sulje ikkuna',
  '_Contents|Help contents' => '_Sisältö|Ohjesisällöt',
  '_Copy Page...|Copy page' => '_Kopioi sivu...|Kopioi sivu',
  '_Copy|Copy' => '_Kopioi|Kopioi',
  '_Date and Time...|Insert date' => '_Päivämäärä...|Lisää päivämäärä',
  '_Delete Page|Delete page' => '_Poista sivu|Poista sivu',
  '_Delete|Delete' => '_Poista|Poista',
  '_Discard changes' => '_Hylkää muutokset',
  '_Edit' => '_Muokkaa',
  '_Edit Equation' => '_Muokkaa yhtälöä',
  '_Edit Link' => '_Muokkaa linkkiä',
  '_Edit Link...|Edit link' => '_Muokkaa linkki...|Muokkaa linkkiä',
  '_Edit|' => '_Muokkaa|',
  '_FAQ|FAQ' => '_UKK|Usein Kysytyt Kysymykset',
  '_File|' => '_Tiedosto|',
  '_Filter' => '_Suodata',
  '_Find...|Find' => 'Etsi _sivusta...|Etsi sivusta',
  '_Forward|Go page forward' => '_Eteenpäin|Mene sivun eteenpäin',
  '_Go|' => 'M_ene|',
  '_Help|' => '_Ohje|',
  '_History|.' => '_Historia|.',
  '_Home|Go home' => '_Koti|Mene kotiin',
  '_Image...|Insert image' => '_Kuva|Lisää kuva',
  '_Index|Show index' => '_Indeksi|Näytä indeksi',
  '_Insert' => 'L_isää',
  '_Insert|' => '_Lisää|',
  '_Italic|Italic' => '_Kursiivi|Kursiivi',
  '_Jump To...|Jump to page' => '_Hyppää...|Hyppää sivulle',
  '_Keybindings|Key bindings' => '_Näppäinyhdistelmät|Näppäinyhdistelmät',
  '_Link' => '_Linkki',
  '_Link to date' => '_Linkki päivämäärään',
  '_Link...|Insert link' => '_Linkki...|Lisää linkki',
  '_Link|Link' => '_Linkki|Linkki',
  '_Namespace|.' => '_Nimiavaruus|.',
  '_New Page|New page' => '_Uusi sivu|Uusi sivu',
  '_Next' => 'Seur_aava',
  '_Next in index|Go to next page' => '_Seuraava indeksissä|Mene seuraavaan sivuun',
  '_Normal|Normal' => '_Normaali|Normaali',
  '_Notebook Changes...' => 'Vihko_n muutokset...',
  '_Open Another Notebook...|Open notebook' => '_Avaa toinen vihko...|Avaa vihko',
  '_Open link' => '_Avaa linkki',
  '_Overwrite' => '_Ylikirjoita',
  '_Page' => '_Sivu',
  '_Page Changes...' => 'Sivumuutokset...',
  '_Parent|Go to parent page' => '_Ylä|Mene yläsivulle',
  '_Paste|Paste' => '_Liitä|Liitä',
  '_Preview' => '_Esikatsele',
  '_Previous' => 'E_dellinen',
  '_Previous in index|Go to previous page' => 'E_dellinen indeksissä|Mene edelliseen sivuun',
  '_Properties' => '_Ominaisuudet',
  '_Quit|Quit' => '_Lopeta|Lopeta',
  '_Recent pages|.' => '_Äskeiset sivut|.',
  '_Redo|Redo' => 'Tee uu_delleen|Tee uudelleen',
  '_Reload|Reload page' => '_Päivitä|Päivitä sivu',
  '_Rename' => '_Uusi nimi',
  '_Rename Page...|Rename page' => '_Uudelleennimeä sivu...|Uudelleennimeä sivu',
  '_Replace' => '_Korvaa',
  '_Replace...|Find and Replace' => '_Korvaa...|Etsi ja korvaa',
  '_Reset' => '_Resetoi',
  '_Restore Version...' => '_Palauta versio',
  '_Save Copy' => '_Tallenna kopio',
  '_Save a copy...' => '_Tallenna kopio...',
  '_Save|Save page' => '_Tallenna|Tallenna sivu',
  '_Screenshot...|Insert screenshot' => 'Kuvakaappaus...|Lisää kuvakaappaus',
  '_Search...|Search' => '_Etsi...|Etsi',
  '_Search|' => 'Et_si|',
  '_Send To...|Mail page' => '_Lähetä...|Lähetä sivu',
  '_Statusbar|Show statusbar' => 'Ti_lannepalkki|Näytä tilannepalkki',
  '_TODO List...|Open TODO List' => 'TO_DO-lista...|Avaa TODO-lista',
  '_Today' => '_Tänään',
  '_Toolbar|Show toolbar' => '_Työpalkki|Näytä työpalkki',
  '_Tools|' => 'Työ_kalut|',
  '_Underline|Underline' => '_Alleviivaus|Alleviivaus',
  '_Undo|Undo' => 'K_umoa|Kumoa',
  '_Update links in this page' => '_Päivitä sivun linkit',
  '_Update {number} page linking here' => [
    '_Päivitä {number} sivun linkkaus',
    '_Päivitä {number} sivun linkkaukset'
  ],
  '_Verbatim|Verbatim' => '_Tasavälinen|Tasavälinen',
  '_Versions...|Versions' => '_Versiot...|Versiot',
  '_View|' => '_Näytä|',
  '_Word Count|Word count' => '_Sanamäärä|Sanamäärä',
  'other...' => 'muu...',
  '{name}_(Copy)' => '{name}_(Kopio)',
  '{number} _Back link' => [
    '{number} _viitelinkki',
    '{number} _viitelinkkiä'
  ],
  '{number} item total' => [
    '{number} tehtävä',
    '{number} tehtävää'
  ]
};
