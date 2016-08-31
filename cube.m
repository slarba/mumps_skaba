 ; ---------- kuution vertexit
 s cube(0,0)=-10
 s cube(0,1)=-10
 s cube(0,2)=-10
 s cube(1,0)=10
 s cube(1,1)=-10
 s cube(1,2)=-10
 s cube(2,0)=10
 s cube(2,1)=10
 s cube(2,2)=-10
 s cube(3,0)=-10
 s cube(3,1)=10
 s cube(3,2)=-10
 s cube(4,0)=-10
 s cube(4,1)=-10
 s cube(4,2)=10
 s cube(5,0)=10
 s cube(5,1)=-10
 s cube(5,2)=10
 s cube(6,0)=10
 s cube(6,1)=10
 s cube(6,2)=10
 s cube(7,0)=-10
 s cube(7,1)=10
 s cube(7,2)=10

 ; ---------- edget
 s edge(0,0)=0,edge(0,1)=1
 s edge(1,0)=1,edge(1,1)=2
 s edge(2,0)=2,edge(2,1)=3
 s edge(3,0)=3,edge(3,1)=0
 s edge(4,0)=4,edge(4,1)=5
 s edge(5,0)=5,edge(5,1)=6
 s edge(6,0)=6,edge(6,1)=7
 s edge(7,0)=7,edge(7,1)=4
 s edge(8,0)=0,edge(8,1)=4
 s edge(9,0)=1,edge(9,1)=5
 s edge(10,0)=2,edge(10,1)=6
 s edge(11,0)=3,edge(11,1)=7

 ; ---------- rotaatiokulmat
 s anglex=0,angley=0,anglez=0

 ; ---------- piirtopuskurin dimensiot ja keskipiste
 s screenwidth=130,screenheight=40
 s screenmidx=screenwidth/2,screenmidy=screenheight/2

 ; ---------- projektion field of view
 s fov=35

 ; ---------- montako framea rendataan
 s frames=1000
 
 ; ---------- paasilmukka
 f  do
 . b:frames'>0
 . do setrot(anglex,angley,anglez)
 . do rotatecube()
 . do initscreen()
 . do drawcube()
 . do showscreen()
 . s anglex=anglex+"0.01"
 . s angley=angley+"0.015"
 . s anglez=anglez+"0.02"
 . s frames=frames-1
 halt

 ; ---------- kerro kuution vektorit matriisilla ja tallenna pyöritelty kuutio rotatedcube-taulukkoon
rotatecube()
 f i=0:1:7 do
 . s tmpx=0,tmpy=0,tmpz=0
 . do matmulv(cube(i,0),cube(i,1),cube(i,2),.tmpx,.tmpy,.tmpz)
 . s rotatedcube(i,0)=tmpx,rotatedcube(i,1)=tmpy,rotatedcube(i,2)=tmpz
 q

 ; ---------- piirrä kuutio
drawcube()
 f v=0:1:11 do
 . s frompt=edge(v,0)
 . s topt=edge(v,1)
 . s zc=fov+rotatedcube(frompt,2)
 . s fax=((fov*(2*rotatedcube(frompt,0)))/zc)+screenmidx
 . s fay=((fov*(rotatedcube(frompt,1)))/zc)+screenmidy
 . s zc=fov+rotatedcube(topt,2)
 . s tax=((fov*(2*rotatedcube(topt,0)))/zc)+screenmidx
 . s tay=((fov*(rotatedcube(topt,1)))/zc)+screenmidy
 . do bresenham(fax,fay,tax,tay)
 q

 ; ---------- piirra piste bufferiin
plot(x,y)
 s:(x'<0)&(x'>screenwidth)&(y'<0)&(y'>screenheight) $e(screen($zfloor(y)),$zfloor(x+1))="o"
 q

 ; ---------- kerro vektori pyöritysmatriisilla
matmulv(x,y,z,retx,rety,retz)
 s retx=(x*rm(0,0))+(y*rm(0,1))+(z*rm(0,2))
 s rety=(x*rm(1,0))+(y*rm(1,1))+(z*rm(1,2))
 s retz=(x*rm(2,0))+(y*rm(2,1))+(z*rm(2,2))
 q

 ; ---------- viivanpiirto
bresenham(ax,ay,bx,by)
 s ax=$zfloor(ax),ay=$zfloor(ay)
 s bx=$zfloor(bx),by=$zfloor(by)
 s dx=bx-ax,dy=by-ay
 s stepx=1,stepy=1
 s:dy<0 dy=-dy,stepy=-1
 s:dx<0 dx=-dx,stepx=-1
 s dx=2*dx
 s dy=2*dy
 do plot(ax,ay)
 i dx>dy do
 . s fraction=dy-(dx/2)
 . f  do
 .. b:ax=bx
 .. s ax=ax+stepx
 .. s:fraction'<0 ay=ay+stepy,fraction=fraction-dx
 .. s fraction=fraction+dy
 .. do plot(ax,ay)
 e do
 . s fraction=dx-(dy/2)
 . f  do
 .. b:ay=by
 .. s:fraction'<0 ax=ax+stepx,fraction=fraction-dy
 .. s ay=ay+stepy
 .. s fraction=fraction+dx
 .. do plot(ax,ay)
 q

 ; ---------- alusta piirtobufferi
initscreen()
 f y=0:1:screenheight  s screen(y)=$j("",screenwidth)
 q

 ; ---------- luo rotaatiomatriisi pyörityskulmilla
setrot(a,b,c)
 s rm(0,0)=$zcos(c)*$zcos(b)
 s rm(0,1)=(-$zsin(c)*$zcos(a))+($zcos(c)*$zsin(b)*$zsin(a))
 s rm(0,2)=($zsin(c)*$zsin(a))+($zcos(c)*$zsin(b)*$zcos(a))
 s rm(1,0)=$zsin(c)*$zcos(b)
 s rm(1,1)=($zcos(c)*$zcos(a))+($zsin(c)*$zsin(b)*$zsin(a))
 s rm(1,2)=(-$zcos(c)*$zsin(a))+($zsin(c)*$zsin(b)*$zcos(a))
 s rm(2,0)=-$zsin(b)
 s rm(2,1)=$zcos(b)*$zsin(a)
 s rm(2,2)=$zcos(b)*$zcos(a)
 q

 ; ---------- piirra piirtobufferi konsolille
showscreen()
 s buf=$chr(27)_"[2J"_$chr(27)_"[H"
 f y=0:1:screenheight  s buf=buf_screen(y)_$chr(10)
 w buf
 q
