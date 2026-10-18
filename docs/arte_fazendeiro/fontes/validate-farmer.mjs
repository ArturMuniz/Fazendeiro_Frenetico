import {connect,work} from './artist-client.mjs';
import {cycles} from './farmer-design.mjs';
import path from 'node:path';
import {writeFile} from 'node:fs/promises';
const {client,call}=await connect();
try{
  for(const name of Object.keys(cycles)){
    await call('sprite_manage',{op:'open',path:path.join(work,name,`fazendeiro_${name}.aseprite`)});
    const r=(await call('validate')).data;
    await writeFile(path.join(work,name,'validation.json'),JSON.stringify(r,null,2));
    console.log(JSON.stringify({state:name,passed:r.passed,findings:r.findings}));
    await call('sprite_manage',{op:'close'});
  }
}finally{await client.close();}
