"use strict";(self.webpackChunkwarp_docs=self.webpackChunkwarp_docs||[]).push([[734],{3905:(e,t,n)=>{n.d(t,{Zo:()=>s,kt:()=>f});var a=n(7294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function c(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},o=Object.keys(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var i=a.createContext({}),p=function(e){var t=a.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):c(c({},t),e)),n},s=function(e){var t=p(e.components);return a.createElement(i.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},u=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,o=e.originalType,i=e.parentName,s=l(e,["components","mdxType","originalType","parentName"]),u=p(n),f=r,h=u["".concat(i,".").concat(f)]||u[f]||d[f]||o;return n?a.createElement(h,c(c({ref:t},s),{},{components:n})):a.createElement(h,c({ref:t},s))}));function f(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=n.length,c=new Array(o);c[0]=u;var l={};for(var i in t)hasOwnProperty.call(t,i)&&(l[i]=t[i]);l.originalType=e,l.mdxType="string"==typeof e?e:r,c[1]=l;for(var p=2;p<o;p++)c[p]=n[p];return a.createElement.apply(null,c)}return a.createElement.apply(null,n)}u.displayName="MDXCreateElement"},451:(e,t,n)=>{n.r(t),n.d(t,{contentTitle:()=>c,default:()=>s,frontMatter:()=>o,metadata:()=>l,toc:()=>i});var a=n(7462),r=(n(7294),n(3905));const o={title:"Contract Factories"},c=void 0,l={unversionedId:"features/contract_factories",id:"features/contract_factories",title:"Contract Factories",description:"Contract factories are now supported by Warp. Contract factories work slightly differently on StarkNet as they do on Ethereum.",source:"@site/docs/features/contract_factories.mdx",sourceDirName:"features",slug:"/features/contract_factories",permalink:"/warp/docs/features/contract_factories",editUrl:"https://github.com/NethermindEth/warp/tree/develop/docs/docs/features/contract_factories.mdx",tags:[],version:"current",frontMatter:{title:"Contract Factories"},sidebar:"tutorialSidebar",previous:{title:"Cairo Blocks",permalink:"/warp/docs/features/cairo_stubs"},next:{title:"interface_call_forwarder",permalink:"/warp/docs/features/interface_call_forwarder"}},i=[],p={toc:i};function s(e){let{components:t,...n}=e;return(0,r.kt)("wrapper",(0,a.Z)({},p,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("p",null,"Contract factories are now supported by Warp. Contract factories work slightly differently on StarkNet as they do on Ethereum.\nTo deploy a contract on StarkNet we need to know the class hash of the contract being deployed, this class hash is then passed\nas an argument to the deploy system call. Warp is designed so that the above is hidden from the user and handled internally.\nThe class hash is calculated offline and inserted into the transpiled Contract factory as a constant."),(0,r.kt)("p",null,"Note that the contract being deployed by the contract factory will still need to be declared online by the user."),(0,r.kt)("p",null,"\u26a0\ufe0f ",(0,r.kt)("strong",{parentName:"p"},"Warning"),": Warp also supports the use of the salt option i.e ",(0,r.kt)("inlineCode",{parentName:"p"},"new Contract{salt: salt}()")," but because of core differences\nbetween Ethereum and StarkNet the salt value will be truncated from 32 to the 31 most significant bytes."),(0,r.kt)("p",null,"The following Solidity contract named example.sol will be used to illustrate the feature:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"pragma solidity ^0.8.14;\n\ncontract DeployedContract {\n    uint8 input1;\n    uint8 input2;\n    constructor(uint8 input1_, uint8 input2_) {\n        input1 = input1_;\n        input2 = input2_;\n    }\n}\n\ncontract ContractFactory {\n    address public deployedContract;\n\n    function deploy() external {\n        deployedContract =  address(new DeployedContract(1, 2));\n    }\n}\n")),(0,r.kt)("p",null,"Transpile the contract:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"warp transpile example.sol --compile-cairo\n")),(0,r.kt)("p",null,"If we inspect the transpiled ",(0,r.kt)("inlineCode",{parentName:"p"},"ContractFactory")," file we can see that the class hash of the ",(0,r.kt)("inlineCode",{parentName:"p"},"DeployedContract")," is inserted as a constant into the file:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"# @declare example__WC__DeployedContract.cairo\nconst _example_DeployedContract_4de2fe6576a500b8 = 0x2a1fa671ab8a9a09bda9147fd7978a1204667a74e9862257b4df5e0b3039f3b\n")),(0,r.kt)("p",null,"Compare this to the class hash produced by manually declaring the ",(0,r.kt)("inlineCode",{parentName:"p"},"DeployedContract")," file and you will see they are identical:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"warp declare warp_output/example__WC__DeployedContract.cairo\nRunning starknet compile with cairoPath /home/user/.config/yarn/global/node_modules/@nethermindeth/warp\nDeclare transaction was sent.\nContract class hash: 0x2a1fa671ab8a9a09bda9147fd7978a1204667a74e9862257b4df5e0b3039f3b\nTransaction hash: 0x361de621248d89435c5a4c0624a3ad842784feb2a71ef8d5833b50fb1727610\n")),(0,r.kt)("p",null,"Now that the ",(0,r.kt)("inlineCode",{parentName:"p"},"DeployedContract")," has been declared we can move to the next step of deploying an instance of the contract from the ",(0,r.kt)("inlineCode",{parentName:"p"},"ContractFactory")," contract."),(0,r.kt)("p",null,"First we need to deploy the ",(0,r.kt)("inlineCode",{parentName:"p"},"ContractFactory"),":"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"warp deploy warp_output/example__WC__ContractFactory.cairo\nRunning starknet compile with cairoPath /home/user/.config/yarn/global/node_modules/@nethermindeth/warp\nRunning starknet compile with cairoPath /home/user/.config/yarn/global/node_modules/@nethermindeth/warp\nDeclare transaction was sent.\nContract class hash: 0x5f6d13c91710a9f38b53461b6d7ef67e4fc22ae0c071b1525a10023a4cfcddb\nTransaction hash: 0x6137adc00ab3971cab712f042632ffbd126d8ed86debc8ac46da668e64de333\n\nSending the transaction with max_fee: 0.000001 ETH.\nInvoke transaction for contract deployment was sent.\nContract address: 0x050dd6362c74c88530a9f78b756cceb562d25475c6dc612488c52ae881235537\nTransaction hash: 0x1e55b1136b0c9735a51f2f778bb46e90058f9df6bc2ed32c94e432c3a82f5c5\n")),(0,r.kt)("p",null,"Note you can check the transaction status with:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"warp status 0x1e55b1136b0c9735a51f2f778bb46e90058f9df6bc2ed32c94e432c3a82f5c5\n")),(0,r.kt)("p",null,"The status of the transaction will be returned:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},'{\n    "block_hash": "0x1755978ce7c28b71766fa3348a9639e9f166a4afe30ad617be7608ea302a890",\n    "tx_status": "ACCEPTED_ON_L2"\n}\n')),(0,r.kt)("p",null,"Now that the ",(0,r.kt)("inlineCode",{parentName:"p"},"ContractFactory")," has been accepted on L2 we can invoke the ",(0,r.kt)("inlineCode",{parentName:"p"},"deploy")," command."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"warp invoke warp_output/example__WC__ContractFactory.cairo --function deploy --address 0x050dd6362c74c88530a9f78b756cceb562d25475c6dc612488c52ae881235537\n")),(0,r.kt)("p",null,"Lastly, once the transaction is completed we can ",(0,r.kt)("inlineCode",{parentName:"p"},"call")," the ",(0,r.kt)("inlineCode",{parentName:"p"},"ContractFactory")," and get the address of the deployed contract."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre"},"warp call warp_output/example__WC__ContractFactory.cairo --function deployedContract --address 0x050dd6362c74c88530a9f78b756cceb562d25475c6dc612488c52ae881235537\nRunning starknet compile with cairoPath /home/user/.config/yarn/global/node_modules/@nethermindeth/warp\n0x74ef3df5514c3aa7320063a699a4d3959dccaf8f1db2b6bd81df7e67dace247\n")))}s.isMDXComponent=!0}}]);