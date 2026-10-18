-- Local correction: only legs in the second half of walk/run. Original cels stay in source_frames.
local root=app.params.output
local pc=app.pixelColor
local function image(state,i) return Image{fromFile=app.fs.joinPath(root,state,"source_frames",state.."_"..i..".png")} end
local neutral=image("idle",0)
local nearBoot=Image(neutral,Rectangle(67,88,11,8))
local farBoot=Image(neutral,Rectangle(55,88,10,8))
local ink=pc.rgba(37,24,19,255)
local brown=pc.rgba(78,54,38,255)
local green=pc.rgba(50,115,49,255)
local light=pc.rgba(72,143,57,255)
local dark=pc.rgba(30,78,37,255)
local function put(im,x,y,c) if x>=0 and x<128 and y>=0 and y<128 then im:drawPixel(math.floor(x),math.floor(y),c) end end
local function line(im,x1,y1,x2,y2,c,w)
 local n=math.max(math.abs(x2-x1),math.abs(y2-y1),1)
 for i=0,math.ceil(n) do
  local t=math.min(i/n,1);local x=math.floor(x1+(x2-x1)*t+.5);local y=math.floor(y1+(y2-y1)*t+.5)
  for dy=-math.floor(w/2),math.ceil(w/2)-1 do for dx=-math.floor(w/2),math.ceil(w/2)-1 do put(im,x+dx,y+dy,c) end end
 end
end
local poses={
 walk={{near={54,96},far={74,96}},{near={59,93},far={68,96}},{near={67,93},far={60,96}}},
 run={{near={49,87},far={77,96}},{near={58,87},far={69,96}},{near={68,90},far={58,96}},{near={77,94},far={51,87}}}
}
for _,state in ipairs({"walk","run"}) do
 local count=state=="walk" and 6 or 8
 for i=0,count-1 do
  local src=image(state,i)
  if i>=count/2 then
   -- Find green boot clusters separately from the apron, then clear their outline too.
   local seen={};local remove={}
   for y=76,95 do for x=20,105 do
    local key=y*128+x;local c=src:getPixel(x,y)
    local function isgreen(v) return pc.rgbaA(v)>0 and pc.rgbaG(v)>pc.rgbaR(v)*1.12 and pc.rgbaG(v)>pc.rgbaB(v)*1.15 and pc.rgbaG(v)>40 end
    if not seen[key] and isgreen(c) then
     local queue={key};seen[key]=true;local j=1;local maxy=y
     while j<=#queue do
      local v=queue[j];j=j+1;local xx=v%128;local yy=v//128;maxy=math.max(maxy,yy)
      for dy=-1,1 do for dx=-1,1 do
       local nx,ny=xx+dx,yy+dy;local k=ny*128+nx
       if nx>=20 and nx<=105 and ny>=76 and ny<=95 and not seen[k] and isgreen(src:getPixel(nx,ny)) then seen[k]=true;queue[#queue+1]=k end
      end end
     end
     if maxy>=90 then for _,v in ipairs(queue) do for dy=-1,1 do for dx=-1,1 do remove[(v//128+dy)*128+v%128+dx]=true end end end end
    end
   end end
   local im=Image(128,128,ColorMode.RGB)
   local pose=poses[state][i-count/2+1]
   local function leg(hip,p,far)
    local kx=hip+(p[1]-hip)*0.4;local ky=84
    line(im,hip,81,kx,ky,ink,6);line(im,hip,81,kx,ky,brown,4)
    line(im,kx,ky,p[1],p[2]-5,ink,7)
    line(im,kx,ky,p[1],p[2]-5,far and dark or green,5)
    if not far then line(im,kx-1,ky+1,p[1]-1,p[2]-6,light,1) end
    im:drawImage(far and farBoot or nearBoot,Point(p[1]-4,p[2]-8))
   end
   leg(58,pose.far,true);leg(63,pose.near,false)
   for y=0,85 do for x=0,127 do
    local c=src:getPixel(x,y)
    local keep=not remove[y*128+x]
    if y>=79 then
     local cloth=false
     for dy=-1,1 do for dx=-1,1 do
      local v=src:getPixel(math.max(0,math.min(127,x+dx)),math.max(0,math.min(127,y+dy)))
      if pc.rgbaA(v)>0 and pc.rgbaR(v)>pc.rgbaG(v)*1.15 and pc.rgbaG(v)>65 then cloth=true end
     end end
     keep=keep and (cloth or (x>=54 and x<=76 and y<=81))
    end
    if pc.rgbaA(c)>0 and keep then put(im,x,y,c) end
   end end
   src=im
  end
  src:saveAs(app.fs.joinPath(root,state,state.."_"..i..".png"))
 end
end
