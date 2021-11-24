---
permalink: /
---

# jekyll-highlight-rgbasm

A Jekyll plugin using Rouge to highlight RGBASM Game Boy assembly language.

<https://github.com/martendo/jekyll-highlight-rgbasm>

This page's code blocks were highlighted using jekyll-highlight-rgbasm!

## Examples

<div id="style-container" style="display: none;">
	<label for="style-select">Style:</label>
	<br>
	<select id="style-select">
		{% for style in site.styles %}
			<option>{{ style }}</option>
		{% endfor %}
	</select>
</div>

```rgbasm
INCLUDE "hardware.inc"

SECTION "Action Variables", HRAM

hCurrentAction::
	DS 1

SECTION "Action Handling", ROM0

DoAction::
	; Do nothing for special actions
	ldh	a, [hCurrentAction]
	cp	a, SPECIAL_ACTIONS_START
	ret	nc

	; Get pointer to action handler
	ld	b, a
	add	a, a ; Pointer: 2 bytes
	add	a, b ; +Bank: 1 byte
	add	a, LOW(ActionTable)
	ld	l, a
	adc	a, HIGH(ActionTable)
	sub	a, l
	ld	h, a

	; Switch to action handler's bank
	ld	a, [hli]
	ldh	[hCurrentROMB], a
	ld	[rROMB0], a

	; Jump to action handler
	ld	a, [hli]
	ld	h, [hl]
	ld	l, a
	jp	hl

SECTION "Action Data Table", ROM0

MACRO action
	; Pointer including bank number to action handler
	DB BANK(xAction\1)
	DW xAction\1
	; Action constant
	DEF NAME EQUS STRUPR("\1")
	DEF ACTION_{NAME} RB 1
	PURGE NAME
ENDM

ActionTable:
	RSRESET
	; Regular actions
	action Jump
	action Climb
	action Dance
	action Magic
	; Special actions
	DEF SPECIAL_ACTIONS_START EQU _RS
	action Quit
	action Restart
```

```rgbasm
GlobalLabel:
ExportedGlobalLabel::
.localLabel
.localLabel2:
.exportedLocalLabel::
NotLabel
; Anonymous label definition and reference
:	jr	!c, :-

/* Block comment
conitnues until
/*
here! */

DB """Multi-line string that contains
newlines
"""

DB "Regular string with line continuations \ ; Comment!
but can't contain literal
newlines"

DB "String with {#02X:SYMBOL_INTERPOLATION} "
DB "and \"escape sequences\""

; Only symbols inside symbol interpolation construct
jp .{STRLWR(NAME)}

PRINTLN "Invalid escape sequence: '\q'"

DW 100, 50_000 ; Decimal
DW $9C00, $FE_40 ; Hexadecimal
DW &777, &2_03 ; Octal
DW %110, %1111_1111_1000_0001 ; Binary
DW 0.125, 32_2._53, 5. ; Fixed point
DW `01233210, `3311_2233 ; Graphics

; NOTE: Arbitrary numeric characters not supported
PUSHO
	OPT g.oOX, bv^
	DW `..ooOOXX, %^^^^v^^v
POPO

; Operators
IF 7 % 6 & $0F || 4 - 1 & 2 == 2 ** 3
	DB (8 - 5) << 3 / 2 ^ 1
	; NOTE: Non-existent operators still highlighted
	PRINTLN STRFMT("%d", 1 %%% 2)
ENDC

; Macro arguments
DL \1, \#, \<10>, \<_NARG>
DL \20, \0

; Predeclared symbols
PRINTLN __ISO_8601_UTC__
PRINTLN "{#05X:@} {u:_RS}"

DB 1, 2, 3, 4, 5, 6, /* 7, */ 8, 9, 10, \
11, 12, 13, 14, 15, 16, 17, 18, 19, 20

; `rl` and `set` can be ambiguous
; Rule for highlighting: instruction if first word
; of line, otherwise directive
rl c
DEF CONST RL 1
set 7, [hl]
VAR SET 0
/* Wrong! */ set 2, a
```
