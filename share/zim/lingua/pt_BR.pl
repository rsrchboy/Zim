# Brazilian Portuguese translation for zim
# Copyright (c) 2007 Rosetta Contributors and Canonical Ltd 2007
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2007.
# 
# 
# TRANSLATORS:
# Daniel Ribeiro (pt_BR)
# Frederico Gonçalves Guimarães (pt_BR)
# ThiagoSerra (pt_BR)
# Wanderson Santiago dos Reis (pt_BR)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-11-17 20:30+0000
# Last-Translator: Wanderson Santiago dos Reis <wasare@gmail.com>
# Language-Team: Brazilian Portuguese <pt_BR@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=2; plural=n > 1;
# X-Launchpad-Export-Date: 2010-01-10 10:44+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; $n > 1},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Deletar página</b>

Tem certeza que deseja deletar a
página \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Ativar Controle de Versão</b>

Controle de versão está atualmente desabilitado para este Bloco de Notas.
Você deseja habilitá-lo?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Pasta não existente.</b>

A pasta: {path}
não existe, você deseja criá-la agora?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Página já existe</b>

A página \'{name}\'
já existe.
Você deseja sobrescrevê-la?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Restaurar página para a versão salva?</b>

Você gostaria de restaurar a página: {page}
para a versão salva: {version} ?

Todas as alterações desde a última versão salva serão perdidas !',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Atualizar páginas de calendário para o formato 0.24?</b>

Este Bloco de Notas contém páginas para datas usando o formato yyyy_mm_dd.
Desde o Zim 0.24 o formato yyyy:mm:dd é utilizado por padrão, criando
namespaces por mês.

Você deseja atualizar este Bloco de NOtas para esse novo layout?
',
  'Add \'tearoff\' strips to the menus' => 'Adicionar tiras \'tearoff\' para os menus',
  'Application show two text files side by side' => 'Programa para mostrar dois arquivos texto lado a lado',
  'Application to compose email' => 'Programa para redigir email',
  'Application to edit text files' => 'Programa para editar arquivos texto',
  'Application to open directories' => 'Programa para abrir pastas',
  'Application to open urls' => 'Programa para abrir urls',
  'Attach _File|Attach external file' => 'Ane_xar arquivo|Anexar um arquivo externo',
  'Attach external files' => 'Anexar arquivo externo',
  'Auto-format entities' => 'Auto-formatar entidades',
  'Auto-increment numbered lists' => 'Auto incrementar listas numeradas',
  'Auto-link CamelCase' => 'Link automático no formato CamelCase',
  'Auto-link files' => 'Link automático para arquivos',
  'Auto-save version on close' => 'Auto salvar versão ao sair',
  'Auto-select words' => 'Auto selecionar palavras',
  'Automatically increment items in a numbered list' => 'Incrementar automaticamente itens na lista numerada',
  'Automatically link file names when you type' => 'Vincula automaticamente nomes quando você digita',
  'Automaticly link CamelCase words when you type' => 'Criar link automático para palavras digitadas no formato CamelCase',
  'Automaticly select the current word when you toggle the format' => 'Selecionar automaticamente a palvra atual enquanto você estiver aplicando formatação',
  'Bold' => 'Negrito',
  'Calen_dar|Show calendar' => 'Calen_dário|Mostrar calendário',
  'Calendar' => 'Calendário',
  'Can not find application "bzr"' => 'Não foi possível encontrar a aplicação "bzr"',
  'Can not find application "{name}"' => 'Não foi possível encontrar o aplicativo "{name}"',
  'Can not save a version without comment' => 'Não é possível salvar uma versão sem um comentário',
  'Can not save to page: {name}' => 'Não foi possível salvar a página: {name}',
  'Can\'t find {url}' => 'Não encontrado {url}',
  'Cha_nge' => 'Muda_r',
  'Chars' => 'Caracteres',
  'Check _spelling|Spell check' => 'Verificação _ortográfica|Verificação ortográfica',
  'Check checkbox lists recursive' => 'Marcar listas de checkbox recursivamente',
  'Checking a checkbox list item will also check any sub-items' => 'Marcar um item na lista de checkbox irá marcar também os subitens dessa lista',
  'Choose {app_type}' => 'Escolha {app_type}',
  'Co_mpare Page...' => 'Co_mparar Páginas...',
  'Command' => 'Comando',
  'Comment' => 'Comentário',
  'Compare this version with' => 'Compare esta versão com',
  'Copy Email Address' => 'Copiar endereço de Email',
  'Copy Location|Copy location' => 'Copiar Localização|Copiar Localização',
  'Copy _Link' => 'Copiar _Link',
  'Could not delete page: {name}' => 'Não foi possível deletar a página: {name}',
  'Could not get annotated source for page {page}' => 'Não foi possível obter a anotação do código fonte da página {page}',
  'Could not get changes for page: {page}' => 'Não foi possível obter as alteração para página: {page}',
  'Could not get changes for this notebook' => 'Não foi possível obter as mudanças para este Bloco de Notas',
  'Could not get file for page: {page}' => 'Não foi possível obter o arquivo para página: {page}',
  'Could not get versions to compare' => 'Não foi possível obter versẽos para comparação',
  'Could not initialize version control' => 'Não foi possível inicializar o controle de versão',
  'Could not load page: {name}' => 'Não foi possível carregar a página: {name}',
  'Could not rename {from} to {to}' => 'Não foi possível renomear {from} para {to}',
  'Could not save page' => 'Página ainda não foi salva.',
  'Could not save version' => 'Não foi possível salver a versão',
  'Creating a new link directly opens the page' => 'Criando um novo link que abre a página diretamente',
  'Creation Date' => 'Data de Criação',
  'Cu_t|Cut' => 'Cor_tar|Cortar',
  'Current' => 'Atual',
  'Customise' => 'Personalizar',
  'Date' => 'Data',
  'Default notebook' => 'Bloco de Notas Padrão',
  'Details' => 'Detalhes',
  'Diff Editor' => 'Editor Diff',
  'Diff editor' => 'Editor de diferenças (diff)',
  'Directory' => 'Pasta',
  'Document Root' => 'Documento Raiz',
  'E_quation...|Insert equation' => 'E_quação...|Inserir equação',
  'E_xport...|Export' => 'E_xportar...|Exporta a página',
  'E_xternal Link...|Insert external link' => 'Link E_xterno...|Inserir link externo',
  'Edit Image' => 'Editar Imagem',
  'Edit Link' => 'Editar Link',
  'Edit Query' => 'Editar Consulta',
  'Edit _Source|Open source' => 'Ed_itar Código Fonte|Editar Código Fonte',
  'Edit notebook' => 'Editar Bloco de Notas',
  'Edit text files "wiki style"' => 'Edite arquivos de texto no "estilo wiki"',
  'Editing' => 'Editando',
  'Email client' => 'Cliente de Email',
  'Enabled' => 'Habilitar',
  'Equation Editor' => 'Editor de Equações',
  'Equation Editor Log' => 'Log do Editor de Equações',
  'Expand side pane' => 'Expandir painel lateral',
  'Export page' => 'Exportar página',
  'Exporting page {number}' => 'Exportanto página {number}',
  'Failed to cleanup SVN working copy.' => 'Falha no SVN cleanup em sua cópia de trabalho',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'Falha ao carregar o plugin SVN,
você tem os utilitários do subversion instalados?',
  'Failed to load plugin: {name}' => 'Falha ao rodar plugin: {name}',
  'Failed update working copy.' => 'Falha ao atualizar cópia de trabalho',
  'File browser' => 'Navegador de Arquivos',
  'File is not a text file: {file}' => 'O arquivo não é arquivo texto: {file}',
  'Filter' => 'Filtrar',
  'Find' => 'Procurar',
  'Find Ne_xt|Find next' => 'Encontrar _Próximo|Encontrar Próximo',
  'Find Pre_vious|Find previous' => 'Encontrar _Anterior|Encontrar Anterior',
  'Find and Replace' => 'Encontrar e Substituir',
  'Find what' => 'Localizar',
  'Follow new link' => 'Seguir novo link',
  'For_mat|' => 'For_matar|',
  'Format' => 'Formato',
  'General' => 'Geral',
  'Go to "{link}"' => 'Vá para "{link}"',
  'H_idden|.' => 'O_culto|.',
  'Head _1|Heading 1' => 'Cabeçalho_1|Cabeçalho 1',
  'Head _2|Heading 2' => 'Cabeçalho_2|Cabeçalho 2',
  'Head _3|Heading 3' => 'Cabeçalho_3|Cabeçalho 3',
  'Head _4|Heading 4' => 'Cabeçalho_4|Cabeçalho 4',
  'Head _5|Heading 5' => 'Cabeçalho_5|Cabeçalho 5',
  'Head1' => 'Cabeçalho1',
  'Head2' => 'Cabeçalho2',
  'Head3' => 'Cabeçalho3',
  'Head4' => 'Cabeçalho4',
  'Head5' => 'Cabeçalho5',
  'Height' => 'Alturar',
  'Home Page' => 'Página Inicial',
  'Icon' => 'Ícone',
  'Id' => 'Id',
  'Include all open checkboxes' => 'Incluir todos os checkboxes abertos',
  'Index page' => 'Página de Índice',
  'Initial version' => 'Versão Inicial',
  'Insert Date' => 'Inserir Data',
  'Insert Image' => 'Inserir Imagem',
  'Insert Link' => 'Inserir Link',
  'Insert from file' => 'Inserir arquivo do arquivo',
  'Interface' => 'Interface',
  'Italic' => 'Itálico',
  'Jump to' => 'Pular para',
  'Jump to Page' => 'Pular para Página',
  'Lines' => 'Linas',
  'Links to' => 'Links para',
  'Match c_ase' => '_Coincidir maiúsculas e minúsculas',
  'Media' => 'Mídia',
  'Modification Date' => 'Data de Modificação',
  'Name' => 'Nome',
  'New notebook' => 'Novo Bloco de Notas',
  'New page' => 'Nova página',
  'No such directory: {name}' => 'Pasta não encontrada: {name}',
  'No such file or directory: {name}' => 'Arquivo ou diretório não encontrado: {name}',
  'No such file: {file}' => 'Arquivo não encontrado: {file}',
  'No such notebook: {name}' => 'Bloco de notas não encontrado: {name}',
  'No such page: {page}' => 'Página não encontrada: {page}',
  'No such plugin: {name}' => 'Plugin não encontrado: {name}',
  'Normal' => 'Normal',
  'Not Now' => 'Agora não',
  'Not a valid page name: {name}' => 'Nome não é válido para página: {name}',
  'Not an url: {url}' => 'Não é uma url: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Note que a vinculação a uma página não existente
também cria automaticamente uma nova página.',
  'Notebook' => 'Bloco de Notas',
  'Notebooks' => 'Blocos de Notas',
  'Open Document _Folder|Open document folder' => 'Abrir _Pasta de Documento|Abrir Pasta de Documento',
  'Open Document _Root|Open document root' => 'Abrir _Raiz do Documento|Abrir Raiz do Documento',
  'Open _Directory' => 'Abrir _Pasta',
  'Open notebook' => 'Abrir Bloco de Notas',
  'Other...' => 'Outro...',
  'Output' => 'Saída',
  'Output dir' => 'Pasta de Saída',
  'P_athbar type|' => 'Tipo de _barra de caminho',
  'Page' => 'Página',
  'Page Editable|Page editable' => 'Página Editável|Página Editável',
  'Page name' => 'Nome da página',
  'Pages' => 'Páginas',
  'Password' => 'Senha',
  'Please enter a comment for this version' => 'Por favor digite um comentário para esta versão',
  'Please enter a name to save a copy of page: {page}' => 'Por favor informe o nome da cópia da página para salvar: {page}',
  'Please enter a {app_type}' => 'Por favor entre com um {app_type}',
  'Please give a page first' => 'Por favor informe a primeira página',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Por favor informe no mínimo uma pasta para armazenar suas páginas.
Para um novo Bloco de Notas este deverá ser uma pasta vazia.
Por exemplo, uma pasta "Notas" no seu diretório Home.',
  'Please provide the password for
{path}' => 'Por favor forneça uma senha para
{path}',
  'Please select a notebook first' => 'Por favor selecione o primeiro Bloco de Notas',
  'Please select a version first' => 'Por favor selecione a primeira versão',
  'Plugin already loaded: {name}' => 'Plugin já carregado: {name}',
  'Plugins' => 'Plugins',
  'Pr_eferences|Preferences dialog' => 'Pr_eferências|Tela de preferências',
  'Preferences' => 'Preferências',
  'Prefix document root' => 'Prefixo da raíz do documento',
  'Print to Browser|Print to browser' => 'Imprimir para Navegador|Imprimir para Navegador',
  'Prio' => 'Prio',
  'Proper_ties|Properties dialog' => '_Propriedades|Propriedades',
  'Properties' => 'Propriedades',
  'Rank' => 'Rank',
  'Re-build Index|Rebuild index' => 'Reconstruir o Índice|Reconstruir o Índice',
  'Recursive' => 'Recursivo',
  'Rename page' => 'Renomear página',
  'Rename to' => 'Renomear para',
  'Replace _all' => 'Substituir _Todos',
  'Replace with' => 'Substituir por',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN cleanup|Cleanup SVN em cópia de trabalho',
  'SVN commit|Commit notebook to SVN repository' => 'SVN commit|Commitar bloco de notas para repositório SVN',
  'SVN update|Update notebook from SVN repository' => 'SVN update|Atualizar Bloco de Notas de repositório SVN',
  'S_ave Version...|Save Version' => 'S_alvar versão...|Salvar versão',
  'Save Copy' => 'Salvar Cópia',
  'Save version' => 'Salvar versão',
  'Scanning tree ...' => 'Escaneando árvore ...',
  'Search' => 'Procurar',
  'Search _Backlinks...|Search Back links' => 'Procurar ligaçõ_es de referência...|Procurar ligações de referência...',
  'Select File' => 'Selecione o Arquivo',
  'Select Folder' => 'Selecione a Pasta',
  'Send To...' => 'Enviar para...',
  'Show cursor for read-only' => 'Mostre o cursos para somente leitura',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Mostre o cursos mesmo quando não for possível editar a página. Isso é útil para navegação pelo teclado.',
  'Slow file system' => 'Sistema de arquivo lento',
  'Source' => 'Fonte',
  'Source Format' => 'Formatar Fonte',
  'Start the side pane with the whole tree expanded.' => 'Iniciar o painel lateral com a árvore inteira expandida.',
  'Stri_ke|Strike' => 'Sob_rescrito|Sobrescrito',
  'Strike' => 'Sobrescrito',
  'TODO List' => 'Lista TODO',
  'Task' => 'Tarefa',
  'Tearoff menus' => 'Menus Tearoff',
  'Template' => 'Modelo',
  'Text' => 'Texto',
  'Text Editor' => 'Editor de texto',
  'Text _From File...|Insert text from file' => 'Texto _do arquivo...|Inserir texto do arquivo',
  'Text editor' => 'Editor de texto',
  'The equation failed to compile. Do you want to save anyway?' => 'A equação não conseguiu compilar. Você gostaria de salvar mesmo assim?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'A equação para a imagem: {path}
está faltando. Não foi possível encontrar o editor de equações.',
  'This notebook does not have a document root' => 'Este Bloco de Notas não tem uma pasta de documento raiz',
  'This page does not exist
404' => 'Esta página não existe
404',
  'This page does not have a document folder' => 'Este página não possui uma pasta de documento',
  'This page does not have a source' => 'Esta página não tem uma fonte',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Esta página foi atualizada no repositório.
Por favor atualize sua cópia de trabalho (Ferramentas -> SVN update).',
  'To_day|Today' => '_Hoje|Hoje',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'Marcar Checkbox com \'V\'|Marcar checkbox com \'V\'',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'Marcar Checkbox com \'X\'|Marcar checkbox com \'X\'',
  'Underline' => 'Sublinhado',
  'Updating links' => 'Atualizar links',
  'Updating links in {name}' => 'Atualizar links em {name}',
  'Updating..' => 'Atualizando...',
  'Use "Backspace" to un-indent' => 'Utilize a tecla "Backspace" para desindentar',
  'Use "Ctrl-Space" to switch focus' => 'Utilizar "Ctrl-Space" para mudar foco',
  'Use "Enter" to follow links' => 'Utilizar "Enter" para seguir links',
  'Use autoformatting to type special characters' => 'Utilizar autoformatação para digitar caracteres especiais',
  'Use custom font' => 'Utilizar fonte personalizada',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'Utilizar a tecla "Backspace" para desindentar listas (o mesmo que "Shift-Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Utilizar as teclas "Ctrl-Space" para mudar foco entre o texto e o painel lateral. Se desabilitado você poderá utilizar "Alt-Space".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Utilizar a tecla "Enter" para seguir links. Se desabilitado, você pode utilizar "Alt-Enter"',
  'User' => 'Usuário',
  'User name' => 'Nome do usuário',
  'Verbatim' => 'Sem formatação',
  'Versions' => 'Versões',
  'View _Annotated...' => 'Ver _Anotações...',
  'View _Log' => 'Visualizar _Log',
  'Web browser' => 'Navegador Web',
  'Whole _word' => 'Toda a _palavra',
  'Width' => 'Largura',
  'Word Count' => 'Contar Palavras',
  'Words' => 'Palavras',
  'You can add rules to your search query below' => 'Você pode adicionar regras para sua pesquisa abaixo',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'Você pode escolher utilizar o <b>Bazaar</b> ou o <b>Subversion</b> como Sistema de Controle de Versões.
Por favor clique em \'Ajuda\' para ler sobre os requisitos de sistema.',
  'You have no {app_type} configured' => 'Você não tem {app_type} configurado',
  'You need to restart the application
for plugin changes to take effect.' => 'Você precisa reiniciar o aplicativo
para que as mudanças de plugin tenham efeito.',
  'Your name; this can be used in export templates' => 'Seu nome; pode ser utilizado em modelos de exportação',
  'Zim Desktop Wiki' => 'Zim Desktop Wiki',
  '_About|About' => '_Sobre|Sobre',
  '_All' => '_Todos',
  '_Back|Go page back' => '_Voltar|Voltar para página anterior',
  '_Bold|Bold' => '_Negrito|Negrito',
  '_Browse...' => '_Navegar...',
  '_Bugs|Bugs' => '_Bugs|Bugs',
  '_Child|Go to child page' => '_Filha|Ir para página filha',
  '_Close|Close window' => '_Fechar|Fecha a janela',
  '_Contents|Help contents' => '_Conteúdo|Conteúdo de Ajuda',
  '_Copy Page...|Copy page' => '_Copiar página...|Copiar página',
  '_Copy|Copy' => '_Copiar|Copiar',
  '_Date and Time...|Insert date' => '_Data e Hora...|Inserir data',
  '_Delete Page|Delete page' => 'Exc_luir a página|Exclui a página',
  '_Delete|Delete' => '_Deletar|Deletar',
  '_Discard changes' => '_Descartar alterações',
  '_Edit' => '_Editar',
  '_Edit Equation' => 'Edit_ar Equação',
  '_Edit Link' => '_Editar Link',
  '_Edit Link...|Edit link' => '_Editar Link...|Editar link',
  '_Edit|' => '_Editar|',
  '_FAQ|FAQ' => '_FAQ|FAQ',
  '_File|' => '_Arquivo|',
  '_Filter' => '_Filtrar',
  '_Find...|Find' => '_Encontrar...|Encontrar',
  '_Forward|Go page forward' => 'Avançar|Ir para próxima página',
  '_Go|' => '_Ir|',
  '_Help|' => '_Ajuda|',
  '_History|.' => '_Histórico|.',
  '_Home|Go home' => '_Início|Início',
  '_Image...|Insert image' => '_Imagem...|Inserir imagem',
  '_Index|Show index' => 'Ín_dice|Mostrar Índice',
  '_Insert' => '_Inserir',
  '_Insert|' => 'I_nserir',
  '_Italic|Italic' => '_Itálico|Itálico',
  '_Jump To...|Jump to page' => 'Pular para...|Pular para página',
  '_Keybindings|Key bindings' => '_Atalhos|Atalhos de teclado',
  '_Link' => '_Link',
  '_Link to date' => '_Link para data',
  '_Link...|Insert link' => '_Link...|Inserir link',
  '_Link|Link' => '_Link|Link',
  '_Namespace|.' => '_Namespace|.',
  '_New Page|New page' => '_Nova página|Cria uma nova página',
  '_Next' => '_Próximo',
  '_Next in index|Go to next page' => '_Próximo no Índice|Próximo no Índice',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => '_Mudanças no Bloco de Notas...',
  '_Open Another Notebook...|Open notebook' => 'Abrir _outro bloco de notas...|Abrir bloco de notas',
  '_Open link' => '_Abrir link',
  '_Overwrite' => 'So_brescrever',
  '_Page' => '_Páginas',
  '_Page Changes...' => '_Mudanças de Páginas...',
  '_Parent|Go to parent page' => '_Principal|Ir para página principal',
  '_Paste|Paste' => 'Co_lar|Colar',
  '_Preview' => '_Visualização Prévia',
  '_Previous' => '_Anterior',
  '_Previous in index|Go to previous page' => '_Anterior no Índice|Anterior no Índice',
  '_Properties' => '_Propriedades',
  '_Quit|Quit' => 'Sai_r|Sai do programa',
  '_Recent pages|.' => 'Páginas Recentes|.',
  '_Redo|Redo' => '_Refazer|Refazer',
  '_Reload|Reload page' => '_Recarregar|Recarregar página',
  '_Rename' => '_Renomear',
  '_Rename Page...|Rename page' => '_Renomear a página...|Renomeia a página',
  '_Replace' => '_Substituir',
  '_Replace...|Find and Replace' => '_Substituir...|Procurar e Substituir',
  '_Reset' => '_Resetar',
  '_Restore Version...' => '_Restaurar Versão...',
  '_Save Copy' => 'S_alvar Cópia',
  '_Save a copy...' => 'S_alvar uma cópia...',
  '_Save|Save page' => '_Salvar|Salva a página',
  '_Screenshot...|Insert screenshot' => '_Captura de tela...|Inserir captura de tela',
  '_Search...|Search' => '_Procurar...|Procura',
  '_Search|' => '_Procurar|',
  '_Send To...|Mail page' => '_Enviar para...|Envia a página por e-mail',
  '_Statusbar|Show statusbar' => 'Barra de Status|Mostrar Barra de Status',
  '_TODO List...|Open TODO List' => '_Lista TODO...|Abrir lista TODO',
  '_Today' => '_Hoje',
  '_Toolbar|Show toolbar' => '_Barra de Tarefas|Mostrar Barra de Tarefas',
  '_Tools|' => '_Ferramentas|',
  '_Underline|Underline' => '_Sublinhado|Sublinhado',
  '_Undo|Undo' => '_Desfazer|Desfazer',
  '_Update links in this page' => 'A_tualizar links nesta página',
  '_Update {number} page linking here' => [
    'At_ualizar {number} página que aponta para cá',
    '_Update {number} páginas que apontam para cá'
  ],
  '_Verbatim|Verbatim' => 'Sem F_ormatação|Sem Formatação',
  '_Versions...|Versions' => '_Versões...|Versões',
  '_View|' => 'E_xibir|',
  '_Word Count|Word count' => 'Contar_ Palavras|Contar Palavras',
  'other...' => 'outro...',
  '{name}_(Copy)' => '{name}_(Cópia)',
  '{number} _Back link' => [
    '{number} _Link de retorno',
    '{number} _Links de retorno'
  ],
  '{number} item total' => [
    '{number} item no total',
    '{number} itens no total'
  ]
};
