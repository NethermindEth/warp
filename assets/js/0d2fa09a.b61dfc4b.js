"use strict";(self.webpackChunkwarp_docs=self.webpackChunkwarp_docs||[]).push([[699],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>f});var a=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function r(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?r(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):r(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,a,o=function(e,t){if(null==e)return{};var n,a,o={},r=Object.keys(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=a.createContext({}),p=function(e){var t=a.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},c=function(e){var t=p(e.components);return a.createElement(s.Provider,{value:t},e.children)},u={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},d=a.forwardRef((function(e,t){var n=e.components,o=e.mdxType,r=e.originalType,s=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),d=p(n),f=o,h=d["".concat(s,".").concat(f)]||d[f]||u[f]||r;return n?a.createElement(h,i(i({ref:t},c),{},{components:n})):a.createElement(h,i({ref:t},c))}));function f(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var r=n.length,i=new Array(r);i[0]=d;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:o,i[1]=l;for(var p=2;p<r;p++)i[p]=n[p];return a.createElement.apply(null,i)}return a.createElement.apply(null,n)}d.displayName="MDXCreateElement"},3488:(e,t,n)=>{n.r(t),n.d(t,{contentTitle:()=>i,default:()=>c,frontMatter:()=>r,metadata:()=>l,toc:()=>s});var a=n(7462),o=(n(7294),n(3905));const r={title:"Warp Command Line Interface"},i=void 0,l={unversionedId:"getting_started/cli",id:"getting_started/cli",title:"Warp Command Line Interface",description:"Useful commands with the Warp Transpiler.",source:"@site/docs/getting_started/cli.mdx",sourceDirName:"getting_started",slug:"/getting_started/cli",permalink:"/warp/docs/getting_started/cli",editUrl:"https://github.com/NethermindEth/warp/tree/develop/docs/docs/getting_started/cli.mdx",tags:[],version:"current",frontMatter:{title:"Warp Command Line Interface"},sidebar:"tutorialSidebar",previous:{title:"Installation and Usage",permalink:"/warp/docs/getting_started/a-usage-and-installation"},next:{title:"Inputs and Outputs",permalink:"/warp/docs/getting_started/inputs-and-outputs"}},s=[{value:"Deploys an account contract to a network",id:"deploys-an-account-contract-to-a-network",children:[],level:3},{value:"Get transaction status:",id:"get-transaction-status",children:[],level:3}],p={toc:s};function c(e){let{components:t,...n}=e;return(0,o.kt)("wrapper",(0,a.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("p",null,"Useful commands with the Warp Transpiler."),(0,o.kt)("p",null,"To query available commands, run ",(0,o.kt)("inlineCode",{parentName:"p"},"warp --help"),"."),(0,o.kt)("p",null,"Available Commands:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"transpile [options] <files...>      Transpile Solidity contracts into Cairo contracts\ntransform [options] <file>          Debug tool which applies any set of passes to the AST and writes out the transformed Solidity\ntest [options]                      Deprecated testing framework\nanalyse [options] <file>            Debug tool to analyse the AST\nstatus [options] <tx_hash>          Get the status of a transaction\ncompile [options] <file>            Compile cairo files with warplib in the cairo-path\ngen_interface [options] <file>      Use native Cairo contracts in your Soldity by creating a Solidity interface and a Cairo translation contract for the target Cairo contract\ndeploy [options] <file>             Deploy a warped cairo contract\ndeploy_account [options]            Deploy an account to StarkNet\ninvoke [options] <file>             Invoke a function on a warped contract using the Solidity abi\ncall [options] <file>               Call a function on a warped contract using the Solidity abi\ninstall [options]                   Install the python dependencies required for Warp\ndeclare [options] <cairo_contract>  Declare a Cairo contract\nnew_account [options]               Command to create a new account\nversion\nhelp [command]                      display help for command\n")),(0,o.kt)("p",null,"Command Options:"),(0,o.kt)("p",null,"transpile ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<file...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},'--compile-cairo             Compile the output to bytecode\n--check-trees               Debug: Run sanity checks on all intermediate ASTs\n--dev                       Run AST sanity checks on every pass instead of the final AST only (default: false)\n--format-cairo              Format the cairo output - can be slow on large contracts\n--highlight <ids...>        Debug: Highlight selected ids in the AST printed by --print-trees\n--order <passOrder>         Use a custom set of transpilation passes\n-o, --output-dir <path>     Output directory for transpiled Cairo files. (default: "warp_output")\n-d, --debug-info            Include debug information in the compiled bytecode produced by --compile-cairo (default: false)\n--print-trees               Debug: Print all the intermediate ASTs\n--no-stubs                  Debug: Hide the stubs in the intermediate ASTs when using --print-trees\n--no-strict                 Debug: Allow silent failure of AST consistency checks\n--until <pass>              Stops transpilation after the specified pass\n--no-warnings               Suppress warnings from the Solidity compiler\n--include-paths <paths...>  Pass through to solc --include-path option\n--base-path <path>          Pass through to solc --base-path option\n-h, --help                  display help for command\n')),(0,o.kt)("p",null,"transform ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<file...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"--check-trees               Debug: Run sanity checks on all intermediate ASTs\n--highlight <ids...>        Debug: highlight selected ids in the AST printed by --print-trees\n--order <passOrder>         Use a custom set of transpilation passes\n-o, --output-dir <path>     Output directory for transformed Solidity files\n--print-trees               Debug: Print all the intermediate ASTs\n--no-stubs                  Debug: Hide the stubs in the intermediate ASTs when using --print-trees\n--no-strict                 Debug: Allow silent failure of AST consistency checks\n--until <pass>              Stop processing at specified pass\n--no-warnings               Suppress printed warnings\n--include-paths <paths...>  Pass through to solc --include-path option\n--base-path <path>          Pass through to solc --base-path option\n-h, --help                  display help for command\n")),(0,o.kt)("p",null,"analyse ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<file...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"--highlight <ids...>  Highlight selected ids in the AST\n-h, --help            display help for command\n")),(0,o.kt)("p",null,"status ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<tx_hash...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"--network <network>             Starknet network URL.\n-h, --help                      display help for command\n")),(0,o.kt)("p",null,"compile ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<file...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"-d, --debug_info                Include debug information. (default: false)\n-h, --help                      display help for command\n")),(0,o.kt)("p",null,"declare ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<cairo_contract>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"--network <network>                        StarkNet network URL\n--account <account>                        The name of the account. If not given, the default for the wallet will be used.\n--account_dir <account_dir>                The directory of the account\n--gateway_url <gateway_url>                StarkNet gateway URL\n--feeder_gateway_url <feeder_gateway_url>  StarkNet feeder gateway URL\n--wallet <wallet>                          The name of the wallet, including the python module and wallet class\n--max_fee <max_fee>                        Maximum fee to pay for the transaction\n-h, --help                                 display help for command\n")),(0,o.kt)("p",null,"deploy ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<file...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"-d, --debug_info                           Compile include debug information (default: false)\n--inputs <inputs...>                       Arguments to be passed to constructor of the program as a comma separated list of strings, ints and lists\n--use_cairo_abi                            Use the cairo abi instead of solidity for the inputs (default: false)\n--network <network>                        StarkNet network URL\n--gateway_url <gateway_url>                StarkNet gateway URL\n--feeder_gateway_url <feeder_gateway_url>  StarkNet feeder gateway URL\n--no_wallet                                Do not use a wallet for deployment (default: false)\n--wallet <wallet>                          Wallet provider to use\n--account <account>                        Account to use for deployment\n--account_dir <account_dir>                The directory of the account.\n--max_fee <max_fee>                        Maximum fee to pay for the transaction.\n-h, --help                                 display help for command\n")),(0,o.kt)("p",null,"deploy_account ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"--account <account>                        The name of the account. If not given, the default for the wallet will be used\n--account_dir <account_dir>                The directory of the account.\n--network <network>                        StarkNet network URL\n--gateway_url <gateway_url>                StarkNet gateway URL\n--feeder_gateway_url <feeder_gateway_url>  StarkNet feeder gateway URL\n--wallet <wallet>                          The name of the wallet, including the python module and wallet class\n--max_fee <max_fee>                        Maximum fee to pay for the transaction.\n-h, --help                                 display help for command\n")),(0,o.kt)("p",null,"invoke ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<file...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"--address <address>                        Address of contract to invoke\n--function <function>                      Function to invoke\n--inputs <inputs...>                       Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.\n--use_cairo_abi                            Use the cairo abi instead of solidity for the inputs (default: false)\n--account <account>                        The name of the account. If not given, the default for the wallet will be used\n--account_dir <account_dir>                The directory of the account\n--network <network>                        StarkNet network URL\n--gateway_url <gateway_url>                StarkNet gateway URL\n--feeder_gateway_url <feeder_gateway_url>  StarkNet feeder gateway URL\n--wallet <wallet>                          The name of the wallet, including the python module and wallet class\n--max_fee <max_fee>                        Maximum fee to pay for the transaction\n-h, --help                                 display help for command\n")),(0,o.kt)("p",null,"call ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]")," ",(0,o.kt)("inlineCode",{parentName:"p"},"<file...>"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"--address <address>                        Address of contract to call\n--function <function>                      Function to call\n--inputs <inputs...>                       Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.\n--use_cairo_abi                            Use the cairo abi instead of solidity for the inputs (default: false)\n--account <account>                        The name of the account. If not given, the default for the wallet will be used\n--account_dir <account_dir>                The directory of the account\n--network <network>                        StarkNet network URL\n--gateway_url <gateway_url>                StarkNet gateway URL\n--feeder_gateway_url <feeder_gateway_url>  StarkNet feeder gateway URL\n--wallet <wallet>                          The name of the wallet, including the python module and wallet class\n--max_fee <max_fee>                        Maximum fee to pay for the transaction\n-h, --help                                 display help for command\n")),(0,o.kt)("p",null,"install ",(0,o.kt)("inlineCode",{parentName:"p"},"[options]"),":"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},'--python <python>  Path to a python3.9 executable (default: "python3.9")\n-v, --verbose      Display python setup info\n-h, --help         display help for command\n')),(0,o.kt)("p",null,"Global flags:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"-h, --help                      display help for command\n")),(0,o.kt)("h1",{id:"example-calls"},"Example calls:"),(0,o.kt)("h3",{id:"deploys-an-account-contract-to-a-network"},"Deploys an account contract to a network"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"warp deploy_account --wallet=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount --account=demo --network=alpha-goerli\n")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Output:")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"#Sent deploy account contract transaction.\n\nNOTE: This is a modified version of the OpenZeppelin account contract. The signature is computed\ndifferently.\n\nContract address: 0x0\nPublic key: 0x1\nTransaction hash: 0x2\n")),(0,o.kt)("h3",{id:"get-transaction-status"},"Get transaction status:"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},"warp status 0x4 --network=alpha-goerli\n")),(0,o.kt)("p",null,(0,o.kt)("strong",{parentName:"p"},"Output:")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre"},'{\n    "block_hash": "0x5",\n    "tx_status": "ACCEPTED_ON_L2"\n}\n')))}c.isMDXComponent=!0}}]);