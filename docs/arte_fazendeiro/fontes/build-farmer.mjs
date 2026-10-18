import {connect,work} from './artist-client.mjs';
import {colors,layerNames,pose,cycles} from './farmer-design.mjs';
import path from 'node:path';
import {mkdir,writeFile} from 'node:fs/promises';
const draft=process.argv.includes('--draft');
const plans=draft?{draft:{keys:[['idle',0],['idle',5],['walk',0],['walk',2],['walk',4],['walk',6],['run',0],['run',2],['run',3],['run',4],['idle_hat',6],['idle_swat',5],['death',4],['death',7],['death',11]],durations:Array(15).fill(120),loop:false}}:cycles;
const {client,call,look}=await connect();
const reports={};
try {
  for(const[state,cycle]of Object.entries(plans)){
    await call('sprite_manage',{op:'new',width:128,height:128,colorMode:'rgb'});
    const info=(await call('sprite_info')).data;
    await call('palette',{op:'set',replace:true,colors:['#00000000',...Object.values(colors)]});
    await call('layer',{batch:[{op:'rename',name:info.layers[0].name,newName:layerNames[0]},...layerNames.slice(1).map(name=>({op:'create',name}))]});
    await call('frame',{op:'add',count:cycle.durations.length-1});
    for(let i=0;i<cycle.durations.length;i++){
      const[s,n]=cycle.keys?.[i]??[state,i],parts=pose(s,n);
      for(const name of layerNames){const grid=parts[name].grid();if(grid)await call('draw',{frame:i+1,layer:name,ops:[grid],label:`${s} / pose ${n+1} / ${name}`});}
    }
    await call('frame',{op:'set_duration',durations:cycle.durations});
    await call('tag',{op:'create',name:state,from:1,to:cycle.durations.length,direction:'forward'});
    const dir=path.join(work,state);await mkdir(dir,{recursive:true});
    await call('sprite_manage',{op:'save_as',path:path.join(dir,`fazendeiro_${state}.aseprite`)});
    await look({op:'filmstrip',scale:3},path.join(dir,`${state}_filmstrip.png`));
    await look({op:'preview',frame:1,scale:4},path.join(dir,`${state}_preview.png`));
    if(!draft){
      await call('export',{op:'spritesheet',path:path.join(dir,`${state}_sheet.png`),sheetType:'rows',includeJson:true,padding:0});
      await call('export',{op:'frames',path:path.join(dir,`${state}_{frame}.png`)});
      await call('export',{op:'gif',path:path.join(dir,`${state}.gif`),scale:3});
      reports[state]=(await call('validate',{checks:['palette','antialiasing','layers','animation','export_readiness']})).data;
      await writeFile(path.join(dir,'validation.json'),JSON.stringify(reports[state],null,2));
    }
    await call('sprite_manage',{op:'close'});
    console.log(`${state}: ${cycle.durations.length} frames painted and saved`);
  }
  if(!draft)await writeFile(path.join(work,'cycles.json'),JSON.stringify(cycles,null,2));
} finally {await client.close();}
