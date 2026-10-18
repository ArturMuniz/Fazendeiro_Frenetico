import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';
import { writeFile, mkdir } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
export const folder = path.dirname(fileURLToPath(import.meta.url));
export const tools = path.dirname(folder);
export const project = path.join(path.dirname(tools), 'fazendeiro-caotico');
export const work = path.join(tools, 'fazendeiro-animation');
export async function connect() {
  await mkdir(work, {recursive:true});
  const transport = new StdioClientTransport({command:process.execPath,
    args:[path.join(folder,'node_modules/@pebbly/aseprite-ai-artist/dist/cli.js'),'serve'],
    env:{...process.env,ASEPRITE_AI_HEADLESS:'1',ASEPRITE_PATH:path.join(tools,'aseprite-build/bin/aseprite.exe')},stderr:'inherit'});
  const client = new Client({name:'fazendeiro-art-production',version:'1.0.0'});
  await client.connect(transport);
  async function call(name,args={}) {
    const r=await client.callTool({name,arguments:args},undefined,{timeout:120000});
    if(r.isError) throw Error(`${name}: ${JSON.stringify(r)}`);
    const d=r.structuredContent;
    if(name==='preflight' && !d?.ready) throw Error(JSON.stringify(r));
    return {result:r,data:d};
  }
  async function look(args,file) {
    const r=await call('look',args);
    const pic=r.result.content.find(c=>c.type==='image');
    if(pic) await writeFile(file,Buffer.from(pic.data,'base64'));
    return r.data;
  }
  await call('preflight');
  return {client,call,look};
}
