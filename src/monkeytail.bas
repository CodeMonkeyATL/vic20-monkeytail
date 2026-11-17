100 poke51,0:poke52,29:poke55,0:poke56,29:clr:rem init: basic top 7424, charset above
110 s=7680:c=38400:dimo%(3)
120 o%(0)=-22:o%(1)=1:o%(2)=22:o%(3)=-1
130 poke198,0:t=rnd(-ti)

200 readk:ifk<0then300:rem charset: a code, then its 8 bytes
210 fori=0to7:readt:poke7168+k*8+i,t:next:goto200

300 poke36879,8:poke36869,255:print"{clr}";:rem board: bricks, title, help
310 fori=0to21:pokec+i,2:pokes+i,42:pokec+44+i,2:pokes+44+i,42
320 pokec+396+i,2:pokes+396+i,42:pokec+484+i,2:pokes+484+i,42:next
330 fori=22to462step22:pokec+i,2:pokes+i,42:pokec+i+21,2:pokes+i+21,42:next
340 print"{home}{down}{right}{reverse on}{cyn}code{reverse off}{yel}){reverse on}{grn}monkey{reverse off}{yel})";
345 print"{reverse on}{cyn}atl{reverse off}{yel}){reverse on}{grn}tail"
350 poke214,18:print:print"{reverse on}{right}{cyn}score {wht}0"
360 print"{reverse on}{right}{cyn}wasd{wht}=move {cyn}rr{wht}=restart"
370 printtab(4)"{reverse on}{cyn}m{wht}=mute {cyn}qq{wht}=quit";

400 p=230:d=1:e=1:q=228:l=0:g=0:v=0:z=ti:pokec+p,7:pokes+p,40:poke198,0:rem play: head mid-field, moving right
405 fori=228to229:pokec+i,5:next:pokes+228,61:pokes+229,53:gosub600:rem tail tip, one body cell, a banana
410 fori=1to400:next:rem delay, tuned by play
420 geta$:ifa$=""then460
430 k=asc(a$)and127:ifk=81thenifl=81then520:rem qq quits
435 ifk=82thenifl=82then300:rem rr restarts
440 l=k:j=-(k=68)-2*(k=83)-3*(k=65):ifj=0thenifk<>87then460:rem w 87, d 68, s 83, a 65
450 ifj<>((d+2)and3)thend=j:rem no reversing
460 n=p+o%(d):t=peek(s+n):ift=41thengosub700:goto464:rem banana: eat it
462 ift<>32thenifn<>qorg>0then480:rem blank is safe, or the tail end if it moves
464 ifg>0theng=g-1:goto470:rem growing: the tail end stays
466 t=peek(s+q)and3:pokes+q,32:q=q+o%(t):rem tail end follows its way out
468 t=peek(s+q)and3:pokes+q,48+((t+2)and3)*4+t:rem new end becomes a tip
470 pokec+p,5:pokes+p,48+e*4+d:e=d:pokec+n,7:pokes+n,40:p=n:goto410:rem old head cell joins the body

480 z=ti-z:poke214,18:print:printtab(12)"{reverse on}{wht}game over";:rem game over, on the score line
482 pokec+p,2:t=p-o%(e):rem the monkey turns red, head to tail
484 fori=1to60:next:pokec+t,2:ift<>qthent=t-o%(int(peek(s+t)/4)and3):goto484
486 t=int(z/60):poke214,19:print:print"{reverse on}{right}{cyn}time {wht}"mid$(str$(int(t/60)),2)":";:rem time played
488 printright$(str$(100+t-int(t/60)*60),2);

500 poke198,0:l=0:rem wait for rr or qq
510 geta$:ifa$=""then510
512 k=asc(a$)and127:ifk<>lthenl=k:goto510
514 ifk=82then300:rem rr restarts
516 ifk<>81then510
520 poke36869,240:poke52,30:poke56,30:clr:poke36879,27:print"{clr}{blu}";:end

600 b=67+int(rnd(1)*15)*22+int(rnd(1)*20):ifpeek(s+b)<>32then600:rem banana, random empty cell
610 pokec+b,7:pokes+b,41:return

700 g=g+3:v=v+1:gosub600:poke214,18:print:printtab(6)"{reverse on}{wht}"v:return:rem eat: grow, score

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
