; MSX2 and MSX2+ BIOS, international version with 60Hz support
; Assemble with z80asm
;
; Source obtained by disassembling the original BIOS, then modified
; by combining code from various versions to create an "international"
; (non-Japanese) version, including character set and keyboard layout,
; while supporting MSX2+ features.
;
; No copyright claims are made regarding this code, and this is
; intended only for use in actual MSX computers to enable reviving
; and upgrading vintage computers.
;
; In addition to this BIOS, a subrom is needed but not currently
; provided in this repository. The one from the msxnewbios project
; works fine with this.

	org	00000h

; 50 Hz / 60 Hz toggle
INTHZ: EQU 60

; MSX version, supported values: 2 (MSX2) and 3 (MSX2+)
VERSION: EQU 3

; MSX2+ F4 register polarity (0 = normal, default zero)
F4_INVERTED: EQU 0

; Enable some Japanese options
JAPANESE: EQU 0

CHRCUR: EQU 024h    ; $
CHRFLN: EQU 05ch    ; \
CHRVLN: EQU 026h    ; &
;CHRVLN: EQU 040     ; @

S.PSET:	        equ 0x006d
S.DOGRPH:	equ 0x0085
S.GRPPRT:	equ 0x0089
S.MAPXYC:	equ 0x0091
S.READC:	equ 0x0095
S.SETC:	        equ 0x009d
S.TRIGHT:	equ 0x00a1
S.TLEFTC:	equ 0x00a9
S.LEFTC:	equ 0x00ad
S.DOWNC:	equ 0x00b5
S.TUPC:	        equ 0x00b9
S.SCANR:	equ 0x00c1
S.SCANL:	equ 0x00c5
S.CHGMOD:	equ 0x00d1
S.INIT32:	equ 0x00d9
S.INIGRP:	equ 0x00dd
S.SETTXT:	equ 0x00e5
S.SETT32:	equ 0x00e9
S.SETMLT:	equ 0x00f1
S.CLRSPR:	equ 0x00f5
S.CLS:	        equ 0x0115
S.CLRTXT:	equ 0x0119
S.DELLNO:	equ 0x0121
S.INSLNO:	equ 0x0125
S.WRTVDP:	equ 0x012d
S.PUTCHR:	equ 0x0139
S.PUTSPRT:	equ 0x0151
S.COLOR:	equ 0x0155
S.WIDTHS:	equ 0x015d
S.VDP:	        equ 0x0161
S.BASE:	        equ 0x0169
S.BASEF:	equ 0x016d
S.VPEEK:	equ 0x0175
S.SETS:	        equ 0x0179

S.PAINT: equ 0x0069
S.GLINE: equ 0x0075
S.RIGHTC: equ 0x00a5
S.TDOWNC: equ 0x00b1
S.UPC: equ 0x00bd
S.INITXT: equ 0x00d5
S.INIMLT: equ 0x00e1
S.SETGRP: equ 0x00ed
S.VPOKE: equ 0x0171
S.VDPF: equ 0x0165
S.SCREEN: equ 0x0159
S.DSPFNK: equ 0x011d
S.BEEP: equ 0x017d
S.PROMPT: equ 0x0181
S.SDFSCR: equ 0x0185
S.SETSCR: equ 0x0189
S.SCOPY: equ 0x18d
S.NEWPAD: equ 0x01ad
S.GETPUT: equ 0x01b1
S.CHGMDP: equ 0x01b5

JF37D:	equ 0xf37d
RDPRIM:	equ 0xf380
WRPRIM:	equ 0xf385
CLPRIM:	equ 0xf38c
CLPRM1:	equ 0xf398
LINLEN:	equ 0xf3b0
CRTCNT:	equ 0xf3b1
T32COL:	equ 0xf3bf
GRPCGP:	equ 0xf3cb
CLIKSW:	equ 0xf3db
CSRY:	equ 0xf3dc
CSRX:	equ 0xf3dd
CNSDFG:	equ 0xf3de
RG0SAV:	equ 0xf3df
RG1SAV:	equ 0xf3e0
RG25SA: equ 0xfffa
STATFL:	equ 0xf3e7
TRGFLG:	equ 0xf3e8
FORCLR:	equ 0xf3e9
BAKCLR:	equ 0xf3ea
BDRCLR:	equ 0xf3eb
ATRBYT:	equ 0xf3f2
QUEUES:	equ 0xf3f3
SCNCNT:	equ 0xf3f6
REPCNT:	equ 0xf3f7
PUTPNT:	equ 0xf3f8
GETPNT:	equ 0xf3fa
LOW.:	equ 0xf406
HIGH.:	equ 0xf408
HEADER:	equ 0xf40a
ASPCT1:	equ 0xf40b
ASPCT2:	equ 0xf40d
ERRFLG:	equ 0xf414
LPTPOS:	equ 0xf415
PRTFLG:	equ 0xf416
NTMSXP:	equ 0xf417
RAWPRT:	equ 0xf418
VLZADR:	equ 0xf419
VLZDAT:	equ 0xf41b
CURLIN:	equ 0xf41c
KBFMIN:	equ 0xf41e
KBUF:	equ 0xf41f
BUFMIN:	equ 0xf55d
BUF:	equ 0xf55e
ENDBUF:	equ 0xf660
TTYPOS:	equ 0xf661
DIMFLG:	equ 0xf662
VALTYP:	equ 0xf663
DORES:	equ 0xf664
DONUM:	equ 0xf665
CONTXT:	equ 0xf666
CONSAV:	equ 0xf668
CONTYP:	equ 0xf669
CONLO:	equ 0xf66a
MEMSIZ:	equ 0xf672
STKTOP:	equ 0xf674
TXTTAB:	equ 0xf676
TEMPPT:	equ 0xf678
TEMPST:	equ 0xf67a
DSCTMP:	equ 0xf698
FRETOP:	equ 0xf69b
TEMP3:	equ 0xf69d
TEMP8:	equ 0xf69f
ENDFOR:	equ 0xf6a1
DATLIN:	equ 0xf6a3
SUBFLG:	equ 0xf6a5
FLGINP:	equ 0xf6a6
TEMP:	equ 0xf6a7
PTRFLG:	equ 0xf6a9
AUTFLG:	equ 0xf6aa
AUTLIN:	equ 0xf6ab
AUTINC:	equ 0xf6ad
SAVTXT:	equ 0xf6af
SAVSTK:	equ 0xf6b1
ERRLIN:	equ 0xf6b3
DOT:	equ 0xf6b5
ERRTXT:	equ 0xf6b7
ONELIN:	equ 0xf6b9
ONEFLG:	equ 0xf6bb
TEMP2:	equ 0xf6bc
OLDLIN:	equ 0xf6be
OLDTXT:	equ 0xf6c0
VARTAB:	equ 0xf6c2
ARYTAB:	equ 0xf6c4
STREND:	equ 0xf6c6
DATPTR:	equ 0xf6c8
DEFTBL:	equ 0xf6ca
PRMSTK:	equ 0xf6e4
PRMLEN:	equ 0xf6e6
PARM1:	equ 0xf6e8
PRMPRV:	equ 0xf74c
PRMLN2:	equ 0xf74e
PARM2:	equ 0xf750
PRMFLG:	equ 0xf7b4
ARYTA2:	equ 0xf7b5
NOFUNS:	equ 0xf7b7
TEMP9:	equ 0xf7b8
FUNACT:	equ 0xf7ba
SWPTMP:	equ 0xf7bc
TRCFLG:	equ 0xf7c4
FBUFFR:	equ 0xf7c5
DECTMP:	equ 0xf7f0
DECTM2:	equ 0xf7f2
DECCNT:	equ 0xf7f4
DAC:	equ 0xf7f6
ARG:	equ 0xf847
RNDX:	equ 0xf857
MAXFIL:	equ 0xf85f
FILTAB:	equ 0xf860
NULBUF:	equ 0xf862
PTRFIL:	equ 0xf864
FILNAM:	equ 0xf866
NLONLY:	equ 0xf87c
SAVEND:	equ 0xf87d
FNKSTR:	equ 0xf87f
CGPNT:	equ 0xf91f
NAMBAS:	equ 0xf922
CGPBAS:	equ 0xf924
PATBAS:	equ 0xf926
ATRBAS:	equ 0xf928
CLOC:	equ 0xf92a
CMASK:	equ 0xf92c
MINDEL:	equ 0xf92d
MAXDEL:	equ 0xf92f
ASPECT:	equ 0xf931
CENCNT:	equ 0xf933
CLINEF:	equ 0xf935
CNPNTS:	equ 0xf936
CPLOTF:	equ 0xf938
CPCNT:	equ 0xf939
CPCNT8:	equ 0xf93b
CRCSUM:	equ 0xf93d
CSTCNT:	equ 0xf93f
CSCLXY:	equ 0xf941
CSAVEA:	equ 0xf942
CSAVEM:	equ 0xf944
CXOFF:	equ 0xf945
CYOFF:	equ 0xf947
LOHMSK:	equ 0xf949
LOHDIR:	equ 0xf94a
LOHADR:	equ 0xf94b
LOHCNT:	equ 0xf94d
SKPCNT:	equ 0xf94f
MOVCNT:	equ 0xf951
PDIREC:	equ 0xf953
LFPROG:	equ 0xf954
RTPROG:	equ 0xf955
MCLTAB:	equ 0xf956
MCLFLG:	equ 0xf958
VOICAQ:	equ 0xf975
ACPAGE:	equ 0xfaf6
CHRCNT:	equ 0xfaf9
MODE:	equ 0xfafc
LOGOPR:	equ 0xfb02
PRSCNT:	equ 0xfb35
SAVSP:	equ 0xfb36
VOICEN:	equ 0xfb38
SAVVOL:	equ 0xfb39
MCLLEN:	equ 0xfb3b
MCLPTR:	equ 0xfb3c
QUEUEN:	equ 0xfb3e
MUSICF:	equ 0xfb3f
PLYCNT:	equ 0xfb40
VCBA:	equ 0xfb41
VCBB:	equ 0xfb66
VCBC:	equ 0xfb8b
ENSTOP:	equ 0xfbb0
BASROM:	equ 0xfbb1
FSTPOS:	equ 0xfbca
CURSAV:	equ 0xfbcc
FNKSWI:	equ 0xfbcd
FNKFLG:	equ 0xfbce
ONGSBF:	equ 0xfbd8
CLIKFL:	equ 0xfbd9
OLDKEY:	equ 0xfbda
NEWKEY:	equ 0xfbe5
KEYBUF:	equ 0xfbf0
LINWRK:	equ 0xfc18
PATWRK:	equ 0xfc40
BOTTOM:	equ 0xfc48
HIMEM:	equ 0xfc4a
TRPTBL:	equ 0xfc4c
INTFLG:	equ 0xfc9b
PADY:	equ 0xfc9c
PADX:	equ 0xfc9d
JIFFY:	equ 0xfc9e
INTVAL:	equ 0xfca0
INTCNT:	equ 0xfca2
LOWLIM:	equ 0xfca4
WINWID:	equ 0xfca5
GRPHED:	equ 0xfca6
ESCCNT:	equ 0xfca7
INSFLG:	equ 0xfca8
CSRSW:	equ 0xfca9
CSTYLE:	equ 0xfcaa
CAPST:	equ 0xfcab
KANAST:	equ 0xfcac
KANAMD:	equ 0xfcad
FLBMEM:	equ 0xfcae
SCRMOD:	equ 0xfcaf
OLDSCR:	equ 0xfcb0
CASPRV:	equ 0xfcb1
BDRATR:	equ 0xfcb2
GXPOS:	equ 0xfcb3
GYPOS:	equ 0xfcb5
GRPACX:	equ 0xfcb7
GRPACY:	equ 0xfcb9
DRWFLG:	equ 0xfcbb
DRWSCL:	equ 0xfcbc
DRWANG:	equ 0xfcbd
RUNBNF:	equ 0xfcbe
SAVENT:	equ 0xfcbf
EXPTBL:	equ 0xfcc1
SLTTBL:	equ 0xfcc5
SLTATR:	equ 0xfcc9
SLTWRK:	equ 0xfd09
PROCNM:	equ 0xfd89
DEVICE:	equ 0xfd99
H.KEYC: equ 0xfdcc
H.KEYI:	equ 0xfd9a
H.TIMI:	equ 0xfd9f
H.CHPU:	equ 0xfda4
H.DSPC:	equ 0xfda9
H.ERAC:	equ 0xfdae
H.DSPF:	equ 0xfdb3
H.ERAF:	equ 0xfdb8
H.TOTE:	equ 0xfdbd
H.CHGE:	equ 0xfdc2
H.INIP:	equ 0xfdc7
H.KEYA:	equ 0xfdd1
H.NMI:	equ 0xfdd6
H.PINL:	equ 0xfddb
H.QINL:	equ 0xfde0
H.INLI:	equ 0xfde5
H.ONGO:	equ 0xfdea
H.DSKO:	equ 0xfdef
H.SETS:	equ 0xfdf4
H.NAME:	equ 0xfdf9
H.KILL:	equ 0xfdfe
H.IPL:	equ 0xfe03
H.COPY:	equ 0xfe08
H.CMD:	equ 0xfe0d
H.DSKF:	equ 0xfe12
H.DSKI:	equ 0xfe17
H.ATTR:	equ 0xfe1c
H.LSET:	equ 0xfe21
H.RSET:	equ 0xfe26
H.FIEL:	equ 0xfe2b
H.MKIS:	equ 0xfe30
H.MKSS:	equ 0xfe35
H.MKDS:	equ 0xfe3a
H.CVI:	equ 0xfe3f
H.CVS:	equ 0xfe44
H.CVD:	equ 0xfe49
H.GETP:	equ 0xfe4e
H.SETF:	equ 0xfe53
H.NOFO:	equ 0xfe58
H.NULO:	equ 0xfe5d
H.NTFL:	equ 0xfe62
H.MERG:	equ 0xfe67
H.SAVE:	equ 0xfe6c
H.BINS:	equ 0xfe71
H.BINL:	equ 0xfe76
H.FILE:	equ 0xfe7b
H.DGET:	equ 0xfe80
H.FILO:	equ 0xfe85
H.INDS:	equ 0xfe8a
H.RSLF:	equ 0xfe8f
H.SAVD:	equ 0xfe94
H.LOC:	equ 0xfe99
H.LOF:	equ 0xfe9e
H.EOF:	equ 0xfea3
H.FPOS:	equ 0xfea8
H.BAKU:	equ 0xfead
H.PARD:	equ 0xfeb2
H.NODE:	equ 0xfeb7
H.POSD:	equ 0xfebc
H.GEND:	equ 0xfec6
H.RUNC:	equ 0xfecb
H.CLEA:	equ 0xfed0
H.LOPD:	equ 0xfed5
H.STKE:	equ 0xfeda
H.ISFL:	equ 0xfedf
H.OUTD:	equ 0xfee4
H.CRDO:	equ 0xfee9
H.DSKC:	equ 0xfeee
H.DOGR:	equ 0xfef3
H.PRGE:	equ 0xfef8
H.ERRP:	equ 0xfefd
H.ERRF:	equ 0xff02
H.READ:	equ 0xff07
H.MAIN:	equ 0xff0c
H.DIRD:	equ 0xff11
H.FINI:	equ 0xff16
H.FINE:	equ 0xff1b
H.CRUN:	equ 0xff20
H.CRUS:	equ 0xff25
H.ISRE:	equ 0xff2a
H.NTFN:	equ 0xff2f
H.NOTR:	equ 0xff34
H.SNGF:	equ 0xff39
H.NEWS:	equ 0xff3e
H.GONE:	equ 0xff43
H.CHRG:	equ 0xff48
H.RETU:	equ 0xff4d
H.PRTF:	equ 0xff52
H.COMP:	equ 0xff57
H.FINP:	equ 0xff5c
H.TRMN:	equ 0xff61
H.FRME:	equ 0xff66
H.NTPL:	equ 0xff6b
H.EVAL:	equ 0xff70
H.OKNO:	equ 0xff75
H.FING:	equ 0xff7a
H.ISMI:	equ 0xff7f
H.WIDT:	equ 0xff84
H.LIST:	equ 0xff89
H.BUFL:	equ 0xff8e
H.MDTM:	equ 0xff93
H.SCNE:	equ 0xff98
H.FRET:	equ 0xff9d
H.PTRG:	equ 0xffa2
H.PHYD:	equ 0xffa7
H.FORM:	equ 0xffac
H.ERRO:	equ 0xffb1
H.LPTO:	equ 0xffb6
H.LPTS:	equ 0xffbb
H.SCRE:	equ 0xffc0
EXTBIO:	equ 0xffca
RG8SAV:	equ 0xffe7

CHKRAM:
	di			;0000	f3 	. 
	jp CHKRAM_DO		;0001	c3 16 04 	. . . 
CGTABL:
	defw CHARGEN_start	;0004	bf 1b 	. . 
	defb 098h		;0006	98 	. 
	defb 098h		;0007	98 	. 
SYNCHR:
	jp SYNCHR_DO		;0008	c3 83 26 	. . & 
	nop			;000b	00 	. 
RDSLT:
	jp RDSLT_DO		;000c	c3 f5 01 	. . . 
	nop			;000f	00 	. 
CHRGTR:
	jp CHRGTR_DO		;0010	c3 86 26 	. . & 
	nop			;0013	00 	. 
WRSLT:
	jp WRSLT_DO		;0014	c3 25 02 	. % . 
	nop			;0017	00 	. 
OUTDO:
	jp OUTDO_DO		;0018	c3 45 1b 	. E . 
	nop			;001b	00 	. 
CALSLT:
	jp CALSLT_DO		;001c	c3 17 02 	. . . 
	nop			;001f	00 	. 
DCOMPR:
	jp DCOMPR_DO		;0020	c3 04 0c 	. . . 
	nop			;0023	00 	. 
ENASLT:
	jp ENASLT_DO		;0024	c3 33 03 	. 3 . 
	nop			;0027	00 	. 
GETYPR:
	jp GETYPR_DO		;0028	c3 89 26 	. . & 
IDBYTES:
    IF INTHZ == 60
	defb 021h		;002b	91 	. 
    ELSE
	defb 0a1h		;002b	91 	. 
    ENDIF
    IF JAPANESE == 1
	defb 001h		;002c	01 	. 
    ELSE
	defb 011h		;002c	11 	. 
    ENDIF
    IF VERSION == 3
	defb 002h		;002d	02 	. 
    ELSE
	defb 001h		;002d	01 	. 
    ENDIF
	defb 000h		;002e	00 	. 
	nop			;002f	00 	. 
CALLF:
	jp CALLF_DO		;0030	c3 c6 02 	. . . 
	nop			;0033	00 	. 
DBZEROHDR:
	defb 000h	    	;0034	00 	. 
	defb 000h		;0035	00 	. 
	defb 000h		;0036	00 	. 
	defb 000h    		;0037	00 	. 
KEYINT:
	jp KEYINT_DO		;0038	c3 3c 0c 	. < . 
INITIO:
	jp INTIO_DO		;003b	c3 92 05 	. . . 
INIFNK:
	jp INIFNK_DO		;003e	c3 a0 13 	. . . 
DISSCR:
	jp DISSCR_DO		;0041	c3 0a 06 	. . . 
ENASCR:
	jp ENASCR_DO		;0044	c3 03 06 	. . . 
WRTVDP:
	jp WRTVDP_DO		;0047	c3 12 06 	. . . 
RDVRM:
	jp RDVRM_DO		;004a	c3 e1 07 	. . . 
WRTVRM:
	jp WRTVRM_DO		;004d	c3 d7 07 	. . . 
SETRD:
	jp SETRD_DO		;0050	c3 08 08 	. . . 
SETWRT:
	jp SETWRT_DO		;0053	c3 f4 07 	. . . 
FILVRM:
	jp FILVRM_DO		;0056	c3 3b 08 	. ; . 
LDIRMV:
	jp LDIRMV_DO		;0059	c3 3d 07 	. = . 
LDIRVM:
	jp LDIRMVM_DO		;005c	c3 80 07 	. . . 
CHGMOD:
	jp CHGMOD_DO		;005f	c3 b1 08 	. . . 
CHGCLR:
	jp CHGCLR_DO		;0062	c3 1a 08 	. . . 
	nop			;0065	00 	. 
NMI:
	jp NMI_DO		;0066	c3 9b 13 	. . . 
CLRSPR:
	jp CLRSPR_DO		;0069	c3 7f 06 	.  . 
INITXT:
	jp INITXT_DO		;006c	c3 3e 06 	. > . 
INIT32:
	jp INIT32_DO		;006f	c3 47 06 	. G . 
INIGRP:
	jp INIGRP_DO		;0072	c3 4f 06 	. O . 
INIMLT:
	jp INIMLT_DO		;0075	c3 57 06 	. W . 
SETTXT:
	jp SETTXT_DO		;0078	c3 5f 06 	. _ . 
SETT32:
	jp SETT32_DO		;007b	c3 67 06 	. g . 
SETGRP:
	jp SETGRP_DO		;007e	c3 6f 06 	. o . 
SETMLT:
	jp SETMLT_DO		;0081	c3 77 06 	. w . 
CALPAT:
	jp CALPAT_DO		;0084	c3 ec 06 	. . . 
CALATR:
	jp CALATR_DO		;0087	c3 01 07 	. . . 
GSPSIZ:
	jp GSPSIZ_DO		;008a	c3 0c 07 	. . . 
GRPPRT:
	jp GRPPRT_DO		;008d	c3 0e 15 	. . . 
GICINI:
	jp GICINI_DO		;0090	c3 b2 05 	. . . 
WRTPSG:
	jp WRTPSG_DO		;0093	c3 02 11 	. . . 
RDPSG:
	jp RDPSG_DO		;0096	c3 0e 11 	. . . 
STRTMS:
	jp STRTMS_DO		;0099	c3 ba 11 	. . . 
CHSNS:
	jp CHSNS_DO		;009c	c3 6a 0d 	. j . 
CHGET:
	jp CHGET_DO		;009f	c3 cb 10 	. . . 
CHPUT:
	jp CHPUT_DO		;00a2	c3 19 09 	. . . 
LPTOUT:
	jp LPTOUT_DO		;00a5	c3 ba 08 	. . . 
LPTSTT:
	jp LPTSTT_DO		;00a8	c3 e1 08 	. . . 
CNVCHR:
	jp CNVCHR_DO		;00ab	c3 fa 08 	. . . 
PINLIN:
	jp PINL_DO		;00ae	c3 bf 23 	. . # 
INLIN:
	jp INLIN_DO		;00b1	c3 d5 23 	. . # 
QINLIN:
	jp QINLIN_DO		;00b4	c3 cc 23 	. . # 
BREAKX:
	jp BREAKX_DO		;00b7	c3 64 05 	. d . 
ISCNTC:
	jp ISCNTC_DO		;00ba	c3 f0 04 	. . . 
CKCNTC:
	jp CKCNTC_DO		;00bd	c3 f9 10 	. . . 
BEEP:
	jp BEEP_DO		;00c0	c3 13 11 	. . . 
CLS:
	jp CLS_DO		;00c3	c3 97 08 	. . . 
POSIT:
	jp POSIT_DO		;00c6	c3 eb 08 	. . . 
FNKSB:
	jp FNKSB_DO		;00c9	c3 3a 0b 	. : . 
ERAFNK:
	jp ERAFNK_DO		;00cc	c3 29 0b 	. ) . 
DSPFNK:
	jp DSPFNK_DO		;00cf	c3 3f 0b 	. ? . 
TOTEXT:
	jp TOTEXT_DO		;00d2	c3 9e 08 	. . . 
GTSTCK:
	jp GTSTCK_DO		;00d5	c3 e4 11 	. . . 
GTTRIG:
	jp GTTRIG_DO		;00d8	c3 49 12 	. I . 
GTPAD:
	jp GTPAD_DO		;00db	c3 a2 12 	. . . 
GTPDL:
	jp GTPDL_DO		;00de	c3 69 12 	. i . 
TAPION:
	jp TAPION_DO		;00e1	c3 63 1a 	. c . 
TAPIN:
	jp TAPIN_DO		;00e4	c3 bc 1a 	. . . 
TAPIOF:
	jp TAPIOF_DO		;00e7	c3 e9 19 	. . . 
TAPOON:
	jp TAPOON_DO		;00ea	c3 f1 19 	. . . 
TAPOUT:
	jp TAPOUT_DO		;00ed	c3 19 1a 	. . . 
TAPOOF:
	jp TAPOOF_DO		;00f0	c3 dd 19 	. . . 
STMOTR:
	jp STMOTR_DO		;00f3	c3 87 13 	. . . 
LFTQ:
	jp LFTQ_DO		;00f6	c3 e9 14 	. . . 
PUTQ:
	jp PUTQ_DO		;00f9	c3 90 14 	. . . 
RIGHTC:
	jp RIGHTC_DO		;00fc	c3 56 17 	. V . 
LEFTC:
	jp LEFTC_DO		;00ff	c3 90 17 	. . . 
UPC:
	jp UPC_DO		;0102	c3 1f 18 	. . . 
TUPC:
	jp TUPC_DO		;0105	c3 f6 17 	. . . 
DOWNC:
	jp DOWNC_DO		;0108	c3 dc 17 	. . . 
TDOWNC:
	jp TDOWNC_DO		;010b	c3 b4 17 	. . . 
SCALXY:
	jp SCALXY_DO		;010e	c3 a5 15 	. . . 
MAPXYC:
	jp MAPXYC_DO		;0111	c3 04 16 	. . . 
FETCHC:
	jp FETCHC_DO		;0114	c3 51 16 	. Q . 
STOREC:
	jp STOREC_DO		;0117	c3 58 16 	. X . 
SETATR:
	jp SETATR_DO		;011a	c3 92 16 	. . . 
READC:
	jp READC_DO		;011d	c3 5f 16 	. _ . 
SETC:
	jp SETC_DO		;0120	c3 c3 16 	. . . 
NSETCX:
	jp NSETCX_DO		;0123	c3 43 18 	. C . 
GTASPC:
	jp GTASPC_DO		;0126	c3 01 19 	. . . 
PNTINI:
	jp PNTINI_DO		;0129	c3 09 19 	. . . 
SCANR:
	jp SCANR_DO		;012c	c3 1e 19 	. . . 
SCANL:
	jp SCANL_DO		;012f	c3 94 19 	. . . 
CHGCAP:
	jp CHGCAP_DO		;0132	c3 3d 0f 	. = . 
CHGSND:
	jp CHGSND_DO		;0135	c3 7a 0f 	. z . 
RSLREG:
	jp RSLREG_DO		;0138	c3 0e 14 	. . . 
WSLREG:
	jp WSLREG_DO		;013b	c3 11 14 	. . . 
RDVDP:
	jp RDVDP_DO		;013e	c3 0b 14 	. . . 
SNSMAT:
	jp SNSMAT_DO		;0141	c3 ec 0b 	. . . 
PHYDIO:
	jp PHYDIO_DO		;0144	c3 14 14 	. . . 
FORMAT:
	jp FORMAT_DO		;0147	c3 18 14 	. . . 
ISFLIO:
	jp ISFLIO_DO		;014a	c3 f9 0b 	. . . 
OUTDLP:
	jp OUTDLP_DO		;014d	c3 63 1b 	. c . 
GETVCP:
	jp GETVCP_DO		;0150	c3 0a 0c 	. . . 
GETVC2:
	jp GETVC2_DO		;0153	c3 0e 0c 	. . . 
KILBUF:
	jp KILBUF_DO		;0156	c3 5d 05 	. ] . 
CALBAS:
	jp CALBAS_DO		;0159	c3 bf 02 	. . . 
SUBROM:
	jp SUBROM_DO		;015c	c3 95 02 	. . . 
EXTROM:
	jp EXTROM_DO		;015f	c3 9b 02 	. . . 
CHKSLZ:
	jp CHKSLZ_DO		;0162	c3 ac 03 	. . . 
CHKNEW:
	jp CHKNEW_DO		;0165	c3 a9 06 	. . . 
EOL:
	jp EOL_DO		;0168	c3 05 0b 	. . . 
BIGFIL:
	jp BIGFIL_DO		;016b	c3 38 08 	. 8 . 
NSETRD:
	jp NSETRD_DO		;016e	c3 c5 06 	. . . 
NSTWRT:
	jp NSTWRT_DO		;0171	c3 b3 06 	. . . 
NRDVRM:
	jp NRDVRM_DO		;0174	c3 e9 07 	. . . 
NWRVRM:
	jp NWRVRM_DO		;0177	c3 69 07 	. i . 
RDBTST:
	jp READ_F4		;017a	c3 6a 14 	. j . 
WRBTST:
	jp WRITE_F4		;017d	c3 6e 14 	. n . 
CHGCPU:
	nop			;0180	00 	. 
	nop			;0181	00 	. 
	nop			;0182	00 	. 
GETCPU:
	nop			;0183	00 	. 
	nop			;0184	00 	. 
	nop			;0185	00 	. 
	nop			;0186	00 	. 
	nop			;0187	00 	. 
	nop			;0188	00 	. 
	nop			;0189	00 	. 
	nop			;018a	00 	. 
	nop			;018b	00 	. 
	nop			;018c	00 	. 
	nop			;018d	00 	. 
	nop			;018e	00 	. 
	nop			;018f	00 	. 
	ret 			;0190	c9 	. 
	nop			;0191	00 	. 
	nop			;0192	00 	. 
	nop			;0193	00 	. 
	nop			;0194	00 	. 
	nop			;0195	00 	. 
	nop			;0196	00 	. 
	nop			;0197	00 	. 
	nop			;0198	00 	. 
	nop			;0199	00 	. 
	nop			;019a	00 	. 
	nop			;019b	00 	. 
	nop			;019c	00 	. 
	nop			;019d	00 	. 
	nop			;019e	00 	. 
	nop			;019f	c9 	. 
	nop			;01a0	00 	. 
	nop			;01a1	00 	. 
	nop			;01a2	00 	. 
	nop			;01a3	00 	. 
	nop			;01a4	00 	. 
	nop			;01a5	00 	. 
	nop			;01a6	00 	. 
	nop			;01a7	00 	. 
	nop			;01a8	00 	. 
	nop			;01a9	00 	. 
	nop			;01aa	00 	. 
	nop			;01ab	00 	. 
	nop			;01ac	00 	. 
	nop			;01ad	00 	. 
	nop			;01ae	00 	. 
	nop			;01af	00 	. 
	nop			;01b0	00 	. 
	nop			;01b1	00 	. 
	nop			;01b2	00 	. 
	nop			;01b3	00 	. 
	nop			;01b4	00 	. 
	nop			;01b5	00 	. 
CALLSLT0P0:
	pop af			;01b6	f1 	. 
	ld d,0fch		;01b7	16 fc 	. . 
	and 00ch		;01b9	e6 0c 	. . 
	rrca			;01bb	0f 	. 
	rrca			;01bc	0f 	. 
	ld h,a			;01bd	67 	g 
	in a,(0a8h)		;01be	db a8 	. . 
	ld b,a			;01c0	47 	G 
	and 03fh		;01c1	e6 3f 	. ? 
	out (0a8h),a		;01c3	d3 a8 	. . 
	ld a,(0ffffh)		;01c5	3a ff ff 	: . . 
	cpl			;01c8	2f 	/ 
	ld c,a			;01c9	4f 	O 
	and d			;01ca	a2 	. 
	or h			;01cb	b4 	. 
	ld e,a			;01cc	5f 	_ 
	ld (0ffffh),a		;01cd	32 ff ff 	2 . . 
	ld a,b			;01d0	78 	x 
	and d			;01d1	a2 	. 
	out (0a8h),a		;01d2	d3 a8 	. . 
	ld a,e			;01d4	7b 	{ 
	ld (SLTTBL),a		;01d5	32 c5 fc 	2 . . 
	push bc			;01d8	c5 	. 
	exx			;01d9	d9 	. 
	ex af,af'		;01da	08 	. 
	call CLPRM1		;01db	cd 98 f3 	. . . 
	di			;01de	f3 	. 
	ex af,af'		;01df	08 	. 
	exx			;01e0	d9 	. 
	pop bc			;01e1	c1 	. 
	ld a,b			;01e2	78 	x 
	and 03fh		;01e3	e6 3f 	. ? 
	out (0a8h),a		;01e5	d3 a8 	. . 
	ld a,c			;01e7	79 	y 
	ld (0ffffh),a		;01e8	32 ff ff 	2 . . 
	ld a,b			;01eb	78 	x 
	out (0a8h),a		;01ec	d3 a8 	. . 
	ld a,c			;01ee	79 	y 
	ld (SLTTBL),a		;01ef	32 c5 fc 	2 . . 
	ex af,af'		;01f2	08 	. 
	exx			;01f3	d9 	. 
	ret			;01f4	c9 	. 
RDSLT_DO:
	call sub_0353h		;01f5	cd 53 03 	. S . 
	jp m,RDSLTEXP		;01f8	fa 05 02 	. . . 
	in a,(0a8h)		;01fb	db a8 	. . 
	ld d,a			;01fd	57 	W 
	and c			;01fe	a1 	. 
	or b			;01ff	b0 	. 
	call RDPRIM		;0200	cd 80 f3 	. . . 
	ld a,e			;0203	7b 	{ 
	ret			;0204	c9 	. 
RDSLTEXP:
	call sub_028ch		;0205	cd 8c 02 	. . . 
	jr nz,RDSLTNOT0P0	;0208	20 10 	  . 
	push hl			;020a	e5 	. 
	call sub_0255h		;020b	cd 55 02 	. U . 
	ex (sp),hl		;020e	e3 	. 
	call sub_7fbeh		;020f	cd be 7f 	. .  
	jr l0244h		;0212	18 30 	. 0 
	nop			;0214	00 	. 
	nop			;0215	00 	. 
	nop			;0216	00 	. 
CALSLT_DO:
	jp l02d8h		;0217	c3 d8 02 	. . . 
RDSLTNOT0P0:
	push hl			;021a	e5 	. 
	call sub_0378h		;021b	cd 78 03 	. x . 
	ex (sp),hl		;021e	e3 	. 
	push bc			;021f	c5 	. 
	call RDSLT_DO		;0220	cd f5 01 	. . . 
	jr l0279h		;0223	18 54 	. T 
WRSLT_DO:
	push de			;0225	d5 	. 
	call sub_0353h		;0226	cd 53 03 	. S . 
	jp m,WRSLTEXP		;0229	fa 35 02 	. 5 . 
	pop de			;022c	d1 	. 
	in a,(0a8h)		;022d	db a8 	. . 
	ld d,a			;022f	57 	W 
	and c			;0230	a1 	. 
	or b			;0231	b0 	. 
	jp WRPRIM		;0232	c3 85 f3 	. . . 
WRSLTEXP:
	call sub_028ch		;0235	cd 8c 02 	. . . 
	jp nz,l026eh		;0238	c2 6e 02 	. n . 
	pop de			;023b	d1 	. 
	push hl			;023c	e5 	. 
	call sub_0255h		;023d	cd 55 02 	. U . 
	ex (sp),hl		;0240	e3 	. 
	call sub_7fc4h		;0241	cd c4 7f 	. .  
l0244h:
	ex (sp),hl			;0244	e3 	. 
	push af			;0245	f5 	. 
	ld a,l			;0246	7d 	} 
	and 03fh		;0247	e6 3f 	. ? 
	out (0a8h),a		;0249	d3 a8 	. . 
	ld a,h			;024b	7c 	| 
	ld (0ffffh),a		;024c	32 ff ff 	2 . . 
	ld a,l			;024f	7d 	} 
	out (0a8h),a		;0250	d3 a8 	. . 
	pop af			;0252	f1 	. 
	pop hl			;0253	e1 	. 
	ret			;0254	c9 	. 
sub_0255h:
	push af			;0255	f5 	. 
	in a,(0a8h)		;0256	db a8 	. . 
	ld l,a			;0258	6f 	o 
	and 03fh		;0259	e6 3f 	. ? 
	out (0a8h),a		;025b	d3 a8 	. . 
	ld a,(0ffffh)		;025d	3a ff ff 	: . . 
	cpl			;0260	2f 	/ 
	ld h,a			;0261	67 	g 
	and 0f3h		;0262	e6 f3 	. . 
	ld (0ffffh),a		;0264	32 ff ff 	2 . . 
	ld a,l			;0267	7d 	} 
	and 0f3h		;0268	e6 f3 	. . 
	out (0a8h),a		;026a	d3 a8 	. . 
	pop af			;026c	f1 	. 
	ret			;026d	c9 	. 
l026eh:
	ex (sp),hl		;026e	e3 	. 
	push hl			;026f	e5 	. 
	call sub_0378h		;0270	cd 78 03 	. x . 
	pop de			;0273	d1 	. 
	ex (sp),hl		;0274	e3 	. 
	push bc			;0275	c5 	. 
	call WRSLT_DO		;0276	cd 25 02 	. % . 
l0279h:
	pop bc			;0279	c1 	. 
	ex (sp),hl		;027a	e3 	. 
	push af			;027b	f5 	. 
	ld a,b			;027c	78 	x 
	and 03fh		;027d	e6 3f 	. ? 
	or c			;027f	b1 	. 
	out (0a8h),a		;0280	d3 a8 	. . 
	ld a,l			;0282	7d 	} 
	ld (0ffffh),a		;0283	32 ff ff 	2 . . 
	ld a,b			;0286	78 	x 
	out (0a8h),a		;0287	d3 a8 	. . 
	pop af			;0289	f1 	. 
	pop hl			;028a	e1 	. 
	ret			;028b	c9 	. 
sub_028ch:
	inc d			;028c	14 	. 
	dec d			;028d	15 	. 
	ret nz			;028e	c0 	. 
	ld b,a			;028f	47 	G 
	ld a,e			;0290	7b 	{ 
	cp 003h		        ;0291	fe 03 	. . 
	ld a,b			;0293	78 	x 
	ret			;0294	c9 	. 
SUBROM_DO:
	call EXTROM_DO		;0295	cd 9b 02 	. . . 
	pop ix		        ;0298	dd e1 	. . 
	ret			;029a	c9 	. 
EXTROM_DO:
	exx			;029b	d9 	. 
	ex af,af'		;029c	08 	. 
	push hl			;029d	e5 	. 
	push de			;029e	d5 	. 
	push bc			;029f	c5 	. 
	push af			;02a0	f5 	. 
	ld a,i		        ;02a1	ed 57 	. W 
	push af			;02a3	f5 	. 
	exx			;02a4	d9 	. 
	ex af,af'		;02a5	08 	. 
	push iy		        ;02a6	fd e5 	. . 
	ld iy,(0faf7h)		;02a8	fd 2a f7 fa 	. * . . 
	call CALSLT_DO		;02ac	cd 17 02 	. . . 
	pop iy		        ;02af	fd e1 	. . 
	ex af,af'		;02b1	08 	. 
	exx			;02b2	d9 	. 
	pop af			;02b3	f1 	. 
	jp po,l02b8h		;02b4	e2 b8 02 	. . . 
	ei			;02b7	fb 	. 
l02b8h:
	pop af			;02b8	f1 	. 
	pop bc			;02b9	c1 	. 
	pop de			;02ba	d1 	. 
	pop hl			;02bb	e1 	. 
	exx			;02bc	d9 	. 
	ex af,af'		;02bd	08 	. 
	ret			;02be	c9 	. 
CALBAS_DO:
	ld iy,(0fcc0h)		;02bf	fd 2a c0 fc 	. * . . 
	jp CALSLT_DO		;02c3	c3 17 02 	. . . 
CALLF_DO:
	ex (sp),hl		;02c6	e3 	. 
	push af			;02c7	f5 	. 
	push de			;02c8	d5 	. 
	ld a,(hl)		;02c9	7e 	~ 
	push af			;02ca	f5 	. 
	pop iy		        ;02cb	fd e1 	. . 
	inc hl			;02cd	23 	# 
	ld e,(hl)		;02ce	5e 	^ 
	inc hl			;02cf	23 	# 
	ld d,(hl)		;02d0	56 	V 
	inc hl			;02d1	23 	# 
	push de			;02d2	d5 	. 
	pop ix		        ;02d3	dd e1 	. . 
	pop de			;02d5	d1 	. 
	pop af			;02d6	f1 	. 
	ex (sp),hl		;02d7	e3 	. 
l02d8h:
	exx			;02d8	d9 	. 
	ex af,af'		;02d9	08 	. 
	push iy		        ;02da	fd e5 	. . 
	pop af			;02dc	f1 	. 
	push ix		        ;02dd	dd e5 	. . 
	pop hl			;02df	e1 	. 
	call sub_0353h		;02e0	cd 53 03 	. S . 
	jp m,l02efh		;02e3	fa ef 02 	. . . 
	in a,(0a8h)		;02e6	db a8 	. . 
	push af			;02e8	f5 	. 
	and c			;02e9	a1 	. 
	or b			;02ea	b0 	. 
	exx			;02eb	d9 	. 
	jp CLPRIM		;02ec	c3 8c f3 	. . . 
l02efh:
	push af			;02ef	f5 	. 
	and 003h		;02f0	e6 03 	. . 
	jr nz,l02fah		;02f2	20 06 	  . 
	ld a,h			;02f4	7c 	| 
	and 0c0h		;02f5	e6 c0 	. . 
	jp z,CALLSLT0P0		;02f7	ca b6 01 	. . . 
l02fah:
	pop af			;02fa	f1 	. 
	call sub_0378h		;02fb	cd 78 03 	. x . 
	push af			;02fe	f5 	. 
	pop iy		        ;02ff	fd e1 	. . 
	push hl			;0301	e5 	. 
	push bc			;0302	c5 	. 
	ld c,a			;0303	4f 	O 
	ld b,000h		;0304	06 00 	. . 
	ld a,l			;0306	7d 	} 
	and h			;0307	a4 	. 
l0308h:
	or d			;0308	b2 	. 
	ld hl,SLTTBL		;0309	21 c5 fc 	! . . 
	add hl,bc		;030c	09 	. 
	ld (hl),a		;030d	77 	w 
	push hl			;030e	e5 	. 
	ex af,af'		;030f	08 	. 
	exx			;0310	d9 	. 
	call CALSLT_DO		;0311	cd 17 02 	. . . 
	exx			;0314	d9 	. 
	ex af,af'		;0315	08 	. 
	pop hl			;0316	e1 	. 
	pop bc			;0317	c1 	. 
	pop de			;0318	d1 	. 
	ld a,i		        ;0319	ed 57 	. W 
	push af			;031b	f5 	. 
	ld a,b			;031c	78 	x 
	and 03fh		;031d	e6 3f 	. ? 
	or c			;031f	b1 	. 
	di			;0320	f3 	. 
	out (0a8h),a		;0321	d3 a8 	. . 
	ld a,e			;0323	7b 	{ 
	ld (0ffffh),a		;0324	32 ff ff 	2 . . 
	ld a,b			;0327	78 	x 
	out (0a8h),a		;0328	d3 a8 	. . 
	ld (hl),e		;032a	73 	s 
	pop af			;032b	f1 	. 
	jp po,l0330h		;032c	e2 30 03 	. 0 . 
	ei			;032f	fb 	. 
l0330h:
	ex af,af'			;0330	08 	. 
	exx			;0331	d9 	. 
	ret			;0332	c9 	. 
ENASLT_DO:
	call sub_0353h		;0333	cd 53 03 	. S . 
	jp m,l0340h		;0336	fa 40 03 	. @ . 
	in a,(0a8h)		;0339	db a8 	. . 
	and c			;033b	a1 	. 
	or b			;033c	b0 	. 
	out (0a8h),a		;033d	d3 a8 	. . 
	ret			;033f	c9 	. 
l0340h:
	push hl			;0340	e5 	. 
	call sub_0378h		;0341	cd 78 03 	. x . 
	ld c,a			;0344	4f 	O 
	ld b,000h		;0345	06 00 	. . 
	ld a,l			;0347	7d 	} 
	and h			;0348	a4 	. 
	or d			;0349	b2 	. 
	ld hl,SLTTBL		;034a	21 c5 fc 	! . . 
	add hl,bc		;034d	09 	. 
	ld (hl),a		;034e	77 	w 
	pop hl			;034f	e1 	. 
	ld a,c			;0350	79 	y 
	jr ENASLT_DO		;0351	18 e0 	. . 
sub_0353h:
	di			;0353	f3 	. 
	push af			;0354	f5 	. 
	ld a,h			;0355	7c 	| 
	rlca			;0356	07 	. 
	rlca			;0357	07 	. 
	and 003h		;0358	e6 03 	. . 
	ld e,a			;035a	5f 	_ 
	ld a,0c0h		;035b	3e c0 	> . 
l035dh:
	rlca			;035d	07 	. 
	rlca			;035e	07 	. 
	dec e			;035f	1d 	. 
	jp p,l035dh		;0360	f2 5d 03 	. ] . 
	ld e,a			;0363	5f 	_ 
	cpl			;0364	2f 	/ 
	ld c,a			;0365	4f 	O 
	pop af			;0366	f1 	. 
	push af			;0367	f5 	. 
	and 003h		;0368	e6 03 	. . 
	inc a			;036a	3c 	< 
	ld b,a			;036b	47 	G 
	ld a,0abh		;036c	3e ab 	> . 
l036eh:
	add a,055h		;036e	c6 55 	. U 
	djnz l036eh		;0370	10 fc 	. . 
	ld d,a			;0372	57 	W 
	and e			;0373	a3 	. 
	ld b,a			;0374	47 	G 
	pop af			;0375	f1 	. 
	and a			;0376	a7 	. 
	ret			;0377	c9 	. 
sub_0378h:
	push af			;0378	f5 	. 
	ld a,d			;0379	7a 	z 
	and 0c0h		;037a	e6 c0 	. . 
	ld c,a			;037c	4f 	O 
	pop af			;037d	f1 	. 
	push af			;037e	f5 	. 
	ld d,a			;037f	57 	W 
	in a,(0a8h)		;0380	db a8 	. . 
	ld b,a			;0382	47 	G 
	and 03fh		;0383	e6 3f 	. ? 
	or c			;0385	b1 	. 
	out (0a8h),a		;0386	d3 a8 	. . 
	ld a,d			;0388	7a 	z 
	rrca			;0389	0f 	. 
	rrca			;038a	0f 	. 
	and 003h		;038b	e6 03 	. . 
	ld d,a			;038d	57 	W 
	ld a,0abh		;038e	3e ab 	> . 
l0390h:
	add a,055h		;0390	c6 55 	. U 
	dec d			;0392	15 	. 
	jp p,l0390h		;0393	f2 90 03 	. . . 
	and e			;0396	a3 	. 
	ld d,a			;0397	57 	W 
	ld a,e			;0398	7b 	{ 
	cpl			;0399	2f 	/ 
	ld h,a			;039a	67 	g 
	ld a,(0ffffh)		;039b	3a ff ff 	: . . 
	cpl			;039e	2f 	/ 
	ld l,a			;039f	6f 	o 
	and h			;03a0	a4 	. 
	or d			;03a1	b2 	. 
	ld (0ffffh),a		;03a2	32 ff ff 	2 . . 
	ld a,b			;03a5	78 	x 
	out (0a8h),a		;03a6	d3 a8 	. . 
	pop af			;03a8	f1 	. 
	and 003h		;03a9	e6 03 	. . 
	ret			;03ab	c9 	. 
CHKSLZ_DO:
	di			;03ac	f3 	. 
	ld c,000h		;03ad	0e 00 	. . 
l03afh:
	ld de,EXPTBL		;03af	11 c1 fc 	. . . 
	ld hl,SLTATR		;03b2	21 c9 fc 	! . . 
l03b5h:
	ld a,(de)			;03b5	1a 	. 
	or c			;03b6	b1 	. 
	ld c,a			;03b7	4f 	O 
	push de			;03b8	d5 	. 
l03b9h:
	push hl			;03b9	e5 	. 
	ld hl,0000h		;03ba	21 00 00 	! . . 
	call sub_7e1ah		;03bd	cd 1a 7e 	. . ~ 
	push hl			;03c0	e5 	. 
	ld hl,l4443h		;03c1	21 43 44 	! C D 
	rst 20h			;03c4	e7 	. 
	pop hl			;03c5	e1 	. 
	ld b,000h		;03c6	06 00 	. . 
	jr nz,l03efh		;03c8	20 25 	  % 
	call sub_7e1ah		;03ca	cd 1a 7e 	. . ~ 
	push hl			;03cd	e5 	. 
	push bc			;03ce	c5 	. 
	push de			;03cf	d5 	. 
	pop ix		        ;03d0	dd e1 	. . 
	ld a,c			;03d2	79 	y 
l03d3h:
	push af			;03d3	f5 	. 
	pop iy		        ;03d4	fd e1 	. . 
	call nz,CALSLT_DO	;03d6	c4 17 02 	. . . 
	pop bc			;03d9	c1 	. 
	pop hl			;03da	e1 	. 
	call sub_7e1ah		;03db	cd 1a 7e 	. . ~ 
	add a,0ffh		;03de	c6 ff 	. . 
	rr b		        ;03e0	cb 18 	. . 
	call sub_7e1ah		;03e2	cd 1a 7e 	. . ~ 
	add a,0ffh		;03e5	c6 ff 	. . 
	rr b		        ;03e7	cb 18 	. . 
	srl b		        ;03e9	cb 38 	. 8 
	ld de,0fff8h		;03eb	11 f8 ff 	. . . 
	add hl,de		;03ee	19 	. 
l03efh:
	ex (sp),hl		;03ef	e3 	. 
	ld (hl),b		;03f0	70 	p 
	ex (sp),hl		;03f1	e3 	. 
	pop hl			;03f2	e1 	. 
	inc hl			;03f3	23 	# 
	inc hl			;03f4	23 	# 
	inc hl			;03f5	23 	# 
	inc hl			;03f6	23 	# 
	ld a,c			;03f7	79 	y 
	and a			;03f8	a7 	. 
	ld de,RDSLT		;03f9	11 0c 00 	. . . 
	jp p,0040ah		;03fc	f2 0a 04 	. . . 
	add a,004h		;03ff	c6 04 	. . 
	ld c,a			;0401	4f 	O 
	cp 090h		        ;0402	fe 90 	. . 
	jr c,l03b9h		;0404	38 b3 	8 . 
	and 003h		;0406	e6 03 	. . 
	ld c,a			;0408	4f 	O 
	ld a,019h		;0409	3e 19 	> . 
	pop de			;040b	d1 	. 
	inc de			;040c	13 	. 
	inc c			;040d	0c 	. 
	ld a,c			;040e	79 	y 
	cp 004h		        ;040f	fe 04 	. . 
	jr c,l03b5h		;0411	38 a2 	8 . 
        ; Expansion ROM handler
	jp l1472h		;0413	c3 72 14 	. r . 
CHKRAM_DO:
	xor a			;0416	af 	. 
	out (0ffh),a		;0417	d3 ff 	. . 
	inc a			;0419	3c 	< 
	out (0feh),a		;041a	d3 fe 	. . 
	inc a			;041c	3c 	< 
	out (0fdh),a		;041d	d3 fd 	. . 
	inc a			;041f	3c 	< 
	out (0fch),a		;0420	d3 fc 	. . 
	ld a,008h		;0422	3e 08 	> . 
	out (0bbh),a		;0424	d3 bb 	. . 
	ld a,082h		;0426	3e 82 	> . 
	out (0abh),a		;0428	d3 ab 	. . 
	xor a			;042a	af 	. 
	out (0a8h),a		;042b	d3 a8 	. . 
    ;IF INTHZ == 60
	;ld a,050h		;042d	3e 50 	> P 
	;out (0aah),a		;042f	d3 aa 	. . 
    ;ELSE
        ; This is the PAL setup patch routine, but it has been changed
        ; to also setup NTSC if INTHZ == 60, so it can be called anyways
        ; to make sure other registers are initialized correctly if the
        ; modes have been switched since last cold boot.
	jp PTCPAL		;042d	c3 d2 7b 	. . { 
	nop			;0430	00 	. 
    ;ENDIF
PTCPALRET:
	ld de,0ffffh		;0431	11 ff ff 	. . . 
	xor a			;0434	af 	. 
	ld c,a			;0435	4f 	O 
l0436h:
	out (0a8h),a		;0436	d3 a8 	. . 
	sla c		;0438	cb 21 	. ! 
	ld b,000h		;043a	06 00 	. . 
	ld hl,0ffffh		;043c	21 ff ff 	! . . 
	ld (hl),0f0h		;043f	36 f0 	6 . 
	ld a,(hl)		;0441	7e 	~ 
	sub 00fh		;0442	d6 0f 	. . 
	jr nz,l0451h		;0444	20 0b 	  . 
	ld (hl),a		;0446	77 	w 
	ld a,(hl)		;0447	7e 	~ 
	inc a			;0448	3c 	< 
	jr nz,l0451h		;0449	20 06 	  . 
	inc b			;044b	04 	. 
	set 0,c		        ;044c	cb c1 	. . 
l044eh:
	ld (0ffffh),a		;044e	32 ff ff 	2 . . 
l0451h:
	ld hl,0bf00h		;0451	21 00 bf 	! . . 
l0454h:
	ld a,(hl)		;0454	7e 	~ 
	cpl			;0455	2f 	/ 
	ld (hl),a		;0456	77 	w 
l0457h:
	cp (hl)			;0457	be 	. 
	cpl			;0458	2f 	/ 
	ld (hl),a		;0459	77 	w 
	jr nz,l0463h		;045a	20 07 	  . 
	inc l			;045c	2c 	, 
	jr nz,l0454h		;045d	20 f5 	  . 
	dec h			;045f	25 	% 
	jp m,l0454h		;0460	fa 54 04 	. T . 
l0463h:
	ld l,000h		;0463	2e 00 	. . 
	inc h			;0465	24 	$ 
	ld a,l			;0466	7d 	} 
	sub e			;0467	93 	. 
	ld a,h			;0468	7c 	| 
	sbc a,d			;0469	9a 	. 
	jr nc,l0476h		;046a	30 0a 	0 . 
	ex de,hl		;046c	eb 	. 
	ld a,(0ffffh)		;046d	3a ff ff 	: . . 
	cpl			;0470	2f 	/ 
	ld l,a			;0471	6f 	o 
	in a,(0a8h)		;0472	db a8 	. . 
	ld h,a			;0474	67 	g 
	ld sp,hl		;0475	f9 	. 
l0476h:
	ld a,b			;0476	78 	x 
	and a			;0477	a7 	. 
	jr z,l0484h		;0478	28 0a 	( . 
	ld a,(0ffffh)		;047a	3a ff ff 	: . . 
	cpl			;047d	2f 	/ 
	add a,010h		;047e	c6 10 	. . 
	cp 040h		        ;0480	fe 40 	. @ 
	jr c,l044eh		;0482	38 ca 	8 . 
l0484h:
	in a,(0a8h)		;0484	db a8 	. . 
	add a,050h		;0486	c6 50 	. P 
	jr nc,l0436h		;0488	30 ac 	0 . 
	ld hl,0000h		;048a	21 00 00 	! . . 
	add hl,sp		;048d	39 	9 
	ld a,h			;048e	7c 	| 
	out (0a8h),a		;048f	d3 a8 	. . 
	ld a,l			;0491	7d 	} 
	ld (0ffffh),a		;0492	32 ff ff 	2 . . 
	ld a,c			;0495	79 	y 
	rlca			;0496	07 	. 
	rlca			;0497	07 	. 
	rlca			;0498	07 	. 
	rlca			;0499	07 	. 
	ld c,a			;049a	4f 	O 
	ld de,0ffffh		;049b	11 ff ff 	. . . 
	in a,(0a8h)		;049e	db a8 	. . 
	and 03fh		;04a0	e6 3f 	. ? 
l04a2h:
	out (0a8h),a		;04a2	d3 a8 	. . 
	ld b,000h		;04a4	06 00 	. . 
	rlc c		        ;04a6	cb 01 	. . 
	jr nc,l04b4h		;04a8	30 0a 	0 . 
	inc b			;04aa	04 	. 
	ld a,(0ffffh)		;04ab	3a ff ff 	: . . 
	cpl			;04ae	2f 	/ 
	and 03fh		;04af	e6 3f 	. ? 
l04b1h:
	ld (0ffffh),a		;04b1	32 ff ff 	2 . . 
l04b4h:
	ld hl,0fe00h		;04b4	21 00 fe 	! . . 
l04b7h:
	ld a,(hl)		;04b7	7e 	~ 
	cpl			;04b8	2f 	/ 
	ld (hl),a		;04b9	77 	w 
	cp (hl)			;04ba	be 	. 
	cpl			;04bb	2f 	/ 
	ld (hl),a		;04bc	77 	w 
	jr nz,l04c8h		;04bd	20 09 	  . 
	inc l			;04bf	2c 	, 
	jr nz,l04b7h		;04c0	20 f5 	  . 
	dec h			;04c2	25 	% 
	ld a,h			;04c3	7c 	| 
	cp 0c0h		        ;04c4	fe c0 	. . 
	jr nc,l04b7h		;04c6	30 ef 	0 . 
l04c8h:
	ld l,000h		;04c8	2e 00 	. . 
	inc h			;04ca	24 	$ 
	ld a,l			;04cb	7d 	} 
	sub e			;04cc	93 	. 
	ld a,h			;04cd	7c 	| 
	sbc a,d			;04ce	9a 	. 
	jr nc,l04dbh		;04cf	30 0a 	0 . 
	ex de,hl		;04d1	eb 	. 
	ld a,(0ffffh)		;04d2	3a ff ff 	: . . 
	cpl			;04d5	2f 	/ 
	ld l,a			;04d6	6f 	o 
	in a,(0a8h)		;04d7	db a8 	. . 
	ld h,a			;04d9	67 	g 
	ld sp,hl		;04da	f9 	. 
l04dbh:
	ld a,b			;04db	78 	x 
	and a			;04dc	a7 	. 
	jr z,l04e7h		;04dd	28 08 	( . 
	ld a,(0ffffh)		;04df	3a ff ff 	: . . 
	cpl			;04e2	2f 	/ 
	add a,040h		;04e3	c6 40 	. @ 
	jr nc,l04b1h		;04e5	30 ca 	0 . 
l04e7h:
	in a,(0a8h)		;04e7	db a8 	. . 
	add a,040h		;04e9	c6 40 	. @ 
	jr nc,l04a2h		;04eb	30 b5 	0 . 
	jp l7b61h		;04ed	c3 61 7b 	. a { 
ISCNTC_DO:
	ld a,(BASROM)		;04f0	3a b1 fb 	: . . 
	and a			;04f3	a7 	. 
	ret nz			;04f4	c0 	. 
	push hl			;04f5	e5 	. 
	ld hl,INTFLG		;04f6	21 9b fc 	! . . 
	di			;04f9	f3 	. 
	ld a,(hl)		;04fa	7e 	~ 
	ei			;04fb	fb 	. 
	ld (hl),000h		;04fc	36 00 	6 . 
	pop hl			;04fe	e1 	. 
	and a			;04ff	a7 	. 
l0500h:
	ret z			;0500	c8 	. 
	cp 003h		        ;0501	fe 03 	. . 
	jr z,l0521h		;0503	28 1c 	( . 
	push hl			;0505	e5 	. 
	push de			;0506	d5 	. 
	push bc			;0507	c5 	. 
	call sub_0a37h		;0508	cd 37 0a 	. 7 . 
	ld hl,INTFLG		;050b	21 9b fc 	! . . 
l050eh:
	di			;050e	f3 	. 
	ld a,(hl)		;050f	7e 	~ 
	ei			;0510	fb 	. 
	ld (hl),000h		;0511	36 00 	6 . 
	and a			;0513	a7 	. 
	jr z,l050eh		;0514	28 f8 	( . 
	push af			;0516	f5 	. 
	call sub_0a84h		;0517	cd 84 0a 	. . . 
	pop af			;051a	f1 	. 
	pop bc			;051b	c1 	. 
	pop de			;051c	d1 	. 
	pop hl			;051d	e1 	. 
	cp 003h		        ;051e	fe 03 	. . 
	ret nz			;0520	c0 	. 
l0521h:
	push hl			;0521	e5 	. 
	call KILBUF_DO		;0522	cd 5d 05 	. ] . 
	call sub_0549h		;0525	cd 49 05 	. I . 
	jr nc,l0534h		;0528	30 0a 	0 . 
	ld hl,0fc6ah		;052a	21 6a fc 	! j . 
	di			;052d	f3 	. 
	call sub_0ef1h		;052e	cd f1 0e 	. . . 
	ei			;0531	fb 	. 
	pop hl			;0532	e1 	. 
	ret			;0533	c9 	. 
l0534h:
	call TOTEXT_DO		;0534	cd 9e 08 	. . . 
	ld a,(EXPTBL)		;0537	3a c1 fc 	: . . 
	ld h,040h		;053a	26 40 	& @ 
	call ENASLT_DO		;053c	cd 33 03 	. 3 . 
	pop hl			;053f	e1 	. 
	xor a			;0540	af 	. 
	ld sp,(SAVSTK)		;0541	ed 7b b1 f6 	. { . . 
	push bc			;0545	c5 	. 
	jp l63e6h		;0546	c3 e6 63 	. . c 
sub_0549h:
	ld a,(0fc6ah)		;0549	3a 6a fc 	: j . 
	rrca			;054c	0f 	. 
	ret nc			;054d	d0 	. 
	ld hl,(0fc6bh)		;054e	2a 6b fc 	* k . 
	ld a,h			;0551	7c 	| 
	or l			;0552	b5 	. 
	ret z			;0553	c8 	. 
	ld hl,(CURLIN)		;0554	2a 1c f4 	* . . 
	inc hl			;0557	23 	# 
	ld a,h			;0558	7c 	| 
	or l			;0559	b5 	. 
	ret z			;055a	c8 	. 
	scf			;055b	37 	7 
	ret			;055c	c9 	. 
KILBUF_DO:
	ld hl,(PUTPNT)		;055d	2a f8 f3 	* . . 
	ld (GETPNT),hl		;0560	22 fa f3 	" . . 
	ret			;0563	c9 	. 
BREAKX_DO:
	in a,(0aah)		;0564	db aa 	. . 
	and 0f0h		;0566	e6 f0 	. . 
	or 007h		        ;0568	f6 07 	. . 
	out (0aah),a		;056a	d3 aa 	. . 
	in a,(0a9h)		;056c	db a9 	. . 
	and 010h		;056e	e6 10 	. . 
	ret nz			;0570	c0 	. 
	in a,(0aah)		;0571	db aa 	. . 
	dec a			;0573	3d 	= 
	out (0aah),a		;0574	d3 aa 	. . 
	in a,(0a9h)		;0576	db a9 	. . 
	and 002h		;0578	e6 02 	. . 
	ret nz			;057a	c0 	. 
	push hl			;057b	e5 	. 
	ld hl,(PUTPNT)		;057c	2a f8 f3 	* . . 
	ld (GETPNT),hl		;057f	22 fa f3 	" . . 
	pop hl			;0582	e1 	. 
	ld a,(0fbe1h)		;0583	3a e1 fb 	: . . 
	and 0efh		;0586	e6 ef 	. . 
	ld (0fbe1h),a		;0588	32 e1 fb 	2 . . 
    IF INTHZ == 60
        ; Repeat at 20 scans
	ld a,014h		;058b	3e 14 	> . 
    ELSE
        ; Repeat at 32 scans
	ld a,020h		;058b	3e 20 	>   
    ENDIF
	ld (REPCNT),a		;058d	32 f7 f3 	2 . . 
	scf			;0590	37 	7 
	ret			;0591	c9 	. 
INTIO_DO:
	ld a,007h		;0592	3e 07 	> . 
	ld e,080h		;0594	1e 80 	. . 
	call WRTPSG_DO		;0596	cd 02 11 	. . . 
	ld a,00fh		;0599	3e 0f 	> . 
	ld e,0cfh		;059b	1e cf 	. . 
	call WRTPSG_DO		;059d	cd 02 11 	. . . 
	ld a,00bh		;05a0	3e 0b 	> . 
	ld e,a			;05a2	5f 	_ 
	call WRTPSG_DO		;05a3	cd 02 11 	. . . 
	call sub_110ch		;05a6	cd 0c 11 	. . . 
	and 040h		;05a9	e6 40 	. @ 
	ld (KANAMD),a		;05ab	32 ad fc 	2 . . 
	ld a,0ffh		;05ae	3e ff 	> . 
	out (090h),a		;05b0	d3 90 	. . 
GICINI_DO:
	push hl			;05b2	e5 	. 
	push de			;05b3	d5 	. 
	push bc			;05b4	c5 	. 
	push af			;05b5	f5 	. 
	ld hl,MUSICF		;05b6	21 3f fb 	! ? . 
	ld b,071h		;05b9	06 71 	. q 
	xor a			;05bb	af 	. 
l05bch:
	ld (hl),a			;05bc	77 	w 
	inc hl			;05bd	23 	# 
	djnz l05bch		;05be	10 fc 	. . 
	ld de,VOICAQ		;05c0	11 75 f9 	. u . 
	ld b,07fh		;05c3	06 7f 	.  
	ld hl,00080h		;05c5	21 80 00 	! . . 
l05c8h:
	push hl			;05c8	e5 	. 
	push de			;05c9	d5 	. 
	push bc			;05ca	c5 	. 
	push af			;05cb	f5 	. 
	call sub_14d8h		;05cc	cd d8 14 	. . . 
	pop af			;05cf	f1 	. 
	add a,008h		;05d0	c6 08 	. . 
	ld e,000h		;05d2	1e 00 	. . 
	call WRTPSG_DO		;05d4	cd 02 11 	. . . 
	sub 008h		;05d7	d6 08 	. . 
	push af			;05d9	f5 	. 
	ld l,00fh		;05da	2e 0f 	. . 
	call sub_0c11h		;05dc	cd 11 0c 	. . . 
	ex de,hl		;05df	eb 	. 
	ld hl,l05fdh		;05e0	21 fd 05 	! . . 
	ld bc,006h		;05e3	01 06 00 	. . . 
	ldir		        ;05e6	ed b0 	. . 
	pop af			;05e8	f1 	. 
	pop bc			;05e9	c1 	. 
	pop hl			;05ea	e1 	. 
	pop de			;05eb	d1 	. 
	add hl,de		;05ec	19 	. 
	ex de,hl		;05ed	eb 	. 
	inc a			;05ee	3c 	< 
	cp 003h		        ;05ef	fe 03 	. . 
	jr c,l05c8h		;05f1	38 d5 	8 . 
	ld a,007h		;05f3	3e 07 	> . 
	ld e,0b8h		;05f5	1e b8 	. . 
	call WRTPSG_DO		;05f7	cd 02 11 	. . . 
	jp l0937h		;05fa	c3 37 09 	. 7 . 
l05fdh:
	inc b			;05fd	04 	. 
	inc b			;05fe	04 	. 
	ld a,b			;05ff	78 	x 
	adc a,b			;0600	88 	. 
	rst 38h			;0601	ff 	. 
	nop			;0602	00 	. 
ENASCR_DO:
	ld a,(RG1SAV)		;0603	3a e0 f3 	: . . 
	or 040h		        ;0606	f6 40 	. @ 
	jr l060fh		;0608	18 05 	. . 
DISSCR_DO:
	ld a,(RG1SAV)		;060a	3a e0 f3 	: . . 
	and 0bfh		;060d	e6 bf 	. . 
l060fh:
	ld b,a			;060f	47 	G 
	ld c,001h		;0610	0e 01 	. . 
WRTVDP_DO:
	ld a,c			;0612	79 	y 
	and a			;0613	a7 	. 
	jr nz,l061dh		;0614	20 07 	  . 
	ld a,(RG0SAV)		;0616	3a df f3 	: . . 
	xor b			;0619	a8 	. 
	rrca			;061a	0f 	. 
	jr nc,l0629h		;061b	30 0c 	0 . 
l061dh:
	cp 008h		        ;061d	fe 08 	. . 
	jr c,l0629h		;061f	38 08 	8 . 
	push ix		        ;0621	dd e5 	. . 
	ld ix,S.WRTVDP		;0623	dd 21 2d 01 	. ! - . 
	jr l0644h		;0627	18 1b 	. . 
l0629h:
	ld a,b			;0629	78 	x 
	di			;062a	f3 	. 
	out (099h),a		;062b	d3 99 	. . 
	ld a,c			;062d	79 	y 
	or 080h		        ;062e	f6 80 	. . 
	ei			;0630	fb 	. 
	out (099h),a		;0631	d3 99 	. . 
	push hl			;0633	e5 	. 
	ld a,b			;0634	78 	x 
	ld b,000h		;0635	06 00 	. . 
	ld hl,RG0SAV		;0637	21 df f3 	! . . 
	add hl,bc		;063a	09 	. 
    IF VERSION == 3
	jp V9958INITP2		;063b	c3 40 14 	. @ . 
    ELSE
	ld (hl),a		;063b	77 	w 
	pop hl			;063c	e1 	. 
	ret			;063d	c9 	. 
    ENDIF
INITXT_DO:
	push ix		        ;063e	dd e5 	. . 
	ld ix,S.INITXT		;0640	dd 21 d5 00 	. ! . . 
l0644h:
	jp SUBROM_DO		;0644	c3 95 02 	. . . 
INIT32_DO:
	push ix		        ;0647	dd e5 	. . 
	ld ix,S.INIT32		;0649	dd 21 d9 00 	. ! . . 
	jr l0644h		;064d	18 f5 	. . 
INIGRP_DO:
	push ix		        ;064f	dd e5 	. . 
	ld ix,S.INIGRP		;0651	dd 21 dd 00 	. ! . . 
	jr l0644h		;0655	18 ed 	. . 
INIMLT_DO:
	push ix		        ;0657	dd e5 	. . 
	ld ix,S.INIMLT		;0659	dd 21 e1 00 	. ! . . 
	jr l0644h		;065d	18 e5 	. . 
SETTXT_DO:
	push ix		        ;065f	dd e5 	. . 
	ld ix,S.SETTXT		;0661	dd 21 e5 00 	. ! . . 
	jr l0644h		;0665	18 dd 	. . 
SETT32_DO:
	push ix		        ;0667	dd e5 	. . 
	ld ix,S.SETT32		;0669	dd 21 e9 00 	. ! . . 
	jr l0644h		;066d	18 d5 	. . 
SETGRP_DO:
	push ix		        ;066f	dd e5 	. . 
	ld ix,S.SETGRP		;0671	dd 21 ed 00 	. ! . . 
	jr l0644h		;0675	18 cd 	. . 
SETMLT_DO:
	push ix		        ;0677	dd e5 	. . 
	ld ix,S.SETMLT		;0679	dd 21 f1 00 	. ! . . 
	jr l0644h		;067d	18 c5 	. . 
CLRSPR_DO:
	push ix		        ;067f	dd e5 	. . 
	ld ix,S.CLRSPR		;0681	dd 21 f5 00 	. ! . . 
	jr l0644h		;0685	18 bd 	. . 
sub_0687h:
	ex de,hl		;0687	eb 	. 
	ld a,c			;0688	79 	y 
	or a			;0689	b7 	. 
	ld a,b			;068a	78 	x 
	ld b,c			;068b	41 	A 
	ret z			;068c	c8 	. 
	inc a			;068d	3c 	< 
	ret			;068e	c9 	. 
sub_068fh:
	ex de,hl		;068f	eb 	. 
	ld a,(SCRMOD)		;0690	3a af fc 	: . . 
	sub 005h		;0693	d6 05 	. . 
	jr c,l06a6h		;0695	38 0f 	8 . 
	and 002h		;0697	e6 02 	. . 
	ld a,h			;0699	7c 	| 
	jr nz,l069dh		;069a	20 01 	  . 
	rra			;069c	1f 	. 
l069dh:
	rra			;069d	1f 	. 
	ld h,a			;069e	67 	g 
	ld a,000h		;069f	3e 00 	> . 
	ld l,a			;06a1	6f 	o 
	adc a,a			;06a2	8f 	. 
	add hl,de		;06a3	19 	. 
	ld d,a			;06a4	57 	W 
	ret			;06a5	c9 	. 
l06a6h:
	ld d,000h		;06a6	16 00 	. . 
	ret			;06a8	c9 	. 
CHKNEW_DO:
	push bc			;06a9	c5 	. 
	ld b,a			;06aa	47 	G 
	ld a,(SCRMOD)		;06ab	3a af fc 	: . . 
l06aeh:
	cp 005h		        ;06ae	fe 05 	. . 
	ld a,b			;06b0	78 	x 
	pop bc			;06b1	c1 	. 
	ret			;06b2	c9 	. 
NSTWRT_DO:
	push bc			;06b3	c5 	. 
	push de			;06b4	d5 	. 
	push hl			;06b5	e5 	. 
	ld a,(ACPAGE)		;06b6	3a f6 fa 	: . . 
	and a			;06b9	a7 	. 
	ld d,a			;06ba	57 	W 
	call nz,sub_068fh	;06bb	c4 8f 06 	. . . 
	ld a,h			;06be	7c 	| 
	and 03fh		;06bf	e6 3f 	. ? 
	or 040h		        ;06c1	f6 40 	. @ 
	jr l06d3h		;06c3	18 0e 	. . 
NSETRD_DO:
	push bc			;06c5	c5 	. 
	push de			;06c6	d5 	. 
	push hl			;06c7	e5 	. 
	ld a,(ACPAGE)		;06c8	3a f6 fa 	: . . 
	and a			;06cb	a7 	. 
	ld d,a			;06cc	57 	W 
	call nz,sub_068fh	;06cd	c4 8f 06 	. . . 
	ld a,h			;06d0	7c 	| 
	and 03fh		;06d1	e6 3f 	. ? 
l06d3h:
	push af			;06d3	f5 	. 
	ld a,h			;06d4	7c 	| 
	and 0c0h		;06d5	e6 c0 	. . 
	or d			;06d7	b2 	. 
	rlca			;06d8	07 	. 
	rlca			;06d9	07 	. 
	di			;06da	f3 	. 
	out (099h),a		;06db	d3 99 	. . 
	ld a,08eh		;06dd	3e 8e 	> . 
	out (099h),a		;06df	d3 99 	. . 
	ld a,l			;06e1	7d 	} 
	out (099h),a		;06e2	d3 99 	. . 
	pop af			;06e4	f1 	. 
	ei			;06e5	fb 	. 
	out (099h),a		;06e6	d3 99 	. . 
	pop hl			;06e8	e1 	. 
	pop de			;06e9	d1 	. 
	pop bc			;06ea	c1 	. 
	ret			;06eb	c9 	. 
CALPAT_DO:
	ld l,a			;06ec	6f 	o 
	ld h,000h		;06ed	26 00 	& . 
	add hl,hl		;06ef	29 	) 
	add hl,hl		;06f0	29 	) 
	add hl,hl		;06f1	29 	) 
	call GSPSIZ_DO		;06f2	cd 0c 07 	. . . 
	cp 008h		        ;06f5	fe 08 	. . 
	jr z,l06fbh		;06f7	28 02 	( . 
	add hl,hl		;06f9	29 	) 
	add hl,hl		;06fa	29 	) 
l06fbh:
	ex de,hl		;06fb	eb 	. 
	ld hl,(PATBAS)		;06fc	2a 26 f9 	* & . 
	add hl,de		;06ff	19 	. 
	ret			;0700	c9 	. 
CALATR_DO:
	ld l,a			;0701	6f 	o 
	ld h,000h		;0702	26 00 	& . 
	add hl,hl		;0704	29 	) 
	add hl,hl		;0705	29 	) 
	ex de,hl		;0706	eb 	. 
	ld hl,(ATRBAS)		;0707	2a 28 f9 	* ( . 
	add hl,de		;070a	19 	. 
	ret			;070b	c9 	. 
GSPSIZ_DO:
	ld a,(RG1SAV)		;070c	3a e0 f3 	: . . 
	rrca			;070f	0f 	. 
	rrca			;0710	0f 	. 
l0711h:
	ld a,008h		;0711	3e 08 	> . 
	ret nc			;0713	d0 	. 
	ld a,020h		;0714	3e 20 	>   
	ret			;0716	c9 	. 
	call H.INIP		;0717	cd c7 fd 	. . . 
	ld hl,(CGPBAS)		;071a	2a 24 f9 	* $ . 
	call SETWRT_DO		;071d	cd f4 07 	. . . 
	ld a,(CGPNT)		;0720	3a 1f f9 	: . . 
	ld hl,(0f920h)		;0723	2a 20 f9 	*   . 
	ld bc,l0800h		;0726	01 00 08 	. . . 
	push af			;0729	f5 	. 
l072ah:
	pop af			;072a	f1 	. 
	push af			;072b	f5 	. 
	push bc			;072c	c5 	. 
	di			;072d	f3 	. 
	call RDSLT_DO		;072e	cd f5 01 	. . . 
	ei			;0731	fb 	. 
	pop bc			;0732	c1 	. 
	out (098h),a		;0733	d3 98 	. . 
	inc hl			;0735	23 	# 
	dec bc			;0736	0b 	. 
	ld a,c			;0737	79 	y 
	or b			;0738	b0 	. 
	jr nz,l072ah		;0739	20 ef 	  . 
	pop af			;073b	f1 	. 
	ret			;073c	c9 	. 
LDIRMV_DO:
	ld a,(SCRMOD)		;073d	3a af fc 	: . . 
	cp 004h		        ;0740	fe 04 	. . 
	jr nc,l075ah		;0742	30 16 	0 . 
	ld a,(MODE)		;0744	3a fc fa 	: . . 
	and 008h		;0747	e6 08 	. . 
	jr nz,l075ah		;0749	20 0f 	  . 
	call SETRD_DO		;074b	cd 08 08 	. . . 
	ex (sp),hl		;074e	e3 	. 
	ex (sp),hl		;074f	e3 	. 
l0750h:
	in a,(098h)		;0750	db 98 	. . 
	ld (de),a		;0752	12 	. 
	inc de			;0753	13 	. 
	dec bc			;0754	0b 	. 
	ld a,c			;0755	79 	y 
	or b			;0756	b0 	. 
	jr nz,l0750h		;0757	20 f7 	  . 
	ret			;0759	c9 	. 
l075ah:
	call NSETRD_DO		;075a	cd c5 06 	. . . 
	call sub_0687h		;075d	cd 87 06 	. . . 
	ld c,098h		;0760	0e 98 	. . 
l0762h:
	inir		        ;0762	ed b2 	. . 
	dec a			;0764	3d 	= 
	jr nz,l0762h		;0765	20 fb 	  . 
	ex de,hl		;0767	eb 	. 
	ret			;0768	c9 	. 
NWRVRM_DO:
	push af			;0769	f5 	. 
	call NSTWRT_DO		;076a	cd b3 06 	. . . 
	ex (sp),hl		;076d	e3 	. 
	ex (sp),hl		;076e	e3 	. 
	pop af			;076f	f1 	. 
	out (098h),a		;0770	d3 98 	. . 
	ret			;0772	c9 	. 
	nop			;0773	00 	. 
	nop			;0774	00 	. 
	nop			;0775	00 	. 
	nop			;0776	00 	. 
sub_0777h:
	push ix		        ;0777	dd e5 	. . 
	ld ix,S.CLS		;0779	dd 21 15 01 	. ! . . 
	jp SUBROM_DO		;077d	c3 95 02 	. . . 
LDIRMVM_DO:
	ex de,hl		;0780	eb 	. 
	ld a,(SCRMOD)		;0781	3a af fc 	: . . 
	cp 004h		        ;0784	fe 04 	. . 
	jr nc,l079ch		;0786	30 14 	0 . 
	ld a,(MODE)		;0788	3a fc fa 	: . . 
	and 008h		;078b	e6 08 	. . 
	jr nz,l079ch		;078d	20 0d 	  . 
	call SETWRT_DO		;078f	cd f4 07 	. . . 
l0792h:
	ld a,(de)		;0792	1a 	. 
	out (098h),a		;0793	d3 98 	. . 
	inc de			;0795	13 	. 
	dec bc			;0796	0b 	. 
	ld a,c			;0797	79 	y 
	or b			;0798	b0 	. 
	jr nz,l0792h		;0799	20 f7 	  . 
	ret			;079b	c9 	. 
l079ch:
	call NSTWRT_DO		;079c	cd b3 06 	. . . 
	call sub_0687h		;079f	cd 87 06 	. . . 
	ld c,098h		;07a2	0e 98 	. . 
l07a4h:
	otir		        ;07a4	ed b3 	. . 
	dec a			;07a6	3d 	= 
	jr nz,l07a4h		;07a7	20 fb 	  . 
	ex de,hl		;07a9	eb 	. 
	ret			;07aa	c9 	. 
sub_07abh:
	ld h,000h		;07ab	26 00 	& . 
	ld l,a			;07ad	6f 	o 
	add hl,hl		;07ae	29 	) 
	add hl,hl		;07af	29 	) 
	add hl,hl		;07b0	29 	) 
	ex de,hl		;07b1	eb 	. 
	ld hl,(0f920h)		;07b2	2a 20 f9 	*   . 
	add hl,de		;07b5	19 	. 
	ld de,PATWRK		;07b6	11 40 fc 	. @ . 
	ld b,008h		;07b9	06 08 	. . 
l07bbh:
	push hl			;07bb	e5 	. 
	push de			;07bc	d5 	. 
	push bc			;07bd	c5 	. 
	ld a,(CGPNT)		;07be	3a 1f f9 	: . . 
	call RDSLT_DO		;07c1	cd f5 01 	. . . 
	ei			;07c4	fb 	. 
	pop bc			;07c5	c1 	. 
	pop de			;07c6	d1 	. 
	pop hl			;07c7	e1 	. 
	ld (de),a			;07c8	12 	. 
	inc de			;07c9	13 	. 
	inc hl			;07ca	23 	# 
	djnz l07bbh		;07cb	10 ee 	. . 
	ret			;07cd	c9 	. 
	push ix		        ;07ce	dd e5 	. . 
	ld ix,S.CLRTXT		;07d0	dd 21 19 01 	. ! . . 
	jp SUBROM_DO		;07d4	c3 95 02 	. . . 
WRTVRM_DO:
	push af			;07d7	f5 	. 
	call SETWRT_DO		;07d8	cd f4 07 	. . . 
	ex (sp),hl		;07db	e3 	. 
	ex (sp),hl		;07dc	e3 	. 
	pop af			;07dd	f1 	. 
	out (098h),a		;07de	d3 98 	. . 
	ret			;07e0	c9 	. 
RDVRM_DO:
	call SETRD_DO		;07e1	cd 08 08 	. . . 
	ex (sp),hl		;07e4	e3 	. 
	ex (sp),hl		;07e5	e3 	. 
	in a,(098h)		;07e6	db 98 	. . 
	ret			;07e8	c9 	. 
NRDVRM_DO:
	call NSETRD_DO		;07e9	cd c5 06 	. . . 
	ex (sp),hl		;07ec	e3 	. 
	ex (sp),hl	    	;07ed	e3 	. 
	in a,(098h)		;07ee	db 98 	. . 
	ret			;07f0	c9 	. 
sub_07f1h:
	call sub_0b98h		;07f1	cd 98 0b 	. . . 
SETWRT_DO:
	xor a			;07f4	af 	. 
	di			;07f5	f3 	. 
	out (099h),a		;07f6	d3 99 	. . 
l07f8h:
	ld a,08eh		;07f8	3e 8e 	> . 
	out (099h),a		;07fa	d3 99 	. . 
	ld a,l			;07fc	7d 	} 
	out (099h),a		;07fd	d3 99 	. . 
	ld a,h			;07ff	7c 	| 
l0800h:
	and 03fh		;0800	e6 3f 	. ? 
	or 040h		        ;0802	f6 40 	. @ 
	out (099h),a		;0804	d3 99 	. . 
	ei			;0806	fb 	. 
	ret			;0807	c9 	. 
SETRD_DO:
	xor a			;0808	af 	. 
	di			;0809	f3 	. 
	out (099h),a		;080a	d3 99 	. . 
	ld a,08eh		;080c	3e 8e 	> . 
	out (099h),a		;080e	d3 99 	. . 
	ld a,l			;0810	7d 	} 
	out (099h),a		;0811	d3 99 	. . 
	ld a,h			;0813	7c 	| 
	and 03fh		;0814	e6 3f 	. ? 
	out (099h),a		;0816	d3 99 	. . 
	ei			;0818	fb 	. 
	ret			;0819	c9 	. 
CHGCLR_DO:
	ld a,(SCRMOD)		;081a	3a af fc 	: . . 
	dec a			;081d	3d 	= 
l081eh:
	jp m,l0881h		;081e	fa 81 08 	. . . 
	push af			;0821	f5 	. 
	call sub_088eh		;0822	cd 8e 08 	. . . 
	pop af			;0825	f1 	. 
	ret nz			;0826	c0 	. 
	ld a,(FORCLR)		;0827	3a e9 f3 	: . . 
	add a,a			;082a	87 	. 
	add a,a			;082b	87 	. 
	add a,a			;082c	87 	. 
	add a,a			;082d	87 	. 
	ld hl,BAKCLR		;082e	21 ea f3 	! . . 
	or (hl)			;0831	b6 	. 
	ld hl,(T32COL)		;0832	2a bf f3 	* . . 
	ld bc,DCOMPR		;0835	01 20 00 	.   . 
BIGFIL_DO:
	push af			;0838	f5 	. 
	jr l0841h		;0839	18 06 	. . 
FILVRM_DO:
	push af			;083b	f5 	. 
	call CHKNEW_DO		;083c	cd a9 06 	. . . 
	jr c,l0853h		;083f	38 12 	8 . 
l0841h:
	call NSTWRT_DO		;0841	cd b3 06 	. . . 
	ld a,c			;0844	79 	y 
	or a			;0845	b7 	. 
	jr z,l0849h		;0846	28 01 	( . 
	inc b			;0848	04 	. 
l0849h:
	pop af			;0849	f1 	. 
l084ah:
	out (098h),a		;084a	d3 98 	. . 
	dec c			;084c	0d 	. 
	jp nz,l084ah		;084d	c2 4a 08 	. J . 
	djnz l084ah		;0850	10 f8 	. . 
	ret			;0852	c9 	. 
l0853h:
	pop af			;0853	f1 	. 
	push hl			;0854	e5 	. 
	push de			;0855	d5 	. 
	ld e,a			;0856	5f 	_ 
	ld a,h			;0857	7c 	| 
	and 03fh		;0858	e6 3f 	. ? 
	ld h,a			;085a	67 	g 
	push hl			;085b	e5 	. 
	add hl,bc	    	;085c	09 	. 
	dec hl			;085d	2b 	+ 
	ld a,h			;085e	7c 	| 
	cp 040h		        ;085f	fe 40 	. @ 
	pop hl			;0861	e1 	. 
	jr c,l087ah		;0862	38 16 	8 . 
	push bc			;0864	c5 	. 
	xor a			;0865	af 	. 
	sub l			;0866	95 	. 
	ld c,a			;0867	4f 	O 
	ld a,040h		;0868	3e 40 	> @ 
	sbc a,h			;086a	9c 	. 
	ld b,a			;086b	47 	G 
	ld a,e			;086c	7b 	{ 
	call BIGFIL_DO		;086d	cd 38 08 	. 8 . 
	pop bc			;0870	c1 	. 
	add hl,bc		;0871	09 	. 
	ld c,l			;0872	4d 	M 
	ld a,h			;0873	7c 	| 
	sub 040h		;0874	d6 40 	. @ 
	ld b,a			;0876	47 	G 
	ld hl,0000h		;0877	21 00 00 	! . . 
l087ah:
	ld a,e			;087a	7b 	{ 
	call BIGFIL_DO		;087b	cd 38 08 	. 8 . 
	pop de			;087e	d1 	. 
	pop hl			;087f	e1 	. 
	ret			;0880	c9 	. 
l0881h:
	ld a,(FORCLR)		;0881	3a e9 f3 	: . . 
	add a,a			;0884	87 	. 
	add a,a			;0885	87 	. 
	add a,a			;0886	87 	. 
	add a,a			;0887	87 	. 
	ld hl,BAKCLR		;0888	21 ea f3 	! . . 
	or (hl)			;088b	b6 	. 
	jr l0891h		;088c	18 03 	. . 
sub_088eh:
	ld a,(BDRCLR)		;088e	3a eb f3 	: . . 
l0891h:
	ld b,a			;0891	47 	G 
	ld c,007h		;0892	0e 07 	. . 
	jp WRTVDP_DO		;0894	c3 12 06 	. . . 
CLS_DO:
	ret nz			;0897	c0 	. 
	push hl			;0898	e5 	. 
	call sub_0777h		;0899	cd 77 07 	. w . 
	pop hl			;089c	e1 	. 
	ret			;089d	c9 	. 
TOTEXT_DO:
	call sub_0b4eh		;089e	cd 4e 0b 	. N . 
	ret c			;08a1	d8 	. 
	ld a,(OLDSCR)		;08a2	3a b0 fc 	: . . 
	call H.TOTE		;08a5	cd bd fd 	. . . 
	push ix		        ;08a8	dd e5 	. . 
	ld ix,S.CHGMDP		;08aa	dd 21 b5 01 	. ! . . 
	jp SUBROM_DO		;08ae	c3 95 02 	. . . 
CHGMOD_DO:
	push ix		        ;08b1	dd e5 	. . 
	ld ix,S.CHGMOD		;08b3	dd 21 d1 00 	. ! . . 
	jp SUBROM_DO		;08b7	c3 95 02 	. . . 
LPTOUT_DO:
	call H.LPTO		;08ba	cd b6 ff 	. . . 
	push af			;08bd	f5 	. 
l08beh:
	call BREAKX_DO		;08be	cd 64 05 	. d . 
	jr c,l08d5h		;08c1	38 12 	8 . 
	call LPTSTT_DO		;08c3	cd e1 08 	. . . 
l08c6h:
	jr z,l08beh		;08c6	28 f6 	( . 
	pop af			;08c8	f1 	. 
sub_08c9h:
	push af			;08c9	f5 	. 
	out (091h),a		;08ca	d3 91 	. . 
	xor a			;08cc	af 	. 
	out (090h),a		;08cd	d3 90 	. . 
	dec a			;08cf	3d 	= 
	out (090h),a		;08d0	d3 90 	. . 
	pop af			;08d2	f1 	. 
	and a			;08d3	a7 	. 
	ret			;08d4	c9 	. 
l08d5h:
	xor a			;08d5	af 	. 
	ld (LPTPOS),a		;08d6	32 15 f4 	2 . . 
	ld a,00dh		;08d9	3e 0d 	> . 
	call sub_08c9h		;08db	cd c9 08 	. . . 
	pop af			;08de	f1 	. 
	scf			;08df	37 	7 
	ret			;08e0	c9 	. 
LPTSTT_DO:
	call H.LPTS		;08e1	cd bb ff 	. . . 
	in a,(090h)		;08e4	db 90 	. . 
	rrca			;08e6	0f 	. 
	rrca			;08e7	0f 	. 
	ccf			;08e8	3f 	? 
	sbc a,a			;08e9	9f 	. 
	ret			;08ea	c9 	. 
POSIT_DO:
	ld a,01bh		;08eb	3e 1b 	> . 
	rst 18h			;08ed	df 	. 
	ld a,059h		;08ee	3e 59 	> Y 
	rst 18h			;08f0	df 	. 
	ld a,l			;08f1	7d 	} 
	add a,01fh		;08f2	c6 1f 	. . 
	rst 18h			;08f4	df 	. 
	ld a,h			;08f5	7c 	| 
	add a,01fh		;08f6	c6 1f 	. . 
	rst 18h			;08f8	df 	. 
	ret			;08f9	c9 	. 
CNVCHR_DO:
	push hl			;08fa	e5 	. 
	push af			;08fb	f5 	. 
	ld hl,GRPHED		;08fc	21 a6 fc 	! . . 
	xor a			;08ff	af 	. 
	cp (hl)			;0900	be 	. 
	ld (hl),a			;0901	77 	w 
	jr z,l0911h		;0902	28 0d 	( . 
	pop af			;0904	f1 	. 
	sub 040h		;0905	d6 40 	. @ 
	cp 020h		        ;0907	fe 20 	.   
	jr c,l090fh		;0909	38 04 	8 . 
	add a,040h		;090b	c6 40 	. @ 
l090dh:
	cp a			;090d	bf 	. 
	scf			;090e	37 	7 
l090fh:
	pop hl			;090f	e1 	. 
	ret			;0910	c9 	. 
l0911h:
	pop af			;0911	f1 	. 
	cp 001h		        ;0912	fe 01 	. . 
	jr nz,l090dh		;0914	20 f7 	  . 
	ld (hl),a			;0916	77 	w 
	pop hl			;0917	e1 	. 
	ret			;0918	c9 	. 
CHPUT_DO:
	push hl			;0919	e5 	. 
	push de			;091a	d5 	. 
	push bc			;091b	c5 	. 
	push af			;091c	f5 	. 
	call H.CHPU		;091d	cd a4 fd 	. . . 
	call sub_0b4eh		;0920	cd 4e 0b 	. N . 
	jr nc,l0937h		;0923	30 12 	0 . 
	call sub_0a8bh		;0925	cd 8b 0a 	. . . 
	pop af			;0928	f1 	. 
	push af			;0929	f5 	. 
	call sub_093ch		;092a	cd 3c 09 	. < . 
	call sub_0a3eh		;092d	cd 3e 0a 	. > . 
	ld a,(CSRX)		;0930	3a dd f3 	: . . 
	dec a			;0933	3d 	= 
	ld (TTYPOS),a		;0934	32 61 f6 	2 a . 
l0937h:
	pop af			;0937	f1 	. 
l0938h:
	pop bc			;0938	c1 	. 
	pop de			;0939	d1 	. 
	pop hl			;093a	e1 	. 
	ret			;093b	c9 	. 
sub_093ch:
	call CNVCHR_DO		;093c	cd fa 08 	. . . 
	ret nc			;093f	d0 	. 
	ld c,a			;0940	4f 	O 
	jr nz,l0950h		;0941	20 0d 	  . 
	ld hl,ESCCNT		;0943	21 a7 fc 	! . . 
	ld a,(hl)			;0946	7e 	~ 
	and a			;0947	a7 	. 
	jp nz,l09ech		;0948	c2 ec 09 	. . . 
	ld a,c			;094b	79 	y 
	cp 020h		        ;094c	fe 20 	.   
	jr c,l0971h		;094e	38 21 	8 ! 
l0950h:
	ld hl,(CSRY)		;0950	2a dc f3 	* . . 
	cp 07fh		        ;0953	fe 7f 	.  
	jp z,l0afah		;0955	ca fa 0a 	. . . 
	call sub_0b8dh		;0958	cd 8d 0b 	. . . 
	call sub_0aa1h		;095b	cd a1 0a 	. . . 
	ret nz			;095e	c0 	. 
	xor a			;095f	af 	. 
	call sub_0bdbh		;0960	cd db 0b 	. . . 
	ld h,001h		;0963	26 01 	& . 
	call sub_0abeh		;0965	cd be 0a 	. . . 
	ret nz			;0968	c0 	. 
	call sub_0ac6h		;0969	cd c6 0a 	. . . 
	ld l,001h		;096c	2e 01 	. . 
	jp l0ae5h		;096e	c3 e5 0a 	. . . 
l0971h:
	ld hl,l098ah		;0971	21 8a 09 	! . . 
	ld c,00ch		;0974	0e 0c 	. . 
l0976h:
	inc hl			;0976	23 	# 
	inc hl			;0977	23 	# 
	and a			;0978	a7 	. 
	dec c			;0979	0d 	. 
	ret m			;097a	f8 	. 
	cp (hl)			;097b	be 	. 
	inc hl			;097c	23 	# 
	jr nz,l0976h		;097d	20 f7 	  . 
	ld c,(hl)		;097f	4e 	N 
	inc hl			;0980	23 	# 
	ld b,(hl)		;0981	46 	F 
	ld hl,(CSRY)		;0982	2a dc f3 	* . . 
	call l098ah		;0985	cd 8a 09 	. . . 
	xor a			;0988	af 	. 
	ret			;0989	c9 	. 
l098ah:
	push bc			;098a	c5 	. 
	ret			;098b	c9 	. 

; BLOCK 'KEYTBL' (start 0x098c end 0x09b0)
KEYTBL_start:
	defb 007h		;098c	07 	. 
	defb 013h		;098d	13 	. 
	defb 011h		;098e	11 	. 
	defb 008h		;098f	08 	. 
	defb 0a9h		;0990	a9 	. 
	defb 00ah		;0991	0a 	. 
	defb 009h		;0992	09 	. 
	defb 0ceh		;0993	ce 	. 
	defb 00ah		;0994	0a 	. 
	defb 00ah		;0995	0a 	. 
	defb 065h		;0996	65 	e 
	defb 009h		;0997	09 	. 
	defb 00bh		;0998	0b 	. 
	defb 0dch		;0999	dc 	. 
	defb 00ah		;099a	0a 	. 
	defb 00ch		;099b	0c 	. 
	defb 0ceh		;099c	ce 	. 
	defb 007h		;099d	07 	. 
	defb 00dh		;099e	0d 	. 
	defb 0deh		;099f	de 	. 
	defb 00ah		;09a0	0a 	. 
	defb 01bh		;09a1	1b 	. 
	defb 0e6h		;09a2	e6 	. 
	defb 009h		;09a3	09 	. 
	defb 01ch		;09a4	1c 	. 
	defb 0b8h		;09a5	b8 	. 
	defb 00ah		;09a6	0a 	. 
	defb 01dh		;09a7	1d 	. 
	defb 0a9h		;09a8	a9 	. 
	defb 00ah		;09a9	0a 	. 
	defb 01eh		;09aa	1e 	. 
	defb 0b4h		;09ab	b4 	. 
	defb 00ah		;09ac	0a 	. 
	defb 01fh		;09ad	1f 	. 
l09aeh:
	defb 0beh		;09ae	be 	. 
	defb 00ah		;09af	0a 	. 
KEYTBL_end:

; BLOCK 'ESCTBL' (start 0x09b0 end 0x09dd)
ESCTBL_start:
	defb 06ah		;09b0	6a 	j 
	defb 0ceh		;09b1	ce 	. 
	defb 007h		;09b2	07 	. 
	defb 045h		;09b3	45 	E 
	defb 0ceh		;09b4	ce 	. 
	defb 007h		;09b5	07 	. 
	defb 04bh		;09b6	4b 	K 
	defb 005h		;09b7	05 	. 
	defb 00bh		;09b8	0b 	. 
	defb 04ah		;09b9	4a 	J 
	defb 019h		;09ba	19 	. 
	defb 00bh		;09bb	0b 	. 
	defb 06ch		;09bc	6c 	l 
	defb 003h		;09bd	03 	. 
	defb 00bh		;09be	0b 	. 
	defb 04ch		;09bf	4c 	L 
	defb 0eeh		;09c0	ee 	. 
	defb 00ah		;09c1	0a 	. 
	defb 04dh		;09c2	4d 	M 
	defb 0e2h		;09c3	e2 	. 
	defb 00ah		;09c4	0a 	. 
	defb 059h		;09c5	59 	Y 
	defb 0e3h		;09c6	e3 	. 
	defb 009h		;09c7	09 	. 
	defb 041h		;09c8	41 	A 
	defb 0b4h		;09c9	b4 	. 
	defb 00ah		;09ca	0a 	. 
	defb 042h		;09cb	42 	B 
	defb 0beh		;09cc	be 	. 
	defb 00ah		;09cd	0a 	. 
	defb 043h		;09ce	43 	C 
	defb 0a1h		;09cf	a1 	. 
	defb 00ah		;09d0	0a 	. 
	defb 044h		;09d1	44 	D 
	defb 0b2h		;09d2	b2 	. 
	defb 00ah		;09d3	0a 	. 
	defb 048h		;09d4	48 	H 
	defb 0dch		;09d5	dc 	. 
	defb 00ah		;09d6	0a 	. 
	defb 078h		;09d7	78 	x 
	defb 0ddh		;09d8	dd 	. 
	defb 009h		;09d9	09 	. 
	defb 079h		;09da	79 	y 
	defb 0e0h		;09db	e0 	. 
	defb 009h		;09dc	09 	. 
ESCTBL_end:
	ld a,001h		;09dd	3e 01 	> . 
	ld bc,0023eh		;09df	01 3e 02 	. > . 
	ld bc,0043eh		;09e2	01 3e 04 	. > . 
	ld bc,H.NEWS		;09e5	01 3e ff 	. > . 
	ld (ESCCNT),a		;09e8	32 a7 fc 	2 . . 
	ret			;09eb	c9 	. 
l09ech:
	jp p,l09fah		;09ec	f2 fa 09 	. . . 
	ld (hl),000h		;09ef	36 00 	6 . 
	ld a,c			;09f1	79 	y 
	ld hl,l09aeh		;09f2	21 ae 09 	! . . 
	ld c,00fh		;09f5	0e 0f 	. . 
	jp l0976h		;09f7	c3 76 09 	. v . 
l09fah:
	dec a			;09fa	3d 	= 
	jr z,l0a1bh		;09fb	28 1e 	( . 
	dec a			;09fd	3d 	= 
	jr z,l0a25h		;09fe	28 25 	( % 
	dec a			;0a00	3d 	= 
l0a01h:
	ld (hl),a			;0a01	77 	w 
	ld a,(LINLEN)		;0a02	3a b0 f3 	: . . 
	ld de,CSRX		;0a05	11 dd f3 	. . . 
	jr z,l0a10h		;0a08	28 06 	( . 
	ld (hl),003h		;0a0a	36 03 	6 . 
	call sub_0be2h		;0a0c	cd e2 0b 	. . . 
	dec de			;0a0f	1b 	. 
l0a10h:
	ld b,a			;0a10	47 	G 
	ld a,c			;0a11	79 	y 
	sub 020h		;0a12	d6 20 	.   
	cp b			;0a14	b8 	. 
	inc a			;0a15	3c 	< 
	ld (de),a		;0a16	12 	. 
	ret c			;0a17	d8 	. 
	ld a,b			;0a18	78 	x 
	ld (de),a		;0a19	12 	. 
	ret			;0a1a	c9 	. 
l0a1bh:
	ld (hl),a		;0a1b	77 	w 
	ld a,c			;0a1c	79 	y 
	sub 034h		;0a1d	d6 34 	. 4 
	jr z,l0a2ch		;0a1f	28 0b 	( . 
	dec a			;0a21	3d 	= 
	jr z,l0a33h		;0a22	28 0f 	( . 
	ret			;0a24	c9 	. 
l0a25h:
	ld (hl),a		;0a25	77 	w 
	ld a,c			;0a26	79 	y 
	sub 034h		;0a27	d6 34 	. 4 
	jr nz,l0a30h		;0a29	20 05 	  . 
	inc a			;0a2b	3c 	< 
l0a2ch:
	ld (CSTYLE),a		;0a2c	32 aa fc 	2 . . 
	ret			;0a2f	c9 	. 
l0a30h:
	dec a			;0a30	3d 	= 
	ret nz			;0a31	c0 	. 
	inc a			;0a32	3c 	< 
l0a33h:
	ld (CSRSW),a		;0a33	32 a9 fc 	2 . . 
	ret			;0a36	c9 	. 
sub_0a37h:
	ld a,(CSRSW)		;0a37	3a a9 fc 	: . . 
	and a			;0a3a	a7 	. 
	ret nz			;0a3b	c0 	. 
	jr l0a43h		;0a3c	18 05 	. . 
sub_0a3eh:
	ld a,(CSRSW)		;0a3e	3a a9 fc 	: . . 
	and a			;0a41	a7 	. 
	ret z			;0a42	c8 	. 
l0a43h:
	call H.DSPC		;0a43	cd a9 fd 	. . . 
	call sub_0b4eh		;0a46	cd 4e 0b 	. N . 
	ret nc			;0a49	d0 	. 
	ld hl,(CSRY)		;0a4a	2a dc f3 	* . . 
	push hl			;0a4d	e5 	. 
	call sub_0b83h		;0a4e	cd 83 0b 	. . . 
	ld (CURSAV),a		;0a51	32 cc fb 	2 . . 
	ld l,a			;0a54	6f 	o 
	ld h,000h		;0a55	26 00 	& . 
	add hl,hl	    	;0a57	29 	) 
	add hl,hl	    	;0a58	29 	) 
	add hl,hl	    	;0a59	29 	) 
	ex de,hl	    	;0a5a	eb 	. 
	ld hl,(CGPBAS)		;0a5b	2a 24 f9 	* $ . 
	push hl			;0a5e	e5 	. 
	add hl,de	    	;0a5f	19 	. 
	call sub_0b54h		;0a60	cd 54 0b 	. T . 
	ld hl,0fc1fh		;0a63	21 1f fc 	! . . 
	ld b,008h		;0a66	06 08 	. . 
	ld a,(CSTYLE)		;0a68	3a aa fc 	: . . 
	and a			;0a6b	a7 	. 
	jr z,l0a70h		;0a6c	28 02 	( . 
	ld b,003h		;0a6e	06 03 	. . 
l0a70h:
	ld a,(hl)	    	;0a70	7e 	~ 
	cpl			;0a71	2f 	/ 
	ld (hl),a	    	;0a72	77 	w 
	dec hl			;0a73	2b 	+ 
	djnz l0a70h		;0a74	10 fa 	. . 
	pop hl			;0a76	e1 	. 
	ld bc,l07f8h		;0a77	01 f8 07 	. . . 
	add hl,bc	    	;0a7a	09 	. 
	call sub_0b6bh		;0a7b	cd 6b 0b 	. k . 
	pop hl			;0a7e	e1 	. 
	ld c,0ffh		;0a7f	0e ff 	. . 
	jp sub_0b8dh		;0a81	c3 8d 0b 	. . . 
sub_0a84h:
	ld a,(CSRSW)		;0a84	3a a9 fc 	: . . 
	and a			;0a87	a7 	. 
	ret nz			;0a88	c0 	. 
	jr l0a90h		;0a89	18 05 	. . 
sub_0a8bh:
	ld a,(CSRSW)		;0a8b	3a a9 fc 	: . . 
	and a			;0a8e	a7 	. 
	ret z			;0a8f	c8 	. 
l0a90h:
	call H.ERAC		;0a90	cd ae fd 	. . . 
	call sub_0b4eh		;0a93	cd 4e 0b 	. N . 
	ret nc			;0a96	d0 	. 
	ld hl,(CSRY)		;0a97	2a dc f3 	* . . 
	ld a,(CURSAV)		;0a9a	3a cc fb 	: . . 
	ld c,a			;0a9d	4f 	O 
	jp sub_0b8dh		;0a9e	c3 8d 0b 	. . . 
sub_0aa1h:
	ld a,(LINLEN)		;0aa1	3a b0 f3 	: . . 
	cp h			;0aa4	bc 	. 
	ret z			;0aa5	c8 	. 
	inc h			;0aa6	24 	$ 
	jr sub_0ac6h		;0aa7	18 1d 	. . 
sub_0aa9h:
	call 00ab2h		;0aa9	cd b2 0a 	. . . 
	ret nz			;0aac	c0 	. 
	ld a,(LINLEN)		;0aad	3a b0 f3 	: . . 
	ld h,a			;0ab0	67 	g 
	ld de,l3e25h		;0ab1	11 25 3e 	. % > 
	dec l			;0ab4	2d 	- 
	ret z			;0ab5	c8 	. 
	jr sub_0ac6h		;0ab6	18 0e 	. . 
sub_0ab8h:
	call sub_0aa1h		;0ab8	cd a1 0a 	. . . 
	ret nz			;0abb	c0 	. 
	ld h,001h		;0abc	26 01 	& . 
sub_0abeh:
	call sub_0be2h		;0abe	cd e2 0b 	. . . 
	cp l			;0ac1	bd 	. 
	ret z			;0ac2	c8 	. 
	jr c,l0acah		;0ac3	38 05 	8 . 
	inc l			;0ac5	2c 	, 
sub_0ac6h:
	ld (CSRY),hl		;0ac6	22 dc f3 	" . . 
	ret			;0ac9	c9 	. 
l0acah:
	dec l			;0aca	2d 	- 
	xor a			;0acb	af 	. 
	jr sub_0ac6h		;0acc	18 f8 	. . 
l0aceh:
	ld a,020h		;0ace	3e 20 	>   
	call sub_093ch		;0ad0	cd 3c 09 	. < . 
	ld a,(CSRX)		;0ad3	3a dd f3 	: . . 
	dec a			;0ad6	3d 	= 
	and 007h		;0ad7	e6 07 	. . 
	jr nz,l0aceh		;0ad9	20 f3 	  . 
	ret			;0adb	c9 	. 
	ld l,001h		;0adc	2e 01 	. . 
sub_0adeh:
	ld h,001h		;0ade	26 01 	& . 
	jr sub_0ac6h		;0ae0	18 e4 	. . 
	call sub_0adeh		;0ae2	cd de 0a 	. . . 
l0ae5h:
	push ix		        ;0ae5	dd e5 	. . 
	ld ix,S.DELLNO		;0ae7	dd 21 21 01 	. ! ! . 
	jp SUBROM_DO		;0aeb	c3 95 02 	. . . 
	call sub_0adeh		;0aee	cd de 0a 	. . . 
sub_0af1h:
	push ix		        ;0af1	dd e5 	. . 
	ld ix,S.INSLNO		;0af3	dd 21 25 01 	. ! % . 
	jp SUBROM_DO		;0af7	c3 95 02 	. . . 
l0afah:
	call sub_0aa9h		;0afa	cd a9 0a 	. . . 
	ret z			;0afd	c8 	. 
	ld c,020h		;0afe	0e 20 	.   
	jp sub_0b8dh		;0b00	c3 8d 0b 	. . . 
sub_0b03h:
	ld h,001h		;0b03	26 01 	& . 
EOL_DO:
	call sub_0bd9h		;0b05	cd d9 0b 	. . . 
	push hl			;0b08	e5 	. 
	call sub_07f1h		;0b09	cd f1 07 	. . . 
	pop hl			;0b0c	e1 	. 
l0b0dh:
	ld a,020h		;0b0d	3e 20 	>   
	out (098h),a		;0b0f	d3 98 	. . 
	inc h			;0b11	24 	$ 
	ld a,(LINLEN)		;0b12	3a b0 f3 	: . . 
	cp h			;0b15	bc 	. 
	jr nc,l0b0dh		;0b16	30 f5 	0 . 
	ret			;0b18	c9 	. 
l0b19h:
	push hl			;0b19	e5 	. 
	call EOL_DO		;0b1a	cd 05 0b 	. . . 
	pop hl			;0b1d	e1 	. 
l0b1eh:
	call sub_0be2h		;0b1e	cd e2 0b 	. . . 
	cp l			;0b21	bd 	. 
	ret c			;0b22	d8 	. 
	ret z			;0b23	c8 	. 
	ld h,001h		;0b24	26 01 	& . 
	inc l			;0b26	2c 	, 
	jr l0b19h		;0b27	18 f0 	. . 
ERAFNK_DO:
	call H.ERAF		;0b29	cd b8 fd 	. . . 
	xor a			;0b2c	af 	. 
	call sub_0b4bh		;0b2d	cd 4b 0b 	. K . 
	ret nc			;0b30	d0 	. 
	push hl			;0b31	e5 	. 
	ld hl,(CRTCNT)		;0b32	2a b1 f3 	* . . 
	call sub_0b03h		;0b35	cd 03 0b 	. . . 
	pop hl			;0b38	e1 	. 
	ret			;0b39	c9 	. 
FNKSB_DO:
	ld a,(CNSDFG)		;0b3a	3a de f3 	: . . 
	and a			;0b3d	a7 	. 
	ret z			;0b3e	c8 	. 
DSPFNK_DO:
	call H.DSPF		;0b3f	cd b3 fd 	. . . 
	push ix		        ;0b42	dd e5 	. . 
	ld ix,S.DSPFNK		;0b44	dd 21 1d 01 	. ! . . 
	jp SUBROM_DO		;0b48	c3 95 02 	. . . 
sub_0b4bh:
	ld (CNSDFG),a		;0b4b	32 de f3 	2 . . 
sub_0b4eh:
	ld a,(SCRMOD)		;0b4e	3a af fc 	: . . 
	cp 002h		        ;0b51	fe 02 	. . 
	ret			;0b53	c9 	. 
sub_0b54h:
	push hl			;0b54	e5 	. 
	ld c,008h		;0b55	0e 08 	. . 
	jr l0b61h		;0b57	18 08 	. . 
	push hl			;0b59	e5 	. 
	call sub_0b96h		;0b5a	cd 96 0b 	. . . 
	ld a,(LINLEN)		;0b5d	3a b0 f3 	: . . 
	ld c,a			;0b60	4f 	O 
l0b61h:
	ld b,000h		;0b61	06 00 	. . 
	ld de,LINWRK		;0b63	11 18 fc 	. . . 
	call LDIRMV_DO		;0b66	cd 3d 07 	. = . 
	pop hl			;0b69	e1 	. 
	ret			;0b6a	c9 	. 
sub_0b6bh:
	push hl			;0b6b	e5 	. 
	ld c,008h		;0b6c	0e 08 	. . 
	jr l0b78h		;0b6e	18 08 	. . 
	push hl			;0b70	e5 	. 
	call sub_0b96h		;0b71	cd 96 0b 	. . . 
	ld a,(LINLEN)		;0b74	3a b0 f3 	: . . 
	ld c,a			;0b77	4f 	O 
l0b78h:
	ld b,000h		;0b78	06 00 	. . 
	ex de,hl			;0b7a	eb 	. 
	ld hl,LINWRK		;0b7b	21 18 fc 	! . . 
	call LDIRMVM_DO		;0b7e	cd 80 07 	. . . 
	pop hl			;0b81	e1 	. 
	ret			;0b82	c9 	. 
sub_0b83h:
	push hl			;0b83	e5 	. 
	call sub_0b98h		;0b84	cd 98 0b 	. . . 
	call RDVRM_DO		;0b87	cd e1 07 	. . . 
	ld c,a			;0b8a	4f 	O 
	pop hl			;0b8b	e1 	. 
	ret			;0b8c	c9 	. 
sub_0b8dh:
	push hl			;0b8d	e5 	. 
	call sub_07f1h		;0b8e	cd f1 07 	. . . 
	ld a,c			;0b91	79 	y 
	out (098h),a		;0b92	d3 98 	. . 
	pop hl			;0b94	e1 	. 
	ret			;0b95	c9 	. 
sub_0b96h:
	ld h,001h		;0b96	26 01 	& . 
sub_0b98h:
	push bc			;0b98	c5 	. 
	dec h			;0b99	25 	% 
	dec l			;0b9a	2d 	- 
	ld e,h			;0b9b	5c 	\ 
	ld h,000h		;0b9c	26 00 	& . 
	ld d,h			;0b9e	54 	T 
	add hl,hl	    	;0b9f	29 	) 
	add hl,hl	    	;0ba0	29 	) 
	add hl,hl	    	;0ba1	29 	) 
	ld c,l			;0ba2	4d 	M 
	ld b,h			;0ba3	44 	D 
	add hl,hl	    	;0ba4	29 	) 
	add hl,hl	    	;0ba5	29 	) 
	ld a,(SCRMOD)		;0ba6	3a af fc 	: . . 
	and a			;0ba9	a7 	. 
	ld a,(LINLEN)		;0baa	3a b0 f3 	: . . 
	jr z,l0bb3h		;0bad	28 04 	( . 
	sbc a,022h		;0baf	de 22 	. " 
	jr l0bc0h		;0bb1	18 0d 	. . 
l0bb3h:
	cp 029h		        ;0bb3	fe 29 	. ) 
	jr c,l0bbdh		;0bb5	38 06 	8 . 
	add hl,bc		;0bb7	09 	. 
	add hl,hl		;0bb8	29 	) 
	sbc a,052h		;0bb9	de 52 	. R 
	jr l0bc0h		;0bbb	18 03 	. . 
l0bbdh:
	add hl,bc		;0bbd	09 	. 
	sbc a,02ah		;0bbe	de 2a 	. * 
l0bc0h:
	add hl,de		;0bc0	19 	. 
	cpl			;0bc1	2f 	/ 
	and a			;0bc2	a7 	. 
	rra			;0bc3	1f 	. 
	ld e,a			;0bc4	5f 	_ 
	add hl,de		;0bc5	19 	. 
	ex de,hl		;0bc6	eb 	. 
	ld hl,(NAMBAS)		;0bc7	2a 22 f9 	* " . 
	add hl,de		;0bca	19 	. 
	pop bc			;0bcb	c1 	. 
	ret			;0bcc	c9 	. 
sub_0bcdh:
	push hl			;0bcd	e5 	. 
	ld de,BASROM		;0bce	11 b1 fb 	. . . 
	ld h,000h		;0bd1	26 00 	& . 
	add hl,de	    	;0bd3	19 	. 
	ld a,(hl)   		;0bd4	7e 	~ 
	ex de,hl	    	;0bd5	eb 	. 
	pop hl			;0bd6	e1 	. 
	and a			;0bd7	a7 	. 
	ret			;0bd8	c9 	. 
sub_0bd9h:
	ld a,0afh		;0bd9	3e af 	> . 
sub_0bdbh:
	push af			;0bdb	f5 	. 
	call sub_0bcdh		;0bdc	cd cd 0b 	. . . 
	pop af			;0bdf	f1 	. 
	ld (de),a	    	;0be0	12 	. 
	ret			;0be1	c9 	. 
sub_0be2h:
	ld a,(CNSDFG)		;0be2	3a de f3 	: . . 
	push hl			;0be5	e5 	. 
	ld hl,CRTCNT		;0be6	21 b1 f3 	! . . 
	add a,(hl)	    	;0be9	86 	. 
	pop hl			;0bea	e1 	. 
	ret			;0beb	c9 	. 
SNSMAT_DO:
	ld c,a			;0bec	4f 	O 
	di			;0bed	f3 	. 
	in a,(0aah)		;0bee	db aa 	. . 
	and 0f0h		;0bf0	e6 f0 	. . 
	add a,c			;0bf2	81 	. 
	out (0aah),a		;0bf3	d3 aa 	. . 
	ei			;0bf5	fb 	. 
	in a,(0a9h)		;0bf6	db a9 	. . 
	ret			;0bf8	c9 	. 
ISFLIO_DO:
	call H.ISFL		;0bf9	cd df fe 	. . . 
	push hl			;0bfc	e5 	. 
	ld hl,(PTRFIL)		;0bfd	2a 64 f8 	* d . 
	ld a,l			;0c00	7d 	} 
	or h			;0c01	b4 	. 
	pop hl			;0c02	e1 	. 
	ret			;0c03	c9 	. 
DCOMPR_DO:
	ld a,h			;0c04	7c 	| 
l0c05h:
	sub d			;0c05	92 	. 
	ret nz			;0c06	c0 	. 
	ld a,l			;0c07	7d 	} 
	sub e			;0c08	93 	. 
	ret			;0c09	c9 	. 
GETVCP_DO:
	ld l,002h		;0c0a	2e 02 	. . 
	jr sub_0c11h		;0c0c	18 03 	. . 
GETVC2_DO:
	ld a,(VOICEN)		;0c0e	3a 38 fb 	: 8 . 
sub_0c11h:
	push de			;0c11	d5 	. 
	ld de,VCBA		;0c12	11 41 fb 	. A . 
	ld h,000h		;0c15	26 00 	& . 
	add hl,de			;0c17	19 	. 
	or a			;0c18	b7 	. 
	jr z,l0c22h		;0c19	28 07 	( . 
	ld de,ENASLT+1		;0c1b	11 25 00 	. % . 
l0c1eh:
	add hl,de			;0c1e	19 	. 
	dec a			;0c1f	3d 	= 
	jr nz,l0c1eh		;0c20	20 fc 	  . 
l0c22h:
	pop de			;0c22	d1 	. 
	ret			;0c23	c9 	. 
	nop			;0c24	00 	. 
l0c25h:
	ld a,(0fbebh)		;0c25	3a eb fb 	: . . 
	rrca			;0c28	0f 	. 
	jr c,l0c34h		;0c29	38 09 	8 . 
	xor a			;0c2b	af 	. 
	ld (CHRCNT),a		;0c2c	32 f9 fa 	2 . . 
	inc a			;0c2f	3c 	< 
	set 0,(hl)		;0c30	cb c6 	. . 
	jr l0c39h		;0c32	18 05 	. . 
l0c34h:
	ld a,0ffh		;0c34	3e ff 	> . 
	ld (KANAST),a		;0c36	32 ac fc 	2 . . 
l0c39h:
	jp l0f29h		;0c39	c3 29 0f 	. ) . 
KEYINT_DO:
	push hl			;0c3c	e5 	. 
	push de			;0c3d	d5 	. 
	push bc			;0c3e	c5 	. 
	push af			;0c3f	f5 	. 
	exx			;0c40	d9 	. 
	ex af,af'			;0c41	08 	. 
	push hl			;0c42	e5 	. 
	push de			;0c43	d5 	. 
	push bc			;0c44	c5 	. 
	push af			;0c45	f5 	. 
	push iy		        ;0c46	fd e5 	. . 
	push ix		        ;0c48	dd e5 	. . 
	call H.KEYI		;0c4a	cd 9a fd 	. . . 
	call sub_1479h		;0c4d	cd 79 14 	. y . 
	jp p,l0d02h		;0c50	f2 02 0d 	. . . 
	call H.TIMI		;0c53	cd 9f fd 	. . . 
	ei			;0c56	fb 	. 
	ld (STATFL),a		;0c57	32 e7 f3 	2 . . 
	and 020h		;0c5a	e6 20 	.   
	ld hl,0fc6dh		;0c5c	21 6d fc 	! m . 
	call nz,sub_0ef1h   	;0c5f	c4 f1 0e 	. . . 
	ld hl,(INTCNT)		;0c62	2a a2 fc 	* . . 
	dec hl			;0c65	2b 	+ 
	ld a,h			;0c66	7c 	| 
	or l			;0c67	b5 	. 
	jr nz,l0c73h		;0c68	20 09 	  . 
	ld hl,0fc7fh		;0c6a	21 7f fc 	!  . 
	call sub_0ef1h		;0c6d	cd f1 0e 	. . . 
	ld hl,(INTVAL)		;0c70	2a a0 fc 	* . . 
l0c73h:
	ld (INTCNT),hl		;0c73	22 a2 fc 	" . . 
	ld hl,(JIFFY)		;0c76	2a 9e fc 	* . . 
	inc hl			;0c79	23 	# 
	ld (JIFFY),hl		;0c7a	22 9e fc 	" . . 
	ld a,(MUSICF)		;0c7d	3a 3f fb 	: ? . 
	ld c,a			;0c80	4f 	O 
	xor a			;0c81	af 	. 
l0c82h:
	rr c		        ;0c82	cb 19 	. . 
	push af			;0c84	f5 	. 
	push bc			;0c85	c5 	. 
	call c,sub_1131h    	;0c86	dc 31 11 	. 1 . 
	pop bc			;0c89	c1 	. 
	pop af			;0c8a	f1 	. 
	inc a			;0c8b	3c 	< 
	cp 003h		        ;0c8c	fe 03 	. . 
	jr c,l0c82h		;0c8e	38 f2 	8 . 
	ld hl,SCNCNT		;0c90	21 f6 f3 	! . . 
	dec (hl)		;0c93	35 	5 
	jr nz,l0d02h		;0c94	20 6c 	  l 
    IF INTHZ == 60
        ; Scan frequency: 2 * 1000/60 = 33 ms
	ld (hl),002h		;0c96	36 01 	6 . 
    ELSE
        ; Scan frequency: 1 * 1000/50 = 20 ms
	ld (hl),001h		;0c96	36 01 	6 . 
    ENDIF
	xor a			;0c98	af 	. 
	call sub_1202h		;0c99	cd 02 12 	. . . 
	and 030h		;0c9c	e6 30 	. 0 
	push af			;0c9e	f5 	. 
	ld a,001h		;0c9f	3e 01 	> . 
	call sub_1202h		;0ca1	cd 02 12 	. . . 
	and 030h		;0ca4	e6 30 	. 0 
	rlca			;0ca6	07 	. 
	rlca			;0ca7	07 	. 
	pop bc			;0ca8	c1 	. 
	or b			;0ca9	b0 	. 
	push af			;0caa	f5 	. 
	call sub_121ch		;0cab	cd 1c 12 	. . . 
	and 001h		;0cae	e6 01 	. . 
	pop bc			;0cb0	c1 	. 
	or b			;0cb1	b0 	. 
	ld c,a			;0cb2	4f 	O 
	ld hl,TRGFLG		;0cb3	21 e8 f3 	! . . 
	xor (hl)	    	;0cb6	ae 	. 
	and (hl)	    	;0cb7	a6 	. 
	ld (hl),c	    	;0cb8	71 	q 
	ld c,a			;0cb9	4f 	O 
	rrca			;0cba	0f 	. 
	ld hl,0fc70h		;0cbb	21 70 fc 	! p . 
	call c,sub_0ef1h    	;0cbe	dc f1 0e 	. . . 
	rl c		        ;0cc1	cb 11 	. . 
	ld hl,0fc7ch		;0cc3	21 7c fc 	! | . 
	call c,sub_0ef1h	;0cc6	dc f1 0e 	. . . 
	rl c		        ;0cc9	cb 11 	. . 
	ld hl,0fc76h		;0ccb	21 76 fc 	! v . 
	call c,sub_0ef1h	;0cce	dc f1 0e 	. . . 
	rl c		        ;0cd1	cb 11 	. . 
	ld hl,0fc79h		;0cd3	21 79 fc 	! y . 
	call c,sub_0ef1h	;0cd6	dc f1 0e 	. . . 
	rl c		        ;0cd9	cb 11 	. . 
	ld hl,0fc73h		;0cdb	21 73 fc 	! s . 
	call c,sub_0ef1h	;0cde	dc f1 0e 	. . . 
	xor a			;0ce1	af 	. 
	ld (CLIKFL),a		;0ce2	32 d9 fb 	2 . . 
	call sub_0d12h		;0ce5	cd 12 0d 	. . . 
	jr nz,l0d02h		;0ce8	20 18 	  . 
	ld hl,REPCNT		;0cea	21 f7 f3 	! . . 
	dec (hl)		;0ced	35 	5 
	jr nz,l0d02h		;0cee	20 12 	  . 
    IF INTHZ == 60
	ld (hl),001h		;0cf0	36 02 	6 . 
    ELSE
	ld (hl),002h		;0cf0	36 02 	6 . 
    ENDIF
	ld hl,OLDKEY		;0cf2	21 da fb 	! . . 
	ld de,0fbdbh		;0cf5	11 db fb 	. . . 
	ld bc,000ah		;0cf8	01 0a 00 	. . . 
	ld (hl),0ffh		;0cfb	36 ff 	6 . 
	ldir		        ;0cfd	ed b0 	. . 
	call sub_0d4eh		;0cff	cd 4e 0d 	. N . 
l0d02h:
	pop ix		        ;0d02	dd e1 	. . 
	pop iy		        ;0d04	fd e1 	. . 
	pop af			;0d06	f1 	. 
	pop bc			;0d07	c1 	. 
	pop de			;0d08	d1 	. 
	pop hl			;0d09	e1 	. 
	ex af,af'		;0d0a	08 	. 
	exx			;0d0b	d9 	. 
	pop af			;0d0c	f1 	. 
	pop bc			;0d0d	c1 	. 
	pop de			;0d0e	d1 	. 
	pop hl			;0d0f	e1 	. 
	ei			;0d10	fb 	. 
	ret			;0d11	c9 	. 
sub_0d12h:
	in a,(0aah)		;0d12	db aa 	. . 
	and 0f0h		;0d14	e6 f0 	. . 
	ld c,a			;0d16	4f 	O 
	ld b,00bh		;0d17	06 0b 	. . 
	ld hl,NEWKEY		;0d19	21 e5 fb 	! . . 
l0d1ch:
	ld a,c			;0d1c	79 	y 
	out (0aah),a		;0d1d	d3 aa 	. . 
	in a,(0a9h)		;0d1f	db a9 	. . 
	ld (hl),a			;0d21	77 	w 
	inc c			;0d22	0c 	. 
	inc hl			;0d23	23 	# 
	djnz l0d1ch		;0d24	10 f6 	. . 
	ld a,(ENSTOP)		;0d26	3a b0 fb 	: . . 
	and a			;0d29	a7 	. 
	jr z,l0d3ah		;0d2a	28 0e 	( . 
	ld a,(0fbebh)		;0d2c	3a eb fb 	: . . 
	cp 0e8h		        ;0d2f	fe e8 	. . 
	jr nz,l0d3ah		;0d31	20 07 	  . 
	ld ix,l409bh		;0d33	dd 21 9b 40 	. ! . @ 
	jp CALBAS_DO		;0d37	c3 bf 02 	. . . 
l0d3ah:
	ld de,NEWKEY		;0d3a	11 e5 fb 	. . . 
	ld b,00bh		;0d3d	06 0b 	. . 
l0d3fh:
	dec de			;0d3f	1b 	. 
	dec hl			;0d40	2b 	+ 
	ld a,(de)			;0d41	1a 	. 
	cp (hl)			;0d42	be 	. 
	jr nz,l0d49h		;0d43	20 04 	  . 
	djnz l0d3fh		;0d45	10 f8 	. . 
	jr sub_0d4eh		;0d47	18 05 	. . 
l0d49h:
    IF INTHZ == 60
        ; Repeat at 20 scans
	ld a,014h		;0d49	3e 14 	> . 
    ELSE
        ; Repeat at 32 scans
	ld a,020h		;0d49	3e 20 	>   
    ENDIF
	ld (REPCNT),a		;0d4b	32 f7 f3 	2 . . 
sub_0d4eh:
	ld b,00bh		;0d4e	06 0b 	. . 
	ld hl,OLDKEY		;0d50	21 da fb 	! . . 
	ld de,NEWKEY		;0d53	11 e5 fb 	. . . 
l0d56h:
	ld a,(de)		;0d56	1a 	. 
	ld c,a			;0d57	4f 	O 
	xor (hl)		;0d58	ae 	. 
	and (hl)		;0d59	a6 	. 
	ld (hl),c		;0d5a	71 	q 
	call nz,sub_0d89h	;0d5b	c4 89 0d 	. . . 
	inc de			;0d5e	13 	. 
	inc hl			;0d5f	23 	# 
	djnz l0d56h		;0d60	10 f4 	. . 
sub_0d62h:
	ld hl,(GETPNT)		;0d62	2a fa f3 	* . . 
	ld a,(PUTPNT)		;0d65	3a f8 f3 	: . . 
	sub l			;0d68	95 	. 
	ret			;0d69	c9 	. 
CHSNS_DO:
	ei			;0d6a	fb 	. 
	push hl			;0d6b	e5 	. 
	push de			;0d6c	d5 	. 
	push bc			;0d6d	c5 	. 
	call sub_0b4eh		;0d6e	cd 4e 0b 	. N . 
	jr nc,l0d82h		;0d71	30 0f 	0 . 
	ld a,(FNKSWI)		;0d73	3a cd fb 	: . . 
	ld hl,0fbebh		;0d76	21 eb fb 	! . . 
	xor (hl)		;0d79	ae 	. 
	ld hl,CNSDFG		;0d7a	21 de f3 	! . . 
	and (hl)		;0d7d	a6 	. 
	rrca			;0d7e	0f 	. 
	call c,DSPFNK_DO	;0d7f	dc 3f 0b 	. ? . 
l0d82h:
	call sub_0d62h		;0d82	cd 62 0d 	. b . 
	pop bc			;0d85	c1 	. 
	pop de			;0d86	d1 	. 
	pop hl			;0d87	e1 	. 
	ret			;0d88	c9 	. 
sub_0d89h:
	push hl			;0d89	e5 	. 
	push de			;0d8a	d5 	. 
	push bc			;0d8b	c5 	. 
	push af			;0d8c	f5 	. 
	ld a,00bh		;0d8d	3e 0b 	> . 
	sub b			;0d8f	90 	. 
	add a,a			;0d90	87 	. 
	add a,a			;0d91	87 	. 
	add a,a			;0d92	87 	. 
	ld c,a			;0d93	4f 	O 
	ld b,008h		;0d94	06 08 	. . 
	pop af			;0d96	f1 	. 
l0d97h:
	rra			;0d97	1f 	. 
	push bc			;0d98	c5 	. 
	push af			;0d99	f5 	. 
        ; KEYBOARD HANDLER (location depends on keymap)
	call c,KEYBHANDLER	;0d9a	dc 21 10 	. ! . 
	pop af			;0d9d	f1 	. 
	pop bc			;0d9e	c1 	. 
	inc c			;0d9f	0c 	. 
	djnz l0d97h		;0da0	10 f5 	. . 
	jp l0938h		;0da2	c3 38 09 	. 8 . 

; BLOCK 'KEYMAP' (start 0x0da5 end 0x0ec5)
KEYMAP_start:
	defb 030h		;0da5	30 	0 
	defb 031h		;0da6	31 	1 
	defb 032h		;0da7	32 	2 
	defb 033h		;0da8	33 	3 
	defb 034h		;0da9	34 	4 
	defb 035h		;0daa	35 	5 
	defb 036h		;0dab	36 	6 
	defb 037h		;0dac	37 	7 
	defb 038h		;0dad	38 	8 
	defb 039h		;0dae	39 	9 
	defb 02dh		;0daf	2d 	- 
	defb 03dh		;0db0	3d 	= 
	defb 05ch		;0db1	5c 	\ 
	defb 05bh		;0db2	5b 	[ 
	defb 05dh		;0db3	5d 	] 
	defb 03bh		;0db4	3b 	; 
	defb 027h		;0db5	27 	' 
	defb 060h		;0db6	60 	` 
	defb 02ch		;0db7	2c 	, 
	defb 02eh		;0db8	2e 	. 
	defb 02fh		;0db9	2f 	/ 
	defb 0ffh		;0dba	ff 	. 
	defb 061h		;0dbb	61 	a 
	defb 062h		;0dbc	62 	b 
	defb 063h		;0dbd	63 	c 
	defb 064h		;0dbe	64 	d 
	defb 065h		;0dbf	65 	e 
	defb 066h		;0dc0	66 	f 
	defb 067h		;0dc1	67 	g 
	defb 068h		;0dc2	68 	h 
	defb 069h		;0dc3	69 	i 
	defb 06ah		;0dc4	6a 	j 
	defb 06bh		;0dc5	6b 	k 
	defb 06ch		;0dc6	6c 	l 
	defb 06dh		;0dc7	6d 	m 
	defb 06eh		;0dc8	6e 	n 
	defb 06fh		;0dc9	6f 	o 
	defb 070h		;0dca	70 	p 
	defb 071h		;0dcb	71 	q 
	defb 072h		;0dcc	72 	r 
	defb 073h		;0dcd	73 	s 
	defb 074h		;0dce	74 	t 
	defb 075h		;0dcf	75 	u 
	defb 076h		;0dd0	76 	v 
	defb 077h		;0dd1	77 	w 
	defb 078h		;0dd2	78 	x 
	defb 079h		;0dd3	79 	y 
	defb 07ah		;0dd4	7a 	z 
	defb 029h		;0dd5	29 	) 
	defb 021h		;0dd6	21 	! 
	defb 040h		;0dd7	40 	@ 
	defb 023h		;0dd8	23 	# 
	defb 024h		;0dd9	24 	$ 
	defb 025h		;0dda	25 	% 
	defb 05eh		;0ddb	5e 	^ 
	defb 026h		;0ddc	26 	& 
	defb 02ah		;0ddd	2a 	* 
	defb 028h		;0dde	28 	( 
	defb 05fh		;0ddf	5f 	_ 
	defb 02bh		;0de0	2b 	+ 
	defb 07ch		;0de1	7c 	| 
	defb 07bh		;0de2	7b 	{ 
	defb 07dh		;0de3	7d 	} 
	defb 03ah		;0de4	3a 	: 
	defb 022h		;0de5	22 	" 
	defb 07eh		;0de6	7e 	~ 
	defb 03ch		;0de7	3c 	< 
	defb 03eh		;0de8	3e 	> 
	defb 03fh		;0de9	3f 	? 
	defb 0ffh		;0dea	ff 	. 
	defb 041h		;0deb	41 	A 
	defb 042h		;0dec	42 	B 
	defb 043h		;0ded	43 	C 
	defb 044h		;0dee	44 	D 
	defb 045h		;0def	45 	E 
	defb 046h		;0df0	46 	F 
	defb 047h		;0df1	47 	G 
	defb 048h		;0df2	48 	H 
	defb 049h		;0df3	49 	I 
	defb 04ah		;0df4	4a 	J 
	defb 04bh		;0df5	4b 	K 
	defb 04ch		;0df6	4c 	L 
	defb 04dh		;0df7	4d 	M 
	defb 04eh		;0df8	4e 	N 
	defb 04fh		;0df9	4f 	O 
	defb 050h		;0dfa	50 	P 
	defb 051h		;0dfb	51 	Q 
	defb 052h		;0dfc	52 	R 
	defb 053h		;0dfd	53 	S 
	defb 054h		;0dfe	54 	T 
	defb 055h		;0dff	55 	U 
	defb 056h		;0e00	56 	V 
	defb 057h		;0e01	57 	W 
	defb 058h		;0e02	58 	X 
	defb 059h		;0e03	59 	Y 
	defb 05ah		;0e04	5a 	Z 
	defb 009h		;0e05	09 	. 
	defb 0ach		;0e06	ac 	. 
	defb 0abh		;0e07	ab 	. 
	defb 0bah		;0e08	ba 	. 
	defb 0efh		;0e09	ef 	. 
	defb 0bdh		;0e0a	bd 	. 
	defb 0f4h		;0e0b	f4 	. 
	defb 0fbh		;0e0c	fb 	. 
	defb 0ech		;0e0d	ec 	. 
	defb 007h		;0e0e	07 	. 
	defb 017h		;0e0f	17 	. 
	defb 0f1h		;0e10	f1 	. 
	defb 01eh		;0e11	1e 	. 
	defb 001h		;0e12	01 	. 
	defb 00dh		;0e13	0d 	. 
	defb 006h		;0e14	06 	. 
	defb 005h		;0e15	05 	. 
	defb 0bbh		;0e16	bb 	. 
	defb 0f3h		;0e17	f3 	. 
	defb 0f2h		;0e18	f2 	. 
	defb 01dh		;0e19	1d 	. 
	defb 0ffh		;0e1a	ff 	. 
	defb 0c4h		;0e1b	c4 	. 
	defb 011h		;0e1c	11 	. 
	defb 0bch		;0e1d	bc 	. 
	defb 0c7h		;0e1e	c7 	. 
	defb 0cdh		;0e1f	cd 	. 
	defb 014h		;0e20	14 	. 
	defb 015h		;0e21	15 	. 
	defb 013h		;0e22	13 	. 
	defb 0dch		;0e23	dc 	. 
	defb 0c6h		;0e24	c6 	. 
	defb 0ddh		;0e25	dd 	. 
	defb 0c8h		;0e26	c8 	. 
	defb 00bh		;0e27	0b 	. 
	defb 01bh		;0e28	1b 	. 
	defb 0c2h		;0e29	c2 	. 
	defb 0dbh		;0e2a	db 	. 
	defb 0cch		;0e2b	cc 	. 
	defb 018h		;0e2c	18 	. 
	defb 0d2h		;0e2d	d2 	. 
	defb 012h		;0e2e	12 	. 
	defb 0c0h		;0e2f	c0 	. 
	defb 01ah		;0e30	1a 	. 
	defb 0cfh		;0e31	cf 	. 
	defb 01ch		;0e32	1c 	. 
	defb 019h		;0e33	19 	. 
	defb 00fh		;0e34	0f 	. 
	defb 00ah		;0e35	0a 	. 
	defb 000h		;0e36	00 	. 
	defb 0fdh		;0e37	fd 	. 
	defb 0fch		;0e38	fc 	. 
	defb 000h		;0e39	00 	. 
l0e3ah:
	defb 000h		;0e3a	00 	. 
	defb 0f5h		;0e3b	f5 	. 
	defb 000h		;0e3c	00 	. 
	defb 000h		;0e3d	00 	. 
	defb 008h		;0e3e	08 	. 
	defb 01fh		;0e3f	1f 	. 
	defb 0f0h		;0e40	f0 	. 
	defb 016h		;0e41	16 	. 
	defb 002h		;0e42	02 	. 
	defb 00eh		;0e43	0e 	. 
	defb 004h		;0e44	04 	. 
	defb 003h		;0e45	03 	. 
	defb 0f7h		;0e46	f7 	. 
	defb 0aeh		;0e47	ae 	. 
	defb 0afh		;0e48	af 	. 
	defb 0f6h		;0e49	f6 	. 
	defb 0ffh		;0e4a	ff 	. 
	defb 0feh		;0e4b	fe 	. 
	defb 000h		;0e4c	00 	. 
	defb 0fah		;0e4d	fa 	. 
	defb 0c1h		;0e4e	c1 	. 
	defb 0ceh		;0e4f	ce 	. 
	defb 0d4h		;0e50	d4 	. 
	defb 010h		;0e51	10 	. 
	defb 0d6h		;0e52	d6 	. 
	defb 0dfh		;0e53	df 	. 
	defb 0cah		;0e54	ca 	. 
	defb 0deh		;0e55	de 	. 
	defb 0c9h		;0e56	c9 	. 
	defb 00ch		;0e57	0c 	. 
	defb 0d3h		;0e58	d3 	. 
	defb 0c3h		;0e59	c3 	. 
	defb 0d7h		;0e5a	d7 	. 
	defb 0cbh		;0e5b	cb 	. 
	defb 0a9h		;0e5c	a9 	. 
	defb 0d1h		;0e5d	d1 	. 
	defb 000h		;0e5e	00 	. 
	defb 0c5h		;0e5f	c5 	. 
	defb 0d5h		;0e60	d5 	. 
	defb 0d0h		;0e61	d0 	. 
	defb 0f9h		;0e62	f9 	. 
	defb 0aah		;0e63	aa 	. 
	defb 0f8h		;0e64	f8 	. 
	defb 0ebh		;0e65	eb 	. 
	defb 09fh		;0e66	9f 	. 
	defb 0d9h		;0e67	d9 	. 
	defb 0bfh		;0e68	bf 	. 
	defb 09bh		;0e69	9b 	. 
	defb 098h		;0e6a	98 	. 
	defb 0e0h		;0e6b	e0 	. 
	defb 0e1h		;0e6c	e1 	. 
	defb 0e7h		;0e6d	e7 	. 
	defb 087h		;0e6e	87 	. 
	defb 0eeh		;0e6f	ee 	. 
	defb 0e9h		;0e70	e9 	. 
	defb 000h		;0e71	00 	. 
	defb 0edh		;0e72	ed 	. 
	defb 0dah		;0e73	da 	. 
	defb 0b7h		;0e74	b7 	. 
	defb 0b9h		;0e75	b9 	. 
	defb 0e5h		;0e76	e5 	. 
	defb 086h		;0e77	86 	. 
	defb 0a6h		;0e78	a6 	. 
	defb 0a7h		;0e79	a7 	. 
	defb 0ffh		;0e7a	ff 	. 
	defb 084h		;0e7b	84 	. 
	defb 097h		;0e7c	97 	. 
	defb 08dh		;0e7d	8d 	. 
	defb 08bh		;0e7e	8b 	. 
	defb 08ch		;0e7f	8c 	. 
	defb 094h		;0e80	94 	. 
	defb 081h		;0e81	81 	. 
	defb 0b1h		;0e82	b1 	. 
	defb 0a1h		;0e83	a1 	. 
	defb 091h		;0e84	91 	. 
	defb 0b3h		;0e85	b3 	. 
	defb 0b5h		;0e86	b5 	. 
	defb 0e6h		;0e87	e6 	. 
	defb 0a4h		;0e88	a4 	. 
	defb 0a2h		;0e89	a2 	. 
	defb 0a3h		;0e8a	a3 	. 
	defb 083h		;0e8b	83 	. 
	defb 093h		;0e8c	93 	. 
	defb 089h		;0e8d	89 	. 
	defb 096h		;0e8e	96 	. 
	defb 082h		;0e8f	82 	. 
	defb 095h		;0e90	95 	. 
	defb 088h		;0e91	88 	. 
	defb 08ah		;0e92	8a 	. 
	defb 0a0h		;0e93	a0 	. 
	defb 085h		;0e94	85 	. 
	defb 0d8h		;0e95	d8 	. 
	defb 0adh		;0e96	ad 	. 
	defb 09eh		;0e97	9e 	. 
	defb 0beh		;0e98	be 	. 
	defb 09ch		;0e99	9c 	. 
	defb 09dh		;0e9a	9d 	. 
	defb 000h		;0e9b	00 	. 
	defb 000h		;0e9c	00 	. 
	defb 0e2h		;0e9d	e2 	. 
	defb 080h		;0e9e	80 	. 
	defb 000h		;0e9f	00 	. 
	defb 000h		;0ea0	00 	. 
	defb 000h		;0ea1	00 	. 
	defb 0e8h		;0ea2	e8 	. 
	defb 0eah		;0ea3	ea 	. 
	defb 0b6h		;0ea4	b6 	. 
	defb 0b8h		;0ea5	b8 	. 
	defb 0e4h		;0ea6	e4 	. 
	defb 08fh		;0ea7	8f 	. 
	defb 000h		;0ea8	00 	. 
	defb 0a8h		;0ea9	a8 	. 
	defb 0ffh		;0eaa	ff 	. 
	defb 08eh		;0eab	8e 	. 
	defb 000h		;0eac	00 	. 
	defb 000h		;0ead	00 	. 
	defb 000h		;0eae	00 	. 
	defb 000h		;0eaf	00 	. 
	defb 099h		;0eb0	99 	. 
	defb 09ah		;0eb1	9a 	. 
	defb 0b0h		;0eb2	b0 	. 
	defb 000h		;0eb3	00 	. 
	defb 092h		;0eb4	92 	. 
	defb 0b2h		;0eb5	b2 	. 
	defb 0b4h		;0eb6	b4 	. 
	defb 000h		;0eb7	00 	. 
	defb 0a5h		;0eb8	a5 	. 
	defb 000h		;0eb9	00 	. 
	defb 0e3h		;0eba	e3 	. 
	defb 000h		;0ebb	00 	. 
	defb 000h		;0ebc	00 	. 
	defb 000h		;0ebd	00 	. 
	defb 000h		;0ebe	00 	. 
	defb 090h		;0ebf	90 	. 
	defb 000h		;0ec0	00 	. 
	defb 000h		;0ec1	00 	. 
	defb 000h		;0ec2	00 	. 
	defb 000h		;0ec3	00 	. 
	defb 000h		;0ec4	00 	. 
FKEYHANDLER:
	ld e,c			;0ec5	59 	Y 
	ld d,000h		;0ec6	16 00 	. . 
	ld hl,0fb99h		;0ec8	21 99 fb 	! . . 
	add hl,de		;0ecb	19 	. 
	ld a,(hl)		;0ecc	7e 	~ 
	and a			;0ecd	a7 	. 
	jr nz,l0ee3h		;0ece	20 13 	  . 
l0ed0h:
	ex de,hl		;0ed0	eb 	. 
	add hl,hl		;0ed1	29 	) 
	add hl,hl		;0ed2	29 	) 
	add hl,hl		;0ed3	29 	) 
	add hl,hl		;0ed4	29 	) 
	ld de,0f52fh		;0ed5	11 2f f5 	. / . 
	add hl,de		;0ed8	19 	. 
	ex de,hl		;0ed9	eb 	. 
l0edah:
	ld a,(de)		;0eda	1a 	. 
	and a			;0edb	a7 	. 
	ret z			;0edc	c8 	. 
	call sub_0f55h		;0edd	cd 55 0f 	. U . 
	inc de			;0ee0	13 	. 
	jr l0edah		;0ee1	18 f7 	. . 
l0ee3h:
	ld hl,(CURLIN)		;0ee3	2a 1c f4 	* . . 
	inc hl			;0ee6	23 	# 
	ld a,h			;0ee7	7c 	| 
	or l			;0ee8	b5 	. 
	jr z,l0ed0h		;0ee9	28 e5 	( . 
	ld hl,0fbadh		;0eeb	21 ad fb 	! . . 
	add hl,de		;0eee	19 	. 
	add hl,de		;0eef	19 	. 
	add hl,de		;0ef0	19 	. 
sub_0ef1h:
	ld a,(hl)		;0ef1	7e 	~ 
	and 001h		;0ef2	e6 01 	. . 
	ret z			;0ef4	c8 	. 
	ld a,(hl)		;0ef5	7e 	~ 
	or 004h		        ;0ef6	f6 04 	. . 
	cp (hl)			;0ef8	be 	. 
	ret z			;0ef9	c8 	. 
	ld (hl),a		;0efa	77 	w 
	xor 005h		;0efb	ee 05 	. . 
	ret nz			;0efd	c0 	. 
	ld a,(ONGSBF)		;0efe	3a d8 fb 	: . . 
	inc a			;0f01	3c 	< 
	ld (ONGSBF),a		;0f02	32 d8 fb 	2 . . 
	ret			;0f05	c9 	. 
	ld a,(0fbebh)		;0f06	3a eb fb 	: . . 
	rrca			;0f09	0f 	. 
	ld a,00ch		;0f0a	3e 0c 	> . 
	sbc a,000h		;0f0c	de 00 	. . 
	jr sub_0f55h		;0f0e	18 45 	. E 
	call H.KEYA		;0f10	cd d1 fd 	. . . 
	ld e,a			;0f13	5f 	_ 
	ld d,000h		;0f14	16 00 	. . 
	ld hl,l1003h		;0f16	21 03 10 	! . . 
	add hl,de	    	;0f19	19 	. 
	ld a,(hl)   		;0f1a	7e 	~ 
	and a			;0f1b	a7 	. 
	ret z			;0f1c	c8 	. 
	jr sub_0f55h		;0f1d	18 36 	. 6 
l0f1fh:
	ld a,(0fbebh)		;0f1f	3a eb fb 	: . . 
	ld e,a			;0f22	5f 	_ 
	or 0feh	                ;0f23	f6 fe 	. . 
	bit 4,e		        ;0f25	cb 63 	. c 
	jr nz,l0f2bh		;0f27	20 02 	  . 
l0f29h:
	and 0fdh		;0f29	e6 fd 	. . 
l0f2bh:
	cpl			;0f2b	2f 	/ 
	inc a			;0f2c	3c 	< 
	ld (KANAST),a		;0f2d	32 ac fc 	2 . . 
	jr l0f64h		;0f30	18 32 	. 2 
	inc c			;0f32	0c 	. 
	jp l0c25h		;0f33	c3 25 0c 	. % . 
	ld hl,CAPST		;0f36	21 ab fc 	! . . 
	ld a,(hl)		;0f39	7e 	~ 
	cpl			;0f3a	2f 	/ 
	ld (hl),a		;0f3b	77 	w 
	cpl			;0f3c	2f 	/ 
CHGCAP_DO:
	and a			;0f3d	a7 	. 
	ld a,00ch		;0f3e	3e 0c 	> . 
	jr z,l0f43h		;0f40	28 01 	( . 
	inc a			;0f42	3c 	< 
l0f43h:
	out (0abh),a		;0f43	d3 ab 	. . 
	ret			;0f45	c9 	. 
	ld a,(0fbebh)		;0f46	3a eb fb 	: . . 
	rrca			;0f49	0f 	. 
	rrca			;0f4a	0f 	. 
	ld a,003h		;0f4b	3e 03 	> . 
	jr nc,l0f50h		;0f4d	30 01 	0 . 
	inc a			;0f4f	3c 	< 
l0f50h:
	ld (INTFLG),a		;0f50	32 9b fc 	2 . . 
	jr c,l0f64h		;0f53	38 0f 	8 . 
sub_0f55h:
	ld hl,(PUTPNT)		;0f55	2a f8 f3 	* . . 
	ld (hl),a		;0f58	77 	w 
	call NEXTKBDSTATE	;0f59	cd 5b 10 	. [ . 
	ld a,(GETPNT)		;0f5c	3a fa f3 	: . . 
	cp l			;0f5f	bd 	. 
	ret z			;0f60	c8 	. 
	ld (PUTPNT),hl		;0f61	22 f8 f3 	" . . 
l0f64h:
	ld a,(CLIKSW)		;0f64	3a db f3 	: . . 
	and a			;0f67	a7 	. 
	ret z			;0f68	c8 	. 
	ld a,(CLIKFL)		;0f69	3a d9 fb 	: . . 
	and a			;0f6c	a7 	. 
	ret nz			;0f6d	c0 	. 
	ld a,00fh		;0f6e	3e 0f 	> . 
	ld (CLIKFL),a		;0f70	32 d9 fb 	2 . . 
	out (0abh),a		;0f73	d3 ab 	. . 
	ld a,00ah		;0f75	3e 0a 	> . 
l0f77h:
	dec a			;0f77	3d 	= 
	jr nz,l0f77h		;0f78	20 fd 	  . 
CHGSND_DO:
	and a			;0f7a	a7 	. 
	ld a,00eh		;0f7b	3e 0e 	> . 
	jr z,l0f80h		;0f7d	28 01 	( . 
	inc a			;0f7f	3c 	< 
l0f80h:
	out (0abh),a		;0f80	d3 ab 	. . 
	ret			;0f82	c9 	. 
	ld a,(0fbebh)		;0f83	3a eb fb 	: . . 
	ld e,a			;0f86	5f 	_ 
	rra			;0f87	1f 	. 
	rra			;0f88	1f 	. 
	push af			;0f89	f5 	. 
	ld a,e			;0f8a	7b 	{ 
	cpl			;0f8b	2f 	/ 
	jr nc,$+18		;0f8c	30 10 	0 . 
	rra			;0f8e	1f 	. 
	rra			;0f8f	1f 	. 
	rlca			;0f90	07 	. 
	and 003h		;0f91	e6 03 	. . 
	bit 1,a		        ;0f93	cb 4f 	. O 
	jr nz,l0fa0h		;0f95	20 09 	  . 
	bit 4,e		        ;0f97	cb 63 	. c 
	jr nz,l0fa0h		;0f99	20 05 	  . 
	or 004h	            	;0f9b	f6 04 	. . 
	ld de,001e6h		;0f9d	11 e6 01 	. . . 
l0fa0h:
	ld e,a			;0fa0	5f 	_ 
	add a,a			;0fa1	87 	. 
	add a,e			;0fa2	83 	. 
	add a,a			;0fa3	87 	. 
	add a,a			;0fa4	87 	. 
	add a,a			;0fa5	87 	. 
	add a,a			;0fa6	87 	. 
	ld e,a			;0fa7	5f 	_ 
	ld d,000h		;0fa8	16 00 	. . 
	ld hl,KEYMAP_start	;0faa	21 a5 0d 	! . . 
	add hl,de		;0fad	19 	. 
	ld b,d			;0fae	42 	B 
	add hl,bc		;0faf	09 	. 
	pop af			;0fb0	f1 	. 
	ld a,(hl)		;0fb1	7e 	~ 
	inc a			;0fb2	3c 	< 
	jp z,l0f1fh		;0fb3	ca 1f 0f 	. . . 
	dec a			;0fb6	3d 	= 
	ret z			;0fb7	c8 	. 
	jr c,l0fd0h		;0fb8	38 16 	8 . 
	and 0dfh		;0fba	e6 df 	. . 
	sub 040h		;0fbc	d6 40 	. @ 
	cp 020h		        ;0fbe	fe 20 	.   
	ret nc			;0fc0	d0 	. 
l0fc1h:
	jr sub_0f55h		;0fc1	18 92 	. . 
	ld a,(0fbebh)		;0fc3	3a eb fb 	: . . 
	rrca			;0fc6	0f 	. 
	jr c,l0fcdh		;0fc7	38 04 	8 . 
	ld a,c			;0fc9	79 	y 
	add a,005h		;0fca	c6 05 	. . 
	ld c,a			;0fcc	4f 	O 
l0fcdh:
	jp FKEYHANDLER		;0fcd	c3 c5 0e 	. . . 
l0fd0h:
	cp 020h		        ;0fd0	fe 20 	.   
	jr nc,l0fdfh		;0fd2	30 0b 	0 . 
	push af			;0fd4	f5 	. 
	ld a,001h		;0fd5	3e 01 	> . 
	call sub_0f55h		;0fd7	cd 55 0f 	. U . 
	pop af			;0fda	f1 	. 
	add a,040h		;0fdb	c6 40 	. @ 
	jr l0fc1h		;0fdd	18 e2 	. . 
l0fdfh:
	ld hl,CAPST		;0fdf	21 ab fc 	! . . 
	inc (hl)	    	;0fe2	34 	4 
	dec (hl)	    	;0fe3	35 	5 
	jr z,l0ff0h		;0fe4	28 0a 	( . 
	cp 061h		        ;0fe6	fe 61 	. a 
	jr c,l1011h		;0fe8	38 27 	8 ' 
	cp 07bh		        ;0fea	fe 7b 	. { 
	jr nc,l1011h		;0fec	30 23 	0 # 
	and 0dfh		;0fee	e6 df 	. . 
l0ff0h:
	ld de,(KANAST)		;0ff0	ed 5b ac fc 	. [ . . 
	inc e			;0ff4	1c 	. 
	dec e			;0ff5	1d 	. 
	jr z,l0fc1h		;0ff6	28 c9 	( . 
	ld d,a			;0ff8	57 	W 
	or 020h		        ;0ff9	f6 20 	.   
	ld hl,l1066h		;0ffb	21 66 10 	! f . 
	ld c,006h		;0ffe	0e 06 	. . 
	cpdr		        ;1000	ed b9 	. . 
	ld a,d			;1002	7a 	z 
l1003h:
	jr nz,l0fc1h		;1003	20 bc 	  . 
	inc hl			;1005	23 	# 
	ld c,006h		;1006	0e 06 	. . 
l1008h:
	add hl,bc		;1008	09 	. 
	dec e			;1009	1d 	. 
	jr nz,l1008h		;100a	20 fc 	  . 
	ld a,(hl)		;100c	7e 	~ 
	bit 5,d		        ;100d	cb 6a 	. j 
	jr nz,l0fc1h		;100f	20 b0 	  . 
l1011h:
	ld c,01fh		;1011	0e 1f 	. . 
	ld hl,l109dh		;1013	21 9d 10 	! . . 
	cpdr		        ;1016	ed b9 	. . 
	jr nz,l0fc1h		;1018	20 a7 	  . 
	ld c,01fh		;101a	0e 1f 	. . 
	inc hl			;101c	23 	# 
	add hl,bc		;101d	09 	. 
	ld a,(hl)		;101e	7e 	~ 
	jr l0fc1h		;101f	18 a0 	. . 
KEYBHANDLER:
	ld a,c			;1021	79 	y 
	ld hl,SCANCODES		;1022	21 96 1b 	! . . 
	call H.KEYC		;1025	cd cc fd 	. . . 
	ld d,00fh		;1028	16 0f 	. . 
l102ah:
	cp (hl)			;102a	be 	. 
	inc hl			;102b	23 	# 
	ld e,(hl)		;102c	5e 	^ 
	inc hl			;102d	23 	# 
	push de			;102e	d5 	. 
	ret c			;102f	d8 	. 
	pop de			;1030	d1 	. 
	jr l102ah		;1031	18 f7 	. . 

; BLOCK 'KEYCODES' (start 0x1033 end 0x105b)
KEYCODES_start:
	defb 000h		;1033	00 	. 
	defb 000h		;1034	00 	. 
	defb 000h		;1035	00 	. 
	defb 000h		;1036	00 	. 
	defb 000h		;1037	00 	. 
	defb 000h		;1038	00 	. 
	defb 000h		;1039	00 	. 
	defb 000h		;103a	00 	. 
	defb 000h		;103b	00 	. 
	defb 000h		;103c	00 	. 
	defb 01bh		;103d	1b 	. 
	defb 009h		;103e	09 	. 
	defb 000h		;103f	00 	. 
	defb 008h		;1040	08 	. 
l1041h:
	defb 018h		;1041	18 	. 
	defb 00dh		;1042	0d 	. 
	defb 020h		;1043	20 	  
	defb 00ch		;1044	0c 	. 
	defb 012h		;1045	12 	. 
	defb 07fh		;1046	7f 	 
	defb 01dh		;1047	1d 	. 
	defb 01eh		;1048	1e 	. 
	defb 01fh		;1049	1f 	. 
	defb 01ch		;104a	1c 	. 
	defb 02ah		;104b	2a 	* 
	defb 02bh		;104c	2b 	+ 
	defb 02fh		;104d	2f 	/ 
	defb 030h		;104e	30 	0 
	defb 031h		;104f	31 	1 
	defb 032h		;1050	32 	2 
	defb 033h		;1051	33 	3 
	defb 034h		;1052	34 	4 
	defb 035h		;1053	35 	5 
	defb 036h		;1054	36 	6 
	defb 037h		;1055	37 	7 
	defb 038h		;1056	38 	8 
	defb 039h		;1057	39 	9 
	defb 02dh		;1058	2d 	- 
	defb 02ch		;1059	2c 	, 
	defb 02eh		;105a	2e 	. 
NEXTKBDSTATE:
	xor a			;105b	af 	. 
	ld (KANAST),a		;105c	32 ac fc 	2 . . 
	jr INCKBDBUFPTR		;105f	18 61 	. a 

; BLOCK 'ACCENTS' (start 0x1061 end 0x10c2)
ACCENTS_start:
	defb 061h		;1061	61 	a 
	defb 065h		;1062	65 	e 
	defb 069h		;1063	69 	i 
	defb 06fh		;1064	6f 	o 
	defb 075h		;1065	75 	u 
l1066h:
	defb 079h		;1066	79 	y 
	defb 085h		;1067	85 	. 
	defb 08ah		;1068	8a 	. 
	defb 08dh		;1069	8d 	. 
	defb 095h		;106a	95 	. 
	defb 097h		;106b	97 	. 
	defb 079h		;106c	79 	y 
	defb 0a0h		;106d	a0 	. 
	defb 082h		;106e	82 	. 
	defb 0a1h		;106f	a1 	. 
	defb 0a2h		;1070	a2 	. 
	defb 0a3h		;1071	a3 	. 
	defb 079h		;1072	79 	y 
	defb 083h		;1073	83 	. 
	defb 088h		;1074	88 	. 
	defb 08ch		;1075	8c 	. 
	defb 093h		;1076	93 	. 
	defb 096h		;1077	96 	. 
	defb 079h		;1078	79 	y 
	defb 084h		;1079	84 	. 
	defb 089h		;107a	89 	. 
	defb 08bh		;107b	8b 	. 
	defb 094h		;107c	94 	. 
	defb 081h		;107d	81 	. 
	defb 098h		;107e	98 	. 
	defb 083h		;107f	83 	. 
	defb 088h		;1080	88 	. 
	defb 08ch		;1081	8c 	. 
	defb 093h		;1082	93 	. 
	defb 096h		;1083	96 	. 
	defb 084h		;1084	84 	. 
	defb 089h		;1085	89 	. 
	defb 08bh		;1086	8b 	. 
	defb 094h		;1087	94 	. 
	defb 081h		;1088	81 	. 
	defb 098h		;1089	98 	. 
	defb 0a0h		;108a	a0 	. 
	defb 082h		;108b	82 	. 
	defb 0a1h		;108c	a1 	. 
	defb 0a2h		;108d	a2 	. 
	defb 0a3h		;108e	a3 	. 
	defb 085h		;108f	85 	. 
	defb 08ah		;1090	8a 	. 
	defb 08dh		;1091	8d 	. 
	defb 095h		;1092	95 	. 
	defb 097h		;1093	97 	. 
	defb 0b1h		;1094	b1 	. 
	defb 0b3h		;1095	b3 	. 
	defb 0b5h		;1096	b5 	. 
	defb 0b7h		;1097	b7 	. 
	defb 0a4h		;1098	a4 	. 
	defb 086h		;1099	86 	. 
	defb 087h		;109a	87 	. 
	defb 091h		;109b	91 	. 
	defb 0b9h		;109c	b9 	. 
l109dh:
	defb 079h		;109d	79 	y 
	defb 041h		;109e	41 	A 
	defb 045h		;109f	45 	E 
	defb 049h		;10a0	49 	I 
	defb 04fh		;10a1	4f 	O 
	defb 055h		;10a2	55 	U 
	defb 08eh		;10a3	8e 	. 
	defb 045h		;10a4	45 	E 
	defb 049h		;10a5	49 	I 
	defb 099h		;10a6	99 	. 
	defb 09ah		;10a7	9a 	. 
	defb 059h		;10a8	59 	Y 
	defb 041h		;10a9	41 	A 
	defb 090h		;10aa	90 	. 
	defb 049h		;10ab	49 	I 
	defb 04fh		;10ac	4f 	O 
	defb 055h		;10ad	55 	U 
	defb 041h		;10ae	41 	A 
	defb 045h		;10af	45 	E 
	defb 049h		;10b0	49 	I 
	defb 04fh		;10b1	4f 	O 
	defb 055h		;10b2	55 	U 
	defb 0b0h		;10b3	b0 	. 
	defb 0b2h		;10b4	b2 	. 
	defb 0b4h		;10b5	b4 	. 
	defb 0b6h		;10b6	b6 	. 
	defb 0a5h		;10b7	a5 	. 
	defb 08fh		;10b8	8f 	. 
	defb 080h		;10b9	80 	. 
	defb 092h		;10ba	92 	. 
	defb 0b8h		;10bb	b8 	. 
	defb 059h		;10bc	59 	Y 
	defb 051h		;10bd	51 	Q 
	defb 000h		;10be	00 	. 
	defb 05ch		;10bf	5c 	\ 
	defb 048h		;10c0	48 	H 
l10c1h:
	defb 000h		;10c1	00 	. 
INCKBDBUFPTR:
	inc hl			;10c2	23 	# 
	ld a,l			;10c3	7d 	} 
	cp 018h		        ;10c4	fe 18 	. . 
	ret nz			;10c6	c0 	. 
	ld hl,KEYBUF		;10c7	21 f0 fb 	! . . 
	ret			;10ca	c9 	. 
CHGET_DO:
	push hl			;10cb	e5 	. 
	push de			;10cc	d5 	. 
	push bc			;10cd	c5 	. 
	call H.CHGE		;10ce	cd c2 fd 	. . . 
	call CHSNS_DO		;10d1	cd 6a 0d 	. j . 
	jr nz,l10e1h		;10d4	20 0b 	  . 
	call sub_0a37h		;10d6	cd 37 0a 	. 7 . 
l10d9h:
	call CHSNS_DO		;10d9	cd 6a 0d 	. j . 
	jr z,l10d9h		;10dc	28 fb 	( . 
	call sub_0a84h		;10de	cd 84 0a 	. . . 
l10e1h:
	ld hl,INTFLG		;10e1	21 9b fc 	! . . 
	ld a,(hl)		;10e4	7e 	~ 
	cp 004h		        ;10e5	fe 04 	. . 
	jr nz,l10ebh		;10e7	20 02 	  . 
	ld (hl),000h		;10e9	36 00 	6 . 
l10ebh:
	ld hl,(GETPNT)		;10eb	2a fa f3 	* . . 
	ld c,(hl)		;10ee	4e 	N 
	call INCKBDBUFPTR	;10ef	cd c2 10 	. . . 
	ld (GETPNT),hl		;10f2	22 fa f3 	" . . 
	ld a,c			;10f5	79 	y 
	jp l0938h		;10f6	c3 38 09 	. 8 . 
CKCNTC_DO:
	push hl			;10f9	e5 	. 
	ld hl,0000h		;10fa	21 00 00 	! . . 
	call ISCNTC_DO		;10fd	cd f0 04 	. . . 
l1100h:
	pop hl			;1100	e1 	. 
l1101h:
	ret			;1101	c9 	. 
WRTPSG_DO:
	di			;1102	f3 	. 
	out (0a0h),a		;1103	d3 a0 	. . 
	push af			;1105	f5 	. 
	ld a,e			;1106	7b 	{ 
	ei			;1107	fb 	. 
	out (0a1h),a		;1108	d3 a1 	. . 
	pop af			;110a	f1 	. 
	ret			;110b	c9 	. 
sub_110ch:
	ld a,00eh		;110c	3e 0e 	> . 
RDPSG_DO:
	out (0a0h),a		;110e	d3 a0 	. . 
	in a,(0a2h)		;1110	db a2 	. . 
	ret			;1112	c9 	. 
BEEP_DO:
	push ix		        ;1113	dd e5 	. . 
	ld ix,S.BEEP		;1115	dd 21 7d 01 	. ! } . 
	jp SUBROM_DO		;1119	c3 95 02 	. . . 
	push af			;111c	f5 	. 
	ld a,00fh		;111d	3e 0f 	> . 
	out (0a0h),a		;111f	d3 a0 	. . 
	in a,(0a2h)		;1121	db a2 	. . 
	and 07fh		;1123	e6 7f 	.  
	ld b,a			;1125	47 	G 
	pop af			;1126	f1 	. 
	or a			;1127	b7 	. 
	ld a,080h		;1128	3e 80 	> . 
	jr z,l112dh		;112a	28 01 	( . 
	xor a			;112c	af 	. 
l112dh:
	or b			;112d	b0 	. 
	out (0a1h),a		;112e	d3 a1 	. . 
	ret			;1130	c9 	. 
sub_1131h:
	ld b,a			;1131	47 	G 
	call GETVCP_DO		;1132	cd 0a 0c 	. . . 
	dec hl			;1135	2b 	+ 
	ld d,(hl)		;1136	56 	V 
	dec hl			;1137	2b 	+ 
	ld e,(hl)	    	;1138	5e 	^ 
	dec de			;1139	1b 	. 
	ld (hl),e	    	;113a	73 	s 
	inc hl			;113b	23 	# 
	ld (hl),d	    	;113c	72 	r 
	ld a,d			;113d	7a 	z 
	or e			;113e	b3 	. 
	ret nz			;113f	c0 	. 
	ld a,b			;1140	78 	x 
	ld (QUEUEN),a		;1141	32 3e fb 	2 > . 
	call sub_11d8h		;1144	cd d8 11 	. . . 
	cp 0ffh		        ;1147	fe ff 	. . 
	jr z,l11a6h		;1149	28 5b 	( [ 
	ld d,a			;114b	57 	W 
	and 0e0h		;114c	e6 e0 	. . 
	rlca			;114e	07 	. 
	rlca			;114f	07 	. 
	rlca			;1150	07 	. 
	ld c,a			;1151	4f 	O 
	ld a,d			;1152	7a 	z 
	and 01fh		;1153	e6 1f 	. . 
	ld (hl),a	    	;1155	77 	w 
	call sub_11d8h		;1156	cd d8 11 	. . . 
	dec hl			;1159	2b 	+ 
	ld (hl),a	    	;115a	77 	w 
	inc c			;115b	0c 	. 
l115ch:
	dec c			;115c	0d 	. 
	ret z			;115d	c8 	. 
	call sub_11d8h		;115e	cd d8 11 	. . . 
	ld d,a			;1161	57 	W 
	and 0c0h		;1162	e6 c0 	. . 
	jr nz,l1177h		;1164	20 11 	  . 
	call sub_11d8h		;1166	cd d8 11 	. . . 
	ld e,a			;1169	5f 	_ 
	ld a,b			;116a	78 	x 
	rlca			;116b	07 	. 
	call WRTPSG_DO		;116c	cd 02 11 	. . . 
	inc a			;116f	3c 	< 
	ld e,d			;1170	5a 	Z 
	call WRTPSG_DO		;1171	cd 02 11 	. . . 
	dec c			;1174	0d 	. 
	jr l115ch		;1175	18 e5 	. . 
l1177h:
	ld h,a			;1177	67 	g 
	and 080h		;1178	e6 80 	. . 
	jr z,l118bh		;117a	28 0f 	( . 
	ld e,d			;117c	5a 	Z 
	ld a,b			;117d	78 	x 
	add a,008h		;117e	c6 08 	. . 
	call WRTPSG_DO		;1180	cd 02 11 	. . . 
	ld a,e			;1183	7b 	{ 
	and 010h		;1184	e6 10 	. . 
	ld a,00dh		;1186	3e 0d 	> . 
	call nz,WRTPSG_DO	;1188	c4 02 11 	. . . 
l118bh:
	ld a,h			;118b	7c 	| 
	and 040h		;118c	e6 40 	. @ 
	jr z,l115ch		;118e	28 cc 	( . 
	call sub_11d8h		;1190	cd d8 11 	. . . 
	ld d,a			;1193	57 	W 
	call sub_11d8h		;1194	cd d8 11 	. . . 
	ld e,a			;1197	5f 	_ 
	ld a,00bh		;1198	3e 0b 	> . 
	call WRTPSG_DO		;119a	cd 02 11 	. . . 
	inc a			;119d	3c 	< 
	ld e,d			;119e	5a 	Z 
	call WRTPSG_DO		;119f	cd 02 11 	. . . 
	dec c			;11a2	0d 	. 
	dec c			;11a3	0d 	. 
	jr l115ch		;11a4	18 b6 	. . 
l11a6h:
	ld a,b			;11a6	78 	x 
	add a,008h		;11a7	c6 08 	. . 
	ld e,000h		;11a9	1e 00 	. . 
	call WRTPSG_DO		;11ab	cd 02 11 	. . . 
	inc b			;11ae	04 	. 
	ld hl,MUSICF		;11af	21 3f fb 	! ? . 
	xor a			;11b2	af 	. 
	scf			;11b3	37 	7 
l11b4h:
	rla			;11b4	17 	. 
	djnz l11b4h		;11b5	10 fd 	. . 
	and (hl)		;11b7	a6 	. 
	xor (hl)		;11b8	ae 	. 
	ld (hl),a		;11b9	77 	w 
STRTMS_DO:
	ld a,(MUSICF)		;11ba	3a 3f fb 	: ? . 
	or a			;11bd	b7 	. 
	ret nz			;11be	c0 	. 
	ld hl,PLYCNT		;11bf	21 40 fb 	! @ . 
	ld a,(hl)	    	;11c2	7e 	~ 
	or a			;11c3	b7 	. 
	ret z			;11c4	c8 	. 
	dec (hl)	    	;11c5	35 	5 
	ld hl,0001h		;11c6	21 01 00 	! . . 
	ld (VCBA),hl		;11c9	22 41 fb 	" A . 
	ld (VCBB),hl		;11cc	22 66 fb 	" f . 
	ld (VCBC),hl		;11cf	22 8b fb 	" . . 
	ld a,007h		;11d2	3e 07 	> . 
	ld (MUSICF),a		;11d4	32 3f fb 	2 ? . 
	ret			;11d7	c9 	. 
sub_11d8h:
	ld a,(QUEUEN)		;11d8	3a 3e fb 	: > . 
	push hl			;11db	e5 	. 
	push de			;11dc	d5 	. 
	push bc			;11dd	c5 	. 
	call sub_14abh		;11de	cd ab 14 	. . . 
	jp l0938h		;11e1	c3 38 09 	. 8 . 
GTSTCK_DO:
	dec a			;11e4	3d 	= 
	jp m,l11f6h		;11e5	fa f6 11 	. . . 
	call sub_1202h		;11e8	cd 02 12 	. . . 
	ld hl,KBDROW8		;11eb	21 29 12 	! ) . 
l11eeh:
	and 00fh		;11ee	e6 0f 	. . 
	ld e,a			;11f0	5f 	_ 
	ld d,000h		;11f1	16 00 	. . 
	add hl,de	    	;11f3	19 	. 
	ld a,(hl)	    	;11f4	7e 	~ 
	ret			;11f5	c9 	. 
l11f6h:
	call sub_121ch		;11f6	cd 1c 12 	. . . 
	rrca			;11f9	0f 	. 
	rrca			;11fa	0f 	. 
	rrca			;11fb	0f 	. 
	rrca			;11fc	0f 	. 
	ld hl,KBDROW8B		;11fd	21 39 12 	! 9 . 
	jr l11eeh		;1200	18 ec 	. . 
sub_1202h:
	ld b,a			;1202	47 	G 
	ld a,00fh		;1203	3e 0f 	> . 
	di			;1205	f3 	. 
	call RDPSG_DO		;1206	cd 0e 11 	. . . 
	djnz l1211h		;1209	10 06 	. . 
	and 0dfh		;120b	e6 df 	. . 
	or 04ch		        ;120d	f6 4c 	. L 
	jr l1215h		;120f	18 04 	. . 
l1211h:
	and 0afh		;1211	e6 af 	. . 
	or 003h		        ;1213	f6 03 	. . 
l1215h:
	out (0a1h),a		;1215	d3 a1 	. . 
	call sub_110ch		;1217	cd 0c 11 	. . . 
	ei			;121a	fb 	. 
	ret			;121b	c9 	. 
sub_121ch:
	di			;121c	f3 	. 
	in a,(0aah)		;121d	db aa 	. . 
	and 0f0h		;121f	e6 f0 	. . 
	add a,008h		;1221	c6 08 	. . 
	out (0aah),a		;1223	d3 aa 	. . 
	in a,(0a9h)		;1225	db a9 	. . 
	ei			;1227	fb 	. 
	ret			;1228	c9 	. 

; BLOCK 'KBDROW8' (start 0x1229 end 0x1249)
KBDROW8:
	defb 000h		;1229	00 	. 
	defb 005h		;122a	05 	. 
	defb 001h		;122b	01 	. 
	defb 000h		;122c	00 	. 
	defb 003h		;122d	03 	. 
	defb 004h		;122e	04 	. 
	defb 002h		;122f	02 	. 
	defb 003h		;1230	03 	. 
	defb 007h		;1231	07 	. 
	defb 006h		;1232	06 	. 
	defb 008h		;1233	08 	. 
	defb 007h		;1234	07 	. 
	defb 000h		;1235	00 	. 
	defb 005h		;1236	05 	. 
	defb 001h		;1237	01 	. 
	defb 000h		;1238	00 	. 
KBDROW8B:
	defb 000h		;1239	00 	. 
	defb 003h		;123a	03 	. 
	defb 005h		;123b	05 	. 
	defb 004h		;123c	04 	. 
	defb 001h		;123d	01 	. 
	defb 002h		;123e	02 	. 
	defb 000h		;123f	00 	. 
	defb 003h		;1240	03 	. 
	defb 007h		;1241	07 	. 
	defb 000h		;1242	00 	. 
	defb 006h		;1243	06 	. 
	defb 005h		;1244	05 	. 
	defb 008h		;1245	08 	. 
	defb 001h		;1246	01 	. 
	defb 007h		;1247	07 	. 
	defb 000h		;1248	00 	. 
GTTRIG_DO:
	dec a			;1249	3d 	= 
	jp m,l1262h		;124a	fa 62 12 	. b . 
	push af			;124d	f5 	. 
	and 001h		;124e	e6 01 	. . 
	call sub_1202h		;1250	cd 02 12 	. . . 
	pop bc			;1253	c1 	. 
	dec b			;1254	05 	. 
	dec b			;1255	05 	. 
	ld b,010h		;1256	06 10 	. . 
	jp m,l125dh		;1258	fa 5d 12 	. ] . 
	ld b,020h		;125b	06 20 	.   
l125dh:
	and b			;125d	a0 	. 
l125eh:
	sub 001h		;125e	d6 01 	. . 
	sbc a,a			;1260	9f 	. 
	ret			;1261	c9 	. 
l1262h:
	call sub_121ch		;1262	cd 1c 12 	. . . 
	and 001h		;1265	e6 01 	. . 
	jr l125eh		;1267	18 f5 	. . 
GTPDL_DO:
	inc a			;1269	3c 	< 
	and a			;126a	a7 	. 
	rra			;126b	1f 	. 
	push af			;126c	f5 	. 
	ld b,a			;126d	47 	G 
	xor a			;126e	af 	. 
	scf			;126f	37 	7 
l1270h:
	rla			;1270	17 	. 
	djnz l1270h		;1271	10 fd 	. . 
	ld b,a			;1273	47 	G 
	pop af			;1274	f1 	. 
	ld c,010h		;1275	0e 10 	. . 
	ld de,l03afh		;1277	11 af 03 	. . . 
	jr nc,l1281h		;127a	30 05 	0 . 
	ld c,020h		;127c	0e 20 	.   
	ld de,l4c9fh		;127e	11 9f 4c 	. . L 
l1281h:
	ld a,00fh		;1281	3e 0f 	> . 
	di			;1283	f3 	. 
	call RDPSG_DO		;1284	cd 0e 11 	. . . 
	and e			;1287	a3 	. 
	or d			;1288	b2 	. 
	or c			;1289	b1 	. 
	out (0a1h),a		;128a	d3 a1 	. . 
	xor c			;128c	a9 	. 
	out (0a1h),a		;128d	d3 a1 	. . 
	ld a,00eh		;128f	3e 0e 	> . 
	out (0a0h),a		;1291	d3 a0 	. . 
	ld c,000h		;1293	0e 00 	. . 
l1295h:
	in a,(0a2h)		;1295	db a2 	. . 
	and b			;1297	a0 	. 
	jr z,l129fh		;1298	28 05 	( . 
	inc c			;129a	0c 	. 
	jp nz,l1295h		;129b	c2 95 12 	. . . 
	dec c			;129e	0d 	. 
l129fh:
	ei			;129f	fb 	. 
	ld a,c			;12a0	79 	y 
	ret			;12a1	c9 	. 
GTPAD_DO:
	cp 008h		        ;12a2	fe 08 	. . 
	jr c,l12afh		;12a4	38 09 	8 . 
	push ix		        ;12a6	dd e5 	. . 
	ld ix,S.NEWPAD		;12a8	dd 21 ad 01 	. ! . . 
	jp SUBROM_DO		;12ac	c3 95 02 	. . . 
l12afh:
	cp 004h		        ;12af	fe 04 	. . 
	ld de,00cech		;12b1	11 ec 0c 	. . . 
	jr c,l12bbh		;12b4	38 05 	8 . 
	ld de,l03d3h		;12b6	11 d3 03 	. . . 
	sub 004h		;12b9	d6 04 	. . 
l12bbh:
	dec a			;12bb	3d 	= 
	jp m,l12c8h		;12bc	fa c8 12 	. . . 
	dec a			;12bf	3d 	= 
	ld a,(PADX)		;12c0	3a 9d fc 	: . . 
	ret m			;12c3	f8 	. 
	ld a,(PADY)		;12c4	3a 9c fc 	: . . 
	ret z			;12c7	c8 	. 
l12c8h:
	push af			;12c8	f5 	. 
	ex de,hl		;12c9	eb 	. 
	ld (FILNAM),hl		;12ca	22 66 f8 	" f . 
	sbc a,a			;12cd	9f 	. 
	cpl			;12ce	2f 	/ 
	and 040h		;12cf	e6 40 	. @ 
	ld c,a			;12d1	4f 	O 
	ld a,00fh		;12d2	3e 0f 	> . 
	di			;12d4	f3 	. 
	call RDPSG_DO		;12d5	cd 0e 11 	. . . 
	and 0bfh		;12d8	e6 bf 	. . 
	or c			;12da	b1 	. 
	out (0a1h),a		;12db	d3 a1 	. . 
	pop af			;12dd	f1 	. 
	jp m,l12ebh		;12de	fa eb 12 	. . . 
	call sub_110ch		;12e1	cd 0c 11 	. . . 
	ei			;12e4	fb 	. 
	and 008h		;12e5	e6 08 	. . 
	sub 001h		;12e7	d6 01 	. . 
	sbc a,a			;12e9	9f 	. 
	ret			;12ea	c9 	. 
l12ebh:
	ld c,000h		;12eb	0e 00 	. . 
	call sub_1335h		;12ed	cd 35 13 	. 5 . 
	call sub_1335h		;12f0	cd 35 13 	. 5 . 
	jr c,l131dh		;12f3	38 28 	8 ( 
	call sub_1323h		;12f5	cd 23 13 	. # . 
	jr c,l131dh		;12f8	38 23 	8 # 
	push de			;12fa	d5 	. 
	call sub_1323h		;12fb	cd 23 13 	. # . 
	pop bc			;12fe	c1 	. 
	jr c,l131dh		;12ff	38 1c 	8 . 
	ld a,b			;1301	78 	x 
	sub d			;1302	92 	. 
	jr nc,l1307h		;1303	30 02 	0 . 
	cpl			;1305	2f 	/ 
	inc a			;1306	3c 	< 
l1307h:
	cp 005h	                ;1307	fe 05 	. . 
	jr nc,l12ebh		;1309	30 e0 	0 . 
	ld a,c			;130b	79 	y 
	sub e			;130c	93 	. 
	jr nc,l1311h		;130d	30 02 	0 . 
	cpl			;130f	2f 	/ 
	inc a			;1310	3c 	< 
l1311h:
	cp 005h		        ;1311	fe 05 	. . 
	jr nc,l12ebh		;1313	30 d6 	0 . 
	ld a,d			;1315	7a 	z 
	ld (PADX),a		;1316	32 9d fc 	2 . . 
	ld a,e			;1319	7b 	{ 
	ld (PADY),a		;131a	32 9c fc 	2 . . 
l131dh:
	ei			;131d	fb 	. 
	ld a,h			;131e	7c 	| 
	sub 001h		;131f	d6 01 	. . 
	sbc a,a			;1321	9f 	. 
	ret			;1322	c9 	. 
sub_1323h:
	ld c,00ah		;1323	0e 0a 	. . 
	call sub_1335h		;1325	cd 35 13 	. 5 . 
	ret c			;1328	d8 	. 
	ld d,l			;1329	55 	U 
	push de			;132a	d5 	. 
	ld c,000h		;132b	0e 00 	. . 
	call sub_1335h		;132d	cd 35 13 	. 5 . 
	pop de			;1330	d1 	. 
	ld e,l			;1331	5d 	] 
	xor a			;1332	af 	. 
	ld h,a			;1333	67 	g 
	ret			;1334	c9 	. 
sub_1335h:
	call sub_135eh		;1335	cd 5e 13 	. ^ . 
	ld b,008h		;1338	06 08 	. . 
	ld d,c			;133a	51 	Q 
l133bh:
	res 0,d		        ;133b	cb 82 	. . 
	res 2,d		        ;133d	cb 92 	. . 
	call sub_1370h		;133f	cd 70 13 	. p . 
	call sub_110ch		;1342	cd 0c 11 	. . . 
	ld h,a			;1345	67 	g 
	rra			;1346	1f 	. 
	rra			;1347	1f 	. 
	rra			;1348	1f 	. 
	rl l		        ;1349	cb 15 	. . 
	set 0,d		        ;134b	cb c2 	. . 
	set 2,d		        ;134d	cb d2 	. . 
	call sub_1370h		;134f	cd 70 13 	. p . 
	djnz l133bh		;1352	10 e7 	. . 
	set 4,d		        ;1354	cb e2 	. . 
	set 5,d		        ;1356	cb ea 	. . 
	call sub_1370h		;1358	cd 70 13 	. p . 
	ld a,h			;135b	7c 	| 
	rra			;135c	1f 	. 
	ret			;135d	c9 	. 
sub_135eh:
	ld a,035h		;135e	3e 35 	> 5 
	or c			;1360	b1 	. 
	ld d,a			;1361	57 	W 
	call sub_1370h		;1362	cd 70 13 	. p . 
l1365h:
	call sub_110ch	    	;1365	cd 0c 11 	. . . 
	and 002h		;1368	e6 02 	. . 
	jr z,l1365h		;136a	28 f9 	( . 
	res 4,d		        ;136c	cb a2 	. . 
	res 5,d		        ;136e	cb aa 	. . 
sub_1370h:
	push hl			;1370	e5 	. 
	push de			;1371	d5 	. 
	ld hl,(FILNAM)		;1372	2a 66 f8 	* f . 
	ld a,l			;1375	7d 	} 
	cpl			;1376	2f 	/ 
	and d			;1377	a2 	. 
	ld d,a			;1378	57 	W 
	ld a,00fh		;1379	3e 0f 	> . 
	out (0a0h),a		;137b	d3 a0 	. . 
	in a,(0a2h)		;137d	db a2 	. . 
	and l			;137f	a5 	. 
	or d			;1380	b2 	. 
	or h			;1381	b4 	. 
	out (0a1h),a		;1382	d3 a1 	. . 
	pop de			;1384	d1 	. 
	pop hl			;1385	e1 	. 
	ret			;1386	c9 	. 
STMOTR_DO:
	and a			;1387	a7 	. 
	jp m,l1395h		;1388	fa 95 13 	. . . 
l138bh:
	jr nz,$+5		;138b	20 03 	  . 
	ld a,009h		;138d	3e 09 	> . 
	jp nz,0083eh		;138f	c2 3e 08 	. > . 
	out (0abh),a		;1392	d3 ab 	. . 
	ret			;1394	c9 	. 
l1395h:
	in a,(0aah)		;1395	db aa 	. . 
	and 010h		;1397	e6 10 	. . 
	jr l138bh		;1399	18 f0 	. . 
NMI_DO:
	call H.NMI		;139b	cd d6 fd 	. . . 
	retn		        ;139e	ed 45 	. E 
INIFNK_DO:
	ld hl,FNKSTR		;13a0	21 7f f8 	!  . 
	ld b,09fh		;13a3	06 9f 	. . 
	push hl			;13a5	e5 	. 
	xor a			;13a6	af 	. 
l13a7h:
	ld (hl),a			;13a7	77 	w 
	inc hl			;13a8	23 	# 
	djnz l13a7h		;13a9	10 fc 	. . 
	pop hl			;13ab	e1 	. 
	ld b,00ah		;13ac	06 0a 	. . 
	ld de,FKEYS_start		;13ae	11 c3 13 	. . . 
l13b1h:
	ld c,010h		;13b1	0e 10 	. . 
l13b3h:
	ld a,(de)			;13b3	1a 	. 
	inc de			;13b4	13 	. 
	ld (hl),a			;13b5	77 	w 
	inc hl			;13b6	23 	# 
	dec c			;13b7	0d 	. 
	or a			;13b8	b7 	. 
	jr nz,l13b3h		;13b9	20 f8 	  . 
	push bc			;13bb	c5 	. 
	ld b,000h		;13bc	06 00 	. . 
	add hl,bc			;13be	09 	. 
	pop bc			;13bf	c1 	. 
	djnz l13b1h		;13c0	10 ef 	. . 
	ret			;13c2	c9 	. 

; BLOCK 'FKEYS' (start 0x13c3 end 0x140b)
FKEYS_start:
	defb 063h		;13c3	63 	c 
	defb 06fh		;13c4	6f 	o 
	defb 06ch		;13c5	6c 	l 
	defb 06fh		;13c6	6f 	o 
	defb 072h		;13c7	72 	r 
	defb 020h		;13c8	20 	  
	defb 000h		;13c9	00 	. 
	defb 061h		;13ca	61 	a 
	defb 075h		;13cb	75 	u 
	defb 074h		;13cc	74 	t 
	defb 06fh		;13cd	6f 	o 
	defb 020h		;13ce	20 	  
	defb 000h		;13cf	00 	. 
	defb 067h		;13d0	67 	g 
	defb 06fh		;13d1	6f 	o 
	defb 074h		;13d2	74 	t 
	defb 06fh		;13d3	6f 	o 
	defb 020h		;13d4	20 	  
	defb 000h		;13d5	00 	. 
	defb 06ch		;13d6	6c 	l 
	defb 069h		;13d7	69 	i 
	defb 073h		;13d8	73 	s 
	defb 074h		;13d9	74 	t 
	defb 020h		;13da	20 	  
	defb 000h		;13db	00 	. 
	defb 072h		;13dc	72 	r 
	defb 075h		;13dd	75 	u 
	defb 06eh		;13de	6e 	n 
	defb 00dh		;13df	0d 	. 
	defb 000h		;13e0	00 	. 
	defb 063h		;13e1	63 	c 
	defb 06fh		;13e2	6f 	o 
	defb 06ch		;13e3	6c 	l 
	defb 06fh		;13e4	6f 	o 
	defb 072h		;13e5	72 	r 
	defb 020h		;13e6	20 	  
	defb 031h		;13e7	31 	1 
	defb 035h		;13e8	35 	5 
	defb 02ch		;13e9	2c 	, 
	defb 034h		;13ea	34 	4 
	defb 02ch		;13eb	2c 	, 
    IF JAPANESE == 1
	defb 037h		;13ec	37 	7 
    ELSE
	defb 034h		;13ec	34 	4 
    ENDIF
	defb 00dh		;13ed	0d 	. 
	defb 000h		;13ee	00 	. 
    IF VERSION == 2
	defb 063h		;13ef	63 	c 
    ENDIF
	defb 06ch		;13ef	6c 	l 
	defb 06fh		;13f0	6f 	o 
	defb 061h		;13f1	61 	a 
	defb 064h		;13f2	64 	d 
	defb 022h		;13f3	22 	" 
	defb 000h		;13f4	00 	. 
	defb 063h		;13f5	63 	c 
	defb 06fh		;13f6	6f 	o 
	defb 06eh		;13f7	6e 	n 
	defb 074h		;13f8	74 	t 
	defb 00dh		;13f9	0d 	. 
	defb 000h		;13fa	00 	. 
	defb 06ch		;13fb	6c 	l 
	defb 069h		;13fc	69 	i 
	defb 073h		;13fd	73 	s 
	defb 074h		;13fe	74 	t 
	defb 02eh		;13ff	2e 	. 
	defb 00dh		;1400	0d 	. 
	defb 01eh		;1401	1e 	. 
	defb 01eh		;1402	1e 	. 
	defb 000h		;1403	00 	. 
	defb 00ch		;1404	0c 	. 
	defb 072h		;1405	72 	r 
	defb 075h		;1406	75 	u 
	defb 06eh		;1407	6e 	n 
	defb 00dh		;1408	0d 	. 
    IF VERSION == 3
	defb 000h		;1409	00 	. 
    ENDIF
	defb 000h		;140a	00 	. 
RDVDP_DO:
	in a,(099h)		;140b	db 99 	. . 
	ret			;140d	c9 	. 
RSLREG_DO:
	in a,(0a8h)		;140e	db a8 	. . 
	ret			;1410	c9 	. 
WSLREG_DO:
	out (0a8h),a		;1411	d3 a8 	. . 
	ret			;1413	c9 	. 
PHYDIO_DO:
	call H.PHYD		;1414	cd a7 ff 	. . . 
	ret			;1417	c9 	. 
FORMAT_DO:
	call H.FORM		;1418	cd ac ff 	. . . 
	ret			;141b	c9 	. 
SCRHEIGHT:
	ld a,(MODE)		;141c	3a fc fa 	: . . 
	and 010h		;141f	e6 10 	. . 
	ld e,0d4h		;1421	1e d4 	. . 
	ret z			;1423	c8 	. 
	ld de,0100h		;1424	11 00 01 	. . . 
	ret			;1427	c9 	. 
V9958INITP:
	ld hl,(CLOC)		;1428	2a 2a f9 	* * . 
	ld a,(RG25SA)		;142b	3a fa ff 	: . . 
	and 018h		;142e	e6 18 	. . 
	cp 018h		;1430	fe 18 	. . 
	ret nz			;1432	c0 	. 
	ld a,(MODE)		;1433	3a fc fa 	: . . 
	and 020h		;1436	e6 20 	.   
	ret nz			;1438	c0 	. 
	ld (LOGOPR),a		;1439	32 02 fb 	2 . . 
	pop hl			;143c	e1 	. 
	jp CS.SETC		;143d	c3 de 16 	. . . 
V9958INITP2:
	ld (hl),a			;1440	77 	w 
	ld h,a			;1441	67 	g 
	ld a,(RG0SAV)		;1442	3a df f3 	: . . 
	and 00eh		;1445	e6 0e 	. . 
	rrca			;1447	0f 	. 
	ld l,a			;1448	6f 	o 
	ld a,(RG1SAV)		;1449	3a e0 f3 	: . . 
	and 018h		;144c	e6 18 	. . 
	or l			;144e	b5 	. 
	ld l,a			;144f	6f 	o 
	ld a,(RG8SAV)		;1450	3a e7 ff 	: . . 
	and 020h		;1453	e6 20 	.   
	or l			;1455	b5 	. 
	ld l,a			;1456	6f 	o 
	ld a,(RG25SA)		;1457	3a fa ff 	: . . 
	and 018h		;145a	e6 18 	. . 
	rlca			;145c	07 	. 
	rlca			;145d	07 	. 
	rlca			;145e	07 	. 
	or l			;145f	b5 	. 
	out (0f3h),a		;1460	d3 f3 	. . 
	ld a,h			;1462	7c 	| 
	pop hl			;1463	e1 	. 
	ret			;1464	c9 	. 
	nop			;1465	00 	. 
	nop			;1466	00 	. 
	nop			;1467	00 	. 
	nop			;1468	00 	. 
	nop			;1469	00 	. 
READ_F4:
	in a,(0f4h)		;146a	db f4 	. . 
    IF F4_INVERTED == 1
	cpl			;146c	2f 	/ 
    ELSE
        nop
    ENDIF
	ret			;146d	c9 	. 
WRITE_F4:
    IF F4_INVERTED == 1
	cpl			;146e	2f 	/ 
    ELSE
        nop
    ENDIF
	out (0f4h),a		;146f	d3 f4 	. . 
	ret			;1471	c9 	. 
l1472h:
	nop			;1472	00 	. 
	nop			;1473	00 	. 
	nop			;1474	00 	. 
	nop			;1475	00 	. 
	jp l7d75h		;1476	c3 75 7d 	. u } 
sub_1479h:
	in a,(0bah)		;1479	db ba 	. . 
	and 010h		;147b	e6 10 	. . 
	jr nz,l148ch		;147d	20 0d 	  . 
	ld hl,0faffh		;147f	21 ff fa 	! . . 
	set 7,(hl)		;1482	cb fe 	. . 
	ld a,020h		;1484	3e 20 	>   
	out (0bbh),a		;1486	d3 bb 	. . 
	or 008h		;1488	f6 08 	. . 
	out (0bbh),a		;148a	d3 bb 	. . 
l148ch:
	in a,(099h)		;148c	db 99 	. . 
	and a			;148e	a7 	. 
	ret			;148f	c9 	. 
PUTQ_DO:
	call sub_14f8h		;1490	cd f8 14 	. . . 
	ld a,b			;1493	78 	x 
	inc a			;1494	3c 	< 
	inc hl			;1495	23 	# 
	and (hl)			;1496	a6 	. 
	cp c			;1497	b9 	. 
	ret z			;1498	c8 	. 
	push hl			;1499	e5 	. 
	dec hl			;149a	2b 	+ 
	dec hl			;149b	2b 	+ 
	dec hl			;149c	2b 	+ 
	ex (sp),hl			;149d	e3 	. 
	inc hl			;149e	23 	# 
	ld c,a			;149f	4f 	O 
	ld a,(hl)			;14a0	7e 	~ 
	inc hl			;14a1	23 	# 
	ld h,(hl)			;14a2	66 	f 
	ld l,a			;14a3	6f 	o 
	ld b,000h		;14a4	06 00 	. . 
	add hl,bc			;14a6	09 	. 
	ld (hl),e			;14a7	73 	s 
	pop hl			;14a8	e1 	. 
	ld (hl),c			;14a9	71 	q 
	ret			;14aa	c9 	. 
sub_14abh:
	call sub_14f8h		;14ab	cd f8 14 	. . . 
	ld (hl),000h		;14ae	36 00 	6 . 
	jr nz,l14cfh		;14b0	20 1d 	  . 
	ld a,c			;14b2	79 	y 
	cp b			;14b3	b8 	. 
	ret z			;14b4	c8 	. 
	inc hl			;14b5	23 	# 
	inc a			;14b6	3c 	< 
	and (hl)			;14b7	a6 	. 
	dec hl			;14b8	2b 	+ 
	dec hl			;14b9	2b 	+ 
	push hl			;14ba	e5 	. 
	inc hl			;14bb	23 	# 
	inc hl			;14bc	23 	# 
	inc hl			;14bd	23 	# 
	ld c,a			;14be	4f 	O 
	ld a,(hl)			;14bf	7e 	~ 
	inc hl			;14c0	23 	# 
	ld h,(hl)			;14c1	66 	f 
	ld l,a			;14c2	6f 	o 
	ld b,000h		;14c3	06 00 	. . 
	add hl,bc			;14c5	09 	. 
	ld a,(hl)			;14c6	7e 	~ 
	pop hl			;14c7	e1 	. 
	ld (hl),c			;14c8	71 	q 
	or a			;14c9	b7 	. 
	ret nz			;14ca	c0 	. 
	inc a			;14cb	3c 	< 
	ld a,000h		;14cc	3e 00 	> . 
	ret			;14ce	c9 	. 
l14cfh:
	ld c,a			;14cf	4f 	O 
	ld b,000h		;14d0	06 00 	. . 
	ld hl,0f970h		;14d2	21 70 f9 	! p . 
	add hl,bc			;14d5	09 	. 
	ld a,(hl)			;14d6	7e 	~ 
	ret			;14d7	c9 	. 
sub_14d8h:
	push bc			;14d8	c5 	. 
	call sub_1502h		;14d9	cd 02 15 	. . . 
	ld (hl),b			;14dc	70 	p 
	inc hl			;14dd	23 	# 
	ld (hl),b			;14de	70 	p 
	inc hl			;14df	23 	# 
	ld (hl),b			;14e0	70 	p 
	inc hl			;14e1	23 	# 
	pop af			;14e2	f1 	. 
	ld (hl),a			;14e3	77 	w 
	inc hl			;14e4	23 	# 
	ld (hl),e			;14e5	73 	s 
	inc hl			;14e6	23 	# 
	ld (hl),d			;14e7	72 	r 
	ret			;14e8	c9 	. 
LFTQ_DO:
	call sub_14f8h		;14e9	cd f8 14 	. . . 
	ld a,b			;14ec	78 	x 
	inc a			;14ed	3c 	< 
	inc hl			;14ee	23 	# 
	and (hl)			;14ef	a6 	. 
	ld b,a			;14f0	47 	G 
	ld a,c			;14f1	79 	y 
	sub b			;14f2	90 	. 
	and (hl)			;14f3	a6 	. 
	ld l,a			;14f4	6f 	o 
	ld h,000h		;14f5	26 00 	& . 
	ret			;14f7	c9 	. 
sub_14f8h:
	call sub_1502h		;14f8	cd 02 15 	. . . 
	ld b,(hl)			;14fb	46 	F 
	inc hl			;14fc	23 	# 
	ld c,(hl)			;14fd	4e 	N 
	inc hl			;14fe	23 	# 
	ld a,(hl)			;14ff	7e 	~ 
	or a			;1500	b7 	. 
	ret			;1501	c9 	. 
sub_1502h:
	rlca			;1502	07 	. 
	ld b,a			;1503	47 	G 
	rlca			;1504	07 	. 
	add a,b			;1505	80 	. 
	ld c,a			;1506	4f 	O 
	ld b,000h		;1507	06 00 	. . 
	ld hl,(QUEUES)		;1509	2a f3 f3 	* . . 
	add hl,bc			;150c	09 	. 
	ret			;150d	c9 	. 
GRPPRT_DO:
	call CHKNEW_DO		;150e	cd a9 06 	. . . 
	jr c,l151ch		;1511	38 09 	8 . 
	push ix		;1513	dd e5 	. . 
	ld ix,S.GRPPRT		;1515	dd 21 89 00 	. ! . . 
	jp SUBROM_DO		;1519	c3 95 02 	. . . 
l151ch:
	push hl			;151c	e5 	. 
	push de			;151d	d5 	. 
	push bc			;151e	c5 	. 
	push af			;151f	f5 	. 
	call CNVCHR_DO		;1520	cd fa 08 	. . . 
	jr nc,l1587h		;1523	30 62 	0 b 
	jr nz,l152fh		;1525	20 08 	  . 
	cp 00dh		;1527	fe 0d 	. . 
	jr z,l158ah		;1529	28 5f 	( _ 
	cp 020h		;152b	fe 20 	.   
	jr c,l1587h		;152d	38 58 	8 X 
l152fh:
	call sub_07abh		;152f	cd ab 07 	. . . 
	ld a,(FORCLR)		;1532	3a e9 f3 	: . . 
	ld (ATRBYT),a		;1535	32 f2 f3 	2 . . 
	ld hl,(GRPACY)		;1538	2a b9 fc 	* . . 
	ex de,hl			;153b	eb 	. 
	ld bc,(GRPACX)		;153c	ed 4b b7 fc 	. K . . 
l1540h:
	call SCALXY_DO		;1540	cd a5 15 	. . . 
	jr nc,l1587h		;1543	30 42 	0 B 
	call MAPXYC_DO		;1545	cd 04 16 	. . . 
	ld de,PATWRK		;1548	11 40 fc 	. @ . 
	ld c,008h		;154b	0e 08 	. . 
l154dh:
	ld b,008h		;154d	06 08 	. . 
	call FETCHC_DO		;154f	cd 51 16 	. Q . 
	push hl			;1552	e5 	. 
	push af			;1553	f5 	. 
	ld a,(de)			;1554	1a 	. 
l1555h:
	add a,a			;1555	87 	. 
	push af			;1556	f5 	. 
	call c,SETC_DO		;1557	dc c3 16 	. . . 
	call sub_1735h		;155a	cd 35 17 	. 5 . 
	pop hl			;155d	e1 	. 
	jr c,l1564h		;155e	38 04 	8 . 
	push hl			;1560	e5 	. 
	pop af			;1561	f1 	. 
	djnz l1555h		;1562	10 f1 	. . 
l1564h:
	pop af			;1564	f1 	. 
	pop hl			;1565	e1 	. 
	call STOREC_DO		;1566	cd 58 16 	. X . 
	call TDOWNC_DO		;1569	cd b4 17 	. . . 
	jr c,l1572h		;156c	38 04 	8 . 
	inc de			;156e	13 	. 
	dec c			;156f	0d 	. 
	jr nz,l154dh		;1570	20 db 	  . 
l1572h:
	call sub_15fbh		;1572	cd fb 15 	. . . 
	ld a,(GRPACX)		;1575	3a b7 fc 	: . . 
	jr z,l1580h		;1578	28 06 	( . 
	add a,020h		;157a	c6 20 	.   
	jr c,l158ah		;157c	38 0c 	8 . 
	jr l1584h		;157e	18 04 	. . 
l1580h:
	add a,008h		;1580	c6 08 	. . 
	jr c,l158ah		;1582	38 06 	8 . 
l1584h:
	ld (GRPACX),a		;1584	32 b7 fc 	2 . . 
l1587h:
	jp l0937h		;1587	c3 37 09 	. 7 . 
l158ah:
	xor a			;158a	af 	. 
	ld (GRPACX),a		;158b	32 b7 fc 	2 . . 
	call sub_15fbh		;158e	cd fb 15 	. . . 
	ld a,(GRPACY)		;1591	3a b9 fc 	: . . 
	jr z,$+5		;1594	28 03 	( . 
	add a,020h		;1596	c6 20 	.   
	ld bc,l08c6h		;1598	01 c6 08 	. . . 
	cp 0c0h		;159b	fe c0 	. . 
	jr c,l15a0h		;159d	38 01 	8 . 
	xor a			;159f	af 	. 
l15a0h:
	ld (GRPACY),a		;15a0	32 b9 fc 	2 . . 
	jr l1587h		;15a3	18 e2 	. . 
SCALXY_DO:
	push hl			;15a5	e5 	. 
	push bc			;15a6	c5 	. 
	ld b,001h		;15a7	06 01 	. . 
	ex de,hl			;15a9	eb 	. 
	ld a,h			;15aa	7c 	| 
	add a,a			;15ab	87 	. 
	jr nc,l15b3h		;15ac	30 05 	0 . 
	ld hl,0000h		;15ae	21 00 00 	! . . 
	jr l15c4h		;15b1	18 11 	. . 
l15b3h:
	ld de,BEEP		;15b3	11 c0 00 	. . . 
	ld a,(SCRMOD)		;15b6	3a af fc 	: . . 
	cp 005h		;15b9	fe 05 	. . 
        ; Determine height of new screen modes
    IF VERSION == 3
	call nc,SCRHEIGHT	;15bb	d4 1c 14 	. . . 
	nop			;15be	00 	. 
    ELSE
	jr c,l15bfh		;15bb	38 02 	8 . 
	ld e,0d4h		;15bd	1e d4 	. . 
    ENDIF
l15bfh:
	rst 20h			;15bf	e7 	. 
	jr c,l15c6h		;15c0	38 04 	8 . 
	ex de,hl			;15c2	eb 	. 
	dec hl			;15c3	2b 	+ 
l15c4h:
	ld b,000h		;15c4	06 00 	. . 
l15c6h:
	ex (sp),hl			;15c6	e3 	. 
	ld a,h			;15c7	7c 	| 
	add a,a			;15c8	87 	. 
	jr nc,l15d0h		;15c9	30 05 	0 . 
	ld hl,0000h		;15cb	21 00 00 	! . . 
	jr l15e3h		;15ce	18 13 	. . 
l15d0h:
	ld de,0100h		;15d0	11 00 01 	. . . 
	ld a,(SCRMOD)		;15d3	3a af fc 	: . . 
	and 007h		;15d6	e6 07 	. . 
	cp 006h		;15d8	fe 06 	. . 
	jr c,l15deh		;15da	38 02 	8 . 
	ld d,002h		;15dc	16 02 	. . 
l15deh:
	rst 20h			;15de	e7 	. 
	jr c,l15e5h		;15df	38 04 	8 . 
	ex de,hl			;15e1	eb 	. 
	dec hl			;15e2	2b 	+ 
l15e3h:
	ld b,000h		;15e3	06 00 	. . 
l15e5h:
	pop de			;15e5	d1 	. 
	ld a,(SCRMOD)		;15e6	3a af fc 	: . . 
	cp 003h		;15e9	fe 03 	. . 
	jr nz,l15f5h		;15eb	20 08 	  . 
	srl l		;15ed	cb 3d 	. = 
	srl l		;15ef	cb 3d 	. = 
	srl e		;15f1	cb 3b 	. ; 
	srl e		;15f3	cb 3b 	. ; 
l15f5h:
	ld a,b			;15f5	78 	x 
	rrca			;15f6	0f 	. 
	ld b,h			;15f7	44 	D 
	ld c,l			;15f8	4d 	M 
	pop hl			;15f9	e1 	. 
	ret			;15fa	c9 	. 
sub_15fbh:
	ld a,(SCRMOD)		;15fb	3a af fc 	: . . 
	cp 004h		;15fe	fe 04 	. . 
	ret z			;1600	c8 	. 
	cp 002h		;1601	fe 02 	. . 
	ret			;1603	c9 	. 
MAPXYC_DO:
	ld a,(SCRMOD)		;1604	3a af fc 	: . . 
	cp 005h		;1607	fe 05 	. . 
	jr nc,$+53		;1609	30 33 	0 3 
	cp 003h		;160b	fe 03 	. . 
	jr z,l1648h		;160d	28 39 	( 9 
	push bc			;160f	c5 	. 
	ld d,c			;1610	51 	Q 
	ld a,c			;1611	79 	y 
	and 007h		;1612	e6 07 	. . 
	ld c,a			;1614	4f 	O 
	ld hl,l1636h		;1615	21 36 16 	! 6 . 
	add hl,bc			;1618	09 	. 
	ld a,(hl)			;1619	7e 	~ 
	ld (CMASK),a		;161a	32 2c f9 	2 , . 
	ld a,e			;161d	7b 	{ 
l161eh:
	rrca			;161e	0f 	. 
	rrca			;161f	0f 	. 
	rrca			;1620	0f 	. 
	and 01fh		;1621	e6 1f 	. . 
	ld b,a			;1623	47 	G 
	ld a,d			;1624	7a 	z 
	and 0f8h		;1625	e6 f8 	. . 
	ld c,a			;1627	4f 	O 
	ld a,e			;1628	7b 	{ 
	and 007h		;1629	e6 07 	. . 
	or c			;162b	b1 	. 
	ld c,a			;162c	4f 	O 
	ld hl,(GRPCGP)		;162d	2a cb f3 	* . . 
	add hl,bc			;1630	09 	. 
	ld (CLOC),hl		;1631	22 2a f9 	" * . 
	pop bc			;1634	c1 	. 
	ret			;1635	c9 	. 
l1636h:
	add a,b			;1636	80 	. 
	ld b,b			;1637	40 	@ 
	jr nz,l164ah		;1638	20 10 	  . 
	ex af,af'			;163a	08 	. 
	inc b			;163b	04 	. 
	ld (bc),a			;163c	02 	. 
	ld bc,l6960h		;163d	01 60 69 	. ` i 
	ld (CLOC),hl		;1640	22 2a f9 	" * . 
	ld a,e			;1643	7b 	{ 
	ld (CMASK),a		;1644	32 2c f9 	2 , . 
	ret			;1647	c9 	. 
l1648h:
	push ix		;1648	dd e5 	. . 
l164ah:
	ld ix,S.MAPXYC		;164a	dd 21 91 00 	. ! . . 
	jp SUBROM_DO		;164e	c3 95 02 	. . . 
FETCHC_DO:
	ld a,(CMASK)		;1651	3a 2c f9 	: , . 
	ld hl,(CLOC)		;1654	2a 2a f9 	* * . 
	ret			;1657	c9 	. 
STOREC_DO:
	ld (CMASK),a		;1658	32 2c f9 	2 , . 
	ld (CLOC),hl		;165b	22 2a f9 	" * . 
	ret			;165e	c9 	. 
READC_DO:
	call CHKNEW_DO		;165f	cd a9 06 	. . . 
	jr c,l166dh		;1662	38 09 	8 . 
l1664h:
	push ix		;1664	dd e5 	. . 
	ld ix,S.READC		;1666	dd 21 95 00 	. ! . . 
	jp SUBROM_DO		;166a	c3 95 02 	. . . 
l166dh:
	call sub_15fbh		;166d	cd fb 15 	. . . 
	jr nz,l1664h		;1670	20 f2 	  . 
	push bc			;1672	c5 	. 
	push hl			;1673	e5 	. 
	call FETCHC_DO		;1674	cd 51 16 	. Q . 
	ld b,a			;1677	47 	G 
	call RDVRM_DO		;1678	cd e1 07 	. . . 
	and b			;167b	a0 	. 
	push af			;167c	f5 	. 
	ld bc,l2000h		;167d	01 00 20 	. .   
	add hl,bc			;1680	09 	. 
	call RDVRM_DO		;1681	cd e1 07 	. . . 
	ld b,a			;1684	47 	G 
	pop af			;1685	f1 	. 
	ld a,b			;1686	78 	x 
	jr z,l168dh		;1687	28 04 	( . 
	rrca			;1689	0f 	. 
	rrca			;168a	0f 	. 
	rrca			;168b	0f 	. 
	rrca			;168c	0f 	. 
l168dh:
	and 00fh		;168d	e6 0f 	. . 
	pop hl			;168f	e1 	. 
	pop bc			;1690	c1 	. 
	ret			;1691	c9 	. 
SETATR_DO:
	call sub_169ah		;1692	cd 9a 16 	. . . 
	ret c			;1695	d8 	. 
	ld (ATRBYT),a		;1696	32 f2 f3 	2 . . 
	ret			;1699	c9 	. 
sub_169ah:
	push af			;169a	f5 	. 
	ld a,(SCRMOD)		;169b	3a af fc 	: . . 
	cp 006h		;169e	fe 06 	. . 
	jr z,l16aeh		;16a0	28 0c 	( . 
	cp 008h		;16a2	fe 08 	. . 
	jr z,l16abh		;16a4	28 05 	( . 
	pop af			;16a6	f1 	. 
	cp 010h		;16a7	fe 10 	. . 
	ccf			;16a9	3f 	? 
	ret			;16aa	c9 	. 
l16abh:
	pop af			;16ab	f1 	. 
	and a			;16ac	a7 	. 
	ret			;16ad	c9 	. 
l16aeh:
	pop af			;16ae	f1 	. 
	cp 020h		;16af	fe 20 	.   
	ccf			;16b1	3f 	? 
	ret c			;16b2	d8 	. 
	cp 010h		;16b3	fe 10 	. . 
	jr c,l16bah		;16b5	38 03 	8 . 
	and 00fh		;16b7	e6 0f 	. . 
	ret			;16b9	c9 	. 
l16bah:
	and 003h		;16ba	e6 03 	. . 
	push bc			;16bc	c5 	. 
	ld b,a			;16bd	47 	G 
	add a,a			;16be	87 	. 
	add a,a			;16bf	87 	. 
	add a,b			;16c0	80 	. 
	pop bc			;16c1	c1 	. 
	ret			;16c2	c9 	. 
SETC_DO:
	ld a,(SCRMOD)		;16c3	3a af fc 	: . . 
	cp 005h		;16c6	fe 05 	. . 
	jr nc,l16e7h		;16c8	30 1d 	0 . 
	cp 003h		;16ca	fe 03 	. . 
	jr z,CS.SETC		;16cc	28 10 	( . 
	push hl			;16ce	e5 	. 
	push bc			;16cf	c5 	. 
	push de			;16d0	d5 	. 
	ld a,(CMASK)		;16d1	3a 2c f9 	: , . 
	ld hl,(CLOC)		;16d4	2a 2a f9 	* * . 
	call sub_18a6h		;16d7	cd a6 18 	. . . 
	pop de			;16da	d1 	. 
	pop bc			;16db	c1 	. 
	pop hl			;16dc	e1 	. 
	ret			;16dd	c9 	. 
CS.SETC:
	push ix		;16de	dd e5 	. . 
	ld ix,S.SETC		;16e0	dd 21 9d 00 	. ! . . 
	jp SUBROM_DO		;16e4	c3 95 02 	. . . 
l16e7h:
        ; MSX2+ patch
    IF VERSION == 3
	call V9958INITP		;16e7	cd 28 14 	. ( . 
    ELSE
	ld hl,(CLOC)		;16e7	2a 2a f9 	* * . 
    ENDIF
	ld a,(CMASK)		;16ea	3a 2c f9 	: , . 
	push af			;16ed	f5 	. 
l16eeh:
	di			;16ee	f3 	. 
	ld a,002h		;16ef	3e 02 	> . 
	out (099h),a		;16f1	d3 99 	. . 
	ld a,08fh		;16f3	3e 8f 	> . 
	out (099h),a		;16f5	d3 99 	. . 
	push hl			;16f7	e5 	. 
	pop hl			;16f8	e1 	. 
	in a,(099h)		;16f9	db 99 	. . 
	push af			;16fb	f5 	. 
	xor a			;16fc	af 	. 
	out (099h),a		;16fd	d3 99 	. . 
	ld a,08fh		;16ff	3e 8f 	> . 
	out (099h),a		;1701	d3 99 	. . 
	pop af			;1703	f1 	. 
	ei			;1704	fb 	. 
	rrca			;1705	0f 	. 
	jr c,l16eeh		;1706	38 e6 	8 . 
	di			;1708	f3 	. 
	ld a,024h		;1709	3e 24 	> $ 
	out (099h),a		;170b	d3 99 	. . 
	ld a,091h		;170d	3e 91 	> . 
	out (099h),a		;170f	d3 99 	. . 
	ld a,l			;1711	7d 	} 
	out (09bh),a		;1712	d3 9b 	. . 
	ld a,h			;1714	7c 	| 
	out (09bh),a		;1715	d3 9b 	. . 
	pop af			;1717	f1 	. 
	out (09bh),a		;1718	d3 9b 	. . 
	ld a,(ACPAGE)		;171a	3a f6 fa 	: . . 
	out (09bh),a		;171d	d3 9b 	. . 
	ld a,02ch		;171f	3e 2c 	> , 
	out (099h),a		;1721	d3 99 	. . 
	ld a,091h		;1723	3e 91 	> . 
	out (099h),a		;1725	d3 99 	. . 
	ld a,(ATRBYT)		;1727	3a f2 f3 	: . . 
	out (09bh),a		;172a	d3 9b 	. . 
	xor a			;172c	af 	. 
	out (09bh),a		;172d	d3 9b 	. . 
	ld a,050h		;172f	3e 50 	> P 
	out (09bh),a		;1731	d3 9b 	. . 
	ei			;1733	fb 	. 
	ret			;1734	c9 	. 
sub_1735h:
	call sub_15fbh		;1735	cd fb 15 	. . . 
	jr z,l1743h		;1738	28 09 	( . 
	push ix		;173a	dd e5 	. . 
	ld ix,S.TRIGHT		;173c	dd 21 a1 00 	. ! . . 
	jp SUBROM_DO		;1740	c3 95 02 	. . . 
l1743h:
	push hl			;1743	e5 	. 
	call FETCHC_DO		;1744	cd 51 16 	. Q . 
	rrca			;1747	0f 	. 
	jr nc,l17aeh		;1748	30 64 	0 d 
	ld a,l			;174a	7d 	} 
	and 0f8h		;174b	e6 f8 	. . 
	cp 0f8h		;174d	fe f8 	. . 
	ld a,080h		;174f	3e 80 	> . 
	jr nz,l176bh		;1751	20 18 	  . 
	jp l181ch		;1753	c3 1c 18 	. . . 
RIGHTC_DO:
	call sub_15fbh		;1756	cd fb 15 	. . . 
	jr z,l1764h		;1759	28 09 	( . 
	push ix		;175b	dd e5 	. . 
	ld ix,S.RIGHTC		;175d	dd 21 a5 00 	. ! . . 
	jp SUBROM_DO		;1761	c3 95 02 	. . . 
l1764h:
	push hl			;1764	e5 	. 
	call FETCHC_DO		;1765	cd 51 16 	. Q . 
	rrca			;1768	0f 	. 
	jr nc,l17aeh		;1769	30 43 	0 C 
l176bh:
	push de			;176b	d5 	. 
	ld de,0008h		;176c	11 08 00 	. . . 
	jr l17a9h		;176f	18 38 	. 8 
sub_1771h:
	call sub_15fbh		;1771	cd fb 15 	. . . 
	jr z,l177fh		;1774	28 09 	( . 
	push ix		;1776	dd e5 	. . 
	ld ix,S.TLEFTC		;1778	dd 21 a9 00 	. ! . . 
	jp SUBROM_DO		;177c	c3 95 02 	. . . 
l177fh:
	push hl			;177f	e5 	. 
	call FETCHC_DO		;1780	cd 51 16 	. Q . 
	rlca			;1783	07 	. 
	jr nc,l17aeh		;1784	30 28 	0 ( 
	ld a,l			;1786	7d 	} 
	and 0f8h		;1787	e6 f8 	. . 
	ld a,001h		;1789	3e 01 	> . 
	jr nz,l17a5h		;178b	20 18 	  . 
	jp l181ch		;178d	c3 1c 18 	. . . 
LEFTC_DO:
	call sub_15fbh		;1790	cd fb 15 	. . . 
	jr z,l179eh		;1793	28 09 	( . 
	push ix		;1795	dd e5 	. . 
	ld ix,S.LEFTC		;1797	dd 21 ad 00 	. ! . . 
	jp SUBROM_DO		;179b	c3 95 02 	. . . 
l179eh:
	push hl			;179e	e5 	. 
	call FETCHC_DO		;179f	cd 51 16 	. Q . 
	rlca			;17a2	07 	. 
	jr nc,l17aeh		;17a3	30 09 	0 . 
l17a5h:
	push de			;17a5	d5 	. 
	ld de,0fff8h		;17a6	11 f8 ff 	. . . 
l17a9h:
	add hl,de			;17a9	19 	. 
	ld (CLOC),hl		;17aa	22 2a f9 	" * . 
	pop de			;17ad	d1 	. 
l17aeh:
	ld (CMASK),a		;17ae	32 2c f9 	2 , . 
	and a			;17b1	a7 	. 
	pop hl			;17b2	e1 	. 
	ret			;17b3	c9 	. 
TDOWNC_DO:
	call sub_15fbh		;17b4	cd fb 15 	. . . 
	jr z,l17c2h		;17b7	28 09 	( . 
	push ix		;17b9	dd e5 	. . 
	ld ix,S.TDOWNC		;17bb	dd 21 b1 00 	. ! . . 
	jp SUBROM_DO		;17bf	c3 95 02 	. . . 
l17c2h:
	push hl			;17c2	e5 	. 
	push de			;17c3	d5 	. 
	ld hl,(CLOC)		;17c4	2a 2a f9 	* * . 
	push hl			;17c7	e5 	. 
	ld hl,(GRPCGP)		;17c8	2a cb f3 	* . . 
	ld de,01700h		;17cb	11 00 17 	. . . 
	add hl,de			;17ce	19 	. 
	ex de,hl			;17cf	eb 	. 
	pop hl			;17d0	e1 	. 
	rst 20h			;17d1	e7 	. 
	jr c,l17efh		;17d2	38 1b 	8 . 
	ld a,l			;17d4	7d 	} 
	inc a			;17d5	3c 	< 
	and 007h		;17d6	e6 07 	. . 
	jr nz,l17efh		;17d8	20 15 	  . 
	jr l181bh		;17da	18 3f 	. ? 
DOWNC_DO:
	call sub_15fbh		;17dc	cd fb 15 	. . . 
	jr z,l17eah		;17df	28 09 	( . 
	push ix		;17e1	dd e5 	. . 
	ld ix,S.DOWNC		;17e3	dd 21 b5 00 	. ! . . 
	jp SUBROM_DO		;17e7	c3 95 02 	. . . 
l17eah:
	push hl			;17ea	e5 	. 
	push de			;17eb	d5 	. 
	ld hl,(CLOC)		;17ec	2a 2a f9 	* * . 
l17efh:
	inc hl			;17ef	23 	# 
	ld a,l			;17f0	7d 	} 
	ld de,0f8h		;17f1	11 f8 00 	. . . 
	jr l1837h		;17f4	18 41 	. A 
TUPC_DO:
	call sub_15fbh		;17f6	cd fb 15 	. . . 
	jr z,l1804h		;17f9	28 09 	( . 
	push ix		;17fb	dd e5 	. . 
	ld ix,S.TUPC		;17fd	dd 21 b9 00 	. ! . . 
	jp SUBROM_DO		;1801	c3 95 02 	. . . 
l1804h:
	push hl			;1804	e5 	. 
	push de			;1805	d5 	. 
	ld hl,(CLOC)		;1806	2a 2a f9 	* * . 
	push hl			;1809	e5 	. 
	ld hl,(GRPCGP)		;180a	2a cb f3 	* . . 
	ld de,0100h		;180d	11 00 01 	. . . 
	add hl,de			;1810	19 	. 
	ex de,hl			;1811	eb 	. 
	pop hl			;1812	e1 	. 
	rst 20h			;1813	e7 	. 
	jr nc,l1832h		;1814	30 1c 	0 . 
	ld a,l			;1816	7d 	} 
	and 007h		;1817	e6 07 	. . 
	jr nz,l1832h		;1819	20 17 	  . 
l181bh:
	pop de			;181b	d1 	. 
l181ch:
	scf			;181c	37 	7 
	pop hl			;181d	e1 	. 
l181eh:
	ret			;181e	c9 	. 
UPC_DO:
	call sub_15fbh		;181f	cd fb 15 	. . . 
	jr z,l182dh		;1822	28 09 	( . 
	push ix		;1824	dd e5 	. . 
	ld ix,S.UPC		;1826	dd 21 bd 00 	. ! . . 
	jp SUBROM_DO		;182a	c3 95 02 	. . . 
l182dh:
	push hl			;182d	e5 	. 
	push de			;182e	d5 	. 
	ld hl,(CLOC)		;182f	2a 2a f9 	* * . 
l1832h:
	ld a,l			;1832	7d 	} 
	dec hl			;1833	2b 	+ 
	ld de,0ff08h		;1834	11 08 ff 	. . . 
l1837h:
	and 007h		;1837	e6 07 	. . 
	jr nz,l183ch		;1839	20 01 	  . 
	add hl,de			;183b	19 	. 
l183ch:
	ld (CLOC),hl		;183c	22 2a f9 	" * . 
	and a			;183f	a7 	. 
	pop de			;1840	d1 	. 
	pop hl			;1841	e1 	. 
	ret			;1842	c9 	. 
NSETCX_DO:
	call sub_15fbh		;1843	cd fb 15 	. . . 
	jp nz,l18f5h		;1846	c2 f5 18 	. . . 
	push hl			;1849	e5 	. 
	call FETCHC_DO		;184a	cd 51 16 	. Q . 
	ex (sp),hl			;184d	e3 	. 
	add a,a			;184e	87 	. 
	jr c,l1869h		;184f	38 18 	8 . 
	push af			;1851	f5 	. 
	ld bc,0ffffh		;1852	01 ff ff 	. . . 
	rrca			;1855	0f 	. 
l1856h:
	add hl,bc			;1856	09 	. 
	jr nc,$+71		;1857	30 45 	0 E 
	rrca			;1859	0f 	. 
	jr nc,l1856h		;185a	30 fa 	0 . 
	pop af			;185c	f1 	. 
	dec a			;185d	3d 	= 
	ex (sp),hl			;185e	e3 	. 
	push hl			;185f	e5 	. 
	call sub_18a6h		;1860	cd a6 18 	. . . 
	pop hl			;1863	e1 	. 
	ld de,0008h		;1864	11 08 00 	. . . 
	add hl,de			;1867	19 	. 
	ex (sp),hl			;1868	e3 	. 
l1869h:
	ld a,l			;1869	7d 	} 
	and 007h		;186a	e6 07 	. . 
	ld c,a			;186c	4f 	O 
	ld a,h			;186d	7c 	| 
	rrca			;186e	0f 	. 
	ld a,l			;186f	7d 	} 
	rra			;1870	1f 	. 
	rrca			;1871	0f 	. 
	rrca			;1872	0f 	. 
	and 03fh		;1873	e6 3f 	. ? 
	pop hl			;1875	e1 	. 
	ld b,a			;1876	47 	G 
	jr z,l188dh		;1877	28 14 	( . 
l1879h:
	xor a			;1879	af 	. 
	call WRTVRM_DO		;187a	cd d7 07 	. . . 
	ld de,l2000h		;187d	11 00 20 	. .   
	add hl,de			;1880	19 	. 
	ld a,(ATRBYT)		;1881	3a f2 f3 	: . . 
	call WRTVRM_DO		;1884	cd d7 07 	. . . 
	ld de,l2008h		;1887	11 08 20 	. .   
	add hl,de			;188a	19 	. 
	djnz l1879h		;188b	10 ec 	. . 
l188dh:
	dec c			;188d	0d 	. 
	ret m			;188e	f8 	. 
	push hl			;188f	e5 	. 
	ld hl,l1897h		;1890	21 97 18 	! . . 
	add hl,bc			;1893	09 	. 
	ld a,(hl)			;1894	7e 	~ 
	jr l18a5h		;1895	18 0e 	. . 
l1897h:
	add a,b			;1897	80 	. 
	ret nz			;1898	c0 	. 
	ret po			;1899	e0 	. 
	ret p			;189a	f0 	. 
	ret m			;189b	f8 	. 
	call m,087feh		;189c	fc fe 87 	. . . 
	dec a			;189f	3d 	= 
	cpl			;18a0	2f 	/ 
	ld b,a			;18a1	47 	G 
	pop af			;18a2	f1 	. 
	dec a			;18a3	3d 	= 
	and b			;18a4	a0 	. 
l18a5h:
	pop hl			;18a5	e1 	. 
sub_18a6h:
	ld b,a			;18a6	47 	G 
	call RDVRM_DO		;18a7	cd e1 07 	. . . 
	ld c,a			;18aa	4f 	O 
	ld de,l2000h		;18ab	11 00 20 	. .   
	add hl,de			;18ae	19 	. 
	call RDVRM_DO		;18af	cd e1 07 	. . . 
	push af			;18b2	f5 	. 
	and 00fh		;18b3	e6 0f 	. . 
	ld e,a			;18b5	5f 	_ 
	pop af			;18b6	f1 	. 
	sub e			;18b7	93 	. 
	ld d,a			;18b8	57 	W 
	ld a,(ATRBYT)		;18b9	3a f2 f3 	: . . 
	cp e			;18bc	bb 	. 
	jr z,l18d8h		;18bd	28 19 	( . 
	add a,a			;18bf	87 	. 
	add a,a			;18c0	87 	. 
	add a,a			;18c1	87 	. 
	add a,a			;18c2	87 	. 
	cp d			;18c3	ba 	. 
	jr z,$+24		;18c4	28 16 	( . 
	push af			;18c6	f5 	. 
	ld a,b			;18c7	78 	x 
	or c			;18c8	b1 	. 
	cp 0ffh		;18c9	fe ff 	. . 
	jr z,l18e4h		;18cb	28 17 	( . 
	push hl			;18cd	e5 	. 
	push de			;18ce	d5 	. 
	call 018dch		;18cf	cd dc 18 	. . . 
	pop de			;18d2	d1 	. 
	pop hl			;18d3	e1 	. 
	pop af			;18d4	f1 	. 
	or e			;18d5	b3 	. 
	jr l18f2h		;18d6	18 1a 	. . 
l18d8h:
	ld a,b			;18d8	78 	x 
	cpl			;18d9	2f 	/ 
	and c			;18da	a1 	. 
	ld de,0b178h		;18db	11 78 b1 	. x . 
sub_18deh:
	ld de,l2000h		;18de	11 00 20 	. .   
	add hl,de			;18e1	19 	. 
	jr l18f2h		;18e2	18 0e 	. . 
l18e4h:
	pop af			;18e4	f1 	. 
	ld a,b			;18e5	78 	x 
	cpl			;18e6	2f 	/ 
	push hl			;18e7	e5 	. 
	push de			;18e8	d5 	. 
	call sub_18deh		;18e9	cd de 18 	. . . 
	pop de			;18ec	d1 	. 
	pop hl			;18ed	e1 	. 
	ld a,(ATRBYT)		;18ee	3a f2 f3 	: . . 
	or d			;18f1	b2 	. 
l18f2h:
	jp WRTVRM_DO		;18f2	c3 d7 07 	. . . 
l18f5h:
	push hl			;18f5	e5 	. 
	call SETC_DO		;18f6	cd c3 16 	. . . 
	call RIGHTC_DO		;18f9	cd 56 17 	. V . 
	pop hl			;18fc	e1 	. 
	dec l			;18fd	2d 	- 
	jr nz,l18f5h		;18fe	20 f5 	  . 
	ret			;1900	c9 	. 
GTASPC_DO:
	ld hl,(ASPCT1)		;1901	2a 0b f4 	* . . 
	ex de,hl			;1904	eb 	. 
	ld hl,(ASPCT2)		;1905	2a 0d f4 	* . . 
	ret			;1908	c9 	. 
PNTINI_DO:
	push af			;1909	f5 	. 
	call sub_15fbh		;190a	cd fb 15 	. . . 
	jr z,l1915h		;190d	28 06 	( . 
	pop af			;190f	f1 	. 
	cp 010h		;1910	fe 10 	. . 
	ccf			;1912	3f 	? 
	jr l191ah		;1913	18 05 	. . 
l1915h:
	pop af			;1915	f1 	. 
	ld a,(ATRBYT)		;1916	3a f2 f3 	: . . 
	and a			;1919	a7 	. 
l191ah:
	ld (BDRATR),a		;191a	32 b2 fc 	2 . . 
	ret			;191d	c9 	. 
SCANR_DO:
	ld hl,0000h		;191e	21 00 00 	! . . 
	ld c,l			;1921	4d 	M 
	call sub_15fbh		;1922	cd fb 15 	. . . 
	jr z,l1930h		;1925	28 09 	( . 
	push ix		;1927	dd e5 	. . 
	ld ix,S.SCANR		;1929	dd 21 c1 00 	. ! . . 
	jp SUBROM_DO		;192d	c3 95 02 	. . . 
l1930h:
	ld a,b			;1930	78 	x 
	ld (FILNAM),a		;1931	32 66 f8 	2 f . 
	xor a			;1934	af 	. 
	ld (0f869h),a		;1935	32 69 f8 	2 i . 
	ld a,(BDRATR)		;1938	3a b2 fc 	: . . 
	ld b,a			;193b	47 	G 
l193ch:
	call READC_DO		;193c	cd 5f 16 	. _ . 
	cp b			;193f	b8 	. 
	jr nz,l194fh		;1940	20 0d 	  . 
	dec de			;1942	1b 	. 
	ld a,d			;1943	7a 	z 
	or e			;1944	b3 	. 
	ret z			;1945	c8 	. 
	call sub_1735h		;1946	cd 35 17 	. 5 . 
	jr nc,l193ch		;1949	30 f1 	0 . 
	ld de,0000h		;194b	11 00 00 	. . . 
	ret			;194e	c9 	. 
l194fh:
	call sub_19d1h		;194f	cd d1 19 	. . . 
	push de			;1952	d5 	. 
	call FETCHC_DO		;1953	cd 51 16 	. Q . 
	ld (CSAVEA),hl		;1956	22 42 f9 	" B . 
	ld (CSAVEM),a		;1959	32 44 f9 	2 D . 
	ld de,0000h		;195c	11 00 00 	. . . 
l195fh:
	inc de			;195f	13 	. 
	call sub_1735h		;1960	cd 35 17 	. 5 . 
	jr c,l1970h		;1963	38 0b 	8 . 
	call READC_DO		;1965	cd 5f 16 	. _ . 
	cp b			;1968	b8 	. 
	jr z,l1970h		;1969	28 05 	( . 
	call sub_19d1h		;196b	cd d1 19 	. . . 
	jr l195fh		;196e	18 ef 	. . 
l1970h:
	push de			;1970	d5 	. 
	call FETCHC_DO		;1971	cd 51 16 	. Q . 
	push hl			;1974	e5 	. 
	push af			;1975	f5 	. 
	ld hl,(CSAVEA)		;1976	2a 42 f9 	* B . 
	ld a,(CSAVEM)		;1979	3a 44 f9 	: D . 
	call STOREC_DO		;197c	cd 58 16 	. X . 
	ex de,hl			;197f	eb 	. 
	ld (0f867h),hl		;1980	22 67 f8 	" g . 
	ld a,(FILNAM)		;1983	3a 66 f8 	: f . 
	and a			;1986	a7 	. 
	call nz,NSETCX_DO		;1987	c4 43 18 	. C . 
	pop af			;198a	f1 	. 
	pop hl			;198b	e1 	. 
	call STOREC_DO		;198c	cd 58 16 	. X . 
	pop hl			;198f	e1 	. 
	pop de			;1990	d1 	. 
	jp l19cch		;1991	c3 cc 19 	. . . 
SCANL_DO:
	ld hl,0000h		;1994	21 00 00 	! . . 
	ld c,l			;1997	4d 	M 
l1998h:
	call sub_15fbh		;1998	cd fb 15 	. . . 
	jr z,l19a6h		;199b	28 09 	( . 
	push ix		;199d	dd e5 	. . 
	ld ix,S.SCANL		;199f	dd 21 c5 00 	. ! . . 
	jp SUBROM_DO		;19a3	c3 95 02 	. . . 
l19a6h:
	xor a			;19a6	af 	. 
	ld (0f869h),a		;19a7	32 69 f8 	2 i . 
	ld a,(BDRATR)		;19aa	3a b2 fc 	: . . 
	ld b,a			;19ad	47 	G 
l19aeh:
	call sub_1771h		;19ae	cd 71 17 	. q . 
	jr c,l19c2h		;19b1	38 0f 	8 . 
	call READC_DO		;19b3	cd 5f 16 	. _ . 
	cp b			;19b6	b8 	. 
	jr z,l19bfh		;19b7	28 06 	( . 
	call sub_19d1h		;19b9	cd d1 19 	. . . 
	inc hl			;19bc	23 	# 
	jr l19aeh		;19bd	18 ef 	. . 
l19bfh:
	call RIGHTC_DO		;19bf	cd 56 17 	. V . 
l19c2h:
	push hl			;19c2	e5 	. 
	ld de,(0f867h)		;19c3	ed 5b 67 f8 	. [ g . 
	add hl,de			;19c7	19 	. 
	call NSETCX_DO		;19c8	cd 43 18 	. C . 
	pop hl			;19cb	e1 	. 
l19cch:
	ld a,(0f869h)		;19cc	3a 69 f8 	: i . 
	ld c,a			;19cf	4f 	O 
	ret			;19d0	c9 	. 
sub_19d1h:
	push hl			;19d1	e5 	. 
	ld hl,ATRBYT		;19d2	21 f2 f3 	! . . 
	cp (hl)			;19d5	be 	. 
	pop hl			;19d6	e1 	. 
	ret z			;19d7	c8 	. 
	inc a			;19d8	3c 	< 
	ld (0f869h),a		;19d9	32 69 f8 	2 i . 
	ret			;19dc	c9 	. 
TAPOOF_DO:
	push bc			;19dd	c5 	. 
	push af			;19de	f5 	. 
	ld bc,0000h		;19df	01 00 00 	. . . 
l19e2h:
	dec bc			;19e2	0b 	. 
	ld a,b			;19e3	78 	x 
	or c			;19e4	b1 	. 
	jr nz,l19e2h		;19e5	20 fb 	  . 
	pop af			;19e7	f1 	. 
	pop bc			;19e8	c1 	. 
TAPIOF_DO:
	push af			;19e9	f5 	. 
	ld a,009h		;19ea	3e 09 	> . 
	out (0abh),a		;19ec	d3 ab 	. . 
	pop af			;19ee	f1 	. 
	ei			;19ef	fb 	. 
	ret			;19f0	c9 	. 
TAPOON_DO:
	or a			;19f1	b7 	. 
	push af			;19f2	f5 	. 
	ld a,008h		;19f3	3e 08 	> . 
	out (0abh),a		;19f5	d3 ab 	. . 
	ld hl,0000h		;19f7	21 00 00 	! . . 
l19fah:
	dec hl			;19fa	2b 	+ 
	ld a,h			;19fb	7c 	| 
	or l			;19fc	b5 	. 
	jr nz,l19fah		;19fd	20 fb 	  . 
	pop af			;19ff	f1 	. 
	ld a,(HEADER)		;1a00	3a 0a f4 	: . . 
	jr z,l1a07h		;1a03	28 02 	( . 
	add a,a			;1a05	87 	. 
	add a,a			;1a06	87 	. 
l1a07h:
	ld b,a			;1a07	47 	G 
	ld c,000h		;1a08	0e 00 	. . 
	di			;1a0a	f3 	. 
l1a0bh:
	call sub_1a4dh		;1a0b	cd 4d 1a 	. M . 
	call sub_1a3fh		;1a0e	cd 3f 1a 	. ? . 
	dec bc			;1a11	0b 	. 
	ld a,b			;1a12	78 	x 
	or c			;1a13	b1 	. 
	jr nz,l1a0bh		;1a14	20 f5 	  . 
	jp BREAKX_DO		;1a16	c3 64 05 	. d . 
TAPOUT_DO:
	ld hl,(LOW.)		;1a19	2a 06 f4 	* . . 
	push af			;1a1c	f5 	. 
	ld a,l			;1a1d	7d 	} 
	sub 00eh		;1a1e	d6 0e 	. . 
	ld l,a			;1a20	6f 	o 
	call sub_1a50h		;1a21	cd 50 1a 	. P . 
	pop af			;1a24	f1 	. 
	ld b,008h		;1a25	06 08 	. . 
l1a27h:
	rrca			;1a27	0f 	. 
	call c,sub_1a40h		;1a28	dc 40 1a 	. @ . 
	call nc,sub_1a39h		;1a2b	d4 39 1a 	. 9 . 
	djnz l1a27h		;1a2e	10 f7 	. . 
	call sub_1a40h		;1a30	cd 40 1a 	. @ . 
	call sub_1a40h		;1a33	cd 40 1a 	. @ . 
	jp BREAKX_DO		;1a36	c3 64 05 	. d . 
sub_1a39h:
	ld hl,(LOW.)		;1a39	2a 06 f4 	* . . 
	call sub_1a50h		;1a3c	cd 50 1a 	. P . 
sub_1a3fh:
	ret			;1a3f	c9 	. 
sub_1a40h:
	call sub_1a4dh		;1a40	cd 4d 1a 	. M . 
	ex (sp),hl			;1a43	e3 	. 
	ex (sp),hl			;1a44	e3 	. 
	nop			;1a45	00 	. 
	nop			;1a46	00 	. 
	nop			;1a47	00 	. 
	nop			;1a48	00 	. 
	call sub_1a4dh		;1a49	cd 4d 1a 	. M . 
	ret			;1a4c	c9 	. 
sub_1a4dh:
	ld hl,(HIGH.)		;1a4d	2a 08 f4 	* . . 
sub_1a50h:
	push af			;1a50	f5 	. 
l1a51h:
	dec l			;1a51	2d 	- 
	jp nz,l1a51h		;1a52	c2 51 1a 	. Q . 
	ld a,00bh		;1a55	3e 0b 	> . 
	out (0abh),a		;1a57	d3 ab 	. . 
l1a59h:
	dec h			;1a59	25 	% 
	jp nz,l1a59h		;1a5a	c2 59 1a 	. Y . 
	ld a,00ah		;1a5d	3e 0a 	> . 
	out (0abh),a		;1a5f	d3 ab 	. . 
	pop af			;1a61	f1 	. 
	ret			;1a62	c9 	. 
TAPION_DO:
	ld a,008h		;1a63	3e 08 	> . 
	out (0abh),a		;1a65	d3 ab 	. . 
	di			;1a67	f3 	. 
	ld a,00eh		;1a68	3e 0e 	> . 
	out (0a0h),a		;1a6a	d3 a0 	. . 
l1a6ch:
	ld hl,l0457h		;1a6c	21 57 04 	! W . 
l1a6fh:
	ld d,c			;1a6f	51 	Q 
	call sub_1b34h		;1a70	cd 34 1b 	. 4 . 
	ret c			;1a73	d8 	. 
	ld a,c			;1a74	79 	y 
	cp 0deh		;1a75	fe de 	. . 
	jr nc,l1a6ch		;1a77	30 f3 	0 . 
	cp 005h		;1a79	fe 05 	. . 
	jr c,l1a6ch		;1a7b	38 ef 	8 . 
	sub d			;1a7d	92 	. 
	jr nc,l1a82h		;1a7e	30 02 	0 . 
	cpl			;1a80	2f 	/ 
	inc a			;1a81	3c 	< 
l1a82h:
	cp 004h		;1a82	fe 04 	. . 
	jr nc,l1a6ch		;1a84	30 e6 	0 . 
	dec hl			;1a86	2b 	+ 
	ld a,h			;1a87	7c 	| 
	or l			;1a88	b5 	. 
	jr nz,l1a6fh		;1a89	20 e4 	  . 
	ld hl,0000h		;1a8b	21 00 00 	! . . 
	ld b,l			;1a8e	45 	E 
	ld d,l			;1a8f	55 	U 
l1a90h:
	call sub_1b34h		;1a90	cd 34 1b 	. 4 . 
	ret c			;1a93	d8 	. 
	add hl,bc			;1a94	09 	. 
	dec d			;1a95	15 	. 
	jp nz,l1a90h		;1a96	c2 90 1a 	. . . 
	ld bc,l06aeh		;1a99	01 ae 06 	. . . 
	add hl,bc			;1a9c	09 	. 
	ld a,h			;1a9d	7c 	| 
	rra			;1a9e	1f 	. 
	and 07fh		;1a9f	e6 7f 	.  
	ld d,a			;1aa1	57 	W 
	add hl,hl			;1aa2	29 	) 
	ld a,h			;1aa3	7c 	| 
	sub d			;1aa4	92 	. 
	ld d,a			;1aa5	57 	W 
	sub 006h		;1aa6	d6 06 	. . 
	ld (LOWLIM),a		;1aa8	32 a4 fc 	2 . . 
	ld a,d			;1aab	7a 	z 
	add a,a			;1aac	87 	. 
	ld b,000h		;1aad	06 00 	. . 
l1aafh:
	sub 003h		;1aaf	d6 03 	. . 
	inc b			;1ab1	04 	. 
	jr nc,l1aafh		;1ab2	30 fb 	0 . 
	ld a,b			;1ab4	78 	x 
	sub 003h		;1ab5	d6 03 	. . 
	ld (WINWID),a		;1ab7	32 a5 fc 	2 . . 
	or a			;1aba	b7 	. 
	ret			;1abb	c9 	. 
TAPIN_DO:
	ld a,(LOWLIM)		;1abc	3a a4 fc 	: . . 
	ld d,a			;1abf	57 	W 
l1ac0h:
	call BREAKX_DO		;1ac0	cd 64 05 	. d . 
	ret c			;1ac3	d8 	. 
	in a,(0a2h)		;1ac4	db a2 	. . 
	rlca			;1ac6	07 	. 
	jr nc,l1ac0h		;1ac7	30 f7 	0 . 
l1ac9h:
	call BREAKX_DO		;1ac9	cd 64 05 	. d . 
	ret c			;1acc	d8 	. 
	in a,(0a2h)		;1acd	db a2 	. . 
	rlca			;1acf	07 	. 
	jr c,l1ac9h		;1ad0	38 f7 	8 . 
	ld e,000h		;1ad2	1e 00 	. . 
	call sub_1b1fh		;1ad4	cd 1f 1b 	. . . 
l1ad7h:
	ld b,c			;1ad7	41 	A 
	call sub_1b1fh		;1ad8	cd 1f 1b 	. . . 
	ret c			;1adb	d8 	. 
	ld a,b			;1adc	78 	x 
	add a,c			;1add	81 	. 
	jp c,l1ad7h		;1ade	da d7 1a 	. . . 
	cp d			;1ae1	ba 	. 
	jr c,l1ad7h		;1ae2	38 f3 	8 . 
	ld l,008h		;1ae4	2e 08 	. . 
l1ae6h:
	call sub_1b03h		;1ae6	cd 03 1b 	. . . 
	cp 004h		;1ae9	fe 04 	. . 
	ccf			;1aeb	3f 	? 
	ret c			;1aec	d8 	. 
	cp 002h		;1aed	fe 02 	. . 
	ccf			;1aef	3f 	? 
	rr d		;1af0	cb 1a 	. . 
	ld a,c			;1af2	79 	y 
	rrca			;1af3	0f 	. 
	call nc,sub_1b23h		;1af4	d4 23 1b 	. # . 
	call sub_1b1fh		;1af7	cd 1f 1b 	. . . 
	dec l			;1afa	2d 	- 
	jp nz,l1ae6h		;1afb	c2 e6 1a 	. . . 
	call BREAKX_DO		;1afe	cd 64 05 	. d . 
	ld a,d			;1b01	7a 	z 
	ret			;1b02	c9 	. 
sub_1b03h:
	ld a,(WINWID)		;1b03	3a a5 fc 	: . . 
	ld b,a			;1b06	47 	G 
	ld c,000h		;1b07	0e 00 	. . 
l1b09h:
	in a,(0a2h)		;1b09	db a2 	. . 
	xor e			;1b0b	ab 	. 
	jp p,l1b17h		;1b0c	f2 17 1b 	. . . 
	ld a,e			;1b0f	7b 	{ 
	cpl			;1b10	2f 	/ 
	ld e,a			;1b11	5f 	_ 
	inc c			;1b12	0c 	. 
	djnz l1b09h		;1b13	10 f4 	. . 
	ld a,c			;1b15	79 	y 
	ret			;1b16	c9 	. 
l1b17h:
	nop			;1b17	00 	. 
	nop			;1b18	00 	. 
	nop			;1b19	00 	. 
	nop			;1b1a	00 	. 
	djnz l1b09h		;1b1b	10 ec 	. . 
	ld a,c			;1b1d	79 	y 
	ret			;1b1e	c9 	. 
sub_1b1fh:
	call BREAKX_DO		;1b1f	cd 64 05 	. d . 
	ret c			;1b22	d8 	. 
sub_1b23h:
	ld c,000h		;1b23	0e 00 	. . 
l1b25h:
	inc c			;1b25	0c 	. 
	jr z,l1b32h		;1b26	28 0a 	( . 
	in a,(0a2h)		;1b28	db a2 	. . 
	xor e			;1b2a	ab 	. 
	jp p,l1b25h		;1b2b	f2 25 1b 	. % . 
	ld a,e			;1b2e	7b 	{ 
	cpl			;1b2f	2f 	/ 
	ld e,a			;1b30	5f 	_ 
	ret			;1b31	c9 	. 
l1b32h:
	dec c			;1b32	0d 	. 
	ret			;1b33	c9 	. 
sub_1b34h:
	call BREAKX_DO		;1b34	cd 64 05 	. d . 
	ret c			;1b37	d8 	. 
	in a,(0a2h)		;1b38	db a2 	. . 
	rlca			;1b3a	07 	. 
	jr c,sub_1b34h		;1b3b	38 f7 	8 . 
	ld e,000h		;1b3d	1e 00 	. . 
	call sub_1b23h		;1b3f	cd 23 1b 	. # . 
	jp l1b25h		;1b42	c3 25 1b 	. % . 
OUTDO_DO:
	push af			;1b45	f5 	. 
	call H.OUTD		;1b46	cd e4 fe 	. . . 
	call ISFLIO_DO		;1b49	cd f9 0b 	. . . 
	jr z,l1b56h		;1b4c	28 08 	( . 
	pop af			;1b4e	f1 	. 
	ld ix,l6c48h		;1b4f	dd 21 48 6c 	. ! H l 
	jp CALBAS_DO		;1b53	c3 bf 02 	. . . 
l1b56h:
	ld a,(PRTFLG)		;1b56	3a 16 f4 	: . . 
	or a			;1b59	b7 	. 
	jr z,l1bbbh		;1b5a	28 5f 	( _ 
	ld a,(RAWPRT)		;1b5c	3a 18 f4 	: . . 
	and a			;1b5f	a7 	. 
	jr nz,PRINT_DO		;1b60	20 49 	  I 
	pop af			;1b62	f1 	. 
OUTDLP_DO:
	push af			;1b63	f5 	. 
	cp 009h		;1b64	fe 09 	. . 
	jr nz,l1b76h		;1b66	20 0e 	  . 
l1b68h:
	ld a,020h		;1b68	3e 20 	>   
	call OUTDLP_DO		;1b6a	cd 63 1b 	. c . 
	ld a,(LPTPOS)		;1b6d	3a 15 f4 	: . . 
	and 007h		;1b70	e6 07 	. . 
	jr nz,l1b68h		;1b72	20 f4 	  . 
	pop af			;1b74	f1 	. 
	ret			;1b75	c9 	. 
l1b76h:
	sub 00dh		;1b76	d6 0d 	. . 
	jr z,l1b84h		;1b78	28 0a 	( . 
	jr c,l1b87h		;1b7a	38 0b 	8 . 
	cp 013h		;1b7c	fe 13 	. . 
	jr c,l1b87h		;1b7e	38 07 	8 . 
	ld a,(LPTPOS)		;1b80	3a 15 f4 	: . . 
	inc a			;1b83	3c 	< 
l1b84h:
	ld (LPTPOS),a		;1b84	32 15 f4 	2 . . 
l1b87h:
	ld a,(NTMSXP)		;1b87	3a 17 f4 	: . . 
	and a			;1b8a	a7 	. 
	jr z,PRINT_DO		;1b8b	28 1e 	( . 
	pop af			;1b8d	f1 	. 
	call CNVCHR_DO		;1b8e	cd fa 08 	. . . 
	ret nc			;1b91	d0 	. 
	jr nz,l1bb7h		;1b92	20 23 	  # 
    IF JAPANESE == 1
	and a			;1b94	a7 	. 
	defb 0f2h		;1b95	f2 	. 
    ELSE
	jr l1bach		;1b94	18 16 	. . 
    ENDIF

; BLOCK 'SCANCODES' (start 0x1b96 end 0x1bab)
SCANCODES:
	defb 030h		;1b96	30 	0 
	defb 083h		;1b97	83 	. 
	defb 033h		;1b98	33 	3 
	defb 010h		;1b99	10 	. 
	defb 034h		;1b9a	34 	4 
	defb 036h		;1b9b	36 	6 
	defb 035h		;1b9c	35 	5 
	defb 010h		;1b9d	10 	. 
	defb 03ah		;1b9e	3a 	: 
	defb 0c3h		;1b9f	c3 	. 
	defb 03ch		;1ba0	3c 	< 
	defb 010h		;1ba1	10 	. 
	defb 03dh		;1ba2	3d 	= 
	defb 046h		;1ba3	46 	F 
	defb 041h		;1ba4	41 	A 
	defb 010h		;1ba5	10 	. 
	defb 042h		;1ba6	42 	B 
	defb 006h		;1ba7	06 	. 
	defb 0ffh		;1ba8	ff 	. 
	defb 010h		;1ba9	10 	. 
	defb 038h		;1baa	38 	8 
PRINT_DO:
	pop af			;1bab	f1 	. 
l1bach:
	call LPTOUT_DO		;1bac	cd ba 08 	. . . 
	ret nc			;1baf	d0 	. 
	ld ix,l73b2h		;1bb0	dd 21 b2 73 	. ! . s 
	jp CALBAS_DO		;1bb4	c3 bf 02 	. . . 
l1bb7h:
	ld a,020h		;1bb7	3e 20 	>   
	jr l1bach		;1bb9	18 f1 	. . 
l1bbbh:
	pop af			;1bbb	f1 	. 
	jp CHPUT_DO		;1bbc	c3 19 09 	. . . 

; BLOCK 'CHARGEN' (start 0x1bbf end 0x23bf)
CHARGEN_start:
	defb 000h		;1bbf	00 	. 
	defb 000h		;1bc0	00 	. 
	defb 000h		;1bc1	00 	. 
	defb 000h		;1bc2	00 	. 
	defb 000h		;1bc3	00 	. 
	defb 000h		;1bc4	00 	. 
	defb 000h		;1bc5	00 	. 
	defb 000h		;1bc6	00 	. 
	defb 03ch		;1bc7	3c 	< 
	defb 042h		;1bc8	42 	B 
	defb 0a5h		;1bc9	a5 	. 
	defb 081h		;1bca	81 	. 
	defb 0a5h		;1bcb	a5 	. 
	defb 099h		;1bcc	99 	. 
	defb 042h		;1bcd	42 	B 
	defb 03ch		;1bce	3c 	< 
	defb 03ch		;1bcf	3c 	< 
	defb 07eh		;1bd0	7e 	~ 
	defb 0dbh		;1bd1	db 	. 
	defb 0ffh		;1bd2	ff 	. 
	defb 0ffh		;1bd3	ff 	. 
	defb 0dbh		;1bd4	db 	. 
	defb 066h		;1bd5	66 	f 
	defb 03ch		;1bd6	3c 	< 
	defb 06ch		;1bd7	6c 	l 
	defb 0feh		;1bd8	fe 	. 
	defb 0feh		;1bd9	fe 	. 
	defb 0feh		;1bda	fe 	. 
	defb 07ch		;1bdb	7c 	| 
	defb 038h		;1bdc	38 	8 
	defb 010h		;1bdd	10 	. 
	defb 000h		;1bde	00 	. 
	defb 010h		;1bdf	10 	. 
	defb 038h		;1be0	38 	8 
	defb 07ch		;1be1	7c 	| 
	defb 0feh		;1be2	fe 	. 
	defb 07ch		;1be3	7c 	| 
	defb 038h		;1be4	38 	8 
	defb 010h		;1be5	10 	. 
	defb 000h		;1be6	00 	. 
	defb 010h		;1be7	10 	. 
	defb 038h		;1be8	38 	8 
	defb 054h		;1be9	54 	T 
	defb 0feh		;1bea	fe 	. 
	defb 054h		;1beb	54 	T 
	defb 010h		;1bec	10 	. 
	defb 038h		;1bed	38 	8 
	defb 000h		;1bee	00 	. 
	defb 010h		;1bef	10 	. 
	defb 038h		;1bf0	38 	8 
	defb 07ch		;1bf1	7c 	| 
	defb 0feh		;1bf2	fe 	. 
	defb 0feh		;1bf3	fe 	. 
	defb 010h		;1bf4	10 	. 
	defb 038h		;1bf5	38 	8 
	defb 000h		;1bf6	00 	. 
	defb 000h		;1bf7	00 	. 
	defb 000h		;1bf8	00 	. 
	defb 000h		;1bf9	00 	. 
	defb 030h		;1bfa	30 	0 
	defb 030h		;1bfb	30 	0 
	defb 000h		;1bfc	00 	. 
	defb 000h		;1bfd	00 	. 
	defb 000h		;1bfe	00 	. 
	defb 0ffh		;1bff	ff 	. 
	defb 0ffh		;1c00	ff 	. 
	defb 0ffh		;1c01	ff 	. 
	defb 0e7h		;1c02	e7 	. 
	defb 0e7h		;1c03	e7 	. 
	defb 0ffh		;1c04	ff 	. 
	defb 0ffh		;1c05	ff 	. 
	defb 0ffh		;1c06	ff 	. 
	defb 038h		;1c07	38 	8 
	defb 044h		;1c08	44 	D 
	defb 082h		;1c09	82 	. 
	defb 082h		;1c0a	82 	. 
	defb 082h		;1c0b	82 	. 
	defb 044h		;1c0c	44 	D 
	defb 038h		;1c0d	38 	8 
	defb 000h		;1c0e	00 	. 
	defb 0c7h		;1c0f	c7 	. 
	defb 0bbh		;1c10	bb 	. 
	defb 07dh		;1c11	7d 	} 
	defb 07dh		;1c12	7d 	} 
	defb 07dh		;1c13	7d 	} 
	defb 0bbh		;1c14	bb 	. 
	defb 0c7h		;1c15	c7 	. 
	defb 0ffh		;1c16	ff 	. 
	defb 00fh		;1c17	0f 	. 
	defb 003h		;1c18	03 	. 
	defb 005h		;1c19	05 	. 
	defb 079h		;1c1a	79 	y 
	defb 088h		;1c1b	88 	. 
	defb 088h		;1c1c	88 	. 
	defb 088h		;1c1d	88 	. 
	defb 070h		;1c1e	70 	p 
	defb 038h		;1c1f	38 	8 
	defb 044h		;1c20	44 	D 
	defb 044h		;1c21	44 	D 
	defb 044h		;1c22	44 	D 
	defb 038h		;1c23	38 	8 
	defb 010h		;1c24	10 	. 
	defb 07ch		;1c25	7c 	| 
	defb 010h		;1c26	10 	. 
	defb 030h		;1c27	30 	0 
	defb 028h		;1c28	28 	( 
	defb 024h		;1c29	24 	$ 
	defb 024h		;1c2a	24 	$ 
	defb 028h		;1c2b	28 	( 
	defb 020h		;1c2c	20 	  
	defb 0e0h		;1c2d	e0 	. 
	defb 0c0h		;1c2e	c0 	. 
	defb 03ch		;1c2f	3c 	< 
	defb 024h		;1c30	24 	$ 
	defb 03ch		;1c31	3c 	< 
	defb 024h		;1c32	24 	$ 
	defb 024h		;1c33	24 	$ 
	defb 0e4h		;1c34	e4 	. 
	defb 0dch		;1c35	dc 	. 
	defb 018h		;1c36	18 	. 
	defb 010h		;1c37	10 	. 
	defb 054h		;1c38	54 	T 
	defb 038h		;1c39	38 	8 
	defb 0eeh		;1c3a	ee 	. 
	defb 038h		;1c3b	38 	8 
	defb 054h		;1c3c	54 	T 
	defb 010h		;1c3d	10 	. 
	defb 000h		;1c3e	00 	. 
	defb 010h		;1c3f	10 	. 
	defb 010h		;1c40	10 	. 
	defb 010h		;1c41	10 	. 
	defb 07ch		;1c42	7c 	| 
	defb 010h		;1c43	10 	. 
	defb 010h		;1c44	10 	. 
	defb 010h		;1c45	10 	. 
	defb 010h		;1c46	10 	. 
	defb 010h		;1c47	10 	. 
	defb 010h		;1c48	10 	. 
	defb 010h		;1c49	10 	. 
	defb 0ffh		;1c4a	ff 	. 
	defb 000h		;1c4b	00 	. 
	defb 000h		;1c4c	00 	. 
	defb 000h		;1c4d	00 	. 
	defb 000h		;1c4e	00 	. 
	defb 000h		;1c4f	00 	. 
	defb 000h		;1c50	00 	. 
	defb 000h		;1c51	00 	. 
	defb 0ffh		;1c52	ff 	. 
	defb 010h		;1c53	10 	. 
	defb 010h		;1c54	10 	. 
	defb 010h		;1c55	10 	. 
	defb 010h		;1c56	10 	. 
	defb 010h		;1c57	10 	. 
	defb 010h		;1c58	10 	. 
	defb 010h		;1c59	10 	. 
	defb 0f0h		;1c5a	f0 	. 
	defb 010h		;1c5b	10 	. 
	defb 010h		;1c5c	10 	. 
	defb 010h		;1c5d	10 	. 
	defb 010h		;1c5e	10 	. 
	defb 010h		;1c5f	10 	. 
	defb 010h		;1c60	10 	. 
	defb 010h		;1c61	10 	. 
	defb 01fh		;1c62	1f 	. 
	defb 010h		;1c63	10 	. 
	defb 010h		;1c64	10 	. 
	defb 010h		;1c65	10 	. 
	defb 010h		;1c66	10 	. 
	defb 010h		;1c67	10 	. 
	defb 010h		;1c68	10 	. 
	defb 010h		;1c69	10 	. 
	defb 0ffh		;1c6a	ff 	. 
	defb 010h		;1c6b	10 	. 
	defb 010h		;1c6c	10 	. 
	defb 010h		;1c6d	10 	. 
	defb 010h		;1c6e	10 	. 
	defb 010h		;1c6f	10 	. 
	defb 010h		;1c70	10 	. 
	defb 010h		;1c71	10 	. 
	defb 010h		;1c72	10 	. 
	defb 010h		;1c73	10 	. 
	defb 010h		;1c74	10 	. 
	defb 010h		;1c75	10 	. 
	defb 010h		;1c76	10 	. 
	defb 000h		;1c77	00 	. 
	defb 000h		;1c78	00 	. 
	defb 000h		;1c79	00 	. 
	defb 0ffh		;1c7a	ff 	. 
	defb 000h		;1c7b	00 	. 
	defb 000h		;1c7c	00 	. 
	defb 000h		;1c7d	00 	. 
	defb 000h		;1c7e	00 	. 
	defb 000h		;1c7f	00 	. 
	defb 000h		;1c80	00 	. 
	defb 000h		;1c81	00 	. 
	defb 01fh		;1c82	1f 	. 
	defb 010h		;1c83	10 	. 
	defb 010h		;1c84	10 	. 
	defb 010h		;1c85	10 	. 
	defb 010h		;1c86	10 	. 
	defb 000h		;1c87	00 	. 
	defb 000h		;1c88	00 	. 
	defb 000h		;1c89	00 	. 
	defb 0f0h		;1c8a	f0 	. 
	defb 010h		;1c8b	10 	. 
	defb 010h		;1c8c	10 	. 
	defb 010h		;1c8d	10 	. 
	defb 010h		;1c8e	10 	. 
	defb 010h		;1c8f	10 	. 
	defb 010h		;1c90	10 	. 
	defb 010h		;1c91	10 	. 
	defb 01fh		;1c92	1f 	. 
	defb 000h		;1c93	00 	. 
	defb 000h		;1c94	00 	. 
	defb 000h		;1c95	00 	. 
	defb 000h		;1c96	00 	. 
	defb 010h		;1c97	10 	. 
	defb 010h		;1c98	10 	. 
	defb 010h		;1c99	10 	. 
	defb 0f0h		;1c9a	f0 	. 
	defb 000h		;1c9b	00 	. 
	defb 000h		;1c9c	00 	. 
	defb 000h		;1c9d	00 	. 
	defb 000h		;1c9e	00 	. 
	defb 081h		;1c9f	81 	. 
	defb 042h		;1ca0	42 	B 
	defb 024h		;1ca1	24 	$ 
	defb 018h		;1ca2	18 	. 
	defb 018h		;1ca3	18 	. 
	defb 024h		;1ca4	24 	$ 
	defb 042h		;1ca5	42 	B 
	defb 081h		;1ca6	81 	. 
	defb 001h		;1ca7	01 	. 
	defb 002h		;1ca8	02 	. 
	defb 004h		;1ca9	04 	. 
	defb 008h		;1caa	08 	. 
	defb 010h		;1cab	10 	. 
	defb 020h		;1cac	20 	  
	defb 040h		;1cad	40 	@ 
	defb 080h		;1cae	80 	. 
	defb 080h		;1caf	80 	. 
	defb 040h		;1cb0	40 	@ 
	defb 020h		;1cb1	20 	  
	defb 010h		;1cb2	10 	. 
	defb 008h		;1cb3	08 	. 
	defb 004h		;1cb4	04 	. 
	defb 002h		;1cb5	02 	. 
	defb 001h		;1cb6	01 	. 
	defb 000h		;1cb7	00 	. 
	defb 010h		;1cb8	10 	. 
	defb 010h		;1cb9	10 	. 
	defb 0ffh		;1cba	ff 	. 
	defb 010h		;1cbb	10 	. 
	defb 010h		;1cbc	10 	. 
	defb 000h		;1cbd	00 	. 
	defb 000h		;1cbe	00 	. 
	defb 000h		;1cbf	00 	. 
	defb 000h		;1cc0	00 	. 
	defb 000h		;1cc1	00 	. 
	defb 000h		;1cc2	00 	. 
	defb 000h		;1cc3	00 	. 
	defb 000h		;1cc4	00 	. 
	defb 000h		;1cc5	00 	. 
	defb 000h		;1cc6	00 	. 
	defb 020h		;1cc7	20 	  
	defb 020h		;1cc8	20 	  
	defb 020h		;1cc9	20 	  
	defb 020h		;1cca	20 	  
	defb 000h		;1ccb	00 	. 
	defb 000h		;1ccc	00 	. 
	defb 020h		;1ccd	20 	  
	defb 000h		;1cce	00 	. 
	defb 050h		;1ccf	50 	P 
	defb 050h		;1cd0	50 	P 
	defb 050h		;1cd1	50 	P 
	defb 000h		;1cd2	00 	. 
	defb 000h		;1cd3	00 	. 
	defb 000h		;1cd4	00 	. 
	defb 000h		;1cd5	00 	. 
	defb 000h		;1cd6	00 	. 
	defb 050h		;1cd7	50 	P 
	defb 050h		;1cd8	50 	P 
	defb 0f8h		;1cd9	f8 	. 
	defb 050h		;1cda	50 	P 
	defb 0f8h		;1cdb	f8 	. 
	defb 050h		;1cdc	50 	P 
	defb 050h		;1cdd	50 	P 
	defb 000h		;1cde	00 	. 
	defb 020h		;1cdf	20 	  
	defb 078h		;1ce0	78 	x 
	defb 0a0h		;1ce1	a0 	. 
	defb 070h		;1ce2	70 	p 
	defb 028h		;1ce3	28 	( 
	defb 0f0h		;1ce4	f0 	. 
	defb 020h		;1ce5	20 	  
	defb 000h		;1ce6	00 	. 
	defb 0c0h		;1ce7	c0 	. 
	defb 0c8h		;1ce8	c8 	. 
	defb 010h		;1ce9	10 	. 
	defb 020h		;1cea	20 	  
	defb 040h		;1ceb	40 	@ 
	defb 098h		;1cec	98 	. 
	defb 018h		;1ced	18 	. 
	defb 000h		;1cee	00 	. 
	defb 040h		;1cef	40 	@ 
	defb 0a0h		;1cf0	a0 	. 
	defb 040h		;1cf1	40 	@ 
	defb 0a8h		;1cf2	a8 	. 
	defb 090h		;1cf3	90 	. 
	defb 098h		;1cf4	98 	. 
	defb 060h		;1cf5	60 	` 
	defb 000h		;1cf6	00 	. 
	defb 010h		;1cf7	10 	. 
	defb 020h		;1cf8	20 	  
	defb 040h		;1cf9	40 	@ 
	defb 000h		;1cfa	00 	. 
	defb 000h		;1cfb	00 	. 
	defb 000h		;1cfc	00 	. 
	defb 000h		;1cfd	00 	. 
	defb 000h		;1cfe	00 	. 
	defb 010h		;1cff	10 	. 
	defb 020h		;1d00	20 	  
	defb 040h		;1d01	40 	@ 
	defb 040h		;1d02	40 	@ 
	defb 040h		;1d03	40 	@ 
	defb 020h		;1d04	20 	  
	defb 010h		;1d05	10 	. 
	defb 000h		;1d06	00 	. 
	defb 040h		;1d07	40 	@ 
	defb 020h		;1d08	20 	  
	defb 010h		;1d09	10 	. 
	defb 010h		;1d0a	10 	. 
	defb 010h		;1d0b	10 	. 
	defb 020h		;1d0c	20 	  
	defb 040h		;1d0d	40 	@ 
	defb 000h		;1d0e	00 	. 
	defb 020h		;1d0f	20 	  
	defb 0a8h		;1d10	a8 	. 
	defb 070h		;1d11	70 	p 
	defb 020h		;1d12	20 	  
	defb 070h		;1d13	70 	p 
	defb 0a8h		;1d14	a8 	. 
	defb 020h		;1d15	20 	  
	defb 000h		;1d16	00 	. 
	defb 000h		;1d17	00 	. 
	defb 020h		;1d18	20 	  
	defb 020h		;1d19	20 	  
	defb 0f8h		;1d1a	f8 	. 
	defb 020h		;1d1b	20 	  
	defb 020h		;1d1c	20 	  
	defb 000h		;1d1d	00 	. 
	defb 000h		;1d1e	00 	. 
	defb 000h		;1d1f	00 	. 
	defb 000h		;1d20	00 	. 
	defb 000h		;1d21	00 	. 
	defb 000h		;1d22	00 	. 
	defb 000h		;1d23	00 	. 
	defb 020h		;1d24	20 	  
	defb 020h		;1d25	20 	  
	defb 040h		;1d26	40 	@ 
	defb 000h		;1d27	00 	. 
	defb 000h		;1d28	00 	. 
	defb 000h		;1d29	00 	. 
	defb 078h		;1d2a	78 	x 
	defb 000h		;1d2b	00 	. 
	defb 000h		;1d2c	00 	. 
	defb 000h		;1d2d	00 	. 
	defb 000h		;1d2e	00 	. 
	defb 000h		;1d2f	00 	. 
	defb 000h		;1d30	00 	. 
	defb 000h		;1d31	00 	. 
	defb 000h		;1d32	00 	. 
	defb 000h		;1d33	00 	. 
	defb 060h		;1d34	60 	` 
	defb 060h		;1d35	60 	` 
	defb 000h		;1d36	00 	. 
	defb 000h		;1d37	00 	. 
	defb 000h		;1d38	00 	. 
	defb 008h		;1d39	08 	. 
	defb 010h		;1d3a	10 	. 
	defb 020h		;1d3b	20 	  
	defb 040h		;1d3c	40 	@ 
	defb 080h		;1d3d	80 	. 
	defb 000h		;1d3e	00 	. 
	defb 070h		;1d3f	70 	p 
	defb 088h		;1d40	88 	. 
	defb 098h		;1d41	98 	. 
	defb 0a8h		;1d42	a8 	. 
	defb 0c8h		;1d43	c8 	. 
	defb 088h		;1d44	88 	. 
	defb 070h		;1d45	70 	p 
	defb 000h		;1d46	00 	. 
	defb 020h		;1d47	20 	  
	defb 060h		;1d48	60 	` 
	defb 0a0h		;1d49	a0 	. 
	defb 020h		;1d4a	20 	  
	defb 020h		;1d4b	20 	  
	defb 020h		;1d4c	20 	  
	defb 0f8h		;1d4d	f8 	. 
	defb 000h		;1d4e	00 	. 
	defb 070h		;1d4f	70 	p 
	defb 088h		;1d50	88 	. 
	defb 008h		;1d51	08 	. 
	defb 010h		;1d52	10 	. 
	defb 060h		;1d53	60 	` 
	defb 080h		;1d54	80 	. 
	defb 0f8h		;1d55	f8 	. 
	defb 000h		;1d56	00 	. 
	defb 070h		;1d57	70 	p 
	defb 088h		;1d58	88 	. 
	defb 008h		;1d59	08 	. 
	defb 030h		;1d5a	30 	0 
	defb 008h		;1d5b	08 	. 
	defb 088h		;1d5c	88 	. 
	defb 070h		;1d5d	70 	p 
	defb 000h		;1d5e	00 	. 
	defb 010h		;1d5f	10 	. 
	defb 030h		;1d60	30 	0 
	defb 050h		;1d61	50 	P 
	defb 090h		;1d62	90 	. 
	defb 0f8h		;1d63	f8 	. 
	defb 010h		;1d64	10 	. 
	defb 010h		;1d65	10 	. 
	defb 000h		;1d66	00 	. 
	defb 0f8h		;1d67	f8 	. 
	defb 080h		;1d68	80 	. 
	defb 0e0h		;1d69	e0 	. 
	defb 010h		;1d6a	10 	. 
	defb 008h		;1d6b	08 	. 
	defb 010h		;1d6c	10 	. 
	defb 0e0h		;1d6d	e0 	. 
	defb 000h		;1d6e	00 	. 
	defb 030h		;1d6f	30 	0 
	defb 040h		;1d70	40 	@ 
	defb 080h		;1d71	80 	. 
	defb 0f0h		;1d72	f0 	. 
	defb 088h		;1d73	88 	. 
	defb 088h		;1d74	88 	. 
	defb 070h		;1d75	70 	p 
	defb 000h		;1d76	00 	. 
	defb 0f8h		;1d77	f8 	. 
	defb 088h		;1d78	88 	. 
	defb 010h		;1d79	10 	. 
	defb 020h		;1d7a	20 	  
	defb 020h		;1d7b	20 	  
	defb 020h		;1d7c	20 	  
	defb 020h		;1d7d	20 	  
	defb 000h		;1d7e	00 	. 
	defb 070h		;1d7f	70 	p 
	defb 088h		;1d80	88 	. 
	defb 088h		;1d81	88 	. 
	defb 070h		;1d82	70 	p 
	defb 088h		;1d83	88 	. 
	defb 088h		;1d84	88 	. 
	defb 070h		;1d85	70 	p 
	defb 000h		;1d86	00 	. 
	defb 070h		;1d87	70 	p 
	defb 088h		;1d88	88 	. 
	defb 088h		;1d89	88 	. 
	defb 078h		;1d8a	78 	x 
	defb 008h		;1d8b	08 	. 
	defb 010h		;1d8c	10 	. 
	defb 060h		;1d8d	60 	` 
	defb 000h		;1d8e	00 	. 
	defb 000h		;1d8f	00 	. 
	defb 000h		;1d90	00 	. 
	defb 020h		;1d91	20 	  
	defb 000h		;1d92	00 	. 
	defb 000h		;1d93	00 	. 
	defb 020h		;1d94	20 	  
	defb 000h		;1d95	00 	. 
	defb 000h		;1d96	00 	. 
	defb 000h		;1d97	00 	. 
	defb 000h		;1d98	00 	. 
	defb 020h		;1d99	20 	  
	defb 000h		;1d9a	00 	. 
	defb 000h		;1d9b	00 	. 
	defb 020h		;1d9c	20 	  
	defb 020h		;1d9d	20 	  
	defb 040h		;1d9e	40 	@ 
	defb 018h		;1d9f	18 	. 
	defb 030h		;1da0	30 	0 
	defb 060h		;1da1	60 	` 
	defb 0c0h		;1da2	c0 	. 
	defb 060h		;1da3	60 	` 
	defb 030h		;1da4	30 	0 
	defb 018h		;1da5	18 	. 
	defb 000h		;1da6	00 	. 
	defb 000h		;1da7	00 	. 
	defb 000h		;1da8	00 	. 
	defb 0f8h		;1da9	f8 	. 
	defb 000h		;1daa	00 	. 
	defb 0f8h		;1dab	f8 	. 
	defb 000h		;1dac	00 	. 
	defb 000h		;1dad	00 	. 
	defb 000h		;1dae	00 	. 
	defb 0c0h		;1daf	c0 	. 
	defb 060h		;1db0	60 	` 
	defb 030h		;1db1	30 	0 
	defb 018h		;1db2	18 	. 
	defb 030h		;1db3	30 	0 
	defb 060h		;1db4	60 	` 
	defb 0c0h		;1db5	c0 	. 
	defb 000h		;1db6	00 	. 
	defb 070h		;1db7	70 	p 
	defb 088h		;1db8	88 	. 
	defb 008h		;1db9	08 	. 
	defb 010h		;1dba	10 	. 
	defb 020h		;1dbb	20 	  
	defb 000h		;1dbc	00 	. 
	defb 020h		;1dbd	20 	  
	defb 000h		;1dbe	00 	. 
	defb 070h		;1dbf	70 	p 
	defb 088h		;1dc0	88 	. 
	defb 008h		;1dc1	08 	. 
	defb 068h		;1dc2	68 	h 
	defb 0a8h		;1dc3	a8 	. 
	defb 0a8h		;1dc4	a8 	. 
	defb 070h		;1dc5	70 	p 
	defb 000h		;1dc6	00 	. 
	defb 020h		;1dc7	20 	  
	defb 050h		;1dc8	50 	P 
	defb 088h		;1dc9	88 	. 
	defb 088h		;1dca	88 	. 
	defb 0f8h		;1dcb	f8 	. 
	defb 088h		;1dcc	88 	. 
	defb 088h		;1dcd	88 	. 
	defb 000h		;1dce	00 	. 
	defb 0f0h		;1dcf	f0 	. 
	defb 048h		;1dd0	48 	H 
	defb 048h		;1dd1	48 	H 
	defb 070h		;1dd2	70 	p 
	defb 048h		;1dd3	48 	H 
	defb 048h		;1dd4	48 	H 
	defb 0f0h		;1dd5	f0 	. 
	defb 000h		;1dd6	00 	. 
	defb 030h		;1dd7	30 	0 
	defb 048h		;1dd8	48 	H 
	defb 080h		;1dd9	80 	. 
	defb 080h		;1dda	80 	. 
	defb 080h		;1ddb	80 	. 
	defb 048h		;1ddc	48 	H 
	defb 030h		;1ddd	30 	0 
	defb 000h		;1dde	00 	. 
	defb 0e0h		;1ddf	e0 	. 
	defb 050h		;1de0	50 	P 
	defb 048h		;1de1	48 	H 
	defb 048h		;1de2	48 	H 
	defb 048h		;1de3	48 	H 
	defb 050h		;1de4	50 	P 
	defb 0e0h		;1de5	e0 	. 
	defb 000h		;1de6	00 	. 
	defb 0f8h		;1de7	f8 	. 
	defb 080h		;1de8	80 	. 
	defb 080h		;1de9	80 	. 
	defb 0f0h		;1dea	f0 	. 
	defb 080h		;1deb	80 	. 
	defb 080h		;1dec	80 	. 
	defb 0f8h		;1ded	f8 	. 
	defb 000h		;1dee	00 	. 
	defb 0f8h		;1def	f8 	. 
	defb 080h		;1df0	80 	. 
	defb 080h		;1df1	80 	. 
	defb 0f0h		;1df2	f0 	. 
	defb 080h		;1df3	80 	. 
	defb 080h		;1df4	80 	. 
	defb 080h		;1df5	80 	. 
	defb 000h		;1df6	00 	. 
	defb 070h		;1df7	70 	p 
	defb 088h		;1df8	88 	. 
	defb 080h		;1df9	80 	. 
	defb 0b8h		;1dfa	b8 	. 
	defb 088h		;1dfb	88 	. 
	defb 088h		;1dfc	88 	. 
	defb 070h		;1dfd	70 	p 
	defb 000h		;1dfe	00 	. 
	defb 088h		;1dff	88 	. 
	defb 088h		;1e00	88 	. 
	defb 088h		;1e01	88 	. 
	defb 0f8h		;1e02	f8 	. 
	defb 088h		;1e03	88 	. 
	defb 088h		;1e04	88 	. 
	defb 088h		;1e05	88 	. 
	defb 000h		;1e06	00 	. 
	defb 070h		;1e07	70 	p 
	defb 020h		;1e08	20 	  
	defb 020h		;1e09	20 	  
	defb 020h		;1e0a	20 	  
	defb 020h		;1e0b	20 	  
	defb 020h		;1e0c	20 	  
	defb 070h		;1e0d	70 	p 
	defb 000h		;1e0e	00 	. 
	defb 038h		;1e0f	38 	8 
	defb 010h		;1e10	10 	. 
	defb 010h		;1e11	10 	. 
	defb 010h		;1e12	10 	. 
	defb 090h		;1e13	90 	. 
	defb 090h		;1e14	90 	. 
	defb 060h		;1e15	60 	` 
	defb 000h		;1e16	00 	. 
	defb 088h		;1e17	88 	. 
	defb 090h		;1e18	90 	. 
	defb 0a0h		;1e19	a0 	. 
	defb 0c0h		;1e1a	c0 	. 
	defb 0a0h		;1e1b	a0 	. 
	defb 090h		;1e1c	90 	. 
	defb 088h		;1e1d	88 	. 
	defb 000h		;1e1e	00 	. 
	defb 080h		;1e1f	80 	. 
	defb 080h		;1e20	80 	. 
	defb 080h		;1e21	80 	. 
	defb 080h		;1e22	80 	. 
	defb 080h		;1e23	80 	. 
	defb 080h		;1e24	80 	. 
	defb 0f8h		;1e25	f8 	. 
	defb 000h		;1e26	00 	. 
	defb 088h		;1e27	88 	. 
	defb 0d8h		;1e28	d8 	. 
	defb 0a8h		;1e29	a8 	. 
	defb 0a8h		;1e2a	a8 	. 
	defb 088h		;1e2b	88 	. 
	defb 088h		;1e2c	88 	. 
	defb 088h		;1e2d	88 	. 
	defb 000h		;1e2e	00 	. 
	defb 088h		;1e2f	88 	. 
	defb 0c8h		;1e30	c8 	. 
	defb 0c8h		;1e31	c8 	. 
	defb 0a8h		;1e32	a8 	. 
	defb 098h		;1e33	98 	. 
	defb 098h		;1e34	98 	. 
	defb 088h		;1e35	88 	. 
	defb 000h		;1e36	00 	. 
	defb 070h		;1e37	70 	p 
	defb 088h		;1e38	88 	. 
	defb 088h		;1e39	88 	. 
	defb 088h		;1e3a	88 	. 
	defb 088h		;1e3b	88 	. 
	defb 088h		;1e3c	88 	. 
	defb 070h		;1e3d	70 	p 
	defb 000h		;1e3e	00 	. 
	defb 0f0h		;1e3f	f0 	. 
	defb 088h		;1e40	88 	. 
	defb 088h		;1e41	88 	. 
	defb 0f0h		;1e42	f0 	. 
	defb 080h		;1e43	80 	. 
	defb 080h		;1e44	80 	. 
	defb 080h		;1e45	80 	. 
	defb 000h		;1e46	00 	. 
	defb 070h		;1e47	70 	p 
	defb 088h		;1e48	88 	. 
	defb 088h		;1e49	88 	. 
	defb 088h		;1e4a	88 	. 
	defb 0a8h		;1e4b	a8 	. 
	defb 090h		;1e4c	90 	. 
	defb 068h		;1e4d	68 	h 
	defb 000h		;1e4e	00 	. 
	defb 0f0h		;1e4f	f0 	. 
	defb 088h		;1e50	88 	. 
	defb 088h		;1e51	88 	. 
	defb 0f0h		;1e52	f0 	. 
	defb 0a0h		;1e53	a0 	. 
	defb 090h		;1e54	90 	. 
	defb 088h		;1e55	88 	. 
	defb 000h		;1e56	00 	. 
	defb 070h		;1e57	70 	p 
	defb 088h		;1e58	88 	. 
	defb 080h		;1e59	80 	. 
	defb 070h		;1e5a	70 	p 
	defb 008h		;1e5b	08 	. 
	defb 088h		;1e5c	88 	. 
	defb 070h		;1e5d	70 	p 
	defb 000h		;1e5e	00 	. 
	defb 0f8h		;1e5f	f8 	. 
	defb 020h		;1e60	20 	  
	defb 020h		;1e61	20 	  
	defb 020h		;1e62	20 	  
	defb 020h		;1e63	20 	  
	defb 020h		;1e64	20 	  
	defb 020h		;1e65	20 	  
	defb 000h		;1e66	00 	. 
	defb 088h		;1e67	88 	. 
	defb 088h		;1e68	88 	. 
	defb 088h		;1e69	88 	. 
	defb 088h		;1e6a	88 	. 
	defb 088h		;1e6b	88 	. 
	defb 088h		;1e6c	88 	. 
	defb 070h		;1e6d	70 	p 
	defb 000h		;1e6e	00 	. 
	defb 088h		;1e6f	88 	. 
	defb 088h		;1e70	88 	. 
	defb 088h		;1e71	88 	. 
	defb 088h		;1e72	88 	. 
	defb 050h		;1e73	50 	P 
	defb 050h		;1e74	50 	P 
	defb 020h		;1e75	20 	  
	defb 000h		;1e76	00 	. 
	defb 088h		;1e77	88 	. 
	defb 088h		;1e78	88 	. 
	defb 088h		;1e79	88 	. 
	defb 0a8h		;1e7a	a8 	. 
	defb 0a8h		;1e7b	a8 	. 
	defb 0d8h		;1e7c	d8 	. 
	defb 088h		;1e7d	88 	. 
	defb 000h		;1e7e	00 	. 
	defb 088h		;1e7f	88 	. 
	defb 088h		;1e80	88 	. 
	defb 050h		;1e81	50 	P 
	defb 020h		;1e82	20 	  
	defb 050h		;1e83	50 	P 
	defb 088h		;1e84	88 	. 
	defb 088h		;1e85	88 	. 
	defb 000h		;1e86	00 	. 
	defb 088h		;1e87	88 	. 
	defb 088h		;1e88	88 	. 
	defb 088h		;1e89	88 	. 
	defb 070h		;1e8a	70 	p 
	defb 020h		;1e8b	20 	  
	defb 020h		;1e8c	20 	  
	defb 020h		;1e8d	20 	  
	defb 000h		;1e8e	00 	. 
	defb 0f8h		;1e8f	f8 	. 
	defb 008h		;1e90	08 	. 
	defb 010h		;1e91	10 	. 
	defb 020h		;1e92	20 	  
	defb 040h		;1e93	40 	@ 
	defb 080h		;1e94	80 	. 
	defb 0f8h		;1e95	f8 	. 
	defb 000h		;1e96	00 	. 
	defb 070h		;1e97	70 	p 
	defb 040h		;1e98	40 	@ 
	defb 040h		;1e99	40 	@ 
	defb 040h		;1e9a	40 	@ 
	defb 040h		;1e9b	40 	@ 
	defb 040h		;1e9c	40 	@ 
	defb 070h		;1e9d	70 	p 
	defb 000h		;1e9e	00 	. 
	defb 000h		;1e9f	00 	. 
	defb 000h		;1ea0	00 	. 
	defb 080h		;1ea1	80 	. 
	defb 040h		;1ea2	40 	@ 
	defb 020h		;1ea3	20 	  
	defb 010h		;1ea4	10 	. 
	defb 008h		;1ea5	08 	. 
	defb 000h		;1ea6	00 	. 
	defb 070h		;1ea7	70 	p 
	defb 010h		;1ea8	10 	. 
	defb 010h		;1ea9	10 	. 
	defb 010h		;1eaa	10 	. 
	defb 010h		;1eab	10 	. 
	defb 010h		;1eac	10 	. 
	defb 070h		;1ead	70 	p 
	defb 000h		;1eae	00 	. 
	defb 020h		;1eaf	20 	  
	defb 050h		;1eb0	50 	P 
	defb 088h		;1eb1	88 	. 
	defb 000h		;1eb2	00 	. 
	defb 000h		;1eb3	00 	. 
	defb 000h		;1eb4	00 	. 
	defb 000h		;1eb5	00 	. 
	defb 000h		;1eb6	00 	. 
	defb 000h		;1eb7	00 	. 
	defb 000h		;1eb8	00 	. 
	defb 000h		;1eb9	00 	. 
	defb 000h		;1eba	00 	. 
	defb 000h		;1ebb	00 	. 
	defb 000h		;1ebc	00 	. 
	defb 0f8h		;1ebd	f8 	. 
	defb 000h		;1ebe	00 	. 
	defb 040h		;1ebf	40 	@ 
	defb 020h		;1ec0	20 	  
	defb 010h		;1ec1	10 	. 
	defb 000h		;1ec2	00 	. 
	defb 000h		;1ec3	00 	. 
	defb 000h		;1ec4	00 	. 
	defb 000h		;1ec5	00 	. 
	defb 000h		;1ec6	00 	. 
	defb 000h		;1ec7	00 	. 
	defb 000h		;1ec8	00 	. 
	defb 070h		;1ec9	70 	p 
	defb 008h		;1eca	08 	. 
	defb 078h		;1ecb	78 	x 
	defb 088h		;1ecc	88 	. 
	defb 078h		;1ecd	78 	x 
	defb 000h		;1ece	00 	. 
	defb 080h		;1ecf	80 	. 
	defb 080h		;1ed0	80 	. 
	defb 0b0h		;1ed1	b0 	. 
	defb 0c8h		;1ed2	c8 	. 
	defb 088h		;1ed3	88 	. 
	defb 0c8h		;1ed4	c8 	. 
	defb 0b0h		;1ed5	b0 	. 
	defb 000h		;1ed6	00 	. 
	defb 000h		;1ed7	00 	. 
	defb 000h		;1ed8	00 	. 
	defb 070h		;1ed9	70 	p 
	defb 088h		;1eda	88 	. 
	defb 080h		;1edb	80 	. 
	defb 088h		;1edc	88 	. 
	defb 070h		;1edd	70 	p 
	defb 000h		;1ede	00 	. 
	defb 008h		;1edf	08 	. 
	defb 008h		;1ee0	08 	. 
	defb 068h		;1ee1	68 	h 
	defb 098h		;1ee2	98 	. 
	defb 088h		;1ee3	88 	. 
	defb 098h		;1ee4	98 	. 
	defb 068h		;1ee5	68 	h 
	defb 000h		;1ee6	00 	. 
	defb 000h		;1ee7	00 	. 
	defb 000h		;1ee8	00 	. 
	defb 070h		;1ee9	70 	p 
	defb 088h		;1eea	88 	. 
	defb 0f8h		;1eeb	f8 	. 
	defb 080h		;1eec	80 	. 
	defb 070h		;1eed	70 	p 
	defb 000h		;1eee	00 	. 
	defb 010h		;1eef	10 	. 
	defb 028h		;1ef0	28 	( 
	defb 020h		;1ef1	20 	  
	defb 0f8h		;1ef2	f8 	. 
	defb 020h		;1ef3	20 	  
	defb 020h		;1ef4	20 	  
	defb 020h		;1ef5	20 	  
	defb 000h		;1ef6	00 	. 
	defb 000h		;1ef7	00 	. 
	defb 000h		;1ef8	00 	. 
	defb 068h		;1ef9	68 	h 
	defb 098h		;1efa	98 	. 
	defb 098h		;1efb	98 	. 
	defb 068h		;1efc	68 	h 
	defb 008h		;1efd	08 	. 
	defb 070h		;1efe	70 	p 
	defb 080h		;1eff	80 	. 
	defb 080h		;1f00	80 	. 
	defb 0f0h		;1f01	f0 	. 
	defb 088h		;1f02	88 	. 
	defb 088h		;1f03	88 	. 
	defb 088h		;1f04	88 	. 
	defb 088h		;1f05	88 	. 
	defb 000h		;1f06	00 	. 
	defb 020h		;1f07	20 	  
	defb 000h		;1f08	00 	. 
	defb 060h		;1f09	60 	` 
	defb 020h		;1f0a	20 	  
	defb 020h		;1f0b	20 	  
	defb 020h		;1f0c	20 	  
	defb 070h		;1f0d	70 	p 
	defb 000h		;1f0e	00 	. 
	defb 010h		;1f0f	10 	. 
	defb 000h		;1f10	00 	. 
	defb 030h		;1f11	30 	0 
	defb 010h		;1f12	10 	. 
	defb 010h		;1f13	10 	. 
	defb 010h		;1f14	10 	. 
	defb 090h		;1f15	90 	. 
	defb 060h		;1f16	60 	` 
	defb 040h		;1f17	40 	@ 
	defb 040h		;1f18	40 	@ 
	defb 048h		;1f19	48 	H 
	defb 050h		;1f1a	50 	P 
	defb 060h		;1f1b	60 	` 
	defb 050h		;1f1c	50 	P 
	defb 048h		;1f1d	48 	H 
	defb 000h		;1f1e	00 	. 
	defb 060h		;1f1f	60 	` 
	defb 020h		;1f20	20 	  
	defb 020h		;1f21	20 	  
	defb 020h		;1f22	20 	  
	defb 020h		;1f23	20 	  
	defb 020h		;1f24	20 	  
	defb 070h		;1f25	70 	p 
	defb 000h		;1f26	00 	. 
	defb 000h		;1f27	00 	. 
	defb 000h		;1f28	00 	. 
	defb 0d0h		;1f29	d0 	. 
	defb 0a8h		;1f2a	a8 	. 
	defb 0a8h		;1f2b	a8 	. 
	defb 0a8h		;1f2c	a8 	. 
	defb 0a8h		;1f2d	a8 	. 
	defb 000h		;1f2e	00 	. 
	defb 000h		;1f2f	00 	. 
	defb 000h		;1f30	00 	. 
	defb 0b0h		;1f31	b0 	. 
	defb 0c8h		;1f32	c8 	. 
	defb 088h		;1f33	88 	. 
	defb 088h		;1f34	88 	. 
	defb 088h		;1f35	88 	. 
	defb 000h		;1f36	00 	. 
	defb 000h		;1f37	00 	. 
	defb 000h		;1f38	00 	. 
	defb 070h		;1f39	70 	p 
	defb 088h		;1f3a	88 	. 
	defb 088h		;1f3b	88 	. 
	defb 088h		;1f3c	88 	. 
	defb 070h		;1f3d	70 	p 
	defb 000h		;1f3e	00 	. 
	defb 000h		;1f3f	00 	. 
	defb 000h		;1f40	00 	. 
	defb 0b0h		;1f41	b0 	. 
	defb 0c8h		;1f42	c8 	. 
	defb 0c8h		;1f43	c8 	. 
	defb 0b0h		;1f44	b0 	. 
	defb 080h		;1f45	80 	. 
	defb 080h		;1f46	80 	. 
	defb 000h		;1f47	00 	. 
	defb 000h		;1f48	00 	. 
	defb 068h		;1f49	68 	h 
	defb 098h		;1f4a	98 	. 
	defb 098h		;1f4b	98 	. 
	defb 068h		;1f4c	68 	h 
	defb 008h		;1f4d	08 	. 
	defb 008h		;1f4e	08 	. 
	defb 000h		;1f4f	00 	. 
	defb 000h		;1f50	00 	. 
	defb 0b0h		;1f51	b0 	. 
	defb 0c8h		;1f52	c8 	. 
	defb 080h		;1f53	80 	. 
	defb 080h		;1f54	80 	. 
	defb 080h		;1f55	80 	. 
	defb 000h		;1f56	00 	. 
	defb 000h		;1f57	00 	. 
	defb 000h		;1f58	00 	. 
	defb 078h		;1f59	78 	x 
	defb 080h		;1f5a	80 	. 
	defb 0f0h		;1f5b	f0 	. 
	defb 008h		;1f5c	08 	. 
	defb 0f0h		;1f5d	f0 	. 
	defb 000h		;1f5e	00 	. 
	defb 040h		;1f5f	40 	@ 
	defb 040h		;1f60	40 	@ 
	defb 0f0h		;1f61	f0 	. 
	defb 040h		;1f62	40 	@ 
	defb 040h		;1f63	40 	@ 
	defb 048h		;1f64	48 	H 
	defb 030h		;1f65	30 	0 
	defb 000h		;1f66	00 	. 
	defb 000h		;1f67	00 	. 
	defb 000h		;1f68	00 	. 
	defb 090h		;1f69	90 	. 
	defb 090h		;1f6a	90 	. 
	defb 090h		;1f6b	90 	. 
	defb 090h		;1f6c	90 	. 
	defb 068h		;1f6d	68 	h 
	defb 000h		;1f6e	00 	. 
	defb 000h		;1f6f	00 	. 
	defb 000h		;1f70	00 	. 
	defb 088h		;1f71	88 	. 
	defb 088h		;1f72	88 	. 
	defb 088h		;1f73	88 	. 
	defb 050h		;1f74	50 	P 
	defb 020h		;1f75	20 	  
	defb 000h		;1f76	00 	. 
	defb 000h		;1f77	00 	. 
	defb 000h		;1f78	00 	. 
	defb 088h		;1f79	88 	. 
	defb 0a8h		;1f7a	a8 	. 
	defb 0a8h		;1f7b	a8 	. 
	defb 0a8h		;1f7c	a8 	. 
	defb 050h		;1f7d	50 	P 
	defb 000h		;1f7e	00 	. 
	defb 000h		;1f7f	00 	. 
	defb 000h		;1f80	00 	. 
	defb 088h		;1f81	88 	. 
	defb 050h		;1f82	50 	P 
	defb 020h		;1f83	20 	  
	defb 050h		;1f84	50 	P 
	defb 088h		;1f85	88 	. 
	defb 000h		;1f86	00 	. 
	defb 000h		;1f87	00 	. 
	defb 000h		;1f88	00 	. 
	defb 088h		;1f89	88 	. 
	defb 088h		;1f8a	88 	. 
	defb 098h		;1f8b	98 	. 
	defb 068h		;1f8c	68 	h 
	defb 008h		;1f8d	08 	. 
	defb 070h		;1f8e	70 	p 
	defb 000h		;1f8f	00 	. 
	defb 000h		;1f90	00 	. 
	defb 0f8h		;1f91	f8 	. 
	defb 010h		;1f92	10 	. 
	defb 020h		;1f93	20 	  
	defb 040h		;1f94	40 	@ 
	defb 0f8h		;1f95	f8 	. 
	defb 000h		;1f96	00 	. 
	defb 018h		;1f97	18 	. 
	defb 020h		;1f98	20 	  
	defb 020h		;1f99	20 	  
	defb 040h		;1f9a	40 	@ 
	defb 020h		;1f9b	20 	  
	defb 020h		;1f9c	20 	  
	defb 018h		;1f9d	18 	. 
	defb 000h		;1f9e	00 	. 
	defb 020h		;1f9f	20 	  
	defb 020h		;1fa0	20 	  
	defb 020h		;1fa1	20 	  
	defb 000h		;1fa2	00 	. 
	defb 020h		;1fa3	20 	  
	defb 020h		;1fa4	20 	  
	defb 020h		;1fa5	20 	  
	defb 000h		;1fa6	00 	. 
	defb 0c0h		;1fa7	c0 	. 
	defb 020h		;1fa8	20 	  
	defb 020h		;1fa9	20 	  
	defb 010h		;1faa	10 	. 
	defb 020h		;1fab	20 	  
	defb 020h		;1fac	20 	  
	defb 0c0h		;1fad	c0 	. 
	defb 000h		;1fae	00 	. 
	defb 040h		;1faf	40 	@ 
	defb 0a8h		;1fb0	a8 	. 
	defb 010h		;1fb1	10 	. 
	defb 000h		;1fb2	00 	. 
	defb 000h		;1fb3	00 	. 
	defb 000h		;1fb4	00 	. 
	defb 000h		;1fb5	00 	. 
	defb 000h		;1fb6	00 	. 
	defb 000h		;1fb7	00 	. 
	defb 000h		;1fb8	00 	. 
	defb 020h		;1fb9	20 	  
	defb 050h		;1fba	50 	P 
	defb 0f8h		;1fbb	f8 	. 
	defb 000h		;1fbc	00 	. 
	defb 000h		;1fbd	00 	. 
	defb 000h		;1fbe	00 	. 
	defb 070h		;1fbf	70 	p 
	defb 088h		;1fc0	88 	. 
	defb 080h		;1fc1	80 	. 
	defb 080h		;1fc2	80 	. 
	defb 088h		;1fc3	88 	. 
	defb 070h		;1fc4	70 	p 
	defb 020h		;1fc5	20 	  
	defb 060h		;1fc6	60 	` 
	defb 090h		;1fc7	90 	. 
	defb 000h		;1fc8	00 	. 
	defb 000h		;1fc9	00 	. 
	defb 090h		;1fca	90 	. 
	defb 090h		;1fcb	90 	. 
	defb 090h		;1fcc	90 	. 
	defb 068h		;1fcd	68 	h 
	defb 000h		;1fce	00 	. 
	defb 010h		;1fcf	10 	. 
	defb 020h		;1fd0	20 	  
	defb 070h		;1fd1	70 	p 
	defb 088h		;1fd2	88 	. 
	defb 0f8h		;1fd3	f8 	. 
	defb 080h		;1fd4	80 	. 
	defb 070h		;1fd5	70 	p 
	defb 000h		;1fd6	00 	. 
	defb 020h		;1fd7	20 	  
	defb 050h		;1fd8	50 	P 
	defb 070h		;1fd9	70 	p 
	defb 008h		;1fda	08 	. 
	defb 078h		;1fdb	78 	x 
	defb 088h		;1fdc	88 	. 
	defb 078h		;1fdd	78 	x 
	defb 000h		;1fde	00 	. 
	defb 048h		;1fdf	48 	H 
	defb 000h		;1fe0	00 	. 
	defb 070h		;1fe1	70 	p 
	defb 008h		;1fe2	08 	. 
	defb 078h		;1fe3	78 	x 
	defb 088h		;1fe4	88 	. 
	defb 078h		;1fe5	78 	x 
	defb 000h		;1fe6	00 	. 
	defb 020h		;1fe7	20 	  
	defb 010h		;1fe8	10 	. 
	defb 070h		;1fe9	70 	p 
	defb 008h		;1fea	08 	. 
	defb 078h		;1feb	78 	x 
	defb 088h		;1fec	88 	. 
	defb 078h		;1fed	78 	x 
	defb 000h		;1fee	00 	. 
	defb 020h		;1fef	20 	  
	defb 000h		;1ff0	00 	. 
	defb 070h		;1ff1	70 	p 
	defb 008h		;1ff2	08 	. 
	defb 078h		;1ff3	78 	x 
	defb 088h		;1ff4	88 	. 
	defb 078h		;1ff5	78 	x 
	defb 000h		;1ff6	00 	. 
	defb 000h		;1ff7	00 	. 
	defb 070h		;1ff8	70 	p 
	defb 080h		;1ff9	80 	. 
	defb 080h		;1ffa	80 	. 
	defb 080h		;1ffb	80 	. 
	defb 070h		;1ffc	70 	p 
	defb 010h		;1ffd	10 	. 
	defb 060h		;1ffe	60 	` 
	defb 020h		;1fff	20 	  
l2000h:
	defb 050h		;2000	50 	P 
	defb 070h		;2001	70 	p 
	defb 088h		;2002	88 	. 
	defb 0f8h		;2003	f8 	. 
	defb 080h		;2004	80 	. 
	defb 070h		;2005	70 	p 
	defb 000h		;2006	00 	. 
	defb 050h		;2007	50 	P 
l2008h:
	defb 000h		;2008	00 	. 
	defb 070h		;2009	70 	p 
	defb 088h		;200a	88 	. 
	defb 0f8h		;200b	f8 	. 
	defb 080h		;200c	80 	. 
	defb 070h		;200d	70 	p 
	defb 000h		;200e	00 	. 
	defb 020h		;200f	20 	  
	defb 010h		;2010	10 	. 
	defb 070h		;2011	70 	p 
	defb 088h		;2012	88 	. 
	defb 0f8h		;2013	f8 	. 
	defb 080h		;2014	80 	. 
	defb 070h		;2015	70 	p 
	defb 000h		;2016	00 	. 
	defb 050h		;2017	50 	P 
	defb 000h		;2018	00 	. 
	defb 000h		;2019	00 	. 
	defb 060h		;201a	60 	` 
	defb 020h		;201b	20 	  
	defb 020h		;201c	20 	  
	defb 070h		;201d	70 	p 
	defb 000h		;201e	00 	. 
	defb 020h		;201f	20 	  
	defb 050h		;2020	50 	P 
	defb 000h		;2021	00 	. 
	defb 060h		;2022	60 	` 
	defb 020h		;2023	20 	  
	defb 020h		;2024	20 	  
	defb 070h		;2025	70 	p 
	defb 000h		;2026	00 	. 
	defb 040h		;2027	40 	@ 
	defb 020h		;2028	20 	  
	defb 000h		;2029	00 	. 
	defb 060h		;202a	60 	` 
	defb 020h		;202b	20 	  
	defb 020h		;202c	20 	  
	defb 070h		;202d	70 	p 
	defb 000h		;202e	00 	. 
	defb 050h		;202f	50 	P 
	defb 000h		;2030	00 	. 
	defb 020h		;2031	20 	  
	defb 050h		;2032	50 	P 
	defb 088h		;2033	88 	. 
	defb 0f8h		;2034	f8 	. 
	defb 088h		;2035	88 	. 
	defb 000h		;2036	00 	. 
	defb 020h		;2037	20 	  
	defb 000h		;2038	00 	. 
	defb 020h		;2039	20 	  
	defb 050h		;203a	50 	P 
	defb 088h		;203b	88 	. 
	defb 0f8h		;203c	f8 	. 
	defb 088h		;203d	88 	. 
	defb 000h		;203e	00 	. 
	defb 010h		;203f	10 	. 
	defb 020h		;2040	20 	  
	defb 0f8h		;2041	f8 	. 
	defb 080h		;2042	80 	. 
	defb 0f0h		;2043	f0 	. 
	defb 080h		;2044	80 	. 
	defb 0f8h		;2045	f8 	. 
	defb 000h		;2046	00 	. 
	defb 000h		;2047	00 	. 
	defb 000h		;2048	00 	. 
	defb 06ch		;2049	6c 	l 
	defb 012h		;204a	12 	. 
	defb 07eh		;204b	7e 	~ 
	defb 090h		;204c	90 	. 
	defb 06eh		;204d	6e 	n 
	defb 000h		;204e	00 	. 
	defb 03eh		;204f	3e 	> 
	defb 050h		;2050	50 	P 
	defb 090h		;2051	90 	. 
	defb 09ch		;2052	9c 	. 
	defb 0f0h		;2053	f0 	. 
	defb 090h		;2054	90 	. 
	defb 09eh		;2055	9e 	. 
	defb 000h		;2056	00 	. 
	defb 060h		;2057	60 	` 
	defb 090h		;2058	90 	. 
	defb 000h		;2059	00 	. 
	defb 060h		;205a	60 	` 
	defb 090h		;205b	90 	. 
	defb 090h		;205c	90 	. 
	defb 060h		;205d	60 	` 
	defb 000h		;205e	00 	. 
	defb 090h		;205f	90 	. 
	defb 000h		;2060	00 	. 
	defb 000h		;2061	00 	. 
	defb 060h		;2062	60 	` 
	defb 090h		;2063	90 	. 
	defb 090h		;2064	90 	. 
	defb 060h		;2065	60 	` 
	defb 000h		;2066	00 	. 
	defb 040h		;2067	40 	@ 
	defb 020h		;2068	20 	  
	defb 000h		;2069	00 	. 
	defb 060h		;206a	60 	` 
	defb 090h		;206b	90 	. 
	defb 090h		;206c	90 	. 
	defb 060h		;206d	60 	` 
	defb 000h		;206e	00 	. 
	defb 040h		;206f	40 	@ 
	defb 0a0h		;2070	a0 	. 
	defb 000h		;2071	00 	. 
	defb 0a0h		;2072	a0 	. 
	defb 0a0h		;2073	a0 	. 
	defb 0a0h		;2074	a0 	. 
	defb 050h		;2075	50 	P 
	defb 000h		;2076	00 	. 
	defb 040h		;2077	40 	@ 
	defb 020h		;2078	20 	  
	defb 000h		;2079	00 	. 
	defb 0a0h		;207a	a0 	. 
	defb 0a0h		;207b	a0 	. 
	defb 0a0h		;207c	a0 	. 
	defb 050h		;207d	50 	P 
	defb 000h		;207e	00 	. 
	defb 090h		;207f	90 	. 
	defb 000h		;2080	00 	. 
	defb 090h		;2081	90 	. 
	defb 090h		;2082	90 	. 
	defb 0b0h		;2083	b0 	. 
	defb 050h		;2084	50 	P 
	defb 010h		;2085	10 	. 
	defb 0e0h		;2086	e0 	. 
	defb 050h		;2087	50 	P 
	defb 000h		;2088	00 	. 
	defb 070h		;2089	70 	p 
	defb 088h		;208a	88 	. 
	defb 088h		;208b	88 	. 
	defb 088h		;208c	88 	. 
	defb 070h		;208d	70 	p 
	defb 000h		;208e	00 	. 
	defb 050h		;208f	50 	P 
	defb 000h		;2090	00 	. 
	defb 088h		;2091	88 	. 
	defb 088h		;2092	88 	. 
	defb 088h		;2093	88 	. 
	defb 088h		;2094	88 	. 
	defb 070h		;2095	70 	p 
	defb 000h		;2096	00 	. 
	defb 020h		;2097	20 	  
	defb 020h		;2098	20 	  
	defb 078h		;2099	78 	x 
	defb 080h		;209a	80 	. 
	defb 080h		;209b	80 	. 
	defb 078h		;209c	78 	x 
	defb 020h		;209d	20 	  
	defb 020h		;209e	20 	  
	defb 018h		;209f	18 	. 
	defb 024h		;20a0	24 	$ 
	defb 020h		;20a1	20 	  
	defb 0f8h		;20a2	f8 	. 
	defb 020h		;20a3	20 	  
	defb 0e2h		;20a4	e2 	. 
	defb 05ch		;20a5	5c 	\ 
	defb 000h		;20a6	00 	. 
	defb 088h		;20a7	88 	. 
	defb 050h		;20a8	50 	P 
	defb 020h		;20a9	20 	  
	defb 0f8h		;20aa	f8 	. 
	defb 020h		;20ab	20 	  
	defb 0f8h		;20ac	f8 	. 
	defb 020h		;20ad	20 	  
	defb 000h		;20ae	00 	. 
	defb 0c0h		;20af	c0 	. 
	defb 0a0h		;20b0	a0 	. 
	defb 0a0h		;20b1	a0 	. 
	defb 0c8h		;20b2	c8 	. 
	defb 09ch		;20b3	9c 	. 
	defb 088h		;20b4	88 	. 
	defb 088h		;20b5	88 	. 
	defb 08ch		;20b6	8c 	. 
	defb 018h		;20b7	18 	. 
	defb 020h		;20b8	20 	  
	defb 020h		;20b9	20 	  
	defb 0f8h		;20ba	f8 	. 
	defb 020h		;20bb	20 	  
	defb 020h		;20bc	20 	  
	defb 020h		;20bd	20 	  
	defb 040h		;20be	40 	@ 
	defb 010h		;20bf	10 	. 
	defb 020h		;20c0	20 	  
	defb 070h		;20c1	70 	p 
	defb 008h		;20c2	08 	. 
	defb 078h		;20c3	78 	x 
	defb 088h		;20c4	88 	. 
	defb 078h		;20c5	78 	x 
	defb 000h		;20c6	00 	. 
	defb 010h		;20c7	10 	. 
	defb 020h		;20c8	20 	  
	defb 000h		;20c9	00 	. 
	defb 060h		;20ca	60 	` 
	defb 020h		;20cb	20 	  
	defb 020h		;20cc	20 	  
	defb 070h		;20cd	70 	p 
	defb 000h		;20ce	00 	. 
	defb 020h		;20cf	20 	  
	defb 040h		;20d0	40 	@ 
	defb 000h		;20d1	00 	. 
	defb 060h		;20d2	60 	` 
	defb 090h		;20d3	90 	. 
	defb 090h		;20d4	90 	. 
	defb 060h		;20d5	60 	` 
	defb 000h		;20d6	00 	. 
	defb 020h		;20d7	20 	  
	defb 040h		;20d8	40 	@ 
	defb 000h		;20d9	00 	. 
	defb 090h		;20da	90 	. 
	defb 090h		;20db	90 	. 
	defb 090h		;20dc	90 	. 
	defb 068h		;20dd	68 	h 
	defb 000h		;20de	00 	. 
	defb 050h		;20df	50 	P 
	defb 0a0h		;20e0	a0 	. 
	defb 000h		;20e1	00 	. 
	defb 0a0h		;20e2	a0 	. 
	defb 0d0h		;20e3	d0 	. 
	defb 090h		;20e4	90 	. 
	defb 090h		;20e5	90 	. 
	defb 000h		;20e6	00 	. 
	defb 028h		;20e7	28 	( 
	defb 050h		;20e8	50 	P 
	defb 000h		;20e9	00 	. 
	defb 0c8h		;20ea	c8 	. 
	defb 0a8h		;20eb	a8 	. 
	defb 098h		;20ec	98 	. 
	defb 088h		;20ed	88 	. 
	defb 000h		;20ee	00 	. 
	defb 000h		;20ef	00 	. 
	defb 070h		;20f0	70 	p 
	defb 008h		;20f1	08 	. 
	defb 078h		;20f2	78 	x 
	defb 088h		;20f3	88 	. 
	defb 078h		;20f4	78 	x 
	defb 000h		;20f5	00 	. 
	defb 0f8h		;20f6	f8 	. 
	defb 000h		;20f7	00 	. 
	defb 060h		;20f8	60 	` 
	defb 090h		;20f9	90 	. 
	defb 090h		;20fa	90 	. 
	defb 090h		;20fb	90 	. 
	defb 060h		;20fc	60 	` 
	defb 000h		;20fd	00 	. 
	defb 0f0h		;20fe	f0 	. 
	defb 020h		;20ff	20 	  
	defb 000h		;2100	00 	. 
	defb 020h		;2101	20 	  
	defb 040h		;2102	40 	@ 
	defb 080h		;2103	80 	. 
	defb 088h		;2104	88 	. 
	defb 070h		;2105	70 	p 
	defb 000h		;2106	00 	. 
	defb 000h		;2107	00 	. 
	defb 000h		;2108	00 	. 
	defb 000h		;2109	00 	. 
	defb 0f8h		;210a	f8 	. 
	defb 080h		;210b	80 	. 
	defb 080h		;210c	80 	. 
	defb 000h		;210d	00 	. 
	defb 000h		;210e	00 	. 
	defb 000h		;210f	00 	. 
	defb 000h		;2110	00 	. 
	defb 000h		;2111	00 	. 
	defb 0f8h		;2112	f8 	. 
	defb 008h		;2113	08 	. 
	defb 008h		;2114	08 	. 
	defb 000h		;2115	00 	. 
	defb 000h		;2116	00 	. 
	defb 084h		;2117	84 	. 
	defb 088h		;2118	88 	. 
	defb 090h		;2119	90 	. 
	defb 0a8h		;211a	a8 	. 
	defb 054h		;211b	54 	T 
	defb 084h		;211c	84 	. 
	defb 008h		;211d	08 	. 
	defb 01ch		;211e	1c 	. 
	defb 084h		;211f	84 	. 
	defb 088h		;2120	88 	. 
	defb 090h		;2121	90 	. 
	defb 0a8h		;2122	a8 	. 
	defb 058h		;2123	58 	X 
	defb 0a8h		;2124	a8 	. 
	defb 03ch		;2125	3c 	< 
	defb 008h		;2126	08 	. 
	defb 020h		;2127	20 	  
	defb 000h		;2128	00 	. 
	defb 000h		;2129	00 	. 
	defb 020h		;212a	20 	  
	defb 020h		;212b	20 	  
	defb 020h		;212c	20 	  
	defb 020h		;212d	20 	  
	defb 000h		;212e	00 	. 
	defb 000h		;212f	00 	. 
	defb 000h		;2130	00 	. 
	defb 024h		;2131	24 	$ 
	defb 048h		;2132	48 	H 
	defb 090h		;2133	90 	. 
	defb 048h		;2134	48 	H 
	defb 024h		;2135	24 	$ 
	defb 000h		;2136	00 	. 
	defb 000h		;2137	00 	. 
	defb 000h		;2138	00 	. 
	defb 090h		;2139	90 	. 
	defb 048h		;213a	48 	H 
	defb 024h		;213b	24 	$ 
	defb 048h		;213c	48 	H 
	defb 090h		;213d	90 	. 
	defb 000h		;213e	00 	. 
	defb 028h		;213f	28 	( 
	defb 050h		;2140	50 	P 
	defb 020h		;2141	20 	  
	defb 050h		;2142	50 	P 
	defb 088h		;2143	88 	. 
	defb 0f8h		;2144	f8 	. 
	defb 088h		;2145	88 	. 
	defb 000h		;2146	00 	. 
	defb 028h		;2147	28 	( 
	defb 050h		;2148	50 	P 
	defb 070h		;2149	70 	p 
	defb 008h		;214a	08 	. 
	defb 078h		;214b	78 	x 
	defb 088h		;214c	88 	. 
	defb 078h		;214d	78 	x 
	defb 000h		;214e	00 	. 
	defb 028h		;214f	28 	( 
	defb 050h		;2150	50 	P 
	defb 000h		;2151	00 	. 
	defb 070h		;2152	70 	p 
	defb 020h		;2153	20 	  
	defb 020h		;2154	20 	  
	defb 070h		;2155	70 	p 
	defb 000h		;2156	00 	. 
	defb 028h		;2157	28 	( 
	defb 050h		;2158	50 	P 
	defb 000h		;2159	00 	. 
	defb 020h		;215a	20 	  
	defb 020h		;215b	20 	  
	defb 020h		;215c	20 	  
	defb 070h		;215d	70 	p 
	defb 000h		;215e	00 	. 
	defb 028h		;215f	28 	( 
	defb 050h		;2160	50 	P 
	defb 000h		;2161	00 	. 
	defb 070h		;2162	70 	p 
	defb 088h		;2163	88 	. 
	defb 088h		;2164	88 	. 
	defb 070h		;2165	70 	p 
	defb 000h		;2166	00 	. 
	defb 050h		;2167	50 	P 
	defb 0a0h		;2168	a0 	. 
	defb 000h		;2169	00 	. 
	defb 060h		;216a	60 	` 
	defb 090h		;216b	90 	. 
	defb 090h		;216c	90 	. 
	defb 060h		;216d	60 	` 
	defb 000h		;216e	00 	. 
	defb 028h		;216f	28 	( 
	defb 050h		;2170	50 	P 
	defb 000h		;2171	00 	. 
	defb 088h		;2172	88 	. 
	defb 088h		;2173	88 	. 
	defb 088h		;2174	88 	. 
	defb 070h		;2175	70 	p 
	defb 000h		;2176	00 	. 
	defb 050h		;2177	50 	P 
	defb 0a0h		;2178	a0 	. 
	defb 000h		;2179	00 	. 
	defb 0a0h		;217a	a0 	. 
	defb 0a0h		;217b	a0 	. 
	defb 0a0h		;217c	a0 	. 
	defb 050h		;217d	50 	P 
	defb 000h		;217e	00 	. 
	defb 0fch		;217f	fc 	. 
	defb 048h		;2180	48 	H 
	defb 048h		;2181	48 	H 
	defb 048h		;2182	48 	H 
	defb 0e8h		;2183	e8 	. 
	defb 008h		;2184	08 	. 
	defb 050h		;2185	50 	P 
	defb 020h		;2186	20 	  
	defb 000h		;2187	00 	. 
	defb 050h		;2188	50 	P 
	defb 000h		;2189	00 	. 
	defb 050h		;218a	50 	P 
	defb 050h		;218b	50 	P 
	defb 050h		;218c	50 	P 
	defb 010h		;218d	10 	. 
	defb 020h		;218e	20 	  
	defb 0c0h		;218f	c0 	. 
	defb 044h		;2190	44 	D 
	defb 0c8h		;2191	c8 	. 
	defb 054h		;2192	54 	T 
	defb 0ech		;2193	ec 	. 
	defb 054h		;2194	54 	T 
	defb 09eh		;2195	9e 	. 
	defb 004h		;2196	04 	. 
	defb 010h		;2197	10 	. 
	defb 0a8h		;2198	a8 	. 
	defb 040h		;2199	40 	@ 
	defb 000h		;219a	00 	. 
	defb 000h		;219b	00 	. 
	defb 000h		;219c	00 	. 
	defb 000h		;219d	00 	. 
	defb 000h		;219e	00 	. 
	defb 000h		;219f	00 	. 
	defb 020h		;21a0	20 	  
	defb 050h		;21a1	50 	P 
	defb 088h		;21a2	88 	. 
	defb 050h		;21a3	50 	P 
	defb 020h		;21a4	20 	  
	defb 000h		;21a5	00 	. 
	defb 000h		;21a6	00 	. 
	defb 088h		;21a7	88 	. 
	defb 010h		;21a8	10 	. 
	defb 020h		;21a9	20 	  
	defb 040h		;21aa	40 	@ 
	defb 080h		;21ab	80 	. 
	defb 028h		;21ac	28 	( 
	defb 000h		;21ad	00 	. 
	defb 000h		;21ae	00 	. 
	defb 07ch		;21af	7c 	| 
	defb 0a8h		;21b0	a8 	. 
	defb 0a8h		;21b1	a8 	. 
	defb 068h		;21b2	68 	h 
	defb 028h		;21b3	28 	( 
	defb 028h		;21b4	28 	( 
	defb 028h		;21b5	28 	( 
	defb 000h		;21b6	00 	. 
	defb 038h		;21b7	38 	8 
	defb 040h		;21b8	40 	@ 
	defb 030h		;21b9	30 	0 
	defb 048h		;21ba	48 	H 
	defb 048h		;21bb	48 	H 
	defb 030h		;21bc	30 	0 
	defb 008h		;21bd	08 	. 
	defb 070h		;21be	70 	p 
	defb 000h		;21bf	00 	. 
	defb 000h		;21c0	00 	. 
	defb 000h		;21c1	00 	. 
	defb 000h		;21c2	00 	. 
	defb 000h		;21c3	00 	. 
	defb 000h		;21c4	00 	. 
	defb 0ffh		;21c5	ff 	. 
	defb 0ffh		;21c6	ff 	. 
	defb 0f0h		;21c7	f0 	. 
	defb 0f0h		;21c8	f0 	. 
	defb 0f0h		;21c9	f0 	. 
	defb 0f0h		;21ca	f0 	. 
	defb 00fh		;21cb	0f 	. 
	defb 00fh		;21cc	0f 	. 
	defb 00fh		;21cd	0f 	. 
	defb 00fh		;21ce	0f 	. 
	defb 000h		;21cf	00 	. 
	defb 000h		;21d0	00 	. 
	defb 0ffh		;21d1	ff 	. 
	defb 0ffh		;21d2	ff 	. 
	defb 0ffh		;21d3	ff 	. 
	defb 0ffh		;21d4	ff 	. 
	defb 0ffh		;21d5	ff 	. 
	defb 0ffh		;21d6	ff 	. 
	defb 0ffh		;21d7	ff 	. 
	defb 0ffh		;21d8	ff 	. 
	defb 000h		;21d9	00 	. 
	defb 000h		;21da	00 	. 
	defb 000h		;21db	00 	. 
	defb 000h		;21dc	00 	. 
	defb 000h		;21dd	00 	. 
	defb 000h		;21de	00 	. 
	defb 000h		;21df	00 	. 
	defb 000h		;21e0	00 	. 
	defb 000h		;21e1	00 	. 
	defb 03ch		;21e2	3c 	< 
	defb 03ch		;21e3	3c 	< 
	defb 000h		;21e4	00 	. 
	defb 000h		;21e5	00 	. 
	defb 000h		;21e6	00 	. 
	defb 0ffh		;21e7	ff 	. 
	defb 0ffh		;21e8	ff 	. 
	defb 0ffh		;21e9	ff 	. 
	defb 0ffh		;21ea	ff 	. 
	defb 0ffh		;21eb	ff 	. 
	defb 0ffh		;21ec	ff 	. 
	defb 000h		;21ed	00 	. 
	defb 000h		;21ee	00 	. 
	defb 0c0h		;21ef	c0 	. 
	defb 0c0h		;21f0	c0 	. 
	defb 0c0h		;21f1	c0 	. 
	defb 0c0h		;21f2	c0 	. 
	defb 0c0h		;21f3	c0 	. 
	defb 0c0h		;21f4	c0 	. 
	defb 0c0h		;21f5	c0 	. 
	defb 0c0h		;21f6	c0 	. 
	defb 00fh		;21f7	0f 	. 
	defb 00fh		;21f8	0f 	. 
	defb 00fh		;21f9	0f 	. 
	defb 00fh		;21fa	0f 	. 
	defb 0f0h		;21fb	f0 	. 
	defb 0f0h		;21fc	f0 	. 
	defb 0f0h		;21fd	f0 	. 
	defb 0f0h		;21fe	f0 	. 
	defb 0fch		;21ff	fc 	. 
	defb 0fch		;2200	fc 	. 
	defb 0fch		;2201	fc 	. 
	defb 0fch		;2202	fc 	. 
	defb 0fch		;2203	fc 	. 
	defb 0fch		;2204	fc 	. 
	defb 0fch		;2205	fc 	. 
	defb 0fch		;2206	fc 	. 
	defb 003h		;2207	03 	. 
	defb 003h		;2208	03 	. 
	defb 003h		;2209	03 	. 
	defb 003h		;220a	03 	. 
	defb 003h		;220b	03 	. 
	defb 003h		;220c	03 	. 
	defb 003h		;220d	03 	. 
	defb 003h		;220e	03 	. 
	defb 03fh		;220f	3f 	? 
	defb 03fh		;2210	3f 	? 
	defb 03fh		;2211	3f 	? 
	defb 03fh		;2212	3f 	? 
	defb 03fh		;2213	3f 	? 
	defb 03fh		;2214	3f 	? 
	defb 03fh		;2215	3f 	? 
	defb 03fh		;2216	3f 	? 
	defb 011h		;2217	11 	. 
	defb 022h		;2218	22 	" 
	defb 044h		;2219	44 	D 
	defb 088h		;221a	88 	. 
	defb 011h		;221b	11 	. 
	defb 022h		;221c	22 	" 
	defb 044h		;221d	44 	D 
	defb 088h		;221e	88 	. 
	defb 088h		;221f	88 	. 
	defb 044h		;2220	44 	D 
	defb 022h		;2221	22 	" 
	defb 011h		;2222	11 	. 
	defb 088h		;2223	88 	. 
	defb 044h		;2224	44 	D 
	defb 022h		;2225	22 	" 
	defb 011h		;2226	11 	. 
	defb 0feh		;2227	fe 	. 
	defb 07ch		;2228	7c 	| 
	defb 038h		;2229	38 	8 
	defb 010h		;222a	10 	. 
	defb 000h		;222b	00 	. 
	defb 000h		;222c	00 	. 
	defb 000h		;222d	00 	. 
	defb 000h		;222e	00 	. 
	defb 000h		;222f	00 	. 
	defb 000h		;2230	00 	. 
	defb 000h		;2231	00 	. 
	defb 000h		;2232	00 	. 
	defb 010h		;2233	10 	. 
	defb 038h		;2234	38 	8 
	defb 07ch		;2235	7c 	| 
	defb 0feh		;2236	fe 	. 
	defb 080h		;2237	80 	. 
	defb 0c0h		;2238	c0 	. 
	defb 0e0h		;2239	e0 	. 
	defb 0f0h		;223a	f0 	. 
	defb 0e0h		;223b	e0 	. 
	defb 0c0h		;223c	c0 	. 
	defb 080h		;223d	80 	. 
	defb 000h		;223e	00 	. 
	defb 001h		;223f	01 	. 
	defb 003h		;2240	03 	. 
	defb 007h		;2241	07 	. 
	defb 00fh		;2242	0f 	. 
	defb 007h		;2243	07 	. 
	defb 003h		;2244	03 	. 
	defb 001h		;2245	01 	. 
	defb 000h		;2246	00 	. 
	defb 0ffh		;2247	ff 	. 
	defb 07eh		;2248	7e 	~ 
	defb 03ch		;2249	3c 	< 
	defb 018h		;224a	18 	. 
	defb 018h		;224b	18 	. 
	defb 03ch		;224c	3c 	< 
	defb 07eh		;224d	7e 	~ 
	defb 0ffh		;224e	ff 	. 
	defb 081h		;224f	81 	. 
	defb 0c3h		;2250	c3 	. 
	defb 0e7h		;2251	e7 	. 
	defb 0ffh		;2252	ff 	. 
	defb 0ffh		;2253	ff 	. 
	defb 0e7h		;2254	e7 	. 
	defb 0c3h		;2255	c3 	. 
	defb 081h		;2256	81 	. 
	defb 0f0h		;2257	f0 	. 
	defb 0f0h		;2258	f0 	. 
	defb 0f0h		;2259	f0 	. 
	defb 0f0h		;225a	f0 	. 
	defb 000h		;225b	00 	. 
	defb 000h		;225c	00 	. 
	defb 000h		;225d	00 	. 
	defb 000h		;225e	00 	. 
	defb 000h		;225f	00 	. 
	defb 000h		;2260	00 	. 
	defb 000h		;2261	00 	. 
	defb 000h		;2262	00 	. 
	defb 00fh		;2263	0f 	. 
	defb 00fh		;2264	0f 	. 
	defb 00fh		;2265	0f 	. 
	defb 00fh		;2266	0f 	. 
	defb 00fh		;2267	0f 	. 
	defb 00fh		;2268	0f 	. 
	defb 00fh		;2269	0f 	. 
	defb 00fh		;226a	0f 	. 
	defb 000h		;226b	00 	. 
	defb 000h		;226c	00 	. 
	defb 000h		;226d	00 	. 
	defb 000h		;226e	00 	. 
	defb 000h		;226f	00 	. 
	defb 000h		;2270	00 	. 
	defb 000h		;2271	00 	. 
	defb 000h		;2272	00 	. 
	defb 0f0h		;2273	f0 	. 
	defb 0f0h		;2274	f0 	. 
	defb 0f0h		;2275	f0 	. 
	defb 0f0h		;2276	f0 	. 
	defb 033h		;2277	33 	3 
	defb 033h		;2278	33 	3 
	defb 0cch		;2279	cc 	. 
	defb 0cch		;227a	cc 	. 
	defb 033h		;227b	33 	3 
	defb 033h		;227c	33 	3 
	defb 0cch		;227d	cc 	. 
	defb 0cch		;227e	cc 	. 
	defb 000h		;227f	00 	. 
	defb 020h		;2280	20 	  
	defb 020h		;2281	20 	  
	defb 050h		;2282	50 	P 
	defb 050h		;2283	50 	P 
	defb 088h		;2284	88 	. 
	defb 0f8h		;2285	f8 	. 
	defb 000h		;2286	00 	. 
	defb 020h		;2287	20 	  
	defb 020h		;2288	20 	  
	defb 070h		;2289	70 	p 
	defb 020h		;228a	20 	  
	defb 070h		;228b	70 	p 
	defb 020h		;228c	20 	  
	defb 020h		;228d	20 	  
	defb 000h		;228e	00 	. 
	defb 000h		;228f	00 	. 
	defb 000h		;2290	00 	. 
	defb 000h		;2291	00 	. 
	defb 050h		;2292	50 	P 
	defb 088h		;2293	88 	. 
	defb 0a8h		;2294	a8 	. 
	defb 050h		;2295	50 	P 
	defb 000h		;2296	00 	. 
	defb 0ffh		;2297	ff 	. 
	defb 0ffh		;2298	ff 	. 
	defb 0ffh		;2299	ff 	. 
	defb 0ffh		;229a	ff 	. 
	defb 0ffh		;229b	ff 	. 
	defb 0ffh		;229c	ff 	. 
	defb 0ffh		;229d	ff 	. 
	defb 0ffh		;229e	ff 	. 
	defb 000h		;229f	00 	. 
	defb 000h		;22a0	00 	. 
	defb 000h		;22a1	00 	. 
	defb 000h		;22a2	00 	. 
	defb 0ffh		;22a3	ff 	. 
	defb 0ffh		;22a4	ff 	. 
	defb 0ffh		;22a5	ff 	. 
	defb 0ffh		;22a6	ff 	. 
	defb 0f0h		;22a7	f0 	. 
	defb 0f0h		;22a8	f0 	. 
	defb 0f0h		;22a9	f0 	. 
	defb 0f0h		;22aa	f0 	. 
	defb 0f0h		;22ab	f0 	. 
	defb 0f0h		;22ac	f0 	. 
	defb 0f0h		;22ad	f0 	. 
	defb 0f0h		;22ae	f0 	. 
	defb 00fh		;22af	0f 	. 
	defb 00fh		;22b0	0f 	. 
	defb 00fh		;22b1	0f 	. 
	defb 00fh		;22b2	0f 	. 
	defb 00fh		;22b3	0f 	. 
	defb 00fh		;22b4	0f 	. 
	defb 00fh		;22b5	0f 	. 
	defb 00fh		;22b6	0f 	. 
	defb 0ffh		;22b7	ff 	. 
	defb 0ffh		;22b8	ff 	. 
	defb 0ffh		;22b9	ff 	. 
	defb 0ffh		;22ba	ff 	. 
	defb 000h		;22bb	00 	. 
	defb 000h		;22bc	00 	. 
	defb 000h		;22bd	00 	. 
	defb 000h		;22be	00 	. 
	defb 000h		;22bf	00 	. 
	defb 000h		;22c0	00 	. 
	defb 068h		;22c1	68 	h 
	defb 090h		;22c2	90 	. 
	defb 090h		;22c3	90 	. 
	defb 090h		;22c4	90 	. 
	defb 068h		;22c5	68 	h 
	defb 000h		;22c6	00 	. 
	defb 030h		;22c7	30 	0 
	defb 048h		;22c8	48 	H 
	defb 048h		;22c9	48 	H 
	defb 070h		;22ca	70 	p 
	defb 048h		;22cb	48 	H 
	defb 048h		;22cc	48 	H 
	defb 070h		;22cd	70 	p 
	defb 0c0h		;22ce	c0 	. 
	defb 0f8h		;22cf	f8 	. 
	defb 088h		;22d0	88 	. 
	defb 080h		;22d1	80 	. 
	defb 080h		;22d2	80 	. 
	defb 080h		;22d3	80 	. 
	defb 080h		;22d4	80 	. 
	defb 080h		;22d5	80 	. 
	defb 000h		;22d6	00 	. 
	defb 0f8h		;22d7	f8 	. 
	defb 050h		;22d8	50 	P 
	defb 050h		;22d9	50 	P 
	defb 050h		;22da	50 	P 
	defb 050h		;22db	50 	P 
	defb 050h		;22dc	50 	P 
	defb 098h		;22dd	98 	. 
	defb 000h		;22de	00 	. 
	defb 0f8h		;22df	f8 	. 
	defb 088h		;22e0	88 	. 
	defb 040h		;22e1	40 	@ 
	defb 020h		;22e2	20 	  
	defb 040h		;22e3	40 	@ 
	defb 088h		;22e4	88 	. 
	defb 0f8h		;22e5	f8 	. 
	defb 000h		;22e6	00 	. 
	defb 000h		;22e7	00 	. 
	defb 000h		;22e8	00 	. 
	defb 078h		;22e9	78 	x 
	defb 090h		;22ea	90 	. 
	defb 090h		;22eb	90 	. 
	defb 090h		;22ec	90 	. 
	defb 060h		;22ed	60 	` 
	defb 000h		;22ee	00 	. 
	defb 000h		;22ef	00 	. 
	defb 050h		;22f0	50 	P 
	defb 050h		;22f1	50 	P 
	defb 050h		;22f2	50 	P 
	defb 050h		;22f3	50 	P 
	defb 068h		;22f4	68 	h 
	defb 080h		;22f5	80 	. 
	defb 080h		;22f6	80 	. 
	defb 000h		;22f7	00 	. 
	defb 050h		;22f8	50 	P 
	defb 0a0h		;22f9	a0 	. 
	defb 020h		;22fa	20 	  
	defb 020h		;22fb	20 	  
	defb 020h		;22fc	20 	  
	defb 020h		;22fd	20 	  
	defb 000h		;22fe	00 	. 
	defb 0f8h		;22ff	f8 	. 
	defb 020h		;2300	20 	  
	defb 070h		;2301	70 	p 
	defb 0a8h		;2302	a8 	. 
	defb 0a8h		;2303	a8 	. 
	defb 070h		;2304	70 	p 
	defb 020h		;2305	20 	  
	defb 0f8h		;2306	f8 	. 
	defb 020h		;2307	20 	  
	defb 050h		;2308	50 	P 
	defb 088h		;2309	88 	. 
	defb 0f8h		;230a	f8 	. 
	defb 088h		;230b	88 	. 
	defb 050h		;230c	50 	P 
	defb 020h		;230d	20 	  
	defb 000h		;230e	00 	. 
	defb 070h		;230f	70 	p 
	defb 088h		;2310	88 	. 
	defb 088h		;2311	88 	. 
	defb 088h		;2312	88 	. 
	defb 050h		;2313	50 	P 
	defb 050h		;2314	50 	P 
	defb 0d8h		;2315	d8 	. 
	defb 000h		;2316	00 	. 
	defb 030h		;2317	30 	0 
	defb 040h		;2318	40 	@ 
	defb 040h		;2319	40 	@ 
	defb 020h		;231a	20 	  
	defb 050h		;231b	50 	P 
	defb 050h		;231c	50 	P 
	defb 050h		;231d	50 	P 
	defb 020h		;231e	20 	  
	defb 000h		;231f	00 	. 
	defb 000h		;2320	00 	. 
	defb 000h		;2321	00 	. 
	defb 050h		;2322	50 	P 
	defb 0a8h		;2323	a8 	. 
	defb 0a8h		;2324	a8 	. 
	defb 050h		;2325	50 	P 
	defb 000h		;2326	00 	. 
	defb 008h		;2327	08 	. 
	defb 070h		;2328	70 	p 
	defb 0a8h		;2329	a8 	. 
	defb 0a8h		;232a	a8 	. 
	defb 0a8h		;232b	a8 	. 
	defb 070h		;232c	70 	p 
	defb 080h		;232d	80 	. 
	defb 000h		;232e	00 	. 
l232fh:
	defb 038h		;232f	38 	8 
	defb 040h		;2330	40 	@ 
	defb 080h		;2331	80 	. 
	defb 0f8h		;2332	f8 	. 
	defb 080h		;2333	80 	. 
	defb 040h		;2334	40 	@ 
	defb 038h		;2335	38 	8 
	defb 000h		;2336	00 	. 
	defb 070h		;2337	70 	p 
	defb 088h		;2338	88 	. 
	defb 088h		;2339	88 	. 
	defb 088h		;233a	88 	. 
	defb 088h		;233b	88 	. 
	defb 088h		;233c	88 	. 
	defb 088h		;233d	88 	. 
	defb 000h		;233e	00 	. 
	defb 000h		;233f	00 	. 
	defb 0f8h		;2340	f8 	. 
	defb 000h		;2341	00 	. 
	defb 0f8h		;2342	f8 	. 
	defb 000h		;2343	00 	. 
	defb 0f8h		;2344	f8 	. 
	defb 000h		;2345	00 	. 
	defb 000h		;2346	00 	. 
	defb 020h		;2347	20 	  
	defb 020h		;2348	20 	  
	defb 0f8h		;2349	f8 	. 
	defb 020h		;234a	20 	  
	defb 020h		;234b	20 	  
	defb 000h		;234c	00 	. 
	defb 0f8h		;234d	f8 	. 
	defb 000h		;234e	00 	. 
	defb 0c0h		;234f	c0 	. 
	defb 030h		;2350	30 	0 
	defb 008h		;2351	08 	. 
	defb 030h		;2352	30 	0 
	defb 0c0h		;2353	c0 	. 
	defb 000h		;2354	00 	. 
	defb 0f8h		;2355	f8 	. 
	defb 000h		;2356	00 	. 
	defb 018h		;2357	18 	. 
	defb 060h		;2358	60 	` 
	defb 080h		;2359	80 	. 
	defb 060h		;235a	60 	` 
	defb 018h		;235b	18 	. 
	defb 000h		;235c	00 	. 
	defb 0f8h		;235d	f8 	. 
	defb 000h		;235e	00 	. 
	defb 010h		;235f	10 	. 
	defb 028h		;2360	28 	( 
	defb 020h		;2361	20 	  
	defb 020h		;2362	20 	  
	defb 020h		;2363	20 	  
	defb 020h		;2364	20 	  
	defb 020h		;2365	20 	  
	defb 020h		;2366	20 	  
	defb 020h		;2367	20 	  
	defb 020h		;2368	20 	  
	defb 020h		;2369	20 	  
	defb 020h		;236a	20 	  
	defb 020h		;236b	20 	  
	defb 020h		;236c	20 	  
	defb 0a0h		;236d	a0 	. 
	defb 040h		;236e	40 	@ 
	defb 000h		;236f	00 	. 
	defb 020h		;2370	20 	  
	defb 000h		;2371	00 	. 
	defb 0f8h		;2372	f8 	. 
	defb 000h		;2373	00 	. 
	defb 020h		;2374	20 	  
	defb 000h		;2375	00 	. 
	defb 000h		;2376	00 	. 
	defb 000h		;2377	00 	. 
	defb 050h		;2378	50 	P 
	defb 0a0h		;2379	a0 	. 
	defb 000h		;237a	00 	. 
	defb 050h		;237b	50 	P 
	defb 0a0h		;237c	a0 	. 
	defb 000h		;237d	00 	. 
	defb 000h		;237e	00 	. 
	defb 000h		;237f	00 	. 
	defb 018h		;2380	18 	. 
	defb 024h		;2381	24 	$ 
	defb 024h		;2382	24 	$ 
	defb 018h		;2383	18 	. 
	defb 000h		;2384	00 	. 
	defb 000h		;2385	00 	. 
	defb 000h		;2386	00 	. 
	defb 000h		;2387	00 	. 
	defb 030h		;2388	30 	0 
	defb 078h		;2389	78 	x 
	defb 078h		;238a	78 	x 
	defb 030h		;238b	30 	0 
	defb 000h		;238c	00 	. 
	defb 000h		;238d	00 	. 
	defb 000h		;238e	00 	. 
	defb 000h		;238f	00 	. 
	defb 000h		;2390	00 	. 
	defb 000h		;2391	00 	. 
	defb 000h		;2392	00 	. 
	defb 030h		;2393	30 	0 
	defb 000h		;2394	00 	. 
	defb 000h		;2395	00 	. 
	defb 000h		;2396	00 	. 
	defb 03eh		;2397	3e 	> 
	defb 020h		;2398	20 	  
	defb 020h		;2399	20 	  
	defb 020h		;239a	20 	  
	defb 0a0h		;239b	a0 	. 
	defb 060h		;239c	60 	` 
	defb 020h		;239d	20 	  
	defb 000h		;239e	00 	. 
	defb 0a0h		;239f	a0 	. 
	defb 050h		;23a0	50 	P 
	defb 050h		;23a1	50 	P 
	defb 050h		;23a2	50 	P 
	defb 000h		;23a3	00 	. 
	defb 000h		;23a4	00 	. 
	defb 000h		;23a5	00 	. 
	defb 000h		;23a6	00 	. 
	defb 040h		;23a7	40 	@ 
	defb 0a0h		;23a8	a0 	. 
	defb 020h		;23a9	20 	  
	defb 040h		;23aa	40 	@ 
	defb 0e0h		;23ab	e0 	. 
	defb 000h		;23ac	00 	. 
	defb 000h		;23ad	00 	. 
	defb 000h		;23ae	00 	. 
	defb 000h		;23af	00 	. 
	defb 038h		;23b0	38 	8 
	defb 038h		;23b1	38 	8 
	defb 038h		;23b2	38 	8 
	defb 038h		;23b3	38 	8 
	defb 038h		;23b4	38 	8 
	defb 038h		;23b5	38 	8 
	defb 000h		;23b6	00 	. 
	defb 000h		;23b7	00 	. 
	defb 000h		;23b8	00 	. 
	defb 000h		;23b9	00 	. 
	defb 000h		;23ba	00 	. 
	defb 000h		;23bb	00 	. 
	defb 000h		;23bc	00 	. 
	defb 000h		;23bd	00 	. 
	defb 000h		;23be	00 	. 
PINL_DO:
	call H.PINL		;23bf	cd db fd 	. . . 
	ld a,(AUTFLG)		;23c2	3a aa f6 	: . . 
	and a			;23c5	a7 	. 
	jr nz,INLIN_DO		;23c6	20 0d 	  . 
	ld l,000h		;23c8	2e 00 	. . 
	jr l23e0h		;23ca	18 14 	. . 
QINLIN_DO:
	call H.QINL		;23cc	cd e0 fd 	. . . 
	ld a,03fh		;23cf	3e 3f 	> ? 
	rst 18h			;23d1	df 	. 
	ld a,020h		;23d2	3e 20 	>   
	rst 18h			;23d4	df 	. 
INLIN_DO:
	call H.INLI		;23d5	cd e5 fd 	. . . 
	ld hl,(CSRY)		;23d8	2a dc f3 	* . . 
	dec l			;23db	2d 	- 
	call nz,sub_0bd9h		;23dc	c4 d9 0b 	. . . 
	inc l			;23df	2c 	, 
l23e0h:
	ld (FSTPOS),hl		;23e0	22 ca fb 	" . . 
	xor a			;23e3	af 	. 
	ld (INTFLG),a		;23e4	32 9b fc 	2 . . 
l23e7h:
	call CHGET_DO		;23e7	cd cb 10 	. . . 
	ld hl,02437h		;23ea	21 37 24 	! 7 $ 
	ld c,00bh		;23ed	0e 0b 	. . 
	call l0976h		;23ef	cd 76 09 	. v . 
	push af			;23f2	f5 	. 
	call nz,sub_23ffh		;23f3	c4 ff 23 	. . # 
	pop af			;23f6	f1 	. 
	jr nc,l23e7h		;23f7	30 ee 	0 . 
	ld hl,BUFMIN		;23f9	21 5d f5 	! ] . 
	ret z			;23fc	c8 	. 
	ccf			;23fd	3f 	? 
	ret			;23fe	c9 	. 
sub_23ffh:
	push af			;23ff	f5 	. 
	cp 009h		;2400	fe 09 	. . 
	jr nz,l2413h		;2402	20 0f 	  . 
	pop af			;2404	f1 	. 
l2405h:
	ld a,020h		;2405	3e 20 	>   
	call sub_23ffh		;2407	cd ff 23 	. . # 
	ld a,(CSRX)		;240a	3a dd f3 	: . . 
	dec a			;240d	3d 	= 
	and 007h		;240e	e6 07 	. . 
	jr nz,l2405h		;2410	20 f3 	  . 
	ret			;2412	c9 	. 
l2413h:
	pop af			;2413	f1 	. 
	ld hl,INSFLG		;2414	21 a8 fc 	! . . 
	cp 001h		;2417	fe 01 	. . 
	jr z,l2426h		;2419	28 0b 	( . 
	cp 020h		;241b	fe 20 	.   
	jr c,l2428h		;241d	38 09 	8 . 
	push af			;241f	f5 	. 
	ld a,(hl)			;2420	7e 	~ 
	and a			;2421	a7 	. 
	call nz,sub_24f2h		;2422	c4 f2 24 	. . $ 
	pop af			;2425	f1 	. 
l2426h:
	rst 18h			;2426	df 	. 
	ret			;2427	c9 	. 
l2428h:
	ld (hl),000h		;2428	36 00 	6 . 
	rst 18h			;242a	df 	. 
	ld a,03eh		;242b	3e 3e 	> > 
sub_242dh:
	xor a			;242d	af 	. 
	push af			;242e	f5 	. 
	call sub_0a8bh		;242f	cd 8b 0a 	. . . 
	pop af			;2432	f1 	. 
	ld (CSTYLE),a		;2433	32 aa fc 	2 . . 
	jp sub_0a3eh		;2436	c3 3e 0a 	. > . 

; BLOCK 'KBDSTUFF' (start 0x2439 end 0x245a)
KBDSTUFF_start:
	defb 008h		;2439	08 	. 
	defb 061h		;243a	61 	a 
	defb 025h		;243b	25 	% 
	defb 012h		;243c	12 	. 
	defb 0e5h		;243d	e5 	. 
	defb 024h		;243e	24 	$ 
	defb 01bh		;243f	1b 	. 
	defb 0feh		;2440	fe 	. 
	defb 023h		;2441	23 	# 
	defb 002h		;2442	02 	. 
	defb 00eh		;2443	0e 	. 
	defb 026h		;2444	26 	& 
	defb 006h		;2445	06 	. 
	defb 0f8h		;2446	f8 	. 
	defb 025h		;2447	25 	% 
	defb 00eh		;2448	0e 	. 
	defb 0d7h		;2449	d7 	. 
	defb 025h		;244a	25 	% 
	defb 005h		;244b	05 	. 
	defb 0b9h		;244c	b9 	. 
	defb 025h		;244d	25 	% 
	defb 003h		;244e	03 	. 
	defb 0c5h		;244f	c5 	. 
	defb 024h		;2450	24 	$ 
	defb 00dh		;2451	0d 	. 
	defb 05ah		;2452	5a 	Z 
	defb 024h		;2453	24 	$ 
	defb 015h		;2454	15 	. 
	defb 0aeh		;2455	ae 	. 
	defb 025h		;2456	25 	% 
	defb 07fh		;2457	7f 	 
	defb 050h		;2458	50 	P 
	defb 025h		;2459	25 	% 
RETURNKEY:
	call sub_266ch		;245a	cd 6c 26 	. l & 
	ld a,(AUTFLG)		;245d	3a aa f6 	: . . 
	and a			;2460	a7 	. 
	jr z,l2465h		;2461	28 02 	( . 
	ld h,001h		;2463	26 01 	& . 
l2465h:
	push hl			;2465	e5 	. 
	call sub_0a8bh		;2466	cd 8b 0a 	. . . 
	pop hl			;2469	e1 	. 
	ld de,BUF		;246a	11 5e f5 	. ^ . 
	ld b,0feh		;246d	06 fe 	. . 
	dec l			;246f	2d 	- 
l2470h:
	inc l			;2470	2c 	, 
l2471h:
	push de			;2471	d5 	. 
	push bc			;2472	c5 	. 
	call sub_0b83h		;2473	cd 83 0b 	. . . 
	pop bc			;2476	c1 	. 
	pop de			;2477	d1 	. 
	and a			;2478	a7 	. 
	jr z,l248fh		;2479	28 14 	( . 
	cp 020h		;247b	fe 20 	.   
	jr nc,l248ah		;247d	30 0b 	0 . 
	dec b			;247f	05 	. 
	jr z,l249fh		;2480	28 1d 	( . 
	ld c,a			;2482	4f 	O 
	ld a,001h		;2483	3e 01 	> . 
	ld (de),a			;2485	12 	. 
	inc de			;2486	13 	. 
	ld a,c			;2487	79 	y 
	add a,040h		;2488	c6 40 	. @ 
l248ah:
	ld (de),a			;248a	12 	. 
	inc de			;248b	13 	. 
	dec b			;248c	05 	. 
	jr z,l249fh		;248d	28 10 	( . 
l248fh:
	inc h			;248f	24 	$ 
	ld a,(LINLEN)		;2490	3a b0 f3 	: . . 
	cp h			;2493	bc 	. 
	jr nc,l2471h		;2494	30 db 	0 . 
	push de			;2496	d5 	. 
	call sub_0bcdh		;2497	cd cd 0b 	. . . 
	pop de			;249a	d1 	. 
	ld h,001h		;249b	26 01 	& . 
	jr z,l2470h		;249d	28 d1 	( . 
l249fh:
	dec de			;249f	1b 	. 
	ld a,(de)			;24a0	1a 	. 
	cp 020h		;24a1	fe 20 	.   
	jr z,l249fh		;24a3	28 fa 	( . 
	push hl			;24a5	e5 	. 
	push de			;24a6	d5 	. 
	call sub_0a3eh		;24a7	cd 3e 0a 	. > . 
	pop de			;24aa	d1 	. 
	pop hl			;24ab	e1 	. 
	inc de			;24ac	13 	. 
	xor a			;24ad	af 	. 
	ld (de),a			;24ae	12 	. 
l24afh:
	ld a,00dh		;24af	3e 0d 	> . 
	and a			;24b1	a7 	. 
l24b2h:
	push af			;24b2	f5 	. 
	call sub_0bd9h		;24b3	cd d9 0b 	. . . 
	call POSIT_DO		;24b6	cd eb 08 	. . . 
	ld a,00ah		;24b9	3e 0a 	> . 
	rst 18h			;24bb	df 	. 
	xor a			;24bc	af 	. 
	ld (INSFLG),a		;24bd	32 a8 fc 	2 . . 
	pop af			;24c0	f1 	. 
	scf			;24c1	37 	7 
	pop hl			;24c2	e1 	. 
	ret			;24c3	c9 	. 
l24c4h:
	inc l			;24c4	2c 	, 
	call sub_0bcdh		;24c5	cd cd 0b 	. . . 
	jr z,l24c4h		;24c8	28 fa 	( . 
	call sub_242dh		;24ca	cd 2d 24 	. - $ 
	xor a			;24cd	af 	. 
	ld (BUF),a		;24ce	32 5e f5 	2 ^ . 
	ld h,001h		;24d1	26 01 	& . 
	push hl			;24d3	e5 	. 
	call GICINI_DO		;24d4	cd b2 05 	. . . 
	call sub_0549h		;24d7	cd 49 05 	. I . 
	pop hl			;24da	e1 	. 
	jr c,l24afh		;24db	38 d2 	8 . 
	ld a,(BASROM)		;24dd	3a b1 fb 	: . . 
	and a			;24e0	a7 	. 
	jr nz,l24afh		;24e1	20 cc 	  . 
	jr l24b2h		;24e3	18 cd 	. . 
	ld hl,INSFLG		;24e5	21 a8 fc 	! . . 
	ld a,(hl)			;24e8	7e 	~ 
	xor 0ffh		;24e9	ee ff 	. . 
	ld (hl),a			;24eb	77 	w 
	jp z,sub_242dh		;24ec	ca 2d 24 	. - $ 
	jp 0242ch		;24ef	c3 2c 24 	. , $ 
sub_24f2h:
	call sub_0a8bh		;24f2	cd 8b 0a 	. . . 
	ld hl,(CSRY)		;24f5	2a dc f3 	* . . 
	ld c,020h		;24f8	0e 20 	.   
l24fah:
	push hl			;24fa	e5 	. 
l24fbh:
	push bc			;24fb	c5 	. 
	call sub_0b83h		;24fc	cd 83 0b 	. . . 
	pop de			;24ff	d1 	. 
	push bc			;2500	c5 	. 
	ld c,e			;2501	4b 	K 
	call sub_0b8dh		;2502	cd 8d 0b 	. . . 
	pop bc			;2505	c1 	. 
	ld a,(LINLEN)		;2506	3a b0 f3 	: . . 
	inc h			;2509	24 	$ 
	cp h			;250a	bc 	. 
	ld a,d			;250b	7a 	z 
	jr nc,l24fbh		;250c	30 ed 	0 . 
	pop hl			;250e	e1 	. 
	call sub_0bcdh		;250f	cd cd 0b 	. . . 
	jr z,l254bh		;2512	28 37 	( 7 
	ld a,c			;2514	79 	y 
	cp 020h		;2515	fe 20 	.   
	push af			;2517	f5 	. 
	jr nz,l2524h		;2518	20 0a 	  . 
	ld a,(LINLEN)		;251a	3a b0 f3 	: . . 
	cp h			;251d	bc 	. 
	jr z,l2524h		;251e	28 04 	( . 
	pop af			;2520	f1 	. 
	jp sub_0a3eh		;2521	c3 3e 0a 	. > . 
l2524h:
	call sub_0bd9h+1		;2524	cd da 0b 	. . . 
	inc l			;2527	2c 	, 
	push bc			;2528	c5 	. 
	push hl			;2529	e5 	. 
	call sub_0be2h		;252a	cd e2 0b 	. . . 
	cp l			;252d	bd 	. 
	jr c,l2535h		;252e	38 05 	8 . 
	call sub_0af1h		;2530	cd f1 0a 	. . . 
	jr l2544h		;2533	18 0f 	. . 
l2535h:
	ld hl,CSRY		;2535	21 dc f3 	! . . 
	dec (hl)			;2538	35 	5 
	jr nz,l253ch		;2539	20 01 	  . 
	inc (hl)			;253b	34 	4 
l253ch:
	ld l,001h		;253c	2e 01 	. . 
	call l0ae5h		;253e	cd e5 0a 	. . . 
	pop hl			;2541	e1 	. 
	dec l			;2542	2d 	- 
l2543h:
	push hl			;2543	e5 	. 
l2544h:
	pop hl			;2544	e1 	. 
	pop bc			;2545	c1 	. 
	pop af			;2546	f1 	. 
	jp z,sub_0a3eh		;2547	ca 3e 0a 	. > . 
	dec l			;254a	2d 	- 
l254bh:
	inc l			;254b	2c 	, 
	ld h,001h		;254c	26 01 	& . 
	jr l24fah		;254e	18 aa 	. . 
	ld a,(LINLEN)		;2550	3a b0 f3 	: . . 
	cp h			;2553	bc 	. 
	jr nz,l255bh		;2554	20 05 	  . 
	call sub_0bcdh		;2556	cd cd 0b 	. . . 
	jr nz,l2595h		;2559	20 3a 	  : 
l255bh:
	ld a,01ch		;255b	3e 1c 	> . 
	rst 18h			;255d	df 	. 
	ld hl,(CSRY)		;255e	2a dc f3 	* . . 
	push hl			;2561	e5 	. 
	call sub_0a8bh		;2562	cd 8b 0a 	. . . 
	pop hl			;2565	e1 	. 
	dec h			;2566	25 	% 
	jp nz,l257ah		;2567	c2 7a 25 	. z % 
	inc h			;256a	24 	$ 
	push hl			;256b	e5 	. 
	dec l			;256c	2d 	- 
	jr z,l2579h		;256d	28 0a 	( . 
	ld a,(LINLEN)		;256f	3a b0 f3 	: . . 
	ld h,a			;2572	67 	g 
	call sub_0bcdh		;2573	cd cd 0b 	. . . 
	jr nz,l2579h		;2576	20 01 	  . 
	ex (sp),hl			;2578	e3 	. 
l2579h:
	pop hl			;2579	e1 	. 
l257ah:
	ld (CSRY),hl		;257a	22 dc f3 	" . . 
l257dh:
	ld a,(LINLEN)		;257d	3a b0 f3 	: . . 
	cp h			;2580	bc 	. 
	jr z,l2595h		;2581	28 12 	( . 
	inc h			;2583	24 	$ 
l2584h:
	call sub_0b83h		;2584	cd 83 0b 	. . . 
	dec h			;2587	25 	% 
	call sub_0b8dh		;2588	cd 8d 0b 	. . . 
	inc h			;258b	24 	$ 
	inc h			;258c	24 	$ 
	ld a,(LINLEN)		;258d	3a b0 f3 	: . . 
	inc a			;2590	3c 	< 
	cp h			;2591	bc 	. 
	jr nz,l2584h		;2592	20 f0 	  . 
	dec h			;2594	25 	% 
l2595h:
	ld c,020h		;2595	0e 20 	.   
	call sub_0b8dh		;2597	cd 8d 0b 	. . . 
	call sub_0bcdh		;259a	cd cd 0b 	. . . 
	jp nz,sub_0a3eh		;259d	c2 3e 0a 	. > . 
	push hl			;25a0	e5 	. 
	inc l			;25a1	2c 	, 
	ld h,001h		;25a2	26 01 	& . 
	call sub_0b83h		;25a4	cd 83 0b 	. . . 
	ex (sp),hl			;25a7	e3 	. 
	call sub_0b8dh		;25a8	cd 8d 0b 	. . . 
	pop hl			;25ab	e1 	. 
	jr l257dh		;25ac	18 cf 	. . 
	call sub_0a8bh		;25ae	cd 8b 0a 	. . . 
	call sub_266ch		;25b1	cd 6c 26 	. l & 
	ld (CSRY),hl		;25b4	22 dc f3 	" . . 
	jr l25beh		;25b7	18 05 	. . 
	push hl			;25b9	e5 	. 
	call sub_0a8bh		;25ba	cd 8b 0a 	. . . 
	pop hl			;25bd	e1 	. 
l25beh:
	call sub_0bcdh		;25be	cd cd 0b 	. . . 
	push af			;25c1	f5 	. 
	call EOL_DO		;25c2	cd 05 0b 	. . . 
	pop af			;25c5	f1 	. 
	jr nz,l25cdh		;25c6	20 05 	  . 
	ld h,001h		;25c8	26 01 	& . 
	inc l			;25ca	2c 	, 
	jr l25beh		;25cb	18 f1 	. . 
l25cdh:
	call sub_0a3eh		;25cd	cd 3e 0a 	. > . 
	xor a			;25d0	af 	. 
	ld (INSFLG),a		;25d1	32 a8 fc 	2 . . 
	jp sub_242dh		;25d4	c3 2d 24 	. - $ 
	call sub_0a8bh		;25d7	cd 8b 0a 	. . . 
	ld hl,(CSRY)		;25da	2a dc f3 	* . . 
	dec l			;25dd	2d 	- 
l25deh:
	inc l			;25de	2c 	, 
	call sub_0bcdh		;25df	cd cd 0b 	. . . 
	jr z,l25deh		;25e2	28 fa 	( . 
	ld a,(LINLEN)		;25e4	3a b0 f3 	: . . 
	ld h,a			;25e7	67 	g 
	inc h			;25e8	24 	$ 
l25e9h:
	dec h			;25e9	25 	% 
	jr z,l25f3h		;25ea	28 07 	( . 
	call sub_0b83h		;25ec	cd 83 0b 	. . . 
	cp 020h		;25ef	fe 20 	.   
	jr z,l25e9h		;25f1	28 f6 	( . 
l25f3h:
	call sub_0ab8h		;25f3	cd b8 0a 	. . . 
	jr l25cdh		;25f6	18 d5 	. . 
	call sub_0a8bh		;25f8	cd 8b 0a 	. . . 
	call sub_2634h		;25fb	cd 34 26 	. 4 & 
l25feh:
	call sub_2624h		;25fe	cd 24 26 	. $ & 
	jr z,l25cdh		;2601	28 ca 	( . 
	jr c,l25feh		;2603	38 f9 	8 . 
l2605h:
	call sub_2624h		;2605	cd 24 26 	. $ & 
	jr z,l25cdh		;2608	28 c3 	( . 
	jr nc,l2605h		;260a	30 f9 	0 . 
	jr l25cdh		;260c	18 bf 	. . 
	call sub_0a8bh		;260e	cd 8b 0a 	. . . 
l2611h:
	call sub_2634h		;2611	cd 34 26 	. 4 & 
	jr z,l25cdh		;2614	28 b7 	( . 
	jr nc,l2611h		;2616	30 f9 	0 . 
l2618h:
	call sub_2634h		;2618	cd 34 26 	. 4 & 
	jr z,l25cdh		;261b	28 b0 	( . 
	jr c,l2618h		;261d	38 f9 	8 . 
	call sub_0ab8h		;261f	cd b8 0a 	. . . 
	jr l25cdh		;2622	18 a9 	. . 
sub_2624h:
	ld hl,(CSRY)		;2624	2a dc f3 	* . . 
	call sub_0ab8h		;2627	cd b8 0a 	. . . 
	call sub_0be2h		;262a	cd e2 0b 	. . . 
	ld e,a			;262d	5f 	_ 
	ld a,(LINLEN)		;262e	3a b0 f3 	: . . 
	ld d,a			;2631	57 	W 
	jr l263dh		;2632	18 09 	. . 
sub_2634h:
	ld hl,(CSRY)		;2634	2a dc f3 	* . . 
	call sub_0aa9h		;2637	cd a9 0a 	. . . 
	ld de,LEFTC+2		;263a	11 01 01 	. . . 
l263dh:
	ld hl,(CSRY)		;263d	2a dc f3 	* . . 
	rst 20h			;2640	e7 	. 
	ret z			;2641	c8 	. 
	ld de,l2668h		;2642	11 68 26 	. h & 
	push de			;2645	d5 	. 
	call sub_0b83h		;2646	cd 83 0b 	. . . 
	cp 030h		;2649	fe 30 	. 0 
	ccf			;264b	3f 	? 
	ret nc			;264c	d0 	. 
	cp 03ah		;264d	fe 3a 	. : 
	ret c			;264f	d8 	. 
	cp 041h		;2650	fe 41 	. A 
	ccf			;2652	3f 	? 
	ret nc			;2653	d0 	. 
	cp 05bh		;2654	fe 5b 	. [ 
	ret c			;2656	d8 	. 
	cp 061h		;2657	fe 61 	. a 
	ccf			;2659	3f 	? 
	ret nc			;265a	d0 	. 
	cp 07bh		;265b	fe 7b 	. { 
	ret c			;265d	d8 	. 
	cp 086h		;265e	fe 86 	. . 
	ccf			;2660	3f 	? 
	ret nc			;2661	d0 	. 
	cp 0a0h		;2662	fe a0 	. . 
	ret c			;2664	d8 	. 
	cp 0a6h		;2665	fe a6 	. . 
	ccf			;2667	3f 	? 
l2668h:
	ld a,000h		;2668	3e 00 	> . 
	inc a			;266a	3c 	< 
	ret			;266b	c9 	. 
sub_266ch:
	dec l			;266c	2d 	- 
	jr z,l2674h		;266d	28 05 	( . 
	call sub_0bcdh		;266f	cd cd 0b 	. . . 
	jr z,sub_266ch		;2672	28 f8 	( . 
l2674h:
	inc l			;2674	2c 	, 
	ld a,(FSTPOS)		;2675	3a ca fb 	: . . 
	cp l			;2678	bd 	. 
	ld h,001h		;2679	26 01 	& . 
	ret nz			;267b	c0 	. 
	ld hl,(FSTPOS)		;267c	2a ca fb 	* . . 
	ret			;267f	c9 	. 
	jp l7c76h		;2680	c3 76 7c 	. v | 
SYNCHR_DO:
	jp l558ch		;2683	c3 8c 55 	. . U 
CHRGTR_DO:
	jp l4666h		;2686	c3 66 46 	. f F 
GETYPR_DO:
	jp l5597h		;2689	c3 97 55 	. . U 
sub_268ch:
	ld hl,ARG		;268c	21 47 f8 	! G . 
	ld a,(hl)			;268f	7e 	~ 
	or a			;2690	b7 	. 
	ret z			;2691	c8 	. 
	xor 080h		;2692	ee 80 	. . 
	ld (hl),a			;2694	77 	w 
	jr l26a0h		;2695	18 09 	. . 
sub_2697h:
	call sub_2eefh		;2697	cd ef 2e 	. . . 
sub_269ah:
	ld hl,ARG		;269a	21 47 f8 	! G . 
	ld a,(hl)			;269d	7e 	~ 
	or a			;269e	b7 	. 
	ret z			;269f	c8 	. 
l26a0h:
	and 07fh		;26a0	e6 7f 	.  
	ld b,a			;26a2	47 	G 
	ld de,DAC		;26a3	11 f6 f7 	. . . 
	ld a,(de)			;26a6	1a 	. 
	or a			;26a7	b7 	. 
	jp z,l2f05h		;26a8	ca 05 2f 	. . / 
	and 07fh		;26ab	e6 7f 	.  
	sub b			;26ad	90 	. 
	jr nc,l26c1h		;26ae	30 11 	0 . 
	cpl			;26b0	2f 	/ 
	inc a			;26b1	3c 	< 
	push af			;26b2	f5 	. 
	push hl			;26b3	e5 	. 
	ld b,008h		;26b4	06 08 	. . 
l26b6h:
	ld a,(de)			;26b6	1a 	. 
	ld c,(hl)			;26b7	4e 	N 
	ld (hl),a			;26b8	77 	w 
	ld a,c			;26b9	79 	y 
	ld (de),a			;26ba	12 	. 
	inc de			;26bb	13 	. 
	inc hl			;26bc	23 	# 
	djnz l26b6h		;26bd	10 f7 	. . 
	pop hl			;26bf	e1 	. 
	pop af			;26c0	f1 	. 
l26c1h:
	cp 010h		;26c1	fe 10 	. . 
	ret nc			;26c3	d0 	. 
	push af			;26c4	f5 	. 
	xor a			;26c5	af 	. 
	ld (0f7feh),a		;26c6	32 fe f7 	2 . . 
	ld (0f84fh),a		;26c9	32 4f f8 	2 O . 
	ld hl,0f848h		;26cc	21 48 f8 	! H . 
	pop af			;26cf	f1 	. 
	call sub_27a3h		;26d0	cd a3 27 	. . ' 
	ld hl,ARG		;26d3	21 47 f8 	! G . 
	ld a,(DAC)		;26d6	3a f6 f7 	: . . 
	xor (hl)			;26d9	ae 	. 
	jp m,l26f7h		;26da	fa f7 26 	. . & 
	ld a,(0f84fh)		;26dd	3a 4f f8 	: O . 
	ld (0f7feh),a		;26e0	32 fe f7 	2 . . 
	call sub_2759h		;26e3	cd 59 27 	. Y ' 
	jp nc,l273ch		;26e6	d2 3c 27 	. < ' 
	ex de,hl			;26e9	eb 	. 
	ld a,(hl)			;26ea	7e 	~ 
	inc (hl)			;26eb	34 	4 
	xor (hl)			;26ec	ae 	. 
	jp m,04067h		;26ed	fa 67 40 	. g @ 
	call sub_27dbh		;26f0	cd db 27 	. . ' 
	set 4,(hl)		;26f3	cb e6 	. . 
	jr l273ch		;26f5	18 45 	. E 
l26f7h:
	call sub_276bh		;26f7	cd 6b 27 	. k ' 
l26fah:
	ld hl,0f7f7h		;26fa	21 f7 f7 	! . . 
	ld bc,l0800h		;26fd	01 00 08 	. . . 
l2700h:
	ld a,(hl)			;2700	7e 	~ 
	or a			;2701	b7 	. 
	jr nz,l270ch		;2702	20 08 	  . 
	inc hl			;2704	23 	# 
	dec c			;2705	0d 	. 
	dec c			;2706	0d 	. 
	djnz l2700h		;2707	10 f7 	. . 
	jp l2e7dh		;2709	c3 7d 2e 	. } . 
l270ch:
	and 0f0h		;270c	e6 f0 	. . 
	jr nz,l2716h		;270e	20 06 	  . 
	push hl			;2710	e5 	. 
	call sub_2797h		;2711	cd 97 27 	. . ' 
	pop hl			;2714	e1 	. 
	dec c			;2715	0d 	. 
l2716h:
	ld a,008h		;2716	3e 08 	> . 
	sub b			;2718	90 	. 
	jr z,l272dh		;2719	28 12 	( . 
	push af			;271b	f5 	. 
	push bc			;271c	c5 	. 
	ld c,b			;271d	48 	H 
	ld de,0f7f7h		;271e	11 f7 f7 	. . . 
	ld b,000h		;2721	06 00 	. . 
	ldir		;2723	ed b0 	. . 
	pop bc			;2725	c1 	. 
	pop af			;2726	f1 	. 
	ld b,a			;2727	47 	G 
	xor a			;2728	af 	. 
l2729h:
	ld (de),a			;2729	12 	. 
	inc de			;272a	13 	. 
	djnz l2729h		;272b	10 fc 	. . 
l272dh:
	ld a,c			;272d	79 	y 
	or a			;272e	b7 	. 
	jr z,l273ch		;272f	28 0b 	( . 
	ld hl,DAC		;2731	21 f6 f7 	! . . 
	ld b,(hl)			;2734	46 	F 
	add a,(hl)			;2735	86 	. 
	ld (hl),a			;2736	77 	w 
	xor b			;2737	a8 	. 
	jp m,04067h		;2738	fa 67 40 	. g @ 
	ret z			;273b	c8 	. 
l273ch:
	ld hl,0f7feh		;273c	21 fe f7 	! . . 
	ld b,007h		;273f	06 07 	. . 
l2741h:
	ld a,(hl)			;2741	7e 	~ 
	cp 050h		;2742	fe 50 	. P 
	ret c			;2744	d8 	. 
	dec hl			;2745	2b 	+ 
	xor a			;2746	af 	. 
	scf			;2747	37 	7 
l2748h:
	adc a,(hl)			;2748	8e 	. 
	daa			;2749	27 	' 
	ld (hl),a			;274a	77 	w 
	ret nc			;274b	d0 	. 
	dec hl			;274c	2b 	+ 
	djnz l2748h		;274d	10 f9 	. . 
	ld a,(hl)			;274f	7e 	~ 
	inc (hl)			;2750	34 	4 
	xor (hl)			;2751	ae 	. 
	jp m,04067h		;2752	fa 67 40 	. g @ 
	inc hl			;2755	23 	# 
	ld (hl),010h		;2756	36 10 	6 . 
	ret			;2758	c9 	. 
sub_2759h:
	ld hl,0f84eh		;2759	21 4e f8 	! N . 
	ld de,0f7fdh		;275c	11 fd f7 	. . . 
	ld b,007h		;275f	06 07 	. . 
sub_2761h:
	xor a			;2761	af 	. 
l2762h:
	ld a,(de)			;2762	1a 	. 
	adc a,(hl)			;2763	8e 	. 
	daa			;2764	27 	' 
	ld (de),a			;2765	12 	. 
	dec de			;2766	1b 	. 
	dec hl			;2767	2b 	+ 
	djnz l2762h		;2768	10 f8 	. . 
	ret			;276a	c9 	. 
sub_276bh:
	ld hl,0f84fh		;276b	21 4f f8 	! O . 
	ld a,(hl)			;276e	7e 	~ 
	cp 050h		;276f	fe 50 	. P 
	jr nz,l2774h		;2771	20 01 	  . 
	inc (hl)			;2773	34 	4 
l2774h:
	ld de,0f7feh		;2774	11 fe f7 	. . . 
	ld b,008h		;2777	06 08 	. . 
	xor a			;2779	af 	. 
l277ah:
	ld a,(de)			;277a	1a 	. 
	sbc a,(hl)			;277b	9e 	. 
	daa			;277c	27 	' 
	ld (de),a			;277d	12 	. 
	dec de			;277e	1b 	. 
	dec hl			;277f	2b 	+ 
	djnz l277ah		;2780	10 f8 	. . 
	ret nc			;2782	d0 	. 
	ex de,hl			;2783	eb 	. 
	ld a,(hl)			;2784	7e 	~ 
	xor 080h		;2785	ee 80 	. . 
	ld (hl),a			;2787	77 	w 
	ld hl,0f7feh		;2788	21 fe f7 	! . . 
	ld b,008h		;278b	06 08 	. . 
	xor a			;278d	af 	. 
l278eh:
	ld a,000h		;278e	3e 00 	> . 
	sbc a,(hl)			;2790	9e 	. 
	daa			;2791	27 	' 
	ld (hl),a			;2792	77 	w 
	dec hl			;2793	2b 	+ 
	djnz l278eh		;2794	10 f8 	. . 
	ret			;2796	c9 	. 
sub_2797h:
	ld hl,0f7feh		;2797	21 fe f7 	! . . 
sub_279ah:
	push bc			;279a	c5 	. 
	xor a			;279b	af 	. 
l279ch:
	rld		;279c	ed 6f 	. o 
	dec hl			;279e	2b 	+ 
	djnz l279ch		;279f	10 fb 	. . 
	pop bc			;27a1	c1 	. 
	ret			;27a2	c9 	. 
sub_27a3h:
	or a			;27a3	b7 	. 
	rra			;27a4	1f 	. 
	push af			;27a5	f5 	. 
	or a			;27a6	b7 	. 
	jp z,l27e2h		;27a7	ca e2 27 	. . ' 
	push af			;27aa	f5 	. 
	cpl			;27ab	2f 	/ 
	inc a			;27ac	3c 	< 
	ld c,a			;27ad	4f 	O 
	ld b,0ffh		;27ae	06 ff 	. . 
	ld de,0007h		;27b0	11 07 00 	. . . 
	add hl,de			;27b3	19 	. 
	ld d,h			;27b4	54 	T 
	ld e,l			;27b5	5d 	] 
	add hl,bc			;27b6	09 	. 
	ld a,008h		;27b7	3e 08 	> . 
	add a,c			;27b9	81 	. 
	ld c,a			;27ba	4f 	O 
	push bc			;27bb	c5 	. 
	ld b,000h		;27bc	06 00 	. . 
	lddr		;27be	ed b8 	. . 
	pop bc			;27c0	c1 	. 
	pop af			;27c1	f1 	. 
	inc hl			;27c2	23 	# 
	inc de			;27c3	13 	. 
	push de			;27c4	d5 	. 
	ld b,a			;27c5	47 	G 
	xor a			;27c6	af 	. 
l27c7h:
	ld (hl),a			;27c7	77 	w 
	inc hl			;27c8	23 	# 
	djnz l27c7h		;27c9	10 fc 	. . 
	pop hl			;27cb	e1 	. 
	pop af			;27cc	f1 	. 
	ret nc			;27cd	d0 	. 
	ld a,c			;27ce	79 	y 
l27cfh:
	push hl			;27cf	e5 	. 
	push bc			;27d0	c5 	. 
	ld b,a			;27d1	47 	G 
	xor a			;27d2	af 	. 
l27d3h:
	rrd		;27d3	ed 67 	. g 
	inc hl			;27d5	23 	# 
	djnz l27d3h		;27d6	10 fb 	. . 
	pop bc			;27d8	c1 	. 
	pop hl			;27d9	e1 	. 
	ret			;27da	c9 	. 
sub_27dbh:
	ld hl,0f7f7h		;27db	21 f7 f7 	! . . 
l27deh:
	ld a,008h		;27de	3e 08 	> . 
	jr l27cfh		;27e0	18 ed 	. . 
l27e2h:
	pop af			;27e2	f1 	. 
	ret nc			;27e3	d0 	. 
	jr l27deh		;27e4	18 f8 	. . 
sub_27e6h:
	call BAS_SIGN		;27e6	cd 71 2e 	. q . 
	ret z			;27e9	c8 	. 
	ld a,(ARG)		;27ea	3a 47 f8 	: G . 
	or a			;27ed	b7 	. 
	jp z,l2e7dh		;27ee	ca 7d 2e 	. } . 
	ld b,a			;27f1	47 	G 
	ld hl,DAC		;27f2	21 f6 f7 	! . . 
	xor (hl)			;27f5	ae 	. 
	and 080h		;27f6	e6 80 	. . 
	ld c,a			;27f8	4f 	O 
	res 7,b		;27f9	cb b8 	. . 
	ld a,(hl)			;27fb	7e 	~ 
	and 07fh		;27fc	e6 7f 	.  
	add a,b			;27fe	80 	. 
	ld b,a			;27ff	47 	G 
	ld (hl),000h		;2800	36 00 	6 . 
	and 0c0h		;2802	e6 c0 	. . 
	ret z			;2804	c8 	. 
	cp 0c0h		;2805	fe c0 	. . 
	jr nz,l280ch		;2807	20 03 	  . 
	jp 04067h		;2809	c3 67 40 	. g @ 
l280ch:
	ld a,b			;280c	78 	x 
	add a,040h		;280d	c6 40 	. @ 
	and 07fh		;280f	e6 7f 	.  
	ret z			;2811	c8 	. 
	or c			;2812	b1 	. 
	dec hl			;2813	2b 	+ 
	ld (hl),a			;2814	77 	w 
	ld de,0f845h		;2815	11 45 f8 	. E . 
	ld bc,0008h		;2818	01 08 00 	. . . 
	ld hl,0f7fdh		;281b	21 fd f7 	! . . 
	push de			;281e	d5 	. 
	lddr		;281f	ed b8 	. . 
	inc hl			;2821	23 	# 
	xor a			;2822	af 	. 
	ld b,008h		;2823	06 08 	. . 
l2825h:
	ld (hl),a			;2825	77 	w 
	inc hl			;2826	23 	# 
	djnz l2825h		;2827	10 fc 	. . 
	pop de			;2829	d1 	. 
	ld bc,l2883h		;282a	01 83 28 	. . ( 
	push bc			;282d	c5 	. 
sub_282eh:
	call sub_288ah		;282e	cd 8a 28 	. . ( 
	push hl			;2831	e5 	. 
	ld bc,0008h		;2832	01 08 00 	. . . 
	ex de,hl			;2835	eb 	. 
	lddr		;2836	ed b8 	. . 
	ex de,hl			;2838	eb 	. 
	ld hl,0f83dh		;2839	21 3d f8 	! = . 
	ld b,008h		;283c	06 08 	. . 
	call sub_2761h		;283e	cd 61 27 	. a ' 
	pop de			;2841	d1 	. 
	call sub_288ah		;2842	cd 8a 28 	. . ( 
	ld c,007h		;2845	0e 07 	. . 
	ld de,0f84eh		;2847	11 4e f8 	. N . 
l284ah:
	ld a,(de)			;284a	1a 	. 
	or a			;284b	b7 	. 
	jr nz,l2852h		;284c	20 04 	  . 
	dec de			;284e	1b 	. 
	dec c			;284f	0d 	. 
	jr l284ah		;2850	18 f8 	. . 
l2852h:
	ld a,(de)			;2852	1a 	. 
	dec de			;2853	1b 	. 
	push de			;2854	d5 	. 
	ld hl,0f80dh		;2855	21 0d f8 	! . . 
l2858h:
	add a,a			;2858	87 	. 
	jr c,l2863h		;2859	38 08 	8 . 
	jr z,l2871h		;285b	28 14 	( . 
l285dh:
	ld de,0008h		;285d	11 08 00 	. . . 
	add hl,de			;2860	19 	. 
	jr l2858h		;2861	18 f5 	. . 
l2863h:
	push af			;2863	f5 	. 
	ld b,008h		;2864	06 08 	. . 
	ld de,0f7fdh		;2866	11 fd f7 	. . . 
	push hl			;2869	e5 	. 
	call sub_2761h		;286a	cd 61 27 	. a ' 
	pop hl			;286d	e1 	. 
	pop af			;286e	f1 	. 
	jr l285dh		;286f	18 ec 	. . 
l2871h:
	ld b,00fh		;2871	06 0f 	. . 
	ld de,0f804h		;2873	11 04 f8 	. . . 
	ld hl,0f805h		;2876	21 05 f8 	! . . 
	call sub_2efeh		;2879	cd fe 2e 	. . . 
	ld (hl),000h		;287c	36 00 	6 . 
	pop de			;287e	d1 	. 
	dec c			;287f	0d 	. 
	jr nz,l2852h		;2880	20 d0 	  . 
	ret			;2882	c9 	. 
l2883h:
	dec hl			;2883	2b 	+ 
	ld a,(hl)			;2884	7e 	~ 
	inc hl			;2885	23 	# 
	ld (hl),a			;2886	77 	w 
	jp l26fah		;2887	c3 fa 26 	. . & 
sub_288ah:
	ld hl,0fff8h		;288a	21 f8 ff 	! . . 
	add hl,de			;288d	19 	. 
	ld c,003h		;288e	0e 03 	. . 
l2890h:
	ld b,008h		;2890	06 08 	. . 
	or a			;2892	b7 	. 
l2893h:
	ld a,(de)			;2893	1a 	. 
	adc a,a			;2894	8f 	. 
	daa			;2895	27 	' 
	ld (hl),a			;2896	77 	w 
	dec hl			;2897	2b 	+ 
	dec de			;2898	1b 	. 
	djnz l2893h		;2899	10 f8 	. . 
	dec c			;289b	0d 	. 
	jr nz,l2890h		;289c	20 f2 	  . 
	ret			;289e	c9 	. 
l289fh:
	ld a,(ARG)		;289f	3a 47 f8 	: G . 
	or a			;28a2	b7 	. 
	jp z,04058h		;28a3	ca 58 40 	. X @ 
	ld b,a			;28a6	47 	G 
	ld hl,DAC		;28a7	21 f6 f7 	! . . 
	ld a,(hl)			;28aa	7e 	~ 
	or a			;28ab	b7 	. 
	jp z,l2e7dh		;28ac	ca 7d 2e 	. } . 
	xor b			;28af	a8 	. 
	and 080h		;28b0	e6 80 	. . 
	ld c,a			;28b2	4f 	O 
	res 7,b		;28b3	cb b8 	. . 
	ld a,(hl)			;28b5	7e 	~ 
	and 07fh		;28b6	e6 7f 	.  
	sub b			;28b8	90 	. 
	ld b,a			;28b9	47 	G 
	rra			;28ba	1f 	. 
	xor b			;28bb	a8 	. 
	and 040h		;28bc	e6 40 	. @ 
	ld (hl),000h		;28be	36 00 	6 . 
	jr z,l28c9h		;28c0	28 07 	( . 
	ld a,b			;28c2	78 	x 
	and 080h		;28c3	e6 80 	. . 
	ret nz			;28c5	c0 	. 
l28c6h:
	jp 04067h		;28c6	c3 67 40 	. g @ 
l28c9h:
	ld a,b			;28c9	78 	x 
	add a,041h		;28ca	c6 41 	. A 
	and 07fh		;28cc	e6 7f 	.  
	ld (hl),a			;28ce	77 	w 
l28cfh:
	jr z,l28c6h		;28cf	28 f5 	( . 
	or c			;28d1	b1 	. 
	ld (hl),000h		;28d2	36 00 	6 . 
	dec hl			;28d4	2b 	+ 
	ld (hl),a			;28d5	77 	w 
	ld de,0f7fdh		;28d6	11 fd f7 	. . . 
	ld hl,0f84eh		;28d9	21 4e f8 	! N . 
	ld b,007h		;28dc	06 07 	. . 
	xor a			;28de	af 	. 
l28dfh:
	cp (hl)			;28df	be 	. 
	jr nz,l28e6h		;28e0	20 04 	  . 
	dec de			;28e2	1b 	. 
	dec hl			;28e3	2b 	+ 
	djnz l28dfh		;28e4	10 f9 	. . 
l28e6h:
	ld (DECTM2),hl		;28e6	22 f2 f7 	" . . 
	ex de,hl			;28e9	eb 	. 
	ld (DECTMP),hl		;28ea	22 f0 f7 	" . . 
	ld a,b			;28ed	78 	x 
	ld (DECCNT),a		;28ee	32 f4 f7 	2 . . 
	ld hl,0f83eh		;28f1	21 3e f8 	! > . 
l28f4h:
	ld b,00fh		;28f4	06 0f 	. . 
l28f6h:
	push hl			;28f6	e5 	. 
	push bc			;28f7	c5 	. 
	ld hl,(DECTM2)		;28f8	2a f2 f7 	* . . 
	ex de,hl			;28fb	eb 	. 
	ld hl,(DECTMP)		;28fc	2a f0 f7 	* . . 
	ld a,(DECCNT)		;28ff	3a f4 f7 	: . . 
	ld c,0ffh		;2902	0e ff 	. . 
l2904h:
	inc c			;2904	0c 	. 
	ld b,a			;2905	47 	G 
	push hl			;2906	e5 	. 
	push de			;2907	d5 	. 
	xor a			;2908	af 	. 
	ex de,hl			;2909	eb 	. 
l290ah:
	ld a,(de)			;290a	1a 	. 
	sbc a,(hl)			;290b	9e 	. 
	daa			;290c	27 	' 
	ld (de),a			;290d	12 	. 
	dec hl			;290e	2b 	+ 
	dec de			;290f	1b 	. 
	djnz l290ah		;2910	10 f8 	. . 
	ld a,(de)			;2912	1a 	. 
	sbc a,b			;2913	98 	. 
	ld (de),a			;2914	12 	. 
	pop de			;2915	d1 	. 
	pop hl			;2916	e1 	. 
	ld a,(DECCNT)		;2917	3a f4 f7 	: . . 
	jr nc,l2904h		;291a	30 e8 	0 . 
	ld b,a			;291c	47 	G 
	ex de,hl			;291d	eb 	. 
	call sub_2761h		;291e	cd 61 27 	. a ' 
	jr nc,l2925h		;2921	30 02 	0 . 
	ex de,hl			;2923	eb 	. 
	inc (hl)			;2924	34 	4 
l2925h:
	ld a,c			;2925	79 	y 
	pop bc			;2926	c1 	. 
	ld c,a			;2927	4f 	O 
	push bc			;2928	c5 	. 
	srl b		;2929	cb 38 	. 8 
	inc b			;292b	04 	. 
	ld e,b			;292c	58 	X 
	ld d,000h		;292d	16 00 	. . 
	ld hl,0f7f5h		;292f	21 f5 f7 	! . . 
	add hl,de			;2932	19 	. 
	call sub_279ah		;2933	cd 9a 27 	. . ' 
	pop bc			;2936	c1 	. 
	pop hl			;2937	e1 	. 
	ld a,b			;2938	78 	x 
	inc c			;2939	0c 	. 
	dec c			;293a	0d 	. 
	jr nz,l2973h		;293b	20 36 	  6 
	cp 00fh		;293d	fe 0f 	. . 
	jr z,l2964h		;293f	28 23 	( # 
	rrca			;2941	0f 	. 
	rlca			;2942	07 	. 
	jr nc,l2973h		;2943	30 2e 	0 . 
	push bc			;2945	c5 	. 
	push hl			;2946	e5 	. 
	ld hl,DAC		;2947	21 f6 f7 	! . . 
	ld b,008h		;294a	06 08 	. . 
	xor a			;294c	af 	. 
l294dh:
	cp (hl)			;294d	be 	. 
	jr nz,l295fh		;294e	20 0f 	  . 
	inc hl			;2950	23 	# 
	djnz l294dh		;2951	10 fa 	. . 
	pop hl			;2953	e1 	. 
	pop bc			;2954	c1 	. 
	srl b		;2955	cb 38 	. 8 
	inc b			;2957	04 	. 
	xor a			;2958	af 	. 
l2959h:
	ld (hl),a			;2959	77 	w 
	inc hl			;295a	23 	# 
	djnz l2959h		;295b	10 fc 	. . 
	jr l2985h		;295d	18 26 	. & 
l295fh:
	pop hl			;295f	e1 	. 
	pop bc			;2960	c1 	. 
	ld a,b			;2961	78 	x 
	jr l2973h		;2962	18 0f 	. . 
l2964h:
	ld a,(0f7f5h)		;2964	3a f5 f7 	: . . 
	ld e,a			;2967	5f 	_ 
	dec a			;2968	3d 	= 
	ld (0f7f5h),a		;2969	32 f5 f7 	2 . . 
	xor e			;296c	ab 	. 
	jp p,l28f4h		;296d	f2 f4 28 	. . ( 
	jp l2e7dh		;2970	c3 7d 2e 	. } . 
l2973h:
	rra			;2973	1f 	. 
	ld a,c			;2974	79 	y 
	jr c,l297ch		;2975	38 05 	8 . 
	or (hl)			;2977	b6 	. 
	ld (hl),a			;2978	77 	w 
	inc hl			;2979	23 	# 
	jr l2981h		;297a	18 05 	. . 
l297ch:
	add a,a			;297c	87 	. 
	add a,a			;297d	87 	. 
	add a,a			;297e	87 	. 
	add a,a			;297f	87 	. 
	ld (hl),a			;2980	77 	w 
l2981h:
	dec b			;2981	05 	. 
	jp nz,l28f6h		;2982	c2 f6 28 	. . ( 
l2985h:
	ld hl,0f7feh		;2985	21 fe f7 	! . . 
	ld de,0f845h		;2988	11 45 f8 	. E . 
	ld b,008h		;298b	06 08 	. . 
	call sub_2efeh		;298d	cd fe 2e 	. . . 
	jp l2883h		;2990	c3 83 28 	. . ( 
sub_2993h:
	ld hl,l2d63h		;2993	21 63 2d 	! c - 
	call sub_2c3bh		;2996	cd 3b 2c 	. ; , 
	ld a,(DAC)		;2999	3a f6 f7 	: . . 
	and 07fh		;299c	e6 7f 	.  
	ld (DAC),a		;299e	32 f6 f7 	2 . . 
	ld hl,l2d23h		;29a1	21 23 2d 	! # - 
	call sub_2c32h		;29a4	cd 32 2c 	. 2 , 
	call sub_2e8dh		;29a7	cd 8d 2e 	. . . 
	jr l29b2h		;29aa	18 06 	. . 
sub_29ach:
	ld hl,l2d63h		;29ac	21 63 2d 	! c - 
	call sub_2c3bh		;29af	cd 3b 2c 	. ; , 
l29b2h:
	ld a,(DAC)		;29b2	3a f6 f7 	: . . 
	or a			;29b5	b7 	. 
	call m,sub_2c80h		;29b6	fc 80 2c 	. . , 
	call sub_2ccch		;29b9	cd cc 2c 	. . , 
	call sub_30cfh		;29bc	cd cf 30 	. . 0 
	call sub_2c4dh		;29bf	cd 4d 2c 	. M , 
	call sub_2ce1h		;29c2	cd e1 2c 	. . , 
	call sub_268ch		;29c5	cd 8c 26 	. . & 
	ld a,(DAC)		;29c8	3a f6 f7 	: . . 
	cp 040h		;29cb	fe 40 	. @ 
	jp c,l29f5h		;29cd	da f5 29 	. . ) 
	ld a,(0f7f7h)		;29d0	3a f7 f7 	: . . 
	cp 025h		;29d3	fe 25 	. % 
	jp c,l29f5h		;29d5	da f5 29 	. . ) 
	cp 075h		;29d8	fe 75 	. u 
	jp nc,l29ech		;29da	d2 ec 29 	. . ) 
	call sub_2c4dh		;29dd	cd 4d 2c 	. M , 
	ld hl,l2d11h		;29e0	21 11 2d 	! . - 
	call sub_2c5ch		;29e3	cd 5c 2c 	. \ , 
	call sub_268ch		;29e6	cd 8c 26 	. . & 
	jp l29f5h		;29e9	c3 f5 29 	. . ) 
l29ech:
	ld hl,l2d1bh		;29ec	21 1b 2d 	! . - 
	call sub_2c50h		;29ef	cd 50 2c 	. P , 
	call sub_268ch		;29f2	cd 8c 26 	. . & 
l29f5h:
	ld hl,l2defh		;29f5	21 ef 2d 	! . - 
	jp l2c88h		;29f8	c3 88 2c 	. . , 
	call sub_2ccch		;29fb	cd cc 2c 	. . , 
	call sub_2993h		;29fe	cd 93 29 	. . ) 
	call sub_2c6fh		;2a01	cd 6f 2c 	. o , 
	call sub_29ach		;2a04	cd ac 29 	. . ) 
	call sub_2cdch		;2a07	cd dc 2c 	. . , 
	ld a,(ARG)		;2a0a	3a 47 f8 	: G . 
	or a			;2a0d	b7 	. 
	jp nz,l289fh		;2a0e	c2 9f 28 	. . ( 
	jp 04067h		;2a11	c3 67 40 	. g @ 
	ld a,(DAC)		;2a14	3a f6 f7 	: . . 
	or a			;2a17	b7 	. 
	ret z			;2a18	c8 	. 
	call m,sub_2c80h		;2a19	fc 80 2c 	. . , 
	cp 041h		;2a1c	fe 41 	. A 
	jp c,l2a3ch		;2a1e	da 3c 2a 	. < * 
	call sub_2c4dh		;2a21	cd 4d 2c 	. M , 
	ld hl,l2d1bh		;2a24	21 1b 2d 	! . - 
	call sub_2c5ch		;2a27	cd 5c 2c 	. \ , 
	call l289fh		;2a2a	cd 9f 28 	. . ( 
	call l2a3ch		;2a2d	cd 3c 2a 	. < * 
	call sub_2c4dh		;2a30	cd 4d 2c 	. M , 
	ld hl,l2d43h		;2a33	21 43 2d 	! C - 
	call sub_2c5ch		;2a36	cd 5c 2c 	. \ , 
	jp sub_268ch		;2a39	c3 8c 26 	. . & 
l2a3ch:
	ld hl,l2d4bh		;2a3c	21 4b 2d 	! K - 
	call sub_2c47h		;2a3f	cd 47 2c 	. G , 
	jp m,l2a6ch		;2a42	fa 6c 2a 	. l * 
	call sub_2ccch		;2a45	cd cc 2c 	. . , 
	ld hl,l2d53h		;2a48	21 53 2d 	! S - 
	call sub_2c2ch		;2a4b	cd 2c 2c 	. , , 
	call sub_2c6fh		;2a4e	cd 6f 2c 	. o , 
	ld hl,l2d53h		;2a51	21 53 2d 	! S - 
	call sub_2c3bh		;2a54	cd 3b 2c 	. ; , 
	ld hl,l2d1bh		;2a57	21 1b 2d 	! . - 
	call sub_2c32h		;2a5a	cd 32 2c 	. 2 , 
	call sub_2cdch		;2a5d	cd dc 2c 	. . , 
	call l289fh		;2a60	cd 9f 28 	. . ( 
	call l2a6ch		;2a63	cd 6c 2a 	. l * 
	ld hl,l2d5bh		;2a66	21 5b 2d 	! [ - 
	jp sub_2c2ch		;2a69	c3 2c 2c 	. , , 
l2a6ch:
	ld hl,l2e30h		;2a6c	21 30 2e 	! 0 . 
	jp l2c88h		;2a6f	c3 88 2c 	. . , 
sub_2a72h:
	call BAS_SIGN		;2a72	cd 71 2e 	. q . 
	jp m,l475ah		;2a75	fa 5a 47 	. Z G 
	jp z,l475ah		;2a78	ca 5a 47 	. Z G 
	ld hl,DAC		;2a7b	21 f6 f7 	! . . 
	ld a,(hl)			;2a7e	7e 	~ 
	push af			;2a7f	f5 	. 
	ld (hl),041h		;2a80	36 41 	6 A 
	ld hl,l2d2bh		;2a82	21 2b 2d 	! + - 
	call sub_2c47h		;2a85	cd 47 2c 	. G , 
	jp m,l2a92h		;2a88	fa 92 2a 	. . * 
	pop af			;2a8b	f1 	. 
	inc a			;2a8c	3c 	< 
	push af			;2a8d	f5 	. 
	ld hl,DAC		;2a8e	21 f6 f7 	! . . 
	dec (hl)			;2a91	35 	5 
l2a92h:
	pop af			;2a92	f1 	. 
	ld (TEMP3),a		;2a93	32 9d f6 	2 . . 
	call sub_2ccch		;2a96	cd cc 2c 	. . , 
	ld hl,l2d1bh		;2a99	21 1b 2d 	! . - 
	call sub_2c2ch		;2a9c	cd 2c 2c 	. , , 
	call sub_2c6fh		;2a9f	cd 6f 2c 	. o , 
	ld hl,l2d1bh		;2aa2	21 1b 2d 	! . - 
	call sub_2c32h		;2aa5	cd 32 2c 	. 2 , 
	call sub_2cdch		;2aa8	cd dc 2c 	. . , 
	call l289fh		;2aab	cd 9f 28 	. . ( 
	call sub_2ccch		;2aae	cd cc 2c 	. . , 
	call sub_2c38h		;2ab1	cd 38 2c 	. 8 , 
	call sub_2ccch		;2ab4	cd cc 2c 	. . , 
	call sub_2ccch		;2ab7	cd cc 2c 	. . , 
	ld hl,l2dc6h		;2aba	21 c6 2d 	! . - 
	call sub_2ca3h		;2abd	cd a3 2c 	. . , 
	call sub_2c6fh		;2ac0	cd 6f 2c 	. o , 
	ld hl,l2da5h		;2ac3	21 a5 2d 	! . - 
	call sub_2ca3h		;2ac6	cd a3 2c 	. . , 
	call sub_2cdch		;2ac9	cd dc 2c 	. . , 
	call l289fh		;2acc	cd 9f 28 	. . ( 
	call sub_2cdch		;2acf	cd dc 2c 	. . , 
	call sub_27e6h		;2ad2	cd e6 27 	. . ' 
	ld hl,l2d33h		;2ad5	21 33 2d 	! 3 - 
	call sub_2c2ch		;2ad8	cd 2c 2c 	. , , 
	call sub_2cdch		;2adb	cd dc 2c 	. . , 
	call sub_27e6h		;2ade	cd e6 27 	. . ' 
	call sub_2ccch		;2ae1	cd cc 2c 	. . , 
	ld a,(TEMP3)		;2ae4	3a 9d f6 	: . . 
	sub 041h		;2ae7	d6 41 	. A 
	ld l,a			;2ae9	6f 	o 
	add a,a			;2aea	87 	. 
	sbc a,a			;2aeb	9f 	. 
	ld h,a			;2aec	67 	g 
	call sub_2fcbh		;2aed	cd cb 2f 	. . / 
	call sub_3042h		;2af0	cd 42 30 	. B 0 
	call sub_2cdch		;2af3	cd dc 2c 	. . , 
	call sub_269ah		;2af6	cd 9a 26 	. . & 
	ld hl,l2d3bh		;2af9	21 3b 2d 	! ; - 
	jp sub_2c3bh		;2afc	c3 3b 2c 	. ; , 
	call BAS_SIGN		;2aff	cd 71 2e 	. q . 
	ret z			;2b02	c8 	. 
	jp m,l475ah		;2b03	fa 5a 47 	. Z G 
	call sub_2c4dh		;2b06	cd 4d 2c 	. M , 
	ld a,(DAC)		;2b09	3a f6 f7 	: . . 
	or a			;2b0c	b7 	. 
	rra			;2b0d	1f 	. 
	adc a,020h		;2b0e	ce 20 	.   
	ld (ARG),a		;2b10	32 47 f8 	2 G . 
	ld a,(0f7f7h)		;2b13	3a f7 f7 	: . . 
	or a			;2b16	b7 	. 
	rrca			;2b17	0f 	. 
	or a			;2b18	b7 	. 
	rrca			;2b19	0f 	. 
	and 033h		;2b1a	e6 33 	. 3 
	add a,010h		;2b1c	c6 10 	. . 
	ld (0f848h),a		;2b1e	32 48 f8 	2 H . 
	ld a,007h		;2b21	3e 07 	> . 
l2b23h:
	ld (TEMP3),a		;2b23	32 9d f6 	2 . . 
	call sub_2ccch		;2b26	cd cc 2c 	. . , 
	call sub_2cc7h		;2b29	cd c7 2c 	. . , 
	call l289fh		;2b2c	cd 9f 28 	. . ( 
	call sub_2cdch		;2b2f	cd dc 2c 	. . , 
	call sub_269ah		;2b32	cd 9a 26 	. . & 
	ld hl,l2d11h		;2b35	21 11 2d 	! . - 
	call sub_2c3bh		;2b38	cd 3b 2c 	. ; , 
	call sub_2c4dh		;2b3b	cd 4d 2c 	. M , 
	call sub_2ce1h		;2b3e	cd e1 2c 	. . , 
	ld a,(TEMP3)		;2b41	3a 9d f6 	: . . 
	dec a			;2b44	3d 	= 
	jr nz,l2b23h		;2b45	20 dc 	  . 
	jp l2c59h		;2b47	c3 59 2c 	. Y , 
l2b4ah:
	ld hl,l2d09h		;2b4a	21 09 2d 	! . - 
	call sub_2c3bh		;2b4d	cd 3b 2c 	. ; , 
	call sub_2ccch		;2b50	cd cc 2c 	. . , 
	call sub_2f8ah		;2b53	cd 8a 2f 	. . / 
	ld a,l			;2b56	7d 	} 
	rla			;2b57	17 	. 
	sbc a,a			;2b58	9f 	. 
	cp h			;2b59	bc 	. 
	jr z,l2b70h		;2b5a	28 14 	( . 
	ld a,h			;2b5c	7c 	| 
	or a			;2b5d	b7 	. 
	jp p,l2b6dh		;2b5e	f2 6d 2b 	. m + 
	call sub_304fh		;2b61	cd 4f 30 	. O 0 
	call sub_2ce1h		;2b64	cd e1 2c 	. . , 
	ld hl,l2d13h		;2b67	21 13 2d 	! . - 
	jp sub_2c5ch		;2b6a	c3 5c 2c 	. \ , 
l2b6dh:
	jp 04067h		;2b6d	c3 67 40 	. g @ 
l2b70h:
	ld (TEMP3),hl		;2b70	22 9d f6 	" . . 
	call FRCDBL		;2b73	cd 3a 30 	. : 0 
	call sub_2c4dh		;2b76	cd 4d 2c 	. M , 
	call sub_2ce1h		;2b79	cd e1 2c 	. . , 
	call sub_268ch		;2b7c	cd 8c 26 	. . & 
	ld hl,l2d11h		;2b7f	21 11 2d 	! . - 
	call sub_2c47h		;2b82	cd 47 2c 	. G , 
	push af			;2b85	f5 	. 
	jr z,l2b90h		;2b86	28 08 	( . 
	jr c,l2b90h		;2b88	38 06 	8 . 
	ld hl,l2d11h		;2b8a	21 11 2d 	! . - 
	call sub_2c32h		;2b8d	cd 32 2c 	. 2 , 
l2b90h:
	call sub_2ccch		;2b90	cd cc 2c 	. . , 
	ld hl,l2d8ch		;2b93	21 8c 2d 	! . - 
	call l2c88h		;2b96	cd 88 2c 	. . , 
	call sub_2c6fh		;2b99	cd 6f 2c 	. o , 
	ld hl,l2d6bh		;2b9c	21 6b 2d 	! k - 
	call sub_2c9ah		;2b9f	cd 9a 2c 	. . , 
	call sub_2cdch		;2ba2	cd dc 2c 	. . , 
	call sub_2cc7h		;2ba5	cd c7 2c 	. . , 
	call sub_2ccch		;2ba8	cd cc 2c 	. . , 
	call sub_268ch		;2bab	cd 8c 26 	. . & 
	ld hl,0f83eh		;2bae	21 3e f8 	! > . 
	call sub_2c67h		;2bb1	cd 67 2c 	. g , 
	call sub_2cdch		;2bb4	cd dc 2c 	. . , 
	call sub_2ce1h		;2bb7	cd e1 2c 	. . , 
	call sub_269ah		;2bba	cd 9a 26 	. . & 
	ld hl,0f83eh		;2bbd	21 3e f8 	! > . 
	call sub_2c50h		;2bc0	cd 50 2c 	. P , 
	call l289fh		;2bc3	cd 9f 28 	. . ( 
	pop af			;2bc6	f1 	. 
	jr c,l2bd1h		;2bc7	38 08 	8 . 
	jr z,l2bd1h		;2bc9	28 06 	( . 
	ld hl,l2d2bh		;2bcb	21 2b 2d 	! + - 
	call sub_2c3bh		;2bce	cd 3b 2c 	. ; , 
l2bd1h:
	ld a,(TEMP3)		;2bd1	3a 9d f6 	: . . 
	ld hl,DAC		;2bd4	21 f6 f7 	! . . 
	ld c,(hl)			;2bd7	4e 	N 
	add a,(hl)			;2bd8	86 	. 
	ld (hl),a			;2bd9	77 	w 
	xor c			;2bda	a9 	. 
	ret p			;2bdb	f0 	. 
	jp 04067h		;2bdc	c3 67 40 	. g @ 
	call BAS_SIGN		;2bdf	cd 71 2e 	. q . 
	ld hl,RNDX		;2be2	21 57 f8 	! W . 
	jr z,l2c15h		;2be5	28 2e 	( . 
	call m,sub_2c67h		;2be7	fc 67 2c 	. g , 
	ld hl,0f83eh		;2bea	21 3e f8 	! > . 
	ld de,RNDX		;2bed	11 57 f8 	. W . 
	call sub_2c6ah		;2bf0	cd 6a 2c 	. j , 
	ld hl,l2cf9h		;2bf3	21 f9 2c 	! . , 
	call sub_2c50h		;2bf6	cd 50 2c 	. P , 
	ld hl,NUMBERS_start		;2bf9	21 f1 2c 	! . , 
	call sub_2c5ch		;2bfc	cd 5c 2c 	. \ , 
	ld de,0f845h		;2bff	11 45 f8 	. E . 
	call sub_282eh		;2c02	cd 2e 28 	. . ( 
	ld de,0f7feh		;2c05	11 fe f7 	. . . 
	ld hl,0f858h		;2c08	21 58 f8 	! X . 
	ld b,007h		;2c0b	06 07 	. . 
	call sub_2ef7h		;2c0d	cd f7 2e 	. . . 
	ld hl,RNDX		;2c10	21 57 f8 	! W . 
	ld (hl),000h		;2c13	36 00 	6 . 
l2c15h:
	call sub_2c5ch		;2c15	cd 5c 2c 	. \ , 
	ld hl,DAC		;2c18	21 f6 f7 	! . . 
	ld (hl),040h		;2c1b	36 40 	6 @ 
	xor a			;2c1d	af 	. 
	ld (0f7feh),a		;2c1e	32 fe f7 	2 . . 
	jp l26fah		;2c21	c3 fa 26 	. . & 
sub_2c24h:
	ld de,l2d01h		;2c24	11 01 2d 	. . - 
	ld hl,RNDX		;2c27	21 57 f8 	! W . 
	jr sub_2c6ah		;2c2a	18 3e 	. > 
sub_2c2ch:
	call sub_2c50h		;2c2c	cd 50 2c 	. P , 
	jp sub_269ah		;2c2f	c3 9a 26 	. . & 
sub_2c32h:
	call sub_2c50h		;2c32	cd 50 2c 	. P , 
	jp sub_268ch		;2c35	c3 8c 26 	. . & 
sub_2c38h:
	ld hl,DAC		;2c38	21 f6 f7 	! . . 
sub_2c3bh:
	call sub_2c50h		;2c3b	cd 50 2c 	. P , 
	jp sub_27e6h		;2c3e	c3 e6 27 	. . ' 
	call sub_2c50h		;2c41	cd 50 2c 	. P , 
	jp l289fh		;2c44	c3 9f 28 	. . ( 
sub_2c47h:
	call sub_2c50h		;2c47	cd 50 2c 	. P , 
	jp l2f5ch		;2c4a	c3 5c 2f 	. \ / 
sub_2c4dh:
	ld hl,DAC		;2c4d	21 f6 f7 	! . . 
sub_2c50h:
	ld de,ARG		;2c50	11 47 f8 	. G . 
l2c53h:
	ex de,hl			;2c53	eb 	. 
	call sub_2c6ah		;2c54	cd 6a 2c 	. j , 
	ex de,hl			;2c57	eb 	. 
	ret			;2c58	c9 	. 
l2c59h:
	ld hl,ARG		;2c59	21 47 f8 	! G . 
sub_2c5ch:
	ld de,DAC		;2c5c	11 f6 f7 	. . . 
	jr l2c53h		;2c5f	18 f2 	. . 
	call sub_2fcbh		;2c61	cd cb 2f 	. . / 
	ld hl,RNDX		;2c64	21 57 f8 	! W . 
sub_2c67h:
	ld de,DAC		;2c67	11 f6 f7 	. . . 
sub_2c6ah:
	ld b,008h		;2c6a	06 08 	. . 
	jp sub_2ef7h		;2c6c	c3 f7 2e 	. . . 
sub_2c6fh:
	pop hl			;2c6f	e1 	. 
	ld (FBUFFR),hl		;2c70	22 c5 f7 	" . . 
	call sub_2cdch		;2c73	cd dc 2c 	. . , 
	call sub_2ccch		;2c76	cd cc 2c 	. . , 
	call l2c59h		;2c79	cd 59 2c 	. Y , 
	ld hl,(FBUFFR)		;2c7c	2a c5 f7 	* . . 
	jp (hl)			;2c7f	e9 	. 
sub_2c80h:
	call sub_2e8dh		;2c80	cd 8d 2e 	. . . 
	ld hl,sub_2e8dh		;2c83	21 8d 2e 	! . . 
	ex (sp),hl			;2c86	e3 	. 
	jp (hl)			;2c87	e9 	. 
l2c88h:
	ld (FBUFFR),hl		;2c88	22 c5 f7 	" . . 
	call sub_2ccch		;2c8b	cd cc 2c 	. . , 
	ld hl,(FBUFFR)		;2c8e	2a c5 f7 	* . . 
	call sub_2c9ah		;2c91	cd 9a 2c 	. . , 
	call sub_2cdch		;2c94	cd dc 2c 	. . , 
	jp sub_27e6h		;2c97	c3 e6 27 	. . ' 
sub_2c9ah:
	ld (FBUFFR),hl		;2c9a	22 c5 f7 	" . . 
	call sub_2c38h		;2c9d	cd 38 2c 	. 8 , 
	ld hl,(FBUFFR)		;2ca0	2a c5 f7 	* . . 
sub_2ca3h:
	ld a,(hl)			;2ca3	7e 	~ 
	push af			;2ca4	f5 	. 
	inc hl			;2ca5	23 	# 
	push hl			;2ca6	e5 	. 
	ld hl,FBUFFR		;2ca7	21 c5 f7 	! . . 
	call sub_2c67h		;2caa	cd 67 2c 	. g , 
	pop hl			;2cad	e1 	. 
	call sub_2c5ch		;2cae	cd 5c 2c 	. \ , 
l2cb1h:
	pop af			;2cb1	f1 	. 
	dec a			;2cb2	3d 	= 
	ret z			;2cb3	c8 	. 
	push af			;2cb4	f5 	. 
	push hl			;2cb5	e5 	. 
	ld hl,FBUFFR		;2cb6	21 c5 f7 	! . . 
	call sub_2c3bh		;2cb9	cd 3b 2c 	. ; , 
	pop hl			;2cbc	e1 	. 
	call sub_2c50h		;2cbd	cd 50 2c 	. P , 
	push hl			;2cc0	e5 	. 
	call sub_269ah		;2cc1	cd 9a 26 	. . & 
	pop hl			;2cc4	e1 	. 
	jr l2cb1h		;2cc5	18 ea 	. . 
sub_2cc7h:
	ld hl,0f84eh		;2cc7	21 4e f8 	! N . 
	jr l2ccfh		;2cca	18 03 	. . 
sub_2ccch:
	ld hl,0f7fdh		;2ccc	21 fd f7 	! . . 
l2ccfh:
	ld a,004h		;2ccf	3e 04 	> . 
	pop de			;2cd1	d1 	. 
l2cd2h:
	ld b,(hl)			;2cd2	46 	F 
	dec hl			;2cd3	2b 	+ 
	ld c,(hl)			;2cd4	4e 	N 
	dec hl			;2cd5	2b 	+ 
	push bc			;2cd6	c5 	. 
	dec a			;2cd7	3d 	= 
	jr nz,l2cd2h		;2cd8	20 f8 	  . 
	ex de,hl			;2cda	eb 	. 
	jp (hl)			;2cdb	e9 	. 
sub_2cdch:
	ld hl,ARG		;2cdc	21 47 f8 	! G . 
	jr l2ce4h		;2cdf	18 03 	. . 
sub_2ce1h:
	ld hl,DAC		;2ce1	21 f6 f7 	! . . 
l2ce4h:
	ld a,004h		;2ce4	3e 04 	> . 
	pop de			;2ce6	d1 	. 
l2ce7h:
	pop bc			;2ce7	c1 	. 
	ld (hl),c			;2ce8	71 	q 
	inc hl			;2ce9	23 	# 
	ld (hl),b			;2cea	70 	p 
	inc hl			;2ceb	23 	# 
	dec a			;2cec	3d 	= 
	jr nz,l2ce7h		;2ced	20 f8 	  . 
	ex de,hl			;2cef	eb 	. 
	jp (hl)			;2cf0	e9 	. 

; BLOCK 'NUMBERS' (start 0x2cf1 end 0x2e71)
NUMBERS_start:
	defb 000h		;2cf1	00 	. 
	defb 014h		;2cf2	14 	. 
	defb 038h		;2cf3	38 	8 
	defb 098h		;2cf4	98 	. 
	defb 020h		;2cf5	20 	  
	defb 042h		;2cf6	42 	B 
	defb 008h		;2cf7	08 	. 
	defb 021h		;2cf8	21 	! 
l2cf9h:
	defb 000h		;2cf9	00 	. 
	defb 021h		;2cfa	21 	! 
	defb 013h		;2cfb	13 	. 
	defb 024h		;2cfc	24 	$ 
	defb 086h		;2cfd	86 	. 
	defb 054h		;2cfe	54 	T 
	defb 005h		;2cff	05 	. 
	defb 019h		;2d00	19 	. 
l2d01h:
	defb 000h		;2d01	00 	. 
	defb 040h		;2d02	40 	@ 
	defb 064h		;2d03	64 	d 
	defb 096h		;2d04	96 	. 
	defb 051h		;2d05	51 	Q 
	defb 037h		;2d06	37 	7 
	defb 023h		;2d07	23 	# 
	defb 058h		;2d08	58 	X 
l2d09h:
	defb 040h		;2d09	40 	@ 
	defb 043h		;2d0a	43 	C 
	defb 042h		;2d0b	42 	B 
	defb 094h		;2d0c	94 	. 
	defb 048h		;2d0d	48 	H 
	defb 019h		;2d0e	19 	. 
	defb 003h		;2d0f	03 	. 
	defb 024h		;2d10	24 	$ 
l2d11h:
	defb 040h		;2d11	40 	@ 
	defb 050h		;2d12	50 	P 
l2d13h:
	defb 000h		;2d13	00 	. 
	defb 000h		;2d14	00 	. 
	defb 000h		;2d15	00 	. 
	defb 000h		;2d16	00 	. 
	defb 000h		;2d17	00 	. 
	defb 000h		;2d18	00 	. 
	defb 000h		;2d19	00 	. 
	defb 000h		;2d1a	00 	. 
l2d1bh:
	defb 041h		;2d1b	41 	A 
	defb 010h		;2d1c	10 	. 
	defb 000h		;2d1d	00 	. 
	defb 000h		;2d1e	00 	. 
	defb 000h		;2d1f	00 	. 
	defb 000h		;2d20	00 	. 
	defb 000h		;2d21	00 	. 
	defb 000h		;2d22	00 	. 
l2d23h:
	defb 040h		;2d23	40 	@ 
	defb 025h		;2d24	25 	% 
	defb 000h		;2d25	00 	. 
	defb 000h		;2d26	00 	. 
	defb 000h		;2d27	00 	. 
	defb 000h		;2d28	00 	. 
	defb 000h		;2d29	00 	. 
	defb 000h		;2d2a	00 	. 
l2d2bh:
	defb 041h		;2d2b	41 	A 
	defb 031h		;2d2c	31 	1 
	defb 062h		;2d2d	62 	b 
	defb 027h		;2d2e	27 	' 
	defb 076h		;2d2f	76 	v 
	defb 060h		;2d30	60 	` 
	defb 016h		;2d31	16 	. 
	defb 084h		;2d32	84 	. 
l2d33h:
	defb 040h		;2d33	40 	@ 
	defb 086h		;2d34	86 	. 
	defb 085h		;2d35	85 	. 
	defb 088h		;2d36	88 	. 
	defb 096h		;2d37	96 	. 
	defb 038h		;2d38	38 	8 
	defb 006h		;2d39	06 	. 
	defb 050h		;2d3a	50 	P 
l2d3bh:
	defb 041h		;2d3b	41 	A 
	defb 023h		;2d3c	23 	# 
	defb 002h		;2d3d	02 	. 
	defb 058h		;2d3e	58 	X 
	defb 050h		;2d3f	50 	P 
	defb 092h		;2d40	92 	. 
	defb 099h		;2d41	99 	. 
	defb 040h		;2d42	40 	@ 
l2d43h:
	defb 041h		;2d43	41 	A 
	defb 015h		;2d44	15 	. 
	defb 070h		;2d45	70 	p 
	defb 079h		;2d46	79 	y 
	defb 063h		;2d47	63 	c 
	defb 026h		;2d48	26 	& 
	defb 079h		;2d49	79 	y 
	defb 049h		;2d4a	49 	I 
l2d4bh:
	defb 040h		;2d4b	40 	@ 
	defb 026h		;2d4c	26 	& 
	defb 079h		;2d4d	79 	y 
	defb 049h		;2d4e	49 	I 
	defb 019h		;2d4f	19 	. 
	defb 024h		;2d50	24 	$ 
	defb 031h		;2d51	31 	1 
	defb 012h		;2d52	12 	. 
l2d53h:
	defb 041h		;2d53	41 	A 
	defb 017h		;2d54	17 	. 
	defb 032h		;2d55	32 	2 
	defb 005h		;2d56	05 	. 
	defb 008h		;2d57	08 	. 
	defb 007h		;2d58	07 	. 
	defb 056h		;2d59	56 	V 
	defb 089h		;2d5a	89 	. 
l2d5bh:
	defb 040h		;2d5b	40 	@ 
	defb 052h		;2d5c	52 	R 
	defb 035h		;2d5d	35 	5 
	defb 098h		;2d5e	98 	. 
	defb 077h		;2d5f	77 	w 
	defb 055h		;2d60	55 	U 
	defb 098h		;2d61	98 	. 
	defb 030h		;2d62	30 	0 
l2d63h:
	defb 040h		;2d63	40 	@ 
	defb 015h		;2d64	15 	. 
	defb 091h		;2d65	91 	. 
	defb 054h		;2d66	54 	T 
	defb 094h		;2d67	94 	. 
	defb 030h		;2d68	30 	0 
	defb 091h		;2d69	91 	. 
	defb 090h		;2d6a	90 	. 
l2d6bh:
	defb 004h		;2d6b	04 	. 
	defb 041h		;2d6c	41 	A 
	defb 010h		;2d6d	10 	. 
	defb 000h		;2d6e	00 	. 
	defb 000h		;2d6f	00 	. 
	defb 000h		;2d70	00 	. 
	defb 000h		;2d71	00 	. 
	defb 000h		;2d72	00 	. 
	defb 000h		;2d73	00 	. 
	defb 043h		;2d74	43 	C 
	defb 015h		;2d75	15 	. 
	defb 093h		;2d76	93 	. 
	defb 074h		;2d77	74 	t 
	defb 015h		;2d78	15 	. 
	defb 023h		;2d79	23 	# 
	defb 060h		;2d7a	60 	` 
	defb 031h		;2d7b	31 	1 
	defb 044h		;2d7c	44 	D 
	defb 027h		;2d7d	27 	' 
	defb 009h		;2d7e	09 	. 
	defb 031h		;2d7f	31 	1 
	defb 069h		;2d80	69 	i 
	defb 040h		;2d81	40 	@ 
	defb 085h		;2d82	85 	. 
	defb 016h		;2d83	16 	. 
	defb 044h		;2d84	44 	D 
	defb 044h		;2d85	44 	D 
	defb 097h		;2d86	97 	. 
	defb 063h		;2d87	63 	c 
	defb 035h		;2d88	35 	5 
	defb 057h		;2d89	57 	W 
	defb 040h		;2d8a	40 	@ 
	defb 058h		;2d8b	58 	X 
l2d8ch:
	defb 003h		;2d8c	03 	. 
	defb 042h		;2d8d	42 	B 
	defb 018h		;2d8e	18 	. 
	defb 031h		;2d8f	31 	1 
	defb 023h		;2d90	23 	# 
	defb 060h		;2d91	60 	` 
	defb 015h		;2d92	15 	. 
	defb 092h		;2d93	92 	. 
	defb 075h		;2d94	75 	u 
	defb 043h		;2d95	43 	C 
	defb 083h		;2d96	83 	. 
	defb 014h		;2d97	14 	. 
	defb 006h		;2d98	06 	. 
	defb 072h		;2d99	72 	r 
	defb 012h		;2d9a	12 	. 
	defb 093h		;2d9b	93 	. 
	defb 071h		;2d9c	71 	q 
	defb 044h		;2d9d	44 	D 
	defb 051h		;2d9e	51 	Q 
	defb 078h		;2d9f	78 	x 
	defb 009h		;2da0	09 	. 
	defb 019h		;2da1	19 	. 
	defb 091h		;2da2	91 	. 
	defb 051h		;2da3	51 	Q 
	defb 062h		;2da4	62 	b 
l2da5h:
	defb 004h		;2da5	04 	. 
	defb 0c0h		;2da6	c0 	. 
	defb 071h		;2da7	71 	q 
	defb 043h		;2da8	43 	C 
	defb 033h		;2da9	33 	3 
	defb 082h		;2daa	82 	. 
	defb 015h		;2dab	15 	. 
	defb 032h		;2dac	32 	2 
	defb 026h		;2dad	26 	& 
	defb 041h		;2dae	41 	A 
	defb 062h		;2daf	62 	b 
	defb 050h		;2db0	50 	P 
	defb 036h		;2db1	36 	6 
	defb 051h		;2db2	51 	Q 
	defb 012h		;2db3	12 	. 
	defb 079h		;2db4	79 	y 
	defb 008h		;2db5	08 	. 
	defb 0c2h		;2db6	c2 	. 
	defb 013h		;2db7	13 	. 
	defb 068h		;2db8	68 	h 
	defb 023h		;2db9	23 	# 
	defb 070h		;2dba	70 	p 
	defb 024h		;2dbb	24 	$ 
	defb 015h		;2dbc	15 	. 
	defb 003h		;2dbd	03 	. 
	defb 041h		;2dbe	41 	A 
	defb 085h		;2dbf	85 	. 
	defb 016h		;2dc0	16 	. 
	defb 073h		;2dc1	73 	s 
	defb 019h		;2dc2	19 	. 
	defb 087h		;2dc3	87 	. 
	defb 023h		;2dc4	23 	# 
	defb 089h		;2dc5	89 	. 
l2dc6h:
	defb 005h		;2dc6	05 	. 
	defb 041h		;2dc7	41 	A 
	defb 010h		;2dc8	10 	. 
	defb 000h		;2dc9	00 	. 
	defb 000h		;2dca	00 	. 
	defb 000h		;2dcb	00 	. 
	defb 000h		;2dcc	00 	. 
	defb 000h		;2dcd	00 	. 
	defb 000h		;2dce	00 	. 
	defb 0c2h		;2dcf	c2 	. 
	defb 013h		;2dd0	13 	. 
	defb 021h		;2dd1	21 	! 
	defb 004h		;2dd2	04 	. 
	defb 078h		;2dd3	78 	x 
	defb 035h		;2dd4	35 	5 
	defb 001h		;2dd5	01 	. 
	defb 056h		;2dd6	56 	V 
	defb 042h		;2dd7	42 	B 
	defb 047h		;2dd8	47 	G 
	defb 092h		;2dd9	92 	. 
	defb 052h		;2dda	52 	R 
	defb 056h		;2ddb	56 	V 
	defb 004h		;2ddc	04 	. 
	defb 038h		;2ddd	38 	8 
	defb 073h		;2dde	73 	s 
	defb 0c2h		;2ddf	c2 	. 
	defb 064h		;2de0	64 	d 
	defb 090h		;2de1	90 	. 
	defb 066h		;2de2	66 	f 
	defb 082h		;2de3	82 	. 
	defb 074h		;2de4	74 	t 
	defb 009h		;2de5	09 	. 
	defb 043h		;2de6	43 	C 
	defb 042h		;2de7	42 	B 
	defb 029h		;2de8	29 	) 
	defb 041h		;2de9	41 	A 
	defb 057h		;2dea	57 	W 
	defb 050h		;2deb	50 	P 
	defb 017h		;2dec	17 	. 
	defb 023h		;2ded	23 	# 
	defb 023h		;2dee	23 	# 
l2defh:
	defb 008h		;2def	08 	. 
	defb 0c0h		;2df0	c0 	. 
	defb 069h		;2df1	69 	i 
	defb 021h		;2df2	21 	! 
	defb 056h		;2df3	56 	V 
	defb 092h		;2df4	92 	. 
	defb 029h		;2df5	29 	) 
	defb 018h		;2df6	18 	. 
	defb 009h		;2df7	09 	. 
	defb 041h		;2df8	41 	A 
	defb 038h		;2df9	38 	8 
	defb 017h		;2dfa	17 	. 
	defb 028h		;2dfb	28 	( 
	defb 086h		;2dfc	86 	. 
	defb 038h		;2dfd	38 	8 
	defb 057h		;2dfe	57 	W 
	defb 071h		;2dff	71 	q 
	defb 0c2h		;2e00	c2 	. 
	defb 015h		;2e01	15 	. 
	defb 009h		;2e02	09 	. 
	defb 044h		;2e03	44 	D 
	defb 099h		;2e04	99 	. 
	defb 047h		;2e05	47 	G 
	defb 048h		;2e06	48 	H 
	defb 001h		;2e07	01 	. 
	defb 042h		;2e08	42 	B 
	defb 042h		;2e09	42 	B 
	defb 005h		;2e0a	05 	. 
	defb 086h		;2e0b	86 	. 
	defb 089h		;2e0c	89 	. 
	defb 066h		;2e0d	66 	f 
	defb 073h		;2e0e	73 	s 
	defb 055h		;2e0f	55 	U 
	defb 0c2h		;2e10	c2 	. 
	defb 076h		;2e11	76 	v 
	defb 070h		;2e12	70 	p 
	defb 058h		;2e13	58 	X 
	defb 059h		;2e14	59 	Y 
	defb 068h		;2e15	68 	h 
	defb 032h		;2e16	32 	2 
	defb 091h		;2e17	91 	. 
	defb 042h		;2e18	42 	B 
	defb 081h		;2e19	81 	. 
	defb 060h		;2e1a	60 	` 
	defb 052h		;2e1b	52 	R 
	defb 049h		;2e1c	49 	I 
	defb 027h		;2e1d	27 	' 
	defb 055h		;2e1e	55 	U 
	defb 013h		;2e1f	13 	. 
	defb 0c2h		;2e20	c2 	. 
	defb 041h		;2e21	41 	A 
	defb 034h		;2e22	34 	4 
	defb 017h		;2e23	17 	. 
	defb 002h		;2e24	02 	. 
	defb 024h		;2e25	24 	$ 
	defb 003h		;2e26	03 	. 
	defb 098h		;2e27	98 	. 
	defb 041h		;2e28	41 	A 
	defb 062h		;2e29	62 	b 
	defb 083h		;2e2a	83 	. 
	defb 018h		;2e2b	18 	. 
	defb 053h		;2e2c	53 	S 
	defb 007h		;2e2d	07 	. 
	defb 017h		;2e2e	17 	. 
	defb 096h		;2e2f	96 	. 
l2e30h:
	defb 008h		;2e30	08 	. 
	defb 0bfh		;2e31	bf 	. 
	defb 052h		;2e32	52 	R 
	defb 008h		;2e33	08 	. 
	defb 069h		;2e34	69 	i 
	defb 039h		;2e35	39 	9 
	defb 004h		;2e36	04 	. 
	defb 000h		;2e37	00 	. 
	defb 000h		;2e38	00 	. 
	defb 03fh		;2e39	3f 	? 
	defb 075h		;2e3a	75 	u 
	defb 030h		;2e3b	30 	0 
	defb 071h		;2e3c	71 	q 
	defb 049h		;2e3d	49 	I 
	defb 013h		;2e3e	13 	. 
	defb 048h		;2e3f	48 	H 
	defb 000h		;2e40	00 	. 
	defb 0bfh		;2e41	bf 	. 
	defb 090h		;2e42	90 	. 
	defb 081h		;2e43	81 	. 
	defb 034h		;2e44	34 	4 
	defb 032h		;2e45	32 	2 
	defb 024h		;2e46	24 	$ 
	defb 070h		;2e47	70 	p 
	defb 050h		;2e48	50 	P 
	defb 040h		;2e49	40 	@ 
	defb 011h		;2e4a	11 	. 
	defb 011h		;2e4b	11 	. 
	defb 007h		;2e4c	07 	. 
	defb 094h		;2e4d	94 	. 
	defb 018h		;2e4e	18 	. 
	defb 040h		;2e4f	40 	@ 
	defb 029h		;2e50	29 	) 
	defb 0c0h		;2e51	c0 	. 
	defb 014h		;2e52	14 	. 
	defb 028h		;2e53	28 	( 
	defb 057h		;2e54	57 	W 
	defb 008h		;2e55	08 	. 
	defb 055h		;2e56	55 	U 
	defb 048h		;2e57	48 	H 
	defb 084h		;2e58	84 	. 
	defb 040h		;2e59	40 	@ 
	defb 019h		;2e5a	19 	. 
	defb 099h		;2e5b	99 	. 
	defb 099h		;2e5c	99 	. 
	defb 099h		;2e5d	99 	. 
	defb 094h		;2e5e	94 	. 
	defb 089h		;2e5f	89 	. 
	defb 067h		;2e60	67 	g 
	defb 0c0h		;2e61	c0 	. 
	defb 033h		;2e62	33 	3 
	defb 033h		;2e63	33 	3 
	defb 033h		;2e64	33 	3 
	defb 033h		;2e65	33 	3 
	defb 033h		;2e66	33 	3 
	defb 031h		;2e67	31 	1 
	defb 060h		;2e68	60 	` 
	defb 041h		;2e69	41 	A 
	defb 010h		;2e6a	10 	. 
	defb 000h		;2e6b	00 	. 
	defb 000h		;2e6c	00 	. 
	defb 000h		;2e6d	00 	. 
	defb 000h		;2e6e	00 	. 
	defb 000h		;2e6f	00 	. 
	defb 000h		;2e70	00 	. 
BAS_SIGN:
	ld a,(DAC)		;2e71	3a f6 f7 	: . . 
	or a			;2e74	b7 	. 
	ret z			;2e75	c8 	. 
	cp 02fh		;2e76	fe 2f 	. / 
l2e78h:
	rla			;2e78	17 	. 
l2e79h:
	sbc a,a			;2e79	9f 	. 
	ret nz			;2e7a	c0 	. 
	inc a			;2e7b	3c 	< 
	ret			;2e7c	c9 	. 
l2e7dh:
	xor a			;2e7d	af 	. 
	ld (DAC),a		;2e7e	32 f6 f7 	2 . . 
	ret			;2e81	c9 	. 
	call sub_2ea1h		;2e82	cd a1 2e 	. . . 
	ret p			;2e85	f0 	. 
l2e86h:
	rst 28h			;2e86	ef 	. 
	jp m,l322bh		;2e87	fa 2b 32 	. + 2 
	jp z,0406dh		;2e8a	ca 6d 40 	. m @ 
sub_2e8dh:
	ld hl,DAC		;2e8d	21 f6 f7 	! . . 
	ld a,(hl)			;2e90	7e 	~ 
	or a			;2e91	b7 	. 
	ret z			;2e92	c8 	. 
	xor 080h		;2e93	ee 80 	. . 
	ld (hl),a			;2e95	77 	w 
	ret			;2e96	c9 	. 
	call sub_2ea1h		;2e97	cd a1 2e 	. . . 
sub_2e9ah:
	ld l,a			;2e9a	6f 	o 
	rla			;2e9b	17 	. 
	sbc a,a			;2e9c	9f 	. 
	ld h,a			;2e9d	67 	g 
	jp l2f99h		;2e9e	c3 99 2f 	. . / 
sub_2ea1h:
	rst 28h			;2ea1	ef 	. 
	jp z,0406dh		;2ea2	ca 6d 40 	. m @ 
	jp p,BAS_SIGN		;2ea5	f2 71 2e 	. q . 
	ld hl,(0f7f8h)		;2ea8	2a f8 f7 	* . . 
sub_2eabh:
	ld a,h			;2eab	7c 	| 
	or l			;2eac	b5 	. 
	ret z			;2ead	c8 	. 
	ld a,h			;2eae	7c 	| 
	jr l2e78h		;2eaf	18 c7 	. . 
sub_2eb1h:
	ex de,hl			;2eb1	eb 	. 
	ld hl,(0f7f8h)		;2eb2	2a f8 f7 	* . . 
	ex (sp),hl			;2eb5	e3 	. 
	push hl			;2eb6	e5 	. 
	ld hl,(DAC)		;2eb7	2a f6 f7 	* . . 
	ex (sp),hl			;2eba	e3 	. 
	push hl			;2ebb	e5 	. 
	ex de,hl			;2ebc	eb 	. 
	ret			;2ebd	c9 	. 
sub_2ebeh:
	call sub_2edfh		;2ebe	cd df 2e 	. . . 
sub_2ec1h:
	ex de,hl			;2ec1	eb 	. 
	ld (0f7f8h),hl		;2ec2	22 f8 f7 	" . . 
	ld h,b			;2ec5	60 	` 
	ld l,c			;2ec6	69 	i 
	ld (DAC),hl		;2ec7	22 f6 f7 	" . . 
	ex de,hl			;2eca	eb 	. 
	ret			;2ecb	c9 	. 
sub_2ecch:
	ld hl,(0f7f8h)		;2ecc	2a f8 f7 	* . . 
	ex de,hl			;2ecf	eb 	. 
	ld hl,(DAC)		;2ed0	2a f6 f7 	* . . 
	ld c,l			;2ed3	4d 	M 
	ld b,h			;2ed4	44 	D 
	ret			;2ed5	c9 	. 
sub_2ed6h:
	ld c,(hl)			;2ed6	4e 	N 
	inc hl			;2ed7	23 	# 
	ld b,(hl)			;2ed8	46 	F 
	inc hl			;2ed9	23 	# 
	ld e,(hl)			;2eda	5e 	^ 
	inc hl			;2edb	23 	# 
	ld d,(hl)			;2edc	56 	V 
	inc hl			;2edd	23 	# 
	ret			;2ede	c9 	. 
sub_2edfh:
	ld e,(hl)			;2edf	5e 	^ 
	inc hl			;2ee0	23 	# 
sub_2ee1h:
	ld d,(hl)			;2ee1	56 	V 
	inc hl			;2ee2	23 	# 
	ld c,(hl)			;2ee3	4e 	N 
	inc hl			;2ee4	23 	# 
	ld b,(hl)			;2ee5	46 	F 
sub_2ee6h:
	inc hl			;2ee6	23 	# 
	ret			;2ee7	c9 	. 
sub_2ee8h:
	ld de,DAC		;2ee8	11 f6 f7 	. . . 
	ld b,004h		;2eeb	06 04 	. . 
	jr sub_2ef7h		;2eed	18 08 	. . 
sub_2eefh:
	ld de,ARG		;2eef	11 47 f8 	. G . 
l2ef2h:
	ex de,hl			;2ef2	eb 	. 
l2ef3h:
	ld a,(VALTYP)		;2ef3	3a 63 f6 	: c . 
	ld b,a			;2ef6	47 	G 
sub_2ef7h:
	ld a,(de)			;2ef7	1a 	. 
	ld (hl),a			;2ef8	77 	w 
	inc de			;2ef9	13 	. 
	inc hl			;2efa	23 	# 
	djnz sub_2ef7h		;2efb	10 fa 	. . 
	ret			;2efd	c9 	. 
sub_2efeh:
	ld a,(de)			;2efe	1a 	. 
	ld (hl),a			;2eff	77 	w 
	dec de			;2f00	1b 	. 
	dec hl			;2f01	2b 	+ 
	djnz sub_2efeh		;2f02	10 fa 	. . 
	ret			;2f04	c9 	. 
l2f05h:
	ld hl,ARG		;2f05	21 47 f8 	! G . 
l2f08h:
	ld de,l2ef2h		;2f08	11 f2 2e 	. . . 
	jr l2f13h		;2f0b	18 06 	. . 
sub_2f0dh:
	ld hl,ARG		;2f0d	21 47 f8 	! G . 
sub_2f10h:
	ld de,l2ef3h		;2f10	11 f3 2e 	. . . 
l2f13h:
	push de			;2f13	d5 	. 
	ld de,DAC		;2f14	11 f6 f7 	. . . 
	ld a,(VALTYP)		;2f17	3a 63 f6 	: c . 
	cp 004h		;2f1a	fe 04 	. . 
	ret nc			;2f1c	d0 	. 
	ld de,0f7f8h		;2f1d	11 f8 f7 	. . . 
	ret			;2f20	c9 	. 
sub_2f21h:
	ld a,c			;2f21	79 	y 
	or a			;2f22	b7 	. 
	jp z,BAS_SIGN		;2f23	ca 71 2e 	. q . 
	ld hl,02e77h		;2f26	21 77 2e 	! w . 
	push hl			;2f29	e5 	. 
	call BAS_SIGN		;2f2a	cd 71 2e 	. q . 
	ld a,c			;2f2d	79 	y 
	ret z			;2f2e	c8 	. 
	ld hl,DAC		;2f2f	21 f6 f7 	! . . 
	xor (hl)			;2f32	ae 	. 
	ld a,c			;2f33	79 	y 
	ret m			;2f34	f8 	. 
	call sub_2f3bh		;2f35	cd 3b 2f 	. ; / 
	rra			;2f38	1f 	. 
	xor c			;2f39	a9 	. 
	ret			;2f3a	c9 	. 
sub_2f3bh:
	ld a,c			;2f3b	79 	y 
	cp (hl)			;2f3c	be 	. 
	ret nz			;2f3d	c0 	. 
	inc hl			;2f3e	23 	# 
	ld a,b			;2f3f	78 	x 
	cp (hl)			;2f40	be 	. 
	ret nz			;2f41	c0 	. 
	inc hl			;2f42	23 	# 
	ld a,e			;2f43	7b 	{ 
	cp (hl)			;2f44	be 	. 
	ret nz			;2f45	c0 	. 
	inc hl			;2f46	23 	# 
	ld a,d			;2f47	7a 	z 
	sub (hl)			;2f48	96 	. 
	ret nz			;2f49	c0 	. 
	pop hl			;2f4a	e1 	. 
	pop hl			;2f4b	e1 	. 
	ret			;2f4c	c9 	. 
sub_2f4dh:
	ld a,d			;2f4d	7a 	z 
	xor h			;2f4e	ac 	. 
	ld a,h			;2f4f	7c 	| 
	jp m,l2e78h		;2f50	fa 78 2e 	. x . 
	cp d			;2f53	ba 	. 
	jr nz,l2f59h		;2f54	20 03 	  . 
	ld a,l			;2f56	7d 	} 
	sub e			;2f57	93 	. 
	ret z			;2f58	c8 	. 
l2f59h:
	jp l2e79h		;2f59	c3 79 2e 	. y . 
l2f5ch:
	ld de,ARG		;2f5c	11 47 f8 	. G . 
	ld a,(de)			;2f5f	1a 	. 
	or a			;2f60	b7 	. 
	jp z,BAS_SIGN		;2f61	ca 71 2e 	. q . 
	ld hl,02e77h		;2f64	21 77 2e 	! w . 
	push hl			;2f67	e5 	. 
	call BAS_SIGN		;2f68	cd 71 2e 	. q . 
	ld a,(de)			;2f6b	1a 	. 
	ld c,a			;2f6c	4f 	O 
	ret z			;2f6d	c8 	. 
	ld hl,DAC		;2f6e	21 f6 f7 	! . . 
	xor (hl)			;2f71	ae 	. 
	ld a,c			;2f72	79 	y 
	ret m			;2f73	f8 	. 
	ld b,008h		;2f74	06 08 	. . 
l2f76h:
	ld a,(de)			;2f76	1a 	. 
	sub (hl)			;2f77	96 	. 
	jr nz,l2f80h		;2f78	20 06 	  . 
	inc de			;2f7a	13 	. 
	inc hl			;2f7b	23 	# 
	djnz l2f76h		;2f7c	10 f8 	. . 
	pop bc			;2f7e	c1 	. 
	ret			;2f7f	c9 	. 
l2f80h:
	rra			;2f80	1f 	. 
	xor c			;2f81	a9 	. 
	ret			;2f82	c9 	. 
	call l2f5ch		;2f83	cd 5c 2f 	. \ / 
	jp nz,02e77h		;2f86	c2 77 2e 	. w . 
	ret			;2f89	c9 	. 
sub_2f8ah:
	rst 28h			;2f8a	ef 	. 
	ld hl,(0f7f8h)		;2f8b	2a f8 f7 	* . . 
	ret m			;2f8e	f8 	. 
	jp z,0406dh		;2f8f	ca 6d 40 	. m @ 
	call sub_305dh		;2f92	cd 5d 30 	. ] 0 
	jp c,04067h		;2f95	da 67 40 	. g @ 
	ex de,hl			;2f98	eb 	. 
l2f99h:
	ld (0f7f8h),hl		;2f99	22 f8 f7 	" . . 
sub_2f9ch:
	ld a,002h		;2f9c	3e 02 	> . 
l2f9eh:
	ld (VALTYP),a		;2f9e	32 63 f6 	2 c . 
	ret			;2fa1	c9 	. 
sub_2fa2h:
	ld bc,l32c5h		;2fa2	01 c5 32 	. . 2 
	ld de,08076h		;2fa5	11 76 80 	. v . 
	call sub_2f21h		;2fa8	cd 21 2f 	. ! / 
	ret nz			;2fab	c0 	. 
	ld hl,08000h		;2fac	21 00 80 	! . . 
l2fafh:
	pop de			;2faf	d1 	. 
	jr l2f99h		;2fb0	18 e7 	. . 
sub_2fb2h:
	rst 28h			;2fb2	ef 	. 
	ret po			;2fb3	e0 	. 
	jp m,l2fc8h		;2fb4	fa c8 2f 	. . / 
	jp z,0406dh		;2fb7	ca 6d 40 	. m @ 
	call sub_3053h		;2fba	cd 53 30 	. S 0 
	call sub_3752h		;2fbd	cd 52 37 	. R 7 
	inc hl			;2fc0	23 	# 
	ld a,b			;2fc1	78 	x 
	or a			;2fc2	b7 	. 
	rra			;2fc3	1f 	. 
	ld b,a			;2fc4	47 	G 
	jp l2741h		;2fc5	c3 41 27 	. A ' 
l2fc8h:
	ld hl,(0f7f8h)		;2fc8	2a f8 f7 	* . . 
sub_2fcbh:
	ld a,h			;2fcb	7c 	| 
l2fcch:
	or a			;2fcc	b7 	. 
	push af			;2fcd	f5 	. 
	call m,sub_3221h		;2fce	fc 21 32 	. ! 2 
	call sub_3053h		;2fd1	cd 53 30 	. S 0 
	ex de,hl			;2fd4	eb 	. 
	ld hl,0000h		;2fd5	21 00 00 	! . . 
	ld (DAC),hl		;2fd8	22 f6 f7 	" . . 
	ld (0f7f8h),hl		;2fdb	22 f8 f7 	" . . 
	ld a,d			;2fde	7a 	z 
	or e			;2fdf	b3 	. 
	jp z,l66a7h		;2fe0	ca a7 66 	. . f 
	ld bc,l0500h		;2fe3	01 00 05 	. . . 
	ld hl,0f7f7h		;2fe6	21 f7 f7 	! . . 
	push hl			;2fe9	e5 	. 
	ld hl,DECNEG_start		;2fea	21 30 30 	! 0 0 
l2fedh:
	ld a,0ffh		;2fed	3e ff 	> . 
	push de			;2fef	d5 	. 
	ld e,(hl)			;2ff0	5e 	^ 
	inc hl			;2ff1	23 	# 
	ld d,(hl)			;2ff2	56 	V 
	inc hl			;2ff3	23 	# 
	ex (sp),hl			;2ff4	e3 	. 
	push bc			;2ff5	c5 	. 
l2ff6h:
	ld b,h			;2ff6	44 	D 
	ld c,l			;2ff7	4d 	M 
	add hl,de			;2ff8	19 	. 
	inc a			;2ff9	3c 	< 
	jr c,l2ff6h		;2ffa	38 fa 	8 . 
	ld h,b			;2ffc	60 	` 
	ld l,c			;2ffd	69 	i 
	pop bc			;2ffe	c1 	. 
	pop de			;2fff	d1 	. 
	ex de,hl			;3000	eb 	. 
	inc c			;3001	0c 	. 
	dec c			;3002	0d 	. 
	jr nz,l3010h		;3003	20 0b 	  . 
	or a			;3005	b7 	. 
	jr z,l3024h		;3006	28 1c 	( . 
	push af			;3008	f5 	. 
	ld a,040h		;3009	3e 40 	> @ 
	add a,b			;300b	80 	. 
	ld (DAC),a		;300c	32 f6 f7 	2 . . 
	pop af			;300f	f1 	. 
l3010h:
	inc c			;3010	0c 	. 
	ex (sp),hl			;3011	e3 	. 
	push af			;3012	f5 	. 
	ld a,c			;3013	79 	y 
	rra			;3014	1f 	. 
	jr nc,l301fh		;3015	30 08 	0 . 
	pop af			;3017	f1 	. 
	add a,a			;3018	87 	. 
	add a,a			;3019	87 	. 
	add a,a			;301a	87 	. 
	add a,a			;301b	87 	. 
	ld (hl),a			;301c	77 	w 
	jr l3023h		;301d	18 04 	. . 
l301fh:
	pop af			;301f	f1 	. 
	or (hl)			;3020	b6 	. 
	ld (hl),a			;3021	77 	w 
	inc hl			;3022	23 	# 
l3023h:
	ex (sp),hl			;3023	e3 	. 
l3024h:
	ld a,d			;3024	7a 	z 
	or e			;3025	b3 	. 
	jr z,l302ah		;3026	28 02 	( . 
	djnz l2fedh		;3028	10 c3 	. . 
l302ah:
	pop hl			;302a	e1 	. 
	pop af			;302b	f1 	. 
	ret p			;302c	f0 	. 
	jp sub_2e8dh		;302d	c3 8d 2e 	. . . 

; BLOCK 'DECNEG' (start 0x3030 end 0x303a)
DECNEG_start:
	defw 0d8f0h		;3030	f0 d8 	. . 
	defw 0fc18h		;3032	18 fc 	. . 
	defw 0ff9ch		;3034	9c ff 	. . 
	defw 0fff6h		;3036	f6 ff 	. . 
	defw 0ffffh		;3038	ff ff 	. . 
FRCDBL:
	rst 28h			;303a	ef 	. 
	ret nc			;303b	d0 	. 
	jp z,0406dh		;303c	ca 6d 40 	. m @ 
	call m,l2fc8h		;303f	fc c8 2f 	. . / 
sub_3042h:
	ld hl,0000h		;3042	21 00 00 	! . . 
	ld (0f7fah),hl		;3045	22 fa f7 	" . . 
	ld (0f7fch),hl		;3048	22 fc f7 	" . . 
	ld a,h			;304b	7c 	| 
	ld (0f7feh),a		;304c	32 fe f7 	2 . . 
sub_304fh:
	ld a,008h		;304f	3e 08 	> . 
	jr l3055h		;3051	18 02 	. . 
sub_3053h:
	ld a,004h		;3053	3e 04 	> . 
l3055h:
	jp l2f9eh		;3055	c3 9e 2f 	. . / 
sub_3058h:
	rst 28h			;3058	ef 	. 
	ret z			;3059	c8 	. 
	jp 0406dh		;305a	c3 6d 40 	. m @ 
sub_305dh:
	ld hl,l30bah		;305d	21 ba 30 	! . 0 
	push hl			;3060	e5 	. 
	ld hl,DAC		;3061	21 f6 f7 	! . . 
	ld a,(hl)			;3064	7e 	~ 
	and 07fh		;3065	e6 7f 	.  
	cp 046h		;3067	fe 46 	. F 
	ret nc			;3069	d0 	. 
	sub 041h		;306a	d6 41 	. A 
	jr nc,l3074h		;306c	30 06 	0 . 
	or a			;306e	b7 	. 
	pop de			;306f	d1 	. 
	ld de,0000h		;3070	11 00 00 	. . . 
	ret			;3073	c9 	. 
l3074h:
	inc a			;3074	3c 	< 
	ld b,a			;3075	47 	G 
	ld de,0000h		;3076	11 00 00 	. . . 
	ld c,d			;3079	4a 	J 
	inc hl			;307a	23 	# 
l307bh:
	ld a,c			;307b	79 	y 
	inc c			;307c	0c 	. 
	rra			;307d	1f 	. 
	ld a,(hl)			;307e	7e 	~ 
	jr c,l3087h		;307f	38 06 	8 . 
	rra			;3081	1f 	. 
	rra			;3082	1f 	. 
	rra			;3083	1f 	. 
	rra			;3084	1f 	. 
	jr l3088h		;3085	18 01 	. . 
l3087h:
	inc hl			;3087	23 	# 
l3088h:
	and 00fh		;3088	e6 0f 	. . 
	ld (DECTMP),hl		;308a	22 f0 f7 	" . . 
	ld h,d			;308d	62 	b 
	ld l,e			;308e	6b 	k 
	add hl,hl			;308f	29 	) 
	ret c			;3090	d8 	. 
	add hl,hl			;3091	29 	) 
	ret c			;3092	d8 	. 
	add hl,de			;3093	19 	. 
	ret c			;3094	d8 	. 
	add hl,hl			;3095	29 	) 
	ret c			;3096	d8 	. 
	ld e,a			;3097	5f 	_ 
	ld d,000h		;3098	16 00 	. . 
	add hl,de			;309a	19 	. 
	ret c			;309b	d8 	. 
	ex de,hl			;309c	eb 	. 
	ld hl,(DECTMP)		;309d	2a f0 f7 	* . . 
	djnz l307bh		;30a0	10 d9 	. . 
	ld hl,08000h		;30a2	21 00 80 	! . . 
	rst 20h			;30a5	e7 	. 
	ld a,(DAC)		;30a6	3a f6 f7 	: . . 
	ret c			;30a9	d8 	. 
	jr z,l30b6h		;30aa	28 0a 	( . 
	pop hl			;30ac	e1 	. 
	or a			;30ad	b7 	. 
	ret p			;30ae	f0 	. 
	ex de,hl			;30af	eb 	. 
	call sub_3221h		;30b0	cd 21 32 	. ! 2 
	ex de,hl			;30b3	eb 	. 
	or a			;30b4	b7 	. 
	ret			;30b5	c9 	. 
l30b6h:
	or a			;30b6	b7 	. 
	ret p			;30b7	f0 	. 
	pop hl			;30b8	e1 	. 
	ret			;30b9	c9 	. 
l30bah:
	scf			;30ba	37 	7 
	ret			;30bb	c9 	. 
	dec bc			;30bc	0b 	. 
	ret			;30bd	c9 	. 
	rst 28h			;30be	ef 	. 
	ret m			;30bf	f8 	. 
	call BAS_SIGN		;30c0	cd 71 2e 	. q . 
	jp p,sub_30cfh		;30c3	f2 cf 30 	. . 0 
	call sub_2e8dh		;30c6	cd 8d 2e 	. . . 
	call sub_30cfh		;30c9	cd cf 30 	. . 0 
	jp l2e86h		;30cc	c3 86 2e 	. . . 
sub_30cfh:
	rst 28h			;30cf	ef 	. 
	ret m			;30d0	f8 	. 
	ld hl,0f7feh		;30d1	21 fe f7 	! . . 
	ld c,00eh		;30d4	0e 0e 	. . 
	jr nc,l30e0h		;30d6	30 08 	0 . 
	jp z,0406dh		;30d8	ca 6d 40 	. m @ 
	ld hl,0f7fah		;30db	21 fa f7 	! . . 
	ld c,006h		;30de	0e 06 	. . 
l30e0h:
	ld a,(DAC)		;30e0	3a f6 f7 	: . . 
	or a			;30e3	b7 	. 
	jp m,l3100h		;30e4	fa 00 31 	. . 1 
	and 07fh		;30e7	e6 7f 	.  
	sub 041h		;30e9	d6 41 	. A 
	jp c,l2e7dh		;30eb	da 7d 2e 	. } . 
	inc a			;30ee	3c 	< 
	sub c			;30ef	91 	. 
	ret nc			;30f0	d0 	. 
	cpl			;30f1	2f 	/ 
	inc a			;30f2	3c 	< 
	ld b,a			;30f3	47 	G 
l30f4h:
	dec hl			;30f4	2b 	+ 
	ld a,(hl)			;30f5	7e 	~ 
	and 0f0h		;30f6	e6 f0 	. . 
	ld (hl),a			;30f8	77 	w 
	dec b			;30f9	05 	. 
	ret z			;30fa	c8 	. 
	xor a			;30fb	af 	. 
	ld (hl),a			;30fc	77 	w 
	djnz l30f4h		;30fd	10 f5 	. . 
	ret			;30ff	c9 	. 
l3100h:
	and 07fh		;3100	e6 7f 	.  
	sub 041h		;3102	d6 41 	. A 
	jr nc,l310ch		;3104	30 06 	0 . 
	ld hl,0ffffh		;3106	21 ff ff 	! . . 
	jp l2f99h		;3109	c3 99 2f 	. . / 
l310ch:
	inc a			;310c	3c 	< 
	sub c			;310d	91 	. 
	ret nc			;310e	d0 	. 
	cpl			;310f	2f 	/ 
	inc a			;3110	3c 	< 
	ld b,a			;3111	47 	G 
	ld e,000h		;3112	1e 00 	. . 
l3114h:
	dec hl			;3114	2b 	+ 
	ld a,(hl)			;3115	7e 	~ 
	ld d,a			;3116	57 	W 
	and 0f0h		;3117	e6 f0 	. . 
	ld (hl),a			;3119	77 	w 
	cp d			;311a	ba 	. 
	jr z,l311eh		;311b	28 01 	( . 
	inc e			;311d	1c 	. 
l311eh:
	dec b			;311e	05 	. 
	jr z,l3129h		;311f	28 08 	( . 
	xor a			;3121	af 	. 
	ld (hl),a			;3122	77 	w 
	cp d			;3123	ba 	. 
	jr z,l3127h		;3124	28 01 	( . 
	inc e			;3126	1c 	. 
l3127h:
	djnz l3114h		;3127	10 eb 	. . 
l3129h:
	inc e			;3129	1c 	. 
	dec e			;312a	1d 	. 
	ret z			;312b	c8 	. 
	ld a,c			;312c	79 	y 
	cp 006h		;312d	fe 06 	. . 
	ld bc,l10c1h		;312f	01 c1 10 	. . . 
	ld de,0000h		;3132	11 00 00 	. . . 
	jp z,l324eh		;3135	ca 4e 32 	. N 2 
	ex de,hl			;3138	eb 	. 
	ld (0f84dh),hl		;3139	22 4d f8 	" M . 
	ld (0f84bh),hl		;313c	22 4b f8 	" K . 
	ld (0f849h),hl		;313f	22 49 f8 	" I . 
	ld h,b			;3142	60 	` 
	ld l,c			;3143	69 	i 
	ld (ARG),hl		;3144	22 47 f8 	" G . 
	jp sub_269ah		;3147	c3 9a 26 	. . & 
sub_314ah:
	push hl			;314a	e5 	. 
	ld hl,0000h		;314b	21 00 00 	! . . 
	ld a,b			;314e	78 	x 
	or c			;314f	b1 	. 
	jr z,l3164h		;3150	28 12 	( . 
	ld a,010h		;3152	3e 10 	> . 
l3154h:
	add hl,hl			;3154	29 	) 
	jp c,l601dh		;3155	da 1d 60 	. . ` 
	ex de,hl			;3158	eb 	. 
	add hl,hl			;3159	29 	) 
	ex de,hl			;315a	eb 	. 
	jr nc,l3161h		;315b	30 04 	0 . 
	add hl,bc			;315d	09 	. 
	jp c,l601dh		;315e	da 1d 60 	. . ` 
l3161h:
	dec a			;3161	3d 	= 
	jr nz,l3154h		;3162	20 f0 	  . 
l3164h:
	ex de,hl			;3164	eb 	. 
	pop hl			;3165	e1 	. 
	ret			;3166	c9 	. 
	ld a,h			;3167	7c 	| 
	rla			;3168	17 	. 
	sbc a,a			;3169	9f 	. 
	ld b,a			;316a	47 	G 
	call sub_3221h		;316b	cd 21 32 	. ! 2 
	ld a,c			;316e	79 	y 
	sbc a,b			;316f	98 	. 
	jr l3175h		;3170	18 03 	. . 
sub_3172h:
	ld a,h			;3172	7c 	| 
	rla			;3173	17 	. 
	sbc a,a			;3174	9f 	. 
l3175h:
	ld b,a			;3175	47 	G 
	push hl			;3176	e5 	. 
	ld a,d			;3177	7a 	z 
	rla			;3178	17 	. 
	sbc a,a			;3179	9f 	. 
	add hl,de			;317a	19 	. 
	adc a,b			;317b	88 	. 
	rrca			;317c	0f 	. 
	xor h			;317d	ac 	. 
	jp p,l2fafh		;317e	f2 af 2f 	. . / 
	push bc			;3181	c5 	. 
	ex de,hl			;3182	eb 	. 
	call sub_2fcbh		;3183	cd cb 2f 	. . / 
	pop af			;3186	f1 	. 
	pop hl			;3187	e1 	. 
	call sub_2eb1h		;3188	cd b1 2e 	. . . 
	call sub_2fcbh		;318b	cd cb 2f 	. . / 
	pop bc			;318e	c1 	. 
	pop de			;318f	d1 	. 
	jp l324eh		;3190	c3 4e 32 	. N 2 
sub_3193h:
	ld a,h			;3193	7c 	| 
	or l			;3194	b5 	. 
	jp z,l2f99h		;3195	ca 99 2f 	. . / 
	push hl			;3198	e5 	. 
	push de			;3199	d5 	. 
	call sub_3215h		;319a	cd 15 32 	. . 2 
	push bc			;319d	c5 	. 
	ld b,h			;319e	44 	D 
	ld c,l			;319f	4d 	M 
	ld hl,0000h		;31a0	21 00 00 	! . . 
	ld a,010h		;31a3	3e 10 	> . 
l31a5h:
	add hl,hl			;31a5	29 	) 
	jr c,l31c7h		;31a6	38 1f 	8 . 
	ex de,hl			;31a8	eb 	. 
	add hl,hl			;31a9	29 	) 
	ex de,hl			;31aa	eb 	. 
	jr nc,l31b0h		;31ab	30 03 	0 . 
	add hl,bc			;31ad	09 	. 
	jr c,l31c7h		;31ae	38 17 	8 . 
l31b0h:
	dec a			;31b0	3d 	= 
	jr nz,l31a5h		;31b1	20 f2 	  . 
	pop bc			;31b3	c1 	. 
	pop de			;31b4	d1 	. 
l31b5h:
	ld a,h			;31b5	7c 	| 
	or a			;31b6	b7 	. 
	jp m,l31bfh		;31b7	fa bf 31 	. . 1 
	pop de			;31ba	d1 	. 
	ld a,b			;31bb	78 	x 
	jp l321dh		;31bc	c3 1d 32 	. . 2 
l31bfh:
	xor 080h		;31bf	ee 80 	. . 
	or l			;31c1	b5 	. 
	jr z,l31d8h		;31c2	28 14 	( . 
	ex de,hl			;31c4	eb 	. 
	jr l31c9h		;31c5	18 02 	. . 
l31c7h:
	pop bc			;31c7	c1 	. 
	pop hl			;31c8	e1 	. 
l31c9h:
	call sub_2fcbh		;31c9	cd cb 2f 	. . / 
	pop hl			;31cc	e1 	. 
	call sub_2eb1h		;31cd	cd b1 2e 	. . . 
	call sub_2fcbh		;31d0	cd cb 2f 	. . / 
	pop bc			;31d3	c1 	. 
	pop de			;31d4	d1 	. 
	jp l325ch		;31d5	c3 5c 32 	. \ 2 
l31d8h:
	ld a,b			;31d8	78 	x 
	or a			;31d9	b7 	. 
	pop bc			;31da	c1 	. 
	jp m,l2f99h		;31db	fa 99 2f 	. . / 
	push de			;31de	d5 	. 
	call sub_2fcbh		;31df	cd cb 2f 	. . / 
	pop de			;31e2	d1 	. 
	jp sub_2e8dh		;31e3	c3 8d 2e 	. . . 
sub_31e6h:
	ld a,h			;31e6	7c 	| 
l31e7h:
	or l			;31e7	b5 	. 
	jp z,04058h		;31e8	ca 58 40 	. X @ 
	call sub_3215h		;31eb	cd 15 32 	. . 2 
	push bc			;31ee	c5 	. 
	ex de,hl			;31ef	eb 	. 
	call sub_3221h		;31f0	cd 21 32 	. ! 2 
	ld b,h			;31f3	44 	D 
	ld c,l			;31f4	4d 	M 
	ld hl,0000h		;31f5	21 00 00 	! . . 
	ld a,011h		;31f8	3e 11 	> . 
	or a			;31fa	b7 	. 
	jr l3206h		;31fb	18 09 	. . 
l31fdh:
	push hl			;31fd	e5 	. 
	add hl,bc			;31fe	09 	. 
	jr nc,$+6		;31ff	30 04 	0 . 
	inc sp			;3201	33 	3 
	inc sp			;3202	33 	3 
	scf			;3203	37 	7 
	jr nc,l31e7h		;3204	30 e1 	0 . 
l3206h:
	rl e		;3206	cb 13 	. . 
	rl d		;3208	cb 12 	. . 
	adc hl,hl		;320a	ed 6a 	. j 
	dec a			;320c	3d 	= 
	jr nz,l31fdh		;320d	20 ee 	  . 
	ex de,hl			;320f	eb 	. 
	pop bc			;3210	c1 	. 
	push de			;3211	d5 	. 
	jp l31b5h		;3212	c3 b5 31 	. . 1 
sub_3215h:
	ld a,h			;3215	7c 	| 
	xor d			;3216	aa 	. 
	ld b,a			;3217	47 	G 
	call sub_321ch		;3218	cd 1c 32 	. . 2 
	ex de,hl			;321b	eb 	. 
sub_321ch:
	ld a,h			;321c	7c 	| 
l321dh:
	or a			;321d	b7 	. 
l321eh:
	jp p,l2f99h		;321e	f2 99 2f 	. . / 
sub_3221h:
	xor a			;3221	af 	. 
	ld c,a			;3222	4f 	O 
	sub l			;3223	95 	. 
	ld l,a			;3224	6f 	o 
	ld a,c			;3225	79 	y 
	sbc a,h			;3226	9c 	. 
	ld h,a			;3227	67 	g 
	jp l2f99h		;3228	c3 99 2f 	. . / 
l322bh:
	ld hl,(0f7f8h)		;322b	2a f8 f7 	* . . 
	call sub_3221h		;322e	cd 21 32 	. ! 2 
	ld a,h			;3231	7c 	| 
	xor 080h		;3232	ee 80 	. . 
	or l			;3234	b5 	. 
	ret nz			;3235	c0 	. 
l3236h:
	xor a			;3236	af 	. 
	jp l2fcch		;3237	c3 cc 2f 	. . / 
l323ah:
	push de			;323a	d5 	. 
	call sub_31e6h		;323b	cd e6 31 	. . 1 
	xor a			;323e	af 	. 
	add a,d			;323f	82 	. 
	rra			;3240	1f 	. 
	ld h,a			;3241	67 	g 
	ld a,e			;3242	7b 	{ 
	rra			;3243	1f 	. 
	ld l,a			;3244	6f 	o 
l3245h:
	call sub_2f9ch		;3245	cd 9c 2f 	. . / 
	pop af			;3248	f1 	. 
	jr l321dh		;3249	18 d2 	. . 
	call sub_2edfh		;324b	cd df 2e 	. . . 
l324eh:
	call sub_3280h		;324e	cd 80 32 	. . 2 
	call sub_3042h		;3251	cd 42 30 	. B 0 
	jp sub_269ah		;3254	c3 9a 26 	. . & 
	call sub_2e8dh		;3257	cd 8d 2e 	. . . 
	jr l324eh		;325a	18 f2 	. . 
l325ch:
	call sub_3280h		;325c	cd 80 32 	. . 2 
	call sub_3042h		;325f	cd 42 30 	. B 0 
	jp sub_27e6h		;3262	c3 e6 27 	. . ' 
l3265h:
	pop bc			;3265	c1 	. 
	pop de			;3266	d1 	. 
sub_3267h:
	ld hl,(0f7f8h)		;3267	2a f8 f7 	* . . 
	ex de,hl			;326a	eb 	. 
	ld (0f7f8h),hl		;326b	22 f8 f7 	" . . 
	push bc			;326e	c5 	. 
	ld hl,(DAC)		;326f	2a f6 f7 	* . . 
	ex (sp),hl			;3272	e3 	. 
	ld (DAC),hl		;3273	22 f6 f7 	" . . 
	pop bc			;3276	c1 	. 
	call sub_3280h		;3277	cd 80 32 	. . 2 
	call sub_3042h		;327a	cd 42 30 	. B 0 
	jp l289fh		;327d	c3 9f 28 	. . ( 
sub_3280h:
	ex de,hl			;3280	eb 	. 
	ld (0f849h),hl		;3281	22 49 f8 	" I . 
	ld h,b			;3284	60 	` 
	ld l,c			;3285	69 	i 
	ld (ARG),hl		;3286	22 47 f8 	" G . 
	ld hl,0000h		;3289	21 00 00 	! . . 
	ld (0f84bh),hl		;328c	22 4b f8 	" K . 
	ld (0f84dh),hl		;328f	22 4d f8 	" M . 
	ret			;3292	c9 	. 
sub_3293h:
	dec a			;3293	3d 	= 
	ret			;3294	c9 	. 
sub_3295h:
	dec hl			;3295	2b 	+ 
	ret			;3296	c9 	. 
l3297h:
	pop hl			;3297	e1 	. 
	ret			;3298	c9 	. 
sub_3299h:
	ex de,hl			;3299	eb 	. 
	ld bc,LEFTC		;329a	01 ff 00 	. . . 
	ld h,b			;329d	60 	` 
	ld l,b			;329e	68 	h 
	call l2f99h		;329f	cd 99 2f 	. . / 
	ex de,hl			;32a2	eb 	. 
	ld a,(hl)			;32a3	7e 	~ 
	cp 026h		;32a4	fe 26 	. & 
	jp z,l4eb8h		;32a6	ca b8 4e 	. . N 
	cp 02dh		;32a9	fe 2d 	. - 
	push af			;32ab	f5 	. 
	jr z,l32b3h		;32ac	28 05 	( . 
	cp 02bh		;32ae	fe 2b 	. + 
	jr z,l32b3h		;32b0	28 01 	( . 
	dec hl			;32b2	2b 	+ 
l32b3h:
	rst 10h			;32b3	d7 	. 
	jp c,l3386h		;32b4	da 86 33 	. . 3 
	cp 02eh		;32b7	fe 2e 	. . 
	jp z,l334fh		;32b9	ca 4f 33 	. O 3 
	cp 065h		;32bc	fe 65 	. e 
	jr z,l32c2h		;32be	28 02 	( . 
	cp 045h		;32c0	fe 45 	. E 
l32c2h:
	jr nz,l32deh		;32c2	20 1a 	  . 
	push hl			;32c4	e5 	. 
l32c5h:
	rst 10h			;32c5	d7 	. 
	cp 06ch		;32c6	fe 6c 	. l 
	jr z,l32d4h		;32c8	28 0a 	( . 
	cp 04ch		;32ca	fe 4c 	. L 
	jr z,l32d4h		;32cc	28 06 	( . 
	cp 071h		;32ce	fe 71 	. q 
	jr z,l32d4h		;32d0	28 02 	( . 
	cp 051h		;32d2	fe 51 	. Q 
l32d4h:
	pop hl			;32d4	e1 	. 
	jr z,l32ddh		;32d5	28 06 	( . 
	rst 28h			;32d7	ef 	. 
	jr nc,l32f5h		;32d8	30 1b 	0 . 
	xor a			;32da	af 	. 
	jr l32f6h		;32db	18 19 	. . 
l32ddh:
	ld a,(hl)			;32dd	7e 	~ 
l32deh:
	cp 025h		;32de	fe 25 	. % 
	jp z,l3362h		;32e0	ca 62 33 	. b 3 
	cp 023h		;32e3	fe 23 	. # 
	jp z,l3370h		;32e5	ca 70 33 	. p 3 
	cp 021h		;32e8	fe 21 	. ! 
	jp z,l3371h		;32ea	ca 71 33 	. q 3 
	cp 064h		;32ed	fe 64 	. d 
	jr z,l32f5h		;32ef	28 04 	( . 
	cp 044h		;32f1	fe 44 	. D 
	jr nz,l331eh		;32f3	20 29 	  ) 
l32f5h:
	or a			;32f5	b7 	. 
l32f6h:
	call sub_3377h		;32f6	cd 77 33 	. w 3 
	rst 10h			;32f9	d7 	. 
	push de			;32fa	d5 	. 
	ld d,000h		;32fb	16 00 	. . 
	call sub_4f47h		;32fd	cd 47 4f 	. G O 
	ld c,d			;3300	4a 	J 
	pop de			;3301	d1 	. 
l3302h:
	rst 10h			;3302	d7 	. 
	jr nc,l3318h		;3303	30 13 	0 . 
	ld a,e			;3305	7b 	{ 
	cp 00ch		;3306	fe 0c 	. . 
	jr nc,l3314h		;3308	30 0a 	0 . 
	rlca			;330a	07 	. 
	rlca			;330b	07 	. 
	add a,e			;330c	83 	. 
	rlca			;330d	07 	. 
	add a,(hl)			;330e	86 	. 
	sub 030h		;330f	d6 30 	. 0 
	ld e,a			;3311	5f 	_ 
	jr l3302h		;3312	18 ee 	. . 
l3314h:
	ld e,080h		;3314	1e 80 	. . 
	jr l3302h		;3316	18 ea 	. . 
l3318h:
	inc c			;3318	0c 	. 
	jr nz,l331eh		;3319	20 03 	  . 
	xor a			;331b	af 	. 
	sub e			;331c	93 	. 
	ld e,a			;331d	5f 	_ 
l331eh:
	rst 28h			;331e	ef 	. 
	jp m,l3334h		;331f	fa 34 33 	. 4 3 
	ld a,(DAC)		;3322	3a f6 f7 	: . . 
	or a			;3325	b7 	. 
	jr z,l3334h		;3326	28 0c 	( . 
	ld a,d			;3328	7a 	z 
	sub b			;3329	90 	. 
	add a,e			;332a	83 	. 
	add a,040h		;332b	c6 40 	. @ 
	ld (DAC),a		;332d	32 f6 f7 	2 . . 
	or a			;3330	b7 	. 
	call m,sub_334ch		;3331	fc 4c 33 	. L 3 
l3334h:
	pop af			;3334	f1 	. 
	push hl			;3335	e5 	. 
	call z,l2e86h		;3336	cc 86 2e 	. . . 
	rst 28h			;3339	ef 	. 
	jr nc,l3347h		;333a	30 0b 	0 . 
	pop hl			;333c	e1 	. 
	ret pe			;333d	e8 	. 
	push hl			;333e	e5 	. 
	ld hl,l3297h		;333f	21 97 32 	! . 2 
	push hl			;3342	e5 	. 
	call sub_2fa2h		;3343	cd a2 2f 	. . / 
	ret			;3346	c9 	. 
l3347h:
	call l273ch		;3347	cd 3c 27 	. < ' 
	pop hl			;334a	e1 	. 
	ret			;334b	c9 	. 
sub_334ch:
	jp 04067h		;334c	c3 67 40 	. g @ 
l334fh:
	rst 28h			;334f	ef 	. 
	inc c			;3350	0c 	. 
	jr nz,l331eh		;3351	20 cb 	  . 
	jr nc,l335fh		;3353	30 0a 	0 . 
	call sub_3377h		;3355	cd 77 33 	. w 3 
	ld a,(DAC)		;3358	3a f6 f7 	: . . 
	or a			;335b	b7 	. 
	jr nz,l335fh		;335c	20 01 	  . 
	ld d,a			;335e	57 	W 
l335fh:
	jp l32b3h		;335f	c3 b3 32 	. . 2 
l3362h:
	rst 10h			;3362	d7 	. 
	pop af			;3363	f1 	. 
	push hl			;3364	e5 	. 
	ld hl,l3297h		;3365	21 97 32 	! . 2 
	push hl			;3368	e5 	. 
	ld hl,sub_2f8ah		;3369	21 8a 2f 	! . / 
	push hl			;336c	e5 	. 
	push af			;336d	f5 	. 
	jr l331eh		;336e	18 ae 	. . 
l3370h:
	or a			;3370	b7 	. 
l3371h:
	call sub_3377h		;3371	cd 77 33 	. w 3 
	rst 10h			;3374	d7 	. 
	jr l331eh		;3375	18 a7 	. . 
sub_3377h:
	push hl			;3377	e5 	. 
	push de			;3378	d5 	. 
	push bc			;3379	c5 	. 
	push af			;337a	f5 	. 
	call z,sub_2fb2h		;337b	cc b2 2f 	. . / 
	pop af			;337e	f1 	. 
	call nz,FRCDBL		;337f	c4 3a 30 	. : 0 
	pop bc			;3382	c1 	. 
	pop de			;3383	d1 	. 
	pop hl			;3384	e1 	. 
	ret			;3385	c9 	. 
l3386h:
	sub 030h		;3386	d6 30 	. 0 
	jp nz,l3393h		;3388	c2 93 33 	. . 3 
	or c			;338b	b1 	. 
	jp z,l3393h		;338c	ca 93 33 	. . 3 
	and d			;338f	a2 	. 
	jp z,l32b3h		;3390	ca b3 32 	. . 2 
l3393h:
	inc d			;3393	14 	. 
	ld a,d			;3394	7a 	z 
	cp 007h		;3395	fe 07 	. . 
	jr nz,l339dh		;3397	20 04 	  . 
	or a			;3399	b7 	. 
	call sub_3377h		;339a	cd 77 33 	. w 3 
l339dh:
	push de			;339d	d5 	. 
	ld a,b			;339e	78 	x 
	add a,c			;339f	81 	. 
	inc a			;33a0	3c 	< 
	ld b,a			;33a1	47 	G 
	push bc			;33a2	c5 	. 
	push hl			;33a3	e5 	. 
	ld a,(hl)			;33a4	7e 	~ 
	sub 030h		;33a5	d6 30 	. 0 
	push af			;33a7	f5 	. 
	rst 28h			;33a8	ef 	. 
	jp p,l33d1h		;33a9	f2 d1 33 	. . 3 
	ld hl,(0f7f8h)		;33ac	2a f8 f7 	* . . 
	ld de,00ccdh		;33af	11 cd 0c 	. . . 
	rst 20h			;33b2	e7 	. 
	jr nc,l33ceh		;33b3	30 19 	0 . 
	ld d,h			;33b5	54 	T 
	ld e,l			;33b6	5d 	] 
	add hl,hl			;33b7	29 	) 
	add hl,hl			;33b8	29 	) 
	add hl,de			;33b9	19 	. 
	add hl,hl			;33ba	29 	) 
	pop af			;33bb	f1 	. 
	ld c,a			;33bc	4f 	O 
	add hl,bc			;33bd	09 	. 
	ld a,h			;33be	7c 	| 
	or a			;33bf	b7 	. 
	jp m,l33cch		;33c0	fa cc 33 	. . 3 
	ld (0f7f8h),hl		;33c3	22 f8 f7 	" . . 
l33c6h:
	pop hl			;33c6	e1 	. 
	pop bc			;33c7	c1 	. 
	pop de			;33c8	d1 	. 
	jp l32b3h		;33c9	c3 b3 32 	. . 2 
l33cch:
	ld a,c			;33cc	79 	y 
	push af			;33cd	f5 	. 
l33ceh:
	call l2fc8h		;33ce	cd c8 2f 	. . / 
l33d1h:
	pop af			;33d1	f1 	. 
	pop hl			;33d2	e1 	. 
	pop bc			;33d3	c1 	. 
	pop de			;33d4	d1 	. 
	jr nz,l33e3h		;33d5	20 0c 	  . 
	ld a,(DAC)		;33d7	3a f6 f7 	: . . 
	or a			;33da	b7 	. 
	ld a,000h		;33db	3e 00 	> . 
	jr nz,l33e3h		;33dd	20 04 	  . 
	ld d,a			;33df	57 	W 
	jp l32b3h		;33e0	c3 b3 32 	. . 2 
l33e3h:
	push de			;33e3	d5 	. 
	push bc			;33e4	c5 	. 
	push hl			;33e5	e5 	. 
	push af			;33e6	f5 	. 
	ld hl,DAC		;33e7	21 f6 f7 	! . . 
	ld (hl),001h		;33ea	36 01 	6 . 
	ld a,d			;33ec	7a 	z 
	cp 010h		;33ed	fe 10 	. . 
	jr c,l33f4h		;33ef	38 03 	8 . 
	pop af			;33f1	f1 	. 
	jr l33c6h		;33f2	18 d2 	. . 
l33f4h:
	inc a			;33f4	3c 	< 
	or a			;33f5	b7 	. 
	rra			;33f6	1f 	. 
	ld b,000h		;33f7	06 00 	. . 
	ld c,a			;33f9	4f 	O 
	add hl,bc			;33fa	09 	. 
	pop af			;33fb	f1 	. 
	ld c,a			;33fc	4f 	O 
	ld a,d			;33fd	7a 	z 
	rra			;33fe	1f 	. 
	ld a,c			;33ff	79 	y 
	jr nc,l3406h		;3400	30 04 	0 . 
	add a,a			;3402	87 	. 
	add a,a			;3403	87 	. 
	add a,a			;3404	87 	. 
	add a,a			;3405	87 	. 
l3406h:
	or (hl)			;3406	b6 	. 
	ld (hl),a			;3407	77 	w 
	jr l33c6h		;3408	18 bc 	. . 
sub_340ah:
	push hl			;340a	e5 	. 
	ld hl,l3fd2h		;340b	21 d2 3f 	! . ? 
	call sub_6678h		;340e	cd 78 66 	. x f 
	pop hl			;3411	e1 	. 
sub_3412h:
	ld bc,l6677h		;3412	01 77 66 	. w f 
	push bc			;3415	c5 	. 
	call l2f99h		;3416	cd 99 2f 	. . / 
	xor a			;3419	af 	. 
	ld (TEMP3),a		;341a	32 9d f6 	2 . . 
	ld hl,0f7c6h		;341d	21 c6 f7 	! . . 
	ld (hl),020h		;3420	36 20 	6   
	or (hl)			;3422	b6 	. 
	jr l3441h		;3423	18 1c 	. . 
sub_3425h:
	xor a			;3425	af 	. 
sub_3426h:
	call sub_375fh		;3426	cd 5f 37 	. _ 7 
	and 008h		;3429	e6 08 	. . 
	jr z,l342fh		;342b	28 02 	( . 
	ld (hl),02bh		;342d	36 2b 	6 + 
l342fh:
	ex de,hl			;342f	eb 	. 
	call sub_2ea1h		;3430	cd a1 2e 	. . . 
	ex de,hl			;3433	eb 	. 
	jp p,l3441h		;3434	f2 41 34 	. A 4 
	ld (hl),02dh		;3437	36 2d 	6 - 
	push bc			;3439	c5 	. 
	push hl			;343a	e5 	. 
	call l2e86h		;343b	cd 86 2e 	. . . 
	pop hl			;343e	e1 	. 
	pop bc			;343f	c1 	. 
	or h			;3440	b4 	. 
l3441h:
	inc hl			;3441	23 	# 
	ld (hl),030h		;3442	36 30 	6 0 
	ld a,(TEMP3)		;3444	3a 9d f6 	: . . 
	ld d,a			;3447	57 	W 
	rla			;3448	17 	. 
	ld a,(VALTYP)		;3449	3a 63 f6 	: c . 
	jp c,l34f7h		;344c	da f7 34 	. . 4 
	jp z,l34efh		;344f	ca ef 34 	. . 4 
	cp 004h		;3452	fe 04 	. . 
	jp nc,l34a1h		;3454	d2 a1 34 	. . 4 
	ld bc,0000h		;3457	01 00 00 	. . . 
	call sub_36dbh		;345a	cd db 36 	. . 6 
sub_345dh:
	ld hl,0f7c6h		;345d	21 c6 f7 	! . . 
	ld b,(hl)			;3460	46 	F 
	ld c,020h		;3461	0e 20 	.   
	ld a,(TEMP3)		;3463	3a 9d f6 	: . . 
	ld e,a			;3466	5f 	_ 
	and 020h		;3467	e6 20 	.   
	jr z,l3477h		;3469	28 0c 	( . 
	ld a,b			;346b	78 	x 
	cp c			;346c	b9 	. 
	ld c,02ah		;346d	0e 2a 	. * 
	jr nz,l3477h		;346f	20 06 	  . 
	ld a,e			;3471	7b 	{ 
	and 004h		;3472	e6 04 	. . 
	jr nz,l3477h		;3474	20 01 	  . 
	ld b,c			;3476	41 	A 
l3477h:
	ld (hl),c			;3477	71 	q 
	rst 10h			;3478	d7 	. 
	jr z,l348fh		;3479	28 14 	( . 
	cp 045h		;347b	fe 45 	. E 
	jr z,l348fh		;347d	28 10 	( . 
	cp 044h		;347f	fe 44 	. D 
	jr z,l348fh		;3481	28 0c 	( . 
	cp 030h		;3483	fe 30 	. 0 
	jr z,l3477h		;3485	28 f0 	( . 
	cp 02ch		;3487	fe 2c 	. , 
	jr z,l3477h		;3489	28 ec 	( . 
	cp 02eh		;348b	fe 2e 	. . 
	jr nz,l3492h		;348d	20 03 	  . 
l348fh:
	dec hl			;348f	2b 	+ 
	ld (hl),030h		;3490	36 30 	6 0 
l3492h:
	ld a,e			;3492	7b 	{ 
	and 010h		;3493	e6 10 	. . 
	jr z,l349ah		;3495	28 03 	( . 
	dec hl			;3497	2b 	+ 
	ld (hl),024h		;3498	36 24 	6 $ 
l349ah:
	ld a,e			;349a	7b 	{ 
	and 004h		;349b	e6 04 	. . 
	ret nz			;349d	c0 	. 
	dec hl			;349e	2b 	+ 
	ld (hl),b			;349f	70 	p 
	ret			;34a0	c9 	. 
l34a1h:
	push hl			;34a1	e5 	. 
	call sub_3752h		;34a2	cd 52 37 	. R 7 
	ld d,b			;34a5	50 	P 
	inc d			;34a6	14 	. 
	ld bc,00300h		;34a7	01 00 03 	. . . 
	ld a,(DAC)		;34aa	3a f6 f7 	: . . 
	sub 03fh		;34ad	d6 3f 	. ? 
	jr c,l34b9h		;34af	38 08 	8 . 
	inc d			;34b1	14 	. 
	cp d			;34b2	ba 	. 
	jr nc,l34b9h		;34b3	30 04 	0 . 
	inc a			;34b5	3c 	< 
	ld b,a			;34b6	47 	G 
	ld a,002h		;34b7	3e 02 	> . 
l34b9h:
	sub 002h		;34b9	d6 02 	. . 
	pop hl			;34bb	e1 	. 
	push af			;34bc	f5 	. 
	call sub_368eh		;34bd	cd 8e 36 	. . 6 
	ld (hl),030h		;34c0	36 30 	6 0 
	call z,sub_2ee6h		;34c2	cc e6 2e 	. . . 
	call sub_36b3h		;34c5	cd b3 36 	. . 6 
l34c8h:
	dec hl			;34c8	2b 	+ 
	ld a,(hl)			;34c9	7e 	~ 
	cp 030h		;34ca	fe 30 	. 0 
	jr z,l34c8h		;34cc	28 fa 	( . 
	cp 02eh		;34ce	fe 2e 	. . 
	call nz,sub_2ee6h		;34d0	c4 e6 2e 	. . . 
	pop af			;34d3	f1 	. 
	jr z,l34f0h		;34d4	28 1a 	( . 
sub_34d6h:
	ld (hl),045h		;34d6	36 45 	6 E 
	inc hl			;34d8	23 	# 
	ld (hl),02bh		;34d9	36 2b 	6 + 
	jp p,l34e2h		;34db	f2 e2 34 	. . 4 
	ld (hl),02dh		;34de	36 2d 	6 - 
	cpl			;34e0	2f 	/ 
	inc a			;34e1	3c 	< 
l34e2h:
	ld b,02fh		;34e2	06 2f 	. / 
l34e4h:
	inc b			;34e4	04 	. 
	sub 00ah		;34e5	d6 0a 	. . 
	jr nc,l34e4h		;34e7	30 fb 	0 . 
	add a,03ah		;34e9	c6 3a 	. : 
	inc hl			;34eb	23 	# 
	ld (hl),b			;34ec	70 	p 
	inc hl			;34ed	23 	# 
	ld (hl),a			;34ee	77 	w 
l34efh:
	inc hl			;34ef	23 	# 
l34f0h:
	ld (hl),000h		;34f0	36 00 	6 . 
	ex de,hl			;34f2	eb 	. 
	ld hl,0f7c6h		;34f3	21 c6 f7 	! . . 
	ret			;34f6	c9 	. 
l34f7h:
	inc hl			;34f7	23 	# 
	push bc			;34f8	c5 	. 
	cp 004h		;34f9	fe 04 	. . 
	ld a,d			;34fb	7a 	z 
	jp nc,l3566h		;34fc	d2 66 35 	. f 5 
	rra			;34ff	1f 	. 
	jp c,l35efh		;3500	da ef 35 	. . 5 
	ld bc,ENASCR_DO		;3503	01 03 06 	. . . 
	call sub_3686h		;3506	cd 86 36 	. . 6 
	pop de			;3509	d1 	. 
	ld a,d			;350a	7a 	z 
	sub 005h		;350b	d6 05 	. . 
	call p,sub_3666h		;350d	f4 66 36 	. f 6 
	call sub_36dbh		;3510	cd db 36 	. . 6 
l3513h:
	ld a,e			;3513	7b 	{ 
	or a			;3514	b7 	. 
	call z,sub_3295h		;3515	cc 95 32 	. . 2 
	dec a			;3518	3d 	= 
	call p,sub_3666h		;3519	f4 66 36 	. f 6 
l351ch:
	push hl			;351c	e5 	. 
	call sub_345dh		;351d	cd 5d 34 	. ] 4 
	pop hl			;3520	e1 	. 
	jr z,l3525h		;3521	28 02 	( . 
	ld (hl),b			;3523	70 	p 
	inc hl			;3524	23 	# 
l3525h:
	ld (hl),000h		;3525	36 00 	6 . 
	ld hl,FBUFFR		;3527	21 c5 f7 	! . . 
l352ah:
	inc hl			;352a	23 	# 
l352bh:
	ld a,(TEMP2)		;352b	3a bc f6 	: . . 
	sub l			;352e	95 	. 
	sub d			;352f	92 	. 
	ret z			;3530	c8 	. 
	ld a,(hl)			;3531	7e 	~ 
	cp 020h		;3532	fe 20 	.   
	jr z,l352ah		;3534	28 f4 	( . 
	cp 02ah		;3536	fe 2a 	. * 
	jr z,l352ah		;3538	28 f0 	( . 
	dec hl			;353a	2b 	+ 
	push hl			;353b	e5 	. 
l353ch:
	push af			;353c	f5 	. 
	ld bc,l353ch		;353d	01 3c 35 	. < 5 
	push bc			;3540	c5 	. 
	rst 10h			;3541	d7 	. 
	cp 02dh		;3542	fe 2d 	. - 
	ret z			;3544	c8 	. 
	cp 02bh		;3545	fe 2b 	. + 
	ret z			;3547	c8 	. 
	cp 024h		;3548	fe 24 	. $ 
	ret z			;354a	c8 	. 
	pop bc			;354b	c1 	. 
	cp 030h		;354c	fe 30 	. 0 
	jr nz,l355fh		;354e	20 0f 	  . 
	inc hl			;3550	23 	# 
	rst 10h			;3551	d7 	. 
	jr nc,l355fh		;3552	30 0b 	0 . 
	dec hl			;3554	2b 	+ 
	jr l3559h		;3555	18 02 	. . 
l3557h:
	dec hl			;3557	2b 	+ 
	ld (hl),a			;3558	77 	w 
l3559h:
	pop af			;3559	f1 	. 
	jr z,l3557h		;355a	28 fb 	( . 
	pop bc			;355c	c1 	. 
	jr l352bh		;355d	18 cc 	. . 
l355fh:
	pop af			;355f	f1 	. 
	jr z,l355fh		;3560	28 fd 	( . 
	pop hl			;3562	e1 	. 
	ld (hl),025h		;3563	36 25 	6 % 
	ret			;3565	c9 	. 
l3566h:
	push hl			;3566	e5 	. 
	rra			;3567	1f 	. 
	jp c,l35f5h		;3568	da f5 35 	. . 5 
	call sub_3752h		;356b	cd 52 37 	. R 7 
	ld d,b			;356e	50 	P 
	ld a,(DAC)		;356f	3a f6 f7 	: . . 
	sub 04fh		;3572	d6 4f 	. O 
	jr c,l3581h		;3574	38 0b 	8 . 
	pop hl			;3576	e1 	. 
	pop bc			;3577	c1 	. 
	call sub_3425h		;3578	cd 25 34 	. % 4 
	ld hl,FBUFFR		;357b	21 c5 f7 	! . . 
	ld (hl),025h		;357e	36 25 	6 % 
	ret			;3580	c9 	. 
l3581h:
	call BAS_SIGN		;3581	cd 71 2e 	. q . 
	call nz,sub_37a2h		;3584	c4 a2 37 	. . 7 
	pop hl			;3587	e1 	. 
	pop bc			;3588	c1 	. 
	jp m,l35a6h		;3589	fa a6 35 	. . 5 
	push bc			;358c	c5 	. 
	ld e,a			;358d	5f 	_ 
	ld a,b			;358e	78 	x 
	sub d			;358f	92 	. 
	sub e			;3590	93 	. 
	call p,sub_3666h		;3591	f4 66 36 	. f 6 
	call sub_367ah		;3594	cd 7a 36 	. z 6 
	call sub_36b3h		;3597	cd b3 36 	. . 6 
	or e			;359a	b3 	. 
	call nz,sub_3674h		;359b	c4 74 36 	. t 6 
	or e			;359e	b3 	. 
	call nz,sub_36a0h		;359f	c4 a0 36 	. . 6 
	pop de			;35a2	d1 	. 
	jp l3513h		;35a3	c3 13 35 	. . 5 
l35a6h:
	ld e,a			;35a6	5f 	_ 
	ld a,c			;35a7	79 	y 
	or a			;35a8	b7 	. 
	call nz,sub_3293h		;35a9	c4 93 32 	. . 2 
	add a,e			;35ac	83 	. 
	jp m,l35b1h		;35ad	fa b1 35 	. . 5 
	xor a			;35b0	af 	. 
l35b1h:
	push bc			;35b1	c5 	. 
	push af			;35b2	f5 	. 
	call m,sub_377bh		;35b3	fc 7b 37 	. { 7 
	pop bc			;35b6	c1 	. 
	ld a,e			;35b7	7b 	{ 
	sub b			;35b8	90 	. 
	pop bc			;35b9	c1 	. 
	ld e,a			;35ba	5f 	_ 
	add a,d			;35bb	82 	. 
	ld a,b			;35bc	78 	x 
	jp m,l35cbh		;35bd	fa cb 35 	. . 5 
	sub d			;35c0	92 	. 
	sub e			;35c1	93 	. 
	call p,sub_3666h		;35c2	f4 66 36 	. f 6 
	push bc			;35c5	c5 	. 
	call sub_367ah		;35c6	cd 7a 36 	. z 6 
	jr l35dch		;35c9	18 11 	. . 
l35cbh:
	call sub_3666h		;35cb	cd 66 36 	. f 6 
	ld a,c			;35ce	79 	y 
	call sub_36a3h		;35cf	cd a3 36 	. . 6 
	ld c,a			;35d2	4f 	O 
	xor a			;35d3	af 	. 
	sub d			;35d4	92 	. 
	sub e			;35d5	93 	. 
	call sub_3666h		;35d6	cd 66 36 	. f 6 
	push bc			;35d9	c5 	. 
	ld b,a			;35da	47 	G 
	ld c,a			;35db	4f 	O 
l35dch:
	call sub_36b3h		;35dc	cd b3 36 	. . 6 
	pop bc			;35df	c1 	. 
	or c			;35e0	b1 	. 
	jr nz,l35e6h		;35e1	20 03 	  . 
	ld hl,(TEMP2)		;35e3	2a bc f6 	* . . 
l35e6h:
	add a,e			;35e6	83 	. 
	dec a			;35e7	3d 	= 
	call p,sub_3666h		;35e8	f4 66 36 	. f 6 
	ld d,b			;35eb	50 	P 
	jp l351ch		;35ec	c3 1c 35 	. . 5 
l35efh:
	push hl			;35ef	e5 	. 
	push de			;35f0	d5 	. 
	call l2fc8h		;35f1	cd c8 2f 	. . / 
	pop de			;35f4	d1 	. 
l35f5h:
	call sub_3752h		;35f5	cd 52 37 	. R 7 
	ld e,b			;35f8	58 	X 
	call BAS_SIGN		;35f9	cd 71 2e 	. q . 
	push af			;35fc	f5 	. 
	call nz,sub_37a2h		;35fd	c4 a2 37 	. . 7 
	pop af			;3600	f1 	. 
	pop hl			;3601	e1 	. 
	pop bc			;3602	c1 	. 
	push af			;3603	f5 	. 
	ld a,c			;3604	79 	y 
	or a			;3605	b7 	. 
	push af			;3606	f5 	. 
	call nz,sub_3293h		;3607	c4 93 32 	. . 2 
	add a,b			;360a	80 	. 
	ld c,a			;360b	4f 	O 
	ld a,d			;360c	7a 	z 
	and 004h		;360d	e6 04 	. . 
	cp 001h		;360f	fe 01 	. . 
	sbc a,a			;3611	9f 	. 
	ld d,a			;3612	57 	W 
	add a,c			;3613	81 	. 
	ld c,a			;3614	4f 	O 
	sub e			;3615	93 	. 
	push af			;3616	f5 	. 
	jp p,l3628h		;3617	f2 28 36 	. ( 6 
	call sub_377bh		;361a	cd 7b 37 	. { 7 
	jr nz,l3628h		;361d	20 09 	  . 
	push hl			;361f	e5 	. 
	call sub_27dbh		;3620	cd db 27 	. . ' 
	ld hl,DAC		;3623	21 f6 f7 	! . . 
	inc (hl)			;3626	34 	4 
	pop hl			;3627	e1 	. 
l3628h:
	pop af			;3628	f1 	. 
	push bc			;3629	c5 	. 
	push af			;362a	f5 	. 
	jp m,l362fh		;362b	fa 2f 36 	. / 6 
	xor a			;362e	af 	. 
l362fh:
	cpl			;362f	2f 	/ 
	inc a			;3630	3c 	< 
	add a,b			;3631	80 	. 
	inc a			;3632	3c 	< 
	add a,d			;3633	82 	. 
	ld b,a			;3634	47 	G 
	ld c,000h		;3635	0e 00 	. . 
	call z,sub_368eh		;3637	cc 8e 36 	. . 6 
	call sub_36b3h		;363a	cd b3 36 	. . 6 
	pop af			;363d	f1 	. 
	call p,sub_366eh		;363e	f4 6e 36 	. n 6 
	call sub_36a0h		;3641	cd a0 36 	. . 6 
	pop bc			;3644	c1 	. 
	pop af			;3645	f1 	. 
	jr nz,l3654h		;3646	20 0c 	  . 
	call sub_3295h		;3648	cd 95 32 	. . 2 
	ld a,(hl)			;364b	7e 	~ 
	cp 02eh		;364c	fe 2e 	. . 
	call nz,sub_2ee6h		;364e	c4 e6 2e 	. . . 
	ld (TEMP2),hl		;3651	22 bc f6 	" . . 
l3654h:
	pop af			;3654	f1 	. 
	ld a,(DAC)		;3655	3a f6 f7 	: . . 
	jr z,l365dh		;3658	28 03 	( . 
	add a,e			;365a	83 	. 
	sub b			;365b	90 	. 
	sub d			;365c	92 	. 
l365dh:
	push bc			;365d	c5 	. 
	call sub_34d6h		;365e	cd d6 34 	. . 4 
	ex de,hl			;3661	eb 	. 
	pop de			;3662	d1 	. 
	jp l351ch		;3663	c3 1c 35 	. . 5 
sub_3666h:
	or a			;3666	b7 	. 
l3667h:
	ret z			;3667	c8 	. 
	dec a			;3668	3d 	= 
	ld (hl),030h		;3669	36 30 	6 0 
	inc hl			;366b	23 	# 
	jr l3667h		;366c	18 f9 	. . 
sub_366eh:
	jr nz,sub_3674h		;366e	20 04 	  . 
l3670h:
	ret z			;3670	c8 	. 
	call sub_36a0h		;3671	cd a0 36 	. . 6 
sub_3674h:
	ld (hl),030h		;3674	36 30 	6 0 
	inc hl			;3676	23 	# 
	dec a			;3677	3d 	= 
	jr l3670h		;3678	18 f6 	. . 
sub_367ah:
	ld a,e			;367a	7b 	{ 
	add a,d			;367b	82 	. 
	inc a			;367c	3c 	< 
	ld b,a			;367d	47 	G 
	inc a			;367e	3c 	< 
l367fh:
	sub 003h		;367f	d6 03 	. . 
	jr nc,l367fh		;3681	30 fc 	0 . 
	add a,005h		;3683	c6 05 	. . 
	ld c,a			;3685	4f 	O 
sub_3686h:
	ld a,(TEMP3)		;3686	3a 9d f6 	: . . 
	and 040h		;3689	e6 40 	. @ 
	ret nz			;368b	c0 	. 
	ld c,a			;368c	4f 	O 
	ret			;368d	c9 	. 
sub_368eh:
	dec b			;368e	05 	. 
	jp p,l36a1h		;368f	f2 a1 36 	. . 6 
	ld (TEMP2),hl		;3692	22 bc f6 	" . . 
	ld (hl),02eh		;3695	36 2e 	6 . 
l3697h:
	inc hl			;3697	23 	# 
	ld (hl),030h		;3698	36 30 	6 0 
	inc b			;369a	04 	. 
	ld c,b			;369b	48 	H 
	jr nz,l3697h		;369c	20 f9 	  . 
	inc hl			;369e	23 	# 
	ret			;369f	c9 	. 
sub_36a0h:
	dec b			;36a0	05 	. 
l36a1h:
	jr nz,l36abh		;36a1	20 08 	  . 
sub_36a3h:
	ld (hl),02eh		;36a3	36 2e 	6 . 
	ld (TEMP2),hl		;36a5	22 bc f6 	" . . 
	inc hl			;36a8	23 	# 
	ld c,b			;36a9	48 	H 
	ret			;36aa	c9 	. 
l36abh:
	dec c			;36ab	0d 	. 
	ret nz			;36ac	c0 	. 
	ld (hl),02ch		;36ad	36 2c 	6 , 
	inc hl			;36af	23 	# 
	ld c,003h		;36b0	0e 03 	. . 
	ret			;36b2	c9 	. 
sub_36b3h:
	push de			;36b3	d5 	. 
	push hl			;36b4	e5 	. 
	push bc			;36b5	c5 	. 
	call sub_3752h		;36b6	cd 52 37 	. R 7 
	ld a,b			;36b9	78 	x 
	pop bc			;36ba	c1 	. 
	pop hl			;36bb	e1 	. 
	ld de,0f7f7h		;36bc	11 f7 f7 	. . . 
	scf			;36bf	37 	7 
l36c0h:
	push af			;36c0	f5 	. 
	call sub_36a0h		;36c1	cd a0 36 	. . 6 
	ld a,(de)			;36c4	1a 	. 
	jr nc,l36cdh		;36c5	30 06 	0 . 
	rra			;36c7	1f 	. 
	rra			;36c8	1f 	. 
	rra			;36c9	1f 	. 
	rra			;36ca	1f 	. 
	jr l36ceh		;36cb	18 01 	. . 
l36cdh:
	inc de			;36cd	13 	. 
l36ceh:
	and 00fh		;36ce	e6 0f 	. . 
	add a,030h		;36d0	c6 30 	. 0 
	ld (hl),a			;36d2	77 	w 
	inc hl			;36d3	23 	# 
	pop af			;36d4	f1 	. 
	dec a			;36d5	3d 	= 
	ccf			;36d6	3f 	? 
	jr nz,l36c0h		;36d7	20 e7 	  . 
	jr l370ah		;36d9	18 2f 	. / 
sub_36dbh:
	push de			;36db	d5 	. 
	ld de,DECPOS_start		;36dc	11 10 37 	. . 7 
	ld a,005h		;36df	3e 05 	> . 
l36e1h:
	call sub_36a0h		;36e1	cd a0 36 	. . 6 
	push bc			;36e4	c5 	. 
	push af			;36e5	f5 	. 
	push hl			;36e6	e5 	. 
	ex de,hl			;36e7	eb 	. 
	ld c,(hl)			;36e8	4e 	N 
	inc hl			;36e9	23 	# 
	ld b,(hl)			;36ea	46 	F 
	push bc			;36eb	c5 	. 
	inc hl			;36ec	23 	# 
	ex (sp),hl			;36ed	e3 	. 
	ex de,hl			;36ee	eb 	. 
	ld hl,(0f7f8h)		;36ef	2a f8 f7 	* . . 
	ld b,02fh		;36f2	06 2f 	. / 
l36f4h:
	inc b			;36f4	04 	. 
	ld a,l			;36f5	7d 	} 
	sub e			;36f6	93 	. 
	ld l,a			;36f7	6f 	o 
	ld a,h			;36f8	7c 	| 
	sbc a,d			;36f9	9a 	. 
	ld h,a			;36fa	67 	g 
	jr nc,l36f4h		;36fb	30 f7 	0 . 
	add hl,de			;36fd	19 	. 
	ld (0f7f8h),hl		;36fe	22 f8 f7 	" . . 
	pop de			;3701	d1 	. 
	pop hl			;3702	e1 	. 
	ld (hl),b			;3703	70 	p 
	inc hl			;3704	23 	# 
	pop af			;3705	f1 	. 
	pop bc			;3706	c1 	. 
	dec a			;3707	3d 	= 
	jr nz,l36e1h		;3708	20 d7 	  . 
l370ah:
	call sub_36a0h		;370a	cd a0 36 	. . 6 
	ld (hl),a			;370d	77 	w 
	pop de			;370e	d1 	. 
	ret			;370f	c9 	. 

; BLOCK 'DECPOS' (start 0x3710 end 0x371a)
DECPOS_start:
	defw 02710h		;3710	10 27 	. ' 
	defw 003e8h		;3712	e8 03 	. . 
	defw 00064h		;3714	64 00 	d . 
	defw 0000ah		;3716	0a 00 	. . 
	defw 00001h		;3718	01 00 	. . 
FOUTB:
	ld b,001h		;371a	06 01 	. . 
	jr l3724h		;371c	18 06 	. . 
l371eh:
	ld b,003h		;371e	06 03 	. . 
	jr l3724h		;3720	18 02 	. . 
l3722h:
	ld b,004h		;3722	06 04 	. . 
l3724h:
	push bc			;3724	c5 	. 
	call sub_5439h		;3725	cd 39 54 	. 9 T 
	ld de,0f7d6h		;3728	11 d6 f7 	. . . 
	xor a			;372b	af 	. 
	ld (de),a			;372c	12 	. 
	pop bc			;372d	c1 	. 
	ld c,a			;372e	4f 	O 
l372fh:
	push bc			;372f	c5 	. 
	dec de			;3730	1b 	. 
l3731h:
	and a			;3731	a7 	. 
	ld a,h			;3732	7c 	| 
	rra			;3733	1f 	. 
	ld h,a			;3734	67 	g 
	ld a,l			;3735	7d 	} 
	rra			;3736	1f 	. 
	ld l,a			;3737	6f 	o 
	ld a,c			;3738	79 	y 
	rra			;3739	1f 	. 
	ld c,a			;373a	4f 	O 
	djnz l3731h		;373b	10 f4 	. . 
	pop bc			;373d	c1 	. 
	push bc			;373e	c5 	. 
l373fh:
	rlca			;373f	07 	. 
	djnz l373fh		;3740	10 fd 	. . 
	add a,030h		;3742	c6 30 	. 0 
	cp 03ah		;3744	fe 3a 	. : 
	jr c,l374ah		;3746	38 02 	8 . 
	add a,007h		;3748	c6 07 	. . 
l374ah:
	ld (de),a			;374a	12 	. 
	pop bc			;374b	c1 	. 
	ld a,l			;374c	7d 	} 
	or h			;374d	b4 	. 
	jr nz,l372fh		;374e	20 df 	  . 
	ex de,hl			;3750	eb 	. 
	ret			;3751	c9 	. 
sub_3752h:
	rst 28h			;3752	ef 	. 
	ld hl,0f7fdh		;3753	21 fd f7 	! . . 
	ld b,00eh		;3756	06 0e 	. . 
	ret nc			;3758	d0 	. 
	ld hl,0f7f9h		;3759	21 f9 f7 	! . . 
	ld b,006h		;375c	06 06 	. . 
	ret			;375e	c9 	. 
sub_375fh:
	ld (TEMP3),a		;375f	32 9d f6 	2 . . 
	push af			;3762	f5 	. 
	push bc			;3763	c5 	. 
	push de			;3764	d5 	. 
	call FRCDBL		;3765	cd 3a 30 	. : 0 
	ld hl,l2d13h		;3768	21 13 2d 	! . - 
	ld a,(DAC)		;376b	3a f6 f7 	: . . 
	and a			;376e	a7 	. 
	call z,sub_2c5ch		;376f	cc 5c 2c 	. \ , 
	pop de			;3772	d1 	. 
	pop bc			;3773	c1 	. 
	pop af			;3774	f1 	. 
	ld hl,0f7c6h		;3775	21 c6 f7 	! . . 
	ld (hl),020h		;3778	36 20 	6   
	ret			;377a	c9 	. 
sub_377bh:
	push hl			;377b	e5 	. 
	push de			;377c	d5 	. 
	push bc			;377d	c5 	. 
	push af			;377e	f5 	. 
	cpl			;377f	2f 	/ 
	inc a			;3780	3c 	< 
	ld e,a			;3781	5f 	_ 
	ld a,001h		;3782	3e 01 	> . 
	jp z,l379ch		;3784	ca 9c 37 	. . 7 
	call sub_3752h		;3787	cd 52 37 	. R 7 
	push hl			;378a	e5 	. 
l378bh:
	call sub_27dbh		;378b	cd db 27 	. . ' 
	dec e			;378e	1d 	. 
	jr nz,l378bh		;378f	20 fa 	  . 
	pop hl			;3791	e1 	. 
	inc hl			;3792	23 	# 
	ld a,b			;3793	78 	x 
	rrca			;3794	0f 	. 
	ld b,a			;3795	47 	G 
	call l2741h		;3796	cd 41 27 	. A ' 
	call sub_37b4h		;3799	cd b4 37 	. . 7 
l379ch:
	pop bc			;379c	c1 	. 
	add a,b			;379d	80 	. 
	pop bc			;379e	c1 	. 
	pop de			;379f	d1 	. 
	pop hl			;37a0	e1 	. 
	ret			;37a1	c9 	. 
sub_37a2h:
	push bc			;37a2	c5 	. 
	push hl			;37a3	e5 	. 
	call sub_3752h		;37a4	cd 52 37 	. R 7 
	ld a,(DAC)		;37a7	3a f6 f7 	: . . 
	sub 040h		;37aa	d6 40 	. @ 
	sub b			;37ac	90 	. 
	ld (DAC),a		;37ad	32 f6 f7 	2 . . 
	pop hl			;37b0	e1 	. 
	pop bc			;37b1	c1 	. 
	or a			;37b2	b7 	. 
	ret			;37b3	c9 	. 
sub_37b4h:
	push bc			;37b4	c5 	. 
	call sub_3752h		;37b5	cd 52 37 	. R 7 
l37b8h:
	ld a,(hl)			;37b8	7e 	~ 
	and 00fh		;37b9	e6 0f 	. . 
	jr nz,l37c5h		;37bb	20 08 	  . 
	dec b			;37bd	05 	. 
	ld a,(hl)			;37be	7e 	~ 
	or a			;37bf	b7 	. 
	jr nz,l37c5h		;37c0	20 03 	  . 
	dec hl			;37c2	2b 	+ 
	djnz l37b8h		;37c3	10 f3 	. . 
l37c5h:
	ld a,b			;37c5	78 	x 
	pop bc			;37c6	c1 	. 
	ret			;37c7	c9 	. 
	call sub_3280h		;37c8	cd 80 32 	. . 2 
	call sub_3042h		;37cb	cd 42 30 	. B 0 
	call sub_2cc7h		;37ce	cd c7 2c 	. . , 
	call sub_2c6fh		;37d1	cd 6f 2c 	. o , 
	call sub_2cdch		;37d4	cd dc 2c 	. . , 
	ld a,(ARG)		;37d7	3a 47 f8 	: G . 
	or a			;37da	b7 	. 
	jp z,l3843h		;37db	ca 43 38 	. C 8 
	ld h,a			;37de	67 	g 
	ld a,(DAC)		;37df	3a f6 f7 	: . . 
	or a			;37e2	b7 	. 
	jp z,l384dh		;37e3	ca 4d 38 	. M 8 
	call sub_2ccch		;37e6	cd cc 2c 	. . , 
	call sub_391ah		;37e9	cd 1a 39 	. . 9 
	jr c,l382ah		;37ec	38 3c 	8 < 
	ex de,hl			;37ee	eb 	. 
	ld (TEMP8),hl		;37ef	22 9f f6 	" . . 
	call sub_304fh		;37f2	cd 4f 30 	. O 0 
	call sub_2cdch		;37f5	cd dc 2c 	. . , 
	call sub_391ah		;37f8	cd 1a 39 	. . 9 
	call sub_304fh		;37fb	cd 4f 30 	. O 0 
	ld hl,(TEMP8)		;37fe	2a 9f f6 	* . . 
	jp nc,l385ah		;3801	d2 5a 38 	. Z 8 
	ld a,(ARG)		;3804	3a 47 f8 	: G . 
	push af			;3807	f5 	. 
	push hl			;3808	e5 	. 
	call l2c59h		;3809	cd 59 2c 	. Y , 
	ld hl,FBUFFR		;380c	21 c5 f7 	! . . 
	call sub_2c67h		;380f	cd 67 2c 	. g , 
	ld hl,l2d1bh		;3812	21 1b 2d 	! . - 
	call sub_2c5ch		;3815	cd 5c 2c 	. \ , 
	pop hl			;3818	e1 	. 
	ld a,h			;3819	7c 	| 
	or a			;381a	b7 	. 
	push af			;381b	f5 	. 
	jp p,l3826h		;381c	f2 26 38 	. & 8 
	xor a			;381f	af 	. 
	ld c,a			;3820	4f 	O 
	sub l			;3821	95 	. 
	ld l,a			;3822	6f 	o 
	ld a,c			;3823	79 	y 
	sbc a,h			;3824	9c 	. 
	ld h,a			;3825	67 	g 
l3826h:
	push hl			;3826	e5 	. 
	jp l3894h		;3827	c3 94 38 	. . 8 
l382ah:
	call sub_304fh		;382a	cd 4f 30 	. O 0 
	call l2c59h		;382d	cd 59 2c 	. Y , 
	call sub_2c6fh		;3830	cd 6f 2c 	. o , 
	call sub_2a72h		;3833	cd 72 2a 	. r * 
	call sub_2cdch		;3836	cd dc 2c 	. . , 
	call sub_27e6h		;3839	cd e6 27 	. . ' 
	jp l2b4ah		;383c	c3 4a 2b 	. J + 
	ld a,h			;383f	7c 	| 
	or l			;3840	b5 	. 
	jr nz,l3849h		;3841	20 06 	  . 
l3843h:
	ld hl,0001h		;3843	21 01 00 	! . . 
	jp l3857h		;3846	c3 57 38 	. W 8 
l3849h:
	ld a,d			;3849	7a 	z 
	or e			;384a	b3 	. 
	jr nz,l385ah		;384b	20 0d 	  . 
l384dh:
	ld a,h			;384d	7c 	| 
	rla			;384e	17 	. 
	jr nc,l3854h		;384f	30 03 	0 . 
	jp 04058h		;3851	c3 58 40 	. X @ 
l3854h:
	ld hl,0000h		;3854	21 00 00 	! . . 
l3857h:
	jp l2f99h		;3857	c3 99 2f 	. . / 
l385ah:
	ld (TEMP8),hl		;385a	22 9f f6 	" . . 
	push de			;385d	d5 	. 
	ld a,h			;385e	7c 	| 
	or a			;385f	b7 	. 
	push af			;3860	f5 	. 
	call m,sub_3221h		;3861	fc 21 32 	. ! 2 
	ld b,h			;3864	44 	D 
	ld c,l			;3865	4d 	M 
	ld hl,0001h		;3866	21 01 00 	! . . 
l3869h:
	or a			;3869	b7 	. 
	ld a,b			;386a	78 	x 
	rra			;386b	1f 	. 
	ld b,a			;386c	47 	G 
	ld a,c			;386d	79 	y 
	rra			;386e	1f 	. 
	ld c,a			;386f	4f 	O 
	jr nc,l3877h		;3870	30 05 	0 . 
	call sub_390dh		;3872	cd 0d 39 	. . 9 
	jr nz,l38c3h		;3875	20 4c 	  L 
l3877h:
	ld a,b			;3877	78 	x 
	or c			;3878	b1 	. 
	jr z,l38deh		;3879	28 63 	( c 
	push hl			;387b	e5 	. 
	ld h,d			;387c	62 	b 
	ld l,e			;387d	6b 	k 
	call sub_390dh		;387e	cd 0d 39 	. . 9 
	ex de,hl			;3881	eb 	. 
	pop hl			;3882	e1 	. 
	jr z,l3869h		;3883	28 e4 	( . 
	push bc			;3885	c5 	. 
	push hl			;3886	e5 	. 
	ld hl,FBUFFR		;3887	21 c5 f7 	! . . 
	call sub_2c67h		;388a	cd 67 2c 	. g , 
	pop hl			;388d	e1 	. 
	call sub_2fcbh		;388e	cd cb 2f 	. . / 
	call sub_3042h		;3891	cd 42 30 	. B 0 
l3894h:
	pop bc			;3894	c1 	. 
	ld a,b			;3895	78 	x 
	or a			;3896	b7 	. 
	rra			;3897	1f 	. 
	ld b,a			;3898	47 	G 
	ld a,c			;3899	79 	y 
	rra			;389a	1f 	. 
	ld c,a			;389b	4f 	O 
	jr nc,l38a6h		;389c	30 08 	0 . 
	push bc			;389e	c5 	. 
	ld hl,FBUFFR		;389f	21 c5 f7 	! . . 
	call sub_2c3bh		;38a2	cd 3b 2c 	. ; , 
	pop bc			;38a5	c1 	. 
l38a6h:
	ld a,b			;38a6	78 	x 
	or c			;38a7	b1 	. 
	jr z,l38deh		;38a8	28 34 	( 4 
	push bc			;38aa	c5 	. 
	call sub_2ccch		;38ab	cd cc 2c 	. . , 
	ld hl,FBUFFR		;38ae	21 c5 f7 	! . . 
	push hl			;38b1	e5 	. 
	call sub_2c5ch		;38b2	cd 5c 2c 	. \ , 
	pop hl			;38b5	e1 	. 
	push hl			;38b6	e5 	. 
	call sub_2c3bh		;38b7	cd 3b 2c 	. ; , 
	pop hl			;38ba	e1 	. 
	call sub_2c67h		;38bb	cd 67 2c 	. g , 
	call sub_2ce1h		;38be	cd e1 2c 	. . , 
	jr l3894h		;38c1	18 d1 	. . 
l38c3h:
	push bc			;38c3	c5 	. 
	push de			;38c4	d5 	. 
	call FRCDBL		;38c5	cd 3a 30 	. : 0 
	call sub_2c4dh		;38c8	cd 4d 2c 	. M , 
	pop hl			;38cb	e1 	. 
	call sub_2fcbh		;38cc	cd cb 2f 	. . / 
	call sub_3042h		;38cf	cd 42 30 	. B 0 
	ld hl,FBUFFR		;38d2	21 c5 f7 	! . . 
	call sub_2c67h		;38d5	cd 67 2c 	. g , 
	call l2c59h		;38d8	cd 59 2c 	. Y , 
	pop bc			;38db	c1 	. 
	jr l38a6h		;38dc	18 c8 	. . 
l38deh:
	pop af			;38de	f1 	. 
	pop bc			;38df	c1 	. 
	ret p			;38e0	f0 	. 
	ld a,(VALTYP)		;38e1	3a 63 f6 	: c . 
	cp 002h		;38e4	fe 02 	. . 
	jr nz,l38f0h		;38e6	20 08 	  . 
	push bc			;38e8	c5 	. 
	call sub_2fcbh		;38e9	cd cb 2f 	. . / 
	call sub_3042h		;38ec	cd 42 30 	. B 0 
	pop bc			;38ef	c1 	. 
l38f0h:
	ld a,(DAC)		;38f0	3a f6 f7 	: . . 
	or a			;38f3	b7 	. 
	jr nz,l3901h		;38f4	20 0b 	  . 
	ld hl,(TEMP8)		;38f6	2a 9f f6 	* . . 
	or h			;38f9	b4 	. 
	ret p			;38fa	f0 	. 
	ld a,l			;38fb	7d 	} 
	rrca			;38fc	0f 	. 
	and b			;38fd	a0 	. 
	jp 04067h		;38fe	c3 67 40 	. g @ 
l3901h:
	call sub_2c4dh		;3901	cd 4d 2c 	. M , 
	ld hl,l2d1bh		;3904	21 1b 2d 	! . - 
	call sub_2c5ch		;3907	cd 5c 2c 	. \ , 
	jp l289fh		;390a	c3 9f 28 	. . ( 
sub_390dh:
	push bc			;390d	c5 	. 
	push de			;390e	d5 	. 
	call sub_3193h		;390f	cd 93 31 	. . 1 
	ld a,(VALTYP)		;3912	3a 63 f6 	: c . 
	cp 002h		;3915	fe 02 	. . 
	pop de			;3917	d1 	. 
	pop bc			;3918	c1 	. 
	ret			;3919	c9 	. 
sub_391ah:
	call l2c59h		;391a	cd 59 2c 	. Y , 
	call sub_2cc7h		;391d	cd c7 2c 	. . , 
	call sub_30cfh		;3920	cd cf 30 	. . 0 
	call sub_2cdch		;3923	cd dc 2c 	. . , 
	call l2f5ch		;3926	cd 5c 2f 	. \ / 
	scf			;3929	37 	7 
	ret nz			;392a	c0 	. 
	jp sub_305dh		;392b	c3 5d 30 	. ] 0 

; BLOCK 'BASICDATA' (start 0x392e end 0x3a3e)
BASICDATA:
	defb 0eah		;392e	ea 	. 
	defb 063h		;392f	63 	c 
	defb 024h		;3930	24 	$ 
	defb 045h		;3931	45 	E 
	defb 027h		;3932	27 	' 
	defb 065h		;3933	65 	e 
	defb 05bh		;3934	5b 	[ 
	defb 048h		;3935	48 	H 
	defb 06ch		;3936	6c 	l 
	defb 04bh		;3937	4b 	K 
	defb 09fh		;3938	9f 	. 
	defb 05eh		;3939	5e 	^ 
	defb 09fh		;393a	9f 	. 
	defb 04bh		;393b	4b 	K 
	defb 080h		;393c	80 	. 
	defb 048h		;393d	48 	H 
	defb 0e8h		;393e	e8 	. 
	defb 047h		;393f	47 	G 
	defb 09eh		;3940	9e 	. 
	defb 047h		;3941	47 	G 
	defb 0e5h		;3942	e5 	. 
	defb 049h		;3943	49 	I 
	defb 0c9h		;3944	c9 	. 
	defb 063h		;3945	63 	c 
	defb 0b2h		;3946	b2 	. 
	defb 047h		;3947	47 	G 
	defb 021h		;3948	21 	! 
	defb 048h		;3949	48 	H 
	defb 05dh		;394a	5d 	] 
	defb 048h		;394b	48 	H 
	defb 0e3h		;394c	e3 	. 
	defb 063h		;394d	63 	c 
	defb 024h		;394e	24 	$ 
	defb 04ah		;394f	4a 	J 
	defb 0afh		;3950	af 	. 
	defb 064h		;3951	64 	d 
	defb 02eh		;3952	2e 	. 
	defb 052h		;3953	52 	R 
	defb 086h		;3954	86 	. 
	defb 062h		;3955	62 	b 
	defb 0e4h		;3956	e4 	. 
	defb 048h		;3957	48 	H 
	defb 01ch		;3958	1c 	. 
	defb 040h		;3959	40 	@ 
	defb 01dh		;395a	1d 	. 
	defb 050h		;395b	50 	P 
	defb 023h		;395c	23 	# 
	defb 054h		;395d	54 	T 
	defb 024h		;395e	24 	$ 
	defb 064h		;395f	64 	d 
	defb 0b7h		;3960	b7 	. 
	defb 06fh		;3961	6f 	o 
	defb 03fh		;3962	3f 	? 
	defb 070h		;3963	70 	p 
	defb 016h		;3964	16 	. 
	defb 040h		;3965	40 	@ 
	defb 01dh		;3966	1d 	. 
	defb 04ah		;3967	4a 	J 
	defb 029h		;3968	29 	) 
	defb 052h		;3969	52 	R 
    if VERSION == 3
        defw CLSKANJI
	;defb 0a9h		;396a	a9 	. 
	;defb 079h		;396b	79 	y 
    ELSE
        defw CLS
	;defb 0c3h		;396a	c3 	. 
	;defb 000h		;396b	00 	. 
    ENDIF
	defb 0c9h		;396c	c9 	. 
	defb 051h		;396d	51 	Q 
	defb 05dh		;396e	5d 	] 
	defb 048h		;396f	48 	H 
	defb 038h		;3970	38 	8 
	defb 064h		;3971	64 	d 
	defb 039h		;3972	39 	9 
	defb 064h		;3973	64 	d 
	defb 03eh		;3974	3e 	> 
	defb 064h		;3975	64 	d 
	defb 077h		;3976	77 	w 
	defb 064h		;3977	64 	d 
	defb 0aah		;3978	aa 	. 
	defb 049h		;3979	49 	I 
	defb 05dh		;397a	5d 	] 
	defb 049h		;397b	49 	I 
	defb 0e2h		;397c	e2 	. 
	defb 053h		;397d	53 	S 
	defb 0b5h		;397e	b5 	. 
	defb 049h		;397f	49 	I 
	defb 068h		;3980	68 	h 
	defb 054h		;3981	54 	T 
	defb 018h		;3982	18 	. 
	defb 047h		;3983	47 	G 
	defb 01bh		;3984	1b 	. 
	defb 047h		;3985	47 	G 
	defb 01eh		;3986	1e 	. 
	defb 047h		;3987	47 	G 
	defb 021h		;3988	21 	! 
	defb 047h		;3989	47 	G 
	defb 00eh		;398a	0e 	. 
	defb 04bh		;398b	4b 	K 
	defb 0b7h		;398c	b7 	. 
	defb 06ah		;398d	6a 	j 
	defb 052h		;398e	52 	R 
	defb 07ch		;398f	7c 	| 
	defb 05bh		;3990	5b 	[ 
	defb 077h		;3991	77 	w 
	defb 058h		;3992	58 	X 
	defb 077h		;3993	77 	w 
	defb 014h		;3994	14 	. 
	defb 06ch		;3995	6c 	l 
	defb 05dh		;3996	5d 	] 
	defb 06bh		;3997	6b 	k 
	defb 05eh		;3998	5e 	^ 
	defb 06bh		;3999	6b 	k 
	defb 02fh		;399a	2f 	/ 
	defb 06ch		;399b	6c 	l 
	defb 048h		;399c	48 	H 
	defb 07ch		;399d	7c 	| 
	defb 04dh		;399e	4d 	M 
	defb 07ch		;399f	7c 	| 
	defb 0a3h		;39a0	a3 	. 
	defb 06bh		;39a1	6b 	k 
	defb 02ah		;39a2	2a 	* 
	defb 06ch		;39a3	6c 	l 
	defb 011h		;39a4	11 	. 
	defb 05bh		;39a5	5b 	[ 
	defb 080h		;39a6	80 	. 
	defb 079h		;39a7	79 	y 
	defb 06eh		;39a8	6e 	n 
	defb 05dh		;39a9	5d 	] 
	defb 0c5h		;39aa	c5 	. 
	defb 059h		;39ab	59 	Y 
	defb 0c0h		;39ac	c0 	. 
	defb 000h		;39ad	00 	. 
	defb 0e5h		;39ae	e5 	. 
	defb 073h		;39af	73 	s 
	defb 0eah		;39b0	ea 	. 
	defb 057h		;39b1	57 	W 
	defb 0e5h		;39b2	e5 	. 
	defb 057h		;39b3	57 	W 
	defb 0cah		;39b4	ca 	. 
	defb 073h		;39b5	73 	s 
	defb 0cch		;39b6	cc 	. 
	defb 079h		;39b7	79 	y 
	defb 0e2h		;39b8	e2 	. 
	defb 07bh		;39b9	7b 	{ 
	defb 048h		;39ba	48 	H 
	defb 07ah		;39bb	7a 	z 
	defb 037h		;39bc	37 	7 
	defb 07bh		;39bd	7b 	{ 
	defb 05ah		;39be	5a 	Z 
	defb 07bh		;39bf	7b 	{ 
	defb 0a8h		;39c0	a8 	. 
	defb 055h		;39c1	55 	U 
	defb 011h		;39c2	11 	. 
	defb 079h		;39c3	79 	y 
	defb 06ch		;39c4	6c 	l 
	defb 078h		;39c5	78 	x 
	defb 04bh		;39c6	4b 	K 
	defb 07eh		;39c7	7e 	~ 
	defb 0b7h		;39c8	b7 	. 
	defb 073h		;39c9	73 	s 
	defb 0c6h		;39ca	c6 	. 
	defb 06eh		;39cb	6e 	n 
	defb 092h		;39cc	92 	. 
	defb 06eh		;39cd	6e 	n 
	defb 016h		;39ce	16 	. 
	defb 07ch		;39cf	7c 	| 
	defb 01bh		;39d0	1b 	. 
	defb 07ch		;39d1	7c 	| 
	defb 020h		;39d2	20 	  
	defb 07ch		;39d3	7c 	| 
	defb 025h		;39d4	25 	% 
	defb 07ch		;39d5	7c 	| 
	defb 02ah		;39d6	2a 	* 
	defb 07ch		;39d7	7c 	| 
	defb 02fh		;39d8	2f 	/ 
	defb 07ch		;39d9	7c 	| 
	defb 034h		;39da	34 	4 
	defb 07ch		;39db	7c 	| 
	defb 066h		;39dc	66 	f 
	defb 077h		;39dd	77 	w 
l39deh:
	defb 061h		;39de	61 	a 
	defb 068h		;39df	68 	h 
	defb 091h		;39e0	91 	. 
	defb 068h		;39e1	68 	h 
	defb 09ah		;39e2	9a 	. 
	defb 068h		;39e3	68 	h 
	defb 097h		;39e4	97 	. 
	defb 02eh		;39e5	2e 	. 
	defb 0cfh		;39e6	cf 	. 
	defb 030h		;39e7	30 	0 
	defb 082h		;39e8	82 	. 
	defb 02eh		;39e9	2e 	. 
	defb 0ffh		;39ea	ff 	. 
	defb 02ah		;39eb	2a 	* 
	defb 0dfh		;39ec	df 	. 
	defb 02bh		;39ed	2b 	+ 
	defb 0ach		;39ee	ac 	. 
	defb 029h		;39ef	29 	) 
	defb 072h		;39f0	72 	r 
	defb 02ah		;39f1	2a 	* 
	defb 04ah		;39f2	4a 	J 
	defb 02bh		;39f3	2b 	+ 
	defb 093h		;39f4	93 	. 
	defb 029h		;39f5	29 	) 
	defb 0fbh		;39f6	fb 	. 
	defb 029h		;39f7	29 	) 
	defb 014h		;39f8	14 	. 
	defb 02ah		;39f9	2a 	* 
	defb 0f2h		;39fa	f2 	. 
	defb 069h		;39fb	69 	i 
	defb 001h		;39fc	01 	. 
	defb 040h		;39fd	40 	@ 
	defb 0cch		;39fe	cc 	. 
	defb 04fh		;39ff	4f 	O 
	defb 0ffh		;3a00	ff 	. 
	defb 067h		;3a01	67 	g 
	defb 004h		;3a02	04 	. 
	defb 066h		;3a03	66 	f 
	defb 0bbh		;3a04	bb 	. 
	defb 068h		;3a05	68 	h 
	defb 00bh		;3a06	0b 	. 
	defb 068h		;3a07	68 	h 
	defb 01bh		;3a08	1b 	. 
	defb 068h		;3a09	68 	h 
	defb 01ch		;3a0a	1c 	. 
	defb 054h		;3a0b	54 	T 
	defb 0f5h		;3a0c	f5 	. 
	defb 07bh		;3a0d	7b 	{ 
	defb 048h		;3a0e	48 	H 
	defb 068h		;3a0f	68 	h 
	defb 0f5h		;3a10	f5 	. 
	defb 065h		;3a11	65 	e 
	defb 0fah		;3a12	fa 	. 
	defb 065h		;3a13	65 	e 
	defb 0c7h		;3a14	c7 	. 
	defb 04fh		;3a15	4f 	O 
	defb 0ffh		;3a16	ff 	. 
	defb 065h		;3a17	65 	e 
	defb 08ah		;3a18	8a 	. 
	defb 02fh		;3a19	2f 	/ 
	defb 0b2h		;3a1a	b2 	. 
	defb 02fh		;3a1b	2f 	/ 
	defb 03ah		;3a1c	3a 	: 
	defb 030h		;3a1d	30 	0 
l3a1eh:
	defb 0beh		;3a1e	be 	. 
	defb 030h		;3a1f	30 	0 
	defb 040h		;3a20	40 	@ 
	defb 079h		;3a21	79 	y 
	defb 04ch		;3a22	4c 	L 
	defb 079h		;3a23	79 	y 
	defb 05ah		;3a24	5a 	Z 
	defb 079h		;3a25	79 	y 
	defb 069h		;3a26	69 	i 
	defb 079h		;3a27	79 	y 
	defb 039h		;3a28	39 	9 
	defb 07ch		;3a29	7c 	| 
	defb 039h		;3a2a	39 	9 
	defb 06dh		;3a2b	6d 	m 
	defb 066h		;3a2c	66 	f 
	defb 07ch		;3a2d	7c 	| 
	defb 06bh		;3a2e	6b 	k 
	defb 07ch		;3a2f	7c 	| 
	defb 070h		;3a30	70 	p 
	defb 07ch		;3a31	7c 	| 
	defb 025h		;3a32	25 	% 
	defb 06dh		;3a33	6d 	m 
	defb 003h		;3a34	03 	. 
	defb 06dh		;3a35	6d 	m 
	defb 014h		;3a36	14 	. 
	defb 06dh		;3a37	6d 	m 
	defb 057h		;3a38	57 	W 
	defb 07ch		;3a39	7c 	| 
	defb 05ch		;3a3a	5c 	\ 
	defb 07ch		;3a3b	7c 	| 
	defb 061h		;3a3c	61 	a 
	defb 07ch		;3a3d	7c 	| 

; BLOCK 'KEYWORDPTR' (start 0x3a3e end 0x3a72)
KEYWORDPTR_start:
	defw KEYWORDPTR_end	;3a3e	72 3a 	r : 
	defw l3a88h		;3a40	88 3a 	. : 
	defw l3a9fh		;3a42	9f 3a 	. : 
	defw l3af3h		;3a44	f3 3a 	. : 
	defw l3b2eh		;3a46	2e 3b 	. ; 
	defw l3b4fh		;3a48	4f 3b 	O ; 
	defw l3b69h		;3a4a	69 3b 	i ; 
	defw l3b7bh		;3a4c	7b 3b 	{ ; 
	defw l3b80h		;3a4e	80 3b 	. ; 
	defw l3b9fh		;3a50	9f 3b 	. ; 
	defw l3ba0h		;3a52	a0 3b 	. ; 
	defw l3ba8h		;3a54	a8 3b 	. ; 
	defw l3be8h		;3a56	e8 3b 	. ; 
	defw l3c09h		;3a58	09 3c 	. < 
	defw l3c18h		;3a5a	18 3c 	. < 
	defw l3c2bh		;3a5c	2b 3c 	+ < 
	defw l3c5dh		;3a5e	5d 3c 	] < 
	defw l3c5eh		;3a60	5e 3c 	^ < 
	defw l3c8eh		;3a62	8e 3c 	. < 
	defw l3cdbh		;3a64	db 3c 	. < 
	defw l3cf6h		;3a66	f6 3c 	. < 
	defw l3cffh		;3a68	ff 3c 	. < 
	defw l3d16h		;3a6a	16 3d 	. = 
	defw l3d20h		;3a6c	20 3d 	  = 
	defw l3d24h		;3a6e	24 3d 	$ = 
	defw l3d25h		;3a70	25 3d 	% = 
KEYWORDPTR_end:

; BLOCK 'BASTOKENS' (start 0x3a72 end 0x3d75)
BASTOKENS:
	defb 055h		;3a72	55 	U 
	defb 054h		;3a73	54 	T 
	defb 0cfh		;3a74	cf 	. 
	defb 0a9h		;3a75	a9 	. 
	defb 04eh		;3a76	4e 	N 
	defb 0c4h		;3a77	c4 	. 
	defb 0f6h		;3a78	f6 	. 
	defb 042h		;3a79	42 	B 
	defb 0d3h		;3a7a	d3 	. 
	defb 006h		;3a7b	06 	. 
	defb 054h		;3a7c	54 	T 
	defb 0ceh		;3a7d	ce 	. 
	defb 00eh		;3a7e	0e 	. 
	defb 053h		;3a7f	53 	S 
	defb 0c3h		;3a80	c3 	. 
	defb 015h		;3a81	15 	. 
	defb 054h		;3a82	54 	T 
	defb 054h		;3a83	54 	T 
	defb 052h		;3a84	52 	R 
	defb 0a4h		;3a85	a4 	. 
	defb 0e9h		;3a86	e9 	. 
	defb 000h		;3a87	00 	. 
l3a88h:
	defb 041h		;3a88	41 	A 
	defb 053h		;3a89	53 	S 
	defb 0c5h		;3a8a	c5 	. 
	defb 0c9h		;3a8b	c9 	. 
	defb 053h		;3a8c	53 	S 
	defb 041h		;3a8d	41 	A 
	defb 056h		;3a8e	56 	V 
	defb 0c5h		;3a8f	c5 	. 
	defb 0d0h		;3a90	d0 	. 
	defb 04ch		;3a91	4c 	L 
	defb 04fh		;3a92	4f 	O 
	defb 041h		;3a93	41 	A 
	defb 0c4h		;3a94	c4 	. 
	defb 0cfh		;3a95	cf 	. 
	defb 045h		;3a96	45 	E 
	defb 045h		;3a97	45 	E 
	defb 0d0h		;3a98	d0 	. 
	defb 0c0h		;3a99	c0 	. 
	defb 049h		;3a9a	49 	I 
	defb 04eh		;3a9b	4e 	N 
	defb 0a4h		;3a9c	a4 	. 
	defb 01dh		;3a9d	1d 	. 
	defb 000h		;3a9e	00 	. 
l3a9fh:
	defb 041h		;3a9f	41 	A 
	defb 04ch		;3aa0	4c 	L 
	defb 0cch		;3aa1	cc 	. 
	defb 0cah		;3aa2	ca 	. 
	defb 04ch		;3aa3	4c 	L 
	defb 04fh		;3aa4	4f 	O 
	defb 053h		;3aa5	53 	S 
	defb 0c5h		;3aa6	c5 	. 
	defb 0b4h		;3aa7	b4 	. 
	defb 04fh		;3aa8	4f 	O 
	defb 050h		;3aa9	50 	P 
	defb 0d9h		;3aaa	d9 	. 
	defb 0d6h		;3aab	d6 	. 
	defb 04fh		;3aac	4f 	O 
	defb 04eh		;3aad	4e 	N 
	defb 0d4h		;3aae	d4 	. 
	defb 099h		;3aaf	99 	. 
	defb 04ch		;3ab0	4c 	L 
	defb 045h		;3ab1	45 	E 
	defb 041h		;3ab2	41 	A 
	defb 0d2h		;3ab3	d2 	. 
	defb 092h		;3ab4	92 	. 
	defb 04ch		;3ab5	4c 	L 
	defb 04fh		;3ab6	4f 	O 
	defb 041h		;3ab7	41 	A 
	defb 0c4h		;3ab8	c4 	. 
	defb 09bh		;3ab9	9b 	. 
	defb 053h		;3aba	53 	S 
	defb 041h		;3abb	41 	A 
	defb 056h		;3abc	56 	V 
	defb 0c5h		;3abd	c5 	. 
	defb 09ah		;3abe	9a 	. 
	defb 053h		;3abf	53 	S 
	defb 052h		;3ac0	52 	R 
	defb 04ch		;3ac1	4c 	L 
	defb 049h		;3ac2	49 	I 
	defb 0ceh		;3ac3	ce 	. 
	defb 0e8h		;3ac4	e8 	. 
	defb 049h		;3ac5	49 	I 
	defb 04eh		;3ac6	4e 	N 
	defb 0d4h		;3ac7	d4 	. 
	defb 01eh		;3ac8	1e 	. 
	defb 053h		;3ac9	53 	S 
	defb 04eh		;3aca	4e 	N 
	defb 0c7h		;3acb	c7 	. 
	defb 01fh		;3acc	1f 	. 
	defb 044h		;3acd	44 	D 
	defb 042h		;3ace	42 	B 
	defb 0cch		;3acf	cc 	. 
	defb 020h		;3ad0	20 	  
	defb 056h		;3ad1	56 	V 
	defb 0c9h		;3ad2	c9 	. 
	defb 028h		;3ad3	28 	( 
	defb 056h		;3ad4	56 	V 
	defb 0d3h		;3ad5	d3 	. 
	defb 029h		;3ad6	29 	) 
	defb 056h		;3ad7	56 	V 
	defb 0c4h		;3ad8	c4 	. 
	defb 02ah		;3ad9	2a 	* 
	defb 04fh		;3ada	4f 	O 
	defb 0d3h		;3adb	d3 	. 
	defb 00ch		;3adc	0c 	. 
	defb 048h		;3add	48 	H 
	defb 052h		;3ade	52 	R 
	defb 0a4h		;3adf	a4 	. 
	defb 016h		;3ae0	16 	. 
	defb 049h		;3ae1	49 	I 
	defb 052h		;3ae2	52 	R 
	defb 043h		;3ae3	43 	C 
	defb 04ch		;3ae4	4c 	L 
	defb 0c5h		;3ae5	c5 	. 
	defb 0bch		;3ae6	bc 	. 
	defb 04fh		;3ae7	4f 	O 
	defb 04ch		;3ae8	4c 	L 
	defb 04fh		;3ae9	4f 	O 
	defb 0d2h		;3aea	d2 	. 
	defb 0bdh		;3aeb	bd 	. 
	defb 04ch		;3aec	4c 	L 
	defb 0d3h		;3aed	d3 	. 
	defb 09fh		;3aee	9f 	. 
	defb 04dh		;3aef	4d 	M 
	defb 0c4h		;3af0	c4 	. 
	defb 0d7h		;3af1	d7 	. 
	defb 000h		;3af2	00 	. 
l3af3h:
	defb 045h		;3af3	45 	E 
	defb 04ch		;3af4	4c 	L 
	defb 045h		;3af5	45 	E 
	defb 054h		;3af6	54 	T 
	defb 0c5h		;3af7	c5 	. 
	defb 0a8h		;3af8	a8 	. 
	defb 041h		;3af9	41 	A 
	defb 054h		;3afa	54 	T 
	defb 0c1h		;3afb	c1 	. 
	defb 084h		;3afc	84 	. 
	defb 049h		;3afd	49 	I 
	defb 0cdh		;3afe	cd 	. 
	defb 086h		;3aff	86 	. 
	defb 045h		;3b00	45 	E 
	defb 046h		;3b01	46 	F 
	defb 053h		;3b02	53 	S 
	defb 054h		;3b03	54 	T 
	defb 0d2h		;3b04	d2 	. 
	defb 0abh		;3b05	ab 	. 
	defb 045h		;3b06	45 	E 
	defb 046h		;3b07	46 	F 
	defb 049h		;3b08	49 	I 
	defb 04eh		;3b09	4e 	N 
	defb 0d4h		;3b0a	d4 	. 
	defb 0ach		;3b0b	ac 	. 
	defb 045h		;3b0c	45 	E 
	defb 046h		;3b0d	46 	F 
	defb 053h		;3b0e	53 	S 
	defb 04eh		;3b0f	4e 	N 
	defb 0c7h		;3b10	c7 	. 
	defb 0adh		;3b11	ad 	. 
	defb 045h		;3b12	45 	E 
	defb 046h		;3b13	46 	F 
	defb 044h		;3b14	44 	D 
	defb 042h		;3b15	42 	B 
	defb 0cch		;3b16	cc 	. 
	defb 0aeh		;3b17	ae 	. 
	defb 053h		;3b18	53 	S 
	defb 04bh		;3b19	4b 	K 
	defb 04fh		;3b1a	4f 	O 
	defb 0a4h		;3b1b	a4 	. 
	defb 0d1h		;3b1c	d1 	. 
	defb 045h		;3b1d	45 	E 
l3b1eh:
	defb 0c6h		;3b1e	c6 	. 
	defb 097h		;3b1f	97 	. 
	defb 053h		;3b20	53 	S 
	defb 04bh		;3b21	4b 	K 
	defb 049h		;3b22	49 	I 
	defb 0a4h		;3b23	a4 	. 
	defb 0eah		;3b24	ea 	. 
	defb 053h		;3b25	53 	S 
	defb 04bh		;3b26	4b 	K 
	defb 0c6h		;3b27	c6 	. 
	defb 026h		;3b28	26 	& 
	defb 052h		;3b29	52 	R 
	defb 041h		;3b2a	41 	A 
	defb 0d7h		;3b2b	d7 	. 
	defb 0beh		;3b2c	be 	. 
	defb 000h		;3b2d	00 	. 
l3b2eh:
	defb 04ch		;3b2e	4c 	L 
	defb 053h		;3b2f	53 	S 
	defb 0c5h		;3b30	c5 	. 
	defb 0a1h		;3b31	a1 	. 
	defb 04eh		;3b32	4e 	N 
	defb 0c4h		;3b33	c4 	. 
	defb 081h		;3b34	81 	. 
	defb 052h		;3b35	52 	R 
	defb 041h		;3b36	41 	A 
	defb 053h		;3b37	53 	S 
	defb 0c5h		;3b38	c5 	. 
	defb 0a5h		;3b39	a5 	. 
	defb 052h		;3b3a	52 	R 
	defb 052h		;3b3b	52 	R 
	defb 04fh		;3b3c	4f 	O 
	defb 0d2h		;3b3d	d2 	. 
	defb 0a6h		;3b3e	a6 	. 
	defb 052h		;3b3f	52 	R 
	defb 0cch		;3b40	cc 	. 
	defb 0e1h		;3b41	e1 	. 
	defb 052h		;3b42	52 	R 
	defb 0d2h		;3b43	d2 	. 
	defb 0e2h		;3b44	e2 	. 
	defb 058h		;3b45	58 	X 
	defb 0d0h		;3b46	d0 	. 
	defb 00bh		;3b47	0b 	. 
	defb 04fh		;3b48	4f 	O 
	defb 0c6h		;3b49	c6 	. 
	defb 02bh		;3b4a	2b 	+ 
	defb 051h		;3b4b	51 	Q 
	defb 0d6h		;3b4c	d6 	. 
	defb 0f9h		;3b4d	f9 	. 
	defb 000h		;3b4e	00 	. 
l3b4fh:
	defb 04fh		;3b4f	4f 	O 
	defb 0d2h		;3b50	d2 	. 
	defb 082h		;3b51	82 	. 
	defb 049h		;3b52	49 	I 
	defb 045h		;3b53	45 	E 
	defb 04ch		;3b54	4c 	L 
	defb 0c4h		;3b55	c4 	. 
	defb 0b1h		;3b56	b1 	. 
	defb 049h		;3b57	49 	I 
	defb 04ch		;3b58	4c 	L 
	defb 045h		;3b59	45 	E 
	defb 0d3h		;3b5a	d3 	. 
	defb 0b7h		;3b5b	b7 	. 
	defb 0ceh		;3b5c	ce 	. 
	defb 0deh		;3b5d	de 	. 
	defb 052h		;3b5e	52 	R 
	defb 0c5h		;3b5f	c5 	. 
	defb 00fh		;3b60	0f 	. 
	defb 049h		;3b61	49 	I 
	defb 0d8h		;3b62	d8 	. 
	defb 021h		;3b63	21 	! 
	defb 050h		;3b64	50 	P 
	defb 04fh		;3b65	4f 	O 
	defb 0d3h		;3b66	d3 	. 
	defb 027h		;3b67	27 	' 
	defb 000h		;3b68	00 	. 
l3b69h:
	defb 04fh		;3b69	4f 	O 
	defb 054h		;3b6a	54 	T 
	defb 0cfh		;3b6b	cf 	. 
	defb 089h		;3b6c	89 	. 
	defb 04fh		;3b6d	4f 	O 
	defb 020h		;3b6e	20 	  
	defb 054h		;3b6f	54 	T 
	defb 0cfh		;3b70	cf 	. 
	defb 089h		;3b71	89 	. 
	defb 04fh		;3b72	4f 	O 
	defb 053h		;3b73	53 	S 
	defb 055h		;3b74	55 	U 
	defb 0c2h		;3b75	c2 	. 
	defb 08dh		;3b76	8d 	. 
	defb 045h		;3b77	45 	E 
	defb 0d4h		;3b78	d4 	. 
	defb 0b2h		;3b79	b2 	. 
	defb 000h		;3b7a	00 	. 
l3b7bh:
	defb 045h		;3b7b	45 	E 
	defb 058h		;3b7c	58 	X 
	defb 0a4h		;3b7d	a4 	. 
	defb 01bh		;3b7e	1b 	. 
	defb 000h		;3b7f	00 	. 
l3b80h:
	defb 04eh		;3b80	4e 	N 
	defb 050h		;3b81	50 	P 
	defb 055h		;3b82	55 	U 
	defb 0d4h		;3b83	d4 	. 
	defb 085h		;3b84	85 	. 
	defb 0c6h		;3b85	c6 	. 
	defb 08bh		;3b86	8b 	. 
	defb 04eh		;3b87	4e 	N 
	defb 053h		;3b88	53 	S 
	defb 054h		;3b89	54 	T 
	defb 0d2h		;3b8a	d2 	. 
	defb 0e5h		;3b8b	e5 	. 
	defb 04eh		;3b8c	4e 	N 
	defb 0d4h		;3b8d	d4 	. 
	defb 005h		;3b8e	05 	. 
	defb 04eh		;3b8f	4e 	N 
	defb 0d0h		;3b90	d0 	. 
	defb 010h		;3b91	10 	. 
	defb 04dh		;3b92	4d 	M 
	defb 0d0h		;3b93	d0 	. 
	defb 0fah		;3b94	fa 	. 
	defb 04eh		;3b95	4e 	N 
	defb 04bh		;3b96	4b 	K 
	defb 045h		;3b97	45 	E 
	defb 059h		;3b98	59 	Y 
	defb 0a4h		;3b99	a4 	. 
	defb 0ech		;3b9a	ec 	. 
	defb 050h		;3b9b	50 	P 
	defb 0cch		;3b9c	cc 	. 
	defb 0d5h		;3b9d	d5 	. 
	defb 000h		;3b9e	00 	. 
l3b9fh:
	defb 000h		;3b9f	00 	. 
l3ba0h:
	defb 049h		;3ba0	49 	I 
	defb 04ch		;3ba1	4c 	L 
	defb 0cch		;3ba2	cc 	. 
	defb 0d4h		;3ba3	d4 	. 
	defb 045h		;3ba4	45 	E 
	defb 0d9h		;3ba5	d9 	. 
	defb 0cch		;3ba6	cc 	. 
	defb 000h		;3ba7	00 	. 
l3ba8h:
	defb 050h		;3ba8	50 	P 
	defb 052h		;3ba9	52 	R 
	defb 049h		;3baa	49 	I 
	defb 04eh		;3bab	4e 	N 
	defb 0d4h		;3bac	d4 	. 
	defb 09dh		;3bad	9d 	. 
	defb 04ch		;3bae	4c 	L 
	defb 049h		;3baf	49 	I 
	defb 053h		;3bb0	53 	S 
	defb 0d4h		;3bb1	d4 	. 
	defb 09eh		;3bb2	9e 	. 
	defb 050h		;3bb3	50 	P 
	defb 04fh		;3bb4	4f 	O 
	defb 0d3h		;3bb5	d3 	. 
	defb 01ch		;3bb6	1c 	. 
	defb 045h		;3bb7	45 	E 
	defb 0d4h		;3bb8	d4 	. 
	defb 088h		;3bb9	88 	. 
	defb 04fh		;3bba	4f 	O 
	defb 043h		;3bbb	43 	C 
	defb 041h		;3bbc	41 	A 
	defb 054h		;3bbd	54 	T 
	defb 0c5h		;3bbe	c5 	. 
	defb 0d8h		;3bbf	d8 	. 
	defb 049h		;3bc0	49 	I 
	defb 04eh		;3bc1	4e 	N 
	defb 0c5h		;3bc2	c5 	. 
	defb 0afh		;3bc3	af 	. 
	defb 04fh		;3bc4	4f 	O 
	defb 041h		;3bc5	41 	A 
	defb 0c4h		;3bc6	c4 	. 
	defb 0b5h		;3bc7	b5 	. 
	defb 053h		;3bc8	53 	S 
	defb 045h		;3bc9	45 	E 
	defb 0d4h		;3bca	d4 	. 
	defb 0b8h		;3bcb	b8 	. 
	defb 049h		;3bcc	49 	I 
	defb 053h		;3bcd	53 	S 
	defb 0d4h		;3bce	d4 	. 
	defb 093h		;3bcf	93 	. 
	defb 046h		;3bd0	46 	F 
	defb 049h		;3bd1	49 	I 
	defb 04ch		;3bd2	4c 	L 
	defb 045h		;3bd3	45 	E 
	defb 0d3h		;3bd4	d3 	. 
	defb 0bbh		;3bd5	bb 	. 
	defb 04fh		;3bd6	4f 	O 
	defb 0c7h		;3bd7	c7 	. 
	defb 00ah		;3bd8	0a 	. 
	defb 04fh		;3bd9	4f 	O 
	defb 0c3h		;3bda	c3 	. 
	defb 02ch		;3bdb	2c 	, 
	defb 045h		;3bdc	45 	E 
	defb 0ceh		;3bdd	ce 	. 
	defb 012h		;3bde	12 	. 
	defb 045h		;3bdf	45 	E 
	defb 046h		;3be0	46 	F 
	defb 054h		;3be1	54 	T 
	defb 0a4h		;3be2	a4 	. 
	defb 001h		;3be3	01 	. 
	defb 04fh		;3be4	4f 	O 
	defb 0c6h		;3be5	c6 	. 
	defb 02dh		;3be6	2d 	- 
	defb 000h		;3be7	00 	. 
l3be8h:
	defb 04fh		;3be8	4f 	O 
	defb 054h		;3be9	54 	T 
	defb 04fh		;3bea	4f 	O 
	defb 0d2h		;3beb	d2 	. 
	defb 0ceh		;3bec	ce 	. 
	defb 045h		;3bed	45 	E 
	defb 052h		;3bee	52 	R 
	defb 047h		;3bef	47 	G 
	defb 0c5h		;3bf0	c5 	. 
	defb 0b6h		;3bf1	b6 	. 
	defb 04fh		;3bf2	4f 	O 
	defb 0c4h		;3bf3	c4 	. 
	defb 0fbh		;3bf4	fb 	. 
	defb 04bh		;3bf5	4b 	K 
	defb 049h		;3bf6	49 	I 
	defb 0a4h		;3bf7	a4 	. 
	defb 02eh		;3bf8	2e 	. 
	defb 04bh		;3bf9	4b 	K 
	defb 053h		;3bfa	53 	S 
	defb 0a4h		;3bfb	a4 	. 
	defb 02fh		;3bfc	2f 	/ 
	defb 04bh		;3bfd	4b 	K 
	defb 044h		;3bfe	44 	D 
	defb 0a4h		;3bff	a4 	. 
	defb 030h		;3c00	30 	0 
	defb 049h		;3c01	49 	I 
	defb 044h		;3c02	44 	D 
	defb 0a4h		;3c03	a4 	. 
	defb 003h		;3c04	03 	. 
	defb 041h		;3c05	41 	A 
	defb 0d8h		;3c06	d8 	. 
	defb 0cdh		;3c07	cd 	. 
	defb 000h		;3c08	00 	. 
l3c09h:
	defb 045h		;3c09	45 	E 
	defb 058h		;3c0a	58 	X 
	defb 0d4h		;3c0b	d4 	. 
	defb 083h		;3c0c	83 	. 
	defb 041h		;3c0d	41 	A 
	defb 04dh		;3c0e	4d 	M 
	defb 0c5h		;3c0f	c5 	. 
	defb 0d3h		;3c10	d3 	. 
	defb 045h		;3c11	45 	E 
	defb 0d7h		;3c12	d7 	. 
	defb 094h		;3c13	94 	. 
	defb 04fh		;3c14	4f 	O 
	defb 0d4h		;3c15	d4 	. 
	defb 0e0h		;3c16	e0 	. 
	defb 000h		;3c17	00 	. 
l3c18h:
	defb 050h		;3c18	50 	P 
	defb 045h		;3c19	45 	E 
	defb 0ceh		;3c1a	ce 	. 
	defb 0b0h		;3c1b	b0 	. 
	defb 055h		;3c1c	55 	U 
	defb 0d4h		;3c1d	d4 	. 
	defb 09ch		;3c1e	9c 	. 
	defb 0ceh		;3c1f	ce 	. 
	defb 095h		;3c20	95 	. 
	defb 0d2h		;3c21	d2 	. 
	defb 0f7h		;3c22	f7 	. 
	defb 043h		;3c23	43 	C 
	defb 054h		;3c24	54 	T 
	defb 0a4h		;3c25	a4 	. 
	defb 01ah		;3c26	1a 	. 
	defb 046h		;3c27	46 	F 
	defb 0c6h		;3c28	c6 	. 
	defb 0ebh		;3c29	eb 	. 
	defb 000h		;3c2a	00 	. 
l3c2bh:
	defb 052h		;3c2b	52 	R 
	defb 049h		;3c2c	49 	I 
	defb 04eh		;3c2d	4e 	N 
	defb 0d4h		;3c2e	d4 	. 
	defb 091h		;3c2f	91 	. 
	defb 055h		;3c30	55 	U 
	defb 0d4h		;3c31	d4 	. 
	defb 0b3h		;3c32	b3 	. 
	defb 04fh		;3c33	4f 	O 
	defb 04bh		;3c34	4b 	K 
	defb 0c5h		;3c35	c5 	. 
	defb 098h		;3c36	98 	. 
	defb 04fh		;3c37	4f 	O 
	defb 0d3h		;3c38	d3 	. 
	defb 011h		;3c39	11 	. 
	defb 045h		;3c3a	45 	E 
	defb 045h		;3c3b	45 	E 
	defb 0cbh		;3c3c	cb 	. 
	defb 017h		;3c3d	17 	. 
	defb 053h		;3c3e	53 	S 
	defb 045h		;3c3f	45 	E 
	defb 0d4h		;3c40	d4 	. 
	defb 0c2h		;3c41	c2 	. 
	defb 052h		;3c42	52 	R 
	defb 045h		;3c43	45 	E 
	defb 053h		;3c44	53 	S 
	defb 045h		;3c45	45 	E 
	defb 0d4h		;3c46	d4 	. 
	defb 0c3h		;3c47	c3 	. 
	defb 04fh		;3c48	4f 	O 
	defb 049h		;3c49	49 	I 
	defb 04eh		;3c4a	4e 	N 
	defb 0d4h		;3c4b	d4 	. 
	defb 0edh		;3c4c	ed 	. 
	defb 041h		;3c4d	41 	A 
	defb 049h		;3c4e	49 	I 
	defb 04eh		;3c4f	4e 	N 
	defb 0d4h		;3c50	d4 	. 
	defb 0bfh		;3c51	bf 	. 
	defb 044h		;3c52	44 	D 
	defb 0cch		;3c53	cc 	. 
	defb 024h		;3c54	24 	$ 
	defb 041h		;3c55	41 	A 
	defb 0c4h		;3c56	c4 	. 
	defb 025h		;3c57	25 	% 
	defb 04ch		;3c58	4c 	L 
	defb 041h		;3c59	41 	A 
	defb 0d9h		;3c5a	d9 	. 
	defb 0c1h		;3c5b	c1 	. 
	defb 000h		;3c5c	00 	. 
l3c5dh:
	defb 000h		;3c5d	00 	. 
l3c5eh:
	defb 045h		;3c5e	45 	E 
	defb 054h		;3c5f	54 	T 
	defb 055h		;3c60	55 	U 
	defb 052h		;3c61	52 	R 
	defb 0ceh		;3c62	ce 	. 
	defb 08eh		;3c63	8e 	. 
	defb 045h		;3c64	45 	E 
	defb 041h		;3c65	41 	A 
	defb 0c4h		;3c66	c4 	. 
	defb 087h		;3c67	87 	. 
	defb 055h		;3c68	55 	U 
	defb 0ceh		;3c69	ce 	. 
	defb 08ah		;3c6a	8a 	. 
	defb 045h		;3c6b	45 	E 
	defb 053h		;3c6c	53 	S 
	defb 054h		;3c6d	54 	T 
	defb 04fh		;3c6e	4f 	O 
	defb 052h		;3c6f	52 	R 
	defb 0c5h		;3c70	c5 	. 
	defb 08ch		;3c71	8c 	. 
	defb 045h		;3c72	45 	E 
	defb 0cdh		;3c73	cd 	. 
	defb 08fh		;3c74	8f 	. 
	defb 045h		;3c75	45 	E 
	defb 053h		;3c76	53 	S 
	defb 055h		;3c77	55 	U 
	defb 04dh		;3c78	4d 	M 
	defb 0c5h		;3c79	c5 	. 
	defb 0a7h		;3c7a	a7 	. 
	defb 053h		;3c7b	53 	S 
	defb 045h		;3c7c	45 	E 
	defb 0d4h		;3c7d	d4 	. 
	defb 0b9h		;3c7e	b9 	. 
	defb 049h		;3c7f	49 	I 
	defb 047h		;3c80	47 	G 
	defb 048h		;3c81	48 	H 
	defb 054h		;3c82	54 	T 
	defb 0a4h		;3c83	a4 	. 
	defb 002h		;3c84	02 	. 
	defb 04eh		;3c85	4e 	N 
	defb 0c4h		;3c86	c4 	. 
	defb 008h		;3c87	08 	. 
	defb 045h		;3c88	45 	E 
	defb 04eh		;3c89	4e 	N 
	defb 055h		;3c8a	55 	U 
	defb 0cdh		;3c8b	cd 	. 
	defb 0aah		;3c8c	aa 	. 
	defb 000h		;3c8d	00 	. 
l3c8eh:
	defb 043h		;3c8e	43 	C 
	defb 052h		;3c8f	52 	R 
	defb 045h		;3c90	45 	E 
	defb 045h		;3c91	45 	E 
	defb 0ceh		;3c92	ce 	. 
	defb 0c5h		;3c93	c5 	. 
	defb 050h		;3c94	50 	P 
	defb 052h		;3c95	52 	R 
	defb 049h		;3c96	49 	I 
	defb 054h		;3c97	54 	T 
	defb 0c5h		;3c98	c5 	. 
	defb 0c7h		;3c99	c7 	. 
	defb 054h		;3c9a	54 	T 
	defb 04fh		;3c9b	4f 	O 
	defb 0d0h		;3c9c	d0 	. 
	defb 090h		;3c9d	90 	. 
	defb 057h		;3c9e	57 	W 
	defb 041h		;3c9f	41 	A 
	defb 0d0h		;3ca0	d0 	. 
	defb 0a4h		;3ca1	a4 	. 
	defb 045h		;3ca2	45 	E 
	defb 0d4h		;3ca3	d4 	. 
	defb 0d2h		;3ca4	d2 	. 
	defb 041h		;3ca5	41 	A 
	defb 056h		;3ca6	56 	V 
	defb 0c5h		;3ca7	c5 	. 
	defb 0bah		;3ca8	ba 	. 
	defb 050h		;3ca9	50 	P 
	defb 043h		;3caa	43 	C 
	defb 0a8h		;3cab	a8 	. 
	defb 0dfh		;3cac	df 	. 
	defb 054h		;3cad	54 	T 
	defb 045h		;3cae	45 	E 
	defb 0d0h		;3caf	d0 	. 
	defb 0dch		;3cb0	dc 	. 
	defb 047h		;3cb1	47 	G 
	defb 0ceh		;3cb2	ce 	. 
	defb 004h		;3cb3	04 	. 
	defb 051h		;3cb4	51 	Q 
	defb 0d2h		;3cb5	d2 	. 
	defb 007h		;3cb6	07 	. 
	defb 049h		;3cb7	49 	I 
	defb 0ceh		;3cb8	ce 	. 
	defb 009h		;3cb9	09 	. 
	defb 054h		;3cba	54 	T 
	defb 052h		;3cbb	52 	R 
	defb 0a4h		;3cbc	a4 	. 
	defb 013h		;3cbd	13 	. 
	defb 054h		;3cbe	54 	T 
	defb 052h		;3cbf	52 	R 
	defb 049h		;3cc0	49 	I 
	defb 04eh		;3cc1	4e 	N 
	defb 047h		;3cc2	47 	G 
	defb 0a4h		;3cc3	a4 	. 
	defb 0e3h		;3cc4	e3 	. 
	defb 050h		;3cc5	50 	P 
	defb 041h		;3cc6	41 	A 
	defb 043h		;3cc7	43 	C 
	defb 045h		;3cc8	45 	E 
	defb 0a4h		;3cc9	a4 	. 
	defb 019h		;3cca	19 	. 
	defb 04fh		;3ccb	4f 	O 
	defb 055h		;3ccc	55 	U 
	defb 04eh		;3ccd	4e 	N 
	defb 0c4h		;3cce	c4 	. 
	defb 0c4h		;3ccf	c4 	. 
	defb 054h		;3cd0	54 	T 
	defb 049h		;3cd1	49 	I 
	defb 043h		;3cd2	43 	C 
	defb 0cbh		;3cd3	cb 	. 
	defb 022h		;3cd4	22 	" 
	defb 054h		;3cd5	54 	T 
	defb 052h		;3cd6	52 	R 
	defb 049h		;3cd7	49 	I 
	defb 0c7h		;3cd8	c7 	. 
	defb 023h		;3cd9	23 	# 
	defb 000h		;3cda	00 	. 
l3cdbh:
	defb 048h		;3cdb	48 	H 
	defb 045h		;3cdc	45 	E 
	defb 0ceh		;3cdd	ce 	. 
	defb 0dah		;3cde	da 	. 
	defb 052h		;3cdf	52 	R 
	defb 04fh		;3ce0	4f 	O 
	defb 0ceh		;3ce1	ce 	. 
	defb 0a2h		;3ce2	a2 	. 
	defb 052h		;3ce3	52 	R 
	defb 04fh		;3ce4	4f 	O 
	defb 046h		;3ce5	46 	F 
	defb 0c6h		;3ce6	c6 	. 
	defb 0a3h		;3ce7	a3 	. 
	defb 041h		;3ce8	41 	A 
	defb 042h		;3ce9	42 	B 
	defb 0a8h		;3cea	a8 	. 
	defb 0dbh		;3ceb	db 	. 
	defb 0cfh		;3cec	cf 	. 
	defb 0d9h		;3ced	d9 	. 
	defb 049h		;3cee	49 	I 
	defb 04dh		;3cef	4d 	M 
	defb 0c5h		;3cf0	c5 	. 
	defb 0cbh		;3cf1	cb 	. 
	defb 041h		;3cf2	41 	A 
	defb 0ceh		;3cf3	ce 	. 
	defb 00dh		;3cf4	0d 	. 
	defb 000h		;3cf5	00 	. 
l3cf6h:
	defb 053h		;3cf6	53 	S 
	defb 049h		;3cf7	49 	I 
	defb 04eh		;3cf8	4e 	N 
	defb 0c7h		;3cf9	c7 	. 
	defb 0e4h		;3cfa	e4 	. 
	defb 053h		;3cfb	53 	S 
	defb 0d2h		;3cfc	d2 	. 
	defb 0ddh		;3cfd	dd 	. 
	defb 000h		;3cfe	00 	. 
l3cffh:
	defb 041h		;3cff	41 	A 
	defb 0cch		;3d00	cc 	. 
	defb 014h		;3d01	14 	. 
	defb 041h		;3d02	41 	A 
	defb 052h		;3d03	52 	R 
	defb 050h		;3d04	50 	P 
	defb 054h		;3d05	54 	T 
	defb 0d2h		;3d06	d2 	. 
	defb 0e7h		;3d07	e7 	. 
	defb 044h		;3d08	44 	D 
	defb 0d0h		;3d09	d0 	. 
	defb 0c8h		;3d0a	c8 	. 
	defb 050h		;3d0b	50 	P 
	defb 04fh		;3d0c	4f 	O 
	defb 04bh		;3d0d	4b 	K 
	defb 0c5h		;3d0e	c5 	. 
	defb 0c6h		;3d0f	c6 	. 
	defb 050h		;3d10	50 	P 
	defb 045h		;3d11	45 	E 
	defb 045h		;3d12	45 	E 
	defb 0cbh		;3d13	cb 	. 
	defb 018h		;3d14	18 	. 
	defb 000h		;3d15	00 	. 
l3d16h:
	defb 049h		;3d16	49 	I 
	defb 044h		;3d17	44 	D 
	defb 054h		;3d18	54 	T 
	defb 0c8h		;3d19	c8 	. 
	defb 0a0h		;3d1a	a0 	. 
	defb 041h		;3d1b	41 	A 
	defb 049h		;3d1c	49 	I 
	defb 0d4h		;3d1d	d4 	. 
	defb 096h		;3d1e	96 	. 
	defb 000h		;3d1f	00 	. 
l3d20h:
	defb 04fh		;3d20	4f 	O 
	defb 0d2h		;3d21	d2 	. 
	defb 0f8h		;3d22	f8 	. 
	defb 000h		;3d23	00 	. 
l3d24h:
	defb 000h		;3d24	00 	. 
l3d25h:
	defb 000h		;3d25	00 	. 
l3d26h:
	defb 0abh		;3d26	ab 	. 
	defb 0f1h		;3d27	f1 	. 
	defb 0adh		;3d28	ad 	. 
	defb 0f2h		;3d29	f2 	. 
	defb 0aah		;3d2a	aa 	. 
	defb 0f3h		;3d2b	f3 	. 
	defb 0afh		;3d2c	af 	. 
	defb 0f4h		;3d2d	f4 	. 
	defb 0deh		;3d2e	de 	. 
	defb 0f5h		;3d2f	f5 	. 
	defb 0dch		;3d30	dc 	. 
	defb 0fch		;3d31	fc 	. 
	defb 0a7h		;3d32	a7 	. 
	defb 0e6h		;3d33	e6 	. 
	defb 0beh		;3d34	be 	. 
	defb 0eeh		;3d35	ee 	. 
	defb 0bdh		;3d36	bd 	. 
	defb 0efh		;3d37	ef 	. 
	defb 0bch		;3d38	bc 	. 
	defb 0f0h		;3d39	f0 	. 
	defb 000h		;3d3a	00 	. 
l3d3bh:
	defb 079h		;3d3b	79 	y 
	defb 079h		;3d3c	79 	y 
	defb 07ch		;3d3d	7c 	| 
	defb 07ch		;3d3e	7c 	| 
	defb 07fh		;3d3f	7f 	 
	defb 050h		;3d40	50 	P 
	defb 046h		;3d41	46 	F 
	defb 03ch		;3d42	3c 	< 
	defb 032h		;3d43	32 	2 
	defb 028h		;3d44	28 	( 
	defb 07ah		;3d45	7a 	z 
	defb 07bh		;3d46	7b 	{ 
l3d47h:
	defb 03ah		;3d47	3a 	: 
	defb 030h		;3d48	30 	0 
	defb 000h		;3d49	00 	. 
	defb 000h		;3d4a	00 	. 
	defb 08ah		;3d4b	8a 	. 
	defb 02fh		;3d4c	2f 	/ 
	defb 058h		;3d4d	58 	X 
	defb 030h		;3d4e	30 	0 
	defb 0b2h		;3d4f	b2 	. 
	defb 02fh		;3d50	2f 	/ 
l3d51h:
	defb 09ah		;3d51	9a 	. 
	defb 026h		;3d52	26 	& 
	defb 08ch		;3d53	8c 	. 
	defb 026h		;3d54	26 	& 
	defb 0e6h		;3d55	e6 	. 
	defb 027h		;3d56	27 	' 
	defb 09fh		;3d57	9f 	. 
	defb 028h		;3d58	28 	( 
	defb 0d7h		;3d59	d7 	. 
	defb 037h		;3d5a	37 	7 
	defb 083h		;3d5b	83 	. 
	defb 02fh		;3d5c	2f 	/ 
l3d5dh:
	defb 04eh		;3d5d	4e 	N 
	defb 032h		;3d5e	32 	2 
	defb 057h		;3d5f	57 	W 
	defb 032h		;3d60	32 	2 
	defb 05ch		;3d61	5c 	\ 
	defb 032h		;3d62	32 	2 
	defb 067h		;3d63	67 	g 
	defb 032h		;3d64	32 	2 
	defb 0c8h		;3d65	c8 	. 
	defb 037h		;3d66	37 	7 
	defb 021h		;3d67	21 	! 
	defb 02fh		;3d68	2f 	/ 
l3d69h:
	defb 072h		;3d69	72 	r 
	defb 031h		;3d6a	31 	1 
	defb 067h		;3d6b	67 	g 
	defb 031h		;3d6c	31 	1 
	defb 093h		;3d6d	93 	. 
	defb 031h		;3d6e	31 	1 
	defb 0b8h		;3d6f	b8 	. 
	defb 04dh		;3d70	4d 	M 
	defb 03fh		;3d71	3f 	? 
	defb 038h		;3d72	38 	8 
	defb 04dh		;3d73	4d 	M 
	defb 02fh		;3d74	2f 	/ 

; BLOCK 'ERRORMSGS' (start 0x3d75 end 0x3fe2)
ERRORMSGS:
	defb 000h		;3d75	00 	. 
	defb 04eh		;3d76	4e 	N 
	defb 045h		;3d77	45 	E 
	defb 058h		;3d78	58 	X 
	defb 054h		;3d79	54 	T 
	defb 020h		;3d7a	20 	  
	defb 077h		;3d7b	77 	w 
	defb 069h		;3d7c	69 	i 
	defb 074h		;3d7d	74 	t 
	defb 068h		;3d7e	68 	h 
	defb 06fh		;3d7f	6f 	o 
	defb 075h		;3d80	75 	u 
	defb 074h		;3d81	74 	t 
	defb 020h		;3d82	20 	  
	defb 046h		;3d83	46 	F 
	defb 04fh		;3d84	4f 	O 
	defb 052h		;3d85	52 	R 
	defb 000h		;3d86	00 	. 
	defb 053h		;3d87	53 	S 
	defb 079h		;3d88	79 	y 
	defb 06eh		;3d89	6e 	n 
	defb 074h		;3d8a	74 	t 
	defb 061h		;3d8b	61 	a 
	defb 078h		;3d8c	78 	x 
	defb 020h		;3d8d	20 	  
	defb 065h		;3d8e	65 	e 
	defb 072h		;3d8f	72 	r 
	defb 072h		;3d90	72 	r 
	defb 06fh		;3d91	6f 	o 
	defb 072h		;3d92	72 	r 
	defb 000h		;3d93	00 	. 
	defb 052h		;3d94	52 	R 
	defb 045h		;3d95	45 	E 
	defb 054h		;3d96	54 	T 
	defb 055h		;3d97	55 	U 
	defb 052h		;3d98	52 	R 
	defb 04eh		;3d99	4e 	N 
	defb 020h		;3d9a	20 	  
	defb 077h		;3d9b	77 	w 
	defb 069h		;3d9c	69 	i 
	defb 074h		;3d9d	74 	t 
	defb 068h		;3d9e	68 	h 
	defb 06fh		;3d9f	6f 	o 
	defb 075h		;3da0	75 	u 
	defb 074h		;3da1	74 	t 
	defb 020h		;3da2	20 	  
	defb 047h		;3da3	47 	G 
	defb 04fh		;3da4	4f 	O 
	defb 053h		;3da5	53 	S 
	defb 055h		;3da6	55 	U 
	defb 042h		;3da7	42 	B 
	defb 000h		;3da8	00 	. 
	defb 04fh		;3da9	4f 	O 
	defb 075h		;3daa	75 	u 
	defb 074h		;3dab	74 	t 
	defb 020h		;3dac	20 	  
	defb 06fh		;3dad	6f 	o 
	defb 066h		;3dae	66 	f 
	defb 020h		;3daf	20 	  
	defb 044h		;3db0	44 	D 
	defb 041h		;3db1	41 	A 
	defb 054h		;3db2	54 	T 
	defb 041h		;3db3	41 	A 
	defb 000h		;3db4	00 	. 
	defb 049h		;3db5	49 	I 
	defb 06ch		;3db6	6c 	l 
	defb 06ch		;3db7	6c 	l 
	defb 065h		;3db8	65 	e 
	defb 067h		;3db9	67 	g 
	defb 061h		;3dba	61 	a 
	defb 06ch		;3dbb	6c 	l 
	defb 020h		;3dbc	20 	  
	defb 066h		;3dbd	66 	f 
	defb 075h		;3dbe	75 	u 
	defb 06eh		;3dbf	6e 	n 
	defb 063h		;3dc0	63 	c 
	defb 074h		;3dc1	74 	t 
	defb 069h		;3dc2	69 	i 
	defb 06fh		;3dc3	6f 	o 
	defb 06eh		;3dc4	6e 	n 
	defb 020h		;3dc5	20 	  
	defb 063h		;3dc6	63 	c 
	defb 061h		;3dc7	61 	a 
	defb 06ch		;3dc8	6c 	l 
	defb 06ch		;3dc9	6c 	l 
	defb 000h		;3dca	00 	. 
	defb 04fh		;3dcb	4f 	O 
	defb 076h		;3dcc	76 	v 
	defb 065h		;3dcd	65 	e 
	defb 072h		;3dce	72 	r 
	defb 066h		;3dcf	66 	f 
	defb 06ch		;3dd0	6c 	l 
	defb 06fh		;3dd1	6f 	o 
	defb 077h		;3dd2	77 	w 
	defb 000h		;3dd3	00 	. 
	defb 04fh		;3dd4	4f 	O 
	defb 075h		;3dd5	75 	u 
	defb 074h		;3dd6	74 	t 
	defb 020h		;3dd7	20 	  
	defb 06fh		;3dd8	6f 	o 
	defb 066h		;3dd9	66 	f 
	defb 020h		;3dda	20 	  
	defb 06dh		;3ddb	6d 	m 
	defb 065h		;3ddc	65 	e 
	defb 06dh		;3ddd	6d 	m 
	defb 06fh		;3dde	6f 	o 
	defb 072h		;3ddf	72 	r 
	defb 079h		;3de0	79 	y 
	defb 000h		;3de1	00 	. 
	defb 055h		;3de2	55 	U 
	defb 06eh		;3de3	6e 	n 
	defb 064h		;3de4	64 	d 
	defb 065h		;3de5	65 	e 
	defb 066h		;3de6	66 	f 
	defb 069h		;3de7	69 	i 
	defb 06eh		;3de8	6e 	n 
	defb 065h		;3de9	65 	e 
	defb 064h		;3dea	64 	d 
	defb 020h		;3deb	20 	  
	defb 06ch		;3dec	6c 	l 
	defb 069h		;3ded	69 	i 
	defb 06eh		;3dee	6e 	n 
	defb 065h		;3def	65 	e 
	defb 020h		;3df0	20 	  
	defb 06eh		;3df1	6e 	n 
	defb 075h		;3df2	75 	u 
	defb 06dh		;3df3	6d 	m 
	defb 062h		;3df4	62 	b 
	defb 065h		;3df5	65 	e 
	defb 072h		;3df6	72 	r 
	defb 000h		;3df7	00 	. 
	defb 053h		;3df8	53 	S 
	defb 075h		;3df9	75 	u 
	defb 062h		;3dfa	62 	b 
	defb 073h		;3dfb	73 	s 
	defb 063h		;3dfc	63 	c 
	defb 072h		;3dfd	72 	r 
	defb 069h		;3dfe	69 	i 
	defb 070h		;3dff	70 	p 
	defb 074h		;3e00	74 	t 
	defb 020h		;3e01	20 	  
	defb 06fh		;3e02	6f 	o 
	defb 075h		;3e03	75 	u 
	defb 074h		;3e04	74 	t 
	defb 020h		;3e05	20 	  
	defb 06fh		;3e06	6f 	o 
	defb 066h		;3e07	66 	f 
	defb 020h		;3e08	20 	  
	defb 072h		;3e09	72 	r 
	defb 061h		;3e0a	61 	a 
	defb 06eh		;3e0b	6e 	n 
	defb 067h		;3e0c	67 	g 
	defb 065h		;3e0d	65 	e 
	defb 000h		;3e0e	00 	. 
	defb 052h		;3e0f	52 	R 
	defb 065h		;3e10	65 	e 
	defb 064h		;3e11	64 	d 
	defb 069h		;3e12	69 	i 
	defb 06dh		;3e13	6d 	m 
	defb 065h		;3e14	65 	e 
	defb 06eh		;3e15	6e 	n 
	defb 073h		;3e16	73 	s 
	defb 069h		;3e17	69 	i 
	defb 06fh		;3e18	6f 	o 
	defb 06eh		;3e19	6e 	n 
	defb 065h		;3e1a	65 	e 
	defb 064h		;3e1b	64 	d 
	defb 020h		;3e1c	20 	  
	defb 061h		;3e1d	61 	a 
	defb 072h		;3e1e	72 	r 
	defb 072h		;3e1f	72 	r 
	defb 061h		;3e20	61 	a 
	defb 079h		;3e21	79 	y 
	defb 000h		;3e22	00 	. 
	defb 044h		;3e23	44 	D 
	defb 069h		;3e24	69 	i 
l3e25h:
	defb 076h		;3e25	76 	v 
	defb 069h		;3e26	69 	i 
	defb 073h		;3e27	73 	s 
	defb 069h		;3e28	69 	i 
	defb 06fh		;3e29	6f 	o 
	defb 06eh		;3e2a	6e 	n 
	defb 020h		;3e2b	20 	  
	defb 062h		;3e2c	62 	b 
	defb 079h		;3e2d	79 	y 
	defb 020h		;3e2e	20 	  
	defb 07ah		;3e2f	7a 	z 
	defb 065h		;3e30	65 	e 
	defb 072h		;3e31	72 	r 
	defb 06fh		;3e32	6f 	o 
	defb 000h		;3e33	00 	. 
	defb 049h		;3e34	49 	I 
	defb 06ch		;3e35	6c 	l 
	defb 06ch		;3e36	6c 	l 
	defb 065h		;3e37	65 	e 
	defb 067h		;3e38	67 	g 
	defb 061h		;3e39	61 	a 
	defb 06ch		;3e3a	6c 	l 
	defb 020h		;3e3b	20 	  
	defb 064h		;3e3c	64 	d 
	defb 069h		;3e3d	69 	i 
	defb 072h		;3e3e	72 	r 
	defb 065h		;3e3f	65 	e 
	defb 063h		;3e40	63 	c 
	defb 074h		;3e41	74 	t 
	defb 000h		;3e42	00 	. 
	defb 054h		;3e43	54 	T 
	defb 079h		;3e44	79 	y 
	defb 070h		;3e45	70 	p 
	defb 065h		;3e46	65 	e 
	defb 020h		;3e47	20 	  
	defb 06dh		;3e48	6d 	m 
	defb 069h		;3e49	69 	i 
	defb 073h		;3e4a	73 	s 
	defb 06dh		;3e4b	6d 	m 
	defb 061h		;3e4c	61 	a 
	defb 074h		;3e4d	74 	t 
	defb 063h		;3e4e	63 	c 
	defb 068h		;3e4f	68 	h 
	defb 000h		;3e50	00 	. 
	defb 04fh		;3e51	4f 	O 
	defb 075h		;3e52	75 	u 
	defb 074h		;3e53	74 	t 
	defb 020h		;3e54	20 	  
	defb 06fh		;3e55	6f 	o 
	defb 066h		;3e56	66 	f 
	defb 020h		;3e57	20 	  
	defb 073h		;3e58	73 	s 
	defb 074h		;3e59	74 	t 
	defb 072h		;3e5a	72 	r 
	defb 069h		;3e5b	69 	i 
	defb 06eh		;3e5c	6e 	n 
	defb 067h		;3e5d	67 	g 
	defb 020h		;3e5e	20 	  
	defb 073h		;3e5f	73 	s 
	defb 070h		;3e60	70 	p 
	defb 061h		;3e61	61 	a 
	defb 063h		;3e62	63 	c 
	defb 065h		;3e63	65 	e 
	defb 000h		;3e64	00 	. 
	defb 053h		;3e65	53 	S 
	defb 074h		;3e66	74 	t 
	defb 072h		;3e67	72 	r 
	defb 069h		;3e68	69 	i 
	defb 06eh		;3e69	6e 	n 
	defb 067h		;3e6a	67 	g 
	defb 020h		;3e6b	20 	  
	defb 074h		;3e6c	74 	t 
	defb 06fh		;3e6d	6f 	o 
	defb 06fh		;3e6e	6f 	o 
	defb 020h		;3e6f	20 	  
	defb 06ch		;3e70	6c 	l 
	defb 06fh		;3e71	6f 	o 
	defb 06eh		;3e72	6e 	n 
	defb 067h		;3e73	67 	g 
	defb 000h		;3e74	00 	. 
	defb 053h		;3e75	53 	S 
	defb 074h		;3e76	74 	t 
	defb 072h		;3e77	72 	r 
	defb 069h		;3e78	69 	i 
	defb 06eh		;3e79	6e 	n 
	defb 067h		;3e7a	67 	g 
	defb 020h		;3e7b	20 	  
	defb 066h		;3e7c	66 	f 
	defb 06fh		;3e7d	6f 	o 
	defb 072h		;3e7e	72 	r 
	defb 06dh		;3e7f	6d 	m 
	defb 075h		;3e80	75 	u 
	defb 06ch		;3e81	6c 	l 
	defb 061h		;3e82	61 	a 
	defb 020h		;3e83	20 	  
	defb 074h		;3e84	74 	t 
	defb 06fh		;3e85	6f 	o 
	defb 06fh		;3e86	6f 	o 
	defb 020h		;3e87	20 	  
	defb 063h		;3e88	63 	c 
	defb 06fh		;3e89	6f 	o 
	defb 06dh		;3e8a	6d 	m 
	defb 070h		;3e8b	70 	p 
	defb 06ch		;3e8c	6c 	l 
	defb 065h		;3e8d	65 	e 
	defb 078h		;3e8e	78 	x 
	defb 000h		;3e8f	00 	. 
	defb 043h		;3e90	43 	C 
	defb 061h		;3e91	61 	a 
	defb 06eh		;3e92	6e 	n 
	defb 027h		;3e93	27 	' 
	defb 074h		;3e94	74 	t 
	defb 020h		;3e95	20 	  
	defb 043h		;3e96	43 	C 
	defb 04fh		;3e97	4f 	O 
	defb 04eh		;3e98	4e 	N 
	defb 054h		;3e99	54 	T 
	defb 049h		;3e9a	49 	I 
	defb 04eh		;3e9b	4e 	N 
	defb 055h		;3e9c	55 	U 
	defb 045h		;3e9d	45 	E 
	defb 000h		;3e9e	00 	. 
	defb 055h		;3e9f	55 	U 
	defb 06eh		;3ea0	6e 	n 
	defb 064h		;3ea1	64 	d 
	defb 065h		;3ea2	65 	e 
	defb 066h		;3ea3	66 	f 
	defb 069h		;3ea4	69 	i 
	defb 06eh		;3ea5	6e 	n 
	defb 065h		;3ea6	65 	e 
	defb 064h		;3ea7	64 	d 
	defb 020h		;3ea8	20 	  
	defb 075h		;3ea9	75 	u 
	defb 073h		;3eaa	73 	s 
	defb 065h		;3eab	65 	e 
	defb 072h		;3eac	72 	r 
	defb 020h		;3ead	20 	  
	defb 066h		;3eae	66 	f 
	defb 075h		;3eaf	75 	u 
	defb 06eh		;3eb0	6e 	n 
	defb 063h		;3eb1	63 	c 
	defb 074h		;3eb2	74 	t 
	defb 069h		;3eb3	69 	i 
	defb 06fh		;3eb4	6f 	o 
	defb 06eh		;3eb5	6e 	n 
	defb 000h		;3eb6	00 	. 
	defb 044h		;3eb7	44 	D 
	defb 065h		;3eb8	65 	e 
	defb 076h		;3eb9	76 	v 
	defb 069h		;3eba	69 	i 
	defb 063h		;3ebb	63 	c 
	defb 065h		;3ebc	65 	e 
	defb 020h		;3ebd	20 	  
	defb 049h		;3ebe	49 	I 
	defb 02fh		;3ebf	2f 	/ 
	defb 04fh		;3ec0	4f 	O 
	defb 020h		;3ec1	20 	  
	defb 065h		;3ec2	65 	e 
	defb 072h		;3ec3	72 	r 
	defb 072h		;3ec4	72 	r 
	defb 06fh		;3ec5	6f 	o 
	defb 072h		;3ec6	72 	r 
	defb 000h		;3ec7	00 	. 
	defb 056h		;3ec8	56 	V 
	defb 065h		;3ec9	65 	e 
	defb 072h		;3eca	72 	r 
	defb 069h		;3ecb	69 	i 
	defb 066h		;3ecc	66 	f 
	defb 079h		;3ecd	79 	y 
	defb 020h		;3ece	20 	  
	defb 065h		;3ecf	65 	e 
	defb 072h		;3ed0	72 	r 
	defb 072h		;3ed1	72 	r 
	defb 06fh		;3ed2	6f 	o 
	defb 072h		;3ed3	72 	r 
	defb 000h		;3ed4	00 	. 
	defb 04eh		;3ed5	4e 	N 
	defb 06fh		;3ed6	6f 	o 
	defb 020h		;3ed7	20 	  
	defb 052h		;3ed8	52 	R 
	defb 045h		;3ed9	45 	E 
	defb 053h		;3eda	53 	S 
	defb 055h		;3edb	55 	U 
	defb 04dh		;3edc	4d 	M 
	defb 045h		;3edd	45 	E 
	defb 000h		;3ede	00 	. 
	defb 052h		;3edf	52 	R 
	defb 045h		;3ee0	45 	E 
	defb 053h		;3ee1	53 	S 
	defb 055h		;3ee2	55 	U 
	defb 04dh		;3ee3	4d 	M 
	defb 045h		;3ee4	45 	E 
	defb 020h		;3ee5	20 	  
	defb 077h		;3ee6	77 	w 
	defb 069h		;3ee7	69 	i 
	defb 074h		;3ee8	74 	t 
	defb 068h		;3ee9	68 	h 
	defb 06fh		;3eea	6f 	o 
	defb 075h		;3eeb	75 	u 
	defb 074h		;3eec	74 	t 
	defb 020h		;3eed	20 	  
	defb 065h		;3eee	65 	e 
	defb 072h		;3eef	72 	r 
	defb 072h		;3ef0	72 	r 
	defb 06fh		;3ef1	6f 	o 
	defb 072h		;3ef2	72 	r 
	defb 000h		;3ef3	00 	. 
	defb 055h		;3ef4	55 	U 
	defb 06eh		;3ef5	6e 	n 
	defb 070h		;3ef6	70 	p 
	defb 072h		;3ef7	72 	r 
	defb 069h		;3ef8	69 	i 
	defb 06eh		;3ef9	6e 	n 
	defb 074h		;3efa	74 	t 
	defb 061h		;3efb	61 	a 
	defb 062h		;3efc	62 	b 
	defb 06ch		;3efd	6c 	l 
	defb 065h		;3efe	65 	e 
	defb 020h		;3eff	20 	  
	defb 065h		;3f00	65 	e 
	defb 072h		;3f01	72 	r 
	defb 072h		;3f02	72 	r 
	defb 06fh		;3f03	6f 	o 
	defb 072h		;3f04	72 	r 
	defb 000h		;3f05	00 	. 
	defb 04dh		;3f06	4d 	M 
	defb 069h		;3f07	69 	i 
	defb 073h		;3f08	73 	s 
	defb 073h		;3f09	73 	s 
	defb 069h		;3f0a	69 	i 
	defb 06eh		;3f0b	6e 	n 
	defb 067h		;3f0c	67 	g 
	defb 020h		;3f0d	20 	  
	defb 06fh		;3f0e	6f 	o 
	defb 070h		;3f0f	70 	p 
	defb 065h		;3f10	65 	e 
	defb 072h		;3f11	72 	r 
	defb 061h		;3f12	61 	a 
	defb 06eh		;3f13	6e 	n 
	defb 064h		;3f14	64 	d 
	defb 000h		;3f15	00 	. 
	defb 04ch		;3f16	4c 	L 
	defb 069h		;3f17	69 	i 
	defb 06eh		;3f18	6e 	n 
	defb 065h		;3f19	65 	e 
	defb 020h		;3f1a	20 	  
	defb 062h		;3f1b	62 	b 
	defb 075h		;3f1c	75 	u 
	defb 066h		;3f1d	66 	f 
	defb 066h		;3f1e	66 	f 
	defb 065h		;3f1f	65 	e 
	defb 072h		;3f20	72 	r 
	defb 020h		;3f21	20 	  
	defb 06fh		;3f22	6f 	o 
	defb 076h		;3f23	76 	v 
	defb 065h		;3f24	65 	e 
	defb 072h		;3f25	72 	r 
	defb 066h		;3f26	66 	f 
	defb 06ch		;3f27	6c 	l 
	defb 06fh		;3f28	6f 	o 
	defb 077h		;3f29	77 	w 
	defb 000h		;3f2a	00 	. 
	defb 046h		;3f2b	46 	F 
	defb 049h		;3f2c	49 	I 
	defb 045h		;3f2d	45 	E 
	defb 04ch		;3f2e	4c 	L 
	defb 044h		;3f2f	44 	D 
	defb 020h		;3f30	20 	  
	defb 06fh		;3f31	6f 	o 
	defb 076h		;3f32	76 	v 
	defb 065h		;3f33	65 	e 
	defb 072h		;3f34	72 	r 
	defb 066h		;3f35	66 	f 
	defb 06ch		;3f36	6c 	l 
	defb 06fh		;3f37	6f 	o 
	defb 077h		;3f38	77 	w 
	defb 000h		;3f39	00 	. 
	defb 049h		;3f3a	49 	I 
	defb 06eh		;3f3b	6e 	n 
	defb 074h		;3f3c	74 	t 
	defb 065h		;3f3d	65 	e 
	defb 072h		;3f3e	72 	r 
	defb 06eh		;3f3f	6e 	n 
	defb 061h		;3f40	61 	a 
	defb 06ch		;3f41	6c 	l 
	defb 020h		;3f42	20 	  
	defb 065h		;3f43	65 	e 
	defb 072h		;3f44	72 	r 
	defb 072h		;3f45	72 	r 
	defb 06fh		;3f46	6f 	o 
	defb 072h		;3f47	72 	r 
	defb 000h		;3f48	00 	. 
	defb 042h		;3f49	42 	B 
	defb 061h		;3f4a	61 	a 
	defb 064h		;3f4b	64 	d 
	defb 020h		;3f4c	20 	  
	defb 066h		;3f4d	66 	f 
	defb 069h		;3f4e	69 	i 
	defb 06ch		;3f4f	6c 	l 
	defb 065h		;3f50	65 	e 
	defb 020h		;3f51	20 	  
	defb 06eh		;3f52	6e 	n 
	defb 075h		;3f53	75 	u 
	defb 06dh		;3f54	6d 	m 
	defb 062h		;3f55	62 	b 
	defb 065h		;3f56	65 	e 
	defb 072h		;3f57	72 	r 
	defb 000h		;3f58	00 	. 
	defb 046h		;3f59	46 	F 
	defb 069h		;3f5a	69 	i 
	defb 06ch		;3f5b	6c 	l 
	defb 065h		;3f5c	65 	e 
	defb 020h		;3f5d	20 	  
	defb 06eh		;3f5e	6e 	n 
	defb 06fh		;3f5f	6f 	o 
	defb 074h		;3f60	74 	t 
	defb 020h		;3f61	20 	  
	defb 066h		;3f62	66 	f 
	defb 06fh		;3f63	6f 	o 
	defb 075h		;3f64	75 	u 
	defb 06eh		;3f65	6e 	n 
	defb 064h		;3f66	64 	d 
	defb 000h		;3f67	00 	. 
	defb 046h		;3f68	46 	F 
	defb 069h		;3f69	69 	i 
	defb 06ch		;3f6a	6c 	l 
	defb 065h		;3f6b	65 	e 
	defb 020h		;3f6c	20 	  
	defb 061h		;3f6d	61 	a 
	defb 06ch		;3f6e	6c 	l 
	defb 072h		;3f6f	72 	r 
	defb 065h		;3f70	65 	e 
	defb 061h		;3f71	61 	a 
l3f72h:
	defb 064h		;3f72	64 	d 
	defb 079h		;3f73	79 	y 
	defb 020h		;3f74	20 	  
	defb 06fh		;3f75	6f 	o 
	defb 070h		;3f76	70 	p 
	defb 065h		;3f77	65 	e 
	defb 06eh		;3f78	6e 	n 
	defb 000h		;3f79	00 	. 
	defb 049h		;3f7a	49 	I 
	defb 06eh		;3f7b	6e 	n 
	defb 070h		;3f7c	70 	p 
	defb 075h		;3f7d	75 	u 
	defb 074h		;3f7e	74 	t 
	defb 020h		;3f7f	20 	  
	defb 070h		;3f80	70 	p 
	defb 061h		;3f81	61 	a 
	defb 073h		;3f82	73 	s 
	defb 074h		;3f83	74 	t 
	defb 020h		;3f84	20 	  
	defb 065h		;3f85	65 	e 
	defb 06eh		;3f86	6e 	n 
	defb 064h		;3f87	64 	d 
	defb 000h		;3f88	00 	. 
	defb 042h		;3f89	42 	B 
	defb 061h		;3f8a	61 	a 
	defb 064h		;3f8b	64 	d 
	defb 020h		;3f8c	20 	  
	defb 066h		;3f8d	66 	f 
	defb 069h		;3f8e	69 	i 
	defb 06ch		;3f8f	6c 	l 
	defb 065h		;3f90	65 	e 
	defb 020h		;3f91	20 	  
	defb 06eh		;3f92	6e 	n 
	defb 061h		;3f93	61 	a 
	defb 06dh		;3f94	6d 	m 
	defb 065h		;3f95	65 	e 
	defb 000h		;3f96	00 	. 
	defb 044h		;3f97	44 	D 
	defb 069h		;3f98	69 	i 
	defb 072h		;3f99	72 	r 
	defb 065h		;3f9a	65 	e 
	defb 063h		;3f9b	63 	c 
	defb 074h		;3f9c	74 	t 
	defb 020h		;3f9d	20 	  
	defb 073h		;3f9e	73 	s 
	defb 074h		;3f9f	74 	t 
	defb 061h		;3fa0	61 	a 
	defb 074h		;3fa1	74 	t 
	defb 065h		;3fa2	65 	e 
	defb 06dh		;3fa3	6d 	m 
	defb 065h		;3fa4	65 	e 
	defb 06eh		;3fa5	6e 	n 
	defb 074h		;3fa6	74 	t 
	defb 020h		;3fa7	20 	  
	defb 069h		;3fa8	69 	i 
	defb 06eh		;3fa9	6e 	n 
	defb 020h		;3faa	20 	  
	defb 066h		;3fab	66 	f 
	defb 069h		;3fac	69 	i 
	defb 06ch		;3fad	6c 	l 
	defb 065h		;3fae	65 	e 
	defb 000h		;3faf	00 	. 
	defb 053h		;3fb0	53 	S 
	defb 065h		;3fb1	65 	e 
	defb 071h		;3fb2	71 	q 
	defb 075h		;3fb3	75 	u 
	defb 065h		;3fb4	65 	e 
	defb 06eh		;3fb5	6e 	n 
	defb 074h		;3fb6	74 	t 
	defb 069h		;3fb7	69 	i 
	defb 061h		;3fb8	61 	a 
	defb 06ch		;3fb9	6c 	l 
	defb 020h		;3fba	20 	  
	defb 049h		;3fbb	49 	I 
	defb 02fh		;3fbc	2f 	/ 
	defb 04fh		;3fbd	4f 	O 
	defb 020h		;3fbe	20 	  
	defb 06fh		;3fbf	6f 	o 
	defb 06eh		;3fc0	6e 	n 
	defb 06ch		;3fc1	6c 	l 
	defb 079h		;3fc2	79 	y 
	defb 000h		;3fc3	00 	. 
	defb 046h		;3fc4	46 	F 
	defb 069h		;3fc5	69 	i 
	defb 06ch		;3fc6	6c 	l 
	defb 065h		;3fc7	65 	e 
	defb 020h		;3fc8	20 	  
	defb 06eh		;3fc9	6e 	n 
	defb 06fh		;3fca	6f 	o 
	defb 074h		;3fcb	74 	t 
	defb 020h		;3fcc	20 	  
	defb 04fh		;3fcd	4f 	O 
	defb 050h		;3fce	50 	P 
	defb 045h		;3fcf	45 	E 
	defb 04eh		;3fd0	4e 	N 
	defb 000h		;3fd1	00 	. 
l3fd2h:
	defb 020h		;3fd2	20 	  
	defb 069h		;3fd3	69 	i 
	defb 06eh		;3fd4	6e 	n 
	defb 020h		;3fd5	20 	  
l3fd6h:
	defb 000h		;3fd6	00 	. 
l3fd7h:
	defb 04fh		;3fd7	4f 	O 
	defb 06bh		;3fd8	6b 	k 
	defb 00dh		;3fd9	0d 	. 
	defb 00ah		;3fda	0a 	. 
	defb 000h		;3fdb	00 	. 
l3fdch:
	defb 042h		;3fdc	42 	B 
	defb 072h		;3fdd	72 	r 
	defb 065h		;3fde	65 	e 
	defb 061h		;3fdf	61 	a 
	defb 06bh		;3fe0	6b 	k 
	defb 000h		;3fe1	00 	. 
CHKFOR:
	ld hl,004h		;3fe2	21 04 00 	! . . 
	add hl,sp			;3fe5	39 	9 
l3fe6h:
	ld a,(hl)			;3fe6	7e 	~ 
	inc hl			;3fe7	23 	# 
	cp 082h		;3fe8	fe 82 	. . 
	ret nz			;3fea	c0 	. 
	ld c,(hl)			;3feb	4e 	N 
	inc hl			;3fec	23 	# 
	ld b,(hl)			;3fed	46 	F 
	inc hl			;3fee	23 	# 
	push hl			;3fef	e5 	. 
	ld h,b			;3ff0	60 	` 
	ld l,c			;3ff1	69 	i 
	ld a,d			;3ff2	7a 	z 
	or e			;3ff3	b3 	. 
	ex de,hl			;3ff4	eb 	. 
	jr z,l3ff9h		;3ff5	28 02 	( . 
	ex de,hl			;3ff7	eb 	. 
	rst 20h			;3ff8	e7 	. 
l3ff9h:
	ld bc,00016h		;3ff9	01 16 00 	. . . 
	pop hl			;3ffc	e1 	. 
	ret z			;3ffd	c8 	. 
l3ffeh:
	add hl,bc			;3ffe	09 	. 
	jr l3fe6h		;3fff	18 e5 	. . 
	call sub_5439h		;4001	cd 39 54 	. 9 T 
	ld b,h			;4004	44 	D 
	ld c,l			;4005	4d 	M 
	in a,(c)		;4006	ed 78 	. x 
	jp l4fcfh		;4008	c3 cf 4f 	. . O 
sub_400bh:
	call sub_542fh		;400b	cd 2f 54 	. / T 
	push de			;400e	d5 	. 
	rst 8			;400f	cf 	. 
	inc l			;4010	2c 	, 
	call sub_521ch		;4011	cd 1c 52 	. . R 
	pop bc			;4014	c1 	. 
	ret			;4015	c9 	. 
	call sub_400bh		;4016	cd 0b 40 	. . @ 
	out (c),a		;4019	ed 79 	. y 
	ret			;401b	c9 	. 
	call sub_400bh		;401c	cd 0b 40 	. . @ 
	push bc			;401f	c5 	. 
	push af			;4020	f5 	. 
	ld e,000h		;4021	1e 00 	. . 
	dec hl			;4023	2b 	+ 
	rst 10h			;4024	d7 	. 
	jr z,l402ch		;4025	28 05 	( . 
	rst 8			;4027	cf 	. 
	inc l			;4028	2c 	, 
	call sub_521ch		;4029	cd 1c 52 	. . R 
l402ch:
	pop af			;402c	f1 	. 
	ld d,a			;402d	57 	W 
	pop bc			;402e	c1 	. 
l402fh:
	call S.UPC		;402f	cd bd 00 	. . . 
	in a,(c)		;4032	ed 78 	. x 
	xor e			;4034	ab 	. 
	and d			;4035	a2 	. 
	jr z,l402fh		;4036	28 f7 	( . 
	ret			;4038	c9 	. 
l4039h:
	call H.PRGE		;4039	cd f8 fe 	. . . 
	ld hl,(CURLIN)		;403c	2a 1c f4 	* . . 
	ld a,h			;403f	7c 	| 
	and l			;4040	a5 	. 
	inc a			;4041	3c 	< 
	jr z,l404ch		;4042	28 08 	( . 
	ld a,(ONEFLG)		;4044	3a bb f6 	: . . 
	or a			;4047	b7 	. 
	ld e,015h		;4048	1e 15 	. . 
	jr nz,l406fh		;404a	20 23 	  # 
l404ch:
	jp l6401h		;404c	c3 01 64 	. . d 
l404fh:
	ld hl,(DATLIN)		;404f	2a a3 f6 	* . . 
	ld (CURLIN),hl		;4052	22 1c f4 	" . . 
l4055h:
	ld e,002h		;4055	1e 02 	. . 
	ld bc,l0b1eh		;4057	01 1e 0b 	. . . 
	ld bc,S.DSPFNK+1		;405a	01 1e 01 	. . . 
	ld bc,00a1eh		;405d	01 1e 0a 	. . . 
	ld bc,0121eh		;4060	01 1e 12 	. . . 
	ld bc,l161eh		;4063	01 1e 16 	. . . 
	ld bc,l061dh+1		;4066	01 1e 06 	. . . 
	ld bc,l181eh		;4069	01 1e 18 	. . . 
	ld bc,00d1eh		;406c	01 1e 0d 	. . . 
l406fh:
	call H.ERRO		;406f	cd b1 ff 	. . . 
	xor a			;4072	af 	. 
	call sub_7987h		;4073	cd 87 79 	. . y 
	ld hl,(VLZADR)		;4076	2a 19 f4 	* . . 
	ld a,h			;4079	7c 	| 
	or l			;407a	b5 	. 
	jr z,l4087h		;407b	28 0a 	( . 
	ld a,(VLZDAT)		;407d	3a 1b f4 	: . . 
	ld (hl),a			;4080	77 	w 
	ld hl,0000h		;4081	21 00 00 	! . . 
	ld (VLZADR),hl		;4084	22 19 f4 	" . . 
l4087h:
	ei			;4087	fb 	. 
	ld hl,(CURLIN)		;4088	2a 1c f4 	* . . 
	ld (ERRLIN),hl		;408b	22 b3 f6 	" . . 
	ld a,h			;408e	7c 	| 
	and l			;408f	a5 	. 
	inc a			;4090	3c 	< 
	jr z,l4096h		;4091	28 03 	( . 
	ld (DOT),hl		;4093	22 b5 f6 	" . . 
l4096h:
	ld bc,l40a4h		;4096	01 a4 40 	. . @ 
	jr l409eh		;4099	18 03 	. . 
l409bh:
	ld bc,0411eh		;409b	01 1e 41 	. . A 
l409eh:
	ld hl,(SAVSTK)		;409e	2a b1 f6 	* . . 
	jp l62f0h		;40a1	c3 f0 62 	. . b 
l40a4h:
	pop bc			;40a4	c1 	. 
	ld a,e			;40a5	7b 	{ 
	ld c,e			;40a6	4b 	K 
	ld (ERRFLG),a		;40a7	32 14 f4 	2 . . 
	ld hl,(SAVTXT)		;40aa	2a af f6 	* . . 
	ld (ERRTXT),hl		;40ad	22 b7 f6 	" . . 
	ex de,hl			;40b0	eb 	. 
	ld hl,(ERRLIN)		;40b1	2a b3 f6 	* . . 
	ld a,h			;40b4	7c 	| 
	and l			;40b5	a5 	. 
	inc a			;40b6	3c 	< 
	jr z,l40c0h		;40b7	28 07 	( . 
	ld (OLDLIN),hl		;40b9	22 be f6 	" . . 
	ex de,hl			;40bc	eb 	. 
	ld (OLDTXT),hl		;40bd	22 c0 f6 	" . . 
l40c0h:
	ld hl,(ONELIN)		;40c0	2a b9 f6 	* . . 
	ld a,h			;40c3	7c 	| 
	or l			;40c4	b5 	. 
	ex de,hl			;40c5	eb 	. 
	ld hl,ONEFLG		;40c6	21 bb f6 	! . . 
	jr z,l40d3h		;40c9	28 08 	( . 
	and (hl)			;40cb	a6 	. 
	jr nz,l40d3h		;40cc	20 05 	  . 
	dec (hl)			;40ce	35 	5 
	ex de,hl			;40cf	eb 	. 
	jp l4620h		;40d0	c3 20 46 	.   F 
l40d3h:
	xor a			;40d3	af 	. 
	ld (hl),a			;40d4	77 	w 
	ld e,c			;40d5	59 	Y 
	call sub_7323h		;40d6	cd 23 73 	. # s 
	ld hl,ERRORMSGS		;40d9	21 75 3d 	! u = 
	call H.ERRP		;40dc	cd fd fe 	. . . 
	ld a,e			;40df	7b 	{ 
	cp 03ch		;40e0	fe 3c 	. < 
	jr nc,l40ech		;40e2	30 08 	0 . 
	cp 032h		;40e4	fe 32 	. 2 
	jr nc,l40eeh		;40e6	30 06 	0 . 
	cp 01ah		;40e8	fe 1a 	. . 
	jr c,l40f1h		;40ea	38 05 	8 . 
l40ech:
	ld a,02fh		;40ec	3e 2f 	> / 
l40eeh:
	sub 018h		;40ee	d6 18 	. . 
	ld e,a			;40f0	5f 	_ 
l40f1h:
	call sub_485dh		;40f1	cd 5d 48 	. ] H 
	inc hl			;40f4	23 	# 
	dec e			;40f5	1d 	. 
	jr nz,l40f1h		;40f6	20 f9 	  . 
	push hl			;40f8	e5 	. 
	ld hl,(ERRLIN)		;40f9	2a b3 f6 	* . . 
	ex (sp),hl			;40fc	e3 	. 
l40fdh:
	call H.ERRF		;40fd	cd 02 ff 	. . . 
	push hl			;4100	e5 	. 
	call TOTEXT		;4101	cd d2 00 	. . . 
	pop hl			;4104	e1 	. 
	ld a,(hl)			;4105	7e 	~ 
	cp 03fh		;4106	fe 3f 	. ? 
	jr nz,l4110h		;4108	20 06 	  . 
	pop hl			;410a	e1 	. 
	ld hl,ERRORMSGS		;410b	21 75 3d 	! u = 
	jr l40ech		;410e	18 dc 	. . 
l4110h:
	call sub_6678h		;4110	cd 78 66 	. x f 
	ld a,007h		;4113	3e 07 	> . 
	rst 18h			;4115	df 	. 
	pop hl			;4116	e1 	. 
	ld a,h			;4117	7c 	| 
	and l			;4118	a5 	. 
	inc a			;4119	3c 	< 
	call nz,sub_340ah		;411a	c4 0a 34 	. . 4 
	ld a,0c1h		;411d	3e c1 	> . 
l411fh:
	call TOTEXT		;411f	cd d2 00 	. . . 
	call sub_7304h		;4122	cd 04 73 	. . s 
	call sub_6d7bh		;4125	cd 7b 6d 	. { m 
	call H.READ		;4128	cd 07 ff 	. . . 
	call sub_7be8h		;412b	cd e8 7b 	. . { 
	nop			;412e	00 	. 
	nop			;412f	00 	. 
	nop			;4130	00 	. 
	nop			;4131	00 	. 
	nop			;4132	00 	. 
	nop			;4133	00 	. 
l4134h:
	call H.MAIN		;4134	cd 0c ff 	. . . 
	ld hl,0ffffh		;4137	21 ff ff 	! . . 
	ld (CURLIN),hl		;413a	22 1c f4 	" . . 
	ld hl,0f40fh		;413d	21 0f f4 	! . . 
	ld (SAVTXT),hl		;4140	22 af f6 	" . . 
	ld a,(AUTFLG)		;4143	3a aa f6 	: . . 
	or a			;4146	b7 	. 
	jr z,l415fh		;4147	28 16 	( . 
	ld hl,(AUTLIN)		;4149	2a ab f6 	* . . 
	push hl			;414c	e5 	. 
	call sub_3412h		;414d	cd 12 34 	. . 4 
	pop de			;4150	d1 	. 
	push de			;4151	d5 	. 
	call sub_4295h		;4152	cd 95 42 	. . B 
	ld a,02ah		;4155	3e 2a 	> * 
	jr c,l415bh		;4157	38 02 	8 . 
	ld a,020h		;4159	3e 20 	>   
l415bh:
	rst 18h			;415b	df 	. 
	ld (AUTFLG),a		;415c	32 aa f6 	2 . . 
l415fh:
	call ISFLIO		;415f	cd 4a 01 	. J . 
	jr nz,l4170h		;4162	20 0c 	  . 
	call PINLIN		;4164	cd ae 00 	. . . 
	jr nc,l4173h		;4167	30 0a 	0 . 
	xor a			;4169	af 	. 
	ld (AUTFLG),a		;416a	32 aa f6 	2 . . 
	jp l4134h		;416d	c3 34 41 	. 4 A 
l4170h:
	call sub_7374h		;4170	cd 74 73 	. t s 
l4173h:
	rst 10h			;4173	d7 	. 
	inc a			;4174	3c 	< 
	dec a			;4175	3d 	= 
	jr z,l4134h		;4176	28 bc 	( . 
	push af			;4178	f5 	. 
	call sub_4769h		;4179	cd 69 47 	. i G 
	jr nc,l4184h		;417c	30 06 	0 . 
	call ISFLIO		;417e	cd 4a 01 	. J . 
	jp z,l4055h		;4181	ca 55 40 	. U @ 
l4184h:
	call sub_4514h		;4184	cd 14 45 	. . E 
	ld a,(AUTFLG)		;4187	3a aa f6 	: . . 
	or a			;418a	b7 	. 
	jr z,l4195h		;418b	28 08 	( . 
	cp 02ah		;418d	fe 2a 	. * 
	jr nz,l4195h		;418f	20 04 	  . 
	cp (hl)			;4191	be 	. 
	jr nz,l4195h		;4192	20 01 	  . 
	inc hl			;4194	23 	# 
l4195h:
	ld a,d			;4195	7a 	z 
	or e			;4196	b3 	. 
	jr z,l419fh		;4197	28 06 	( . 
	ld a,(hl)			;4199	7e 	~ 
	cp 020h		;419a	fe 20 	.   
	jr nz,l419fh		;419c	20 01 	  . 
	inc hl			;419e	23 	# 
l419fh:
	push de			;419f	d5 	. 
	call sub_42b2h		;41a0	cd b2 42 	. . B 
	pop de			;41a3	d1 	. 
	pop af			;41a4	f1 	. 
	ld (SAVTXT),hl		;41a5	22 af f6 	" . . 
	call H.DIRD		;41a8	cd 11 ff 	. . . 
	jr c,l41b4h		;41ab	38 07 	8 . 
	xor a			;41ad	af 	. 
	ld (AUTFLG),a		;41ae	32 aa f6 	2 . . 
	jp l6d48h		;41b1	c3 48 6d 	. H m 
l41b4h:
	push de			;41b4	d5 	. 
	push bc			;41b5	c5 	. 
	rst 10h			;41b6	d7 	. 
	or a			;41b7	b7 	. 
	push af			;41b8	f5 	. 
	ld a,(AUTFLG)		;41b9	3a aa f6 	: . . 
	and a			;41bc	a7 	. 
	jr z,l41c2h		;41bd	28 03 	( . 
	pop af			;41bf	f1 	. 
	scf			;41c0	37 	7 
	push af			;41c1	f5 	. 
l41c2h:
	ld (DOT),de		;41c2	ed 53 b5 f6 	. S . . 
	ld hl,(AUTINC)		;41c6	2a ad f6 	* . . 
	add hl,de			;41c9	19 	. 
	jr c,l41d7h		;41ca	38 0b 	8 . 
	push de			;41cc	d5 	. 
	ld de,0fffah		;41cd	11 fa ff 	. . . 
	rst 20h			;41d0	e7 	. 
	pop de			;41d1	d1 	. 
	ld (AUTLIN),hl		;41d2	22 ab f6 	" . . 
	jr c,l41dbh		;41d5	38 04 	8 . 
l41d7h:
	xor a			;41d7	af 	. 
	ld (AUTFLG),a		;41d8	32 aa f6 	2 . . 
l41dbh:
	call sub_4295h		;41db	cd 95 42 	. . B 
	jr c,l41edh		;41de	38 0d 	8 . 
	pop af			;41e0	f1 	. 
	push af			;41e1	f5 	. 
	jr nz,l41eah		;41e2	20 06 	  . 
	jp nc,l481ch		;41e4	d2 1c 48 	. . H 
l41e7h:
	push bc			;41e7	c5 	. 
	jr l4237h		;41e8	18 4d 	. M 
l41eah:
	or a			;41ea	b7 	. 
	jr l41f4h		;41eb	18 07 	. . 
l41edh:
	pop af			;41ed	f1 	. 
	push af			;41ee	f5 	. 
	jr nz,l41f3h		;41ef	20 02 	  . 
	jr c,l41e7h		;41f1	38 f4 	8 . 
l41f3h:
	scf			;41f3	37 	7 
l41f4h:
	push bc			;41f4	c5 	. 
	push af			;41f5	f5 	. 
	push hl			;41f6	e5 	. 
	call sub_54eah		;41f7	cd ea 54 	. . T 
	pop hl			;41fa	e1 	. 
	pop af			;41fb	f1 	. 
	pop bc			;41fc	c1 	. 
	push bc			;41fd	c5 	. 
	call c,sub_5405h		;41fe	dc 05 54 	. . T 
	pop de			;4201	d1 	. 
	pop af			;4202	f1 	. 
	push de			;4203	d5 	. 
	jr z,l4237h		;4204	28 31 	( 1 
	pop de			;4206	d1 	. 
	ld hl,0000h		;4207	21 00 00 	! . . 
	ld (ONELIN),hl		;420a	22 b9 f6 	" . . 
	ld hl,(VARTAB)		;420d	2a c2 f6 	* . . 
	ex (sp),hl			;4210	e3 	. 
	pop bc			;4211	c1 	. 
	push hl			;4212	e5 	. 
	add hl,bc			;4213	09 	. 
	push hl			;4214	e5 	. 
	call sub_6250h		;4215	cd 50 62 	. P b 
	pop hl			;4218	e1 	. 
	ld (VARTAB),hl		;4219	22 c2 f6 	" . . 
	ex de,hl			;421c	eb 	. 
	ld (hl),h			;421d	74 	t 
	pop bc			;421e	c1 	. 
	pop de			;421f	d1 	. 
	push hl			;4220	e5 	. 
	inc hl			;4221	23 	# 
	inc hl			;4222	23 	# 
	ld (hl),e			;4223	73 	s 
	inc hl			;4224	23 	# 
	ld (hl),d			;4225	72 	r 
	inc hl			;4226	23 	# 
	ld de,KBUF		;4227	11 1f f4 	. . . 
	dec bc			;422a	0b 	. 
	dec bc			;422b	0b 	. 
	dec bc			;422c	0b 	. 
	dec bc			;422d	0b 	. 
l422eh:
	ld a,(de)			;422e	1a 	. 
	ld (hl),a			;422f	77 	w 
	inc hl			;4230	23 	# 
	inc de			;4231	13 	. 
	dec bc			;4232	0b 	. 
	ld a,c			;4233	79 	y 
	or b			;4234	b0 	. 
	jr nz,l422eh		;4235	20 f7 	  . 
l4237h:
	call H.FINI		;4237	cd 16 ff 	. . . 
	pop de			;423a	d1 	. 
	call sub_79a1h		;423b	cd a1 79 	. . y 
	ld hl,(PTRFIL)		;423e	2a 64 f8 	* d . 
l4241h:
	ld (TEMP2),hl		;4241	22 bc f6 	" . . 
	call sub_629ah		;4244	cd 9a 62 	. . b 
	call H.FINE		;4247	cd 1b ff 	. . . 
	ld hl,(TEMP2)		;424a	2a bc f6 	* . . 
	ld (PTRFIL),hl		;424d	22 64 f8 	" d . 
	jp l4134h		;4250	c3 34 41 	. 4 A 
sub_4253h:
	ld hl,(TXTTAB)		;4253	2a 76 f6 	* v . 
	ex de,hl			;4256	eb 	. 
l4257h:
	ld h,d			;4257	62 	b 
	ld l,e			;4258	6b 	k 
	ld a,(hl)			;4259	7e 	~ 
	inc hl			;425a	23 	# 
	or (hl)			;425b	b6 	. 
	ret z			;425c	c8 	. 
	inc hl			;425d	23 	# 
	inc hl			;425e	23 	# 
l425fh:
	inc hl			;425f	23 	# 
	ld a,(hl)			;4260	7e 	~ 
l4261h:
	or a			;4261	b7 	. 
	jr z,l4272h		;4262	28 0e 	( . 
	cp 020h		;4264	fe 20 	.   
	jr nc,l425fh		;4266	30 f7 	0 . 
	cp 00bh		;4268	fe 0b 	. . 
	jr c,l425fh		;426a	38 f3 	8 . 
	call sub_466ah		;426c	cd 6a 46 	. j F 
	rst 10h			;426f	d7 	. 
	jr l4261h		;4270	18 ef 	. . 
l4272h:
	inc hl			;4272	23 	# 
	ex de,hl			;4273	eb 	. 
	ld (hl),e			;4274	73 	s 
	inc hl			;4275	23 	# 
	ld (hl),d			;4276	72 	r 
	jr l4257h		;4277	18 de 	. . 
sub_4279h:
	ld de,0000h		;4279	11 00 00 	. . . 
	push de			;427c	d5 	. 
	jr z,$+11		;427d	28 09 	( . 
	pop de			;427f	d1 	. 
	call sub_475fh		;4280	cd 5f 47 	. _ G 
	push de			;4283	d5 	. 
	jr z,l4291h		;4284	28 0b 	( . 
	rst 8			;4286	cf 	. 
	jp p,0fa11h		;4287	f2 11 fa 	. . . 
	rst 38h			;428a	ff 	. 
	call nz,sub_475fh		;428b	c4 5f 47 	. _ G 
	jp nz,l4055h		;428e	c2 55 40 	. U @ 
l4291h:
	ex de,hl			;4291	eb 	. 
	pop de			;4292	d1 	. 
sub_4293h:
	ex (sp),hl			;4293	e3 	. 
	push hl			;4294	e5 	. 
sub_4295h:
	ld hl,(TXTTAB)		;4295	2a 76 f6 	* v . 
l4298h:
	ld b,h			;4298	44 	D 
	ld c,l			;4299	4d 	M 
	ld a,(hl)			;429a	7e 	~ 
	inc hl			;429b	23 	# 
	or (hl)			;429c	b6 	. 
	dec hl			;429d	2b 	+ 
	ret z			;429e	c8 	. 
	inc hl			;429f	23 	# 
	inc hl			;42a0	23 	# 
	ld a,(hl)			;42a1	7e 	~ 
	inc hl			;42a2	23 	# 
	ld h,(hl)			;42a3	66 	f 
	ld l,a			;42a4	6f 	o 
	rst 20h			;42a5	e7 	. 
	ld h,b			;42a6	60 	` 
	ld l,c			;42a7	69 	i 
	ld a,(hl)			;42a8	7e 	~ 
	inc hl			;42a9	23 	# 
	ld h,(hl)			;42aa	66 	f 
	ld l,a			;42ab	6f 	o 
	ccf			;42ac	3f 	? 
	ret z			;42ad	c8 	. 
	ccf			;42ae	3f 	? 
	ret nc			;42af	d0 	. 
	jr l4298h		;42b0	18 e6 	. . 
sub_42b2h:
	xor a			;42b2	af 	. 
	ld (DONUM),a		;42b3	32 65 f6 	2 e . 
	ld (DORES),a		;42b6	32 64 f6 	2 d . 
	call H.CRUN		;42b9	cd 20 ff 	.   . 
	ld bc,013bh		;42bc	01 3b 01 	. ; . 
	ld de,KBUF		;42bf	11 1f f4 	. . . 
l42c2h:
	ld a,(hl)			;42c2	7e 	~ 
	or a			;42c3	b7 	. 
	jr nz,l42d9h		;42c4	20 13 	  . 
l42c6h:
	ld hl,0140h		;42c6	21 40 01 	! @ . 
	ld a,l			;42c9	7d 	} 
	sub c			;42ca	91 	. 
	ld c,a			;42cb	4f 	O 
	ld a,h			;42cc	7c 	| 
	sbc a,b			;42cd	98 	. 
	ld b,a			;42ce	47 	G 
	ld hl,KBFMIN		;42cf	21 1e f4 	! . . 
	xor a			;42d2	af 	. 
	ld (de),a			;42d3	12 	. 
	inc de			;42d4	13 	. 
	ld (de),a			;42d5	12 	. 
	inc de			;42d6	13 	. 
	ld (de),a			;42d7	12 	. 
	ret			;42d8	c9 	. 
l42d9h:
	cp 022h		;42d9	fe 22 	. " 
	jp z,l4316h		;42db	ca 16 43 	. . C 
	cp 020h		;42de	fe 20 	.   
	jr z,l42e9h		;42e0	28 07 	( . 
	ld a,(DORES)		;42e2	3a 64 f6 	: d . 
	or a			;42e5	b7 	. 
	ld a,(hl)			;42e6	7e 	~ 
	jr z,l4326h		;42e7	28 3d 	( = 
l42e9h:
	inc hl			;42e9	23 	# 
	push af			;42ea	f5 	. 
	cp 001h		;42eb	fe 01 	. . 
	jr nz,l42f3h		;42ed	20 04 	  . 
	ld a,(hl)			;42ef	7e 	~ 
	and a			;42f0	a7 	. 
	ld a,001h		;42f1	3e 01 	> . 
l42f3h:
	call nz,sub_44e0h		;42f3	c4 e0 44 	. . D 
	pop af			;42f6	f1 	. 
	sub 03ah		;42f7	d6 3a 	. : 
	jr z,l4301h		;42f9	28 06 	( . 
	cp 04ah		;42fb	fe 4a 	. J 
	jr nz,l4307h		;42fd	20 08 	  . 
	ld a,001h		;42ff	3e 01 	> . 
l4301h:
	ld (DORES),a		;4301	32 64 f6 	2 d . 
	ld (DONUM),a		;4304	32 65 f6 	2 e . 
l4307h:
	sub 055h		;4307	d6 55 	. U 
	jr nz,l42c2h		;4309	20 b7 	  . 
	push af			;430b	f5 	. 
l430ch:
	ld a,(hl)			;430c	7e 	~ 
	or a			;430d	b7 	. 
	ex (sp),hl			;430e	e3 	. 
	ld a,h			;430f	7c 	| 
	pop hl			;4310	e1 	. 
	jr z,l42c6h		;4311	28 b3 	( . 
	cp (hl)			;4313	be 	. 
	jr z,l42e9h		;4314	28 d3 	( . 
l4316h:
	push af			;4316	f5 	. 
	ld a,(hl)			;4317	7e 	~ 
l4318h:
	inc hl			;4318	23 	# 
	cp 001h		;4319	fe 01 	. . 
	jr nz,l4321h		;431b	20 04 	  . 
	ld a,(hl)			;431d	7e 	~ 
	and a			;431e	a7 	. 
	ld a,001h		;431f	3e 01 	> . 
l4321h:
	call nz,sub_44e0h		;4321	c4 e0 44 	. . D 
	jr l430ch		;4324	18 e6 	. . 
l4326h:
	inc hl			;4326	23 	# 
	or a			;4327	b7 	. 
	jp m,l42c2h		;4328	fa c2 42 	. . B 
	cp 001h		;432b	fe 01 	. . 
	jr nz,l4336h		;432d	20 07 	  . 
	ld a,(hl)			;432f	7e 	~ 
	and a			;4330	a7 	. 
	jr z,l42c6h		;4331	28 93 	( . 
	inc hl			;4333	23 	# 
	jr l42c2h		;4334	18 8c 	. . 
l4336h:
	dec hl			;4336	2b 	+ 
	cp 03fh		;4337	fe 3f 	. ? 
	ld a,091h		;4339	3e 91 	> . 
	push de			;433b	d5 	. 
	push bc			;433c	c5 	. 
	jp z,l43a3h		;433d	ca a3 43 	. . C 
	ld a,(hl)			;4340	7e 	~ 
	cp 05fh		;4341	fe 5f 	. _ 
	jp z,l43a3h		;4343	ca a3 43 	. . C 
	ld de,l3d26h		;4346	11 26 3d 	. & = 
	call sub_4ea9h		;4349	cd a9 4e 	. . N 
	call sub_64a8h		;434c	cd a8 64 	. . d 
	jp c,l441dh		;434f	da 1d 44 	. . D 
	push hl			;4352	e5 	. 
	call H.CRUS		;4353	cd 25 ff 	. % . 
	ld hl,KEYWORDPTR_start	;4356	21 3e 3a 	! > : 
	sub 041h		;4359	d6 41 	. A 
	add a,a			;435b	87 	. 
	ld c,a			;435c	4f 	O 
	ld b,000h		;435d	06 00 	. . 
	add hl,bc			;435f	09 	. 
	ld e,(hl)			;4360	5e 	^ 
	inc hl			;4361	23 	# 
	ld d,(hl)			;4362	56 	V 
	pop hl			;4363	e1 	. 
	inc hl			;4364	23 	# 
l4365h:
	push hl			;4365	e5 	. 
l4366h:
	call sub_4ea9h		;4366	cd a9 4e 	. . N 
	ld c,a			;4369	4f 	O 
	ld a,(de)			;436a	1a 	. 
	and 07fh		;436b	e6 7f 	.  
	jp z,l44ebh		;436d	ca eb 44 	. . D 
	inc hl			;4370	23 	# 
	cp c			;4371	b9 	. 
	jr nz,l4398h		;4372	20 24 	  $ 
	ld a,(de)			;4374	1a 	. 
	inc de			;4375	13 	. 
	or a			;4376	b7 	. 
	jp p,l4366h		;4377	f2 66 43 	. f C 
	pop af			;437a	f1 	. 
	ld a,(de)			;437b	1a 	. 
	call H.ISRE		;437c	cd 2a ff 	. * . 
	or a			;437f	b7 	. 
	jp m,l43a2h		;4380	fa a2 43 	. . C 
	pop bc			;4383	c1 	. 
	pop de			;4384	d1 	. 
	or 080h		;4385	f6 80 	. . 
	push af			;4387	f5 	. 
	ld a,0ffh		;4388	3e ff 	> . 
	call sub_44e0h		;438a	cd e0 44 	. . D 
	xor a			;438d	af 	. 
	ld (DONUM),a		;438e	32 65 f6 	2 e . 
	pop af			;4391	f1 	. 
	call sub_44e0h		;4392	cd e0 44 	. . D 
	jp l42c2h		;4395	c3 c2 42 	. . B 
l4398h:
	pop hl			;4398	e1 	. 
l4399h:
	ld a,(de)			;4399	1a 	. 
	inc de			;439a	13 	. 
	or a			;439b	b7 	. 
	jp p,l4399h		;439c	f2 99 43 	. . C 
	inc de			;439f	13 	. 
	jr l4365h		;43a0	18 c3 	. . 
l43a2h:
	dec hl			;43a2	2b 	+ 
l43a3h:
	push af			;43a3	f5 	. 
	call H.NTFN		;43a4	cd 2f ff 	. / . 
	ld de,TABTOKENS_start		;43a7	11 b5 43 	. . C 
	ld c,a			;43aa	4f 	O 
l43abh:
	ld a,(de)			;43ab	1a 	. 
	or a			;43ac	b7 	. 
	jr z,TABTOKENS_end		;43ad	28 15 	( . 
	inc de			;43af	13 	. 
	cp c			;43b0	b9 	. 
	jr nz,l43abh		;43b1	20 f8 	  . 
	jr $+19		;43b3	18 11 	. . 

; BLOCK 'TABTOKENS' (start 0x43b5 end 0x43c4)
TABTOKENS_start:
	defb 08ch		;43b5	8c 	. 
	defb 0a9h		;43b6	a9 	. 
	defb 0aah		;43b7	aa 	. 
	defb 0a8h		;43b8	a8 	. 
	defb 0a7h		;43b9	a7 	. 
	defb 0e1h		;43ba	e1 	. 
	defb 0a1h		;43bb	a1 	. 
	defb 08ah		;43bc	8a 	. 
	defb 093h		;43bd	93 	. 
	defb 09eh		;43be	9e 	. 
	defb 089h		;43bf	89 	. 
	defb 08eh		;43c0	8e 	. 
	defb 0dah		;43c1	da 	. 
	defb 08dh		;43c2	8d 	. 
	defb 000h		;43c3	00 	. 
TABTOKENS_end:
	xor a			;43c4	af 	. 
	jp nz,RDVDP		;43c5	c2 3e 01 	. > . 
l43c8h:
	ld (DONUM),a		;43c8	32 65 f6 	2 e . 
	pop af			;43cb	f1 	. 
l43cch:
	pop bc			;43cc	c1 	. 
	pop de			;43cd	d1 	. 
	cp 0a1h		;43ce	fe a1 	. . 
	push af			;43d0	f5 	. 
	call z,sub_44deh		;43d1	cc de 44 	. . D 
	pop af			;43d4	f1 	. 
	cp 0cah		;43d5	fe ca 	. . 
	jr z,l43ddh		;43d7	28 04 	( . 
	cp 05fh		;43d9	fe 5f 	. _ 
	jr nz,l4406h		;43db	20 29 	  ) 
l43ddh:
	call nc,sub_44e0h		;43dd	d4 e0 44 	. . D 
l43e0h:
	inc hl			;43e0	23 	# 
	call sub_4ea9h		;43e1	cd a9 4e 	. . N 
	and a			;43e4	a7 	. 
l43e5h:
	jp z,l42c6h		;43e5	ca c6 42 	. . B 
	jp m,l43e0h		;43e8	fa e0 43 	. . C 
	cp 001h		;43eb	fe 01 	. . 
	jr nz,l43f6h		;43ed	20 07 	  . 
	inc hl			;43ef	23 	# 
	ld a,(hl)			;43f0	7e 	~ 
	and a			;43f1	a7 	. 
	jr z,l43e5h		;43f2	28 f1 	( . 
	jr l43e0h		;43f4	18 ea 	. . 
l43f6h:
	cp 020h		;43f6	fe 20 	.   
	jr z,l43ddh		;43f8	28 e3 	( . 
	cp 03ah		;43fa	fe 3a 	. : 
	jr z,l443ah		;43fc	28 3c 	( < 
	cp 028h		;43fe	fe 28 	. ( 
	jr z,l443ah		;4400	28 38 	( 8 
	cp 030h		;4402	fe 30 	. 0 
	jr l43ddh		;4404	18 d7 	. . 
l4406h:
	cp 0e6h		;4406	fe e6 	. . 
	jp nz,l44b4h		;4408	c2 b4 44 	. . D 
	push af			;440b	f5 	. 
	call sub_44deh		;440c	cd de 44 	. . D 
	ld a,08fh		;440f	3e 8f 	> . 
	call sub_44e0h		;4411	cd e0 44 	. . D 
	pop af			;4414	f1 	. 
	push hl			;4415	e5 	. 
	ld hl,0000h		;4416	21 00 00 	! . . 
	ex (sp),hl			;4419	e3 	. 
	jp l4318h		;441a	c3 18 43 	. . C 
l441dh:
	ld a,(hl)			;441d	7e 	~ 
	cp 02eh		;441e	fe 2e 	. . 
	jr z,l442ch		;4420	28 0a 	( . 
	cp 03ah		;4422	fe 3a 	. : 
	jp nc,l44a2h		;4424	d2 a2 44 	. . D 
	cp 030h		;4427	fe 30 	. 0 
	jp c,l44a2h		;4429	da a2 44 	. . D 
l442ch:
	ld a,(DONUM)		;442c	3a 65 f6 	: e . 
	or a			;442f	b7 	. 
	ld a,(hl)			;4430	7e 	~ 
	pop bc			;4431	c1 	. 
	pop de			;4432	d1 	. 
	jp m,l42e9h		;4433	fa e9 42 	. . B 
	jr z,l4457h		;4436	28 1f 	( . 
	cp 02eh		;4438	fe 2e 	. . 
l443ah:
	jp z,l42e9h		;443a	ca e9 42 	. . B 
	ld a,00eh		;443d	3e 0e 	> . 
	call sub_44e0h		;443f	cd e0 44 	. . D 
	push de			;4442	d5 	. 
l4443h:
	call sub_4769h		;4443	cd 69 47 	. i G 
	call sub_4514h		;4446	cd 14 45 	. . E 
l4449h:
	ex (sp),hl			;4449	e3 	. 
	ex de,hl			;444a	eb 	. 
l444bh:
	ld a,l			;444b	7d 	} 
	call sub_44e0h		;444c	cd e0 44 	. . D 
	ld a,h			;444f	7c 	| 
l4450h:
	pop hl			;4450	e1 	. 
	call sub_44e0h		;4451	cd e0 44 	. . D 
	jp l42c2h		;4454	c3 c2 42 	. . B 
l4457h:
	push de			;4457	d5 	. 
	push bc			;4458	c5 	. 
	ld a,(hl)			;4459	7e 	~ 
	call sub_3299h		;445a	cd 99 32 	. . 2 
	call sub_4514h		;445d	cd 14 45 	. . E 
	pop bc			;4460	c1 	. 
	pop de			;4461	d1 	. 
	push hl			;4462	e5 	. 
	ld a,(VALTYP)		;4463	3a 63 f6 	: c . 
	cp 002h		;4466	fe 02 	. . 
	jr nz,l447fh		;4468	20 15 	  . 
	ld hl,(0f7f8h)		;446a	2a f8 f7 	* . . 
	ld a,h			;446d	7c 	| 
	or a			;446e	b7 	. 
	ld a,002h		;446f	3e 02 	> . 
	jr nz,l447fh		;4471	20 0c 	  . 
	ld a,l			;4473	7d 	} 
	ld h,l			;4474	65 	e 
	ld l,00fh		;4475	2e 0f 	. . 
	cp 00ah		;4477	fe 0a 	. . 
	jr nc,l444bh		;4479	30 d0 	0 . 
	add a,011h		;447b	c6 11 	. . 
	jr l4450h		;447d	18 d1 	. . 
l447fh:
	push af			;447f	f5 	. 
	rrca			;4480	0f 	. 
	add a,01bh		;4481	c6 1b 	. . 
	call sub_44e0h		;4483	cd e0 44 	. . D 
	ld hl,DAC		;4486	21 f6 f7 	! . . 
	ld a,(VALTYP)		;4489	3a 63 f6 	: c . 
	cp 002h		;448c	fe 02 	. . 
	jr nz,l4493h		;448e	20 03 	  . 
	ld hl,0f7f8h		;4490	21 f8 f7 	! . . 
l4493h:
	pop af			;4493	f1 	. 
l4494h:
	push af			;4494	f5 	. 
	ld a,(hl)			;4495	7e 	~ 
	call sub_44e0h		;4496	cd e0 44 	. . D 
	pop af			;4499	f1 	. 
	inc hl			;449a	23 	# 
	dec a			;449b	3d 	= 
	jr nz,l4494h		;449c	20 f6 	  . 
	pop hl			;449e	e1 	. 
	jp l42c2h		;449f	c3 c2 42 	. . B 
l44a2h:
	ld de,l3d25h		;44a2	11 25 3d 	. % = 
l44a5h:
	inc de			;44a5	13 	. 
	ld a,(de)			;44a6	1a 	. 
	and 07fh		;44a7	e6 7f 	.  
	jp z,l44fah		;44a9	ca fa 44 	. . D 
	inc de			;44ac	13 	. 
	cp (hl)			;44ad	be 	. 
	ld a,(de)			;44ae	1a 	. 
	jr nz,l44a5h		;44af	20 f4 	  . 
	jp l4509h		;44b1	c3 09 45 	. . E 
l44b4h:
	cp 026h		;44b4	fe 26 	. & 
	jp nz,l42e9h		;44b6	c2 e9 42 	. . B 
	push hl			;44b9	e5 	. 
	rst 10h			;44ba	d7 	. 
	pop hl			;44bb	e1 	. 
	call sub_4eaah		;44bc	cd aa 4e 	. . N 
	cp 048h		;44bf	fe 48 	. H 
	jr z,l44d0h		;44c1	28 0d 	( . 
	cp 04fh		;44c3	fe 4f 	. O 
	jr z,l44cch		;44c5	28 05 	( . 
	ld a,026h		;44c7	3e 26 	> & 
	jp l42e9h		;44c9	c3 e9 42 	. . B 
l44cch:
	ld a,00bh		;44cc	3e 0b 	> . 
	jr l44d2h		;44ce	18 02 	. . 
l44d0h:
	ld a,00ch		;44d0	3e 0c 	> . 
l44d2h:
	call sub_44e0h		;44d2	cd e0 44 	. . D 
	push de			;44d5	d5 	. 
	push bc			;44d6	c5 	. 
	call l4eb8h		;44d7	cd b8 4e 	. . N 
	pop bc			;44da	c1 	. 
	jp l4449h		;44db	c3 49 44 	. I D 
sub_44deh:
	ld a,03ah		;44de	3e 3a 	> : 
sub_44e0h:
	ld (de),a			;44e0	12 	. 
	inc de			;44e1	13 	. 
	dec bc			;44e2	0b 	. 
	ld a,c			;44e3	79 	y 
	or b			;44e4	b0 	. 
	ret nz			;44e5	c0 	. 
	ld e,019h		;44e6	1e 19 	. . 
	jp l406fh		;44e8	c3 6f 40 	. o @ 
l44ebh:
	call H.NOTR		;44eb	cd 34 ff 	. 4 . 
	pop hl			;44ee	e1 	. 
	dec hl			;44ef	2b 	+ 
	dec a			;44f0	3d 	= 
	ld (DONUM),a		;44f1	32 65 f6 	2 e . 
	call sub_4ea9h		;44f4	cd a9 4e 	. . N 
	jp l43cch		;44f7	c3 cc 43 	. . C 
l44fah:
	ld a,(hl)			;44fa	7e 	~ 
	cp 020h		;44fb	fe 20 	.   
	jr nc,l4509h		;44fd	30 0a 	0 . 
	cp 009h		;44ff	fe 09 	. . 
	jr z,l4509h		;4501	28 06 	( . 
	cp 00ah		;4503	fe 0a 	. . 
	jr z,l4509h		;4505	28 02 	( . 
	ld a,020h		;4507	3e 20 	>   
l4509h:
	push af			;4509	f5 	. 
	ld a,(DONUM)		;450a	3a 65 f6 	: e . 
	inc a			;450d	3c 	< 
	jr z,l4511h		;450e	28 01 	( . 
	dec a			;4510	3d 	= 
l4511h:
	jp l43c8h		;4511	c3 c8 43 	. . C 
sub_4514h:
	dec hl			;4514	2b 	+ 
	ld a,(hl)			;4515	7e 	~ 
	cp 020h		;4516	fe 20 	.   
	jr z,sub_4514h		;4518	28 fa 	( . 
	cp 009h		;451a	fe 09 	. . 
	jr z,sub_4514h		;451c	28 f6 	( . 
	cp 00ah		;451e	fe 0a 	. . 
	jr z,sub_4514h		;4520	28 f2 	( . 
	inc hl			;4522	23 	# 
	ret			;4523	c9 	. 
	ld a,064h		;4524	3e 64 	> d 
	ld (SUBFLG),a		;4526	32 a5 f6 	2 . . 
	call sub_4880h		;4529	cd 80 48 	. . H 
	pop bc			;452c	c1 	. 
	push hl			;452d	e5 	. 
	call sub_485bh		;452e	cd 5b 48 	. [ H 
	ld (ENDFOR),hl		;4531	22 a1 f6 	" . . 
	ld hl,0002h		;4534	21 02 00 	! . . 
	add hl,sp			;4537	39 	9 
l4538h:
	call l3fe6h		;4538	cd e6 3f 	. . ? 
	jr nz,$+25		;453b	20 17 	  . 
	add hl,bc			;453d	09 	. 
	push de			;453e	d5 	. 
	dec hl			;453f	2b 	+ 
	ld d,(hl)			;4540	56 	V 
	dec hl			;4541	2b 	+ 
	ld e,(hl)			;4542	5e 	^ 
	inc hl			;4543	23 	# 
	inc hl			;4544	23 	# 
	push hl			;4545	e5 	. 
	ld hl,(ENDFOR)		;4546	2a a1 f6 	* . . 
	rst 20h			;4549	e7 	. 
	pop hl			;454a	e1 	. 
	pop de			;454b	d1 	. 
	jr nz,l4538h		;454c	20 ea 	  . 
	pop de			;454e	d1 	. 
	ld sp,hl			;454f	f9 	. 
	ld (SAVSTK),hl		;4550	22 b1 f6 	" . . 
	ld c,0d1h		;4553	0e d1 	. . 
	ex de,hl			;4555	eb 	. 
	ld c,00ch		;4556	0e 0c 	. . 
	call sub_625eh		;4558	cd 5e 62 	. ^ b 
	push hl			;455b	e5 	. 
	ld hl,(ENDFOR)		;455c	2a a1 f6 	* . . 
	ex (sp),hl			;455f	e3 	. 
	push hl			;4560	e5 	. 
	ld hl,(CURLIN)		;4561	2a 1c f4 	* . . 
	ex (sp),hl			;4564	e3 	. 
	rst 8			;4565	cf 	. 
	exx			;4566	d9 	. 
	rst 28h			;4567	ef 	. 
	jp z,0406dh		;4568	ca 6d 40 	. m @ 
	push af			;456b	f5 	. 
	call sub_4c64h		;456c	cd 64 4c 	. d L 
	pop af			;456f	f1 	. 
	push hl			;4570	e5 	. 
	jr nc,l458bh		;4571	30 18 	0 . 
	jp p,l45c2h		;4573	f2 c2 45 	. . E 
	call sub_2f8ah		;4576	cd 8a 2f 	. . / 
	ex (sp),hl			;4579	e3 	. 
	ld de,0001h		;457a	11 01 00 	. . . 
	ld a,(hl)			;457d	7e 	~ 
	cp 0dch		;457e	fe dc 	. . 
	call z,sub_520eh		;4580	cc 0e 52 	. . R 
	push de			;4583	d5 	. 
	push hl			;4584	e5 	. 
	ex de,hl			;4585	eb 	. 
	call sub_2eabh		;4586	cd ab 2e 	. . . 
	jr l45e8h		;4589	18 5d 	. ] 
l458bh:
	call FRCDBL		;458b	cd 3a 30 	. : 0 
	pop de			;458e	d1 	. 
	ld hl,0fff8h		;458f	21 f8 ff 	! . . 
	add hl,sp			;4592	39 	9 
	ld sp,hl			;4593	f9 	. 
	push de			;4594	d5 	. 
	call sub_2f10h		;4595	cd 10 2f 	. . / 
	pop hl			;4598	e1 	. 
	ld a,(hl)			;4599	7e 	~ 
	cp 0dch		;459a	fe dc 	. . 
	ld de,l2d1bh		;459c	11 1b 2d 	. . - 
	ld a,001h		;459f	3e 01 	> . 
	jr nz,l45b2h		;45a1	20 0f 	  . 
	rst 10h			;45a3	d7 	. 
	call sub_4c64h		;45a4	cd 64 4c 	. d L 
	push hl			;45a7	e5 	. 
	call FRCDBL		;45a8	cd 3a 30 	. : 0 
	call BAS_SIGN		;45ab	cd 71 2e 	. q . 
	ld de,DAC		;45ae	11 f6 f7 	. . . 
	pop hl			;45b1	e1 	. 
l45b2h:
	ld b,h			;45b2	44 	D 
	ld c,l			;45b3	4d 	M 
	ld hl,0fff8h		;45b4	21 f8 ff 	! . . 
	add hl,sp			;45b7	39 	9 
	ld sp,hl			;45b8	f9 	. 
	push af			;45b9	f5 	. 
	push bc			;45ba	c5 	. 
	call l2ef3h		;45bb	cd f3 2e 	. . . 
	pop hl			;45be	e1 	. 
	pop af			;45bf	f1 	. 
	jr l45efh		;45c0	18 2d 	. - 
l45c2h:
	call sub_2fb2h		;45c2	cd b2 2f 	. . / 
	call sub_2ecch		;45c5	cd cc 2e 	. . . 
	pop hl			;45c8	e1 	. 
	push bc			;45c9	c5 	. 
	push de			;45ca	d5 	. 
	ld bc,l1041h		;45cb	01 41 10 	. A . 
	ld de,0000h		;45ce	11 00 00 	. . . 
	call H.SNGF		;45d1	cd 39 ff 	. 9 . 
	ld a,(hl)			;45d4	7e 	~ 
	cp 0dch		;45d5	fe dc 	. . 
	ld a,001h		;45d7	3e 01 	> . 
	jr nz,l45e9h		;45d9	20 0e 	  . 
	call sub_4c65h		;45db	cd 65 4c 	. e L 
	push hl			;45de	e5 	. 
	call sub_2fb2h		;45df	cd b2 2f 	. . / 
	call sub_2ecch		;45e2	cd cc 2e 	. . . 
	call BAS_SIGN		;45e5	cd 71 2e 	. q . 
l45e8h:
	pop hl			;45e8	e1 	. 
l45e9h:
	push de			;45e9	d5 	. 
	push bc			;45ea	c5 	. 
	push bc			;45eb	c5 	. 
	push bc			;45ec	c5 	. 
	push bc			;45ed	c5 	. 
	push bc			;45ee	c5 	. 
l45efh:
	or a			;45ef	b7 	. 
	jr nz,l45f4h		;45f0	20 02 	  . 
	ld a,002h		;45f2	3e 02 	> . 
l45f4h:
	ld c,a			;45f4	4f 	O 
	rst 28h			;45f5	ef 	. 
	ld b,a			;45f6	47 	G 
	push bc			;45f7	c5 	. 
	push hl			;45f8	e5 	. 
	ld hl,(TEMP)		;45f9	2a a7 f6 	* . . 
	ex (sp),hl			;45fc	e3 	. 
l45fdh:
	ld b,082h		;45fd	06 82 	. . 
	push bc			;45ff	c5 	. 
	inc sp			;4600	33 	3 
l4601h:
	call H.NEWS		;4601	cd 3e ff 	. > . 
	ld (SAVSTK),sp		;4604	ed 73 b1 f6 	. s . . 
	call ISCNTC		;4608	cd ba 00 	. . . 
	ld a,(ONGSBF)		;460b	3a d8 fb 	: . . 
	or a			;460e	b7 	. 
	call nz,sub_6389h		;460f	c4 89 63 	. . c 
l4612h:
	ei			;4612	fb 	. 
	ld (SAVTXT),hl		;4613	22 af f6 	" . . 
	ld a,(hl)			;4616	7e 	~ 
	cp 03ah		;4617	fe 3a 	. : 
	jr z,l4640h		;4619	28 25 	( % 
	or a			;461b	b7 	. 
	jp nz,l4055h		;461c	c2 55 40 	. U @ 
	inc hl			;461f	23 	# 
l4620h:
	ld a,(hl)			;4620	7e 	~ 
	inc hl			;4621	23 	# 
	or (hl)			;4622	b6 	. 
	jp z,l4039h		;4623	ca 39 40 	. 9 @ 
	inc hl			;4626	23 	# 
	ld e,(hl)			;4627	5e 	^ 
	inc hl			;4628	23 	# 
	ld d,(hl)			;4629	56 	V 
	ex de,hl			;462a	eb 	. 
	ld (CURLIN),hl		;462b	22 1c f4 	" . . 
	ld a,(TRCFLG)		;462e	3a c4 f7 	: . . 
	or a			;4631	b7 	. 
	jr z,l463fh		;4632	28 0b 	( . 
	push de			;4634	d5 	. 
	ld a,05bh		;4635	3e 5b 	> [ 
	rst 18h			;4637	df 	. 
	call sub_3412h		;4638	cd 12 34 	. . 4 
	ld a,05dh		;463b	3e 5d 	> ] 
	rst 18h			;463d	df 	. 
	pop de			;463e	d1 	. 
l463fh:
	ex de,hl			;463f	eb 	. 
l4640h:
	rst 10h			;4640	d7 	. 
	ld de,l4601h		;4641	11 01 46 	. . F 
	push de			;4644	d5 	. 
	ret z			;4645	c8 	. 
l4646h:
	call H.GONE		;4646	cd 43 ff 	. C . 
	cp 05fh		;4649	fe 5f 	. _ 
	jp z,l55a7h		;464b	ca a7 55 	. . U 
	sub 081h		;464e	d6 81 	. . 
	jp c,sub_4880h		;4650	da 80 48 	. . H 
	cp 058h		;4653	fe 58 	. X 
	jp nc,l51adh		;4655	d2 ad 51 	. . Q 
	rlca			;4658	07 	. 
	ld c,a			;4659	4f 	O 
	ld b,000h		;465a	06 00 	. . 
	ex de,hl			;465c	eb 	. 
	ld hl,BASICDATA		;465d	21 2e 39 	! . 9 
	add hl,bc			;4660	09 	. 
	ld c,(hl)			;4661	4e 	N 
	inc hl			;4662	23 	# 
	ld b,(hl)			;4663	46 	F 
	push bc			;4664	c5 	. 
	ex de,hl			;4665	eb 	. 
l4666h:
	call H.CHRG		;4666	cd 48 ff 	. H . 
	inc hl			;4669	23 	# 
sub_466ah:
	ld a,(hl)			;466a	7e 	~ 
	cp 03ah		;466b	fe 3a 	. : 
	ret nc			;466d	d0 	. 
	cp 020h		;466e	fe 20 	.   
	jr z,l4666h		;4670	28 f4 	( . 
	jr nc,l46e0h		;4672	30 6c 	0 l 
	or a			;4674	b7 	. 
	ret z			;4675	c8 	. 
	cp 00bh		;4676	fe 0b 	. . 
	jr c,l46dbh		;4678	38 61 	8 a 
	cp 01eh		;467a	fe 1e 	. . 
	jr nz,l4683h		;467c	20 05 	  . 
	ld a,(CONSAV)		;467e	3a 68 f6 	: h . 
	or a			;4681	b7 	. 
	ret			;4682	c9 	. 
l4683h:
	cp 010h		;4683	fe 10 	. . 
	jr z,l46bbh		;4685	28 34 	( 4 
	push af			;4687	f5 	. 
	inc hl			;4688	23 	# 
	ld (CONSAV),a		;4689	32 68 f6 	2 h . 
	sub 01ch		;468c	d6 1c 	. . 
	jr nc,l46c0h		;468e	30 30 	0 0 
	sub 0f5h		;4690	d6 f5 	. . 
	jr nc,l469ah		;4692	30 06 	0 . 
	cp 0feh		;4694	fe fe 	. . 
	jr nz,l46aeh		;4696	20 16 	  . 
	ld a,(hl)			;4698	7e 	~ 
	inc hl			;4699	23 	# 
l469ah:
	ld (CONTXT),hl		;469a	22 66 f6 	" f . 
	ld h,000h		;469d	26 00 	& . 
l469fh:
	ld l,a			;469f	6f 	o 
	ld (CONLO),hl		;46a0	22 6a f6 	" j . 
	ld a,002h		;46a3	3e 02 	> . 
	ld (CONTYP),a		;46a5	32 69 f6 	2 i . 
	ld hl,l46e6h		;46a8	21 e6 46 	! . F 
	pop af			;46ab	f1 	. 
	or a			;46ac	b7 	. 
	ret			;46ad	c9 	. 
l46aeh:
	ld a,(hl)			;46ae	7e 	~ 
	inc hl			;46af	23 	# 
	inc hl			;46b0	23 	# 
	ld (CONTXT),hl		;46b1	22 66 f6 	" f . 
	dec hl			;46b4	2b 	+ 
	ld h,(hl)			;46b5	66 	f 
	jr l469fh		;46b6	18 e7 	. . 
l46b8h:
	call sub_46e8h		;46b8	cd e8 46 	. . F 
l46bbh:
	ld hl,(CONTXT)		;46bb	2a 66 f6 	* f . 
	jr sub_466ah		;46be	18 aa 	. . 
l46c0h:
	inc a			;46c0	3c 	< 
	rlca			;46c1	07 	. 
	ld (CONTYP),a		;46c2	32 69 f6 	2 i . 
	push de			;46c5	d5 	. 
	push bc			;46c6	c5 	. 
	ld de,CONLO		;46c7	11 6a f6 	. j . 
	ex de,hl			;46ca	eb 	. 
	ld b,a			;46cb	47 	G 
	call sub_2ef7h		;46cc	cd f7 2e 	. . . 
	ex de,hl			;46cf	eb 	. 
	pop bc			;46d0	c1 	. 
	pop de			;46d1	d1 	. 
	ld (CONTXT),hl		;46d2	22 66 f6 	" f . 
	pop af			;46d5	f1 	. 
	ld hl,l46e6h		;46d6	21 e6 46 	! . F 
	or a			;46d9	b7 	. 
	ret			;46da	c9 	. 
l46dbh:
	cp 009h		;46db	fe 09 	. . 
	jp nc,l4666h		;46dd	d2 66 46 	. f F 
l46e0h:
	cp 030h		;46e0	fe 30 	. 0 
	ccf			;46e2	3f 	? 
	inc a			;46e3	3c 	< 
	dec a			;46e4	3d 	= 
	ret			;46e5	c9 	. 
l46e6h:
	ld e,010h		;46e6	1e 10 	. . 
sub_46e8h:
	ld a,(CONSAV)		;46e8	3a 68 f6 	: h . 
	cp 00fh		;46eb	fe 0f 	. . 
	jr nc,l4702h		;46ed	30 13 	0 . 
	cp 00dh		;46ef	fe 0d 	. . 
	jr c,l4702h		;46f1	38 0f 	8 . 
	ld hl,(CONLO)		;46f3	2a 6a f6 	* j . 
	jr nz,l46ffh		;46f6	20 07 	  . 
	inc hl			;46f8	23 	# 
	inc hl			;46f9	23 	# 
	inc hl			;46fa	23 	# 
	ld e,(hl)			;46fb	5e 	^ 
	inc hl			;46fc	23 	# 
	ld d,(hl)			;46fd	56 	V 
	ex de,hl			;46fe	eb 	. 
l46ffh:
	jp l3236h		;46ff	c3 36 32 	. 6 2 
l4702h:
	ld a,(CONTYP)		;4702	3a 69 f6 	: i . 
	ld (VALTYP),a		;4705	32 63 f6 	2 c . 
	cp 002h		;4708	fe 02 	. . 
	jr nz,l4712h		;470a	20 06 	  . 
	ld hl,(CONLO)		;470c	2a 6a f6 	* j . 
	ld (0f7f8h),hl		;470f	22 f8 f7 	" . . 
l4712h:
	ld hl,CONLO		;4712	21 6a f6 	! j . 
	jp l2f08h		;4715	c3 08 2f 	. . / 
	ld e,003h		;4718	1e 03 	. . 
	ld bc,0021eh		;471a	01 1e 02 	. . . 
	ld bc,0041eh		;471d	01 1e 04 	. . . 
	ld bc,l081eh		;4720	01 1e 08 	. . . 
l4723h:
	call sub_64a7h		;4723	cd a7 64 	. . d 
	ld bc,l4055h		;4726	01 55 40 	. U @ 
	push bc			;4729	c5 	. 
	ret c			;472a	d8 	. 
	sub 041h		;472b	d6 41 	. A 
	ld c,a			;472d	4f 	O 
	ld b,a			;472e	47 	G 
	rst 10h			;472f	d7 	. 
	cp 0f2h		;4730	fe f2 	. . 
	jr nz,l473dh		;4732	20 09 	  . 
	rst 10h			;4734	d7 	. 
	call sub_64a7h		;4735	cd a7 64 	. . d 
	ret c			;4738	d8 	. 
	sub 041h		;4739	d6 41 	. A 
	ld b,a			;473b	47 	G 
	rst 10h			;473c	d7 	. 
l473dh:
	ld a,b			;473d	78 	x 
	sub c			;473e	91 	. 
	ret c			;473f	d8 	. 
	inc a			;4740	3c 	< 
	ex (sp),hl			;4741	e3 	. 
	ld hl,DEFTBL		;4742	21 ca f6 	! . . 
	ld b,000h		;4745	06 00 	. . 
	add hl,bc			;4747	09 	. 
l4748h:
	ld (hl),e			;4748	73 	s 
	inc hl			;4749	23 	# 
	dec a			;474a	3d 	= 
	jr nz,l4748h		;474b	20 fb 	  . 
	pop hl			;474d	e1 	. 
	ld a,(hl)			;474e	7e 	~ 
	cp 02ch		;474f	fe 2c 	. , 
	ret nz			;4751	c0 	. 
	rst 10h			;4752	d7 	. 
	jr l4723h		;4753	18 ce 	. . 
sub_4755h:
	rst 10h			;4755	d7 	. 
sub_4756h:
	call sub_520fh		;4756	cd 0f 52 	. . R 
	ret p			;4759	f0 	. 
l475ah:
	ld e,005h		;475a	1e 05 	. . 
	jp l406fh		;475c	c3 6f 40 	. o @ 
sub_475fh:
	ld a,(hl)			;475f	7e 	~ 
	cp 02eh		;4760	fe 2e 	. . 
	ld de,(DOT)		;4762	ed 5b b5 f6 	. [ . . 
	jp z,l4666h		;4766	ca 66 46 	. f F 
sub_4769h:
	dec hl			;4769	2b 	+ 
sub_476ah:
	rst 10h			;476a	d7 	. 
	cp 00eh		;476b	fe 0e 	. . 
	jr z,l4771h		;476d	28 02 	( . 
	cp 00dh		;476f	fe 0d 	. . 
l4771h:
	ld de,(CONLO)		;4771	ed 5b 6a f6 	. [ j . 
	jp z,l4666h		;4775	ca 66 46 	. f F 
	xor a			;4778	af 	. 
	ld (CONSAV),a		;4779	32 68 f6 	2 h . 
	ld de,0000h		;477c	11 00 00 	. . . 
	dec hl			;477f	2b 	+ 
l4780h:
	rst 10h			;4780	d7 	. 
	ret nc			;4781	d0 	. 
	push hl			;4782	e5 	. 
	push af			;4783	f5 	. 
	ld hl,l1998h		;4784	21 98 19 	! . . 
	rst 20h			;4787	e7 	. 
	jr c,l479bh		;4788	38 11 	8 . 
	ld h,d			;478a	62 	b 
	ld l,e			;478b	6b 	k 
	add hl,de			;478c	19 	. 
	add hl,hl			;478d	29 	) 
	add hl,de			;478e	19 	. 
	add hl,hl			;478f	29 	) 
	pop af			;4790	f1 	. 
	sub 030h		;4791	d6 30 	. 0 
	ld e,a			;4793	5f 	_ 
	ld d,000h		;4794	16 00 	. . 
	add hl,de			;4796	19 	. 
	ex de,hl			;4797	eb 	. 
	pop hl			;4798	e1 	. 
	jr l4780h		;4799	18 e5 	. . 
l479bh:
	pop af			;479b	f1 	. 
	pop hl			;479c	e1 	. 
	ret			;479d	c9 	. 
	jp z,sub_629ah		;479e	ca 9a 62 	. . b 
	cp 00eh		;47a1	fe 0e 	. . 
	jr z,l47aah		;47a3	28 05 	( . 
	cp 00dh		;47a5	fe 0d 	. . 
	jp nz,l6b5bh		;47a7	c2 5b 6b 	. [ k 
l47aah:
	call sub_62a1h		;47aa	cd a1 62 	. . b 
	ld bc,l4601h		;47ad	01 01 46 	. . F 
	jr l47e7h		;47b0	18 35 	. 5 
	ld c,003h		;47b2	0e 03 	. . 
	call sub_625eh		;47b4	cd 5e 62 	. ^ b 
	call sub_4769h		;47b7	cd 69 47 	. i G 
	pop bc			;47ba	c1 	. 
	push hl			;47bb	e5 	. 
	push hl			;47bc	e5 	. 
	ld hl,(CURLIN)		;47bd	2a 1c f4 	* . . 
	ex (sp),hl			;47c0	e3 	. 
	ld bc,0000h		;47c1	01 00 00 	. . . 
	push bc			;47c4	c5 	. 
	ld bc,l4601h		;47c5	01 01 46 	. . F 
	ld a,08dh		;47c8	3e 8d 	> . 
	push af			;47ca	f5 	. 
	inc sp			;47cb	33 	3 
	push bc			;47cc	c5 	. 
	jr l47ebh		;47cd	18 1c 	. . 
l47cfh:
	push hl			;47cf	e5 	. 
	push hl			;47d0	e5 	. 
	ld hl,(CURLIN)		;47d1	2a 1c f4 	* . . 
	ex (sp),hl			;47d4	e3 	. 
	push bc			;47d5	c5 	. 
	ld a,08dh		;47d6	3e 8d 	> . 
	push af			;47d8	f5 	. 
	inc sp			;47d9	33 	3 
	ex de,hl			;47da	eb 	. 
	dec hl			;47db	2b 	+ 
	ld (SAVTXT),hl		;47dc	22 af f6 	" . . 
	inc hl			;47df	23 	# 
	ld (SAVSTK),sp		;47e0	ed 73 b1 f6 	. s . . 
	jp l4620h		;47e4	c3 20 46 	.   F 
l47e7h:
	push bc			;47e7	c5 	. 
l47e8h:
	call sub_4769h		;47e8	cd 69 47 	. i G 
l47ebh:
	ld a,(CONSAV)		;47eb	3a 68 f6 	: h . 
	cp 00dh		;47ee	fe 0d 	. . 
	ex de,hl			;47f0	eb 	. 
	ret z			;47f1	c8 	. 
	cp 00eh		;47f2	fe 0e 	. . 
	jp nz,l4055h		;47f4	c2 55 40 	. U @ 
	ex de,hl			;47f7	eb 	. 
	push hl			;47f8	e5 	. 
	ld hl,(CONTXT)		;47f9	2a 66 f6 	* f . 
	ex (sp),hl			;47fc	e3 	. 
	call sub_485dh		;47fd	cd 5d 48 	. ] H 
	inc hl			;4800	23 	# 
	push hl			;4801	e5 	. 
	ld hl,(CURLIN)		;4802	2a 1c f4 	* . . 
	rst 20h			;4805	e7 	. 
	pop hl			;4806	e1 	. 
	call c,l4298h		;4807	dc 98 42 	. . B 
	call nc,sub_4295h		;480a	d4 95 42 	. . B 
	jr nc,l481ch		;480d	30 0d 	0 . 
	dec bc			;480f	0b 	. 
	ld a,00dh		;4810	3e 0d 	> . 
	ld (PTRFLG),a		;4812	32 a9 f6 	2 . . 
	pop hl			;4815	e1 	. 
	call sub_5583h		;4816	cd 83 55 	. . U 
	ld h,b			;4819	60 	` 
	ld l,c			;481a	69 	i 
	ret			;481b	c9 	. 
l481ch:
	ld e,008h		;481c	1e 08 	. . 
	jp l406fh		;481e	c3 6f 40 	. o @ 
	call H.RETU		;4821	cd 4d ff 	. M . 
	ld (TEMP),hl		;4824	22 a7 f6 	" . . 
	ld d,0ffh		;4827	16 ff 	. . 
	call CHKFOR		;4829	cd e2 3f 	. . ? 
	cp 08dh		;482c	fe 8d 	. . 
	jr z,l4831h		;482e	28 01 	( . 
	dec hl			;4830	2b 	+ 
l4831h:
	ld sp,hl			;4831	f9 	. 
	ld (SAVSTK),hl		;4832	22 b1 f6 	" . . 
	ld e,003h		;4835	1e 03 	. . 
	jp nz,l406fh		;4837	c2 6f 40 	. o @ 
	pop hl			;483a	e1 	. 
	ld a,h			;483b	7c 	| 
	or l			;483c	b5 	. 
	jr z,l4845h		;483d	28 06 	( . 
	ld a,(hl)			;483f	7e 	~ 
	and 001h		;4840	e6 01 	. . 
	call nz,sub_633eh		;4842	c4 3e 63 	. > c 
l4845h:
	pop bc			;4845	c1 	. 
	ld hl,l4601h		;4846	21 01 46 	! . F 
	ex (sp),hl			;4849	e3 	. 
	ex de,hl			;484a	eb 	. 
	ld hl,(TEMP)		;484b	2a a7 f6 	* . . 
	dec hl			;484e	2b 	+ 
	rst 10h			;484f	d7 	. 
	jp nz,l47e8h		;4850	c2 e8 47 	. . G 
	ld h,b			;4853	60 	` 
	ld l,c			;4854	69 	i 
	ld (CURLIN),hl		;4855	22 1c f4 	" . . 
	ex de,hl			;4858	eb 	. 
	ld a,0e1h		;4859	3e e1 	> . 
sub_485bh:
        defb 001h               ;485b   01      .
        defb 03ah               ;485c   3a      :
sub_485dh:
        ld c,000h
        ld b,000h       
l4861h:
	ld a,c			;4861	79 	y 
	ld c,b			;4862	48 	H 
	ld b,a			;4863	47 	G 
l4864h:
	dec hl			;4864	2b 	+ 
l4865h:
	rst 10h			;4865	d7 	. 
	or a			;4866	b7 	. 
	ret z			;4867	c8 	. 
	cp b			;4868	b8 	. 
	ret z			;4869	c8 	. 
	inc hl			;486a	23 	# 
	cp 022h		;486b	fe 22 	. " 
	jr z,l4861h		;486d	28 f2 	( . 
	inc a			;486f	3c 	< 
	jr z,l4865h		;4870	28 f3 	( . 
	sub 08ch		;4872	d6 8c 	. . 
	jr nz,l4864h		;4874	20 ee 	  . 
	cp b			;4876	b8 	. 
	adc a,d			;4877	8a 	. 
	ld d,a			;4878	57 	W 
	jr l4864h		;4879	18 e9 	. . 
l487bh:
	pop af			;487b	f1 	. 
	add a,003h		;487c	c6 03 	. . 
	jr l4892h		;487e	18 12 	. . 
sub_4880h:
	call 05ea4h		;4880	cd a4 5e 	. . ^ 
	rst 8			;4883	cf 	. 
	rst 28h			;4884	ef 	. 
	ld (TEMP),de		;4885	ed 53 a7 f6 	. S . . 
	push de			;4889	d5 	. 
	ld a,(VALTYP)		;488a	3a 63 f6 	: c . 
	push af			;488d	f5 	. 
	call sub_4c64h		;488e	cd 64 4c 	. d L 
	pop af			;4891	f1 	. 
l4892h:
	ex (sp),hl			;4892	e3 	. 
l4893h:
	ld b,a			;4893	47 	G 
	ld a,(VALTYP)		;4894	3a 63 f6 	: c . 
	cp b			;4897	b8 	. 
	ld a,b			;4898	78 	x 
	jr z,l48a1h		;4899	28 06 	( . 
	call sub_517ah		;489b	cd 7a 51 	. z Q 
l489eh:
	ld a,(VALTYP)		;489e	3a 63 f6 	: c . 
l48a1h:
	ld de,DAC		;48a1	11 f6 f7 	. . . 
	cp 002h		;48a4	fe 02 	. . 
	jr nz,l48abh		;48a6	20 03 	  . 
	ld de,0f7f8h		;48a8	11 f8 f7 	. . . 
l48abh:
	push hl			;48ab	e5 	. 
	cp 003h		;48ac	fe 03 	. . 
	jr nz,l48deh		;48ae	20 2e 	  . 
	ld hl,(0f7f8h)		;48b0	2a f8 f7 	* . . 
	push hl			;48b3	e5 	. 
	inc hl			;48b4	23 	# 
	ld e,(hl)			;48b5	5e 	^ 
	inc hl			;48b6	23 	# 
	ld d,(hl)			;48b7	56 	V 
	ld hl,KBFMIN		;48b8	21 1e f4 	! . . 
	rst 20h			;48bb	e7 	. 
	jr c,$+22		;48bc	38 14 	8 . 
	ld hl,(STREND)		;48be	2a c6 f6 	* . . 
	rst 20h			;48c1	e7 	. 
	pop de			;48c2	d1 	. 
	jr nc,l48dah		;48c3	30 15 	0 . 
	ld hl,0f697h		;48c5	21 97 f6 	! . . 
	rst 20h			;48c8	e7 	. 
	jr c,l48d1h		;48c9	38 06 	8 . 
	ld hl,0f679h		;48cb	21 79 f6 	! y . 
	rst 20h			;48ce	e7 	. 
	jr c,l48dah		;48cf	38 09 	8 . 
l48d1h:
	ld a,0d1h		;48d1	3e d1 	> . 
	call sub_67eeh		;48d3	cd ee 67 	. . g 
	ex de,hl			;48d6	eb 	. 
	call sub_6611h		;48d7	cd 11 66 	. . f 
l48dah:
	call sub_67eeh		;48da	cd ee 67 	. . g 
	ex (sp),hl			;48dd	e3 	. 
l48deh:
	call l2ef3h		;48de	cd f3 2e 	. . . 
	pop de			;48e1	d1 	. 
	pop hl			;48e2	e1 	. 
	ret			;48e3	c9 	. 
	cp 0a6h		;48e4	fe a6 	. . 
	jr nz,l490dh		;48e6	20 25 	  % 
	rst 10h			;48e8	d7 	. 
	rst 8			;48e9	cf 	. 
	adc a,c			;48ea	89 	. 
	call sub_4769h		;48eb	cd 69 47 	. i G 
	ld a,d			;48ee	7a 	z 
	or e			;48ef	b3 	. 
	jr z,l48fbh		;48f0	28 09 	( . 
	call sub_4293h		;48f2	cd 93 42 	. . B 
	ld d,b			;48f5	50 	P 
	ld e,c			;48f6	59 	Y 
	pop hl			;48f7	e1 	. 
	jp nc,l481ch		;48f8	d2 1c 48 	. . H 
l48fbh:
	ld (ONELIN),de		;48fb	ed 53 b9 f6 	. S . . 
	ret c			;48ff	d8 	. 
	ld a,(ONEFLG)		;4900	3a bb f6 	: . . 
	or a			;4903	b7 	. 
	ld a,e			;4904	7b 	{ 
	ret z			;4905	c8 	. 
	ld a,(ERRFLG)		;4906	3a 14 f4 	: . . 
	ld e,a			;4909	5f 	_ 
	jp l4096h		;490a	c3 96 40 	. . @ 
l490dh:
	call sub_7810h		;490d	cd 10 78 	. . x 
	jr c,l4943h		;4910	38 31 	8 1 
	push bc			;4912	c5 	. 
	rst 10h			;4913	d7 	. 
	rst 8			;4914	cf 	. 
	adc a,l			;4915	8d 	. 
	xor a			;4916	af 	. 
l4917h:
	pop bc			;4917	c1 	. 
	push bc			;4918	c5 	. 
	cp c			;4919	b9 	. 
	jp nc,l4055h		;491a	d2 55 40 	. U @ 
	push af			;491d	f5 	. 
	call sub_4769h		;491e	cd 69 47 	. i G 
	ld a,d			;4921	7a 	z 
	or e			;4922	b3 	. 
	jr z,l492eh		;4923	28 09 	( . 
	call sub_4293h		;4925	cd 93 42 	. . B 
	ld d,b			;4928	50 	P 
	ld e,c			;4929	59 	Y 
	pop hl			;492a	e1 	. 
	jp nc,l481ch		;492b	d2 1c 48 	. . H 
l492eh:
	pop af			;492e	f1 	. 
	pop bc			;492f	c1 	. 
	push af			;4930	f5 	. 
	add a,b			;4931	80 	. 
	push bc			;4932	c5 	. 
	call sub_785ch		;4933	cd 5c 78 	. \ x 
	dec hl			;4936	2b 	+ 
	rst 10h			;4937	d7 	. 
	pop bc			;4938	c1 	. 
	pop de			;4939	d1 	. 
	ret z			;493a	c8 	. 
	push bc			;493b	c5 	. 
	push de			;493c	d5 	. 
	rst 8			;493d	cf 	. 
	inc l			;493e	2c 	, 
	pop af			;493f	f1 	. 
	inc a			;4940	3c 	< 
	jr l4917h		;4941	18 d4 	. . 
l4943h:
	call sub_521ch		;4943	cd 1c 52 	. . R 
	ld a,(hl)			;4946	7e 	~ 
	ld b,a			;4947	47 	G 
	cp 08dh		;4948	fe 8d 	. . 
	jr z,l494fh		;494a	28 03 	( . 
	rst 8			;494c	cf 	. 
	adc a,c			;494d	89 	. 
	dec hl			;494e	2b 	+ 
l494fh:
	ld c,e			;494f	4b 	K 
l4950h:
	dec c			;4950	0d 	. 
	ld a,b			;4951	78 	x 
	jp z,l4646h		;4952	ca 46 46 	. F F 
	call sub_476ah		;4955	cd 6a 47 	. j G 
	cp 02ch		;4958	fe 2c 	. , 
	ret nz			;495a	c0 	. 
	jr l4950h		;495b	18 f3 	. . 
	ld a,(ONEFLG)		;495d	3a bb f6 	: . . 
	or a			;4960	b7 	. 
	jr nz,l496ch		;4961	20 09 	  . 
	ld (ONELIN),a		;4963	32 b9 f6 	2 . . 
	ld (0f6bah),a		;4966	32 ba f6 	2 . . 
	jp 04064h		;4969	c3 64 40 	. d @ 
l496ch:
	inc a			;496c	3c 	< 
	ld (ERRFLG),a		;496d	32 14 f4 	2 . . 
	ld a,(hl)			;4970	7e 	~ 
	cp 083h		;4971	fe 83 	. . 
	jr z,l4985h		;4973	28 10 	( . 
	call sub_4769h		;4975	cd 69 47 	. i G 
	ret nz			;4978	c0 	. 
	ld a,d			;4979	7a 	z 
	or e			;497a	b3 	. 
	jr z,l4989h		;497b	28 0c 	( . 
	call l47ebh		;497d	cd eb 47 	. . G 
	xor a			;4980	af 	. 
	ld (ONEFLG),a		;4981	32 bb f6 	2 . . 
	ret			;4984	c9 	. 
l4985h:
	rst 10h			;4985	d7 	. 
	ret nz			;4986	c0 	. 
	jr l498eh		;4987	18 05 	. . 
l4989h:
	xor a			;4989	af 	. 
	ld (ONEFLG),a		;498a	32 bb f6 	2 . . 
	inc a			;498d	3c 	< 
l498eh:
	ld hl,(ERRTXT)		;498e	2a b7 f6 	* . . 
	ex de,hl			;4991	eb 	. 
	ld hl,(ERRLIN)		;4992	2a b3 f6 	* . . 
	ld (CURLIN),hl		;4995	22 1c f4 	" . . 
	ex de,hl			;4998	eb 	. 
	ret nz			;4999	c0 	. 
	ld a,(hl)			;499a	7e 	~ 
	or a			;499b	b7 	. 
	jr nz,l49a2h		;499c	20 04 	  . 
	inc hl			;499e	23 	# 
	inc hl			;499f	23 	# 
	inc hl			;49a0	23 	# 
	inc hl			;49a1	23 	# 
l49a2h:
	inc hl			;49a2	23 	# 
	xor a			;49a3	af 	. 
	ld (ONEFLG),a		;49a4	32 bb f6 	2 . . 
	jp sub_485bh		;49a7	c3 5b 48 	. [ H 
	call sub_521ch		;49aa	cd 1c 52 	. . R 
	ret nz			;49ad	c0 	. 
	or a			;49ae	b7 	. 
	jp z,l475ah		;49af	ca 5a 47 	. Z G 
	jp l406fh		;49b2	c3 6f 40 	. o @ 
	ld de,000ah		;49b5	11 0a 00 	. . . 
	push de			;49b8	d5 	. 
	jr z,l49d1h		;49b9	28 16 	( . 
	call sub_475fh		;49bb	cd 5f 47 	. _ G 
	ex de,hl			;49be	eb 	. 
	ex (sp),hl			;49bf	e3 	. 
	jr z,l49d2h		;49c0	28 10 	( . 
	ex de,hl			;49c2	eb 	. 
	rst 8			;49c3	cf 	. 
	inc l			;49c4	2c 	, 
	ld de,(AUTINC)		;49c5	ed 5b ad f6 	. [ . . 
	jr z,l49d1h		;49c9	28 06 	( . 
	call sub_4769h		;49cb	cd 69 47 	. i G 
	jp nz,l4055h		;49ce	c2 55 40 	. U @ 
l49d1h:
	ex de,hl			;49d1	eb 	. 
l49d2h:
	ld a,h			;49d2	7c 	| 
	or l			;49d3	b5 	. 
	jp z,l475ah		;49d4	ca 5a 47 	. Z G 
	ld (AUTINC),hl		;49d7	22 ad f6 	" . . 
	ld (AUTFLG),a		;49da	32 aa f6 	2 . . 
	pop hl			;49dd	e1 	. 
	ld (AUTLIN),hl		;49de	22 ab f6 	" . . 
	pop bc			;49e1	c1 	. 
	jp l4134h		;49e2	c3 34 41 	. 4 A 
	call sub_4c64h		;49e5	cd 64 4c 	. d L 
	ld a,(hl)			;49e8	7e 	~ 
	cp 02ch		;49e9	fe 2c 	. , 
	call z,l4666h		;49eb	cc 66 46 	. f F 
	cp 089h		;49ee	fe 89 	. . 
	jr z,$+5		;49f0	28 03 	( . 
	rst 8			;49f2	cf 	. 
	jp c,0e52bh		;49f3	da 2b e5 	. + . 
	call sub_2ea1h		;49f6	cd a1 2e 	. . . 
	pop hl			;49f9	e1 	. 
	jr z,l4a0ch		;49fa	28 10 	( . 
l49fch:
	rst 10h			;49fc	d7 	. 
	ret z			;49fd	c8 	. 
	cp 00eh		;49fe	fe 0e 	. . 
	jp z,l47e8h		;4a00	ca e8 47 	. . G 
	cp 00dh		;4a03	fe 0d 	. . 
	jp nz,l4646h		;4a05	c2 46 46 	. F F 
	ld hl,(CONLO)		;4a08	2a 6a f6 	* j . 
	ret			;4a0b	c9 	. 
l4a0ch:
	ld d,001h		;4a0c	16 01 	. . 
l4a0eh:
	call sub_485bh		;4a0e	cd 5b 48 	. [ H 
	or a			;4a11	b7 	. 
	ret z			;4a12	c8 	. 
	rst 10h			;4a13	d7 	. 
	cp 0a1h		;4a14	fe a1 	. . 
	jr nz,l4a0eh		;4a16	20 f6 	  . 
	dec d			;4a18	15 	. 
	jr nz,l4a0eh		;4a19	20 f3 	  . 
	jr l49fch		;4a1b	18 df 	. . 
	ld a,001h		;4a1d	3e 01 	> . 
	ld (PRTFLG),a		;4a1f	32 16 f4 	2 . . 
	jr l4a29h		;4a22	18 05 	. . 
	ld c,002h		;4a24	0e 02 	. . 
	call sub_6d57h		;4a26	cd 57 6d 	. W m 
l4a29h:
	dec hl			;4a29	2b 	+ 
	rst 10h			;4a2a	d7 	. 
	call z,sub_7328h		;4a2b	cc 28 73 	. ( s 
l4a2eh:
	jp z,l4affh		;4a2e	ca ff 4a 	. . J 
	cp 0e4h		;4a31	fe e4 	. . 
	jp z,l60b1h		;4a33	ca b1 60 	. . ` 
	cp 0dbh		;4a36	fe db 	. . 
	jp z,l4ac6h		;4a38	ca c6 4a 	. . J 
	cp 0dfh		;4a3b	fe df 	. . 
	jp z,l4ac6h		;4a3d	ca c6 4a 	. . J 
	push hl			;4a40	e5 	. 
	cp 02ch		;4a41	fe 2c 	. , 
	jr z,l4a94h		;4a43	28 4f 	( O 
	cp 03bh		;4a45	fe 3b 	. ; 
	jp z,l4afah		;4a47	ca fa 4a 	. . J 
	pop bc			;4a4a	c1 	. 
	call sub_4c64h		;4a4b	cd 64 4c 	. d L 
	push hl			;4a4e	e5 	. 
	rst 28h			;4a4f	ef 	. 
	jr z,l4a8dh		;4a50	28 3b 	( ; 
	call sub_3425h		;4a52	cd 25 34 	. % 4 
	call sub_6635h		;4a55	cd 35 66 	. 5 f 
	ld (hl),020h		;4a58	36 20 	6   
	ld hl,(0f7f8h)		;4a5a	2a f8 f7 	* . . 
	inc (hl)			;4a5d	34 	4 
	call H.PRTF		;4a5e	cd 52 ff 	. R . 
	call ISFLIO		;4a61	cd 4a 01 	. J . 
	jr nz,l4a89h		;4a64	20 23 	  # 
	ld hl,(0f7f8h)		;4a66	2a f8 f7 	* . . 
	ld a,(PRTFLG)		;4a69	3a 16 f4 	: . . 
	or a			;4a6c	b7 	. 
	jr z,l4a77h		;4a6d	28 08 	( . 
	ld a,(LPTPOS)		;4a6f	3a 15 f4 	: . . 
	add a,(hl)			;4a72	86 	. 
	cp 0ffh		;4a73	fe ff 	. . 
	jr l4a81h		;4a75	18 0a 	. . 
l4a77h:
	ld a,(LINLEN)		;4a77	3a b0 f3 	: . . 
	ld b,a			;4a7a	47 	G 
	ld a,(TTYPOS)		;4a7b	3a 61 f6 	: a . 
	add a,(hl)			;4a7e	86 	. 
	dec a			;4a7f	3d 	= 
	cp b			;4a80	b8 	. 
l4a81h:
	jr c,l4a89h		;4a81	38 06 	8 . 
	call z,sub_7331h		;4a83	cc 31 73 	. 1 s 
	call nz,sub_7328h		;4a86	c4 28 73 	. ( s 
l4a89h:
	call sub_667bh		;4a89	cd 7b 66 	. { f 
	or a			;4a8c	b7 	. 
l4a8dh:
	call z,sub_667bh		;4a8d	cc 7b 66 	. { f 
	pop hl			;4a90	e1 	. 
	jp l4a29h		;4a91	c3 29 4a 	. ) J 
l4a94h:
	call H.COMP		;4a94	cd 57 ff 	. W . 
	ld bc,0008h		;4a97	01 08 00 	. . . 
	ld hl,(PTRFIL)		;4a9a	2a 64 f8 	* d . 
	add hl,bc			;4a9d	09 	. 
	call ISFLIO		;4a9e	cd 4a 01 	. J . 
	ld a,(hl)			;4aa1	7e 	~ 
	jr nz,l4abfh		;4aa2	20 1b 	  . 
	ld a,(PRTFLG)		;4aa4	3a 16 f4 	: . . 
	or a			;4aa7	b7 	. 
	jr z,l4ab1h		;4aa8	28 07 	( . 
	ld a,(LPTPOS)		;4aaa	3a 15 f4 	: . . 
	cp 0eeh		;4aad	fe ee 	. . 
	jr l4ab9h		;4aaf	18 08 	. . 
l4ab1h:
	ld a,(0f3b2h)		;4ab1	3a b2 f3 	: . . 
	ld b,a			;4ab4	47 	G 
	ld a,(TTYPOS)		;4ab5	3a 61 f6 	: a . 
	cp b			;4ab8	b8 	. 
l4ab9h:
	call nc,sub_7328h		;4ab9	d4 28 73 	. ( s 
	jp nc,l4afah		;4abc	d2 fa 4a 	. . J 
l4abfh:
	sub 00eh		;4abf	d6 0e 	. . 
	jr nc,l4abfh		;4ac1	30 fc 	0 . 
	cpl			;4ac3	2f 	/ 
	jr l4af3h		;4ac4	18 2d 	. - 
l4ac6h:
	push af			;4ac6	f5 	. 
	call sub_521bh		;4ac7	cd 1b 52 	. . R 
	rst 8			;4aca	cf 	. 
	add hl,hl			;4acb	29 	) 
	dec hl			;4acc	2b 	+ 
	pop af			;4acd	f1 	. 
	sub 0dfh		;4ace	d6 df 	. . 
	push hl			;4ad0	e5 	. 
	jr z,l4aefh		;4ad1	28 1c 	( . 
	ld bc,0008h		;4ad3	01 08 00 	. . . 
	ld hl,(PTRFIL)		;4ad6	2a 64 f8 	* d . 
	add hl,bc			;4ad9	09 	. 
	call ISFLIO		;4ada	cd 4a 01 	. J . 
	ld a,(hl)			;4add	7e 	~ 
	jr nz,l4aefh		;4ade	20 0f 	  . 
	ld a,(PRTFLG)		;4ae0	3a 16 f4 	: . . 
	or a			;4ae3	b7 	. 
	jp z,l4aech		;4ae4	ca ec 4a 	. . J 
	ld a,(LPTPOS)		;4ae7	3a 15 f4 	: . . 
	jr l4aefh		;4aea	18 03 	. . 
l4aech:
	ld a,(TTYPOS)		;4aec	3a 61 f6 	: a . 
l4aefh:
	cpl			;4aef	2f 	/ 
	add a,e			;4af0	83 	. 
	jr nc,l4afah		;4af1	30 07 	0 . 
l4af3h:
	inc a			;4af3	3c 	< 
	ld b,a			;4af4	47 	G 
	ld a,020h		;4af5	3e 20 	>   
l4af7h:
	rst 18h			;4af7	df 	. 
	djnz l4af7h		;4af8	10 fd 	. . 
l4afah:
	pop hl			;4afa	e1 	. 
	rst 10h			;4afb	d7 	. 
	jp l4a2eh		;4afc	c3 2e 4a 	. . J 
l4affh:
	call H.FINP		;4aff	cd 5c ff 	. \ . 
	xor a			;4b02	af 	. 
	ld (PRTFLG),a		;4b03	32 16 f4 	2 . . 
	push hl			;4b06	e5 	. 
	ld h,a			;4b07	67 	g 
	ld l,a			;4b08	6f 	o 
	ld (PTRFIL),hl		;4b09	22 64 f8 	" d . 
	pop hl			;4b0c	e1 	. 
	ret			;4b0d	c9 	. 
	cp 085h		;4b0e	fe 85 	. . 
	jp nz,l58a7h		;4b10	c2 a7 58 	. . X 
	rst 8			;4b13	cf 	. 
	add a,l			;4b14	85 	. 
	cp 023h		;4b15	fe 23 	. # 
	jp z,l6d8fh		;4b17	ca 8f 6d 	. . m 
	call sub_4b7bh		;4b1a	cd 7b 4b 	. { K 
	call 05ea4h		;4b1d	cd a4 5e 	. . ^ 
	call sub_3058h		;4b20	cd 58 30 	. X 0 
	push de			;4b23	d5 	. 
	push hl			;4b24	e5 	. 
	call S.TDOWNC		;4b25	cd b1 00 	. . . 
	pop de			;4b28	d1 	. 
	pop bc			;4b29	c1 	. 
	jp c,063feh		;4b2a	da fe 63 	. . c 
	push bc			;4b2d	c5 	. 
	push de			;4b2e	d5 	. 
	ld b,000h		;4b2f	06 00 	. . 
	call sub_6638h		;4b31	cd 38 66 	. 8 f 
	pop hl			;4b34	e1 	. 
	ld a,003h		;4b35	3e 03 	> . 
	jp l4892h		;4b37	c3 92 48 	. . H 
l4b3ah:
	ccf			;4b3a	3f 	? 
	ld d,d			;4b3b	52 	R 
	ld h,l			;4b3c	65 	e 
	ld h,h			;4b3d	64 	d 
	ld l,a			;4b3e	6f 	o 
	jr nz,$+104		;4b3f	20 66 	  f 
	ld (hl),d			;4b41	72 	r 
	ld l,a			;4b42	6f 	o 
	ld l,l			;4b43	6d 	m 
	jr nz,l4bb9h		;4b44	20 73 	  s 
	ld (hl),h			;4b46	74 	t 
	ld h,c			;4b47	61 	a 
	ld (hl),d			;4b48	72 	r 
	ld (hl),h			;4b49	74 	t 
	dec c			;4b4a	0d 	. 
	ld a,(bc)			;4b4b	0a 	. 
	nop			;4b4c	00 	. 
l4b4dh:
	call H.TRMN		;4b4d	cd 61 ff 	. a . 
	ld a,(FLGINP)		;4b50	3a a6 f6 	: . . 
	or a			;4b53	b7 	. 
	jp nz,l404fh		;4b54	c2 4f 40 	. O @ 
	pop bc			;4b57	c1 	. 
	ld hl,l4b3ah		;4b58	21 3a 4b 	! : K 
	call sub_6678h		;4b5b	cd 78 66 	. x f 
	ld hl,(SAVTXT)		;4b5e	2a af f6 	* . . 
	ret			;4b61	c9 	. 
l4b62h:
	call sub_6d55h		;4b62	cd 55 6d 	. U m 
	push hl			;4b65	e5 	. 
	ld hl,BUFMIN		;4b66	21 5d f5 	! ] . 
	jp l4b9bh		;4b69	c3 9b 4b 	. . K 
	cp 023h		;4b6c	fe 23 	. # 
	jr z,l4b62h		;4b6e	28 f2 	( . 
	push hl			;4b70	e5 	. 
	push af			;4b71	f5 	. 
	call TOTEXT		;4b72	cd d2 00 	. . . 
	pop af			;4b75	f1 	. 
	pop hl			;4b76	e1 	. 
	ld bc,l4b8bh		;4b77	01 8b 4b 	. . K 
	push bc			;4b7a	c5 	. 
sub_4b7bh:
	cp 022h		;4b7b	fe 22 	. " 
	ld a,000h		;4b7d	3e 00 	> . 
	ret nz			;4b7f	c0 	. 
	call sub_6636h		;4b80	cd 36 66 	. 6 f 
	rst 8			;4b83	cf 	. 
	dec sp			;4b84	3b 	; 
	push hl			;4b85	e5 	. 
	call sub_667bh		;4b86	cd 7b 66 	. { f 
	pop hl			;4b89	e1 	. 
	ret			;4b8a	c9 	. 
l4b8bh:
	push hl			;4b8b	e5 	. 
	call QINLIN		;4b8c	cd b4 00 	. . . 
	pop bc			;4b8f	c1 	. 
	jp c,063feh		;4b90	da fe 63 	. . c 
	inc hl			;4b93	23 	# 
	ld a,(hl)			;4b94	7e 	~ 
	or a			;4b95	b7 	. 
	dec hl			;4b96	2b 	+ 
	push bc			;4b97	c5 	. 
	jp z,0485ah		;4b98	ca 5a 48 	. Z H 
l4b9bh:
	ld (hl),02ch		;4b9b	36 2c 	6 , 
	jr $+7		;4b9d	18 05 	. . 
	push hl			;4b9f	e5 	. 
	ld hl,(DATPTR)		;4ba0	2a c8 f6 	* . . 
	or 0afh		;4ba3	f6 af 	. . 
	ld (FLGINP),a		;4ba5	32 a6 f6 	2 . . 
	ex (sp),hl			;4ba8	e3 	. 
	ld bc,l2ccfh		;4ba9	01 cf 2c 	. . , 
	call 05ea4h		;4bac	cd a4 5e 	. . ^ 
	ex (sp),hl			;4baf	e3 	. 
	push de			;4bb0	d5 	. 
	ld a,(hl)			;4bb1	7e 	~ 
	cp 02ch		;4bb2	fe 2c 	. , 
	jr z,l4bd1h		;4bb4	28 1b 	( . 
	ld a,(FLGINP)		;4bb6	3a a6 f6 	: . . 
l4bb9h:
	or a			;4bb9	b7 	. 
	jp nz,l4c40h		;4bba	c2 40 4c 	. @ L 
	ld a,03fh		;4bbd	3e 3f 	> ? 
	rst 18h			;4bbf	df 	. 
	call QINLIN		;4bc0	cd b4 00 	. . . 
	pop de			;4bc3	d1 	. 
	pop bc			;4bc4	c1 	. 
	jp c,063feh		;4bc5	da fe 63 	. . c 
	inc hl			;4bc8	23 	# 
	ld a,(hl)			;4bc9	7e 	~ 
	dec hl			;4bca	2b 	+ 
	or a			;4bcb	b7 	. 
	push bc			;4bcc	c5 	. 
	jp z,0485ah		;4bcd	ca 5a 48 	. Z H 
	push de			;4bd0	d5 	. 
l4bd1h:
	call ISFLIO		;4bd1	cd 4a 01 	. J . 
	jp nz,l6d83h		;4bd4	c2 83 6d 	. . m 
	rst 28h			;4bd7	ef 	. 
	push af			;4bd8	f5 	. 
	jr nz,l4bfdh		;4bd9	20 22 	  " 
	rst 10h			;4bdb	d7 	. 
	ld d,a			;4bdc	57 	W 
	ld b,a			;4bdd	47 	G 
	cp 022h		;4bde	fe 22 	. " 
	jr z,l4beeh		;4be0	28 0c 	( . 
	ld a,(FLGINP)		;4be2	3a a6 f6 	: . . 
	or a			;4be5	b7 	. 
	ld d,a			;4be6	57 	W 
	jr z,l4bebh		;4be7	28 02 	( . 
	ld d,03ah		;4be9	16 3a 	. : 
l4bebh:
	ld b,02ch		;4beb	06 2c 	. , 
	dec hl			;4bed	2b 	+ 
l4beeh:
	call sub_6639h		;4bee	cd 39 66 	. 9 f 
l4bf1h:
	pop af			;4bf1	f1 	. 
	add a,003h		;4bf2	c6 03 	. . 
	ex de,hl			;4bf4	eb 	. 
	ld hl,l4c05h		;4bf5	21 05 4c 	! . L 
	ex (sp),hl			;4bf8	e3 	. 
	push de			;4bf9	d5 	. 
	jp l4893h		;4bfa	c3 93 48 	. . H 
l4bfdh:
	rst 10h			;4bfd	d7 	. 
	ld bc,l4bf1h		;4bfe	01 f1 4b 	. . K 
	push bc			;4c01	c5 	. 
	jp sub_3299h		;4c02	c3 99 32 	. . 2 
l4c05h:
	dec hl			;4c05	2b 	+ 
	rst 10h			;4c06	d7 	. 
	jr z,l4c0eh		;4c07	28 05 	( . 
	cp 02ch		;4c09	fe 2c 	. , 
	jp nz,l4b4dh		;4c0b	c2 4d 4b 	. M K 
l4c0eh:
	ex (sp),hl			;4c0e	e3 	. 
	dec hl			;4c0f	2b 	+ 
	rst 10h			;4c10	d7 	. 
	jp nz,04baah		;4c11	c2 aa 4b 	. . K 
	pop de			;4c14	d1 	. 
	ld a,(FLGINP)		;4c15	3a a6 f6 	: . . 
	or a			;4c18	b7 	. 
	ex de,hl			;4c19	eb 	. 
	jp nz,l63deh		;4c1a	c2 de 63 	. . c 
	push de			;4c1d	d5 	. 
	call ISFLIO		;4c1e	cd 4a 01 	. J . 
	jr nz,l4c2bh		;4c21	20 08 	  . 
	ld a,(hl)			;4c23	7e 	~ 
	or a			;4c24	b7 	. 
	ld hl,l4c2fh		;4c25	21 2f 4c 	! / L 
	call nz,sub_6678h		;4c28	c4 78 66 	. x f 
l4c2bh:
	pop hl			;4c2b	e1 	. 
	jp l4affh		;4c2c	c3 ff 4a 	. . J 
l4c2fh:
	ccf			;4c2f	3f 	? 
	ld b,l			;4c30	45 	E 
	ld a,b			;4c31	78 	x 
	ld (hl),h			;4c32	74 	t 
	ld (hl),d			;4c33	72 	r 
	ld h,c			;4c34	61 	a 
	jr nz,l4ca0h		;4c35	20 69 	  i 
	ld h,a			;4c37	67 	g 
	ld l,(hl)			;4c38	6e 	n 
	ld l,a			;4c39	6f 	o 
	ld (hl),d			;4c3a	72 	r 
	ld h,l			;4c3b	65 	e 
	ld h,h			;4c3c	64 	d 
	dec c			;4c3d	0d 	. 
	ld a,(bc)			;4c3e	0a 	. 
	nop			;4c3f	00 	. 
l4c40h:
	call sub_485bh		;4c40	cd 5b 48 	. [ H 
	or a			;4c43	b7 	. 
	jr nz,l4c57h		;4c44	20 11 	  . 
	inc hl			;4c46	23 	# 
	ld a,(hl)			;4c47	7e 	~ 
	inc hl			;4c48	23 	# 
	or (hl)			;4c49	b6 	. 
	ld e,004h		;4c4a	1e 04 	. . 
	jp z,l406fh		;4c4c	ca 6f 40 	. o @ 
	inc hl			;4c4f	23 	# 
	ld e,(hl)			;4c50	5e 	^ 
	inc hl			;4c51	23 	# 
	ld d,(hl)			;4c52	56 	V 
	ld (DATLIN),de		;4c53	ed 53 a3 f6 	. S . . 
l4c57h:
	rst 10h			;4c57	d7 	. 
	cp 084h		;4c58	fe 84 	. . 
	jr nz,l4c40h		;4c5a	20 e4 	  . 
	jp l4bd1h		;4c5c	c3 d1 4b 	. . K 
sub_4c5fh:
	rst 8			;4c5f	cf 	. 
	rst 28h			;4c60	ef 	. 
	ld bc,l28cfh		;4c61	01 cf 28 	. . ( 
sub_4c64h:
	dec hl			;4c64	2b 	+ 
sub_4c65h:
	ld d,000h		;4c65	16 00 	. . 
l4c67h:
	push de			;4c67	d5 	. 
	ld c,001h		;4c68	0e 01 	. . 
	call sub_625eh		;4c6a	cd 5e 62 	. ^ b 
	call H.FRME		;4c6d	cd 66 ff 	. f . 
	call sub_4dc7h		;4c70	cd c7 4d 	. . M 
l4c73h:
	ld (TEMP2),hl		;4c73	22 bc f6 	" . . 
l4c76h:
	ld hl,(TEMP2)		;4c76	2a bc f6 	* . . 
	pop bc			;4c79	c1 	. 
	ld a,(hl)			;4c7a	7e 	~ 
	ld (TEMP3),hl		;4c7b	22 9d f6 	" . . 
	cp 0eeh		;4c7e	fe ee 	. . 
	ret c			;4c80	d8 	. 
	cp 0f1h		;4c81	fe f1 	. . 
	jr c,l4ce4h		;4c83	38 5f 	8 _ 
	sub 0f1h		;4c85	d6 f1 	. . 
	ld e,a			;4c87	5f 	_ 
	jr nz,l4c93h		;4c88	20 09 	  . 
	ld a,(VALTYP)		;4c8a	3a 63 f6 	: c . 
	cp 003h		;4c8d	fe 03 	. . 
	ld a,e			;4c8f	7b 	{ 
	jp z,l6787h		;4c90	ca 87 67 	. . g 
l4c93h:
	cp 00ch		;4c93	fe 0c 	. . 
	ret nc			;4c95	d0 	. 
	ld hl,l3d3bh		;4c96	21 3b 3d 	! ; = 
	ld d,000h		;4c99	16 00 	. . 
	add hl,de			;4c9b	19 	. 
	ld a,b			;4c9c	78 	x 
	ld d,(hl)			;4c9d	56 	V 
	cp d			;4c9e	ba 	. 
l4c9fh:
	ret nc			;4c9f	d0 	. 
l4ca0h:
	push bc			;4ca0	c5 	. 
	ld bc,l4c76h		;4ca1	01 76 4c 	. v L 
	push bc			;4ca4	c5 	. 
	ld a,d			;4ca5	7a 	z 
	call H.NTPL		;4ca6	cd 6b ff 	. k . 
	cp 051h		;4ca9	fe 51 	. Q 
	jr c,l4cfdh		;4cab	38 50 	8 P 
	and 0feh		;4cad	e6 fe 	. . 
	cp 07ah		;4caf	fe 7a 	. z 
	jr z,l4cfdh		;4cb1	28 4a 	( J 
l4cb3h:
	ld hl,0f7f8h		;4cb3	21 f8 f7 	! . . 
	ld a,(VALTYP)		;4cb6	3a 63 f6 	: c . 
	sub 003h		;4cb9	d6 03 	. . 
	jp z,0406dh		;4cbb	ca 6d 40 	. m @ 
	or a			;4cbe	b7 	. 
	ld hl,(0f7f8h)		;4cbf	2a f8 f7 	* . . 
	push hl			;4cc2	e5 	. 
	jp m,l4cd5h		;4cc3	fa d5 4c 	. . L 
	ld hl,(DAC)		;4cc6	2a f6 f7 	* . . 
	push hl			;4cc9	e5 	. 
	jp po,l4cd5h		;4cca	e2 d5 4c 	. . L 
	ld hl,(0f7fch)		;4ccd	2a fc f7 	* . . 
	push hl			;4cd0	e5 	. 
	ld hl,(0f7fah)		;4cd1	2a fa f7 	* . . 
	push hl			;4cd4	e5 	. 
l4cd5h:
	add a,003h		;4cd5	c6 03 	. . 
	ld c,e			;4cd7	4b 	K 
	ld b,a			;4cd8	47 	G 
	push bc			;4cd9	c5 	. 
	ld bc,l4d22h		;4cda	01 22 4d 	. " M 
l4cddh:
	push bc			;4cdd	c5 	. 
	ld hl,(TEMP3)		;4cde	2a 9d f6 	* . . 
	jp l4c67h		;4ce1	c3 67 4c 	. g L 
l4ce4h:
	ld d,000h		;4ce4	16 00 	. . 
l4ce6h:
	sub 0eeh		;4ce6	d6 ee 	. . 
	jr c,l4d08h		;4ce8	38 1e 	8 . 
	cp 003h		;4cea	fe 03 	. . 
	jr nc,l4d08h		;4cec	30 1a 	0 . 
	cp 001h		;4cee	fe 01 	. . 
	rla			;4cf0	17 	. 
	xor d			;4cf1	aa 	. 
	cp d			;4cf2	ba 	. 
	ld d,a			;4cf3	57 	W 
	jp c,l4055h		;4cf4	da 55 40 	. U @ 
	ld (TEMP3),hl		;4cf7	22 9d f6 	" . . 
	rst 10h			;4cfa	d7 	. 
	jr l4ce6h		;4cfb	18 e9 	. . 
l4cfdh:
	push de			;4cfd	d5 	. 
	call sub_2f8ah		;4cfe	cd 8a 2f 	. . / 
	pop de			;4d01	d1 	. 
	push hl			;4d02	e5 	. 
	ld bc,l4f78h		;4d03	01 78 4f 	. x O 
	jr l4cddh		;4d06	18 d5 	. . 
l4d08h:
	ld a,b			;4d08	78 	x 
	cp 064h		;4d09	fe 64 	. d 
	ret nc			;4d0b	d0 	. 
	push bc			;4d0c	c5 	. 
	push de			;4d0d	d5 	. 
	ld de,l6405h		;4d0e	11 05 64 	. . d 
	ld hl,l4f57h		;4d11	21 57 4f 	! W O 
	push hl			;4d14	e5 	. 
	rst 28h			;4d15	ef 	. 
	jp nz,l4cb3h		;4d16	c2 b3 4c 	. . L 
	ld hl,(0f7f8h)		;4d19	2a f8 f7 	* . . 
	push hl			;4d1c	e5 	. 
	ld bc,l65c8h		;4d1d	01 c8 65 	. . e 
	jr l4cddh		;4d20	18 bb 	. . 
l4d22h:
	pop bc			;4d22	c1 	. 
	ld a,c			;4d23	79 	y 
	ld (DORES),a		;4d24	32 64 f6 	2 d . 
	ld a,(VALTYP)		;4d27	3a 63 f6 	: c . 
	cp b			;4d2a	b8 	. 
	jr nz,l4d38h		;4d2b	20 0b 	  . 
	cp 002h		;4d2d	fe 02 	. . 
	jr z,l4d50h		;4d2f	28 1f 	( . 
	cp 004h		;4d31	fe 04 	. . 
	jp z,l4d9dh		;4d33	ca 9d 4d 	. . M 
	jr nc,l4d63h		;4d36	30 2b 	0 + 
l4d38h:
	ld d,a			;4d38	57 	W 
	ld a,b			;4d39	78 	x 
	cp 008h		;4d3a	fe 08 	. . 
	jr z,l4d60h		;4d3c	28 22 	( " 
	ld a,d			;4d3e	7a 	z 
	cp 008h		;4d3f	fe 08 	. . 
	jr z,l4d87h		;4d41	28 44 	( D 
	ld a,b			;4d43	78 	x 
	cp 004h		;4d44	fe 04 	. . 
	jr z,l4d9ah		;4d46	28 52 	( R 
	ld a,d			;4d48	7a 	z 
	cp 003h		;4d49	fe 03 	. . 
	jp z,0406dh		;4d4b	ca 6d 40 	. m @ 
	jr nc,l4da4h		;4d4e	30 54 	0 T 
l4d50h:
	ld hl,l3d69h		;4d50	21 69 3d 	! i = 
	ld b,000h		;4d53	06 00 	. . 
	add hl,bc			;4d55	09 	. 
	add hl,bc			;4d56	09 	. 
	ld c,(hl)			;4d57	4e 	N 
	inc hl			;4d58	23 	# 
	ld b,(hl)			;4d59	46 	F 
	pop de			;4d5a	d1 	. 
	ld hl,(0f7f8h)		;4d5b	2a f8 f7 	* . . 
	push bc			;4d5e	c5 	. 
	ret			;4d5f	c9 	. 
l4d60h:
	call FRCDBL		;4d60	cd 3a 30 	. : 0 
l4d63h:
	call sub_2f0dh		;4d63	cd 0d 2f 	. . / 
	pop hl			;4d66	e1 	. 
	ld (0f7fah),hl		;4d67	22 fa f7 	" . . 
	pop hl			;4d6a	e1 	. 
	ld (0f7fch),hl		;4d6b	22 fc f7 	" . . 
l4d6eh:
	pop bc			;4d6e	c1 	. 
	pop de			;4d6f	d1 	. 
	call sub_2ec1h		;4d70	cd c1 2e 	. . . 
l4d73h:
	call FRCDBL		;4d73	cd 3a 30 	. : 0 
	ld hl,l3d51h		;4d76	21 51 3d 	! Q = 
l4d79h:
	ld a,(DORES)		;4d79	3a 64 f6 	: d . 
	rlca			;4d7c	07 	. 
	add a,l			;4d7d	85 	. 
	ld l,a			;4d7e	6f 	o 
	adc a,h			;4d7f	8c 	. 
	sub l			;4d80	95 	. 
	ld h,a			;4d81	67 	g 
	ld a,(hl)			;4d82	7e 	~ 
	inc hl			;4d83	23 	# 
	ld h,(hl)			;4d84	66 	f 
	ld l,a			;4d85	6f 	o 
	jp (hl)			;4d86	e9 	. 
l4d87h:
	ld a,b			;4d87	78 	x 
	push af			;4d88	f5 	. 
	call sub_2f0dh		;4d89	cd 0d 2f 	. . / 
	pop af			;4d8c	f1 	. 
	ld (VALTYP),a		;4d8d	32 63 f6 	2 c . 
	cp 004h		;4d90	fe 04 	. . 
	jr z,l4d6eh		;4d92	28 da 	( . 
	pop hl			;4d94	e1 	. 
	ld (0f7f8h),hl		;4d95	22 f8 f7 	" . . 
	jr l4d73h		;4d98	18 d9 	. . 
l4d9ah:
	call sub_2fb2h		;4d9a	cd b2 2f 	. . / 
l4d9dh:
	pop bc			;4d9d	c1 	. 
	pop de			;4d9e	d1 	. 
l4d9fh:
	ld hl,l3d5dh		;4d9f	21 5d 3d 	! ] = 
	jr l4d79h		;4da2	18 d5 	. . 
l4da4h:
	pop hl			;4da4	e1 	. 
	call sub_2eb1h		;4da5	cd b1 2e 	. . . 
	call sub_2fcbh		;4da8	cd cb 2f 	. . / 
	call sub_2ecch		;4dab	cd cc 2e 	. . . 
	pop hl			;4dae	e1 	. 
	ld (DAC),hl		;4daf	22 f6 f7 	" . . 
	pop hl			;4db2	e1 	. 
	ld (0f7f8h),hl		;4db3	22 f8 f7 	" . . 
	jr l4d9fh		;4db6	18 e7 	. . 
	push hl			;4db8	e5 	. 
	ex de,hl			;4db9	eb 	. 
	call sub_2fcbh		;4dba	cd cb 2f 	. . / 
	pop hl			;4dbd	e1 	. 
	call sub_2eb1h		;4dbe	cd b1 2e 	. . . 
	call sub_2fcbh		;4dc1	cd cb 2f 	. . / 
	jp l3265h		;4dc4	c3 65 32 	. e 2 
sub_4dc7h:
	rst 10h			;4dc7	d7 	. 
	jp z,0406ah		;4dc8	ca 6a 40 	. j @ 
	jp c,sub_3299h		;4dcb	da 99 32 	. . 2 
	call sub_64a8h		;4dce	cd a8 64 	. . d 
	jp nc,l4e9bh		;4dd1	d2 9b 4e 	. . N 
	cp 020h		;4dd4	fe 20 	.   
	jp c,l46b8h		;4dd6	da b8 46 	. . F 
	call H.EVAL		;4dd9	cd 70 ff 	. p . 
	inc a			;4ddc	3c 	< 
	jp z,l4efch		;4ddd	ca fc 4e 	. . N 
	dec a			;4de0	3d 	= 
	cp 0f1h		;4de1	fe f1 	. . 
	jr z,sub_4dc7h		;4de3	28 e2 	( . 
	cp 0f2h		;4de5	fe f2 	. . 
	jp z,l4e8dh		;4de7	ca 8d 4e 	. . N 
	cp 022h		;4dea	fe 22 	. " 
	jp z,sub_6636h		;4dec	ca 36 66 	. 6 f 
	cp 0e0h		;4def	fe e0 	. . 
	jp z,l4f63h		;4df1	ca 63 4f 	. c O 
	cp 026h		;4df4	fe 26 	. & 
	jp z,l4eb8h		;4df6	ca b8 4e 	. . N 
	cp 0e2h		;4df9	fe e2 	. . 
	jr nz,l4e07h		;4dfb	20 0a 	  . 
	rst 10h			;4dfd	d7 	. 
	ld a,(ERRFLG)		;4dfe	3a 14 f4 	: . . 
	push hl			;4e01	e5 	. 
	call l4fcfh		;4e02	cd cf 4f 	. . O 
	pop hl			;4e05	e1 	. 
	ret			;4e06	c9 	. 
l4e07h:
	cp 0e1h		;4e07	fe e1 	. . 
	jr nz,l4e15h		;4e09	20 0a 	  . 
	rst 10h			;4e0b	d7 	. 
	push hl			;4e0c	e5 	. 
	ld hl,(ERRLIN)		;4e0d	2a b3 f6 	* . . 
	call l3236h		;4e10	cd 36 32 	. 6 2 
	pop hl			;4e13	e1 	. 
	ret			;4e14	c9 	. 
l4e15h:
	cp 0edh		;4e15	fe ed 	. . 
	jp z,l5803h		;4e17	ca 03 58 	. . X 
	cp 0cbh		;4e1a	fe cb 	. . 
	jp z,l7900h		;4e1c	ca 00 79 	. . y 
	cp 0c7h		;4e1f	fe c7 	. . 
	jp z,l7a84h		;4e21	ca 84 7a 	. . z 
	cp 0c8h		;4e24	fe c8 	. . 
	jp z,l7b47h		;4e26	ca 47 7b 	. G { 
	cp 0c9h		;4e29	fe c9 	. . 
	jp z,l7bcbh		;4e2b	ca cb 7b 	. . { 
	cp 0c1h		;4e2e	fe c1 	. . 
	jp z,l791bh		;4e30	ca 1b 79 	. . y 
	cp 0eah		;4e33	fe ea 	. . 
	jp z,l7c3eh		;4e35	ca 3e 7c 	. > | 
	cp 0e9h		;4e38	fe e9 	. . 
	jp z,l7c43h		;4e3a	ca 43 7c 	. C | 
	cp 0e7h		;4e3d	fe e7 	. . 
	jr nz,l4e64h		;4e3f	20 23 	  # 
	rst 10h			;4e41	d7 	. 
	rst 8			;4e42	cf 	. 
l4e43h:
	jr z,l4e43h		;4e43	28 fe 	( . 
	inc hl			;4e45	23 	# 
	jr nz,l4e53h		;4e46	20 0b 	  . 
	call sub_521bh		;4e48	cd 1b 52 	. . R 
	push hl			;4e4b	e5 	. 
	call sub_6a6dh		;4e4c	cd 6d 6a 	. m j 
	ex de,hl			;4e4f	eb 	. 
	pop hl			;4e50	e1 	. 
	jr l4e56h		;4e51	18 03 	. . 
l4e53h:
	call sub_5f5dh		;4e53	cd 5d 5f 	. ] _ 
l4e56h:
	rst 8			;4e56	cf 	. 
	add hl,hl			;4e57	29 	) 
	push hl			;4e58	e5 	. 
	ex de,hl			;4e59	eb 	. 
	ld a,h			;4e5a	7c 	| 
	or l			;4e5b	b5 	. 
	jp z,l475ah		;4e5c	ca 5a 47 	. Z G 
	call l2f99h		;4e5f	cd 99 2f 	. . / 
	pop hl			;4e62	e1 	. 
	ret			;4e63	c9 	. 
l4e64h:
	cp 0ddh		;4e64	fe dd 	. . 
	jp z,l4fd5h		;4e66	ca d5 4f 	. . O 
	cp 0e5h		;4e69	fe e5 	. . 
	jp z,l68ebh		;4e6b	ca eb 68 	. . h 
	cp 0ech		;4e6e	fe ec 	. . 
	jp z,l7347h		;4e70	ca 47 73 	. G s 
	cp 0e3h		;4e73	fe e3 	. . 
	jp z,l6829h		;4e75	ca 29 68 	. ) h 
	cp 085h		;4e78	fe 85 	. . 
	jp z,l6c87h		;4e7a	ca 87 6c 	. . l 
	cp 0e8h		;4e7d	fe e8 	. . 
	jp z,l790ah		;4e7f	ca 0a 79 	. . y 
	cp 0deh		;4e82	fe de 	. . 
	jp z,l5040h		;4e84	ca 40 50 	. @ P 
sub_4e87h:
	call 04c62h		;4e87	cd 62 4c 	. b L 
	rst 8			;4e8a	cf 	. 
	add hl,hl			;4e8b	29 	) 
	ret			;4e8c	c9 	. 
l4e8dh:
	ld d,07dh		;4e8d	16 7d 	. } 
	call l4c67h		;4e8f	cd 67 4c 	. g L 
	ld hl,(TEMP2)		;4e92	2a bc f6 	* . . 
	push hl			;4e95	e5 	. 
	call l2e86h		;4e96	cd 86 2e 	. . . 
l4e99h:
	pop hl			;4e99	e1 	. 
	ret			;4e9a	c9 	. 
l4e9bh:
	call 05ea4h		;4e9b	cd a4 5e 	. . ^ 
l4e9eh:
	push hl			;4e9e	e5 	. 
	ex de,hl			;4e9f	eb 	. 
	ld (0f7f8h),hl		;4ea0	22 f8 f7 	" . . 
	rst 28h			;4ea3	ef 	. 
	call nz,l2f08h		;4ea4	c4 08 2f 	. . / 
	pop hl			;4ea7	e1 	. 
	ret			;4ea8	c9 	. 
sub_4ea9h:
	ld a,(hl)			;4ea9	7e 	~ 
sub_4eaah:
	cp 061h		;4eaa	fe 61 	. a 
	ret c			;4eac	d8 	. 
	cp 07bh		;4ead	fe 7b 	. { 
	ret nc			;4eaf	d0 	. 
	and 05fh		;4eb0	e6 5f 	. _ 
	ret			;4eb2	c9 	. 
	cp 026h		;4eb3	fe 26 	. & 
	jp nz,sub_4769h		;4eb5	c2 69 47 	. i G 
l4eb8h:
	ld de,0000h		;4eb8	11 00 00 	. . . 
	rst 10h			;4ebb	d7 	. 
	call sub_4eaah		;4ebc	cd aa 4e 	. . N 
	ld bc,0102h		;4ebf	01 02 01 	. . . 
	cp 042h		;4ec2	fe 42 	. B 
	jr z,l4ed5h		;4ec4	28 0f 	( . 
	ld bc,l0308h		;4ec6	01 08 03 	. . . 
	cp 04fh		;4ec9	fe 4f 	. O 
	jr z,l4ed5h		;4ecb	28 08 	( . 
	ld bc,00410h		;4ecd	01 10 04 	. . . 
	cp 048h		;4ed0	fe 48 	. H 
	jp nz,l4055h		;4ed2	c2 55 40 	. U @ 
l4ed5h:
	inc hl			;4ed5	23 	# 
	ld a,(hl)			;4ed6	7e 	~ 
	ex de,hl			;4ed7	eb 	. 
	call sub_4eaah		;4ed8	cd aa 4e 	. . N 
	cp 03ah		;4edb	fe 3a 	. : 
	jr c,l4ee5h		;4edd	38 06 	8 . 
	cp 041h		;4edf	fe 41 	. A 
	jr c,l4ef7h		;4ee1	38 14 	8 . 
	sub 007h		;4ee3	d6 07 	. . 
l4ee5h:
	sub 030h		;4ee5	d6 30 	. 0 
	cp c			;4ee7	b9 	. 
	jr nc,l4ef7h		;4ee8	30 0d 	0 . 
	push bc			;4eea	c5 	. 
l4eebh:
	add hl,hl			;4eeb	29 	) 
	jp c,04067h		;4eec	da 67 40 	. g @ 
	djnz l4eebh		;4eef	10 fa 	. . 
	pop bc			;4ef1	c1 	. 
	or l			;4ef2	b5 	. 
	ld l,a			;4ef3	6f 	o 
	ex de,hl			;4ef4	eb 	. 
	jr l4ed5h		;4ef5	18 de 	. . 
l4ef7h:
	call l2f99h		;4ef7	cd 99 2f 	. . / 
	ex de,hl			;4efa	eb 	. 
	ret			;4efb	c9 	. 
l4efch:
	inc hl			;4efc	23 	# 
	ld a,(hl)			;4efd	7e 	~ 
	sub 081h		;4efe	d6 81 	. . 
	ld b,000h		;4f00	06 00 	. . 
	rlca			;4f02	07 	. 
	ld c,a			;4f03	4f 	O 
	push bc			;4f04	c5 	. 
	rst 10h			;4f05	d7 	. 
	ld a,c			;4f06	79 	y 
	cp 005h		;4f07	fe 05 	. . 
	jr nc,l4f21h		;4f09	30 16 	0 . 
	call 04c62h		;4f0b	cd 62 4c 	. b L 
	rst 8			;4f0e	cf 	. 
	inc l			;4f0f	2c 	, 
	call sub_3058h		;4f10	cd 58 30 	. X 0 
	ex de,hl			;4f13	eb 	. 
	ld hl,(0f7f8h)		;4f14	2a f8 f7 	* . . 
	ex (sp),hl			;4f17	e3 	. 
	push hl			;4f18	e5 	. 
	ex de,hl			;4f19	eb 	. 
	call sub_521ch		;4f1a	cd 1c 52 	. . R 
	ex de,hl			;4f1d	eb 	. 
	ex (sp),hl			;4f1e	e3 	. 
	jr l4f3bh		;4f1f	18 1a 	. . 
l4f21h:
	call sub_4e87h		;4f21	cd 87 4e 	. . N 
	ex (sp),hl			;4f24	e3 	. 
	ld a,l			;4f25	7d 	} 
	cp 00ch		;4f26	fe 0c 	. . 
	jr c,l4f37h		;4f28	38 0d 	8 . 
	cp 01bh		;4f2a	fe 1b 	. . 
	call H.OKNO		;4f2c	cd 75 ff 	. u . 
	jr nc,l4f37h		;4f2f	30 06 	0 . 
	rst 28h			;4f31	ef 	. 
	push hl			;4f32	e5 	. 
	call c,FRCDBL		;4f33	dc 3a 30 	. : 0 
	pop hl			;4f36	e1 	. 
l4f37h:
	ld de,l4e99h		;4f37	11 99 4e 	. . N 
	push de			;4f3a	d5 	. 
l4f3bh:
	ld bc,l39deh		;4f3b	01 de 39 	. . 9 
	call H.FING		;4f3e	cd 7a ff 	. z . 
sub_4f41h:
	add hl,bc			;4f41	09 	. 
	ld c,(hl)			;4f42	4e 	N 
	inc hl			;4f43	23 	# 
	ld h,(hl)			;4f44	66 	f 
	ld l,c			;4f45	69 	i 
	jp (hl)			;4f46	e9 	. 
sub_4f47h:
	dec d			;4f47	15 	. 
	cp 0f2h		;4f48	fe f2 	. . 
	ret z			;4f4a	c8 	. 
	cp 02dh		;4f4b	fe 2d 	. - 
	ret z			;4f4d	c8 	. 
	inc d			;4f4e	14 	. 
	cp 02bh		;4f4f	fe 2b 	. + 
	ret z			;4f51	c8 	. 
	cp 0f1h		;4f52	fe f1 	. . 
	ret z			;4f54	c8 	. 
	dec hl			;4f55	2b 	+ 
	ret			;4f56	c9 	. 
l4f57h:
	inc a			;4f57	3c 	< 
	adc a,a			;4f58	8f 	. 
	pop bc			;4f59	c1 	. 
	and b			;4f5a	a0 	. 
	add a,0ffh		;4f5b	c6 ff 	. . 
	sbc a,a			;4f5d	9f 	. 
	call sub_2e9ah		;4f5e	cd 9a 2e 	. . . 
	jr l4f75h		;4f61	18 12 	. . 
l4f63h:
	ld d,05ah		;4f63	16 5a 	. Z 
	call l4c67h		;4f65	cd 67 4c 	. g L 
	call sub_2f8ah		;4f68	cd 8a 2f 	. . / 
	ld a,l			;4f6b	7d 	} 
	cpl			;4f6c	2f 	/ 
	ld l,a			;4f6d	6f 	o 
	ld a,h			;4f6e	7c 	| 
	cpl			;4f6f	2f 	/ 
	ld h,a			;4f70	67 	g 
	ld (0f7f8h),hl		;4f71	22 f8 f7 	" . . 
	pop bc			;4f74	c1 	. 
l4f75h:
	jp l4c76h		;4f75	c3 76 4c 	. v L 
l4f78h:
	ld a,b			;4f78	78 	x 
	push af			;4f79	f5 	. 
	call sub_2f8ah		;4f7a	cd 8a 2f 	. . / 
	pop af			;4f7d	f1 	. 
	pop de			;4f7e	d1 	. 
	cp 07ah		;4f7f	fe 7a 	. z 
	jp z,l323ah		;4f81	ca 3a 32 	. : 2 
	cp 07bh		;4f84	fe 7b 	. { 
	jp z,sub_31e6h		;4f86	ca e6 31 	. . 1 
	ld bc,l4fd1h		;4f89	01 d1 4f 	. . O 
	push bc			;4f8c	c5 	. 
	cp 046h		;4f8d	fe 46 	. F 
	jr nz,l4f97h		;4f8f	20 06 	  . 
	ld a,e			;4f91	7b 	{ 
	or l			;4f92	b5 	. 
	ld l,a			;4f93	6f 	o 
	ld a,h			;4f94	7c 	| 
	or d			;4f95	b2 	. 
	ret			;4f96	c9 	. 
l4f97h:
	cp 050h		;4f97	fe 50 	. P 
	jr nz,l4fa1h		;4f99	20 06 	  . 
	ld a,e			;4f9b	7b 	{ 
	and l			;4f9c	a5 	. 
	ld l,a			;4f9d	6f 	o 
	ld a,h			;4f9e	7c 	| 
	and d			;4f9f	a2 	. 
	ret			;4fa0	c9 	. 
l4fa1h:
	cp 03ch		;4fa1	fe 3c 	. < 
	jr nz,l4fabh		;4fa3	20 06 	  . 
	ld a,e			;4fa5	7b 	{ 
	xor l			;4fa6	ad 	. 
	ld l,a			;4fa7	6f 	o 
	ld a,h			;4fa8	7c 	| 
	xor d			;4fa9	aa 	. 
	ret			;4faa	c9 	. 
l4fabh:
	cp 032h		;4fab	fe 32 	. 2 
	jr nz,l4fb7h		;4fad	20 08 	  . 
	ld a,e			;4faf	7b 	{ 
	xor l			;4fb0	ad 	. 
	cpl			;4fb1	2f 	/ 
	ld l,a			;4fb2	6f 	o 
	ld a,h			;4fb3	7c 	| 
	xor d			;4fb4	aa 	. 
	cpl			;4fb5	2f 	/ 
	ret			;4fb6	c9 	. 
l4fb7h:
	ld a,l			;4fb7	7d 	} 
	cpl			;4fb8	2f 	/ 
	and e			;4fb9	a3 	. 
	cpl			;4fba	2f 	/ 
	ld l,a			;4fbb	6f 	o 
	ld a,h			;4fbc	7c 	| 
	cpl			;4fbd	2f 	/ 
	and d			;4fbe	a2 	. 
	cpl			;4fbf	2f 	/ 
	ret			;4fc0	c9 	. 
l4fc1h:
	or a			;4fc1	b7 	. 
	sbc hl,de		;4fc2	ed 52 	. R 
	jp l3236h		;4fc4	c3 36 32 	. 6 2 
	ld a,(LPTPOS)		;4fc7	3a 15 f4 	: . . 
	jr l4fcfh		;4fca	18 03 	. . 
	ld a,(TTYPOS)		;4fcc	3a 61 f6 	: a . 
l4fcfh:
	ld l,a			;4fcf	6f 	o 
	xor a			;4fd0	af 	. 
l4fd1h:
	ld h,a			;4fd1	67 	g 
	jp l2f99h		;4fd2	c3 99 2f 	. . / 
l4fd5h:
	call sub_4ff4h		;4fd5	cd f4 4f 	. . O 
	push de			;4fd8	d5 	. 
	call sub_4e87h		;4fd9	cd 87 4e 	. . N 
	ex (sp),hl			;4fdc	e3 	. 
	ld e,(hl)			;4fdd	5e 	^ 
	inc hl			;4fde	23 	# 
	ld d,(hl)			;4fdf	56 	V 
	ld hl,l3297h		;4fe0	21 97 32 	! . 2 
	push hl			;4fe3	e5 	. 
	push de			;4fe4	d5 	. 
	ld a,(VALTYP)		;4fe5	3a 63 f6 	: c . 
	push af			;4fe8	f5 	. 
	cp 003h		;4fe9	fe 03 	. . 
	call z,sub_67d3h		;4feb	cc d3 67 	. . g 
	pop af			;4fee	f1 	. 
	ex de,hl			;4fef	eb 	. 
	ld hl,DAC		;4ff0	21 f6 f7 	! . . 
	ret			;4ff3	c9 	. 
sub_4ff4h:
	rst 10h			;4ff4	d7 	. 
	ld bc,0000h		;4ff5	01 00 00 	. . . 
	cp 01bh		;4ff8	fe 1b 	. . 
	jr nc,l5007h		;4ffa	30 0b 	0 . 
	cp 011h		;4ffc	fe 11 	. . 
	jr c,l5007h		;4ffe	38 07 	8 . 
	rst 10h			;5000	d7 	. 
	ld a,(CONLO)		;5001	3a 6a f6 	: j . 
	or a			;5004	b7 	. 
	rla			;5005	17 	. 
	ld c,a			;5006	4f 	O 
l5007h:
	ex de,hl			;5007	eb 	. 
	ld hl,0f39ah		;5008	21 9a f3 	! . . 
	add hl,bc			;500b	09 	. 
	ex de,hl			;500c	eb 	. 
	ret			;500d	c9 	. 
l500eh:
	call sub_4ff4h		;500e	cd f4 4f 	. . O 
	push de			;5011	d5 	. 
	rst 8			;5012	cf 	. 
	rst 28h			;5013	ef 	. 
	call sub_542fh		;5014	cd 2f 54 	. / T 
	ex (sp),hl			;5017	e3 	. 
	ld (hl),e			;5018	73 	s 
	inc hl			;5019	23 	# 
	ld (hl),d			;501a	72 	r 
	pop hl			;501b	e1 	. 
	ret			;501c	c9 	. 
	cp 0ddh		;501d	fe dd 	. . 
	jr z,l500eh		;501f	28 ed 	( . 
	call sub_51a1h		;5021	cd a1 51 	. . Q 
	call sub_5193h		;5024	cd 93 51 	. . Q 
	ex de,hl			;5027	eb 	. 
	ld (hl),e			;5028	73 	s 
	inc hl			;5029	23 	# 
	ld (hl),d			;502a	72 	r 
	ex de,hl			;502b	eb 	. 
	ld a,(hl)			;502c	7e 	~ 
	cp 028h		;502d	fe 28 	. ( 
	jp nz,sub_485bh		;502f	c2 5b 48 	. [ H 
	rst 10h			;5032	d7 	. 
l5033h:
	call 05ea4h		;5033	cd a4 5e 	. . ^ 
	ld a,(hl)			;5036	7e 	~ 
	cp 029h		;5037	fe 29 	. ) 
	jp z,sub_485bh		;5039	ca 5b 48 	. [ H 
	rst 8			;503c	cf 	. 
	inc l			;503d	2c 	, 
	jr l5033h		;503e	18 f3 	. . 
l5040h:
	call sub_51a1h		;5040	cd a1 51 	. . Q 
	ld a,(VALTYP)		;5043	3a 63 f6 	: c . 
	or a			;5046	b7 	. 
	push af			;5047	f5 	. 
	ld (TEMP2),hl		;5048	22 bc f6 	" . . 
	ex de,hl			;504b	eb 	. 
	ld a,(hl)			;504c	7e 	~ 
	inc hl			;504d	23 	# 
	ld h,(hl)			;504e	66 	f 
	ld l,a			;504f	6f 	o 
	ld a,h			;5050	7c 	| 
	or l			;5051	b5 	. 
	jp z,04061h		;5052	ca 61 40 	. a @ 
	ld a,(hl)			;5055	7e 	~ 
	cp 028h		;5056	fe 28 	. ( 
	jp nz,050f4h		;5058	c2 f4 50 	. . P 
	rst 10h			;505b	d7 	. 
	ld (TEMP3),hl		;505c	22 9d f6 	" . . 
	ex de,hl			;505f	eb 	. 
	ld hl,(TEMP2)		;5060	2a bc f6 	* . . 
	rst 8			;5063	cf 	. 
	jr z,$-79		;5064	28 af 	( . 
	push af			;5066	f5 	. 
	push hl			;5067	e5 	. 
	ex de,hl			;5068	eb 	. 
l5069h:
	ld a,080h		;5069	3e 80 	> . 
	ld (SUBFLG),a		;506b	32 a5 f6 	2 . . 
	call 05ea4h		;506e	cd a4 5e 	. . ^ 
	ex de,hl			;5071	eb 	. 
	ex (sp),hl			;5072	e3 	. 
	ld a,(VALTYP)		;5073	3a 63 f6 	: c . 
	push af			;5076	f5 	. 
	push de			;5077	d5 	. 
	call sub_4c64h		;5078	cd 64 4c 	. d L 
	ld (TEMP2),hl		;507b	22 bc f6 	" . . 
	pop hl			;507e	e1 	. 
	ld (TEMP3),hl		;507f	22 9d f6 	" . . 
	pop af			;5082	f1 	. 
	call sub_517ah		;5083	cd 7a 51 	. z Q 
	ld c,004h		;5086	0e 04 	. . 
	call sub_625eh		;5088	cd 5e 62 	. ^ b 
	ld hl,0fff8h		;508b	21 f8 ff 	! . . 
	add hl,sp			;508e	39 	9 
	ld sp,hl			;508f	f9 	. 
	call sub_2f10h		;5090	cd 10 2f 	. . / 
	ld a,(VALTYP)		;5093	3a 63 f6 	: c . 
	push af			;5096	f5 	. 
	ld hl,(TEMP2)		;5097	2a bc f6 	* . . 
	ld a,(hl)			;509a	7e 	~ 
	cp 029h		;509b	fe 29 	. ) 
	jr z,l50adh		;509d	28 0e 	( . 
	rst 8			;509f	cf 	. 
	inc l			;50a0	2c 	, 
	push hl			;50a1	e5 	. 
	ld hl,(TEMP3)		;50a2	2a 9d f6 	* . . 
	rst 8			;50a5	cf 	. 
	inc l			;50a6	2c 	, 
	jr l5069h		;50a7	18 c0 	. . 
l50a9h:
	pop af			;50a9	f1 	. 
	ld (PRMLN2),a		;50aa	32 4e f7 	2 N . 
l50adh:
	pop af			;50ad	f1 	. 
	or a			;50ae	b7 	. 
	jr z,l50e9h		;50af	28 38 	( 8 
	ld (VALTYP),a		;50b1	32 63 f6 	2 c . 
	ld hl,0000h		;50b4	21 00 00 	! . . 
	add hl,sp			;50b7	39 	9 
	call l2f08h		;50b8	cd 08 2f 	. . / 
	ld hl,0008h		;50bb	21 08 00 	! . . 
	add hl,sp			;50be	39 	9 
	ld sp,hl			;50bf	f9 	. 
	pop de			;50c0	d1 	. 
	ld l,003h		;50c1	2e 03 	. . 
	dec de			;50c3	1b 	. 
	dec de			;50c4	1b 	. 
	dec de			;50c5	1b 	. 
	ld a,(VALTYP)		;50c6	3a 63 f6 	: c . 
	add a,l			;50c9	85 	. 
	ld b,a			;50ca	47 	G 
	ld a,(PRMLN2)		;50cb	3a 4e f7 	: N . 
	ld c,a			;50ce	4f 	O 
	add a,b			;50cf	80 	. 
	cp 064h		;50d0	fe 64 	. d 
	jp nc,l475ah		;50d2	d2 5a 47 	. Z G 
	push af			;50d5	f5 	. 
	ld a,l			;50d6	7d 	} 
	ld b,000h		;50d7	06 00 	. . 
	ld hl,PARM2		;50d9	21 50 f7 	! P . 
	add hl,bc			;50dc	09 	. 
	ld c,a			;50dd	4f 	O 
	call sub_518eh		;50de	cd 8e 51 	. . Q 
	ld bc,l50a9h		;50e1	01 a9 50 	. . P 
	push bc			;50e4	c5 	. 
	push bc			;50e5	c5 	. 
	jp l489eh		;50e6	c3 9e 48 	. . H 
l50e9h:
	ld hl,(TEMP2)		;50e9	2a bc f6 	* . . 
	rst 10h			;50ec	d7 	. 
	push hl			;50ed	e5 	. 
	ld hl,(TEMP3)		;50ee	2a 9d f6 	* . . 
	rst 8			;50f1	cf 	. 
	add hl,hl			;50f2	29 	) 
	ld a,0d5h		;50f3	3e d5 	> . 
	ld (TEMP3),hl		;50f5	22 9d f6 	" . . 
	ld a,(PRMLEN)		;50f8	3a e6 f6 	: . . 
	add a,004h		;50fb	c6 04 	. . 
	push af			;50fd	f5 	. 
	rrca			;50fe	0f 	. 
	ld c,a			;50ff	4f 	O 
	call sub_625eh		;5100	cd 5e 62 	. ^ b 
	pop af			;5103	f1 	. 
	ld c,a			;5104	4f 	O 
	cpl			;5105	2f 	/ 
	inc a			;5106	3c 	< 
	ld l,a			;5107	6f 	o 
	ld h,0ffh		;5108	26 ff 	& . 
	add hl,sp			;510a	39 	9 
	ld sp,hl			;510b	f9 	. 
	push hl			;510c	e5 	. 
	ld de,PRMSTK		;510d	11 e4 f6 	. . . 
	call sub_518eh		;5110	cd 8e 51 	. . Q 
	pop hl			;5113	e1 	. 
	ld (PRMSTK),hl		;5114	22 e4 f6 	" . . 
	ld hl,(PRMLN2)		;5117	2a 4e f7 	* N . 
	ld (PRMLEN),hl		;511a	22 e6 f6 	" . . 
	ld b,h			;511d	44 	D 
	ld c,l			;511e	4d 	M 
	ld hl,PARM1		;511f	21 e8 f6 	! . . 
	ld de,PARM2		;5122	11 50 f7 	. P . 
	call sub_518eh		;5125	cd 8e 51 	. . Q 
	ld h,a			;5128	67 	g 
	ld l,a			;5129	6f 	o 
	ld (PRMLN2),hl		;512a	22 4e f7 	" N . 
	ld hl,(FUNACT)		;512d	2a ba f7 	* . . 
	inc hl			;5130	23 	# 
	ld (FUNACT),hl		;5131	22 ba f7 	" . . 
	ld a,h			;5134	7c 	| 
	or l			;5135	b5 	. 
	ld (NOFUNS),a		;5136	32 b7 f7 	2 . . 
	ld hl,(TEMP3)		;5139	2a 9d f6 	* . . 
	call sub_4c5fh		;513c	cd 5f 4c 	. _ L 
	dec hl			;513f	2b 	+ 
	rst 10h			;5140	d7 	. 
	jp nz,l4055h		;5141	c2 55 40 	. U @ 
	rst 28h			;5144	ef 	. 
	jr nz,l5156h		;5145	20 0f 	  . 
	ld de,DSCTMP		;5147	11 98 f6 	. . . 
	ld hl,(0f7f8h)		;514a	2a f8 f7 	* . . 
	rst 20h			;514d	e7 	. 
	jr c,l5156h		;514e	38 06 	8 . 
	call sub_6611h		;5150	cd 11 66 	. . f 
	call 06658h		;5153	cd 58 66 	. X f 
l5156h:
	ld hl,(PRMSTK)		;5156	2a e4 f6 	* . . 
	ld d,h			;5159	54 	T 
	ld e,l			;515a	5d 	] 
	inc hl			;515b	23 	# 
	inc hl			;515c	23 	# 
	ld c,(hl)			;515d	4e 	N 
	inc hl			;515e	23 	# 
	ld b,(hl)			;515f	46 	F 
	inc bc			;5160	03 	. 
	inc bc			;5161	03 	. 
	inc bc			;5162	03 	. 
	inc bc			;5163	03 	. 
	ld hl,PRMSTK		;5164	21 e4 f6 	! . . 
	call sub_518eh		;5167	cd 8e 51 	. . Q 
	ex de,hl			;516a	eb 	. 
	ld sp,hl			;516b	f9 	. 
	ld hl,(FUNACT)		;516c	2a ba f7 	* . . 
	dec hl			;516f	2b 	+ 
	ld (FUNACT),hl		;5170	22 ba f7 	" . . 
	ld a,h			;5173	7c 	| 
	or l			;5174	b5 	. 
	ld (NOFUNS),a		;5175	32 b7 f7 	2 . . 
	pop hl			;5178	e1 	. 
	pop af			;5179	f1 	. 
sub_517ah:
	push hl			;517a	e5 	. 
	and 007h		;517b	e6 07 	. . 
	ld hl,l3d47h		;517d	21 47 3d 	! G = 
	ld c,a			;5180	4f 	O 
	ld b,000h		;5181	06 00 	. . 
	add hl,bc			;5183	09 	. 
	call sub_4f41h		;5184	cd 41 4f 	. A O 
	pop hl			;5187	e1 	. 
	ret			;5188	c9 	. 
l5189h:
	ld a,(de)			;5189	1a 	. 
	ld (hl),a			;518a	77 	w 
	inc hl			;518b	23 	# 
	inc de			;518c	13 	. 
	dec bc			;518d	0b 	. 
sub_518eh:
	ld a,b			;518e	78 	x 
	or c			;518f	b1 	. 
	jr nz,l5189h		;5190	20 f7 	  . 
	ret			;5192	c9 	. 
sub_5193h:
	push hl			;5193	e5 	. 
	ld hl,(CURLIN)		;5194	2a 1c f4 	* . . 
	inc hl			;5197	23 	# 
	ld a,h			;5198	7c 	| 
	or l			;5199	b5 	. 
	pop hl			;519a	e1 	. 
	ret nz			;519b	c0 	. 
	ld e,00ch		;519c	1e 0c 	. . 
	jp l406fh		;519e	c3 6f 40 	. o @ 
sub_51a1h:
	rst 8			;51a1	cf 	. 
	sbc a,03eh		;51a2	de 3e 	. > 
	add a,b			;51a4	80 	. 
	ld (SUBFLG),a		;51a5	32 a5 f6 	2 . . 
	or (hl)			;51a8	b6 	. 
	ld c,a			;51a9	4f 	O 
	jp l5ea9h		;51aa	c3 a9 5e 	. . ^ 
l51adh:
	cp 07eh		;51ad	fe 7e 	. ~ 
	jr nz,l51c6h		;51af	20 15 	  . 
	inc hl			;51b1	23 	# 
	ld a,(hl)			;51b2	7e 	~ 
	inc hl			;51b3	23 	# 
	cp 083h		;51b4	fe 83 	. . 
	jp z,l696eh		;51b6	ca 6e 69 	. n i 
	cp 0a3h		;51b9	fe a3 	. . 
	jp z,l77bfh		;51bb	ca bf 77 	. . w 
	cp 085h		;51be	fe 85 	. . 
	jp z,l77b1h		;51c0	ca b1 77 	. . w 
	call H.ISMI		;51c3	cd 7f ff 	.  . 
l51c6h:
	jp l4055h		;51c6	c3 55 40 	. U @ 
	call sub_521ch		;51c9	cd 1c 52 	. . R 
	call H.WIDT		;51cc	cd 84 ff 	. . . 
	and a			;51cf	a7 	. 
	ld ix,S.WIDTHS		;51d0	dd 21 5d 01 	. ! ] . 
	jp EXTROM		;51d4	c3 5f 01 	. _ . 
l51d7h:
	out (0a8h),a		;51d7	d3 a8 	. . 
	ld a,(hl)			;51d9	7e 	~ 
	cpl			;51da	2f 	/ 
	ld c,a			;51db	4f 	O 
	and 0fch		;51dc	e6 fc 	. . 
	or d			;51de	b2 	. 
	ld (hl),a			;51df	77 	w 
	ld a,e			;51e0	7b 	{ 
	and 03fh		;51e1	e6 3f 	. ? 
	ld d,a			;51e3	57 	W 
	ld a,b			;51e4	78 	x 
	and 0c0h		;51e5	e6 c0 	. . 
	or d			;51e7	b2 	. 
	out (0a8h),a		;51e8	d3 a8 	. . 
	exx			;51ea	d9 	. 
	ldir		;51eb	ed b0 	. . 
	exx			;51ed	d9 	. 
	ld a,e			;51ee	7b 	{ 
	out (0a8h),a		;51ef	d3 a8 	. . 
	ld a,c			;51f1	79 	y 
	ld (hl),a			;51f2	77 	w 
	ld a,b			;51f3	78 	x 
	out (0a8h),a		;51f4	d3 a8 	. . 
	ret			;51f6	c9 	. 
        ret                     ;51f7   c9      .
PTCPAL:
	ld a,050h		;51f8	3e 50 	> P 
	out (0aah),a		;51fa	d3 aa 	. . 
    IF INTHZ == 60
	ld a,000h		;51fc	3e 00 	> . 
    ELSE
	ld a,002h		;51fc	3e 02 	> . 
    ENDIF
	out (099h),a		;51fe	d3 99 	. . 
	ld a,089h		;5200	3e 89 	> . 
	out (099h),a		;5202	d3 99 	. . 
	jp PTCPAL2		;5204	c3 c0 7b 	. . { 
	nop			;5207	00 	. 
	nop			;5208	00 	. 
	nop			;5209	00 	. 
	nop			;520a	00 	. 
	nop			;520b	00 	. 
	nop			;520c	00 	. 
	ret			;520d	c9 	. 
sub_520eh:
	rst 10h			;520e	d7 	. 
sub_520fh:
	call sub_4c64h		;520f	cd 64 4c 	. d L 
sub_5212h:
	push hl			;5212	e5 	. 
	call sub_2f8ah		;5213	cd 8a 2f 	. . / 
	ex de,hl			;5216	eb 	. 
	pop hl			;5217	e1 	. 
	ld a,d			;5218	7a 	z 
	or a			;5219	b7 	. 
	ret			;521a	c9 	. 
sub_521bh:
	rst 10h			;521b	d7 	. 
sub_521ch:
	call sub_4c64h		;521c	cd 64 4c 	. d L 
sub_521fh:
	call sub_5212h		;521f	cd 12 52 	. . R 
	jp nz,l475ah		;5222	c2 5a 47 	. Z G 
	dec hl			;5225	2b 	+ 
	rst 10h			;5226	d7 	. 
	ld a,e			;5227	7b 	{ 
	ret			;5228	c9 	. 
	ld a,001h		;5229	3e 01 	> . 
	ld (PRTFLG),a		;522b	32 16 f4 	2 . . 
l522eh:
	call H.LIST		;522e	cd 89 ff 	. . . 
	pop bc			;5231	c1 	. 
	call sub_4279h		;5232	cd 79 42 	. y B 
	push bc			;5235	c5 	. 
l5236h:
	ld hl,0ffffh		;5236	21 ff ff 	! . . 
	ld (CURLIN),hl		;5239	22 1c f4 	" . . 
	pop hl			;523c	e1 	. 
	pop de			;523d	d1 	. 
	ld c,(hl)			;523e	4e 	N 
	inc hl			;523f	23 	# 
	ld b,(hl)			;5240	46 	F 
	inc hl			;5241	23 	# 
	ld a,b			;5242	78 	x 
	or c			;5243	b1 	. 
	jp z,l411fh		;5244	ca 1f 41 	. . A 
	call ISFLIO		;5247	cd 4a 01 	. J . 
	call z,ISCNTC		;524a	cc ba 00 	. . . 
	push bc			;524d	c5 	. 
	ld c,(hl)			;524e	4e 	N 
	inc hl			;524f	23 	# 
	ld b,(hl)			;5250	46 	F 
	inc hl			;5251	23 	# 
	push bc			;5252	c5 	. 
	ex (sp),hl			;5253	e3 	. 
	ex de,hl			;5254	eb 	. 
	rst 20h			;5255	e7 	. 
	pop bc			;5256	c1 	. 
	jp c,0411eh		;5257	da 1e 41 	. . A 
	ex (sp),hl			;525a	e3 	. 
	push hl			;525b	e5 	. 
	push bc			;525c	c5 	. 
	ex de,hl			;525d	eb 	. 
	ld (DOT),hl		;525e	22 b5 f6 	" . . 
	call sub_3412h		;5261	cd 12 34 	. . 4 
	pop hl			;5264	e1 	. 
	ld a,(hl)			;5265	7e 	~ 
	cp 009h		;5266	fe 09 	. . 
	jr z,l526dh		;5268	28 03 	( . 
	ld a,020h		;526a	3e 20 	>   
	rst 18h			;526c	df 	. 
l526dh:
	call sub_5284h		;526d	cd 84 52 	. . R 
	ld hl,BUF		;5270	21 5e f5 	! ^ . 
	call sub_527bh		;5273	cd 7b 52 	. { R 
	call sub_7328h		;5276	cd 28 73 	. ( s 
	jr l5236h		;5279	18 bb 	. . 
sub_527bh:
	ld a,(hl)			;527b	7e 	~ 
	or a			;527c	b7 	. 
	ret z			;527d	c8 	. 
	call sub_7367h		;527e	cd 67 73 	. g s 
	inc hl			;5281	23 	# 
	jr sub_527bh		;5282	18 f7 	. . 
sub_5284h:
	ld bc,BUF		;5284	01 5e f5 	. ^ . 
	ld d,0ffh		;5287	16 ff 	. . 
	xor a			;5289	af 	. 
	ld (DORES),a		;528a	32 64 f6 	2 d . 
	jr l5293h		;528d	18 04 	. . 
l528fh:
	inc bc			;528f	03 	. 
	inc hl			;5290	23 	# 
	dec d			;5291	15 	. 
	ret z			;5292	c8 	. 
l5293h:
	ld a,(hl)			;5293	7e 	~ 
	or a			;5294	b7 	. 
	ld (bc),a			;5295	02 	. 
	ret z			;5296	c8 	. 
	cp 00bh		;5297	fe 0b 	. . 
	jr c,l52c0h		;5299	38 25 	8 % 
	cp 020h		;529b	fe 20 	.   
	jp c,l5361h		;529d	da 61 53 	. a S 
	cp 022h		;52a0	fe 22 	. " 
	jr nz,l52aeh		;52a2	20 0a 	  . 
	ld a,(DORES)		;52a4	3a 64 f6 	: d . 
	xor 001h		;52a7	ee 01 	. . 
	ld (DORES),a		;52a9	32 64 f6 	2 d . 
	ld a,022h		;52ac	3e 22 	> " 
l52aeh:
	cp 03ah		;52ae	fe 3a 	. : 
	jr nz,l52c0h		;52b0	20 0e 	  . 
	ld a,(DORES)		;52b2	3a 64 f6 	: d . 
	rra			;52b5	1f 	. 
	jr c,l52beh		;52b6	38 06 	8 . 
	rla			;52b8	17 	. 
	and 0fdh		;52b9	e6 fd 	. . 
	ld (DORES),a		;52bb	32 64 f6 	2 d . 
l52beh:
	ld a,03ah		;52be	3e 3a 	> : 
l52c0h:
	or a			;52c0	b7 	. 
	jp p,l528fh		;52c1	f2 8f 52 	. . R 
	ld a,(DORES)		;52c4	3a 64 f6 	: d . 
	rra			;52c7	1f 	. 
	jr c,l52f8h		;52c8	38 2e 	8 . 
	rra			;52ca	1f 	. 
	rra			;52cb	1f 	. 
	jr nc,l530ch		;52cc	30 3e 	0 > 
	ld a,(hl)			;52ce	7e 	~ 
	cp 0e6h		;52cf	fe e6 	. . 
	push hl			;52d1	e5 	. 
	push bc			;52d2	c5 	. 
	ld hl,l52f5h		;52d3	21 f5 52 	! . R 
	push hl			;52d6	e5 	. 
	ret nz			;52d7	c0 	. 
	dec bc			;52d8	0b 	. 
	ld a,(bc)			;52d9	0a 	. 
	cp 04dh		;52da	fe 4d 	. M 
	ret nz			;52dc	c0 	. 
	dec bc			;52dd	0b 	. 
	ld a,(bc)			;52de	0a 	. 
	cp 045h		;52df	fe 45 	. E 
	ret nz			;52e1	c0 	. 
	dec bc			;52e2	0b 	. 
	ld a,(bc)			;52e3	0a 	. 
	cp 052h		;52e4	fe 52 	. R 
	ret nz			;52e6	c0 	. 
	dec bc			;52e7	0b 	. 
	ld a,(bc)			;52e8	0a 	. 
	cp 03ah		;52e9	fe 3a 	. : 
	ret nz			;52eb	c0 	. 
	pop af			;52ec	f1 	. 
	pop af			;52ed	f1 	. 
	pop hl			;52ee	e1 	. 
	inc d			;52ef	14 	. 
	inc d			;52f0	14 	. 
	inc d			;52f1	14 	. 
	inc d			;52f2	14 	. 
	jr l531ah		;52f3	18 25 	. % 
l52f5h:
	pop bc			;52f5	c1 	. 
	pop hl			;52f6	e1 	. 
	ld a,(hl)			;52f7	7e 	~ 
l52f8h:
	jp l528fh		;52f8	c3 8f 52 	. . R 
sub_52fbh:
	ld a,(DORES)		;52fb	3a 64 f6 	: d . 
	or 002h		;52fe	f6 02 	. . 
l5300h:
	ld (DORES),a		;5300	32 64 f6 	2 d . 
	xor a			;5303	af 	. 
	ret			;5304	c9 	. 
sub_5305h:
	ld a,(DORES)		;5305	3a 64 f6 	: d . 
	or 004h		;5308	f6 04 	. . 
	jr l5300h		;530a	18 f4 	. . 
l530ch:
	rla			;530c	17 	. 
	jr c,l52f8h		;530d	38 e9 	8 . 
	ld a,(hl)			;530f	7e 	~ 
	cp 084h		;5310	fe 84 	. . 
	call z,sub_52fbh		;5312	cc fb 52 	. . R 
	cp 08fh		;5315	fe 8f 	. . 
	call z,sub_5305h		;5317	cc 05 53 	. . S 
l531ah:
	ld a,(hl)			;531a	7e 	~ 
	inc a			;531b	3c 	< 
	ld a,(hl)			;531c	7e 	~ 
	jr nz,l5323h		;531d	20 04 	  . 
	inc hl			;531f	23 	# 
	ld a,(hl)			;5320	7e 	~ 
	and 07fh		;5321	e6 7f 	.  
l5323h:
	inc hl			;5323	23 	# 
	cp 0a1h		;5324	fe a1 	. . 
	jr nz,l532ah		;5326	20 02 	  . 
	dec bc			;5328	0b 	. 
	inc d			;5329	14 	. 
l532ah:
	push hl			;532a	e5 	. 
	push bc			;532b	c5 	. 
	push de			;532c	d5 	. 
	call H.BUFL		;532d	cd 8e ff 	. . . 
	ld hl,03a71h		;5330	21 71 3a 	! q : 
	ld b,a			;5333	47 	G 
	ld c,040h		;5334	0e 40 	. @ 
l5336h:
	inc c			;5336	0c 	. 
l5337h:
	inc hl			;5337	23 	# 
	ld d,h			;5338	54 	T 
	ld e,l			;5339	5d 	] 
l533ah:
	ld a,(hl)			;533a	7e 	~ 
	or a			;533b	b7 	. 
	jr z,l5336h		;533c	28 f8 	( . 
	inc hl			;533e	23 	# 
	jp p,l533ah		;533f	f2 3a 53 	. : S 
	ld a,(hl)			;5342	7e 	~ 
	cp b			;5343	b8 	. 
	jr nz,l5337h		;5344	20 f1 	  . 
	ex de,hl			;5346	eb 	. 
	ld a,c			;5347	79 	y 
	pop de			;5348	d1 	. 
	pop bc			;5349	c1 	. 
	cp 05bh		;534a	fe 5b 	. [ 
	jr nz,l5350h		;534c	20 02 	  . 
l534eh:
	ld a,(hl)			;534e	7e 	~ 
	inc hl			;534f	23 	# 
l5350h:
	ld e,a			;5350	5f 	_ 
	and 07fh		;5351	e6 7f 	.  
	ld (bc),a			;5353	02 	. 
	inc bc			;5354	03 	. 
	dec d			;5355	15 	. 
	jp z,l66a7h		;5356	ca a7 66 	. . f 
	or e			;5359	b3 	. 
	jp p,l534eh		;535a	f2 4e 53 	. N S 
	pop hl			;535d	e1 	. 
	jp l5293h		;535e	c3 93 52 	. . R 
l5361h:
	dec hl			;5361	2b 	+ 
	rst 10h			;5362	d7 	. 
	push de			;5363	d5 	. 
	push bc			;5364	c5 	. 
	push af			;5365	f5 	. 
	call sub_46e8h		;5366	cd e8 46 	. . F 
	pop af			;5369	f1 	. 
	ld bc,l537eh		;536a	01 7e 53 	. ~ S 
	push bc			;536d	c5 	. 
	cp 00bh		;536e	fe 0b 	. . 
	jp z,l371eh		;5370	ca 1e 37 	. . 7 
	cp 00ch		;5373	fe 0c 	. . 
	jp z,l3722h		;5375	ca 22 37 	. " 7 
	ld hl,(CONLO)		;5378	2a 6a f6 	* j . 
	jp sub_3425h		;537b	c3 25 34 	. % 4 
l537eh:
	pop bc			;537e	c1 	. 
	pop de			;537f	d1 	. 
	ld a,(CONSAV)		;5380	3a 68 f6 	: h . 
	ld e,04fh		;5383	1e 4f 	. O 
	cp 00bh		;5385	fe 0b 	. . 
	jr z,l538fh		;5387	28 06 	( . 
	cp 00ch		;5389	fe 0c 	. . 
	ld e,048h		;538b	1e 48 	. H 
	jr nz,l539ah		;538d	20 0b 	  . 
l538fh:
	ld a,026h		;538f	3e 26 	> & 
	ld (bc),a			;5391	02 	. 
	inc bc			;5392	03 	. 
	dec d			;5393	15 	. 
	ret z			;5394	c8 	. 
	ld a,e			;5395	7b 	{ 
	ld (bc),a			;5396	02 	. 
	inc bc			;5397	03 	. 
	dec d			;5398	15 	. 
	ret z			;5399	c8 	. 
l539ah:
	ld a,(CONTYP)		;539a	3a 69 f6 	: i . 
	cp 004h		;539d	fe 04 	. . 
	ld e,000h		;539f	1e 00 	. . 
	jr c,l53a9h		;53a1	38 06 	8 . 
	ld e,021h		;53a3	1e 21 	. ! 
	jr z,l53a9h		;53a5	28 02 	( . 
	ld e,023h		;53a7	1e 23 	. # 
l53a9h:
	ld a,(hl)			;53a9	7e 	~ 
	cp 020h		;53aa	fe 20 	.   
	jr nz,l53afh		;53ac	20 01 	  . 
	inc hl			;53ae	23 	# 
l53afh:
	ld a,(hl)			;53af	7e 	~ 
	inc hl			;53b0	23 	# 
	or a			;53b1	b7 	. 
	jr z,l53d4h		;53b2	28 20 	(   
	ld (bc),a			;53b4	02 	. 
	inc bc			;53b5	03 	. 
	dec d			;53b6	15 	. 
	ret z			;53b7	c8 	. 
	ld a,(CONTYP)		;53b8	3a 69 f6 	: i . 
	cp 004h		;53bb	fe 04 	. . 
	jr c,l53afh		;53bd	38 f0 	8 . 
	dec bc			;53bf	0b 	. 
	ld a,(bc)			;53c0	0a 	. 
	inc bc			;53c1	03 	. 
	jr nz,l53c8h		;53c2	20 04 	  . 
	cp 02eh		;53c4	fe 2e 	. . 
	jr z,l53d0h		;53c6	28 08 	( . 
l53c8h:
	cp 044h		;53c8	fe 44 	. D 
	jr z,l53d0h		;53ca	28 04 	( . 
	cp 045h		;53cc	fe 45 	. E 
	jr nz,l53afh		;53ce	20 df 	  . 
l53d0h:
	ld e,000h		;53d0	1e 00 	. . 
	jr l53afh		;53d2	18 db 	. . 
l53d4h:
	ld a,e			;53d4	7b 	{ 
	or a			;53d5	b7 	. 
	jr z,l53dch		;53d6	28 04 	( . 
	ld (bc),a			;53d8	02 	. 
	inc bc			;53d9	03 	. 
	dec d			;53da	15 	. 
	ret z			;53db	c8 	. 
l53dch:
	ld hl,(CONTXT)		;53dc	2a 66 f6 	* f . 
	jp l5293h		;53df	c3 93 52 	. . R 
	call sub_4279h		;53e2	cd 79 42 	. y B 
	push bc			;53e5	c5 	. 
	call sub_54eah		;53e6	cd ea 54 	. . T 
	pop bc			;53e9	c1 	. 
	pop de			;53ea	d1 	. 
	push bc			;53eb	c5 	. 
	push bc			;53ec	c5 	. 
	call sub_4295h		;53ed	cd 95 42 	. . B 
	jr nc,l53f7h		;53f0	30 05 	0 . 
	ld d,h			;53f2	54 	T 
	ld e,l			;53f3	5d 	] 
	ex (sp),hl			;53f4	e3 	. 
	push hl			;53f5	e5 	. 
	rst 20h			;53f6	e7 	. 
l53f7h:
	jp nc,l475ah		;53f7	d2 5a 47 	. Z G 
	ld hl,l3fd7h		;53fa	21 d7 3f 	! . ? 
	call sub_7be8h		;53fd	cd e8 7b 	. . { 
	pop bc			;5400	c1 	. 
	ld hl,l4237h		;5401	21 37 42 	! 7 B 
	ex (sp),hl			;5404	e3 	. 
sub_5405h:
	ex de,hl			;5405	eb 	. 
	ld hl,(VARTAB)		;5406	2a c2 f6 	* . . 
l5409h:
	ld a,(de)			;5409	1a 	. 
	ld (bc),a			;540a	02 	. 
	inc bc			;540b	03 	. 
	inc de			;540c	13 	. 
	rst 20h			;540d	e7 	. 
	jr nz,l5409h		;540e	20 f9 	  . 
	ld h,b			;5410	60 	` 
	ld l,c			;5411	69 	i 
	ld (VARTAB),hl		;5412	22 c2 f6 	" . . 
	ld (ARYTAB),hl		;5415	22 c4 f6 	" . . 
	ld (STREND),hl		;5418	22 c6 f6 	" . . 
	ret			;541b	c9 	. 
	call sub_5439h		;541c	cd 39 54 	. 9 T 
	ld a,(hl)			;541f	7e 	~ 
	jp l4fcfh		;5420	c3 cf 4f 	. . O 
	call sub_542fh		;5423	cd 2f 54 	. / T 
	push de			;5426	d5 	. 
	rst 8			;5427	cf 	. 
	inc l			;5428	2c 	, 
	call sub_521ch		;5429	cd 1c 52 	. . R 
	pop de			;542c	d1 	. 
	ld (de),a			;542d	12 	. 
	ret			;542e	c9 	. 
sub_542fh:
	call sub_4c64h		;542f	cd 64 4c 	. d L 
	push hl			;5432	e5 	. 
	call sub_5439h		;5433	cd 39 54 	. 9 T 
	ex de,hl			;5436	eb 	. 
	pop hl			;5437	e1 	. 
	ret			;5438	c9 	. 
sub_5439h:
	ld bc,sub_2f8ah		;5439	01 8a 2f 	. . / 
	push bc			;543c	c5 	. 
	rst 28h			;543d	ef 	. 
	ret m			;543e	f8 	. 
	call H.MDTM		;543f	cd 93 ff 	. . . 
	call BAS_SIGN		;5442	cd 71 2e 	. q . 
	ret m			;5445	f8 	. 
	call sub_2fb2h		;5446	cd b2 2f 	. . / 
	ld bc,l3245h		;5449	01 45 32 	. E 2 
	ld de,08076h		;544c	11 76 80 	. v . 
	call sub_2f21h		;544f	cd 21 2f 	. ! / 
	ret c			;5452	d8 	. 
	ld bc,l6545h		;5453	01 45 65 	. E e 
	ld de,l6053h		;5456	11 53 60 	. S ` 
	call sub_2f21h		;5459	cd 21 2f 	. ! / 
	jp nc,04067h		;545c	d2 67 40 	. g @ 
	ld bc,l65c5h		;545f	01 c5 65 	. . e 
	ld de,l6053h		;5462	11 53 60 	. S ` 
	jp l324eh		;5465	c3 4e 32 	. N 2 
	ld bc,000ah		;5468	01 0a 00 	. . . 
	push bc			;546b	c5 	. 
	ld d,b			;546c	50 	P 
	ld e,b			;546d	58 	X 
	jr z,l5496h		;546e	28 26 	( & 
	cp 02ch		;5470	fe 2c 	. , 
	jr z,l547dh		;5472	28 09 	( . 
	push de			;5474	d5 	. 
	call sub_475fh		;5475	cd 5f 47 	. _ G 
	ld b,d			;5478	42 	B 
	ld c,e			;5479	4b 	K 
	pop de			;547a	d1 	. 
	jr z,l5496h		;547b	28 19 	( . 
l547dh:
	rst 8			;547d	cf 	. 
	inc l			;547e	2c 	, 
	call sub_475fh		;547f	cd 5f 47 	. _ G 
	jr z,l5496h		;5482	28 12 	( . 
	pop af			;5484	f1 	. 
	rst 8			;5485	cf 	. 
	inc l			;5486	2c 	, 
	push de			;5487	d5 	. 
	call sub_4769h		;5488	cd 69 47 	. i G 
	jp nz,l4055h		;548b	c2 55 40 	. U @ 
	ld a,d			;548e	7a 	z 
	or e			;548f	b3 	. 
	jp z,l475ah		;5490	ca 5a 47 	. Z G 
	ex de,hl			;5493	eb 	. 
	ex (sp),hl			;5494	e3 	. 
	ex de,hl			;5495	eb 	. 
l5496h:
	push bc			;5496	c5 	. 
	call sub_4295h		;5497	cd 95 42 	. . B 
	pop de			;549a	d1 	. 
	push de			;549b	d5 	. 
	push bc			;549c	c5 	. 
	call sub_4295h		;549d	cd 95 42 	. . B 
	ld h,b			;54a0	60 	` 
	ld l,c			;54a1	69 	i 
	pop de			;54a2	d1 	. 
	rst 20h			;54a3	e7 	. 
	ex de,hl			;54a4	eb 	. 
	jp c,l475ah		;54a5	da 5a 47 	. Z G 
	pop de			;54a8	d1 	. 
	pop bc			;54a9	c1 	. 
	pop af			;54aa	f1 	. 
	push hl			;54ab	e5 	. 
	push de			;54ac	d5 	. 
	jr l54bdh		;54ad	18 0e 	. . 
l54afh:
	add hl,bc			;54af	09 	. 
	jp c,l475ah		;54b0	da 5a 47 	. Z G 
	ex de,hl			;54b3	eb 	. 
	push hl			;54b4	e5 	. 
	ld hl,0fff9h		;54b5	21 f9 ff 	! . . 
	rst 20h			;54b8	e7 	. 
	pop hl			;54b9	e1 	. 
	jp c,l475ah		;54ba	da 5a 47 	. Z G 
l54bdh:
	push de			;54bd	d5 	. 
	ld e,(hl)			;54be	5e 	^ 
	inc hl			;54bf	23 	# 
	ld d,(hl)			;54c0	56 	V 
	ld a,d			;54c1	7a 	z 
	or e			;54c2	b3 	. 
	ex de,hl			;54c3	eb 	. 
	pop de			;54c4	d1 	. 
	jr z,l54ceh		;54c5	28 07 	( . 
	ld a,(hl)			;54c7	7e 	~ 
	inc hl			;54c8	23 	# 
	or (hl)			;54c9	b6 	. 
	dec hl			;54ca	2b 	+ 
	ex de,hl			;54cb	eb 	. 
	jr nz,l54afh		;54cc	20 e1 	  . 
l54ceh:
	push bc			;54ce	c5 	. 
	call 054f6h		;54cf	cd f6 54 	. . T 
	pop bc			;54d2	c1 	. 
	pop de			;54d3	d1 	. 
	pop hl			;54d4	e1 	. 
l54d5h:
	push de			;54d5	d5 	. 
	ld e,(hl)			;54d6	5e 	^ 
	inc hl			;54d7	23 	# 
	ld d,(hl)			;54d8	56 	V 
	ld a,d			;54d9	7a 	z 
	or e			;54da	b3 	. 
	jr z,l54f1h		;54db	28 14 	( . 
	ex de,hl			;54dd	eb 	. 
	ex (sp),hl			;54de	e3 	. 
	ex de,hl			;54df	eb 	. 
	inc hl			;54e0	23 	# 
	ld (hl),e			;54e1	73 	s 
	inc hl			;54e2	23 	# 
	ld (hl),d			;54e3	72 	r 
	ex de,hl			;54e4	eb 	. 
	add hl,bc			;54e5	09 	. 
	ex de,hl			;54e6	eb 	. 
	pop hl			;54e7	e1 	. 
	jr l54d5h		;54e8	18 eb 	. . 
sub_54eah:
	ld a,(PTRFLG)		;54ea	3a a9 f6 	: . . 
	or a			;54ed	b7 	. 
	ret z			;54ee	c8 	. 
	jr l54f7h		;54ef	18 06 	. . 
l54f1h:
	ld bc,0411eh		;54f1	01 1e 41 	. . A 
	push bc			;54f4	c5 	. 
	cp 0f6h		;54f5	fe f6 	. . 
l54f7h:
	xor a			;54f7	af 	. 
	ld (PTRFLG),a		;54f8	32 a9 f6 	2 . . 
	ld hl,(TXTTAB)		;54fb	2a 76 f6 	* v . 
	dec hl			;54fe	2b 	+ 
l54ffh:
	inc hl			;54ff	23 	# 
	ld a,(hl)			;5500	7e 	~ 
	inc hl			;5501	23 	# 
	or (hl)			;5502	b6 	. 
	ret z			;5503	c8 	. 
	inc hl			;5504	23 	# 
	ld e,(hl)			;5505	5e 	^ 
	inc hl			;5506	23 	# 
	ld d,(hl)			;5507	56 	V 
l5508h:
	rst 10h			;5508	d7 	. 
l5509h:
	or a			;5509	b7 	. 
	jr z,l54ffh		;550a	28 f3 	( . 
	ld c,a			;550c	4f 	O 
	ld a,(PTRFLG)		;550d	3a a9 f6 	: . . 
	or a			;5510	b7 	. 
	ld a,c			;5511	79 	y 
	jr z,l556ah		;5512	28 56 	( V 
	call H.SCNE		;5514	cd 98 ff 	. . . 
	cp 0a6h		;5517	fe a6 	. . 
	jr nz,l552fh		;5519	20 14 	  . 
	rst 10h			;551b	d7 	. 
	cp 089h		;551c	fe 89 	. . 
	jr nz,l5509h		;551e	20 e9 	  . 
	rst 10h			;5520	d7 	. 
	cp 00eh		;5521	fe 0e 	. . 
	jr nz,l5509h		;5523	20 e4 	  . 
	push de			;5525	d5 	. 
	call l4771h		;5526	cd 71 47 	. q G 
	ld a,d			;5529	7a 	z 
	or e			;552a	b3 	. 
	jr nz,l5537h		;552b	20 0a 	  . 
	jr l5556h		;552d	18 27 	. ' 
l552fh:
	cp 00eh		;552f	fe 0e 	. . 
	jr nz,l5508h		;5531	20 d5 	  . 
	push de			;5533	d5 	. 
	call l4771h		;5534	cd 71 47 	. q G 
l5537h:
	push hl			;5537	e5 	. 
	call sub_4295h		;5538	cd 95 42 	. . B 
	dec bc			;553b	0b 	. 
	ld a,00dh		;553c	3e 0d 	> . 
	jr c,l557ch		;553e	38 3c 	8 < 
	call sub_7323h		;5540	cd 23 73 	. # s 
	ld hl,l555ah		;5543	21 5a 55 	! Z U 
	push de			;5546	d5 	. 
	call sub_6678h		;5547	cd 78 66 	. x f 
	pop hl			;554a	e1 	. 
	call sub_3412h		;554b	cd 12 34 	. . 4 
	pop bc			;554e	c1 	. 
	pop hl			;554f	e1 	. 
	push hl			;5550	e5 	. 
	push bc			;5551	c5 	. 
	call sub_340ah		;5552	cd 0a 34 	. . 4 
l5555h:
	pop hl			;5555	e1 	. 
l5556h:
	pop de			;5556	d1 	. 
	dec hl			;5557	2b 	+ 
l5558h:
	jr l5508h		;5558	18 ae 	. . 
l555ah:
	ld d,l			;555a	55 	U 
	ld l,(hl)			;555b	6e 	n 
	ld h,h			;555c	64 	d 
	ld h,l			;555d	65 	e 
	ld h,(hl)			;555e	66 	f 
	ld l,c			;555f	69 	i 
	ld l,(hl)			;5560	6e 	n 
	ld h,l			;5561	65 	e 
	ld h,h			;5562	64 	d 
	jr nz,l55d1h		;5563	20 6c 	  l 
	ld l,c			;5565	69 	i 
	ld l,(hl)			;5566	6e 	n 
	ld h,l			;5567	65 	e 
	jr nz,l556ah		;5568	20 00 	  . 
l556ah:
	cp 00dh		;556a	fe 0d 	. . 
	jr nz,l5558h		;556c	20 ea 	  . 
	push de			;556e	d5 	. 
	call l4771h		;556f	cd 71 47 	. q G 
	push hl			;5572	e5 	. 
	ex de,hl			;5573	eb 	. 
	inc hl			;5574	23 	# 
	inc hl			;5575	23 	# 
	inc hl			;5576	23 	# 
	ld c,(hl)			;5577	4e 	N 
	inc hl			;5578	23 	# 
	ld b,(hl)			;5579	46 	F 
	ld a,00eh		;557a	3e 0e 	> . 
l557ch:
	ld hl,l5555h		;557c	21 55 55 	! U U 
	push hl			;557f	e5 	. 
	ld hl,(CONTXT)		;5580	2a 66 f6 	* f . 
sub_5583h:
	push hl			;5583	e5 	. 
	dec hl			;5584	2b 	+ 
	ld (hl),b			;5585	70 	p 
	dec hl			;5586	2b 	+ 
	ld (hl),c			;5587	71 	q 
	dec hl			;5588	2b 	+ 
	ld (hl),a			;5589	77 	w 
	pop hl			;558a	e1 	. 
	ret			;558b	c9 	. 
l558ch:
	ld a,(hl)			;558c	7e 	~ 
	ex (sp),hl			;558d	e3 	. 
	cp (hl)			;558e	be 	. 
	inc hl			;558f	23 	# 
	ex (sp),hl			;5590	e3 	. 
l5591h:
	jp nz,l4055h		;5591	c2 55 40 	. U @ 
	jp l4666h		;5594	c3 66 46 	. f F 
l5597h:
	ld a,(VALTYP)		;5597	3a 63 f6 	: c . 
	cp 008h		;559a	fe 08 	. . 
	jr nc,l55a3h		;559c	30 05 	0 . 
	sub 003h		;559e	d6 03 	. . 
	or a			;55a0	b7 	. 
	scf			;55a1	37 	7 
	ret			;55a2	c9 	. 
l55a3h:
	sub 003h		;55a3	d6 03 	. . 
	or a			;55a5	b7 	. 
	ret			;55a6	c9 	. 
l55a7h:
	rst 10h			;55a7	d7 	. 
	ld de,PROCNM		;55a8	11 89 fd 	. . . 
	ld b,00fh		;55ab	06 0f 	. . 
l55adh:
	ld a,(hl)			;55ad	7e 	~ 
	and a			;55ae	a7 	. 
	jr z,l55beh		;55af	28 0d 	( . 
	cp 03ah		;55b1	fe 3a 	. : 
	jr z,l55beh		;55b3	28 09 	( . 
	cp 028h		;55b5	fe 28 	. ( 
	jr z,l55beh		;55b7	28 05 	( . 
	ld (de),a			;55b9	12 	. 
	inc de			;55ba	13 	. 
	inc hl			;55bb	23 	# 
	djnz l55adh		;55bc	10 ef 	. . 
l55beh:
	ld a,b			;55be	78 	x 
	cp 00fh		;55bf	fe 0f 	. . 
	jr z,l55d8h		;55c1	28 15 	( . 
l55c3h:
	xor a			;55c3	af 	. 
	ld (de),a			;55c4	12 	. 
	dec de			;55c5	1b 	. 
	ld a,(de)			;55c6	1a 	. 
	cp 020h		;55c7	fe 20 	.   
	jr z,l55c3h		;55c9	28 f8 	( . 
	ld b,040h		;55cb	06 40 	. @ 
	ld de,SLTATR		;55cd	11 c9 fc 	. . . 
l55d0h:
	ld a,(de)			;55d0	1a 	. 
l55d1h:
	and 020h		;55d1	e6 20 	.   
	jr nz,l55dbh		;55d3	20 06 	  . 
l55d5h:
	inc de			;55d5	13 	. 
	djnz l55d0h		;55d6	10 f8 	. . 
l55d8h:
	jp l4055h		;55d8	c3 55 40 	. U @ 
l55dbh:
	push bc			;55db	c5 	. 
	push de			;55dc	d5 	. 
	push hl			;55dd	e5 	. 
	call sub_7e2ah		;55de	cd 2a 7e 	. * ~ 
	push af			;55e1	f5 	. 
	ld c,a			;55e2	4f 	O 
	ld l,004h		;55e3	2e 04 	. . 
	call sub_7e1ah		;55e5	cd 1a 7e 	. . ~ 
	push de			;55e8	d5 	. 
	pop ix		;55e9	dd e1 	. . 
	pop iy		;55eb	fd e1 	. . 
	pop hl			;55ed	e1 	. 
	dec hl			;55ee	2b 	+ 
	rst 10h			;55ef	d7 	. 
	call CALSLT2		;55f0	cd 1c 00 	. . . 
	pop de			;55f3	d1 	. 
	pop bc			;55f4	c1 	. 
	jr c,l55d5h		;55f5	38 de 	8 . 
	ret			;55f7	c9 	. 
l55f8h:
	pop hl			;55f8	e1 	. 
	ld a,b			;55f9	78 	x 
	cp 010h		;55fa	fe 10 	. . 
	jr c,l5600h		;55fc	38 02 	8 . 
	ld b,00fh		;55fe	06 0f 	. . 
l5600h:
	call CHKEMPTYDEVNAME	;5600	cd b7 7f 	. .  
l5603h:
	call sub_4ea9h		;5603	cd a9 4e 	. . N 
	ld (de),a			;5606	12 	. 
	inc hl			;5607	23 	# 
	inc de			;5608	13 	. 
	djnz l5603h		;5609	10 f8 	. . 
	xor a			;560b	af 	. 
	ld (de),a			;560c	12 	. 
	ld b,040h		;560d	06 40 	. @ 
	ld de,SLTATR		;560f	11 c9 fc 	. . . 
l5612h:
	ld a,(de)			;5612	1a 	. 
	and 040h		;5613	e6 40 	. @ 
	jr nz,l561dh		;5615	20 06 	  . 
l5617h:
	inc de			;5617	13 	. 
	djnz l5612h		;5618	10 f8 	. . 
l561ah:
	jp l6e6bh		;561a	c3 6b 6e 	. k n 
l561dh:
	push bc			;561d	c5 	. 
	push de			;561e	d5 	. 
	call sub_7e2ah		;561f	cd 2a 7e 	. * ~ 
	push af			;5622	f5 	. 
	ld c,a			;5623	4f 	O 
	ld l,006h		;5624	2e 06 	. . 
	call sub_7e1ah		;5626	cd 1a 7e 	. . ~ 
	push de			;5629	d5 	. 
	pop ix		;562a	dd e1 	. . 
	pop iy		;562c	fd e1 	. . 
	ld a,0ffh		;562e	3e ff 	> . 
	call CALSLT		;5630	cd 1c 00 	. . . 
	pop de			;5633	d1 	. 
	pop bc			;5634	c1 	. 
	jr c,l5617h		;5635	38 e0 	8 . 
	ld c,a			;5637	4f 	O 
	ld a,040h		;5638	3e 40 	> @ 
	sub b			;563a	90 	. 
	add a,a			;563b	87 	. 
	add a,a			;563c	87 	. 
	or c			;563d	b1 	. 
	cp 009h		;563e	fe 09 	. . 
	jr c,l561ah		;5640	38 d8 	8 . 
	cp 0fch		;5642	fe fc 	. . 
	jr nc,l561ah		;5644	30 d4 	0 . 
	pop hl			;5646	e1 	. 
	pop de			;5647	d1 	. 
	and a			;5648	a7 	. 
	ret			;5649	c9 	. 
l564ah:
	push bc			;564a	c5 	. 
	push af			;564b	f5 	. 
	rra			;564c	1f 	. 
	rra			;564d	1f 	. 
	and 03fh		;564e	e6 3f 	. ? 
	call sub_7e2dh		;5650	cd 2d 7e 	. - ~ 
	push af			;5653	f5 	. 
	ld c,a			;5654	4f 	O 
	ld l,006h		;5655	2e 06 	. . 
	call sub_7e1ah		;5657	cd 1a 7e 	. . ~ 
	push de			;565a	d5 	. 
	pop ix		;565b	dd e1 	. . 
	pop iy		;565d	fd e1 	. . 
	pop af			;565f	f1 	. 
	and 003h		;5660	e6 03 	. . 
	ld (DEVICE),a		;5662	32 99 fd 	2 . . 
	pop bc			;5665	c1 	. 
	pop af			;5666	f1 	. 
	pop de			;5667	d1 	. 
	pop hl			;5668	e1 	. 
	jp CALSLT		;5669	c3 1c 00 	. . . 
l566ch:
	ld (MCLTAB),de		;566c	ed 53 56 f9 	. S V . 
	call sub_4c64h		;5670	cd 64 4c 	. d L 
	push hl			;5673	e5 	. 
	ld de,0000h		;5674	11 00 00 	. . . 
	push de			;5677	d5 	. 
	push af			;5678	f5 	. 
l5679h:
	call sub_67d0h		;5679	cd d0 67 	. . g 
	call sub_2edfh		;567c	cd df 2e 	. . . 
	ld b,c			;567f	41 	A 
	ld c,d			;5680	4a 	J 
	ld d,e			;5681	53 	S 
	ld a,b			;5682	78 	x 
	or c			;5683	b1 	. 
	jr z,l568ch		;5684	28 06 	( . 
	ld a,d			;5686	7a 	z 
	or a			;5687	b7 	. 
	jr z,l568ch		;5688	28 02 	( . 
	push bc			;568a	c5 	. 
	push de			;568b	d5 	. 
l568ch:
	pop af			;568c	f1 	. 
	ld (MCLLEN),a		;568d	32 3b fb 	2 ; . 
	pop hl			;5690	e1 	. 
	ld a,h			;5691	7c 	| 
	or l			;5692	b5 	. 
	jr nz,l569fh		;5693	20 0a 	  . 
	ld a,(MCLFLG)		;5695	3a 58 f9 	: X . 
	or a			;5698	b7 	. 
	jp z,l5709h		;5699	ca 09 57 	. . W 
	jp l7494h		;569c	c3 94 74 	. . t 
l569fh:
	ld (MCLPTR),hl		;569f	22 3c fb 	" < . 
l56a2h:
	call sub_56eeh		;56a2	cd ee 56 	. . V 
	jr z,l568ch		;56a5	28 e5 	( . 
	add a,a			;56a7	87 	. 
	ld c,a			;56a8	4f 	O 
	ld hl,(MCLTAB)		;56a9	2a 56 f9 	* V . 
l56ach:
	ld a,(hl)			;56ac	7e 	~ 
	add a,a			;56ad	87 	. 
l56aeh:
	call z,l475ah		;56ae	cc 5a 47 	. Z G 
	cp c			;56b1	b9 	. 
	jr z,l56b9h		;56b2	28 05 	( . 
	inc hl			;56b4	23 	# 
	inc hl			;56b5	23 	# 
	inc hl			;56b6	23 	# 
	jr l56ach		;56b7	18 f3 	. . 
l56b9h:
	ld bc,l56a2h		;56b9	01 a2 56 	. . V 
	push bc			;56bc	c5 	. 
	ld a,(hl)			;56bd	7e 	~ 
	ld c,a			;56be	4f 	O 
	add a,a			;56bf	87 	. 
	jr nc,l56e2h		;56c0	30 20 	0   
	or a			;56c2	b7 	. 
	rra			;56c3	1f 	. 
	ld c,a			;56c4	4f 	O 
	push bc			;56c5	c5 	. 
	push hl			;56c6	e5 	. 
	call sub_56eeh		;56c7	cd ee 56 	. . V 
	ld de,0001h		;56ca	11 01 00 	. . . 
	jp z,l56dfh		;56cd	ca df 56 	. . V 
	call sub_64a8h		;56d0	cd a8 64 	. . d 
	jp nc,l56dch		;56d3	d2 dc 56 	. . V 
	call sub_571ch		;56d6	cd 1c 57 	. . W 
	scf			;56d9	37 	7 
	jr l56e0h		;56da	18 04 	. . 
l56dch:
	call sub_570bh		;56dc	cd 0b 57 	. . W 
l56dfh:
	or a			;56df	b7 	. 
l56e0h:
	pop hl			;56e0	e1 	. 
	pop bc			;56e1	c1 	. 
l56e2h:
	inc hl			;56e2	23 	# 
	ld a,(hl)			;56e3	7e 	~ 
	inc hl			;56e4	23 	# 
	ld h,(hl)			;56e5	66 	f 
	ld l,a			;56e6	6f 	o 
	jp (hl)			;56e7	e9 	. 
sub_56e8h:
	call sub_56eeh		;56e8	cd ee 56 	. . V 
	jr z,l56aeh		;56eb	28 c1 	( . 
	ret			;56ed	c9 	. 
sub_56eeh:
	push hl			;56ee	e5 	. 
l56efh:
	ld hl,MCLLEN		;56ef	21 3b fb 	! ; . 
	ld a,(hl)			;56f2	7e 	~ 
	or a			;56f3	b7 	. 
	jr z,l5709h		;56f4	28 13 	( . 
	dec (hl)			;56f6	35 	5 
	ld hl,(MCLPTR)		;56f7	2a 3c fb 	* < . 
	ld a,(hl)			;56fa	7e 	~ 
	inc hl			;56fb	23 	# 
	ld (MCLPTR),hl		;56fc	22 3c fb 	" < . 
	cp 020h		;56ff	fe 20 	.   
	jr z,l56efh		;5701	28 ec 	( . 
	cp 060h		;5703	fe 60 	. ` 
	jr c,l5709h		;5705	38 02 	8 . 
	sub 020h		;5707	d6 20 	.   
l5709h:
	pop hl			;5709	e1 	. 
	ret			;570a	c9 	. 
sub_570bh:
	push hl			;570b	e5 	. 
	ld hl,MCLLEN		;570c	21 3b fb 	! ; . 
	inc (hl)			;570f	34 	4 
	ld hl,(MCLPTR)		;5710	2a 3c fb 	* < . 
	dec hl			;5713	2b 	+ 
	ld (MCLPTR),hl		;5714	22 3c fb 	" < . 
	pop hl			;5717	e1 	. 
	ret			;5718	c9 	. 
l5719h:
	call sub_56e8h		;5719	cd e8 56 	. . V 
sub_571ch:
	cp 03dh		;571c	fe 3d 	. = 
	jp z,l577ah		;571e	ca 7a 57 	. z W 
	cp 02bh		;5721	fe 2b 	. + 
	jr z,l5719h		;5723	28 f4 	( . 
	cp 02dh		;5725	fe 2d 	. - 
	jr nz,l572fh		;5727	20 06 	  . 
	ld de,l5795h		;5729	11 95 57 	. . W 
	push de			;572c	d5 	. 
	jr l5719h		;572d	18 ea 	. . 
l572fh:
	ld de,0000h		;572f	11 00 00 	. . . 
l5732h:
	cp 02ch		;5732	fe 2c 	. , 
	jr z,sub_570bh		;5734	28 d5 	( . 
	cp 03bh		;5736	fe 3b 	. ; 
	ret z			;5738	c8 	. 
	cp 03ah		;5739	fe 3a 	. : 
	jr nc,sub_570bh		;573b	30 ce 	0 . 
	cp 030h		;573d	fe 30 	. 0 
	jr c,sub_570bh		;573f	38 ca 	8 . 
	ld hl,0000h		;5741	21 00 00 	! . . 
	ld b,00ah		;5744	06 0a 	. . 
l5746h:
	add hl,de			;5746	19 	. 
	jr c,l5773h		;5747	38 2a 	8 * 
	djnz l5746h		;5749	10 fb 	. . 
	sub 030h		;574b	d6 30 	. 0 
	ld e,a			;574d	5f 	_ 
	ld d,000h		;574e	16 00 	. . 
	add hl,de			;5750	19 	. 
	jr c,l5773h		;5751	38 20 	8   
	ex de,hl			;5753	eb 	. 
	call sub_56eeh		;5754	cd ee 56 	. . V 
	jr nz,l5732h		;5757	20 d9 	  . 
	ret			;5759	c9 	. 
sub_575ah:
	call sub_56e8h		;575a	cd e8 56 	. . V 
	ld de,BUF		;575d	11 5e f5 	. ^ . 
	push de			;5760	d5 	. 
	ld b,028h		;5761	06 28 	. ( 
	call sub_64a8h		;5763	cd a8 64 	. . d 
	jr c,l5773h		;5766	38 0b 	8 . 
l5768h:
	ld (de),a			;5768	12 	. 
	inc de			;5769	13 	. 
	cp 03bh		;576a	fe 3b 	. ; 
	jr z,l5776h		;576c	28 08 	( . 
	call sub_56e8h		;576e	cd e8 56 	. . V 
	djnz l5768h		;5771	10 f5 	. . 
l5773h:
	call l475ah		;5773	cd 5a 47 	. Z G 
l5776h:
	pop hl			;5776	e1 	. 
	jp l4e9bh		;5777	c3 9b 4e 	. . N 
l577ah:
	call sub_575ah		;577a	cd 5a 57 	. Z W 
	call sub_2f8ah		;577d	cd 8a 2f 	. . / 
	ex de,hl			;5780	eb 	. 
	ret			;5781	c9 	. 
l5782h:
	call sub_575ah		;5782	cd 5a 57 	. Z W 
	ld a,(MCLLEN)		;5785	3a 3b fb 	: ; . 
	ld hl,(MCLPTR)		;5788	2a 3c fb 	* < . 
	ex (sp),hl			;578b	e3 	. 
	push af			;578c	f5 	. 
	ld c,002h		;578d	0e 02 	. . 
	call sub_625eh		;578f	cd 5e 62 	. ^ b 
	jp l5679h		;5792	c3 79 56 	. y V 
l5795h:
	xor a			;5795	af 	. 
	sub e			;5796	93 	. 
	ld e,a			;5797	5f 	_ 
	sbc a,d			;5798	9a 	. 
	sub e			;5799	93 	. 
	ld d,a			;579a	57 	W 
	ret			;579b	c9 	. 
sub_579ch:
	ld a,(hl)			;579c	7e 	~ 
	cp 040h		;579d	fe 40 	. @ 
	call z,l4666h		;579f	cc 66 46 	. f F 
	ld bc,0000h		;57a2	01 00 00 	. . . 
	ld d,b			;57a5	50 	P 
	ld e,c			;57a6	59 	Y 
	cp 0f2h		;57a7	fe f2 	. . 
	jr z,l57c1h		;57a9	28 16 	( . 
sub_57abh:
	ld a,(hl)			;57ab	7e 	~ 
	cp 0dch		;57ac	fe dc 	. . 
	push af			;57ae	f5 	. 
	call z,l4666h		;57af	cc 66 46 	. f F 
	rst 8			;57b2	cf 	. 
	jr z,l5782h		;57b3	28 cd 	( . 
	rrca			;57b5	0f 	. 
	ld d,d			;57b6	52 	R 
	push de			;57b7	d5 	. 
	rst 8			;57b8	cf 	. 
	inc l			;57b9	2c 	, 
	call sub_520fh		;57ba	cd 0f 52 	. . R 
	rst 8			;57bd	cf 	. 
	add hl,hl			;57be	29 	) 
	pop bc			;57bf	c1 	. 
	pop af			;57c0	f1 	. 
l57c1h:
	push hl			;57c1	e5 	. 
	ld hl,(GRPACX)		;57c2	2a b7 fc 	* . . 
	jr z,l57cah		;57c5	28 03 	( . 
	ld hl,0000h		;57c7	21 00 00 	! . . 
l57cah:
	add hl,bc			;57ca	09 	. 
	ld (GRPACX),hl		;57cb	22 b7 fc 	" . . 
	ld (GXPOS),hl		;57ce	22 b3 fc 	" . . 
	ld b,h			;57d1	44 	D 
	ld c,l			;57d2	4d 	M 
	ld hl,(GRPACY)		;57d3	2a b9 fc 	* . . 
	jr z,l57dbh		;57d6	28 03 	( . 
	ld hl,0000h		;57d8	21 00 00 	! . . 
l57dbh:
	add hl,de			;57db	19 	. 
	ld (GRPACY),hl		;57dc	22 b9 fc 	" . . 
	ld (GYPOS),hl		;57df	22 b5 fc 	" . . 
	ex de,hl			;57e2	eb 	. 
	pop hl			;57e3	e1 	. 
	ret			;57e4	c9 	. 
	ld a,(BAKCLR)		;57e5	3a ea f3 	: . . 
	jr l57edh		;57e8	18 03 	. . 
	ld a,(FORCLR)		;57ea	3a e9 f3 	: . . 
l57edh:
	jp l79d6h		;57ed	c3 d6 79 	. . y 
	ld d,a			;57f0	57 	W 
l57f1h:
	pop af			;57f1	f1 	. 
	call sub_5850h		;57f2	cd 50 58 	. P X 
	push hl			;57f5	e5 	. 
	call SCALXY		;57f6	cd 0e 01 	. . . 
	jr nc,l5801h		;57f9	30 06 	0 . 
	call MAPXYC		;57fb	cd 11 01 	. . . 
	call SETC		;57fe	cd 20 01 	.   . 
l5801h:
	pop hl			;5801	e1 	. 
	ret			;5802	c9 	. 
l5803h:
	rst 10h			;5803	d7 	. 
	push hl			;5804	e5 	. 
	call FETCHC		;5805	cd 14 01 	. . . 
	pop de			;5808	d1 	. 
	push hl			;5809	e5 	. 
	push af			;580a	f5 	. 
	ld hl,(GYPOS)		;580b	2a b5 fc 	* . . 
	push hl			;580e	e5 	. 
	ld hl,(GXPOS)		;580f	2a b3 fc 	* . . 
	push hl			;5812	e5 	. 
	ld hl,(GRPACY)		;5813	2a b9 fc 	* . . 
	push hl			;5816	e5 	. 
	ld hl,(GRPACX)		;5817	2a b7 fc 	* . . 
	push hl			;581a	e5 	. 
	ex de,hl			;581b	eb 	. 
	call sub_57abh		;581c	cd ab 57 	. . W 
	push hl			;581f	e5 	. 
	call SCALXY		;5820	cd 0e 01 	. . . 
	ld hl,0ffffh		;5823	21 ff ff 	! . . 
	jr nc,l5831h		;5826	30 09 	0 . 
	call MAPXYC		;5828	cd 11 01 	. . . 
	call S.DSPFNK		;582b	cd 1d 01 	. . . 
	ld l,a			;582e	6f 	o 
	ld h,000h		;582f	26 00 	& . 
l5831h:
	call l2f99h		;5831	cd 99 2f 	. . / 
	pop de			;5834	d1 	. 
	pop hl			;5835	e1 	. 
	ld (GRPACX),hl		;5836	22 b7 fc 	" . . 
	pop hl			;5839	e1 	. 
	ld (GRPACY),hl		;583a	22 b9 fc 	" . . 
	pop hl			;583d	e1 	. 
	ld (GXPOS),hl		;583e	22 b3 fc 	" . . 
	pop hl			;5841	e1 	. 
	ld (GYPOS),hl		;5842	22 b5 fc 	" . . 
	pop af			;5845	f1 	. 
	pop hl			;5846	e1 	. 
	push de			;5847	d5 	. 
	call STOREC		;5848	cd 17 01 	. . . 
	pop hl			;584b	e1 	. 
	ret			;584c	c9 	. 
sub_584dh:
	ld a,(FORCLR)		;584d	3a e9 f3 	: . . 
sub_5850h:
	push bc			;5850	c5 	. 
	push de			;5851	d5 	. 
	ld e,a			;5852	5f 	_ 
	call sub_59bch		;5853	cd bc 59 	. . Y 
	dec hl			;5856	2b 	+ 
	rst 10h			;5857	d7 	. 
	jr z,l5863h		;5858	28 09 	( . 
	rst 8			;585a	cf 	. 
	inc l			;585b	2c 	, 
	cp 02ch		;585c	fe 2c 	. , 
	jr z,l5863h		;585e	28 03 	( . 
	call sub_521ch		;5860	cd 1c 52 	. . R 
l5863h:
	ld a,e			;5863	7b 	{ 
	push hl			;5864	e5 	. 
	call SETATR		;5865	cd 1a 01 	. . . 
	jp c,l475ah		;5868	da 5a 47 	. Z G 
	pop hl			;586b	e1 	. 
	pop de			;586c	d1 	. 
	pop bc			;586d	c1 	. 
	jp sub_466ah		;586e	c3 6a 46 	. j F 
sub_5871h:
	ld hl,(GXPOS)		;5871	2a b3 fc 	* . . 
	ld a,l			;5874	7d 	} 
	sub c			;5875	91 	. 
	ld l,a			;5876	6f 	o 
	ld a,h			;5877	7c 	| 
	sbc a,b			;5878	98 	. 
	ld h,a			;5879	67 	g 
l587ah:
	ret nc			;587a	d0 	. 
sub_587bh:
	xor a			;587b	af 	. 
	sub l			;587c	95 	. 
	ld l,a			;587d	6f 	o 
	sbc a,h			;587e	9c 	. 
	sub l			;587f	95 	. 
	ld h,a			;5880	67 	g 
	scf			;5881	37 	7 
	ret			;5882	c9 	. 
sub_5883h:
	ld hl,(GYPOS)		;5883	2a b5 fc 	* . . 
	ld a,l			;5886	7d 	} 
	sub e			;5887	93 	. 
	ld l,a			;5888	6f 	o 
	ld a,h			;5889	7c 	| 
	sbc a,d			;588a	9a 	. 
	ld h,a			;588b	67 	g 
	jr l587ah		;588c	18 ec 	. . 
sub_588eh:
	push hl			;588e	e5 	. 
	ld hl,(GYPOS)		;588f	2a b5 fc 	* . . 
	ex de,hl			;5892	eb 	. 
	ld (GYPOS),hl		;5893	22 b5 fc 	" . . 
	pop hl			;5896	e1 	. 
	ret			;5897	c9 	. 
sub_5898h:
	call sub_588eh		;5898	cd 8e 58 	. . X 
sub_589bh:
	push hl			;589b	e5 	. 
	push bc			;589c	c5 	. 
	ld hl,(GXPOS)		;589d	2a b3 fc 	* . . 
	ex (sp),hl			;58a0	e3 	. 
	ld (GXPOS),hl		;58a1	22 b3 fc 	" . . 
	pop bc			;58a4	c1 	. 
	pop hl			;58a5	e1 	. 
	ret			;58a6	c9 	. 
l58a7h:
	jp l79e9h		;58a7	c3 e9 79 	. . y 
l58aah:
	push bc			;58aa	c5 	. 
	push de			;58ab	d5 	. 
	rst 8			;58ac	cf 	. 
	jp p,0abcdh		;58ad	f2 cd ab 	. . . 
	ld d,a			;58b0	57 	W 
	call sub_584dh		;58b1	cd 4d 58 	. M X 
	pop de			;58b4	d1 	. 
	pop bc			;58b5	c1 	. 
	jr z,l58fch		;58b6	28 44 	( D 
	rst 8			;58b8	cf 	. 
	inc l			;58b9	2c 	, 
	rst 8			;58ba	cf 	. 
	ld b,d			;58bb	42 	B 
	jp z,l5912h		;58bc	ca 12 59 	. . Y 
	rst 8			;58bf	cf 	. 
	ld b,(hl)			;58c0	46 	F 
	push hl			;58c1	e5 	. 
	call SCALXY		;58c2	cd 0e 01 	. . . 
	call sub_5898h		;58c5	cd 98 58 	. . X 
	call SCALXY		;58c8	cd 0e 01 	. . . 
	call sub_5883h		;58cb	cd 83 58 	. . X 
	call c,sub_588eh		;58ce	dc 8e 58 	. . X 
	inc hl			;58d1	23 	# 
	push hl			;58d2	e5 	. 
	call sub_5871h		;58d3	cd 71 58 	. q X 
	call c,sub_589bh		;58d6	dc 9b 58 	. . X 
	inc hl			;58d9	23 	# 
	push hl			;58da	e5 	. 
	call MAPXYC		;58db	cd 11 01 	. . . 
	pop de			;58de	d1 	. 
	pop bc			;58df	c1 	. 
l58e0h:
	push de			;58e0	d5 	. 
	push bc			;58e1	c5 	. 
	call FETCHC		;58e2	cd 14 01 	. . . 
	push af			;58e5	f5 	. 
	push hl			;58e6	e5 	. 
	ex de,hl			;58e7	eb 	. 
	call NSETCX		;58e8	cd 23 01 	. # . 
	pop hl			;58eb	e1 	. 
	pop af			;58ec	f1 	. 
	call STOREC		;58ed	cd 17 01 	. . . 
	call DOWNC		;58f0	cd 08 01 	. . . 
	pop bc			;58f3	c1 	. 
	pop de			;58f4	d1 	. 
	dec bc			;58f5	0b 	. 
	ld a,b			;58f6	78 	x 
	or c			;58f7	b1 	. 
	jr nz,l58e0h		;58f8	20 e6 	  . 
	pop hl			;58fa	e1 	. 
	ret			;58fb	c9 	. 
l58fch:
	push bc			;58fc	c5 	. 
	push de			;58fd	d5 	. 
	push hl			;58fe	e5 	. 
	call sub_593ch		;58ff	cd 3c 59 	. < Y 
	ld hl,(GRPACX)		;5902	2a b7 fc 	* . . 
	ld (GXPOS),hl		;5905	22 b3 fc 	" . . 
	ld hl,(GRPACY)		;5908	2a b9 fc 	* . . 
	ld (GYPOS),hl		;590b	22 b5 fc 	" . . 
	pop hl			;590e	e1 	. 
	pop de			;590f	d1 	. 
	pop bc			;5910	c1 	. 
	ret			;5911	c9 	. 
l5912h:
	push hl			;5912	e5 	. 
	ld hl,(GYPOS)		;5913	2a b5 fc 	* . . 
	push hl			;5916	e5 	. 
	push de			;5917	d5 	. 
	ex de,hl			;5918	eb 	. 
	call l58fch		;5919	cd fc 58 	. . X 
	pop hl			;591c	e1 	. 
	ld (GYPOS),hl		;591d	22 b5 fc 	" . . 
	ex de,hl			;5920	eb 	. 
	call l58fch		;5921	cd fc 58 	. . X 
	pop hl			;5924	e1 	. 
	ld (GYPOS),hl		;5925	22 b5 fc 	" . . 
	ld hl,(GXPOS)		;5928	2a b3 fc 	* . . 
	push bc			;592b	c5 	. 
	ld b,h			;592c	44 	D 
	ld c,l			;592d	4d 	M 
	call l58fch		;592e	cd fc 58 	. . X 
	pop hl			;5931	e1 	. 
	ld (GXPOS),hl		;5932	22 b3 fc 	" . . 
	ld b,h			;5935	44 	D 
	ld c,l			;5936	4d 	M 
	call l58fch		;5937	cd fc 58 	. . X 
	pop hl			;593a	e1 	. 
	ret			;593b	c9 	. 
sub_593ch:
	call H.DOGR		;593c	cd f3 fe 	. . . 
	jp l7a0dh		;593f	c3 0d 7a 	. . z 
l5942h:
	call sub_5898h		;5942	cd 98 58 	. . X 
	call SCALXY		;5945	cd 0e 01 	. . . 
	call sub_5883h		;5948	cd 83 58 	. . X 
	call c,sub_5898h		;594b	dc 98 58 	. . X 
	push de			;594e	d5 	. 
	push hl			;594f	e5 	. 
	call sub_5871h		;5950	cd 71 58 	. q X 
	ex de,hl			;5953	eb 	. 
	ld hl,00fch		;5954	21 fc 00 	! . . 
	jr nc,l595ch		;5957	30 03 	0 . 
	ld hl,LEFTC		;5959	21 ff 00 	! . . 
l595ch:
	ex (sp),hl			;595c	e3 	. 
	rst 20h			;595d	e7 	. 
	jr nc,l5970h		;595e	30 10 	0 . 
	ld (MINDEL),hl		;5960	22 2d f9 	" - . 
	pop hl			;5963	e1 	. 
	ld (0f3edh),hl		;5964	22 ed f3 	" . . 
	ld hl,DOWNC		;5967	21 08 01 	! . . 
	ld (0f3f0h),hl		;596a	22 f0 f3 	" . . 
	ex de,hl			;596d	eb 	. 
	jr l597fh		;596e	18 0f 	. . 
l5970h:
	ex (sp),hl			;5970	e3 	. 
	ld (0f3f0h),hl		;5971	22 f0 f3 	" . . 
	ld hl,DOWNC		;5974	21 08 01 	! . . 
	ld (0f3edh),hl		;5977	22 ed f3 	" . . 
	ex de,hl			;597a	eb 	. 
	ld (MINDEL),hl		;597b	22 2d f9 	" - . 
	pop hl			;597e	e1 	. 
l597fh:
	pop de			;597f	d1 	. 
	push hl			;5980	e5 	. 
	call sub_587bh		;5981	cd 7b 58 	. { X 
	ld (MAXDEL),hl		;5984	22 2f f9 	" / . 
	call MAPXYC		;5987	cd 11 01 	. . . 
	pop de			;598a	d1 	. 
	push de			;598b	d5 	. 
	call sub_59b4h		;598c	cd b4 59 	. . Y 
	pop bc			;598f	c1 	. 
	inc bc			;5990	03 	. 
	jr l599ah		;5991	18 07 	. . 
l5993h:
	pop hl			;5993	e1 	. 
	ld a,b			;5994	78 	x 
	or c			;5995	b1 	. 
	ret z			;5996	c8 	. 
l5997h:
	call 0f3ech		;5997	cd ec f3 	. . . 
l599ah:
	call SETC		;599a	cd 20 01 	.   . 
	dec bc			;599d	0b 	. 
	push hl			;599e	e5 	. 
	ld hl,(MINDEL)		;599f	2a 2d f9 	* - . 
	add hl,de			;59a2	19 	. 
	ex de,hl			;59a3	eb 	. 
	ld hl,(MAXDEL)		;59a4	2a 2f f9 	* / . 
	add hl,de			;59a7	19 	. 
	jr nc,l5993h		;59a8	30 e9 	0 . 
	ex de,hl			;59aa	eb 	. 
	pop hl			;59ab	e1 	. 
	ld a,b			;59ac	78 	x 
	or c			;59ad	b1 	. 
	ret z			;59ae	c8 	. 
	call 0f3efh		;59af	cd ef f3 	. . . 
	jr l5997h		;59b2	18 e3 	. . 
sub_59b4h:
	ld a,d			;59b4	7a 	z 
	or a			;59b5	b7 	. 
	rra			;59b6	1f 	. 
	ld d,a			;59b7	57 	W 
	ld a,e			;59b8	7b 	{ 
	rra			;59b9	1f 	. 
	ld e,a			;59ba	5f 	_ 
	ret			;59bb	c9 	. 
sub_59bch:
	ld a,(SCRMOD)		;59bc	3a af fc 	: . . 
	cp 002h		;59bf	fe 02 	. . 
	ret p			;59c1	f0 	. 
	jp l475ah		;59c2	c3 5a 47 	. Z G 
	jp l79fbh		;59c5	c3 fb 79 	. . y 
l59c8h:
	push bc			;59c8	c5 	. 
	push de			;59c9	d5 	. 
	call sub_584dh		;59ca	cd 4d 58 	. M X 
	ld a,(ATRBYT)		;59cd	3a f2 f3 	: . . 
	ld e,a			;59d0	5f 	_ 
	dec hl			;59d1	2b 	+ 
	rst 10h			;59d2	d7 	. 
	jr z,l59dah		;59d3	28 05 	( . 
	rst 8			;59d5	cf 	. 
	inc l			;59d6	2c 	, 
	call sub_521ch		;59d7	cd 1c 52 	. . R 
l59dah:
	ld a,e			;59da	7b 	{ 
	call PNTINI		;59db	cd 29 01 	. ) . 
	jp c,l475ah		;59de	da 5a 47 	. Z G 
	pop de			;59e1	d1 	. 
	pop bc			;59e2	c1 	. 
	push hl			;59e3	e5 	. 
	call sub_5e91h		;59e4	cd 91 5e 	. . ^ 
	call MAPXYC		;59e7	cd 11 01 	. . . 
	ld de,0001h		;59ea	11 01 00 	. . . 
	ld b,000h		;59ed	06 00 	. . 
	call sub_5adch		;59ef	cd dc 5a 	. . Z 
	jr z,l5a08h		;59f2	28 14 	( . 
	push hl			;59f4	e5 	. 
	call sub_5aedh		;59f5	cd ed 5a 	. . Z 
	pop de			;59f8	d1 	. 
	add hl,de			;59f9	19 	. 
	ex de,hl			;59fa	eb 	. 
	xor a			;59fb	af 	. 
	call sub_5aceh		;59fc	cd ce 5a 	. . Z 
	ld a,040h		;59ff	3e 40 	> @ 
	call sub_5aceh		;5a01	cd ce 5a 	. . Z 
	ld b,0c0h		;5a04	06 c0 	. . 
	jr l5a26h		;5a06	18 1e 	. . 
l5a08h:
	pop hl			;5a08	e1 	. 
	ret			;5a09	c9 	. 
l5a0ah:
	call S.UPC		;5a0a	cd bd 00 	. . . 
	ld a,(LOHDIR)		;5a0d	3a 4a f9 	: J . 
	or a			;5a10	b7 	. 
	jr z,l5a1fh		;5a11	28 0c 	( . 
	ld hl,(LOHADR)		;5a13	2a 4b f9 	* K . 
	push hl			;5a16	e5 	. 
	ld hl,(LOHMSK)		;5a17	2a 49 f9 	* I . 
	push hl			;5a1a	e5 	. 
	ld hl,(LOHCNT)		;5a1b	2a 4d f9 	* M . 
	push hl			;5a1e	e5 	. 
l5a1fh:
	pop de			;5a1f	d1 	. 
	pop bc			;5a20	c1 	. 
	pop hl			;5a21	e1 	. 
	ld a,c			;5a22	79 	y 
	call STOREC		;5a23	cd 17 01 	. . . 
l5a26h:
	ld a,b			;5a26	78 	x 
	ld (PDIREC),a		;5a27	32 53 f9 	2 S . 
	add a,a			;5a2a	87 	. 
	jr z,l5a08h		;5a2b	28 db 	( . 
	push de			;5a2d	d5 	. 
	jr nc,l5a35h		;5a2e	30 05 	0 . 
	call TUPC		;5a30	cd 05 01 	. . . 
	jr l5a38h		;5a33	18 03 	. . 
l5a35h:
	call TDOWNC		;5a35	cd 0b 01 	. . . 
l5a38h:
	pop de			;5a38	d1 	. 
	jr c,l5a1fh		;5a39	38 e4 	8 . 
	ld b,000h		;5a3b	06 00 	. . 
	call sub_5adch		;5a3d	cd dc 5a 	. . Z 
	jp z,l5a1fh		;5a40	ca 1f 5a 	. . Z 
	xor a			;5a43	af 	. 
	ld (LOHDIR),a		;5a44	32 4a f9 	2 J . 
	call sub_5aedh		;5a47	cd ed 5a 	. . Z 
	ld e,l			;5a4a	5d 	] 
	ld d,h			;5a4b	54 	T 
	or a			;5a4c	b7 	. 
	jr z,l5a69h		;5a4d	28 1a 	( . 
	dec hl			;5a4f	2b 	+ 
	dec hl			;5a50	2b 	+ 
	ld a,h			;5a51	7c 	| 
	add a,a			;5a52	87 	. 
	jr c,l5a69h		;5a53	38 14 	8 . 
	ld (LOHCNT),de		;5a55	ed 53 4d f9 	. S M . 
	call FETCHC		;5a59	cd 14 01 	. . . 
	ld (LOHADR),hl		;5a5c	22 4b f9 	" K . 
	ld (LOHMSK),a		;5a5f	32 49 f9 	2 I . 
	ld a,(PDIREC)		;5a62	3a 53 f9 	: S . 
	cpl			;5a65	2f 	/ 
	ld (LOHDIR),a		;5a66	32 4a f9 	2 J . 
l5a69h:
	ld hl,(MOVCNT)		;5a69	2a 51 f9 	* Q . 
	add hl,de			;5a6c	19 	. 
	ex de,hl			;5a6d	eb 	. 
	call sub_5ac2h		;5a6e	cd c2 5a 	. . Z 
l5a71h:
	ld hl,(CSAVEA)		;5a71	2a 42 f9 	* B . 
	ld a,(CSAVEM)		;5a74	3a 44 f9 	: D . 
	call STOREC		;5a77	cd 17 01 	. . . 
l5a7ah:
	ld hl,(SKPCNT)		;5a7a	2a 4f f9 	* O . 
	ld de,(MOVCNT)		;5a7d	ed 5b 51 f9 	. [ Q . 
	or a			;5a81	b7 	. 
	sbc hl,de		;5a82	ed 52 	. R 
	jr z,l5abfh		;5a84	28 39 	( 9 
	jr c,l5aa4h		;5a86	38 1c 	8 . 
	ex de,hl			;5a88	eb 	. 
	ld b,001h		;5a89	06 01 	. . 
	call sub_5adch		;5a8b	cd dc 5a 	. . Z 
	jr z,l5abfh		;5a8e	28 2f 	( / 
	or a			;5a90	b7 	. 
	jr z,l5a7ah		;5a91	28 e7 	( . 
	ex de,hl			;5a93	eb 	. 
	ld hl,(CSAVEA)		;5a94	2a 42 f9 	* B . 
	ld a,(CSAVEM)		;5a97	3a 44 f9 	: D . 
	ld c,a			;5a9a	4f 	O 
	ld a,(PDIREC)		;5a9b	3a 53 f9 	: S . 
	ld b,a			;5a9e	47 	G 
	call sub_5ad3h		;5a9f	cd d3 5a 	. . Z 
	jr l5a7ah		;5aa2	18 d6 	. . 
l5aa4h:
	call sub_587bh		;5aa4	cd 7b 58 	. { X 
	dec hl			;5aa7	2b 	+ 
	dec hl			;5aa8	2b 	+ 
	ld a,h			;5aa9	7c 	| 
	add a,a			;5aaa	87 	. 
	jr c,l5abfh		;5aab	38 12 	8 . 
	inc hl			;5aad	23 	# 
	push hl			;5aae	e5 	. 
l5aafh:
	call LEFTC		;5aaf	cd ff 00 	. . . 
	dec hl			;5ab2	2b 	+ 
	ld a,h			;5ab3	7c 	| 
	or l			;5ab4	b5 	. 
	jr nz,l5aafh		;5ab5	20 f8 	  . 
	pop de			;5ab7	d1 	. 
	ld a,(PDIREC)		;5ab8	3a 53 f9 	: S . 
	cpl			;5abb	2f 	/ 
	call sub_5aceh		;5abc	cd ce 5a 	. . Z 
l5abfh:
	jp l5a0ah		;5abf	c3 0a 5a 	. . Z 
sub_5ac2h:
	ld a,(LFPROG)		;5ac2	3a 54 f9 	: T . 
	ld c,a			;5ac5	4f 	O 
	ld a,(RTPROG)		;5ac6	3a 55 f9 	: U . 
	or c			;5ac9	b1 	. 
	ret z			;5aca	c8 	. 
	ld a,(PDIREC)		;5acb	3a 53 f9 	: S . 
sub_5aceh:
	ld b,a			;5ace	47 	G 
	call FETCHC		;5acf	cd 14 01 	. . . 
	ld c,a			;5ad2	4f 	O 
sub_5ad3h:
	ex (sp),hl			;5ad3	e3 	. 
	push bc			;5ad4	c5 	. 
	push de			;5ad5	d5 	. 
	push hl			;5ad6	e5 	. 
	ld c,002h		;5ad7	0e 02 	. . 
	jp sub_625eh		;5ad9	c3 5e 62 	. ^ b 
sub_5adch:
	call SCANR		;5adc	cd 2c 01 	. , . 
	ld (SKPCNT),de		;5adf	ed 53 4f f9 	. S O . 
	ld (MOVCNT),hl		;5ae3	22 51 f9 	" Q . 
	ld a,h			;5ae6	7c 	| 
	or l			;5ae7	b5 	. 
	ld a,c			;5ae8	79 	y 
	ld (RTPROG),a		;5ae9	32 55 f9 	2 U . 
	ret			;5aec	c9 	. 
sub_5aedh:
	call FETCHC		;5aed	cd 14 01 	. . . 
	push hl			;5af0	e5 	. 
	push af			;5af1	f5 	. 
	ld hl,(CSAVEA)		;5af2	2a 42 f9 	* B . 
	ld a,(CSAVEM)		;5af5	3a 44 f9 	: D . 
	call STOREC		;5af8	cd 17 01 	. . . 
	pop af			;5afb	f1 	. 
	pop hl			;5afc	e1 	. 
	ld (CSAVEA),hl		;5afd	22 42 f9 	" B . 
	ld (CSAVEM),a		;5b00	32 44 f9 	2 D . 
	call SCANL		;5b03	cd 2f 01 	. / . 
	ld a,c			;5b06	79 	y 
	ld (LFPROG),a		;5b07	32 54 f9 	2 T . 
	ret			;5b0a	c9 	. 
sub_5b0bh:
	ex de,hl			;5b0b	eb 	. 
	call sub_587bh		;5b0c	cd 7b 58 	. { X 
	ex de,hl			;5b0f	eb 	. 
	ret			;5b10	c9 	. 
	call sub_579ch		;5b11	cd 9c 57 	. . W 
	rst 8			;5b14	cf 	. 
	inc l			;5b15	2c 	, 
	call sub_520fh		;5b16	cd 0f 52 	. . R 
	push hl			;5b19	e5 	. 
	ex de,hl			;5b1a	eb 	. 
	ld (GXPOS),hl		;5b1b	22 b3 fc 	" . . 
	call l2f99h		;5b1e	cd 99 2f 	. . / 
	call sub_2fb2h		;5b21	cd b2 2f 	. . / 
	ld bc,07040h		;5b24	01 40 70 	. @ p 
	ld de,00771h		;5b27	11 71 07 	. q . 
	call l325ch		;5b2a	cd 5c 32 	. \ 2 
	call sub_2f8ah		;5b2d	cd 8a 2f 	. . / 
	ld (CNPNTS),hl		;5b30	22 36 f9 	" 6 . 
	xor a			;5b33	af 	. 
	ld (CLINEF),a		;5b34	32 35 f9 	2 5 . 
	ld (CSCLXY),a		;5b37	32 41 f9 	2 A . 
	pop hl			;5b3a	e1 	. 
	call sub_584dh		;5b3b	cd 4d 58 	. M X 
	ld c,001h		;5b3e	0e 01 	. . 
	ld de,0000h		;5b40	11 00 00 	. . . 
	call sub_5d17h		;5b43	cd 17 5d 	. . ] 
	push de			;5b46	d5 	. 
	ld c,080h		;5b47	0e 80 	. . 
	ld de,0ffffh		;5b49	11 ff ff 	. . . 
	call sub_5d17h		;5b4c	cd 17 5d 	. . ] 
	ex (sp),hl			;5b4f	e3 	. 
	xor a			;5b50	af 	. 
	ex de,hl			;5b51	eb 	. 
	rst 20h			;5b52	e7 	. 
	ld a,000h		;5b53	3e 00 	> . 
	jr nc,l5b66h		;5b55	30 0f 	0 . 
	dec a			;5b57	3d 	= 
	ex de,hl			;5b58	eb 	. 
	push af			;5b59	f5 	. 
	ld a,(CLINEF)		;5b5a	3a 35 f9 	: 5 . 
	ld c,a			;5b5d	4f 	O 
	rlca			;5b5e	07 	. 
	rlca			;5b5f	07 	. 
	or c			;5b60	b1 	. 
	rrca			;5b61	0f 	. 
	ld (CLINEF),a		;5b62	32 35 f9 	2 5 . 
	pop af			;5b65	f1 	. 
l5b66h:
	ld (CPLOTF),a		;5b66	32 38 f9 	2 8 . 
	ld (CSTCNT),de		;5b69	ed 53 3f f9 	. S ? . 
	ld (CENCNT),hl		;5b6d	22 33 f9 	" 3 . 
	pop hl			;5b70	e1 	. 
	dec hl			;5b71	2b 	+ 
	rst 10h			;5b72	d7 	. 
	jr nz,l5b85h		;5b73	20 10 	  . 
	push hl			;5b75	e5 	. 
	call GTASPC		;5b76	cd 26 01 	. & . 
	ld a,h			;5b79	7c 	| 
	or a			;5b7a	b7 	. 
	jr z,l5bafh		;5b7b	28 32 	( 2 
	ld a,001h		;5b7d	3e 01 	> . 
	ld (CSCLXY),a		;5b7f	32 41 f9 	2 A . 
	ex de,hl			;5b82	eb 	. 
	jr l5bafh		;5b83	18 2a 	. * 
l5b85h:
	rst 8			;5b85	cf 	. 
	inc l			;5b86	2c 	, 
	call sub_4c64h		;5b87	cd 64 4c 	. d L 
	push hl			;5b8a	e5 	. 
	call sub_2fb2h		;5b8b	cd b2 2f 	. . / 
	call BAS_SIGN		;5b8e	cd 71 2e 	. q . 
	jp z,l475ah		;5b91	ca 5a 47 	. Z G 
	jp m,l475ah		;5b94	fa 5a 47 	. Z G 
	call sub_5d63h		;5b97	cd 63 5d 	. c ] 
	jr nz,l5ba3h		;5b9a	20 07 	  . 
	inc a			;5b9c	3c 	< 
	ld (CSCLXY),a		;5b9d	32 41 f9 	2 A . 
	call sub_3267h		;5ba0	cd 67 32 	. g 2 
l5ba3h:
	ld bc,l2543h		;5ba3	01 43 25 	. C % 
	ld de,00060h		;5ba6	11 60 00 	. ` . 
	call l325ch		;5ba9	cd 5c 32 	. \ 2 
	call sub_2f8ah		;5bac	cd 8a 2f 	. . / 
l5bafh:
	ld (ASPECT),hl		;5baf	22 31 f9 	" 1 . 
	ld de,0000h		;5bb2	11 00 00 	. . . 
	ld (CRCSUM),de		;5bb5	ed 53 3d f9 	. S = . 
	ld hl,(GXPOS)		;5bb9	2a b3 fc 	* . . 
	add hl,hl			;5bbc	29 	) 
l5bbdh:
	call S.UPC		;5bbd	cd bd 00 	. . . 
	ld a,e			;5bc0	7b 	{ 
	rra			;5bc1	1f 	. 
	jr c,l5bdah		;5bc2	38 16 	8 . 
	push de			;5bc4	d5 	. 
	push hl			;5bc5	e5 	. 
	inc hl			;5bc6	23 	# 
	ex de,hl			;5bc7	eb 	. 
	call sub_59b4h		;5bc8	cd b4 59 	. . Y 
	ex de,hl			;5bcb	eb 	. 
	inc de			;5bcc	13 	. 
	call sub_59b4h		;5bcd	cd b4 59 	. . Y 
	call sub_5c06h		;5bd0	cd 06 5c 	. . \ 
	pop de			;5bd3	d1 	. 
	pop hl			;5bd4	e1 	. 
	rst 20h			;5bd5	e7 	. 
	jp nc,l5a08h		;5bd6	d2 08 5a 	. . Z 
	ex de,hl			;5bd9	eb 	. 
l5bdah:
	ld b,h			;5bda	44 	D 
	ld c,l			;5bdb	4d 	M 
	ld hl,(CRCSUM)		;5bdc	2a 3d f9 	* = . 
	inc hl			;5bdf	23 	# 
	add hl,de			;5be0	19 	. 
	add hl,de			;5be1	19 	. 
	ld a,h			;5be2	7c 	| 
	add a,a			;5be3	87 	. 
	jr c,l5bf2h		;5be4	38 0c 	8 . 
	push de			;5be6	d5 	. 
	ex de,hl			;5be7	eb 	. 
	ld h,b			;5be8	60 	` 
	ld l,c			;5be9	69 	i 
	add hl,hl			;5bea	29 	) 
	dec hl			;5beb	2b 	+ 
	ex de,hl			;5bec	eb 	. 
	or a			;5bed	b7 	. 
	sbc hl,de		;5bee	ed 52 	. R 
	dec bc			;5bf0	0b 	. 
	pop de			;5bf1	d1 	. 
l5bf2h:
	ld (CRCSUM),hl		;5bf2	22 3d f9 	" = . 
	ld h,b			;5bf5	60 	` 
	ld l,c			;5bf6	69 	i 
	inc de			;5bf7	13 	. 
	jr l5bbdh		;5bf8	18 c3 	. . 
sub_5bfah:
	push de			;5bfa	d5 	. 
	call sub_5cebh		;5bfb	cd eb 5c 	. . \ 
	pop hl			;5bfe	e1 	. 
	ld a,(CSCLXY)		;5bff	3a 41 f9 	: A . 
	or a			;5c02	b7 	. 
	ret z			;5c03	c8 	. 
	ex de,hl			;5c04	eb 	. 
	ret			;5c05	c9 	. 
sub_5c06h:
	ld (CPCNT),de		;5c06	ed 53 39 f9 	. S 9 . 
	push hl			;5c0a	e5 	. 
	ld hl,0000h		;5c0b	21 00 00 	! . . 
	ld (CPCNT8),hl		;5c0e	22 3b f9 	" ; . 
	call sub_5bfah		;5c11	cd fa 5b 	. . [ 
	ld (CXOFF),hl		;5c14	22 45 f9 	" E . 
	pop hl			;5c17	e1 	. 
	ex de,hl			;5c18	eb 	. 
	push hl			;5c19	e5 	. 
	call sub_5bfah		;5c1a	cd fa 5b 	. . [ 
	ld (CYOFF),de		;5c1d	ed 53 47 f9 	. S G . 
	pop de			;5c21	d1 	. 
	call sub_5b0bh		;5c22	cd 0b 5b 	. . [ 
	call sub_5c48h		;5c25	cd 48 5c 	. H \ 
	push hl			;5c28	e5 	. 
	push de			;5c29	d5 	. 
	ld hl,(CNPNTS)		;5c2a	2a 36 f9 	* 6 . 
	ld (CPCNT8),hl		;5c2d	22 3b f9 	" ; . 
	ld de,(CPCNT)		;5c30	ed 5b 39 f9 	. [ 9 . 
	or a			;5c34	b7 	. 
	sbc hl,de		;5c35	ed 52 	. R 
	ld (CPCNT),hl		;5c37	22 39 f9 	" 9 . 
	ld hl,(CXOFF)		;5c3a	2a 45 f9 	* E . 
	call sub_587bh		;5c3d	cd 7b 58 	. { X 
	ld (CXOFF),hl		;5c40	22 45 f9 	" E . 
	pop de			;5c43	d1 	. 
	pop hl			;5c44	e1 	. 
	call sub_5b0bh		;5c45	cd 0b 5b 	. . [ 
sub_5c48h:
	ld a,004h		;5c48	3e 04 	> . 
l5c4ah:
	push af			;5c4a	f5 	. 
	push hl			;5c4b	e5 	. 
	push de			;5c4c	d5 	. 
	push hl			;5c4d	e5 	. 
	push de			;5c4e	d5 	. 
	ld de,(CPCNT8)		;5c4f	ed 5b 3b f9 	. [ ; . 
	ld hl,(CNPNTS)		;5c53	2a 36 f9 	* 6 . 
	add hl,hl			;5c56	29 	) 
	add hl,de			;5c57	19 	. 
	ld (CPCNT8),hl		;5c58	22 3b f9 	" ; . 
	ld hl,(CPCNT)		;5c5b	2a 39 f9 	* 9 . 
	add hl,de			;5c5e	19 	. 
	ex de,hl			;5c5f	eb 	. 
	ld hl,(CSTCNT)		;5c60	2a 3f f9 	* ? . 
	rst 20h			;5c63	e7 	. 
	jr z,l5c80h		;5c64	28 1a 	( . 
	jr nc,l5c70h		;5c66	30 08 	0 . 
	ld hl,(CENCNT)		;5c68	2a 33 f9 	* 3 . 
	rst 20h			;5c6b	e7 	. 
	jr z,l5c78h		;5c6c	28 0a 	( . 
	jr nc,l5c90h		;5c6e	30 20 	0   
l5c70h:
	ld a,(CPLOTF)		;5c70	3a 38 f9 	: 8 . 
	or a			;5c73	b7 	. 
	jr nz,l5c9ah		;5c74	20 24 	  $ 
	jr l5c96h		;5c76	18 1e 	. . 
l5c78h:
	ld a,(CLINEF)		;5c78	3a 35 f9 	: 5 . 
	add a,a			;5c7b	87 	. 
	jr nc,l5c9ah		;5c7c	30 1c 	0 . 
	jr l5c86h		;5c7e	18 06 	. . 
l5c80h:
	ld a,(CLINEF)		;5c80	3a 35 f9 	: 5 . 
	rra			;5c83	1f 	. 
	jr nc,l5c9ah		;5c84	30 14 	0 . 
l5c86h:
	pop de			;5c86	d1 	. 
	pop hl			;5c87	e1 	. 
	call sub_5cdch		;5c88	cd dc 5c 	. . \ 
	call sub_5ccdh		;5c8b	cd cd 5c 	. . \ 
	jr l5caah		;5c8e	18 1a 	. . 
l5c90h:
	ld a,(CPLOTF)		;5c90	3a 38 f9 	: 8 . 
	or a			;5c93	b7 	. 
	jr z,l5c9ah		;5c94	28 04 	( . 
l5c96h:
	pop de			;5c96	d1 	. 
	pop hl			;5c97	e1 	. 
	jr l5caah		;5c98	18 10 	. . 
l5c9ah:
	pop de			;5c9a	d1 	. 
	pop hl			;5c9b	e1 	. 
	call sub_5cdch		;5c9c	cd dc 5c 	. . \ 
	call SCALXY		;5c9f	cd 0e 01 	. . . 
	jr nc,l5caah		;5ca2	30 06 	0 . 
	call MAPXYC		;5ca4	cd 11 01 	. . . 
	call SETC		;5ca7	cd 20 01 	.   . 
l5caah:
	pop de			;5caa	d1 	. 
	pop hl			;5cab	e1 	. 
	pop af			;5cac	f1 	. 
	dec a			;5cad	3d 	= 
	ret z			;5cae	c8 	. 
	push af			;5caf	f5 	. 
	push de			;5cb0	d5 	. 
	ld de,(CXOFF)		;5cb1	ed 5b 45 f9 	. [ E . 
	call sub_5b0bh		;5cb5	cd 0b 5b 	. . [ 
	ld (CXOFF),hl		;5cb8	22 45 f9 	" E . 
	ex de,hl			;5cbb	eb 	. 
	pop de			;5cbc	d1 	. 
	push hl			;5cbd	e5 	. 
	ld hl,(CYOFF)		;5cbe	2a 47 f9 	* G . 
	ex de,hl			;5cc1	eb 	. 
	ld (CYOFF),hl		;5cc2	22 47 f9 	" G . 
	call sub_5b0bh		;5cc5	cd 0b 5b 	. . [ 
	pop hl			;5cc8	e1 	. 
	pop af			;5cc9	f1 	. 
	jp l5c4ah		;5cca	c3 4a 5c 	. J \ 
sub_5ccdh:
	ld hl,(GRPACX)		;5ccd	2a b7 fc 	* . . 
	ld (GXPOS),hl		;5cd0	22 b3 fc 	" . . 
	ld hl,(GRPACY)		;5cd3	2a b9 fc 	* . . 
	ld (GYPOS),hl		;5cd6	22 b5 fc 	" . . 
	jp sub_593ch		;5cd9	c3 3c 59 	. < Y 
sub_5cdch:
	push de			;5cdc	d5 	. 
	ld de,(GRPACX)		;5cdd	ed 5b b7 fc 	. [ . . 
	add hl,de			;5ce1	19 	. 
	ld b,h			;5ce2	44 	D 
	ld c,l			;5ce3	4d 	M 
	pop de			;5ce4	d1 	. 
	ld hl,(GRPACY)		;5ce5	2a b9 fc 	* . . 
	add hl,de			;5ce8	19 	. 
	ex de,hl			;5ce9	eb 	. 
	ret			;5cea	c9 	. 
sub_5cebh:
	ld hl,(ASPECT)		;5ceb	2a 31 f9 	* 1 . 
	ld a,l			;5cee	7d 	} 
	or a			;5cef	b7 	. 
	jr nz,l5cf6h		;5cf0	20 04 	  . 
	or h			;5cf2	b4 	. 
	ret nz			;5cf3	c0 	. 
	ex de,hl			;5cf4	eb 	. 
	ret			;5cf5	c9 	. 
l5cf6h:
	ld c,d			;5cf6	4a 	J 
	ld d,000h		;5cf7	16 00 	. . 
	push af			;5cf9	f5 	. 
	call sub_5d0ah		;5cfa	cd 0a 5d 	. . ] 
	ld e,080h		;5cfd	1e 80 	. . 
	add hl,de			;5cff	19 	. 
	ld e,c			;5d00	59 	Y 
	ld c,h			;5d01	4c 	L 
	pop af			;5d02	f1 	. 
	call sub_5d0ah		;5d03	cd 0a 5d 	. . ] 
	ld e,c			;5d06	59 	Y 
	add hl,de			;5d07	19 	. 
	ex de,hl			;5d08	eb 	. 
	ret			;5d09	c9 	. 
sub_5d0ah:
	ld b,008h		;5d0a	06 08 	. . 
	ld hl,0000h		;5d0c	21 00 00 	! . . 
l5d0fh:
	add hl,hl			;5d0f	29 	) 
	add a,a			;5d10	87 	. 
	jr nc,l5d14h		;5d11	30 01 	0 . 
	add hl,de			;5d13	19 	. 
l5d14h:
	djnz l5d0fh		;5d14	10 f9 	. . 
	ret			;5d16	c9 	. 
sub_5d17h:
	dec hl			;5d17	2b 	+ 
	rst 10h			;5d18	d7 	. 
	ret z			;5d19	c8 	. 
	rst 8			;5d1a	cf 	. 
	inc l			;5d1b	2c 	, 
	cp 02ch		;5d1c	fe 2c 	. , 
	ret z			;5d1e	c8 	. 
	push bc			;5d1f	c5 	. 
	call sub_4c64h		;5d20	cd 64 4c 	. d L 
	ex (sp),hl			;5d23	e3 	. 
	push hl			;5d24	e5 	. 
	call sub_2fb2h		;5d25	cd b2 2f 	. . / 
	pop bc			;5d28	c1 	. 
	ld hl,DAC		;5d29	21 f6 f7 	! . . 
	ld a,(hl)			;5d2c	7e 	~ 
	or a			;5d2d	b7 	. 
	jp p,l5d3ah		;5d2e	f2 3a 5d 	. : ] 
	and 07fh		;5d31	e6 7f 	.  
	ld (hl),a			;5d33	77 	w 
	ld hl,CLINEF		;5d34	21 35 f9 	! 5 . 
	ld a,(hl)			;5d37	7e 	~ 
	or c			;5d38	b1 	. 
	ld (hl),a			;5d39	77 	w 
l5d3ah:
	ld bc,l1540h		;5d3a	01 40 15 	. @ . 
	ld de,l5591h		;5d3d	11 91 55 	. . U 
	call l325ch		;5d40	cd 5c 32 	. \ 2 
	call sub_5d63h		;5d43	cd 63 5d 	. c ] 
	jp z,l475ah		;5d46	ca 5a 47 	. Z G 
	call sub_2eb1h		;5d49	cd b1 2e 	. . . 
	ld hl,(CNPNTS)		;5d4c	2a 36 f9 	* 6 . 
	add hl,hl			;5d4f	29 	) 
	add hl,hl			;5d50	29 	) 
	add hl,hl			;5d51	29 	) 
	call l2f99h		;5d52	cd 99 2f 	. . / 
	call sub_2fb2h		;5d55	cd b2 2f 	. . / 
	pop bc			;5d58	c1 	. 
	pop de			;5d59	d1 	. 
	call l325ch		;5d5a	cd 5c 32 	. \ 2 
	call sub_2f8ah		;5d5d	cd 8a 2f 	. . / 
	pop de			;5d60	d1 	. 
	ex de,hl			;5d61	eb 	. 
	ret			;5d62	c9 	. 
sub_5d63h:
	ld bc,l1041h		;5d63	01 41 10 	. A . 
	ld de,0000h		;5d66	11 00 00 	. . . 
	call sub_2f21h		;5d69	cd 21 2f 	. ! / 
	dec a			;5d6c	3d 	= 
	ret			;5d6d	c9 	. 
	ld a,(SCRMOD)		;5d6e	3a af fc 	: . . 
	cp 002h		;5d71	fe 02 	. . 
	jp c,l475ah		;5d73	da 5a 47 	. Z G 
	ld de,DRAWDATA_start		;5d76	11 83 5d 	. . ] 
	xor a			;5d79	af 	. 
	ld (DRWFLG),a		;5d7a	32 bb fc 	2 . . 
	ld (MCLFLG),a		;5d7d	32 58 f9 	2 X . 
	jp l566ch		;5d80	c3 6c 56 	. l V 

; BLOCK 'DRAWDATA' (start 0x5d83 end 0x5db1)
DRAWDATA_start:
	defb 0d5h		;5d83	d5 	. 
	defb 0b1h		;5d84	b1 	. 
	defb 05dh		;5d85	5d 	] 
	defb 0c4h		;5d86	c4 	. 
	defb 0b4h		;5d87	b4 	. 
	defb 05dh		;5d88	5d 	] 
	defb 0cch		;5d89	cc 	. 
	defb 0b9h		;5d8a	b9 	. 
	defb 05dh		;5d8b	5d 	] 
	defb 0d2h		;5d8c	d2 	. 
	defb 0bch		;5d8d	bc 	. 
	defb 05dh		;5d8e	5d 	] 
	defb 04dh		;5d8f	4d 	M 
	defb 0d8h		;5d90	d8 	. 
	defb 05dh		;5d91	5d 	] 
	defb 0c5h		;5d92	c5 	. 
	defb 0cah		;5d93	ca 	. 
	defb 05dh		;5d94	5d 	] 
	defb 0c6h		;5d95	c6 	. 
	defb 0c6h		;5d96	c6 	. 
	defb 05dh		;5d97	5d 	] 
	defb 0c7h		;5d98	c7 	. 
	defb 0d1h		;5d99	d1 	. 
	defb 05dh		;5d9a	5d 	] 
	defb 0c8h		;5d9b	c8 	. 
	defb 0c3h		;5d9c	c3 	. 
	defb 05dh		;5d9d	5d 	] 
	defb 0c1h		;5d9e	c1 	. 
	defb 04eh		;5d9f	4e 	N 
	defb 05eh		;5da0	5e 	^ 
	defb 042h		;5da1	42 	B 
	defb 046h		;5da2	46 	F 
	defb 05eh		;5da3	5e 	^ 
	defb 04eh		;5da4	4e 	N 
	defb 042h		;5da5	42 	B 
	defb 05eh		;5da6	5e 	^ 
	defb 058h		;5da7	58 	X 
	defb 082h		;5da8	82 	. 
	defb 057h		;5da9	57 	W 
	defb 0c3h		;5daa	c3 	. 
	defb 087h		;5dab	87 	. 
	defb 05eh		;5dac	5e 	^ 
	defb 0d3h		;5dad	d3 	. 
	defb 059h		;5dae	59 	Y 
	defb 05eh		;5daf	5e 	^ 
	defb 000h		;5db0	00 	. 
l5db1h:
	call sub_5b0bh		;5db1	cd 0b 5b 	. . [ 
	ld bc,0000h		;5db4	01 00 00 	. . . 
	jr l5dffh		;5db7	18 46 	. F 
	call sub_5b0bh		;5db9	cd 0b 5b 	. . [ 
	ld b,d			;5dbc	42 	B 
	ld c,e			;5dbd	4b 	K 
	ld de,0000h		;5dbe	11 00 00 	. . . 
	jr l5dffh		;5dc1	18 3c 	. < 
	call sub_5b0bh		;5dc3	cd 0b 5b 	. . [ 
	ld b,d			;5dc6	42 	B 
	ld c,e			;5dc7	4b 	K 
	jr l5dffh		;5dc8	18 35 	. 5 
	ld b,d			;5dca	42 	B 
	ld c,e			;5dcb	4b 	K 
l5dcch:
	call sub_5b0bh		;5dcc	cd 0b 5b 	. . [ 
	jr l5dffh		;5dcf	18 2e 	. . 
	call sub_5b0bh		;5dd1	cd 0b 5b 	. . [ 
	ld b,d			;5dd4	42 	B 
	ld c,e			;5dd5	4b 	K 
	jr l5dcch		;5dd6	18 f4 	. . 
	call sub_56e8h		;5dd8	cd e8 56 	. . V 
	ld b,000h		;5ddb	06 00 	. . 
	cp 02bh		;5ddd	fe 2b 	. + 
	jr z,l5de6h		;5ddf	28 05 	( . 
	cp 02dh		;5de1	fe 2d 	. - 
	jr z,l5de6h		;5de3	28 01 	( . 
	inc b			;5de5	04 	. 
l5de6h:
	ld a,b			;5de6	78 	x 
	push af			;5de7	f5 	. 
	call sub_570bh		;5de8	cd 0b 57 	. . W 
	call l5719h		;5deb	cd 19 57 	. . W 
	push de			;5dee	d5 	. 
	call sub_56e8h		;5def	cd e8 56 	. . V 
	cp 02ch		;5df2	fe 2c 	. , 
	jp nz,l475ah		;5df4	c2 5a 47 	. Z G 
	call l5719h		;5df7	cd 19 57 	. . W 
	pop bc			;5dfa	c1 	. 
	pop af			;5dfb	f1 	. 
	or a			;5dfc	b7 	. 
	jr nz,l5e22h		;5dfd	20 23 	  # 
l5dffh:
	call sub_5e66h		;5dff	cd 66 5e 	. f ^ 
	push de			;5e02	d5 	. 
	ld d,b			;5e03	50 	P 
	ld e,c			;5e04	59 	Y 
	call sub_5e66h		;5e05	cd 66 5e 	. f ^ 
	ex de,hl			;5e08	eb 	. 
	pop de			;5e09	d1 	. 
	ld a,(DRWANG)		;5e0a	3a bd fc 	: . . 
	rra			;5e0d	1f 	. 
	jr nc,l5e16h		;5e0e	30 06 	0 . 
	push af			;5e10	f5 	. 
	call sub_587bh		;5e11	cd 7b 58 	. { X 
	ex de,hl			;5e14	eb 	. 
	pop af			;5e15	f1 	. 
l5e16h:
	rra			;5e16	1f 	. 
	jr nc,l5e1fh		;5e17	30 06 	0 . 
	call sub_587bh		;5e19	cd 7b 58 	. { X 
	call sub_5b0bh		;5e1c	cd 0b 5b 	. . [ 
l5e1fh:
	call sub_5cdch		;5e1f	cd dc 5c 	. . \ 
l5e22h:
	ld a,(DRWFLG)		;5e22	3a bb fc 	: . . 
	add a,a			;5e25	87 	. 
	jr c,l5e31h		;5e26	38 09 	8 . 
	push af			;5e28	f5 	. 
	push bc			;5e29	c5 	. 
	push de			;5e2a	d5 	. 
	call sub_5ccdh		;5e2b	cd cd 5c 	. . \ 
	pop de			;5e2e	d1 	. 
	pop bc			;5e2f	c1 	. 
	pop af			;5e30	f1 	. 
l5e31h:
	add a,a			;5e31	87 	. 
	jr c,l5e3dh		;5e32	38 09 	8 . 
	ld (GRPACY),de		;5e34	ed 53 b9 fc 	. S . . 
	ld h,b			;5e38	60 	` 
	ld l,c			;5e39	69 	i 
	ld (GRPACX),hl		;5e3a	22 b7 fc 	" . . 
l5e3dh:
	xor a			;5e3d	af 	. 
	ld (DRWFLG),a		;5e3e	32 bb fc 	2 . . 
	ret			;5e41	c9 	. 
	ld a,040h		;5e42	3e 40 	> @ 
	jr l5e48h		;5e44	18 02 	. . 
	ld a,080h		;5e46	3e 80 	> . 
l5e48h:
	ld hl,DRWFLG		;5e48	21 bb fc 	! . . 
	or (hl)			;5e4b	b6 	. 
	ld (hl),a			;5e4c	77 	w 
	ret			;5e4d	c9 	. 
	jr nc,l5e59h		;5e4e	30 09 	0 . 
	ld a,e			;5e50	7b 	{ 
	cp 004h		;5e51	fe 04 	. . 
	jr nc,l5e59h		;5e53	30 04 	0 . 
	ld (DRWANG),a		;5e55	32 bd fc 	2 . . 
	ret			;5e58	c9 	. 
l5e59h:
	jp nc,l475ah		;5e59	d2 5a 47 	. Z G 
	ld a,d			;5e5c	7a 	z 
	or a			;5e5d	b7 	. 
	jp nz,l475ah		;5e5e	c2 5a 47 	. Z G 
	ld a,e			;5e61	7b 	{ 
	ld (DRWSCL),a		;5e62	32 bc fc 	2 . . 
	ret			;5e65	c9 	. 
sub_5e66h:
	ld a,(DRWSCL)		;5e66	3a bc fc 	: . . 
	or a			;5e69	b7 	. 
	ret z			;5e6a	c8 	. 
	ld hl,0000h		;5e6b	21 00 00 	! . . 
l5e6eh:
	add hl,de			;5e6e	19 	. 
	dec a			;5e6f	3d 	= 
	jr nz,l5e6eh		;5e70	20 fc 	  . 
	ex de,hl			;5e72	eb 	. 
	ld a,d			;5e73	7a 	z 
	add a,a			;5e74	87 	. 
	push af			;5e75	f5 	. 
	jr nc,l5e79h		;5e76	30 01 	0 . 
	dec de			;5e78	1b 	. 
l5e79h:
	call sub_59b4h		;5e79	cd b4 59 	. . Y 
	call sub_59b4h		;5e7c	cd b4 59 	. . Y 
	pop af			;5e7f	f1 	. 
	ret nc			;5e80	d0 	. 
	ld a,d			;5e81	7a 	z 
	or 0c0h		;5e82	f6 c0 	. . 
	ld d,a			;5e84	57 	W 
	inc de			;5e85	13 	. 
	ret			;5e86	c9 	. 
	jr nc,l5e59h		;5e87	30 d0 	0 . 
	ld a,e			;5e89	7b 	{ 
	call SETATR		;5e8a	cd 1a 01 	. . . 
	jp c,l475ah		;5e8d	da 5a 47 	. Z G 
	ret			;5e90	c9 	. 
sub_5e91h:
	push hl			;5e91	e5 	. 
	call SCALXY		;5e92	cd 0e 01 	. . . 
	jp nc,l475ah		;5e95	d2 5a 47 	. Z G 
	pop hl			;5e98	e1 	. 
	ret			;5e99	c9 	. 
l5e9ah:
	dec hl			;5e9a	2b 	+ 
	rst 10h			;5e9b	d7 	. 
	ret z			;5e9c	c8 	. 
	rst 8			;5e9d	cf 	. 
	inc l			;5e9e	2c 	, 
	ld bc,l5e9ah		;5e9f	01 9a 5e 	. . ^ 
	push bc			;5ea2	c5 	. 
	or 0afh		;5ea3	f6 af 	. . 
	ld (DIMFLG),a		;5ea5	32 62 f6 	2 b . 
	ld c,(hl)			;5ea8	4e 	N 
l5ea9h:
	call H.PTRG		;5ea9	cd a2 ff 	. . . 
	call sub_64a7h		;5eac	cd a7 64 	. . d 
	jp c,l4055h		;5eaf	da 55 40 	. U @ 
	xor a			;5eb2	af 	. 
	ld b,a			;5eb3	47 	G 
	rst 10h			;5eb4	d7 	. 
	jr c,l5ebch		;5eb5	38 05 	8 . 
	call sub_64a8h		;5eb7	cd a8 64 	. . d 
	jr c,l5ec5h		;5eba	38 09 	8 . 
l5ebch:
	ld b,a			;5ebc	47 	G 
l5ebdh:
	rst 10h			;5ebd	d7 	. 
	jr c,l5ebdh		;5ebe	38 fd 	8 . 
	call sub_64a8h		;5ec0	cd a8 64 	. . d 
	jr nc,l5ebdh		;5ec3	30 f8 	0 . 
l5ec5h:
	cp 026h		;5ec5	fe 26 	. & 
	jr nc,l5ee0h		;5ec7	30 17 	0 . 
	ld de,l5eeeh		;5ec9	11 ee 5e 	. . ^ 
	push de			;5ecc	d5 	. 
	ld d,002h		;5ecd	16 02 	. . 
	cp 025h		;5ecf	fe 25 	. % 
	ret z			;5ed1	c8 	. 
	inc d			;5ed2	14 	. 
	cp 024h		;5ed3	fe 24 	. $ 
	ret z			;5ed5	c8 	. 
	inc d			;5ed6	14 	. 
	cp 021h		;5ed7	fe 21 	. ! 
	ret z			;5ed9	c8 	. 
	ld d,008h		;5eda	16 08 	. . 
	cp 023h		;5edc	fe 23 	. # 
	ret z			;5ede	c8 	. 
	pop af			;5edf	f1 	. 
l5ee0h:
	ld a,c			;5ee0	79 	y 
	and 07fh		;5ee1	e6 7f 	.  
	ld e,a			;5ee3	5f 	_ 
	ld d,000h		;5ee4	16 00 	. . 
	push hl			;5ee6	e5 	. 
	ld hl,0f689h		;5ee7	21 89 f6 	! . . 
	add hl,de			;5eea	19 	. 
	ld d,(hl)			;5eeb	56 	V 
	pop hl			;5eec	e1 	. 
	dec hl			;5eed	2b 	+ 
l5eeeh:
	ld a,d			;5eee	7a 	z 
	ld (VALTYP),a		;5eef	32 63 f6 	2 c . 
	rst 10h			;5ef2	d7 	. 
	ld a,(SUBFLG)		;5ef3	3a a5 f6 	: . . 
	dec a			;5ef6	3d 	= 
	jp z,05fe8h		;5ef7	ca e8 5f 	. . _ 
	jp p,l5f08h		;5efa	f2 08 5f 	. . _ 
	ld a,(hl)			;5efd	7e 	~ 
	sub 028h		;5efe	d6 28 	. ( 
	jp z,l5fbah		;5f00	ca ba 5f 	. . _ 
	sub 033h		;5f03	d6 33 	. 3 
	jp z,l5fbah		;5f05	ca ba 5f 	. . _ 
l5f08h:
	xor a			;5f08	af 	. 
	ld (SUBFLG),a		;5f09	32 a5 f6 	2 . . 
	push hl			;5f0c	e5 	. 
	ld a,(NOFUNS)		;5f0d	3a b7 f7 	: . . 
	or a			;5f10	b7 	. 
	ld (PRMFLG),a		;5f11	32 b4 f7 	2 . . 
	jr z,l5f52h		;5f14	28 3c 	( < 
	ld hl,(PRMLEN)		;5f16	2a e6 f6 	* . . 
	ld de,PARM1		;5f19	11 e8 f6 	. . . 
	add hl,de			;5f1c	19 	. 
	ld (ARYTA2),hl		;5f1d	22 b5 f7 	" . . 
	ex de,hl			;5f20	eb 	. 
	jr l5f3ah		;5f21	18 17 	. . 
l5f23h:
	ld a,(de)			;5f23	1a 	. 
	ld l,a			;5f24	6f 	o 
	inc de			;5f25	13 	. 
	ld a,(de)			;5f26	1a 	. 
	inc de			;5f27	13 	. 
	cp c			;5f28	b9 	. 
	jr nz,l5f36h		;5f29	20 0b 	  . 
	ld a,(VALTYP)		;5f2b	3a 63 f6 	: c . 
	cp l			;5f2e	bd 	. 
	jr nz,l5f36h		;5f2f	20 05 	  . 
	ld a,(de)			;5f31	1a 	. 
	cp b			;5f32	b8 	. 
	jp z,l5fa4h		;5f33	ca a4 5f 	. . _ 
l5f36h:
	inc de			;5f36	13 	. 
	ld h,000h		;5f37	26 00 	& . 
	add hl,de			;5f39	19 	. 
l5f3ah:
	ex de,hl			;5f3a	eb 	. 
	ld a,(ARYTA2)		;5f3b	3a b5 f7 	: . . 
	cp e			;5f3e	bb 	. 
	jp nz,l5f23h		;5f3f	c2 23 5f 	. # _ 
	ld a,(0f7b6h)		;5f42	3a b6 f7 	: . . 
	cp d			;5f45	ba 	. 
	jr nz,l5f23h		;5f46	20 db 	  . 
	ld a,(PRMFLG)		;5f48	3a b4 f7 	: . . 
	or a			;5f4b	b7 	. 
	jr z,l5f66h		;5f4c	28 18 	( . 
	xor a			;5f4e	af 	. 
	ld (PRMFLG),a		;5f4f	32 b4 f7 	2 . . 
l5f52h:
	ld hl,(ARYTAB)		;5f52	2a c4 f6 	* . . 
	ld (ARYTA2),hl		;5f55	22 b5 f7 	" . . 
	ld hl,(VARTAB)		;5f58	2a c2 f6 	* . . 
	jr l5f3ah		;5f5b	18 dd 	. . 
sub_5f5dh:
	call 05ea4h		;5f5d	cd a4 5e 	. . ^ 
l5f60h:
	ret			;5f60	c9 	. 
l5f61h:
	ld d,a			;5f61	57 	W 
	ld e,a			;5f62	5f 	_ 
	pop bc			;5f63	c1 	. 
	ex (sp),hl			;5f64	e3 	. 
	ret			;5f65	c9 	. 
l5f66h:
	pop hl			;5f66	e1 	. 
	ex (sp),hl			;5f67	e3 	. 
	push de			;5f68	d5 	. 
	ld de,l5f60h		;5f69	11 60 5f 	. ` _ 
	rst 20h			;5f6c	e7 	. 
	jr z,l5f61h		;5f6d	28 f2 	( . 
	ld de,l4e9eh		;5f6f	11 9e 4e 	. . N 
	rst 20h			;5f72	e7 	. 
	pop de			;5f73	d1 	. 
	jr z,l5fa7h		;5f74	28 31 	( 1 
	ex (sp),hl			;5f76	e3 	. 
	push hl			;5f77	e5 	. 
	push bc			;5f78	c5 	. 
	ld a,(VALTYP)		;5f79	3a 63 f6 	: c . 
	ld c,a			;5f7c	4f 	O 
	push bc			;5f7d	c5 	. 
	ld b,000h		;5f7e	06 00 	. . 
	inc bc			;5f80	03 	. 
	inc bc			;5f81	03 	. 
	inc bc			;5f82	03 	. 
	ld hl,(STREND)		;5f83	2a c6 f6 	* . . 
	push hl			;5f86	e5 	. 
	add hl,bc			;5f87	09 	. 
	pop bc			;5f88	c1 	. 
	push hl			;5f89	e5 	. 
	call sub_6250h		;5f8a	cd 50 62 	. P b 
	pop hl			;5f8d	e1 	. 
	ld (STREND),hl		;5f8e	22 c6 f6 	" . . 
	ld h,b			;5f91	60 	` 
	ld l,c			;5f92	69 	i 
	ld (ARYTAB),hl		;5f93	22 c4 f6 	" . . 
l5f96h:
	dec hl			;5f96	2b 	+ 
	ld (hl),000h		;5f97	36 00 	6 . 
	rst 20h			;5f99	e7 	. 
	jr nz,l5f96h		;5f9a	20 fa 	  . 
	pop de			;5f9c	d1 	. 
	ld (hl),e			;5f9d	73 	s 
	inc hl			;5f9e	23 	# 
	pop de			;5f9f	d1 	. 
	ld (hl),e			;5fa0	73 	s 
	inc hl			;5fa1	23 	# 
	ld (hl),d			;5fa2	72 	r 
	ex de,hl			;5fa3	eb 	. 
l5fa4h:
	inc de			;5fa4	13 	. 
	pop hl			;5fa5	e1 	. 
	ret			;5fa6	c9 	. 
l5fa7h:
	ld (DAC),a		;5fa7	32 f6 f7 	2 . . 
	ld h,a			;5faa	67 	g 
	ld l,a			;5fab	6f 	o 
	ld (0f7f8h),hl		;5fac	22 f8 f7 	" . . 
	rst 28h			;5faf	ef 	. 
	jr nz,l5fb8h		;5fb0	20 06 	  . 
	ld hl,l3fd6h		;5fb2	21 d6 3f 	! . ? 
	ld (0f7f8h),hl		;5fb5	22 f8 f7 	" . . 
l5fb8h:
	pop hl			;5fb8	e1 	. 
	ret			;5fb9	c9 	. 
l5fbah:
	push hl			;5fba	e5 	. 
	ld hl,(DIMFLG)		;5fbb	2a 62 f6 	* b . 
	ex (sp),hl			;5fbe	e3 	. 
	ld d,a			;5fbf	57 	W 
l5fc0h:
	push de			;5fc0	d5 	. 
	push bc			;5fc1	c5 	. 
	call sub_4755h		;5fc2	cd 55 47 	. U G 
	pop bc			;5fc5	c1 	. 
	pop af			;5fc6	f1 	. 
	ex de,hl			;5fc7	eb 	. 
	ex (sp),hl			;5fc8	e3 	. 
	push hl			;5fc9	e5 	. 
	ex de,hl			;5fca	eb 	. 
	inc a			;5fcb	3c 	< 
	ld d,a			;5fcc	57 	W 
	ld a,(hl)			;5fcd	7e 	~ 
	cp 02ch		;5fce	fe 2c 	. , 
	jp z,l5fc0h		;5fd0	ca c0 5f 	. . _ 
	cp 029h		;5fd3	fe 29 	. ) 
	jr z,l5fdch		;5fd5	28 05 	( . 
	cp 05dh		;5fd7	fe 5d 	. ] 
	jp nz,l4055h		;5fd9	c2 55 40 	. U @ 
l5fdch:
	rst 10h			;5fdc	d7 	. 
	ld (TEMP2),hl		;5fdd	22 bc f6 	" . . 
	pop hl			;5fe0	e1 	. 
	ld (DIMFLG),hl		;5fe1	22 62 f6 	" b . 
	ld e,000h		;5fe4	1e 00 	. . 
	push de			;5fe6	d5 	. 
	ld de,0f5e5h		;5fe7	11 e5 f5 	. . . 
	ld hl,(ARYTAB)		;5fea	2a c4 f6 	* . . 
	ld a,019h		;5fed	3e 19 	> . 
	ld de,(STREND)		;5fef	ed 5b c6 f6 	. [ . . 
	rst 20h			;5ff3	e7 	. 
	jr z,l6023h		;5ff4	28 2d 	( - 
	ld e,(hl)			;5ff6	5e 	^ 
	inc hl			;5ff7	23 	# 
	ld a,(hl)			;5ff8	7e 	~ 
	inc hl			;5ff9	23 	# 
	cp c			;5ffa	b9 	. 
	jr nz,l6005h		;5ffb	20 08 	  . 
	ld a,(VALTYP)		;5ffd	3a 63 f6 	: c . 
	cp e			;6000	bb 	. 
	jr nz,l6005h		;6001	20 02 	  . 
	ld a,(hl)			;6003	7e 	~ 
	cp b			;6004	b8 	. 
l6005h:
	inc hl			;6005	23 	# 
	ld e,(hl)			;6006	5e 	^ 
	inc hl			;6007	23 	# 
	ld d,(hl)			;6008	56 	V 
	inc hl			;6009	23 	# 
	jr nz,$-28		;600a	20 e2 	  . 
	ld a,(DIMFLG)		;600c	3a 62 f6 	: b . 
	or a			;600f	b7 	. 
	jp nz,0405eh		;6010	c2 5e 40 	. ^ @ 
	pop af			;6013	f1 	. 
	ld b,h			;6014	44 	D 
	ld c,l			;6015	4d 	M 
	jp z,l3297h		;6016	ca 97 32 	. . 2 
	sub (hl)			;6019	96 	. 
	jp z,l607dh		;601a	ca 7d 60 	. } ` 
l601dh:
	ld de,0009h		;601d	11 09 00 	. . . 
	jp l406fh		;6020	c3 6f 40 	. o @ 
l6023h:
	ld a,(VALTYP)		;6023	3a 63 f6 	: c . 
	ld (hl),a			;6026	77 	w 
	inc hl			;6027	23 	# 
	ld e,a			;6028	5f 	_ 
	ld d,000h		;6029	16 00 	. . 
	pop af			;602b	f1 	. 
	jp z,l475ah		;602c	ca 5a 47 	. Z G 
	ld (hl),c			;602f	71 	q 
	inc hl			;6030	23 	# 
	ld (hl),b			;6031	70 	p 
	inc hl			;6032	23 	# 
	ld c,a			;6033	4f 	O 
	call sub_625eh		;6034	cd 5e 62 	. ^ b 
	inc hl			;6037	23 	# 
	inc hl			;6038	23 	# 
	ld (TEMP3),hl		;6039	22 9d f6 	" . . 
	ld (hl),c			;603c	71 	q 
	inc hl			;603d	23 	# 
	ld a,(DIMFLG)		;603e	3a 62 f6 	: b . 
	rla			;6041	17 	. 
	ld a,c			;6042	79 	y 
l6043h:
	ld bc,000bh		;6043	01 0b 00 	. . . 
	jr nc,l604ah		;6046	30 02 	0 . 
	pop bc			;6048	c1 	. 
	inc bc			;6049	03 	. 
l604ah:
	ld (hl),c			;604a	71 	q 
	push af			;604b	f5 	. 
	inc hl			;604c	23 	# 
	ld (hl),b			;604d	70 	p 
	inc hl			;604e	23 	# 
	call sub_314ah		;604f	cd 4a 31 	. J 1 
	pop af			;6052	f1 	. 
l6053h:
	dec a			;6053	3d 	= 
	jr nz,l6043h		;6054	20 ed 	  . 
	push af			;6056	f5 	. 
	ld b,d			;6057	42 	B 
	ld c,e			;6058	4b 	K 
	ex de,hl			;6059	eb 	. 
	add hl,de			;605a	19 	. 
	jp c,l6275h		;605b	da 75 62 	. u b 
	call 06267h		;605e	cd 67 62 	. g b 
	ld (STREND),hl		;6061	22 c6 f6 	" . . 
l6064h:
	dec hl			;6064	2b 	+ 
	ld (hl),000h		;6065	36 00 	6 . 
	rst 20h			;6067	e7 	. 
	jr nz,l6064h		;6068	20 fa 	  . 
	inc bc			;606a	03 	. 
	ld d,a			;606b	57 	W 
	ld hl,(TEMP3)		;606c	2a 9d f6 	* . . 
	ld e,(hl)			;606f	5e 	^ 
	ex de,hl			;6070	eb 	. 
	add hl,hl			;6071	29 	) 
	add hl,bc			;6072	09 	. 
	ex de,hl			;6073	eb 	. 
	dec hl			;6074	2b 	+ 
	dec hl			;6075	2b 	+ 
	ld (hl),e			;6076	73 	s 
	inc hl			;6077	23 	# 
	ld (hl),d			;6078	72 	r 
	inc hl			;6079	23 	# 
	pop af			;607a	f1 	. 
	jr c,l60adh		;607b	38 30 	8 0 
l607dh:
	ld b,a			;607d	47 	G 
	ld c,a			;607e	4f 	O 
	ld a,(hl)			;607f	7e 	~ 
	inc hl			;6080	23 	# 
	ld d,0e1h		;6081	16 e1 	. . 
	ld e,(hl)			;6083	5e 	^ 
	inc hl			;6084	23 	# 
	ld d,(hl)			;6085	56 	V 
	inc hl			;6086	23 	# 
	ex (sp),hl			;6087	e3 	. 
	push af			;6088	f5 	. 
	rst 20h			;6089	e7 	. 
	jp nc,l601dh		;608a	d2 1d 60 	. . ` 
	call sub_314ah		;608d	cd 4a 31 	. J 1 
	add hl,de			;6090	19 	. 
	pop af			;6091	f1 	. 
	dec a			;6092	3d 	= 
	ld b,h			;6093	44 	D 
	ld c,l			;6094	4d 	M 
	jr nz,$-19		;6095	20 eb 	  . 
	ld a,(VALTYP)		;6097	3a 63 f6 	: c . 
	ld b,h			;609a	44 	D 
	ld c,l			;609b	4d 	M 
	add hl,hl			;609c	29 	) 
	sub 004h		;609d	d6 04 	. . 
	jr c,l60a5h		;609f	38 04 	8 . 
	add hl,hl			;60a1	29 	) 
	jr z,l60aah		;60a2	28 06 	( . 
	add hl,hl			;60a4	29 	) 
l60a5h:
	or a			;60a5	b7 	. 
	jp po,l60aah		;60a6	e2 aa 60 	. . ` 
	add hl,bc			;60a9	09 	. 
l60aah:
	pop bc			;60aa	c1 	. 
	add hl,bc			;60ab	09 	. 
	ex de,hl			;60ac	eb 	. 
l60adh:
	ld hl,(TEMP2)		;60ad	2a bc f6 	* . . 
	ret			;60b0	c9 	. 
l60b1h:
	call sub_4c65h		;60b1	cd 65 4c 	. e L 
	call sub_3058h		;60b4	cd 58 30 	. X 0 
	rst 8			;60b7	cf 	. 
	dec sp			;60b8	3b 	; 
	ex de,hl			;60b9	eb 	. 
	ld hl,(0f7f8h)		;60ba	2a f8 f7 	* . . 
	jr l60c7h		;60bd	18 08 	. . 
l60bfh:
	ld a,(FLGINP)		;60bf	3a a6 f6 	: . . 
	or a			;60c2	b7 	. 
	jr z,l60d2h		;60c3	28 0d 	( . 
	pop de			;60c5	d1 	. 
	ex de,hl			;60c6	eb 	. 
l60c7h:
	push hl			;60c7	e5 	. 
	xor a			;60c8	af 	. 
	ld (FLGINP),a		;60c9	32 a6 f6 	2 . . 
	inc a			;60cc	3c 	< 
	push af			;60cd	f5 	. 
	push de			;60ce	d5 	. 
	ld b,(hl)			;60cf	46 	F 
	inc b			;60d0	04 	. 
	dec b			;60d1	05 	. 
l60d2h:
	jp z,l475ah		;60d2	ca 5a 47 	. Z G 
	inc hl			;60d5	23 	# 
	ld a,(hl)			;60d6	7e 	~ 
	inc hl			;60d7	23 	# 
	ld h,(hl)			;60d8	66 	f 
	ld l,a			;60d9	6f 	o 
	jr l60f6h		;60da	18 1a 	. . 
l60dch:
	ld e,b			;60dc	58 	X 
	push hl			;60dd	e5 	. 
	ld c,002h		;60de	0e 02 	. . 
l60e0h:
	ld a,(hl)			;60e0	7e 	~ 
	inc hl			;60e1	23 	# 
	cp CHRFLN		;60e2	fe 26 	. & 
	jp z,06210h		;60e4	ca 10 62 	. . b 
	cp 020h		;60e7	fe 20 	.   
	jr nz,l60eeh		;60e9	20 03 	  . 
	inc c			;60eb	0c 	. 
	djnz l60e0h		;60ec	10 f2 	. . 
l60eeh:
	pop hl			;60ee	e1 	. 
	ld b,e			;60ef	43 	C 
	ld a,CHRFLN		;60f0	3e 26 	> & 
l60f2h:
	call sub_6246h		;60f2	cd 46 62 	. F b 
	rst 18h			;60f5	df 	. 
l60f6h:
	xor a			;60f6	af 	. 
	ld e,a			;60f7	5f 	_ 
	ld d,a			;60f8	57 	W 
l60f9h:
	call sub_6246h		;60f9	cd 46 62 	. F b 
	ld d,a			;60fc	57 	W 
	ld a,(hl)			;60fd	7e 	~ 
	inc hl			;60fe	23 	# 
	cp 021h		;60ff	fe 21 	. ! 
	jp z,l620dh		;6101	ca 0d 62 	. . b 
	cp 023h		;6104	fe 23 	. # 
	jr z,l6144h		;6106	28 3c 	( < 
	cp CHRVLN		;6108	fe 40 	. @ 
	jp z,l6209h		;610a	ca 09 62 	. . b 
	dec b			;610d	05 	. 
	jp z,l61f5h		;610e	ca f5 61 	. . a 
	cp 02bh		;6111	fe 2b 	. + 
	ld a,008h		;6113	3e 08 	> . 
	jr z,l60f9h		;6115	28 e2 	( . 
	dec hl			;6117	2b 	+ 
	ld a,(hl)			;6118	7e 	~ 
	inc hl			;6119	23 	# 
	cp 02eh		;611a	fe 2e 	. . 
	jr z,l615eh		;611c	28 40 	( @ 
	cp CHRFLN		;611e	fe 26 	. & 
	jr z,l60dch		;6120	28 ba 	( . 
	cp (hl)			;6122	be 	. 
	jr nz,l60f2h		;6123	20 cd 	  . 
	cp CHRCUR		;6125	fe 5c 	. \ 
	jr z,$+22		;6127	28 14 	( . 
	cp 02ah		;6129	fe 2a 	. * 
	jr nz,l60f2h		;612b	20 c5 	  . 
	inc hl			;612d	23 	# 
	ld a,b			;612e	78 	x 
	cp 002h		;612f	fe 02 	. . 
	jr c,l6136h		;6131	38 03 	8 . 
	ld a,(hl)			;6133	7e 	~ 
	cp CHRCUR		;6134	fe 5c 	. \ 
l6136h:
	ld a,020h		;6136	3e 20 	>   
	jr nz,l6141h		;6138	20 07 	  . 
	dec b			;613a	05 	. 
	inc e			;613b	1c 	. 
	cp 0afh		;613c	fe af 	. . 
	add a,010h		;613e	c6 10 	. . 
	inc hl			;6140	23 	# 
l6141h:
	inc e			;6141	1c 	. 
	add a,d			;6142	82 	. 
	ld d,a			;6143	57 	W 
l6144h:
	inc e			;6144	1c 	. 
	ld c,000h		;6145	0e 00 	. . 
	dec b			;6147	05 	. 
	jr z,l6192h		;6148	28 48 	( H 
	ld a,(hl)			;614a	7e 	~ 
	inc hl			;614b	23 	# 
	cp 02eh		;614c	fe 2e 	. . 
	jr z,l6169h		;614e	28 19 	( . 
	cp 023h		;6150	fe 23 	. # 
	jr z,l6144h		;6152	28 f0 	( . 
	cp 02ch		;6154	fe 2c 	. , 
	jr nz,l6173h		;6156	20 1b 	  . 
	ld a,d			;6158	7a 	z 
	or 040h		;6159	f6 40 	. @ 
	ld d,a			;615b	57 	W 
	jr l6144h		;615c	18 e6 	. . 
l615eh:
	ld a,(hl)			;615e	7e 	~ 
	cp 023h		;615f	fe 23 	. # 
	ld a,02eh		;6161	3e 2e 	> . 
	jp nz,l60f2h		;6163	c2 f2 60 	. . ` 
	ld c,001h		;6166	0e 01 	. . 
	inc hl			;6168	23 	# 
l6169h:
	inc c			;6169	0c 	. 
	dec b			;616a	05 	. 
	jr z,l6192h		;616b	28 25 	( % 
	ld a,(hl)			;616d	7e 	~ 
	inc hl			;616e	23 	# 
	cp 023h		;616f	fe 23 	. # 
	jr z,l6169h		;6171	28 f6 	( . 
l6173h:
	push de			;6173	d5 	. 
	ld de,06190h		;6174	11 90 61 	. . a 
	push de			;6177	d5 	. 
	ld d,h			;6178	54 	T 
	ld e,l			;6179	5d 	] 
	cp 05eh		;617a	fe 5e 	. ^ 
	ret nz			;617c	c0 	. 
	cp (hl)			;617d	be 	. 
	ret nz			;617e	c0 	. 
	inc hl			;617f	23 	# 
	cp (hl)			;6180	be 	. 
	ret nz			;6181	c0 	. 
	inc hl			;6182	23 	# 
	cp (hl)			;6183	be 	. 
	ret nz			;6184	c0 	. 
	inc hl			;6185	23 	# 
	ld a,b			;6186	78 	x 
	sub 004h		;6187	d6 04 	. . 
	ret c			;6189	d8 	. 
	pop de			;618a	d1 	. 
	pop de			;618b	d1 	. 
	ld b,a			;618c	47 	G 
	inc d			;618d	14 	. 
	inc hl			;618e	23 	# 
	jp z,0d1ebh		;618f	ca eb d1 	. . . 
l6192h:
	ld a,d			;6192	7a 	z 
	dec hl			;6193	2b 	+ 
	inc e			;6194	1c 	. 
	and 008h		;6195	e6 08 	. . 
	jr nz,l61aeh		;6197	20 15 	  . 
	dec e			;6199	1d 	. 
	ld a,b			;619a	78 	x 
	or a			;619b	b7 	. 
	jr z,l61aeh		;619c	28 10 	( . 
	ld a,(hl)			;619e	7e 	~ 
	sub 02dh		;619f	d6 2d 	. - 
	jr z,l61a9h		;61a1	28 06 	( . 
	cp 0feh		;61a3	fe fe 	. . 
	jr nz,l61aeh		;61a5	20 07 	  . 
	ld a,008h		;61a7	3e 08 	> . 
l61a9h:
	add a,004h		;61a9	c6 04 	. . 
	add a,d			;61ab	82 	. 
	ld d,a			;61ac	57 	W 
	dec b			;61ad	05 	. 
l61aeh:
	pop hl			;61ae	e1 	. 
	pop af			;61af	f1 	. 
	jr z,l61feh		;61b0	28 4c 	( L 
	push bc			;61b2	c5 	. 
	push de			;61b3	d5 	. 
	call sub_4c64h		;61b4	cd 64 4c 	. d L 
	pop de			;61b7	d1 	. 
	pop bc			;61b8	c1 	. 
	push bc			;61b9	c5 	. 
	push hl			;61ba	e5 	. 
	ld b,e			;61bb	43 	C 
	ld a,b			;61bc	78 	x 
	add a,c			;61bd	81 	. 
	cp 019h		;61be	fe 19 	. . 
	jp nc,l475ah		;61c0	d2 5a 47 	. Z G 
	ld a,d			;61c3	7a 	z 
	or 080h		;61c4	f6 80 	. . 
	call sub_3426h		;61c6	cd 26 34 	. & 4 
	call sub_6678h		;61c9	cd 78 66 	. x f 
l61cch:
	pop hl			;61cc	e1 	. 
	dec hl			;61cd	2b 	+ 
	rst 10h			;61ce	d7 	. 
	scf			;61cf	37 	7 
	jr z,l61ddh		;61d0	28 0b 	( . 
	ld (FLGINP),a		;61d2	32 a6 f6 	2 . . 
	cp 03bh		;61d5	fe 3b 	. ; 
	jr z,$+5		;61d7	28 03 	( . 
	rst 8			;61d9	cf 	. 
	inc l			;61da	2c 	, 
	ld b,0d7h		;61db	06 d7 	. . 
l61ddh:
	pop bc			;61dd	c1 	. 
	ex de,hl			;61de	eb 	. 
	pop hl			;61df	e1 	. 
	push hl			;61e0	e5 	. 
	push af			;61e1	f5 	. 
	push de			;61e2	d5 	. 
	ld a,(hl)			;61e3	7e 	~ 
	sub b			;61e4	90 	. 
	inc hl			;61e5	23 	# 
	ld d,000h		;61e6	16 00 	. . 
	ld e,a			;61e8	5f 	_ 
	ld a,(hl)			;61e9	7e 	~ 
	inc hl			;61ea	23 	# 
	ld h,(hl)			;61eb	66 	f 
	ld l,a			;61ec	6f 	o 
	add hl,de			;61ed	19 	. 
	ld a,b			;61ee	78 	x 
	or a			;61ef	b7 	. 
	jp nz,l60f6h		;61f0	c2 f6 60 	. . ` 
	jr l61f9h		;61f3	18 04 	. . 
l61f5h:
	call sub_6246h		;61f5	cd 46 62 	. F b 
	rst 18h			;61f8	df 	. 
l61f9h:
	pop hl			;61f9	e1 	. 
	pop af			;61fa	f1 	. 
	jp nz,l60bfh		;61fb	c2 bf 60 	. . ` 
l61feh:
	call c,sub_7328h		;61fe	dc 28 73 	. ( s 
	ex (sp),hl			;6201	e3 	. 
	call sub_67d6h		;6202	cd d6 67 	. . g 
	pop hl			;6205	e1 	. 
	jp l4affh		;6206	c3 ff 4a 	. . J 
l6209h:
	ld c,000h		;6209	0e 00 	. . 
	jr l6211h		;620b	18 04 	. . 
l620dh:
	ld c,001h		;620d	0e 01 	. . 
	ld a,0f1h		;620f	3e f1 	> . 
l6211h:
	dec b			;6211	05 	. 
	call sub_6246h		;6212	cd 46 62 	. F b 
	pop hl			;6215	e1 	. 
	pop af			;6216	f1 	. 
	jr z,l61feh		;6217	28 e5 	( . 
	push bc			;6219	c5 	. 
	call sub_4c64h		;621a	cd 64 4c 	. d L 
	call sub_3058h		;621d	cd 58 30 	. X 0 
	pop bc			;6220	c1 	. 
	push bc			;6221	c5 	. 
	push hl			;6222	e5 	. 
	ld hl,(0f7f8h)		;6223	2a f8 f7 	* . . 
	ld b,c			;6226	41 	A 
	ld c,000h		;6227	0e 00 	. . 
	ld a,b			;6229	78 	x 
	push af			;622a	f5 	. 
	or a			;622b	b7 	. 
	call nz,06868h		;622c	c4 68 68 	. h h 
	call sub_667bh		;622f	cd 7b 66 	. { f 
	ld hl,(0f7f8h)		;6232	2a f8 f7 	* . . 
	pop af			;6235	f1 	. 
	or a			;6236	b7 	. 
	jp z,l61cch		;6237	ca cc 61 	. . a 
	sub (hl)			;623a	96 	. 
	ld b,a			;623b	47 	G 
	ld a,020h		;623c	3e 20 	>   
	inc b			;623e	04 	. 
l623fh:
	dec b			;623f	05 	. 
	jp z,l61cch		;6240	ca cc 61 	. . a 
	rst 18h			;6243	df 	. 
	jr l623fh		;6244	18 f9 	. . 
sub_6246h:
	push af			;6246	f5 	. 
	ld a,d			;6247	7a 	z 
	or a			;6248	b7 	. 
	ld a,02bh		;6249	3e 2b 	> + 
	call nz,OUTDO		;624b	c4 18 00 	. . . 
	pop af			;624e	f1 	. 
	ret			;624f	c9 	. 
sub_6250h:
	call 06267h		;6250	cd 67 62 	. g b 
sub_6253h:
	push bc			;6253	c5 	. 
	ex (sp),hl			;6254	e3 	. 
	pop bc			;6255	c1 	. 
l6256h:
	rst 20h			;6256	e7 	. 
	ld a,(hl)			;6257	7e 	~ 
	ld (bc),a			;6258	02 	. 
	ret z			;6259	c8 	. 
	dec bc			;625a	0b 	. 
	dec hl			;625b	2b 	+ 
	jr l6256h		;625c	18 f8 	. . 
sub_625eh:
	push hl			;625e	e5 	. 
	ld hl,(STREND)		;625f	2a c6 f6 	* . . 
	ld b,000h		;6262	06 00 	. . 
	add hl,bc		;6264	09 	. 
	add hl,bc		;6265	09 	. 
        defb 03eh
sub_6267h:
        push hl
        ; Stack space
    IF VERSION == 3
	ld a,088h		;6268	3e 88 	> . 
    ELSE
	ld a,060h		;6268	3e 60 	> ` 
    ENDIF
	sub l			;626a	95 	. 
	ld l,a			;626b	6f 	o 
    IF VERSION == 3
	ld a,0ffh		;626c	3e ff 	> . 
    ELSE
	ld a,0ffh		;626c	3e ff 	> . 
    ENDIF
	sbc a,h			;626e	9c 	. 
	ld h,a			;626f	67 	g 
	jr c,l6275h		;6270	38 03 	8 . 
	add hl,sp			;6272	39 	9 
	pop hl			;6273	e1 	. 
	ret c			;6274	d8 	. 
l6275h:
	call sub_4253h		;6275	cd 53 42 	. S B 
	ld hl,(STKTOP)		;6278	2a 74 f6 	* t . 
	dec hl			;627b	2b 	+ 
	dec hl			;627c	2b 	+ 
	ld (SAVSTK),hl		;627d	22 b1 f6 	" . . 
	ld de,0007h		;6280	11 07 00 	. . . 
	jp l406fh		;6283	c3 6f 40 	. o @ 
	ret nz			;6286	c0 	. 
sub_6287h:
	ld hl,(TXTTAB)		;6287	2a 76 f6 	* v . 
	call 06439h		;628a	cd 39 64 	. 9 d 
	ld (AUTFLG),a		;628d	32 aa f6 	2 . . 
	ld (PTRFLG),a		;6290	32 a9 f6 	2 . . 
	ld (hl),a			;6293	77 	w 
	inc hl			;6294	23 	# 
	ld (hl),a			;6295	77 	w 
	inc hl			;6296	23 	# 
	ld (VARTAB),hl		;6297	22 c2 f6 	" . . 
sub_629ah:
	call H.RUNC		;629a	cd cb fe 	. . . 
	ld hl,(TXTTAB)		;629d	2a 76 f6 	* v . 
	dec hl			;62a0	2b 	+ 
sub_62a1h:
	call H.CLEA		;62a1	cd d0 fe 	. . . 
	ld (TEMP),hl		;62a4	22 a7 f6 	" . . 
sub_62a7h:
	call sub_636eh		;62a7	cd 6e 63 	. n c 
	ld b,01ah		;62aa	06 1a 	. . 
	ld hl,DEFTBL		;62ac	21 ca f6 	! . . 
	call H.LOPD		;62af	cd d5 fe 	. . . 
l62b2h:
	ld (hl),008h		;62b2	36 08 	6 . 
	inc hl			;62b4	23 	# 
	djnz l62b2h		;62b5	10 fb 	. . 
	call sub_2c24h		;62b7	cd 24 2c 	. $ , 
	xor a			;62ba	af 	. 
	ld (ONEFLG),a		;62bb	32 bb f6 	2 . . 
	ld l,a			;62be	6f 	o 
	ld h,a			;62bf	67 	g 
	ld (ONELIN),hl		;62c0	22 b9 f6 	" . . 
	ld (OLDTXT),hl		;62c3	22 c0 f6 	" . . 
	ld hl,(MEMSIZ)		;62c6	2a 72 f6 	* r . 
	ld (FRETOP),hl		;62c9	22 9b f6 	" . . 
	call sub_63c9h		;62cc	cd c9 63 	. . c 
	ld hl,(VARTAB)		;62cf	2a c2 f6 	* . . 
	ld (ARYTAB),hl		;62d2	22 c4 f6 	" . . 
	ld (STREND),hl		;62d5	22 c6 f6 	" . . 
	call sub_6c1ch		;62d8	cd 1c 6c 	. . l 
	ld a,(NLONLY)		;62db	3a 7c f8 	: | . 
	and 001h		;62de	e6 01 	. . 
	jr nz,l62e5h		;62e0	20 03 	  . 
	ld (NLONLY),a		;62e2	32 7c f8 	2 | . 
l62e5h:
	pop bc			;62e5	c1 	. 
	ld hl,(STKTOP)		;62e6	2a 74 f6 	* t . 
	dec hl			;62e9	2b 	+ 
	dec hl			;62ea	2b 	+ 
	ld (SAVSTK),hl		;62eb	22 b1 f6 	" . . 
	inc hl			;62ee	23 	# 
	inc hl			;62ef	23 	# 
l62f0h:
	call H.STKE		;62f0	cd da fe 	. . . 
	ld sp,hl			;62f3	f9 	. 
	ld hl,TEMPST		;62f4	21 7a f6 	! z . 
	ld (TEMPPT),hl		;62f7	22 78 f6 	" x . 
	call sub_7304h		;62fa	cd 04 73 	. . s 
	call l4affh		;62fd	cd ff 4a 	. . J 
	xor a			;6300	af 	. 
	ld h,a			;6301	67 	g 
	ld l,a			;6302	6f 	o 
	ld (PRMLEN),hl		;6303	22 e6 f6 	" . . 
	ld (NOFUNS),a		;6306	32 b7 f7 	2 . . 
	ld (PRMLN2),hl		;6309	22 4e f7 	" N . 
	ld (FUNACT),hl		;630c	22 ba f7 	" . . 
	ld (PRMSTK),hl		;630f	22 e4 f6 	" . . 
	ld (SUBFLG),a		;6312	32 a5 f6 	2 . . 
	push hl			;6315	e5 	. 
	push bc			;6316	c5 	. 
l6317h:
	ld hl,(TEMP)		;6317	2a a7 f6 	* . . 
	ret			;631a	c9 	. 
l631bh:
	di			;631b	f3 	. 
	ld a,(hl)			;631c	7e 	~ 
	and 004h		;631d	e6 04 	. . 
	or 001h		;631f	f6 01 	. . 
	cp (hl)			;6321	be 	. 
	ld (hl),a			;6322	77 	w 
	jr z,l6329h		;6323	28 04 	( . 
	and 004h		;6325	e6 04 	. . 
	jr nz,l634fh		;6327	20 26 	  & 
l6329h:
	ei			;6329	fb 	. 
	ret			;632a	c9 	. 
l632bh:
	di			;632b	f3 	. 
	ld a,(hl)			;632c	7e 	~ 
	ld (hl),000h		;632d	36 00 	6 . 
	jr l6338h		;632f	18 07 	. . 
sub_6331h:
	di			;6331	f3 	. 
	ld a,(hl)			;6332	7e 	~ 
	push af			;6333	f5 	. 
	or 002h		;6334	f6 02 	. . 
	ld (hl),a			;6336	77 	w 
	pop af			;6337	f1 	. 
l6338h:
	xor 005h		;6338	ee 05 	. . 
	jr z,l6362h		;633a	28 26 	( & 
	ei			;633c	fb 	. 
	ret			;633d	c9 	. 
sub_633eh:
	di			;633e	f3 	. 
	ld a,(hl)			;633f	7e 	~ 
	and 005h		;6340	e6 05 	. . 
	cp (hl)			;6342	be 	. 
	ld (hl),a			;6343	77 	w 
	jr nz,l6348h		;6344	20 02 	  . 
	ei			;6346	fb 	. 
	ret			;6347	c9 	. 
l6348h:
	xor 005h		;6348	ee 05 	. . 
	jr z,l634fh		;634a	28 03 	( . 
	ei			;634c	fb 	. 
	ret			;634d	c9 	. 
	di			;634e	f3 	. 
l634fh:
	ld a,(ONGSBF)		;634f	3a d8 fb 	: . . 
	inc a			;6352	3c 	< 
	ld (ONGSBF),a		;6353	32 d8 fb 	2 . . 
	ei			;6356	fb 	. 
	ret			;6357	c9 	. 
sub_6358h:
	di			;6358	f3 	. 
	ld a,(hl)			;6359	7e 	~ 
	and 003h		;635a	e6 03 	. . 
	cp (hl)			;635c	be 	. 
	ld (hl),a			;635d	77 	w 
	jr nz,l6362h		;635e	20 02 	  . 
l6360h:
	ei			;6360	fb 	. 
	ret			;6361	c9 	. 
l6362h:
	ld a,(ONGSBF)		;6362	3a d8 fb 	: . . 
	sub 001h		;6365	d6 01 	. . 
	jr c,l6360h		;6367	38 f7 	8 . 
	ld (ONGSBF),a		;6369	32 d8 fb 	2 . . 
	ei			;636c	fb 	. 
	ret			;636d	c9 	. 
sub_636eh:
	ld hl,TRPTBL		;636e	21 4c fc 	! L . 
	ld b,01ah		;6371	06 1a 	. . 
	xor a			;6373	af 	. 
l6374h:
	ld (hl),a			;6374	77 	w 
	inc hl			;6375	23 	# 
	ld (hl),a			;6376	77 	w 
	inc hl			;6377	23 	# 
	ld (hl),a			;6378	77 	w 
	inc hl			;6379	23 	# 
	djnz l6374h		;637a	10 f8 	. . 
	ld hl,FNKFLG		;637c	21 ce fb 	! . . 
	ld b,00ah		;637f	06 0a 	. . 
l6381h:
	ld (hl),a			;6381	77 	w 
	inc hl			;6382	23 	# 
	djnz l6381h		;6383	10 fc 	. . 
	ld (ONGSBF),a		;6385	32 d8 fb 	2 . . 
	ret			;6388	c9 	. 
sub_6389h:
	ld a,(ONEFLG)		;6389	3a bb f6 	: . . 
	or a			;638c	b7 	. 
	ret nz			;638d	c0 	. 
	push hl			;638e	e5 	. 
	ld hl,(CURLIN)		;638f	2a 1c f4 	* . . 
	ld a,h			;6392	7c 	| 
	and l			;6393	a5 	. 
	inc a			;6394	3c 	< 
	jr z,l63a6h		;6395	28 0f 	( . 
	ld hl,TRPTBL		;6397	21 4c fc 	! L . 
	ld b,01ah		;639a	06 1a 	. . 
l639ch:
	ld a,(hl)			;639c	7e 	~ 
	cp 005h		;639d	fe 05 	. . 
	jr z,l63a8h		;639f	28 07 	( . 
l63a1h:
	inc hl			;63a1	23 	# 
	inc hl			;63a2	23 	# 
	inc hl			;63a3	23 	# 
	djnz l639ch		;63a4	10 f6 	. . 
l63a6h:
	pop hl			;63a6	e1 	. 
	ret			;63a7	c9 	. 
l63a8h:
	push bc			;63a8	c5 	. 
	inc hl			;63a9	23 	# 
	ld e,(hl)			;63aa	5e 	^ 
	inc hl			;63ab	23 	# 
	ld d,(hl)			;63ac	56 	V 
	dec hl			;63ad	2b 	+ 
	dec hl			;63ae	2b 	+ 
	ld a,d			;63af	7a 	z 
	or e			;63b0	b3 	. 
	pop bc			;63b1	c1 	. 
	jr z,l63a1h		;63b2	28 ed 	( . 
	push de			;63b4	d5 	. 
	push hl			;63b5	e5 	. 
	call sub_6358h		;63b6	cd 58 63 	. X c 
	call sub_6331h		;63b9	cd 31 63 	. 1 c 
	ld c,003h		;63bc	0e 03 	. . 
	call sub_625eh		;63be	cd 5e 62 	. ^ b 
	pop bc			;63c1	c1 	. 
	pop de			;63c2	d1 	. 
	pop hl			;63c3	e1 	. 
	ex (sp),hl			;63c4	e3 	. 
	pop hl			;63c5	e1 	. 
	jp l47cfh		;63c6	c3 cf 47 	. . G 
sub_63c9h:
	ex de,hl			;63c9	eb 	. 
	ld hl,(TXTTAB)		;63ca	2a 76 f6 	* v . 
	jr z,l63ddh		;63cd	28 0e 	( . 
	ex de,hl			;63cf	eb 	. 
	call sub_4769h		;63d0	cd 69 47 	. i G 
	push hl			;63d3	e5 	. 
	call sub_4295h		;63d4	cd 95 42 	. . B 
	ld h,b			;63d7	60 	` 
	ld l,c			;63d8	69 	i 
	pop de			;63d9	d1 	. 
	jp nc,l481ch		;63da	d2 1c 48 	. . H 
l63ddh:
	dec hl			;63dd	2b 	+ 
l63deh:
	ld (DATPTR),hl		;63de	22 c8 f6 	" . . 
	ex de,hl			;63e1	eb 	. 
	ret			;63e2	c9 	. 
	jp nz,l77a5h		;63e3	c2 a5 77 	. . w 
l63e6h:
	ret nz			;63e6	c0 	. 
	inc a			;63e7	3c 	< 
	jr l63f4h		;63e8	18 0a 	. . 
	ret nz			;63ea	c0 	. 
	xor a			;63eb	af 	. 
	ld (ONEFLG),a		;63ec	32 bb f6 	2 . . 
	push af			;63ef	f5 	. 
	call z,sub_6c1ch		;63f0	cc 1c 6c 	. . l 
	pop af			;63f3	f1 	. 
l63f4h:
	ld (SAVTXT),hl		;63f4	22 af f6 	" . . 
	ld hl,TEMPST		;63f7	21 7a f6 	! z . 
	ld (TEMPPT),hl		;63fa	22 78 f6 	" x . 
	ld hl,0fff6h		;63fd	21 f6 ff 	! . . 
	pop bc			;6400	c1 	. 
l6401h:
	ld hl,(CURLIN)		;6401	2a 1c f4 	* . . 
	push hl			;6404	e5 	. 
l6405h:
	push af			;6405	f5 	. 
	ld a,l			;6406	7d 	} 
	and h			;6407	a4 	. 
	inc a			;6408	3c 	< 
	jr z,l6414h		;6409	28 09 	( . 
	ld (OLDLIN),hl		;640b	22 be f6 	" . . 
	ld hl,(SAVTXT)		;640e	2a af f6 	* . . 
	ld (OLDTXT),hl		;6411	22 c0 f6 	" . . 
l6414h:
	call sub_7304h		;6414	cd 04 73 	. . s 
	call sub_7323h		;6417	cd 23 73 	. # s 
	pop af			;641a	f1 	. 
	ld hl,l3fdch		;641b	21 dc 3f 	! . ? 
	jp nz,l40fdh		;641e	c2 fd 40 	. . @ 
	jp 0411eh		;6421	c3 1e 41 	. . A 
	ld hl,(OLDTXT)		;6424	2a c0 f6 	* . . 
	ld a,h			;6427	7c 	| 
	or l			;6428	b5 	. 
	ld de,CHRGTR+1		;6429	11 11 00 	. . . 
	jp z,l406fh		;642c	ca 6f 40 	. o @ 
	ld de,(OLDLIN)		;642f	ed 5b be f6 	. [ . . 
	ld (CURLIN),de		;6433	ed 53 1c f4 	. S . . 
	ret			;6437	c9 	. 
	ld a,0afh		;6438	3e af 	> . 
	ld (TRCFLG),a		;643a	32 c4 f7 	2 . . 
	ret			;643d	c9 	. 
	call 05ea4h		;643e	cd a4 5e 	. . ^ 
	push de			;6441	d5 	. 
	push hl			;6442	e5 	. 
	ld hl,SWPTMP		;6443	21 bc f7 	! . . 
	call l2ef3h		;6446	cd f3 2e 	. . . 
	ld hl,(ARYTAB)		;6449	2a c4 f6 	* . . 
	ex (sp),hl			;644c	e3 	. 
	rst 28h			;644d	ef 	. 
	push af			;644e	f5 	. 
	rst 8			;644f	cf 	. 
	inc l			;6450	2c 	, 
	call 05ea4h		;6451	cd a4 5e 	. . ^ 
	pop af			;6454	f1 	. 
	ld b,a			;6455	47 	G 
	rst 28h			;6456	ef 	. 
	cp b			;6457	b8 	. 
	jp nz,0406dh		;6458	c2 6d 40 	. m @ 
	ex (sp),hl			;645b	e3 	. 
	ex de,hl			;645c	eb 	. 
	push hl			;645d	e5 	. 
	ld hl,(ARYTAB)		;645e	2a c4 f6 	* . . 
	rst 20h			;6461	e7 	. 
	jr nz,l6474h		;6462	20 10 	  . 
	pop de			;6464	d1 	. 
	pop hl			;6465	e1 	. 
	ex (sp),hl			;6466	e3 	. 
	push de			;6467	d5 	. 
	call l2ef3h		;6468	cd f3 2e 	. . . 
	pop hl			;646b	e1 	. 
	ld de,SWPTMP		;646c	11 bc f7 	. . . 
	call l2ef3h		;646f	cd f3 2e 	. . . 
	pop hl			;6472	e1 	. 
	ret			;6473	c9 	. 
l6474h:
	jp l475ah		;6474	c3 5a 47 	. Z G 
l6477h:
	ld a,001h		;6477	3e 01 	> . 
	ld (SUBFLG),a		;6479	32 a5 f6 	2 . . 
	call 05ea4h		;647c	cd a4 5e 	. . ^ 
	push hl			;647f	e5 	. 
	ld (SUBFLG),a		;6480	32 a5 f6 	2 . . 
	ld h,b			;6483	60 	` 
	ld l,c			;6484	69 	i 
	dec bc			;6485	0b 	. 
	dec bc			;6486	0b 	. 
	dec bc			;6487	0b 	. 
	dec bc			;6488	0b 	. 
	dec bc			;6489	0b 	. 
	add hl,de			;648a	19 	. 
	ex de,hl			;648b	eb 	. 
	ld hl,(STREND)		;648c	2a c6 f6 	* . . 
l648fh:
	rst 20h			;648f	e7 	. 
	ld a,(de)			;6490	1a 	. 
	ld (bc),a			;6491	02 	. 
	inc de			;6492	13 	. 
	inc bc			;6493	03 	. 
	jr nz,l648fh		;6494	20 f9 	  . 
	dec bc			;6496	0b 	. 
	ld h,b			;6497	60 	` 
	ld l,c			;6498	69 	i 
	ld (STREND),hl		;6499	22 c6 f6 	" . . 
	pop hl			;649c	e1 	. 
	ld a,(hl)			;649d	7e 	~ 
	cp 02ch		;649e	fe 2c 	. , 
	ret nz			;64a0	c0 	. 
	rst 10h			;64a1	d7 	. 
	jr l6477h		;64a2	18 d3 	. . 
	pop af			;64a4	f1 	. 
	pop hl			;64a5	e1 	. 
	ret			;64a6	c9 	. 
sub_64a7h:
	ld a,(hl)			;64a7	7e 	~ 
sub_64a8h:
	cp 041h		;64a8	fe 41 	. A 
	ret c			;64aa	d8 	. 
	cp 05bh		;64ab	fe 5b 	. [ 
	ccf			;64ad	3f 	? 
	ret			;64ae	c9 	. 
	jp z,sub_62a1h		;64af	ca a1 62 	. . b 
	call sub_4756h		;64b2	cd 56 47 	. V G 
	dec hl			;64b5	2b 	+ 
	rst 10h			;64b6	d7 	. 
	push hl			;64b7	e5 	. 
	ld hl,(HIMEM)		;64b8	2a 4a fc 	* J . 
	ld b,h			;64bb	44 	D 
	ld c,l			;64bc	4d 	M 
	ld hl,(MEMSIZ)		;64bd	2a 72 f6 	* r . 
	jr z,l64ech		;64c0	28 2a 	( * 
	pop hl			;64c2	e1 	. 
	rst 8			;64c3	cf 	. 
	inc l			;64c4	2c 	, 
	push de			;64c5	d5 	. 
	call sub_542fh		;64c6	cd 2f 54 	. / T 
	dec hl			;64c9	2b 	+ 
	rst 10h			;64ca	d7 	. 
	jp nz,l4055h		;64cb	c2 55 40 	. U @ 
	ex (sp),hl			;64ce	e3 	. 
	ex de,hl			;64cf	eb 	. 
	ld a,h			;64d0	7c 	| 
	and a			;64d1	a7 	. 
	jp p,l475ah		;64d2	f2 5a 47 	. Z G 
	push de			;64d5	d5 	. 
	ld de,0f381h		;64d6	11 81 f3 	. . . 
	rst 20h			;64d9	e7 	. 
	jp nc,l475ah		;64da	d2 5a 47 	. Z G 
	pop de			;64dd	d1 	. 
	push hl			;64de	e5 	. 
	ld bc,0fef5h		;64df	01 f5 fe 	. . . 
	ld a,(MAXFIL)		;64e2	3a 5f f8 	: _ . 
l64e5h:
	add hl,bc			;64e5	09 	. 
	dec a			;64e6	3d 	= 
	jp l7a1fh		;64e7	c3 1f 7a 	. . z 
l64eah:
	pop bc			;64ea	c1 	. 
	dec hl			;64eb	2b 	+ 
l64ech:
	ld a,l			;64ec	7d 	} 
	sub e			;64ed	93 	. 
	ld e,a			;64ee	5f 	_ 
	ld a,h			;64ef	7c 	| 
	sbc a,d			;64f0	9a 	. 
	ld d,a			;64f1	57 	W 
	jp c,l6275h		;64f2	da 75 62 	. u b 
	push hl			;64f5	e5 	. 
	ld hl,(VARTAB)		;64f6	2a c2 f6 	* . . 
	push bc			;64f9	c5 	. 
	ld bc,CHGET+1		;64fa	01 a0 00 	. . . 
	add hl,bc			;64fd	09 	. 
	pop bc			;64fe	c1 	. 
	rst 20h			;64ff	e7 	. 
	jp nc,l6275h		;6500	d2 75 62 	. u b 
	ex de,hl			;6503	eb 	. 
	ld (STKTOP),hl		;6504	22 74 f6 	" t . 
	ld h,b			;6507	60 	` 
	ld l,c			;6508	69 	i 
	ld (HIMEM),hl		;6509	22 4a fc 	" J . 
	pop hl			;650c	e1 	. 
	ld (MEMSIZ),hl		;650d	22 72 f6 	" r . 
	pop hl			;6510	e1 	. 
	call sub_62a1h		;6511	cd a1 62 	. . b 
	ld a,(MAXFIL)		;6514	3a 5f f8 	: _ . 
	call sub_7e6bh		;6517	cd 6b 7e 	. k ~ 
	ld hl,(TEMP)		;651a	2a a7 f6 	* . . 
	jp l4601h		;651d	c3 01 46 	. . F 
	ld a,l			;6520	7d 	} 
	sub e			;6521	93 	. 
	ld e,a			;6522	5f 	_ 
	ld a,h			;6523	7c 	| 
	sbc a,d			;6524	9a 	. 
	ld d,a			;6525	57 	W 
	ret			;6526	c9 	. 
	ld de,0000h		;6527	11 00 00 	. . . 
sub_652ah:
	call nz,05ea4h		;652a	c4 a4 5e 	. . ^ 
	ld (TEMP),hl		;652d	22 a7 f6 	" . . 
	call CHKFOR		;6530	cd e2 3f 	. . ? 
	jp nz,0405bh		;6533	c2 5b 40 	. [ @ 
	ld sp,hl			;6536	f9 	. 
	push de			;6537	d5 	. 
	ld a,(hl)			;6538	7e 	~ 
	push af			;6539	f5 	. 
	inc hl			;653a	23 	# 
	push de			;653b	d5 	. 
	ld a,(hl)			;653c	7e 	~ 
	inc hl			;653d	23 	# 
	or a			;653e	b7 	. 
	jp m,l656bh		;653f	fa 6b 65 	. k e 
	dec a			;6542	3d 	= 
	jr nz,l6549h		;6543	20 04 	  . 
l6545h:
	ld bc,0008h		;6545	01 08 00 	. . . 
	add hl,bc			;6548	09 	. 
l6549h:
	add a,004h		;6549	c6 04 	. . 
	ld (VALTYP),a		;654b	32 63 f6 	2 c . 
	call l2f08h		;654e	cd 08 2f 	. . / 
	ex de,hl			;6551	eb 	. 
	ex (sp),hl			;6552	e3 	. 
	push hl			;6553	e5 	. 
	rst 28h			;6554	ef 	. 
	jr nc,l65a5h		;6555	30 4e 	0 N 
	call sub_2ed6h		;6557	cd d6 2e 	. . . 
	call l324eh		;655a	cd 4e 32 	. N 2 
	pop hl			;655d	e1 	. 
	call sub_2ee8h		;655e	cd e8 2e 	. . . 
	pop hl			;6561	e1 	. 
	call sub_2edfh		;6562	cd df 2e 	. . . 
	push hl			;6565	e5 	. 
	call sub_2f21h		;6566	cd 21 2f 	. ! / 
	jr l6594h		;6569	18 29 	. ) 
l656bh:
	ld bc,RDSLT		;656b	01 0c 00 	. . . 
	add hl,bc			;656e	09 	. 
	ld c,(hl)			;656f	4e 	N 
	inc hl			;6570	23 	# 
	ld b,(hl)			;6571	46 	F 
	inc hl			;6572	23 	# 
	ex (sp),hl			;6573	e3 	. 
	ld e,(hl)			;6574	5e 	^ 
	inc hl			;6575	23 	# 
	ld d,(hl)			;6576	56 	V 
	push hl			;6577	e5 	. 
	ld l,c			;6578	69 	i 
	ld h,b			;6579	60 	` 
	call sub_3172h		;657a	cd 72 31 	. r 1 
	ld a,(VALTYP)		;657d	3a 63 f6 	: c . 
	cp 002h		;6580	fe 02 	. . 
	jp nz,04067h		;6582	c2 67 40 	. g @ 
	ex de,hl			;6585	eb 	. 
	pop hl			;6586	e1 	. 
	ld (hl),d			;6587	72 	r 
	dec hl			;6588	2b 	+ 
	ld (hl),e			;6589	73 	s 
	pop hl			;658a	e1 	. 
	push de			;658b	d5 	. 
	ld e,(hl)			;658c	5e 	^ 
	inc hl			;658d	23 	# 
	ld d,(hl)			;658e	56 	V 
	inc hl			;658f	23 	# 
	ex (sp),hl			;6590	e3 	. 
	call sub_2f4dh		;6591	cd 4d 2f 	. M / 
l6594h:
	pop hl			;6594	e1 	. 
	pop bc			;6595	c1 	. 
	sub b			;6596	90 	. 
	call sub_2edfh		;6597	cd df 2e 	. . . 
	jr z,l65b6h		;659a	28 1a 	( . 
	ex de,hl			;659c	eb 	. 
	ld (CURLIN),hl		;659d	22 1c f4 	" . . 
	ld l,c			;65a0	69 	i 
	ld h,b			;65a1	60 	` 
	jp l45fdh		;65a2	c3 fd 45 	. . E 
l65a5h:
	call sub_2697h		;65a5	cd 97 26 	. . & 
	pop hl			;65a8	e1 	. 
	call sub_2f10h		;65a9	cd 10 2f 	. . / 
	pop hl			;65ac	e1 	. 
	call sub_2eefh		;65ad	cd ef 2e 	. . . 
	push de			;65b0	d5 	. 
	call l2f5ch		;65b1	cd 5c 2f 	. \ / 
	jr l6594h		;65b4	18 de 	. . 
l65b6h:
	ld sp,hl			;65b6	f9 	. 
	ld (SAVSTK),hl		;65b7	22 b1 f6 	" . . 
	ex de,hl			;65ba	eb 	. 
	ld hl,(TEMP)		;65bb	2a a7 f6 	* . . 
	ld a,(hl)			;65be	7e 	~ 
	cp 02ch		;65bf	fe 2c 	. , 
	jp nz,l4601h		;65c1	c2 01 46 	. . F 
	rst 10h			;65c4	d7 	. 
l65c5h:
	call sub_652ah		;65c5	cd 2a 65 	. * e 
l65c8h:
	call sub_67d0h		;65c8	cd d0 67 	. . g 
	ld a,(hl)			;65cb	7e 	~ 
	inc hl			;65cc	23 	# 
	ld c,(hl)			;65cd	4e 	N 
	inc hl			;65ce	23 	# 
	ld b,(hl)			;65cf	46 	F 
	pop de			;65d0	d1 	. 
	push bc			;65d1	c5 	. 
	push af			;65d2	f5 	. 
	call sub_67d7h		;65d3	cd d7 67 	. . g 
	pop af			;65d6	f1 	. 
	ld d,a			;65d7	57 	W 
	ld e,(hl)			;65d8	5e 	^ 
	inc hl			;65d9	23 	# 
	ld c,(hl)			;65da	4e 	N 
	inc hl			;65db	23 	# 
	ld b,(hl)			;65dc	46 	F 
	pop hl			;65dd	e1 	. 
l65deh:
	ld a,e			;65de	7b 	{ 
	or d			;65df	b2 	. 
	ret z			;65e0	c8 	. 
	ld a,d			;65e1	7a 	z 
	sub 001h		;65e2	d6 01 	. . 
	ret c			;65e4	d8 	. 
	xor a			;65e5	af 	. 
	cp e			;65e6	bb 	. 
	inc a			;65e7	3c 	< 
	ret nc			;65e8	d0 	. 
	dec d			;65e9	15 	. 
	dec e			;65ea	1d 	. 
	ld a,(bc)			;65eb	0a 	. 
	inc bc			;65ec	03 	. 
	cp (hl)			;65ed	be 	. 
	inc hl			;65ee	23 	# 
	jr z,l65deh		;65ef	28 ed 	( . 
	ccf			;65f1	3f 	? 
	jp l2e79h		;65f2	c3 79 2e 	. y . 
	call l371eh		;65f5	cd 1e 37 	. . 7 
	jr l6607h		;65f8	18 0d 	. . 
	call l3722h		;65fa	cd 22 37 	. " 7 
	jr l6607h		;65fd	18 08 	. . 
	call FOUTB		;65ff	cd 1a 37 	. . 7 
	jr l6607h		;6602	18 03 	. . 
	call sub_3425h		;6604	cd 25 34 	. % 4 
l6607h:
	call sub_6635h		;6607	cd 35 66 	. 5 f 
	call sub_67d3h		;660a	cd d3 67 	. . g 
	ld bc,l6825h		;660d	01 25 68 	. % h 
	push bc			;6610	c5 	. 
sub_6611h:
	ld a,(hl)			;6611	7e 	~ 
	inc hl			;6612	23 	# 
	push hl			;6613	e5 	. 
	call sub_668eh		;6614	cd 8e 66 	. . f 
	pop hl			;6617	e1 	. 
	ld c,(hl)			;6618	4e 	N 
	inc hl			;6619	23 	# 
	ld b,(hl)			;661a	46 	F 
	call sub_662ah		;661b	cd 2a 66 	. * f 
	push hl			;661e	e5 	. 
	ld l,a			;661f	6f 	o 
	call sub_67c7h		;6620	cd c7 67 	. . g 
	pop de			;6623	d1 	. 
	ret			;6624	c9 	. 
sub_6625h:
	ld a,001h		;6625	3e 01 	> . 
sub_6627h:
	call sub_668eh		;6627	cd 8e 66 	. . f 
sub_662ah:
	ld hl,DSCTMP		;662a	21 98 f6 	! . . 
	push hl			;662d	e5 	. 
	ld (hl),a			;662e	77 	w 
	inc hl			;662f	23 	# 
	ld (hl),e			;6630	73 	s 
	inc hl			;6631	23 	# 
	ld (hl),d			;6632	72 	r 
	pop hl			;6633	e1 	. 
	ret			;6634	c9 	. 
sub_6635h:
	dec hl			;6635	2b 	+ 
sub_6636h:
	ld b,022h		;6636	06 22 	. " 
sub_6638h:
	ld d,b			;6638	50 	P 
sub_6639h:
	push hl			;6639	e5 	. 
	ld c,0ffh		;663a	0e ff 	. . 
l663ch:
	inc hl			;663c	23 	# 
	ld a,(hl)			;663d	7e 	~ 
	inc c			;663e	0c 	. 
	or a			;663f	b7 	. 
	jr z,l6648h		;6640	28 06 	( . 
	cp d			;6642	ba 	. 
	jr z,l6648h		;6643	28 03 	( . 
	cp b			;6645	b8 	. 
	jr nz,l663ch		;6646	20 f4 	  . 
l6648h:
	cp 022h		;6648	fe 22 	. " 
	call z,l4666h		;664a	cc 66 46 	. f F 
	ex (sp),hl			;664d	e3 	. 
	inc hl			;664e	23 	# 
	ex de,hl			;664f	eb 	. 
	ld a,c			;6650	79 	y 
	call sub_662ah		;6651	cd 2a 66 	. * f 
l6654h:
	ld de,DSCTMP		;6654	11 98 f6 	. . . 
	ld a,0d5h		;6657	3e d5 	> . 
	ld hl,(TEMPPT)		;6659	2a 78 f6 	* x . 
	ld (0f7f8h),hl		;665c	22 f8 f7 	" . . 
	ld a,003h		;665f	3e 03 	> . 
	ld (VALTYP),a		;6661	32 63 f6 	2 c . 
	call l2ef3h		;6664	cd f3 2e 	. . . 
	ld de,FRETOP		;6667	11 9b f6 	. . . 
	rst 20h			;666a	e7 	. 
	ld (TEMPPT),hl		;666b	22 78 f6 	" x . 
	pop hl			;666e	e1 	. 
	ld a,(hl)			;666f	7e 	~ 
	ret nz			;6670	c0 	. 
	ld de,CHRGTR		;6671	11 10 00 	. . . 
	jp l406fh		;6674	c3 6f 40 	. o @ 
l6677h:
	inc hl			;6677	23 	# 
sub_6678h:
	call sub_6635h		;6678	cd 35 66 	. 5 f 
sub_667bh:
	call sub_67d3h		;667b	cd d3 67 	. . g 
	call sub_2ee1h		;667e	cd e1 2e 	. . . 
	inc d			;6681	14 	. 
l6682h:
	dec d			;6682	15 	. 
	ret z			;6683	c8 	. 
	ld a,(bc)			;6684	0a 	. 
	rst 18h			;6685	df 	. 
	cp 00dh		;6686	fe 0d 	. . 
	call z,sub_7331h		;6688	cc 31 73 	. 1 s 
	inc bc			;668b	03 	. 
	jr l6682h		;668c	18 f4 	. . 
sub_668eh:
	or a			;668e	b7 	. 
	ld c,0f1h		;668f	0e f1 	. . 
	push af			;6691	f5 	. 
	ld hl,(STKTOP)		;6692	2a 74 f6 	* t . 
	ex de,hl			;6695	eb 	. 
	ld hl,(FRETOP)		;6696	2a 9b f6 	* . . 
	cpl			;6699	2f 	/ 
	ld c,a			;669a	4f 	O 
	ld b,0ffh		;669b	06 ff 	. . 
	add hl,bc			;669d	09 	. 
	inc hl			;669e	23 	# 
	rst 20h			;669f	e7 	. 
	jr c,l66a9h		;66a0	38 07 	8 . 
	ld (FRETOP),hl		;66a2	22 9b f6 	" . . 
	inc hl			;66a5	23 	# 
	ex de,hl			;66a6	eb 	. 
l66a7h:
	pop af			;66a7	f1 	. 
	ret			;66a8	c9 	. 
l66a9h:
	pop af			;66a9	f1 	. 
	ld de,RDSLT+2		;66aa	11 0e 00 	. . . 
	jp z,l406fh		;66ad	ca 6f 40 	. o @ 
	cp a			;66b0	bf 	. 
	push af			;66b1	f5 	. 
	ld bc,06690h		;66b2	01 90 66 	. . f 
	push bc			;66b5	c5 	. 
sub_66b6h:
	ld hl,(MEMSIZ)		;66b6	2a 72 f6 	* r . 
l66b9h:
	ld (FRETOP),hl		;66b9	22 9b f6 	" . . 
	ld hl,0000h		;66bc	21 00 00 	! . . 
	push hl			;66bf	e5 	. 
	ld hl,(STREND)		;66c0	2a c6 f6 	* . . 
	push hl			;66c3	e5 	. 
	ld hl,TEMPST		;66c4	21 7a f6 	! z . 
l66c7h:
	ld de,(TEMPPT)		;66c7	ed 5b 78 f6 	. [ x . 
	rst 20h			;66cb	e7 	. 
	ld bc,l66c7h		;66cc	01 c7 66 	. . f 
	jp nz,l6742h		;66cf	c2 42 67 	. B g 
	ld hl,PRMPRV		;66d2	21 4c f7 	! L . 
	ld (TEMP9),hl		;66d5	22 b8 f7 	" . . 
	ld hl,(ARYTAB)		;66d8	2a c4 f6 	* . . 
	ld (ARYTA2),hl		;66db	22 b5 f7 	" . . 
	ld hl,(VARTAB)		;66de	2a c2 f6 	* . . 
l66e1h:
	ld de,(ARYTA2)		;66e1	ed 5b b5 f7 	. [ . . 
	rst 20h			;66e5	e7 	. 
	jr z,l66fah		;66e6	28 12 	( . 
	ld a,(hl)			;66e8	7e 	~ 
	inc hl			;66e9	23 	# 
	inc hl			;66ea	23 	# 
	inc hl			;66eb	23 	# 
	cp 003h		;66ec	fe 03 	. . 
	jr nz,l66f4h		;66ee	20 04 	  . 
	call sub_6743h		;66f0	cd 43 67 	. C g 
	xor a			;66f3	af 	. 
l66f4h:
	ld e,a			;66f4	5f 	_ 
	ld d,000h		;66f5	16 00 	. . 
	add hl,de			;66f7	19 	. 
	jr l66e1h		;66f8	18 e7 	. . 
l66fah:
	ld hl,(TEMP9)		;66fa	2a b8 f7 	* . . 
	ld e,(hl)			;66fd	5e 	^ 
	inc hl			;66fe	23 	# 
	ld d,(hl)			;66ff	56 	V 
	ld a,d			;6700	7a 	z 
	or e			;6701	b3 	. 
	ld hl,(ARYTAB)		;6702	2a c4 f6 	* . . 
	jr z,l671ah		;6705	28 13 	( . 
	ex de,hl			;6707	eb 	. 
	ld (TEMP9),hl		;6708	22 b8 f7 	" . . 
	inc hl			;670b	23 	# 
	inc hl			;670c	23 	# 
	ld e,(hl)			;670d	5e 	^ 
	inc hl			;670e	23 	# 
	ld d,(hl)			;670f	56 	V 
	inc hl			;6710	23 	# 
	ex de,hl			;6711	eb 	. 
	add hl,de			;6712	19 	. 
	ld (ARYTA2),hl		;6713	22 b5 f7 	" . . 
	ex de,hl			;6716	eb 	. 
	jr l66e1h		;6717	18 c8 	. . 
l6719h:
	pop bc			;6719	c1 	. 
l671ah:
	ld de,(STREND)		;671a	ed 5b c6 f6 	. [ . . 
	rst 20h			;671e	e7 	. 
	jp z,l6763h		;671f	ca 63 67 	. c g 
	ld a,(hl)			;6722	7e 	~ 
	inc hl			;6723	23 	# 
	call sub_2edfh		;6724	cd df 2e 	. . . 
	push hl			;6727	e5 	. 
	add hl,bc			;6728	09 	. 
	cp 003h		;6729	fe 03 	. . 
	jr nz,l6719h		;672b	20 ec 	  . 
	ld (TEMP8),hl		;672d	22 9f f6 	" . . 
	pop hl			;6730	e1 	. 
	ld c,(hl)			;6731	4e 	N 
	ld b,000h		;6732	06 00 	. . 
	add hl,bc			;6734	09 	. 
	add hl,bc			;6735	09 	. 
	inc hl			;6736	23 	# 
l6737h:
	ex de,hl			;6737	eb 	. 
	ld hl,(TEMP8)		;6738	2a 9f f6 	* . . 
	ex de,hl			;673b	eb 	. 
	rst 20h			;673c	e7 	. 
	jr z,l671ah		;673d	28 db 	( . 
	ld bc,l6737h		;673f	01 37 67 	. 7 g 
l6742h:
	push bc			;6742	c5 	. 
sub_6743h:
	xor a			;6743	af 	. 
	or (hl)			;6744	b6 	. 
	inc hl			;6745	23 	# 
	ld e,(hl)			;6746	5e 	^ 
	inc hl			;6747	23 	# 
	ld d,(hl)			;6748	56 	V 
	inc hl			;6749	23 	# 
	ret z			;674a	c8 	. 
	ld b,h			;674b	44 	D 
	ld c,l			;674c	4d 	M 
	ld hl,(FRETOP)		;674d	2a 9b f6 	* . . 
	rst 20h			;6750	e7 	. 
	ld h,b			;6751	60 	` 
	ld l,c			;6752	69 	i 
	ret c			;6753	d8 	. 
	pop hl			;6754	e1 	. 
	ex (sp),hl			;6755	e3 	. 
	rst 20h			;6756	e7 	. 
	ex (sp),hl			;6757	e3 	. 
	push hl			;6758	e5 	. 
	ld h,b			;6759	60 	` 
	ld l,c			;675a	69 	i 
	ret nc			;675b	d0 	. 
	pop bc			;675c	c1 	. 
	pop af			;675d	f1 	. 
	pop af			;675e	f1 	. 
	push hl			;675f	e5 	. 
	push de			;6760	d5 	. 
	push bc			;6761	c5 	. 
	ret			;6762	c9 	. 
l6763h:
	pop de			;6763	d1 	. 
	pop hl			;6764	e1 	. 
	ld a,h			;6765	7c 	| 
	or l			;6766	b5 	. 
	ret z			;6767	c8 	. 
	dec hl			;6768	2b 	+ 
	ld b,(hl)			;6769	46 	F 
	dec hl			;676a	2b 	+ 
	ld c,(hl)			;676b	4e 	N 
	push hl			;676c	e5 	. 
	dec hl			;676d	2b 	+ 
	ld l,(hl)			;676e	6e 	n 
	ld h,000h		;676f	26 00 	& . 
	add hl,bc			;6771	09 	. 
	ld d,b			;6772	50 	P 
	ld e,c			;6773	59 	Y 
	dec hl			;6774	2b 	+ 
	ld b,h			;6775	44 	D 
	ld c,l			;6776	4d 	M 
	ld hl,(FRETOP)		;6777	2a 9b f6 	* . . 
	call sub_6253h		;677a	cd 53 62 	. S b 
	pop hl			;677d	e1 	. 
	ld (hl),c			;677e	71 	q 
	inc hl			;677f	23 	# 
	ld (hl),b			;6780	70 	p 
	ld h,b			;6781	60 	` 
	ld l,c			;6782	69 	i 
	dec hl			;6783	2b 	+ 
	jp l66b9h		;6784	c3 b9 66 	. . f 
l6787h:
	push bc			;6787	c5 	. 
	push hl			;6788	e5 	. 
	ld hl,(0f7f8h)		;6789	2a f8 f7 	* . . 
	ex (sp),hl			;678c	e3 	. 
	call sub_4dc7h		;678d	cd c7 4d 	. . M 
	ex (sp),hl			;6790	e3 	. 
	call sub_3058h		;6791	cd 58 30 	. X 0 
	ld a,(hl)			;6794	7e 	~ 
	push hl			;6795	e5 	. 
	ld hl,(0f7f8h)		;6796	2a f8 f7 	* . . 
	push hl			;6799	e5 	. 
	add a,(hl)			;679a	86 	. 
	ld de,000fh		;679b	11 0f 00 	. . . 
	jp c,l406fh		;679e	da 6f 40 	. o @ 
	call sub_6627h		;67a1	cd 27 66 	. ' f 
	pop de			;67a4	d1 	. 
	call sub_67d7h		;67a5	cd d7 67 	. . g 
	ex (sp),hl			;67a8	e3 	. 
	call sub_67d6h		;67a9	cd d6 67 	. . g 
	push hl			;67ac	e5 	. 
	ld hl,(0f699h)		;67ad	2a 99 f6 	* . . 
	ex de,hl			;67b0	eb 	. 
	call sub_67bfh		;67b1	cd bf 67 	. . g 
	call sub_67bfh		;67b4	cd bf 67 	. . g 
	ld hl,l4c73h		;67b7	21 73 4c 	! s L 
	ex (sp),hl			;67ba	e3 	. 
	push hl			;67bb	e5 	. 
	jp l6654h		;67bc	c3 54 66 	. T f 
sub_67bfh:
	pop hl			;67bf	e1 	. 
	ex (sp),hl			;67c0	e3 	. 
	ld a,(hl)			;67c1	7e 	~ 
	inc hl			;67c2	23 	# 
	ld c,(hl)			;67c3	4e 	N 
	inc hl			;67c4	23 	# 
	ld b,(hl)			;67c5	46 	F 
	ld l,a			;67c6	6f 	o 
sub_67c7h:
	inc l			;67c7	2c 	, 
l67c8h:
	dec l			;67c8	2d 	- 
	ret z			;67c9	c8 	. 
	ld a,(bc)			;67ca	0a 	. 
	ld (de),a			;67cb	12 	. 
	inc bc			;67cc	03 	. 
	inc de			;67cd	13 	. 
	jr l67c8h		;67ce	18 f8 	. . 
sub_67d0h:
	call sub_3058h		;67d0	cd 58 30 	. X 0 
sub_67d3h:
	ld hl,(0f7f8h)		;67d3	2a f8 f7 	* . . 
sub_67d6h:
	ex de,hl			;67d6	eb 	. 
sub_67d7h:
	call sub_67eeh		;67d7	cd ee 67 	. . g 
	ex de,hl			;67da	eb 	. 
	ret nz			;67db	c0 	. 
	push de			;67dc	d5 	. 
	ld d,b			;67dd	50 	P 
	ld e,c			;67de	59 	Y 
	dec de			;67df	1b 	. 
	ld c,(hl)			;67e0	4e 	N 
	ld hl,(FRETOP)		;67e1	2a 9b f6 	* . . 
	rst 20h			;67e4	e7 	. 
	jr nz,l67ech		;67e5	20 05 	  . 
	ld b,a			;67e7	47 	G 
	add hl,bc			;67e8	09 	. 
	ld (FRETOP),hl		;67e9	22 9b f6 	" . . 
l67ech:
	pop hl			;67ec	e1 	. 
	ret			;67ed	c9 	. 
sub_67eeh:
	call H.FRET		;67ee	cd 9d ff 	. . . 
	ld hl,(TEMPPT)		;67f1	2a 78 f6 	* x . 
	dec hl			;67f4	2b 	+ 
	ld b,(hl)			;67f5	46 	F 
	dec hl			;67f6	2b 	+ 
	ld c,(hl)			;67f7	4e 	N 
	dec hl			;67f8	2b 	+ 
	rst 20h			;67f9	e7 	. 
l67fah:
	ret nz			;67fa	c0 	. 
	ld (TEMPPT),hl		;67fb	22 78 f6 	" x . 
	ret			;67fe	c9 	. 
	ld bc,l4fcfh		;67ff	01 cf 4f 	. . O 
	push bc			;6802	c5 	. 
sub_6803h:
	call sub_67d0h		;6803	cd d0 67 	. . g 
	xor a			;6806	af 	. 
	ld d,a			;6807	57 	W 
	ld a,(hl)			;6808	7e 	~ 
	or a			;6809	b7 	. 
	ret			;680a	c9 	. 
	ld bc,l4fcfh		;680b	01 cf 4f 	. . O 
	push bc			;680e	c5 	. 
sub_680fh:
	call sub_6803h		;680f	cd 03 68 	. . h 
	jp z,l475ah		;6812	ca 5a 47 	. Z G 
	inc hl			;6815	23 	# 
	ld e,(hl)			;6816	5e 	^ 
	inc hl			;6817	23 	# 
	ld d,(hl)			;6818	56 	V 
	ld a,(de)			;6819	1a 	. 
	ret			;681a	c9 	. 
	call sub_6625h		;681b	cd 25 66 	. % f 
	call sub_521fh		;681e	cd 1f 52 	. . R 
sub_6821h:
	ld hl,(0f699h)		;6821	2a 99 f6 	* . . 
	ld (hl),e			;6824	73 	s 
l6825h:
	pop bc			;6825	c1 	. 
	jp l6654h		;6826	c3 54 66 	. T f 
l6829h:
	rst 10h			;6829	d7 	. 
	rst 8			;682a	cf 	. 
	jr z,l67fah		;682b	28 cd 	( . 
	inc e			;682d	1c 	. 
	ld d,d			;682e	52 	R 
	push de			;682f	d5 	. 
	rst 8			;6830	cf 	. 
	inc l			;6831	2c 	, 
	call sub_4c64h		;6832	cd 64 4c 	. d L 
	rst 8			;6835	cf 	. 
	add hl,hl			;6836	29 	) 
	ex (sp),hl			;6837	e3 	. 
	push hl			;6838	e5 	. 
	rst 28h			;6839	ef 	. 
	jr z,l6841h		;683a	28 05 	( . 
	call sub_521fh		;683c	cd 1f 52 	. . R 
	jr l6844h		;683f	18 03 	. . 
l6841h:
	call sub_680fh		;6841	cd 0f 68 	. . h 
l6844h:
	pop de			;6844	d1 	. 
	call sub_684dh		;6845	cd 4d 68 	. M h 
	call sub_521fh		;6848	cd 1f 52 	. . R 
	ld a,020h		;684b	3e 20 	>   
sub_684dh:
	push af			;684d	f5 	. 
	ld a,e			;684e	7b 	{ 
	call sub_6627h		;684f	cd 27 66 	. ' f 
	ld b,a			;6852	47 	G 
	pop af			;6853	f1 	. 
	inc b			;6854	04 	. 
	dec b			;6855	05 	. 
	jr z,l6825h		;6856	28 cd 	( . 
	ld hl,(0f699h)		;6858	2a 99 f6 	* . . 
l685bh:
	ld (hl),a			;685b	77 	w 
	inc hl			;685c	23 	# 
	djnz l685bh		;685d	10 fc 	. . 
	jr l6825h		;685f	18 c4 	. . 
	call sub_68e3h		;6861	cd e3 68 	. . h 
	xor a			;6864	af 	. 
l6865h:
	ex (sp),hl			;6865	e3 	. 
	ld c,a			;6866	4f 	O 
	ld a,0e5h		;6867	3e e5 	> . 
l6869h:
	push hl			;6869	e5 	. 
	ld a,(hl)			;686a	7e 	~ 
	cp b			;686b	b8 	. 
	jr c,$+4		;686c	38 02 	8 . 
	ld a,b			;686e	78 	x 
	ld de,RDSLT+2		;686f	11 0e 00 	. . . 
	push bc			;6872	c5 	. 
	call sub_668eh		;6873	cd 8e 66 	. . f 
	pop bc			;6876	c1 	. 
	pop hl			;6877	e1 	. 
	push hl			;6878	e5 	. 
	inc hl			;6879	23 	# 
	ld b,(hl)			;687a	46 	F 
	inc hl			;687b	23 	# 
	ld h,(hl)			;687c	66 	f 
	ld l,b			;687d	68 	h 
	ld b,000h		;687e	06 00 	. . 
	add hl,bc			;6880	09 	. 
	ld b,h			;6881	44 	D 
	ld c,l			;6882	4d 	M 
	call sub_662ah		;6883	cd 2a 66 	. * f 
	ld l,a			;6886	6f 	o 
	call sub_67c7h		;6887	cd c7 67 	. . g 
	pop de			;688a	d1 	. 
	call sub_67d7h		;688b	cd d7 67 	. . g 
	jp l6654h		;688e	c3 54 66 	. T f 
	call sub_68e3h		;6891	cd e3 68 	. . h 
	pop de			;6894	d1 	. 
	push de			;6895	d5 	. 
	ld a,(de)			;6896	1a 	. 
	sub b			;6897	90 	. 
	jr l6865h		;6898	18 cb 	. . 
	ex de,hl			;689a	eb 	. 
	ld a,(hl)			;689b	7e 	~ 
	call sub_68e6h		;689c	cd e6 68 	. . h 
	inc b			;689f	04 	. 
	dec b			;68a0	05 	. 
	jp z,l475ah		;68a1	ca 5a 47 	. Z G 
	push bc			;68a4	c5 	. 
	call sub_69e4h		;68a5	cd e4 69 	. . i 
	pop af			;68a8	f1 	. 
	ex (sp),hl			;68a9	e3 	. 
	ld bc,l6869h		;68aa	01 69 68 	. i h 
	push bc			;68ad	c5 	. 
	dec a			;68ae	3d 	= 
	cp (hl)			;68af	be 	. 
	ld b,000h		;68b0	06 00 	. . 
	ret nc			;68b2	d0 	. 
	ld c,a			;68b3	4f 	O 
	ld a,(hl)			;68b4	7e 	~ 
	sub c			;68b5	91 	. 
	cp e			;68b6	bb 	. 
	ld b,a			;68b7	47 	G 
	ret c			;68b8	d8 	. 
	ld b,e			;68b9	43 	C 
	ret			;68ba	c9 	. 
	call sub_6803h		;68bb	cd 03 68 	. . h 
	jp z,l4fcfh		;68be	ca cf 4f 	. . O 
	ld e,a			;68c1	5f 	_ 
	inc hl			;68c2	23 	# 
	ld a,(hl)			;68c3	7e 	~ 
	inc hl			;68c4	23 	# 
	ld h,(hl)			;68c5	66 	f 
	ld l,a			;68c6	6f 	o 
	push hl			;68c7	e5 	. 
	add hl,de			;68c8	19 	. 
	ld b,(hl)			;68c9	46 	F 
	ld (VLZADR),hl		;68ca	22 19 f4 	" . . 
	ld a,b			;68cd	78 	x 
	ld (VLZDAT),a		;68ce	32 1b f4 	2 . . 
	ld (hl),d			;68d1	72 	r 
	ex (sp),hl			;68d2	e3 	. 
	push bc			;68d3	c5 	. 
	dec hl			;68d4	2b 	+ 
	rst 10h			;68d5	d7 	. 
	call sub_3299h		;68d6	cd 99 32 	. . 2 
	ld hl,0000h		;68d9	21 00 00 	! . . 
	ld (VLZADR),hl		;68dc	22 19 f4 	" . . 
	pop bc			;68df	c1 	. 
	pop hl			;68e0	e1 	. 
	ld (hl),b			;68e1	70 	p 
	ret			;68e2	c9 	. 
sub_68e3h:
	ex de,hl			;68e3	eb 	. 
	rst 8			;68e4	cf 	. 
	add hl,hl			;68e5	29 	) 
sub_68e6h:
	pop bc			;68e6	c1 	. 
	pop de			;68e7	d1 	. 
	push bc			;68e8	c5 	. 
	ld b,e			;68e9	43 	C 
	ret			;68ea	c9 	. 
l68ebh:
	rst 10h			;68eb	d7 	. 
	call 04c62h		;68ec	cd 62 4c 	. b L 
	rst 28h			;68ef	ef 	. 
	ld a,001h		;68f0	3e 01 	> . 
	push af			;68f2	f5 	. 
	jr z,l6906h		;68f3	28 11 	( . 
	pop af			;68f5	f1 	. 
	call sub_521fh		;68f6	cd 1f 52 	. . R 
	or a			;68f9	b7 	. 
	jp z,l475ah		;68fa	ca 5a 47 	. Z G 
	push af			;68fd	f5 	. 
	rst 8			;68fe	cf 	. 
	inc l			;68ff	2c 	, 
	call sub_4c64h		;6900	cd 64 4c 	. d L 
	call sub_3058h		;6903	cd 58 30 	. X 0 
l6906h:
	rst 8			;6906	cf 	. 
	inc l			;6907	2c 	, 
	push hl			;6908	e5 	. 
	ld hl,(0f7f8h)		;6909	2a f8 f7 	* . . 
	ex (sp),hl			;690c	e3 	. 
	call sub_4c64h		;690d	cd 64 4c 	. d L 
	rst 8			;6910	cf 	. 
	add hl,hl			;6911	29 	) 
	push hl			;6912	e5 	. 
	call sub_67d0h		;6913	cd d0 67 	. . g 
	ex de,hl			;6916	eb 	. 
	pop bc			;6917	c1 	. 
	pop hl			;6918	e1 	. 
	pop af			;6919	f1 	. 
	push bc			;691a	c5 	. 
	ld bc,l3297h		;691b	01 97 32 	. . 2 
	push bc			;691e	c5 	. 
	ld bc,l4fcfh		;691f	01 cf 4f 	. . O 
	push bc			;6922	c5 	. 
	push af			;6923	f5 	. 
	push de			;6924	d5 	. 
	call sub_67d6h		;6925	cd d6 67 	. . g 
	pop de			;6928	d1 	. 
	pop af			;6929	f1 	. 
	ld b,a			;692a	47 	G 
	dec a			;692b	3d 	= 
	ld c,a			;692c	4f 	O 
	cp (hl)			;692d	be 	. 
	ld a,000h		;692e	3e 00 	> . 
	ret nc			;6930	d0 	. 
	ld a,(de)			;6931	1a 	. 
	or a			;6932	b7 	. 
	ld a,b			;6933	78 	x 
	ret z			;6934	c8 	. 
	ld a,(hl)			;6935	7e 	~ 
	inc hl			;6936	23 	# 
	ld b,(hl)			;6937	46 	F 
	inc hl			;6938	23 	# 
	ld h,(hl)			;6939	66 	f 
	ld l,b			;693a	68 	h 
	ld b,000h		;693b	06 00 	. . 
	add hl,bc			;693d	09 	. 
l693eh:
	sub c			;693e	91 	. 
	ld b,a			;693f	47 	G 
	push bc			;6940	c5 	. 
	push de			;6941	d5 	. 
	ex (sp),hl			;6942	e3 	. 
	ld c,(hl)			;6943	4e 	N 
	inc hl			;6944	23 	# 
	ld e,(hl)			;6945	5e 	^ 
	inc hl			;6946	23 	# 
	ld d,(hl)			;6947	56 	V 
	pop hl			;6948	e1 	. 
l6949h:
	push hl			;6949	e5 	. 
	push de			;694a	d5 	. 
	push bc			;694b	c5 	. 
l694ch:
	ld a,(de)			;694c	1a 	. 
	cp (hl)			;694d	be 	. 
	jr nz,l6966h		;694e	20 16 	  . 
	inc de			;6950	13 	. 
	dec c			;6951	0d 	. 
	jr z,l695dh		;6952	28 09 	( . 
	inc hl			;6954	23 	# 
	djnz l694ch		;6955	10 f5 	. . 
	pop de			;6957	d1 	. 
	pop de			;6958	d1 	. 
	pop bc			;6959	c1 	. 
l695ah:
	pop de			;695a	d1 	. 
	xor a			;695b	af 	. 
	ret			;695c	c9 	. 
l695dh:
	pop hl			;695d	e1 	. 
	pop de			;695e	d1 	. 
	pop de			;695f	d1 	. 
l6960h:
	pop bc			;6960	c1 	. 
	ld a,b			;6961	78 	x 
	sub h			;6962	94 	. 
	add a,c			;6963	81 	. 
	inc a			;6964	3c 	< 
	ret			;6965	c9 	. 
l6966h:
	pop bc			;6966	c1 	. 
	pop de			;6967	d1 	. 
	pop hl			;6968	e1 	. 
	inc hl			;6969	23 	# 
	djnz l6949h		;696a	10 dd 	. . 
	jr l695ah		;696c	18 ec 	. . 
l696eh:
	rst 8			;696e	cf 	. 
	jr z,l693eh		;696f	28 cd 	( . 
	and h			;6971	a4 	. 
	ld e,(hl)			;6972	5e 	^ 
	call sub_3058h		;6973	cd 58 30 	. X 0 
	push hl			;6976	e5 	. 
	push de			;6977	d5 	. 
	ex de,hl			;6978	eb 	. 
	inc hl			;6979	23 	# 
	ld e,(hl)			;697a	5e 	^ 
	inc hl			;697b	23 	# 
	ld d,(hl)			;697c	56 	V 
	ld hl,(STREND)		;697d	2a c6 f6 	* . . 
	rst 20h			;6980	e7 	. 
	jr c,l6993h		;6981	38 10 	8 . 
	ld hl,(TXTTAB)		;6983	2a 76 f6 	* v . 
	rst 20h			;6986	e7 	. 
	jr nc,l6993h		;6987	30 0a 	0 . 
	pop hl			;6989	e1 	. 
	push hl			;698a	e5 	. 
	call sub_6611h		;698b	cd 11 66 	. . f 
	pop hl			;698e	e1 	. 
	push hl			;698f	e5 	. 
	call l2ef3h		;6990	cd f3 2e 	. . . 
l6993h:
	pop hl			;6993	e1 	. 
	ex (sp),hl			;6994	e3 	. 
	rst 8			;6995	cf 	. 
	inc l			;6996	2c 	, 
	call sub_521ch		;6997	cd 1c 52 	. . R 
	or a			;699a	b7 	. 
	jp z,l475ah		;699b	ca 5a 47 	. Z G 
	push af			;699e	f5 	. 
	ld a,(hl)			;699f	7e 	~ 
	call sub_69e4h		;69a0	cd e4 69 	. . i 
	push de			;69a3	d5 	. 
	call sub_4c5fh		;69a4	cd 5f 4c 	. _ L 
	push hl			;69a7	e5 	. 
	call sub_67d0h		;69a8	cd d0 67 	. . g 
	ex de,hl			;69ab	eb 	. 
	pop hl			;69ac	e1 	. 
	pop bc			;69ad	c1 	. 
	pop af			;69ae	f1 	. 
	ld b,a			;69af	47 	G 
	ex (sp),hl			;69b0	e3 	. 
	push hl			;69b1	e5 	. 
	ld hl,l3297h		;69b2	21 97 32 	! . 2 
	ex (sp),hl			;69b5	e3 	. 
	ld a,c			;69b6	79 	y 
	or a			;69b7	b7 	. 
	ret z			;69b8	c8 	. 
	ld a,(hl)			;69b9	7e 	~ 
	sub b			;69ba	90 	. 
	jp c,l475ah		;69bb	da 5a 47 	. Z G 
	inc a			;69be	3c 	< 
	cp c			;69bf	b9 	. 
	jr c,l69c3h		;69c0	38 01 	8 . 
	ld a,c			;69c2	79 	y 
l69c3h:
	ld c,b			;69c3	48 	H 
	dec c			;69c4	0d 	. 
	ld b,000h		;69c5	06 00 	. . 
	push de			;69c7	d5 	. 
	inc hl			;69c8	23 	# 
	ld e,(hl)			;69c9	5e 	^ 
	inc hl			;69ca	23 	# 
	ld h,(hl)			;69cb	66 	f 
	ld l,e			;69cc	6b 	k 
	add hl,bc			;69cd	09 	. 
	ld b,a			;69ce	47 	G 
	pop de			;69cf	d1 	. 
	ex de,hl			;69d0	eb 	. 
	ld c,(hl)			;69d1	4e 	N 
	inc hl			;69d2	23 	# 
	ld a,(hl)			;69d3	7e 	~ 
	inc hl			;69d4	23 	# 
	ld h,(hl)			;69d5	66 	f 
	ld l,a			;69d6	6f 	o 
	ex de,hl			;69d7	eb 	. 
	ld a,c			;69d8	79 	y 
	or a			;69d9	b7 	. 
	ret z			;69da	c8 	. 
l69dbh:
	ld a,(de)			;69db	1a 	. 
	ld (hl),a			;69dc	77 	w 
	inc de			;69dd	13 	. 
	inc hl			;69de	23 	# 
	dec c			;69df	0d 	. 
	ret z			;69e0	c8 	. 
	djnz l69dbh		;69e1	10 f8 	. . 
	ret			;69e3	c9 	. 
sub_69e4h:
	ld e,0ffh		;69e4	1e ff 	. . 
	cp 029h		;69e6	fe 29 	. ) 
	jr z,l69efh		;69e8	28 05 	( . 
	rst 8			;69ea	cf 	. 
	inc l			;69eb	2c 	, 
	call sub_521ch		;69ec	cd 1c 52 	. . R 
l69efh:
	rst 8			;69ef	cf 	. 
	add hl,hl			;69f0	29 	) 
	ret			;69f1	c9 	. 
	ld hl,(STREND)		;69f2	2a c6 f6 	* . . 
	ex de,hl			;69f5	eb 	. 
	ld hl,0000h		;69f6	21 00 00 	! . . 
	add hl,sp			;69f9	39 	9 
	rst 28h			;69fa	ef 	. 
	jp nz,l4fc1h		;69fb	c2 c1 4f 	. . O 
	call sub_67d3h		;69fe	cd d3 67 	. . g 
	call sub_66b6h		;6a01	cd b6 66 	. . f 
	ld de,(STKTOP)		;6a04	ed 5b 74 f6 	. [ t . 
	ld hl,(FRETOP)		;6a08	2a 9b f6 	* . . 
	jp l4fc1h		;6a0b	c3 c1 4f 	. . O 
sub_6a0eh:
	call sub_4c64h		;6a0e	cd 64 4c 	. d L 
	push hl			;6a11	e5 	. 
	call sub_67d0h		;6a12	cd d0 67 	. . g 
	ld a,(hl)			;6a15	7e 	~ 
	or a			;6a16	b7 	. 
	jr z,l6a47h		;6a17	28 2e 	( . 
	inc hl			;6a19	23 	# 
	ld e,(hl)			;6a1a	5e 	^ 
	inc hl			;6a1b	23 	# 
	ld h,(hl)			;6a1c	66 	f 
	ld l,e			;6a1d	6b 	k 
	ld e,a			;6a1e	5f 	_ 
	call sub_6f15h		;6a1f	cd 15 6f 	. . o 
	push af			;6a22	f5 	. 
	ld bc,FILNAM		;6a23	01 66 f8 	. f . 
	ld d,00bh		;6a26	16 0b 	. . 
	inc e			;6a28	1c 	. 
l6a29h:
	dec e			;6a29	1d 	. 
	jr z,l6a61h		;6a2a	28 35 	( 5 
	ld a,(hl)			;6a2c	7e 	~ 
	cp 020h		;6a2d	fe 20 	.   
	jr c,l6a47h		;6a2f	38 16 	8 . 
	cp 02eh		;6a31	fe 2e 	. . 
	jr z,l6a4dh		;6a33	28 18 	( . 
	ld (bc),a			;6a35	02 	. 
	inc bc			;6a36	03 	. 
	inc hl			;6a37	23 	# 
	dec d			;6a38	15 	. 
	jr nz,l6a29h		;6a39	20 ee 	  . 
l6a3bh:
	pop af			;6a3b	f1 	. 
	push af			;6a3c	f5 	. 
	ld d,a			;6a3d	57 	W 
	ld a,(FILNAM)		;6a3e	3a 66 f8 	: f . 
	inc a			;6a41	3c 	< 
	jr z,l6a47h		;6a42	28 03 	( . 
	pop af			;6a44	f1 	. 
	pop hl			;6a45	e1 	. 
	ret			;6a46	c9 	. 
l6a47h:
	jp l6e6bh		;6a47	c3 6b 6e 	. k n 
l6a4ah:
	inc hl			;6a4a	23 	# 
	jr l6a29h		;6a4b	18 dc 	. . 
l6a4dh:
	ld a,d			;6a4d	7a 	z 
	cp 00bh		;6a4e	fe 0b 	. . 
	jp z,l6a47h		;6a50	ca 47 6a 	. G j 
	cp 003h		;6a53	fe 03 	. . 
	jp c,l6a47h		;6a55	da 47 6a 	. G j 
	jr z,l6a4ah		;6a58	28 f0 	( . 
	ld a,020h		;6a5a	3e 20 	>   
	ld (bc),a			;6a5c	02 	. 
	inc bc			;6a5d	03 	. 
	dec d			;6a5e	15 	. 
	jr l6a4dh		;6a5f	18 ec 	. . 
l6a61h:
	ld a,020h		;6a61	3e 20 	>   
	ld (bc),a			;6a63	02 	. 
	inc bc			;6a64	03 	. 
	dec d			;6a65	15 	. 
	jr nz,l6a61h		;6a66	20 f9 	  . 
	jr l6a3bh		;6a68	18 d1 	. . 
sub_6a6ah:
	call sub_521fh		;6a6a	cd 1f 52 	. . R 
sub_6a6dh:
	ld l,a			;6a6d	6f 	o 
	ld a,(MAXFIL)		;6a6e	3a 5f f8 	: _ . 
	cp l			;6a71	bd 	. 
	jp c,06e7dh		;6a72	da 7d 6e 	. } n 
	ld h,000h		;6a75	26 00 	& . 
	add hl,hl			;6a77	29 	) 
	ex de,hl			;6a78	eb 	. 
	ld hl,(FILTAB)		;6a79	2a 60 f8 	* ` . 
	add hl,de			;6a7c	19 	. 
	ld a,(hl)			;6a7d	7e 	~ 
	inc hl			;6a7e	23 	# 
	ld h,(hl)			;6a7f	66 	f 
	ld l,a			;6a80	6f 	o 
	ld a,(NLONLY)		;6a81	3a 7c f8 	: | . 
	inc a			;6a84	3c 	< 
	ret z			;6a85	c8 	. 
	ld a,(hl)			;6a86	7e 	~ 
	or a			;6a87	b7 	. 
	ret z			;6a88	c8 	. 
	push hl			;6a89	e5 	. 
	ld de,004h		;6a8a	11 04 00 	. . . 
	add hl,de			;6a8d	19 	. 
	ld a,(hl)			;6a8e	7e 	~ 
	cp 009h		;6a8f	fe 09 	. . 
	jr nc,l6a99h		;6a91	30 06 	0 . 
	call H.GETP		;6a93	cd 4e fe 	. N . 
	jp 06e80h		;6a96	c3 80 6e 	. . n 
l6a99h:
	pop hl			;6a99	e1 	. 
	ld a,(hl)			;6a9a	7e 	~ 
	or a			;6a9b	b7 	. 
	scf			;6a9c	37 	7 
	ret			;6a9d	c9 	. 
sub_6a9eh:
	dec hl			;6a9e	2b 	+ 
	rst 10h			;6a9f	d7 	. 
	cp 023h		;6aa0	fe 23 	. # 
	call z,l4666h		;6aa2	cc 66 46 	. f F 
	call sub_521ch		;6aa5	cd 1c 52 	. . R 
	ex (sp),hl			;6aa8	e3 	. 
	push hl			;6aa9	e5 	. 
sub_6aaah:
	call sub_6a6dh		;6aaa	cd 6d 6a 	. m j 
	jp z,06e77h		;6aad	ca 77 6e 	. w n 
	ld (PTRFIL),hl		;6ab0	22 64 f8 	" d . 
	call H.SETF		;6ab3	cd 53 fe 	. S . 
	ret			;6ab6	c9 	. 
	ld bc,l4affh		;6ab7	01 ff 4a 	. . J 
	push bc			;6aba	c5 	. 
	call sub_6a0eh		;6abb	cd 0e 6a 	. . j 
	ld a,(hl)			;6abe	7e 	~ 
	cp 082h		;6abf	fe 82 	. . 
	ld e,004h		;6ac1	1e 04 	. . 
	jr nz,l6ae4h		;6ac3	20 1f 	  . 
	rst 10h			;6ac5	d7 	. 
	cp 085h		;6ac6	fe 85 	. . 
	ld e,001h		;6ac8	1e 01 	. . 
	jr z,l6ae3h		;6aca	28 17 	( . 
	cp 09ch		;6acc	fe 9c 	. . 
	jr z,l6adch		;6ace	28 0c 	( . 
	rst 8			;6ad0	cf 	. 
	ld b,c			;6ad1	41 	A 
	rst 8			;6ad2	cf 	. 
	ld d,b			;6ad3	50 	P 
	rst 8			;6ad4	cf 	. 
	ld d,b			;6ad5	50 	P 
	rst 8			;6ad6	cf 	. 
	add a,c			;6ad7	81 	. 
	ld e,008h		;6ad8	1e 08 	. . 
	jr l6ae4h		;6ada	18 08 	. . 
l6adch:
	rst 10h			;6adc	d7 	. 
	rst 8			;6add	cf 	. 
	or e			;6ade	b3 	. 
	ld e,002h		;6adf	1e 02 	. . 
	jr l6ae4h		;6ae1	18 01 	. . 
l6ae3h:
	rst 10h			;6ae3	d7 	. 
l6ae4h:
	rst 8			;6ae4	cf 	. 
	ld b,c			;6ae5	41 	A 
	rst 8			;6ae6	cf 	. 
	ld d,e			;6ae7	53 	S 
	push de			;6ae8	d5 	. 
	ld a,(hl)			;6ae9	7e 	~ 
	cp 023h		;6aea	fe 23 	. # 
	call z,l4666h		;6aec	cc 66 46 	. f F 
	call sub_521ch		;6aef	cd 1c 52 	. . R 
	or a			;6af2	b7 	. 
	jp z,06e7dh		;6af3	ca 7d 6e 	. } n 
	call H.NOFO		;6af6	cd 58 fe 	. X . 
	ld e,0d5h		;6af9	1e d5 	. . 
	dec hl			;6afb	2b 	+ 
	ld e,a			;6afc	5f 	_ 
	rst 10h			;6afd	d7 	. 
	jp nz,l4055h		;6afe	c2 55 40 	. U @ 
	ex (sp),hl			;6b01	e3 	. 
	ld a,e			;6b02	7b 	{ 
	push af			;6b03	f5 	. 
	push hl			;6b04	e5 	. 
	call sub_6a6dh		;6b05	cd 6d 6a 	. m j 
	jp nz,06e6eh		;6b08	c2 6e 6e 	. n n 
	pop de			;6b0b	d1 	. 
	ld a,d			;6b0c	7a 	z 
	cp 009h		;6b0d	fe 09 	. . 
	call H.NULO		;6b0f	cd 5d fe 	. ] . 
	jp c,06e80h		;6b12	da 80 6e 	. . n 
	push hl			;6b15	e5 	. 
	ld bc,004h		;6b16	01 04 00 	. . . 
	add hl,bc			;6b19	09 	. 
	ld (hl),d			;6b1a	72 	r 
	ld a,000h		;6b1b	3e 00 	> . 
	pop hl			;6b1d	e1 	. 
	call IODISPATCH		;6b1e	cd 8f 6f 	. . o 
	pop af			;6b21	f1 	. 
	pop hl			;6b22	e1 	. 
	ret			;6b23	c9 	. 
l6b24h:
	push hl			;6b24	e5 	. 
	or a			;6b25	b7 	. 
	jr nz,l6b30h		;6b26	20 08 	  . 
	ld a,(NLONLY)		;6b28	3a 7c f8 	: | . 
	and 001h		;6b2b	e6 01 	. . 
	jp nz,l6cf3h		;6b2d	c2 f3 6c 	. . l 
l6b30h:
	call sub_6a6dh		;6b30	cd 6d 6a 	. m j 
	jr z,l6b4ah		;6b33	28 15 	( . 
	ld (PTRFIL),hl		;6b35	22 64 f8 	" d . 
	push hl			;6b38	e5 	. 
	jr c,l6b41h		;6b39	38 06 	8 . 
	call H.NTFL		;6b3b	cd 62 fe 	. b . 
	jp 06e80h		;6b3e	c3 80 6e 	. . n 
l6b41h:
	ld a,002h		;6b41	3e 02 	> . 
	call IODISPATCH		;6b43	cd 8f 6f 	. . o 
	call sub_6ceah		;6b46	cd ea 6c 	. . l 
	pop hl			;6b49	e1 	. 
l6b4ah:
	push hl			;6b4a	e5 	. 
	ld de,0007h		;6b4b	11 07 00 	. . . 
	add hl,de			;6b4e	19 	. 
	ld (hl),a			;6b4f	77 	w 
	ld h,a			;6b50	67 	g 
	ld l,a			;6b51	6f 	o 
	ld (PTRFIL),hl		;6b52	22 64 f8 	" d . 
	pop hl			;6b55	e1 	. 
	add a,(hl)			;6b56	86 	. 
	ld (hl),000h		;6b57	36 00 	6 . 
	pop hl			;6b59	e1 	. 
	ret			;6b5a	c9 	. 
l6b5bh:
	scf			;6b5b	37 	7 
	ld de,0aff6h		;6b5c	11 f6 af 	. . . 
	push af			;6b5f	f5 	. 
	call sub_6a0eh		;6b60	cd 0e 6a 	. . j 
	call H.MERG		;6b63	cd 67 fe 	. g . 
	pop af			;6b66	f1 	. 
	push af			;6b67	f5 	. 
	jr z,l6b76h		;6b68	28 0c 	( . 
	ld a,(hl)			;6b6a	7e 	~ 
	sub 02ch		;6b6b	d6 2c 	. , 
	or a			;6b6d	b7 	. 
	jr nz,l6b76h		;6b6e	20 06 	  . 
	rst 10h			;6b70	d7 	. 
	rst 8			;6b71	cf 	. 
	ld d,d			;6b72	52 	R 
	pop af			;6b73	f1 	. 
	scf			;6b74	37 	7 
	push af			;6b75	f5 	. 
l6b76h:
	push af			;6b76	f5 	. 
	xor a			;6b77	af 	. 
	ld e,001h		;6b78	1e 01 	. . 
	call 06afah		;6b7a	cd fa 6a 	. . j 
	ld hl,(PTRFIL)		;6b7d	2a 64 f8 	* d . 
	ld bc,0007h		;6b80	01 07 00 	. . . 
	add hl,bc			;6b83	09 	. 
	pop af			;6b84	f1 	. 
	sbc a,a			;6b85	9f 	. 
	and 080h		;6b86	e6 80 	. . 
	or 001h		;6b88	f6 01 	. . 
	ld (NLONLY),a		;6b8a	32 7c f8 	2 | . 
	pop af			;6b8d	f1 	. 
	push af			;6b8e	f5 	. 
	sbc a,a			;6b8f	9f 	. 
	ld (FILNAM),a		;6b90	32 66 f8 	2 f . 
	ld a,(hl)			;6b93	7e 	~ 
	or a			;6b94	b7 	. 
	jp m,l6bd4h		;6b95	fa d4 6b 	. . k 
	pop af			;6b98	f1 	. 
	call nz,sub_6287h		;6b99	c4 87 62 	. . b 
	xor a			;6b9c	af 	. 
	call sub_6aaah		;6b9d	cd aa 6a 	. . j 
	jp l4134h		;6ba0	c3 34 41 	. 4 A 
	call sub_6a0eh		;6ba3	cd 0e 6a 	. . j 
	call H.SAVE		;6ba6	cd 6c fe 	. l . 
	dec hl			;6ba9	2b 	+ 
	rst 10h			;6baa	d7 	. 
	ld e,080h		;6bab	1e 80 	. . 
	scf			;6bad	37 	7 
	jr z,l6bb7h		;6bae	28 07 	( . 
	rst 8			;6bb0	cf 	. 
	inc l			;6bb1	2c 	, 
	rst 8			;6bb2	cf 	. 
	ld b,c			;6bb3	41 	A 
	or a			;6bb4	b7 	. 
	ld e,002h		;6bb5	1e 02 	. . 
l6bb7h:
	push af			;6bb7	f5 	. 
	ld a,d			;6bb8	7a 	z 
	cp 009h		;6bb9	fe 09 	. . 
	jr c,l6bc2h		;6bbb	38 05 	8 . 
	ld e,002h		;6bbd	1e 02 	. . 
	pop af			;6bbf	f1 	. 
	xor a			;6bc0	af 	. 
	push af			;6bc1	f5 	. 
l6bc2h:
	xor a			;6bc2	af 	. 
	call 06afah		;6bc3	cd fa 6a 	. . j 
	pop af			;6bc6	f1 	. 
	jr c,l6bceh		;6bc7	38 05 	8 . 
	dec hl			;6bc9	2b 	+ 
	rst 10h			;6bca	d7 	. 
	jp l522eh		;6bcb	c3 2e 52 	. . R 
l6bceh:
	call H.BINS		;6bce	cd 71 fe 	. q . 
	jp l6e6bh		;6bd1	c3 6b 6e 	. k n 
l6bd4h:
	call H.BINL		;6bd4	cd 76 fe 	. v . 
	jp l6e6bh		;6bd7	c3 6b 6e 	. k n 
	push hl			;6bda	e5 	. 
	push de			;6bdb	d5 	. 
	ld hl,(PTRFIL)		;6bdc	2a 64 f8 	* d . 
	ld de,004h		;6bdf	11 04 00 	. . . 
	add hl,de			;6be2	19 	. 
	ld a,(hl)			;6be3	7e 	~ 
	pop de			;6be4	d1 	. 
	pop hl			;6be5	e1 	. 
	ret			;6be6	c9 	. 
l6be7h:
	jr nz,l6c02h		;6be7	20 19 	  . 
	push hl			;6be9	e5 	. 
l6beah:
	push bc			;6bea	c5 	. 
	push af			;6beb	f5 	. 
	ld de,l6bf3h		;6bec	11 f3 6b 	. . k 
	push de			;6bef	d5 	. 
	push bc			;6bf0	c5 	. 
	or a			;6bf1	b7 	. 
	ret			;6bf2	c9 	. 
l6bf3h:
	pop af			;6bf3	f1 	. 
	pop bc			;6bf4	c1 	. 
	dec a			;6bf5	3d 	= 
	jp p,l6beah		;6bf6	f2 ea 6b 	. . k 
	pop hl			;6bf9	e1 	. 
	ret			;6bfa	c9 	. 
l6bfbh:
	pop bc			;6bfb	c1 	. 
	pop hl			;6bfc	e1 	. 
	ld a,(hl)			;6bfd	7e 	~ 
	cp 02ch		;6bfe	fe 2c 	. , 
	ret nz			;6c00	c0 	. 
	rst 10h			;6c01	d7 	. 
l6c02h:
	push bc			;6c02	c5 	. 
	ld a,(hl)			;6c03	7e 	~ 
	cp 023h		;6c04	fe 23 	. # 
	call z,l4666h		;6c06	cc 66 46 	. f F 
	call sub_521ch		;6c09	cd 1c 52 	. . R 
	ex (sp),hl			;6c0c	e3 	. 
	push hl			;6c0d	e5 	. 
	ld de,l6bfbh		;6c0e	11 fb 6b 	. . k 
	push de			;6c11	d5 	. 
	scf			;6c12	37 	7 
	jp (hl)			;6c13	e9 	. 
	ld bc,l6b24h		;6c14	01 24 6b 	. $ k 
	ld a,(MAXFIL)		;6c17	3a 5f f8 	: _ . 
	jr l6be7h		;6c1a	18 cb 	. . 
sub_6c1ch:
	ld a,(NLONLY)		;6c1c	3a 7c f8 	: | . 
	or a			;6c1f	b7 	. 
	ret m			;6c20	f8 	. 
	ld bc,l6b24h		;6c21	01 24 6b 	. $ k 
	xor a			;6c24	af 	. 
	ld a,(MAXFIL)		;6c25	3a 5f f8 	: _ . 
	jr l6be7h		;6c28	18 bd 	. . 
	ld a,001h		;6c2a	3e 01 	> . 
	ld (PRTFLG),a		;6c2c	32 16 f4 	2 . . 
	call H.FILE		;6c2f	cd 7b fe 	. { . 
	jp l475ah		;6c32	c3 5a 47 	. Z G 
l6c35h:
	push af			;6c35	f5 	. 
	call sub_6a9eh		;6c36	cd 9e 6a 	. . j 
	jr c,l6c41h		;6c39	38 06 	8 . 
	call H.DGET		;6c3b	cd 80 fe 	. . . 
	jp l6e6bh		;6c3e	c3 6b 6e 	. k n 
l6c41h:
	pop de			;6c41	d1 	. 
	pop bc			;6c42	c1 	. 
	ld a,004h		;6c43	3e 04 	> . 
	jp IODISPATCH		;6c45	c3 8f 6f 	. . o 
l6c48h:
	push hl			;6c48	e5 	. 
	push de			;6c49	d5 	. 
	push bc			;6c4a	c5 	. 
	push af			;6c4b	f5 	. 
	call sub_6c62h		;6c4c	cd 62 6c 	. b l 
	jr nc,l6c57h		;6c4f	30 06 	0 . 
	call H.FILO		;6c51	cd 85 fe 	. . . 
	jp l6e6bh		;6c54	c3 6b 6e 	. k n 
l6c57h:
	pop af			;6c57	f1 	. 
	push af			;6c58	f5 	. 
	ld c,a			;6c59	4f 	O 
	ld a,006h		;6c5a	3e 06 	> . 
	call IODISPATCH		;6c5c	cd 8f 6f 	. . o 
	jp l72ffh		;6c5f	c3 ff 72 	. . r 
sub_6c62h:
	push de			;6c62	d5 	. 
	ld hl,(PTRFIL)		;6c63	2a 64 f8 	* d . 
	ex de,hl			;6c66	eb 	. 
	ld hl,004h		;6c67	21 04 00 	! . . 
	add hl,de			;6c6a	19 	. 
	ld a,(hl)			;6c6b	7e 	~ 
	ex de,hl			;6c6c	eb 	. 
	pop de			;6c6d	d1 	. 
	cp 009h		;6c6e	fe 09 	. . 
	ret			;6c70	c9 	. 
sub_6c71h:
	push hl			;6c71	e5 	. 
l6c72h:
	push de			;6c72	d5 	. 
	push bc			;6c73	c5 	. 
	call sub_6c62h		;6c74	cd 62 6c 	. b l 
	jr nc,l6c7fh		;6c77	30 06 	0 . 
	call H.INDS		;6c79	cd 8a fe 	. . . 
	jp 06e80h		;6c7c	c3 80 6e 	. . n 
l6c7fh:
	ld a,008h		;6c7f	3e 08 	> . 
	call IODISPATCH		;6c81	cd 8f 6f 	. . o 
	jp l7300h		;6c84	c3 00 73 	. . s 
l6c87h:
	rst 10h			;6c87	d7 	. 
	rst 8			;6c88	cf 	. 
	inc h			;6c89	24 	$ 
	rst 8			;6c8a	cf 	. 
	jr z,l6c72h		;6c8b	28 e5 	( . 
	ld hl,(PTRFIL)		;6c8d	2a 64 f8 	* d . 
	push hl			;6c90	e5 	. 
	ld hl,0000h		;6c91	21 00 00 	! . . 
	ld (PTRFIL),hl		;6c94	22 64 f8 	" d . 
	pop hl			;6c97	e1 	. 
	ex (sp),hl			;6c98	e3 	. 
	call sub_521ch		;6c99	cd 1c 52 	. . R 
	push de			;6c9c	d5 	. 
	ld a,(hl)			;6c9d	7e 	~ 
	cp 02ch		;6c9e	fe 2c 	. , 
	jr nz,l6cb3h		;6ca0	20 11 	  . 
	rst 10h			;6ca2	d7 	. 
	call sub_6a9eh		;6ca3	cd 9e 6a 	. . j 
	cp 001h		;6ca6	fe 01 	. . 
	jp z,l6cb0h		;6ca8	ca b0 6c 	. . l 
	cp 004h		;6cab	fe 04 	. . 
	jp nz,06e83h		;6cad	c2 83 6e 	. . n 
l6cb0h:
	pop hl			;6cb0	e1 	. 
	xor a			;6cb1	af 	. 
	ld a,(hl)			;6cb2	7e 	~ 
l6cb3h:
	push af			;6cb3	f5 	. 
	rst 8			;6cb4	cf 	. 
	add hl,hl			;6cb5	29 	) 
	pop af			;6cb6	f1 	. 
	ex (sp),hl			;6cb7	e3 	. 
	push af			;6cb8	f5 	. 
	ld a,l			;6cb9	7d 	} 
	or a			;6cba	b7 	. 
	jp z,l475ah		;6cbb	ca 5a 47 	. Z G 
	push hl			;6cbe	e5 	. 
	call sub_6627h		;6cbf	cd 27 66 	. ' f 
	ex de,hl			;6cc2	eb 	. 
	pop bc			;6cc3	c1 	. 
l6cc4h:
	pop af			;6cc4	f1 	. 
	push af			;6cc5	f5 	. 
	jr z,l6ce2h		;6cc6	28 1a 	( . 
	call CHGET		;6cc8	cd 9f 00 	. . . 
	push af			;6ccb	f5 	. 
	call S.UPC		;6ccc	cd bd 00 	. . . 
	pop af			;6ccf	f1 	. 
l6cd0h:
	ld (hl),a			;6cd0	77 	w 
	inc hl			;6cd1	23 	# 
	dec c			;6cd2	0d 	. 
	jr nz,l6cc4h		;6cd3	20 ef 	  . 
	pop af			;6cd5	f1 	. 
	pop bc			;6cd6	c1 	. 
	pop hl			;6cd7	e1 	. 
	call H.RSLF		;6cd8	cd 8f fe 	. . . 
	ld (PTRFIL),hl		;6cdb	22 64 f8 	" d . 
	push bc			;6cde	c5 	. 
	jp l6654h		;6cdf	c3 54 66 	. T f 
l6ce2h:
	call sub_6c71h		;6ce2	cd 71 6c 	. q l 
	jp c,06e83h		;6ce5	da 83 6e 	. . n 
	jr l6cd0h		;6ce8	18 e6 	. . 
sub_6ceah:
	call sub_6cfbh		;6cea	cd fb 6c 	. . l 
	push hl			;6ced	e5 	. 
	ld b,000h		;6cee	06 00 	. . 
	call sub_6cf5h		;6cf0	cd f5 6c 	. . l 
l6cf3h:
	pop hl			;6cf3	e1 	. 
	ret			;6cf4	c9 	. 
sub_6cf5h:
	xor a			;6cf5	af 	. 
l6cf6h:
	ld (hl),a			;6cf6	77 	w 
	inc hl			;6cf7	23 	# 
	djnz l6cf6h		;6cf8	10 fc 	. . 
	ret			;6cfa	c9 	. 
sub_6cfbh:
	ld hl,(PTRFIL)		;6cfb	2a 64 f8 	* d . 
	ld de,0009h		;6cfe	11 09 00 	. . . 
	add hl,de			;6d01	19 	. 
	ret			;6d02	c9 	. 
	call H.SAVD		;6d03	cd 94 fe 	. . . 
	call sub_6a6ah		;6d06	cd 6a 6a 	. j j 
	jr z,l6d2bh		;6d09	28 20 	(   
	ld a,00ah		;6d0b	3e 0a 	> . 
	jr c,l6d30h		;6d0d	38 21 	8 ! 
	call H.LOC		;6d0f	cd 99 fe 	. . . 
	jr l6d36h		;6d12	18 22 	. " 
	call H.SAVD		;6d14	cd 94 fe 	. . . 
	call sub_6a6ah		;6d17	cd 6a 6a 	. j j 
	jr z,l6d2bh		;6d1a	28 0f 	( . 
	ld a,00ch		;6d1c	3e 0c 	> . 
	jr c,l6d30h		;6d1e	38 10 	8 . 
	call H.LOF		;6d20	cd 9e fe 	. . . 
	jr l6d36h		;6d23	18 11 	. . 
	call H.SAVD		;6d25	cd 94 fe 	. . . 
	call sub_6a6ah		;6d28	cd 6a 6a 	. j j 
l6d2bh:
	jp z,06e77h		;6d2b	ca 77 6e 	. w n 
	ld a,00eh		;6d2e	3e 0e 	> . 
l6d30h:
	jp c,IODISPATCH		;6d30	da 8f 6f 	. . o 
	call H.EOF		;6d33	cd a3 fe 	. . . 
l6d36h:
	jp 06e80h		;6d36	c3 80 6e 	. . n 
	call H.SAVD		;6d39	cd 94 fe 	. . . 
	call sub_6a6ah		;6d3c	cd 6a 6a 	. j j 
	ld a,010h		;6d3f	3e 10 	> . 
	jr c,l6d30h		;6d41	38 ed 	8 . 
	call H.FPOS		;6d43	cd a8 fe 	. . . 
	jr l6d36h		;6d46	18 ee 	. . 
l6d48h:
	call ISFLIO		;6d48	cd 4a 01 	. J . 
	jp z,l4640h		;6d4b	ca 40 46 	. @ F 
	xor a			;6d4e	af 	. 
	call l6b24h		;6d4f	cd 24 6b 	. $ k 
	jp 06e71h		;6d52	c3 71 6e 	. q n 
sub_6d55h:
	ld c,001h		;6d55	0e 01 	. . 
sub_6d57h:
	cp 023h		;6d57	fe 23 	. # 
	ret nz			;6d59	c0 	. 
	push bc			;6d5a	c5 	. 
	call sub_521bh		;6d5b	cd 1b 52 	. . R 
	rst 8			;6d5e	cf 	. 
	inc l			;6d5f	2c 	, 
	ld a,e			;6d60	7b 	{ 
	push hl			;6d61	e5 	. 
	call sub_6aaah		;6d62	cd aa 6a 	. . j 
	ld a,(hl)			;6d65	7e 	~ 
	pop hl			;6d66	e1 	. 
	pop bc			;6d67	c1 	. 
	cp c			;6d68	b9 	. 
	jr z,l6d79h		;6d69	28 0e 	( . 
	cp 004h		;6d6b	fe 04 	. . 
	jr z,l6d79h		;6d6d	28 0a 	( . 
	cp 008h		;6d6f	fe 08 	. . 
	jr nz,l6d76h		;6d71	20 03 	  . 
	ld a,c			;6d73	79 	y 
	cp 002h		;6d74	fe 02 	. . 
l6d76h:
	jp nz,06e7dh		;6d76	c2 7d 6e 	. } n 
l6d79h:
	ld a,(hl)			;6d79	7e 	~ 
	ret			;6d7a	c9 	. 
sub_6d7bh:
	ld bc,l6317h		;6d7b	01 17 63 	. . c 
	push bc			;6d7e	c5 	. 
	xor a			;6d7f	af 	. 
	jp l6b24h		;6d80	c3 24 6b 	. $ k 
l6d83h:
	rst 28h			;6d83	ef 	. 
	ld bc,l4bf1h		;6d84	01 f1 4b 	. . K 
	ld de,02c20h		;6d87	11 20 2c 	.   , 
	jr nz,l6da3h		;6d8a	20 17 	  . 
	ld e,d			;6d8c	5a 	Z 
	jr l6da3h		;6d8d	18 14 	. . 
l6d8fh:
	ld bc,l4affh		;6d8f	01 ff 4a 	. . J 
	push bc			;6d92	c5 	. 
	call sub_6d55h		;6d93	cd 55 6d 	. U m 
	call 05ea4h		;6d96	cd a4 5e 	. . ^ 
	call sub_3058h		;6d99	cd 58 30 	. X 0 
	push de			;6d9c	d5 	. 
	ld bc,l487bh		;6d9d	01 7b 48 	. { H 
	xor a			;6da0	af 	. 
	ld d,a			;6da1	57 	W 
	ld e,a			;6da2	5f 	_ 
l6da3h:
	push af			;6da3	f5 	. 
	push bc			;6da4	c5 	. 
	push hl			;6da5	e5 	. 
l6da6h:
	call sub_6c71h		;6da6	cd 71 6c 	. q l 
	jp c,06e83h		;6da9	da 83 6e 	. . n 
	cp 020h		;6dac	fe 20 	.   
	jr nz,l6db4h		;6dae	20 04 	  . 
	inc d			;6db0	14 	. 
	dec d			;6db1	15 	. 
	jr nz,l6da6h		;6db2	20 f2 	  . 
l6db4h:
	cp 022h		;6db4	fe 22 	. " 
	jr nz,l6dc6h		;6db6	20 0e 	  . 
	ld a,e			;6db8	7b 	{ 
	cp 02ch		;6db9	fe 2c 	. , 
	ld a,022h		;6dbb	3e 22 	> " 
	jr nz,l6dc6h		;6dbd	20 07 	  . 
	ld d,a			;6dbf	57 	W 
	ld e,a			;6dc0	5f 	_ 
	call sub_6c71h		;6dc1	cd 71 6c 	. q l 
	jr c,l6e0dh		;6dc4	38 47 	8 G 
l6dc6h:
	ld hl,BUF		;6dc6	21 5e f5 	! ^ . 
	ld b,0ffh		;6dc9	06 ff 	. . 
l6dcbh:
	ld c,a			;6dcb	4f 	O 
	ld a,d			;6dcc	7a 	z 
	cp 022h		;6dcd	fe 22 	. " 
	ld a,c			;6dcf	79 	y 
	jr z,l6dfch		;6dd0	28 2a 	( * 
	cp 00dh		;6dd2	fe 0d 	. . 
	push hl			;6dd4	e5 	. 
	jr z,l6e27h		;6dd5	28 50 	( P 
	pop hl			;6dd7	e1 	. 
	cp 00ah		;6dd8	fe 0a 	. . 
	jr nz,l6dfch		;6dda	20 20 	    
l6ddch:
	ld c,a			;6ddc	4f 	O 
	ld a,e			;6ddd	7b 	{ 
	cp 02ch		;6dde	fe 2c 	. , 
	ld a,c			;6de0	79 	y 
	call nz,sub_6e61h		;6de1	c4 61 6e 	. a n 
	call sub_6c71h		;6de4	cd 71 6c 	. q l 
	jr c,l6e0dh		;6de7	38 24 	8 $ 
	cp 00ah		;6de9	fe 0a 	. . 
	jr z,l6ddch		;6deb	28 ef 	( . 
	cp 00dh		;6ded	fe 0d 	. . 
	jr nz,l6dfch		;6def	20 0b 	  . 
	ld a,e			;6df1	7b 	{ 
	cp 020h		;6df2	fe 20 	.   
	jr z,l6e08h		;6df4	28 12 	( . 
	cp 02ch		;6df6	fe 2c 	. , 
	ld a,00dh		;6df8	3e 0d 	> . 
	jr z,l6e08h		;6dfa	28 0c 	( . 
l6dfch:
	or a			;6dfc	b7 	. 
	jr z,l6e08h		;6dfd	28 09 	( . 
	cp d			;6dff	ba 	. 
	jr z,l6e0dh		;6e00	28 0b 	( . 
	cp e			;6e02	bb 	. 
	jr z,l6e0dh		;6e03	28 08 	( . 
	call sub_6e61h		;6e05	cd 61 6e 	. a n 
l6e08h:
	call sub_6c71h		;6e08	cd 71 6c 	. q l 
	jr nc,l6dcbh		;6e0b	30 be 	0 . 
l6e0dh:
	push hl			;6e0d	e5 	. 
	cp 022h		;6e0e	fe 22 	. " 
	jr z,l6e16h		;6e10	28 04 	( . 
	cp 020h		;6e12	fe 20 	.   
	jr nz,l6e41h		;6e14	20 2b 	  + 
l6e16h:
	call sub_6c71h		;6e16	cd 71 6c 	. q l 
	jr c,l6e41h		;6e19	38 26 	8 & 
	cp 020h		;6e1b	fe 20 	.   
	jr z,l6e16h		;6e1d	28 f7 	( . 
	cp 02ch		;6e1f	fe 2c 	. , 
	jr z,l6e41h		;6e21	28 1e 	( . 
	cp 00dh		;6e23	fe 0d 	. . 
	jr nz,l6e30h		;6e25	20 09 	  . 
l6e27h:
	call sub_6c71h		;6e27	cd 71 6c 	. q l 
	jr c,l6e41h		;6e2a	38 15 	8 . 
	cp 00ah		;6e2c	fe 0a 	. . 
	jr z,l6e41h		;6e2e	28 11 	( . 
l6e30h:
	ld c,a			;6e30	4f 	O 
	call sub_6c62h		;6e31	cd 62 6c 	. b l 
	jr nc,l6e3ch		;6e34	30 06 	0 . 
	call H.BAKU		;6e36	cd ad fe 	. . . 
	jp 06e80h		;6e39	c3 80 6e 	. . n 
l6e3ch:
	ld a,012h		;6e3c	3e 12 	> . 
	call IODISPATCH		;6e3e	cd 8f 6f 	. . o 
l6e41h:
	pop hl			;6e41	e1 	. 
l6e42h:
	ld (hl),000h		;6e42	36 00 	6 . 
	ld hl,BUFMIN		;6e44	21 5d f5 	! ] . 
	ld a,e			;6e47	7b 	{ 
	sub 020h		;6e48	d6 20 	.   
	jr z,l6e53h		;6e4a	28 07 	( . 
	ld b,000h		;6e4c	06 00 	. . 
	call sub_6638h		;6e4e	cd 38 66 	. 8 f 
	pop hl			;6e51	e1 	. 
	ret			;6e52	c9 	. 
l6e53h:
	rst 28h			;6e53	ef 	. 
	push af			;6e54	f5 	. 
	rst 10h			;6e55	d7 	. 
	pop af			;6e56	f1 	. 
	push af			;6e57	f5 	. 
	call c,sub_3299h		;6e58	dc 99 32 	. . 2 
	pop af			;6e5b	f1 	. 
	call nc,sub_3299h		;6e5c	d4 99 32 	. . 2 
	pop hl			;6e5f	e1 	. 
	ret			;6e60	c9 	. 
sub_6e61h:
	or a			;6e61	b7 	. 
	ret z			;6e62	c8 	. 
	ld (hl),a			;6e63	77 	w 
	inc hl			;6e64	23 	# 
	dec b			;6e65	05 	. 
	ret nz			;6e66	c0 	. 
	pop af			;6e67	f1 	. 
	jp l6e42h		;6e68	c3 42 6e 	. B n 
l6e6bh:
	ld e,038h		;6e6b	1e 38 	. 8 
	ld bc,0361eh		;6e6d	01 1e 36 	. . 6 
	ld bc,0391eh		;6e70	01 1e 39 	. . 9 
	ld bc,0351eh		;6e73	01 1e 35 	. . 5 
	ld bc,l3b1eh		;6e76	01 1e 3b 	. . ; 
	ld bc,l321eh		;6e79	01 1e 32 	. . 2 
	ld bc,0341eh		;6e7c	01 1e 34 	. . 4 
	ld bc,l331eh		;6e7f	01 1e 33 	. . 3 
	ld bc,l371eh		;6e82	01 1e 37 	. . 7 
	ld bc,l3a1eh		;6e85	01 1e 3a 	. . : 
	xor a			;6e88	af 	. 
	ld (NLONLY),a		;6e89	32 7c f8 	2 | . 
	ld (FLBMEM),a		;6e8c	32 ae fc 	2 . . 
	jp l406fh		;6e8f	c3 6f 40 	. o @ 
	call sub_6a0eh		;6e92	cd 0e 6a 	. . j 
	push de			;6e95	d5 	. 
	rst 8			;6e96	cf 	. 
	inc l			;6e97	2c 	, 
	call sub_6f0bh		;6e98	cd 0b 6f 	. . o 
	ex de,hl			;6e9b	eb 	. 
	ld (SAVENT),hl		;6e9c	22 bf fc 	" . . 
	ex de,hl			;6e9f	eb 	. 
	push de			;6ea0	d5 	. 
	rst 8			;6ea1	cf 	. 
	inc l			;6ea2	2c 	, 
	call sub_6f0bh		;6ea3	cd 0b 6f 	. . o 
	ex de,hl			;6ea6	eb 	. 
	ld (SAVEND),hl		;6ea7	22 7d f8 	" } . 
	ex de,hl			;6eaa	eb 	. 
	dec hl			;6eab	2b 	+ 
	rst 10h			;6eac	d7 	. 
	jr z,l6eb9h		;6ead	28 0a 	( . 
	rst 8			;6eaf	cf 	. 
	inc l			;6eb0	2c 	, 
	call sub_6f0bh		;6eb1	cd 0b 6f 	. . o 
	ex de,hl			;6eb4	eb 	. 
	ld (SAVENT),hl		;6eb5	22 bf fc 	" . . 
	ex de,hl			;6eb8	eb 	. 
l6eb9h:
	pop bc			;6eb9	c1 	. 
	pop de			;6eba	d1 	. 
	push hl			;6ebb	e5 	. 
	push bc			;6ebc	c5 	. 
	ld a,d			;6ebd	7a 	z 
	cp 0ffh		;6ebe	fe ff 	. . 
	jp z,l6fd7h		;6ec0	ca d7 6f 	. . o 
	jp l6e6bh		;6ec3	c3 6b 6e 	. k n 
	call sub_6a0eh		;6ec6	cd 0e 6a 	. . j 
	push de			;6ec9	d5 	. 
	xor a			;6eca	af 	. 
	ld (RUNBNF),a		;6ecb	32 be fc 	2 . . 
	dec hl			;6ece	2b 	+ 
	rst 10h			;6ecf	d7 	. 
	ld bc,0000h		;6ed0	01 00 00 	. . . 
	jr z,l6ee8h		;6ed3	28 13 	( . 
	rst 8			;6ed5	cf 	. 
	inc l			;6ed6	2c 	, 
	cp 052h		;6ed7	fe 52 	. R 
	jr nz,l6ee3h		;6ed9	20 08 	  . 
	ld (RUNBNF),a		;6edb	32 be fc 	2 . . 
	rst 10h			;6ede	d7 	. 
	jr z,l6ee8h		;6edf	28 07 	( . 
	rst 8			;6ee1	cf 	. 
	inc l			;6ee2	2c 	, 
l6ee3h:
	call sub_6f0bh		;6ee3	cd 0b 6f 	. . o 
	ld b,d			;6ee6	42 	B 
	ld c,e			;6ee7	4b 	K 
l6ee8h:
	pop de			;6ee8	d1 	. 
	push hl			;6ee9	e5 	. 
	push bc			;6eea	c5 	. 
	ld a,d			;6eeb	7a 	z 
	cp 0ffh		;6eec	fe ff 	. . 
	jp z,l7014h		;6eee	ca 14 70 	. . p 
	jp l6e6bh		;6ef1	c3 6b 6e 	. k n 
l6ef4h:
	ld a,(RUNBNF)		;6ef4	3a be fc 	: . . 
	or a			;6ef7	b7 	. 
	jr z,l6f06h		;6ef8	28 0c 	( . 
	xor a			;6efa	af 	. 
	call l6b24h		;6efb	cd 24 6b 	. $ k 
	ld hl,l6cf3h		;6efe	21 f3 6c 	! . l 
	push hl			;6f01	e5 	. 
	ld hl,(SAVENT)		;6f02	2a bf fc 	* . . 
	jp (hl)			;6f05	e9 	. 
l6f06h:
	pop hl			;6f06	e1 	. 
	xor a			;6f07	af 	. 
	jp l6b24h		;6f08	c3 24 6b 	. $ k 
sub_6f0bh:
	call sub_4c64h		;6f0b	cd 64 4c 	. d L 
	push hl			;6f0e	e5 	. 
	call sub_5439h		;6f0f	cd 39 54 	. 9 T 
	pop de			;6f12	d1 	. 
	ex de,hl			;6f13	eb 	. 
	ret			;6f14	c9 	. 
sub_6f15h:
	call H.PARD		;6f15	cd b2 fe 	. . . 
	ld a,(hl)			;6f18	7e 	~ 
	cp 03ah		;6f19	fe 3a 	. : 
	jr c,l6f37h		;6f1b	38 1a 	8 . 
	push hl			;6f1d	e5 	. 
	ld d,e			;6f1e	53 	S 
	ld a,(hl)			;6f1f	7e 	~ 
	inc hl			;6f20	23 	# 
	dec e			;6f21	1d 	. 
	jr z,l6f2eh		;6f22	28 0a 	( . 
l6f24h:
	cp 03ah		;6f24	fe 3a 	. : 
	jr z,l6f3dh		;6f26	28 15 	( . 
	ld a,(hl)			;6f28	7e 	~ 
	inc hl			;6f29	23 	# 
	dec e			;6f2a	1d 	. 
	jp p,l6f24h		;6f2b	f2 24 6f 	. $ o 
l6f2eh:
	ld e,d			;6f2e	5a 	Z 
	pop hl			;6f2f	e1 	. 
	xor a			;6f30	af 	. 
	ld a,0ffh		;6f31	3e ff 	> . 
	call H.NODE		;6f33	cd b7 fe 	. . . 
	ret			;6f36	c9 	. 
l6f37h:
	call H.POSD		;6f37	cd bc fe 	. . . 
	jp l6e6bh		;6f3a	c3 6b 6e 	. k n 
l6f3dh:
	ld a,d			;6f3d	7a 	z 
	sub e			;6f3e	93 	. 
	dec a			;6f3f	3d 	= 
	pop bc			;6f40	c1 	. 
	push de			;6f41	d5 	. 
	push bc			;6f42	c5 	. 
	ld c,a			;6f43	4f 	O 
	ld b,a			;6f44	47 	G 
	ld de,DEVNAMES		;6f45	11 76 6f 	. v o 
	ex (sp),hl			;6f48	e3 	. 
	push hl			;6f49	e5 	. 
l6f4ah:
	call sub_4ea9h		;6f4a	cd a9 4e 	. . N 
	push bc			;6f4d	c5 	. 
	ld b,a			;6f4e	47 	G 
	ld a,(de)			;6f4f	1a 	. 
	inc hl			;6f50	23 	# 
	inc de			;6f51	13 	. 
	cp b			;6f52	b8 	. 
	pop bc			;6f53	c1 	. 
	jr nz,l6f63h		;6f54	20 0d 	  . 
	dec c			;6f56	0d 	. 
	jr nz,l6f4ah		;6f57	20 f1 	  . 
l6f59h:
	ld a,(de)			;6f59	1a 	. 
	or a			;6f5a	b7 	. 
	jp p,l6f63h		;6f5b	f2 63 6f 	. c o 
	pop hl			;6f5e	e1 	. 
	pop hl			;6f5f	e1 	. 
	pop de			;6f60	d1 	. 
	or a			;6f61	b7 	. 
	ret			;6f62	c9 	. 
l6f63h:
	or a			;6f63	b7 	. 
	jp m,l6f59h		;6f64	fa 59 6f 	. Y o 
l6f67h:
	ld a,(de)			;6f67	1a 	. 
	add a,a			;6f68	87 	. 
	inc de			;6f69	13 	. 
	jr nc,l6f67h		;6f6a	30 fb 	0 . 
	ld c,b			;6f6c	48 	H 
	pop hl			;6f6d	e1 	. 
	push hl			;6f6e	e5 	. 
	ld a,(de)			;6f6f	1a 	. 
	or a			;6f70	b7 	. 
	jr nz,l6f4ah		;6f71	20 d7 	  . 
	jp l55f8h		;6f73	c3 f8 55 	. . U 

; BLOCK 'DEVNAMES' (start 0x6f76 end 0x6f87)
DEVNAMES:
	defb 043h		;6f76	43 	C 
	defb 041h		;6f77	41 	A 
	defb 053h		;6f78	53 	S 
	defb 0ffh		;6f79	ff 	. 
	defb 04ch		;6f7a	4c 	L 
	defb 050h		;6f7b	50 	P 
	defb 054h		;6f7c	54 	T 
	defb 0feh		;6f7d	fe 	. 
	defb 043h		;6f7e	43 	C 
	defb 052h		;6f7f	52 	R 
	defb 054h		;6f80	54 	T 
	defb 0fdh		;6f81	fd 	. 
	defb 047h		;6f82	47 	G 
	defb 052h		;6f83	52 	R 
	defb 050h		;6f84	50 	P 
	defb 0fch		;6f85	fc 	. 
	defb 000h		;6f86	00 	. 

; BLOCK 'DEVPTRS' (start 0x6f87 end 0x6f8f)
DEVPTRS:
	defw l71c7h		;6f87	c7 71 	. q 
	defw l72a6h		;6f89	a6 72 	. r 
	defw l71a2h		;6f8b	a2 71 	. q 
	defw l7182h		;6f8d	82 71 	. q 
IODISPATCH:
	call H.GEND		;6f8f	cd c6 fe 	. . . 
	push hl			;6f92	e5 	. 
	push de			;6f93	d5 	. 
	push af			;6f94	f5 	. 
	ld de,004h		;6f95	11 04 00 	. . . 
	add hl,de			;6f98	19 	. 
	ld a,(hl)			;6f99	7e 	~ 
	cp 0fch		;6f9a	fe fc 	. . 
	jp c,l564ah		;6f9c	da 4a 56 	. J V 
	ld a,0ffh		;6f9f	3e ff 	> . 
	sub (hl)			;6fa1	96 	. 
	add a,a			;6fa2	87 	. 
	ld e,a			;6fa3	5f 	_ 
	ld hl,DEVPTRS		;6fa4	21 87 6f 	! . o 
	add hl,de			;6fa7	19 	. 
	ld e,(hl)			;6fa8	5e 	^ 
	inc hl			;6fa9	23 	# 
	ld d,(hl)			;6faa	56 	V 
	pop af			;6fab	f1 	. 
	ld l,a			;6fac	6f 	o 
	ld h,000h		;6fad	26 00 	& . 
	add hl,de			;6faf	19 	. 
	ld e,(hl)			;6fb0	5e 	^ 
	inc hl			;6fb1	23 	# 
	ld d,(hl)			;6fb2	56 	V 
	ex de,hl			;6fb3	eb 	. 
	pop de			;6fb4	d1 	. 
	ex (sp),hl			;6fb5	e3 	. 
	ret			;6fb6	c9 	. 
	call sub_7098h		;6fb7	cd 98 70 	. . p 
	dec hl			;6fba	2b 	+ 
	rst 10h			;6fbb	d7 	. 
	jr z,l6fc3h		;6fbc	28 05 	( . 
	rst 8			;6fbe	cf 	. 
	inc l			;6fbf	2c 	, 
	call sub_7a2dh		;6fc0	cd 2d 7a 	. - z 
l6fc3h:
	push hl			;6fc3	e5 	. 
	ld a,0d3h		;6fc4	3e d3 	> . 
	call sub_7125h		;6fc6	cd 25 71 	. % q 
	ld hl,(VARTAB)		;6fc9	2a c2 f6 	* . . 
	ld (SAVEND),hl		;6fcc	22 7d f8 	" } . 
	ld hl,(TXTTAB)		;6fcf	2a 76 f6 	* v . 
	call sub_713eh		;6fd2	cd 3e 71 	. > q 
	pop hl			;6fd5	e1 	. 
	ret			;6fd6	c9 	. 
l6fd7h:
	ld a,0d0h		;6fd7	3e d0 	> . 
	call sub_7125h		;6fd9	cd 25 71 	. % q 
	xor a			;6fdc	af 	. 
	call sub_72f8h		;6fdd	cd f8 72 	. . r 
	pop hl			;6fe0	e1 	. 
	push hl			;6fe1	e5 	. 
	call sub_7003h		;6fe2	cd 03 70 	. . p 
	ld hl,(SAVEND)		;6fe5	2a 7d f8 	* } . 
	push hl			;6fe8	e5 	. 
	call sub_7003h		;6fe9	cd 03 70 	. . p 
	ld hl,(SAVENT)		;6fec	2a bf fc 	* . . 
	call sub_7003h		;6fef	cd 03 70 	. . p 
	pop de			;6ff2	d1 	. 
	pop hl			;6ff3	e1 	. 
l6ff4h:
	ld a,(hl)			;6ff4	7e 	~ 
	call sub_72deh		;6ff5	cd de 72 	. . r 
	rst 20h			;6ff8	e7 	. 
	jr nc,l6ffeh		;6ff9	30 03 	0 . 
	inc hl			;6ffb	23 	# 
	jr l6ff4h		;6ffc	18 f6 	. . 
l6ffeh:
	call TAPOOF		;6ffe	cd f0 00 	. . . 
	pop hl			;7001	e1 	. 
	ret			;7002	c9 	. 
sub_7003h:
	ld a,l			;7003	7d 	} 
	call sub_72deh		;7004	cd de 72 	. . r 
	ld a,h			;7007	7c 	| 
	jp sub_72deh		;7008	c3 de 72 	. . r 
sub_700bh:
	call sub_72d4h		;700b	cd d4 72 	. . r 
	ld l,a			;700e	6f 	o 
	call sub_72d4h		;700f	cd d4 72 	. . r 
	ld h,a			;7012	67 	g 
	ret			;7013	c9 	. 
l7014h:
	ld c,0d0h		;7014	0e d0 	. . 
	call sub_70b8h		;7016	cd b8 70 	. . p 
	call sub_72e9h		;7019	cd e9 72 	. . r 
	pop bc			;701c	c1 	. 
	call sub_700bh		;701d	cd 0b 70 	. . p 
	add hl,bc			;7020	09 	. 
	ex de,hl			;7021	eb 	. 
	call sub_700bh		;7022	cd 0b 70 	. . p 
	add hl,bc			;7025	09 	. 
	push hl			;7026	e5 	. 
	call sub_700bh		;7027	cd 0b 70 	. . p 
	ld (SAVENT),hl		;702a	22 bf fc 	" . . 
	ex de,hl			;702d	eb 	. 
	pop de			;702e	d1 	. 
l702fh:
	call sub_72d4h		;702f	cd d4 72 	. . r 
	ld (hl),a			;7032	77 	w 
	rst 20h			;7033	e7 	. 
	jr z,l7039h		;7034	28 03 	( . 
	inc hl			;7036	23 	# 
	jr l702fh		;7037	18 f6 	. . 
l7039h:
	call TAPIOF		;7039	cd e7 00 	. . . 
	jp l6ef4h		;703c	c3 f4 6e 	. . n 
	sub 091h		;703f	d6 91 	. . 
	jr z,$+4		;7041	28 02 	( . 
	xor a			;7043	af 	. 
	ld bc,l232fh		;7044	01 2f 23 	. / # 
	cp 001h		;7047	fe 01 	. . 
	push af			;7049	f5 	. 
	call sub_708ch		;704a	cd 8c 70 	. . p 
	ld c,0d3h		;704d	0e d3 	. . 
	call sub_70b8h		;704f	cd b8 70 	. . p 
	pop af			;7052	f1 	. 
	ld (0f7f8h),a		;7053	32 f8 f7 	2 . . 
	call c,sub_6287h		;7056	dc 87 62 	. . b 
	ld a,(0f7f8h)		;7059	3a f8 f7 	: . . 
	cp 001h		;705c	fe 01 	. . 
	ld (0f3f5h),a		;705e	32 f5 f3 	2 . . 
	push af			;7061	f5 	. 
	call sub_54eah		;7062	cd ea 54 	. . T 
	pop af			;7065	f1 	. 
	ld hl,(TXTTAB)		;7066	2a 76 f6 	* v . 
	call sub_715dh		;7069	cd 5d 71 	. ] q 
	jr nz,l707eh		;706c	20 10 	  . 
	ld (VARTAB),hl		;706e	22 c2 f6 	" . . 
l7071h:
	ld hl,l3fd7h		;7071	21 d7 3f 	! . ? 
	call sub_7be8h		;7074	cd e8 7b 	. . { 
	ld hl,(TXTTAB)		;7077	2a 76 f6 	* v . 
	push hl			;707a	e5 	. 
	jp l4237h		;707b	c3 37 42 	. 7 B 
l707eh:
	inc hl			;707e	23 	# 
	ex de,hl			;707f	eb 	. 
	ld hl,(VARTAB)		;7080	2a c2 f6 	* . . 
	rst 20h			;7083	e7 	. 
	jp c,l7071h		;7084	da 71 70 	. q p 
	ld e,014h		;7087	1e 14 	. . 
	jp l406fh		;7089	c3 6f 40 	. o @ 
sub_708ch:
	dec hl			;708c	2b 	+ 
	rst 10h			;708d	d7 	. 
	jr nz,sub_7098h		;708e	20 08 	  . 
	push hl			;7090	e5 	. 
	ld hl,FILNAM		;7091	21 66 f8 	! f . 
	ld b,006h		;7094	06 06 	. . 
	jr l70b1h		;7096	18 19 	. . 
sub_7098h:
	call sub_4c64h		;7098	cd 64 4c 	. d L 
	push hl			;709b	e5 	. 
	call sub_680fh		;709c	cd 0f 68 	. . h 
	dec hl			;709f	2b 	+ 
	dec hl			;70a0	2b 	+ 
	ld b,(hl)			;70a1	46 	F 
	ld c,006h		;70a2	0e 06 	. . 
	ld hl,FILNAM		;70a4	21 66 f8 	! f . 
l70a7h:
	ld a,(de)			;70a7	1a 	. 
	ld (hl),a			;70a8	77 	w 
	inc hl			;70a9	23 	# 
	inc de			;70aa	13 	. 
	dec c			;70ab	0d 	. 
	jr z,l70b6h		;70ac	28 08 	( . 
	djnz l70a7h		;70ae	10 f7 	. . 
	ld b,c			;70b0	41 	A 
l70b1h:
	ld (hl),020h		;70b1	36 20 	6   
	inc hl			;70b3	23 	# 
	djnz l70b1h		;70b4	10 fb 	. . 
l70b6h:
	pop hl			;70b6	e1 	. 
	ret			;70b7	c9 	. 
sub_70b8h:
	call sub_72e9h		;70b8	cd e9 72 	. . r 
	ld b,00ah		;70bb	06 0a 	. . 
l70bdh:
	call sub_72d4h		;70bd	cd d4 72 	. . r 
	cp c			;70c0	b9 	. 
	jr nz,sub_70b8h		;70c1	20 f5 	  . 
	djnz l70bdh		;70c3	10 f8 	. . 
	ld hl,0f871h		;70c5	21 71 f8 	! q . 
	push hl			;70c8	e5 	. 
	ld b,006h		;70c9	06 06 	. . 
l70cbh:
	call sub_72d4h		;70cb	cd d4 72 	. . r 
	ld (hl),a			;70ce	77 	w 
	inc hl			;70cf	23 	# 
	djnz l70cbh		;70d0	10 f9 	. . 
	pop hl			;70d2	e1 	. 
	ld de,FILNAM		;70d3	11 66 f8 	. f . 
	ld b,006h		;70d6	06 06 	. . 
l70d8h:
	ld a,(de)			;70d8	1a 	. 
	inc de			;70d9	13 	. 
	cp 020h		;70da	fe 20 	.   
	jr nz,l70e2h		;70dc	20 04 	  . 
	djnz l70d8h		;70de	10 f8 	. . 
	jr l70efh		;70e0	18 0d 	. . 
l70e2h:
	ld de,FILNAM		;70e2	11 66 f8 	. f . 
	ld b,006h		;70e5	06 06 	. . 
l70e7h:
	ld a,(de)			;70e7	1a 	. 
	cp (hl)			;70e8	be 	. 
	jr nz,l70f5h		;70e9	20 0a 	  . 
	inc hl			;70eb	23 	# 
	inc de			;70ec	13 	. 
	djnz l70e7h		;70ed	10 f8 	. . 
l70efh:
	ld hl,l70ffh		;70ef	21 ff 70 	! . p 
	jp l710dh		;70f2	c3 0d 71 	. . q 
l70f5h:
	push bc			;70f5	c5 	. 
	ld hl,07106h		;70f6	21 06 71 	! . q 
	call l710dh		;70f9	cd 0d 71 	. . q 
	pop bc			;70fc	c1 	. 
	jr sub_70b8h		;70fd	18 b9 	. . 
l70ffh:
	ld b,(hl)			;70ff	46 	F 
	ld l,a			;7100	6f 	o 
	ld (hl),l			;7101	75 	u 
	ld l,(hl)			;7102	6e 	n 
	ld h,h			;7103	64 	d 
	ld a,(l5300h)		;7104	3a 00 53 	: . S 
	ld l,e			;7107	6b 	k 
	ld l,c			;7108	69 	i 
	ld (hl),b			;7109	70 	p 
	jr nz,l7146h		;710a	20 3a 	  : 
	nop			;710c	00 	. 
l710dh:
	ld de,(CURLIN)		;710d	ed 5b 1c f4 	. [ . . 
	inc de			;7111	13 	. 
	ld a,d			;7112	7a 	z 
	or e			;7113	b3 	. 
	ret nz			;7114	c0 	. 
	call sub_6678h		;7115	cd 78 66 	. x f 
	ld hl,0f871h		;7118	21 71 f8 	! q . 
	ld b,006h		;711b	06 06 	. . 
l711dh:
	ld a,(hl)			;711d	7e 	~ 
	inc hl			;711e	23 	# 
	rst 18h			;711f	df 	. 
	djnz l711dh		;7120	10 fb 	. . 
	jp sub_7328h		;7122	c3 28 73 	. ( s 
sub_7125h:
	call sub_72f8h		;7125	cd f8 72 	. . r 
	ld b,00ah		;7128	06 0a 	. . 
l712ah:
	call sub_72deh		;712a	cd de 72 	. . r 
	djnz l712ah		;712d	10 fb 	. . 
	ld b,006h		;712f	06 06 	. . 
	ld hl,FILNAM		;7131	21 66 f8 	! f . 
l7134h:
	ld a,(hl)			;7134	7e 	~ 
	inc hl			;7135	23 	# 
	call sub_72deh		;7136	cd de 72 	. . r 
	djnz l7134h		;7139	10 f9 	. . 
	jp TAPOOF		;713b	c3 f0 00 	. . . 
sub_713eh:
	push hl			;713e	e5 	. 
	call sub_54eah		;713f	cd ea 54 	. . T 
	xor a			;7142	af 	. 
	call sub_72f8h		;7143	cd f8 72 	. . r 
l7146h:
	pop de			;7146	d1 	. 
	ld hl,(SAVEND)		;7147	2a 7d f8 	* } . 
l714ah:
	ld a,(de)			;714a	1a 	. 
	inc de			;714b	13 	. 
	call sub_72deh		;714c	cd de 72 	. . r 
	rst 20h			;714f	e7 	. 
	jr nz,l714ah		;7150	20 f8 	  . 
	ld l,007h		;7152	2e 07 	. . 
l7154h:
	call sub_72deh		;7154	cd de 72 	. . r 
	dec l			;7157	2d 	- 
	jr nz,l7154h		;7158	20 fa 	  . 
	jp TAPOOF		;715a	c3 f0 00 	. . . 
sub_715dh:
	call sub_72e9h		;715d	cd e9 72 	. . r 
	sbc a,a			;7160	9f 	. 
	cpl			;7161	2f 	/ 
	ld d,a			;7162	57 	W 
l7163h:
	ld b,00ah		;7163	06 0a 	. . 
l7165h:
	call sub_72d4h		;7165	cd d4 72 	. . r 
	ld e,a			;7168	5f 	_ 
	call 06267h		;7169	cd 67 62 	. g b 
	ld a,e			;716c	7b 	{ 
	sub (hl)			;716d	96 	. 
	and d			;716e	a2 	. 
	jp nz,TAPIOF		;716f	c2 e7 00 	. . . 
	ld (hl),e			;7172	73 	s 
	ld a,(hl)			;7173	7e 	~ 
	or a			;7174	b7 	. 
	inc hl			;7175	23 	# 
	jr nz,l7163h		;7176	20 eb 	  . 
	djnz l7165h		;7178	10 eb 	. . 
	ld bc,0fffah		;717a	01 fa ff 	. . . 
	add hl,bc			;717d	09 	. 
	xor a			;717e	af 	. 
	jp TAPIOF		;717f	c3 e7 00 	. . . 
l7182h:
	or (hl)			;7182	b6 	. 
	ld (hl),c			;7183	71 	q 
	jp nz,08671h		;7184	c2 71 86 	. q . 
	ld l,(hl)			;7187	6e 	n 
	sub (hl)			;7188	96 	. 
	ld (hl),c			;7189	71 	q 
	ld e,d			;718a	5a 	Z 
	ld b,a			;718b	47 	G 
	ld e,d			;718c	5a 	Z 
	ld b,a			;718d	47 	G 
	ld e,d			;718e	5a 	Z 
	ld b,a			;718f	47 	G 
	ld e,d			;7190	5a 	Z 
	ld b,a			;7191	47 	G 
	ld e,d			;7192	5a 	Z 
	ld b,a			;7193	47 	G 
	ld e,d			;7194	5a 	Z 
	ld b,a			;7195	47 	G 
	ld a,(SCRMOD)		;7196	3a af fc 	: . . 
	cp 002h		;7199	fe 02 	. . 
	jp c,l475ah		;719b	da 5a 47 	. Z G 
	ld a,c			;719e	79 	y 
	jp GRPPRT		;719f	c3 8d 00 	. . . 
l71a2h:
	or (hl)			;71a2	b6 	. 
	ld (hl),c			;71a3	71 	q 
	jp nz,08671h		;71a4	c2 71 86 	. q . 
	ld l,(hl)			;71a7	6e 	n 
	jp l5a71h		;71a8	c3 71 5a 	. q Z 
	ld b,a			;71ab	47 	G 
	ld e,d			;71ac	5a 	Z 
	ld b,a			;71ad	47 	G 
	ld e,d			;71ae	5a 	Z 
	ld b,a			;71af	47 	G 
	ld e,d			;71b0	5a 	Z 
	ld b,a			;71b1	47 	G 
	ld e,d			;71b2	5a 	Z 
	ld b,a			;71b3	47 	G 
	ld e,d			;71b4	5a 	Z 
	ld b,a			;71b5	47 	G 
	call sub_72cdh		;71b6	cd cd 72 	. . r 
	cp 001h		;71b9	fe 01 	. . 
	jp z,l6e6bh		;71bb	ca 6b 6e 	. k n 
l71beh:
	ld (PTRFIL),hl		;71be	22 64 f8 	" d . 
	ld (hl),e			;71c1	73 	s 
	ret			;71c2	c9 	. 
	ld a,c			;71c3	79 	y 
	jp CHPUT		;71c4	c3 a2 00 	. . . 
l71c7h:
	in a,(071h)		;71c7	db 71 	. q 
	dec b			;71c9	05 	. 
	ld (hl),d			;71ca	72 	r 
	add a,(hl)			;71cb	86 	. 
	ld l,(hl)			;71cc	6e 	n 
	ld hl,(l3f72h)		;71cd	2a 72 3f 	* r ? 
	ld (hl),d			;71d0	72 	r 
	ld e,d			;71d1	5a 	Z 
	ld b,a			;71d2	47 	G 
	ld e,d			;71d3	5a 	Z 
	ld b,a			;71d4	47 	G 
	ld l,l			;71d5	6d 	m 
	ld (hl),d			;71d6	72 	r 
	ld e,d			;71d7	5a 	Z 
	ld b,a			;71d8	47 	G 
	ld a,h			;71d9	7c 	| 
	ld (hl),d			;71da	72 	r 
	push hl			;71db	e5 	. 
	push de			;71dc	d5 	. 
	ld bc,006h		;71dd	01 06 00 	. . . 
	add hl,bc			;71e0	09 	. 
	xor a			;71e1	af 	. 
	ld (hl),a			;71e2	77 	w 
	ld (CASPRV),a		;71e3	32 b1 fc 	2 . . 
	call sub_72cdh		;71e6	cd cd 72 	. . r 
	cp 004h		;71e9	fe 04 	. . 
	jp z,l6e6bh		;71eb	ca 6b 6e 	. k n 
	cp 001h		;71ee	fe 01 	. . 
	jr z,l71fbh		;71f0	28 09 	( . 
	ld a,0eah		;71f2	3e ea 	> . 
	call sub_7125h		;71f4	cd 25 71 	. % q 
l71f7h:
	pop de			;71f7	d1 	. 
	pop hl			;71f8	e1 	. 
	jr l71beh		;71f9	18 c3 	. . 
l71fbh:
	ld c,0eah		;71fb	0e ea 	. . 
	call sub_70b8h		;71fd	cd b8 70 	. . p 
	call TAPIOF		;7200	cd e7 00 	. . . 
	jr l71f7h		;7203	18 f2 	. . 
	ld a,(hl)			;7205	7e 	~ 
	cp 001h		;7206	fe 01 	. . 
	jr z,l7225h		;7208	28 1b 	( . 
	ld a,01ah		;720a	3e 1a 	> . 
	push hl			;720c	e5 	. 
	call sub_728bh		;720d	cd 8b 72 	. . r 
	call z,sub_722fh		;7210	cc 2f 72 	. / r 
	pop hl			;7213	e1 	. 
	call sub_7281h		;7214	cd 81 72 	. . r 
	jr z,l7225h		;7217	28 0c 	( . 
	push hl			;7219	e5 	. 
	add hl,bc			;721a	09 	. 
l721bh:
	ld (hl),01ah		;721b	36 1a 	6 . 
	inc hl			;721d	23 	# 
	inc c			;721e	0c 	. 
	jr nz,l721bh		;721f	20 fa 	  . 
	pop hl			;7221	e1 	. 
	call sub_722fh		;7222	cd 2f 72 	. / r 
l7225h:
	xor a			;7225	af 	. 
	ld (CASPRV),a		;7226	32 b1 fc 	2 . . 
	ret			;7229	c9 	. 
	ld a,c			;722a	79 	y 
	call sub_728bh		;722b	cd 8b 72 	. . r 
	ret nz			;722e	c0 	. 
sub_722fh:
	xor a			;722f	af 	. 
	call sub_72f8h		;7230	cd f8 72 	. . r 
	ld b,000h		;7233	06 00 	. . 
l7235h:
	ld a,(hl)			;7235	7e 	~ 
	call sub_72deh		;7236	cd de 72 	. . r 
	inc hl			;7239	23 	# 
	djnz l7235h		;723a	10 f9 	. . 
	jp TAPOOF		;723c	c3 f0 00 	. . . 
sub_723fh:
	ex de,hl			;723f	eb 	. 
	ld hl,CASPRV		;7240	21 b1 fc 	! . . 
	call sub_72beh		;7243	cd be 72 	. . r 
	ex de,hl			;7246	eb 	. 
	call sub_729bh		;7247	cd 9b 72 	. . r 
	jr nz,l7260h		;724a	20 14 	  . 
	push hl			;724c	e5 	. 
	call sub_72e9h		;724d	cd e9 72 	. . r 
	pop hl			;7250	e1 	. 
	ld b,000h		;7251	06 00 	. . 
l7253h:
	call sub_72d4h		;7253	cd d4 72 	. . r 
	ld (hl),a			;7256	77 	w 
	inc hl			;7257	23 	# 
	djnz l7253h		;7258	10 f9 	. . 
	call TAPIOF		;725a	cd e7 00 	. . . 
	dec h			;725d	25 	% 
	xor a			;725e	af 	. 
	ld b,a			;725f	47 	G 
l7260h:
	ld c,a			;7260	4f 	O 
	add hl,bc			;7261	09 	. 
	ld a,(hl)			;7262	7e 	~ 
	cp 01ah		;7263	fe 1a 	. . 
	scf			;7265	37 	7 
	ccf			;7266	3f 	? 
	ret nz			;7267	c0 	. 
	ld (CASPRV),a		;7268	32 b1 fc 	2 . . 
	scf			;726b	37 	7 
	ret			;726c	c9 	. 
	call sub_723fh		;726d	cd 3f 72 	. ? r 
	ld hl,CASPRV		;7270	21 b1 fc 	! . . 
	ld (hl),a			;7273	77 	w 
	sub 01ah		;7274	d6 1a 	. . 
	sub 001h		;7276	d6 01 	. . 
	sbc a,a			;7278	9f 	. 
	jp sub_2e9ah		;7279	c3 9a 2e 	. . . 
	ld hl,CASPRV		;727c	21 b1 fc 	! . . 
	ld (hl),c			;727f	71 	q 
	ret			;7280	c9 	. 
sub_7281h:
	ld bc,006h		;7281	01 06 00 	. . . 
	add hl,bc			;7284	09 	. 
	ld a,(hl)			;7285	7e 	~ 
	ld c,a			;7286	4f 	O 
	ld (hl),000h		;7287	36 00 	6 . 
	jr l72a1h		;7289	18 16 	. . 
sub_728bh:
	ld e,a			;728b	5f 	_ 
	ld bc,006h		;728c	01 06 00 	. . . 
	add hl,bc			;728f	09 	. 
	ld a,(hl)			;7290	7e 	~ 
	inc (hl)			;7291	34 	4 
	inc hl			;7292	23 	# 
	inc hl			;7293	23 	# 
	inc hl			;7294	23 	# 
	push hl			;7295	e5 	. 
	ld c,a			;7296	4f 	O 
	add hl,bc			;7297	09 	. 
	ld (hl),e			;7298	73 	s 
	pop hl			;7299	e1 	. 
	ret			;729a	c9 	. 
sub_729bh:
	ld bc,006h		;729b	01 06 00 	. . . 
	add hl,bc			;729e	09 	. 
	ld a,(hl)			;729f	7e 	~ 
	inc (hl)			;72a0	34 	4 
l72a1h:
	inc hl			;72a1	23 	# 
	inc hl			;72a2	23 	# 
	inc hl			;72a3	23 	# 
	and a			;72a4	a7 	. 
	ret			;72a5	c9 	. 
l72a6h:
	or (hl)			;72a6	b6 	. 
	ld (hl),c			;72a7	71 	q 
	jp nz,08671h		;72a8	c2 71 86 	. q . 
	ld l,(hl)			;72ab	6e 	n 
	cp d			;72ac	ba 	. 
	ld (hl),d			;72ad	72 	r 
	ld e,d			;72ae	5a 	Z 
	ld b,a			;72af	47 	G 
	ld e,d			;72b0	5a 	Z 
	ld b,a			;72b1	47 	G 
	ld e,d			;72b2	5a 	Z 
	ld b,a			;72b3	47 	G 
	ld e,d			;72b4	5a 	Z 
	ld b,a			;72b5	47 	G 
	ld e,d			;72b6	5a 	Z 
	ld b,a			;72b7	47 	G 
	ld e,d			;72b8	5a 	Z 
	ld b,a			;72b9	47 	G 
	ld a,c			;72ba	79 	y 
	jp OUTDLP		;72bb	c3 4d 01 	. M . 
sub_72beh:
	ld a,(hl)			;72be	7e 	~ 
	ld (hl),000h		;72bf	36 00 	6 . 
	and a			;72c1	a7 	. 
	ret z			;72c2	c8 	. 
	inc sp			;72c3	33 	3 
	inc sp			;72c4	33 	3 
	cp 01ah		;72c5	fe 1a 	. . 
	scf			;72c7	37 	7 
	ccf			;72c8	3f 	? 
	ret nz			;72c9	c0 	. 
	ld (hl),a			;72ca	77 	w 
	scf			;72cb	37 	7 
	ret			;72cc	c9 	. 
sub_72cdh:
	ld a,e			;72cd	7b 	{ 
	cp 008h		;72ce	fe 08 	. . 
	jp z,l6e6bh		;72d0	ca 6b 6e 	. k n 
	ret			;72d3	c9 	. 
sub_72d4h:
	push hl			;72d4	e5 	. 
	push de			;72d5	d5 	. 
	push bc			;72d6	c5 	. 
	call TAPIN		;72d7	cd e4 00 	. . . 
	jr nc,l7300h		;72da	30 24 	0 $ 
	jr l72f2h		;72dc	18 14 	. . 
sub_72deh:
	push hl			;72de	e5 	. 
	push de			;72df	d5 	. 
	push bc			;72e0	c5 	. 
	push af			;72e1	f5 	. 
	call S.SETGRP		;72e2	cd ed 00 	. . . 
	jr nc,l72ffh		;72e5	30 18 	0 . 
	jr l72f2h		;72e7	18 09 	. . 
sub_72e9h:
	push hl			;72e9	e5 	. 
	push de			;72ea	d5 	. 
	push bc			;72eb	c5 	. 
	push af			;72ec	f5 	. 
	call S.INIMLT		;72ed	cd e1 00 	. . . 
	jr nc,l72ffh		;72f0	30 0d 	0 . 
l72f2h:
	call TAPIOF		;72f2	cd e7 00 	. . . 
	jp l73b2h		;72f5	c3 b2 73 	. . s 
sub_72f8h:
	push hl			;72f8	e5 	. 
	push de			;72f9	d5 	. 
	push bc			;72fa	c5 	. 
	push af			;72fb	f5 	. 
	call TAPOON		;72fc	cd ea 00 	. . . 
l72ffh:
	pop af			;72ff	f1 	. 
l7300h:
	pop bc			;7300	c1 	. 
	pop de			;7301	d1 	. 
	pop hl			;7302	e1 	. 
	ret			;7303	c9 	. 
sub_7304h:
	xor a			;7304	af 	. 
	ld (PRTFLG),a		;7305	32 16 f4 	2 . . 
	ld a,(LPTPOS)		;7308	3a 15 f4 	: . . 
	or a			;730b	b7 	. 
	ret z			;730c	c8 	. 
	ld a,00dh		;730d	3e 0d 	> . 
	call sub_731ch		;730f	cd 1c 73 	. . s 
	ld a,00ah		;7312	3e 0a 	> . 
	call sub_731ch		;7314	cd 1c 73 	. . s 
	xor a			;7317	af 	. 
	ld (LPTPOS),a		;7318	32 15 f4 	2 . . 
	ret			;731b	c9 	. 
sub_731ch:
	call S.RIGHTC		;731c	cd a5 00 	. . . 
	ret nc			;731f	d0 	. 
	jp l73b2h		;7320	c3 b2 73 	. . s 
sub_7323h:
	ld a,(TTYPOS)		;7323	3a 61 f6 	: a . 
	or a			;7326	b7 	. 
	ret z			;7327	c8 	. 
sub_7328h:
	call H.CRDO		;7328	cd e9 fe 	. . . 
	ld a,00dh		;732b	3e 0d 	> . 
	rst 18h			;732d	df 	. 
	ld a,00ah		;732e	3e 0a 	> . 
	rst 18h			;7330	df 	. 
sub_7331h:
	call ISFLIO		;7331	cd 4a 01 	. J . 
	jr z,l7338h		;7334	28 02 	( . 
	xor a			;7336	af 	. 
	ret			;7337	c9 	. 
l7338h:
	ld a,(PRTFLG)		;7338	3a 16 f4 	: . . 
	or a			;733b	b7 	. 
	jr z,l7343h		;733c	28 05 	( . 
	xor a			;733e	af 	. 
	ld (LPTPOS),a		;733f	32 15 f4 	2 . . 
	ret			;7342	c9 	. 
l7343h:
	ld (TTYPOS),a		;7343	32 61 f6 	2 a . 
	ret			;7346	c9 	. 
l7347h:
	rst 10h			;7347	d7 	. 
	push hl			;7348	e5 	. 
	call CHSNS		;7349	cd 9c 00 	. . . 
	jr z,l735ah		;734c	28 0c 	( . 
	call CHGET		;734e	cd 9f 00 	. . . 
	push af			;7351	f5 	. 
	call sub_6625h		;7352	cd 25 66 	. % f 
	pop af			;7355	f1 	. 
	ld e,a			;7356	5f 	_ 
	call sub_6821h		;7357	cd 21 68 	. ! h 
l735ah:
	ld hl,l3fd6h		;735a	21 d6 3f 	! . ? 
	ld (0f7f8h),hl		;735d	22 f8 f7 	" . . 
	ld a,003h		;7360	3e 03 	> . 
	ld (VALTYP),a		;7362	32 63 f6 	2 c . 
	pop hl			;7365	e1 	. 
	ret			;7366	c9 	. 
sub_7367h:
	rst 18h			;7367	df 	. 
	cp 00ah		;7368	fe 0a 	. . 
	ret nz			;736a	c0 	. 
	ld a,00dh		;736b	3e 0d 	> . 
	rst 18h			;736d	df 	. 
	call sub_7331h		;736e	cd 31 73 	. 1 s 
	ld a,00ah		;7371	3e 0a 	> . 
	ret			;7373	c9 	. 
sub_7374h:
	call H.DSKC		;7374	cd ee fe 	. . . 
	ld b,0ffh		;7377	06 ff 	. . 
	ld hl,BUF		;7379	21 5e f5 	! ^ . 
l737ch:
	call sub_6c71h		;737c	cd 71 6c 	. q l 
	jr c,l7397h		;737f	38 16 	8 . 
	ld (hl),a			;7381	77 	w 
	cp 00dh		;7382	fe 0d 	. . 
	jr z,l7391h		;7384	28 0b 	( . 
	cp 009h		;7386	fe 09 	. . 
	jr z,l738eh		;7388	28 04 	( . 
	cp 00ah		;738a	fe 0a 	. . 
	jr z,l737ch		;738c	28 ee 	( . 
l738eh:
	inc hl			;738e	23 	# 
	djnz l737ch		;738f	10 eb 	. . 
l7391h:
	xor a			;7391	af 	. 
	ld (hl),a			;7392	77 	w 
	ld hl,BUFMIN		;7393	21 5d f5 	! ] . 
	ret			;7396	c9 	. 
l7397h:
	inc b			;7397	04 	. 
	jr nz,l7391h		;7398	20 f7 	  . 
	ld a,(NLONLY)		;739a	3a 7c f8 	: | . 
	and 080h		;739d	e6 80 	. . 
	ld (NLONLY),a		;739f	32 7c f8 	2 | . 
	call sub_6d7bh		;73a2	cd 7b 6d 	. { m 
	ld a,(FILNAM)		;73a5	3a 66 f8 	: f . 
	and a			;73a8	a7 	. 
	jp z,0411eh		;73a9	ca 1e 41 	. . A 
	call sub_629ah		;73ac	cd 9a 62 	. . b 
	jp l4601h		;73af	c3 01 46 	. . F 
l73b2h:
	ld e,013h		;73b2	1e 13 	. . 
	jp l406fh		;73b4	c3 6f 40 	. o @ 
	ld e,0ffh		;73b7	1e ff 	. . 
	jr z,l73c6h		;73b9	28 0b 	( . 
	sub 0ebh		;73bb	d6 eb 	. . 
	ld e,a			;73bd	5f 	_ 
	jr z,$+7		;73be	28 05 	( . 
	rst 8			;73c0	cf 	. 
	sub l			;73c1	95 	. 
	ld e,001h		;73c2	1e 01 	. . 
	ld a,0d7h		;73c4	3e d7 	> . 
l73c6h:
	ld a,e			;73c6	7b 	{ 
	jp STMOTR		;73c7	c3 f3 00 	. . . 
	call sub_521ch		;73ca	cd 1c 52 	. . R 
	cp 00eh		;73cd	fe 0e 	. . 
	jp nc,l475ah		;73cf	d2 5a 47 	. Z G 
	push af			;73d2	f5 	. 
	rst 8			;73d3	cf 	. 
	inc l			;73d4	2c 	, 
	call sub_521ch		;73d5	cd 1c 52 	. . R 
	pop af			;73d8	f1 	. 
	cp 007h		;73d9	fe 07 	. . 
	jr nz,l73e1h		;73db	20 04 	  . 
	res 6,e		;73dd	cb b3 	. . 
	set 7,e		;73df	cb fb 	. . 
l73e1h:
	jp WRTPSG		;73e1	c3 93 00 	. . . 
l73e4h:
	jr nz,$-49		;73e4	20 cd 	  . 
	push bc			;73e6	c5 	. 
	rst 38h			;73e7	ff 	. 
	push hl			;73e8	e5 	. 
	ld hl,BASVDATAt		;73e9	21 2e 75 	! . u 
	ld (MCLTAB),hl		;73ec	22 56 f9 	" V . 
	ld a,000h		;73ef	3e 00 	> . 
	ld (PRSCNT),a		;73f1	32 35 fb 	2 5 . 
	ld hl,0fff6h		;73f4	21 f6 ff 	! . . 
	add hl,sp			;73f7	39 	9 
	ld (SAVSP),hl		;73f8	22 36 fb 	" 6 . 
	pop hl			;73fb	e1 	. 
	push af			;73fc	f5 	. 
l73fdh:
	call sub_4c64h		;73fd	cd 64 4c 	. d L 
	ex (sp),hl			;7400	e3 	. 
	push hl			;7401	e5 	. 
	call sub_67d0h		;7402	cd d0 67 	. . g 
	call sub_2edfh		;7405	cd df 2e 	. . . 
	ld a,e			;7408	7b 	{ 
	or a			;7409	b7 	. 
	jr nz,l7413h		;740a	20 07 	  . 
	ld e,001h		;740c	1e 01 	. . 
	ld bc,l73e4h		;740e	01 e4 73 	. . s 
	ld d,c			;7411	51 	Q 
	ld c,b			;7412	48 	H 
l7413h:
	pop af			;7413	f1 	. 
	push af			;7414	f5 	. 
	call GETVCP		;7415	cd 50 01 	. P . 
	ld (hl),e			;7418	73 	s 
	inc hl			;7419	23 	# 
	ld (hl),d			;741a	72 	r 
	inc hl			;741b	23 	# 
	ld (hl),c			;741c	71 	q 
	inc hl			;741d	23 	# 
	ld d,h			;741e	54 	T 
	ld e,l			;741f	5d 	] 
	ld bc,CALSLT		;7420	01 1c 00 	. . . 
	add hl,bc			;7423	09 	. 
	ex de,hl			;7424	eb 	. 
	ld (hl),e			;7425	73 	s 
	inc hl			;7426	23 	# 
	ld (hl),d			;7427	72 	r 
	pop bc			;7428	c1 	. 
	pop hl			;7429	e1 	. 
	inc b			;742a	04 	. 
	ld a,b			;742b	78 	x 
	cp 003h		;742c	fe 03 	. . 
	jr nc,l7446h		;742e	30 16 	0 . 
	dec hl			;7430	2b 	+ 
	rst 10h			;7431	d7 	. 
	jr z,l7439h		;7432	28 05 	( . 
	push bc			;7434	c5 	. 
	rst 8			;7435	cf 	. 
	inc l			;7436	2c 	, 
	jr l73fdh		;7437	18 c4 	. . 
l7439h:
	ld a,b			;7439	78 	x 
	ld (VOICEN),a		;743a	32 38 fb 	2 8 . 
	call sub_7507h		;743d	cd 07 75 	. . u 
	inc b			;7440	04 	. 
	ld a,b			;7441	78 	x 
	cp 003h		;7442	fe 03 	. . 
	jr c,l7439h		;7444	38 f3 	8 . 
l7446h:
	dec hl			;7446	2b 	+ 
	rst 10h			;7447	d7 	. 
	jp nz,l4055h		;7448	c2 55 40 	. U @ 
	push hl			;744b	e5 	. 
l744ch:
	xor a			;744c	af 	. 
l744dh:
	push af			;744d	f5 	. 
	ld (VOICEN),a		;744e	32 38 fb 	2 8 . 
	ld b,a			;7451	47 	G 
	call sub_7521h		;7452	cd 21 75 	. ! u 
	jp c,l74d6h		;7455	da d6 74 	. . t 
	ld a,b			;7458	78 	x 
	call GETVCP		;7459	cd 50 01 	. P . 
	ld a,(hl)			;745c	7e 	~ 
	or a			;745d	b7 	. 
	jp z,l74d6h		;745e	ca d6 74 	. . t 
	ld (MCLLEN),a		;7461	32 3b fb 	2 ; . 
	inc hl			;7464	23 	# 
	ld e,(hl)			;7465	5e 	^ 
	inc hl			;7466	23 	# 
	ld d,(hl)			;7467	56 	V 
	inc hl			;7468	23 	# 
	ld (MCLPTR),de		;7469	ed 53 3c fb 	. S < . 
	ld e,(hl)			;746d	5e 	^ 
	inc hl			;746e	23 	# 
	ld d,(hl)			;746f	56 	V 
	inc hl			;7470	23 	# 
	push hl			;7471	e5 	. 
	ld l,024h		;7472	2e 24 	. $ 
	call GETVC2		;7474	cd 53 01 	. S . 
	push hl			;7477	e5 	. 
	ld hl,(SAVSP)		;7478	2a 36 fb 	* 6 . 
	dec hl			;747b	2b 	+ 
	pop bc			;747c	c1 	. 
	di			;747d	f3 	. 
	call sub_6253h		;747e	cd 53 62 	. S b 
	pop de			;7481	d1 	. 
	ld h,b			;7482	60 	` 
	ld l,c			;7483	69 	i 
	ld sp,hl			;7484	f9 	. 
	ei			;7485	fb 	. 
	ld a,0ffh		;7486	3e ff 	> . 
	ld (MCLFLG),a		;7488	32 58 f9 	2 X . 
	jp l56a2h		;748b	c3 a2 56 	. . V 
l748eh:
	ld a,(MCLLEN)		;748e	3a 3b fb 	: ; . 
	or a			;7491	b7 	. 
	jr nz,l7497h		;7492	20 03 	  . 
l7494h:
	call sub_7507h		;7494	cd 07 75 	. . u 
l7497h:
	ld a,(VOICEN)		;7497	3a 38 fb 	: 8 . 
	call GETVCP		;749a	cd 50 01 	. P . 
	ld a,(MCLLEN)		;749d	3a 3b fb 	: ; . 
	ld (hl),a			;74a0	77 	w 
	inc hl			;74a1	23 	# 
	ld de,(MCLPTR)		;74a2	ed 5b 3c fb 	. [ < . 
	ld (hl),e			;74a6	73 	s 
	inc hl			;74a7	23 	# 
	ld (hl),d			;74a8	72 	r 
	ld hl,0000h		;74a9	21 00 00 	! . . 
	add hl,sp			;74ac	39 	9 
	ex de,hl			;74ad	eb 	. 
	ld hl,(SAVSP)		;74ae	2a 36 fb 	* 6 . 
	di			;74b1	f3 	. 
	ld sp,hl			;74b2	f9 	. 
	pop bc			;74b3	c1 	. 
	pop bc			;74b4	c1 	. 
	pop bc			;74b5	c1 	. 
	push hl			;74b6	e5 	. 
	or a			;74b7	b7 	. 
	sbc hl,de		;74b8	ed 52 	. R 
	jr z,l74d4h		;74ba	28 18 	( . 
	ld a,0f0h		;74bc	3e f0 	> . 
	and l			;74be	a5 	. 
	or h			;74bf	b4 	. 
	jp nz,l475ah		;74c0	c2 5a 47 	. Z G 
	ld l,024h		;74c3	2e 24 	. $ 
	call GETVC2		;74c5	cd 53 01 	. S . 
	pop bc			;74c8	c1 	. 
	dec bc			;74c9	0b 	. 
	call sub_6253h		;74ca	cd 53 62 	. S b 
	pop hl			;74cd	e1 	. 
	dec hl			;74ce	2b 	+ 
	ld (hl),b			;74cf	70 	p 
	dec hl			;74d0	2b 	+ 
	ld (hl),c			;74d1	71 	q 
	jr l74d6h		;74d2	18 02 	. . 
l74d4h:
	pop bc			;74d4	c1 	. 
	pop bc			;74d5	c1 	. 
l74d6h:
	ei			;74d6	fb 	. 
	pop af			;74d7	f1 	. 
	inc a			;74d8	3c 	< 
	cp 003h		;74d9	fe 03 	. . 
	jp c,l744dh		;74db	da 4d 74 	. M t 
	di			;74de	f3 	. 
	ld a,(INTFLG)		;74df	3a 9b fc 	: . . 
	cp 003h		;74e2	fe 03 	. . 
	jr z,l7502h		;74e4	28 1c 	( . 
	ld a,(PRSCNT)		;74e6	3a 35 fb 	: 5 . 
	rlca			;74e9	07 	. 
	jr c,l74f3h		;74ea	38 07 	8 . 
	ld hl,PLYCNT		;74ec	21 40 fb 	! @ . 
	inc (hl)			;74ef	34 	4 
	call STRTMS		;74f0	cd 99 00 	. . . 
l74f3h:
	ei			;74f3	fb 	. 
	ld hl,PRSCNT		;74f4	21 35 fb 	! 5 . 
	ld a,(hl)			;74f7	7e 	~ 
	or 080h		;74f8	f6 80 	. . 
	ld (hl),a			;74fa	77 	w 
	cp 083h		;74fb	fe 83 	. . 
	jp nz,l744ch		;74fd	c2 4c 74 	. L t 
l7500h:
	pop hl			;7500	e1 	. 
	ret			;7501	c9 	. 
l7502h:
	call GICINI		;7502	cd 90 00 	. . . 
	jr l7500h		;7505	18 f9 	. . 
sub_7507h:
	ld a,(PRSCNT)		;7507	3a 35 fb 	: 5 . 
	inc a			;750a	3c 	< 
	ld (PRSCNT),a		;750b	32 35 fb 	2 5 . 
	ld e,0ffh		;750e	1e ff 	. . 
sub_7510h:
	push hl			;7510	e5 	. 
	push bc			;7511	c5 	. 
l7512h:
	push de			;7512	d5 	. 
	ld a,(VOICEN)		;7513	3a 38 fb 	: 8 . 
	di			;7516	f3 	. 
	call PUTQ		;7517	cd f9 00 	. . . 
	ei			;751a	fb 	. 
	pop de			;751b	d1 	. 
	jr z,l7512h		;751c	28 f4 	( . 
	pop bc			;751e	c1 	. 
	pop hl			;751f	e1 	. 
	ret			;7520	c9 	. 
sub_7521h:
	ld a,(VOICEN)		;7521	3a 38 fb 	: 8 . 
	push bc			;7524	c5 	. 
	di			;7525	f3 	. 
	call LFTQ		;7526	cd f6 00 	. . . 
	ei			;7529	fb 	. 
	pop bc			;752a	c1 	. 
	cp 008h		;752b	fe 08 	. . 
	ret			;752d	c9 	. 

; BLOCK 'BASVDATA' (start 0x752e end 0x7586)
BASVDATAt:
	defb 041h		;752e	41 	A 
	defb 03eh		;752f	3e 	> 
	defb 076h		;7530	76 	v 
	defb 042h		;7531	42 	B 
	defb 03eh		;7532	3e 	> 
	defb 076h		;7533	76 	v 
	defb 043h		;7534	43 	C 
	defb 03eh		;7535	3e 	> 
	defb 076h		;7536	76 	v 
	defb 044h		;7537	44 	D 
	defb 03eh		;7538	3e 	> 
	defb 076h		;7539	76 	v 
	defb 045h		;753a	45 	E 
	defb 03eh		;753b	3e 	> 
	defb 076h		;753c	76 	v 
	defb 046h		;753d	46 	F 
	defb 03eh		;753e	3e 	> 
	defb 076h		;753f	76 	v 
	defb 047h		;7540	47 	G 
	defb 03eh		;7541	3e 	> 
	defb 076h		;7542	76 	v 
	defb 0cdh		;7543	cd 	. 
	defb 09eh		;7544	9e 	. 
	defb 075h		;7545	75 	u 
	defb 0d6h		;7546	d6 	. 
	defb 086h		;7547	86 	. 
	defb 075h		;7548	75 	u 
	defb 0d3h		;7549	d3 	. 
	defb 0beh		;754a	be 	. 
	defb 075h		;754b	75 	u 
	defb 0ceh		;754c	ce 	. 
	defb 021h		;754d	21 	! 
	defb 076h		;754e	76 	v 
	defb 0cfh		;754f	cf 	. 
	defb 0efh		;7550	ef 	. 
	defb 075h		;7551	75 	u 
	defb 0d2h		;7552	d2 	. 
	defb 0fch		;7553	fc 	. 
	defb 075h		;7554	75 	u 
	defb 0d4h		;7555	d4 	. 
	defb 0e2h		;7556	e2 	. 
	defb 075h		;7557	75 	u 
	defb 0cch		;7558	cc 	. 
	defb 0c8h		;7559	c8 	. 
	defb 075h		;755a	75 	u 
	defb 058h		;755b	58 	X 
	defb 082h		;755c	82 	. 
	defb 057h		;755d	57 	W 
	defb 000h		;755e	00 	. 
l755fh:
	defb 010h		;755f	10 	. 
	defb 012h		;7560	12 	. 
	defb 014h		;7561	14 	. 
	defb 016h		;7562	16 	. 
	defb 000h		;7563	00 	. 
	defb 000h		;7564	00 	. 
	defb 002h		;7565	02 	. 
	defb 004h		;7566	04 	. 
	defb 006h		;7567	06 	. 
	defb 008h		;7568	08 	. 
	defb 00ah		;7569	0a 	. 
	defb 00ah		;756a	0a 	. 
	defb 00ch		;756b	0c 	. 
	defb 00eh		;756c	0e 	. 
	defb 010h		;756d	10 	. 
l756eh:
	defb 05dh		;756e	5d 	] 
	defb 00dh		;756f	0d 	. 
	defb 09ch		;7570	9c 	. 
	defb 00ch		;7571	0c 	. 
	defb 0e7h		;7572	e7 	. 
	defb 00bh		;7573	0b 	. 
	defb 03ch		;7574	3c 	< 
	defb 00bh		;7575	0b 	. 
	defb 09bh		;7576	9b 	. 
	defb 00ah		;7577	0a 	. 
	defb 002h		;7578	02 	. 
	defb 00ah		;7579	0a 	. 
	defb 073h		;757a	73 	s 
	defb 009h		;757b	09 	. 
	defb 0ebh		;757c	eb 	. 
	defb 008h		;757d	08 	. 
	defb 06bh		;757e	6b 	k 
	defb 008h		;757f	08 	. 
	defb 0f2h		;7580	f2 	. 
	defb 007h		;7581	07 	. 
	defb 080h		;7582	80 	. 
	defb 007h		;7583	07 	. 
	defb 014h		;7584	14 	. 
	defb 007h		;7585	07 	. 
BASVDATA_end:
	jr c,l758ah		;7586	38 02 	8 . 
	ld e,008h		;7588	1e 08 	. . 
l758ah:
	ld a,00fh		;758a	3e 0f 	> . 
	cp e			;758c	bb 	. 
	jr c,l75dfh		;758d	38 50 	8 P 
l758fh:
	xor a			;758f	af 	. 
	or d			;7590	b2 	. 
	jr nz,l75dfh		;7591	20 4c 	  L 
	ld l,012h		;7593	2e 12 	. . 
	call GETVC2		;7595	cd 53 01 	. S . 
	ld a,040h		;7598	3e 40 	> @ 
	and (hl)			;759a	a6 	. 
	or e			;759b	b3 	. 
	ld (hl),a			;759c	77 	w 
	ret			;759d	c9 	. 
	ld a,e			;759e	7b 	{ 
	jr c,l75a4h		;759f	38 03 	8 . 
	cpl			;75a1	2f 	/ 
	inc a			;75a2	3c 	< 
	ld e,a			;75a3	5f 	_ 
l75a4h:
	or d			;75a4	b2 	. 
	jr z,l75dfh		;75a5	28 38 	( 8 
	ld l,013h		;75a7	2e 13 	. . 
	call GETVC2		;75a9	cd 53 01 	. S . 
	push hl			;75ac	e5 	. 
	ld a,(hl)			;75ad	7e 	~ 
	inc hl			;75ae	23 	# 
	ld h,(hl)			;75af	66 	f 
	ld l,a			;75b0	6f 	o 
	rst 20h			;75b1	e7 	. 
	pop hl			;75b2	e1 	. 
	ret z			;75b3	c8 	. 
	ld (hl),e			;75b4	73 	s 
	inc hl			;75b5	23 	# 
	ld (hl),d			;75b6	72 	r 
	dec hl			;75b7	2b 	+ 
	dec hl			;75b8	2b 	+ 
	ld a,040h		;75b9	3e 40 	> @ 
	or (hl)			;75bb	b6 	. 
	ld (hl),a			;75bc	77 	w 
	ret			;75bd	c9 	. 
	ld a,e			;75be	7b 	{ 
	cp 010h		;75bf	fe 10 	. . 
	jr nc,l75dfh		;75c1	30 1c 	0 . 
	or 010h		;75c3	f6 10 	. . 
	ld e,a			;75c5	5f 	_ 
	jr l758fh		;75c6	18 c7 	. . 
	jr c,l75cch		;75c8	38 02 	8 . 
	ld e,004h		;75ca	1e 04 	. . 
l75cch:
	ld a,e			;75cc	7b 	{ 
	cp 041h		;75cd	fe 41 	. A 
	jr nc,l75dfh		;75cf	30 0e 	0 . 
	ld l,010h		;75d1	2e 10 	. . 
l75d3h:
	call GETVC2		;75d3	cd 53 01 	. S . 
	xor a			;75d6	af 	. 
	or d			;75d7	b2 	. 
	jr nz,l75dfh		;75d8	20 05 	  . 
	or e			;75da	b3 	. 
	jr z,l75dfh		;75db	28 02 	( . 
	ld (hl),a			;75dd	77 	w 
	ret			;75de	c9 	. 
l75dfh:
	call l475ah		;75df	cd 5a 47 	. Z G 
	jr c,l75e6h		;75e2	38 02 	8 . 
	ld e,078h		;75e4	1e 78 	. x 
l75e6h:
	ld a,e			;75e6	7b 	{ 
	cp 020h		;75e7	fe 20 	.   
	jr c,l75dfh		;75e9	38 f4 	8 . 
	ld l,011h		;75eb	2e 11 	. . 
	jr l75d3h		;75ed	18 e4 	. . 
	jr c,l75f3h		;75ef	38 02 	8 . 
	ld e,004h		;75f1	1e 04 	. . 
l75f3h:
	ld a,e			;75f3	7b 	{ 
	cp 009h		;75f4	fe 09 	. . 
	jr nc,l75dfh		;75f6	30 e7 	0 . 
	ld l,00fh		;75f8	2e 0f 	. . 
	jr l75d3h		;75fa	18 d7 	. . 
	jr c,l7600h		;75fc	38 02 	8 . 
	ld e,004h		;75fe	1e 04 	. . 
l7600h:
	xor a			;7600	af 	. 
	or d			;7601	b2 	. 
	jr nz,l75dfh		;7602	20 db 	  . 
	or e			;7604	b3 	. 
	jr z,l75dfh		;7605	28 d8 	( . 
	cp 041h		;7607	fe 41 	. A 
	jr nc,l75dfh		;7609	30 d4 	0 . 
l760bh:
	ld hl,0000h		;760b	21 00 00 	! . . 
	push hl			;760e	e5 	. 
	ld l,010h		;760f	2e 10 	. . 
	call GETVC2		;7611	cd 53 01 	. S . 
	push hl			;7614	e5 	. 
	inc hl			;7615	23 	# 
	inc hl			;7616	23 	# 
	ld a,(hl)			;7617	7e 	~ 
	ld (SAVVOL),a		;7618	32 39 fb 	2 9 . 
	ld (hl),080h		;761b	36 80 	6 . 
	dec hl			;761d	2b 	+ 
	dec hl			;761e	2b 	+ 
	jr l769ch		;761f	18 7b 	. { 
	jr nc,l75dfh		;7621	30 bc 	0 . 
	xor a			;7623	af 	. 
	or d			;7624	b2 	. 
	jr nz,l75dfh		;7625	20 b8 	  . 
	or e			;7627	b3 	. 
	jr z,l760bh		;7628	28 e1 	( . 
	cp 061h		;762a	fe 61 	. a 
	jr nc,l75dfh		;762c	30 b1 	0 . 
	ld a,e			;762e	7b 	{ 
	ld b,000h		;762f	06 00 	. . 
	ld e,b			;7631	58 	X 
l7632h:
	sub 00ch		;7632	d6 0c 	. . 
	inc e			;7634	1c 	. 
	jr nc,l7632h		;7635	30 fb 	0 . 
	add a,00ch		;7637	c6 0c 	. . 
	add a,a			;7639	87 	. 
	ld c,a			;763a	4f 	O 
	jp l7673h		;763b	c3 73 76 	. s v 
	ld b,c			;763e	41 	A 
	ld a,c			;763f	79 	y 
	sub 040h		;7640	d6 40 	. @ 
	add a,a			;7642	87 	. 
	ld c,a			;7643	4f 	O 
	call sub_56eeh		;7644	cd ee 56 	. . V 
	jr z,l7665h		;7647	28 1c 	( . 
	cp 023h		;7649	fe 23 	. # 
	jr z,l7666h		;764b	28 19 	( . 
	cp 02bh		;764d	fe 2b 	. + 
	jr z,l7666h		;764f	28 15 	( . 
	cp 02dh		;7651	fe 2d 	. - 
	jr z,l765ah		;7653	28 05 	( . 
	call sub_570bh		;7655	cd 0b 57 	. . W 
	jr l7665h		;7658	18 0b 	. . 
l765ah:
	dec c			;765a	0d 	. 
	ld a,b			;765b	78 	x 
	cp 043h		;765c	fe 43 	. C 
	jr z,l7664h		;765e	28 04 	( . 
	cp 046h		;7660	fe 46 	. F 
	jr nz,l7665h		;7662	20 01 	  . 
l7664h:
	dec c			;7664	0d 	. 
l7665h:
	dec c			;7665	0d 	. 
l7666h:
	ld l,00fh		;7666	2e 0f 	. . 
	call GETVC2		;7668	cd 53 01 	. S . 
	ld e,(hl)			;766b	5e 	^ 
	ld b,000h		;766c	06 00 	. . 
	ld hl,l755fh		;766e	21 5f 75 	! _ u 
	add hl,bc			;7671	09 	. 
	ld c,(hl)			;7672	4e 	N 
l7673h:
	ld hl,l756eh		;7673	21 6e 75 	! n u 
	add hl,bc			;7676	09 	. 
	ld a,e			;7677	7b 	{ 
	ld e,(hl)			;7678	5e 	^ 
	inc hl			;7679	23 	# 
	ld d,(hl)			;767a	56 	V 
l767bh:
	dec a			;767b	3d 	= 
	jr z,l7687h		;767c	28 09 	( . 
	srl d		;767e	cb 3a 	. : 
	rr e		;7680	cb 1b 	. . 
	jr l767bh		;7682	18 f7 	. . 
l7684h:
	call l475ah		;7684	cd 5a 47 	. Z G 
l7687h:
	adc a,e			;7687	8b 	. 
	ld e,a			;7688	5f 	_ 
	adc a,d			;7689	8a 	. 
	sub e			;768a	93 	. 
	ld d,a			;768b	57 	W 
	push de			;768c	d5 	. 
	ld l,010h		;768d	2e 10 	. . 
	call GETVC2		;768f	cd 53 01 	. S . 
	ld c,(hl)			;7692	4e 	N 
	push hl			;7693	e5 	. 
	call sub_56eeh		;7694	cd ee 56 	. . V 
	jr z,l76a9h		;7697	28 10 	( . 
	call l572fh		;7699	cd 2f 57 	. / W 
l769ch:
	ld a,040h		;769c	3e 40 	> @ 
	cp e			;769e	bb 	. 
	jr c,l7684h		;769f	38 e3 	8 . 
	xor a			;76a1	af 	. 
	or d			;76a2	b2 	. 
	jr nz,l7684h		;76a3	20 df 	  . 
	or e			;76a5	b3 	. 
	jr z,l76a9h		;76a6	28 01 	( . 
	ld c,e			;76a8	4b 	K 
l76a9h:
	pop hl			;76a9	e1 	. 
	ld d,000h		;76aa	16 00 	. . 
	ld b,d			;76ac	42 	B 
	inc hl			;76ad	23 	# 
	ld e,(hl)			;76ae	5e 	^ 
	push hl			;76af	e5 	. 
	call sub_314ah		;76b0	cd 4a 31 	. J 1 
	ex de,hl			;76b3	eb 	. 
	call sub_2fcbh		;76b4	cd cb 2f 	. . / 
	call sub_2f0dh		;76b7	cd 0d 2f 	. . / 
	ld hl,BASHZ_start		;76ba	21 54 77 	! T w 
	call sub_2ebeh		;76bd	cd be 2e 	. . . 
	call l289fh		;76c0	cd 9f 28 	. . ( 
	call sub_2f8ah		;76c3	cd 8a 2f 	. . / 
	ld d,h			;76c6	54 	T 
	ld e,l			;76c7	5d 	] 
l76c8h:
	call sub_56eeh		;76c8	cd ee 56 	. . V 
	jr z,l76e3h		;76cb	28 16 	( . 
	cp 02eh		;76cd	fe 2e 	. . 
	jr nz,l76e0h		;76cf	20 0f 	  . 
	srl d		;76d1	cb 3a 	. : 
	rr e		;76d3	cb 1b 	. . 
	adc hl,de		;76d5	ed 5a 	. Z 
	ld a,0e0h		;76d7	3e e0 	> . 
	and h			;76d9	a4 	. 
	jr z,l76c8h		;76da	28 ec 	( . 
	xor h			;76dc	ac 	. 
	ld h,a			;76dd	67 	g 
	jr l76e3h		;76de	18 03 	. . 
l76e0h:
	call sub_570bh		;76e0	cd 0b 57 	. . W 
l76e3h:
	ld de,05h		;76e3	11 05 00 	. . . 
	rst 20h			;76e6	e7 	. 
	jr c,l76eah		;76e7	38 01 	8 . 
	ex de,hl			;76e9	eb 	. 
l76eah:
	ld bc,0fff7h		;76ea	01 f7 ff 	. . . 
	pop hl			;76ed	e1 	. 
	push hl			;76ee	e5 	. 
	add hl,bc			;76ef	09 	. 
	ld (hl),d			;76f0	72 	r 
	inc hl			;76f1	23 	# 
	ld (hl),e			;76f2	73 	s 
	inc hl			;76f3	23 	# 
	ld c,002h		;76f4	0e 02 	. . 
	ex (sp),hl			;76f6	e3 	. 
	inc hl			;76f7	23 	# 
	ld e,(hl)			;76f8	5e 	^ 
	ld a,e			;76f9	7b 	{ 
	and 0bfh		;76fa	e6 bf 	. . 
	ld (hl),a			;76fc	77 	w 
	ex (sp),hl			;76fd	e3 	. 
	ld a,080h		;76fe	3e 80 	> . 
	or e			;7700	b3 	. 
	ld (hl),a			;7701	77 	w 
	inc hl			;7702	23 	# 
	inc c			;7703	0c 	. 
	ex (sp),hl			;7704	e3 	. 
	ld a,e			;7705	7b 	{ 
	and 040h		;7706	e6 40 	. @ 
	jr z,$+14		;7708	28 0c 	( . 
	inc hl			;770a	23 	# 
	ld e,(hl)			;770b	5e 	^ 
	inc hl			;770c	23 	# 
	ld d,(hl)			;770d	56 	V 
	pop hl			;770e	e1 	. 
	ld (hl),d			;770f	72 	r 
	inc hl			;7710	23 	# 
	ld (hl),e			;7711	73 	s 
	inc hl			;7712	23 	# 
	inc c			;7713	0c 	. 
	inc c			;7714	0c 	. 
	cp 0e1h		;7715	fe e1 	. . 
	pop de			;7717	d1 	. 
	ld a,d			;7718	7a 	z 
	or e			;7719	b3 	. 
	jr z,l7721h		;771a	28 05 	( . 
	ld (hl),d			;771c	72 	r 
	inc hl			;771d	23 	# 
	ld (hl),e			;771e	73 	s 
	inc c			;771f	0c 	. 
	inc c			;7720	0c 	. 
l7721h:
	ld l,007h		;7721	2e 07 	. . 
	call GETVC2		;7723	cd 53 01 	. S . 
	ld (hl),c			;7726	71 	q 
	ld a,c			;7727	79 	y 
	sub 002h		;7728	d6 02 	. . 
	rrca			;772a	0f 	. 
	rrca			;772b	0f 	. 
	rrca			;772c	0f 	. 
	inc hl			;772d	23 	# 
	or (hl)			;772e	b6 	. 
	ld (hl),a			;772f	77 	w 
	dec hl			;7730	2b 	+ 
	ld a,d			;7731	7a 	z 
	or e			;7732	b3 	. 
	jr nz,l7741h		;7733	20 0c 	  . 
	push hl			;7735	e5 	. 
	ld a,(SAVVOL)		;7736	3a 39 fb 	: 9 . 
	or 080h		;7739	f6 80 	. . 
	ld bc,000bh		;773b	01 0b 00 	. . . 
	add hl,bc			;773e	09 	. 
	ld (hl),a			;773f	77 	w 
	pop hl			;7740	e1 	. 
l7741h:
	pop de			;7741	d1 	. 
	ld b,(hl)			;7742	46 	F 
	inc hl			;7743	23 	# 
l7744h:
	ld e,(hl)			;7744	5e 	^ 
	inc hl			;7745	23 	# 
	call sub_7510h		;7746	cd 10 75 	. . u 
	djnz l7744h		;7749	10 f9 	. . 
	call sub_7521h		;774b	cd 21 75 	. ! u 
	jp c,l748eh		;774e	da 8e 74 	. . t 
	jp l56a2h		;7751	c3 a2 56 	. . V 

; BLOCK 'BASHZ' (start 0x7754 end 0x7758)
BASHZ_start:
    IF INTHZ == 60
	defb 040h		;7754	40 	@ 
	defb 000h		;7755	00 	. 
	defb 045h		;7756	45 	E 
	defb 014h		;7757	14 	. 
    ELSE
	defb 000h		;7754	00 	. 
	defb 000h		;7755	00 	. 
	defb 045h		;7756	45 	E 
	defb 012h		;7757	12 	. 
    ENDIF
BASHZ_end:
	ld b,080h		;7758	06 80 	. . 
	ld de,006h		;775a	11 06 00 	. . . 
	cp 0c7h		;775d	fe c7 	. . 
	jp l7993h		;775f	c3 93 79 	. . y 
l7762h:
	ld a,b			;7762	78 	x 
	jp l6c35h		;7763	c3 35 6c 	. 5 l 
	ld de,(CSRY)		;7766	ed 5b dc f3 	. [ . . 
	push de			;776a	d5 	. 
	cp 02ch		;776b	fe 2c 	. , 
	jr z,l777ah		;776d	28 0b 	( . 
	call sub_521ch		;776f	cd 1c 52 	. . R 
	inc a			;7772	3c 	< 
	pop de			;7773	d1 	. 
	ld d,a			;7774	57 	W 
	push de			;7775	d5 	. 
	dec hl			;7776	2b 	+ 
	rst 10h			;7777	d7 	. 
	jr z,l779fh		;7778	28 25 	( % 
l777ah:
	rst 8			;777a	cf 	. 
	inc l			;777b	2c 	, 
	cp 02ch		;777c	fe 2c 	. , 
	jr z,l778bh		;777e	28 0b 	( . 
	call sub_521ch		;7780	cd 1c 52 	. . R 
	inc a			;7783	3c 	< 
	pop de			;7784	d1 	. 
	ld e,a			;7785	5f 	_ 
	push de			;7786	d5 	. 
	dec hl			;7787	2b 	+ 
	rst 10h			;7788	d7 	. 
	jr z,l779fh		;7789	28 14 	( . 
l778bh:
	rst 8			;778b	cf 	. 
	inc l			;778c	2c 	, 
	call sub_521ch		;778d	cd 1c 52 	. . R 
	and a			;7790	a7 	. 
	ld a,079h		;7791	3e 79 	> y 
	jr nz,l7796h		;7793	20 01 	  . 
	dec a			;7795	3d 	= 
l7796h:
	push af			;7796	f5 	. 
	ld a,01bh		;7797	3e 1b 	> . 
	rst 18h			;7799	df 	. 
	pop af			;779a	f1 	. 
	rst 18h			;779b	df 	. 
	ld a,035h		;779c	3e 35 	> 5 
	rst 18h			;779e	df 	. 
l779fh:
	ex (sp),hl			;779f	e3 	. 
	call POSIT		;77a0	cd c6 00 	. . . 
	pop hl			;77a3	e1 	. 
	ret			;77a4	c9 	. 
l77a5h:
	push hl			;77a5	e5 	. 
	ld hl,0fc6ah		;77a6	21 6a fc 	! j . 
	jr l77cfh		;77a9	18 24 	. $ 
l77abh:
	push hl			;77ab	e5 	. 
	ld hl,0fc6dh		;77ac	21 6d fc 	! m . 
	jr l77cfh		;77af	18 1e 	. . 
l77b1h:
	rst 8			;77b1	cf 	. 
	ld b,l			;77b2	45 	E 
	rst 8			;77b3	cf 	. 
	ld d,d			;77b4	52 	R 
	rst 8			;77b5	cf 	. 
	rst 38h			;77b6	ff 	. 
	rst 8			;77b7	cf 	. 
	sub h			;77b8	94 	. 
	push hl			;77b9	e5 	. 
	ld hl,0fc7fh		;77ba	21 7f fc 	!  . 
	jr l77cfh		;77bd	18 10 	. . 
l77bfh:
	ld a,004h		;77bf	3e 04 	> . 
	call sub_7c08h		;77c1	cd 08 7c 	. . | 
	dec hl			;77c4	2b 	+ 
	rst 10h			;77c5	d7 	. 
	push hl			;77c6	e5 	. 
	ld d,000h		;77c7	16 00 	. . 
	ld hl,0fc70h		;77c9	21 70 fc 	! p . 
	add hl,de			;77cc	19 	. 
	add hl,de			;77cd	19 	. 
	add hl,de			;77ce	19 	. 
l77cfh:
	call sub_77feh		;77cf	cd fe 77 	. . w 
	jr l77e2h		;77d2	18 0e 	. . 
l77d4h:
	call sub_521ch		;77d4	cd 1c 52 	. . R 
	dec a			;77d7	3d 	= 
	cp 00ah		;77d8	fe 0a 	. . 
	jp nc,l475ah		;77da	d2 5a 47 	. Z G 
	ld a,(hl)			;77dd	7e 	~ 
	push hl			;77de	e5 	. 
	call sub_77e8h		;77df	cd e8 77 	. . w 
l77e2h:
	pop hl			;77e2	e1 	. 
	pop af			;77e3	f1 	. 
	rst 10h			;77e4	d7 	. 
	jp l4612h		;77e5	c3 12 46 	. . F 
sub_77e8h:
	ld d,000h		;77e8	16 00 	. . 
	ld hl,FNKSWI		;77ea	21 cd fb 	! . . 
	add hl,de			;77ed	19 	. 
	push hl			;77ee	e5 	. 
	ld hl,0fc49h		;77ef	21 49 fc 	! I . 
	add hl,de			;77f2	19 	. 
	add hl,de			;77f3	19 	. 
	add hl,de			;77f4	19 	. 
	call sub_77feh		;77f5	cd fe 77 	. . w 
	ld a,(hl)			;77f8	7e 	~ 
	and 001h		;77f9	e6 01 	. . 
	pop hl			;77fb	e1 	. 
	ld (hl),a			;77fc	77 	w 
	ret			;77fd	c9 	. 
sub_77feh:
	cp 095h		;77fe	fe 95 	. . 
	jp z,l631bh		;7800	ca 1b 63 	. . c 
	cp 0ebh		;7803	fe eb 	. . 
	jp z,l632bh		;7805	ca 2b 63 	. + c 
	cp 090h		;7808	fe 90 	. . 
	jp z,sub_6331h		;780a	ca 31 63 	. 1 c 
	jp l4055h		;780d	c3 55 40 	. U @ 
sub_7810h:
	call H.ONGO		;7810	cd ea fd 	. . . 
	ld bc,000ah		;7813	01 0a 00 	. . . 
	cp 0cch		;7816	fe cc 	. . 
	ret z			;7818	c8 	. 
	ld bc,l0a01h		;7819	01 01 0a 	. . . 
	cp 090h		;781c	fe 90 	. . 
	ret z			;781e	c8 	. 
	inc b			;781f	04 	. 
	cp 0c7h		;7820	fe c7 	. . 
	ret z			;7822	c8 	. 
	cp 0ffh		;7823	fe ff 	. . 
	ret c			;7825	d8 	. 
	push hl			;7826	e5 	. 
	rst 10h			;7827	d7 	. 
	cp 0a3h		;7828	fe a3 	. . 
	jr z,l7833h		;782a	28 07 	( . 
	cp 085h		;782c	fe 85 	. . 
	jr z,l7838h		;782e	28 08 	( . 
l7830h:
	pop hl			;7830	e1 	. 
	scf			;7831	37 	7 
	ret			;7832	c9 	. 
l7833h:
	pop bc			;7833	c1 	. 
	ld bc,l0c05h		;7834	01 05 0c 	. . . 
	ret			;7837	c9 	. 
l7838h:
	rst 10h			;7838	d7 	. 
	cp 045h		;7839	fe 45 	. E 
	jr nz,l7830h		;783b	20 f3 	  . 
	pop bc			;783d	c1 	. 
	rst 10h			;783e	d7 	. 
	rst 8			;783f	cf 	. 
	ld d,d			;7840	52 	R 
	rst 8			;7841	cf 	. 
	rst 38h			;7842	ff 	. 
	rst 8			;7843	cf 	. 
	sub h			;7844	94 	. 
	rst 8			;7845	cf 	. 
	rst 28h			;7846	ef 	. 
	call sub_542fh		;7847	cd 2f 54 	. / T 
	ld a,d			;784a	7a 	z 
	or e			;784b	b3 	. 
	jp z,l475ah		;784c	ca 5a 47 	. Z G 
	ex de,hl			;784f	eb 	. 
	ld (INTVAL),hl		;7850	22 a0 fc 	" . . 
	ld (INTCNT),hl		;7853	22 a2 fc 	" . . 
	ex de,hl			;7856	eb 	. 
	ld bc,l1101h		;7857	01 01 11 	. . . 
	dec hl			;785a	2b 	+ 
	ret			;785b	c9 	. 
sub_785ch:
	push hl			;785c	e5 	. 
	ld b,a			;785d	47 	G 
	add a,a			;785e	87 	. 
	add a,b			;785f	80 	. 
	ld l,a			;7860	6f 	o 
	ld h,000h		;7861	26 00 	& . 
	ld bc,0fc4dh		;7863	01 4d fc 	. M . 
	add hl,bc			;7866	09 	. 
	ld (hl),e			;7867	73 	s 
	inc hl			;7868	23 	# 
	ld (hl),d			;7869	72 	r 
	pop hl			;786a	e1 	. 
	ret			;786b	c9 	. 
	cp 093h		;786c	fe 93 	. . 
	jr nz,l78aeh		;786e	20 3e 	  > 
	rst 10h			;7870	d7 	. 
	push hl			;7871	e5 	. 
	ld hl,FNKSTR		;7872	21 7f f8 	!  . 
	ld c,00ah		;7875	0e 0a 	. . 
l7877h:
	ld b,010h		;7877	06 10 	. . 
l7879h:
	ld a,(hl)			;7879	7e 	~ 
	inc hl			;787a	23 	# 
	call CNVCHR		;787b	cd ab 00 	. . . 
	jr c,l7891h		;787e	38 11 	8 . 
	dec b			;7880	05 	. 
	jr z,l789eh		;7881	28 1b 	( . 
	ld a,(hl)			;7883	7e 	~ 
	inc hl			;7884	23 	# 
	ld e,a			;7885	5f 	_ 
	call CNVCHR		;7886	cd ab 00 	. . . 
	jr z,l7891h		;7889	28 06 	( . 
	ld a,001h		;788b	3e 01 	> . 
	rst 18h			;788d	df 	. 
	ld a,e			;788e	7b 	{ 
	jr l789bh		;788f	18 0a 	. . 
l7891h:
	cp 07fh		;7891	fe 7f 	.  
	jr z,l7899h		;7893	28 04 	( . 
	cp 020h		;7895	fe 20 	.   
	jr nc,l789bh		;7897	30 02 	0 . 
l7899h:
	ld a,020h		;7899	3e 20 	>   
l789bh:
	rst 18h			;789b	df 	. 
	djnz l7879h		;789c	10 db 	. . 
l789eh:
	call sub_7328h		;789e	cd 28 73 	. ( s 
	dec c			;78a1	0d 	. 
	jr nz,l7877h		;78a2	20 d3 	  . 
	pop hl			;78a4	e1 	. 
	ret			;78a5	c9 	. 
l78a6h:
	rst 10h			;78a6	d7 	. 
	jp DSPFNK		;78a7	c3 cf 00 	. . . 
l78aah:
	rst 10h			;78aa	d7 	. 
	jp ERAFNK		;78ab	c3 cc 00 	. . . 
l78aeh:
	cp 028h		;78ae	fe 28 	. ( 
	jp z,l77d4h		;78b0	ca d4 77 	. . w 
	cp 095h		;78b3	fe 95 	. . 
	jr z,l78a6h		;78b5	28 ef 	( . 
	cp 0ebh		;78b7	fe eb 	. . 
	jr z,l78aah		;78b9	28 ef 	( . 
	call sub_521ch		;78bb	cd 1c 52 	. . R 
	dec a			;78be	3d 	= 
	cp 00ah		;78bf	fe 0a 	. . 
	jp nc,l475ah		;78c1	d2 5a 47 	. Z G 
	ex de,hl			;78c4	eb 	. 
	ld l,a			;78c5	6f 	o 
	ld h,000h		;78c6	26 00 	& . 
	add hl,hl			;78c8	29 	) 
	add hl,hl			;78c9	29 	) 
	add hl,hl			;78ca	29 	) 
	add hl,hl			;78cb	29 	) 
	ld bc,FNKSTR		;78cc	01 7f f8 	.  . 
	add hl,bc			;78cf	09 	. 
	push hl			;78d0	e5 	. 
	ex de,hl			;78d1	eb 	. 
	rst 8			;78d2	cf 	. 
	inc l			;78d3	2c 	, 
	call sub_4c64h		;78d4	cd 64 4c 	. d L 
	push hl			;78d7	e5 	. 
	call sub_67d0h		;78d8	cd d0 67 	. . g 
	ld b,(hl)			;78db	46 	F 
	inc hl			;78dc	23 	# 
	ld e,(hl)			;78dd	5e 	^ 
	inc hl			;78de	23 	# 
	ld d,(hl)			;78df	56 	V 
	pop hl			;78e0	e1 	. 
	ex (sp),hl			;78e1	e3 	. 
	ld c,00fh		;78e2	0e 0f 	. . 
	ld a,b			;78e4	78 	x 
	and a			;78e5	a7 	. 
	jr z,l78f5h		;78e6	28 0d 	( . 
l78e8h:
	ld a,(de)			;78e8	1a 	. 
	and a			;78e9	a7 	. 
	jp z,l475ah		;78ea	ca 5a 47 	. Z G 
	ld (hl),a			;78ed	77 	w 
	inc de			;78ee	13 	. 
	inc hl			;78ef	23 	# 
	dec c			;78f0	0d 	. 
	jr z,l78fah		;78f1	28 07 	( . 
	djnz l78e8h		;78f3	10 f3 	. . 
l78f5h:
	ld (hl),b			;78f5	70 	p 
	inc hl			;78f6	23 	# 
	dec c			;78f7	0d 	. 
	jr nz,l78f5h		;78f8	20 fb 	  . 
l78fah:
	ld (hl),c			;78fa	71 	q 
	call FNKSB		;78fb	cd c9 00 	. . . 
	pop hl			;78fe	e1 	. 
	ret			;78ff	c9 	. 
l7900h:
	rst 10h			;7900	d7 	. 
	push hl			;7901	e5 	. 
	ld hl,(JIFFY)		;7902	2a 9e fc 	* . . 
	call l3236h		;7905	cd 36 32 	. 6 2 
	pop hl			;7908	e1 	. 
	ret			;7909	c9 	. 
l790ah:
	rst 10h			;790a	d7 	. 
	push hl			;790b	e5 	. 
	ld a,(CSRY)		;790c	3a dc f3 	: . . 
	jr l7932h		;790f	18 21 	. ! 
	rst 8			;7911	cf 	. 
	rst 28h			;7912	ef 	. 
	call sub_542fh		;7913	cd 2f 54 	. / T 
	ld (JIFFY),de		;7916	ed 53 9e fc 	. S . . 
	ret			;791a	c9 	. 
l791bh:
	rst 10h			;791b	d7 	. 
	ld a,003h		;791c	3e 03 	> . 
	call sub_7c08h		;791e	cd 08 7c 	. . | 
	push hl			;7921	e5 	. 
	ld a,(MUSICF)		;7922	3a 3f fb 	: ? . 
	dec e			;7925	1d 	. 
	jp m,l7938h		;7926	fa 38 79 	. 8 y 
l7929h:
	rrca			;7929	0f 	. 
	dec e			;792a	1d 	. 
	jp p,l7929h		;792b	f2 29 79 	. ) y 
	ld a,000h		;792e	3e 00 	> . 
	jr nc,l7933h		;7930	30 01 	0 . 
l7932h:
	dec a			;7932	3d 	= 
l7933h:
	call sub_2e9ah		;7933	cd 9a 2e 	. . . 
	pop hl			;7936	e1 	. 
	ret			;7937	c9 	. 
l7938h:
	and 007h		;7938	e6 07 	. . 
	jr z,l7933h		;793a	28 f7 	( . 
	ld a,0ffh		;793c	3e ff 	> . 
	jr l7933h		;793e	18 f3 	. . 
	call sub_521fh		;7940	cd 1f 52 	. . R 
	cp 003h		;7943	fe 03 	. . 
	jr nc,l7951h		;7945	30 0a 	0 . 
	call S.INITXT		;7947	cd d5 00 	. . . 
	jr l7966h		;794a	18 1a 	. . 
	call sub_521fh		;794c	cd 1f 52 	. . R 
	cp 005h		;794f	fe 05 	. . 
l7951h:
	jp nc,l475ah		;7951	d2 5a 47 	. Z G 
	call GTTRIG		;7954	cd d8 00 	. . . 
l7957h:
	jp sub_2e9ah		;7957	c3 9a 2e 	. . . 
	call sub_521fh		;795a	cd 1f 52 	. . R 
	dec a			;795d	3d 	= 
	cp 00ch		;795e	fe 0c 	. . 
	jr nc,l7951h		;7960	30 ef 	0 . 
	inc a			;7962	3c 	< 
	call GTPDL		;7963	cd de 00 	. . . 
l7966h:
	jp l4fcfh		;7966	c3 cf 4f 	. . O 
	call sub_521fh		;7969	cd 1f 52 	. . R 
	cp 014h		;796c	fe 14 	. . 
	jr nc,l7951h		;796e	30 e1 	0 . 
	push af			;7970	f5 	. 
	call GTPAD		;7971	cd db 00 	. . . 
	ld b,a			;7974	47 	G 
	pop af			;7975	f1 	. 
	call sub_7b3eh		;7976	cd 3e 7b 	. > { 
	cp 002h		;7979	fe 02 	. . 
	ld a,b			;797b	78 	x 
	jr c,l7966h		;797c	38 e8 	8 . 
	jr l7957h		;797e	18 d7 	. . 
	ld ix,S.COLOR		;7980	dd 21 55 01 	. ! U . 
	jp EXTROM		;7984	c3 5f 01 	. _ . 
sub_7987h:
	ld (NLONLY),a		;7987	32 7c f8 	2 | . 
	di			;798a	f3 	. 
	out (099h),a		;798b	d3 99 	. . 
	ld a,0aeh		;798d	3e ae 	> . 
	out (099h),a		;798f	d3 99 	. . 
	ei			;7991	fb 	. 
	ret			;7992	c9 	. 
l7993h:
	jp z,l7aafh		;7993	ca af 7a 	. . z 
	ld ix,S.GETPUT		;7996	dd 21 b1 01 	. ! . . 
	call EXTROM		;799a	cd 5f 01 	. _ . 
	ret nc			;799d	d0 	. 
	jp l7762h		;799e	c3 62 77 	. b w 
sub_79a1h:
	call l4257h		;79a1	cd 57 42 	. W B 
	inc hl			;79a4	23 	# 
	ld (VARTAB),hl		;79a5	22 c2 f6 	" . . 
	ret			;79a8	c9 	. 
CLSKANJI:
	ret nz			;79a9	c0 	. 
	ld a,(SCRMOD)		;79aa	3a af fc 	: . . 
	cp 002h		        ;79ad	fe 02 	. . 
	jr nc,l79beh		;79af	30 0d 	0 . 
	push hl			;79b1	e5 	. 
	xor a			;79b2	af 	. 
	ld de,l1100h		;79b3	11 00 11 	. . . 
	call EXTBIO		;79b6	cd ca ff 	. . . 
	pop hl			;79b9	e1 	. 
	and a			;79ba	a7 	. 
	jp nz,l475ah		;79bb	c2 5a 47 	. Z G 
l79beh:
	xor a			;79be	af 	. 
	jp CLS		        ;79bf	c3 c3 00 	. . . 
CALSLT2:
	ex af,af'		;79c2	08 	. 
	bit 7,d		        ;79c3	cb 7a 	. z 
	jp nz,SLOTHAND		;79c5	c2 d2 7b 	. . { 
	ex af,af'		;79c8	08 	. 
	jp CALSLT		;79c9	c3 1c 00 	. . . 
l79cc:
	call H.SCRE		;79cc	cd c0 ff 	. . . 
	ld ix,S.SCREEN		;79cf	dd 21 59 01 	. ! Y . 
	jp EXTROM		;79d3	c3 5f 01 	. _ . 
l79d6h:
	call CHKNEW		;79d6	cd 65 01 	. e . 
	jr c,l79e2h		;79d9	38 07 	8 . 
	ld ix,S.PSET		;79db	dd 21 6d 00 	. ! m . 
	jp EXTROM		;79df	c3 5f 01 	. _ . 
l79e2h:
	push af			;79e2	f5 	. 
	call sub_57abh		;79e3	cd ab 57 	. . W 
	jp l57f1h		;79e6	c3 f1 57 	. . W 
l79e9h:
	call CHKNEW		;79e9	cd 65 01 	. e . 
	jr c,l79f5h		;79ec	38 07 	8 . 
	ld ix,S.GLINE		;79ee	dd 21 75 00 	. ! u . 
	jp EXTROM		;79f2	c3 5f 01 	. _ . 
l79f5h:
	call sub_579ch		;79f5	cd 9c 57 	. . W 
	jp l58aah		;79f8	c3 aa 58 	. . X 
l79fbh:
	call CHKNEW		;79fb	cd 65 01 	. e . 
	jr c,l7a07h		;79fe	38 07 	8 . 
	ld ix,S.PAINT		;7a00	dd 21 69 00 	. ! i . 
	jp EXTROM		;7a04	c3 5f 01 	. _ . 
l7a07h:
	call sub_579ch		;7a07	cd 9c 57 	. . W 
	jp l59c8h		;7a0a	c3 c8 59 	. . Y 
l7a0dh:
	call CHKNEW		;7a0d	cd 65 01 	. e . 
	jr c,l7a19h		;7a10	38 07 	8 . 
	ld ix,S.DOGRPH		;7a12	dd 21 85 00 	. ! . . 
	jp EXTROM		;7a16	c3 5f 01 	. _ . 
l7a19h:
	call SCALXY		;7a19	cd 0e 01 	. . . 
	jp l5942h		;7a1c	c3 42 59 	. B Y 
l7a1fh:
	jp p,l64e5h		;7a1f	f2 e5 64 	. . d 
	dec hl			;7a22	2b 	+ 
	jp l64eah		;7a23	c3 ea 64 	. . d 
	call sub_521ch		;7a26	cd 1c 52 	. . R 
	ld (NTMSXP),a		;7a29	32 17 f4 	2 . . 
	ret			;7a2c	c9 	. 
sub_7a2dh:
	call sub_521ch		;7a2d	cd 1c 52 	. . R 
	dec a			;7a30	3d 	= 
	cp 002h		;7a31	fe 02 	. . 
	jp nc,l475ah		;7a33	d2 5a 47 	. Z G 
	push hl			;7a36	e5 	. 
	ld bc,05h		;7a37	01 05 00 	. . . 
	and a			;7a3a	a7 	. 
	ld hl,0f3fch		;7a3b	21 fc f3 	! . . 
	jr z,l7a41h		;7a3e	28 01 	( . 
	add hl,bc			;7a40	09 	. 
l7a41h:
	ld de,LOW.		;7a41	11 06 f4 	. . . 
	ldir		;7a44	ed b0 	. . 
	pop hl			;7a46	e1 	. 
	ret			;7a47	c9 	. 
l7a48h:
	cp 024h		;7a48	fe 24 	. $ 
	jp nz,l77abh		;7a4a	c2 ab 77 	. . w 
	ld a,(SCRMOD)		;7a4d	3a af fc 	: . . 
	and a			;7a50	a7 	. 
	jp z,l475ah		;7a51	ca 5a 47 	. Z G 
	call sub_7aa0h		;7a54	cd a0 7a 	. . z 
	push de			;7a57	d5 	. 
	call sub_4c5fh		;7a58	cd 5f 4c 	. _ L 
	ex (sp),hl			;7a5b	e3 	. 
	push hl			;7a5c	e5 	. 
	call sub_67d0h		;7a5d	cd d0 67 	. . g 
	inc hl			;7a60	23 	# 
	ld e,(hl)			;7a61	5e 	^ 
	inc hl			;7a62	23 	# 
	ld d,(hl)			;7a63	56 	V 
	call GSPSIZ		;7a64	cd 8a 00 	. . . 
	ld c,a			;7a67	4f 	O 
	ld b,000h		;7a68	06 00 	. . 
	dec hl			;7a6a	2b 	+ 
	dec hl			;7a6b	2b 	+ 
	dec a			;7a6c	3d 	= 
	cp (hl)			;7a6d	be 	. 
	ld a,(hl)			;7a6e	7e 	~ 
	jr c,l7a7dh		;7a6f	38 0c 	8 . 
	pop hl			;7a71	e1 	. 
	push hl			;7a72	e5 	. 
	push af			;7a73	f5 	. 
	xor a			;7a74	af 	. 
	call BIGFIL		;7a75	cd 6b 01 	. k . 
	pop af			;7a78	f1 	. 
	and a			;7a79	a7 	. 
	ld c,a			;7a7a	4f 	O 
	ld b,000h		;7a7b	06 00 	. . 
l7a7dh:
	ex de,hl			;7a7d	eb 	. 
	pop de			;7a7e	d1 	. 
	call nz,LDIRVM		;7a7f	c4 5c 00 	. \ . 
	pop hl			;7a82	e1 	. 
	ret			;7a83	c9 	. 
l7a84h:
	call sub_7a9fh		;7a84	cd 9f 7a 	. . z 
	push hl			;7a87	e5 	. 
	push de			;7a88	d5 	. 
	call GSPSIZ		;7a89	cd 8a 00 	. . . 
	ld c,a			;7a8c	4f 	O 
	ld b,000h		;7a8d	06 00 	. . 
	push bc			;7a8f	c5 	. 
	call sub_6627h		;7a90	cd 27 66 	. ' f 
	ld hl,(0f699h)		;7a93	2a 99 f6 	* . . 
	ex de,hl			;7a96	eb 	. 
	pop bc			;7a97	c1 	. 
	pop hl			;7a98	e1 	. 
	call LDIRMV		;7a99	cd 59 00 	. Y . 
	jp l6654h		;7a9c	c3 54 66 	. T f 
sub_7a9fh:
	rst 10h			;7a9f	d7 	. 
sub_7aa0h:
	rst 8			;7aa0	cf 	. 
	inc h			;7aa1	24 	$ 
	ld a,0ffh		;7aa2	3e ff 	> . 
	call sub_7c08h		;7aa4	cd 08 7c 	. . | 
	push hl			;7aa7	e5 	. 
	ld a,e			;7aa8	7b 	{ 
	call CALPAT		;7aa9	cd 84 00 	. . . 
	ex de,hl			;7aac	eb 	. 
	pop hl			;7aad	e1 	. 
	ret			;7aae	c9 	. 
l7aafh:
	dec b			;7aaf	05 	. 
	jp m,l475ah		;7ab0	fa 5a 47 	. Z G 
	jp l7cf4h		;7ab3	c3 f4 7c 	. . | 
l7ab6h:
	and a			;7ab6	a7 	. 
	jp z,l475ah		;7ab7	ca 5a 47 	. Z G 
	rst 10h			;7aba	d7 	. 
	call sub_521ch		;7abb	cd 1c 52 	. . R 
	cp 020h		;7abe	fe 20 	.   
	jp nc,l475ah		;7ac0	d2 5a 47 	. Z G 
	push hl			;7ac3	e5 	. 
	call CALATR		;7ac4	cd 87 00 	. . . 
	ex (sp),hl			;7ac7	e3 	. 
	rst 8			;7ac8	cf 	. 
	inc l			;7ac9	2c 	, 
	cp 02ch		;7aca	fe 2c 	. , 
	jr z,l7af9h		;7acc	28 2b 	( + 
	call sub_579ch		;7ace	cd 9c 57 	. . W 
	ex (sp),hl			;7ad1	e3 	. 
	ld a,e			;7ad2	7b 	{ 
	call WRTVRM		;7ad3	cd 4d 00 	. M . 
	ld a,b			;7ad6	78 	x 
	add a,a			;7ad7	87 	. 
	ld a,c			;7ad8	79 	y 
	ld b,000h		;7ad9	06 00 	. . 
	jr nc,l7ae1h		;7adb	30 04 	0 . 
	add a,020h		;7add	c6 20 	.   
	ld b,080h		;7adf	06 80 	. . 
l7ae1h:
	inc hl			;7ae1	23 	# 
	call WRTVRM		;7ae2	cd 4d 00 	. M . 
	inc hl			;7ae5	23 	# 
	inc hl			;7ae6	23 	# 
	call RDVRM		;7ae7	cd 4a 00 	. J . 
	and 00fh		;7aea	e6 0f 	. . 
	or b			;7aec	b0 	. 
	call WRTVRM		;7aed	cd 4d 00 	. M . 
	dec hl			;7af0	2b 	+ 
	dec hl			;7af1	2b 	+ 
	dec hl			;7af2	2b 	+ 
	ex (sp),hl			;7af3	e3 	. 
	dec hl			;7af4	2b 	+ 
	rst 10h			;7af5	d7 	. 
	pop bc			;7af6	c1 	. 
	ret z			;7af7	c8 	. 
	push bc			;7af8	c5 	. 
l7af9h:
	rst 8			;7af9	cf 	. 
	inc l			;7afa	2c 	, 
	cp 02ch		;7afb	fe 2c 	. , 
	jr z,l7b1dh		;7afd	28 1e 	( . 
	call sub_521ch		;7aff	cd 1c 52 	. . R 
	cp 010h		;7b02	fe 10 	. . 
	jp nc,l475ah		;7b04	d2 5a 47 	. Z G 
	ex (sp),hl			;7b07	e3 	. 
	inc hl			;7b08	23 	# 
	inc hl			;7b09	23 	# 
	inc hl			;7b0a	23 	# 
	call RDVRM		;7b0b	cd 4a 00 	. J . 
	and 080h		;7b0e	e6 80 	. . 
	or e			;7b10	b3 	. 
	call WRTVRM		;7b11	cd 4d 00 	. M . 
	dec hl			;7b14	2b 	+ 
	dec hl			;7b15	2b 	+ 
	dec hl			;7b16	2b 	+ 
	ex (sp),hl			;7b17	e3 	. 
	dec hl			;7b18	2b 	+ 
	rst 10h			;7b19	d7 	. 
	pop bc			;7b1a	c1 	. 
	ret z			;7b1b	c8 	. 
	push bc			;7b1c	c5 	. 
l7b1dh:
	rst 8			;7b1d	cf 	. 
	inc l			;7b1e	2c 	, 
	call sub_521ch		;7b1f	cd 1c 52 	. . R 
	call GSPSIZ		;7b22	cd 8a 00 	. . . 
	ld a,e			;7b25	7b 	{ 
	jr nc,l7b2fh		;7b26	30 07 	0 . 
	cp 040h		;7b28	fe 40 	. @ 
	jp nc,l475ah		;7b2a	d2 5a 47 	. Z G 
	add a,a			;7b2d	87 	. 
	add a,a			;7b2e	87 	. 
l7b2fh:
	ex (sp),hl			;7b2f	e3 	. 
	inc hl			;7b30	23 	# 
	inc hl			;7b31	23 	# 
	call WRTVRM		;7b32	cd 4d 00 	. M . 
	pop hl			;7b35	e1 	. 
	ret			;7b36	c9 	. 
	ld ix,S.VDP		;7b37	dd 21 61 01 	. ! a . 
	jp EXTROM		;7b3b	c3 5f 01 	. _ . 
sub_7b3eh:
	add a,004h		;7b3e	c6 04 	. . 
	and 0f3h		;7b40	e6 f3 	. . 
	dec a			;7b42	3d 	= 
	ret			;7b43	c9 	. 
	jp WRTVDP		;7b44	c3 47 00 	. G . 
l7b47h:
	ld ix,CHKNEW		;7b47	dd 21 65 01 	. ! e . 
	jp EXTROM		;7b4b	c3 5f 01 	. _ . 
l7b4eh:
	ld d,000h		;7b4e	16 00 	. . 
	ld hl,RG0SAV		;7b50	21 df f3 	! . . 
	add hl,de			;7b53	19 	. 
	ld a,(hl)			;7b54	7e 	~ 
	call l4fcfh		;7b55	cd cf 4f 	. . O 
	pop hl			;7b58	e1 	. 
	ret			;7b59	c9 	. 
	ld ix,S.BASE		;7b5a	dd 21 69 01 	. ! i . 
	jp EXTROM		;7b5e	c3 5f 01 	. _ . 
l7b61h:
	ld hl,0000h		;7b61	21 00 00 	! . . 
	add hl,sp			;7b64	39 	9 
	ld a,h			;7b65	7c 	| 
	out (0a8h),a		;7b66	d3 a8 	. . 
	ld a,l			;7b68	7d 	} 
	ld (0ffffh),a		;7b69	32 ff ff 	2 . . 
	ld a,c			;7b6c	79 	y 
	ld bc,00c77h		;7b6d	01 77 0c 	. w . 
	ld de,0f381h		;7b70	11 81 f3 	. . . 
	ld hl,RDPRIM		;7b73	21 80 f3 	! . . 
	ld (hl),000h		;7b76	36 00 	6 . 
	ldir		;7b78	ed b0 	. . 
	ld c,a			;7b7a	4f 	O 
	ld b,004h		;7b7b	06 04 	. . 
	ld hl,0fcc4h		;7b7d	21 c4 fc 	! . . 
l7b80h:
	rr c		;7b80	cb 19 	. . 
	sbc a,a			;7b82	9f 	. 
	and 080h		;7b83	e6 80 	. . 
	ld (hl),a			;7b85	77 	w 
	dec hl			;7b86	2b 	+ 
	djnz l7b80h		;7b87	10 f7 	. . 
	in a,(0a8h)		;7b89	db a8 	. . 
	ld c,a			;7b8b	4f 	O 
	xor a			;7b8c	af 	. 
	out (0a8h),a		;7b8d	d3 a8 	. . 
	ld a,(0ffffh)		;7b8f	3a ff ff 	: . . 
	cpl			;7b92	2f 	/ 
	ld l,a			;7b93	6f 	o 
	ld a,040h		;7b94	3e 40 	> @ 
	out (0a8h),a		;7b96	d3 a8 	. . 
	ld a,(0ffffh)		;7b98	3a ff ff 	: . . 
	cpl			;7b9b	2f 	/ 
	ld h,a			;7b9c	67 	g 
	ld a,080h		;7b9d	3e 80 	> . 
	out (0a8h),a		;7b9f	d3 a8 	. . 
	ld a,(0ffffh)		;7ba1	3a ff ff 	: . . 
	cpl			;7ba4	2f 	/ 
	ld e,a			;7ba5	5f 	_ 
	ld a,0c0h		;7ba6	3e c0 	> . 
	out (0a8h),a		;7ba8	d3 a8 	. . 
	ld a,(0ffffh)		;7baa	3a ff ff 	: . . 
	cpl			;7bad	2f 	/ 
	ld d,a			;7bae	57 	W 
	ld a,c			;7baf	79 	y 
	out (0a8h),a		;7bb0	d3 a8 	. . 
	ld (SLTTBL),hl		;7bb2	22 c5 fc 	" . . 
	ex de,hl			;7bb5	eb 	. 
	ld (0fcc7h),hl		;7bb6	22 c7 fc 	" . . 
	im 1		;7bb9	ed 56 	. V 
	jp l7c76h		;7bbb	c3 76 7c 	. v | 
PTCPAL2:
	ld hl,0a0f9h		;7bbe	21 f9 a0 	! . . 
PTCPA1:
	dec hl			;7bc1	2b 	+ 
	ld a,h			;7bc2	7c 	| 
	or l			;7bc3	b5 	. 
	jr nz,PTCPA1		;7bc4	20 fb 	  . 
	jp PTCPALRET		;7bc6	c3 31 04 	. 1 . 
	rst 38h			;7bc9	ff 	. 
	rlca			;7bca	07 	. 
l7bcbh:
	ld ix,S.BASEF		;7bcb	dd 21 6d 01 	. ! m . 
	jp EXTROM		;7bcf	c3 5f 01 	. _ . 
SLOTHAND:
	ex af,af'		;7bd2	08 	. 
	ld (0f65eh),sp		;7bd3	ed 73 5e f6 	. s ^ . 
	ld sp,0f65eh		;7bd7	31 5e f6 	1 ^ . 
	call CALSLT		;7bda	cd 1c 00 	. . . 
	ld sp,(0f65eh)		;7bdd	ed 7b 5e f6 	. { ^ . 
	ret			;7be1	c9 	. 
l7be2h:
	ld ix,S.VPOKE		;7be2	dd 21 71 01 	. ! q . 
	jr l7bf2h		;7be6	18 0a 	. . 
sub_7be8h:
	ld ix,S.PROMPT		;7be8	dd 21 81 01 	. ! . . 
	jr l7bf2h		;7bec	18 04 	. . 
sub_7beeh:
	ld ix,S.SETSCR		;7bee	dd 21 89 01 	. ! . . 
l7bf2h:
	jp EXTROM		;7bf2	c3 5f 01 	. _ . 
	ld ix,S.VPEEK		;7bf5	dd 21 75 01 	. ! u . 
	jp EXTROM		;7bf9	c3 5f 01 	. _ . 
	rst 8			;7bfc	cf 	. 
	ld c,a			;7bfd	4f 	O 
	call sub_2f8ah		;7bfe	cd 8a 2f 	. . / 
	ld de,04000h		;7c01	11 00 40 	. . @ 
	rst 20h			;7c04	e7 	. 
	ret c			;7c05	d8 	. 
	jr l7c73h		;7c06	18 6b 	. k 
sub_7c08h:
	push af			;7c08	f5 	. 
	rst 8			;7c09	cf 	. 
	jr z,$-49		;7c0a	28 cd 	( . 
	inc e			;7c0c	1c 	. 
	ld d,d			;7c0d	52 	R 
	pop af			;7c0e	f1 	. 
	cp e			;7c0f	bb 	. 
	jr c,l7c73h		;7c10	38 61 	8 a 
	rst 8			;7c12	cf 	. 
	add hl,hl			;7c13	29 	) 
	ld a,e			;7c14	7b 	{ 
	ret			;7c15	c9 	. 
	call H.DSKO		;7c16	cd ef fd 	. . . 
	jr l7c73h		;7c19	18 58 	. X 
	jp l7ce3h		;7c1b	c3 e3 7c 	. . | 
	jr l7c73h		;7c1e	18 53 	. S 
	call H.NAME		;7c20	cd f9 fd 	. . . 
	jr l7c73h		;7c23	18 4e 	. N 
	call H.KILL		;7c25	cd fe fd 	. . . 
	jr l7c73h		;7c28	18 49 	. I 
	call H.IPL		;7c2a	cd 03 fe 	. . . 
	jr l7c73h		;7c2d	18 44 	. D 
	jp l7d03h		;7c2f	c3 03 7d 	. . } 
	jr l7c73h		;7c32	18 3f 	. ? 
	call H.CMD		;7c34	cd 0d fe 	. . . 
	jr l7c73h		;7c37	18 3a 	. : 
	call H.DSKF		;7c39	cd 12 fe 	. . . 
	jr l7c73h		;7c3c	18 35 	. 5 
l7c3eh:
	call H.DSKI		;7c3e	cd 17 fe 	. . . 
	jr l7c73h		;7c41	18 30 	. 0 
l7c43h:
	call H.ATTR		;7c43	cd 1c fe 	. . . 
	jr l7c73h		;7c46	18 2b 	. + 
	call H.LSET		;7c48	cd 21 fe 	. ! . 
	jr l7c73h		;7c4b	18 26 	. & 
	call H.RSET		;7c4d	cd 26 fe 	. & . 
	jr l7c73h		;7c50	18 21 	. ! 
	call H.FIEL		;7c52	cd 2b fe 	. + . 
	jr l7c73h		;7c55	18 1c 	. . 
	call H.MKIS		;7c57	cd 30 fe 	. 0 . 
	jr l7c73h		;7c5a	18 17 	. . 
	call H.MKSS		;7c5c	cd 35 fe 	. 5 . 
	jr l7c73h		;7c5f	18 12 	. . 
	call H.MKDS		;7c61	cd 3a fe 	. : . 
	jr l7c73h		;7c64	18 0d 	. . 
	call H.CVI		;7c66	cd 3f fe 	. ? . 
	jr l7c73h		;7c69	18 08 	. . 
	call H.CVS		;7c6b	cd 44 fe 	. D . 
	jr l7c73h		;7c6e	18 03 	. . 
	call H.CVD		;7c70	cd 49 fe 	. I . 
l7c73h:
	jp l475ah		;7c73	c3 5a 47 	. Z G 
l7c76h:
	ld sp,0f376h		;7c76	31 76 f3 	1 v . 
	ld bc,0022fh		;7c79	01 2f 02 	. / . 
	ld de,0fd9bh		;7c7c	11 9b fd 	. . . 
	ld hl,H.KEYI		;7c7f	21 9a fd 	! . . 
	ld (hl),0c9h		;7c82	36 c9 	6 . 
	ldir		;7c84	ed b0 	. . 
	ld hl,RDPRIM		;7c86	21 80 f3 	! . . 
	ld (HIMEM),hl		;7c89	22 4a fc 	" J . 
	call sub_7d5dh		;7c8c	cd 5d 7d 	. ] } 
	ld (BOTTOM),hl		;7c8f	22 48 fc 	" H . 
	ld bc,GICINI		;7c92	01 90 00 	. . . 
	ld de,RDPRIM		;7c95	11 80 f3 	. . . 
	ld hl,BASVERSION_end		;7c98	21 27 7f 	! '  
	ldir		;7c9b	ed b0 	. . 
	call INIFNK		;7c9d	cd 3e 00 	. > . 
	xor a			;7ca0	af 	. 
	ld (ENDBUF),a		;7ca1	32 60 f6 	2 ` . 
	ld (NLONLY),a		;7ca4	32 7c f8 	2 | . 
	ld a,02ch		;7ca7	3e 2c 	> , 
	ld (BUFMIN),a		;7ca9	32 5d f5 	2 ] . 
	ld a,03ah		;7cac	3e 3a 	> : 
	ld (KBFMIN),a		;7cae	32 1e f4 	2 . . 
	ld hl,(CGTABL)		;7cb1	2a 04 00 	* . . 
	ld (0f920h),hl		;7cb4	22 20 f9 	"   . 
	ld hl,PRMSTK		;7cb7	21 e4 f6 	! . . 
	ld (PRMPRV),hl		;7cba	22 4c f7 	" L . 
	ld (STKTOP),hl		;7cbd	22 74 f6 	" t . 
	ld bc,POSIT+2		;7cc0	01 c8 00 	. . . 
	add hl,bc			;7cc3	09 	. 
	ld (MEMSIZ),hl		;7cc4	22 72 f6 	" r . 
	ld a,001h		;7cc7	3e 01 	> . 
	ld (0f6c3h),a		;7cc9	32 c3 f6 	2 . . 
	call sub_7e6bh		;7ccc	cd 6b 7e 	. k ~ 
	call l62e5h		;7ccf	cd e5 62 	. . b 
	ld hl,(BOTTOM)		;7cd2	2a 48 fc 	* H . 
	xor a			;7cd5	af 	. 
	ld (hl),a			;7cd6	77 	w 
	inc hl			;7cd7	23 	# 
	ld (TXTTAB),hl		;7cd8	22 76 f6 	" v . 
	call sub_6287h		;7cdb	cd 87 62 	. . b 
	call INITIO		;7cde	cd 3b 00 	. ; . 
	jr l7d14h		;7ce1	18 31 	. 1 
l7ce3h:
	call H.SETS		;7ce3	cd f4 fd 	. . . 
	ld ix,S.SETS		;7ce6	dd 21 79 01 	. ! y . 
	jp EXTROM		;7cea	c3 5f 01 	. _ . 
	ld ix,S.SDFSCR		;7ced	dd 21 85 01 	. ! . . 
	jp EXTROM		;7cf1	c3 5f 01 	. _ . 
l7cf4h:
	ld a,(SCRMOD)		;7cf4	3a af fc 	: . . 
	cp 004h		;7cf7	fe 04 	. . 
	jp c,l7ab6h		;7cf9	da b6 7a 	. . z 
	ld ix,S.PUTSPRT		;7cfc	dd 21 51 01 	. ! Q . 
	jp EXTROM		;7d00	c3 5f 01 	. _ . 
l7d03h:
	ld ix,S.SCOPY		;7d03	dd 21 8d 01 	. ! . . 
	call EXTROM		;7d07	cd 5f 01 	. _ . 
	ret nc			;7d0a	d0 	. 
	call H.COPY		;7d0b	cd 08 fe 	. . . 
	jp l475ah		;7d0e	c3 5a 47 	. Z G 
	nop			;7d11	00 	. 
	nop			;7d12	00 	. 
	nop			;7d13	00 	. 
l7d14h:
	call CHKSLZ		;7d14	cd 62 01 	. b . 
	ld hl,(BOTTOM)		;7d17	2a 48 fc 	* H . 
	xor a			;7d1a	af 	. 
	ld (hl),a			;7d1b	77 	w 
	inc hl			;7d1c	23 	# 
	ld (TXTTAB),hl		;7d1d	22 76 f6 	" v . 
	call sub_6287h		;7d20	cd 87 62 	. . b 
	call sub_7d29h		;7d23	cd 29 7d 	. ) } 
	jp l411fh		;7d26	c3 1f 41 	. . A 
sub_7d29h:
	jr l7d31h		;7d29	18 06 	. . 
	nop			;7d2b	00 	. 
	nop			;7d2c	00 	. 
	nop			;7d2d	00 	. 
	nop			;7d2e	00 	. 
	defb 0edh;next byte illegal after ed		;7d2f	ed 	. 
	ld a,h			;7d30	7c 	| 
l7d31h:
	call sub_7beeh		;7d31	cd ee 7b 	. . { 
	ld hl,SLTWRK		;7d34	21 09 fd 	! . . 
	ld a,(hl)			;7d37	7e 	~ 
	and 020h		;7d38	e6 20 	.   
	ld (hl),a			;7d3a	77 	w 
	nop			;7d3b	00 	. 
	nop			;7d3c	00 	. 
	ld hl,l7efdh		;7d3d	21 fd 7e 	! . ~ 
	call sub_6678h		;7d40	cd 78 66 	. x f 
	ld hl,(VARTAB)		;7d43	2a c2 f6 	* . . 
	ex de,hl			;7d46	eb 	. 
	ld hl,(STKTOP)		;7d47	2a 74 f6 	* t . 
	ld a,l			;7d4a	7d 	} 
	sub e			;7d4b	93 	. 
	ld l,a			;7d4c	6f 	o 
	ld a,h			;7d4d	7c 	| 
	sbc a,d			;7d4e	9a 	. 
	ld h,a			;7d4f	67 	g 
	ld bc,0fff2h		;7d50	01 f2 ff 	. . . 
	add hl,bc			;7d53	09 	. 
	call sub_3412h		;7d54	cd 12 34 	. . 4 
	ld hl,l7f1bh		;7d57	21 1b 7f 	! .  
	jp sub_6678h		;7d5a	c3 78 66 	. x f 
sub_7d5dh:
	ld hl,0ef00h		;7d5d	21 00 ef 	! . . 
l7d60h:
	ld a,(hl)			;7d60	7e 	~ 
	cpl			;7d61	2f 	/ 
	ld (hl),a			;7d62	77 	w 
	cp (hl)			;7d63	be 	. 
	cpl			;7d64	2f 	/ 
	ld (hl),a			;7d65	77 	w 
	jr nz,l7d71h		;7d66	20 09 	  . 
	inc l			;7d68	2c 	, 
	jr nz,l7d60h		;7d69	20 f5 	  . 
	ld a,h			;7d6b	7c 	| 
	dec a			;7d6c	3d 	= 
	ret p			;7d6d	f0 	. 
	ld h,a			;7d6e	67 	g 
	jr l7d60h		;7d6f	18 ef 	. . 
l7d71h:
	ld l,000h		;7d71	2e 00 	. . 
	inc h			;7d73	24 	$ 
	ret			;7d74	c9 	. 
l7d75h:
	di			;7d75	f3 	. 
	ld c,000h		;7d76	0e 00 	. . 
	ld de,EXPTBL		;7d78	11 c1 fc 	. . . 
	ld hl,SLTATR		;7d7b	21 c9 fc 	! . . 
l7d7eh:
	ld a,(de)			;7d7e	1a 	. 
	or c			;7d7f	b1 	. 
	ld c,a			;7d80	4f 	O 
	push de			;7d81	d5 	. 
l7d82h:
	inc hl			;7d82	23 	# 
	push hl			;7d83	e5 	. 
	ld hl,04000h		;7d84	21 00 40 	! . @ 
l7d87h:
	call sub_7e1ah		;7d87	cd 1a 7e 	. . ~ 
	push hl			;7d8a	e5 	. 
	ld hl,l4241h		;7d8b	21 41 42 	! A B 
	rst 20h			;7d8e	e7 	. 
	pop hl			;7d8f	e1 	. 
	ld b,000h		;7d90	06 00 	. . 
	jr nz,l7dbeh		;7d92	20 2a 	  * 
	call sub_7e1ah		;7d94	cd 1a 7e 	. . ~ 
	push hl			;7d97	e5 	. 
	push bc			;7d98	c5 	. 
	push de			;7d99	d5 	. 
	pop ix		;7d9a	dd e1 	. . 
	ld a,c			;7d9c	79 	y 
	push af			;7d9d	f5 	. 
	pop iy		;7d9e	fd e1 	. . 
	call nz,sub_7ff2h		;7da0	c4 f2 7f 	. .  
	pop bc			;7da3	c1 	. 
	pop hl			;7da4	e1 	. 
	call sub_7e1ah		;7da5	cd 1a 7e 	. . ~ 
	add a,0ffh		;7da8	c6 ff 	. . 
	rr b		;7daa	cb 18 	. . 
	call sub_7e1ah		;7dac	cd 1a 7e 	. . ~ 
	add a,0ffh		;7daf	c6 ff 	. . 
	rr b		;7db1	cb 18 	. . 
	call sub_7e1ah		;7db3	cd 1a 7e 	. . ~ 
	add a,0ffh		;7db6	c6 ff 	. . 
	rr b		;7db8	cb 18 	. . 
	ld de,0fff8h		;7dba	11 f8 ff 	. . . 
	add hl,de			;7dbd	19 	. 
l7dbeh:
	ex (sp),hl			;7dbe	e3 	. 
	ld (hl),b			;7dbf	70 	p 
	inc hl			;7dc0	23 	# 
	ex (sp),hl			;7dc1	e3 	. 
	ld de,l3ffeh		;7dc2	11 fe 3f 	. . ? 
	add hl,de			;7dc5	19 	. 
	ld a,h			;7dc6	7c 	| 
	cp 0c0h		;7dc7	fe c0 	. . 
	jr c,l7d87h		;7dc9	38 bc 	8 . 
	pop hl			;7dcb	e1 	. 
	inc hl			;7dcc	23 	# 
	ld a,c			;7dcd	79 	y 
	and a			;7dce	a7 	. 
	ld de,RDSLT		;7dcf	11 0c 00 	. . . 
	jp p,07de0h		;7dd2	f2 e0 7d 	. . } 
	add a,004h		;7dd5	c6 04 	. . 
	ld c,a			;7dd7	4f 	O 
	cp 090h		;7dd8	fe 90 	. . 
	jr c,l7d82h		;7dda	38 a6 	8 . 
	and 003h		;7ddc	e6 03 	. . 
	ld c,a			;7dde	4f 	O 
	ld a,019h		;7ddf	3e 19 	> . 
	pop de			;7de1	d1 	. 
	inc de			;7de2	13 	. 
	inc c			;7de3	0c 	. 
	ld a,c			;7de4	79 	y 
	cp 004h		;7de5	fe 04 	. . 
	jr c,l7d7eh		;7de7	38 95 	8 . 
	ld hl,SLTATR		;7de9	21 c9 fc 	! . . 
	ld b,040h		;7dec	06 40 	. @ 
l7deeh:
	ld a,(hl)			;7dee	7e 	~ 
	add a,a			;7def	87 	. 
	jr c,l7df6h		;7df0	38 04 	8 . 
	inc hl			;7df2	23 	# 
	djnz l7deeh		;7df3	10 f9 	. . 
	ret			;7df5	c9 	. 
l7df6h:
	call sub_7e2ah		;7df6	cd 2a 7e 	. * ~ 
	call ENASLT		;7df9	cd 24 00 	. $ . 
	ld hl,(VARTAB)		;7dfc	2a c2 f6 	* . . 
	ld de,0c000h		;7dff	11 00 c0 	. . . 
	rst 20h			;7e02	e7 	. 
	jr nc,l7e09h		;7e03	30 04 	0 . 
	ex de,hl			;7e05	eb 	. 
	ld (VARTAB),hl		;7e06	22 c2 f6 	" . . 
l7e09h:
	ld hl,(08008h)		;7e09	2a 08 80 	* . . 
	inc hl			;7e0c	23 	# 
	ld (TXTTAB),hl		;7e0d	22 76 f6 	" v . 
	ld a,h			;7e10	7c 	| 
	ld (BASROM),a		;7e11	32 b1 fb 	2 . . 
	call sub_629ah		;7e14	cd 9a 62 	. . b 
	jp l4601h		;7e17	c3 01 46 	. . F 
sub_7e1ah:
	call sub_7e1eh		;7e1a	cd 1e 7e 	. . ~ 
	ld e,d			;7e1d	5a 	Z 
sub_7e1eh:
	ld a,c			;7e1e	79 	y 
	push bc			;7e1f	c5 	. 
	push de			;7e20	d5 	. 
	call RDSLT		;7e21	cd 0c 00 	. . . 
	pop de			;7e24	d1 	. 
	pop bc			;7e25	c1 	. 
	ld d,a			;7e26	57 	W 
	or e			;7e27	b3 	. 
	inc hl			;7e28	23 	# 
	ret			;7e29	c9 	. 
sub_7e2ah:
	ld a,040h		;7e2a	3e 40 	> @ 
	sub b			;7e2c	90 	. 
sub_7e2dh:
	ld b,a			;7e2d	47 	G 
	ld h,000h		;7e2e	26 00 	& . 
	rra			;7e30	1f 	. 
	rr h		;7e31	cb 1c 	. . 
	rra			;7e33	1f 	. 
	rr h		;7e34	cb 1c 	. . 
	rra			;7e36	1f 	. 
	rra			;7e37	1f 	. 
	and 003h		;7e38	e6 03 	. . 
	ld c,a			;7e3a	4f 	O 
	ld a,b			;7e3b	78 	x 
	ld b,000h		;7e3c	06 00 	. . 
	push hl			;7e3e	e5 	. 
	ld hl,EXPTBL		;7e3f	21 c1 fc 	! . . 
	add hl,bc			;7e42	09 	. 
	and 00ch		;7e43	e6 0c 	. . 
	or c			;7e45	b1 	. 
	ld c,a			;7e46	4f 	O 
	ld a,(hl)			;7e47	7e 	~ 
	pop hl			;7e48	e1 	. 
	or c			;7e49	b1 	. 
	ret			;7e4a	c9 	. 
	rst 8			;7e4b	cf 	. 
	or a			;7e4c	b7 	. 
	rst 8			;7e4d	cf 	. 
	rst 28h			;7e4e	ef 	. 
	call sub_521ch		;7e4f	cd 1c 52 	. . R 
	jp nz,l4055h		;7e52	c2 55 40 	. U @ 
	cp 010h		;7e55	fe 10 	. . 
	jp nc,l475ah		;7e57	d2 5a 47 	. Z G 
	ld (TEMP),hl		;7e5a	22 a7 f6 	" . . 
	push af			;7e5d	f5 	. 
	call sub_6c1ch		;7e5e	cd 1c 6c 	. . l 
	pop af			;7e61	f1 	. 
	call sub_7e6bh		;7e62	cd 6b 7e 	. k ~ 
	call sub_62a7h		;7e65	cd a7 62 	. . b 
	jp l4601h		;7e68	c3 01 46 	. . F 
sub_7e6bh:
	push af			;7e6b	f5 	. 
	ld hl,(HIMEM)		;7e6c	2a 4a fc 	* J . 
	ld de,0fef5h		;7e6f	11 f5 fe 	. . . 
l7e72h:
	add hl,de			;7e72	19 	. 
	dec a			;7e73	3d 	= 
	jp p,l7e72h		;7e74	f2 72 7e 	. r ~ 
	ex de,hl			;7e77	eb 	. 
	ld hl,(STKTOP)		;7e78	2a 74 f6 	* t . 
	ld b,h			;7e7b	44 	D 
	ld c,l			;7e7c	4d 	M 
	ld hl,(MEMSIZ)		;7e7d	2a 72 f6 	* r . 
	ld a,l			;7e80	7d 	} 
	sub c			;7e81	91 	. 
	ld l,a			;7e82	6f 	o 
	ld a,h			;7e83	7c 	| 
	sbc a,b			;7e84	98 	. 
	ld h,a			;7e85	67 	g 
	pop af			;7e86	f1 	. 
	push hl			;7e87	e5 	. 
	push af			;7e88	f5 	. 
	ld bc,GSPSIZ+2		;7e89	01 8c 00 	. . . 
	add hl,bc			;7e8c	09 	. 
	ld b,h			;7e8d	44 	D 
	ld c,l			;7e8e	4d 	M 
	ld hl,(VARTAB)		;7e8f	2a c2 f6 	* . . 
	add hl,bc			;7e92	09 	. 
	rst 20h			;7e93	e7 	. 
	jp nc,l6275h		;7e94	d2 75 62 	. u b 
	pop af			;7e97	f1 	. 
	ld (MAXFIL),a		;7e98	32 5f f8 	2 _ . 
	ld l,e			;7e9b	6b 	k 
	ld h,d			;7e9c	62 	b 
	ld (FILTAB),hl		;7e9d	22 60 f8 	" ` . 
	dec hl			;7ea0	2b 	+ 
	dec hl			;7ea1	2b 	+ 
	ld (MEMSIZ),hl		;7ea2	22 72 f6 	" r . 
	pop bc			;7ea5	c1 	. 
	ld a,l			;7ea6	7d 	} 
	sub c			;7ea7	91 	. 
	ld l,a			;7ea8	6f 	o 
	ld a,h			;7ea9	7c 	| 
	sbc a,b			;7eaa	98 	. 
	ld h,a			;7eab	67 	g 
	ld (STKTOP),hl		;7eac	22 74 f6 	" t . 
	dec hl			;7eaf	2b 	+ 
	dec hl			;7eb0	2b 	+ 
	pop bc			;7eb1	c1 	. 
	ld sp,hl			;7eb2	f9 	. 
	push bc			;7eb3	c5 	. 
	ld a,(MAXFIL)		;7eb4	3a 5f f8 	: _ . 
	ld l,a			;7eb7	6f 	o 
	inc l			;7eb8	2c 	, 
	ld h,000h		;7eb9	26 00 	& . 
	add hl,hl			;7ebb	29 	) 
	add hl,de			;7ebc	19 	. 
	ex de,hl			;7ebd	eb 	. 
	push de			;7ebe	d5 	. 
	ld bc,DOWNC+1		;7ebf	01 09 01 	. . . 
l7ec2h:
	ld (hl),e			;7ec2	73 	s 
	inc hl			;7ec3	23 	# 
	ld (hl),d			;7ec4	72 	r 
	inc hl			;7ec5	23 	# 
	ex de,hl			;7ec6	eb 	. 
	ld (hl),000h		;7ec7	36 00 	6 . 
	add hl,bc			;7ec9	09 	. 
	ex de,hl			;7eca	eb 	. 
	dec a			;7ecb	3d 	= 
	jp p,l7ec2h		;7ecc	f2 c2 7e 	. . ~ 
	pop hl			;7ecf	e1 	. 
	ld bc,0009h		;7ed0	01 09 00 	. . . 
	add hl,bc			;7ed3	09 	. 
	ld (NULBUF),hl		;7ed4	22 62 f8 	" b . 
	ret			;7ed7	c9 	. 

; BLOCK 'BASVERSION' (start 0x7ed8 end 0x7f27)
BASVERSION_start:
	defb 04dh		;7ed8	4d 	M 
	defb 053h		;7ed9	53 	S 
	defb 058h		;7eda	58 	X 
	defb 020h		;7edb	20 	  
	defb 020h		;7edc	20 	  
	defb 073h		;7edd	73 	s 
	defb 079h		;7ede	79 	y 
	defb 073h		;7edf	73 	s 
	defb 074h		;7ee0	74 	t 
	defb 065h		;7ee1	65 	e 
	defb 06dh		;7ee2	6d 	m 
	defb 000h		;7ee3	00 	. 
	defb 076h		;7ee4	76 	v 
	defb 065h		;7ee5	65 	e 
	defb 072h		;7ee6	72 	r 
	defb 073h		;7ee7	73 	s 
	defb 069h		;7ee8	69 	i 
	defb 06fh		;7ee9	6f 	o 
	defb 06eh		;7eea	6e 	n 
	defb 020h		;7eeb	20 	  
    IF VERSION == 3
	defb 033h		;7eec	33 	3 
	defb 02eh		;7eed	2e 	. 
	defb 030h		;7eee	30 	0 
    ELSE
	defb 033h		;7eec	32 	2 
	defb 02eh		;7eed	2e 	. 
	defb 030h		;7eee	31 	1 
    ENDIF
	defb 00dh		;7eef	0d 	. 
	defb 00ah		;7ef0	0a 	. 
	defb 000h		;7ef1	00 	. 
	defb 04dh		;7ef2	4d 	M 
	defb 053h		;7ef3	53 	S 
	defb 058h		;7ef4	58 	X 
	defb 020h		;7ef5	20 	  
	defb 042h		;7ef6	42 	B 
	defb 041h		;7ef7	41 	A 
	defb 053h		;7ef8	53 	S 
	defb 049h		;7ef9	49 	I 
	defb 043h		;7efa	43 	C 
	defb 020h		;7efb	20 	  
	defb 000h		;7efc	00 	. 
l7efdh:
	defb 043h		;7efd	43 	C 
	defb 06fh		;7efe	6f 	o 
	defb 070h		;7eff	70 	p 
	defb 079h		;7f00	79 	y 
	defb 072h		;7f01	72 	r 
	defb 069h		;7f02	69 	i 
	defb 067h		;7f03	67 	g 
	defb 068h		;7f04	68 	h 
	defb 074h		;7f05	74 	t 
	defb 020h		;7f06	20 	  
	defb 031h		;7f07	31 	1 
	defb 039h		;7f08	39 	9 
	defb 038h		;7f09	38 	8 
    IF VERSION == 3
	defb 038h		;7f0a	38 	8 
    ELSE
	defb 038h		;7f0a	36 	6 
    ENDIF
	defb 020h		;7f0b	20 	  
	defb 062h		;7f0c	62 	b 
	defb 079h		;7f0d	79 	y 
	defb 020h		;7f0e	20 	  
	defb 04dh		;7f0f	4d 	M 
	defb 069h		;7f10	69 	i 
	defb 063h		;7f11	63 	c 
	defb 072h		;7f12	72 	r 
	defb 06fh		;7f13	6f 	o 
	defb 073h		;7f14	73 	s 
	defb 06fh		;7f15	6f 	o 
	defb 066h		;7f16	66 	f 
	defb 074h		;7f17	74 	t 
	defb 00dh		;7f18	0d 	. 
	defb 00ah		;7f19	0a 	. 
	defb 000h		;7f1a	00 	. 
l7f1bh:
	defb 020h		;7f1b	20 	  
	defb 042h		;7f1c	42 	B 
	defb 079h		;7f1d	79 	y 
	defb 074h		;7f1e	74 	t 
	defb 065h		;7f1f	65 	e 
	defb 073h		;7f20	73 	s 
	defb 020h		;7f21	20 	  
	defb 066h		;7f22	66 	f 
	defb 072h		;7f23	72 	r 
	defb 065h		;7f24	65 	e 
	defb 065h		;7f25	65 	e 
	defb 000h		;7f26	00 	. 
BASVERSION_end:
	out (0a8h),a		;7f27	d3 a8 	. . 
	ld e,(hl)			;7f29	5e 	^ 
	jr l7f2fh		;7f2a	18 03 	. . 
	out (0a8h),a		;7f2c	d3 a8 	. . 
	ld (hl),e			;7f2e	73 	s 
l7f2fh:
	ld a,d			;7f2f	7a 	z 
	out (0a8h),a		;7f30	d3 a8 	. . 
	ret			;7f32	c9 	. 
	out (0a8h),a		;7f33	d3 a8 	. . 
	ex af,af'			;7f35	08 	. 
	call CLPRM1		;7f36	cd 98 f3 	. . . 
	ex af,af'			;7f39	08 	. 
	pop af			;7f3a	f1 	. 
	out (0a8h),a		;7f3b	d3 a8 	. . 
	ex af,af'			;7f3d	08 	. 
	ret			;7f3e	c9 	. 
	jp (ix)		;7f3f	dd e9 	. . 

; BLOCK 'BASVARS' (start 0x7f41 end 0x7fb7)
BASVARS_start:
	defb 05ah		;7f41	5a 	Z 
	defb 047h		;7f42	47 	G 
	defb 05ah		;7f43	5a 	Z 
	defb 047h		;7f44	47 	G 
	defb 05ah		;7f45	5a 	Z 
	defb 047h		;7f46	47 	G 
	defb 05ah		;7f47	5a 	Z 
	defb 047h		;7f48	47 	G 
	defb 05ah		;7f49	5a 	Z 
	defb 047h		;7f4a	47 	G 
	defb 05ah		;7f4b	5a 	Z 
	defb 047h		;7f4c	47 	G 
	defb 05ah		;7f4d	5a 	Z 
	defb 047h		;7f4e	47 	G 
	defb 05ah		;7f4f	5a 	Z 
	defb 047h		;7f50	47 	G 
	defb 05ah		;7f51	5a 	Z 
	defb 047h		;7f52	47 	G 
	defb 05ah		;7f53	5a 	Z 
	defb 047h		;7f54	47 	G 
LINL40:
    IF JAPANESE == 1
	defb 027h		;7f55	27 	' 
    ELSE
	defb 025h		;7f55	25 	% 
    ENDIF
LINL32:
	defb 01dh		;7f56	1d 	. 
    IF JAPANESE == 1
	defb 01dh		;7f57	1d 	. 
    ELSE
	defb 01dh		;7f57	25 	% 
    ENDIF
	defb 018h		;7f58	18 	. 
	defb 00eh		;7f59	0e 	. 
	defb 000h		;7f5a	00 	. 
	defb 000h		;7f5b	00 	. 
	defb 000h		;7f5c	00 	. 
	defb 000h		;7f5d	00 	. 
	defb 000h		;7f5e	00 	. 
	defb 008h		;7f5f	08 	. 
	defb 000h		;7f60	00 	. 
	defb 000h		;7f61	00 	. 
	defb 000h		;7f62	00 	. 
	defb 000h		;7f63	00 	. 
	defb 000h		;7f64	00 	. 
	defb 018h		;7f65	18 	. 
	defb 000h		;7f66	00 	. 
	defb 020h		;7f67	20 	  
	defb 000h		;7f68	00 	. 
	defb 000h		;7f69	00 	. 
	defb 000h		;7f6a	00 	. 
	defb 01bh		;7f6b	1b 	. 
	defb 000h		;7f6c	00 	. 
	defb 038h		;7f6d	38 	8 
	defb 000h		;7f6e	00 	. 
	defb 018h		;7f6f	18 	. 
	defb 000h		;7f70	00 	. 
	defb 020h		;7f71	20 	  
	defb 000h		;7f72	00 	. 
	defb 000h		;7f73	00 	. 
	defb 000h		;7f74	00 	. 
	defb 01bh		;7f75	1b 	. 
	defb 000h		;7f76	00 	. 
	defb 038h		;7f77	38 	8 
	defb 000h		;7f78	00 	. 
	defb 008h		;7f79	08 	. 
	defb 000h		;7f7a	00 	. 
	defb 000h		;7f7b	00 	. 
	defb 000h		;7f7c	00 	. 
	defb 000h		;7f7d	00 	. 
	defb 000h		;7f7e	00 	. 
	defb 01bh		;7f7f	1b 	. 
	defb 000h		;7f80	00 	. 
	defb 038h		;7f81	38 	8 
	defb 001h		;7f82	01 	. 
	defb 001h		;7f83	01 	. 
	defb 001h		;7f84	01 	. 
	defb 000h		;7f85	00 	. 
	defb 000h		;7f86	00 	. 
	defb 0e0h		;7f87	e0 	. 
	defb 000h		;7f88	00 	. 
	defb 000h		;7f89	00 	. 
	defb 000h		;7f8a	00 	. 
	defb 000h		;7f8b	00 	. 
	defb 000h		;7f8c	00 	. 
	defb 000h		;7f8d	00 	. 
	defb 000h		;7f8e	00 	. 
	defb 0ffh		;7f8f	ff 	. 
	defb 00fh		;7f90	0f 	. 
	defb 004h		;7f91	04 	. 
    IF JAPANESE == 1
	defb 007h		;7f92	07 	. 
    ELSE
	defb 004h		;7f92	04 	. 
    ENDIF
	defb 0c3h		;7f93	c3 	. 
	defb 000h		;7f94	00 	. 
	defb 000h		;7f95	00 	. 
	defb 0c3h		;7f96	c3 	. 
	defb 000h		;7f97	00 	. 
	defb 000h		;7f98	00 	. 
	defb 00fh		;7f99	0f 	. 
	defb 059h		;7f9a	59 	Y 
	defb 0f9h		;7f9b	f9 	. 
	defb 0ffh		;7f9c	ff 	. 
	defb 001h		;7f9d	01 	. 
	defb 032h		;7f9e	32 	2 
	defb 0f0h		;7f9f	f0 	. 
	defb 0fbh		;7fa0	fb 	. 
	defb 0f0h		;7fa1	f0 	. 
	defb 0fbh		;7fa2	fb 	. 
	defb 053h		;7fa3	53 	S 
	defb 05ch		;7fa4	5c 	\ 
	defb 026h		;7fa5	26 	& 
	defb 02dh		;7fa6	2d 	- 
	defb 00fh		;7fa7	0f 	. 
	defb 025h		;7fa8	25 	% 
	defb 02dh		;7fa9	2d 	- 
	defb 00eh		;7faa	0e 	. 
	defb 016h		;7fab	16 	. 
	defb 01fh		;7fac	1f 	. 
	defb 053h		;7fad	53 	S 
	defb 05ch		;7fae	5c 	\ 
	defb 026h		;7faf	26 	& 
	defb 02dh		;7fb0	2d 	- 
	defb 00fh		;7fb1	0f 	. 
	defb 000h		;7fb2	00 	. 
	defb 001h		;7fb3	01 	. 
	defb 000h		;7fb4	00 	. 
	defb 001h		;7fb5	01 	. 
	defb 03ah		;7fb6	3a 	: 
CHKEMPTYDEVNAME:
	ld de,PROCNM		;7fb7	11 89 fd 	. . . 
	and a			;7fba	a7 	. 
	ret nz			;7fbb	c0 	. 
	inc b			;7fbc	04 	. 
	ret			;7fbd	c9 	. 
sub_7fbeh:
	call sub_7fd1h		;7fbe	cd d1 7f 	. .  
	ld e,(hl)			;7fc1	5e 	^ 
	jr l7fc8h		;7fc2	18 04 	. . 
sub_7fc4h:
	call sub_7fd1h		;7fc4	cd d1 7f 	. .  
	ld (hl),e			;7fc7	73 	s 
l7fc8h:
	in a,(0a8h)		;7fc8	db a8 	. . 
	and 03fh		;7fca	e6 3f 	. ? 
	out (0a8h),a		;7fcc	d3 a8 	. . 
	ld a,c			;7fce	79 	y 
	jr l7fe6h		;7fcf	18 15 	. . 
sub_7fd1h:
	rrca			;7fd1	0f 	. 
	rrca			;7fd2	0f 	. 
	and 003h		;7fd3	e6 03 	. . 
	ld d,a			;7fd5	57 	W 
	in a,(0a8h)		;7fd6	db a8 	. . 
	ld b,a			;7fd8	47 	G 
	and 03fh		;7fd9	e6 3f 	. ? 
	out (0a8h),a		;7fdb	d3 a8 	. . 
	ld a,(0ffffh)		;7fdd	3a ff ff 	: . . 
	cpl			;7fe0	2f 	/ 
	ld c,a			;7fe1	4f 	O 
	and 0fch		;7fe2	e6 fc 	. . 
	or d			;7fe4	b2 	. 
	ld d,a			;7fe5	57 	W 
l7fe6h:
	ld (0ffffh),a		;7fe6	32 ff ff 	2 . . 
	ld a,b			;7fe9	78 	x 
	out (0a8h),a		;7fea	d3 a8 	. . 
	ld a,e			;7fec	7b 	{ 
	ret			;7fed	c9 	. 
	nop			;7fee	00 	. 
	nop			;7fef	00 	. 
	nop			;7ff0	00 	. 
	nop			;7ff1	00 	. 
sub_7ff2h:
	in a,(099h)		;7ff2	db 99 	. . 
	rlca			;7ff4	07 	. 
	jr nc,sub_7ff2h		;7ff5	30 fb 	0 . 
	jp CALSLT		;7ff7	c3 1c 00 	. . . 
	jp EXTBIO		;7ffa	c3 ca ff 	. . . 
	jp JF37D		;7ffd	c3 7d f3 	. } . 
