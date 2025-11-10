-- PHP Language Server (Intelephense)
-- Comprehensive PHP language support with Laravel optimization
return {
	settings = {
		intelephense = {
			-- Stubs: PHP built-in functions and popular frameworks
			stubs = {
				"apache",
				"bcmath",
				"bz2",
				"calendar",
				"com_dotnet",
				"Core",
				"ctype",
				"curl",
				"date",
				"dba",
				"dom",
				"enchant",
				"exif",
				"FFI",
				"fileinfo",
				"filter",
				"fpm",
				"ftp",
				"gd",
				"gettext",
				"gmp",
				"hash",
				"iconv",
				"imap",
				"intl",
				"json",
				"ldap",
				"libxml",
				"mbstring",
				"meta",
				"mysqli",
				"oci8",
				"odbc",
				"openssl",
				"pcntl",
				"pcre",
				"PDO",
				"pdo_ibm",
				"pdo_mysql",
				"pdo_pgsql",
				"pdo_sqlite",
				"pgsql",
				"Phar",
				"posix",
				"pspell",
				"readline",
				"Reflection",
				"session",
				"shmop",
				"SimpleXML",
				"snmp",
				"soap",
				"sockets",
				"sodium",
				"SPL",
				"sqlite3",
				"standard",
				"superglobals",
				"sysvmsg",
				"sysvsem",
				"sysvshm",
				"tidy",
				"tokenizer",
				"xml",
				"xmlreader",
				"xmlrpc",
				"xmlwriter",
				"xsl",
				"Zend OPcache",
				"zip",
				"zlib",
				-- Laravel
				"laravel",
			},
			-- File indexing
			files = {
				maxSize = 5000000, -- 5MB
				associations = { "*.php", "*.phtml" },
				exclude = {
					"**/node_modules/**",
					"**/vendor/**/Tests/**",
					"**/vendor/**/tests/**",
					"**/storage/**",
					"**/cache/**",
				},
			},
			-- Diagnostics
			diagnostics = {
				enable = true,
			},
			-- Completion
			completion = {
				insertUseDeclaration = true,
				fullyQualifyGlobalConstantsAndFunctions = false,
				triggerParameterHints = true,
				maxItems = 100,
			},
			-- Format
			format = {
				enable = false, -- Handled by php-cs-fixer via conform.nvim
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by php-cs-fixer via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
