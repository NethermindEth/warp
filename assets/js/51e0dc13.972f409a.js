"use strict";(self.webpackChunkwarp_docs=self.webpackChunkwarp_docs||[]).push([[298],{3905:(e,n,t)=>{t.d(n,{Zo:()=>u,kt:()=>f});var r=t(7294);function a(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function i(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function l(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?i(Object(t),!0).forEach((function(n){a(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):i(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function o(e,n){if(null==e)return{};var t,r,a=function(e,n){if(null==e)return{};var t,r,a={},i=Object.keys(e);for(r=0;r<i.length;r++)t=i[r],n.indexOf(t)>=0||(a[t]=e[t]);return a}(e,n);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)t=i[r],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(a[t]=e[t])}return a}var s=r.createContext({}),c=function(e){var n=r.useContext(s),t=n;return e&&(t="function"==typeof e?e(n):l(l({},n),e)),t},u=function(e){var n=c(e.components);return r.createElement(s.Provider,{value:n},e.children)},p={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},d=r.forwardRef((function(e,n){var t=e.components,a=e.mdxType,i=e.originalType,s=e.parentName,u=o(e,["components","mdxType","originalType","parentName"]),d=c(t),f=a,h=d["".concat(s,".").concat(f)]||d[f]||p[f]||i;return t?r.createElement(h,l(l({ref:n},u),{},{components:t})):r.createElement(h,l({ref:n},u))}));function f(e,n){var t=arguments,a=n&&n.mdxType;if("string"==typeof e||a){var i=t.length,l=new Array(i);l[0]=d;var o={};for(var s in n)hasOwnProperty.call(n,s)&&(o[s]=n[s]);o.originalType=e,o.mdxType="string"==typeof e?e:a,l[1]=o;for(var c=2;c<i;c++)l[c]=t[c];return r.createElement.apply(null,l)}return r.createElement.apply(null,t)}d.displayName="MDXCreateElement"},5893:(e,n,t)=>{t.r(n),t.d(n,{contentTitle:()=>l,default:()=>u,frontMatter:()=>i,metadata:()=>o,toc:()=>s});var r=t(7462),a=(t(7294),t(3905));const i={title:"Cairo Blocks"},l=void 0,o={unversionedId:"features/cairo_stubs",id:"features/cairo_stubs",title:"Cairo Blocks",description:"Cairo Blocks allow users to place their desired Cairo code into a transpiled contract.",source:"@site/docs/features/cairo_stubs.mdx",sourceDirName:"features",slug:"/features/cairo_stubs",permalink:"/warp/docs/features/cairo_stubs",editUrl:"https://github.com/NethermindEth/warp/tree/develop/docs/docs/features/cairo_stubs.mdx",tags:[],version:"current",frontMatter:{title:"Cairo Blocks"},sidebar:"tutorialSidebar",previous:{title:"Features",permalink:"/warp/docs/category/features"},next:{title:"Contract Factories",permalink:"/warp/docs/features/contract_factories"}},s=[{value:"Additional examples of using Cairo Blocks:",id:"additional-examples-of-using-cairo-blocks",children:[],level:2}],c={toc:s};function u(e){let{components:n,...t}=e;return(0,a.kt)("wrapper",(0,r.Z)({},c,t,{components:n,mdxType:"MDXLayout"}),(0,a.kt)("p",null,"Cairo Blocks allow users to place their desired Cairo code into a transpiled contract.\nThis allows users to avoid inefficiently transpiled functions, implement Cairo features that Warp does not yet support and allow transpiled contracts to interact with native Cairo contracts."),(0,a.kt)("p",null,"The system works in the following way:"),(0,a.kt)("ol",null,(0,a.kt)("li",{parentName:"ol"},"To start a Cairo Block add your Cairo code above a Solidity function with 3 forward slashes at the beginning of each line and the phrase ",(0,a.kt)("inlineCode",{parentName:"li"},"warp-cairo")," at the top."),(0,a.kt)("li",{parentName:"ol"},"The user then uses a number of MACROS to interact with the transpiled contract."),(0,a.kt)("li",{parentName:"ol"},"The Solidity function will then be replaced with the Cario function that is above it.")),(0,a.kt)("p",null,"The following MACROS are supported:"),(0,a.kt)("p",null,(0,a.kt)("inlineCode",{parentName:"p"},"CURRENTFUNC")," - References the Solidity function it is stubbing."),(0,a.kt)("p",null,(0,a.kt)("inlineCode",{parentName:"p"},"DECORATOR")," - Adds decorators to the function."),(0,a.kt)("p",null,(0,a.kt)("inlineCode",{parentName:"p"},"INTERNALFUNC")," - References an internal function matching the string that is passed to it."),(0,a.kt)("p",null,(0,a.kt)("inlineCode",{parentName:"p"},"STATEVAR")," - References the state variable matching the string passed to it."),(0,a.kt)("p",null,"Please note that the Solidity you are stubbing will still have to preserve the integrity of the AST, so whatever you are passing into your Cairo Block will have to match its corresponding Solidity function below."),(0,a.kt)("p",null,"Below is an example of how Cairo Blocks are intended to be used:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"// SPDX-License-Identifier: BUSL-1.1\npragma solidity ^0.8.14;\n\ncontract Example {\n\n  ///warp-cairo\n  ///DECORATOR(external)\n  ///func CURRENTFUNC()(lhs : felt, rhs : felt) -> (res : felt):\n  ///    if lhs == 0:\n  ///        return (rhs)\n  ///    else:\n  ///        return CURRENTFUNC()(lhs - 1, rhs + 1)\n  ///    end\n  ///end\n  function recursiveAdd(uint8 lhs, uint8 rhs) pure external returns (uint8) {\n    return 0;\n  }\n}\n")),(0,a.kt)("p",null,"The solidity code above gets transpiled into the following Cairo:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"%lang starknet\n\nfrom warplib.maths.external_input_check_ints import warp_external_input_check_int8\nfrom starkware.cairo.common.cairo_builtins import HashBuiltin\n\n# Contract Def Example\n\n@storage_var\nfunc WARP_STORAGE(index : felt) -> (val : felt):\nend\n@storage_var\nfunc WARP_USED_STORAGE() -> (val : felt):\nend\n@storage_var\nfunc WARP_NAMEGEN() -> (name : felt):\nend\nfunc readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(\n    loc : felt\n) -> (val : felt):\n    alloc_locals\n    let (id) = WARP_STORAGE.read(loc)\n    if id == 0:\n        let (id) = WARP_NAMEGEN.read()\n        WARP_NAMEGEN.write(id + 1)\n        WARP_STORAGE.write(loc, id + 1)\n        return (id + 1)\n    else:\n        return (id)\n    end\nend\n\nnamespace Example:\n    # Dynamic variables - Arrays and Maps\n\n    # Static variables\n\n    @external\n    func recursiveAdd_87bcdfdf(lhs : felt, rhs : felt) -> (res : felt):\n        if lhs == 0:\n            return (rhs)\n        else:\n            return recursiveAdd_87bcdfdf(lhs - 1, rhs + 1)\n        end\n    end\n\n    @constructor\n    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}():\n        alloc_locals\n\n        return ()\n    end\nend\n")),(0,a.kt)("p",null,"The contract above now has the CairoBlock present and its corresponding Solidity function removed."),(0,a.kt)("h2",{id:"additional-examples-of-using-cairo-blocks"},"Additional examples of using Cairo Blocks:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"pragma solidity ^0.8.10;\n\n// SDPX-License-Identifier: MIT\n\ncontract Base {\n  ///warp-cairo\n  ///DECORATOR(external)\n  ///func CURRENTFUNC()() -> (res: felt):\n  ///    return (1)\n  ///end\n  function externalDefinedInBase() virtual pure external returns (uint8) {\n    return 0;\n  }\n\n  ///warp-cairo\n  ///func CURRENTFUNC()() -> (res: felt):\n  ///    return (2)\n  ///end\n  function internalDefinedInBase() virtual pure internal returns (uint8) {\n    return 0;\n  }\n}\n\ncontract WARP is Base {\n  function testExternalDefinedInBase() view public returns (uint8) {\n    return this.externalDefinedInBase();\n  }\n\n  function testInternalDefinedInBase() pure public returns (uint8) {\n    return internalDefinedInBase();\n  }\n\n  ///warp-cairo\n  ///DECORATOR(external)\n  ///func CURRENTFUNC()() -> (res: felt):\n  ///    return (1)\n  ///end\n  function simpleCase() pure external returns (uint8) {\n    return 0;\n  }\n\n  ///warp-cairo\n  ///DECORATOR(external)\n  ///func CURRENTFUNC()(lhs : felt, rhs : felt) -> (res : felt):\n  ///    if lhs == 0:\n  ///        return (rhs)\n  ///    else:\n  ///        return CURRENTFUNC()(lhs - 1, rhs + 1)\n  ///    end\n  ///end\n  function recursiveAdd(uint8 lhs, uint8 rhs) pure external returns (uint8) {\n    return 0;\n  }\n}\n")),(0,a.kt)("p",null,"Cairo Blocks used for proxy:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"pragma solidity ^0.8.10;\n\n// SPDX-License-Identifier: MIT\n\ncontract WARP {\n  /// warp-cairo\n  /// from starkware.starknet.common.syscalls import library_call\n  /// DECORATOR(external)\n  /// DECORATOR(raw_input)\n  /// DECORATOR(raw_output)\n  /// func __default__{\n  ///     syscall_ptr : felt*,\n  ///     pedersen_ptr : HashBuiltin*,\n  ///     range_check_ptr,\n  /// }(selector : felt, calldata_size : felt, calldata : felt*) -> (\n  ///     retdata_size : felt, retdata : felt*\n  /// ):\n  ///     alloc_locals\n  ///     let (class_hash_low) = WARP_STORAGE.read(STATEVAR(implementation_hash))\n  ///     let (class_hash_high) = WARP_STORAGE.read(STATEVAR(implementation_hash) + 1)\n  ///     let class_hash = class_hash_low + 2**128 * class_hash_high\n  ///\n  ///     let (retdata_size : felt, retdata : felt*) = library_call(\n  ///         class_hash=class_hash,\n  ///         function_selector=selector,\n  ///         calldata_size=calldata_size,\n  ///         calldata=calldata,\n  ///     )\n  ///     return (retdata_size=retdata_size, retdata=retdata)\n  /// end\n  fallback() external {\n\n  }\n\n  uint256 implementation_hash = 0;\n\n  function setHash(uint256 newHash) external {\n    implementation_hash = newHash;\n  }\n}\n```\n")))}u.isMDXComponent=!0}}]);