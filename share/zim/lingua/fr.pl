# French translation for zim
# Copyright (c) 2007 Rosetta Contributors and Canonical Ltd 2007
# This file is distributed under the same license as the zim package.
# 
# Robert-André Mauchin <zebob.m@pengzone.org>, 2008.
# 
# 
# TRANSLATORS:
# Jean Demartini (fr)
# Daniel Stoyanov (fr)
# Etienne Le Belléguy (fr)
# Jaap Karssenberg (fr)
# Jérôme Guelfucci (fr)
# Nucleos (fr)
# Rui Nibau (fr)
# Daniel Stoyanov (fr)
# Etienne Le Belléguy (fr)
# Jaap Karssenberg (fr)
# Jérôme Guelfucci (fr)
# Nucleos (fr)
# Rui Nibau (fr)
# BobMauchin (fr)
# Daniel Stoyanov (fr)
# Etienne Le Belléguy (fr)
# Jaap Karssenberg (fr)
# Jean DEMARTINI (fr)
# Jérôme Guelfucci (fr)
# Nucleos (fr)
# Rui Nibau (fr)
# 
# Project-Id-Version: zim HEAD
# Report-Msgid-Bugs-To: pardus@cpan.org
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-11-05 12:55+0000
# Last-Translator: Jean DEMARTINI <jean.demartini@dem-tech.net>
# Language-Team: GNOME French Team <gnomefr@traduc.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=2; plural=n > 1;
# X-Launchpad-Export-Date: 2008-11-09 09:04+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n > 1},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %e %b %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Supprimer la page</b>
Voulez-vous vraiment supprimer
la page \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Contrôle de version activé</b>

Le contrôle de version n\'est pas activé pour ce bloc-notes
Voulez-vous l\'activer ?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Le dossier n\'existe pas</b>
Le dossier : {path}
n\'existe pas, souhaitez-vous le créer ?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '\'<b>Cette page existe déjà</b>

La page \'{name}\'
existe déjà.
Voulez-vous la remplacer ?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Revenir à la version sauvegardée de la page ?</b>
Voulez-vous revenir à la version {version}
de la page {page} ?
Toutes les modifications effectuées depuis seront perdues !',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Mettre à jour les pages du calendrier au format 0.24 ?</b>

Ce bloc-notes contient des pages dates utilisant le format yyyy_mm_dd.
Depuis Zim 0.24, le format utilisé par défaut est yyyy:mm:dd, ce qui permet
de créer un espace de nom par mois.

Voulez-vous mettre à jour ce bloc-notes avec le nouveau format ?
',
  'Add \'tearoff\' strips to the menus' => 'Ajouter aux menus des pointillés pour les détacher',
  'Application show two text files side by side' => 'L\'application affiche deux fichiers texte côte à côte',
  'Application to compose email' => 'Application pour écrire des courriels',
  'Application to edit text files' => 'Application pour modifier des fichiers texte',
  'Application to open directories' => 'Application pour ouvrir les répertoires',
  'Application to open urls' => 'Application pour ouvrir les URL',
  'Attach _File|Attach external file' => 'Joindre un _fichier|Joindre un fichier extérieur',
  'Attach external files' => 'Joindre des fichiers externes',
  'Auto-format entities' => 'Formatage automatique des entités',
  'Auto-increment numbered lists' => 'Auto-incrémenter les listes numériques',
  'Auto-link CamelCase' => 'Lier automatiquement CamelCase',
  'Auto-link files' => 'Lier automatiquement les fichiers',
  'Auto-save version on close' => 'Enregistrement automatique de la version à la fermeture',
  'Auto-select words' => 'Sélectionner automatiquement les mots',
  'Automatically increment items in a numbered list' => 'Incrémente automatiquement les listes numériques',
  'Automatically link file names when you type' => 'Lier automatiquement les noms de fichiers quand vous saisissez du texte',
  'Automaticly link CamelCase words when you type' => 'Lier automatiquement les mots CamelCase pendant que vous saisissez du texte',
  'Automaticly select the current word when you toggle the format' => 'Sélectionner automatiquement le mot actuel lors du changement de format',
  'Bold' => 'Gras',
  'Calen_dar|Show calendar' => 'Calen_drier|Afficher le calendrier',
  'Calendar' => 'Agenda',
  'Can not find application "bzr"' => 'Impossible de trouver l\'application "bzr"',
  'Can not find application "{name}"' => 'Impossible de trouver l\'application "{name}"',
  'Can not save a version without comment' => 'Impossible d\'enregistrer une version sans commentaires',
  'Can not save to page: {name}' => 'Impossible d\'enregistrer la page : {name}',
  'Can\'t find {url}' => 'Impossible d\'atteindre {url}',
  'Cha_nge' => 'Mo_difier',
  'Chars' => 'Caractères',
  'Check _spelling|Spell check' => '_Vérifier l\'orthographe|Vérifier l\'orthographe',
  'Check checkbox lists recursive' => 'Cocher les cases de manière récursive',
  'Checking a checkbox list item will also check any sub-items' => 'Cocher la case d\'une entrée cochera aussi celle de toutes les sous-entrées',
  'Choose {app_type}' => 'Choisir {app_type}',
  'Co_mpare Page...' => 'Co_mparer la page...',
  'Command' => 'Commande',
  'Comment' => 'Commentaire',
  'Compare this version with' => 'Comparer cette version à',
  'Copy Email Address' => 'Copier le courriel',
  'Copy Location|Copy location' => 'Copier le chemin|Copier le chemin',
  'Copy _Link' => 'Copier le _lien',
  'Could not delete page: {name}' => 'Impossible de supprimer la page : {name}',
  'Could not get annotated source for page {page}' => 'Impossible d\'obtenir les sources annotées pour la page {page}',
  'Could not get changes for page: {page}' => 'Impossible d\'obtenir les modifications de la page : {page}',
  'Could not get changes for this notebook' => 'Impossible d\'obtenir les modifications pour ce bloc-notes',
  'Could not get file for page: {page}' => 'Impossible d\'obtenir un fichier pour la page : {page}',
  'Could not get versions to compare' => 'Impossible d\'obtenir des versions à comparer',
  'Could not initialize version control' => 'Impossible d\'activer le contrôle de version',
  'Could not load page: {name}' => 'Impossible de charger la page : {name}',
  'Could not rename {from} to {to}' => 'Impossible de renommer {from} en {to}',
  'Could not save page' => 'Impossible d\'enregistrer la page',
  'Could not save version' => 'Version impossible à enregistrer',
  'Creating a new link directly opens the page' => 'La création d\'un nouveau lien ouvre directement la nouvelle page',
  'Creation Date' => 'Date de création',
  'Cu_t|Cut' => 'Co_uper|Couper',
  'Current' => 'Actuelle',
  'Customise' => 'Personnaliser',
  'Date' => 'Date',
  'Default notebook' => 'Carnet par défaut',
  'Details' => 'Détails',
  'Diff Editor' => 'Éditeur de différences',
  'Diff editor' => 'Éditeur de différences',
  'Directory' => 'Répertoire',
  'Document Root' => 'Racine du document',
  'E_quation...|Insert equation' => 'É_quation...|Insérer une équation',
  'E_xport...|Export' => 'E_xporter...|Exporter',
  'E_xternal Link...|Insert external link' => 'Lien e_xterne|Insérer un lien externe',
  'Edit Image' => 'Modifier l\'image',
  'Edit Link' => 'Modifier le lien',
  'Edit Query' => 'Modifier la requête',
  'Edit _Source|Open source' => 'Modifier le code _source|Ouvrir le code source',
  'Edit notebook' => 'Modifier le bloc-notes',
  'Edit text files "wiki style"' => 'Modifier les fichiers textes « à la façon wiki »',
  'Editing' => 'Modification',
  'Email client' => 'Client de messagerie',
  'Enabled' => 'Actif',
  'Equation Editor' => 'Éditeur d\'équations',
  'Equation Editor Log' => 'Journal de l\'éditeur d\'équations',
  'Expand side pane' => 'Étendre le volet latéral',
  'Export page' => 'Exporter la page',
  'Exporting page {number}' => 'Exportation de la page {number}',
  'Failed to cleanup SVN working copy.' => 'Echec lors du nettoyage de la copie de travail SVN',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Echec lors du chargement du plugin SVN.
Subversion est-il installé sur votre système?',
  'Failed to load plugin: {name}' => 'Le chargement de ce greffon a échoué : {name}',
  'Failed update working copy.' => 'Echec lors de la mise à jour de la copie de travail',
  'File browser' => 'Navigateur de fichiers',
  'File is not a text file: {file}' => 'Ce fichier n\'est pas un fichier texte : {file}',
  'Filter' => 'Filtrer',
  'Find' => 'Rechercher',
  'Find Ne_xt|Find next' => 'Rechercher le _suivant|Rechercher le suivant',
  'Find Pre_vious|Find previous' => 'Rechercher le _précédent|Rechercher le précédent',
  'Find and Replace' => 'Rechercher et Remplacer',
  'Find what' => 'Rechercher',
  'Follow new link' => 'Suivre le nouveau lien',
  'For_mat|' => 'For_mat|',
  'Format' => 'Format',
  'General' => 'Général',
  'Go to "{link}"' => 'Consulter « {link} »',
  'H_idden|.' => '_Masqué|.',
  'Head _1|Heading 1' => 'Titre_1|Titre 1',
  'Head _2|Heading 2' => 'Titre_2|Titre 2',
  'Head _3|Heading 3' => 'Titre_3|Titre 3',
  'Head _4|Heading 4' => 'Titre_4|Titre 4',
  'Head _5|Heading 5' => 'Titre_5|Titre 5',
  'Head1' => 'Titre1',
  'Head2' => 'Titre2',
  'Head3' => 'Titre3',
  'Head4' => 'Titre4',
  'Head5' => 'Titre5',
  'Height' => 'Hauteur',
  'Home Page' => 'Page d\'accueil',
  'Icon' => 'Icône',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Inclure toutes les cases à cocher ouvertes',
  'Index page' => 'Page d\'index',
  'Initial version' => 'Version Initiale',
  'Insert Date' => 'Insérer la date',
  'Insert Image' => 'Insérer une image',
  'Insert Link' => 'Insérer un lien',
  'Insert from file' => 'Insérer à partir d\'un fichier',
  'Interface' => 'Interface',
  'Italic' => 'Italique',
  'Jump to' => 'Passer à',
  'Jump to Page' => 'Passer à la page',
  'Lines' => 'Lignes',
  'Links to' => 'Lien vers',
  'Match c_ase' => 'Respecter la c_asse',
  'Media' => 'Média',
  'Modification Date' => 'Date de modification',
  'Name' => 'Nom',
  'New notebook' => 'Nouveau bloc-notes',
  'New page' => 'Nouvelle page',
  'No such directory: {name}' => 'Dossier non trouvé : {name}',
  'No such file or directory: {name}' => 'Dossier ou fichier non trouvé : {name}',
  'No such file: {file}' => 'Fichier introuvable : {file}',
  'No such notebook: {name}' => 'Bloc-notes non trouvé : {name}',
  'No such page: {page}' => 'Page non trouvée : {page}',
  'No such plugin: {name}' => 'Greffon inconnu : {name}',
  'Normal' => 'Normal',
  'Not Now' => 'Pas maintenant',
  'Not a valid page name: {name}' => 'Nom de page invalide : {name}',
  'Not an url: {url}' => 'URL invalide : {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Pointer vers une page inexistante
crée automatiquement une nouvelle page.',
  'Notebook' => 'Bloc-notes',
  'Notebooks' => 'Bloc-notes',
  'Open Document _Folder|Open document folder' => 'Ouvrir le dossier du document|Ouvrir le dossier du document',
  'Open Document _Root|Open document root' => 'Ouvrir la _racine du document|Ouvrir la-racine du document',
  'Open _Directory' => 'Ouvrir le _dossier',
  'Open notebook' => 'Ouvrir un bloc-notes',
  'Other...' => 'Autre...',
  'Output' => 'Sortie',
  'Output dir' => 'Dossier de destination',
  'P_athbar type|' => 'Type de b_arre de chemin|',
  'Page' => 'Page',
  'Page Editable|Page editable' => 'Page modifiable|Page modifiable',
  'Page name' => 'Nom de la page',
  'Pages' => 'Pages',
  'Password' => 'Mot de passe',
  'Please enter a comment for this version' => 'Saisissez un commentaire pour cette version',
  'Please enter a name to save a copy of page: {page}' => 'Saisissez un nom pour enregistrer une copie de la page : {page}',
  'Please enter a {app_type}' => 'Veuillez saisir un {app_type}',
  'Please give a page first' => 'Indiquez d\'abord une page',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Merci d\'indiquer au moins un répertoire où vos pages seront enregistrées.
Pour un nouveau bloc-notes un dossier vide est nécessaire.
Par exemple un dossier « Notes » dans votre dossier personnel.',
  'Please provide the password for
{path}' => 'Veuillez fournir un mot de passe pour
{path}',
  'Please select a notebook first' => 'Sélectionnez un carnet d\'abord',
  'Please select a version first' => 'Sélectionnez d\'abord une version',
  'Plugin already loaded: {name}' => 'Greffon déjà chargé : {name}',
  'Plugins' => 'Greffons',
  'Pr_eferences|Preferences dialog' => 'Pré_férences|Boîte de dialogue des préférences',
  'Preferences' => 'Préférences',
  'Prefix document root' => 'Préfixe de document-racine',
  'Print to Browser|Print to browser' => 'Imprimer dans le navigateur|Imprimer dans le navigateur',
  'Prio' => 'Prio',
  'Proper_ties|Properties dialog' => 'Proprié_tés|Boîte de dialogue des propriétés',
  'Properties' => 'Propriétés',
  'Rank' => 'Rang',
  'Re-build Index|Rebuild index' => 'Reconstruire l\'index|Reconstruire l\'index',
  'Recursive' => 'Récursif',
  'Rename page' => 'Renommer la page',
  'Rename to' => 'Renommer en',
  'Replace _all' => 'Remplacer _tout',
  'Replace with' => 'Remplacer par',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN cleanup|Nettoyer la copie de travail',
  'SVN commit|Commit notebook to SVN repository' => 'SVN commit|Enregistrer les modifications du carnet dans le dépôt SVN',
  'SVN update|Update notebook from SVN repository' => 'SVN update|Mettre à jour le carnet depuis le dépôt SVN',
  'S_ave Version...|Save Version' => 'Enregi_strer la version...|Enregistrer la version',
  'Save Copy' => 'Enregistrer une copie',
  'Save version' => 'Enregistrer la version',
  'Scanning tree ...' => 'Lecture de l\'arborescence',
  'Search' => 'Rechercher',
  'Search _Backlinks...|Search Back links' => 'Rechercher les _rétroliens|Rechercher les rétroliens',
  'Select File' => 'Sélectionner un fichier',
  'Select Folder' => 'Sélectionner un dossier',
  'Send To...' => 'Envoyer à...',
  'Show cursor for read-only' => 'Afficher le curseur en lecture seule',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Afficher le curseur même si vous ne pouvez pas modifier la page. Cela rend plus pratique la navigation au clavier.',
  'Slow file system' => 'Système de fichiers lent',
  'Source' => 'Code Source',
  'Source Format' => 'Format de la source',
  'Start the side pane with the whole tree expanded.' => 'Ouvrir le volet latéral avec l\'arbre complètement déplié.',
  'Stri_ke|Strike' => '_Barré|Barré',
  'Strike' => 'Barré',
  'TODO List' => 'Tâches À FAIRE',
  'Task' => 'Tâche',
  'Tearoff menus' => 'Menu détachables',
  'Template' => 'Modèle',
  'Text' => 'Texte',
  'Text Editor' => 'Éditeur de texte',
  'Text _From File...|Insert text from file' => 'Texte à _partir d\'un fichier|Insérer du texte à partir d\'un fichier',
  'Text editor' => 'Éditeur de texte',
  'The equation failed to compile. Do you want to save anyway?' => 'La compilation de l\'équation a échoué. Souhaitez-vous quand même l\'enregistrer ?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'L\'équation pour l\'image : {path}
est manquante. Elle ne peut pas être modifiée.',
  'This notebook does not have a document root' => 'Ce bloc-notes n\'a pas de document-racine',
  'This page does not exist
404' => 'La page n\'existe pas
404',
  'This page does not have a document folder' => 'Cette page n\'a pas de dossier de documents',
  'This page does not have a source' => 'Cette page n\'a pas de source',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Cette page a été modifiée dans le dépôt.
Mettez à jour votre copie de travail (Outils -> SVN update).',
  'To_day|Today' => '_Aujourd\'hui|Aujourd\'hui',
  'Toggle Checkbox \'V\'|Toggle checkbox' => 'Cocher la case \'V\'|Cocher la case',
  'Toggle Checkbox \'X\'|Toggle checkbox' => 'Cocher la case \'X\'|Cocher la case',
  'Underline' => 'Souligné',
  'Updating links' => 'Mise à jour des liens',
  'Updating links in {name}' => 'Mise à jour des liens dans {name}',
  'Updating..' => 'Mise à jour...',
  'Use "Backspace" to un-indent' => 'Utiliser la touche « Retour Arrière » pour désindenter',
  'Use "Ctrl-Space" to switch focus' => 'Utilisez « Ctrl-Espace » pour basculer le focus',
  'Use "Enter" to follow links' => 'Utiliser « Entrée » pour suivre les liens',
  'Use autoformatting to type special characters' => 'Utiliser le formatage automatique pour saisir des caractères spéciaux',
  'Use custom font' => 'Utiliser une police personnalisée',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Utiliser la touche « Retour Arrière » pour désindenter (identique à « Maj+Tab »)',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Utilisez la combinaison « Ctrl+Espace » pour basculer le focus entre le text et le volet latéral. Si désactivé, vous pouvez toujours utiliser « Alt+Espace ».',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Utiliser la touche « Entrée » pour suivre les liens. Si désactivé, vous pouvez toujours utiliser la combinaison « Alt+Entrée »',
  'User' => 'Utilisateur',
  'User name' => 'Nom d\'utilisateur',
  'Verbatim' => 'Verbatim',
  'Versions' => 'Versions',
  'View _Annotated...' => '_Afficher les annotations',
  'View _Log' => 'Consulter le _journal',
  'Web browser' => 'Navigateur web',
  'Whole _word' => 'Mot _entier',
  'Width' => 'Largeur',
  'Word Count' => 'Statistiques',
  'Words' => 'Mots',
  'You can add rules to your search query below' => 'Vous pouvez ajouter des règles à votre requête de recherche ci-dessous',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Vous pouvez utiliser <b>Bazaar</b> ou <b>Subversion</b> comme système de gestion de versions.
Cliquez sur le bouton d\'aide pour en savoir plus.',
  'You have no {app_type} configured' => 'Vous n\'avez pas configuré {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => 'Vous devez redémarrer l\'application pour que
les changements de greffon prennent effet.',
  'Your name; this can be used in export templates' => 'Votre nom ; il peut être utilisé dans les modèles d\'exportation',
  'Zim Desktop Wiki' => 'Zim, le Wiki de bureau',
  '_About|About' => '_À propos|À propos',
  '_All' => '_Tous',
  '_Back|Go page back' => '_Précédent|Va à la page visitée précédente',
  '_Bold|Bold' => '_Gras|Gras',
  '_Browse...' => '_Parcourir...',
  '_Bugs|Bugs' => '_Anomalies|Anomalies',
  '_Child|Go to child page' => '_Fille|Va à la page fille',
  '_Close|Close window' => '_Fermer|Fermer la fenêtre',
  '_Contents|Help contents' => '_Sommaire|Sommaire de l\'aide',
  '_Copy Page...|Copy page' => '_Copier la page...|Copier la page',
  '_Copy|Copy' => '_Copier|Copier',
  '_Date and Time...|Insert date' => 'Date et Heure...|Insérer la date',
  '_Delete Page|Delete page' => '_Supprimer la page|Supprimer la page',
  '_Delete|Delete' => '_Supprimer|Supprimer',
  '_Discard changes' => 'Ann_uler les modifications',
  '_Edit' => '_Edition',
  '_Edit Equation' => '_Modifier l\'équation',
  '_Edit Link' => 'Mo_difier le lien',
  '_Edit Link...|Edit link' => 'Mo_difier le lien...|Modifier le lien',
  '_Edit|' => 'É_dition|',
  '_FAQ|FAQ' => '_FAQ|Foire Aux Questions',
  '_File|' => '_Fichier|',
  '_Filter' => '_Filtrer',
  '_Find...|Find' => '_Rechercher...|Rechercher',
  '_Forward|Go page forward' => '_Suivante|Va à la page visitée suivante',
  '_Go|' => '_Aller à|',
  '_Help|' => 'Aid_e|',
  '_History|.' => '_Historique|.',
  '_Home|Go home' => '_Accueil|Aller à la page d\'accueil',
  '_Image...|Insert image' => '_Image...|Insérer une image',
  '_Index|Show index' => '_Index|Afficher l\'index',
  '_Insert' => '_Insérer',
  '_Insert|' => '_Insérer|',
  '_Italic|Italic' => '_Italique|Italique',
  '_Jump To...|Jump to page' => '_Passer à...|Passer à la page',
  '_Keybindings|Key bindings' => 'Raccourcis cla_vier|Raccourcis clavier',
  '_Link' => '_Lien',
  '_Link to date' => '_Lier à une date',
  '_Link...|Insert link' => '_Lien...|Insérer un lien',
  '_Link|Link' => '_Lien|Lien',
  '_Namespace|.' => 'Espace de _noms|.',
  '_New Page|New page' => '_Nouvelle Page|Nouvelle page',
  '_Next' => '_Suivant',
  '_Next in index|Go to next page' => 'Page s_uivante dans l\'index|Va à la page suivante',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => '_Modifications du carnet...',
  '_Open Another Notebook...|Open notebook' => '_Ouvrir un autre bloc-notes...|Ouvrir un bloc-notes',
  '_Open link' => '_Ouvrir le lien',
  '_Overwrite' => 'É_craser',
  '_Page' => '_Page',
  '_Page Changes...' => 'Modifications de la _page...',
  '_Parent|Go to parent page' => '_Parent|Va à la page parent',
  '_Paste|Paste' => 'C_oller|Coller',
  '_Preview' => 'Aperçu',
  '_Previous' => '_Précédent',
  '_Previous in index|Go to previous page' => 'Page pré_cédente dans l\'index|Va à la page précédente',
  '_Properties' => '_Propriétés',
  '_Quit|Quit' => '_Quitter|Quitter',
  '_Recent pages|.' => 'Pages _récentes|.',
  '_Redo|Redo' => '_Rétablir|Rétablir',
  '_Reload|Reload page' => '_Recharger|Recharger la page',
  '_Rename' => '_Renommer',
  '_Rename Page...|Rename page' => '_Renommer la page...|Renommer la page',
  '_Replace' => 'Re_mplacer',
  '_Replace...|Find and Replace' => '_Remplacer...|Rechercher et remplacer',
  '_Reset' => '_Réinitialiser',
  '_Restore Version...' => '_Restaurer la version...',
  '_Save Copy' => '_Enregistrer la copie',
  '_Save a copy...' => 'Enregi_strer une copie...',
  '_Save|Save page' => '_Enregistrer|Enregistrer la page',
  '_Screenshot...|Insert screenshot' => '_Capture d\'écran...|Insérer une capture d\'écran',
  '_Search...|Search' => '_Rechercher...|Rechercher',
  '_Search|' => '_Rechercher|',
  '_Send To...|Mail page' => 'E_nvoyer à...|Envoyer la page',
  '_Statusbar|Show statusbar' => '_Barre d\'état|Afficher la barre d\'état',
  '_TODO List...|Open TODO List' => '_Liste des tâches à faire|Ouvrir la liste des tâches à faire',
  '_Today' => 'Au_jourd\'hui',
  '_Toolbar|Show toolbar' => '_Barre d\'outils|Afficher la barre d\'outils',
  '_Tools|' => 'Ou_tils|',
  '_Underline|Underline' => '_Souligné|Souligné',
  '_Undo|Undo' => 'Ann_uler|Annuler',
  '_Update links in this page' => '_Mettre à jour des liens de cette page',
  '_Update {number} page linking here' => [
    '_Mettre à jour {number} page référençant celle-ci',
    '_Mettre à jour les {number} pages référençant celle-ci'
  ],
  '_Verbatim|Verbatim' => '_Verbatim|Verbatim',
  '_Versions...|Versions' => '_Versions...|Versions',
  '_View|' => '_Affichage|',
  '_Word Count|Word count' => 'Statisti_ques|Statistiques',
  'other...' => 'autre...',
  '{name}_(Copy)' => '{name}_(Copie)',
  '{number} _Back link' => [
    '{number} _rétrolien',
    '{number} _rétroliens'
  ],
  '{number} item total' => [
    '{number} élement en tout',
    '{number} élements en tout'
  ]
};
