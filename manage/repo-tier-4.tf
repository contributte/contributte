resource "github_repository" "digitalpaint" {
	name                 = "digitalpaint"
	description          = "💦 Digital Paint: Paintball 2.0"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "http://digitalpaint.org/"
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "rankface" {
	name                 = "rankface"
	description          = "🐘 Simple PHP library to collect page ranks"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "gopay" {
	name                 = "gopay"
	description          = ":moneybag: Integrace Gopay pro Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["ecommerce","gopay","markette","nette","payments","php","soap"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "kleinphp-smartyphp" {
	name                 = "kleinphp-smartyphp"
	description          = "💀 [DEPRECATED] Klein.php with smarty template engine"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://f00b4r.dev"
	topics               = ["klein","php","smarty"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "mobilni-platby" {
	name                 = "mobilni-platby"
	description          = ":moneybag: MobilniPlatby.cz for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/mobilni-platby.html"
	topics               = ["contributte","mobilniplatby","nette","payments","php","sms"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "codeception" {
	name                 = "codeception"
	description          = ":arrow_forward: Integration of Nette Framework to Codeception."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/codeception.html"
	topics               = ["codeception","contributte","nette","nette-framework","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "newrelic" {
	name                 = "newrelic"
	description          = "💎 NewRelic PHP agent integration for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["contributte","monitoring","newrelic","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "pdf" {
	name                 = "pdf"
	description          = "📮 PDF toolbox for Nette Framework using mPDF"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/pdf.html"
	topics               = ["contributte","mpdf","nette","pdf","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "menu-control" {
	name                 = "menu-control"
	description          = "🍔 Menu and breadcrumb components for Nette framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["component","contributte","control","menu","ui"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "thumbator" {
	name                 = "thumbator"
	description          = "💀 [DISCONTINUED] Serve and resize images on-the-fly for Nette Framework (@nette). Use contributte/image-storage."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","images","nette-framework","php","resize"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "newrelic-tracy" {
	name                 = "newrelic-tracy"
	description          = "💀 [DISCONTINUED] Newrelic Tracy extension for Nette Framework (@nette). Use contributte/newrelic."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","debugging","nette-framework","newrelic","tracy"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "reCAPTCHA" {
	name                 = "reCAPTCHA"
	description          = ":bangbang: Google reCAPTCHA (security) for Nette Framework \\ Forms"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/reCAPTCHA.html"
	topics               = ["contributte","forms","google-recaptcha","nette","nette-framework","recaptcha"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "kleinphp-latte" {
	name                 = "kleinphp-latte"
	description          = "🐘 Klein.php with Latte Template Engine by Nette."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["klein","latte","php","router","templates"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "planette-play-site" {
	name                 = "planette-play-site"
	description          = "💀  [DISCONTINUED] Former Planette (Nette Play) Portal"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://blog.nette.org"
	topics               = ["community","contributte","nette-framework","php","planette"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "social" {
	name                 = "social"
	description          = ":fries: Social plugins  (facebook, twitter, google) for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/social.html"
	topics               = ["contributte","facebook","nette","plugins","social","twitter"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "forms-controls" {
	name                 = "forms-controls"
	description          = "💀 [DISCONTINUED] Inputs, controls and extensions for Nette Forms (@nette). Use contributte/forms."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","forms","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "latte-email" {
	name                 = "latte-email"
	description          = "💀 [DISCONTINUED] Protect your email addresses in Latte template engine. Use contributte/latte."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","email","latte","nette-framework","php","protection","templates"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "tester-skeleton" {
	name                 = "tester-skeleton"
	description          = "🎁 Nette\\Tester project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","e2e","nette","nette-framework","nette-tester","qa","tester","testing","tests"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "latte-formatter" {
	name                 = "latte-formatter"
	description          = "💀 [DISCONTINUED] Simple string formatter for Latte. Use contributte/utils."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","formatter","latte","nette-framework"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "dummy-events" {
	name                 = "dummy-events"
	description          = "💀 [DISCONTINUED] Ultra easy-to-use event system for Nette Framework (@nette). Use contributte/event-dispatcher. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","event-dispatcher","event-management","event-manager","events","nette","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "gopay-inline" {
	name                 = "gopay-inline"
	description          = ":credit_card: GoPay Inline Payment for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/gopay-inline.html"
	topics               = ["api","contributte","curl","ecommerce","gopay","gopay-inline","markette","nette","payments"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "imap" {
	name                 = "imap"
	description          = ":mailbox: Simple PHP IMAP wrapper"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://f00b4r.dev"
	topics               = ["imap","mail","ninjify","php","wrapper"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "cli-http" {
	name                 = "cli-http"
	description          = "💀 [DISCONTINUED] Provide HTTP settings in CLI mode for Nette Framework (@nette). Use contributte/http."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["command-line","contributte","http","nette-framework"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "ghpage" {
	name                 = "ghpage"
	description          = "💀 [DISCONTINUED] Github page generator written in Nette Framework (@nette)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","nette-framework","pages","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "latte-parsedown" {
	name                 = "latte-parsedown"
	description          = "💀 [DISCONTINUED] Parsedown parser for Latte template engine. Use contributte/latteparsedown-extra."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","latte","markdown","nette-framework","parsedown","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "latte-parsedown-extra" {
	name                 = "latte-parsedown-extra"
	description          = ":tractor: Parsedown (markdown) template parser for Nette \\ Latte (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/latte-parsedown-extra.html"
	topics               = ["latte","markdown","nette","parsedown","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "gopay-api" {
	name                 = "gopay-api"
	description          = "💰 GopayAPI SDK [Unofficial]"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://www.gopay.com/"
	topics               = ["api","ecommerce","gopay","markette","nette","php","soap"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "uniparser" {
	name                 = "uniparser"
	description          = "💀 [DISCONTINUED] Universal text parser (Texy, Markdown, Parsedown, ...) for Nette Framework (@nette). Use contributte/latte."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","latte","markdown","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "simple-blogger" {
	name                 = "simple-blogger"
	description          = "💀 [DISCONTINUED] Simple blogger for Nette Framework (@nette)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["blogger","contributte","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "ftpdeployer" {
	name                 = "ftpdeployer"
	description          = ":horse_racing: FTP deployment (by @dg) extension for Nette Framework (@nette)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/deployer-extension.html"
	topics               = ["contributte","deploy","deployment","ftp-deployment","nette","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "nextras-orm-generator" {
	name                 = "nextras-orm-generator"
	description          = ":wolf: Rich Nextras\\ORM entity generator for fast prototyping your new project."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/nextras-orm-generator.html"
	topics               = ["contributte","database","entity","generator","nette","nexras","orm"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "live-form-validation" {
	name                 = "live-form-validation"
	description          = ":no_entry: Nice client-side live form validation for Nette Forms."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/live-form-validation.html"
	topics               = ["forms","javascript","live","nette","validation"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "forms-wizard" {
	name                 = "forms-wizard"
	description          = ":tophat: Easy to use step-by-step form for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/forms-wizard.html"
	topics               = ["contributte","forms","nette","steps","wizard"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "forms-multiplier" {
	name                 = "forms-multiplier"
	description          = ":repeat: Form multiplier & replicator for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/forms-multiplier.html"
	topics               = ["contributte","forms","multiplier","nette","replicator"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "ntdb" {
	name                 = "ntdb"
	description          = "💀 [DISCONTINUED] Nested Transaction for Nette Database (@nette). Use contributte/database."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","database","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "thepay-api" {
	name                 = "thepay-api"
	description          = ":dollar: Port of ThePay library"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/thepay-api.html"
	topics               = ["library","thepay"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "thepay" {
	name                 = "thepay"
	description          = ":dollar: ThePay integration for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/thepay.html"
	topics               = ["contributte","money","payment","thepay"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "componette-site" {
	name                 = "componette-site"
	description          = ":loop: Addons, plugins, components and extensions (@componette :heart: @nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://componette.org"
	topics               = ["components","nette-framework","portal"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "platte" {
	name                 = "platte"
	description          = "Latte template engine for Phalcon"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["latte","latte-template-engine","macros","phalcon"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "pidic" {
	name                 = "pidic"
	description          = "Nette Dependency Injection/Container for Phalcon"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["dependency-injection","phalcon"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "cookbook" {
	name                 = "cookbook"
	description          = ":notes: Cookbook for Nette Framework (@nette) & Contributte (@contributte). Read it while its HOT!"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["configuration","contributte","dependency-injection","documentation","manual","neon","nette","nette-framework","php","services"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "gopay-simple" {
	name                 = "gopay-simple"
	description          = "💀 [DISCONTINUED] One-class Gopay API library. Use contributte/gopay-inline."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["api","contributte","ecommerce","gopay","markette","nette-framework","payments","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "blogette" {
	name                 = "blogette"
	description          = "💀 [DISCONTINUED] PoC of blogging platform for Nette Framework (@nette)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["blogging","contributte","latte","nette-framework","templates"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "datagrid" {
	name                 = "datagrid"
	description          = ":muscle: DataGrid for Nette Framework: filtering, sorting, pagination, tree view, table view, translator, etc"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/datagrid/"
	topics               = ["contributte","datagrid","dibi","doctrine","nette","nette-database","nette-framework","nextras-orm"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "webhosting-tools" {
	name                 = "webhosting-tools"
	description          = ":ghost: Hosting Apps"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["adminer","apps","php","phpinfo","website"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "benchmarks" {
	name                 = "benchmarks"
	description          = ":hourglass: Various benchmarks tests for PHP (frameworks, routers, dbals) and other. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["benchmark","dbal","framework","nette-framework","php","router","routing"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "image-storage" {
	name                 = "image-storage"
	description          = ":stars: Image storage for Nette framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/image-storage.html"
	topics               = ["contributte","image-storage","images","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "api-router" {
	name                 = "api-router"
	description          = ":man: RESTful router for your API in Nette Framework (@nette). Created either directly or via annotation."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/api-router.html"
	topics               = ["annotations","api","contributte","nette-framework","router","routing"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "api-docu" {
	name                 = "api-docu"
	description          = ":woman: Document generator for ApiRouter routes - awesome runtime documentation"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/api-docu.html"
	topics               = ["api","contributte","documentation","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "nusoap" {
	name                 = "nusoap"
	description          = ":smirk: Fixed NuSOAP for PHP 5.6 - 8.2"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://f00b4r.github.io/nusoap/"
	topics               = ["http","library","nusoap","php","soap"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "invoice" {
	name                 = "invoice"
	description          = ":memo: PDF invoice generator "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/invoice.html"
	topics               = ["contributte","invoice","invoice-generator","invoice-pdf","invoice-template","invoices","invoicing","nette","pdf-invoice","pdf-invoice-generation"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "datagrid-nette-database-data-source" {
	name                 = "datagrid-nette-database-data-source"
	description          = ":feet: Nette\\Database data source for ublaboo/datagrid"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/datagrid-nette-database-data-source.html"
	topics               = ["contributte","data-source","datagrid","nette-database"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "wordcha" {
	name                 = "wordcha"
	description          = ":exclamation: Word based captcha (security) for Nette Framework \\ Forms (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/wordcha.html"
	topics               = ["captcha","contributte","nette","nette-framework","security","word-based"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "fileupload" {
	name                 = "fileupload"
	description          = "🆙 File uploads on steroids for Nette Framework (@nette). Implements blueimp/jquery-file-upload.  "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/fileupload.html"
	topics               = ["blueimp","contributte","jquery-fileupload","nette","nette-framework","upload"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "seznamcaptcha" {
	name                 = "seznamcaptcha"
	description          = ":exclamation: Seznam captcha (security) for Nette Framework \\ Forms"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/seznamcaptcha.html"
	topics               = ["captcha","contributte","forms","nette-framework","seznam-captcha"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "guzzlette" {
	name                 = "guzzlette"
	description          = ":cyclone: Guzzle integration into Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/guzzlette.html"
	topics               = ["client","contributte","guzzle","http","nette","nette-framework","request","response"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "fly-response" {
	name                 = "fly-response"
	description          = "💀 [DISCONTINUED] Serve data and files on-the-fly as response to Nette Framework (@nette). Use contributte/application."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","curl","http","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "componette-dockerfiles" {
	name                 = "componette-dockerfiles"
	description          = "💀 [DISCONTINUED] Dockerfiles for Componette. Use contributte/dockerfiles."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://componette.com"
	topics               = ["componette","contributte","database","dockerfile","dockerfiles","nginx","php","proxy","varnish"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-extensions-atlantic18" {
	name                 = "doctrine-extensions-atlantic18"
	description          = ":mag: Doctrine Atlantic18/DoctrineExtensions extension for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["database","doctrine2","doctrineextensions","gedmo","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "service-autoloader" {
	name                 = "service-autoloader"
	description          = "💀 [DISCONTINUED] Nette DI container servicer autoloader for Nette Framework (@contributte). Use contributte/di."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","dependency-injection","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "nextras-criteria" {
	name                 = "nextras-criteria"
	description          = "Criteria Expression for Nextras\\ORM + Nextras\\DBAL (@nextras)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/nextras-criteria.html"
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "model-specification" {
	name                 = "model-specification"
	description          = "💀 [DISCONTINUED] Simple specification/configuration model classes. Use contributte/utils."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["model","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "nextras-orm-events" {
	name                 = "nextras-orm-events"
	description          = ":wolf: Doctrine-like events for Nextras ORM"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/nextras-orm-events.html"
	topics               = ["contributte","database","event-dispatcher","events","nette","nextras-orm","orm"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "dockerfiles" {
	name                 = "dockerfiles"
	description          = ":whale: Dockerfiles for Nette Framework. Nette in Docker. (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","development","docker","dockerfile","nette","nette-framework","orchestration","php","sandbox"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "utils" {
	name                 = "utils"
	description          = ":sparkles: Extra contrib to nette/utils (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/utils.html"
	topics               = ["arrays","contributte","filters","helpers","nette","nette-framework","strings","utils"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "webmaster-tools" {
	name                 = "webmaster-tools"
	description          = ":neckbeard: Webmaster Tools"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["generators","hash","passwords","tools","webmaster"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "application" {
	name                 = "application"
	description          = ":sparkles: Extra contrib to nette/application (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/application.html"
	topics               = ["ajax","application","contributte","mvc","mvp","nette","nette-framework","presenters"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "nextras-orm-query-object" {
	name                 = "nextras-orm-query-object"
	description          = ":wolf: Query-objects for Nextras ORM"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/nextras-orm-query-object.html"
	topics               = ["contributte","database","nette","nextras-orm","orm","query-builder"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "microapi" {
	name                 = "microapi"
	description          = "💀 [DISCONTINUED] Microapi management for Nette Framework (@nette). Use contributte/apitte."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["api","contributte","controller","http","micro","nette-framework","php","requests"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "console" {
	name                 = "console"
	description          = ":boom: Best minimal console (symfony/console) to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/console.html"
	topics               = ["cli","command-line","commands","console","contributte","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "event-dispatcher" {
	name                 = "event-dispatcher"
	description          = ":boom: Best events support (symfony/event-dispatcher) to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/event-dispatcher.html"
	topics               = ["contributte","event-dispatcher","events","listeners","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "dev" {
	name                 = "dev"
	description          = ":godmode: Set of tools for development / debugging (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/dev.html"
	topics               = ["contributte","developer-tools","development","nette","nette-framework","tracy"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "latte" {
	name                 = "latte"
	description          = ":sparkles: Extra contrib to nette/latte (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/latte.html"
	topics               = ["contributte","engine","filters","latte","macros","nette","nette-framework","templates","templating"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "security" {
	name                 = "security"
	description          = ":sparkles: Extra contrib to nette/security (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/security.html"
	topics               = ["authentication","authorization","contributte","nette","nette-framework","security"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "mail" {
	name                 = "mail"
	description          = ":sparkles: Extra contrib to nette/mail (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/mail.html"
	topics               = ["contributte","mail","mailers","message","nette","nette-framework","smtp"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "api" {
	name                 = "api"
	description          = "🆖 Powerful, documented, validated, built-in API to Nette Framework. (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/api.html"
	topics               = ["annotations","api","contributte","http","middleware","nette-framework","php","requests","responses"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "logging" {
	name                 = "logging"
	description          = ":boom: Universal logging support to Tracy / Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/logging.html"
	topics               = ["contributte","logging","nette","nette-framework","slack","tracy"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "http" {
	name                 = "http"
	description          = ":sparkles: Extra contrib to nette/http (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/http.html"
	topics               = ["cli","content-security-policy","contributte","http","nette","nette-framework","request","response"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "cache" {
	name                 = "cache"
	description          = ":sparkles: Extra contrib to nette/caching (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/cache.html"
	topics               = ["cache","caching","contributte","nette","nette-framework","sqlite","temporary"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "dataql" {
	name                 = "dataql"
	description          = "✍️GraphQL-inspired micro alternative (WIP)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "di" {
	name                 = "di"
	description          = ":sparkles: Extra contrib to nette/di (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/di.html"
	topics               = ["autoloader","contributte","dependency-injection","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "database" {
	name                 = "database"
	description          = ":sparkles: Extra contrib to nette/database (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/database.html"
	topics               = ["active-record","contributte","database","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "bootstrap" {
	name                 = "bootstrap"
	description          = ":sparkles: Extra contrib to nette/bootstrap (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/bootstrap.html"
	topics               = ["bootstrap","contributte","docker","environment","nette","nette-framework","vagrant"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "psr6-caching" {
	name                 = "psr6-caching"
	description          = ":dizzy: PSR #6 [Caching Interface] to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/psr6-caching.html"
	topics               = ["caching","contributte","nette-framework","psr-6"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "psr7-http-message" {
	name                 = "psr7-http-message"
	description          = ":dizzy: PSR #7 [HTTP Message Interface] to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/psr7-http-message.html"
	topics               = ["contributte","http","immutable","nette","nette-framework","psr-7","request","response"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "neonizer" {
	name                 = "neonizer"
	description          = ":wrench: Collection of useful scripts for manipulaton with NEON files. Support composer pre-install / post-install events. Set/get parameters, validate files."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/neonizer.html"
	topics               = ["contributte","neon","nette","nette-framework","parameters"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "middlewares" {
	name                 = "middlewares"
	description          = ":boom: Middlewares / Relay / PSR-7 support to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/middlewares.html"
	topics               = ["contributte","http","middleware","nette","nette-framework","relay","requests","responses"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "forms" {
	name                 = "forms"
	description          = ":sparkles: Extra contrib to nette/forms (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/forms.html"
	topics               = ["contributte","email","forms","inputs","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "playground" {
	name                 = "playground"
	description          = ":books: Examples, projects, webprojects, skeletons for Nette Framework (@nette) from community members. Included @contributte @apitte @nettrine projects."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/examples.html"
	topics               = ["contributte","examples","nette","nette-framework","playground","project","samples","webproject"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "event-application-bridge" {
	name                 = "event-application-bridge"
	description          = "💀 [DISCONTINUED] Symfony Event Dispatcher and Nette Application (@nette) bridge. Use contributte/event-dispatcher-extra. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["application","bridge","contributte","event-dispatcher","events","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "event-security-bridge" {
	name                 = "event-security-bridge"
	description          = "💀 [DISCONTINUED] Symfony Event Dispatcher and Nette Security (@nette) bridge. Use contributte/event-dispatcher-extra."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","event-dispatcher","events","nette-framework","php","security"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "event-bridges" {
	name                 = "event-bridges"
	description          = "💀 [DISCONTINUED] Symfony Event Dispatcher and Nette Framework (@nette) bridges. Use contributte/event-dispatcher-extra."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["application","contributte","events","nette-framework","php","security"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "webpack" {
	name                 = "webpack"
	description          = "📦 Webpack adapter for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/webpack.html"
	topics               = ["contributte","hacktoberfest","nette-framework","webpack","webpack-dev-server"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = true
}

resource "github_repository" "doctrine-orm" {
	name                 = "doctrine-orm"
	description          = ":fire: Well-integrated Doctrine ORM for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/orm.html"
	topics               = ["database","doctrine-orm","doctrine2","nette","nette-framework","nettrine","orm","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-migrations" {
	name                 = "doctrine-migrations"
	description          = ":running: Doctrine Migrations for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/migrations.html"
	topics               = ["database","doctrine-migrations","doctrine2","migrations","nette","nette-framework","nettrine"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "tracy" {
	name                 = "tracy"
	description          = ":sunglasses: Tuned Tracy Bars/Panels/BlueScreens for easy-developing"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/tracy.html"
	topics               = ["bar","contributte","development","nette","nette-framework","panel","tracy"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-dbal" {
	name                 = "doctrine-dbal"
	description          = ":bulb: Well-integrated Doctrine DBAL for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/dbal.html"
	topics               = ["database","dbal","doctrine2","mysql","nette","nettrine","oracle","postgresql"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "model" {
	name                 = "model"
	description          = "💀 [DISCONTINUED] View-Model + Model-View layer to Nette Framework (@nette). Use contributte/utils."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","model","modelview","nette","nette-framework","view","viewmodel"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "psr11-container-interface" {
	name                 = "psr11-container-interface"
	description          = ":dizzy: PSR #11 [Container Interface] to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/psr11-container-interface.html"
	topics               = ["container","dependency-injection","di","interop","nette-framework","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "rabbitmq" {
	name                 = "rabbitmq"
	description          = "🐰 RabbitMQ (AMQP, STOMP, MQTT) using BunnyPHP for Nette Framework (@nette)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/rabbitmq.html"
	topics               = ["amqp","async","bunny","contributte","mqtt","php","rabbitmq","stomp"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "planette-site" {
	name                 = "planette-site"
	description          = "💀 [DISCONTINUED] All the roads go through the Planette "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://planette.vercel.app"
	topics               = ["contributte","cookbook","examples","nette-framework","tutorials"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "commits-site" {
	name                 = "commits-site"
	description          = ":octocat: All @nette commits in one place"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://commits.nette.org"
	topics               = ["commits","github","nette","repositories"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "api-router-skeleton" {
	name                 = "api-router-skeleton"
	description          = "🎁 API router project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries by @f3l1x & @paveljanda."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/api-router-skeleton/"
	topics               = ["api","contributte","nette-framework","router"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "phpdoc" {
	name                 = "phpdoc"
	description          = "💀 [DISCONTINUED] Enhanced PHPdoc annotations for Nette Framework (@nette). Use nettrine/annotations."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["annotations","contributte","nette-framework","php","phpdoc"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-skeleton" {
	name                 = "apitte-skeleton"
	description          = "🎁  API / REST API / JSON API / PSR-7 / Middlewares project skeleton based on Nette Framework (@nette), Apitte (@apitte), Doctrine (@nettrine) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/apitte-skeleton/"
	topics               = ["api","apitte","contributte","nette-framework","nettrine","project","projectte","template"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "contributte" {
	name                 = "contributte"
	description          = ":heart: Contributte Happy Place"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","doc","members","nette","rfc","team"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = true
}

resource "github_repository" "doctrine-fixtures" {
	name                 = "doctrine-fixtures"
	description          = ":wrench: Doctrine Fixtures for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/fixtures.html"
	topics               = ["database","doctrine-fixtures","doctrine2","fixtures","nette","nettrine"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "facebook" {
	name                 = "facebook"
	description          = ":yum: Tiny Facebook SDK 5.x integration to Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/facebook.html"
	topics               = ["facebook","login","nette","oauth2","php","sdk"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte" {
	name                 = "apitte"
	description          = ":wrench: An opinionated and enjoyable API framework based on Nette Framework. Supporting content negotiation, debugging, middlewares, attributes, annotations and loving openapi/swagger."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/apitte/"
	topics               = ["api","apitte","core","http","nette","nette-framework","request","response"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-negotiation" {
	name                 = "apitte-negotiation"
	description          = "💀 [DISCONTINUED] :art: Content-Negotiation support for Apitte stack"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/negotiation.html"
	topics               = ["api","apitte","content-negotiation","contributte","negotiation","negotiaton","nette"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-openapi" {
	name                 = "apitte-openapi"
	description          = "💀 [DISCONTINUED] :family: OpenAPI specification for Apitte stack"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/openapi.html"
	topics               = ["apitte","nette","nette-framework","openapi","swagger"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-middlewares" {
	name                 = "apitte-middlewares"
	description          = "💀 [DISCONTINUED] :speedboat: Middlewares support for Apitte stack"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/middlewares.html"
	topics               = ["apitte","middlewares","nette","nette-framework","psr7"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-events" {
	name                 = "apitte-events"
	description          = "💀 [DISCONTINUED] Symfony\\EventDispatcher for Apitte stack. Use contributte/apitte."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["apitte","contributte","events","nette-framework","symfony","symfony-eventdispatcher"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-mapping" {
	name                 = "apitte-mapping"
	description          = "💀 [DISCONTINUED] Request mappers, transformers and decorators for Apitte stack. Use contributte/apitte."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["apitte","contributte","entity","mapping","nette-framework","parameters","request"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-fullstack" {
	name                 = "apitte-fullstack"
	description          = "💀 [DISCONTINUED] :thumbsup: Apitte meta package with all features"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/fullstack.html"
	topics               = ["api","apitte","fullstack","http","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-debug" {
	name                 = "apitte-debug"
	description          = "💀 [DISCONTINUED] :interrobang: Debugging tools for Apitte stack"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/debug.html"
	topics               = ["apitte","debug","debugging","nette","nette-framework","tracy"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "doctrine-annotations" {
	name                 = "doctrine-annotations"
	description          = ":memo: Standalone Doctrine Annotations for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/annotations.html"
	topics               = ["annotations","doctrine-annotations","doctrine2","nette","nettrine","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-presenter" {
	name                 = "apitte-presenter"
	description          = "💀 [DISCONTINUED] :sunflower: PSR-7 for Nette\\Presenters with Apitte stack"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/presenter.html"
	topics               = ["apitte","http","nette","nette-framework","presenter"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "apitte-console" {
	name                 = "apitte-console"
	description          = "💀 [DISCONTINUED] :pill: Symfony\\Console bridge for Apitte stack"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/console.html"
	topics               = ["apitte","cli","console","nette","nette-framework","symfony"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "fio" {
	name                 = "fio"
	description          = ":euro: Fio API integration for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/fio.html"
	topics               = ["api","education","fio","gateway","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "console-extra" {
	name                 = "console-extra"
	description          = ":recycle: Nette-based console commands for latte, DIC, MVC, security, utils and many others.  "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/console-extra.html"
	topics               = ["caching","console","contributte","nette","nette-framework","symfony-console"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "datagrid-elasticsearch-data-source" {
	name                 = "datagrid-elasticsearch-data-source"
	description          = "💀 [DISCONTINUED] ElasticSearch data source for contributte/datagrid. Use contributte/datagrid."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","data-source","datagrid","elasticsearch","nette-framework","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-cache" {
	name                 = "doctrine-cache"
	description          = ":arrows_clockwise: Doctrine Cache adapter for Nette Framework "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/cache.html"
	topics               = ["cache","doctrine-cache","doctrine2","nette-framework","nettrine","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "anabelle" {
	name                 = "anabelle"
	description          = ":princess: API documentation generator (JSON-RPC / REST)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/anabelle.html"
	topics               = ["api","contributte","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "scheduler" {
	name                 = "scheduler"
	description          = ":hourglass: PHP job scheduler (cron) with locking for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/scheduler.html"
	topics               = ["contributte","cron","job","nette","php","planning","scheduler","task"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "mailing" {
	name                 = "mailing"
	description          = ":mailbox_with_mail: Sending emails with pleasure and prepared templates."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/mailing.html"
	topics               = ["contributte","mail","mailbox","mailer","mailing","nette"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "micro-skeleton" {
	name                 = "micro-skeleton"
	description          = "🎁 Micro project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries for fast prototyping by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/micro-skeleton/"
	topics               = ["contributte","experimental","project","sandbox","skeleton"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "starter-skeleton" {
	name                 = "starter-skeleton"
	description          = "🎁  Starter project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/starter-skeleton/"
	topics               = ["contributte","nette","php","project","sandbox"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "console-skeleton" {
	name                 = "console-skeleton"
	description          = "🎁 Console (CLI) project skeleton based on Nette Framework (@nette),  Symfony (@symfony) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["console","contributte","php","project","symfony"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "advisories" {
	name                 = "advisories"
	description          = ":punch: Collection of Contributte/Nette advisories"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/advisories.html"
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "phalboot" {
	name                 = "phalboot"
	description          = ""
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "notefw" {
	name                 = "notefw"
	description          = "🛠Alternative Nette-inspired micro-tiny framework."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "webpack-skeleton" {
	name                 = "webpack-skeleton"
	description          = "🎁 Webpack 5 project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/webpack-skeleton/"
	topics               = ["assets","contributte","frontend","nette","nette-framework","npm","project","webpack"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "event-dispatcher-extra" {
	name                 = "event-dispatcher-extra"
	description          = ":recycle: Nette-based Symfony events for application, presenter, form, latte, templates, security and many others."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/event-dispatcher-extra.html"
	topics               = ["application","contributte","event-dispatcher","event-emitter","events","mvc","nette","nette-framework","security"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "contributte-site" {
	name                 = "contributte-site"
	description          = "👨‍💻 Contributte Website & Docs"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","docs","documentation","nette","website"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "elasticsearch" {
	name                 = "elasticsearch"
	description          = ":mag: Tiny Elasticsearch integration into Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/elasticsearch.html"
	topics               = ["contributte","elasticsearch","nette","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "flysystem" {
	name                 = "flysystem"
	description          = ":airplane: Smart integration of Flysystem into Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/flysystem.html"
	topics               = ["contributte","filesystem","flysystem","nette","storage"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "hydrator" {
	name                 = "hydrator"
	description          = "💀 [DISCONTINUED] Convert Doctrine entity to array and conversely. Use @contributte."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["array","contributte","doctrine","entity","hydrations","hydrator","nette-framework","nettrine","object","orm","php"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "webapp-skeleton" {
	name                 = "webapp-skeleton"
	description          = "🎁 Web application project skeleton based on Nette Framework (@nette), Doctrine (@nettrine) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/webapp-skeleton/"
	topics               = ["api","apitte","contributte","nette-framework","nettrine","project","skeleton","web"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "oauth2-client" {
	name                 = "oauth2-client"
	description          = ":lock: OAuth2 client for Nette Framework  "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/oauth2-client.html"
	topics               = ["client","contributte","http","nette","nette-framework","oauth2","security"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "jsonrpc" {
	name                 = "jsonrpc"
	description          = "📞 JSON-RPC toolset build on top of psr-7 (guzzlehttp), league/json-guard, league/json-reference, league/flysystem and nette/di"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/jsonrpc.html"
	topics               = ["api","contributte","http","json","jsonrpc","nette","php","request","response","rpc"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "monolog" {
	name                 = "monolog"
	description          = ":memo: Best logging support into Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/monolog.html"
	topics               = ["contributte","doctrine","logging","monolog","nette-framework","psr-3","tracy"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "php-hostinfo" {
	name                 = "php-hostinfo"
	description          = "Simple PHP tool to quickly check for sane webhosting setup   "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["apache2","audit","permissions","php","security","shared-hosting","unix-perm","webhosting"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "redis" {
	name                 = "redis"
	description          = ":floppy_disk: Redis (predis) for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/redis.html"
	topics               = ["contributte","nette","nette-framework","predis","redis"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "replacus" {
	name                 = "replacus"
	description          = ":basketball: :soccer: :baseball: :tennis: :8ball: Latte-based replacer for simple texts."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/replacus.html"
	topics               = ["contributte","latte","nette","replace","templating"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "czech-post" {
	name                 = "czech-post"
	description          = ":postbox: Czech Post API client"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/czech-post.html"
	topics               = ["api","contributte","czech-post","http","nette"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "gosms" {
	name                 = "gosms"
	description          = ":speech_balloon: GoSMS.cz HTTP client for Nette "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/gosms.html"
	topics               = ["client","contributte","http","nette","sms"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "translation" {
	name                 = "translation"
	description          = ":tongue: Translations (symfony/translation) to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/translation.html"
	topics               = ["contributte","i18n","l10n","localization","nette-framework","symfony","translation"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "planette-micro-site" {
	name                 = "planette-micro-site"
	description          = "💀 [DISCONTINUED] Former planette microsite"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://microplanette.vercel.app"
	topics               = ["contributte","nette-framework","planette"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "dag" {
	name                 = "dag"
	description          = ":running: Dag is opinionated expression data generator written in PHP to fake your API."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://daggy.vercel.app"
	topics               = ["alice","api","data","expression","faker","generator","ninjify","php","serverless"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "comgate" {
	name                 = "comgate"
	description          = ":euro: Comgate Payment Gateway implementation for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/comgate.html"
	topics               = ["api","comgate","contributte","http","payments","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "eet" {
	name                 = "eet"
	description          = "💀 [DISCONTINUED]  EET integration for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["contributte","eet","nette","payments"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "doctrine-extensions-beberlei" {
	name                 = "doctrine-extensions-beberlei"
	description          = ":mag: Doctrine beberlei/DoctrineExtensions extension for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["doctrine","dql","extension","nettrine"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "doctrine-extensions-knplabs" {
	name                 = "doctrine-extensions-knplabs"
	description          = ":mag: Doctrine KnpLabs/DoctrineBehaviors extension for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["doctrine","dql","extension","knplabs","nettrine"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-extensions-oroinc" {
	name                 = "doctrine-extensions-oroinc"
	description          = ":mag: Doctrine oroinc/doctrine-extensions extension for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["database","doctrine","dql","extension","nettrine"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "validator" {
	name                 = "validator"
	description          = ":no_good: Validator (symfony/validator) to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["contributte","data","dto","entity","hacktoberfest","nette","validation","validator"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = true
}

resource "github_repository" "bare" {
	name                 = "bare"
	description          = "🖨 Contributte Bare Repository Template"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/contributing.html"
	topics               = ["bare","contributte","repository","template"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "code-checker" {
	name                 = "code-checker"
	description          = "☑️ Enhanced code checker based on nette/code-checker."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/code-checker.html"
	topics               = ["checker","codestyle","contributte","nette","quality"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "forms-bootstrap" {
	name                 = "forms-bootstrap"
	description          = "👾 Bootstrap 4 + 5 forms for Nette framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["bootstrap","contributte","forms","theme","twitter-bootstrap","ui"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-odm" {
	name                 = "doctrine-odm"
	description          = ":collision:  Well-integrated Doctrine2 ODM for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/odm.html"
	topics               = ["database","mongodb","nette","nette-framework","nettrine","odm","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "doctrine-mongodb" {
	name                 = "doctrine-mongodb"
	description          = ":zap:  Well-integrated MongoDB for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/nettrine/mongodb.html"
	topics               = ["database","mongodb","nette","nette-framework","nettrine","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "oauth2-server" {
	name                 = "oauth2-server"
	description          = "🔒 OAuth2 server for Nette Framework"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/oauth2-server.html"
	topics               = ["contributte","nette","outh2","security"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "embedded-skeleton" {
	name                 = "embedded-skeleton"
	description          = "🎁 Tech boosted project skeleton based on Nette Framework (@nette), TailwindCSS (@tailwindcss), Alpine.js (@alpinejs) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/embedded-skeleton/"
	topics               = ["alpinejs","nette","nette-framework","php","project","skeleton","skywind","tailwindcss","template","web"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "qa" {
	name                 = "qa"
	description          = ":neckbeard: Quality Assurance. Code standards for @contributte ecosystem."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/qa.html"
	topics               = ["assurance","codestyle","contributte","qa","quality"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "componette-design" {
	name                 = "componette-design"
	description          = "💀 [DISCONTINUED] Componette Design Prototype based on Nuxt.js and Alpine.js"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://componette.vercel.app"
	topics               = ["componette","contributte","nette-framework","nuxt","vercel","website"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "tester" {
	name                 = "tester"
	description          = "🧪 Nette Tester with extra horse power."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/tester.html"
	topics               = ["contributte","integration-testing","mocks","nette","tester","testing","unit-testing"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "ui" {
	name                 = "ui"
	description          = "🌠 Contributte UI. Opinionated prime components for your Nette applications. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "aop" {
	name                 = "aop"
	description          = "🎯 AOP (Aspect-oriented programming) for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["aop","aspects","contributte","nette"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "elastica" {
	name                 = "elastica"
	description          = ":mag: Tiny Elastica integration into Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["contributte","elastica","elasticsearch","nette-framework"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-gedmo" {
	name                 = "doctrine-gedmo"
	description          = "💀 [DISCONTINUED] Doctrine Gedmo Extension for Nette Framework (@nette). Use nettrine/extensions-gedmo. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","doctrine","entity","nette-framework","orm"]
	vulnerability_alerts = true
	archived             = true
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "imagist" {
	name                 = "imagist"
	description          = "🏞 Image library for Nette Framework (@nette) "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/imagist.html"
	topics               = ["contributte","image","images","manipulation","nette","nette-framework","resize","storage"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "_github" {
	name                 = ".github"
	description          = ":octocat: Contributte + Github = ❤️"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "code-rules" {
	name                 = "code-rules"
	description          = "🙅‍♀️🙅‍♂️🙅 Codesniffer & phpstan prepared configs for easy-to-use. Rewritten by contributte's authors. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "fx-skeleton" {
	name                 = "fx-skeleton"
	description          = "🎁 All time best project skeleton for Nette Framework (@nette). Bootloader, DDD, TDD, Command Bus, Event Bus, Message Bus, API, Middlewares, ORM, DBAL. Using Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["api","bus","command-bus","cqrs","dbal","ddd","doctrine","event-bus","message-bus","middlewares","nette","orm","tdd"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "firewall" {
	name                 = "firewall"
	description          = ":closed_lock_with_key: Multi module Authentication and Authorization for Nette Framework (@nette)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/firewall/"
	topics               = ["auth","authentication","authorization","contributte","firewall","nette"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-extra-skeleton" {
	name                 = "doctrine-extra-skeleton"
	description          = "🎁  Nette and Doctrine project skeleton with all possible packages. Using Doctrine (@nettrine) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/doctrine-extra-skeleton/"
	topics               = ["contributte","doctrine","nette","nettrine"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "gettext" {
	name                 = "gettext"
	description          = "📄 Fixed php-gettext for PHP 5.6 and PHP 8.4"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["gettext","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "apitte-core" {
	name                 = "apitte-core"
	description          = "💀 [DISCONTINUED] 🔧 Enjoyable [PSR-7 based] API framework for Nette Framework. Heart of the apitte stack."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/apitte/core/"
	topics               = ["apitte","contributte","http","nette","php","rest"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "paginator-control" {
	name                 = "paginator-control"
	description          = "📕📗 Paginator component for Nette framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["component","contributte","latte","nette","pagination","paginator","template","ui"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "datagrid-skeleton" {
	name                 = "datagrid-skeleton"
	description          = "🎁  Example of contributte/datagrid component. Project skeleton based on Nette Framework and Contributte libraries by @f3l1x & @paveljanda."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/datagrid-skeleton/"
	topics               = ["component","contributte","datagrid","grid","nette","nette-framework","tables","ui"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "gui-skeleton" {
	name                 = "gui-skeleton"
	description          = "🎁  GUI project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/gui-skeleton"
	topics               = ["component","contributte","control","gui","nette","nette-framework","project","skeleton","ui","visual"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "nella" {
	name                 = "nella"
	description          = "👩‍💻 Opinionated pre-configured kernel based on Nette (@nette). Suitable for all kind of apps."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["boot","bootloader","bootstrap","contributte","kernel","nella","nette","nette-framework","preconfigured"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "payments-skeleton" {
	name                 = "payments-skeleton"
	description          = "🎁  Example of payment libraries (payu, thepay, gopay) based on Nette Framework (@nette) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","nette","nette-framework","payments"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "nella-skeleton" {
	name                 = "nella-skeleton"
	description          = "🎉  Essential project substance for rapid prototyping on Nette (@nette) by @f3l1x. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "sentry" {
	name                 = "sentry"
	description          = "🔴 First class integration of Sentry to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/sentry"
	topics               = ["contributte","error-tracking","errors","logging","nette","php","sentry","tracy"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "sentry-skeleton" {
	name                 = "sentry-skeleton"
	description          = "🕵🏻‍♀️ Example of first class integration of Sentry to Nette (@nette) by @f3l1x"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/sentry-skeleton/"
	topics               = ["contributte","error","exception","nette","project","sentry","skeleton"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "crafter" {
	name                 = "crafter"
	description          = "🧬 Yummy opinionated PHP generator for web masters."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["code","contributte","gen","generator","nella","nette","php","project","scaffold","skeleton"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "phpless" {
	name                 = "phpless"
	description          = "▲ PHP services on serverless steroids • 🐘+ λ = 👨🏻‍💻"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://phpless.vercel.app"
	topics               = ["container","dependency-injection","lambda","latte","neon","nette","php","phpless","phpstan","serverless","vercel"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "doctrine-skeleton" {
	name                 = "doctrine-skeleton"
	description          = "🎁  Nette and Doctrine project skeleton. Using Doctrine (@nettrine) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/doctrine-skeleton/"
	topics               = ["contributte","database","dbal","doctrine","nette","orm","project","skeleton"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "bus" {
	name                 = "bus"
	description          = "🚌 Simple and adaptive command bus to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "vite" {
	name                 = "vite"
	description          = "📦 Vite adapter for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "vite-skeleton" {
	name                 = "vite-skeleton"
	description          = "🎁 Vite project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries by @lubomirblazekcz."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "ui-skeleton" {
	name                 = "ui-skeleton"
	description          = "🎁 Next generation frontend project skeleton based on Nette Framework (@nette), TailwindCSS (@tailwindcss), Alpine.js (@alpinejs) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["alpinejs","assets","contributte","css","frontend","next","skeleton","tailwindcss","ui","vite"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "lambdas" {
	name                 = "lambdas"
	description          = "ƛ Swiss-army serverless lambdas tailored for @contributte needs."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "ctte.vercel.app"
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "instahost" {
	name                 = "instahost"
	description          = "🐘 Little PHP for parsing instagram and serving it like REST JSON API."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "messenger" {
	name                 = "messenger"
	description          = "💥 Best messenger support (symfony/messenger) to Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/messenger.html"
	topics               = ["amqp","async","bus","command-bus","contributte","doctrine","event-bus","events","message","message-bus","messenger","queue","redis","symfony"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "framex" {
	name                 = "framex"
	description          = "🥾 Bootloader for Framework X and Nette Framework (@nette)."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["api","async","contributte","frameworkx","http","middleware","psr7","react","validation"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "messenger-skeleton" {
	name                 = "messenger-skeleton"
	description          = "📤📥 Example of integration of Symfony Messenger to Nette (@nette) by @f3l1x"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/"
	topics               = ["async","bus","command-bus","console","doctrine","event-bus","http","message-bus","messenger","nette","project","rabbitmq","redis","skeleton","web"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "phpunit" {
	name                 = "phpunit"
	description          = "🧪 PHPUnit with extra horse power."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "phpstan" {
	name                 = "phpstan"
	description          = "⛺️ Opinionated set of phpstan extensions & rules for all fans. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "doctrine" {
	name                 = "doctrine"
	description          = "Meta integration package of Doctrine (Netterine) for Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["contributte","database","dbal","doctrine","meta","migrations","nette","nettrine","orm","php"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "doctrine-extra" {
	name                 = "doctrine-extra"
	description          = "🦄 Extra functions to Doctrine ecosystem in Nette Framework (@nette)"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "framex-skeleton" {
	name                 = "framex-skeleton"
	description          = "🎉 Fast API skeleton based on Framework X and Nette (@nette) by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "kernel" {
	name                 = "kernel"
	description          = "👩‍💻 Convenient bootloader for Nette (@nette) applications."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "openapi" {
	name                 = "openapi"
	description          = "🔡 Pure OpenAPI implementation for your API applications. Great for documentation. "
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org/packages/contributte/openapi/"
	topics               = ["api","http","openapi","rest","swagger"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "ddd-skeleton" {
	name                 = "ddd-skeleton"
	description          = "🎁 DDD skeleton based on Nette Framework (@nette), Doctrine (@nettrine) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://examples.contributte.org/ddd-skeleton/"
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "demo-frankenphp" {
	name                 = "demo-frankenphp"
	description          = "🏀 Demo application of FrankenPHP (@dunglas) based on Nette Framework (@nette) by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "api-skeleton" {
	name                 = "api-skeleton"
	description          = "🎁 API project skeleton based on Nette Framework (@nette) and Contributte (@contributte) libraries by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "all" {
	name                 = "all"
	description          = "💯+💯 all PHP libraries in all big fat composer. Quality assurance & upgrade paths."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "webdata" {
	name                 = "webdata"
	description          = "📦 Contributte's data for webs."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "doctrine-project" {
	name                 = "doctrine-project"
	description          = "🕹️ Minimal viable project with Doctrine to Nette (@nette) by @f3l1x"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = "https://contributte.org"
	topics               = ["contributte","doctrine","example","mvp","nette","php","project"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}

resource "github_repository" "demo-typesense" {
	name                 = "demo-typesense"
	description          = "🏀 Demo application of Typesense (@typesense) based on Nette Framework (@nette) by @f3l1x."
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = ["contributte","demo","engine","nette","project","search","skeleton","typesense"]
	vulnerability_alerts = true
	archived             = false
	has_wiki             = false
	has_discussions      = false
}

resource "github_repository" "turnstile" {
	name                 = "turnstile"
	description          = "‼️ Cloudflare Turnstile (security) for Nette Framework \\ Forms"
	allow_merge_commit   = false
	has_downloads        = true
	has_issues           = true
	homepage_url         = ""
	topics               = []
	vulnerability_alerts = true
	archived             = false
	has_wiki             = true
	has_discussions      = false
}