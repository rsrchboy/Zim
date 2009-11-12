# Spanish translation for zim
# Copyright (c) 2007 Rosetta Contributors and Canonical Ltd 2007
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2007.
# 
# 
# TRANSLATORS:
# Andrés Rassol (es)
# Javier Rovegno Campos (es)
# Paco Molinero (es)
# Servilio Afre Puentes (es)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-01-04 01:23+0000
# Last-Translator: Takmadeus <takmadeus@gmail.com>
# Language-Team: Spanish <es@li.org>
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
  '%a %b %e %Y' => '%a %e %b %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Borrar la página</b>

¿Está usted seguro de borrar
la página \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Habilitar Control de Versiones</b>

El control de versiones no esta habilitado en este momento para este cuaderno de notas.
¿Quiere habilitarlo?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>La carpeta no existe</b>

La carpeta: {path}
no existe, ¿Quiere crearla ahora?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Página ya existe</b>

La página \'{name}\'
ya existe.
¿Quiere usted sobreescribirla?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>¿Restaurar página a la versión guardada?</b>

¿Quiere usted restaurar la página: {page}
a la versión guardada: {version} ?

¡Todos los cambios desde la última versión guardada se perderán !',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>¿Actualizar las páginas de calendario al formato 0.24?</b>

Este bloc de notas contiene páginas para fechas que usan el formato aaaa_mm_dd.
Desde Zim 0.24 el formato aaaa:mm:dd es usado por defecto, creando
espacios de nombres por mes.

¿Desea actualizar este bloc de notas al nuevo formato?
',
  'Add \'tearoff\' strips to the menus' => 'Agregar \'barra de herramientas\' a los menús',
  'Application show two text files side by side' => 'La aplicación muestra dos archivos de texto uno junto al otro',
  'Application to compose email' => 'Aplicación para escribir correo electrónico',
  'Application to edit text files' => 'Aplicación para editar archivos de texto',
  'Application to open directories' => 'Aplicación para abrir directorios',
  'Application to open urls' => 'Aplicación para abrir urls',
  'Attach _File|Attach external file' => 'Adjuntar _Archivo|Adjuntar archivo externo',
  'Attach external files' => 'Adjuntar archivos externos',
  'Auto-format entities' => 'Auto-formatear entidades',
  'Auto-increment numbered lists' => 'Listas numeradas con auto-incremento',
  'Auto-link CamelCase' => 'Auto-enlazar CamelCase',
  'Auto-link files' => 'Auto-enlazar archivos',
  'Auto-save version on close' => 'Auto-guardar versión al cerrar',
  'Auto-select words' => 'Autoseleccionar palabras',
  'Automatically increment items in a numbered list' => 'Incrementar elementos automáticamente en una lista numerada',
  'Automatically link file names when you type' => 'Vincular automáticamente los nombres cuando los escriba',
  'Automaticly link CamelCase words when you type' => 'Enlazar automáticamente palabras CamelCase cuando se escriben',
  'Automaticly select the current word when you toggle the format' => 'Selecciona automáticamente la palabra actual cuando cambia el formato',
  'Bold' => 'Negrita',
  'Calen_dar|Show calendar' => 'Calen_dario|Mostrar calendario',
  'Calendar' => 'Calendario',
  'Can not find application "bzr"' => 'No se encontró la aplicación "bzr"',
  'Can not find application "{name}"' => 'No se puede encontrar la aplicación "{name}"',
  'Can not save a version without comment' => 'No se puede guardar una versión sin comentario',
  'Can not save to page: {name}' => 'No se puede guardar en la página: {name}',
  'Can\'t find {url}' => 'No se puede encontrar {url}',
  'Cha_nge' => 'Ca_mbiar',
  'Chars' => 'Caracteres',
  'Check _spelling|Spell check' => 'Revisar _ortografía|Revisar ortografía',
  'Check checkbox lists recursive' => 'Revisa la lista checkbox recursiva',
  'Checking a checkbox list item will also check any sub-items' => 'Revisando un ítem de lista checkbox, también revisará cualquier sub-ítem',
  'Choose {app_type}' => 'Elejir {app_type}',
  'Co_mpare Page...' => 'Co_mparar Página...',
  'Command' => 'Orden',
  'Comment' => 'Comentario',
  'Compare this version with' => 'Comparar esta versión con',
  'Copy Email Address' => 'Copiar dirección de correo electrónico',
  'Copy Location|Copy location' => 'Copiar enlace|Copiar enlace',
  'Copy _Link' => 'Copiar víncu _lo',
  'Could not delete page: {name}' => 'No se puede borrar la página: {name}',
  'Could not get annotated source for page {page}' => 'No se pudo obtener la fuente anotada para la página {page}',
  'Could not get changes for page: {page}' => 'No se pudieron obtener los cambios para la página: {page}',
  'Could not get changes for this notebook' => 'No pudo obtener cambios para este cuaderno',
  'Could not get file for page: {page}' => 'No se pudo obtener el archivo para la página: {page}',
  'Could not get versions to compare' => 'No se pudieron obtener las versiones a comparar',
  'Could not initialize version control' => 'No se pudo inicializar el control de versiones',
  'Could not load page: {name}' => 'No se puede cargar la página: {name}',
  'Could not rename {from} to {to}' => 'No se puede renombrar de {from} a {to}',
  'Could not save page' => 'No se puede guardar la página',
  'Could not save version' => 'No se pudo guardar la versión',
  'Creating a new link directly opens the page' => 'Creando un nuevo vínculo se abre directamente la página',
  'Creation Date' => 'Fecha de Creación',
  'Cu_t|Cut' => 'Cor_tar|Cortar',
  'Current' => 'Actual',
  'Customise' => 'Modificar',
  'Date' => 'Fecha',
  'Default notebook' => 'Cuaderno por omisión',
  'Details' => 'Detalles',
  'Diff Editor' => 'Editor Diff',
  'Diff editor' => 'Editor diff',
  'Directory' => 'Directorio',
  'Document Root' => 'Documento raíz',
  'E_quation...|Insert equation' => 'E_cuación...|Insertar ecuación',
  'E_xport...|Export' => 'E_xportar...|Exportar',
  'E_xternal Link...|Insert external link' => 'Enlace E_xterno...|Insertar enlace externo',
  'Edit Image' => 'Editar imagen',
  'Edit Link' => 'Editar enlace',
  'Edit Query' => 'Editar Consulta',
  'Edit _Source|Open source' => 'Editar _fuente|Abrir fuente',
  'Edit notebook' => 'Editar cuaderno de notas',
  'Edit text files "wiki style"' => 'Editar archivos de texto "estilo wiki"',
  'Editing' => 'Editando',
  'Email client' => 'Cliente de correo electrónico',
  'Enabled' => 'Habilitado',
  'Equation Editor' => 'Editor de ecuaciones',
  'Equation Editor Log' => 'Registro del editor de ecuaciones',
  'Expand side pane' => 'Expander panel lateral',
  'Export page' => 'Exportar página',
  'Exporting page {number}' => 'Exportar página {number}',
  'Failed to cleanup SVN working copy.' => 'Falló limpiar la copia de trabajo SVN.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Falló cargar SVN plugin,
¿Tiene instaladas las utilidades de subversion?',
  'Failed to load plugin: {name}' => 'Fallo al cargar el complemento: {name}',
  'Failed update working copy.' => 'Falló actualizar la copia de trabajo.',
  'File browser' => 'Explorador de archivos',
  'File is not a text file: {file}' => 'El archivo no es de texto: {file}',
  'Filter' => 'Filtrar',
  'Find' => 'Buscar',
  'Find Ne_xt|Find next' => 'Buscar si_giuiente|Buscar siguiente',
  'Find Pre_vious|Find previous' => 'Buscar pre_vio|Buscar previo',
  'Find and Replace' => 'Encontrar y reemplazar',
  'Find what' => 'Econtrar qué',
  'Follow new link' => 'Seguir vínculo nuevo',
  'For_mat|' => 'For_mato|',
  'Format' => 'Dar formato',
  'General' => 'General',
  'Go to "{link}"' => 'Ir a "{link}"',
  'H_idden|.' => 'O_cultar|.',
  'Head _1|Heading 1' => 'Encabezado _1|Encabezado 1',
  'Head _2|Heading 2' => 'Encabezado _2|Encabezado 2',
  'Head _3|Heading 3' => 'Encabezado _3|Encabezado 3',
  'Head _4|Heading 4' => 'Encabezado _4|Encabezado 4',
  'Head _5|Heading 5' => 'Encabezado _5|Encabezado 5',
  'Head1' => 'Encabezado1',
  'Head2' => 'Encabezado2',
  'Head3' => 'Encabezado3',
  'Head4' => 'Encabezado4',
  'Head5' => 'Encabezado5',
  'Height' => 'Altura',
  'Home Page' => 'Página personal',
  'Icon' => 'Icono',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Incluye todas las checkboxes abiertas',
  'Index page' => 'Índice de páginas',
  'Initial version' => 'Versión inicial',
  'Insert Date' => 'Insertar fecha',
  'Insert Image' => 'Insertar imagen',
  'Insert Link' => 'Inserta un vínculo',
  'Insert from file' => 'Insertar desde archivo',
  'Interface' => 'Interfaz',
  'Italic' => 'Cursiva',
  'Jump to' => 'Saltar a',
  'Jump to Page' => 'Saltar a página',
  'Lines' => 'Líneas',
  'Links to' => 'Víncular a',
  'Match c_ase' => 'Coincidir m_ayúsculas y minúsculas',
  'Media' => 'Media',
  'Modification Date' => 'Fecha de Modificación',
  'Name' => 'Nombre',
  'New notebook' => 'Cuaderno de notas nuevo',
  'New page' => 'Página nueva',
  'No such directory: {name}' => 'No es un directorio: {name}',
  'No such file or directory: {name}' => 'Archivo o directorio no encontrado : {name}',
  'No such file: {file}' => 'No es un archivo: {file}',
  'No such notebook: {name}' => 'Cuaderno de notas no encontrado: {name}',
  'No such page: {page}' => 'Página no encontrada: {page}',
  'No such plugin: {name}' => 'Complemento no encontrado: {name}',
  'Normal' => 'Normal',
  'Not Now' => 'Ahora no',
  'Not a valid page name: {name}' => 'No es un nombre de página válido: {name}',
  'Not an url: {url}' => 'No es un url: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Tenga en cuenta que el vínculo a una página
inexistente, crea automáticamente una nueva página.',
  'Notebook' => 'Cuaderno',
  'Notebooks' => 'Cuadernos de notas',
  'Open Document _Folder|Open document folder' => 'Abrir _Carpeta de Documentos|Abrir carpeta de documentos',
  'Open Document _Root|Open document root' => 'Abrir _Raíz de Documentos|Abrir raíz de documentos',
  'Open _Directory' => 'Abrir _directorio',
  'Open notebook' => 'Abrir cuaderno de notas',
  'Other...' => 'Otros…',
  'Output' => 'Salida',
  'Output dir' => 'Directorio de salida',
  'P_athbar type|' => 'Tipo de b_arra de ruta|',
  'Page' => 'Página',
  'Page Editable|Page editable' => 'Página Editable|Página editable',
  'Page name' => 'Nombre de página',
  'Pages' => 'Páginas',
  'Password' => 'Contraseña',
  'Please enter a comment for this version' => 'Por favor, entre un comentario para esta versión',
  'Please enter a name to save a copy of page: {page}' => 'Por favor, entre un nombre para guardar una copia de la página: {page}',
  'Please enter a {app_type}' => 'Introduzca {app_type}',
  'Please give a page first' => 'Por favor, provea una página primero',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Por favor dé al menos un directorio para almacenar sus páginas.
Para un nuevo bloc de notas este debería ser un directorio vacío.
Por ejemplo un directorio "Notas" en su carpeta personal.',
  'Please provide the password for
{path}' => 'Por favor ingrese la contraseña para
{path}',
  'Please select a notebook first' => 'Por favor, selecciones un cuaderno primero',
  'Please select a version first' => 'Por favor, seleccione una versión primero',
  'Plugin already loaded: {name}' => 'Complemento ya cargado: {name}',
  'Plugins' => 'Extensiones',
  'Pr_eferences|Preferences dialog' => 'Pr_eferencias|Diálogo de preferencias',
  'Preferences' => 'Preferencias',
  'Prefix document root' => 'Prefijo del documento raíz',
  'Print to Browser|Print to browser' => 'Imprimir en el navegador|Imprimir en el navegador',
  'Prio' => 'Prioridad',
  'Proper_ties|Properties dialog' => 'Propie_dades|Diálogo de propiedades',
  'Properties' => 'Propiedades',
  'Rank' => 'Categoría',
  'Re-build Index|Rebuild index' => 'Reconstruir índice|Reconstruir índice',
  'Recursive' => 'Recursivo',
  'Rename page' => 'Renombrar página',
  'Rename to' => 'Renombrar a',
  'Replace _all' => 'Reemplazar _todo',
  'Replace with' => 'Reemplazar con',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN cleanup|Limpiar la copia de trabajo SVN',
  'SVN commit|Commit notebook to SVN repository' => 'SVN commit|Commit cuaderno al repositorio SVN',
  'SVN update|Update notebook from SVN repository' => 'Actualizar SVN|Actualizar el cuaderno desde el repositorio SVN',
  'S_ave Version...|Save Version' => 'Gu_ardar Versión...|Guardar Versión',
  'Save Copy' => 'Guardar una copia',
  'Save version' => 'Guardar versión',
  'Scanning tree ...' => 'Explorando árbol...',
  'Search' => 'Buscar',
  'Search _Backlinks...|Search Back links' => 'Buscar _Enlaces de referencia...|Buscar enlaces de referencia',
  'Select File' => 'Seleccionar archivo',
  'Select Folder' => 'Seleccione la carpeta',
  'Send To...' => 'Enviar a...',
  'Show cursor for read-only' => 'Mostrar cursor para sólo lectura',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Muestre el cursos incluso cuando no se puede editar la página. Esto es útil para navegación usando el teclado.',
  'Slow file system' => 'Sistema de archivos lento',
  'Source' => 'Fuente',
  'Source Format' => 'Formato Fuente',
  'Start the side pane with the whole tree expanded.' => 'Empezar el panel lateral con todo el árbol expandido',
  'Stri_ke|Strike' => 'Tach_ar|Tachar',
  'Strike' => 'Tachar',
  'TODO List' => 'Lista tareas por hacer',
  'Task' => 'Tarea',
  'Tearoff menus' => 'Barra de herramientas',
  'Template' => 'Plantilla',
  'Text' => 'Texto',
  'Text Editor' => 'Editor de texto',
  'Text _From File...|Insert text from file' => 'Texto _Desde Archivo...|Insertar texto desde archivo',
  'Text editor' => 'Editor de texto',
  'The equation failed to compile. Do you want to save anyway?' => 'La ecuación falló al compilarse. ¿Desea guardar de todos modos?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'la ecuación para la imagen: {path}
está perdida. No se puede editar la ecuación.',
  'This notebook does not have a document root' => 'Este cuaderno de notas no tiene una raíz de documentos',
  'This page does not exist
404' => 'Esta página no existe.
404',
  'This page does not have a document folder' => 'Esta página no tiene una carpeta de documentos',
  'This page does not have a source' => 'Esta página no tiene un código fuente',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Esta página fue actualizada en el repositorio.
Por favor actualiza tu copia de trabajo (Herramientas -> Actualizar SVN ).',
  'To_day|Today' => 'Ho_y|Hoy',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Alternar Chechbox \'V\'|Alternar checkbox',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Alternar Chechbox \'X\'|Alternar checkbox',
  'Underline' => 'Subrayado',
  'Updating links' => 'Actualizando vínculos',
  'Updating links in {name}' => 'Actualizar vínculos en {name}',
  'Updating..' => 'Actualizando..',
  'Use "Backspace" to un-indent' => 'Usar tecla de retroceso para desindentar',
  'Use "Ctrl-Space" to switch focus' => 'Use "Ctrl-Espacio" para cambiar el foco',
  'Use "Enter" to follow links' => 'Use "Intro" para seguir vínculos',
  'Use autoformatting to type special characters' => 'Usar autoformateo para teclear caracteres especiales',
  'Use custom font' => 'Usar tipografía personalizada',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Usar la tecla de retroceso para desindentar listas (Como "May-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Usar combinación "Ctrl-Space" para cambiar el foco entre el texto y el panel lateral. si es deshabilitado aún se puede usar  "Alt-Space".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Use la tecla "Intro" para ir a los vínculos. Si está deshabilitada puede usar "Alt-Intro"',
  'User' => 'Usuario',
  'User name' => 'Nombre de usuario',
  'Verbatim' => 'Resaltar',
  'Versions' => 'Versiones',
  'View _Annotated...' => 'Ver _Anotado...',
  'View _Log' => 'Ver _registro',
  'Web browser' => 'Navegador',
  'Whole _word' => 'Toda la _palabra',
  'Width' => 'Ancho',
  'Word Count' => 'Contar palabras',
  'Words' => 'Palabras',
  'You can add rules to your search query below' => 'Puede agregar reglas a la búsqueda debajo',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Usted puede elegir entre <b>Bazaar</b> o el Sistema de Control de Versiones <b>Subversion</b>.
Haga click en \'ayuda\' para leer los requerimientos de sistema.',
  'You have no {app_type} configured' => 'No tiene configurado {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => 'Usted necesita reiniciar la aplicación 
para que los cambios en los complementos tengan efecto.',
  'Your name; this can be used in export templates' => 'Su nombre; puede ser usado para exportar plantillas',
  'Zim Desktop Wiki' => 'Zim Wiki de escritorio',
  '_About|About' => '_Acerca de|Acerca de',
  '_All' => '_Todo',
  '_Back|Go page back' => '_Atrás|Página anterior',
  '_Bold|Bold' => '_Negrilla|Negrilla',
  '_Browse...' => 'E_xaminar…',
  '_Bugs|Bugs' => '_Errores|Errores',
  '_Child|Go to child page' => '_Hija|Ir a págin hija',
  '_Close|Close window' => '_Cerrar|Cerrar ventana',
  '_Contents|Help contents' => '_Contenidos|Contenidos de ayuda',
  '_Copy Page...|Copy page' => '_Copiar Página...|Copiar Página',
  '_Copy|Copy' => '_Copiar|Copiar',
  '_Date and Time...|Insert date' => '_Fecha y hora...|Insertar fecha',
  '_Delete Page|Delete page' => '_Borrar página|Borrar página',
  '_Delete|Delete' => '_Borrar|Borrar',
  '_Discard changes' => '_Descartar los cambios',
  '_Edit' => '_Editar',
  '_Edit Equation' => '_Editar ecuación',
  '_Edit Link' => '_Editar vínculo',
  '_Edit Link...|Edit link' => '_Editar vínculo...|Editar vínculo',
  '_Edit|' => '_Editar|',
  '_FAQ|FAQ' => '_PUF|PUF',
  '_File|' => '_Archivo|',
  '_Filter' => '_Filtro',
  '_Find...|Find' => '_Buscar...|Buscar',
  '_Forward|Go page forward' => '_Avanzar|Página siguiente',
  '_Go|' => '_Ir|',
  '_Help|' => '_Ayuda|',
  '_History|.' => '_Historial|.',
  '_Home|Go home' => '_Inicio|Ir a inicio',
  '_Image...|Insert image' => '_Imagen...|Insertar imagen',
  '_Index|Show index' => '_Indice|Mostrar el índice',
  '_Insert' => '_Insertar',
  '_Insert|' => '_Insertar|',
  '_Italic|Italic' => '_Cursiva|Cursiva',
  '_Jump To...|Jump to page' => '_Saltar a...|Saltar a página',
  '_Keybindings|Key bindings' => '_Atajos de teclado|Atajos de teclado',
  '_Link' => '_Vínculo',
  '_Link to date' => '_Vínculo a la fecha',
  '_Link...|Insert link' => '_Vínculo...|Insertar vínculo',
  '_Link|Link' => '_Vínculo|Vínculo',
  '_Namespace|.' => '_Nombre identificador|.',
  '_New Page|New page' => '_Nueva página|Nueva página',
  '_Next' => '_Siguiente',
  '_Next in index|Go to next page' => '_Siguiente en índice|Ir a la página siguiente',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => 'Cambios al cuader_no...',
  '_Open Another Notebook...|Open notebook' => '_Abrir Otro Cuaderno de notas..|Abrir cuaderno de notas',
  '_Open link' => 'Abrir víncul_o',
  '_Overwrite' => '_Sobreescribir',
  '_Page' => '_Página',
  '_Page Changes...' => 'Cambios de la Página...',
  '_Parent|Go to parent page' => '_Padre|Ir a página padre',
  '_Paste|Paste' => '_Pegar|Pegar',
  '_Preview' => '_Vista previa',
  '_Previous' => '_Previo',
  '_Previous in index|Go to previous page' => '_Previa en índice|Ir a la página previa',
  '_Properties' => '_Propiedades',
  '_Quit|Quit' => '_Salir|Salir',
  '_Recent pages|.' => 'Páginas _recientes|.',
  '_Redo|Redo' => '_Rehacer|Rehacer',
  '_Reload|Reload page' => '_Recargar|Recargar página',
  '_Rename' => '_Renombrar',
  '_Rename Page...|Rename page' => '_Renombrar página...|Renombrar página',
  '_Replace' => '_Reemplazar',
  '_Replace...|Find and Replace' => '_Remplazar...|Encontrar y remplazar',
  '_Reset' => '_Restablecer',
  '_Restore Version...' => '_Restaurar Versión...',
  '_Save Copy' => '_Salvar una copia',
  '_Save a copy...' => '_Salvar una copia...',
  '_Save|Save page' => '_Guardar|Guardar página',
  '_Screenshot...|Insert screenshot' => 'Captura de _pantalla...|Insertar captura de pantalla',
  '_Search...|Search' => '_Buscar...|Buscar',
  '_Search|' => '_Buscar|',
  '_Send To...|Mail page' => '_Eviar a...|Enviar página',
  '_Statusbar|Show statusbar' => '_Barra de estatus|Mostrar barra de estatus',
  '_TODO List...|Open TODO List' => '_TODO List...|Abrir TODO List',
  '_Today' => '_Hoy',
  '_Toolbar|Show toolbar' => '_Barra de herramientas|Mostras barra de herramientas',
  '_Tools|' => '_Herramientas|',
  '_Underline|Underline' => '_Subrayada|Subrayada',
  '_Undo|Undo' => '_Deshacer|Deshacer',
  '_Update links in this page' => '_Actualizar vínculos en esta página',
  '_Update {number} page linking here' => [
    'Act_ualizar {number} página enlazando a ésta',
    'Act_ualizar {number} páginas enlazanado a ésta'
  ],
  '_Verbatim|Verbatim' => '_Resaltado|Resaltado',
  '_Versions...|Versions' => '_Versiones...|Versiones',
  '_View|' => '_Ver|',
  '_Word Count|Word count' => '_Contar palabras|Contar palabras',
  'other...' => 'otro/a...',
  '{name}_(Copy)' => '{name}_(Copiar)',
  '{number} _Back link' => [
    '{number} _Enlace inverso',
    '{number} _Enlaces inversos'
  ],
  '{number} item total' => [
    '{number} elemento en total',
    '{number} elementos en total'
  ]
};
