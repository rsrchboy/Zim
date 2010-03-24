# Hebrew translation for zim
# Copyright (c) 2008 Rosetta Contributors and Canonical Ltd 2008
# This file is distributed under the same license as the zim package.
# FIRST AUTHOR <EMAIL@ADDRESS>, 2008.
# 
# 
# TRANSLATORS:
# Yaron (he)
# dotancohen (he)
# 
# Project-Id-Version: zim
# Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
# POT-Creation-Date: 2008-10-27 21:09+0100
# PO-Revision-Date: 2009-11-18 00:01+0000
# Last-Translator: dotancohen <kubuntu@dotancohen.com>
# Language-Team: Hebrew <he@li.org>
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
page \'{name}\' ?' => '<b>מחיקת העמוד</b>

האם אתה בטוח שברצונך למחוק
את העמוד \'{name}\' ?',
  '<b>Enable Version Control</b>

Version control is currently not enabled for this notebook.
Do you want to enable it ?' => '<b>אפשר בקרת גירסאות</b>

בקרת הגירסאות אינה פעילה עבור מחברת זו.
האם ברצונך להפעיל אותה ?',
  '<b>Folder does not exist.</b>

The folder: {path}
does not exist, do you want to create it now?' => '<b>התיקייה אינה קיימת.</b>

התיקייה: {path}
אינה קיימת, האם ברצונך ליצור אותה כעת?',
  '<b>Page already exists</b>

The page \'{name}\'
already exists.
Do you want to overwrite it?' => '<b>העמוד כבר קיים</b>

העמוד \'{name}\'
כבר קיים.
האם ברצונך לשכתב עליו?',
  '<b>Restore page to saved version?</b>

Do you want to restore page: {page}
to saved version: {version} ?

All changes since the last saved version will be lost !' => '<b>שחזר את העמוד לגירסתו השמורה?</b>

האם ברצונך לשחזר את העמוד: {page}
לגירסה השמורה: {version} ?

כל השינויים מאז השמירה האחרונה יאבדו !',
  '<b>Upgrade calendar pages to 0.24 format?</b>

This notebook contains pages for dates using the format yyyy_mm_dd.
Since Zim 0.24 the format yyyy:mm:dd is used by default, creating
namespaces per month.

Do you want to upgrade this notebook to the new layout?
' => '<b>לשדרג את לוח השנה למבנה 0.24?</b>

מחברת זו מכילה עמודים לתאריכים באמצעות המבנה yyyy_mm_dd.
מאז שיחרורה של זים בגירסה 0.24 נעשה שימוש בתבנית ברירת המחדל yyyy:mm:dd, וכך נוצרים מתחמים לכל חודש.

האם ברצונך לשדרג מחברת זו למערך החדש?
',
  'Add \'tearoff\' strips to the menus' => 'הוסף רצועות \'זריזות\' לתפריטים',
  'Application show two text files side by side' => 'יישום המציג את שני קבצי הטקסט האחד לצד השני',
  'Application to compose email' => 'תוכנה לחיבור דואל',
  'Application to edit text files' => 'תוכנה לעריכת קבצי טקסט',
  'Application to open directories' => 'תוכנה לפתיחת תיקיות',
  'Application to open urls' => 'תוכנה לפתיחת קישורים',
  'Attach _File|Attach external file' => 'צרף _קובץ|צרף קובץ חיצוני',
  'Attach external files' => 'צרף קבצים חיצוניים',
  'Auto-format entities' => 'עיצוב ישויות אוטומטי',
  'Auto-increment numbered lists' => 'רשימות בעלות מספרים עוקבים',
  'Auto-link CamelCase' => 'אוטומטית קשר רישיות ביניים',
  'Auto-link files' => 'קשר-אוטומטית לקבצים',
  'Auto-save version on close' => 'שמור גירסה אוטומטית עם הסגירה',
  'Auto-select words' => 'בחר מילים אוטומטית',
  'Automatically increment items in a numbered list' => 'אוטומטית העלה את הפריטים ברשימה ממוספרת',
  'Automatically link file names when you type' => 'קשר אוטומטית את שמות הקבצים בזמן ההקלדה',
  'Automaticly link CamelCase words when you type' => 'אוטומטית קשר מילים בעלות רישיות ביניים בזמן ההקלדה',
  'Automaticly select the current word when you toggle the format' => 'אוטומטית בחר את המילה הנוכחית כאשר העיצוב מוחלף',
  'Bold' => 'מודגש',
  'Calen_dar|Show calendar' => 'ל_וח שנה|הצג את לוח השנה',
  'Calendar' => 'לוח שנה',
  'Can not find application "bzr"' => 'לא ניתן למצוא את היישום "bzr"',
  'Can not find application "{name}"' => 'לא ניתן למצוא את היישום "{name}"',
  'Can not save a version without comment' => 'לא ניתן לשמור את הגירסה בלי הערה',
  'Can not save to page: {name}' => 'לא ניתן לשמור לעמוד: {name}',
  'Can\'t find {url}' => 'לא ניתן למצוא את הכתובת {url}',
  'Cha_nge' => 'ש_נה',
  'Chars' => 'תווים',
  'Check _spelling|Spell check' => '_בדוק איות|בדוק איות',
  'Check checkbox lists recursive' => 'בדוק האם רשימות הסימונים הן רקורסיביות',
  'Checking a checkbox list item will also check any sub-items' => 'בודק פריט ברשימת הסימונים תבדוק גם את כל תת־הפריטים שלו',
  'Choose {app_type}' => 'בחר {app_type}',
  'Co_mpare Page...' => 'הש_ווה עמוד...',
  'Command' => 'פקודה',
  'Comment' => 'הערה',
  'Compare this version with' => 'השווה גירסה זו עם',
  'Copy Email Address' => 'העתק כתובת דואל',
  'Copy Location|Copy location' => 'העתק מיקום|העתק מיקום',
  'Copy _Link' => 'העתק _קישור',
  'Could not delete page: {name}' => 'לא ניתן למחוק עמוד: {name}',
  'Could not get annotated source for page {page}' => 'לא ניתן לאחזר את מקור הדף המפורש {page}',
  'Could not get changes for page: {page}' => 'לא ניתן לאחזר את השינויים בעמוד: {page}',
  'Could not get changes for this notebook' => 'לא ניתן לאחזר את השינויים עבור מחברת זו',
  'Could not get file for page: {page}' => 'לא ניתן לאחזר את הקובץ עבור העמוד: {page}',
  'Could not get versions to compare' => 'לא ניתן לאחזר גירסאות להשוואה',
  'Could not initialize version control' => 'לא ניתן להפעיל את בקרת הגירסאות',
  'Could not load page: {name}' => 'לא ניתן לטעון עמוד: {name}',
  'Could not rename {from} to {to}' => 'לא ניתן לשנות שם מ-{from} אל {to}',
  'Could not save page' => 'לא ניתן לשמור עמוד',
  'Could not save version' => 'לא ניתן לשמור גירסה',
  'Creating a new link directly opens the page' => 'יצירת קישור חדש אוטומטית פותחת את הדף',
  'Creation Date' => 'תאריך היצירה',
  'Cu_t|Cut' => 'ג_זור|גזור',
  'Current' => 'נוכחית',
  'Customise' => 'התאמה אישית',
  'Date' => 'תאריך',
  'Default notebook' => 'מחברת ברירת המחדל',
  'Details' => 'פרטים',
  'Diff Editor' => 'עורך שינויים',
  'Diff editor' => 'עורך שינויים',
  'Directory' => 'תיקיה',
  'Document Root' => 'יסוד המסמך',
  'E_quation...|Insert equation' => 'מ_שוואה|הוסף משוואה',
  'E_xport...|Export' => 'יי_צא...|ייצא',
  'E_xternal Link...|Insert external link' => 'קישור _חיצוני...|הוסף קישור חיצוני',
  'Edit Image' => 'ערוך תמונה',
  'Edit Link' => 'ערוך קישור',
  'Edit Query' => 'ערוך שאילתה',
  'Edit _Source|Open source' => 'ער_וך מקור|פתח מקור',
  'Edit notebook' => 'ערוך מחברת',
  'Edit text files "wiki style"' => 'ערוך קבצי טקסט "בסגנון ויקי"',
  'Editing' => 'עריכה',
  'Email client' => 'לקוח דוא"ל',
  'Enabled' => 'מופעל',
  'Equation Editor' => 'עורך משוואות',
  'Equation Editor Log' => 'דוח עורך המשוואות',
  'Expand side pane' => 'הרחב חלונית צד',
  'Export page' => 'ייצא דף',
  'Exporting page {number}' => 'מייצא עמוד {number}',
  'Failed to cleanup SVN working copy.' => 'כשל בנקיון העותק הפעיל מה־SVN.',
  'Failed to load SVN plugin,
do you have subversion utils installed?' => 'שגיאה בטעינת תוסף ה־SVN,
האם מותקנים אצלך העזרים של subversion?',
  'Failed to load plugin: {name}' => 'שגיאה בטעינת תוסף: {name}',
  'Failed update working copy.' => 'עדכון העותק הפעיל נכשל.',
  'File browser' => 'סייר קבצים',
  'File is not a text file: {file}' => 'הקובץ אינו קובץ טקסט: {file}',
  'Filter' => 'מסנן',
  'Find' => 'חפש',
  'Find Ne_xt|Find next' => 'חפש את ה_בא|חפש את הבא',
  'Find Pre_vious|Find previous' => 'חפש את ה_קודם|חפש את הקודם',
  'Find and Replace' => 'חפש והחלף',
  'Find what' => 'מה לחפש',
  'Follow new link' => 'עקוב אחר קישור חדש',
  'For_mat|' => 'עי_צוב|',
  'Format' => 'מבנה',
  'General' => 'כללי',
  'Go to "{link}"' => 'גש אל "{link}"',
  'H_idden|.' => 'מו_סתר|.',
  'Head _1|Heading 1' => 'כותרת_1|כותרת 1',
  'Head _2|Heading 2' => 'כותרת _2|כותרת 2',
  'Head _3|Heading 3' => 'כותרת _3|כותרת 3',
  'Head _4|Heading 4' => 'כותרת _4|כותרת 4',
  'Head _5|Heading 5' => 'כותרת _5|כותרת 5',
  'Head1' => 'כותרת1',
  'Head2' => 'כותרת2',
  'Head3' => 'כותרת3',
  'Head4' => 'כותרת4',
  'Head5' => 'כותרת5',
  'Height' => 'גובה',
  'Home Page' => 'דף הבית',
  'Icon' => 'סמל',
  'Id' => 'מזהה',
  'Include all open checkboxes' => 'כלול את כל תיבות הסימון הפתוחות',
  'Index page' => 'עמוד מפתח',
  'Initial version' => 'גירסה ראשונית',
  'Insert Date' => 'הוסף תאריך',
  'Insert Image' => 'הוסף תמונה',
  'Insert Link' => 'הוסף קישור',
  'Insert from file' => 'הוסף מקובץ',
  'Interface' => 'ממשק',
  'Italic' => 'נטוי',
  'Jump to' => 'עבור אל',
  'Jump to Page' => 'עבור לעמוד',
  'Lines' => 'שורות',
  'Links to' => 'קישור אל',
  'Match c_ase' => 'התאם _רישיות',
  'Media' => 'מדיה',
  'Modification Date' => 'תאריך השינוי',
  'Name' => 'שם',
  'New notebook' => 'מחברת חדשה',
  'New page' => 'עמוד חדש',
  'No such directory: {name}' => 'אין כזו תיקיה: {name}',
  'No such file or directory: {name}' => 'לא קיימים קובץ או תיקייה: {name}',
  'No such file: {file}' => 'קובץ לא קיים: {file}',
  'No such notebook: {name}' => 'לא קיימת מחברת: {name}',
  'No such page: {page}' => 'אין כלל עמוד כזה: {page}',
  'No such plugin: {name}' => 'אין תוסף כזה: {name}',
  'Normal' => 'רגיל',
  'Not Now' => 'לא כעת',
  'Not a valid page name: {name}' => 'שם לא תקני לעמוד: {name}',
  'Not an url: {url}' => 'כתובת לא חוקית: {url}',
  'Note that linking to a non-existing page
also automatically creates a new page.' => 'שים לב שקישור לדף שאינו קיים
מייצר דף חדש באופן עצמאי.',
  'Notebook' => 'מחברת',
  'Notebooks' => 'מחברות',
  'Open Document _Folder|Open document folder' => 'פתח _תיקיית המסמך|פתח תיקיית המסמך',
  'Open Document _Root|Open document root' => 'פתח _שורש המסמך|פתח שורש המסמך',
  'Open _Directory' => 'פתח ת_יקיה',
  'Open notebook' => 'פתח מחברת',
  'Other...' => 'אחר...',
  'Output' => 'פלט',
  'Output dir' => 'תיקיית הפלט',
  'P_athbar type|' => 'ס_וג סרגל הנתיב|',
  'Page' => 'עמוד',
  'Page Editable|Page editable' => 'הדף ניתן לעריכה|הדף ניתן לעריכה',
  'Page name' => 'שם עמוד',
  'Pages' => 'עמודים',
  'Password' => 'סיסמה',
  'Please enter a comment for this version' => 'נא הזינו הערה לגירסה זו',
  'Please enter a name to save a copy of page: {page}' => 'נא הזן שם כדי לשמור עותק של העמוד: {page}',
  'Please enter a {app_type}' => 'נא הזן {app_type}',
  'Please give a page first' => 'נא ספקו עמוד תחילה',
  'Please give at least a directory to store your pages.
For a new notebook this should be an empty directory.
For example a "Notes" directory in your home dir.' => 'יש להזין לפחות את התיקייה לאיחסון הדפים שלך.
למחברת חדשה יש להשתמש בתיקייה ריקה.
לדוגמה תיקייה בשם "הערות" בתיקיית הבית שלך.',
  'Please provide the password for
{path}' => 'נא ספק את הסיסמה עבור
{path}',
  'Please select a notebook first' => 'נא בחרו מחברת תחילה',
  'Please select a version first' => 'נא בחר גירסה תחילה',
  'Plugin already loaded: {name}' => 'התוסף כבר נטען: {name}',
  'Plugins' => 'תוספים',
  'Pr_eferences|Preferences dialog' => 'ה_עדפות|תיבת דו-שיח העדפות',
  'Preferences' => 'העדפות',
  'Prefix document root' => 'קידומת לשורש המסמכים',
  'Print to Browser|Print to browser' => 'הדפס לדפדפן|הדפס לדפדפן',
  'Prio' => 'עדיפות',
  'Proper_ties|Properties dialog' => 'מא_פיינים|תיבת דו שיח מאפיינים',
  'Properties' => 'מאפיינים',
  'Rank' => 'דירוג',
  'Re-build Index|Rebuild index' => 'בנה את המפתח מחדש|בנה את המפתח מחדש',
  'Recursive' => 'רקורסיבי',
  'Rename page' => 'שנה את שם העמוד',
  'Rename to' => 'שינוי השם אל',
  'Replace _all' => 'החלף ה_כל',
  'Replace with' => 'החלף עם',
  'SVN cleanup|Cleanup SVN working copy' => 'ניקוי SVN|נקה עותק פעיל של SVN',
  'SVN commit|Commit notebook to SVN repository' => 'מסירת SVN|מסירת המחברת למאגר SVN',
  'SVN update|Update notebook from SVN repository' => 'עדכון SVN|עדכון המחברת ממאגר SVN',
  'S_ave Version...|Save Version' => 'ש_מור גירסה...|שמור גירסה',
  'Save Copy' => 'שמור עותק',
  'Save version' => 'שמור גירסה',
  'Scanning tree ...' => 'סורק את העץ...',
  'Search' => 'חפש',
  'Search _Backlinks...|Search Back links' => 'חפש ב_קישורי חזרה...|חפש בקישורי החזרה',
  'Select File' => 'בחר קובץ',
  'Select Folder' => 'בחר תיקייה',
  'Send To...' => 'שלח אל...',
  'Show cursor for read-only' => 'הצג סמן לקריאה-בלבד',
  'Show the cursor even when you can not edit the page. This is useful for keyboard based browsing.' => 'הצג את הסמן אפילו כאשר אינך יכול לערוך את הדף. יעיל למטרות עיון באמצעות המקלדת.',
  'Slow file system' => 'מערכת קבצים איטית',
  'Source' => 'מקור',
  'Source Format' => 'מבנה המקור',
  'Start the side pane with the whole tree expanded.' => 'התחל את חלונית הצג עם עץ מורחב במלואו.',
  'Stri_ke|Strike' => 'קו _חוצה|קו חוצה',
  'Strike' => 'קו חוצה',
  'TODO List' => 'רשימת מטלות',
  'Task' => 'משימה',
  'Tearoff menus' => 'תפריטים מהירים',
  'Template' => 'תבנית',
  'Text' => 'טקסט',
  'Text Editor' => 'עורך טקסט',
  'Text _From File...|Insert text from file' => 'טקסט מ_קובץ...|הוסף טקסט מקובץ',
  'Text editor' => 'עורך טקסט',
  'The equation failed to compile. Do you want to save anyway?' => 'הידור המשוואה נכשלה. האם ברצונך לשמור על כל אופן?',
  'The equation for image: {path}
is missing. Can not edit equation.' => 'המשוואה לתמונה: {path}
חסרה. לא ניתן לערוך את המשוואה.',
  'This notebook does not have a document root' => 'למחברת זו אין שורש מסמכים',
  'This page does not exist
404' => 'הדף אינו קיים
404',
  'This page does not have a document folder' => 'לעמוד זה אין תיקיית מסמך',
  'This page does not have a source' => 'לדף זה אין מקור',
  'This page was updated in the repository.
Please update your working copy (Tools -> SVN update).' => 'עמוד זה עודכן במאגר.
אנא עדכן את העותק הפעיל שלך (כלים ->עדכון SVN).',
  'To_day|Today' => 'ה_יום|היום',
  'Toggle Chechbox \'V\'|Toggle checkbox' => 'סמן/בטל תיבת בחירה \'V\'|סמן/בטל תיבת בחירה',
  'Toggle Chechbox \'X\'|Toggle checkbox' => 'סמן/בטל תיבת בחירה \'X\'|סמן/בטל תיבת בחירה',
  'Underline' => 'קו תחתי',
  'Updating links' => 'מעדכן קישורים',
  'Updating links in {name}' => 'מעדכן קישורים תחת {name}',
  'Updating..' => 'מעדכן...',
  'Use "Backspace" to un-indent' => 'השתמש ב-"Backspace" (מחיקה) כדי לבטל הזחה',
  'Use "Ctrl-Space" to switch focus' => 'השתמש ב-"Ctrl-רווח" כדי להחליף מיקוד',
  'Use "Enter" to follow links' => 'השתמש ב-"Enter" למעקב אחר קישורים',
  'Use autoformatting to type special characters' => 'השתמש בעיצוב אוטומטי כדי להקליד תווים מיוחדים',
  'Use custom font' => 'השתמש בגופן מותאם אישית',
  'Use the "Backspace" key to un-indent bullet lists (Same as "Shift-Tab")' => 'השתמש ב-"Backspace" (מחיקה) כדי לבטל הזחת רשימות תבליטים (בדומה ל-"Shift+Tab")',
  'Use the "Ctrl-Space" key combo to switch focus between text and side pane. If disabled you can still use "Alt-Space".' => 'השתמש בצירוף המקשים "Ctrl-רווח" כדי להעביר את המיקוד בין הטקסט לבין חלונית הצד. במידה ומבוטל עדיין ניתן להשתמש ב-"Alt-רווח".',
  'Use the "Enter" key to follow links. If disabled you still can use "Alt-Enter"' => 'השתמש במקש ה-"Enter" (אנטר) כדי לעקוב אחר קישורים. במידה ומבוטל עדיין תוכל להשתמש ב-"Alt+Enter"',
  'User' => 'משתמש',
  'User name' => 'שם משתמש',
  'Verbatim' => 'מדוייק',
  'Versions' => 'גירסאות',
  'View _Annotated...' => 'הצג _מפורש...',
  'View _Log' => 'הצ_ג דוח',
  'Web browser' => 'דפדפן אינטרנט',
  'Whole _word' => 'מילה _שלמה',
  'Width' => 'רוחב',
  'Word Count' => 'ספירת המילים',
  'Words' => 'מילים',
  'You can add rules to your search query below' => 'תוכל להוסיף כללים לשאילתת החיפוש שלך להלן',
  'You can choose using either the <b>Bazaar</b> or the <b>Subversion</b> Version Control System.
Please click \'help\' to read about the system requirements.' => 'תוכל להשתמש במערכות בקרת הגירסאות <b>Bazaar</b> או <b>Subversion</b>.
אנא לחץ על \'עזרה\' כדי לקרוא אודות דרישות המערכת.',
  'You have no {app_type} configured' => 'לא מוגדרות אצלך {app_type}',
  'You need to restart the application
for plugin changes to take effect.' => 'עליך לאתחל את התוכנה על מנת
שהשינויים בתוספים יכנסו לתוקף.',
  'Your name; this can be used in export templates' => 'שמך; ניתן לעשות בו שימוש בתבניות יצוא',
  'Zim Desktop Wiki' => 'זים הוויקי השולחני',
  '_About|About' => '_אודות|אודות',
  '_All' => '_הכל',
  '_Back|Go page back' => 'ח_זרה|חזור לעמוד הקודם',
  '_Bold|Bold' => '_מודגש|מודגש',
  '_Browse...' => '_עיין...',
  '_Bugs|Bugs' => '_שגיאות|שגיאות',
  '_Child|Go to child page' => '_צאצא|עבור לעמוד צאצא',
  '_Close|Close window' => '_סגור|סגור את החלון',
  '_Contents|Help contents' => 'ת_כנים|תכני העזרה',
  '_Copy Page...|Copy page' => 'ה_עתק עמוד...|העתק עמוד',
  '_Copy|Copy' => 'ה_עתק|העתק',
  '_Date and Time...|Insert date' => '_שעה ותאריך|הוסף תאריך',
  '_Delete Page|Delete page' => 'מחק _עמוד|מחק עמוד',
  '_Delete|Delete' => '_מחק|מחק',
  '_Discard changes' => 'ה_תעלם מהשינויים',
  '_Edit' => '_ערוך',
  '_Edit Equation' => 'ע_רוך משוואה',
  '_Edit Link' => '_ערוך קישור',
  '_Edit Link...|Edit link' => '_ערוך קישור...|ערוך קישור',
  '_Edit|' => '_עריכה|',
  '_FAQ|FAQ' => '_שאלות נפוצות|שאלות נפוצות',
  '_File|' => '_קובץ|',
  '_Filter' => '_מסנן',
  '_Find...|Find' => 'ח_פש...|חפש',
  '_Forward|Go page forward' => 'ק_דימה|התקדם לעמוד הבא',
  '_Go|' => 'ה_פעלה|',
  '_Help|' => 'ע_זרה|',
  '_History|.' => 'הי_סטוריה|.',
  '_Home|Go home' => '_בית|גש לעמוד הבית',
  '_Image...|Insert image' => '__תמונה...|הוסף תמונה',
  '_Index|Show index' => '_מפתח הנושאים|הצג את מפתח הנושאים',
  '_Insert' => 'ה_וסף',
  '_Insert|' => '_הוספה|',
  '_Italic|Italic' => '_נטוי|נטוי',
  '_Jump To...|Jump to page' => 'עבור _אל...|עבור לעמוד',
  '_Keybindings|Key bindings' => '_צירופי מקשים|צירופי מקשים',
  '_Link' => '_קישור',
  '_Link to date' => '_קשר לתאריך',
  '_Link...|Insert link' => '_קישור...|הוסף קישור',
  '_Link|Link' => '_קישור|קישור',
  '_Namespace|.' => 'שם _תחום|.',
  '_New Page|New page' => '_עמוד חדש|עמוד חדש',
  '_Next' => 'ה_בא',
  '_Next in index|Go to next page' => 'ה_בא במפתח|עבור לעמוד הבא',
  '_Normal|Normal' => 'ר_גיל|רגיל',
  '_Notebook Changes...' => 'שינויים ב_מחברת...',
  '_Open Another Notebook...|Open notebook' => 'פתח מחברת _אחרת...|פתח מחברת',
  '_Open link' => 'פתח _קישור',
  '_Overwrite' => '_דרוס',
  '_Page' => '_עמוד',
  '_Page Changes...' => '_שינויי העמוד...',
  '_Parent|Go to parent page' => '_אב|עבור לעמוד האב',
  '_Paste|Paste' => 'ה_דבק|הדבק',
  '_Preview' => '_תצוגה מקדימה',
  '_Previous' => 'ה_קודם',
  '_Previous in index|Go to previous page' => 'ה_קודם במפתח|עבור לעמוד הקודם',
  '_Properties' => 'מ_אפיינים',
  '_Quit|Quit' => '_צא|יציאה',
  '_Recent pages|.' => '_דפים אחרונים|.',
  '_Redo|Redo' => '_בצע שוב|בצע שוב',
  '_Reload|Reload page' => '_רענן|רענן עמוד',
  '_Rename' => '_שנה שם',
  '_Rename Page...|Rename page' => 'ש_נה שם העמוד...|שנה שם העמוד',
  '_Replace' => 'ה_חלף',
  '_Replace...|Find and Replace' => 'ה_חלף|חפש והחלף',
  '_Reset' => '_איפוס',
  '_Restore Version...' => '_שחזר גירסה...',
  '_Save Copy' => '_שמור עותק',
  '_Save a copy...' => '_שמור עותק...',
  '_Save|Save page' => '_שמור|שמור את העמוד',
  '_Screenshot...|Insert screenshot' => '_צילום מסך...|הוסף צילום מסך',
  '_Search...|Search' => '_חפש...|חפש',
  '_Search|' => '_חיפוש|',
  '_Send To...|Mail page' => 'ש_לח אל...|שלח את הדף בדואל',
  '_Statusbar|Show statusbar' => '_שורת מצה|הצג את שורת המצב',
  '_TODO List...|Open TODO List' => '_רשימת מטלות...|פתח רשימת מטלות',
  '_Today' => 'ה_יום',
  '_Toolbar|Show toolbar' => '_סרגל כלים|הצג את סרגל הכלים',
  '_Tools|' => '_כלים|',
  '_Underline|Underline' => '_קו תחתי|קו תחתי',
  '_Undo|Undo' => '_בטל|בטל',
  '_Update links in this page' => '_עדכן קישורים בעמוד זה',
  '_Update {number} page linking here' => [
    'ע_דכן עמוד {number} המקשר לכאן',
    'ע_דכן {number} עמודים המקשרים לכאן'
  ],
  '_Verbatim|Verbatim' => '_מדוייק|מדוייק',
  '_Versions...|Versions' => 'גי_רסאות...|גירסאות',
  '_View|' => '_תצוגה|',
  '_Word Count|Word count' => '_ספירת מילים|ספירת מילים',
  'other...' => 'אחר...',
  '{name}_(Copy)' => '{name}_(עותק)',
  '{number} _Back link' => [
    '_קישורי חזרה {number}',
    '{number} _קישורי חזרה'
  ],
  '{number} item total' => [
    'פריט {number} סך הכל',
    '{number} פריטים סך הכל'
  ]
};
