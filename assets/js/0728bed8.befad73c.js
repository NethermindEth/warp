"use strict";(self.webpackChunkwarp_docs=self.webpackChunkwarp_docs||[]).push([[359],{3905:(e,t,n)=>{n.d(t,{Zo:()=>p,kt:()=>_});var r=n(7294);function a(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function l(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?l(Object(n),!0).forEach((function(t){a(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):l(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function o(e,t){if(null==e)return{};var n,r,a=function(e,t){if(null==e)return{};var n,r,a={},l=Object.keys(e);for(r=0;r<l.length;r++)n=l[r],t.indexOf(n)>=0||(a[n]=e[n]);return a}(e,t);if(Object.getOwnPropertySymbols){var l=Object.getOwnPropertySymbols(e);for(r=0;r<l.length;r++)n=l[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(a[n]=e[n])}return a}var c=r.createContext({}),s=function(e){var t=r.useContext(c),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},p=function(e){var t=s(e.components);return r.createElement(c.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},u=r.forwardRef((function(e,t){var n=e.components,a=e.mdxType,l=e.originalType,c=e.parentName,p=o(e,["components","mdxType","originalType","parentName"]),u=s(n),_=a,f=u["".concat(c,".").concat(_)]||u[_]||d[_]||l;return n?r.createElement(f,i(i({ref:t},p),{},{components:n})):r.createElement(f,i({ref:t},p))}));function _(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var l=n.length,i=new Array(l);i[0]=u;var o={};for(var c in t)hasOwnProperty.call(t,c)&&(o[c]=t[c]);o.originalType=e,o.mdxType="string"==typeof e?e:a,i[1]=o;for(var s=2;s<l;s++)i[s]=n[s];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}u.displayName="MDXCreateElement"},1278:(e,t,n)=>{n.r(t),n.d(t,{contentTitle:()=>i,default:()=>p,frontMatter:()=>l,metadata:()=>o,toc:()=>c});var r=n(7462),a=(n(7294),n(3905));const l={},i=void 0,o={unversionedId:"features/interface_call_forwarder",id:"features/interface_call_forwarder",title:"interface_call_forwarder",description:"Interface Call Forwarder",source:"@site/docs/features/interface_call_forwarder.mdx",sourceDirName:"features",slug:"/features/interface_call_forwarder",permalink:"/warp/docs/features/interface_call_forwarder",editUrl:"https://github.com/NethermindEth/warp/tree/develop/docs/docs/features/interface_call_forwarder.mdx",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Contract Factories",permalink:"/warp/docs/features/contract_factories"},next:{title:"Solidity Equivalents",permalink:"/warp/docs/category/solidity-equivalents"}},c=[{value:"Interface Call Forwarder",id:"interface-call-forwarder",children:[{value:"Step 1.",id:"step-1",children:[],level:3},{value:"Step 2.",id:"step-2",children:[],level:3},{value:"Step 3.",id:"step-3",children:[],level:3},{value:"Step 4.",id:"step-4",children:[],level:3},{value:"Step 5.",id:"step-5",children:[],level:3}],level:2},{value:"Running tests",id:"running-tests",children:[],level:2}],s={toc:c};function p(e){let{components:t,...n}=e;return(0,a.kt)("wrapper",(0,r.Z)({},s,n,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h2",{id:"interface-call-forwarder"},"Interface Call Forwarder"),(0,a.kt)("p",null,"This is a feature for the Warp transpiler to enable interaction between non-warped cairo contracts with a warped cairo contract ",(0,a.kt)("em",{parentName:"p"},"(cairo file generated after transpilation of a solidity contract)"),"."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-text"},'Usage: warp gen_interface [options] <file>\n\nOptions:\n  --cairo-path <cairo-path>              Cairo libraries/modules import path\n  --output <output>                      Output path for the generation of files\n  --contract-address <contract-address>  Address at which cairo contract has been deployed\n  --class-hash <class-hash>              Class hash of the cairo contract\n  --solc-version <version>               Solc version to use. (default: "0.8.14")\n  -h, --help                             display help for command\n')),(0,a.kt)("p",null,"Assume you have a cairo contract ",(0,a.kt)("inlineCode",{parentName:"p"},"add.cairo"),"."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-js"},"%lang starknet\n\n@view\nfunc add(a: felt, b: felt) -> (res:felt){\n    return (res=a+b);\n}\n")),(0,a.kt)("p",null,"The cairo contract ",(0,a.kt)("inlineCode",{parentName:"p"},"a.cairo")," has been deployed at address ",(0,a.kt)("inlineCode",{parentName:"p"},"addr"),". And, we want to call ",(0,a.kt)("inlineCode",{parentName:"p"},"add")," function from a warped version of a solidity contract. All you have to do is to follow these steps:"),(0,a.kt)("h3",{id:"step-1"},"Step 1."),(0,a.kt)("p",null,"Run command with appropriate cairo file name and it's address at which it has been deployed"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"bin/warp gen_interface a.cairo --contract-address `${addr}` --class_hash `${cairo_contract_class_hash}`\n")),(0,a.kt)("p",null,"This command will generate two files in the directory where your cairo file (in this case ",(0,a.kt)("inlineCode",{parentName:"p"},"a.cairo"),") is present."),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"The generated cairo file which would look like as follows with name ",(0,a.kt)("inlineCode",{parentName:"li"},"a_forwarder.cairo"),":")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-js"},"%lang starknet\n\nfrom starkware.cairo.common.uint256 import Uint256\nfrom starkware.cairo.common.cairo_builtins import HashBuiltin\nfrom warplib.maths.utils import felt_to_uint256, narrow_safe\nfrom warplib.maths.external_input_check_ints import warp_external_input_check_int256\n\n@contract_interface\nnamespace Forwarder {\n    func add(\n        a: felt,\n        b: felt,\n    ) -> (res:felt){\n    }\n}\n\n@view\nfunc add_771602f7 {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(\n    a: Uint256,\n    b: Uint256,\n) -> (\n    res: Uint256,\n) {\n    alloc_locals;\n    // check external input\n    warp_external_input_check_int256(a);\n    warp_external_input_check_int256(b);\n    // cast inputs\n    let (a_cast) = narrow_safe(a);\n    let (b_cast) = narrow_safe(b);\n    // call cairo contract function\n    let (res_cast_rev) = Forwarder.add(**${addr}**,a_cast,b_cast);\n    // cast outputs\n    let (res) = felt_to_uint256(res_cast_rev);\n    return (res,);\n}\n")),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"The generated solidity file (",(0,a.kt)("inlineCode",{parentName:"li"},"a.sol"),") would like as follows with")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-solidity"},"pragma solidity ^0.8.14;\n\n/// WARP-GENERATED\n/// class_hash: 0x590f5d5d27ce148a5435e25097968f38b0fe3fe991147a784b1e5c2755c472a\ninterface Forwarder_a {\n    function add(uint256 a, uint256 b) external returns (uint256 res);\n}\n")),(0,a.kt)("h3",{id:"step-2"},"Step 2."),(0,a.kt)("p",null,"Declare and deploy the generated cairo file. More info at : ",(0,a.kt)("a",{parentName:"p",href:"https://www.cairo-lang.org/docs/hello_starknet/intro.html#declare-the-contract-on-the-starknet-testnet"},"starknet declare&deploy cairo contracts")," ."),(0,a.kt)("h3",{id:"step-3"},"Step 3."),(0,a.kt)("p",null,"Implement your logic using function generated inside a solidity interface object in the ",(0,a.kt)("inlineCode",{parentName:"p"},"a.sol"),"."),(0,a.kt)("p",null,"For example: ",(0,a.kt)("inlineCode",{parentName:"p"},"my_impl.sol")," would be as follows:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-solidity"},'pragma solidity ^0.8.14;\n\nimport "./a.sol";\n\ncontract WARP{\n    Forwarder_a public itr;\n    function useAdd(uint a, uint b) public returns (uint res){\n        return itr.add(a,b);\n    }\n}\n')),(0,a.kt)("h3",{id:"step-4"},"Step 4."),(0,a.kt)("p",null,"Transpile your solidity file using"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-sh"},"bin/warp transpile /path/to/solc_file\n")),(0,a.kt)("p",null,"to get corresponding cairo code."),(0,a.kt)("p",null,"This is a traspiled cairo output for ",(0,a.kt)("inlineCode",{parentName:"p"},"my_impl.sol"),":"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-js"},'%lang starknet\n\nfrom warplib.maths.external_input_check_ints import warp_external_input_check_int256\nfrom starkware.cairo.common.uint256 import Uint256\nfrom starkware.cairo.common.cairo_builtins import HashBuiltin\n\nfunc WS0_READ_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(\n    loc: felt\n) -> (val: felt) {\n    alloc_locals;\n    let (read0) = WARP_STORAGE.read(loc);\n    return (read0,);\n}\n\n// Contract Def WARP\n\nnamespace WARP {\n    // Dynamic variables - Arrays and Maps\n\n    // Static variables\n\n    const __warp_usrid_00_itr = 0;\n}\n\n@external\nfunc useAdd_99bd125f{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(\n    __warp_usrid_01_a: Uint256, __warp_usrid_02_b: Uint256\n) -> (__warp_usrid_03_res: Uint256) {\n    alloc_locals;\n\n    warp_external_input_check_int256(__warp_usrid_02_b);\n\n    warp_external_input_check_int256(__warp_usrid_01_a);\n\n    let (__warp_se_0) = WS0_READ_felt(WARP.__warp_usrid_00_itr);\n\n    let (__warp_pse_0) = Forwarder_a_warped_interface.library_call_add_771602f7(\n        0x590f5d5d27ce148a5435e25097968f38b0fe3fe991147a784b1e5c2755c472a,\n        __warp_usrid_01_a,\n        __warp_usrid_02_b,\n    );\n\n    return (__warp_pse_0,);\n}\n\n@view\nfunc itr_2dd658c7{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (\n    __warp_usrid_04_: felt\n) {\n    alloc_locals;\n\n    let (__warp_se_1) = WS0_READ_felt(WARP.__warp_usrid_00_itr);\n\n    return (__warp_se_1,);\n}\n\n@constructor\nfunc constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {\n    alloc_locals;\n    WARP_USED_STORAGE.write(1);\n\n    return ();\n}\n\n\n// Contract Def Forwarder_a@interface\n\n@contract_interface\nnamespace Forwarder_a_warped_interface {\n    func add_771602f7(__warp_usrid_00_a: Uint256, __warp_usrid_01_b: Uint256) -> (\n        __warp_usrid_02_res: Uint256\n    ) {\n    }\n}\n\n// Original soldity abi: ["constructor()","useAdd(uint256,uint256)","itr()"]\n')),(0,a.kt)("h3",{id:"step-5"},"Step 5."),(0,a.kt)("p",null,"Compile & Deploy the transpiled output cairo contract and invoke the functions. More info about invoke to cairo contract : ",(0,a.kt)("a",{parentName:"p",href:"https://www.cairo-lang.org/docs/hello_starknet/intro.html#interact-with-the-contract"},"cairo contract function invoke")," ."),(0,a.kt)("p",null,"For example:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"starknet invoke \\\n    --address ${CONTRACT_ADDRESS} \\\n    --abi my_impl.json \\\n    --function useAdd_99bd125f \\\n    --inputs 12 0 13 0\n")),(0,a.kt)("h2",{id:"running-tests"},"Running tests"),(0,a.kt)("p",null,"For more detailed and implemented steps, you can look at the ",(0,a.kt)("a",{parentName:"p",href:"../../tests/interface_call_forwarder/interface_forwarder.test.ts"},"interface_forwarder.test.ts")," file."),(0,a.kt)("p",null,"To execute interface call forwarder test, run ",(0,a.kt)("inlineCode",{parentName:"p"},"$ yarn test:forwarder")))}p.isMDXComponent=!0}}]);