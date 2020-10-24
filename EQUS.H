
@WINDOWS = WINSEGM


INCLUDE	mylib.inc
INCLUDE	sdir.inc
INCLUDE	sindisk.inc
INCLUDE	snaioxi.inc
INCLUDE	keys.inc

cr		= 13
lf		= 10
LEFT_ARROW	= 75
RIGHT_ARROW	= 77
UP_ARROW	= 72
DOWN_ARROW	= 80
CTRL_LEFT	= 115
CTRL_RIGHT	= 116
_HOME		= 47h
_END		= 4fh
_INS		= 82

BUFDATA		= 54000	;за_____ data ___ ____
BUFASCII	= 60480	;за_____ ascii ___ ____
BUFAXB_AB	= 47031	;buffer ___ ___ & plirakia
BUFAXB_A	= 10100	;buffer ___ _ ______ ___ ___

INCLUDE	globals.inc
