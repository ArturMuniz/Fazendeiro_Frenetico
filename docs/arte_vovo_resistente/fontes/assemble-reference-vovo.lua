local root=app.params.output
local pc=app.pixelColor
local cycles={
 idle={durations={220,420,100,660},loop=true},
 walk={durations={150,130,140,150,130,140},loop=true},
 run={durations={90,75,65,70,90,75,65,70},loop=true},
 idle_plant={durations={180,220,180,200,180,200,240,340},loop=false},
 death={durations={80,100,120,140,180,220},loop=false}
}
for _,state in ipairs({"idle","walk","run","idle_plant","death"}) do
 local data=cycles[state];local spr=Sprite(128,128,ColorMode.RGB)
 local used={};local colors={}
 spr.layers[1].name="Vovó — arte baseada nos anexos"
 for i,duration in ipairs(data.durations) do
  if i>1 then spr:newEmptyFrame() end
  local im=Image{fromFile=app.fs.joinPath(root,state,state.."_"..(i-1)..".png")}
  for px in im:pixels() do local c=px();if pc.rgbaA(c)>0 and not used[c] then used[c]=true;colors[#colors+1]=c end end
  spr:newCel(spr.layers[1],spr.frames[i],im,Point(0,0))
  spr.frames[i].duration=duration/1000
 end
 table.sort(colors)
 local palette=Palette();palette:resize(#colors+1);palette:setColor(0,Color{r=0,g=0,b=0,a=0})
 for i,c in ipairs(colors) do palette:setColor(i,Color{r=pc.rgbaR(c),g=pc.rgbaG(c),b=pc.rgbaB(c),a=255}) end
 spr:setPalette(palette)
 spr:newTag(1,#data.durations).name=state
 spr:saveAs(app.fs.joinPath(root,state,"vovo_"..state..".aseprite"))
 spr:close()
 print(state..": "..#data.durations.." frames assembled")
end
local f=assert(io.open(app.fs.joinPath(root,"cycles.json"),"w"));f:write(json.encode(cycles));f:close()
