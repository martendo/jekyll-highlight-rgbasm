Jekyll::Hooks.register :site, :pre_render do
	puts 'Registering RGBASM lexer...'
	require 'rouge'

	class RGBASMLexer < Rouge::RegexLexer
		title 'RGBASM'
		desc 'RGBASM Assembly Language'
		tag 'rgbasm'
		filenames '*.asm', '*.inc'

		state :symbols do
			rule %r'@', Name::Builtin # PC value (incompatible with \b used below)
			rule %r'\b(?:_RS|_NARG|__LINE__|__FILE__|__DATE__|__TIME__|__ISO_8601_LOCAL__|__ISO_8601_UTC__|__UTC_YEAR__|__UTC_MONTH__|__UTC_DAY__|__UTC_HOUR__|__UTC_MINUTE__|__UTC_SECOND__|__RGBDS_MAJOR__|__RGBDS_MINOR__|__RGBDS_PATCH__|__RGBDS_RC__|__RGBDS_VERSION__)\b', Name::Builtin # Predeclared symbol
			rule %r'[a-z_][a-z0-9_#@]*'i, Name # Symbol
			rule %r'(?:[a-z_][a-z0-9_#@]*)?\.[a-z0-9_#@]+'i, Name # Local label (global handled by above "Symbol")
		end

		state :macargs do
			rule %r'\\<.+?>', Str::Escape # Bracketed macro argument
			rule %r'\\[1-9#@]', Str::Escape # Macro argument
			rule %r'\\0', Error # Macro argument numbering starts at 1
		end

		state :root do
			rule %r'\s+', Text
			rule %r'^([ \t]*)([a-z_][a-z0-9_#@]*::?)'i do
				groups Text, Name::Label # Global label definition
			end
			rule %r'^([ \t]*)((?:[a-z_][a-z0-9_#@]*)?\.[a-z0-9_#@]+:?:?)'i do
				groups Text, Name::Label # Local label definition
			end
			rule %r'{', Str::Interpol, :interpol # Symbol interpolation
			rule %r'/\*', Comment::Multiline, :comment # Multiline comment
			rule %r';.*?$', Comment::Single # Line comment
			rule %r'"""', Str::Heredoc, :mlstring # Multi-line string
			rule %r'"', Str, :string # String
			rule %r'\b(?:adc|add|and|bit|call|ccf|cpl|cp|daa|dec|di|ei|halt|inc|jp|jr|ld|ldi|ldd|ldio|ldh|nop|or|pop|push|res|reti|ret|rlca|rlc|rla|rl|rrc|rrca|rra|rr|rst|sbc|scf|set|sla|sra|srl|stop|sub|swap|xor)\b'i, Keyword # Instruction
			rule %r'\b(?:def|fragment|bank|align|sizeof|startof|round|ceil|floor|div|mul|pow|log|sin|cos|tan|asin|acos|atan|atan2|high|low|isconst|strcmp|strin|strrin|strsub|strlen|strcat|strupr|strlwr|strrpl|strfmt|charlen|charsub|include|print|println|printt|printi|printv|printf|export|ds|db|dw|dl|section|purge|rsreset|rsset|incbin|charmap|newcharmap|setcharmap|pushc|popc|fail|warn|fatal|assert|static_assert|macro|endm|shift|rept|for|endr|break|load|endl|if|else|elif|endc|union|nextu|endu|rb|rw|equ|equs|redef|pushs|pops|pusho|popo)\b'i, Name::Function # Directive
			rule %r'\b(opt)\b(.+?)$'i do
				groups Name::Function, Text # Assmebler options
			end
			rule %r'\b(?:wram0|vram|romx|rom0|hram|wramx|sram|oam)\b'i, Keyword::Type # Section type
			rule %r'\b(?:af|bc|de|hl|sp|hld|hli|a|b|c|d|e|h|l)\b'i, Name::Variable # Register
			mixin :symbols
			mixin :macargs
			rule %r'\$[0-9a-f_]+'i, Num::Hex # Hex number
			rule %r'&[0-7_]+', Num::Oct # Octal number
			rule %r'%[01_]+', Num::Bin # Binary number
			rule %r'`[0-3]+', Num # GFX constant
			rule %r'\b[0-9_]+\.[0-9_]*', Num::Float # Fixed point number
			rule %r'\b[0-9_]+', Num::Integer # Integer
			rule %r'[&|^<>!=*/%~+-]+', Operator # Operator
			rule %r'[.,:\(\)\[\]\\]+', Punctuation # Misc. symbol
		end

		state :comment do
			rule %r'[^*/]+', Comment::Multiline
			rule %r'\*/', Comment::Multiline, :pop!
			rule %r'[*/]', Comment::Multiline
		end

		state :mlstring do
			rule %r'[^"\\{]+', Str::Heredoc
			mixin :macargs
			rule %r'\\.'m, Str::Escape
			rule %r'{', Str::Interpol, :interpol
			rule %r'"""', Str::Heredoc, :pop!
			rule %r'"', Str::Heredoc
		end

		state :string do
			rule %r'[^"\\{\n]+', Str
			rule %r'\n', Error, :pop!
			mixin :macargs
			rule %r'\\.'m, Str::Escape
			rule %r'{', Str::Interpol, :interpol
			rule %r'"', Str, :pop!
		end

		state :interpolnofmt do
			mixin :symbols
			mixin :macargs
			rule %r'{', Str::Interpol, :interpol
			rule %r'}', Str::Interpol, :pop!
		end

		state :interpol do
			rule %r'[+ ]?#?-?0?[0-9]*(?:\.[0-9]+)?[duxXbofs]:' do
				token Str::Interpol
				goto :interpolnofmt
			end
			rule %r'.*:' do
				token Error
				goto :interpolnofmt
			end
			mixin :interpolnofmt
		end
	end
end
