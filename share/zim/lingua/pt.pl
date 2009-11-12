# Portuguese translation for zim
# Copyright (c) 2007 Rosetta Contributors and Canonical Ltd 2007
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2007.
# 
# 
# TRANSLATORS:
# João Santos (pt)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-11-05 21:59+0000
# Last-Translator: João Santos <twocool.pt@gmail.com>
# Language-Team: Portuguese <pt@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=2; plural=n != 1;
# X-Launchpad-Export-Date: 2008-11-09 09:04+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n != 1},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %e %b %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Apagar página</b>

Tem a certeza que deseja apagar
a página \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Activar Controle de Versão</b>

O controle de versão não está activo neste bloco de notas.
Deseja activa-lo?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Pasta inexistente.</b>

A pasta: {path}
não existe, deseja cria-la?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>A página já existe</b>

A página \'{name}\'
já existe.
Deseja substitui-la?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Actualizar as páginas de calendário para o formato 0.24?</b>

Este bloco de notas contém página para datas que utilizam o formato yyyy_mm_dd.
Desde o Zim 0.24 o formato yyyy:mm:dd é usado por defeito, criando um
namespace por mês.

Deseja actualizar o seu bloco de notas para usar o novo formato?
',
  'Add \'tearoff\' strips to the menus' => 'Adicionar faixas para "arrancar" menus"',
  'Application show two text files side by side' => '',
  'Application to compose email' => 'Aplicação para compor emails',
  'Application to edit text files' => 'Aplicação para editar ficheiros de texto',
  'Application to open directories' => 'Aplicação para abrir directórios',
  'Application to open urls' => 'Aplicação para abrir url\'s',
  'Attach _File|Attach external file' => 'Anexar _Ficheiro|Adicionar um ficheiro externo',
  'Attach external files' => 'Anexar ficheiros extenros',
  'Auto-format entities' => 'Formatar entidades automaticamente',
  'Auto-increment numbered lists' => 'Auto-incrementar listas numeradas',
  'Auto-link CamelCase' => 'Ligar CamelCase automaticamente',
  'Auto-link files' => 'Ligar ficheiros automaticamente',
  'Auto-save version on close' => 'Gravar automaticamente ao sair',
  'Auto-select words' => 'Selecionar palavras automaticamente',
  'Automatically increment items in a numbered list' => 'Incrementar automaticamente itens numa lista numerada',
  'Automatically link file names when you type' => 'Criar ligações a ficheiros automaticamente ao escrever',
  'Automaticly link CamelCase words when you type' => 'Ligar CamelCase automaticamente ao escrever',
  'Automaticly select the current word when you toggle the format' => 'Seleccionar palavra automaticamente quando muda o formato',
  'Bold' => 'Negrito',
  'Calen_dar|Show calendar' => 'Calen_dário|Mostrar Calendário',
  'Calendar' => 'Calendário',
  'Can not find application "bzr"' => 'Não foi possível encontrar a aplicação "bzr"',
  'Can not find application "{name}"' => 'Não foi possível encontrar a aplicação "{name}"',
  'Can not save a version without comment' => 'Não é possível guardar uma versão sem um comentário',
  'Can not save to page: {name}' => 'Não foi possível gravar para a página: {name}',
  'Can\'t find {url}' => 'Não foi possível encontrar {url}',
  'Cha_nge' => '_Mudar',
  'Chars' => 'Caracteres',
  'Check _spelling|Spell check' => 'Verificar _ortografica|Verificar Ortografica',
  'Check checkbox lists recursive' => '',
  'Checking a checkbox list item will also check any sub-items' => '',
  'Choose {app_type}' => 'Escolha {app_type}',
  'Co_mpare Page...' => 'Co_mparar Página...',
  'Command' => 'Comando',
  'Comment' => 'Comentário',
  'Compare this version with' => 'Comparar esta versão com',
  'Copy Email Address' => 'Copy endereço de Email',
  'Copy Location|Copy location' => 'Copiar Localização|Copiar Localização',
  'Copy _Link' => 'Copiar _Ligação',
  'Could not delete page: {name}' => 'Não foi possível apagar página: {name}',
  'Could not get annotated source for page {page}' => 'Não foi possível encontrar a fonte anotada para a página {page}',
  'Could not get changes for page: {page}' => 'Não foi possível encontrar as alterações para esta página: {page}',
  'Could not get changes for this notebook' => 'Não foi possível encontrar as alterações para este bloco de notas',
  'Could not get file for page: {page}' => 'Não foi possível encontrar o ficheiro desta página: {page}',
  'Could not get versions to compare' => 'Não foi possível encontrar as versões para comparar',
  'Could not initialize version control' => 'Não foi possível iniciar o controle de versão',
  'Could not load page: {name}' => 'Não foi possível carregar a página: {name}',
  'Could not rename {from} to {to}' => 'Não foi possível renomear {from} para {to}',
  'Could not save page' => 'Não foi possível gravar página',
  'Could not save version' => 'Não foi possível guardar versão',
  'Creating a new link directly opens the page' => 'Criar uma nova ligação abre a página',
  'Creation Date' => 'Data de Criação',
  'Cu_t|Cut' => 'Cor_tar|Cortar',
  'Current' => 'Actual',
  'Customise' => 'Personalizar',
  'Date' => 'Data',
  'Default notebook' => 'Bloco de notas padrão',
  'Details' => 'Detalhes',
  'Diff Editor' => '',
  'Diff editor' => '',
  'Directory' => 'Directório',
  'Document Root' => 'Raíz do Documento',
  'E_quation...|Insert equation' => 'E_quação...|Inserir equação',
  'E_xport...|Export' => 'E_xportar...|Exportar',
  'E_xternal Link...|Insert external link' => 'Ligação E_xterna...|Inserir ligação externa',
  'Edit Image' => 'Editar Imagem',
  'Edit Link' => 'Editar Ligação',
  'Edit Query' => 'Editar Consulta',
  'Edit _Source|Open source' => 'Ed_itar o Código|Abrir o Código',
  'Edit notebook' => 'Editar bloco de notas',
  'Edit text files "wiki style"' => 'Editor de texto "tipo wiki"',
  'Editing' => 'Edição',
  'Email client' => 'Cliente de e-mail',
  'Enabled' => 'Activo',
  'Equation Editor' => 'Editor de Equações',
  'Equation Editor Log' => 'Registo do Editor de Equações',
  'Expand side pane' => 'Expandir painel lateral',
  'Export page' => 'Exportar página',
  'Exporting page {number}' => 'Exportando página {number}',
  'Failed to cleanup SVN working copy.' => '',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Falha ao carregar o plugin SVN,
tem as ferramentas subversion instaladas?',
  'Failed to load plugin: {name}' => 'Não foi possivel carregar plugin: {name}',
  'Failed update working copy.' => 'Falha ao actualizar cópia de trabalho',
  'File browser' => 'Navegador de ficheiros',
  'File is not a text file: {file}' => 'Não é um ficheiro de texto: {file}',
  'Filter' => 'Filtro',
  'Find' => 'Procurar',
  'Find Ne_xt|Find next' => 'Procurar o Pró_xmo|Procurar o Próximo',
  'Find Pre_vious|Find previous' => 'Procurar o _Anterior|Procurar o Anterior',
  'Find and Replace' => 'Encontrar e Substituir',
  'Find what' => 'Encontrar o que',
  'Follow new link' => 'Seguir nova ligação',
  'For_mat|' => 'For_matar|',
  'Format' => 'Formato',
  'General' => 'Geral',
  'Go to "{link}"' => 'Ir para "{link}"',
  'H_idden|.' => 'Escond_ido|.',
  'Head _1|Heading 1' => 'Cabeçalho _1|Cabeçalho 1',
  'Head _2|Heading 2' => 'Cabeçalho _2|Cabeçalho 2',
  'Head _3|Heading 3' => 'Cabeçalho _3|Cabeçalho 3',
  'Head _4|Heading 4' => 'Cabeçalho _4|Cabeçalho 4',
  'Head _5|Heading 5' => 'Cabeçalho _5|Cabeçalho 5',
  'Head1' => 'Cabeçalho1',
  'Head2' => 'Cabeçalho2',
  'Head3' => 'Cabeçalho3',
  'Head4' => 'Cabeçalho4',
  'Head5' => 'Cabeçalho5',
  'Height' => 'Altura',
  'Home Page' => 'Página Inicial',
  'Icon' => 'Ícone',
  'Id' => 'Id',
  'Include all open checkboxes' => '',
  'Index page' => 'Página de Índice',
  'Initial version' => 'Versão Inicial',
  'Insert Date' => 'Inserir data',
  'Insert Image' => 'Inserir Imagem',
  'Insert Link' => 'Inserir Ligação',
  'Insert from file' => 'Inserir do ficheiro',
  'Interface' => 'Interface',
  'Italic' => 'Itálico',
  'Jump to' => 'Saltar para',
  'Jump to Page' => 'Saltar para Página',
  'Lines' => 'Linhas',
  'Links to' => 'Liga a',
  'Match c_ase' => 'Corresponder c_apitalização',
  'Media' => 'Mídia',
  'Modification Date' => 'Data de Modificação',
  'Name' => 'Nome',
  'New notebook' => 'Novo bloco de notas',
  'New page' => 'Nova Página',
  'No such directory: {name}' => 'Directório inexistente: {name}',
  'No such file or directory: {name}' => 'Ficheiro ou directório inexistente: {name}',
  'No such file: {file}' => 'Ficheiro inexistente: {file}',
  'No such notebook: {name}' => 'Bloco de notas inexistente: {name}',
  'No such page: {page}' => 'Página inexistente: {page}',
  'No such plugin: {name}' => 'Plugin inexistente: {name}',
  'Normal' => 'Normal',
  'Not Now' => 'Agora Não',
  'Not a valid page name: {name}' => 'Nome de página inválido: {name}',
  'Not an url: {url}' => 'Não é um url: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Repare que criar um ligação para uma página inexistente
irá automaticamente criar uma nova página.',
  'Notebook' => 'Bloco de Notas',
  'Notebooks' => 'Blocos de Notas',
  'Open Document _Folder|Open document folder' => 'Abrir _Pasta de Documento|Abrir pasta de documento',
  'Open Document _Root|Open document root' => 'Abrir _Raiz do Documento|Abrir raiz do documento',
  'Open _Directory' => 'Abrir _Directório',
  'Open notebook' => 'Abrir Bloco de Notas',
  'Other...' => 'Outro...',
  'Output' => 'Resultado',
  'Output dir' => 'Directório de saida',
  'P_athbar type|' => 'Tipo de B_arra de Caminho|',
  'Page' => 'Página',
  'Page Editable|Page editable' => 'Página Editável|Página Editável',
  'Page name' => 'Nome da Página',
  'Pages' => 'Páginas',
  'Password' => 'Palavra-passe',
  'Please enter a comment for this version' => 'Insira um comentário para esta versão',
  'Please enter a name to save a copy of page: {page}' => 'Insira um nome para guardar uma cópia da página: {page}',
  'Please enter a {app_type}' => 'Por favor insira um {app_type}',
  'Please give a page first' => 'Por favor seleccione um página',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Por favor indique pelo menos um directório para guardar as suas páginas.
Para um novo bloco de notas este deve ser um directório vazio.
Por exemplo um directório "Notas" na sua pasta pessoal.',
  'Please provide the password for
{path}' => 'Por favor insira a palavra-chave para
{path}',
  'Please select a notebook first' => 'Por favor seleccione um bloco de notas primeiro',
  'Please select a version first' => 'Por favor seleccione um versão',
  'Plugin already loaded: {name}' => 'Plugin já carregado: {name}',
  'Plugins' => '\'Plugins\'',
  'Pr_eferences|Preferences dialog' => '_Preferências|Preferências',
  'Preferences' => 'Preferências',
  'Prefix document root' => 'Prefixo da raíz de documentos',
  'Print to Browser|Print to browser' => 'Imprimir para o Navegador Web|Imprimir para o navegador web',
  'Prio' => 'Prio',
  'Proper_ties|Properties dialog' => 'Proprie_dades|Propriedades',
  'Properties' => 'Propriedades',
  'Rank' => 'Classificação',
  'Re-build Index|Rebuild index' => 'Reconstruir o Índice|Reconstruir o Índice',
  'Recursive' => 'Recursivo',
  'Rename page' => 'Renomear página',
  'Rename to' => 'Renomear Página',
  'Replace _all' => 'Substituir _tudo',
  'Replace with' => 'Substituir por',
  'SVN cleanup|Cleanup SVN working copy' => '',
  'SVN commit|Commit notebook to SVN repository' => 'Submeter SVN|Submeter bloco de notas para um repositório SVN',
  'SVN update|Update notebook from SVN repository' => 'Actualização SVN|Actualiza o bloco de notas a partir de um repositório SVN',
  'S_ave Version...|Save Version' => 'Guardar Ver_são...|Guardar Versão',
  'Save Copy' => 'Gravar cópia',
  'Save version' => 'Guardar versão',
  'Scanning tree ...' => 'Examinando a Árvore ...',
  'Search' => 'Procurar',
  'Search _Backlinks...|Search Back links' => 'Procurar ligaçõ_es de referencia...|Procurar ligações de referencia',
  'Select File' => 'Seleccionar ficheiro',
  'Select Folder' => 'Seleccionar Pasta',
  'Send To...' => 'Enviar Para...',
  'Show cursor for read-only' => 'Mostrar cursor em páginas só de leitura',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Mostrar o cursor mesmo quando não pode editar a página. Isto é útil para navegar com o teclado.',
  'Slow file system' => 'Sistema de Ficheiros lento',
  'Source' => 'Fonte',
  'Source Format' => 'Formato da origem',
  'Start the side pane with the whole tree expanded.' => 'Iniciar o painel lateral com a árvore expandida',
  'Stri_ke|Strike' => 'R_iscado|Riscado',
  'Strike' => 'Riscar',
  'TODO List' => 'Lista PARA FAZER',
  'Task' => 'Tarefa',
  'Tearoff menus' => 'Arrancar menus',
  'Template' => 'Modelo',
  'Text' => 'Texto',
  'Text Editor' => 'Editor de Texto',
  'Text _From File...|Insert text from file' => 'Texto do _Ficheiro...|Inserir texto do ficheiro',
  'Text editor' => 'Editor de Texto',
  'The equation failed to compile. Do you want to save anyway?' => 'A equação não pode ser compilada. Deseja gravar na mesma?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'A equação para imagem: {path}
não existe. Não é possível editar a equação.',
  'This notebook does not have a document root' => 'Este bloco de notas não tem uma raíz de documento',
  'This page does not exist
404' => 'Esta página não existe
404',
  'This page does not have a document folder' => 'Esta página não tem uma pasta de documento',
  'This page does not have a source' => 'Esta página não tem uma fonte',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Esta página foi actualizada no repositório,
Por favor actualize a sua cópia de trabalho (Ferramentas -> Actualização SVN).',
  'To_day|Today' => 'Ho_je|Hoje',
  'Toggle Checkbox \'V\'|Toggle checkbox' => '',
  'Toggle Checkbox \'X\'|Toggle checkbox' => '',
  'Underline' => 'Sublinhar',
  'Updating links' => 'Actualizando ligações',
  'Updating links in {name}' => 'Actualizando ligações em {name}',
  'Updating..' => 'Actualizando..',
  'Use "Backspace" to un-indent' => 'Usar "Backscape" para desindentar',
  'Use "Ctrl-Space" to switch focus' => 'Usar "Ctrl-Space" para mudar foco',
  'Use "Enter" to follow links' => 'Use o "Enter" para seguir ligações',
  'Use autoformatting to type special characters' => 'Usar auto formatação para escrever caracteres especiais',
  'Use custom font' => 'Usar fonte personalizada',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Usar "Backscape" para desindentar listas (O mesmo que "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Usar "Ctrl-Space" para trocar o foco entre o texto e o painel lateral. Se desabilitado pode, ainda assim, usar "Alt-Space"',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Usar a tecla "Enter" para seguir ligações. Se desabilitado pode usar "Alt-Enter"',
  'User' => 'Utilizador',
  'User name' => 'Nome de utilizador',
  'Verbatim' => 'Verbatim',
  'Versions' => 'Versões',
  'View _Annotated...' => '',
  'View _Log' => 'Ver R_egisto',
  'Web browser' => 'Navegador web',
  'Whole _word' => 'Pala_vra Completa',
  'Width' => 'Largura',
  'Word Count' => 'Contar Palavras',
  'Words' => 'Palavras',
  'You can add rules to your search query below' => 'Pode adicionar regras à sua consulta em baixo',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Pode usar o sistema de controlo de versão <b>Bazaar</b> ou <b>Subversion</b>.
Por favor clique \'ajuda\' para se informar sobre os requisitos do sistema.',
  'You have no {app_type} configured' => 'Não tem nenhum {app_type} configurado',
  'You need to restart the application
for plugin changes to take effect.' => 'É necessário reiniciar a aplicação para as
 mudanças nos plugins terem efeito.',
  'Your name; this can be used in export templates' => 'O seu nome;pode ser usado para exportar modelos',
  'Zim Desktop Wiki' => 'Wiki Pessoal Zim',
  '_About|About' => 'So_bre|Sobre',
  '_All' => 'T_udo',
  '_Back|Go page back' => 'Rec_uar|Ir para a página atrás',
  '_Bold|Bold' => 'N_egrito|Negrito',
  '_Browse...' => '_Navegar...',
  '_Bugs|Bugs' => '_Bugs|Bugs',
  '_Child|Go to child page' => '_Descer|Ir para página inferior',
  '_Close|Close window' => 'Fe_char|Fechar Janela',
  '_Contents|Help contents' => '_Conteúdos|Conteúdos da Ajuda',
  '_Copy Page...|Copy page' => '_Copiar Página...|Copiar Página',
  '_Copy|Copy' => '_Copiar|Copiar',
  '_Date and Time...|Insert date' => '_Data e Hora...|Inserir data',
  '_Delete Page|Delete page' => 'Apa_gar Página|Apagar Página',
  '_Delete|Delete' => '_Apagar|Apagar',
  '_Discard changes' => '_Descartar as alterações',
  '_Edit' => '_Editar',
  '_Edit Equation' => '_Editar Equação',
  '_Edit Link' => '_Editar Ligação',
  '_Edit Link...|Edit link' => '_Editar Ligação...|Editar ligação',
  '_Edit|' => '_Editar|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_Ficheiro|',
  '_Filter' => '_Filtro',
  '_Find...|Find' => '_Procurar...|Procurar',
  '_Forward|Go page forward' => 'A_vançar|Ir para a página à frente',
  '_Go|' => 'I_r|',
  '_Help|' => '_Ajuda|',
  '_History|.' => '_Histórico|.',
  '_Home|Go home' => 'I_nicio|Ir para a Página Inicial',
  '_Image...|Insert image' => '_Imagem...|Inserir imagem',
  '_Index|Show index' => '_Índice|Mostrar Índice',
  '_Insert' => '_Inserir',
  '_Insert|' => '_Inserir|',
  '_Italic|Italic' => '_Itálico|Itálico',
  '_Jump To...|Jump to page' => '_Ir Para...|Ir para página',
  '_Keybindings|Key bindings' => 'Atal_hos do Teclado|Atalhos do teclado',
  '_Link' => '_Ligação',
  '_Link to date' => '_Link para data',
  '_Link...|Insert link' => '_Ligação...|Inserir Ligação',
  '_Link|Link' => '_Ligação|Ligação',
  '_Namespace|.' => 'Es_pacial|.',
  '_New Page|New page' => '_Nova Página|Nova Página',
  '_Next' => 'Pró_ximo',
  '_Next in index|Go to next page' => '_Próximo no índice|Ir para a página seguinte',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => 'Mudanças do Bloco de _Notas...',
  '_Open Another Notebook...|Open notebook' => 'Abrir _Outro Bloco de Notas...|Abrir Bloco de Notas',
  '_Open link' => 'Abrir Ligaçã_o',
  '_Overwrite' => 'S_obrepor',
  '_Page' => '_Página',
  '_Page Changes...' => 'Mudanças das _Páginas',
  '_Parent|Go to parent page' => '_Subir|Ir para a página superior',
  '_Paste|Paste' => 'Co_lar|Colar',
  '_Preview' => '_Pré-visualizar',
  '_Previous' => 'A_nterior',
  '_Previous in index|Go to previous page' => '_Anterior no índice|Ir para a página anterior',
  '_Properties' => '_Propriedades',
  '_Quit|Quit' => '_Sair|Sair',
  '_Recent pages|.' => 'Páginas _Recentes|.',
  '_Redo|Redo' => '_Refazer|Refazer',
  '_Reload|Reload page' => '_Recarregar|Recarregar Página',
  '_Rename' => '_Renomear',
  '_Rename Page...|Rename page' => '_Renomear Página...|Renomear Página',
  '_Replace' => 'Substit_uir',
  '_Replace...|Find and Replace' => '_Substituir...|Procurar e Substituir',
  '_Reset' => '_Reset',
  '_Restore Version...' => '_Restaurar Versão...',
  '_Save Copy' => 'Gra_var cópia...',
  '_Save a copy...' => 'Gra_var uma cópia...',
  '_Save|Save page' => '_Gravar|Gravar Página',
  '_Screenshot...|Insert screenshot' => '_Captura de tela...|Inserir captura de tal',
  '_Search...|Search' => 'Pro_curar...|Procurar',
  '_Search|' => '_Procurar|',
  '_Send To...|Mail page' => 'En_viar Para...|Enviar página por e-mail',
  '_Statusbar|Show statusbar' => 'Barra de E_stado|Mostrar Barra de Estado',
  '_TODO List...|Open TODO List' => 'Lista _PARA FAZER... |Abre a lista PARA FAZER',
  '_Today' => 'Ho_je',
  '_Toolbar|Show toolbar' => 'Barra de Ferramen_tas|Mostrar a barra de ferramentas',
  '_Tools|' => 'Ferramen_tas|',
  '_Underline|Underline' => '_Sublinhado|Sublinhado',
  '_Undo|Undo' => '_Desfazer|Desfazer',
  '_Update links in this page' => 'Act_ualizar ligações nesta página',
  '_Update {number} page linking here' => [
    'Act_ualizar {number} página que ligam para aqui',
    'Act_ualizar {number} páginas que ligam para aqui'
  ],
  '_Verbatim|Verbatim' => '_Verbatim|Verbatim',
  '_Versions...|Versions' => '_Versões...|Versões',
  '_View|' => '_Ver|',
  '_Word Count|Word count' => '_Contar Palavras|Contar Palavras',
  'other...' => 'outro...',
  '{name}_(Copy)' => '{name}_(Copia)',
  '{number} _Back link' => [
    '',
    ''
  ],
  '{number} item total' => [
    '{number} item no total',
    '{number} itens no total'
  ]
};
