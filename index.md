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
		<option value="default">default</option>
		<option value="abap">abap</option>
		<option value="algol">algol</option>
		<option value="algol_nu">algol_nu</option>
		<option value="arduino">arduino</option>
		<option value="autumn">autumn</option>
		<option value="borland">borland</option>
		<option value="bw">bw</option>
		<option value="colorful">colorful</option>
		<option value="emacs">emacs</option>
		<option value="friendly">friendly</option>
		<option value="fruity">fruity</option>
		<option value="gruvbox-dark">gruvbox-dark</option>
		<option value="gruvbox-light">gruvbox-light</option>
		<option value="igor">igor</option>
		<option value="inkpot">inkpot</option>
		<option value="lovelace">lovelace</option>
		<option value="manni">manni</option>
		<option value="material">material</option>
		<option value="monokai">monokai</option>
		<option value="murphy">murphy</option>
		<option value="native">native</option>
		<option value="paraiso-dark">paraiso-dark</option>
		<option value="paraiso-light">paraiso-light</option>
		<option value="pastie">pastie</option>
		<option value="perldoc">perldoc</option>
		<option value="rainbow_dash">rainbow_dash</option>
		<option value="rrt">rrt</option>
		<option value="sas">sas</option>
		<option value="solarized-dark">solarized-dark</option>
		<option value="solarized-light">solarized-light</option>
		<option value="stata-dark">stata-dark</option>
		<option value="stata-light">stata-light</option>
		<option value="tango">tango</option>
		<option value="trac">trac</option>
		<option value="vim">vim</option>
		<option value="vs">vs</option>
		<option value="xcode">xcode</option>
		<option value="zenburn">zenburn</option>
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

/* Block comment
conitnues until
/*
here! */

DB """Multi-line string that contains
newlines
"""

DB "Regular string that can contain \
escaped newlines but can't have them
unescaped"

DB "String with {#02X:SYMBOL_INTERPOLATION} "
DB "and \"escape sequences\""

; Only symbols inside symbol interpolation construct
jp .{STRLWR(NAME)}

DW 100, 50_000 ; Decimal
DW $9C00, $FE_40 ; Hexadecimal
DW &777, &2_03 ; Octal
DW %110, %1111_1111_1000_0001 ; Binary
DW 0.125, 5. ; Fixed point
DW `01233210 ; Graphics

; NOTE: Arbitrary numeric characters not supported
PUSHO
	OPT g.oOX, bv^
	DW `..ooOOXX, %^^^^v^^v
POPO

; Macro arguments
DL \1, \#, \<10>, \<_NARG>
DL \20, \0

; Predeclared symbols
PRINTLN __ISO_8601_UTC__
PRINTLN "{#05X:@} {u:_RS}"

DB 1, 2, 3, 4, 5, 6, /* 7, */ 8, 9, 10, \
11, 12, 13, 14, 15, 16, 17, 18, 19, 20
```
