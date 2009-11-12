# Turkish translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# M. Emin Akşehirli (tr)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2008-11-05 14:42+0000
# Last-Translator: M. Emin Akşehirli <m.emin@aksehirli.name.tr>
# Language-Team: Turkish <tr@li.org>
# MIME-Version: 1.0
# Content-Type: text/plain; charset=UTF-8
# Content-Transfer-Encoding: 8bit
# Plural-Forms: nplurals=1; plural=0;
# X-Launchpad-Export-Date: 2008-11-09 09:04+0000
# X-Generator: Launchpad (build Unknown)

use utf8;

# Subroutine to determine plural:
sub {my $n = shift; 0},

# Hash with translation strings:
{
  '%a %b %e %Y' => '%a %b %e %Y',
  '<b>Delete page</b>

Are you sure you want to delete
page \'{name}\' ?' => '<b>Sayfayı Sil</b>

\'{name}\' adlı sayfayı 
silmek istediğinizden emin misiniz?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>Sürüm Denetimini Etkinleştir</b>

Bu not defteri için sürüm denetimi etkinleştirilmemiş.
Şimdi etkinleştirmek ister misiniz?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>Dizin bulunamadı.</b>

{path} yolundaki dizin oluşturulmamış, 
şimdi oluşturmak ister misiniz?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>Sayfa zaten var</b>

\'{name}\' 
adlı sayfa zaten var.
Üzerine yazmak ister misiniz?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>Sayfa kayıtlı sürüme geri döndürülsün mü?</b>

{page} sayfasını,
{version} sürümüne geri döndürmek istiyor musunuz?

Kayıtlı son sürümden sonra yapılan tüm değişiklikler kaybolacak !',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>Takvim sayfaları 0.24 biçimine yükseltilsin mi?</b>

Bu notdefteri yyyy_aa_gg biçimli tarih kullanan sayfalar içeriyor.
Zim 0.24\'ten itibaren, her bir ay için bir isim alanı oluşturan,
yyyy:aa:gg tarih biçimi kullanılıyor.

Bu not defterini yeni biçime yükseltmek ister misiniz?
',
  'Add \'tearoff\' strips to the menus' => 'Menülere koparma öğesi ekler',
  'Application show two text files side by side' => 'Metin dosyalarını yan yana göstermek için kullanılacak uygulama',
  'Application to compose email' => 'E-posta yazmak için kullanılacak uygulama',
  'Application to edit text files' => 'Metin dosyalarını düzenlemek için kullanılacak uygulama',
  'Application to open directories' => 'Dizinleri açmak için kullanılacak uygulama',
  'Application to open urls' => 'Url\'leri açmak için kullanılacak uygulama',
  'Attach _File|Attach external file' => 'Dosya _Ekle|Dışardan dosya ekle',
  'Attach external files' => 'Dışardan dosya ekle',
  'Auto-format entities' => 'Özel karakterleri oto-biçimlendir',
  'Auto-increment numbered lists' => 'Numaralı listeleri oto-artır',
  'Auto-link CamelCase' => 'DeveSözcükleri oto-bağla',
  'Auto-link files' => 'Dosyaları oto-bağla',
  'Auto-save version on close' => 'Kapanışta sürümü oto-kaydet',
  'Auto-select words' => 'Sözcükleri oto-seç',
  'Automatically increment items in a numbered list' => 'Numaralı listede elemanları otomatik artırır',
  'Automatically link file names when you type' => 'Dosya isimlerini siz yazarken bağlantı haline getirir',
  'Automaticly link CamelCase words when you type' => 'DeveSözcükleri (CamelCase) siz yazarken bağlantı haline getir',
  'Automaticly select the current word when you toggle the format' => 'Biçimi değiştirdiğinizde imlecin bulunduğu sözcüğü otomatik olarak seçer',
  'Bold' => 'Kalın',
  'Calen_dar|Show calendar' => 'Tak_vim|Takvimi göster',
  'Calendar' => 'Takvim',
  'Can not find application "bzr"' => '"bzr" uygulaması bulunamıyor',
  'Can not find application "{name}"' => '"{name}" adlı uygulama bulunamıyor.',
  'Can not save a version without comment' => 'Açıklama olmadan sürüm kaydedilemiyor.',
  'Can not save to page: {name}' => '{name} adlı sayfa kaydedilemiyor.',
  'Can\'t find {url}' => '{url} bulunamıyor.',
  'Cha_nge' => '_Değiştir',
  'Chars' => 'Harf',
  'Check _spelling|Spell check' => 'Yazımı De_netle|Yazım denetimi',
  'Check checkbox lists recursive' => 'Onay listeleri yinelemeli onaylansın',
  'Checking a checkbox list item will also check any sub-items' => 'Onay listesinde bir onay öğesini işaretlemek bütün alt öğelerini de işaretler',
  'Choose {app_type}' => '{app_type} seçin',
  'Co_mpare Page...' => 'Sayfayı Karşı_laştır...',
  'Command' => 'Komut',
  'Comment' => 'Açıklama',
  'Compare this version with' => 'Bu sürümü şununla karşılaştır:',
  'Copy Email Address' => 'E-posta Adresini Kopyala',
  'Copy Location|Copy location' => 'Konumu Kopyala|Konumu kopyala',
  'Copy _Link' => 'Bağlantıyı _Kopyala',
  'Could not delete page: {name}' => '{name} adlı sayfa silinemiyor',
  'Could not get annotated source for page {page}' => 'Could not get annotated source for page {page}',
  'Could not get changes for page: {page}' => '{page} sayfası için değişiklikler alınamadı',
  'Could not get changes for this notebook' => 'Bu not defteri için değişiklikler geri alınamıyor',
  'Could not get file for page: {page}' => '{page} sayfası için dosya alınamadı',
  'Could not get versions to compare' => 'Karşılaştırma için sürüm alınamadı',
  'Could not initialize version control' => 'Sürüm denetimi başlatılamadı.',
  'Could not load page: {name}' => '{name} adlı sayfa yüklenemiyor.',
  'Could not rename {from} to {to}' => '{from} adı, {to} olarak değiştirilemiyor.',
  'Could not save page' => 'Sayfa kaydedilemiyor.',
  'Could not save version' => 'Sürüm kaydedilemiyor.',
  'Creating a new link directly opens the page' => 'Yeni bir bağlantı yaratmak direk olarak sayfayı açar',
  'Creation Date' => 'Oluşturulma Tarihi',
  'Cu_t|Cut' => 'K_es|Kes',
  'Current' => 'Şimdiki',
  'Customise' => 'Özelleştir',
  'Date' => 'Tarih',
  'Default notebook' => 'Öntanımlı not defteri',
  'Details' => 'Ayrıntılar',
  'Diff Editor' => 'Diff (Fark) Düzenleyici',
  'Diff editor' => 'Diff (Fark) düzenleyici',
  'Directory' => 'Dizin',
  'Document Root' => 'Belge Kök Dizini',
  'E_quation...|Insert equation' => 'Den_klem...|Denklem ekle',
  'E_xport...|Export' => 'Dışa A_ktar...|Dışa aktar',
  'E_xternal Link...|Insert external link' => 'Dış Bağla_ntı...|Dış bağlantı ekle',
  'Edit Image' => 'Görsel Düzenle',
  'Edit Link' => 'Bağlantı Düzenle',
  'Edit Query' => 'Sorguyu Düzenle',
  'Edit _Source|Open source' => 'Kaynak K_odu Düzenle|Kaynak Kodu düzenle',
  'Edit notebook' => 'Not defterini düzenle',
  'Edit text files "wiki style"' => 'Metin dosyalarını "wiki tarzı"nda düzenleyin',
  'Editing' => 'Düzenleme',
  'Email client' => 'E-posta istemcisi',
  'Enabled' => 'Etkin',
  'Equation Editor' => 'Denklem Düzenleyici',
  'Equation Editor Log' => 'Denklem Düzenleyici Kayıtları',
  'Expand side pane' => 'Yan paneli genişlet',
  'Export page' => 'Sayfayı dışa aktar',
  'Exporting page {number}' => '{number} numaralı sayfa dışa aktarılıyor',
  'Failed to cleanup SVN working copy.' => 'Çalışılan SVN kopyası toparlanamadı.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'SVN eklentisi yüklenemedi.
Subversion araçları kurulu mu?',
  'Failed to load plugin: {name}' => '{name} adlı eklenti yüklenemedi',
  'Failed update working copy.' => 'Çalışan kopya güncellenemedi.',
  'File browser' => 'Dosya Tarayıcı',
  'File is not a text file: {file}' => '{file} dosyası bir metin dosyası değilBaşlık1',
  'Filter' => 'Süzgeç',
  'Find' => 'Bul',
  'Find Ne_xt|Find next' => 'Sonrakin_i Bul|Sonrakini bul',
  'Find Pre_vious|Find previous' => '_Öncekini Bul|Öncekini Bul',
  'Find and Replace' => 'Bul ve Değiştir',
  'Find what' => 'Bul...',
  'Follow new link' => 'Yeni bağlantıyı takip et',
  'For_mat|' => '_Biçim|',
  'Format' => 'Biçim',
  'General' => 'Genel',
  'Go to "{link}"' => '"{link}" bağlantısına git',
  'H_idden|.' => 'Üst çubuğu giz_le',
  'Head _1|Heading 1' => 'Başlık _1|Başlık 1',
  'Head _2|Heading 2' => 'Başlık _2|Başlık 2',
  'Head _3|Heading 3' => 'Başlık _3|Başlık 3',
  'Head _4|Heading 4' => 'Başlık _4|Başlık 4',
  'Head _5|Heading 5' => 'Başlık _5|Başlık 5',
  'Head1' => 'Başlık1',
  'Head2' => 'Başlık2',
  'Head3' => 'Başlık3',
  'Head4' => 'Başlık4',
  'Head5' => 'Başlık5',
  'Height' => 'Yükseklik',
  'Home Page' => 'Başlangıç Sayfası',
  'Icon' => 'Simge',
  'Id' => 'ID',
  'Include all open checkboxes' => 'İşaretlenmemiş bütün onay kutularını dahil et',
  'Index page' => 'Index sayfası',
  'Initial version' => 'İlk sürüm',
  'Insert Date' => 'Tarih Ekle',
  'Insert Image' => 'Görsel Ekle',
  'Insert Link' => 'Bağlantı Ekle',
  'Insert from file' => 'Dosyadan ekle',
  'Interface' => 'Arayüz',
  'Italic' => 'İtalik',
  'Jump to' => 'Sayfaya git',
  'Jump to Page' => 'Sayfaya Git',
  'Lines' => 'Satır',
  'Links to' => 'Bağ hedefi:',
  'Match c_ase' => 'BÜYÜK/küçük harf _eşleştir',
  'Media' => 'Ortam',
  'Modification Date' => 'Değiştirilme Tarihi',
  'Name' => 'Ad',
  'New notebook' => 'Yeni not defteri',
  'New page' => 'Yeni sayfa',
  'No such directory: {name}' => '{name} adlı bir dizin yok.',
  'No such file or directory: {name}' => '{name} adında bir dosya ya da dizin yok.',
  'No such file: {file}' => '{file} dosyası bulunamadı',
  'No such notebook: {name}' => '{name} adlı bir not defteri yok.',
  'No such page: {page}' => '{page} adlı bir sayfa yok',
  'No such plugin: {name}' => '{name} adlı eklenti bulunamadı!',
  'Normal' => 'Normal',
  'Not Now' => 'Şimdi değil',
  'Not a valid page name: {name}' => '{name}, sayfa adı için uygun değil.',
  'Not an url: {url}' => '{url} bir url değil.',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'Oluşturulmamış bir sayfaya bağlantı vererek de
yeni bir sayfa oluşturabilirsiniz.',
  'Notebook' => 'Not defteri',
  'Notebooks' => 'Not Defterleri',
  'Open Document _Folder|Open document folder' => 'Belge _Dizinini Aç|Belge dizinini aç',
  'Open Document _Root|Open document root' => 'Belge _Kök Dizinini Aç|Belge Kök Dizinini Aç',
  'Open _Directory' => 'Dizin _Aç',
  'Open notebook' => 'Not defteri aç',
  'Other...' => 'Diğer...',
  'Output' => 'Çıktı',
  'Output dir' => 'Çıktı dizini',
  'P_athbar type|' => 'Üst ç_ubukta göster|',
  'Page' => 'Sayfa',
  'Page Editable|Page editable' => 'Sayfa Düzenlenebilir|Sayfa düzenlenebilir',
  'Page name' => 'Sayfa adı',
  'Pages' => 'Sayfalar',
  'Password' => 'Parola',
  'Please enter a comment for this version' => 'Bu sürüm için bir açıklama girin',
  'Please enter a name to save a copy of page: {page}' => '{page} adlı sayfanın kopyası için isim girin:',
  'Please enter a {app_type}' => 'Lütfen bir {app_type} seçin',
  'Please give a page first' => 'Öncelikle bir sayfa belirtin',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'Sayfaların saklanacağı dizini belirtin.
Yeni bir not defteri için boş bir dizin belirtmelisiniz.
Örneğin bağlangıç dizininizdeki "Notlar" dizini olabilir.',
  'Please provide the password for
{path}' => '{path} 
için bir parola girin.',
  'Please select a notebook first' => 'Lütfen öncelikle bir not defteri seçin',
  'Please select a version first' => 'Öncelikle bir sürüm seçin',
  'Plugin already loaded: {name}' => '{name} adlı eklenti zaten yüklü.',
  'Plugins' => 'Eklentiler',
  'Pr_eferences|Preferences dialog' => 'Y_eğlenenler|Yeğlenen ayarlar',
  'Preferences' => 'Yeğlenenler',
  'Prefix document root' => 'Belge kök dizini ön eki',
  'Print to Browser|Print to browser' => 'Web Gezginine Gönder|Sayfanın Web gezgininde nasıl görüneceğine bakın',
  'Prio' => 'Önc',
  'Proper_ties|Properties dialog' => 'Öze_llikler|Özelliklere bak',
  'Properties' => 'Özellikler',
  'Rank' => 'Sıra',
  'Re-build Index|Rebuild index' => 'Dizi_n\'i Tazele|Dizin\'i tazele',
  'Recursive' => 'Özyinelemeli',
  'Rename page' => 'Sayfayı yeniden isimlendir',
  'Rename to' => 'Yeni ad:',
  'Replace _all' => '_Tümünü değiştir',
  'Replace with' => 'Yerine bunu koy:',
  'SVN cleanup|Cleanup SVN working copy' => 'SVN toparla|(cleanup)Çalışılan SVN kopyasını toparlar, temizler',
  'SVN commit|Commit notebook to SVN repository' => 'SVN\'ye işle|(commit)Not defterini SVN deposuna işle',
  'SVN update|Update notebook from SVN repository' => 'SVN\'den güncelle|(update)Not defterini SVN deposundan günceller',
  'S_ave Version...|Save Version' => 'Sü_rümü Kaydet...|Sürümü Kaydet',
  'Save Copy' => 'Kopyayı Kaydet',
  'Save version' => 'Sürümü kaydet',
  'Scanning tree ...' => 'Ağaç taranıyor...',
  'Search' => 'Ara',
  'Search _Backlinks...|Search Back links' => '_Geri Bağlantıları Ara...|Geri bağlantıları ara',
  'Select File' => 'Dosya Seç',
  'Select Folder' => 'Dizini Seç',
  'Send To...' => 'Gönder...',
  'Show cursor for read-only' => 'Salt-okunur modda imleç göster',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'Sayfayı düzenleyemeseniz de imleci gösterir. Sayfayı tuş takımı ile gezerken işe yarar.',
  'Slow file system' => 'Yavaş dosya sistemi',
  'Source' => 'Kaynak',
  'Source Format' => 'Kaynak kodu biçimi',
  'Start the side pane with the whole tree expanded.' => 'Yan paneli bütün ağaçlar genişletilmiş biçimde başlatır',
  'Stri_ke|Strike' => 'Ü_stü çizli|Üstü çizli',
  'Strike' => 'Üstü çizili',
  'TODO List' => 'TODO listesi',
  'Task' => 'Görev',
  'Tearoff menus' => 'Kopan menüler',
  'Template' => 'Şablon',
  'Text' => 'Görünecek Metin',
  'Text Editor' => 'Metin Düzenleyici',
  'Text _From File...|Insert text from file' => 'Dosyadan _Metin|Dosyadan metin ekle',
  'Text editor' => 'Metin düzenleyici',
  'The equation failed to compile. Do you want to save anyway?' => 'Denklem derlenemedi. Yine de kaydetmek istiyor musunuz?',
  'The equation for image: {path}
is missing. Can not edit equation.' => '{path} konumundaki denklem görseli 
bulunamadı. Denklem düzenlenemez.',
  'This notebook does not have a document root' => 'Bu not defterinin bir belge kök dizini yok.',
  'This page does not exist
404' => 'Böyle bir sayfa yok.
404',
  'This page does not have a document folder' => 'Bu sayfanın bir belge dizini yok',
  'This page does not have a source' => 'Bu sayfanın kaynak kodu yok',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'Depodaki sayfa güncellenmiş.
Lütfen çalıştığınız kopyayı güncelleyin (Tools -> SVN\'den güncelle).',
  'To_day|Today' => 'Bu_gün|Bugün',
  'Toggle Checkbox \'V\'|Toggle checkbox' => 'Onay Kutusunu \'V\'le | Onay kutusunu değiştir',
  'Toggle Checkbox \'X\'|Toggle checkbox' => 'Onay Kutusunu \'X\'le | Onay kutusunu değiştir',
  'Underline' => 'Altı çizili',
  'Updating links' => 'Bağlantılar güncelleniyor',
  'Updating links in {name}' => '{name} içindeki bağlantılar güncelleniyor',
  'Updating..' => 'Güncelleniyor..',
  'Use "Backspace" to un-indent' => 'Girinti azaltmak için "GeriSilme" tuşunu kullan',
  'Use "Ctrl-Space" to switch focus' => 'Odağı değiştirmek için "Ctrl-Boşluk" kullan',
  'Use "Enter" to follow links' => 'Bağlantıyı takip etmek için "Enter" kullan',
  'Use autoformatting to type special characters' => 'Özel karakterleri yazmak için otomatik biçimlendirme kullan',
  'Use custom font' => 'Özel yazı-yüzü kullan',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'İmli listelerde (bullet list) girinti azaltmak (un-indent) için "GeriSilme" ("BackSpace") tuşunu kullan. ("Shift-Tab" ile aynı)',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'Metin ve yan panel arasında geçiş yapmak için "Ctrl-Boşluk" tuş bileşimini kullanın. Eğer etkisizleştirilirse "Alt-Boşluk" kullanabilirsiniz.',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'Bağlantıları takip etmek için "Enter" tuşunu kullan. Eğer etkisizleştirilirse "Alt-Enter" kullanabilirsiniz.',
  'User' => 'Kullanıcı',
  'User name' => 'Kullanıcı adı',
  'Verbatim' => 'Sabit',
  'Versions' => 'Sürümler',
  'View _Annotated...' => 'View _Annotated...',
  'View _Log' => '_Kayıtları Göster',
  'Web browser' => 'Web tarayıcı',
  'Whole _word' => 'Kelimenin _tamamı',
  'Width' => 'Genişlik',
  'Word Count' => 'Sözcük Sayımı',
  'Words' => 'Sözcük',
  'You can add rules to your search query below' => 'Aşağıdan, arama sorgunuza yeni kurallar ekleyebilirsiniz',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => '<b>Bazaar</b> ya da <b>Subversion</b> Sürüm Denetim Sistemleri\'nden birini seçebilirsiniz.
Sistem isterleri hakkında bilgi almak için lütfen \'yardım\'a tıklayın.',
  'You have no {app_type} configured' => 'Ayarlanmış bir {app_type} yok.',
  'You need to restart the application
for plugin changes to take effect.' => 'Eklentilerin etkin olabilmesi için
uygulamayı yeniden başlatmalısınız.',
  'Your name; this can be used in export templates' => 'İsminiz; şablonları dışa aktarırken kullanılabilir',
  'Zim Desktop Wiki' => 'Zim Desktop Wiki',
  '_About|About' => 'Hakk_ında|Hakkında',
  '_All' => '_Tümü',
  '_Back|Go page back' => '_Geri|Önceki sayfa',
  '_Bold|Bold' => '_Kalın|Kalın',
  '_Browse...' => '_Gözat...',
  '_Bugs|Bugs' => '_Sorunlar|Sorunlar',
  '_Child|Go to child page' => 'Bir _Alt Seviye|Alt seviyedeki sayfaya git',
  '_Close|Close window' => 'Ka_pat|Pencereyi kapat',
  '_Contents|Help contents' => 'Yardım İ_çeriği|Yardım içeriği',
  '_Copy Page...|Copy page' => 'Sayfayı _Kopyala...|Sayfayı kopyala',
  '_Copy|Copy' => '_Kopyala|Kopyala',
  '_Date and Time...|Insert date' => 'Tari_h ve Saat|Tarih ekle',
  '_Delete Page|Delete page' => 'Sayfayı _Sil|Sayfayı Sil',
  '_Delete|Delete' => 'S_il|Sil',
  '_Discard changes' => '_Değişiklikleri sil',
  '_Edit' => '_Düzenle',
  '_Edit Equation' => 'Denklemi D_üzenle',
  '_Edit Link' => 'Bağlantıyı _Düzenle',
  '_Edit Link...|Edit link' => 'Bağlantıyı _Düzenle...|Bağlantıyı düzenle',
  '_Edit|' => 'Dü_zen|',
  '_FAQ|FAQ' => '_SSS|SSS',
  '_File|' => '_Dosya|',
  '_Filter' => '_Süz',
  '_Find...|Find' => 'B_ul...|Bul',
  '_Forward|Go page forward' => 'İ_leri|Sonraki sayfa',
  '_Go|' => 'G_it|',
  '_Help|' => '_Yardım|',
  '_History|.' => '_Geçmiş|.',
  '_Home|Go home' => 'Ba_şlangıç|Başlangıç sayfasını aç',
  '_Image...|Insert image' => 'G_örsel...|Görsel ekle',
  '_Index|Show index' => 'Di_zin|Dizini göster',
  '_Insert' => '_Ekle',
  '_Insert|' => '_Ekle|',
  '_Italic|Italic' => 'İ_talik|İtalik',
  '_Jump To...|Jump to page' => 'A_tla...|Sayfaya atla',
  '_Keybindings|Key bindings' => 'Kısayol T_uşları|Kısayol tuşları',
  '_Link' => '_Bağlantı',
  '_Link to date' => 'Tari_he bağla',
  '_Link...|Insert link' => 'Bağ_lantı...|Bağlantı ekle',
  '_Link|Link' => 'Bağ_lantı|Bağlantı',
  '_Namespace|.' => 'İsi_m Alanı|.',
  '_New Page|New page' => '_Yeni Sayfa|Yeni sayfa',
  '_Next' => 'So_nraki',
  '_Next in index|Go to next page' => 'Aynı seviyede _ileri|Aynı seviyedeki bir sonraki sayfaya git',
  '_Normal|Normal' => '_Normal|Normal',
  '_Notebook Changes...' => '_Not Defteri Değişiklikleri...',
  '_Open Another Notebook...|Open notebook' => 'B_aşka Bir Not Defteri Aç...|Not Defteri Aç',
  '_Open link' => '_Bağlantıyı aç',
  '_Overwrite' => 'Ü_zerine Yaz',
  '_Page' => '_Sayfa',
  '_Page Changes...' => '_Sayfa Değişiklikleri...',
  '_Parent|Go to parent page' => 'Bir Ü_st Seviye|Üst seviyeye çık',
  '_Paste|Paste' => 'Ya_pıştır|Yapıştır',
  '_Preview' => 'Ö_nizleme',
  '_Previous' => '_Önceki',
  '_Previous in index|Go to previous page' => 'Aynı seviyede _geri|Aynı seviyedeki bir önceki sayfaya git',
  '_Properties' => 'Ö_zellikler',
  '_Quit|Quit' => 'Çı_k|Çık',
  '_Recent pages|.' => 'Açılan s_on sayfalar|.',
  '_Redo|Redo' => 'T_ekrarla|Tekrarla',
  '_Reload|Reload page' => '_Tazele|Sayfayı tazele',
  '_Rename' => '_Yeniden Adlandır',
  '_Rename Page...|Rename page' => 'Sayfanın Adını _Değiştir...|Sayfanın adını değiştir',
  '_Replace' => '_Değiştir',
  '_Replace...|Find and Replace' => '_Değiştir...|Bul ve değiştir',
  '_Reset' => 'Sıfı_rla',
  '_Restore Version...' => 'Sürümü _Geri Al...',
  '_Save Copy' => '_Kopyayı Kaydet',
  '_Save a copy...' => 'Bir kop_yasını kaydet...',
  '_Save|Save page' => '_Kaydet|Sayfayı Kaydet',
  '_Screenshot...|Insert screenshot' => 'Ekran Görüntü_sü...|Ekran görüntüsü ekle',
  '_Search...|Search' => '_Ara...|Ara',
  '_Search|' => '_Ara|',
  '_Send To...|Mail page' => 'G_önder...|Sayfayı postala',
  '_Statusbar|Show statusbar' => '_Durum Çubuğu|Durum Çubuğunu Göster',
  '_TODO List...|Open TODO List' => '_TODO Listesi...|TODO Listesini Aç',
  '_Today' => '_Bugün',
  '_Toolbar|Show toolbar' => 'A_raç Çubuğu|Araç çubuğunu göster',
  '_Tools|' => 'A_raçlar|',
  '_Underline|Underline' => '_Altı Çizili|Altı çizili',
  '_Undo|Undo' => 'Ge_ri Al|Geri al',
  '_Update links in this page' => 'Bu sayfadaki bağlantıları g_üncelle',
  '_Update {number} page linking here' => [
    'Buraya _bağlanan {number} adet sayfayı güncelle'
  ],
  '_Verbatim|Verbatim' => 'Sa_bit|Sabit genişlikli',
  '_Versions...|Versions' => '_Sürümler...|Sürümler',
  '_View|' => '_Görünüm|',
  '_Word Count|Word count' => 'Söz_cük Sayımı|Sözcük sayısı',
  'other...' => 'diğer...',
  '{name}_(Copy)' => '{name}_(Kopyası)',
  '{number} _Back link' => [
    '{number} _Geri bağlantı'
  ],
  '{number} item total' => [
    'Toplam {number} öğe'
  ]
};
