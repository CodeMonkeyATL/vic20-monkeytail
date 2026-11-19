100 poke51,0:poke52,29:poke55,0:poke56,29:clr:s=7680:c=38400:dimo%(3):rem init: basic top 7424
110 o%(0)=-22:o%(1)=1:o%(2)=22:o%(3)=-1:poke198,0:t=rnd(-ti):h=7:poke36878,h

200 readk:ifk<0then300:rem charset: a code, then its 8 bytes, or minus a code to copy
205 readt:ift<0thenfori=0to7:poke7168+k*8+i,peek(7168-t*8+i):next:goto200
210 poke7168+k*8,t:fori=1to7:readt:poke7168+k*8+i,t:next:goto200

300 poke36879,8:poke36869,255:print"{clr}";:rem board: bricks, title, help
310 fori=0to21:pokec+i,2:pokes+i,42:pokec+44+i,2:pokes+44+i,42
320 pokec+396+i,2:pokes+396+i,42:pokec+484+i,2:pokes+484+i,42:next
330 fori=22to462step22:pokec+i,2:pokes+i,42:pokec+i+21,2:pokes+i+21,42:next
340 print"{home}{down}{right}{reverse on}{cyn}code{reverse off}{yel}){reverse on}{grn}monkey{reverse off}{yel})";
345 print"{reverse on}{cyn}atl{reverse off}{yel}){reverse on}{grn}tail":poke214,18:print
350 print"{reverse on}{right}{cyn}score {wht}0":print"{reverse on}{right}{cyn}wasd{wht}=move {cyn}rr{wht}=restart"
370 printtab(4)"{reverse on}{cyn}m{wht}=mute {cyn}qq{wht}=quit";:gosub740

400 p=230:d=1:e=1:q=228:l=0:g=0:v=0:w=400:z=ti:pokec+p,7:pokes+p,40:poke198,0:rem play: head mid-field
405 fori=228to229:pokec+i,5:next:pokes+228,61:pokes+229,53:gosub600:rem tail tip, one body cell, a banana
410 fori=1tow:next:geta$:ifa$=""then460:rem delay: the speed, then a key
430 k=asc(a$)and127:ifk=81thenifl=81then890:rem qq quits
435 ifk=82thenifl=82then300:rem rr restarts
437 ifk=77thenh=7-h:poke36878,h:gosub740:rem m mutes: volume 7 or 0
440 l=k:j=-(k=68)-2*(k=83)-3*(k=65):ifj=0thenifk<>87then460:rem w 87, d 68, s 83, a 65
450 ifj<>((d+2)and3)thend=j:rem no reversing
460 n=p+o%(d):t=peek(s+n):ift=41thengosub700:goto464:rem banana: eat it
462 ift<>32thenifn<>qorg>0then480:rem blank is safe, or the tail end if it moves
464 ifg>0theng=g-1:goto470:rem growing: the tail end stays
466 t=peek(s+q)and3:pokes+q,32:q=q+o%(t):t=peek(s+q)and3:pokes+q,48+((t+2)and3)*4+t:rem tail end moves
470 pokec+p,5:pokes+p,48+e*4+d:e=d:pokec+n,7:pokes+n,40:p=n:goto410:rem old head cell joins the body

480 z=ti-z:t=int(z/60):poke214,18:print:printtab(12)"{reverse on}{wht}game over":rem game over, time below
481 print"{reverse on}{right}{cyn}time {wht}"mid$(str$(int(t/60)),2)":"right$(str$(100+t-int(t/60)*60),2);
482 gosub900:fori=200to140step-.5:poke36874,i:next:pokec+p,2:t=p-o%(e):x=226:y=196:rem crash, then red
483 poke36874,x:poke36875,y:poke36876,x:x=x-4:y=y+4:ifx<196thenx=x+30:rem up+down sound
485 ify>226theny=y-30
486 fori=1to20:next:pokec+t,2:ift<>qthent=t-o%(int(peek(s+t)/4)and3):goto483
487 poke36874,0:poke36875,0:poke36876,0:poke198,0:l=0:rem wait for rr or qq
510 geta$:ifa$=""then510
512 k=asc(a$)and127:ifk<>lthenl=k:goto510
514 ifk=82then300:rem rr restarts
516 ifk<>81then510
520 poke36878,0:poke36869,240:poke52,30:poke56,30:clr:poke36879,27:print"{clr}{blu}";
525 ifpeek(841)=0thenend
530 print"{reverse off}{down}{down}load"chr$(34);:fori=1topeek(842):printchr$(peek(842+i));:next:rem load the launcher
540 printchr$(34)","peek(841)"{home}";:poke631,13:poke632,82:poke633,85
545 poke634,78:poke635,13:poke198,5:end

600 b=67+int(rnd(1)*15)*22+int(rnd(1)*20):ifpeek(s+b)<>32then600:rem banana, random empty cell
610 pokec+b,7:pokes+b,41:return

700 g=g+3:v=v+1:gosub600:poke214,18:print:printtab(6)"{reverse on}{wht}"v:rem eat: grow, score
702 poke36876,230:gosub720:poke36876,240:fori=1to60:next:gosub720:poke36876,0:rem ding-ding
705 ifv-int(v/3)*3=0thenw=w-12:ifw<150thenw=150:rem every 3rd banana: faster, to a floor
710 return

720 ifhthenfori=hto0step-h/15:poke36878,i:next:poke36878,h:rem fade the volume out, then back
730 return

740 fori=38869to38871:pokei,1-(h=0):next:return:rem the help's "ute": red when muted, white with sound

890 ifpeek(841)thenifv>0thent=int((ti-z)/60):gosub900:rem qq in play: the score so far, from a launcher
895 goto520

900 ifv<1orpeek(900)=3andv<=peek(904)+256*peek(905)thenreturn:rem result: keep the best game
910 poke900,3:poke901,252:poke902,1:poke903,2:poke904,255andv:poke905,v/256:poke906,0
920 poke907,255andt:poke908,t/256:poke909,0:return

1000 data32,0,0,0,0,0,0,0,0,40,60,126,219,255,126,66,36,24:rem blank, head
1002 data41,3,6,6,12,28,120,224,0,42,255,136,136,136,255,34,34,34:rem banana, brick
1010 data48,153,165,195,129,153,165,195,129,49,1,2,4,8,24,36,66,129:rem straight up, corner up-right
1014 data50,0,0,0,24,36,36,102,90,51,128,64,32,16,24,36,66,129:rem tip down, corner up-left
1018 data52,129,66,36,24,16,32,64,128,53,255,68,34,17,17,34,68,255:rem corner right-up, straight right
1022 data54,-51,55,0,192,112,136,136,112,192,0,56,90,102,36,36,24,0,0,0:rem corner, tips left, up
1028 data57,129,66,36,24,8,4,2,1,58,129,195,165,153,129,195,165,153:rem corner down-right, straight down
1032 data59,-52,60,-57,61,0,3,14,17,17,14,3,0,62,-49:rem corners, tip right, corner
1040 data63,255,34,68,136,136,68,34,255,-1:rem straight left
