
INCLUDE	equs.h
INCLUDE	mode.inc

DATAS1	segment	public
;**********************************************
prakt_name	db	40 dup(" "),0
prakt_code	db	15 dup(" "),0
cprgt0		db	"     V99    "
cprgt1		db	"€‰’„ˆ "
mload		db	"”’—‹€ ‘“‘’†‹€’‘",0
mascii		db	"”’—‹€ APXEIOY ASCII",0
mload_v95	db	"”’—‹€ ‘“‘’. V95",0
mypmnimi	db	"Y€•„ˆ ‘“‘’†‹€ ‘’† ‹Œ†‹†",0
mnaapou		db	"?? NA TO A‡†‰„“‘— ??",0
myparx1		db	"“€•„ˆ ‘“‘’†‹€ ‹„ ’ ˆƒˆ Œ‹€",0
myparx2		db	"NA ’ ‘†‘—?",0
mmetatr1 	db	"META’† ‘’†Š—Œ ‘„ “‘",0
mmetatr2 	db	"ˆ ˆ ’“ ‘“‘’. ‡€ •€‡“Œ",0
mdokim1		db	"‹„’†‹€ € ‹Œ†‹†",0
mdokim2		db	"??  ƒ‰ˆ‹†  ‹„’†‘†‘  ??",0
mmnimi1		db	"ƒˆ€‰’†‘ ‹Œ†‹†‘",0
mmnimi2		db	"??  „ˆŠ‚† ‹Œ†‹†‘  ??",0
mmnimi3		db	"??  €‰“—‘† ‹Œ†‹†‘  ??",0
msbise		db	"‘†‘ˆ‹ ‹€ƒ€‘",0
mantiksim	db	"AŠŠ€‚† ‘†‹„ˆ“",0
mallage		db	"AŠŠ€‚† ‹€ƒ€‘",0
maloria		db	"€ŠŠ€‚† ˆ—Œ",0
mantigr		db	"AN’ˆ‚€”† ‹€ƒ€‘",0
mejodos		db	"TEŠ‘ „‚€‘ˆ€‘",0
msigor		db	"??  „ˆ‘€‘’„ ‘ˆ‚“‘  ??",0
mpatapl		db	"€’†‘’„ „Œ€ Š†‰’",0
mypolog		db	"YŠ‚ˆ…—...",0
mdelsys		db	"‘†‘ˆ‹ ‘“‘’†‹€’‘",0
mdelm		db	"‡A ‘†‘— ’ €•„ˆ ",12 dup(0)
mtelos		db	"TEŠO‘....˜«ã©«œ 'T'",0
mhnplhr 	db      "   ###    ŠHH                           OMAƒA    Oˆ     # “•„—’ˆ‰ˆ #",0
omada   	db      "  OMAƒA    OPOI     AO     E—‘           OMAƒA    OPOI     AO     E—‘    ",0
omadb   	db      "  OMAƒA   OMAƒE‘    AO     E—‘   ",0
omadea  	db      "‘“ŒŠ —Œ:                       O M A ƒ „ ‘",0
omadeb  	db      "                               “  „   ‹ € ƒ „ ‘",0
dialekt1	db	"ƒˆ€Š‚† APXEIOY ",0
dialekt2	db	"13 : ",0
dialekt3	db	"12 : ",0
dialekt4	db	"11 : ",0
sup13ekt1	db	"‘HMEIO A‚—NA 14 : ",0
sup13ekt2	db	" ANA ",0
issuper13	db	" -> SUPER13API !!!",0

super_xarti	db	0
dial_xarti	db	0
metr_tmp	db	0

simea_ekt_oron	db	0
simetoxes	dw	1
ektor_onoma	db	"€•„ˆ: ",0
ektor_simet	db	"‘“‹‹„’•†: ",0
ektor_drx	db	"„“— : ",0
ektor_stlplr	db	"‘’†Š„‘ Š†“‘: ",0
ektor_dektes	db	"ƒ„‰’„‘: ",0
ektor_kostos	db	"‰‘’‘: ",0

cprstr		db	"‚€‹‹€ €Œ€’“†‘ ‘“‘’†‹€’—Œ  V99",0
plirstr		db	"** Š†† : ",0
ypoxrstr	db	"** Y•„—’ˆ‰ˆ ˆ : ",0
protstr		db	"**  ƒ†Š—Œ— & „Š„‚•—   **",0
omadesstr	db	"**    O M A ƒ „ ‘    **",0
yperomstr	db	"** “  „   ‹ € ƒ „ ‘ **",0
omadstr		db	" OMAƒ€ ",0
oroistr		db	" Oˆ ",0
apostr		db	" € ",0
eosstr		db	" „—‘ ",0
omad1str	db	" OMAƒ„‘ ",0
metabstr	db	"** METABŠHTO : ",0
emfanejo	db	".",0

diagonismos	dw	0
metraAscii	db	0
FileMetraAscii	db	25 dup(" "),0
def_disk_file	db	"DISK",0
;******************************************************
prnfile		db	"C:V90.PRN",0
inffile		db	"C:V90.INI",0
klidifile	db	"C:V90.INF",0
;******************************************************
stat_disk	db	"C:"
stat_arxeio	db	8 dup(" "),0,0,0,0,0,0
pioi_oroi 	db	24 dup(0)
;******************************************************
aples_file	db	"C:APLESPLR.TMP",0	;arxeio aplvn stl sta plirakia
filetemp	db	"C:AUTOSAVE.V97",0
aples_handle	dw	0
asciidisk	db	"C:\ascii\"
asciiname	db	15 dup(" "),0
filedisk 	db	"C:"
filename 	db	15 dup(" "),0
disk		db	"C:*.V97",0
disk_v95	db	"C:*.V95",0
disk_asc	db	"C:\ascii\*.TLK",0
filedisk_v95	db	"C:"
filename_v95	db	15 dup(" "),0
strbuf		db	100 dup(0)
v97dir		db	"C:\V90",0
protapo		dw	0,0
protevs		dw	0,0
protop		db	15 dup(0)
protodrx 	dw	0,0
pejeproto 	db	0
coundq		dw	0,0
pokeplr 	dw	0

antistixia 	db      1,2,3,4,5,6,7,8,9,10,11,12,13

tipos_orou 	db	"W",0

antist		db	" 1X2 "		;	apokodikopiisi stilvn

antistplr	db	"1  ",0		;2	apokodikopiisi plirakia
		db	"X  ",0		;3
		db	"2  ",0		;4
		db	"1X ",0		;5
		db	"12 ",0		;6
		db	"X2 ",0		;7
		db      "   ",0		;8
		db	"1X2",0		;9

mhnhm		db	"A",0
		db	"„—‘",0
		db	"Œ/",0
		db	"‹€ƒ€",0

leonid		db	"O   OMAƒ„‘    "
		db	"P„Œ€ŠŠ€‚„‘    "
		db	"Q‘“‹‹„’ˆ‰€   "
		db	"R   ‚„Œ€€‚  "
		db	"S€‡ˆ‘‹€     "
		db	"U   OM ƒˆŠ—Œ "
		db	"\OMAƒE‘1X2    "
		db	"1AŒ„‘1X2    "
		db	"2‹ „Œ€ŠŠ€‚—Œ "
		db	"3‘“ŒEX ‘“‹ETP "
		db	"A€‘        "
		db	"4ƒ“€ƒ„‘ ‘“Œ„• "
		db	"5   ‚„Œ‘“Œ„•  "
		db	"6„‹”€Œ —Œ   "
		db	"&   „‹”€ŒI‘†xN"
		db	"{Tˆ€ƒ ‘“Œ„•  "
		db	"7„ˆƒ‘     "
		db	"V  €‡ˆ‘TIKO‘"
		db	"@MON€ƒ„‘  1X2 "
		db	"!   AŒ„‘    "
		db	"$   ‹Œ€ƒ„‘   "
		db	"<‘’€’ˆ‘’ˆ‰ €‰"
		db	0

aurmsg	db	"  1   X   2    ",0
mesfor12 db	"METABŠ†’ ‚ˆ€ ",0

errorpl		db	0
komad1		dw	0
plhrqa		dw	0,0
es_point 	dw	0
ds_point 	dw	0
dialogp 	dw	0,0

;*************************************************** ektyposh deltioy
lptfile		db	"LPT.INF",0
draxmespropo	dw	40,0,0,0
lptnames	db	"LPT1",0,0,0,0,0,0,0,0,0,0,0
		db	"LPT2",0,0,0,0,0,0,0,0,0,0,0
		db	"LPT3",0,0,0,0,0,0,0,0,0,0,0
		db	"eror",0,0,0,0,0,0,0,0,0,0,0
lpt_number	dw	offset lptnames

;************************************************************* EPSON
prn_reset		db	27,64,0,0,0,0,0,0,0,0	;prn_reset
prn_formfeed		db	12,0,0,0,0,0,0,0,0,0	;prn_formfeed
prn_left_mergin		db	27,"l",0,0,0,0,0,0,0,0	;prn_left_mergin
prn_vert_space		db	27,"3",0,0,0,0,0,0,0,0	;prn_vert_space
prn_hori_space		db	27," ",0,0,0,0,0,0,0,0	;prn_hori_space
prn_set_10cpi		db	27,"P",0,0,0,0,0,0,0,0	;prn_set_10cpi
prn_set_12cpi		db	27,"M",0,0,0,0,0,0,0,0	;prn_set_12cpi
prn_set_conden		db	27,15,0,0,0,0,0,0,0,0	;prn_set_conden
prn_can_conden		db	27,18,0,0,0,0,0,0,0,0	;prn_can_conden
prn_line_feed		db	10,13,0,0,0,0,0,0,0,0	;prn_line_feed
prn_expanded_on		db	27,"W","1",0,0,0,0,0,0,0 ;prn_expanded_on
prn_expanded_off	db	27,"W","0",0,0,0,0,0,0,0 ;prn_expanded_off
prn_relative_horiz_pos	db	27,"\",0,0,0,0,0,0,0,0
prn_absolute_horiz_pos	db	27,"$",0,0,0,0,0,0,0,0
prn_relative_vert_pos	db	27,"(","v",0,0,0,0,0,0,0
prn_absolute_vert_pos	db	27,"(","V",0,0,0,0,0,0,0
;************************************************************* HP_PCL
pcl_asci		db	1
pcl_reset		db	27,69,0,0,0,0,0,0,0,0
pcl_formfeed		db	27,38,108,48,72,0,0,0,0,0
pcl_10cpi		db	27,38,107,48,83,0,0,0,0,0
pcl_12cpi		db	27,38,107,52,83,0,0,0,0,0
pcl_linefeed		db	10,13,0,0,0,0,0,0,0,0
pcl_mov_horiz1		db	27,38,97,0,0,0,0,0,0,0
pcl_mov_horiz2		db	72,0,0,0,0,0,0,0,0,0
pcl_mov_vert1		db	27,38,97,0,0,0,0,0,0,0
pcl_mov_vert2		db	86,0,0,0,0,0,0,0,0,0
pcl_select_charset	db	27,'(','1','2','U',0,0,0,0,0
pcl_set_height		db	27,'(','s','3','4','V',0,0,0,0,0
pcl_char		db	'ş',0
;*************************************************************
pcl_prn			dw	0,0,0
;*************************************************************
ektip_plr		label	word
ektipotes_plr		dw	1
aytomato_plr		dw	1
anamoni_plr		dw	80
riumisi_pano_plr	dw	28,28,28
riumisi_aris_plr	dw	4,4,4
kena_kaueta_plr		dw	40,40,40
kena_kaueta_end_plr	dw	39,39,39
kena_orizontia_plr	dw	0,0,0
kena_oriz_end_plr	dw	1,1,1
emfasi_plr		dw	0,0,0
double_str_plr		dw	0,0,0
prchar_plr		dw	42,42,42
tiposekt_plr		dw	5,5,5
endiam_kau_plr		dw	3,3,3
endiam_oriz_plr		dw	3,3,3
kena_info_plr		dw	70,70,70

;*************************************
ektip_axb		label	word
ektipotes_axb		dw	1
aytomato_axb		dw	1
anamoni_axb		dw	80
riumisi_pano_axb	dw	28,28,28
riumisi_aris_axb	dw	1,1,1
kena_kaueta_axb		dw	40,40,40
kena_kaueta_end_axb	dw	39,39,39
kena_orizontia_axb	dw	0,0,0
kena_oriz_end_axb	dw	1,1,1
emfasi_axb		dw	0,0,0
double_str_axb		dw	0,0,0
prchar_axb		dw	42,42,42
tiposekt_axb		dw	5,5,5
endiam_kau_axb		dw	3,3,3
endiam_oriz_axb		dw	3,3,3
kena_info_axb		dw	70,70,70

;*************************************

pindial 	db	13 dup(1)
dialsuper13	db	"1"
klidoma_prot 	db	0
stilmn		dw	0
pokmetbl 	dw	0
aromad		db	20 dup(0)
sigoyra 	db	0
buffers 	db	47 dup(" "),"*"
buffer		db	47 dup(" "),"*"
prog		dw	50 dup(0)
pinplhr 	db	39 dup(" "),0	;sthn plhra
;************************************************
ti_deltia	db	0
;************************************************ AURISTIKOI PINAKES
auristikos	dw	10 dup(0,39 dup(100),0,1300)   ;flag,39pososta,apo,eos

;************************************************ ektiposi 14 Agona (09.2009)
Agonas14_	label	byte
Agonas14_Simio		db	"1X2",0
Agonas14_Anaposa 	db	0
Agonas14_Thesi		db	14
Agonas14_Dialogi	db	0
Agonas14_Simio_Code	db	4,3,2,0,9
			db	20 dup(0)		
;************************************************ SAVE START
saveheader	label byte				;500 byte HEADER
		db	10,13
		db	"*************************************************",10,13
		db	"**     (C)Copyright 1997 PROPO V90,5,6,7,8     **",10,13
		db	"** TZORTZAKIS DIMITRIS - PAPADOPOYLOS LEONIDAS **",10,13
		db	"*************************************************",10,13
		db	26
prg_version	dw	2013,1

saveinf		db	5 dup(59 dup(" "),0)	;plirofories

savestart	label byte			;2000 byte VARIABLES
buf_protasi	db	19 dup(39 dup(" "),0)	;protaseis
cound		dw	0,0			;ariumos sthlvn
pinak1		dw	108 dup(0)		;omadopoihsh
pinak2		db	34 dup("*")		;   ""
pinak3		db	12 dup(0)		;   ""
stili		db	0			;editor
asthlh		db	23			;  ""
selida		dw	0			;  ""
bselida 	dw	0			;  ""
arxascii	dw	0			;pointer toy arxasc
axbuesi		db	11			;arxikh uesh axb = 10
arbuf		dw	0			;ariumos buffers gia mnhmh
memory		db	0			;mnhmh...1=nai..0=oxi
exomnimi 	db	0
		db	0,0			;...
;**************************************** SAVE END - synexizi o pinakas arxasc
klidi11		label	byte
;****************************************************** mhdenismoi metablhtvn
arxhm			db	0
axbpin			db	BUFAXB_AB dup(0)	;buffer plirakia & axb
axb_am			dw	0
axb_bm			dw	0
exi_aples		db	0
fatal_stack		dw	0
mexri_tora		dw	0,0
point_bx 		dw	0,0
point_si 		dw	0,0
segm			db	0
antig			db	14 dup(0)
cbyte			db	0
point			db	0
ubyte			db	0
upoint			db	0
servieta 		db	0
axbpoy			dw	0,0
periodos 		db	0
stand			db	13 dup(0)
bytes			dw	0,0
tajin			dw	0
poyli			dw	0
epitixies 		db	22 dup(0)
epig			db	13 dup(0)
sepig			dw	13 dup(0)
pliraki1 		dw	0,0
pliraki2 		dw	0,0
plirues 		dw	0,0
metabl			db	0
metablhths 		db	0,0
filtra			dw	0,0
pin_ues_met 		db	13 dup(0),0		;uesis metablhtoy...
sel			db	0
artyor			dw	0
bin			dw	0
ayjhse			dw	0
synor			dw	0
sthlh			db	0
grammh			db	0
plktr			dw	0		;plhktro
bufpik			db	200 dup(0)	;omades protasevn
pinmet			db	5100 dup(0)	;pinakas metablhtoy
metp			dw	0
chfioa			db	0
chfiob			db	0
chfioc			db	5 dup(0),0
poipro			dw	0
callipr 		dw	400 dup(0)	;protaseis
callpro 		dw	800 dup(0)	;protaseis
pinprot 		db	400 dup(0)	;protaseis
comom			db	0,0
axbp			dw	0		;pointer toy axbpin
pinbil			dw	600 dup(0)	;binelikia (elegxos)
pinbil1			dw	6 dup(0)	;binelikia (shmeia ana uesh+paragoga)
pinak			dw	0
axbpb			dw	0			;pointer toy axbbuf
axbl			db	0			;shmaia gia axbs > 12
axbs			dw	0			;byte sthlvn b merous
baxb			dw	0			;pointer toy bufaxb
bufaxb			db	315 dup(0)		;apouhkeush sthlvn a merous
buf24			db	315 dup(0)		;gia thn proc deltyp
buf48			db	630 dup(0)		;gia axb < 24 sthles
klitaj			dw	0
mastos			db	0
bp48			dw	0			;pointer toy buf48
plirup			dw	0			;uesi gia elegxo
stlplr			dw	10 dup(0)		;stiles sta plirakia
lola			db	0			;axb..
deltio			dw	0,0
delt1			dw	0,0
ar_deltiou 		dw	0,0			; ariumos deltiou
ardel			dw	0,0			; pane ston ariumo deltiou ('1')
shmeadel 		db	0
pointpi 		dw	0
pointp			dw	0
pdata			dw	0			;deikths toy arxdat
pplhr			dw	0			;sthn tajasc
komad			db	0			;sthn tajasc
mapo			db	0			;perna o oros...1=oxi..0=nai
poros			dw	0,0
noxi			db	0
stillo			dw	0
stilpo			dw	0			;pointer toy apstil
stilpo1 		dw	0			;  ""
pointl			dw	0			;  ""
arsave			dw	0			;  ""
arload			dw	0			;  ""
miden			db	0,0
uth			dw	0
;---------------------------------------------------------------------
			db	99 ;;;;;-> EDO AYTO (99)
;---------------------------------------------------------------------
pinsthl 		db	13 dup(0),0	;sthn plhra
pinsthl1 		db	13 dup(0),0	;gia tis parastaseis....
pinsthl2 		db	13 dup(0),0	;gia tis staueres ....
pinsthl3		db	13 dup(0),13,10	;gia ascii
ypoxr			dw	0		;ariumos ypoxreotikvn orvn
comast			dw	0		;ariumos orvn poy perasan se omada
porel			dw	0		;pointer toy pinaka pinbil gia elegxo E
sofi			db	0
skata			db	0
ypor			dw	0
ypor1			dw	0
plr			dw	0
pror			db	0
asor			dw	0
omor			db	5 dup(0)
poson			dw	0,0
plirpoint 		dw	0			;plirakia...
poio			db	0,0
mema			db	0
emfan			db	0
g_emf			dw	0
shmbas			db	0
tsoyk			db	20 dup(0),0
shmea_diplh 		db	0
shmea1			db	0
shmea2			db	0
shmea3			db	0
shmea4			db	0
shmea5			db	0
shmea6			db	0
shmea7			db	0
shmea8			db	0
shmea9			db	0
shmea10 		db	0
shmea11 		db	0
shmea12 		db	0
shmea13 		db	0
shmeat			db	0
dialogi			db	0
gen_buf			db	200 dup(0)
metatropi_se_basikes	db	0
plhrqpin 		dw	0,0,0,0,0
protia_prn		dw	0,0,0
clr_win			db	0
elepin			db	100 dup(0)
simio_super13		db	0,0,0,0,0
exosuper13		db	0
uesi_super13		dw	0,0
triades_pollapl		dw	0,0
poio_extra_simio	dw	0

Agonas14_Metritis	dw	0
Agonas14_Simio_point	dw	0

telosm			db	0
;*****************************************************
ektaktos		db	0
m_ektaktos		db	"?? EKTAKTO‘ ƒˆ€‚—Œˆ‘‹‘ ??",0
triades_poll_apo	label	word
			dd	1
triades_poll_eos	label	word
			dd	1000
deltio2prn		db	600 dup(0)

;*****************************************************
DATAS1	ends

DATANA	segment public
datanarxh 	db	0
arxdat		db	BUFDATA dup(0)	;pinakas arxeioy gia to program
axbbuf		db	BUFAXB_A dup(0)	;buffer	toy axb A meros
datanend 	db	0
DATANA	ends
;
DATASC	segment public
arxasc		db	BUFASCII dup(0)		;pinakas arxeioy ascii
klioma		db	34 dup(0)		;klidoma omadvn *
kliype		db	4 dup(0)		;  ""	   ""  a,b,c,d
klioro		db	1300 dup(0)		;  ""	 orvn
DATASC	ends

WINSEGM segment public
;********************************************************
klidi2	label	byte
;********************************************************
whelp	db	1,0,0,78,23,07h,1
	db      "   0 ..Œ„ Š†„‘           P ..„Œ€ŠŠ€‚„‘            Q ..‘“‹‹„’ˆ‰€",0
        db      "   W ..€‘ˆ‰H ‘’†ŠH         \ ..‹€ƒ„‘ 1•2           M ..‹„’€Š†’",0
        db      "    ..‹€ƒ„‘ ‘†‹„ˆ—Œ       U ..‹€ƒ„‘ ƒˆŠ—Œ        R ..‚„Œˆ‰€ €€‚—‚€",0
        db      "   L ..€€‚—‚€             … ..‹Œ€-…“‚€            “ ..‹€ƒ.‘“Œ„•‹„Œ—Œ",0
        db      "   A ..B€‘ 1®2 - 102      S ..€‡ˆ‘‹€ 1®2 - 012   D ..€‡ˆ‘‹€ ANA ‡E‘H",0
        db      "   I ..€.‘’€‡.‹„ “‘    J ..€.‘’€‡.•—.“‘    ..’ˆŠ„‘ €€‘’€‘„ˆ‘",0
        db      "   H ..€.„Š„“.‹„ “‘    K ..€.„Š„“.•—.“‘   • ..‘“Œ„•‹„Œ€",0
        db      "   1 ..€Œ„‘ 1•2           2 ..‹€ƒ„‘ „Œ€ŠŠ€‚—Œ     3 ..‘“Œ„•. ‘“‹‹„’ˆ‰€",0
	db	"   4 ..ƒ“€ƒ„‘ ‘“Œ„•‹„Œ„‘   5 ..‚„Œˆ‰€ ‘“Œ„•‹„Œ€    6 ..„‹”€Œˆ‘„ˆ‘ —Œ",0
	db	"   { ..Tˆ€ƒ„‘ ‘“Œ„•‹.     7 ..„ˆƒ‘             & ..„‹”€Œˆ‘„ˆ‘ ® Œ",0
	db	"   % ..‘“Œ„•.„Œ€ŠŠ€‚„‘      } ..„Œ€ŠŠ€‚„‘ €Œ€ ‡„‘†   V ..€‡ˆ‘T.INAKE‘",0
	db	"   @ ..MONAƒ„‘ 1•2          ( ..ƒ“€ƒ„‘  -9-          ) ..Tˆ€ƒ„‘  -27-",0
	db	"   ! ..€Œ„‘ ‘†‹„ˆ—Œ       $ ..MONAƒ„‘ ‘†‹„ˆ—Œ      * ..ƒ†Š—Œ— & „Š„‚•—",0
IFDEF	@STATISTIKA
	db	"                            < ..€‰„’O OMOIOTHT—Œ",0
ENDIF
	db	"Ä",1
        db	"   G ..Aˆ‡‹‘ ‘’†Š—Œ       ; ..‹€ƒˆ†‘†          N ..„‰’“—‘„ˆ‘",0
        db      "   C ..ˆŒ€‰„‘ „Š„‚•“      ? ..‹Œ†‹†                9 ..€•„ˆ€",0
        db      "   E ..EŠE‚XO‘ ‘“‘’†‹€’‘   [ ..E‚€Š„ˆ€ ƒˆ€”€     ^ ..‘HMEI—‘EI‘",0
        db      "   ] ..ƒIO‡—‘H O“        8 ..‘’†Š† ƒˆ€ŠO‚†‘       > ..14¦ ‘†‹„ˆ",0
        db      "   , ..ƒˆ€Š‚† AŠ†         F ..‘’†Š„‘ ‘’†Œ ‡Œ†",0
	db	"Ä",1
	db	0
tstcpr5	db	"      (c)1990 - V99 - T…—’…€‰†‘ ƒ†‹†’†‘ & €€ƒ“Š‘ Š„—Œˆƒ€‘",0
	db	0,0,0,0,0,0,0

tstcpr4	label byte
XORDATA	<      (c)1990 - V99 - T…—’…€‰†‘ ƒ†‹†’†‘ & €€ƒ“Š‘ Š„—Œˆƒ€‘>,27
	db	0

wutils	db	21,30,2,39,17,70h,2
	db	"           E  ‚ € Š „ ˆ €",0
	db	0
	db	"    1 ..EˆŠ‚† “",0
	db	"    2 ..‹„’€’† ‘’†Š—Œ ‘„ “‘",0
	db	"    3 ..‹„’€’† ‘’†Š—Œ ‘„ 3€ƒ„‘",0
	db	"    4 ..€ŠŠ€‚† ‹€ƒ€‘",0
	db	"    5 ..€Œ’ˆ‚€”† ‹€ƒ€‘",0
	db	"    6 ..‘†‘ˆ‹ ‹€ƒ€‘",0
	db	"    7 ..€ŠŠ€‚† ˆ—Œ —Œ",0
	db	"    8 ..AN’ˆ‰€’€‘’€‘† ‘†‹„ˆ“",0
	db	"    9 ..‹€ƒ€ €Œ€ ® “‘",0
	db	"    0 ..Eƒ‘ ‘’†Š—Œ ‘„ €SCII",0
	db	0
	db	"    A ..ˆ‘‹‘ €‡ˆ‘’ˆ‰—Œ ˆŒ€‰—Œ",0
IFDEF	@STATISTIKA
	db	"     ..ˆ‘‹‘ ‹ˆ’†’—Œ",0
ENDIF
IFDEF	@TRIADES_POLLAPL
	db	"    D ..ˆ€ ŠŠ€.’ˆ€ƒ—Œ",0
ENDIF
	db	0
	db	0
	db	0

wektiposis	db	22,28,5,22,8,70h,2
	db	"     ƒ „ Š ’ ˆ A",0
	db	0
	db	0
	db	"    4 ..„‰’“—‘H",0
	db	0
	db	"    5 ..ƒˆ€Š‚†",0
	db	0
	db	0

warxeia	db	3,30,3,40,15,70h,1
	db	"           A  • „ ˆ €",0
	db	0
	db	"      1.. ‘—‘ˆ‹ ‘“‘’†‹€’‘",0
	db	"      2.. ”’—‹€ ‘“‘’†‹€’‘",0
	db	"      3.. ‘‡„‘† OP—Œ",0
	db	"      4.. ”’—‹€ ‘“‘’. V95",0
	db	"      5.. ‘‡„‘† O—Œ ASCII",0
	db	"      6.. ”’—‹€ ‘’HŠ—N ASCII",0
	db	0
	db	"      •.. Œ„ ‘“‘’†‹€",0
	db	"      P.. ‘H‘ˆ‹ ‘“‘’.€ ƒˆ‘‰",0
	db	"      A.. Oˆ‘‹‘ ƒˆ‘‰“",0
	db	"      M.. ‘†‘ˆ‹ MONO ’—Œ —Œ",0
	db	"      *.. TEŠ‘ „‚€‘ˆ€‘",0
	db	0

wsave	db	4,22,9,35,5,07h,2
	db	"         ‘—‘ˆ‹ ‘“‘’†‹€’‘",0
	db	0
	db	"     ONOMA €•„ˆ“ :",0
	db	"       ƒIA‚—NI‘MO‘ :",0
	db	0

wmazikd	db	4,22,9,35,4,07h,2
	db	"       ‹€…ˆ‰† ƒˆ€Š‚† €•„ˆ—Œ",0
	db	0
	db	"       ƒIA‚—NI‘MO‘ :",0
	db	0

wsaveAscii db	4,22,9,35,5,07h,2
	db	"      Eƒ‘ ‘’†Š—Œ ‘„ €SCII",0
	db	0
	db	"     ONOMA €•„ˆ“ :",0
	db	0
	db	0

wsuper13 db	6,24,7,18,7,70h,2
	db	"    14os A‚—NA‘",0
	db	0
	db	"   ‘HMEIO :",0
	db	0
	db	" ANA O‘A :",0
	db	"     ‡E‘H :",0
	db	0

wdialsuper13 db	6,24,7,18,4,70h,2
	db	"    14o A‚—NA‘",0
	db	0
	db	"   ‘HMEIO :",0
	db	0

widio	db	5,6,6,69,6,70h,2
	db	0
	db	"   TO €•„ˆ •†‘ˆ‹ˆ„ˆ ˆƒˆ„‘ ‹€ƒ„‘ —Œ ‹„ €“’„‘ “ “€•“Œ",0
	db	"   Hƒ† ‘’† ‹Œ†‹†.   €ŠŠ€’„ ‹€ƒ„‘ —Œ ‰€ˆ €Œ€‘€‡†‘’„.",0
	db	0
	db	"Ä",1
	db	"                             €’†‘’„ '’'",0

wdelti	db	8,1,13,22,8,70h,1
	db	0
	db	" „ ..E‹„Œ ƒ„Š’ˆ",0
	db	" Q ..„‰’“—‘† ƒ„Š’ˆ“",0
	db	" P ..“‡‹ˆ‘† „‰’“—’†",0
	db	" € ..€Œ„ ‘’ ƒ„Š’ˆ",0
	db	" ’ ..’„ŠO‘",0
	db	" ! ..ƒ‰ˆ‹† „‰’“—‘†‘",0
	db	0

wdial1	db	10,6,5,34,17,70h,1
	db	"   ƒ„Š’ˆ   ÚÄ14Ä¿ ÚÄ13Ä¿ ÚÄ12Ä¿",0
	db	"Ä",1
	db	13 dup(0)
	db	"Ä",1
	db	"           YŠ‚ˆ…—...",0

wclr_dial db	13,6,7,34,13,70h,1

wdial2	db	11,44,5,25,16,70h,1
	db	0
	db	"    ƒ„Š’ˆO :",0
	db	"  „—‘ ’—€ :",0
	db	0
	db	"    ‘“ŒŠ  „ˆ’“•ˆ—Œ",0
	db	0
	db	"        14 : 0",0
	db	"        13 : 0",0
	db	"        12 : 0",0
	db	"        11 : 0",0
	db	"        10 : 0",0
	db	"         9 : 0",0
	db	"         8 : 0",0
	db	"         7 : 0",0
	db	"         6 : 0",0
	db	0

wnikitr	db	13,0,3,11,8,70h,2
	db	0
	db	" EI‘€‚—‚†",0
	db	" Œˆ‰H’ˆ€‘",0
	db	0
	db	"Ä",1
	db	"  €’†‘’„",0
	db	"    '’'",0
	db	" ‚ˆ€ ’„Š‘",0

wektip	db	14,20,1,30,20,70h,2
	db	"       “‡‹ˆ‘† „‰’“—’H",0
	db	0
	db	"            ANA‹Œ† :",0
	db	"     „ˆ‡—ˆ €Œ— :",0
	db	" „ˆ‡—ˆ €ˆ‘’„ :",0
	db	0
	db	"  ‰“ˆ€ ‰€‡„’€ ‰„Œ€ :",0
	db	" „Œƒˆ€‹.‰€‡„’€ ‰„Œ€ :",0
	db	" €Œ€ ‘€ „Œƒ.‰€‡„. :",0
	db	0
	db	"  ‰“ˆ€ Oˆ…Œ.‰„Œ€ :",0
	db	" „Œƒˆ€‹.Oˆ…Œ.‰„Œ€ :",0
	db	" €Œ€ ‘€ „Œƒ.Oˆ…. :",0
	db	0
	db	"         •€€‰’†€‘ :",0
	db	"      TO‡.ƒ„Š’ˆ“ :",0
	db	"  „ˆ‡.Š†”Oˆ—Œ :",0
	db	0
	db	"          „‰’“—’†‘ :",0
	db	0

waurist	db	14,10,4,25,17,70h,2
	db	"  €‡ˆ‘T.INAKA‘ No 1 ",0
	db	"    ÚÄÄ1ÄÄÂÄÄXÄÄÂÄÄ2ÄÄ¿",0
	db	"  1 ³     ³     ³     ³",0
	db	"  2 ³     ³     ³     ³",0
	db	"  3 ³     ³     ³     ³",0
	db	"  4 ³     ³     ³     ³",0
	db	"  5 ³     ³     ³     ³",0
	db	"  6 ³     ³     ³     ³",0
	db	"  7 ³     ³     ³     ³",0
	db	"  8 ³     ³     ³     ³",0
	db	"  9 ³     ³     ³     ³",0
	db	" 10 ³     ³     ³     ³",0
	db	" 11 ³     ³     ³     ³",0
	db	" 12 ³     ³     ³     ³",0
	db	" 13 ³     ³     ³     ³",0
	db	"    ÀÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÙ",0
	db	"  €:       „—‘:",0

wpane	db	15,13,8,28,3,70h,2
	db	0
	db	"  A.ƒ„Š’ˆ“ :",0
	db	0
	
wtaf	db	17,1,22,23,1,70h,2
	db	"  ’„Š‘ - €’†‘’„ '’'",0
	
wparag	db	18,4,1,71,21,70h,1
	db	"                     * * *    ˆ Œ € ‰ „ ‘  * * *",0
	db	"Ä",1
	db	"    ‘ † ‹ „ ˆ €   € Œ €   ‡ „ ‘ †  ³             €  € ‚ — ‚ €",0
	db	"         1         X         2     ³         1         X         2",0
	db	"   1.                              ³   0.",0
	db	"   2.                              ³   1.",0
	db	"   3.                              ³   2.",0
	db	"   4.                              ³   3.",0
	db	"   5.                              ³   4.",0
	db	"   6.                              ³   5.",0
	db	"   7.                              ³   6.",0
	db	"   8.                              ³   7.",0
	db	"   9.                              ³   8.",0
	db	"  10.                              ³   9.",0
	db	"  11.                              ³  10.",0
	db	"  12.                              ³  11.",0
	db	"  13.                              ³  12.",0
	db	"                                   ³  13.",0
	db	"  „€‘€Œ :",0
	db	"Ä",1
	db	"                       €’†‘’„  „sc  ‚ˆ€ ƒˆ€‰†",0

wgen	db	19,0,22,78,1,70h,2
	db	0

welegx	db	20,1,1,75,22,70h,1
	db	"      „Š„‚•‡†‘€Œ:         - ‹„’€Š†’:         - „€‘€Œ:",0
	db	"ÄÄÄÄÄÄÄÄÄ³ “•„—’ˆ‰ˆ ˆ ³ ......0 Ä",1
	db	"  1",0
	db	"  9",0
	db	" 17",0
	db	" 25",0
	db	" 33",0
	db	" 41",0
	db	" 49",0
IFDEF	@PROTASI
	db	"ÄÄÄÄÄÄÄÄÄ³ ƒ†Š—Œ—-„Š„‚•—     ³ ......0 Ä",1
ELSE
   IFDEF	@DILONO_ELEGXO
	db	"ÄÄÄÄÄÄÄÄÄ³ ƒ†Š—Œ—-„Š„‚•—     ³ ......0 Ä",1
   ELSE
	db	"ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³ ......0 Ä",1
   ENDIF
ENDIF
	db	0
	db	0
	db	"ÄÄÄÄÄÄÄÄÄ³ OMAƒ„‘            ³ ......0 Ä",1
	db	"  2",0
	db	"  9",0
	db	" 16",0
	db	" 23",0
	db	" 30",0
	db	"ÄÄÄÄÄÄÄÄÄ³ “„‹€ƒ„‘        ³ ......0 Ä",1
	db	0
	db	"Ä",1
	db	"                         €’†‘’„  „sc  ‚ˆ€ ƒˆ€‰†",0


wdiakop	db	21,2,2,36,15,70h,2
	db	"        ƒˆ€‰† „„„‚€‘ˆ€‘",0
	db	"Ä",1
	db	"          ‘’†Š†  €Œ€’“†‘",0
	db	0
	db	"Ä",1
	db	"     ‘’†Š„‘ ‹„•ˆ ’—€ : ......0",0
	db	"Ä",1
	db	0,0,0,0,0
	db	"Ä",1
	db	"       €’†‘’„ '’' ‚ˆ€ ’„Š‘",0
	db	"    † €ŠŠ Š†‰’ ‚ˆ€ ‘“Œ„•„ˆ€",0

wfatal	db	22,25,7,30,7,70h,2
	db	0
fatl	db	"     !!  ‘€ Š€‡‘  !!",0
	db	0
	db	"          €’†‘’„ '’'",0
	db	0
kenl	db	"                         ",0
	db	0

wtoobig	db	23,20,10,40,6,70h,2
	db	0
	db	"       !!!  Š†‹€  ‹Œ†‹†‘  !!!",0
	db	"    ‘†‘’„ “‘ ‰€ˆ €Œ€‘€‡†‘’„",0
	db	0
	db	"Ä",1
	db	"              €’†‘’„  '’'",0

widosor	db	24,28,2,22,19,70h,2
	db	"     EIƒ‘ “: W",0
	db	"Ä",1
	db	"      AN’ˆ‘’ˆ•ˆ€",0
	db	"Ä",1
	db	"        1 ->",0
	db	"        2 ->",0
	db	"        3 ->",0
	db	"        4 ->",0
	db	"        5 ->",0
	db	"        6 ->",0
	db	"        7 ->",0
	db	"        8 ->",0
	db	"        9 ->",0
	db	"       10 ->",0
	db	"       11 ->",0
	db	"       12 ->",0
	db	"       13 ->",0
	db	"Ä",1
	db	"€’†‘’„ Esc  ‚ˆ€ ’„Š‘",0

wmetrima db	25,32,5,36,16,70h,2
	db	"            ME’†‹€ ‘’†Š—Œ",0
	db	"Ä",1
	db	"      ‘’†Š†--> ",0
	db	"        ‘’†Š„‘ Š†“‘ : ......0",0
	db	"Ä",1
	db	"    ‘’†Š„‘ “ „€‘€Œ : ......0",0
	db	"Ä",1
	db	0,0,0,0,0
	db	"Ä",1
	db	"       OI‰Œ‹ˆ€ : ",0
	db	"Ä",1
	db	"      €’†‘’„ „sc ‚ˆ€ ƒˆ€‰†",0

waxb	db	26,23,9,33,3,70h,2
	db	0
	db	"     Oˆ‘‹‘ ‡„‘†‘ €• :",0
	db	0

wsimet	db	26,23,9,27,3,70h,2
	db	0
	db	"     ‘“‹‹„’•„‘ :",0
	db	0

wsbise	db	27,23,9,34,3,70h,2
	db	0
	db	"     ‹€ƒ€ ‚ˆ€ ‘BH‘ˆ‹ :",0
	db	0

wtimi_stilis	db	67,23,9,34,3,70h,2
	db	0
	db	"     ’ˆ‹† ‘’†Š†‘ :",0
	db	0

wallagi	db	28,23,9,34,4,70h,2
	db	0
	db	"     AŠŠ€‚† ’†‘ ‹€ƒ€‘ :",0
	db	"              ‘„ ‹€ƒ€ :",0
	db	0

waloria	db	29,23,9,34,8,70h,2
	db	0
	db	"       AŠŠ€‚† ˆ—Œ —Œ",0
	db	0
	db	"          ‹€ƒ€ :",0
	db	"    Oˆ€    € :",0
	db	"            „—‘ :",0
	db	"            Œ/ :",0
	db	0
	db	0

wantiksim	db	29,23,9,34,8,70h,2
	db	0
	db	"         AŒ’ˆ‰€’€‘’€‘† ‘†‹„ˆ“",0
	db	0
	db	"          ‹€ƒ€ :",0
	db	"           ‡„‘† :",0
	db	"     € ‘†‹„ˆ :",0
	db	"      ‘„ ‘†‹„ˆ :",0
	db	0
	db	0

wantigr	db	30,23,9,34,4,70h,2
	db	0
	db	"  €Œ’ˆ‚€”† ’†‘ ‹€ƒ€‘ :",0
	db	"            ‘’†Œ ‹€ƒ€ :",0
	db	0

wprotas	db	31,17,2,46,19,70h,1
	db	"        ****    ƒ†Š—Œ—  &  „Š„‚•—    ****",0
	db	"Ä",1
	db	"  1.",0
	db	"  2.",0
	db	"  3.",0
	db	"  4.",0
	db	"  5.",0
	db	"  6.",0
	db	"  7.",0
	db	"  8.",0
	db	"  9.",0
	db	" 10.",0
	db	" 11.",0
	db	" 12.",0
	db	" 13.",0
	db	" 14.",0
	db	" 15.",0
	db	"Ä",1
	db	"             €’†‘’„ „sc ‚ˆ€ ’„Š‘",0

wdilono	db	31,17,2,27,19,70h,1
	db	"   ³EAN I‘XYEI³ NA I‘XYEI",0
	db	"Ä",1
	db	"  1³          ³",0
	db	"  2³          ³",0
	db	"  3³          ³",0
	db	"  4³          ³",0
	db	"  5³          ³",0
	db	"  6³          ³",0
	db	"  7³          ³",0
	db	"  8³          ³",0
	db	"  9³          ³",0
	db	" 10³          ³",0
	db	" 11³          ³",0
	db	" 12³          ³",0
	db	" 13³          ³",0
	db	" 14³          ³",0
	db	" 15³          ³",0
	db	"Ä",1
	db	"       „sc ‚ˆ€ ’„Š‘",0

wbaleomad db	32,19,8,41,3,70h,2
	db	0
	db	"   ˆ‘„ Œ„€ ‹€ƒˆ†‘† €Œ€     “‘",0
	db	0

wdialogi db	33,29,8,22,7,70h,2
	db	"  ƒˆ€Š‚† ‘“‘’†‹€’‘",0
	db	"Ä",1
	db	0
	db	"   13á¨   : 0",0
	db	"   12á¨   : 0",0
	db	"   11á¨   : 0",0
	db	0

wstlouoni db	34,25,3,26,19,70h,1
	db	"    ‘’†Š„‘ ‘’†Œ ‡Œ†",0
	db	"Ä",1
	db	15 dup(0)
	db	"Ä",1
	db	"  €’†‘’„  '’' ‚ˆ€ ’„Š‘",0

wtajin	db	35,25,8,26,5,70h,2
	db	0
	db	0
	db	"        TAˆŒ‹†‘†",0
	db	0
	db	0

wdeltio_axb db	36,32,1,26,20,70h,1
	db	"        ƒ„Š’ˆ €®",0
	db	"Ä",1
	db	13 dup(0)
	db	"Ä",1
	db	"      ƒ„Š’ˆ :",0
	db	"      ‘’†Š„‘ :",0
	db	"  ‹„•ˆ ’—€ :",0
	db	"   ‘“„ 13 :",0

wclr_axb db	37,32,3,26,13,70h,1

wdeltio_pliraki	db	39,27,0,33,21,70h,1
	db	"         ƒ„Š’ˆ Š†€‰ˆ€",0
	db	0
	db	15 dup(0)
	db	"Ä",1
	db	"      ƒ„Š’ˆ :",0
	db	"      ‘’†Š„‘ :",0
	db	"  ‹„•ˆ ’—€ :",0

wclr_pliraki db	40,27,1,33,16,70h,1

winkeno	db	94,30 dup(0)

menu_statistika	db	58,14,3,51,15,70h,1
		db	"                ‘ ’ € ’ ˆ ‘ ’ ˆ ‰ €",0
		db	"Ä",1
		db	"              Š†‡‘ 1   ³          ‘“Œ„•‹„Œ€ 1",0
		db	"              Š†‡‘ 2   ³          ‘“Œ„•‹„Œ€ 2",0 
		db	"              Š†‡‘ •   ³          ‘“Œ„•‹„Œ€ •",0
		db	"            ‘“‹‹„’ˆ‰A   ³  ‘“Œ„•‹„Œ€ ‘“‹„’ˆ‰€",0
		db	"             „Œ€ŠŠ€‚„‘   ³      ‹€ƒ„‘ „Œ€ŠŠ€‚—Œ",0
		db	"                €Œ„‘   ³            ‹€ƒ„‘ 12•",0
		db	"          €‘ ‘’†Š†‘   ³       €‡ˆ‘‹€ ‘’†Š†‘",0
		db	"              ‹€ƒ„‘ 1   ³             ‹€ƒ„‘ 1•",0
		db	"              ‹€ƒ„‘ 2   ³             ‹€ƒ„‘ 12",0
		db	"              ‹€ƒ„‘ X   ³             ‹€ƒ„‘ 2•",0
		db	"    ƒ“€ƒ„‘ ‘“Œ„•‹„Œ„‘   ³   ’ˆ€ƒ„‘ ‘“Œ„•‹„Œ„‘",0
		db	"Ä",1
		db	"        AXEIO : ",0

wplwait		db	59,25,9,29,3,70h,2
		db	0
		db	"     €€‰€Š— „ˆ‹„Œ„’„",0
		db	0

wplirof	db	95,14,6,63,9,70h,2
	db	"                      ‘ H M E I — ‘ E I ‘",0
	db	"Ä",1
	db	0,0,0,0,0
	db	"Ä",1
	db	"                         'Esc' ’„Š‘",0

wpollapl db	42,10,8,20,5,70h,2
	db	"  Tˆ€ƒ„‘ ŠŠ€Š. ",0
	db	0
	db	"  €: ",0
	db	"  „—‘: ",0
	db	0

;**************************************************************
wright	label	byte
	db	1,30,1,46,16,70h,2
	db	0
	db	"          ±±     ±±   ±±±±   ±±±±   ",0
	db	"          ±±     ±±  ±±  ±± ±±  ±±  ",0
	db	"           ±±   ±±   ±±±±±±  ±±±±±  ",0
	db	"            ±± ±±        ±±     ±±  ",0
	db	"             ±±±  ±  ±±±±±  ±±±±±   ",0
	db	0
	db	"Ä",1
	db	0
	db	"           E¡›¦© 6.00 - 01.11.2013",0
	db	"        "
tstcpr1	db	"’…—’…A‰†‘ ƒ. & AAƒ“Š‘ Š.",0
	db	0
	db	"Ä",1
	db	0
	db	"               leonpap@gmail.com",0
	db	0


tstcpr2	label	byte
XORDATA	<’…—’…A‰†‘ ƒ. & AAƒ“Š‘ Š.>,39
	db	0

wstart	db	42,13,4,52,17,07h,0
	db	"±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
	db	"±±±ÛÛÛÛÛÛÛ±±ÛÛÛÛÛÛ±±ÛÛÛÛÛÛ±±±±±±±ÛÛÛÛÛÛÛ±±ÛÛÛÛÛÛ±±±±"
	db	"±±±ÛÛ°°°ÛÛ°±ÛÛ°°ÛÛ°±ÛÛ°°ÛÛ°±±±±±±ÛÛ°°°ÛÛ°±ÛÛ°°ÛÛ°±±±"
	db	"±±±ÛÛ°±±ÛÛ°±ÛÛÛÛÛÛ°±ÛÛ°±ÛÛ°±ÛÛÛ±±ÛÛ°±±ÛÛ°±ÛÛ°±ÛÛ°±±±"
	db	"±±±ÛÛ°±±ÛÛ°±ÛÛ°°°°°±ÛÛÛÛÛÛ°±±°°°±ÛÛ°±±ÛÛ°±ÛÛÛÛÛÛ°±±±"
	db	"±±±±°°±±±°°±±°°±±±±±±°°°°°°±±±±±±±°°±±±°°±±°°°°°°±±±"
	db	"±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±ÛÛ±±±±±±ÛÛ±±±ÛÛÛÛÛÛ±±ÛÛÛÛÛÛ±±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±ÛÛ°±±±±±ÛÛ°±±ÛÛ°°°Û°±ÛÛ°°°Û°±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±±Û°±±±±±Û°±±±ÛÛÛÛÛÛ°±ÛÛÛÛÛÛ°±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±±±Û°±±±Û°±±±±±°°°°Û°±±°°°°Û°±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±±±±Û°±Û°±±±±±±±±±±Û°±±±±±±Û°±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±±±±±ÛÛ°°±ÛÛ±±ÛÛÛÛÛÛ°±ÛÛÛÛÛÛ°±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±±±±±±°°±±±°°±±°°°°°°±±°°°°°°±±±±±±±±±±±±"
	db	"±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
	db	"  (C)  ’…—’…€‰†‘ ƒ†‹†’†‘ & €€ƒ“Š‘ Š„—Œˆƒ€‘  "

wstr	db	10 dup(0)
;***********************************************
WINSEGM ends

CODESG	segment	public
ascii_handle	dw	0
print_stack	dw	0
CODESG	ends

CODESG5	segment	public
print_stack5	dw	0
CODESG5	ends

;*************************************** MNIMI
MAST1	segment	public
master1	db	65504 dup(?)
MAST1	ends

MAST2	segment	public
	db	65504 dup(?)
MAST2	ends

MAST3	segment	public
	db	65504 dup(?)
MAST3	ends

MAST4	segment public
	db      65504 dup(?)
MAST4	ends

MAST5	segment public
;;;	db      65504 dup(?)
MAST5	ends

MAST6	segment public
	db	0
MAST6	ends

;******************************
	end
