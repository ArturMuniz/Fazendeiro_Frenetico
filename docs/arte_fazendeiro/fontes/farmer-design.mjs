// Pixel poses authored as shapes and clusters, painted through Aseprite's grid tool.
export const colors={
  O:'#281d22',h:'#543126',H:'#895132',L:'#ba7c43',G:'#e5aa62',
  s:'#b66240',S:'#e8955c',K:'#ffc58b',k:'#ffe0ae',
  a:'#422a26',A:'#684131',E:'#202334',W:'#fff0d3',
  b:'#273950',B:'#3f6485',C:'#6598b1',c:'#96bec6',r:'#865c5b',
  p:'#2b3f59',P:'#476587',Q:'#6e90a4',
  d:'#40282a',D:'#75462f',T:'#b17742',g:'#e8b65a',
  f:'#b5d3c2',F:'#47646a',z:'#6b5143'
};
export const layerNames=['shadow','leg-far','arm-far','torso','leg-near','head','hat','arm-near','effects'];
class Pixels {
  constructor(){this.a=Array.from({length:128},()=>Array(128).fill('.'));}
  put(x,y,c){x=Math.round(x+64);y=Math.round(y+96);if(x>=0&&x<128&&y>=0&&y<128)this.a[y][x]=c;}
  get(x,y){return this.a[y]?.[x]??'.';}
  rect(x,y,w,h,c){for(let j=0;j<h;j++)for(let i=0;i<w;i++)this.put(x+i,y+j,c);}
  line(x0,y0,x1,y1,c,w=1){const n=Math.max(Math.abs(x1-x0),Math.abs(y1-y0),1);for(let i=0;i<=n;i++)this.rect(Math.round(x0+(x1-x0)*i/n)-Math.floor(w/2),Math.round(y0+(y1-y0)*i/n)-Math.floor(w/2),w,w,c);}
  poly(pts,c){const minX=Math.floor(Math.min(...pts.map(p=>p[0]))),maxX=Math.ceil(Math.max(...pts.map(p=>p[0]))),minY=Math.floor(Math.min(...pts.map(p=>p[1]))),maxY=Math.ceil(Math.max(...pts.map(p=>p[1])));for(let y=minY;y<=maxY;y++)for(let x=minX;x<=maxX;x++){let inside=false;for(let i=0,j=pts.length-1;i<pts.length;j=i++){let [xi,yi]=pts[i],[xj,yj]=pts[j];if((yi>y+.1)!=(yj>y+.1)&&(x+.1<(xj-xi)*(y+.1-yi)/(yj-yi)+xi))inside=!inside;}if(inside)this.put(x,y,c);}}
  shape(pts,fill){this.poly(pts,fill);for(let i=0;i<pts.length;i++){const a=pts[i],b=pts[(i+1)%pts.length];this.line(...a,...b,'O');}}
  oval(cx,cy,rx,ry,c){for(let y=Math.floor(cy-ry);y<=cy+ry;y++)for(let x=Math.floor(cx-rx);x<=cx+rx;x++)if(((x-cx)/rx)**2+((y-cy)/ry)**2<=1)this.put(x,y,c);}
  grid(){let x0=128,y0=128,x1=-1,y1=-1;for(let y=0;y<128;y++)for(let x=0;x<128;x++)if(this.a[y][x]!=='.'){x0=Math.min(x0,x);y0=Math.min(y0,y);x1=Math.max(x1,x);y1=Math.max(y1,y);}if(x1<0)return null;return{kind:'grid',x:x0,y:y0,legend:colors,rows:this.a.slice(y0,y1+1).map(r=>r.slice(x0,x1+1).join(''))};}
  shifted(dx,dy){let o=new Pixels();for(let y=0;y<128;y++)for(let x=0;x<128;x++)if(this.a[y][x]!=='.')o.put(x-64+dx,y-96+dy,this.a[y][x]);return o;}
  rotated(deg,pivot=[0,-18]){let o=new Pixels(),a=deg*Math.PI/180,c=Math.cos(a),s=Math.sin(a);for(let y=0;y<128;y++)for(let x=0;x<128;x++){let dx=x-64-pivot[0],dy=y-96-pivot[1],sx=Math.round(dx*c+dy*s+pivot[0]+64),sy=Math.round(-dx*s+dy*c+pivot[1]+96);o.a[y][x]=this.get(sx,sy);}return o;}
  bottom(){for(let y=127;y>=0;y--)if(this.a[y].some(c=>c!=='.'))return y-96;return -128;}
}
function leg(q,hip,foot,far=false,bob=0,run=false){
  let [fx,fy]=foot;const hx=hip,hy=-20+bob;
  const ky=fy< -3?fy-7:(hy+fy)/2;
  const kx=fy< -3?hx+5:(hx+fx)/2;
  q.line(hx,hy,kx,ky,'O',8);q.line(kx,ky,fx,fy-5,'O',7);
  q.line(hx,hy,kx,ky,far?'p':'P',6);q.line(kx,ky,fx,fy-5,far?'p':'P',5);
  if(!far){q.line(hx-2,hy+1,kx-2,ky,'Q',2);q.line(kx-1,ky+1,fx-1,fy-6,'Q');}
  q.line(kx-2,ky+1,kx+2,ky+1,far?'O':'p');
  q.shape([[fx-4,fy-7],[fx+2,fy-7],[fx+3,fy-3],[fx+6,fy-2],[fx+6,fy],[fx-4,fy]],far?'d':'D');
  q.rect(fx-2,fy-6,3,3,far?'D':'T');q.line(fx-3,fy-1,fx+5,fy-1,far?'D':'T');
}
function arm(q,side,elbow,hand,bob=0,lean=0,far=false){
  const shoulder=[side*9+lean,-36+bob],sx=shoulder[0],sy=shoulder[1];
  q.line(sx,sy,...elbow,'O',7);q.line(...elbow,...hand,'O',5);
  q.line(sx,sy,...elbow,far?'b':'B',5);
  // Rolled cuff; forearm starts below the sleeve rather than exposing a gap.
  const mx=sx+(elbow[0]-sx)*.72,my=sy+(elbow[1]-sy)*.72;
  q.line(mx,my,...elbow,far?'B':'C',5);
  q.line(...elbow,...hand,far?'s':'S',3);
  if(!far)q.line(elbow[0]-1,elbow[1],hand[0]-1,hand[1],'K');
  q.oval(hand[0],hand[1],2.2,2.6,'O');q.oval(hand[0],hand[1]-.3,1.4,1.8,far?'S':'K');
  q.put(hand[0]+1,hand[1]+1,'s');
}
function torso(q,bob=0,lean=0){
  const sh=(x,y)=>[x+lean,y+bob];
  q.shape([sh(-8,-39),sh(6,-39),sh(10,-35),[7,-20+bob],[-7,-20+bob],sh(-10,-34)],'B');
  q.poly([sh(-8,-36),sh(-4,-36),[-4,-21+bob],[-7,-21+bob]],'C');
  q.poly([sh(5,-36),sh(9,-34),[7,-21+bob],[4,-21+bob]],'b');
  for(let y of[-34,-28,-23])q.line(-7+lean,y+bob,7+lean,y+bob,'c');
  for(let y of[-33,-27])q.line(-7+lean,y+bob,7+lean,y+bob,'r');
  q.line(-4+lean,-35+bob,-4,-22+bob,'b');q.line(3+lean,-35+bob,3,-22+bob,'b');
  q.line(lean,-34+bob,0,-22+bob,'O');
  q.shape([sh(-5,-39),sh(0,-35),sh(4,-39)],'s');
  q.line(-6+lean,-37+bob,-2+lean,-34+bob,'c');q.line(4+lean,-38+bob,1+lean,-34+bob,'C');
  q.rect(-6+lean,-31+bob,3,3,'B');q.line(-6+lean,-31+bob,-3+lean,-31+bob,'b');
  q.put(1+lean,-30+bob,'W');q.put(1+lean,-25+bob,'W');
  q.rect(-7,-21+bob,15,3,'O');q.rect(-6,-20+bob,13,1,'h');q.rect(-1,-21+bob,4,3,'g');q.rect(0,-20+bob,2,1,'h');
}
function head(q,bob=0,lean=0,expression='normal',look=0){
  const o=(x,y)=>[x+lean,y+bob];
  q.rect(-2+lean,-41+bob,6,4,'s');q.rect(-1+lean,-41+bob,3,3,'S');
  q.shape([o(-7,-55),o(-2,-58),o(6,-56),o(10,-52),o(9,-43),o(5,-39),o(-2,-39),o(-7,-43)],'a');
  q.oval(-7+lean,-47+bob,2,3,'O');q.oval(-7+lean,-47+bob,1,2,'S');
  q.shape([o(-5,-53),o(6,-53),o(8,-49),o(8,-43),o(4,-40),o(-2,-40),o(-5,-44)],'S');
  q.poly([o(-4,-52),o(2,-52),o(4,-49),o(2,-43),o(-2,-42),o(-4,-45)],'K');
  q.rect(-3+lean,-51+bob,4,2,'k');
  q.poly([o(-6,-55),o(7,-55),o(6,-51),o(3,-52),o(0,-51),o(-2,-53),o(-4,-49),o(-6,-47)],'a');
  q.line(-5+lean,-53+bob,-1+lean,-54+bob,'A');
  if(expression==='dead'){
    for(let ex of[-1,5]){q.line(ex-1+lean,-49+bob,ex+1+lean,-47+bob,'E');q.line(ex-1+lean,-47+bob,ex+1+lean,-49+bob,'E');}
  }else if(expression==='blink'){
    q.line(-3+lean,-48+bob,-1+lean,-48+bob,'E');q.line(4+lean,-48+bob,6+lean,-48+bob,'E');
  }else{
    q.rect(-3+lean+look,-49+bob,3,3,'W');q.rect(4+lean+look,-49+bob,2,3,'W');
    q.rect(-2+lean+look,-49+bob,2,3,'E');q.rect(5+lean+look,-49+bob,1,3,'E');
    q.line(-4+lean,-51+bob,-1+lean,-51+bob,'a');q.line(4+lean,-51+bob,6+lean,-50+bob,'a');
  }
  q.line(3+lean,-47+bob,4+lean,-45+bob,'s');q.put(4+lean,-45+bob,'k');
  if(expression==='shock')q.oval(3+lean,-42+bob,1,1,'O');
  else{q.line(1+lean,-42+bob,4+lean,-42+bob,'s');q.put(5+lean,-43+bob,'s');}
}
function hat(q,bob=0,lean=0,lift=0){
  const o=(x,y)=>[x+lean,y+bob-lift];
  q.shape([o(-11,-57),o(-9,-62),o(-5,-66),o(4,-66),o(9,-62),o(11,-57)],'H');
  q.poly([o(-8,-62),o(-4,-65),o(2,-65),o(6,-62),o(5,-59),o(-8,-59)],'L');
  q.line(-5+lean,-64+bob-lift,3+lean,-64+bob-lift,'G');
  q.rect(-10+lean,-59+bob-lift,21,3,'h');q.rect(-8+lean,-59+bob-lift,12,1,'H');
  q.shape([o(-17,-56),o(-11,-59),o(-4,-58),o(7,-58),o(16,-55),o(17,-53),o(9,-52),o(2,-54),o(-7,-53),o(-15,-53)],'H');
  q.line(-14+lean,-56+bob-lift,-7+lean,-57+bob-lift,'G');q.line(-6+lean,-57+bob-lift,5+lean,-56+bob-lift,'L');
  q.line(6+lean,-55+bob-lift,13+lean,-54+bob-lift,'L');q.put(-12+lean,-54+bob-lift,'L');
}
const WALK=[[10,0],[6,0],[1,0],[-5,0],[-10,0],[-7,-5],[1,-8],[7,-5]];
const RUN=[[6,0],[-2,0],[-11,0],[-10,-10],[-2,-16],[9,-10],[14,-5],[11,-2]];
export function pose(state,i){
  const p=Object.fromEntries(layerNames.map(n=>[n,new Pixels()]));
  let bob=0,lean=0,lift=0,expression='normal',look=0;
  let near=[5,0],far=[-5,0],nearElbow=[11,-28],nearHand=[12,-20],farElbow=[-11,-28],farHand=[-10,-21];
  if(state==='idle'){bob=[0,0,-1,-1,-1,0,0,0][i];expression=i===5?'blink':'normal';}
  if(state==='walk'||state==='run'){
    const run=state==='run',table=run?RUN:WALK;near=table[i];far=table[(i+4)%8];bob=(run?[0,2,0,-3,0,2,0,-3]:[0,1,-1,-2,0,1,-1,-2])[i];lean=run?3:0;
    const swing=(near[0]-far[0])/2;
    nearElbow=[11+lean-swing*.45,-28+bob];farElbow=[-10+lean+swing*.45,-28+bob];
    nearHand=[11+lean-swing*.85,(run?-34:-20)+bob];farHand=[-10+lean+swing*.85,(run?-34:-20)+bob];
  }
  if(state==='idle_hat'){
    const t=[0,0,.25,.5,.8,1,1,1,1,.7,.4,.2,0,0][i];
    nearElbow=[11+5*t,-28-14*t];nearHand=[12-2*t,-20-34*t];
    lift=[0,0,0,0,0,1,3,3,1,0,0,0,0,0][i];
    expression=i===7||i===8?'blink':'normal';
  }
  if(state==='idle_swat'){
    const hands=[[12,-20],[12,-20],[14,-25],[17,-33],[18,-43],[12,-49],[19,-43],[22,-35],[14,-42],[11,-47],[17,-34],[14,-27],[12,-20],[12,-20]];
    nearHand=hands[i];nearElbow=[14,-29-Math.max(0,(-nearHand[1]-25)*.3)];look=i>1&&i<10?1:0;expression=i===5||i===9?'blink':'normal';
    if(i>0&&i<11){const fx=[0,18,21,24,25,21,16,20,26,28,30][i],fy=[0,-57,-59,-57,-53,-52,-55,-60,-61,-56,-51][i];p.effects.oval(fx,fy,2,1,'f');p.effects.rect(fx-1,fy+1,2,2,'O');p.effects.put(fx+1,fy,'F');}
  }
  if(state==='death'){
    expression=i<4?'shock':'dead';bob=i===1?1:0;
    nearHand=[12+i*.5,-20-Math.min(i,4)*3];farHand=[-11-i*.5,-21-Math.min(i,4)*2];
    if(i>=6){nearElbow=[8,-28];nearHand=[5,-31];farElbow=[-7,-28];farHand=[-4,-31];}
  }
  p.shadow.oval(0,0,14,2,'z');
  leg(p['leg-far'],-4,far,true,bob,state==='run');
  arm(p['arm-far'],-1,farElbow,farHand,bob,lean,true);
  leg(p['leg-near'],4,near,false,bob,state==='run');
  torso(p.torso,bob,lean);
  head(p.head,bob,lean,expression,look);hat(p.hat,bob+(state==='run'&&[1,5].includes(i)?-1:0),lean,lift);
  arm(p['arm-near'],1,nearElbow,nearHand,bob,lean,false);
  if(state==='death'){
    const angle=[0,-5,-12,10,25,45,70,88,92,88,90,90][i];
    const names=layerNames.filter(n=>!['shadow','effects','hat'].includes(n));
    for(const n of names)p[n]=p[n].rotated(angle);
    const bottom=Math.max(...names.map(n=>p[n].bottom()));
    for(const n of names)p[n]=p[n].shifted(i>4?5:0,-bottom);
    if(i<4)p.hat=p.hat.rotated(angle).shifted(0,-bottom);
    else {const dx=[-7,-12,-18,-23,-28,-28,-27,-27][i-4],dy=[-6,0,10,24,40,54,57,57][i-4];p.hat=p.hat.rotated(-15,[0,-59]).shifted(dx,dy);}
    if(i>=7&&i<=9){for(const[x,y]of[[-16,-4],[34,-4],[40,-2]])p.effects.rect(x,y,2,1,'L');}
    // Ground shadow remains anchored; the fallen body extends to the right.
    if(i>=6){p.shadow=new Pixels();p.shadow.oval(17,0,32,2,'z');}
  }
  return p;
}
export const cycles={
  idle:{durations:[220,180,180,200,180,90,100,250],loop:true},
  walk:{durations:[100,90,85,90,100,90,85,90],loop:true},
  run:{durations:[75,65,60,65,75,65,60,65],loop:true},
  idle_hat:{durations:[90,80,70,70,80,100,110,110,100,80,70,70,80,90],loop:false},
  idle_swat:{durations:[90,100,80,75,70,65,65,70,65,65,75,80,90,100],loop:false},
  death:{durations:[60,60,60,70,60,70,60,80,80,70,80,90],loop:false}
};
