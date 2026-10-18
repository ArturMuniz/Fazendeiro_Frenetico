-- All raster operations run in Aseprite; source PNG/JPG files remain untouched.
local f=assert(io.open(app.params.plan,"r"));local plan=json.decode(f:read("*a"));f:close()
local out=app.params.output;app.fs.makeAllDirectories(out)
local pc=app.pixelColor;local result={};local sources={}
local function round(v) return math.floor(v+.5) end
local function read(path) sources[path]=true;return Image{fromFile=path} end
local function blank(w,h) return Image(w,h,ColorMode.RGB) end
local function clean(im)
 for p in im:pixels() do local c=p();local r,g,b=pc.rgbaR(c),pc.rgbaG(c),pc.rgbaB(c)
  if pc.rgbaA(c)<224 or (r>g*1.45+15 and b>g*1.45+15 and math.min(r,b)>50) then p(0)
  else p(pc.rgba(r,g,b,255)) end
 end
 return im
end
local function crop(path,rect)
 local im=read(path)
 if rect then im=Image(im,Rectangle(round(rect[1]*im.width),round(rect[2]*im.height),round((rect[3]-rect[1])*im.width),round((rect[4]-rect[2])*im.height))) end
 clean(im);local b=im:shrinkBounds();assert(b.width>0,path);return Image(im,b)
end
local function place(im,w,h,feet,factor)
 local img=Image(im);img:resize(math.max(1,round(img.width*factor)),math.max(1,round(img.height*factor)))
 local frame=blank(w,h);local x=round(w/2-img.width/2);local y=feet-img.height
 assert(x>=2 and y>=2 and x+img.width<=w-2 and y+img.height<=h-2,"clipped source")
 frame:drawImage(img,Point(x,y));return frame
end
local function shift_parts(im,fn)
 local dst=blank(im.width,im.height)
 for p in im:pixels() do local c=p();if pc.rgbaA(c)>0 then local x,y=fn(p.x,p.y,c)
  if x>=1 and y>=1 and x<im.width-1 and y<im.height-1 then dst:drawPixel(round(x),round(y),c) end
 end end
 return dst
end
local function breathing(im,dy,split)
 local dst=blank(im.width,im.height)
 -- Inverse sampling keeps the join filled when the upper body moves.
 for y=1,im.height-2 do for x=1,im.width-2 do
  local sy=y-round(dy*math.max(0,math.min(1,(split-y)/10)))
  if sy>=0 and sy<im.height then dst:drawPixel(x,y,im:getPixel(x,sy)) end
 end end
 return dst
end
local function topple(im,angle,drop)
 local b=im:shrinkBounds();local cx=b.x+b.width/2;local cy=b.y+b.height/2
 local dst=blank(im.width,im.height);local cs,sn=math.cos(angle),math.sin(angle)
 for y=1,im.height-2 do for x=1,im.width-2 do
  local dx,dy=x-cx,y-cy-drop;local sx=round(cs*dx+sn*dy+cx);local sy=round(-sn*dx+cs*dy+cy)
  if sx>=0 and sy>=0 and sx<im.width and sy<im.height then dst:drawPixel(x,y,im:getPixel(sx,sy)) end
 end end
 return dst
end
local function wing_pose(im,phase,cut,amp,bob)
 return shift_parts(im,function(x,y,c)
  if y<cut then
   local weight=(cut-y)/math.max(1,cut-im:shrinkBounds().y)
   return x+round(phase*amp*weight*(x<im.width/2 and -1 or 1)), y+round(math.abs(phase)*amp*weight)+bob
  end
  return x,y+bob
 end)
end
local function cycle(entity,state,images,durations,loop,offset)
 -- Copy into a Lua array: decoded JSON arrays are userdata in Aseprite.
 offset={0,entity=="netinho" and -32 or (images[1].width==256 and -24 or -16)}
 local folder=app.fs.joinPath(out,entity,state);app.fs.makeAllDirectories(folder)
 local spr=Sprite(images[1].width,images[1].height,ColorMode.RGB)
 spr.layers[1].name="corpo-original"
 local upper=spr:newLayer();upper.name="partes-secundarias"
 local used,colors={},{}
 for i,im in ipairs(images) do
  if i>1 then spr:newEmptyFrame() end
  clean(im)
  if state=="death" and (entity=="mosca" or entity=="gafanhoto") then
   local isolated={}
   for p in im:pixels() do if pc.rgbaA(p())>0 then
    local neighbours=0
    for dy=-1,1 do for dx=-1,1 do
     local x,y=p.x+dx,p.y+dy
     if (dx~=0 or dy~=0) and x>=0 and y>=0 and x<im.width and y<im.height and pc.rgbaA(im:getPixel(x,y))>0 then neighbours=neighbours+1 end
    end end
    if neighbours==0 then isolated[#isolated+1]={p.x,p.y} end
   end end
   for _,p in ipairs(isolated) do im:drawPixel(p[1],p[2],0) end
  end
  local b=im:shrinkBounds();assert(b.x>0 and b.y>0 and b.x+b.width<im.width and b.y+b.height<im.height,entity..state)
  local body=blank(im.width,im.height);local secondary=blank(im.width,im.height)
  local split=b.y+round(b.height*.35)
  for p in im:pixels() do local c=p();if pc.rgbaA(c)>0 then
   (p.y<split and secondary or body):drawPixel(p.x,p.y,c)
   if not used[c] then used[c]=true;colors[#colors+1]=c end
  end end
  spr:newCel(spr.layers[1],spr.frames[i],body,Point(0,0))
  spr:newCel(upper,spr.frames[i],secondary,Point(0,0))
  spr.frames[i].duration=durations[i]/1000
  im:saveAs(app.fs.joinPath(folder,entity.."_"..state.."_"..string.format("%02d",i-1)..".png"))
 end
 table.sort(colors);local pal=Palette();pal:resize(#colors+1);pal:setColor(0,Color{r=0,g=0,b=0,a=0})
 for i,c in ipairs(colors) do pal:setColor(i,Color{r=pc.rgbaR(c),g=pc.rgbaG(c),b=pc.rgbaB(c),a=255}) end
 spr:setPalette(pal);spr:newTag(1,#images).name=state
 spr:saveAs(app.fs.joinPath(folder,entity.."_"..state..".aseprite"));spr:close()
 result[entity]=result[entity] or {};local paths={}
 for i=1,#images do paths[i]="res://art/atores_polidos/"..entity.."_"..state.."_"..string.format("%02d",i-1)..".png" end
 result[entity][state]={frames=paths,durations_ms=durations,fps=#images/(function() local n=0;for _,v in ipairs(durations) do n=n+v end;return n/1000 end)(),loop=loop,offset=offset}
 print(entity.." "..state.." "..#images.." frames")
end
local function originals(entity,state)
 local images={};for _,p in ipairs(plan.actors[entity][state].frames) do images[#images+1]=read(p) end;return images
end
-- Netinho: recrop the supplied high-resolution family at one scale per cycle.
local net={}
for _,state in ipairs({"idle","walk","death"}) do
 local raws={};for _,entry in ipairs(plan.netinho[state]) do raws[#raws+1]=crop(entry.path,entry.crop) end
 local factor=state=="death" and 96/raws[1].height or (state=="idle" and 96/raws[2].height or 96/894)
 net[state]={};for _,raw in ipairs(raws) do net[state][#net[state]+1]=place(raw,128,128,112,factor) end
end
local base=net.idle[2]
cycle("netinho","idle",{base,breathing(base,-1,88),breathing(base,-1,83),base},{320,180,220,480},true,{0,-32})
-- One original torso/view throughout; alternating articulated legs complete the gait.
local function nearest(im,r,g,b)
 local best,dist=0,math.huge
 for p in im:pixels() do local c=p();if pc.rgbaA(c)>0 then
  local d=(pc.rgbaR(c)-r)^2+(pc.rgbaG(c)-g)^2+(pc.rgbaB(c)-b)^2
  if d<dist then best,dist=c,d end
 end end;return best
end
local ink=nearest(base,40,24,24);local skin=nearest(base,209,150,104);local sock=nearest(base,219,206,168);local blue=nearest(base,53,84,107)
local bootNear=Image(base,Rectangle(65,102,15,10));local bootFar=Image(bootNear);bootFar:resize(12,10)
local function line(im,x1,y1,x2,y2,c,w)
 local n=math.max(1,math.abs(x2-x1),math.abs(y2-y1))
 for k=0,math.ceil(n) do local t=k/n;local xx,yy=round(x1+(x2-x1)*t),round(y1+(y2-y1)*t)
  for dy=-w//2,(w-1)//2 do for dx=-w//2,(w-1)//2 do
   if xx+dx>0 and xx+dx<127 and yy+dy>0 and yy+dy<127 then im:drawPixel(xx+dx,yy+dy,c) end
  end end
 end
end
local function gait(running)
 local frames={};local feet=running and {{76,112},{69,112},{58,111},{51,108},{50,103},{58,102},{70,105},{77,109}} or {{72,112},{66,112},{58,112},{52,110},{51,106},{58,104},{67,107},{73,110}}
 local bob=running and {0,1,0,-2,-3,-2,-1,0} or {0,1,0,-1,-1,0,0,0}
 for i=1,8 do local im=blank(128,128);local shift=bob[i]
  local function leg(hip,p,far)
   local hx,hy=hip,85+shift;local ax,ay=p[1],p[2]-8
   local dx,dy=ax-hx,ay-hy;local dist=math.sqrt(dx*dx+dy*dy)
   if dist>23.8 then ax=hx+dx/dist*23.8;ay=hy+dy/dist*23.8;dx,dy=ax-hx,ay-hy;dist=23.8 end
   local bend=math.sqrt(math.max(0,12*12-dist*dist/4))
   local kx,ky=(hx+ax)/2+dy/dist*bend,(hy+ay)/2-dx/dist*bend
   line(im,hx,hy,kx,ky,ink,7);line(im,hx,hy,kx,ky,blue,5)
   line(im,kx,ky,ax,ay,ink,6);line(im,kx,ky,ax,ay,skin,4)
   line(im,p[1],p[2]-12,p[1],p[2]-7,sock,4)
   im:drawImage(far and bootFar or bootNear,Point(round(ax)-(far and 5 or 6),round(ay)-2))
  end
  leg(54,feet[(i+3)%8+1],true);leg(65,feet[i],false)
  for y=0,85 do for x=0,127 do local c=base:getPixel(x,y);if pc.rgbaA(c)>0 then im:drawPixel(x,y+shift,c) end end end
  -- Original hand and slingshot remain connected beside the shorts.
  for y=86,94 do for x=79,94 do local c=base:getPixel(x,y);if pc.rgbaA(c)>0 then im:drawPixel(x,y+shift,c) end end end
  frames[i]=im
 end;return frames
end
cycle("netinho","walk",gait(false),{115,100,100,110,115,100,100,110},true,{0,-32})
cycle("netinho","run",gait(true),{80,65,60,65,80,65,60,65},true,{0,-32})
cycle("netinho","death",net.death,{130,180,220,360},false,{0,-32})
-- Small grounded creatures: planted contacts, local motion instead of size pulses.
for _,id in ipairs({"pulgao","lesma","boss_lagarta","gafanhoto"}) do
 local im=read(plan.actors[id].idle.frames[1]);local b=im:shrinkBounds();local cut=b.y+round(b.height*.72)
 cycle(id,"idle",{im,breathing(im,-1,cut),breathing(im,-1,cut-2),im},{280,160,220,340},true,plan.actors[id].idle.offset)
end
local aphidRaw={};for i=0,3 do aphidRaw[i+1]=crop(plan.aphid_walk,{i/4+.014,.03,(i+1)/4-.014,.75}) end
local aphids={};local factor=27/aphidRaw[1].height
local aphid=read(plan.actors.pulgao.idle.frames[1])
for i=1,4 do aphids[i]=breathing(aphid,({0,-1,0,1})[i],62) end
cycle("pulgao","walk",aphids,{100,80,100,80},true,{0,-16})
local deathRaw={};local boxes={{0,0,.5,.5},{.5,0,1,.5},{0,.5,.5,1},{.5,.5,1,1}}
for _,box in ipairs(boxes) do deathRaw[#deathRaw+1]=crop(plan.aphid_death,box) end
local dying={};factor=31/deathRaw[1].height
for i=1,4 do dying[i]=topple(aphid,({0,-.35,-1.1,-1.5})[i],({0,2,6,7})[i]) end
cycle("pulgao","death",dying,{70,90,110,160},false,{0,-16})
for _,id in ipairs({"lesma","boss_lagarta"}) do
 local im=read(plan.actors[id].idle.frames[1]);local b=im:shrinkBounds();local frames={}
 local n=id=="lesma" and 6 or 8
 for i=1,n do frames[i]=shift_parts(im,function(x,y,c)
  if y>b.y+b.height*.68 then
   return x,y+round(math.sin((x-b.x)/math.max(1,b.width)*math.pi*2+(i-1)/n*math.pi*2))
  elseif id=="boss_lagarta" and x<b.x+b.width*.55 then
   return x,y+round(math.sin((x-b.x)/b.width*math.pi*2+(i-1)/n*math.pi*2))
  end
  return x,y
 end) end
 cycle(id,"walk",frames,id=="lesma" and {150,110,130,150,110,130} or {130,100,100,120,130,100,100,120},true,plan.actors[id].idle.offset)
end
-- Stable body mass, wing silhouettes change independently.
for _,id in ipairs({"mosca","boss_rainha_moscas"}) do
 local im=read(plan.actors[id].idle.frames[1]);local cut=id=="mosca" and 46 or 125;local amp=id=="mosca" and 3 or 6
 local imgs={};local phases={0,1,0,-1,0,1}
 for i,p in ipairs(phases) do imgs[i]=wing_pose(im,p,cut,amp,({0,-1,-1,0,1,0})[i]) end
 cycle(id,"idle",{imgs[1],imgs[2],imgs[3],imgs[4]},{100,70,90,80},true,plan.actors[id].idle.offset)
 cycle(id,"walk",imgs,{80,60,70,80,60,70},true,plan.actors[id].idle.offset)
 local attack={imgs[1],wing_pose(im,1,cut,amp,0),breathing(im,1,cut+12),imgs[1]};local durations={65,80,80,150}
 cycle(id,"attack",attack,durations,false,plan.actors[id].attack.offset)
 local death={};durations={70,90,120,180}
 for i=1,4 do death[i]=topple(im,({0,.3,1.0,1.5})[i],({0,2,5,8})[i]*(id=="mosca" and 1 or 2)) end
 cycle(id,"death",death,durations,false,plan.actors[id].death.offset)
end
-- Hopper crouch uses a single source scale, not a height-normalized second pose.
local h0=crop(plan.hopper,{0,.05,.5,.92});local h1=crop(plan.hopper,{.5,.05,1,.92});factor=33/h0.height
local normal=place(h0,96,96,64,factor);local crouch=place(h1,96,96,64,factor)
cycle("gafanhoto","idle",{normal,breathing(normal,-1,58),normal,breathing(normal,1,58)},{280,160,220,340},true,{0,-16})
cycle("gafanhoto","anticipate",{normal,breathing(normal,1,58),breathing(normal,3,58)},{60,60,80},false,{0,-16})
cycle("gafanhoto","jump",{normal,breathing(normal,-1,58),normal,breathing(normal,1,58)},{75,85,85,105},false,{0,-16})
cycle("gafanhoto","land",{breathing(normal,3,58),breathing(normal,1,58),normal},{70,70,100},false,{0,-16})
local d=originals("gafanhoto","death");cycle("gafanhoto","death",d,{65,85,110,160},false,{0,-16})
-- Giant: canonical art has no cell borders and includes both feet and fists.
local raw=crop(plan.giant);local giant=place(raw,256,256,176,108/raw.height)
cycle("boss_gafanhoto_gigante","idle",{giant,breathing(giant,-1,158),breathing(giant,-2,154),breathing(giant,-1,158)},{240,180,260,180},true,{0,-24})
cycle("boss_gafanhoto_gigante","anticipate",{giant,breathing(giant,2,164),breathing(giant,3,164)},{70,80,90},false,{0,-24})
cycle("boss_gafanhoto_gigante","jump",{breathing(giant,-2,164),breathing(giant,-3,164),breathing(giant,-1,164),giant},{70,90,100,140},false,{0,-24})
cycle("boss_gafanhoto_gigante","land",{breathing(giant,3,164),breathing(giant,1,164),giant},{90,110,140},false,{0,-24})
local file=assert(io.open(app.fs.joinPath(out,"catalog.json"),"w"));file:write(json.encode(result));file:close()
local paths={};for path in pairs(sources) do paths[#paths+1]=path end;table.sort(paths)
file=assert(io.open(app.fs.joinPath(out,"sources.json"),"w"));file:write(json.encode(paths));file:close()
