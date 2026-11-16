100 poke51,0:poke52,29:poke55,0:poke56,29:clr:rem init: basic top 7424, charset above
110 s=7680:c=38400:dimo%(3)
120 o%(0)=-22:o%(1)=1:o%(2)=22:o%(3)=-1
130 poke198,0

200 readk:ifk<0then300:rem charset: a code, then its 8 bytes
210 fori=0to7:readt:poke7168+k*8+i,t:next:goto200

300 poke36879,8:poke36869,255:print"{clr}";:rem board: bricks, title, help
310 fori=0to21:pokec+i,2:pokes+i,42:pokec+44+i,2:pokes+44+i,42
320 pokec+396+i,2:pokes+396+i,42:pokec+484+i,2:pokes+484+i,42:next
330 fori=22to462step22:pokec+i,2:pokes+i,42:pokec+i+21,2:pokes+i+21,42:next
340 print"{home}{down}{right}{right}{reverse on}{wht}code{yel}monkey{wht}atl{yel}tail"
350 poke214,18:print:print"{reverse on}{right}{cyn}score {wht}0"
360 printtab(12)"{reverse on}{cyn}qq{wht}=quit"
370 print"{reverse on}{right}{cyn}wasd{wht}=move   {cyn}m{wht}=mute";

400 p=230:d=1:l=0:pokec+p,1:pokes+p,40:poke198,0:rem play: head mid-field, moving right
410 fori=1to400:next:rem delay, tuned by play
420 geta$:ifa$=""then460
430 k=asc(a$)and127:ifk=81thenifl=81then520:rem qq quits
440 l=k:j=-(k=68)-2*(k=83)-3*(k=65):ifj=0thenifk<>87then460:rem w 87, d 68, s 83, a 65
450 ifj<>((d+2)and3)thend=j:rem no reversing
460 n=p+o%(d):ifpeek(s+n)<>32then480:rem step; anything but blank ends the game
470 pokes+p,32:pokec+n,1:pokes+n,40:p=n:goto410

480 poke214,18:print:printtab(11)"{reverse on}{wht}game over";:rem game over, on the score line

500 poke198,0:rem wait for a key, then restore and end
510 geta$:ifa$=""then510
520 poke36869,240:poke52,30:poke56,30:clr:poke36879,27:print"{clr}{blu}";:end

1000 data32,0,0,0,0,0,0,0,0:rem blank
1002 data40,60,126,219,255,126,66,36,24:rem head: monkey face
1004 data41,3,6,6,12,28,120,224,0:rem banana
1006 data42,255,136,136,136,255,34,34,34:rem brick
1010 data48,153,165,195,129,153,165,195,129:rem tail pieces (design.md): straight up
1012 data49,1,2,4,8,24,36,66,129:rem corner up to right
1014 data50,0,0,0,24,36,36,102,90:rem tip, out down
1016 data51,128,64,32,16,24,36,66,129:rem corner up to left
1018 data52,129,66,36,24,16,32,64,128:rem corner right to up
1020 data53,255,68,34,17,17,34,68,255:rem straight right
1022 data54,128,64,32,16,24,36,66,129:rem corner right to down
1024 data55,0,192,112,136,136,112,192,0:rem tip, out left
1026 data56,90,102,36,36,24,0,0,0:rem tip, out up
1028 data57,129,66,36,24,8,4,2,1:rem corner down to right
1030 data58,129,195,165,153,129,195,165,153:rem straight down
1032 data59,129,66,36,24,16,32,64,128:rem corner down to left
1034 data60,129,66,36,24,8,4,2,1:rem corner left to up
1036 data61,0,3,14,17,17,14,3,0:rem tip, out right
1038 data62,1,2,4,8,24,36,66,129:rem corner left to down
1040 data63,255,34,68,136,136,68,34,255:rem straight left
1050 data-1
