
#SingleInstance, Off
#NoTrayIcon

language:="en"
i8n:=Object()
i8n.title:={en:"Kerbal Space Program",zh_cn:"坎巴拉`n太空计划"}
i8n.calct:={en:"ΔV calculator",zh_cn:"ΔV计算器"}
i8n.lspt:={en:"lsp(s)",zh_cn:"比冲(s)"}
i8n.calct:={en:"ΔV calculator",zh_cn:"ΔV计算器"}
i8n.tmt:={en:"Total Mass(ton)",zh_cn:"总重量(吨)"}
i8n.dvt:={en:"deltaV",zh_cn:"真空动增量"}
i8n.fmt:={en:"Fuel Mass(ton)",zh_cn:"燃料重量(吨)"}
i8n.lft:={en:"LF(unit)",zh_cn:"液体燃料"}
i8n.oxt:={en:"OX(unit)",zh_cn:"氧化剂"}
i8n.langt:={en:"中文",zh_cn:"English"}

OnMessage(0x201, "mousedrag")

gui, +Caption +HwndGuiHwnd
gui, color, 333234, 333234
gui, font, s8 cFAFAFA, Arial
Gui, add, Text, w100 glangswitch vlangt,% i8n.langt[language]
gui, font, s44 cFAFAFA bold, Arial
Gui, add, Text, y+0 w410 center gtop vtitle,% i8n.title[language]
gui, font, s22 c2A5AFF, Arial
Gui, add, Text, wp y+0 center vcalct,% i8n.calct[language]
gui, font, s8 c2A5AFF, Arial
Gui, add, Text, wp y+0 center,jiyucheng007@gmail.com

gui, font, s14 cFAFAFA, Arial
Gui, add, Text, section w150 vlspt,% i8n.lspt[language]
Gui, add, Edit, wp vlsp gcalc number,800

Gui, add, text, wp vtmt,% i8n.tmt[language]
Gui, add, Edit, wp vM gcalc,25

gui, font, c2A5AFF s32 bold
Gui, add, text, w410 Center vdvt,% i8n.dvt[language]
Gui, add, text, y+0 center wp vdv ReadOnly, 12617.99 m/s

gui, font, s14 cFAFAFA, Arial
Gui, add, text, xs+160 ys w250 vfmt,% i8n.fmt[language]
Gui, add, Edit, wp vm0 goxlf,20

Gui, add, text, section w120 vlft,% i8n.lft[language]
Gui, add, text, x+10 w120 voxt,% i8n.oxt[language]
Gui, add, Edit, xs wp vox gfuel number,4000
Gui, add, Edit, x+10 wp vlf gfuel number,0

Gui, show
WinSet, Transparent, Off, ahk_id %GuiHwnd%
Return

; deltaV = lsp * Ln(M/(M-m0))
; m0 = mass of fuel
; M = total mass
; 200unit LF = 1 ton
; 200unit OX = 1 ton
; LF : OX = 9 : 11

langswitch:
if(language="zh_cn")
{
	language:="en"
}
Else
{
	language:="zh_cn"
}
For key, value in i8n
{
	; gui, font, s44 c2A5AFF bold, Arial
	; GuiControl, Font, title
	GuiControl, , % key, % value[language]
}

Return

mousedrag()
{
	PostMessage, 0xA1, 2
}

top:
WinSet, AlwaysOnTop, Toggle,ahk_id %GuiHwnd%
WinGet, ExStyle, ExStyle, ahk_id %GuiHwnd%
if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
{
	WinSet, Transparent, 200, ahk_id %GuiHwnd%
	gui, font, s44 c2A5AFF bold, Arial
	GuiControl, Font, title
}
Else
{

	WinSet, Transparent, Off, ahk_id %GuiHwnd%
	gui, font, s44 cFAFAFA, Arial
	GuiControl, Font, title
}
Return

oxlf:
if block
Return
block:=1
Gui, Submit, nohide
_lf:=200*m0*(9/20)
_ox:=200*m0*(11/20)
GuiControl, , lf, % round(_lf,0)
GuiControl, , ox, % round(_ox,0)
Sleep, 30
block:=0
Goto, calc
return

fuel:
if block
Return
block:=1
Gui, Submit, nohide
_m0:=(ox+lf)/200
GuiControl, , m0, % round(_m0,3)
Sleep, 30
block:=0
Goto, calc
return

calc:
Gui, Submit, nohide
_dv:=9.8* lsp * Ln(M/(M-m0))
if _dv is number
{
	GuiControl, , dv, % round(_dv,2) " m/s"
}
Else
{
	GuiControl, , dv, Error
}
Return

GuiClose:
ExitApp
