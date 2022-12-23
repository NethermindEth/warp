"use strict";(self.webpackChunkwarp_docs=self.webpackChunkwarp_docs||[]).push([[43],{3905:(e,t,a)=>{a.d(t,{Zo:()=>m,kt:()=>c});var n=a(7294);function l(e,t,a){return t in e?Object.defineProperty(e,t,{value:a,enumerable:!0,configurable:!0,writable:!0}):e[t]=a,e}function i(e,t){var a=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),a.push.apply(a,n)}return a}function o(e){for(var t=1;t<arguments.length;t++){var a=null!=arguments[t]?arguments[t]:{};t%2?i(Object(a),!0).forEach((function(t){l(e,t,a[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(a)):i(Object(a)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(a,t))}))}return e}function r(e,t){if(null==e)return{};var a,n,l=function(e,t){if(null==e)return{};var a,n,l={},i=Object.keys(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||(l[a]=e[a]);return l}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(n=0;n<i.length;n++)a=i[n],t.indexOf(a)>=0||Object.prototype.propertyIsEnumerable.call(e,a)&&(l[a]=e[a])}return l}var s=n.createContext({}),d=function(e){var t=n.useContext(s),a=t;return e&&(a="function"==typeof e?e(t):o(o({},t),e)),a},m=function(e){var t=d(e.components);return n.createElement(s.Provider,{value:t},e.children)},p={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},u=n.forwardRef((function(e,t){var a=e.components,l=e.mdxType,i=e.originalType,s=e.parentName,m=r(e,["components","mdxType","originalType","parentName"]),u=d(a),c=l,h=u["".concat(s,".").concat(c)]||u[c]||p[c]||i;return a?n.createElement(h,o(o({ref:t},m),{},{components:a})):n.createElement(h,o({ref:t},m))}));function c(e,t){var a=arguments,l=t&&t.mdxType;if("string"==typeof e||l){var i=a.length,o=new Array(i);o[0]=u;var r={};for(var s in t)hasOwnProperty.call(t,s)&&(r[s]=t[s]);r.originalType=e,r.mdxType="string"==typeof e?e:l,o[1]=r;for(var d=2;d<i;d++)o[d]=a[d];return n.createElement.apply(null,o)}return n.createElement.apply(null,a)}u.displayName="MDXCreateElement"},5002:(e,t,a)=>{a.d(t,{Z:()=>r});var n=a(7462),l=a(7294),i=a(5773);function o(e){let{toc:t,className:a,linkClassName:n,isChild:i}=e;return t.length?l.createElement("ul",{className:i?void 0:a},t.map((e=>l.createElement("li",{key:e.id},l.createElement("a",{href:"#"+e.id,className:null!=n?n:void 0,dangerouslySetInnerHTML:{__html:e.value}}),l.createElement(o,{isChild:!0,toc:e.children,className:a,linkClassName:n}))))):null}function r(e){let{toc:t,className:a="table-of-contents table-of-contents__left-border",linkClassName:r="table-of-contents__link",linkActiveClassName:s,minHeadingLevel:d,maxHeadingLevel:m,...p}=e;const u=(0,i.LU)(),c=null!=d?d:u.tableOfContents.minHeadingLevel,h=null!=m?m:u.tableOfContents.maxHeadingLevel,k=(0,i.DA)({toc:t,minHeadingLevel:c,maxHeadingLevel:h}),g=(0,l.useMemo)((()=>{if(r&&s)return{linkClassName:r,linkActiveClassName:s,minHeadingLevel:c,maxHeadingLevel:h}}),[r,s,c,h]);return(0,i.Si)(g),l.createElement(o,(0,n.Z)({toc:k,className:a,linkClassName:r},p))}},1:(e,t,a)=>{a.r(t),a.d(t,{contentTitle:()=>v,default:()=>w,frontMatter:()=>g,metadata:()=>N,toc:()=>f});var n=a(7462),l=a(7294),i=a(3905),o=a(2389),r=a(5773),s=a(6010);const d="tabItem_LplD";function m(e){var t,a,i;const{lazy:o,block:m,defaultValue:p,values:u,groupId:c,className:h}=e,k=l.Children.map(e.children,(e=>{if((0,l.isValidElement)(e)&&void 0!==e.props.value)return e;throw new Error("Docusaurus error: Bad <Tabs> child <"+("string"==typeof e.type?e.type:e.type.name)+'>: all children of the <Tabs> component should be <TabItem>, and every <TabItem> should have a unique "value" prop.')})),g=null!=u?u:k.map((e=>{let{props:{value:t,label:a,attributes:n}}=e;return{value:t,label:a,attributes:n}})),v=(0,r.lx)(g,((e,t)=>e.value===t.value));if(v.length>0)throw new Error('Docusaurus error: Duplicate values "'+v.map((e=>e.value)).join(", ")+'" found in <Tabs>. Every value needs to be unique.');const N=null===p?p:null!=(t=null!=p?p:null==(a=k.find((e=>e.props.default)))?void 0:a.props.value)?t:null==(i=k[0])?void 0:i.props.value;if(null!==N&&!g.some((e=>e.value===N)))throw new Error('Docusaurus error: The <Tabs> has a defaultValue "'+N+'" but none of its children has the corresponding value. Available values are: '+g.map((e=>e.value)).join(", ")+". If you intend to show no default tab, use defaultValue={null} instead.");const{tabGroupChoices:f,setTabGroupChoices:b}=(0,r.UB)(),[w,x]=(0,l.useState)(N),y=[],{blockElementScrollPositionUntilNextRender:T}=(0,r.o5)();if(null!=c){const e=f[c];null!=e&&e!==w&&g.some((t=>t.value===e))&&x(e)}const A=e=>{const t=e.currentTarget,a=y.indexOf(t),n=g[a].value;n!==w&&(T(t),x(n),null!=c&&b(c,n))},C=e=>{var t;let a=null;switch(e.key){case"ArrowRight":{const t=y.indexOf(e.currentTarget)+1;a=y[t]||y[0];break}case"ArrowLeft":{const t=y.indexOf(e.currentTarget)-1;a=y[t]||y[y.length-1];break}}null==(t=a)||t.focus()};return l.createElement("div",{className:"tabs-container"},l.createElement("ul",{role:"tablist","aria-orientation":"horizontal",className:(0,s.Z)("tabs",{"tabs--block":m},h)},g.map((e=>{let{value:t,label:a,attributes:i}=e;return l.createElement("li",(0,n.Z)({role:"tab",tabIndex:w===t?0:-1,"aria-selected":w===t,key:t,ref:e=>y.push(e),onKeyDown:C,onFocus:A,onClick:A},i,{className:(0,s.Z)("tabs__item",d,null==i?void 0:i.className,{"tabs__item--active":w===t})}),null!=a?a:t)}))),o?(0,l.cloneElement)(k.filter((e=>e.props.value===w))[0],{className:"margin-vert--md"}):l.createElement("div",{className:"margin-vert--md"},k.map(((e,t)=>(0,l.cloneElement)(e,{key:t,hidden:e.props.value!==w})))))}function p(e){const t=(0,o.Z)();return l.createElement(m,(0,n.Z)({key:String(t)},e))}const u=function(e){let{children:t,hidden:a,className:n}=e;return l.createElement("div",{role:"tabpanel",hidden:a,className:n},t)},c="tableOfContentsInline_gwOO";var h=a(5002);const k=function(e){let{toc:t,minHeadingLevel:a,maxHeadingLevel:n}=e;return l.createElement("div",{className:c},l.createElement(h.Z,{toc:t,minHeadingLevel:a,maxHeadingLevel:n,className:"table-of-contents",linkClassName:null}))},g={title:"Docs Cheatsheet"},v=void 0,N={unversionedId:"contribution_guidelines/cheatsheet",id:"contribution_guidelines/cheatsheet",title:"Docs Cheatsheet",description:"On this page you'll find every markdown & mdx component used in our docs.",source:"@site/i18n/vi/docusaurus-plugin-content-docs/current/contribution_guidelines/cheatsheet.mdx",sourceDirName:"contribution_guidelines",slug:"/contribution_guidelines/cheatsheet",permalink:"/warp/vi/docs/contribution_guidelines/cheatsheet",editUrl:"https://github.com/NethermindEth/warp/tree/develop/docs/docs/contribution_guidelines/cheatsheet.mdx",tags:[],version:"current",frontMatter:{title:"Docs Cheatsheet"},sidebar:"tutorialSidebar",previous:{title:"Contribution Guidelines",permalink:"/warp/vi/docs/category/contribution-guidelines"},next:{title:"Docs Contributor Guide",permalink:"/warp/vi/docs/contribution_guidelines/contribution-guide"}},f=[{value:"Page Title &amp; Data",id:"page-title--data",children:[],level:2},{value:"Heading 2",id:"heading-2",children:[{value:"Heading 3",id:"heading-3",children:[{value:"Heading 4",id:"heading-4",children:[{value:"Heading 5",id:"heading-5",children:[{value:"Heading 6",id:"heading-6",children:[],level:6}],level:5}],level:4}],level:3}],level:2},{value:"Line breaks",id:"line-breaks",children:[],level:2},{value:"Lists",id:"lists",children:[{value:"Unordered lists",id:"unordered-lists",children:[],level:3},{value:"Unordered lists",id:"unordered-lists-1",children:[],level:3},{value:"Nested &amp; Mixed lists",id:"nested--mixed-lists",children:[],level:3}],level:2},{value:"Text styling",id:"text-styling",children:[],level:2},{value:"Codeblocks",id:"codeblocks",children:[],level:2},{value:"Quotes",id:"quotes",children:[],level:2},{value:"Admonitions",id:"admonitions",children:[],level:2},{value:"Links",id:"links",children:[],level:2},{value:"Images",id:"images",children:[{value:"Alt tags for images",id:"alt-tags-for-images",children:[],level:3}],level:2},{value:"MDX features",id:"mdx-features",children:[{value:"Tabs",id:"tabs",children:[],level:3},{value:"Inline Table of Contents",id:"inline-table-of-contents",children:[],level:3}],level:2},{value:"Footnotes &amp; references",id:"footnotes--references",children:[],level:2}],b={toc:f};function w(e){let{components:t,...l}=e;return(0,i.kt)("wrapper",(0,n.Z)({},b,l,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("p",null,"On this page you'll find every markdown & mdx component used in our docs."),(0,i.kt)("h2",{id:"page-title--data"},"Page Title & Data"),(0,i.kt)("p",null,"For the title of the page, and the name of the tab, at the very top of your file, add this code snippet at the top."),(0,i.kt)("p",null,"Anything inbetween the ",(0,i.kt)("inlineCode",{parentName:"p"},"---")," tags will be used for the page meta data."),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"---\ntitle: Cheatsheet\nid: page-id-when-linking-to-it\n---\n")),(0,i.kt)("p",null,"For Heading 1 specifically, you should set the page title in the meta data."),(0,i.kt)("p",null,(0,i.kt)("a",{parentName:"p",href:"https://docusaurus.io/docs/next/markdown-features/headings"},"Docusaurus source docs")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"# Heading 1\n")),(0,i.kt)("h2",{id:"heading-2"},"Heading 2"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"## Heading 2\n")),(0,i.kt)("h3",{id:"heading-3"},"Heading 3"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"### Heading 3\n")),(0,i.kt)("h4",{id:"heading-4"},"Heading 4"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"#### Heading 4\n")),(0,i.kt)("h5",{id:"heading-5"},"Heading 5"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"##### Heading 5\n")),(0,i.kt)("h6",{id:"heading-6"},"Heading 6"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"###### Heading 6\n")),(0,i.kt)("h2",{id:"line-breaks"},"Line breaks"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"Some text\n\nWith a line break between each line\n")),(0,i.kt)("h2",{id:"lists"},"Lists"),(0,i.kt)("h3",{id:"unordered-lists"},"Unordered lists"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Unordered list 1"),(0,i.kt)("li",{parentName:"ul"},"Unordered list 2"),(0,i.kt)("li",{parentName:"ul"},"Unordered list 3")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"- Unordered list 1\n- Unordered list 2\n- Unordered list 3\n")),(0,i.kt)("h3",{id:"unordered-lists-1"},"Unordered lists"),(0,i.kt)("p",null,"As long as there is a number at the start of a list, docusaurus will count incrementally starting with the first number in the list"),(0,i.kt)("ol",null,(0,i.kt)("li",{parentName:"ol"},"Ordered list 1"),(0,i.kt)("li",{parentName:"ol"},"Ordered list 2"),(0,i.kt)("li",{parentName:"ol"},"Ordered list 3")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"1. Ordered list 1\n2. Ordered list 2\n3. Ordered list 3\n")),(0,i.kt)("h3",{id:"nested--mixed-lists"},"Nested & Mixed lists"),(0,i.kt)("ol",null,(0,i.kt)("li",{parentName:"ol"},"Ordered list",(0,i.kt)("ol",{parentName:"li"},(0,i.kt)("li",{parentName:"ol"},"Sable"),(0,i.kt)("li",{parentName:"ol"},"Ferret",(0,i.kt)("ul",{parentName:"li"},(0,i.kt)("li",{parentName:"ul"},"Cat rat"),(0,i.kt)("li",{parentName:"ul"},"Fox weasel"))),(0,i.kt)("li",{parentName:"ol"},"Lamp"))),(0,i.kt)("li",{parentName:"ol"},"Ordered list",(0,i.kt)("ul",{parentName:"li"},(0,i.kt)("li",{parentName:"ul"},"Grape"),(0,i.kt)("li",{parentName:"ul"},"Potatoes",(0,i.kt)("ul",{parentName:"li"},(0,i.kt)("li",{parentName:"ul"},"Chips",(0,i.kt)("ol",{parentName:"li"},(0,i.kt)("li",{parentName:"ol"},"Crisps"),(0,i.kt)("li",{parentName:"ol"},"Fondant"),(0,i.kt)("li",{parentName:"ol"},"Frites"))))),(0,i.kt)("li",{parentName:"ul"},"Lemons",(0,i.kt)("ol",{parentName:"li"},(0,i.kt)("li",{parentName:"ol"},"Three cats"),(0,i.kt)("li",{parentName:"ol"},"Pasta"),(0,i.kt)("li",{parentName:"ol"},"Ragu"))))),(0,i.kt)("li",{parentName:"ol"},"Ordered list")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"1. Ordered list\n   1. Sable\n   2. Ferret\n      - Cat rat\n      - Fox weasel\n   3. Lamp\n2. Ordered list\n   - Grape\n   - Potatoes\n     - Chips\n       1. Crisps\n       1. Fondant\n       1. Frites\n   - Lemons\n     1. Three cats\n     1. Pasta\n     1. Ragu\n3. Ordered list\n")),(0,i.kt)("h2",{id:"text-styling"},"Text styling"),(0,i.kt)("p",null,(0,i.kt)("em",{parentName:"p"},"Italic/Emphasize")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"_Italic/Emphasize_\n")),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},"Strong/Bold")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"**Strong/Bold**\n")),(0,i.kt)("p",null,(0,i.kt)("strong",{parentName:"p"},(0,i.kt)("em",{parentName:"strong"},"Italic & Bold"))),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"**_Italic & Bold_**\n")),(0,i.kt)("h2",{id:"codeblocks"},"Codeblocks"),(0,i.kt)("p",null,"Define a section using ",(0,i.kt)("inlineCode",{parentName:"p"},"```"),". Anything between two lines that contain these 3 back quotes will be in a code block."),(0,i.kt)("p",null,"To get syntax highlighting and formatting for a certain language succh as Javascript:"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-js"},"const threeCats = ['cat', 'cat', 'cat'];\n")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},'Mind indentation here, code blocks in code blocks is not standard\n`js const threeCats = ["cat", "cat", "cat"] `\n')),(0,i.kt)("p",null,"There are many different formattings to use, ",(0,i.kt)("inlineCode",{parentName:"p"},"md"),", ",(0,i.kt)("inlineCode",{parentName:"p"},"js"),", ",(0,i.kt)("inlineCode",{parentName:"p"},"ts"),", etc. The package used to render ",(0,i.kt)("a",{parentName:"p",href:"https://github.com/FormidableLabs/prism-react-renderer"},"Prism react render")),(0,i.kt)("h2",{id:"quotes"},"Quotes"),(0,i.kt)("blockquote",null,(0,i.kt)("p",{parentName:"blockquote"},"Quoted text.")),(0,i.kt)("blockquote",null,(0,i.kt)("blockquote",{parentName:"blockquote"},(0,i.kt)("p",{parentName:"blockquote"},"Quoted quote."))),(0,i.kt)("blockquote",null,(0,i.kt)("p",{parentName:"blockquote"},"Quoted text."),(0,i.kt)("blockquote",{parentName:"blockquote"},(0,i.kt)("p",{parentName:"blockquote"},"Quoted quote."),(0,i.kt)("blockquote",{parentName:"blockquote"},(0,i.kt)("p",{parentName:"blockquote"},"Quoted quote.")))),(0,i.kt)("blockquote",null,(0,i.kt)("p",{parentName:"blockquote"},"Quoted text."),(0,i.kt)("blockquote",{parentName:"blockquote"},(0,i.kt)("p",{parentName:"blockquote"},"Quoted quote."),(0,i.kt)("blockquote",{parentName:"blockquote"},(0,i.kt)("p",{parentName:"blockquote"},"Quoted quote."),(0,i.kt)("blockquote",{parentName:"blockquote"},(0,i.kt)("p",{parentName:"blockquote"},"Quoted quote."))))),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"> Quoted text.\n\n> > Quoted quote.\n\n> Quoted text.\n>\n> > Quoted quote.\n> >\n> > > Quoted quote.\n\n> Quoted text.\n>\n> > Quoted quote.\n> >\n> > > Quoted quote.\n> > >\n> > > > Quoted quote.\n")),(0,i.kt)("h2",{id:"admonitions"},"Admonitions"),(0,i.kt)("p",null,"These are nifty notification blocks ",(0,i.kt)("a",{parentName:"p",href:"https://docusaurus.io/docs/next/markdown-features/admonitions"},"from Docusaurus"),"."),(0,i.kt)("div",{className:"admonition admonition-note alert alert--secondary"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.3 5.69a.942.942 0 0 1-.28-.7c0-.28.09-.52.28-.7.19-.18.42-.28.7-.28.28 0 .52.09.7.28.18.19.28.42.28.7 0 .28-.09.52-.28.7a1 1 0 0 1-.7.3c-.28 0-.52-.11-.7-.3zM8 7.99c-.02-.25-.11-.48-.31-.69-.2-.19-.42-.3-.69-.31H6c-.27.02-.48.13-.69.31-.2.2-.3.44-.31.69h1v3c.02.27.11.5.31.69.2.2.42.31.69.31h1c.27 0 .48-.11.69-.31.2-.19.3-.42.31-.69H8V7.98v.01zM7 2.3c-3.14 0-5.7 2.54-5.7 5.68 0 3.14 2.56 5.7 5.7 5.7s5.7-2.55 5.7-5.7c0-3.15-2.56-5.69-5.7-5.69v.01zM7 .98c3.86 0 7 3.14 7 7s-3.14 7-7 7-7-3.12-7-7 3.14-7 7-7z"}))),"note")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"The content and title ",(0,i.kt)("em",{parentName:"p"},"can")," include markdown."))),(0,i.kt)("div",{className:"admonition admonition-note alert alert--secondary"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.3 5.69a.942.942 0 0 1-.28-.7c0-.28.09-.52.28-.7.19-.18.42-.28.7-.28.28 0 .52.09.7.28.18.19.28.42.28.7 0 .28-.09.52-.28.7a1 1 0 0 1-.7.3c-.28 0-.52-.11-.7-.3zM8 7.99c-.02-.25-.11-.48-.31-.69-.2-.19-.42-.3-.69-.31H6c-.27.02-.48.13-.69.31-.2.2-.3.44-.31.69h1v3c.02.27.11.5.31.69.2.2.42.31.69.31h1c.27 0 .48-.11.69-.31.2-.19.3-.42.31-.69H8V7.98v.01zM7 2.3c-3.14 0-5.7 2.54-5.7 5.68 0 3.14 2.56 5.7 5.7 5.7s5.7-2.55 5.7-5.7c0-3.15-2.56-5.69-5.7-5.69v.01zM7 .98c3.86 0 7 3.14 7 7s-3.14 7-7 7-7-3.12-7-7 3.14-7 7-7z"}))),"Your Title")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"The content and title ",(0,i.kt)("em",{parentName:"p"},"can")," include markdown."))),(0,i.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"You can specify an optional title")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"Heads up! Here's a pro-tip."))),(0,i.kt)("div",{className:"admonition admonition-info alert alert--info"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"14",height:"16",viewBox:"0 0 14 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z"}))),"info")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"Useful information."))),(0,i.kt)("div",{className:"admonition admonition-caution alert alert--warning"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"16",height:"16",viewBox:"0 0 16 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M8.893 1.5c-.183-.31-.52-.5-.887-.5s-.703.19-.886.5L.138 13.499a.98.98 0 0 0 0 1.001c.193.31.53.501.886.501h13.964c.367 0 .704-.19.877-.5a1.03 1.03 0 0 0 .01-1.002L8.893 1.5zm.133 11.497H6.987v-2.003h2.039v2.003zm0-3.004H6.987V5.987h2.039v4.006z"}))),"caution")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"Warning! You better pay attention!"))),(0,i.kt)("div",{className:"admonition admonition-danger alert alert--danger"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M5.05.31c.81 2.17.41 3.38-.52 4.31C3.55 5.67 1.98 6.45.9 7.98c-1.45 2.05-1.7 6.53 3.53 7.7-2.2-1.16-2.67-4.52-.3-6.61-.61 2.03.53 3.33 1.94 2.86 1.39-.47 2.3.53 2.27 1.67-.02.78-.31 1.44-1.13 1.81 3.42-.59 4.78-3.42 4.78-5.56 0-2.84-2.53-3.22-1.25-5.61-1.52.13-2.03 1.13-1.89 2.75.09 1.08-1.02 1.8-1.86 1.33-.67-.41-.66-1.19-.06-1.78C8.18 5.31 8.68 2.45 5.05.32L5.03.3l.02.01z"}))),"danger")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"Danger danger, mayday!"))),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre"},":::note\n\nThe content and title *can* include markdown.\n\n:::\n\n:::note Your Title\n\nThe content and title *can* include markdown.\n\n:::\n\n:::tip You can specify an optional title\n\nHeads up! Here's a pro-tip.\n\n:::\n\n:::info\n\nUseful information.\n\n:::\n\n:::caution\n\nWarning! You better pay attention!\n\n:::\n\n:::danger\n\nDanger danger, mayday!\n\n:::\n")),(0,i.kt)("h2",{id:"links"},"Links"),(0,i.kt)("p",null,"The links in this paragraph are being pulled from a list ",(0,i.kt)("a",{parentName:"p",href:"http://example.com/",title:"Title"},"a link")," and\nanother ",(0,i.kt)("a",{parentName:"p",href:"http://example.org/",title:"Title"},"link"),"."),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"The links in this paragraph are being pulled from a list [a link][1] and\nanother [link][2].\n")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"This is that list\n\n[1]: http://example.com/ 'Title'\n[2]: http://example.org/ 'Title'\n")),(0,i.kt)("h2",{id:"images"},"Images"),(0,i.kt)("h3",{id:"alt-tags-for-images"},"Alt tags for images"),(0,i.kt)("p",null,"You can update the alt tag data for text like this:"),(0,i.kt)("p",null,"Logo: ",(0,i.kt)("img",{alt:"Alt",src:a(9025).Z,title:"Warp logo",width:"140",height:"140"})),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"Logo: ![Alt](/img/logo.png 'Warp logo')\n")),(0,i.kt)("p",null,"You can create a image with a hyperlink to another page or a hash link on the page by adding the link in the brackets next to it."),(0,i.kt)("p",null,"Linked logo: ",(0,i.kt)("a",{parentName:"p",href:"https://nethermindeth.github.io/warp/",title:"Off to the docs"},(0,i.kt)("img",{alt:"alt text",src:a(9025).Z,width:"140",height:"140"}))),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"Linked logo: [![alt text](//img/logo.png)](https://nethermindeth.github.io/warp/ 'Off to the docs')\n")),(0,i.kt)("h2",{id:"mdx-features"},"MDX features"),(0,i.kt)("p",null,"A quick note on using what's called ",(0,i.kt)("inlineCode",{parentName:"p"},".mdx")," features, ",(0,i.kt)("inlineCode",{parentName:"p"},"mdx")," means markdown extended, to used these features, you need to name your file to have the extention ",(0,i.kt)("inlineCode",{parentName:"p"},".mdx")),(0,i.kt)("p",null,"For example ",(0,i.kt)("inlineCode",{parentName:"p"},"cheatsheet.mdx")),(0,i.kt)("p",null,"This lets you use react components that are a bit more intricate that the standard markdown features."),(0,i.kt)("p",null,"To make use of an ",(0,i.kt)("inlineCode",{parentName:"p"},"mdx")," component like ",(0,i.kt)("inlineCode",{parentName:"p"},"Tabs"),", you need to add any ",(0,i.kt)("inlineCode",{parentName:"p"},"import ... from ...")," lines to the top of the page, but below the meta data section. Heres an example:"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre"},"---\ntitle: Cheatsheet (Heading 1)\n---\nimport Tabs from '@theme/Tabs';\nimport TabItem from '@theme/TabItem';\n")),(0,i.kt)("h3",{id:"tabs"},"Tabs"),(0,i.kt)("p",null,"This is an example of the ",(0,i.kt)("inlineCode",{parentName:"p"},"tabs")," component."),(0,i.kt)("p",null,"For extend usage, please refer to the ",(0,i.kt)("a",{parentName:"p",href:"https://docusaurus.io/docs/next/markdown-features/tabs"},"Docusaurus documentation.")),(0,i.kt)(p,{defaultValue:"apple",values:[{label:"Apple",value:"apple"},{label:"Orange",value:"orange"},{label:"Banana",value:"banana"}],mdxType:"Tabs"},(0,i.kt)(u,{value:"apple",mdxType:"TabItem"},"This is an apple \ud83c\udf4e"),(0,i.kt)(u,{value:"orange",mdxType:"TabItem"},"This is an orange \ud83c\udf4a"),(0,i.kt)(u,{value:"banana",mdxType:"TabItem"},"This is a banana \ud83c\udf4c")),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-mdx"},"import Tabs from '@theme/Tabs';\nimport TabItem from '@theme/TabItem';\n\n<Tabs\n  defaultValue=\"apple\"\n  values={[\n    { label: 'Apple', value: 'apple' },\n    { label: 'Orange', value: 'orange' },\n    { label: 'Banana', value: 'banana' },\n  ]}\n>\n  <TabItem value=\"apple\">This is an apple \ud83c\udf4e</TabItem>\n  <TabItem value=\"orange\">This is an orange \ud83c\udf4a</TabItem>\n  <TabItem value=\"banana\">This is a banana \ud83c\udf4c</TabItem>\n</Tabs>\n")),(0,i.kt)("h3",{id:"inline-table-of-contents"},"Inline Table of Contents"),(0,i.kt)("p",null,"If you need a table contents literally anywhere, you can make use of the ",(0,i.kt)("inlineCode",{parentName:"p"},"<TOCInline>")," component."),(0,i.kt)("p",null,"For extend usage, please refer to the ",(0,i.kt)("a",{parentName:"p",href:"https://docusaurus.io/docs/next/markdown-features/inline-toc"},"Docusaurus documentation.")),(0,i.kt)(k,{toc:f,mdxType:"TOCInline"}),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-mdx"},"import TOCInline from '@theme/TOCInline';\n\n<TOCInline toc={toc} />\n")),(0,i.kt)("h2",{id:"footnotes--references"},"Footnotes & references"),(0,i.kt)("p",null,"This is how we make a reference to a foot note or reference that's found at the bottoms of the page.",(0,i.kt)("sup",{parentName:"p",id:"fnref-1"},(0,i.kt)("a",{parentName:"sup",href:"#fn-1",className:"footnote-ref"},"1"))),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"This is how we make a reference to a footnote [^1] that's found at the bottoms of the page\n")),(0,i.kt)("p",null,"To create list of foot notes, you just add list like this somewhere, preferably at the bottom of the file"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-md"},"[^1]: an amazing foot note, you can add links n things here as usual\n")),(0,i.kt)("div",{className:"footnotes"},(0,i.kt)("hr",{parentName:"div"}),(0,i.kt)("ol",{parentName:"div"},(0,i.kt)("li",{parentName:"ol",id:"fn-1"},"an amazing foot note, you can add links n things here as usual",(0,i.kt)("a",{parentName:"li",href:"#fnref-1",className:"footnote-backref"},"\u21a9")))))}w.isMDXComponent=!0},9025:(e,t,a)=>{a.d(t,{Z:()=>n});const n="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIwAAACMCAYAAACuwEE+AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAFvSURBVHhe7dIxAYAwEMDAB3fVWXzCgoBmv1tiINdezztw6P4LRwxDYhgSw5AYhsQwJIYhMQyJYUgMQ2IYEsOQGIbEMCSGITEMiWFIDENiGBLDkBiGxDAkhiExDIlhSAxDYhgSw5AYhsQwJIYhMQyJYUgMQ2IYEsOQGIbEMCSGITEMiWFIDENiGBLDkBiGxDAkhiExDIlhSAxDYhgSw5AYhsQwJIYhMQyJYUgMQ2IYEsOQGIbEMCSGITEMiWFIDENiGBLDkBiGxDAkhiExDIlhSAxDYhgSw5AYhsQwJIYhMQyJYUgMQ2IYEsOQGIbEMCSGITEMiWFIDENiGBLDkBiGxDAkhiExDIlhSAxDYhgSw5AYhsQwJIYhMQyJYUgMQ2IYEsOQGIbEMCSGITEMiWFIDENiGBLDkBiGxDAkhiExDIlhSAxDYhgSw5AYhsQwJIYhMQyJYUgMQ2IYEsOQGIbEMCSGITEMiWFIDENiGIKZDyMZA6djpecuAAAAAElFTkSuQmCC"}}]);