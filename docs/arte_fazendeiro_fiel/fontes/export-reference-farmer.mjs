import {connect,tools} from './artist-client.mjs';
import path from 'node:path';
import {writeFile} from 'node:fs/promises';
const root=path.join(tools,'fazendeiro-reference');
const {client,call,look}=await connect();
try{
  for(const state of ['idle','walk','run','idle_hat','idle_swat','death']){
    const dir=path.join(root,state);
    await call('sprite_manage',{op:'open',path:path.join(dir,`fazendeiro_${state}.aseprite`)});
    await look({op:'filmstrip',scale:4},path.join(dir,`${state}_filmstrip.png`));
    await look({op:'preview',frame:1,scale:5},path.join(dir,`${state}_preview.png`));
    await call('export',{op:'spritesheet',path:path.join(dir,`${state}_sheet.png`),sheetType:'rows',padding:0,includeJson:true});
    await call('export',{op:'gif',path:path.join(dir,`${state}.gif`),scale:4});
    const data=(await call('validate')).data;
    await writeFile(path.join(dir,'validation.json'),JSON.stringify(data,null,2));
    console.log(JSON.stringify({state,passed:data.passed,errors:data.findings.filter(f=>f.severity==='error').length,warnings:data.findings.filter(f=>f.severity==='warning').length}));
    await call('sprite_manage',{op:'close'});
  }
}finally{await client.close();}
