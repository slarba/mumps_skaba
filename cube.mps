 ; ---------- kuution vertexit
 set cube(0,0)=-10
 set cube(0,1)=-10
 set cube(0,2)=-10

 set cube(1,0)=10
 set cube(1,1)=-10
 set cube(1,2)=-10

 set cube(2,0)=10
 set cube(2,1)=10
 set cube(2,2)=-10

 set cube(3,0)=-10
 set cube(3,1)=10
 set cube(3,2)=-10

 set cube(4,0)=-10
 set cube(4,1)=-10
 set cube(4,2)=10

 set cube(5,0)=10
 set cube(5,1)=-10
 set cube(5,2)=10

 set cube(6,0)=10
 set cube(6,1)=10
 set cube(6,2)=10

 set cube(7,0)=-10
 set cube(7,1)=10
 set cube(7,2)=10

 ; ---------- edget
 set edge(0,0)=0
 set edge(0,1)=1

 set edge(1,0)=1
 set edge(1,1)=2

 set edge(2,0)=2
 set edge(2,1)=3

 set edge(3,0)=3
 set edge(3,1)=0

 set edge(4,0)=4
 set edge(4,1)=5

 set edge(5,0)=5
 set edge(5,1)=6

 set edge(6,0)=6
 set edge(6,1)=7

 set edge(7,0)=7
 set edge(7,1)=4

 set edge(8,0)=0
 set edge(8,1)=4

 set edge(9,0)=1
 set edge(9,1)=5

 set edge(10,0)=2
 set edge(10,1)=6

 set edge(11,0)=3
 set edge(11,1)=7

 ; ---------- rotaatiokulmat
 set anglex=0
 set angley=0
 set anglez=0

 ; ---------- piirtopuskurin dimensiot ja keskipiste
 set screenwidth=80
 set screenheight=40
 set screenmidx=screenwidth/2
 set screenmidy=screenheight/2

 ; ---------- projektion field of view
 set fov=35

 ; ---------- montako framea rendataan
 set frames=10

 ; ---------- paasilmukka
 for  do
 . break:frames'>0
 . do initscreen()
 . do setrot(anglex,angley,anglez)
 . do rotatecube()
 . do drawcube()
 . do showscreen()
 . set anglex=anglex+"0.1"
 . set angley=angley+"0.2"
 . set anglez=anglez+"0.3"
 . set frames=frames-1
 halt

 ; ---------- kerro kuution vektorit matriisilla ja tallenna pyöritelty kuutio rotatedcube-taulukkoon
rotatecube()
 for i=0:1:7 do
 . set tmpx=0
 . set tmpy=0
 . set tmpz=0
 . do matmulv(cube(i,0),cube(i,1),cube(i,2),.tmpx,.tmpy,.tmpz)
 . set rotatedcube(i,0)=tmpx
 . set rotatedcube(i,1)=tmpy
 . set rotatedcube(i,2)=tmpz
 quit

 ; ---------- piirrä kuutio
drawcube()
 for v=0:1:11 do
 . set frompt=edge(v,0)
 . set topt=edge(v,1)
 . set zc=fov+rotatedcube(frompt,2)
 . set fax=((fov*(rotatedcube(frompt,0)))/zc)+screenmidx
 . set fay=((fov*(rotatedcube(frompt,1)))/zc)+screenmidy
 . set zc=fov+rotatedcube(topt,2)
 . set tax=((fov*(rotatedcube(topt,0)))/zc)+screenmidx
 . set tay=((fov*(rotatedcube(topt,1)))/zc)+screenmidy
 . do bresenham(fax,fay,tax,tay)
 quit

 ; ---------- piirra piste bufferiin
plot(x,y)
 if (x'<0)&(x'>screenwidth)&(y'<0)&(y'>screenheight) do
 . set screen($zfloor(x),$zfloor(y))="o"
 quit

 ; ---------- kerro vektori pyöritysmatriisilla
matmulv(x,y,z,retx,rety,retz)
 set retx=(x*rm(0,0))+(y*rm(0,1))+(z*rm(0,2))
 set rety=(x*rm(1,0))+(y*rm(1,1))+(z*rm(1,2))
 set retz=(x*rm(2,0))+(y*rm(2,1))+(z*rm(2,2))
 quit

 ; ---------- viivanpiirto
bresenham(ax,ay,bx,by)
 set ax=$zfloor(ax)
 set ay=$zfloor(ay)
 set bx=$zfloor(bx)
 set by=$zfloor(by)
 set dx=bx-ax
 set dy=by-ay
 set stepx=1
 set stepy=1
 if dy<0 do
 . set dy=-dy
 . set stepy=-1
 if dx<0 do
 . set dx=-dx
 . set stepx=-1
 set dx=2*dx
 set dy=2*dy
 do plot(ax,ay)
 if dx>dy do
 . set fraction=dy-(dx/2)
 . for  do
 .. break:ax=bx
 .. set ax=ax+stepx
 .. if fraction'<0 do
 ... set ay=ay+stepy
 ... set fraction=fraction-dx
 .. set fraction=fraction+dy
 .. do plot(ax,ay)
 else do
 . set fraction=dx-(dy/2)
 . for  do
 .. break:ay=by
 .. if fraction'<0 do
 ... set ax=ax+stepx
 ... set fraction=fraction-dy
 .. set ay=ay+stepy
 .. set fraction=fraction+dx
 .. do plot(ax,ay)
 quit

 ; ---------- alusta piirtobufferi
initscreen()
 for x=0:1:screenwidth do
 . for y=0:1:screenheight do
 .. set screen(x,y)="."
 quit

 ; ---------- luo rotaatiomatriisi pyörityskulmilla
setrot(a,b,c)
 set rm(0,0)=$zcos(c)*$zcos(b)
 set rm(0,1)=(-$zsin(c)*$zcos(a))+($zcos(c)*$zsin(b)*$zsin(a))
 set rm(0,2)=($zsin(c)*$zsin(a))+($zcos(c)*$zsin(b)*$zcos(a))
 set rm(1,0)=$zsin(c)*$zcos(b)
 set rm(1,1)=($zcos(c)*$zcos(a))+($zsin(c)*$zsin(b)*$zsin(a))
 set rm(1,2)=(-$zcos(c)*$zsin(a))+($zsin(c)*$zsin(b)*$zcos(a))
 set rm(2,0)=-$zsin(b)
 set rm(2,1)=$zcos(b)*$zsin(a)
 set rm(2,2)=$zcos(b)*$zcos(a)
 quit

 ; ---------- piirra piirtobufferi konsolille
showscreen()
 write !
 for y=0:1:screenheight do
 . for x=0:1:screenwidth do
 .. write screen(x,y)
 . write !
 quit
