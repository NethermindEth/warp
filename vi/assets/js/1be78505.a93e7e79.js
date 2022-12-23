"use strict";(self.webpackChunkwarp_docs=self.webpackChunkwarp_docs||[]).push([[514,75],{6756:(e,t,a)=>{a.r(t),a.d(t,{default:()=>X});var n=a(7294),l=a(3905),o=a(6291),c=a(2434),r=a(6010),i=a(5773),s=a(5537),d=a(7462);const m=function(e){return n.createElement("svg",(0,d.Z)({width:"20",height:"20","aria-hidden":"true"},e),n.createElement("g",{fill:"#7a7a7a"},n.createElement("path",{d:"M9.992 10.023c0 .2-.062.399-.172.547l-4.996 7.492a.982.982 0 01-.828.454H1c-.55 0-1-.453-1-1 0-.2.059-.403.168-.551l4.629-6.942L.168 3.078A.939.939 0 010 2.528c0-.548.45-.997 1-.997h2.996c.352 0 .649.18.828.45L9.82 9.472c.11.148.172.347.172.55zm0 0"}),n.createElement("path",{d:"M19.98 10.023c0 .2-.058.399-.168.547l-4.996 7.492a.987.987 0 01-.828.454h-3c-.547 0-.996-.453-.996-1 0-.2.059-.403.168-.551l4.625-6.942-4.625-6.945a.939.939 0 01-.168-.55 1 1 0 01.996-.997h3c.348 0 .649.18.828.45l4.996 7.492c.11.148.168.347.168.55zm0 0"})))};var u=a(5999),p=a(9960),b=a(3919),h=a(541);const E="menuLinkText_QVir",f="hasHref_VCh3";var g=a(2389);function v(e){let{item:t,...a}=e;return"category"===t.type?0===t.items.length?null:n.createElement(_,(0,d.Z)({item:t},a)):n.createElement(k,(0,d.Z)({item:t},a))}function _(e){let{item:t,onItemClick:a,activePath:l,level:o,index:c,...s}=e;const{items:m,label:b,collapsible:h,className:v,href:_}=t,k=function(e){const t=(0,g.Z)();return(0,n.useMemo)((()=>e.href?e.href:!t&&e.collapsible?(0,i.Wl)(e):void 0),[e,t])}(t),C=(0,i._F)(t,l),{collapsed:N,setCollapsed:I}=(0,i.uR)({initialState:()=>!!h&&(!C&&t.collapsed)});!function(e){let{isActive:t,collapsed:a,setCollapsed:l}=e;const o=(0,i.D9)(t);(0,n.useEffect)((()=>{t&&!o&&a&&l(!1)}),[t,o,a,l])}({isActive:C,collapsed:N,setCollapsed:I});const{expandedItem:Z,setExpandedItem:T}=(0,i.fP)();function M(e){void 0===e&&(e=!N),T(e?null:c),I(e)}const{autoCollapseSidebarCategories:x}=(0,i.LU)();return(0,n.useEffect)((()=>{h&&Z&&Z!==c&&x&&I(!0)}),[h,Z,c,I,x]),n.createElement("li",{className:(0,r.Z)(i.kM.docs.docSidebarItemCategory,i.kM.docs.docSidebarItemCategoryLevel(o),"menu__list-item",{"menu__list-item--collapsed":N},v)},n.createElement("div",{className:"menu__list-item-collapsible"},n.createElement(p.Z,(0,d.Z)({className:(0,r.Z)("menu__link",{"menu__link--sublist":h&&!_,"menu__link--active":C,[E]:!h,[f]:!!k}),onClick:h?e=>{null==a||a(t),_?M(!1):(e.preventDefault(),M())}:()=>{null==a||a(t)},"aria-current":C?"page":void 0,href:h?null!=k?k:"#":k},s),b),_&&h&&n.createElement("button",{"aria-label":(0,u.I)({id:"theme.DocSidebarItem.toggleCollapsedCategoryAriaLabel",message:"Toggle the collapsible sidebar category '{label}'",description:"The ARIA label to toggle the collapsible sidebar category"},{label:b}),type:"button",className:"clean-btn menu__caret",onClick:e=>{e.preventDefault(),M()}})),n.createElement(i.zF,{lazy:!0,as:"ul",className:"menu__list",collapsed:N},n.createElement(S,{items:m,tabIndex:N?-1:0,onItemClick:a,activePath:l,level:o+1})))}function k(e){let{item:t,onItemClick:a,activePath:l,level:o,index:c,...s}=e;const{href:m,label:u,className:E}=t,f=(0,i._F)(t,l);return n.createElement("li",{className:(0,r.Z)(i.kM.docs.docSidebarItemLink,i.kM.docs.docSidebarItemLinkLevel(o),"menu__list-item",E),key:u},n.createElement(p.Z,(0,d.Z)({className:(0,r.Z)("menu__link",{"menu__link--active":f}),"aria-current":f?"page":void 0,to:m},(0,b.Z)(m)&&{onClick:a?()=>a(t):void 0},s),(0,b.Z)(m)?u:n.createElement("span",null,u,n.createElement(h.Z,null))))}function C(e){let{items:t,...a}=e;return n.createElement(i.D_,null,t.map(((e,t)=>n.createElement(v,(0,d.Z)({key:t,item:e,index:t},a)))))}const S=(0,n.memo)(C),N="sidebar_CW9Y",I="sidebarWithHideableNavbar_FoYL",Z="sidebarHidden_D64r",T="sidebarLogo_FJUI",M="menu_SkdO",x="menuWithAnnouncementBar_x19h",y="collapseSidebarButton_cwdi",A="collapseSidebarButtonIcon_xORG";function L(e){let{onClick:t}=e;return n.createElement("button",{type:"button",title:(0,u.I)({id:"theme.docs.sidebar.collapseButtonTitle",message:"Collapse sidebar",description:"The title attribute for collapse button of doc sidebar"}),"aria-label":(0,u.I)({id:"theme.docs.sidebar.collapseButtonAriaLabel",message:"Collapse sidebar",description:"The title attribute for collapse button of doc sidebar"}),className:(0,r.Z)("button button--secondary button--outline",y),onClick:t},n.createElement(m,{className:A}))}function w(e){let{path:t,sidebar:a,onCollapse:l,isHidden:o}=e;const c=function(){const{isActive:e}=(0,i.nT)(),[t,a]=(0,n.useState)(e);return(0,i.RF)((t=>{let{scrollY:n}=t;e&&a(0===n)}),[e]),e&&t}(),{navbar:{hideOnScroll:d},hideableSidebar:m}=(0,i.LU)();return n.createElement("div",{className:(0,r.Z)(N,{[I]:d,[Z]:o})},d&&n.createElement(s.Z,{tabIndex:-1,className:T}),n.createElement("nav",{className:(0,r.Z)("menu thin-scrollbar",M,{[x]:c})},n.createElement("ul",{className:(0,r.Z)(i.kM.docs.docSidebarMenu,"menu__list")},n.createElement(S,{items:a,activePath:t,level:1}))),m&&n.createElement(L,{onClick:l}))}const F=e=>{let{toggleSidebar:t,sidebar:a,path:l}=e;return n.createElement("ul",{className:(0,r.Z)(i.kM.docs.docSidebarMenu,"menu__list")},n.createElement(S,{items:a,activePath:l,onItemClick:e=>{"category"===e.type&&e.href&&t(),"link"===e.type&&t()},level:1}))};function P(e){return n.createElement(i.Cv,{component:F,props:e})}const B=n.memo(w),D=n.memo(P);function R(e){const t=(0,i.iP)(),a="desktop"===t||"ssr"===t,l="mobile"===t;return n.createElement(n.Fragment,null,a&&n.createElement(B,e),l&&n.createElement(D,e))}var H=a(4689),W=a(4608);const Y="backToTopButton_RiI4",q="backToTopButtonShow_ssHd";function z(){const e=(0,n.useRef)(null);return{smoothScrollTop:function(){e.current=function(){let e=null;return function t(){const a=document.documentElement.scrollTop;a>0&&(e=requestAnimationFrame(t),window.scrollTo(0,Math.floor(.85*a)))}(),()=>e&&cancelAnimationFrame(e)}()},cancelScrollToTop:()=>null==e.current?void 0:e.current()}}const U=function(){const[e,t]=(0,n.useState)(!1),a=(0,n.useRef)(!1),{smoothScrollTop:l,cancelScrollToTop:o}=z();return(0,i.RF)(((e,n)=>{let{scrollY:l}=e;const c=null==n?void 0:n.scrollY;if(!c)return;if(a.current)return void(a.current=!1);const r=l<c;if(r||o(),l<300)t(!1);else if(r){const e=document.documentElement.scrollHeight;l+window.innerHeight<e&&t(!0)}else t(!1)})),(0,i.SL)((e=>{e.location.hash&&(a.current=!0,t(!1))})),n.createElement("button",{"aria-label":(0,u.I)({id:"theme.BackToTopButton.buttonAriaLabel",message:"Scroll back to top",description:"The ARIA label for the back to top button"}),className:(0,r.Z)("clean-btn",i.kM.common.backToTopButton,Y,{[q]:e}),type:"button",onClick:()=>l()})};var V=a(6775);const O={docPage:"docPage_P2Lg",docMainContainer:"docMainContainer_TCnq",docSidebarContainer:"docSidebarContainer_rKC_",docMainContainerEnhanced:"docMainContainerEnhanced_WDCb",docSidebarContainerHidden:"docSidebarContainerHidden_nvlY",collapsedDocSidebar:"collapsedDocSidebar_Xgr6",expandSidebarButtonIcon:"expandSidebarButtonIcon_AV8S",docItemWrapperEnhanced:"docItemWrapperEnhanced_r_WG"};var G=a(2859);function K(e){let{currentDocRoute:t,versionMetadata:a,children:o,sidebarName:s}=e;const d=(0,i.Vq)(),{pluginId:p,version:b}=a,[h,E]=(0,n.useState)(!1),[f,g]=(0,n.useState)(!1),v=(0,n.useCallback)((()=>{f&&g(!1),E((e=>!e))}),[f]);return n.createElement(c.Z,{wrapperClassName:i.kM.wrapper.docsPages,pageClassName:i.kM.page.docsDocPage,searchMetadata:{version:b,tag:(0,i.os)(p,b)}},n.createElement("div",{className:O.docPage},n.createElement(U,null),d&&n.createElement("aside",{className:(0,r.Z)(i.kM.docs.docSidebarContainer,O.docSidebarContainer,{[O.docSidebarContainerHidden]:h}),onTransitionEnd:e=>{e.currentTarget.classList.contains(O.docSidebarContainer)&&h&&g(!0)}},n.createElement(R,{key:s,sidebar:d,path:t.path,onCollapse:v,isHidden:f}),f&&n.createElement("div",{className:O.collapsedDocSidebar,title:(0,u.I)({id:"theme.docs.sidebar.expandButtonTitle",message:"Expand sidebar",description:"The ARIA label and title attribute for expand button of doc sidebar"}),"aria-label":(0,u.I)({id:"theme.docs.sidebar.expandButtonAriaLabel",message:"Expand sidebar",description:"The ARIA label and title attribute for expand button of doc sidebar"}),tabIndex:0,role:"button",onKeyDown:v,onClick:v},n.createElement(m,{className:O.expandSidebarButtonIcon}))),n.createElement("main",{className:(0,r.Z)(O.docMainContainer,{[O.docMainContainerEnhanced]:h||!d})},n.createElement("div",{className:(0,r.Z)("container padding-top--md padding-bottom--lg",O.docItemWrapper,{[O.docItemWrapperEnhanced]:h})},n.createElement(l.Zo,{components:H.Z},o)))))}const X=function(e){const{route:{routes:t},versionMetadata:a,location:l}=e,c=t.find((e=>(0,V.LX)(l.pathname,e)));if(!c)return n.createElement(W.default,null);const r=c.sidebar,s=r?a.docsSidebars[r]:null;return n.createElement(n.Fragment,null,n.createElement(G.Z,null,n.createElement("html",{className:a.className})),n.createElement(i.qu,{version:a},n.createElement(i.bT,{sidebar:s},n.createElement(K,{currentDocRoute:c,versionMetadata:a,sidebarName:r},(0,o.Z)(t,{versionMetadata:a})))))}},4608:(e,t,a)=>{a.r(t),a.d(t,{default:()=>c});var n=a(7294),l=a(2434),o=a(5999);const c=function(){return n.createElement(l.Z,{title:(0,o.I)({id:"theme.NotFound.title",message:"Page Not Found"})},n.createElement("main",{className:"container margin-vert--xl"},n.createElement("div",{className:"row"},n.createElement("div",{className:"col col--6 col--offset-3"},n.createElement("h1",{className:"hero__title"},n.createElement(o.Z,{id:"theme.NotFound.title",description:"The title of the 404 page"},"Page Not Found")),n.createElement("p",null,n.createElement(o.Z,{id:"theme.NotFound.p1",description:"The first paragraph of the 404 page"},"We could not find what you were looking for.")),n.createElement("p",null,n.createElement(o.Z,{id:"theme.NotFound.p2",description:"The 2nd paragraph of the 404 page"},"Please contact the owner of the site that linked you to the original URL and let them know their link is broken."))))))}}}]);