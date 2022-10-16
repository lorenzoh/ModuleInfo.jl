var dr=Object.defineProperty;var vr=(e,r,n)=>r in e?dr(e,r,{enumerable:!0,configurable:!0,writable:!0,value:n}):e[r]=n;var G=(e,r,n)=>(vr(e,typeof r!="symbol"?r+"":r,n),n);import{R as yr,H as gr}from"./control-6eaf9e57.js";function hr(e,r){return new gr(e,r)}function Rn(e,r){if(isNaN(e)||e<300||e>399)throw new Error("Invalid status code");return new yr(e,r)}var S=typeof globalThis<"u"?globalThis:typeof window<"u"?window:typeof global<"u"?global:typeof self<"u"?self:{},me={},nr={};Object.defineProperty(nr,"__esModule",{value:!0});var ye={};Object.defineProperty(ye,"__esModule",{value:!0});ye.Failcode=void 0;ye.Failcode={TYPE_INCORRECT:"TYPE_INCORRECT",VALUE_INCORRECT:"VALUE_INCORRECT",KEY_INCORRECT:"KEY_INCORRECT",CONTENT_INCORRECT:"CONTENT_INCORRECT",ARGUMENT_INCORRECT:"ARGUMENT_INCORRECT",RETURN_INCORRECT:"RETURN_INCORRECT",CONSTRAINT_FAILED:"CONSTRAINT_FAILED",PROPERTY_MISSING:"PROPERTY_MISSING",PROPERTY_PRESENT:"PROPERTY_PRESENT",NOTHING_EXPECTED:"NOTHING_EXPECTED"};var Re={},K={},Rr=S&&S.__extends||function(){var e=function(r,n){return e=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,a){t.__proto__=a}||function(t,a){for(var o in a)Object.prototype.hasOwnProperty.call(a,o)&&(t[o]=a[o])},e(r,n)};return function(r,n){if(typeof n!="function"&&n!==null)throw new TypeError("Class extends value "+String(n)+" is not a constructor or null");e(r,n);function t(){this.constructor=r}r.prototype=n===null?Object.create(n):(t.prototype=n.prototype,new t)}}();Object.defineProperty(K,"__esModule",{value:!0});K.ValidationError=void 0;var Er=function(e){Rr(r,e);function r(n){var t=e.call(this,n.message)||this;return t.name="ValidationError",t.code=n.code,n.details!==void 0&&(t.details=n.details),Object.setPrototypeOf(t,r.prototype),t}return r}(Error);K.ValidationError=Er;var T={},H={};Object.defineProperty(H,"__esModule",{value:!0});var ge=function(e){return function(r){switch(r.tag){case"literal":return'"'.concat(String(r.value),'"');case"string":return"string";case"brand":return r.brand;case"constraint":return r.name||ge(e)(r.underlying);case"union":return r.alternatives.map(ge(e)).join(" | ");case"intersect":return r.intersectees.map(ge(e)).join(" & ")}return"`${".concat(q(!1,e)(r),"}`")}},he=function(e){return function(r){switch(r.tag){case"literal":return String(r.value);case"brand":return"${".concat(r.brand,"}");case"constraint":return r.name?"${".concat(r.name,"}"):he(e)(r.underlying);case"union":if(r.alternatives.length===1){var n=r.alternatives[0];return he(e)(n.reflect)}break;case"intersect":if(r.intersectees.length===1){var n=r.intersectees[0];return he(e)(n.reflect)}break}return"${".concat(q(!1,e)(r),"}")}},q=function(e,r){return function(n){var t=function(c){return e?"(".concat(c,")"):c};if(r.has(n))return t("CIRCULAR ".concat(n.tag));r.add(n);try{switch(n.tag){case"unknown":case"never":case"void":case"boolean":case"number":case"bigint":case"string":case"symbol":case"function":return n.tag;case"literal":{var a=n.value;return typeof a=="string"?'"'.concat(a,'"'):String(a)}case"template":{if(n.strings.length===0)return'""';if(n.strings.length===1)return'"'.concat(n.strings[0],'"');if(n.strings.length===2&&n.strings.every(function(c){return c===""})){var o=n.runtypes[0];return ge(r)(o.reflect)}var f=!1,y=n.strings.reduce(function(c,l,g){var h=c+l,R=n.runtypes[g];if(R){var E=he(r)(R.reflect);return!f&&E.startsWith("$")&&(f=!0),h+E}else return h},"");return f?"`".concat(y,"`"):'"'.concat(y,'"')}case"array":return"".concat(we(n)).concat(q(!0,r)(n.element),"[]");case"dictionary":return"{ [_: ".concat(n.key,"]: ").concat(q(!1,r)(n.value)," }");case"record":{var i=Object.keys(n.fields);return i.length?"{ ".concat(i.map(function(c){return"".concat(we(n)).concat(c).concat(mr(n,c),": ").concat(n.fields[c].tag==="optional"?q(!1,r)(n.fields[c].underlying):q(!1,r)(n.fields[c]),";")}).join(" ")," }"):"{}"}case"tuple":return"[".concat(n.components.map(q(!1,r)).join(", "),"]");case"union":return t("".concat(n.alternatives.map(q(!0,r)).join(" | ")));case"intersect":return t("".concat(n.intersectees.map(q(!0,r)).join(" & ")));case"optional":return q(e,r)(n.underlying)+" | undefined";case"constraint":return n.name||q(e,r)(n.underlying);case"instanceof":return n.ctor.name;case"brand":return q(e,r)(n.entity)}}finally{r.delete(n)}throw Error("impossible")}};H.default=q(!1,new Set);function mr(e,r){var n=e.isPartial,t=e.fields;return n||r!==void 0&&t[r].tag==="optional"?"?":""}function we(e){var r=e.isReadonly;return r?"readonly ":""}(function(e){var r=S&&S.__assign||function(){return r=Object.assign||function(i){for(var c,l=1,g=arguments.length;l<g;l++){c=arguments[l];for(var h in c)Object.prototype.hasOwnProperty.call(c,h)&&(i[h]=c[h])}return i},r.apply(this,arguments)};Object.defineProperty(e,"__esModule",{value:!0}),e.FAILURE=e.SUCCESS=e.enumerableKeysOf=e.typeOf=e.hasKey=void 0;var n=ye,t=H;function a(i,c){return typeof c=="object"&&c!==null&&i in c}e.hasKey=a;var o=function(i){var c,l,g;return typeof i=="object"?i===null?"null":Array.isArray(i)?"array":((c=i.constructor)===null||c===void 0?void 0:c.name)==="Object"?"object":(g=(l=i.constructor)===null||l===void 0?void 0:l.name)!==null&&g!==void 0?g:typeof i:typeof i};e.typeOf=o;var f=function(i){return typeof i=="object"&&i!==null?Reflect.ownKeys(i).filter(function(c){var l,g;return(g=(l=i.propertyIsEnumerable)===null||l===void 0?void 0:l.call(i,c))!==null&&g!==void 0?g:!0}):[]};e.enumerableKeysOf=f;function y(i){return{success:!0,value:i}}e.SUCCESS=y,e.FAILURE=Object.assign(function(i,c,l){return r({success:!1,code:i,message:c},l?{details:l}:{})},{TYPE_INCORRECT:function(i,c){var l="Expected ".concat(i.tag==="template"?"string ".concat((0,t.default)(i)):(0,t.default)(i),", but was ").concat((0,e.typeOf)(c));return(0,e.FAILURE)(n.Failcode.TYPE_INCORRECT,l)},VALUE_INCORRECT:function(i,c,l){return(0,e.FAILURE)(n.Failcode.VALUE_INCORRECT,"Expected ".concat(i," ").concat(String(c),", but was ").concat(String(l)))},KEY_INCORRECT:function(i,c,l){return(0,e.FAILURE)(n.Failcode.KEY_INCORRECT,"Expected ".concat((0,t.default)(i)," key to be ").concat((0,t.default)(c),", but was ").concat((0,e.typeOf)(l)))},CONTENT_INCORRECT:function(i,c){var l=JSON.stringify(c,null,2).replace(/^ *null,\n/gm,""),g=`Validation failed:
`.concat(l,`.
Object should match `).concat((0,t.default)(i));return(0,e.FAILURE)(n.Failcode.CONTENT_INCORRECT,g,c)},ARGUMENT_INCORRECT:function(i){return(0,e.FAILURE)(n.Failcode.ARGUMENT_INCORRECT,i)},RETURN_INCORRECT:function(i){return(0,e.FAILURE)(n.Failcode.RETURN_INCORRECT,i)},CONSTRAINT_FAILED:function(i,c){var l=c?": ".concat(c):"";return(0,e.FAILURE)(n.Failcode.CONSTRAINT_FAILED,"Failed constraint check for ".concat((0,t.default)(i)).concat(l))},PROPERTY_MISSING:function(i){var c="Expected ".concat((0,t.default)(i),", but was missing");return(0,e.FAILURE)(n.Failcode.PROPERTY_MISSING,c)},PROPERTY_PRESENT:function(i){var c="Expected nothing, but was ".concat((0,e.typeOf)(i));return(0,e.FAILURE)(n.Failcode.PROPERTY_PRESENT,c)},NOTHING_EXPECTED:function(i){var c="Expected nothing, but was ".concat((0,e.typeOf)(i));return(0,e.FAILURE)(n.Failcode.NOTHING_EXPECTED,c)}})})(T);var pr=S&&S.__read||function(e,r){var n=typeof Symbol=="function"&&e[Symbol.iterator];if(!n)return e;var t=n.call(e),a,o=[],f;try{for(;(r===void 0||r-- >0)&&!(a=t.next()).done;)o.push(a.value)}catch(y){f={error:y}}finally{try{a&&!a.done&&(n=t.return)&&n.call(t)}finally{if(f)throw f.error}}return o},_r=S&&S.__spreadArray||function(e,r,n){if(n||arguments.length===2)for(var t=0,a=r.length,o;t<a;t++)(o||!(t in r))&&(o||(o=Array.prototype.slice.call(r,0,t)),o[t]=r[t]);return e.concat(o||Array.prototype.slice.call(r))};Object.defineProperty(Re,"__esModule",{value:!0});Re.Contract=void 0;var br=K,Sr=T;function Cr(){for(var e=[],r=0;r<arguments.length;r++)e[r]=arguments[r];var n=e.length-1,t=e.slice(0,n),a=e[n];return{enforce:function(o){return function(){for(var f=[],y=0;y<arguments.length;y++)f[y]=arguments[y];if(f.length<t.length){var i="Expected ".concat(t.length," arguments but only received ").concat(f.length),c=Sr.FAILURE.ARGUMENT_INCORRECT(i);throw new br.ValidationError(c)}for(var l=0;l<t.length;l++)t[l].check(f[l]);return a.check(o.apply(void 0,_r([],pr(f),!1)))}}}}Re.Contract=Cr;var Ee={},Or=S&&S.__read||function(e,r){var n=typeof Symbol=="function"&&e[Symbol.iterator];if(!n)return e;var t=n.call(e),a,o=[],f;try{for(;(r===void 0||r-- >0)&&!(a=t.next()).done;)o.push(a.value)}catch(y){f={error:y}}finally{try{a&&!a.done&&(n=t.return)&&n.call(t)}finally{if(f)throw f.error}}return o},Ir=S&&S.__spreadArray||function(e,r,n){if(n||arguments.length===2)for(var t=0,a=r.length,o;t<a;t++)(o||!(t in r))&&(o||(o=Array.prototype.slice.call(r,0,t)),o[t]=r[t]);return e.concat(o||Array.prototype.slice.call(r))};Object.defineProperty(Ee,"__esModule",{value:!0});Ee.AsyncContract=void 0;var Ue=K,Pe=T;function Tr(){for(var e=[],r=0;r<arguments.length;r++)e[r]=arguments[r];var n=e.length-1,t=e.slice(0,n),a=e[n];return{enforce:function(o){return function(){for(var f=[],y=0;y<arguments.length;y++)f[y]=arguments[y];if(f.length<t.length){var i="Expected ".concat(t.length," arguments but only received ").concat(f.length),c=Pe.FAILURE.ARGUMENT_INCORRECT(i);throw new Ue.ValidationError(c)}for(var l=0;l<t.length;l++)t[l].check(f[l]);var g=o.apply(void 0,Ir([],Or(f),!1));if(!(g instanceof Promise)){var i="Expected function to return a promise, but instead got ".concat(g),c=Pe.FAILURE.RETURN_INCORRECT(i);throw new Ue.ValidationError(c)}return g.then(a.check)}}}}Ee.AsyncContract=Tr;var $={},Nr=S&&S.__values||function(e){var r=typeof Symbol=="function"&&Symbol.iterator,n=r&&e[r],t=0;if(n)return n.call(e);if(e&&typeof e.length=="number")return{next:function(){return e&&t>=e.length&&(e=void 0),{value:e&&e[t++],done:!e}}};throw new TypeError(r?"Object is not iterable.":"Symbol.iterator is not defined.")},wr=S&&S.__read||function(e,r){var n=typeof Symbol=="function"&&e[Symbol.iterator];if(!n)return e;var t=n.call(e),a,o=[],f;try{for(;(r===void 0||r-- >0)&&!(a=t.next()).done;)o.push(a.value)}catch(y){f={error:y}}finally{try{a&&!a.done&&(n=t.return)&&n.call(t)}finally{if(f)throw f.error}}return o};Object.defineProperty($,"__esModule",{value:!0});$.when=$.match=void 0;function Ur(){for(var e=[],r=0;r<arguments.length;r++)e[r]=arguments[r];return function(n){var t,a;try{for(var o=Nr(e),f=o.next();!f.done;f=o.next()){var y=wr(f.value,2),i=y[0],c=y[1];if(i.guard(n))return c(n)}}catch(l){t={error:l}}finally{try{f&&!f.done&&(a=o.return)&&a.call(o)}finally{if(t)throw t.error}}throw new Error("No alternatives were matched")}}$.match=Ur;function Pr(e,r){return[e,r]}$.when=Pr;var X={},D={},Le;function P(){if(Le)return D;Le=1,Object.defineProperty(D,"__esModule",{value:!0}),D.innerValidate=D.create=D.isRuntype=void 0;var e=ur(),r=H,n=K,t=T,a=Symbol(),o=function(c){return(0,t.hasKey)(a,c)};D.isRuntype=o;function f(c,l){return l[a]=!0,l.check=g,l.assert=g,l._innerValidate=function(d,v){return v.has(d,l)?(0,t.SUCCESS)(d):c(d,v)},l.validate=function(d){return l._innerValidate(d,i())},l.guard=h,l.Or=R,l.And=E,l.optional=_,l.nullable=w,l.withConstraint=L,l.withGuard=C,l.withBrand=u,l.reflect=l,l.toString=function(){return"Runtype<".concat((0,r.default)(l),">")},l;function g(d){var v=l.validate(d);if(v.success)return v.value;throw new n.ValidationError(v)}function h(d){return l.validate(d).success}function R(d){return(0,e.Union)(l,d)}function E(d){return(0,e.Intersect)(l,d)}function _(){return(0,e.Optional)(l)}function w(){return(0,e.Union)(l,e.Null)}function L(d,v){return(0,e.Constraint)(l,d,v)}function C(d,v){return(0,e.Constraint)(l,d,v)}function u(d){return(0,e.Brand)(d,l)}}D.create=f;function y(c,l,g){return c._innerValidate(l,g)}D.innerValidate=y;function i(){var c=new WeakMap,l=function(h,R){if(!(h===null||typeof h!="object")){var E=c.get(h);c.set(h,E?E.set(R,!0):new WeakMap().set(R,!0))}},g=function(h,R){var E=c.get(h),_=E&&E.get(R)||!1;return l(h,R),_};return{has:g}}return D}var Ae;function Oe(){if(Ae)return X;Ae=1,Object.defineProperty(X,"__esModule",{value:!0}),X.Unknown=void 0;var e=P(),r=T,n={tag:"unknown"};return X.Unknown=(0,e.create)(function(t){return(0,r.SUCCESS)(t)},n),X}var J={},Fe;function Lr(){if(Fe)return J;Fe=1,Object.defineProperty(J,"__esModule",{value:!0}),J.Never=void 0;var e=P(),r=T,n={tag:"never"};return J.Never=(0,e.create)(r.FAILURE.NOTHING_EXPECTED,n),J}var Q={},je;function Ar(){if(je)return Q;je=1,Object.defineProperty(Q,"__esModule",{value:!0}),Q.Void=void 0;var e=Oe();return Q.Void=e.Unknown,Q}var pe={},Z={},Me;function tr(){if(Me)return Z;Me=1;var e=S&&S.__values||function(a){var o=typeof Symbol=="function"&&Symbol.iterator,f=o&&a[o],y=0;if(f)return f.call(a);if(a&&typeof a.length=="number")return{next:function(){return a&&y>=a.length&&(a=void 0),{value:a&&a[y++],done:!a}}};throw new TypeError(o?"Object is not iterable.":"Symbol.iterator is not defined.")};Object.defineProperty(Z,"__esModule",{value:!0}),Z.Union=void 0;var r=P(),n=T;function t(){for(var a=[],o=0;o<arguments.length;o++)a[o]=arguments[o];var f=function(){for(var i=[],c=0;c<arguments.length;c++)i[c]=arguments[c];return function(l){for(var g=0;g<a.length;g++)if(a[g].guard(l))return i[g](l)}},y={tag:"union",alternatives:a,match:f};return(0,r.create)(function(i,c){var l,g,h,R,E,_,w,L;if(typeof i!="object"||i===null){try{for(var C=e(a),u=C.next();!u.done;u=C.next()){var d=u.value;if((0,r.innerValidate)(d,i,c).success)return(0,n.SUCCESS)(i)}}catch(F){l={error:F}}finally{try{u&&!u.done&&(g=C.return)&&g.call(C)}finally{if(l)throw l.error}}return n.FAILURE.TYPE_INCORRECT(y,i)}var v={};try{for(var m=e(a),p=m.next();!p.done;p=m.next()){var d=p.value;if(d.reflect.tag==="record"){var b=function(k){var V=d.reflect.fields[k];V.tag==="literal"&&(v[k]?v[k].every(function(W){return W!==V.value})&&v[k].push(V.value):v[k]=[V.value])};for(var O in d.reflect.fields)b(O)}}}catch(F){h={error:F}}finally{try{p&&!p.done&&(R=m.return)&&R.call(m)}finally{if(h)throw h.error}}for(var O in v)if(v[O].length===a.length)try{for(var U=(E=void 0,e(a)),I=U.next();!I.done;I=U.next()){var d=I.value;if(d.reflect.tag==="record"){var j=d.reflect.fields[O];if(j.tag==="literal"&&(0,n.hasKey)(O,i)&&i[O]===j.value)return(0,r.innerValidate)(d,i,c)}}}catch(k){E={error:k}}finally{try{I&&!I.done&&(_=U.return)&&_.call(U)}finally{if(E)throw E.error}}try{for(var A=e(a),N=A.next();!N.done;N=A.next()){var M=N.value;if((0,r.innerValidate)(M,i,c).success)return(0,n.SUCCESS)(i)}}catch(F){w={error:F}}finally{try{N&&!N.done&&(L=A.return)&&L.call(A)}finally{if(w)throw w.error}}return n.FAILURE.TYPE_INCORRECT(y,i)},y)}return Z.Union=t,Z}var ke;function ar(){return ke||(ke=1,function(e){Object.defineProperty(e,"__esModule",{value:!0}),e.Nullish=e.Null=e.Undefined=e.Literal=e.literal=void 0;var r=P(),n=T,t=tr();function a(f){return Array.isArray(f)?String(f.map(String)):typeof f=="bigint"?String(f)+"n":String(f)}e.literal=a;function o(f){var y={tag:"literal",value:f};return(0,r.create)(function(i){return i===f?(0,n.SUCCESS)(i):n.FAILURE.VALUE_INCORRECT("literal","`".concat(a(f),"`"),"`".concat(a(i),"`"))},y)}e.Literal=o,e.Undefined=o(void 0),e.Null=o(null),e.Nullish=(0,t.Union)(e.Null,e.Undefined)}(pe)),pe}var x={},qe;function Fr(){if(qe)return x;qe=1;var e=S&&S.__read||function(u,d){var v=typeof Symbol=="function"&&u[Symbol.iterator];if(!v)return u;var m=v.call(u),p,b=[],O;try{for(;(d===void 0||d-- >0)&&!(p=m.next()).done;)b.push(p.value)}catch(U){O={error:U}}finally{try{p&&!p.done&&(v=m.return)&&v.call(m)}finally{if(O)throw O.error}}return b},r=S&&S.__spreadArray||function(u,d,v){if(v||arguments.length===2)for(var m=0,p=d.length,b;m<p;m++)(b||!(m in d))&&(b||(b=Array.prototype.slice.call(d,0,m)),b[m]=d[m]);return u.concat(b||Array.prototype.slice.call(d))},n=S&&S.__values||function(u){var d=typeof Symbol=="function"&&Symbol.iterator,v=d&&u[d],m=0;if(v)return v.call(u);if(u&&typeof u.length=="number")return{next:function(){return u&&m>=u.length&&(u=void 0),{value:u&&u[m++],done:!u}}};throw new TypeError(d?"Object is not iterable.":"Symbol.iterator is not defined.")};Object.defineProperty(x,"__esModule",{value:!0}),x.Template=void 0;var t=P(),a=H,o=T,f=ar(),y=function(u){return u.replace(/[.*+?^${}()|[\]\\]/g,"\\$&")},i=function(u){if(0<u.length&&Array.isArray(u[0])){var d=e(u),v=d[0],m=d.slice(1);return[Array.from(v),m]}else{var p=u,v=p.reduce(function(U,I){return(0,t.isRuntype)(I)?U.push(""):U.push(U.pop()+String(I)),U},[""]),m=p.filter(t.isRuntype);return[v,m]}},c=function(u,d){for(var v=0;v<d.length;)switch(d[v].reflect.tag){case"literal":{var m=d[v];d.splice(v,1);var p=String(m.value);u.splice(v,2,u[v]+p+u[v+1]);break}case"template":{var b=d[v];d.splice.apply(d,r([v,1],e(b.runtypes),!1));var O=b.strings;if(O.length===1)u.splice(v,2,u[v]+O[0]+u[v+1]);else{var U=O[0],I=O.slice(1,-1),j=O[O.length-1];u.splice.apply(u,r(r([v,2,u[v]+U],e(I),!1),[j+u[v+1]],!1))}break}case"union":{var A=d[v];if(A.alternatives.length===1)try{var N=g(A);d.splice(v,1);var p=String(N.value);u.splice(v,2,u[v]+p+u[v+1]);break}catch{v++;break}else{v++;break}}case"intersect":{var M=d[v];if(M.intersectees.length===1)try{var F=g(M);d.splice(v,1);var p=String(F.value);u.splice(v,2,u[v]+p+u[v+1]);break}catch{v++;break}else{v++;break}}default:v++;break}},l=function(u){var d=e(i(u),2),v=d[0],m=d[1];return c(v,m),[v,m]},g=function(u){switch(u.reflect.tag){case"literal":return u;case"brand":return g(u.reflect.entity);case"union":if(u.reflect.alternatives.length===1)return g(u.reflect.alternatives[0]);break;case"intersect":if(u.reflect.intersectees.length===1)return g(u.reflect.intersectees[0]);break}throw void 0},h=function(u){return u},R={string:[function(u){return globalThis.String(u)},".*"],number:[function(u){return globalThis.Number(u)},"[+-]?(?:\\d*\\.\\d+|\\d+\\.\\d*|\\d+)(?:[Ee][+-]?\\d+)?","0[Bb][01]+","0[Oo][0-7]+","0[Xx][0-9A-Fa-f]+"],bigint:[function(u){return globalThis.BigInt(u)},"-?[1-9]d*"],boolean:[function(u){return u!=="false"},"true","false"],null:[function(){return null},"null"],undefined:[function(){},"undefined"]},E=function(u){switch(u.tag){case"literal":{var d=e(R[(0,o.typeOf)(u.value)]||[h],1),v=d[0];return v}case"brand":return E(u.entity);case"constraint":return E(u.underlying);case"union":return u.alternatives.map(E);case"intersect":return u.intersectees.map(E);default:var m=e(R[u.tag]||[h],1),p=m[0];return p}},_=function(u,d){return function(v){var m,p,b,O,U=E(u);if(Array.isArray(U))switch(u.tag){case"union":try{for(var I=n(u.alternatives),j=I.next();!j.done;j=I.next()){var A=j.value,N=_(A.reflect,d)(v);if(N.success)return N}}catch(W){m={error:W}}finally{try{j&&!j.done&&(p=I.return)&&p.call(I)}finally{if(m)throw m.error}}return o.FAILURE.TYPE_INCORRECT(u,v);case"intersect":try{for(var M=n(u.intersectees),F=M.next();!F.done;F=M.next()){var k=F.value,N=_(k.reflect,d)(v);if(!N.success)return N}}catch(W){b={error:W}}finally{try{F&&!F.done&&(O=M.return)&&O.call(M)}finally{if(b)throw b.error}}return(0,o.SUCCESS)(v);default:throw Error("impossible")}else{var V=U,N=(0,t.innerValidate)(u,V(v),d);return!N.success&&N.code==="VALUE_INCORRECT"&&u.tag==="literal"?o.FAILURE.VALUE_INCORRECT("literal",'"'.concat((0,f.literal)(u.value),'"'),'"'.concat(v,'"')):N}}},w=function(u){switch(u.tag){case"literal":return y(String(u.value));case"brand":return w(u.entity);case"constraint":return w(u.underlying);case"union":return u.alternatives.map(w).join("|");case"template":return u.strings.map(y).reduce(function(m,p,b){var O=m+p,U=u.runtypes[b];return U?O+"(?:".concat(w(U.reflect),")"):O},"");default:var d=e(R[u.tag]||[void 0,".*"]),v=d.slice(1);return v.join("|")}},L=function(u){var d=u.strings.map(y).reduce(function(v,m,p){var b=v+m,O=u.runtypes[p];return O?b+"(".concat(w(O.reflect),")"):b},"");return new RegExp("^".concat(d,"$"),"su")};function C(){for(var u=[],d=0;d<arguments.length;d++)u[d]=arguments[d];var v=e(l(u),2),m=v[0],p=v[1],b={tag:"template",strings:m,runtypes:p},O=L(b),U=function(I,j){var A=I.match(O);if(A){for(var N=A.slice(1),M=0;M<p.length;M++){var F=p[M],k=N[M],V=_(F.reflect,j)(k);if(!V.success)return V}return(0,o.SUCCESS)(I)}else return o.FAILURE.VALUE_INCORRECT("string","".concat((0,a.default)(b)),'"'.concat((0,f.literal)(I),'"'))};return(0,t.create)(function(I,j){if(typeof I!="string")return o.FAILURE.TYPE_INCORRECT(b,I);var A=U(I,j);if(A.success)return(0,o.SUCCESS)(I);var N=o.FAILURE.VALUE_INCORRECT("string","".concat((0,a.default)(b)),'"'.concat(I,'"'));return N.message!==A.message&&(N.message+=" (inner: ".concat(A.message,")")),N},b)}return x.Template=C,x}var ee={},Ve;function jr(){if(Ve)return ee;Ve=1,Object.defineProperty(ee,"__esModule",{value:!0}),ee.Boolean=void 0;var e=P(),r=T,n={tag:"boolean"};return ee.Boolean=(0,e.create)(function(t){return typeof t=="boolean"?(0,r.SUCCESS)(t):r.FAILURE.TYPE_INCORRECT(n,t)},n),ee}var re={},De;function Mr(){if(De)return re;De=1,Object.defineProperty(re,"__esModule",{value:!0}),re.Number=void 0;var e=P(),r=T,n={tag:"number"};return re.Number=(0,e.create)(function(t){return typeof t=="number"?(0,r.SUCCESS)(t):r.FAILURE.TYPE_INCORRECT(n,t)},n),re}var ne={},Ye;function kr(){if(Ye)return ne;Ye=1,Object.defineProperty(ne,"__esModule",{value:!0}),ne.BigInt=void 0;var e=P(),r=T,n={tag:"bigint"};return ne.BigInt=(0,e.create)(function(t){return typeof t=="bigint"?(0,r.SUCCESS)(t):r.FAILURE.TYPE_INCORRECT(n,t)},n),ne}var te={},Ke;function ir(){if(Ke)return te;Ke=1,Object.defineProperty(te,"__esModule",{value:!0}),te.String=void 0;var e=P(),r=T,n={tag:"string"};return te.String=(0,e.create)(function(t){return typeof t=="string"?(0,r.SUCCESS)(t):r.FAILURE.TYPE_INCORRECT(n,t)},n),te}var ae={},Ge;function qr(){if(Ge)return ae;Ge=1,Object.defineProperty(ae,"__esModule",{value:!0}),ae.Symbol=void 0;var e=P(),r=T,n=function(o){var f={tag:"symbol",key:o};return(0,e.create)(function(y){if(typeof y!="symbol")return r.FAILURE.TYPE_INCORRECT(f,y);var i=globalThis.Symbol.keyFor(y);return i!==o?r.FAILURE.VALUE_INCORRECT("symbol key",a(o),a(i)):(0,r.SUCCESS)(y)},f)},t={tag:"symbol"};ae.Symbol=(0,e.create)(function(o){return typeof o=="symbol"?(0,r.SUCCESS)(o):r.FAILURE.TYPE_INCORRECT(t,o)},Object.assign(n,t));var a=function(o){return o===void 0?"undefined":'"'.concat(o,'"')};return ae}var ie={},Be;function Vr(){if(Be)return ie;Be=1,Object.defineProperty(ie,"__esModule",{value:!0}),ie.Array=void 0;var e=P(),r=T;function n(o,f){var y={tag:"array",isReadonly:f,element:o};return a((0,e.create)(function(i,c){if(!Array.isArray(i))return r.FAILURE.TYPE_INCORRECT(y,i);var l=(0,r.enumerableKeysOf)(i),g=l.map(function(R){return(0,e.innerValidate)(o,i[R],c)}),h=l.reduce(function(R,E){var _=g[E];return _.success||(R[E]=_.details||_.message),R},[]);return(0,r.enumerableKeysOf)(h).length!==0?r.FAILURE.CONTENT_INCORRECT(y,h):(0,r.SUCCESS)(i)},y))}function t(o){return n(o,!1)}ie.Array=t;function a(o){return o.asReadonly=f,o;function f(){return n(o.element,!0)}}return ie}var oe={},$e;function Dr(){if($e)return oe;$e=1,Object.defineProperty(oe,"__esModule",{value:!0}),oe.Tuple=void 0;var e=P(),r=T;function n(){for(var t=[],a=0;a<arguments.length;a++)t[a]=arguments[a];var o={tag:"tuple",components:t};return(0,e.create)(function(f,y){if(!Array.isArray(f))return r.FAILURE.TYPE_INCORRECT(o,f);if(f.length!==t.length)return r.FAILURE.CONSTRAINT_FAILED(o,"Expected length ".concat(t.length,", but was ").concat(f.length));var i=(0,r.enumerableKeysOf)(f),c=i.map(function(g){return(0,e.innerValidate)(t[g],f[g],y)}),l=i.reduce(function(g,h){var R=c[h];return R.success||(g[h]=R.details||R.message),g},[]);return(0,r.enumerableKeysOf)(l).length!==0?r.FAILURE.CONTENT_INCORRECT(o,l):(0,r.SUCCESS)(f)},o)}return oe.Tuple=n,oe}var Y={},ze;function Yr(){if(ze)return Y;ze=1;var e=S&&S.__read||function(i,c){var l=typeof Symbol=="function"&&i[Symbol.iterator];if(!l)return i;var g=l.call(i),h,R=[],E;try{for(;(c===void 0||c-- >0)&&!(h=g.next()).done;)R.push(h.value)}catch(_){E={error:_}}finally{try{h&&!h.done&&(l=g.return)&&l.call(g)}finally{if(E)throw E.error}}return R},r=S&&S.__spreadArray||function(i,c,l){if(l||arguments.length===2)for(var g=0,h=c.length,R;g<h;g++)(R||!(g in c))&&(R||(R=Array.prototype.slice.call(c,0,g)),R[g]=c[g]);return i.concat(R||Array.prototype.slice.call(c))};Object.defineProperty(Y,"__esModule",{value:!0}),Y.Partial=Y.Record=Y.InternalRecord=void 0;var n=P(),t=T;function a(i,c,l){var g={tag:"record",isPartial:c,isReadonly:l,fields:i};return y((0,n.create)(function(h,R){if(h==null)return t.FAILURE.TYPE_INCORRECT(g,h);var E=(0,t.enumerableKeysOf)(i);if(E.length!==0&&typeof h!="object")return t.FAILURE.TYPE_INCORRECT(g,h);var _=r([],e(new Set(r(r([],e(E),!1),e((0,t.enumerableKeysOf)(h)),!1))),!1),w=_.reduce(function(C,u){var d=(0,t.hasKey)(u,i),v=(0,t.hasKey)(u,h);if(d){var m=i[u],p=c||m.reflect.tag==="optional";if(v){var b=h[u];p&&b===void 0?C[u]=(0,t.SUCCESS)(b):C[u]=(0,n.innerValidate)(m,b,R)}else p?C[u]=(0,t.SUCCESS)(void 0):C[u]=t.FAILURE.PROPERTY_MISSING(m.reflect)}else if(v){var b=h[u];C[u]=(0,t.SUCCESS)(b)}else throw new Error("impossible");return C},{}),L=_.reduce(function(C,u){var d=w[u];return d.success||(C[u]=d.details||d.message),C},{});return(0,t.enumerableKeysOf)(L).length!==0?t.FAILURE.CONTENT_INCORRECT(g,L):(0,t.SUCCESS)(h)},g))}Y.InternalRecord=a;function o(i){return a(i,!1,!1)}Y.Record=o;function f(i){return a(i,!0,!1)}Y.Partial=f;function y(i){return i.asPartial=c,i.asReadonly=l,i.pick=g,i.omit=h,i.extend=R,i;function c(){return a(i.fields,!0,i.isReadonly)}function l(){return a(i.fields,i.isPartial,!0)}function g(){for(var E=[],_=0;_<arguments.length;_++)E[_]=arguments[_];var w={};return E.forEach(function(L){w[L]=i.fields[L]}),a(w,i.isPartial,i.isReadonly)}function h(){for(var E=[],_=0;_<arguments.length;_++)E[_]=arguments[_];var w={},L=(0,t.enumerableKeysOf)(i.fields);return L.forEach(function(C){E.includes(C)||(w[C]=i.fields[C])}),a(w,i.isPartial,i.isReadonly)}function R(E){return a(Object.assign({},i.fields,E),i.isPartial,i.isReadonly)}}return Y}var ue={},B={},He;function or(){if(He)return B;He=1,Object.defineProperty(B,"__esModule",{value:!0}),B.Guard=B.Constraint=void 0;var e=P(),r=T,n=Oe();function t(o,f,y){var i=y&&y.name,c=y&&y.args,l={tag:"constraint",underlying:o,constraint:f,name:i,args:c};return(0,e.create)(function(g){var h=o.validate(g);if(!h.success)return h;var R=f(h.value);return typeof R=="string"?r.FAILURE.CONSTRAINT_FAILED(l,R):R?(0,r.SUCCESS)(h.value):r.FAILURE.CONSTRAINT_FAILED(l)},l)}B.Constraint=t;var a=function(o,f){return n.Unknown.withGuard(o,f)};return B.Guard=a,B}var We;function Kr(){if(We)return ue;We=1,Object.defineProperty(ue,"__esModule",{value:!0}),ue.Dictionary=void 0;var e=P(),r=ir(),n=or(),t=H,a=T,o=(0,n.Constraint)(r.String,function(y){return!isNaN(+y)},{name:"number"});function f(y,i){var c=i===void 0||i==="string"?r.String:i==="number"?o:i,l=(0,t.default)(c),g={tag:"dictionary",key:l,value:y};return(0,e.create)(function(h,R){if(h==null||typeof h!="object"||Object.getPrototypeOf(h)!==Object.prototype&&(!Array.isArray(h)||l==="string"))return a.FAILURE.TYPE_INCORRECT(g,h);var E=/^(?:NaN|-?\d+(?:\.\d+)?)$/,_=(0,a.enumerableKeysOf)(h),w=_.reduce(function(C,u){var d=typeof u=="string"&&E.test(u),v=d?globalThis.Number(u):u;return(d?!c.guard(v)&&!c.guard(u):!c.guard(v))?C[u]=a.FAILURE.KEY_INCORRECT(g,c.reflect,v):C[u]=(0,e.innerValidate)(y,h[u],R),C},{}),L=_.reduce(function(C,u){var d=w[u];return d.success||(C[u]=d.details||d.message),C},{});return(0,a.enumerableKeysOf)(L).length!==0?a.FAILURE.CONTENT_INCORRECT(g,L):(0,a.SUCCESS)(h)},g)}return ue.Dictionary=f,ue}var ce={},Xe;function Gr(){if(Xe)return ce;Xe=1;var e=S&&S.__values||function(a){var o=typeof Symbol=="function"&&Symbol.iterator,f=o&&a[o],y=0;if(f)return f.call(a);if(a&&typeof a.length=="number")return{next:function(){return a&&y>=a.length&&(a=void 0),{value:a&&a[y++],done:!a}}};throw new TypeError(o?"Object is not iterable.":"Symbol.iterator is not defined.")};Object.defineProperty(ce,"__esModule",{value:!0}),ce.Intersect=void 0;var r=P(),n=T;function t(){for(var a=[],o=0;o<arguments.length;o++)a[o]=arguments[o];var f={tag:"intersect",intersectees:a};return(0,r.create)(function(y,i){var c,l;try{for(var g=e(a),h=g.next();!h.done;h=g.next()){var R=h.value,E=(0,r.innerValidate)(R,y,i);if(!E.success)return E}}catch(_){c={error:_}}finally{try{h&&!h.done&&(l=g.return)&&l.call(g)}finally{if(c)throw c.error}}return(0,n.SUCCESS)(y)},f)}return ce.Intersect=t,ce}var le={},Je;function Br(){if(Je)return le;Je=1,Object.defineProperty(le,"__esModule",{value:!0}),le.Optional=void 0;var e=P(),r=T;function n(t){var a={tag:"optional",underlying:t};return(0,e.create)(function(o){return o===void 0?(0,r.SUCCESS)(o):t.validate(o)},a)}return le.Optional=n,le}var se={},Qe;function $r(){if(Qe)return se;Qe=1,Object.defineProperty(se,"__esModule",{value:!0}),se.Function=void 0;var e=P(),r=T,n={tag:"function"};return se.Function=(0,e.create)(function(t){return typeof t=="function"?(0,r.SUCCESS)(t):r.FAILURE.TYPE_INCORRECT(n,t)},n),se}var fe={},Ze;function zr(){if(Ze)return fe;Ze=1,Object.defineProperty(fe,"__esModule",{value:!0}),fe.InstanceOf=void 0;var e=P(),r=T;function n(t){var a={tag:"instanceof",ctor:t};return(0,e.create)(function(o){return o instanceof t?(0,r.SUCCESS)(o):r.FAILURE.TYPE_INCORRECT(a,o)},a)}return fe.InstanceOf=n,fe}var de={},xe;function Hr(){if(xe)return de;xe=1,Object.defineProperty(de,"__esModule",{value:!0}),de.Lazy=void 0;var e=P();function r(n){var t={get tag(){return o().tag}},a;function o(){if(!a){a=n();for(var f in a)f!=="tag"&&(t[f]=a[f])}return a}return(0,e.create)(function(f){return o().validate(f)},t)}return de.Lazy=r,de}var ve={},er;function Wr(){if(er)return ve;er=1,Object.defineProperty(ve,"__esModule",{value:!0}),ve.Brand=void 0;var e=P();function r(n,t){var a={tag:"brand",brand:n,entity:t};return(0,e.create)(function(o){return t.validate(o)},a)}return ve.Brand=r,ve}var z={};Object.defineProperty(z,"__esModule",{value:!0});z.checked=z.check=void 0;var Xr=K,Jr=T,Se=new WeakMap;function Qr(e,r,n){var t=Se.get(e)||new Map;Se.set(e,t);var a=t.get(r)||[];t.set(r,a),a.push(n)}z.check=Qr;function Zr(e,r,n){var t=Se.get(e),a=t&&t.get(r);if(a)return a;for(var o=[],f=0;f<n;f++)o.push(f);return o}function xr(){for(var e=[],r=0;r<arguments.length;r++)e[r]=arguments[r];if(e.length===0)throw new Error("No runtype provided to `@checked`. Please remove the decorator.");return function(n,t,a){var o=a.value,f=(n.name||n.constructor.name+".prototype")+(typeof t=="string"?'["'.concat(t,'"]'):"[".concat(String(t),"]")),y=Zr(n,t,e.length);if(y.length!==e.length)throw new Error("Number of `@checked` runtypes and @check parameters not matched.");if(y.length>o.length)throw new Error("Number of `@checked` runtypes exceeds actual parameter length.");a.value=function(){for(var i=[],c=0;c<arguments.length;c++)i[c]=arguments[c];return e.forEach(function(l,g){var h=y[g],R=l.validate(i[h]);if(!R.success){var E="".concat(f,", argument #").concat(h,": ").concat(R.message),_=Jr.FAILURE.ARGUMENT_INCORRECT(E);throw new Xr.ValidationError(_)}}),o.apply(this,i)}}}z.checked=xr;var rr;function ur(){return rr||(rr=1,function(e){var r=S&&S.__createBinding||(Object.create?function(o,f,y,i){i===void 0&&(i=y),Object.defineProperty(o,i,{enumerable:!0,get:function(){return f[y]}})}:function(o,f,y,i){i===void 0&&(i=y),o[i]=f[y]}),n=S&&S.__exportStar||function(o,f){for(var y in o)y!=="default"&&!Object.prototype.hasOwnProperty.call(f,y)&&r(f,o,y)};Object.defineProperty(e,"__esModule",{value:!0}),e.InstanceOf=e.Nullish=e.Null=e.Undefined=e.Literal=void 0,n(nr,e),n(ye,e),n(Re,e),n(Ee,e),n($,e),n(K,e),n(Oe(),e),n(Lr(),e),n(Ar(),e);var t=ar();Object.defineProperty(e,"Literal",{enumerable:!0,get:function(){return t.Literal}}),Object.defineProperty(e,"Undefined",{enumerable:!0,get:function(){return t.Undefined}}),Object.defineProperty(e,"Null",{enumerable:!0,get:function(){return t.Null}}),Object.defineProperty(e,"Nullish",{enumerable:!0,get:function(){return t.Nullish}}),n(Fr(),e),n(jr(),e),n(Mr(),e),n(kr(),e),n(ir(),e),n(qr(),e),n(Vr(),e),n(Dr(),e),n(Yr(),e),n(Kr(),e),n(tr(),e),n(Gr(),e),n(Br(),e),n($r(),e);var a=zr();Object.defineProperty(e,"InstanceOf",{enumerable:!0,get:function(){return a.InstanceOf}}),n(Hr(),e),n(or(),e),n(Wr(),e),n(z,e)}(me)),me}var s=ur();const cr=s.Record({tag:s.String,attributes:s.Dictionary(s.Unknown,s.String),children:s.Array(s.Lazy(()=>nn))}),en=s.Union(s.Literal("text/html"),s.Literal("text/plain"),s.Literal("image/jpeg"),s.Literal("image/png")),rn=s.Union(s.String,s.Record({mimes:s.Dictionary(s.String,en)})),nn=s.Union(cr,rn),lr=s.Record({tag:s.String,title:s.String,docid:s.String}),Ie=s.Record({title:s.String,backlinks:s.Array(lr)}),Ce=cr.extend({tag:s.Union(s.Literal("documentation"),s.Literal("document"),s.Literal("sourcefile")),attributes:Ie}),sr=s.Union(s.Literal("struct"),s.Literal("function"),s.Literal("module"),s.Literal("abstract type"),s.Literal("const")),tn=s.Record({id:s.String,kind:sr,module_id:s.String,name:s.String,parent_module_id:s.String.optional(),public:s.Boolean}),an=s.Record({symbol_id:s.String,module_id:s.String,file:s.String,line:s.Number.withConstraint(e=>e>0),signature:s.String}),on=s.Record({package_id:s.String,file:s.String});Ie.extend({path:s.String,module_id:s.String,package_id:s.String});const Te=Ie.extend({kind:sr,module_id:s.String,package_id:s.String,symbol_id:s.String,exported:s.Boolean});Te.extend({kind:s.Literal("module"),symbols:s.Array(tn),files:s.Array(on)});Te.extend({kind:s.Literal("function"),methods:s.Array(an)});Ce.extend({attributes:Te});const fr=s.Record({dependencies:s.Array(s.String),title:s.String,linktree:s.Dictionary(s.Unknown,s.String),columnWidth:s.Number,defaultDocument:s.String}).asReadonly(),_e=s.Dictionary(fr,s.String),be=s.Dictionary(s.Record({title:s.String,tag:s.String,backlinks:s.Array(lr)}),s.String),un=s.Record({type:s.Literal("malformedjson"),url:s.String}),cn=s.Record({type:s.Literal("devserverunavailable"),host:s.String,port:s.Number}),ln=s.Record({type:s.Literal("networkerror"),message:s.String,url:s.String}),sn=s.Record({type:s.Literal("docnotfound"),url:s.String,document:s.String}),fn=s.Record({type:s.Literal("unknown"),error:s.Unknown,url:s.String}),dn=s.Record({type:s.Literal("schema"),code:s.String,details:s.Unknown}),vn=s.Record({type:s.Literal("invalidversion"),version:s.String,versions:s.Array(s.String)}),Ne=s.Union(un,cn,ln,sn,fn,dn,vn),yn=e=>Ne.match(r=>502,r=>500,r=>500,r=>404,r=>500,r=>422,r=>404)(e);class En{constructor(r,n,t=fetch,a={},o=null,f={}){G(this,"dataurl");G(this,"version");G(this,"documents");G(this,"fetch");G(this,"docversions",null);G(this,"pkgindexes",{});this.dataurl=r,this.version=n,this.fetch=t,this.documents=a,this.docversions=null,this.pkgindexes={}}async loadVersions(){if(this.docversions)return this.docversions;{const r=await this.safeLoad("versions",_e);return _e.guard(r)&&(this.docversions=r),r}}async loadDocumentIndex(r){const n=await this.loadVersionConfig(r);if(!fr.guard(n))return n;try{const t=await Promise.all(n.dependencies.map(this.loadPackageIndex.bind(this))),a=t.find(Ne.guard);return a===void 0?Object.assign({},...t.filter(be.guard)):a}catch(t){return console.log(t),{x:1}}}async loadPackageIndex(r){if(r in this.pkgindexes)return this.pkgindexes[r];const n=await this.safeLoad(`${r}/index`,be);return be.guard(n)&&(this.pkgindexes[r]=n),n}async loadVersionConfig(r){const n=await this.loadVersions();return _e.guard(n)?r in n?n[r]:{type:"invalidversion",version:r,versions:Object.keys(n)}:n}async loadDocument(r){if(r in this.documents)return this.documents[r];const n=await this.safeLoad(r,Ce);return Ce.guard(n)&&(this.documents[r]=n),n}async loadDocuments(r){return Promise.all(r.map(this.loadDocument.bind(this)))}async safeLoad(r,n){const t=`${this.dataurl}/${r}.json`;try{const a=await this.fetch(t);if(a.ok){const o=await a.json();return n.check(o)}else{if(a.status==404)return{type:"docnotfound",url:t,document:r};throw Error("UNKNOWN NETWORK ERROR")}}catch(a){const o=a.message;return a instanceof SyntaxError?{url:t,type:"malformedjson"}:a instanceof s.ValidationError?{type:"schema",code:a.code,details:a.details}:"cause"in a?a.cause.code=="ECONNREFUSED"?{type:"devserverunavailable",host:a.cause.address,port:a.cause.port}:{type:"networkerror",message:a.message,url:t}:o.startsWith("CORS")?{type:"docnotfound",url:t,document:r}:(console.log("Unknown error!"),console.log(t),console.log(Object.keys(a)),console.log(a.message),console.log(a),{type:"unknown",error:a,url:t})}}}function mn(e){if(Ne.guard(e))throw hr(yn(e),JSON.stringify({message:e}))}export{En as A,fr as D,Ne as a,hr as e,Rn as r,mn as t};
