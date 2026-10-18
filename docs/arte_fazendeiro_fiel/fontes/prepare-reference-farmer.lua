-- All raster preparation is executed by Aseprite. Original/generated files stay intact.
local f=assert(io.open(app.params.plan,"r"));local plan=json.decode(f:read("*a"));f:close()
local out=app.params.output
app.fs.makeAllDirectories(out)
local pc=app.pixelColor
local function alpha(c) return pc.rgbaA(c) end
local function clean(im)
  for p in im:pixels() do local c=p();p(alpha(c)>=224 and pc.rgba(pc.rgbaR(c),pc.rgbaG(c),pc.rgbaB(c),255) or 0) end
  -- Remove detached generation speckles, retaining hats/tools and the fly.
  local w,h=im.width,im.height;local seen={};local groups={};local largest=0
  for y=0,h-1 do for x=0,w-1 do
    local key=y*w+x
    if not seen[key] and alpha(im:getPixel(x,y))>0 then
      local queue={key};seen[key]=true;local n=1
      while n<=#queue do
        local v=queue[n];n=n+1;local xx=v%w;local yy=v//w
        for _,d in ipairs({{-1,0},{1,0},{0,-1},{0,1}}) do
          local nx,ny=xx+d[1],yy+d[2];local k=ny*w+nx
          if nx>=0 and nx<w and ny>=0 and ny<h and not seen[k] and alpha(im:getPixel(nx,ny))>0 then seen[k]=true;queue[#queue+1]=k end
        end
      end
      groups[#groups+1]=queue;largest=math.max(largest,#queue)
    end
  end end
  for _,g in ipairs(groups) do if #g<math.max(16,largest*.0008) then for _,v in ipairs(g) do im:drawPixel(v%w,v//w,0) end end end
  return im
end
local function head_center(im)
  local b=im:shrinkBounds();local sx,n=0,0
  for y=b.y,b.y+math.floor(b.height*.25) do for x=b.x,b.x+b.width-1 do if alpha(im:getPixel(x,y))>0 then sx=sx+x;n=n+1 end end end
  return n>0 and sx/n or b.x+b.width/2
end
local states={"idle","walk","run","idle_hat","idle_swat","death"}
for _,state in ipairs(states) do
  local source=Image{fromFile=plan[state].path}
  local cut={};local heights={}
  for _,r in ipairs(plan[state].boxes) do
    local im=clean(Image(source,Rectangle(r[1],r[2],r[3],r[4])))
    local b=im:shrinkBounds();assert(b.width>0 and b.height>0,state)
    heights[#heights+1]=b.height;cut[#cut+1]={im=im,bounds=b,head=head_center(im)}
  end
  local heightsSorted={table.unpack(heights)};table.sort(heightsSorted)
  local height=state=="death" and heights[1] or heightsSorted[math.ceil(#heightsSorted/2)]
  local factor=64/height
  local folder=app.fs.joinPath(out,state);app.fs.makeAllDirectories(folder)
  app.fs.makeAllDirectories(app.fs.joinPath(folder,"source_frames"))
  for i,item in ipairs(cut) do
    local b=item.bounds;local im=Image(item.im,b)
    local nw=math.max(1,math.floor(im.width*factor+.5));local nh=math.max(1,math.floor(im.height*factor+.5))
    im:resize(nw,nh)
    local x=math.floor(64-(item.head-b.x)*factor+.5)
    if state=="death" then x=math.floor(64-nw/2) end
    local y=96-nh
    assert(x>=2 and y>=2 and x+nw<127 and y+nh<127,"clipped "..state.." "..i)
    local frame=Image(128,128,ColorMode.RGB)
    frame:drawImage(im,Point(x,y))
    frame:saveAs(app.fs.joinPath(folder,state.."_"..(i-1)..".png"))
    frame:saveAs(app.fs.joinPath(folder,"source_frames",state.."_"..(i-1)..".png"))
  end
  print(state..": "..#cut.." crops, constant factor="..factor)
end
