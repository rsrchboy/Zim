# Galician translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Miguel Anxo Bouzada (gl)
# Roberto Suarez (gl)
# marisma (gl)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-11-18 01:39+0000
# Last-Translator: Miguel Anxo Bouzada <mbouzada@gmail.com>
# Language-Team: Galician <gl@li.org>
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
page \'{name}\' ?' => '<b>Borrar a páxina</b>

Está seguro de querer borrar
a páxina «{name}»?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Activar o control de versións</b>

O control de versións non está activado para este caderno de notas
Quere activalo?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>O cartafol non existe.</b>

O cartafol {path}
non existe, quere crealo agora?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>A páxina xa existe</b>

A páxina «{name}»
xa existe.
Desexa sobrescribila?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Restaurar a páxina á versión gardada?</b>

Quere restaurar a páxina: {page}
á versión gardada: {version}?

Todos os cambios desde a última versión gardada hanse perder!',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Actualizar as páxinas do calendario ao formato da versión 0.24?</b>

Este caderno contén páxinas para datas que usan o formato aaaa_mm_dd.
Dende Zim 0.24 úsase o formato aaaa:mm:dd como predefinido, creando
nomes de espazo por mes.

Desexa actualizar este caderno ao novo esquema?
',
  'Add \'tearoff\' strips to the menus' => 'Engadir barras para desprender os menús',
  'Application show two text files side by side' => 'Aplicativo para amosar dous ficheiros de texto simultaneamente',
  'Application to compose email' => 'Aplicativo de correo-e',
  'Application to edit text files' => 'Aplicativo para editar ficheiros de texto',
  'Application to open directories' => 'Aplicativo para abrir directorios',
  'Application to open urls' => 'Aplicativo para abrir urls',
  'Attach _File|Attach external file' => 'Anexar _ficheiro|Anexar un ficheiro externo',
  'Attach external files' => 'Adxuntar ficheiros externos',
  'Auto-format entities' => 'Formato automático de entidades',
  'Auto-increment numbered lists' => 'Incrementar automáticamente as listas enumeradas',
  'Auto-link CamelCase' => 'Auto-ligar CamelCase',
  'Auto-link files' => 'Auto-ligar ficheiros',
  'Auto-save version on close' => 'Gardar a versión automáticamente ao saír',
  'Auto-select words' => 'Seleccionar palabras automáticamente',
  'Automatically increment items in a numbered list' => 'Incrementar automáticamente os artigos nunha lista enumerada',
  'Automatically link file names when you type' => 'Ligar ficheiros automáticamente cando se escriben',
  'Automaticly link CamelCase words when you type' => 'Ligar automáticamente as palabras en CamelCase cando se escriben',
  'Automaticly select the current word when you toggle the format' => 'Seleccionar automáticamente a palabra actual cando cambia o formato',
  'Bold' => 'Negriña',
  'Calen_dar|Show calendar' => 'Calen_dario|Amosar calendario',
  'Calendar' => 'Calendario',
  'Can not find application "bzr"' => 'Non se atopa o aplicativo "bzr"',
  'Can not find application "{name}"' => 'Non se atopa o aplicativo "{name}"',
  'Can not save a version without comment' => 'Non está permitido gardar unha versión sen comentario',
  'Can not save to page: {name}' => 'Non se puido gardar á páxina: {name}',
  'Can\'t find {url}' => 'Non se pode atopar {url}',
  'Cha_nge' => 'Ca_mbiar',
  'Chars' => 'Caracteres',
  'Check _spelling|Spell check' => 'Comprobar _ortografía|Comprobación da ortografía',
  'Check checkbox lists recursive' => 'Revisa a lista "Caixa de verificación" recursiva',
  'Checking a checkbox list item will also check any sub-items' => 'Revisando un elemento da lista "Caixa de verificación", tamén revisará calquera sub-elemento',
  'Choose {app_type}' => 'Escolla {app_type}',
  'Co_mpare Page...' => 'Co_mparar a páxina...',
  'Command' => 'Orde',
  'Comment' => 'Comentario',
  'Compare this version with' => 'Comparar esta versión con',
  'Copy Email Address' => 'Copiar o enderezo de correo-e',
  'Copy Location|Copy location' => 'Copiar a ligazón|Copiar a ligazón',
  'Copy _Link' => 'Copiar a _ligazón',
  'Could not delete page: {name}' => 'Non foi posible borrar a páxina: {name}',
  'Could not get annotated source for page {page}' => 'Non foi posible recuperar a orixe anotada para a páxina {page}',
  'Could not get changes for page: {page}' => 'Non foi posible recuperar os cambios para a páxina: {page}',
  'Could not get changes for this notebook' => 'Non se puideron obter cambios para este caderno de notas',
  'Could not get file for page: {page}' => 'Non foi posible recuperar o ficheiro para a páxina: {page}',
  'Could not get versions to compare' => 'Non foi posible recuperar as versións para comparar',
  'Could not initialize version control' => 'Non foi posible inicializar o sistema de control de versións',
  'Could not load page: {name}' => 'Non se puido cargar a páxina: {name}',
  'Could not rename {from} to {to}' => 'Non foi posible cambiar o nome de {from} a {to}',
  'Could not save page' => 'Non foi posible gardar a páxina',
  'Could not save version' => 'Non foi posible gardar a versión',
  'Creating a new link directly opens the page' => 'Crear unha nova ligazón abre directamente a páxina',
  'Creation Date' => 'Data de creación',
  'Cu_t|Cut' => '_Cortar|Cortar',
  'Current' => 'Actual',
  'Customise' => 'Personalizar',
  'Date' => 'Data',
  'Default notebook' => 'Caderno de notas predeterminado',
  'Details' => 'Detalles',
  'Diff Editor' => 'Editor de diferencias',
  'Diff editor' => 'Editor de diferencias',
  'Directory' => 'Directorio',
  'Document Root' => 'Documento pai',
  'E_quation...|Insert equation' => 'E_cuación...|Inserir ecuación',
  'E_xport...|Export' => 'E_xportar...|Exportar',
  'E_xternal Link...|Insert external link' => 'Ligazón e_xterno...|Inserir unha ligazón externa',
  'Edit Image' => 'Editar imaxe',
  'Edit Link' => 'Editar a ligazón',
  'Edit Query' => 'Editar consulta',
  'Edit _Source|Open source' => 'Ed_itar a orixe|Abrir a orixe',
  'Edit notebook' => 'Editar o caderno de notas',
  'Edit text files "wiki style"' => 'Editor de texto "ó xeito Wiki"',
  'Editing' => 'Editando',
  'Email client' => 'Programa de correo-e',
  'Enabled' => 'Activado',
  'Equation Editor' => 'Editor de ecuacións',
  'Equation Editor Log' => 'Rexistro do Editor de ecuacións',
  'Expand side pane' => 'Expandir panel lateral',
  'Export page' => 'Exportar páxina',
  'Exporting page {number}' => 'Exportando a páxina {number}',
  'Failed to cleanup SVN working copy.' => 'Fallou ao limpar a copia de traballo  no SVN.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Fallou ao cargar o engadido SVN,
ten instaladas as utilidades de subversión?',
  'Failed to load plugin: {name}' => 'Fallou a carga do engadido: {name}',
  'Failed update working copy.' => 'Fallou ao actualizar a copia de traballo.',
  'File browser' => 'Navegador de ficheiros',
  'File is not a text file: {file}' => 'O ficheiro non é un ficheiro de texto: {file}',
  'Filter' => 'Filtrar',
  'Find' => 'Buscar',
  'Find Ne_xt|Find next' => 'Buscar _seguinte|Buscar seguinte',
  'Find Pre_vious|Find previous' => 'Buscar _anterior|Buscar anterior',
  'Find and Replace' => 'Buscar e substituír',
  'Find what' => 'Palabras a atopar',
  'Follow new link' => 'Seguir unha nova ligazón',
  'For_mat|' => 'For_mato|',
  'Format' => 'Formato',
  'General' => 'Xeral',
  'Go to "{link}"' => 'Ir a "{link}"',
  'H_idden|.' => 'A_gochado|.',
  'Head _1|Heading 1' => 'Cabeceira _1|Cabeceira 1',
  'Head _2|Heading 2' => 'Cabeceira _2|Cabeceira 2',
  'Head _3|Heading 3' => 'Cabeceira _3|Cabeceira 3',
  'Head _4|Heading 4' => 'Cabeceira _4|Cabeceira 4',
  'Head _5|Heading 5' => 'Cabeceira _5|Cabeceira 5',
  'Head1' => 'Cabeceira1',
  'Head2' => 'Cabeceira2',
  'Head3' => 'Cabeceira3',
  'Head4' => 'Cabeceira4',
  'Head5' => 'Cabeceira5',
  'Height' => 'Altura',
  'Home Page' => 'Páxina de inicio',
  'Icon' => 'Icona',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Incluir todas as "Caixas de verificación" abertas',
  'Index page' => 'Páxina de índice',
  'Initial version' => 'Versión inicial',
  'Insert Date' => 'Inserir data',
  'Insert Image' => 'Inserir unha imaxe',
  'Insert Link' => 'Inserir unha ligazón',
  'Insert from file' => 'Inserir desde un ficheiro',
  'Interface' => 'Interface',
  'Italic' => 'Cursiva',
  'Jump to' => 'Ir a',
  'Jump to Page' => 'Ir a Páxina',
  'Lines' => 'Liñas',
  'Links to' => 'Ligazóns a',
  'Match c_ase' => '_Distinguir maiúsculas e minúsculas',
  'Media' => 'Medio',
  'Modification Date' => 'Data de modificación',
  'Name' => 'Nome',
  'New notebook' => 'Novo caderno de notas',
  'New page' => 'Nova páxina',
  'No such directory: {name}' => 'Non hai tal directorio: {name}',
  'No such file or directory: {name}' => 'Non hai tal ficheiro ou directorio: {name}',
  'No such file: {file}' => 'Non hai tal ficheiro: {file}',
  'No such notebook: {name}' => 'Non hai tal caderno de notas: {name}',
  'No such page: {page}' => 'Non existe tal páxina: {page}',
  'No such plugin: {name}' => 'Non hai tal engadido: {name}',
  'Normal' => 'Normal',
  'Not Now' => 'Agora non',
  'Not a valid page name: {name}' => 'Non é un nome correcto de páxina: {name}',
  'Not an url: {url}' => 'Non é un url correcto: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Lembre que enlazar a unha páxina non existente
crea unha nova páxina.',
  'Notebook' => 'Caderno de Notas',
  'Notebooks' => 'Cadernos de notas',
  'Open Document _Folder|Open document folder' => 'Abrir o _cartafol de documentos|Abrir o cartafol de documentos',
  'Open Document _Root|Open document root' => 'Ab_rir o documento pai|Abrir o documento pai',
  'Open _Directory' => 'Abrir o _directorio',
  'Open notebook' => 'Abrir caderno de notas',
  'Other...' => 'Outro...',
  'Output' => 'Saída',
  'Output dir' => 'Directorio de saída',
  'P_athbar type|' => 'Tipo de b_arra de rutas',
  'Page' => 'Páxina',
  'Page Editable|Page editable' => 'Páxina editable|Páxina editable',
  'Page name' => 'Nome da páxina',
  'Pages' => 'Páxinas',
  'Password' => 'Contrasinal',
  'Please enter a comment for this version' => 'Por favor, introduza un comentario para esta versión',
  'Please enter a name to save a copy of page: {page}' => 'Por favor, introduza un nome para gardar a copia da páxina: {page}',
  'Please enter a {app_type}' => 'Por favor, introduza un {app_type}',
  'Please give a page first' => 'Por favor, introduza unha páxina primeiro',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Indique como mínimo un directorio onde gardar as súas páxinas.
Para un novo caderno de notas isto debería ser un directorio baleiro.
Por exemplo, un directorio chamado «Notas» no seu directorio persoal.',
  'Please provide the password for
{path}' => 'Precisa introducir o contrasinal para
{path}',
  'Please select a notebook first' => 'Por favor, seleccione un caderno de notas primeiro',
  'Please select a version first' => 'Seleccione unha versión primeiro',
  'Plugin already loaded: {name}' => 'Engadido xa cargado: {name}',
  'Plugins' => 'Engadidos',
  'Pr_eferences|Preferences dialog' => 'Pre_ferencias|Preferencias',
  'Preferences' => 'Preferencias',
  'Prefix document root' => 'Prefixo do documento pai',
  'Print to Browser|Print to browser' => 'Imprimir ao navegador|Imprimir ao navegador',
  'Prio' => 'Prioridade',
  'Proper_ties|Properties dialog' => 'Propie_dades|Propiedades',
  'Properties' => 'Propiedades',
  'Rank' => 'Clasificación',
  'Re-build Index|Rebuild index' => 'Reconstruir o índice|Reconstruir o índice',
  'Recursive' => 'Recursivo',
  'Rename page' => 'Renomear a páxina',
  'Rename to' => 'Renomear como',
  'Replace _all' => 'Substituír _todo',
  'Replace with' => 'Substituír por',
  'SVN cleanup|Cleanup SVN working copy' => 'Limpar o SVN|Limpar as copias de traballo do SVN',
  'SVN commit|Commit notebook to SVN repository' => 'Enviar a SVN|Enviar o caderno de notas ao repositorio SVN',
  'SVN update|Update notebook from SVN repository' => 'Actualizar SVN|Actualizar o caderno de notas desde o repositorio SVN',
  'S_ave Version...|Save Version' => '_Gardar a versión...|Gardar a versión',
  'Save Copy' => 'Gardar unha copia',
  'Save version' => 'Gardar a versión',
  'Scanning tree ...' => 'Buscando na árbore...',
  'Search' => 'Buscar',
  'Search _Backlinks...|Search Back links' => '_Buscar ligazóns cara atrás...|Buscar ligazóns cvara atrás',
  'Select File' => 'Escoller un ficheiro',
  'Select Folder' => 'Escoller un cartafol',
  'Send To...' => 'Enviar a...',
  'Show cursor for read-only' => 'Amosar o cursor en modo de só lectura',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Amosar o cursor aínda que non se poida editar a páxina.
Isto é útil para navegar usando o teclado.',
  'Slow file system' => 'Sistema de ficheiros lento',
  'Source' => 'Orixe',
  'Source Format' => 'Formato orixinal',
  'Start the side pane with the whole tree expanded.' => 'Comezar coa árbore do panel lateral expandida',
  'Stri_ke|Strike' => '_Tachado|Tachado',
  'Strike' => 'Tachado',
  'TODO List' => 'Lista de tarefas',
  'Task' => 'Tarefa',
  'Tearoff menus' => 'Menús desprendibles',
  'Template' => 'Modelo',
  'Text' => 'Texto',
  'Text Editor' => 'Editor de texto',
  'Text _From File...|Insert text from file' => 'Texto desde _ficheiro...|Inserir texto desde un ficheiro',
  'Text editor' => 'Editor de textos',
  'The equation failed to compile. Do you want to save anyway?' => 'Fallou a compilación da ecuación. Desexa gardar aínda así?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'A ecuación para a imaxe: {path}
non existe. Non se pode editar a ecuación.',
  'This notebook does not have a document root' => 'Este caderno de notas non ten un documento pai',
  'This page does not exist
404' => 'Esta páxina non existe
404',
  'This page does not have a document folder' => 'Esta páxina non ten un cartafol de documentos',
  'This page does not have a source' => 'Esta páxina non ten orixe',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Esta páxina foie actualizada no repositorio
Por favor actualice a súa copia de traballo (Ferramentas -> Actualizar SVN).',
  'To_day|Today' => '_Hoxe|Hoxe',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Alternar Chechbox «V»|Alternar checkbox',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Alternar Chechbox «X»|Alternar checkbox',
  'Underline' => 'Subliñado',
  'Updating links' => 'Actualizando ligazóns',
  'Updating links in {name}' => 'Actualizando ligazóns en {name}',
  'Updating..' => 'Actualizando ...',
  'Use "Backspace" to un-indent' => 'Usar "Espazo atrás" para quitar a sangría',
  'Use "Ctrl-Space" to switch focus' => 'Usar "Ctrl-Espazo" para cambiar o enfoque',
  'Use "Enter" to follow links' => 'Usar "Enter" para seguir ligazóns',
  'Use autoformatting to type special characters' => 'Usar formato automático para teclear caracteres especiais',
  'Use custom font' => 'Usar un tipo de letra personalizado',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Usar a tecla de "Espazo atrás" para quitar a sangría das listas de puntos (o mesmo que "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Use a combinación "Ctrl-Espazo" para cambiar o enfoque entre o texto e o panel lateral.
Se non se activa esta opción, sempre pode usar "Alt-Espazo".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Use a tecla "Enter" para seguir ligazóns. Se non se activa esta opción,
sempre pode usar "Alt-Enter".',
  'User' => 'Usuario',
  'User name' => 'Nome de usuario',
  'Verbatim' => 'Literal',
  'Versions' => 'Versións',
  'View _Annotated...' => 'Ver _anotacións...',
  'View _Log' => 'Ver _rexistro',
  'Web browser' => 'Navegador web',
  'Whole _word' => 'Palabras _enteiras',
  'Width' => 'Anchura',
  'Word Count' => 'Contador de palabras',
  'Words' => 'Palabras',
  'You can add rules to your search query below' => 'Pode engadir regras para a súa consulta abaixo',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Para o control de versións pode elexir entre <b>Bazaar</b> ou <b>Subversion</b>,
Faga clic en «Axuda» para ler sobre os requisitos do sistema.',
  'You have no {app_type} configured' => 'Non ten un {app_type} configurado',
  'You need to restart the application
for plugin changes to take effect.' => 'Necesita reiniciar o aplicativo
para que os cambios dos engadidos
teñan efecto.',
  'Your name; this can be used in export templates' => 'O seu nome; isto pode ser usado nos patróns de exportación',
  'Zim Desktop Wiki' => 'Wiki persoal Zim',
  '_About|About' => '_Acerca de|Acerca do aplicativo',
  '_All' => '_Todo',
  '_Back|Go page back' => 'A_trás|Ir á páxina anterior',
  '_Bold|Bold' => 'N_egriña|Negriña',
  '_Browse...' => 'E_xaminar...',
  '_Bugs|Bugs' => '_Erros|Erros do aplicativo',
  '_Child|Go to child page' => '_Descender|Ir á páxina inferior',
  '_Close|Close window' => 'Pe_char|Pechar a ventá',
  '_Contents|Help contents' => '_Contidos|Contidos da axuda',
  '_Copy Page...|Copy page' => '_Copiar a páxina...|Copiar a páxina',
  '_Copy|Copy' => '_Copiar|Copiar',
  '_Date and Time...|Insert date' => '_Data e hora...|Inserir data',
  '_Delete Page|Delete page' => 'E_liminar a páxina|Eliminar a páxina',
  '_Delete|Delete' => '_Borrar|Borrar',
  '_Discard changes' => '_Desbotar os cambios',
  '_Edit' => '_Editar',
  '_Edit Equation' => '_Editar ecuación',
  '_Edit Link' => '_Editar ligazón',
  '_Edit Link...|Edit link' => '_Editar ligazón...|Editar ligazón',
  '_Edit|' => '_Editar|',
  '_FAQ|FAQ' => '_FAQ|Preguntas máis frecuentes',
  '_File|' => '_Ficheiro|',
  '_Filter' => '_Filtrar',
  '_Find...|Find' => '_Buscar...|Buscar',
  '_Forward|Go page forward' => 'A_diante|Ir á páxina seguinte',
  '_Go|' => 'I_r|',
  '_Help|' => '_Axuda|',
  '_History|.' => '_Historial|.',
  '_Home|Go home' => '_Inicio|Ir á páxina de inicio',
  '_Image...|Insert image' => '_Imaxe...|Inserir imaxe',
  '_Index|Show index' => 'Í_ndice|Amosar o índice',
  '_Insert' => '_Inserir',
  '_Insert|' => '_Inserir|',
  '_Italic|Italic' => '_Cursiva|Cursiva',
  '_Jump To...|Jump to page' => '_Ir a...|Ir á páxina',
  '_Keybindings|Key bindings' => 'Ata_llos de teclado|Atallos de teclado',
  '_Link' => '_Ligazón',
  '_Link to date' => '_Ligar á data',
  '_Link...|Insert link' => '_Ligazón...|Inserir ligazón',
  '_Link|Link' => '_Ligazón|Ligazón',
  '_Namespace|.' => 'Espazo de _nomes|.',
  '_New Page|New page' => '_Nova páxina|Nova páxina',
  '_Next' => '_Seguinte',
  '_Next in index|Go to next page' => '_Seguinte no índice|Ir á seguinte páxina',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => 'Cambios no _caderno de notas...',
  '_Open Another Notebook...|Open notebook' => 'Abrir _outro caderno de notas...|Abrir un caderno de notas',
  '_Open link' => 'Abrir a _ligazón',
  '_Overwrite' => 'S_obrescribir',
  '_Page' => '_Páxina',
  '_Page Changes...' => 'Cambios na _páxina',
  '_Parent|Go to parent page' => '_Subir|Ir á páxina superior',
  '_Paste|Paste' => '_Pegar|Pegar',
  '_Preview' => 'Vista _previa',
  '_Previous' => '_Anterior',
  '_Previous in index|Go to previous page' => '_Anterior no índice|Ir á páxina anterior',
  '_Properties' => '_Propiedades',
  '_Quit|Quit' => '_Saír|Saír',
  '_Recent pages|.' => 'Páxinas recentes|.',
  '_Redo|Redo' => '_Refacer|Refacer',
  '_Reload|Reload page' => 'Actualiza_r|Actualizar a páxina',
  '_Rename' => '_Renomear',
  '_Rename Page...|Rename page' => '_Renomear a páxina...|Renomear a páxina',
  '_Replace' => '_Substituír',
  '_Replace...|Find and Replace' => '_Substituir...|Procurar e substituir',
  '_Reset' => '_Restablecer',
  '_Restore Version...' => '_Restablecer a versión...',
  '_Save Copy' => '_Gardar unha copia',
  '_Save a copy...' => '_Gardar unha copia...',
  '_Save|Save page' => '_Gardar|Gardar a páxina',
  '_Screenshot...|Insert screenshot' => 'Captura de _pantalla...|Inserir captura de pantalla',
  '_Search...|Search' => 'Bu_scar...|Buscar',
  '_Search|' => '_Buscar|',
  '_Send To...|Mail page' => 'En_viar a...|Enviar a páxina por correo electrónico',
  '_Statusbar|Show statusbar' => 'Barra de e_stado|Amosar a barra de estado',
  '_TODO List...|Open TODO List' => 'Lista de _tarefas...|Abrir a lista de tarefas',
  '_Today' => '_Hoxe',
  '_Toolbar|Show toolbar' => 'Barra de ferramen_tas|Amosar a barra de ferramentas',
  '_Tools|' => 'Ferramen_tas|',
  '_Underline|Underline' => '_Subliñado|Subliñado',
  '_Undo|Undo' => '_Desfacer|Desfacer',
  '_Update links in this page' => 'Actualizar _ligazóns nesta páxina',
  '_Update {number} page linking here' => [
    '_Actualizar {number} páxina que liga aquí',
    '_Actualizar {number} páxinas que ligan aquí'
  ],
  '_Verbatim|Verbatim' => '_Literal|Literal',
  '_Versions...|Versions' => '_Versións...|Versións',
  '_View|' => '_Ver|',
  '_Word Count|Word count' => '_Contar palabras|Contar palabras',
  'other...' => 'outro...',
  '{name}_(Copy)' => '{name}_(Copia)',
  '{number} _Back link' => [
    '{number} ligazón _cara atrás',
    '{number} ligazóns _cara atrás'
  ],
  '{number} item total' => [
    '{number} elemento en total',
    '{number} elementos en total'
  ]
};
