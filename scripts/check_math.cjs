/* Compile every Pandoc math node using the bundled renderer's TeX version.
 * This checks mathematical syntax and macros; it does not prove physics
 * or substitute for browser layout inspection. npm ci, then npm run check:math.
 */
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const {spawnSync} = require('node:child_process');
const {mathjax} = require('mathjax-full/js/mathjax.js');
const {TeX} = require('mathjax-full/js/input/tex.js');
const {SVG} = require('mathjax-full/js/output/svg.js');
const {liteAdaptor} = require('mathjax-full/js/adaptors/liteAdaptor.js');
const {RegisterHTMLHandler} = require('mathjax-full/js/handlers/html.js');
const {AllPackages} = require('mathjax-full/js/input/tex/AllPackages.js');
const root = path.resolve(__dirname, '..');
const macroText = fs.readFileSync(path.join(root,'assets/mathjax-config.html'),'utf8');
const context = {window:{}};
vm.runInNewContext(macroText.replace(/<\/?script>/g,''),context);
const adaptor = liteAdaptor();
RegisterHTMLHandler(adaptor);
const failures = [];
let count = 0;
for (const file of fs.readdirSync(root).filter(x=>x.endsWith('.qmd')).sort()) {
  const parsed=spawnSync('quarto',['pandoc',file,'--from=markdown','--to=json'],
    {cwd:root,encoding:'utf8',maxBuffer:32*1024*1024});
  if(parsed.status!==0) throw new Error(file+': '+parsed.stderr);
  const expressions=[];
  function walk(node){
    if(!node || typeof node!=='object') return;
    if(node.t==='Math') expressions.push(node.c);
    for(const v of Object.values(node)) {
      if(Array.isArray(v)) v.forEach(walk); else if(v && typeof v==='object') walk(v);
    }
  }
  walk(JSON.parse(parsed.stdout));
  let current=0;
  const tex = new TeX({
    packages:AllPackages,
    macros:context.window.MathJax.tex.macros,
    formatError:(_jax,error)=>{
      failures.push({file,expression:current,error:error.message});
      return _jax.formatError(error);
    }
  });
  const document=mathjax.document('',{InputJax:tex,OutputJax:new SVG({fontCache:'none'})});
  for(const [kind,source] of expressions){
    current++; count++;
    try {
      const output=adaptor.outerHTML(document.convert(source,{display:kind.t==='DisplayMath'}));
      if(output.includes('data-mjx-error=') && !failures.some(x=>x.file===file && x.expression===current))
        failures.push({file,expression:current,error:'MathJax produced an error node',source});
    } catch(error) {failures.push({file,expression:current,error:error.message,source});}
  }
}
if(failures.length){
  process.stderr.write(JSON.stringify(failures,null,2)+'\n');
  process.exitCode=1;
} else console.log('MathJax 3.2.2 compiled all '+count+' mathematical expressions successfully.');
