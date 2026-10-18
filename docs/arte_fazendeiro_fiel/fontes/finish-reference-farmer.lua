-- Preserve generated/reference face, clothes and trowel; articulate the run legs.
local root=app.params.output
local pc=app.pixelColor
local function image(state,i) return Image{fromFile=app.fs.joinPath(root,state,state.."_"..i..".png")} end
local neutral=image("idle",0)
local bootNear=Image(neutral,Rectangle(67,87,12,10))
local bootFar=Image(neutral,Rectangle(54,87,12,10))
local ink=pc.rgba(27,21,29,255)
local mid=pc.rgba(67,96,139,255)
local light=pc.rgba(91,130,167,255)
local dark=pc.rgba(39,62,108,255)
local function put(im,x,y,c)
  x=math.floor(x+.5);y=math.floor(y+.5)
  if x>=0 and x<128 and y>=0 and y<128 then im:drawPixel(x,y,c) end
end
local function line(im,x1,y1,x2,y2,color,width)
  local n=math.max(math.abs(x2-x1),math.abs(y2-y1),1)
  for i=0,math.ceil(n) do
    local t=math.min(i/n,1);local x=x1+(x2-x1)*t;local y=y1+(y2-y1)*t
    for dy=-math.floor(width/2),math.ceil(width/2)-1 do for dx=-math.floor(width/2),math.ceil(width/2)-1 do put(im,x+dx,y+dy,color) end end
  end
end
local feet={{5,96},{-2,96},{-11,96},{-10,86},{-2,80},{9,86},{14,91},{11,94}}
local bob={0,1,-1,-3,0,1,-1,-3}
local originals={};for i=0,7 do originals[i+1]=Image{fromFile=app.fs.joinPath(root,"run","source_frames","run_"..i..".png")} end
local function leg(im,hip,p,far,b)
  local fx,fy=hip+p[1],p[2]
  local kx=fy<92 and hip+5 or (hip+fx)/2
  local ky=fy<92 and fy-7 or 84+b
  line(im,hip,75+b,kx,ky,ink,8);line(im,kx,ky,fx,fy-7,ink,7)
  line(im,hip,75+b,kx,ky,far and dark or mid,6);line(im,kx,ky,fx,fy-7,far and dark or mid,5)
  if not far then line(im,hip-2,76+b,kx-2,ky,light,2);line(im,kx-1,ky+1,fx-1,fy-8,light,1) end
  line(im,kx-2,ky+1,kx+2,ky+1,dark,1)
  im:drawImage(far and bootFar or bootNear,Point(fx-5,fy-10))
end
for i=0,7 do
  local src=originals[i+1];local im=Image(128,128,ColorMode.RGB)
  leg(im,57,feet[(i+4)%8+1],true,bob[i+1]);leg(im,64,feet[i+1],false,bob[i+1])
  -- Head, hat, plaid shirt and arms remain actual pixels of the reference model.
  for y=0,74 do for x=0,127 do
    local c=src:getPixel(x,y)
    if pc.rgbaA(c)>0 then put(im,x,y+bob[i+1],c) end
  end end
  -- The real metal trowel projects below the belt. Do not clip it with the legs.
  for y=73,80 do for x=40,56 do local c=src:getPixel(x,y);if pc.rgbaA(c)>0 then put(im,x,y+bob[i+1],c) end end end
  im:saveAs(app.fs.joinPath(root,"run","run_"..i..".png"))
end
local cycles={
 idle={durations={220,420,100,660},loop=true},
 walk={durations={120,110,120,130,110,140},loop=true},
 run={durations={75,65,60,65,75,65,60,65},loop=true},
 idle_hat={durations={90,110,130,180,240,170,150,130},loop=false},
 idle_swat={durations={120,150,130,120,110,140,140,180},loop=false},
 death={durations={140,180,220,300},loop=false}
}
for _,state in ipairs({"idle","walk","run","idle_hat","idle_swat","death"}) do
  local data=cycles[state];local spr=Sprite(128,128,ColorMode.RGB)
  local used={};local colors={}
  spr.layers[1].name="Arte fiel às referências"
  for i,duration in ipairs(data.durations) do
    if i>1 then spr:newEmptyFrame() end
    local frameImage=image(state,i-1)
    for px in frameImage:pixels() do local c=px();if pc.rgbaA(c)>0 and not used[c] then used[c]=true;colors[#colors+1]=c end end
    spr:newCel(spr.layers[1],spr.frames[i],frameImage,Point(0,0))
    spr.frames[i].duration=duration/1000
  end
  table.sort(colors)
  local palette=Palette();palette:resize(#colors+1);palette:setColor(0,Color{r=0,g=0,b=0,a=0})
  for i,c in ipairs(colors) do palette:setColor(i,Color{r=pc.rgbaR(c),g=pc.rgbaG(c),b=pc.rgbaB(c),a=255}) end
  spr:setPalette(palette)
  spr:newTag(1,#data.durations).name=state
  spr:saveAs(app.fs.joinPath(root,state,"fazendeiro_"..state..".aseprite"))
  spr:close()
  print(state..": "..#data.durations.." frames assembled")
end
local f=assert(io.open(app.fs.joinPath(root,"cycles.json"),"w"));f:write(json.encode(cycles));f:close()
