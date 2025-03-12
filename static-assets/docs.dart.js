(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.k_(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a){a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.eC(b)
return new s(c,this)}:function(){if(s===null)s=A.eC(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.eC(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
eH(a,b,c,d){return{i:a,p:b,e:c,x:d}},
eE(a){var s,r,q,p,o,n=a[v.dispatchPropertyName]
if(n==null)if($.eF==null){A.jL()
n=a[v.dispatchPropertyName]}if(n!=null){s=n.p
if(!1===s)return n.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return n.i
if(n.e===r)throw A.a(A.f7("Return interceptor for "+A.i(s(a,n))))}q=a.constructor
if(q==null)p=null
else{o=$.df
if(o==null)o=$.df=v.getIsolateTag("_$dart_js")
p=q[o]}if(p!=null)return p
p=A.jQ(a)
if(p!=null)return p
if(typeof a=="function")return B.F
s=Object.getPrototypeOf(a)
if(s==null)return B.t
if(s===Object.prototype)return B.t
if(typeof q=="function"){o=$.df
if(o==null)o=$.df=v.getIsolateTag("_$dart_js")
Object.defineProperty(q,o,{value:B.k,enumerable:false,writable:true,configurable:true})
return B.k}return B.k},
hK(a,b){if(a<0||a>4294967295)throw A.a(A.F(a,0,4294967295,"length",null))
return J.hM(new Array(a),b)},
hL(a,b){if(a<0)throw A.a(A.M("Length must be a non-negative integer: "+a,null))
return A.h(new Array(a),b.j("p<0>"))},
eS(a,b){if(a<0)throw A.a(A.M("Length must be a non-negative integer: "+a,null))
return A.h(new Array(a),b.j("p<0>"))},
hM(a,b){var s=A.h(a,b.j("p<0>"))
s.$flags=1
return s},
hN(a,b){return J.hm(a,b)},
al(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.aN.prototype
return J.bG.prototype}if(typeof a=="string")return J.af.prototype
if(a==null)return J.aO.prototype
if(typeof a=="boolean")return J.bF.prototype
if(Array.isArray(a))return J.p.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a1.prototype
if(typeof a=="symbol")return J.aS.prototype
if(typeof a=="bigint")return J.aQ.prototype
return a}if(a instanceof A.k)return a
return J.eE(a)},
ck(a){if(typeof a=="string")return J.af.prototype
if(a==null)return a
if(Array.isArray(a))return J.p.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a1.prototype
if(typeof a=="symbol")return J.aS.prototype
if(typeof a=="bigint")return J.aQ.prototype
return a}if(a instanceof A.k)return a
return J.eE(a)},
dS(a){if(a==null)return a
if(Array.isArray(a))return J.p.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a1.prototype
if(typeof a=="symbol")return J.aS.prototype
if(typeof a=="bigint")return J.aQ.prototype
return a}if(a instanceof A.k)return a
return J.eE(a)},
jE(a){if(typeof a=="number")return J.aP.prototype
if(typeof a=="string")return J.af.prototype
if(a==null)return a
if(!(a instanceof A.k))return J.as.prototype
return a},
H(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.al(a).E(a,b)},
hj(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.fX(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.ck(a).k(a,b)},
hk(a,b,c){if(typeof b==="number")if((Array.isArray(a)||A.fX(a,a[v.dispatchPropertyName]))&&!(a.$flags&2)&&b>>>0===b&&b<a.length)return a[b]=c
return J.dS(a).q(a,b,c)},
hl(a,b){return J.dS(a).Y(a,b)},
hm(a,b){return J.jE(a).aH(a,b)},
hn(a,b){return J.ck(a).O(a,b)},
e8(a,b){return J.dS(a).C(a,b)},
Y(a){return J.al(a).gp(a)},
ac(a){return J.dS(a).gA(a)},
bu(a){return J.ck(a).gl(a)},
ho(a){return J.al(a).gt(a)},
an(a){return J.al(a).h(a)},
bE:function bE(){},
bF:function bF(){},
aO:function aO(){},
aR:function aR(){},
a2:function a2(){},
bT:function bT(){},
as:function as(){},
a1:function a1(){},
aQ:function aQ(){},
aS:function aS(){},
p:function p(a){this.$ti=a},
cz:function cz(a){this.$ti=a},
Z:function Z(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aP:function aP(){},
aN:function aN(){},
bG:function bG(){},
af:function af(){}},A={ec:function ec(){},
hr(a,b,c){if(b.j("c<0>").b(a))return new A.b7(a,b.j("@<0>").B(c).j("b7<1,2>"))
return new A.ad(a,b.j("@<0>").B(c).j("ad<1,2>"))},
dT(a){var s,r=a^48
if(r<=9)return r
s=a|32
if(97<=s&&s<=102)return s-87
return-1},
a4(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
ej(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
eB(a,b,c){return a},
eG(a){var s,r
for(s=$.am.length,r=0;r<s;++r)if(a===$.am[r])return!0
return!1},
hQ(a,b,c,d){if(t.U.b(a))return new A.aK(a,b,c.j("@<0>").B(d).j("aK<1,2>"))
return new A.ah(a,b,c.j("@<0>").B(d).j("ah<1,2>"))},
hG(){return new A.b3("No element")},
a5:function a5(){},
bx:function bx(a,b){this.a=a
this.$ti=b},
ad:function ad(a,b){this.a=a
this.$ti=b},
b7:function b7(a,b){this.a=a
this.$ti=b},
b6:function b6(){},
N:function N(a,b){this.a=a
this.$ti=b},
aT:function aT(a){this.a=a},
by:function by(a){this.a=a},
cJ:function cJ(){},
c:function c(){},
J:function J(){},
ao:function ao(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
ah:function ah(a,b,c){this.a=a
this.b=b
this.$ti=c},
aK:function aK(a,b,c){this.a=a
this.b=b
this.$ti=c},
ap:function ap(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
ai:function ai(a,b,c){this.a=a
this.b=b
this.$ti=c},
aM:function aM(){},
bY:function bY(){},
at:function at(){},
bm:function bm(){},
hx(){throw A.a(A.bZ("Cannot modify unmodifiable Map"))},
h1(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
fX(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.p.b(a)},
i(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.an(a)
return s},
bU(a){var s,r=$.eX
if(r==null)r=$.eX=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
eY(a,b){var s,r,q,p,o,n=null,m=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(m==null)return n
s=m[3]
if(b==null){if(s!=null)return parseInt(a,10)
if(m[2]!=null)return parseInt(a,16)
return n}if(b<2||b>36)throw A.a(A.F(b,2,36,"radix",n))
if(b===10&&s!=null)return parseInt(a,10)
if(b<10||s==null){r=b<=10?47+b:86+b
q=m[1]
for(p=q.length,o=0;o<p;++o)if((q.charCodeAt(o)|32)>r)return n}return parseInt(a,b)},
cI(a){return A.hU(a)},
hU(a){var s,r,q,p
if(a instanceof A.k)return A.C(A.aD(a),null)
s=J.al(a)
if(s===B.E||s===B.G||t.o.b(a)){r=B.m(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.C(A.aD(a),null)},
eZ(a){if(a==null||typeof a=="number"||A.ew(a))return J.an(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.ae)return a.h(0)
if(a instanceof A.bc)return a.aE(!0)
return"Instance of '"+A.cI(a)+"'"},
hW(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
Q(a){var s
if(0<=a){if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.b.W(s,10)|55296)>>>0,s&1023|56320)}}throw A.a(A.F(a,0,1114111,null,null))},
hV(a){var s=a.$thrownJsError
if(s==null)return null
return A.aa(s)},
f_(a,b){var s
if(a.$thrownJsError==null){s=A.a(a)
a.$thrownJsError=s
s.stack=b.h(0)}},
eD(a,b){var s,r="index"
if(!A.fH(b))return new A.I(!0,b,r,null)
s=J.bu(a)
if(b<0||b>=s)return A.ea(b,s,a,r)
return A.hX(b,r)},
jB(a,b,c){if(a>c)return A.F(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.F(b,a,c,"end",null)
return new A.I(!0,b,"end",null)},
ju(a){return new A.I(!0,a,null,null)},
a(a){return A.fW(new Error(),a)},
fW(a,b){var s
if(b==null)b=new A.R()
a.dartException=b
s=A.k0
if("defineProperty" in Object){Object.defineProperty(a,"message",{get:s})
a.name=""}else a.toString=s
return a},
k0(){return J.an(this.dartException)},
h0(a){throw A.a(a)},
eI(a,b){throw A.fW(b,a)},
K(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.eI(A.iT(a,b,c),s)},
iT(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.b4("'"+s+"': Cannot "+o+" "+l+k+n)},
e6(a){throw A.a(A.aF(a))},
S(a){var s,r,q,p,o,n
a=A.jV(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.h([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.cM(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
cN(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
f6(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
ed(a,b){var s=b==null,r=s?null:b.method
return new A.bH(a,r,s?null:b.receiver)},
X(a){if(a==null)return new A.cH(a)
if(a instanceof A.aL)return A.ab(a,a.a)
if(typeof a!=="object")return a
if("dartException" in a)return A.ab(a,a.dartException)
return A.jt(a)},
ab(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
jt(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.b.W(r,16)&8191)===10)switch(q){case 438:return A.ab(a,A.ed(A.i(s)+" (Error "+q+")",null))
case 445:case 5007:A.i(s)
return A.ab(a,new A.b_())}}if(a instanceof TypeError){p=$.h2()
o=$.h3()
n=$.h4()
m=$.h5()
l=$.h8()
k=$.h9()
j=$.h7()
$.h6()
i=$.hb()
h=$.ha()
g=p.D(s)
if(g!=null)return A.ab(a,A.ed(s,g))
else{g=o.D(s)
if(g!=null){g.method="call"
return A.ab(a,A.ed(s,g))}else if(n.D(s)!=null||m.D(s)!=null||l.D(s)!=null||k.D(s)!=null||j.D(s)!=null||m.D(s)!=null||i.D(s)!=null||h.D(s)!=null)return A.ab(a,new A.b_())}return A.ab(a,new A.bX(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.b2()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.ab(a,new A.I(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.b2()
return a},
aa(a){var s
if(a instanceof A.aL)return a.b
if(a==null)return new A.bd(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.bd(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
fY(a){if(a==null)return J.Y(a)
if(typeof a=="object")return A.bU(a)
return J.Y(a)},
jD(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.q(0,a[s],a[r])}return b},
j6(a,b,c,d,e,f){switch(b){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.a(new A.d1("Unsupported number of arguments for wrapped closure"))},
aC(a,b){var s=a.$identity
if(!!s)return s
s=A.jz(a,b)
a.$identity=s
return s},
jz(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.j6)},
hw(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.cK().constructor.prototype):Object.create(new A.aE(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.eR(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.hs(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.eR(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
hs(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.a("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.hp)}throw A.a("Error in functionType of tearoff")},
ht(a,b,c,d){var s=A.eQ
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
eR(a,b,c,d){if(c)return A.hv(a,b,d)
return A.ht(b.length,d,a,b)},
hu(a,b,c,d){var s=A.eQ,r=A.hq
switch(b?-1:a){case 0:throw A.a(new A.bV("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
hv(a,b,c){var s,r
if($.eO==null)$.eO=A.eN("interceptor")
if($.eP==null)$.eP=A.eN("receiver")
s=b.length
r=A.hu(s,c,a,b)
return r},
eC(a){return A.hw(a)},
hp(a,b){return A.bi(v.typeUniverse,A.aD(a.a),b)},
eQ(a){return a.a},
hq(a){return a.b},
eN(a){var s,r,q,p=new A.aE("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.a(A.M("Field name "+a+" not found.",null))},
kC(a){throw A.a(new A.c4(a))},
jF(a){return v.getIsolateTag(a)},
jQ(a){var s,r,q,p,o,n=$.fV.$1(a),m=$.dR[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.e1[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=$.fS.$2(a,n)
if(q!=null){m=$.dR[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.e1[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.e2(s)
$.dR[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.e1[n]=s
return s}if(p==="-"){o=A.e2(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.fZ(a,s)
if(p==="*")throw A.a(A.f7(n))
if(v.leafTags[n]===true){o=A.e2(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.fZ(a,s)},
fZ(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.eH(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
e2(a){return J.eH(a,!1,null,!!a.$iD)},
jS(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.e2(s)
else return J.eH(s,c,null,null)},
jL(){if(!0===$.eF)return
$.eF=!0
A.jM()},
jM(){var s,r,q,p,o,n,m,l
$.dR=Object.create(null)
$.e1=Object.create(null)
A.jK()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.h_.$1(o)
if(n!=null){m=A.jS(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
jK(){var s,r,q,p,o,n,m=B.v()
m=A.aB(B.w,A.aB(B.x,A.aB(B.n,A.aB(B.n,A.aB(B.y,A.aB(B.z,A.aB(B.A(B.m),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.fV=new A.dU(p)
$.fS=new A.dV(o)
$.h_=new A.dW(n)},
aB(a,b){return a(b)||b},
jA(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
eT(a,b,c,d,e,f){var s=b?"m":"",r=c?"":"i",q=d?"u":"",p=e?"s":"",o=f?"g":"",n=function(g,h){try{return new RegExp(g,h)}catch(m){return m}}(a,s+r+q+p+o)
if(n instanceof RegExp)return n
throw A.a(A.x("Illegal RegExp pattern ("+String(n)+")",a,null))},
jY(a,b,c){var s=a.indexOf(b,c)
return s>=0},
jV(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
fP(a){return a},
jZ(a,b,c,d){var s,r,q,p=new A.cW(b,a,0),o=t.F,n=0,m=""
for(;p.m();){s=p.d
if(s==null)s=o.a(s)
r=s.b
q=r.index
m=m+A.i(A.fP(B.a.i(a,n,q)))+A.i(c.$1(s))
n=q+r[0].length}p=m+A.i(A.fP(B.a.L(a,n)))
return p.charCodeAt(0)==0?p:p},
cd:function cd(a,b){this.a=a
this.b=b},
aG:function aG(){},
aI:function aI(a,b,c){this.a=a
this.b=b
this.$ti=c},
ca:function ca(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aH:function aH(){},
aJ:function aJ(a,b,c){this.a=a
this.b=b
this.$ti=c},
cM:function cM(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
b_:function b_(){},
bH:function bH(a,b,c){this.a=a
this.b=b
this.c=c},
bX:function bX(a){this.a=a},
cH:function cH(a){this.a=a},
aL:function aL(a,b){this.a=a
this.b=b},
bd:function bd(a){this.a=a
this.b=null},
ae:function ae(){},
cn:function cn(){},
co:function co(){},
cL:function cL(){},
cK:function cK(){},
aE:function aE(a,b){this.a=a
this.b=b},
c4:function c4(a){this.a=a},
bV:function bV(a){this.a=a},
ag:function ag(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
cA:function cA(a){this.a=a},
cD:function cD(a,b){this.a=a
this.b=b
this.c=null},
O:function O(a,b){this.a=a
this.$ti=b},
bI:function bI(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
dU:function dU(a){this.a=a},
dV:function dV(a){this.a=a},
dW:function dW(a){this.a=a},
bc:function bc(){},
cc:function cc(){},
cy:function cy(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
cb:function cb(a){this.b=a},
cW:function cW(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.d=null},
iU(a){return a},
hR(a){return new Int8Array(a)},
hS(a){return new Uint8Array(a)},
U(a,b,c){if(a>>>0!==a||a>=c)throw A.a(A.eD(b,a))},
iQ(a,b,c){var s
if(!(a>>>0!==a))s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.a(A.jB(a,b,c))
return b},
bJ:function bJ(){},
aX:function aX(){},
bK:function bK(){},
aq:function aq(){},
aV:function aV(){},
aW:function aW(){},
bL:function bL(){},
bM:function bM(){},
bN:function bN(){},
bO:function bO(){},
bP:function bP(){},
bQ:function bQ(){},
bR:function bR(){},
aY:function aY(){},
aZ:function aZ(){},
b8:function b8(){},
b9:function b9(){},
ba:function ba(){},
bb:function bb(){},
f1(a,b){var s=b.c
return s==null?b.c=A.eo(a,b.x,!0):s},
ei(a,b){var s=b.c
return s==null?b.c=A.bg(a,"a0",[b.x]):s},
f2(a){var s=a.w
if(s===6||s===7||s===8)return A.f2(a.x)
return s===12||s===13},
hY(a){return a.as},
bq(a){return A.ch(v.typeUniverse,a,!1)},
a9(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.a9(a1,s,a3,a4)
if(r===s)return a2
return A.fk(a1,r,!0)
case 7:s=a2.x
r=A.a9(a1,s,a3,a4)
if(r===s)return a2
return A.eo(a1,r,!0)
case 8:s=a2.x
r=A.a9(a1,s,a3,a4)
if(r===s)return a2
return A.fi(a1,r,!0)
case 9:q=a2.y
p=A.aA(a1,q,a3,a4)
if(p===q)return a2
return A.bg(a1,a2.x,p)
case 10:o=a2.x
n=A.a9(a1,o,a3,a4)
m=a2.y
l=A.aA(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.em(a1,n,l)
case 11:k=a2.x
j=a2.y
i=A.aA(a1,j,a3,a4)
if(i===j)return a2
return A.fj(a1,k,i)
case 12:h=a2.x
g=A.a9(a1,h,a3,a4)
f=a2.y
e=A.jq(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.fh(a1,g,e)
case 13:d=a2.y
a4+=d.length
c=A.aA(a1,d,a3,a4)
o=a2.x
n=A.a9(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.en(a1,n,c,!0)
case 14:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.a(A.bw("Attempted to substitute unexpected RTI kind "+a0))}},
aA(a,b,c,d){var s,r,q,p,o=b.length,n=A.dA(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.a9(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
jr(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.dA(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.a9(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
jq(a,b,c,d){var s,r=b.a,q=A.aA(a,r,c,d),p=b.b,o=A.aA(a,p,c,d),n=b.c,m=A.jr(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.c7()
s.a=q
s.b=o
s.c=m
return s},
h(a,b){a[v.arrayRti]=b
return a},
fU(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.jH(s)
return a.$S()}return null},
jN(a,b){var s
if(A.f2(b))if(a instanceof A.ae){s=A.fU(a)
if(s!=null)return s}return A.aD(a)},
aD(a){if(a instanceof A.k)return A.E(a)
if(Array.isArray(a))return A.a7(a)
return A.ev(J.al(a))},
a7(a){var s=a[v.arrayRti],r=t.b
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
E(a){var s=a.$ti
return s!=null?s:A.ev(a)},
ev(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.j2(a,s)},
j2(a,b){var s=a instanceof A.ae?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.ir(v.typeUniverse,s.name)
b.$ccache=r
return r},
jH(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.ch(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
jG(a){return A.ak(A.E(a))},
ez(a){var s
if(a instanceof A.bc)return A.jC(a.$r,a.aw())
s=a instanceof A.ae?A.fU(a):null
if(s!=null)return s
if(t.k.b(a))return J.ho(a).a
if(Array.isArray(a))return A.a7(a)
return A.aD(a)},
ak(a){var s=a.r
return s==null?a.r=A.fD(a):s},
fD(a){var s,r,q=a.as,p=q.replace(/\*/g,"")
if(p===q)return a.r=new A.ds(a)
s=A.ch(v.typeUniverse,p,!0)
r=s.r
return r==null?s.r=A.fD(s):r},
jC(a,b){var s,r,q=b,p=q.length
if(p===0)return t.d
s=A.bi(v.typeUniverse,A.ez(q[0]),"@<0>")
for(r=1;r<p;++r)s=A.fl(v.typeUniverse,s,A.ez(q[r]))
return A.bi(v.typeUniverse,s,a)},
L(a){return A.ak(A.ch(v.typeUniverse,a,!1))},
j1(a){var s,r,q,p,o,n,m=this
if(m===t.K)return A.V(m,a,A.jb)
if(!A.W(m))s=m===t._
else s=!0
if(s)return A.V(m,a,A.jf)
s=m.w
if(s===7)return A.V(m,a,A.iY)
if(s===1)return A.V(m,a,A.fI)
r=s===6?m.x:m
q=r.w
if(q===8)return A.V(m,a,A.j7)
if(r===t.S)p=A.fH
else if(r===t.i||r===t.H)p=A.ja
else if(r===t.N)p=A.jd
else p=r===t.y?A.ew:null
if(p!=null)return A.V(m,a,p)
if(q===9){o=r.x
if(r.y.every(A.jO)){m.f="$i"+o
if(o==="f")return A.V(m,a,A.j9)
return A.V(m,a,A.je)}}else if(q===11){n=A.jA(r.x,r.y)
return A.V(m,a,n==null?A.fI:n)}return A.V(m,a,A.iW)},
V(a,b,c){a.b=c
return a.b(b)},
j0(a){var s,r=this,q=A.iV
if(!A.W(r))s=r===t._
else s=!0
if(s)q=A.iN
else if(r===t.K)q=A.iL
else{s=A.br(r)
if(s)q=A.iX}r.a=q
return r.a(a)},
cj(a){var s=a.w,r=!0
if(!A.W(a))if(!(a===t._))if(!(a===t.A))if(s!==7)if(!(s===6&&A.cj(a.x)))r=s===8&&A.cj(a.x)||a===t.P||a===t.T
return r},
iW(a){var s=this
if(a==null)return A.cj(s)
return A.jP(v.typeUniverse,A.jN(a,s),s)},
iY(a){if(a==null)return!0
return this.x.b(a)},
je(a){var s,r=this
if(a==null)return A.cj(r)
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.al(a)[s]},
j9(a){var s,r=this
if(a==null)return A.cj(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.al(a)[s]},
iV(a){var s=this
if(a==null){if(A.br(s))return a}else if(s.b(a))return a
A.fE(a,s)},
iX(a){var s=this
if(a==null)return a
else if(s.b(a))return a
A.fE(a,s)},
fE(a,b){throw A.a(A.ih(A.fb(a,A.C(b,null))))},
fb(a,b){return A.cr(a)+": type '"+A.C(A.ez(a),null)+"' is not a subtype of type '"+b+"'"},
ih(a){return new A.be("TypeError: "+a)},
B(a,b){return new A.be("TypeError: "+A.fb(a,b))},
j7(a){var s=this,r=s.w===6?s.x:s
return r.x.b(a)||A.ei(v.typeUniverse,r).b(a)},
jb(a){return a!=null},
iL(a){if(a!=null)return a
throw A.a(A.B(a,"Object"))},
jf(a){return!0},
iN(a){return a},
fI(a){return!1},
ew(a){return!0===a||!1===a},
ko(a){if(!0===a)return!0
if(!1===a)return!1
throw A.a(A.B(a,"bool"))},
kq(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a(A.B(a,"bool"))},
kp(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a(A.B(a,"bool?"))},
kr(a){if(typeof a=="number")return a
throw A.a(A.B(a,"double"))},
kt(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a(A.B(a,"double"))},
ks(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a(A.B(a,"double?"))},
fH(a){return typeof a=="number"&&Math.floor(a)===a},
fw(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.a(A.B(a,"int"))},
ku(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a(A.B(a,"int"))},
fx(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a(A.B(a,"int?"))},
ja(a){return typeof a=="number"},
kv(a){if(typeof a=="number")return a
throw A.a(A.B(a,"num"))},
kx(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a(A.B(a,"num"))},
kw(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a(A.B(a,"num?"))},
jd(a){return typeof a=="string"},
fy(a){if(typeof a=="string")return a
throw A.a(A.B(a,"String"))},
ky(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a(A.B(a,"String"))},
iM(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a(A.B(a,"String?"))},
fM(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.C(a[q],b)
return s},
jk(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.fM(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.C(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
fF(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.h([],t.s)
else a2=a4.length
r=a4.length
for(q=s;q>0;--q)a4.push("T"+(r+q))
for(p=t.X,o=t._,n="<",m="",q=0;q<s;++q,m=a1){n=n+m+a4[a4.length-1-q]
l=a5[q]
k=l.w
if(!(k===2||k===3||k===4||k===5||l===p))j=l===o
else j=!0
if(!j)n+=" extends "+A.C(l,a4)}n+=">"}else n=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.C(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.C(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.C(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.C(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return n+"("+a+") => "+b},
C(a,b){var s,r,q,p,o,n,m=a.w
if(m===5)return"erased"
if(m===2)return"dynamic"
if(m===3)return"void"
if(m===1)return"Never"
if(m===4)return"any"
if(m===6)return A.C(a.x,b)
if(m===7){s=a.x
r=A.C(s,b)
q=s.w
return(q===12||q===13?"("+r+")":r)+"?"}if(m===8)return"FutureOr<"+A.C(a.x,b)+">"
if(m===9){p=A.js(a.x)
o=a.y
return o.length>0?p+("<"+A.fM(o,b)+">"):p}if(m===11)return A.jk(a,b)
if(m===12)return A.fF(a,b,null)
if(m===13)return A.fF(a.x,b,a.y)
if(m===14){n=a.x
return b[b.length-1-n]}return"?"},
js(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
is(a,b){var s=a.tR[b]
for(;typeof s=="string";)s=a.tR[s]
return s},
ir(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.ch(a,b,!1)
else if(typeof m=="number"){s=m
r=A.bh(a,5,"#")
q=A.dA(s)
for(p=0;p<s;++p)q[p]=r
o=A.bg(a,b,q)
n[b]=o
return o}else return m},
iq(a,b){return A.fu(a.tR,b)},
ip(a,b){return A.fu(a.eT,b)},
ch(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.ff(A.fd(a,null,b,c))
r.set(b,s)
return s},
bi(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.ff(A.fd(a,b,c,!0))
q.set(c,r)
return r},
fl(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.em(a,b,c.w===10?c.y:[c])
p.set(s,q)
return q},
T(a,b){b.a=A.j0
b.b=A.j1
return b},
bh(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.G(null,null)
s.w=b
s.as=c
r=A.T(a,s)
a.eC.set(c,r)
return r},
fk(a,b,c){var s,r=b.as+"*",q=a.eC.get(r)
if(q!=null)return q
s=A.im(a,b,r,c)
a.eC.set(r,s)
return s},
im(a,b,c,d){var s,r,q
if(d){s=b.w
if(!A.W(b))r=b===t.P||b===t.T||s===7||s===6
else r=!0
if(r)return b}q=new A.G(null,null)
q.w=6
q.x=b
q.as=c
return A.T(a,q)},
eo(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.il(a,b,r,c)
a.eC.set(r,s)
return s},
il(a,b,c,d){var s,r,q,p
if(d){s=b.w
r=!0
if(!A.W(b))if(!(b===t.P||b===t.T))if(s!==7)r=s===8&&A.br(b.x)
if(r)return b
else if(s===1||b===t.A)return t.P
else if(s===6){q=b.x
if(q.w===8&&A.br(q.x))return q
else return A.f1(a,b)}}p=new A.G(null,null)
p.w=7
p.x=b
p.as=c
return A.T(a,p)},
fi(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.ij(a,b,r,c)
a.eC.set(r,s)
return s},
ij(a,b,c,d){var s,r
if(d){s=b.w
if(A.W(b)||b===t.K||b===t._)return b
else if(s===1)return A.bg(a,"a0",[b])
else if(b===t.P||b===t.T)return t.W}r=new A.G(null,null)
r.w=8
r.x=b
r.as=c
return A.T(a,r)},
io(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.G(null,null)
s.w=14
s.x=b
s.as=q
r=A.T(a,s)
a.eC.set(q,r)
return r},
bf(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
ii(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
bg(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.bf(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.G(null,null)
r.w=9
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.T(a,r)
a.eC.set(p,q)
return q},
em(a,b,c){var s,r,q,p,o,n
if(b.w===10){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.bf(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.G(null,null)
o.w=10
o.x=s
o.y=r
o.as=q
n=A.T(a,o)
a.eC.set(q,n)
return n},
fj(a,b,c){var s,r,q="+"+(b+"("+A.bf(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.G(null,null)
s.w=11
s.x=b
s.y=c
s.as=q
r=A.T(a,s)
a.eC.set(q,r)
return r},
fh(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.bf(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.bf(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.ii(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.G(null,null)
p.w=12
p.x=b
p.y=c
p.as=r
o=A.T(a,p)
a.eC.set(r,o)
return o},
en(a,b,c,d){var s,r=b.as+("<"+A.bf(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.ik(a,b,c,r,d)
a.eC.set(r,s)
return s},
ik(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.dA(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.a9(a,b,r,0)
m=A.aA(a,c,r,0)
return A.en(a,n,m,c!==m)}}l=new A.G(null,null)
l.w=13
l.x=b
l.y=c
l.as=d
return A.T(a,l)},
fd(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
ff(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.ia(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.fe(a,r,l,k,!1)
else if(q===46)r=A.fe(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.a6(a.u,a.e,k.pop()))
break
case 94:k.push(A.io(a.u,k.pop()))
break
case 35:k.push(A.bh(a.u,5,"#"))
break
case 64:k.push(A.bh(a.u,2,"@"))
break
case 126:k.push(A.bh(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.ic(a,k)
break
case 38:A.ib(a,k)
break
case 42:p=a.u
k.push(A.fk(p,A.a6(p,a.e,k.pop()),a.n))
break
case 63:p=a.u
k.push(A.eo(p,A.a6(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.fi(p,A.a6(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.i9(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.fg(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.ie(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.a6(a.u,a.e,m)},
ia(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
fe(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===10)o=o.x
n=A.is(s,o.x)[p]
if(n==null)A.h0('No "'+p+'" in "'+A.hY(o)+'"')
d.push(A.bi(s,o,n))}else d.push(p)
return m},
ic(a,b){var s,r=a.u,q=A.fc(a,b),p=b.pop()
if(typeof p=="string")b.push(A.bg(r,p,q))
else{s=A.a6(r,a.e,p)
switch(s.w){case 12:b.push(A.en(r,s,q,a.n))
break
default:b.push(A.em(r,s,q))
break}}},
i9(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.fc(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.a6(p,a.e,o)
q=new A.c7()
q.a=s
q.b=n
q.c=m
b.push(A.fh(p,r,q))
return
case-4:b.push(A.fj(p,b.pop(),s))
return
default:throw A.a(A.bw("Unexpected state under `()`: "+A.i(o)))}},
ib(a,b){var s=b.pop()
if(0===s){b.push(A.bh(a.u,1,"0&"))
return}if(1===s){b.push(A.bh(a.u,4,"1&"))
return}throw A.a(A.bw("Unexpected extended operation "+A.i(s)))},
fc(a,b){var s=b.splice(a.p)
A.fg(a.u,a.e,s)
a.p=b.pop()
return s},
a6(a,b,c){if(typeof c=="string")return A.bg(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.id(a,b,c)}else return c},
fg(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.a6(a,b,c[s])},
ie(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.a6(a,b,c[s])},
id(a,b,c){var s,r,q=b.w
if(q===10){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==9)throw A.a(A.bw("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.a(A.bw("Bad index "+c+" for "+b.h(0)))},
jP(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.r(a,b,null,c,null,!1)?1:0
r.set(c,s)}if(0===s)return!1
if(1===s)return!0
return!0},
r(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(!A.W(d))s=d===t._
else s=!0
if(s)return!0
r=b.w
if(r===4)return!0
if(A.W(b))return!1
s=b.w
if(s===1)return!0
q=r===14
if(q)if(A.r(a,c[b.x],c,d,e,!1))return!0
p=d.w
s=b===t.P||b===t.T
if(s){if(p===8)return A.r(a,b,c,d.x,e,!1)
return d===t.P||d===t.T||p===7||p===6}if(d===t.K){if(r===8)return A.r(a,b.x,c,d,e,!1)
if(r===6)return A.r(a,b.x,c,d,e,!1)
return r!==7}if(r===6)return A.r(a,b.x,c,d,e,!1)
if(p===6){s=A.f1(a,d)
return A.r(a,b,c,s,e,!1)}if(r===8){if(!A.r(a,b.x,c,d,e,!1))return!1
return A.r(a,A.ei(a,b),c,d,e,!1)}if(r===7){s=A.r(a,t.P,c,d,e,!1)
return s&&A.r(a,b.x,c,d,e,!1)}if(p===8){if(A.r(a,b,c,d.x,e,!1))return!0
return A.r(a,b,c,A.ei(a,d),e,!1)}if(p===7){s=A.r(a,b,c,t.P,e,!1)
return s||A.r(a,b,c,d.x,e,!1)}if(q)return!1
s=r!==12
if((!s||r===13)&&d===t.Z)return!0
o=r===11
if(o&&d===t.L)return!0
if(p===13){if(b===t.g)return!0
if(r!==13)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.r(a,j,c,i,e,!1)||!A.r(a,i,e,j,c,!1))return!1}return A.fG(a,b.x,c,d.x,e,!1)}if(p===12){if(b===t.g)return!0
if(s)return!1
return A.fG(a,b,c,d,e,!1)}if(r===9){if(p!==9)return!1
return A.j8(a,b,c,d,e,!1)}if(o&&p===11)return A.jc(a,b,c,d,e,!1)
return!1},
fG(a3,a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.r(a3,a4.x,a5,a6.x,a7,!1))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.r(a3,p[h],a7,g,a5,!1))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.r(a3,p[o+h],a7,g,a5,!1))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.r(a3,k[h],a7,g,a5,!1))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;!0;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.r(a3,e[a+2],a7,g,a5,!1))return!1
break}}for(;b<d;){if(f[b+1])return!1
b+=3}return!0},
j8(a,b,c,d,e,f){var s,r,q,p,o,n=b.x,m=d.x
for(;n!==m;){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.bi(a,b,r[o])
return A.fv(a,p,null,c,d.y,e,!1)}return A.fv(a,b.y,null,c,d.y,e,!1)},
fv(a,b,c,d,e,f,g){var s,r=b.length
for(s=0;s<r;++s)if(!A.r(a,b[s],d,e[s],f,!1))return!1
return!0},
jc(a,b,c,d,e,f){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.r(a,r[s],c,q[s],e,!1))return!1
return!0},
br(a){var s=a.w,r=!0
if(!(a===t.P||a===t.T))if(!A.W(a))if(s!==7)if(!(s===6&&A.br(a.x)))r=s===8&&A.br(a.x)
return r},
jO(a){var s
if(!A.W(a))s=a===t._
else s=!0
return s},
W(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
fu(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
dA(a){return a>0?new Array(a):v.typeUniverse.sEA},
G:function G(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
c7:function c7(){this.c=this.b=this.a=null},
ds:function ds(a){this.a=a},
c6:function c6(){},
be:function be(a){this.a=a},
i5(){var s,r,q={}
if(self.scheduleImmediate!=null)return A.jv()
if(self.MutationObserver!=null&&self.document!=null){s=self.document.createElement("div")
r=self.document.createElement("span")
q.a=null
new self.MutationObserver(A.aC(new A.cY(q),1)).observe(s,{childList:true})
return new A.cX(q,s,r)}else if(self.setImmediate!=null)return A.jw()
return A.jx()},
i6(a){self.scheduleImmediate(A.aC(new A.cZ(a),0))},
i7(a){self.setImmediate(A.aC(new A.d_(a),0))},
i8(a){A.ig(0,a)},
ig(a,b){var s=new A.dq()
s.ba(a,b)
return s},
fK(a){return new A.c1(new A.v($.q,a.j("v<0>")),a.j("c1<0>"))},
fC(a,b){a.$2(0,null)
b.b=!0
return b.a},
fz(a,b){A.iO(a,b)},
fB(a,b){b.ae(a)},
fA(a,b){b.af(A.X(a),A.aa(a))},
iO(a,b){var s,r,q=new A.dC(b),p=new A.dD(b)
if(a instanceof A.v)a.aD(q,p,t.z)
else{s=t.z
if(a instanceof A.v)a.a2(q,p,s)
else{r=new A.v($.q,t.e)
r.a=8
r.c=a
r.aD(q,p,s)}}},
fR(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.q.aX(new A.dQ(s))},
e9(a){var s
if(t.C.b(a)){s=a.gK()
if(s!=null)return s}return B.f},
j3(a,b){if($.q===B.c)return null
return null},
j4(a,b){if($.q!==B.c)A.j3(a,b)
if(b==null)if(t.C.b(a)){b=a.gK()
if(b==null){A.f_(a,B.f)
b=B.f}}else b=B.f
else if(t.C.b(a))A.f_(a,b)
return new A.a_(a,b)},
ek(a,b,c){var s,r,q,p={},o=p.a=a
for(;s=o.a,(s&4)!==0;){o=o.c
p.a=o}if(o===b){b.a6(new A.I(!0,o,null,"Cannot complete a future with itself"),A.hZ())
return}r=b.a&1
s=o.a=s|r
if((s&24)===0){q=b.c
b.a=b.a&1|4
b.c=o
o.aA(q)
return}if(!c)if(b.c==null)o=(s&16)===0||r!==0
else o=!1
else o=!0
if(o){q=b.U()
b.T(p.a)
A.aw(b,q)
return}b.a^=2
A.az(null,null,b.b,new A.d5(p,b))},
aw(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g={},f=g.a=a
for(;!0;){s={}
r=f.a
q=(r&16)===0
p=!q
if(b==null){if(p&&(r&1)===0){f=f.c
A.ey(f.a,f.b)}return}s.a=b
o=b.a
for(f=b;o!=null;f=o,o=n){f.a=null
A.aw(g.a,f)
s.a=o
n=o.a}r=g.a
m=r.c
s.b=p
s.c=m
if(q){l=f.c
l=(l&1)!==0||(l&15)===8}else l=!0
if(l){k=f.b.b
if(p){r=r.b===k
r=!(r||r)}else r=!1
if(r){A.ey(m.a,m.b)
return}j=$.q
if(j!==k)$.q=k
else j=null
f=f.c
if((f&15)===8)new A.dc(s,g,p).$0()
else if(q){if((f&1)!==0)new A.db(s,m).$0()}else if((f&2)!==0)new A.da(g,s).$0()
if(j!=null)$.q=j
f=s.c
if(f instanceof A.v){r=s.a.$ti
r=r.j("a0<2>").b(f)||!r.y[1].b(f)}else r=!1
if(r){i=s.a.b
if((f.a&24)!==0){h=i.c
i.c=null
b=i.V(h)
i.a=f.a&30|i.a&1
i.c=f.c
g.a=f
continue}else A.ek(f,i,!0)
return}}i=s.a.b
h=i.c
i.c=null
b=i.V(h)
f=s.b
r=s.c
if(!f){i.a=8
i.c=r}else{i.a=i.a&1|16
i.c=r}g.a=i
f=i}},
jl(a,b){if(t.Q.b(a))return b.aX(a)
if(t.v.b(a))return a
throw A.a(A.eL(a,"onError",u.c))},
ji(){var s,r
for(s=$.ay;s!=null;s=$.ay){$.bp=null
r=s.b
$.ay=r
if(r==null)$.bo=null
s.a.$0()}},
jp(){$.ex=!0
try{A.ji()}finally{$.bp=null
$.ex=!1
if($.ay!=null)$.eK().$1(A.fT())}},
fO(a){var s=new A.c2(a),r=$.bo
if(r==null){$.ay=$.bo=s
if(!$.ex)$.eK().$1(A.fT())}else $.bo=r.b=s},
jo(a){var s,r,q,p=$.ay
if(p==null){A.fO(a)
$.bp=$.bo
return}s=new A.c2(a)
r=$.bp
if(r==null){s.b=p
$.ay=$.bp=s}else{q=r.b
s.b=q
$.bp=r.b=s
if(q==null)$.bo=s}},
jW(a){var s=null,r=$.q
if(B.c===r){A.az(s,s,B.c,a)
return}A.az(s,s,r,r.aF(a))},
k6(a){A.eB(a,"stream",t.K)
return new A.cf()},
ey(a,b){A.jo(new A.dO(a,b))},
fL(a,b,c,d){var s,r=$.q
if(r===c)return d.$0()
$.q=c
s=r
try{r=d.$0()
return r}finally{$.q=s}},
jn(a,b,c,d,e){var s,r=$.q
if(r===c)return d.$1(e)
$.q=c
s=r
try{r=d.$1(e)
return r}finally{$.q=s}},
jm(a,b,c,d,e,f){var s,r=$.q
if(r===c)return d.$2(e,f)
$.q=c
s=r
try{r=d.$2(e,f)
return r}finally{$.q=s}},
az(a,b,c,d){if(B.c!==c)d=c.aF(d)
A.fO(d)},
cY:function cY(a){this.a=a},
cX:function cX(a,b,c){this.a=a
this.b=b
this.c=c},
cZ:function cZ(a){this.a=a},
d_:function d_(a){this.a=a},
dq:function dq(){},
dr:function dr(a,b){this.a=a
this.b=b},
c1:function c1(a,b){this.a=a
this.b=!1
this.$ti=b},
dC:function dC(a){this.a=a},
dD:function dD(a){this.a=a},
dQ:function dQ(a){this.a=a},
a_:function a_(a,b){this.a=a
this.b=b},
c3:function c3(){},
b5:function b5(a,b){this.a=a
this.$ti=b},
av:function av(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
v:function v(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
d2:function d2(a,b){this.a=a
this.b=b},
d9:function d9(a,b){this.a=a
this.b=b},
d6:function d6(a){this.a=a},
d7:function d7(a){this.a=a},
d8:function d8(a,b,c){this.a=a
this.b=b
this.c=c},
d5:function d5(a,b){this.a=a
this.b=b},
d4:function d4(a,b){this.a=a
this.b=b},
d3:function d3(a,b,c){this.a=a
this.b=b
this.c=c},
dc:function dc(a,b,c){this.a=a
this.b=b
this.c=c},
dd:function dd(a,b){this.a=a
this.b=b},
de:function de(a){this.a=a},
db:function db(a,b){this.a=a
this.b=b},
da:function da(a,b){this.a=a
this.b=b},
c2:function c2(a){this.a=a
this.b=null},
cf:function cf(){},
dB:function dB(){},
dO:function dO(a,b){this.a=a
this.b=b},
dh:function dh(){},
di:function di(a,b){this.a=a
this.b=b},
eU(a,b,c){return A.jD(a,new A.ag(b.j("@<0>").B(c).j("ag<1,2>")))},
ee(a,b){return new A.ag(a.j("@<0>").B(b).j("ag<1,2>"))},
hH(a){var s,r=A.a7(a),q=new J.Z(a,a.length,r.j("Z<1>"))
if(q.m()){s=q.d
return s==null?r.c.a(s):s}return null},
ef(a){var s,r={}
if(A.eG(a))return"{...}"
s=new A.z("")
try{$.am.push(a)
s.a+="{"
r.a=!0
a.F(0,new A.cE(r,s))
s.a+="}"}finally{$.am.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
e:function e(){},
P:function P(){},
cE:function cE(a,b){this.a=a
this.b=b},
ci:function ci(){},
aU:function aU(){},
au:function au(a,b){this.a=a
this.$ti=b},
ar:function ar(){},
bj:function bj(){},
jj(a,b){var s,r,q,p=null
try{p=JSON.parse(a)}catch(r){s=A.X(r)
q=A.x(String(s),null,null)
throw A.a(q)}q=A.dE(p)
return q},
dE(a){var s
if(a==null)return null
if(typeof a!="object")return a
if(!Array.isArray(a))return new A.c8(a,Object.create(null))
for(s=0;s<a.length;++s)a[s]=A.dE(a[s])
return a},
iJ(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.hh()
else s=new Uint8Array(o)
for(r=J.ck(a),q=0;q<o;++q){p=r.k(a,b+q)
if((p&255)!==p)p=255
s[q]=p}return s},
iI(a,b,c,d){var s=a?$.hg():$.hf()
if(s==null)return null
if(0===c&&d===b.length)return A.ft(s,b)
return A.ft(s,b.subarray(c,d))},
ft(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
eM(a,b,c,d,e,f){if(B.b.a3(f,4)!==0)throw A.a(A.x("Invalid base64 padding, padded length must be multiple of four, is "+f,a,c))
if(d+e!==f)throw A.a(A.x("Invalid base64 padding, '=' not at the end",a,b))
if(e>2)throw A.a(A.x("Invalid base64 padding, more than two '=' characters",a,b))},
iK(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
c8:function c8(a,b){this.a=a
this.b=b
this.c=null},
c9:function c9(a){this.a=a},
dy:function dy(){},
dx:function dx(){},
cl:function cl(){},
cm:function cm(){},
bz:function bz(){},
bB:function bB(){},
cq:function cq(){},
ct:function ct(){},
cs:function cs(){},
cB:function cB(){},
cC:function cC(a){this.a=a},
cT:function cT(){},
cV:function cV(){},
dz:function dz(a){this.b=0
this.c=a},
cU:function cU(a){this.a=a},
dw:function dw(a){this.a=a
this.b=16
this.c=0},
e0(a,b){var s=A.eY(a,b)
if(s!=null)return s
throw A.a(A.x(a,null,null))},
hy(a,b){a=A.a(a)
a.stack=b.h(0)
throw a
throw A.a("unreachable")},
eV(a,b,c,d){var s,r=c?J.hL(a,d):J.hK(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
hP(a,b,c){var s,r,q=A.h([],c.j("p<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.e6)(a),++r)q.push(a[r])
q.$flags=1
return q},
eW(a,b,c){var s=A.hO(a,c)
return s},
hO(a,b){var s,r
if(Array.isArray(a))return A.h(a.slice(0),b.j("p<0>"))
s=A.h([],b.j("p<0>"))
for(r=J.ac(a);r.m();)s.push(r.gn())
return s},
f5(a,b,c){var s,r
A.eg(b,"start")
if(c!=null){s=c-b
if(s<0)throw A.a(A.F(c,b,null,"end",null))
if(s===0)return""}r=A.i_(a,b,c)
return r},
i_(a,b,c){var s=a.length
if(b>=s)return""
return A.hW(a,b,c==null||c>s?s:c)},
f0(a,b){return new A.cy(a,A.eT(a,!1,b,!1,!1,!1))},
f4(a,b,c){var s=J.ac(b)
if(!s.m())return a
if(c.length===0){do a+=A.i(s.gn())
while(s.m())}else{a+=A.i(s.gn())
for(;s.m();)a=a+c+A.i(s.gn())}return a},
fs(a,b,c,d){var s,r,q,p,o,n="0123456789ABCDEF"
if(c===B.e){s=$.hd()
s=s.b.test(b)}else s=!1
if(s)return b
r=B.D.I(b)
for(s=r.length,q=0,p="";q<s;++q){o=r[q]
if(o<128&&(a[o>>>4]&1<<(o&15))!==0)p+=A.Q(o)
else p=d&&o===32?p+"+":p+"%"+n[o>>>4&15]+n[o&15]}return p.charCodeAt(0)==0?p:p},
iA(a){var s,r,q
if(!$.he())return A.iB(a)
s=new URLSearchParams()
a.F(0,new A.dv(s))
r=s.toString()
q=r.length
if(q>0&&r[q-1]==="=")r=B.a.i(r,0,q-1)
return r.replace(/=&|\*|%7E/g,b=>b==="=&"?"&":b==="*"?"%2A":"~")},
hZ(){return A.aa(new Error())},
cr(a){if(typeof a=="number"||A.ew(a)||a==null)return J.an(a)
if(typeof a=="string")return JSON.stringify(a)
return A.eZ(a)},
hz(a,b){A.eB(a,"error",t.K)
A.eB(b,"stackTrace",t.l)
A.hy(a,b)},
bw(a){return new A.bv(a)},
M(a,b){return new A.I(!1,null,b,a)},
eL(a,b,c){return new A.I(!0,a,b,c)},
hX(a,b){return new A.b0(null,null,!0,a,b,"Value not in range")},
F(a,b,c,d,e){return new A.b0(b,c,!0,a,d,"Invalid value")},
b1(a,b,c){if(0>a||a>c)throw A.a(A.F(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.a(A.F(b,a,c,"end",null))
return b}return c},
eg(a,b){if(a<0)throw A.a(A.F(a,0,null,b,null))
return a},
ea(a,b,c,d){return new A.bD(b,!0,a,d,"Index out of range")},
bZ(a){return new A.b4(a)},
f7(a){return new A.bW(a)},
f3(a){return new A.b3(a)},
aF(a){return new A.bA(a)},
x(a,b,c){return new A.bC(a,b,c)},
hI(a,b,c){var s,r
if(A.eG(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.h([],t.s)
$.am.push(a)
try{A.jg(a,s)}finally{$.am.pop()}r=A.f4(b,s,", ")+c
return r.charCodeAt(0)==0?r:r},
eb(a,b,c){var s,r
if(A.eG(a))return b+"..."+c
s=new A.z(b)
$.am.push(a)
try{r=s
r.a=A.f4(r.a,a,", ")}finally{$.am.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
jg(a,b){var s,r,q,p,o,n,m,l=a.gA(a),k=0,j=0
while(!0){if(!(k<80||j<3))break
if(!l.m())return
s=A.i(l.gn())
b.push(s)
k+=s.length+2;++j}if(!l.m()){if(j<=5)return
r=b.pop()
q=b.pop()}else{p=l.gn();++j
if(!l.m()){if(j<=4){b.push(A.i(p))
return}r=A.i(p)
q=b.pop()
k+=r.length+2}else{o=l.gn();++j
for(;l.m();p=o,o=n){n=l.gn();++j
if(j>100){while(!0){if(!(k>75&&j>3))break
k-=b.pop().length+2;--j}b.push("...")
return}}q=A.i(p)
r=A.i(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
while(!0){if(!(k>80&&b.length>3))break
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)b.push(m)
b.push(q)
b.push(r)},
hT(a,b,c,d){var s
if(B.j===c){s=B.b.gp(a)
b=J.Y(b)
return A.ej(A.a4(A.a4($.e7(),s),b))}if(B.j===d){s=B.b.gp(a)
b=J.Y(b)
c=J.Y(c)
return A.ej(A.a4(A.a4(A.a4($.e7(),s),b),c))}s=B.b.gp(a)
b=J.Y(b)
c=J.Y(c)
d=J.Y(d)
d=A.ej(A.a4(A.a4(A.a4(A.a4($.e7(),s),b),c),d))
return d},
c0(a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=null
a6=a4.length
s=a5+5
if(a6>=s){r=((a4.charCodeAt(a5+4)^58)*3|a4.charCodeAt(a5)^100|a4.charCodeAt(a5+1)^97|a4.charCodeAt(a5+2)^116|a4.charCodeAt(a5+3)^97)>>>0
if(r===0)return A.f8(a5>0||a6<a6?B.a.i(a4,a5,a6):a4,5,a3).gb_()
else if(r===32)return A.f8(B.a.i(a4,s,a6),0,a3).gb_()}q=A.eV(8,0,!1,t.S)
q[0]=0
p=a5-1
q[1]=p
q[2]=p
q[7]=p
q[3]=a5
q[4]=a5
q[5]=a6
q[6]=a6
if(A.fN(a4,a5,a6,0,q)>=14)q[7]=a6
o=q[1]
if(o>=a5)if(A.fN(a4,a5,o,20,q)===20)q[7]=o
n=q[2]+1
m=q[3]
l=q[4]
k=q[5]
j=q[6]
if(j<k)k=j
if(l<n)l=k
else if(l<=o)l=o+1
if(m<n)m=l
i=q[7]<a5
h=a3
if(i){i=!1
if(!(n>o+3)){p=m>a5
g=0
if(!(p&&m+1===l)){if(!B.a.v(a4,"\\",l))if(n>a5)f=B.a.v(a4,"\\",n-1)||B.a.v(a4,"\\",n-2)
else f=!1
else f=!0
if(!f){if(!(k<a6&&k===l+2&&B.a.v(a4,"..",l)))f=k>l+2&&B.a.v(a4,"/..",k-3)
else f=!0
if(!f)if(o===a5+4){if(B.a.v(a4,"file",a5)){if(n<=a5){if(!B.a.v(a4,"/",l)){e="file:///"
r=3}else{e="file://"
r=2}a4=e+B.a.i(a4,l,a6)
o-=a5
s=r-a5
k+=s
j+=s
a6=a4.length
a5=g
n=7
m=7
l=7}else if(l===k){s=a5===0
s
if(s){a4=B.a.J(a4,l,k,"/");++k;++j;++a6}else{a4=B.a.i(a4,a5,l)+"/"+B.a.i(a4,k,a6)
o-=a5
n-=a5
m-=a5
l-=a5
s=1-a5
k+=s
j+=s
a6=a4.length
a5=g}}h="file"}else if(B.a.v(a4,"http",a5)){if(p&&m+3===l&&B.a.v(a4,"80",m+1)){s=a5===0
s
if(s){a4=B.a.J(a4,m,l,"")
l-=3
k-=3
j-=3
a6-=3}else{a4=B.a.i(a4,a5,m)+B.a.i(a4,l,a6)
o-=a5
n-=a5
m-=a5
s=3+a5
l-=s
k-=s
j-=s
a6=a4.length
a5=g}}h="http"}}else if(o===s&&B.a.v(a4,"https",a5)){if(p&&m+4===l&&B.a.v(a4,"443",m+1)){s=a5===0
s
if(s){a4=B.a.J(a4,m,l,"")
l-=4
k-=4
j-=4
a6-=3}else{a4=B.a.i(a4,a5,m)+B.a.i(a4,l,a6)
o-=a5
n-=a5
m-=a5
s=4+a5
l-=s
k-=s
j-=s
a6=a4.length
a5=g}}h="https"}i=!f}}}}if(i){if(a5>0||a6<a4.length){a4=B.a.i(a4,a5,a6)
o-=a5
n-=a5
m-=a5
l-=a5
k-=a5
j-=a5}return new A.ce(a4,o,n,m,l,k,j,h)}if(h==null)if(o>a5)h=A.iC(a4,a5,o)
else{if(o===a5)A.ax(a4,a5,"Invalid empty scheme")
h=""}d=a3
if(n>a5){c=o+3
b=c<n?A.iD(a4,c,n-1):""
a=A.ix(a4,n,m,!1)
s=m+1
if(s<l){a0=A.eY(B.a.i(a4,s,l),a3)
d=A.iz(a0==null?A.h0(A.x("Invalid port",a4,s)):a0,h)}}else{a=a3
b=""}a1=A.iy(a4,l,k,a3,h,a!=null)
a2=k<j?A.er(a4,k+1,j,a3):a3
return A.ep(h,b,a,d,a1,a2,j<a6?A.iw(a4,j+1,a6):a3)},
i4(a){var s,r,q=0,p=null
try{s=A.c0(a,q,p)
return s}catch(r){if(A.X(r) instanceof A.bC)return null
else throw r}},
fa(a){var s=t.N
return B.d.bB(A.h(a.split("&"),t.s),A.ee(s,s),new A.cS(B.e))},
i3(a,b,c){var s,r,q,p,o,n,m="IPv4 address should contain exactly 4 parts",l="each part must be in the range 0..255",k=new A.cP(a),j=new Uint8Array(4)
for(s=b,r=s,q=0;s<c;++s){p=a.charCodeAt(s)
if(p!==46){if((p^48)>9)k.$2("invalid character",s)}else{if(q===3)k.$2(m,s)
o=A.e0(B.a.i(a,r,s),null)
if(o>255)k.$2(l,r)
n=q+1
j[q]=o
r=s+1
q=n}}if(q!==3)k.$2(m,c)
o=A.e0(B.a.i(a,r,c),null)
if(o>255)k.$2(l,r)
j[q]=o
return j},
f9(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=null,d=new A.cQ(a),c=new A.cR(d,a)
if(a.length<2)d.$2("address is too short",e)
s=A.h([],t.t)
for(r=b,q=r,p=!1,o=!1;r<a0;++r){n=a.charCodeAt(r)
if(n===58){if(r===b){++r
if(a.charCodeAt(r)!==58)d.$2("invalid start colon.",r)
q=r}if(r===q){if(p)d.$2("only one wildcard `::` is allowed",r)
s.push(-1)
p=!0}else s.push(c.$2(q,r))
q=r+1}else if(n===46)o=!0}if(s.length===0)d.$2("too few parts",e)
m=q===a0
l=B.d.ga0(s)
if(m&&l!==-1)d.$2("expected a part after last `:`",a0)
if(!m)if(!o)s.push(c.$2(q,a0))
else{k=A.i3(a,q,a0)
s.push((k[0]<<8|k[1])>>>0)
s.push((k[2]<<8|k[3])>>>0)}if(p){if(s.length>7)d.$2("an address with a wildcard must have less than 7 parts",e)}else if(s.length!==8)d.$2("an address without a wildcard must contain exactly 8 parts",e)
j=new Uint8Array(16)
for(l=s.length,i=9-l,r=0,h=0;r<l;++r){g=s[r]
if(g===-1)for(f=0;f<i;++f){j[h]=0
j[h+1]=0
h+=2}else{j[h]=B.b.W(g,8)
j[h+1]=g&255
h+=2}}return j},
ep(a,b,c,d,e,f,g){return new A.bk(a,b,c,d,e,f,g)},
fm(a){if(a==="http")return 80
if(a==="https")return 443
return 0},
ax(a,b,c){throw A.a(A.x(c,a,b))},
iz(a,b){if(a!=null&&a===A.fm(b))return null
return a},
ix(a,b,c,d){var s,r,q,p,o,n
if(b===c)return""
if(a.charCodeAt(b)===91){s=c-1
if(a.charCodeAt(s)!==93)A.ax(a,b,"Missing end `]` to match `[` in host")
r=b+1
q=A.iu(a,r,s)
if(q<s){p=q+1
o=A.fr(a,B.a.v(a,"25",p)?q+3:p,s,"%25")}else o=""
A.f9(a,r,q)
return B.a.i(a,b,q).toLowerCase()+o+"]"}for(n=b;n<c;++n)if(a.charCodeAt(n)===58){q=B.a.a_(a,"%",b)
q=q>=b&&q<c?q:c
if(q<c){p=q+1
o=A.fr(a,B.a.v(a,"25",p)?q+3:p,c,"%25")}else o=""
A.f9(a,b,q)
return"["+B.a.i(a,b,q)+o+"]"}return A.iF(a,b,c)},
iu(a,b,c){var s=B.a.a_(a,"%",b)
return s>=b&&s<c?s:c},
fr(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i=d!==""?new A.z(d):null
for(s=b,r=s,q=!0;s<c;){p=a.charCodeAt(s)
if(p===37){o=A.es(a,s,!0)
n=o==null
if(n&&q){s+=3
continue}if(i==null)i=new A.z("")
m=i.a+=B.a.i(a,r,s)
if(n)o=B.a.i(a,s,s+3)
else if(o==="%")A.ax(a,s,"ZoneID should not contain % anymore")
i.a=m+o
s+=3
r=s
q=!0}else if(p<127&&(B.h[p>>>4]&1<<(p&15))!==0){if(q&&65<=p&&90>=p){if(i==null)i=new A.z("")
if(r<s){i.a+=B.a.i(a,r,s)
r=s}q=!1}++s}else{l=1
if((p&64512)===55296&&s+1<c){k=a.charCodeAt(s+1)
if((k&64512)===56320){p=65536+((p&1023)<<10)+(k&1023)
l=2}}j=B.a.i(a,r,s)
if(i==null){i=new A.z("")
n=i}else n=i
n.a+=j
m=A.eq(p)
n.a+=m
s+=l
r=s}}if(i==null)return B.a.i(a,b,c)
if(r<c){j=B.a.i(a,r,c)
i.a+=j}n=i.a
return n.charCodeAt(0)==0?n:n},
iF(a,b,c){var s,r,q,p,o,n,m,l,k,j,i
for(s=b,r=s,q=null,p=!0;s<c;){o=a.charCodeAt(s)
if(o===37){n=A.es(a,s,!0)
m=n==null
if(m&&p){s+=3
continue}if(q==null)q=new A.z("")
l=B.a.i(a,r,s)
if(!p)l=l.toLowerCase()
k=q.a+=l
j=3
if(m)n=B.a.i(a,s,s+3)
else if(n==="%"){n="%25"
j=1}q.a=k+n
s+=j
r=s
p=!0}else if(o<127&&(B.a5[o>>>4]&1<<(o&15))!==0){if(p&&65<=o&&90>=o){if(q==null)q=new A.z("")
if(r<s){q.a+=B.a.i(a,r,s)
r=s}p=!1}++s}else if(o<=93&&(B.q[o>>>4]&1<<(o&15))!==0)A.ax(a,s,"Invalid character")
else{j=1
if((o&64512)===55296&&s+1<c){i=a.charCodeAt(s+1)
if((i&64512)===56320){o=65536+((o&1023)<<10)+(i&1023)
j=2}}l=B.a.i(a,r,s)
if(!p)l=l.toLowerCase()
if(q==null){q=new A.z("")
m=q}else m=q
m.a+=l
k=A.eq(o)
m.a+=k
s+=j
r=s}}if(q==null)return B.a.i(a,b,c)
if(r<c){l=B.a.i(a,r,c)
if(!p)l=l.toLowerCase()
q.a+=l}m=q.a
return m.charCodeAt(0)==0?m:m},
iC(a,b,c){var s,r,q
if(b===c)return""
if(!A.fo(a.charCodeAt(b)))A.ax(a,b,"Scheme not starting with alphabetic character")
for(s=b,r=!1;s<c;++s){q=a.charCodeAt(s)
if(!(q<128&&(B.o[q>>>4]&1<<(q&15))!==0))A.ax(a,s,"Illegal scheme character")
if(65<=q&&q<=90)r=!0}a=B.a.i(a,b,c)
return A.it(r?a.toLowerCase():a)},
it(a){if(a==="http")return"http"
if(a==="file")return"file"
if(a==="https")return"https"
if(a==="package")return"package"
return a},
iD(a,b,c){return A.bl(a,b,c,B.a4,!1,!1)},
iy(a,b,c,d,e,f){var s,r=e==="file",q=r||f
if(a==null)return r?"/":""
else s=A.bl(a,b,c,B.p,!0,!0)
if(s.length===0){if(r)return"/"}else if(q&&!B.a.u(s,"/"))s="/"+s
return A.iE(s,e,f)},
iE(a,b,c){var s=b.length===0
if(s&&!c&&!B.a.u(a,"/")&&!B.a.u(a,"\\"))return A.iG(a,!s||c)
return A.iH(a)},
er(a,b,c,d){if(a!=null){if(d!=null)throw A.a(A.M("Both query and queryParameters specified",null))
return A.bl(a,b,c,B.i,!0,!1)}if(d==null)return null
return A.iA(d)},
iB(a){var s={},r=new A.z("")
s.a=""
a.F(0,new A.dt(new A.du(s,r)))
s=r.a
return s.charCodeAt(0)==0?s:s},
iw(a,b,c){return A.bl(a,b,c,B.i,!0,!1)},
es(a,b,c){var s,r,q,p,o,n=b+2
if(n>=a.length)return"%"
s=a.charCodeAt(b+1)
r=a.charCodeAt(n)
q=A.dT(s)
p=A.dT(r)
if(q<0||p<0)return"%"
o=q*16+p
if(o<127&&(B.h[B.b.W(o,4)]&1<<(o&15))!==0)return A.Q(c&&65<=o&&90>=o?(o|32)>>>0:o)
if(s>=97||r>=97)return B.a.i(a,b,b+3).toUpperCase()
return null},
eq(a){var s,r,q,p,o,n="0123456789ABCDEF"
if(a<=127){s=new Uint8Array(3)
s[0]=37
s[1]=n.charCodeAt(a>>>4)
s[2]=n.charCodeAt(a&15)}else{if(a>2047)if(a>65535){r=240
q=4}else{r=224
q=3}else{r=192
q=2}s=new Uint8Array(3*q)
for(p=0;--q,q>=0;r=128){o=B.b.bq(a,6*q)&63|r
s[p]=37
s[p+1]=n.charCodeAt(o>>>4)
s[p+2]=n.charCodeAt(o&15)
p+=3}}return A.f5(s,0,null)},
bl(a,b,c,d,e,f){var s=A.fq(a,b,c,d,e,f)
return s==null?B.a.i(a,b,c):s},
fq(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j,i=null
for(s=!e,r=b,q=r,p=i;r<c;){o=a.charCodeAt(r)
if(o<127&&(d[o>>>4]&1<<(o&15))!==0)++r
else{n=1
if(o===37){m=A.es(a,r,!1)
if(m==null){r+=3
continue}if("%"===m)m="%25"
else n=3}else if(o===92&&f)m="/"
else if(s&&o<=93&&(B.q[o>>>4]&1<<(o&15))!==0){A.ax(a,r,"Invalid character")
n=i
m=n}else{if((o&64512)===55296){l=r+1
if(l<c){k=a.charCodeAt(l)
if((k&64512)===56320){o=65536+((o&1023)<<10)+(k&1023)
n=2}}}m=A.eq(o)}if(p==null){p=new A.z("")
l=p}else l=p
j=l.a+=B.a.i(a,q,r)
l.a=j+A.i(m)
r+=n
q=r}}if(p==null)return i
if(q<c){s=B.a.i(a,q,c)
p.a+=s}s=p.a
return s.charCodeAt(0)==0?s:s},
fp(a){if(B.a.u(a,"."))return!0
return B.a.aQ(a,"/.")!==-1},
iH(a){var s,r,q,p,o,n
if(!A.fp(a))return a
s=A.h([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(n===".."){if(s.length!==0){s.pop()
if(s.length===0)s.push("")}p=!0}else{p="."===n
if(!p)s.push(n)}}if(p)s.push("")
return B.d.aU(s,"/")},
iG(a,b){var s,r,q,p,o,n
if(!A.fp(a))return!b?A.fn(a):a
s=A.h([],t.s)
for(r=a.split("/"),q=r.length,p=!1,o=0;o<q;++o){n=r[o]
if(".."===n){p=s.length!==0&&B.d.ga0(s)!==".."
if(p)s.pop()
else s.push("..")}else{p="."===n
if(!p)s.push(n)}}r=s.length
if(r!==0)r=r===1&&s[0].length===0
else r=!0
if(r)return"./"
if(p||B.d.ga0(s)==="..")s.push("")
if(!b)s[0]=A.fn(s[0])
return B.d.aU(s,"/")},
fn(a){var s,r,q=a.length
if(q>=2&&A.fo(a.charCodeAt(0)))for(s=1;s<q;++s){r=a.charCodeAt(s)
if(r===58)return B.a.i(a,0,s)+"%3A"+B.a.L(a,s+1)
if(r>127||(B.o[r>>>4]&1<<(r&15))===0)break}return a},
iv(a,b){var s,r,q
for(s=0,r=0;r<2;++r){q=a.charCodeAt(b+r)
if(48<=q&&q<=57)s=s*16+q-48
else{q|=32
if(97<=q&&q<=102)s=s*16+q-87
else throw A.a(A.M("Invalid URL encoding",null))}}return s},
et(a,b,c,d,e){var s,r,q,p,o=b
while(!0){if(!(o<c)){s=!0
break}r=a.charCodeAt(o)
q=!0
if(r<=127)if(r!==37)q=r===43
if(q){s=!1
break}++o}if(s)if(B.e===d)return B.a.i(a,b,c)
else p=new A.by(B.a.i(a,b,c))
else{p=A.h([],t.t)
for(q=a.length,o=b;o<c;++o){r=a.charCodeAt(o)
if(r>127)throw A.a(A.M("Illegal percent encoding in URI",null))
if(r===37){if(o+3>q)throw A.a(A.M("Truncated URI",null))
p.push(A.iv(a,o+1))
o+=2}else if(r===43)p.push(32)
else p.push(r)}}return B.an.I(p)},
fo(a){var s=a|32
return 97<=s&&s<=122},
f8(a,b,c){var s,r,q,p,o,n,m,l,k="Invalid MIME type",j=A.h([b-1],t.t)
for(s=a.length,r=b,q=-1,p=null;r<s;++r){p=a.charCodeAt(r)
if(p===44||p===59)break
if(p===47){if(q<0){q=r
continue}throw A.a(A.x(k,a,r))}}if(q<0&&r>b)throw A.a(A.x(k,a,r))
for(;p!==44;){j.push(r);++r
for(o=-1;r<s;++r){p=a.charCodeAt(r)
if(p===61){if(o<0)o=r}else if(p===59||p===44)break}if(o>=0)j.push(o)
else{n=B.d.ga0(j)
if(p!==44||r!==n+7||!B.a.v(a,"base64",n+1))throw A.a(A.x("Expecting '='",a,r))
break}}j.push(r)
m=r+1
if((j.length&1)===1)a=B.u.bH(a,m,s)
else{l=A.fq(a,m,s,B.i,!0,!1)
if(l!=null)a=B.a.J(a,m,s,l)}return new A.cO(a,j,c)},
iS(){var s,r,q,p,o,n="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._~!$&'()*+,;=",m=".",l=":",k="/",j="\\",i="?",h="#",g="/\\",f=J.eS(22,t.D)
for(s=0;s<22;++s)f[s]=new Uint8Array(96)
r=new A.dH(f)
q=new A.dI()
p=new A.dJ()
o=r.$2(0,225)
q.$3(o,n,1)
q.$3(o,m,14)
q.$3(o,l,34)
q.$3(o,k,3)
q.$3(o,j,227)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(14,225)
q.$3(o,n,1)
q.$3(o,m,15)
q.$3(o,l,34)
q.$3(o,g,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(15,225)
q.$3(o,n,1)
q.$3(o,"%",225)
q.$3(o,l,34)
q.$3(o,k,9)
q.$3(o,j,233)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(1,225)
q.$3(o,n,1)
q.$3(o,l,34)
q.$3(o,k,10)
q.$3(o,j,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(2,235)
q.$3(o,n,139)
q.$3(o,k,131)
q.$3(o,j,131)
q.$3(o,m,146)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(3,235)
q.$3(o,n,11)
q.$3(o,k,68)
q.$3(o,j,68)
q.$3(o,m,18)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(4,229)
q.$3(o,n,5)
p.$3(o,"AZ",229)
q.$3(o,l,102)
q.$3(o,"@",68)
q.$3(o,"[",232)
q.$3(o,k,138)
q.$3(o,j,138)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(5,229)
q.$3(o,n,5)
p.$3(o,"AZ",229)
q.$3(o,l,102)
q.$3(o,"@",68)
q.$3(o,k,138)
q.$3(o,j,138)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(6,231)
p.$3(o,"19",7)
q.$3(o,"@",68)
q.$3(o,k,138)
q.$3(o,j,138)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(7,231)
p.$3(o,"09",7)
q.$3(o,"@",68)
q.$3(o,k,138)
q.$3(o,j,138)
q.$3(o,i,172)
q.$3(o,h,205)
q.$3(r.$2(8,8),"]",5)
o=r.$2(9,235)
q.$3(o,n,11)
q.$3(o,m,16)
q.$3(o,g,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(16,235)
q.$3(o,n,11)
q.$3(o,m,17)
q.$3(o,g,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(17,235)
q.$3(o,n,11)
q.$3(o,k,9)
q.$3(o,j,233)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(10,235)
q.$3(o,n,11)
q.$3(o,m,18)
q.$3(o,k,10)
q.$3(o,j,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(18,235)
q.$3(o,n,11)
q.$3(o,m,19)
q.$3(o,g,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(19,235)
q.$3(o,n,11)
q.$3(o,g,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(11,235)
q.$3(o,n,11)
q.$3(o,k,10)
q.$3(o,j,234)
q.$3(o,i,172)
q.$3(o,h,205)
o=r.$2(12,236)
q.$3(o,n,12)
q.$3(o,i,12)
q.$3(o,h,205)
o=r.$2(13,237)
q.$3(o,n,13)
q.$3(o,i,13)
p.$3(r.$2(20,245),"az",21)
o=r.$2(21,245)
p.$3(o,"az",21)
p.$3(o,"09",21)
q.$3(o,"+-.",21)
return f},
fN(a,b,c,d,e){var s,r,q,p,o=$.hi()
for(s=b;s<c;++s){r=o[d]
q=a.charCodeAt(s)^96
p=r[q>95?31:q]
d=p&31
e[p>>>5]=s}return d},
dv:function dv(a){this.a=a},
d0:function d0(){},
l:function l(){},
bv:function bv(a){this.a=a},
R:function R(){},
I:function I(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
b0:function b0(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
bD:function bD(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
b4:function b4(a){this.a=a},
bW:function bW(a){this.a=a},
b3:function b3(a){this.a=a},
bA:function bA(a){this.a=a},
bS:function bS(){},
b2:function b2(){},
d1:function d1(a){this.a=a},
bC:function bC(a,b,c){this.a=a
this.b=b
this.c=c},
o:function o(){},
u:function u(){},
k:function k(){},
cg:function cg(){},
z:function z(a){this.a=a},
cS:function cS(a){this.a=a},
cP:function cP(a){this.a=a},
cQ:function cQ(a){this.a=a},
cR:function cR(a,b){this.a=a
this.b=b},
bk:function bk(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=_.y=_.w=$},
du:function du(a,b){this.a=a
this.b=b},
dt:function dt(a){this.a=a},
cO:function cO(a,b,c){this.a=a
this.b=b
this.c=c},
dH:function dH(a){this.a=a},
dI:function dI(){},
dJ:function dJ(){},
ce:function ce(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=null},
c5:function c5(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=_.y=_.w=$},
a8(a){var s
if(typeof a=="function")throw A.a(A.M("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.iP,a)
s[$.eJ()]=a
return s},
iP(a,b,c){if(c>=1)return a.$1(b)
return a.$0()},
e3(a,b){var s=new A.v($.q,b.j("v<0>")),r=new A.b5(s,b.j("b5<0>"))
a.then(A.aC(new A.e4(r),1),A.aC(new A.e5(r),1))
return s},
e4:function e4(a){this.a=a},
e5:function e5(a){this.a=a},
cG:function cG(a){this.a=a},
m:function m(a,b){this.a=a
this.b=b},
hC(a){var s,r,q,p,o,n,m,l,k="enclosedBy"
if(a.k(0,k)!=null){s=t.a.a(a.k(0,k))
r=new A.cp(A.fy(s.k(0,"name")),B.r[A.fw(s.k(0,"kind"))],A.fy(s.k(0,"href")))}else r=null
q=a.k(0,"name")
p=a.k(0,"qualifiedName")
o=A.fx(a.k(0,"packageRank"))
if(o==null)o=0
n=a.k(0,"href")
m=B.r[A.fw(a.k(0,"kind"))]
l=A.fx(a.k(0,"overriddenDepth"))
if(l==null)l=0
return new A.w(q,p,o,m,n,l,a.k(0,"desc"),r)},
A:function A(a,b){this.a=a
this.b=b},
cu:function cu(a){this.a=a},
cx:function cx(a,b){this.a=a
this.b=b},
cv:function cv(){},
cw:function cw(){},
w:function w(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h},
cp:function cp(a,b,c){this.a=a
this.b=b
this.c=c},
jI(){var s=self,r=s.document.getElementById("search-box"),q=s.document.getElementById("search-body"),p=s.document.getElementById("search-sidebar")
A.e3(s.window.fetch($.bt()+"index.json"),t.m).aY(new A.dY(new A.dZ(r,q,p),r,q,p),t.P)},
el(a){var s=A.h([],t.O),r=A.h([],t.M)
return new A.dj(a,A.c0(self.window.location.href,0,null),s,r)},
iR(a,b){var s,r,q,p,o,n,m,l=self,k=l.document.createElement("div"),j=b.e
if(j==null)j=""
k.setAttribute("data-href",j)
k.classList.add("tt-suggestion")
s=l.document.createElement("span")
s.classList.add("tt-suggestion-title")
s.innerHTML=A.eu(b.a+" "+b.d.h(0).toLowerCase(),a)
k.appendChild(s)
r=b.w
j=r!=null
if(j){s=l.document.createElement("span")
s.classList.add("tt-suggestion-container")
s.innerHTML="(in "+A.eu(r.a,a)+")"
k.appendChild(s)}q=b.r
if(q!=null&&q.length!==0){s=l.document.createElement("blockquote")
s.classList.add("one-line-description")
p=l.document.createElement("textarea")
p.innerHTML=q
s.setAttribute("title",p.value)
s.innerHTML=A.eu(q,a)
k.appendChild(s)}k.addEventListener("mousedown",A.a8(new A.dF()))
k.addEventListener("click",A.a8(new A.dG(b)))
if(j){j=r.a
o=r.b.h(0)
n=r.c
s=l.document.createElement("div")
s.classList.add("tt-container")
p=l.document.createElement("p")
p.textContent="Results from "
p.classList.add("tt-container-text")
m=l.document.createElement("a")
m.setAttribute("href",n)
m.innerHTML=j+" "+o
p.appendChild(m)
s.appendChild(p)
A.jh(s,k)}return k},
jh(a,b){var s,r=a.innerHTML
if(r.length===0)return
s=$.bn.k(0,r)
if(s!=null)s.appendChild(b)
else{a.appendChild(b)
$.bn.q(0,r,a)}},
eu(a,b){return A.jZ(a,A.f0(b,!1),new A.dK(),null)},
dL:function dL(){},
dZ:function dZ(a,b,c){this.a=a
this.b=b
this.c=c},
dY:function dY(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dj:function dj(a,b,c,d){var _=this
_.a=a
_.b=b
_.e=_.d=_.c=$
_.f=null
_.r=""
_.w=c
_.x=d
_.y=-1},
dk:function dk(a){this.a=a},
dl:function dl(a,b){this.a=a
this.b=b},
dm:function dm(a,b){this.a=a
this.b=b},
dn:function dn(a,b){this.a=a
this.b=b},
dp:function dp(a,b){this.a=a
this.b=b},
dF:function dF(){},
dG:function dG(a){this.a=a},
dK:function dK(){},
j_(){var s=self,r=s.document.getElementById("sidenav-left-toggle"),q=s.document.querySelector(".sidebar-offcanvas-left"),p=s.document.getElementById("overlay-under-drawer"),o=A.a8(new A.dM(q,p))
if(p!=null)p.addEventListener("click",o)
if(r!=null)r.addEventListener("click",o)},
iZ(){var s,r,q,p,o=self,n=o.document.body
if(n==null)return
s=n.getAttribute("data-using-base-href")
if(s==null)return
if(s!=="true"){r=n.getAttribute("data-base-href")
if(r==null)return
q=r}else q=""
p=o.document.getElementById("dartdoc-main-content")
if(p==null)return
A.fJ(q,p.getAttribute("data-above-sidebar"),o.document.getElementById("dartdoc-sidebar-left-content"))
A.fJ(q,p.getAttribute("data-below-sidebar"),o.document.getElementById("dartdoc-sidebar-right"))},
fJ(a,b,c){if(b==null||b.length===0||c==null)return
A.e3(self.window.fetch(a+A.i(b)),t.m).aY(new A.dN(c,a),t.P)},
fQ(a,b){var s,r,q,p,o,n=A.hJ(b,"HTMLAnchorElement")
if(n){n=b.attributes.getNamedItem("href")
s=n==null?null:n.value
if(s==null)return
r=A.i4(s)
if(r!=null&&!r.gaT())b.href=a+s}q=b.childNodes
for(p=0;p<q.length;++p){o=q.item(p)
if(o!=null)A.fQ(a,o)}},
dM:function dM(a,b){this.a=a
this.b=b},
dN:function dN(a,b){this.a=a
this.b=b},
jJ(){var s,r,q,p=self,o=p.document.body
if(o==null)return
s=p.document.getElementById("theme")
if(s==null)s=t.m.a(s)
r=new A.e_(s,o)
s.addEventListener("change",A.a8(new A.dX(r)))
q=p.window.localStorage.getItem("colorTheme")
if(q!=null){s.checked=q==="true"
r.$0()}},
e_:function e_(a,b){this.a=a
this.b=b},
dX:function dX(a){this.a=a},
jU(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
k_(a){A.eI(new A.aT("Field '"+a+"' has been assigned during initialization."),new Error())},
bs(){A.eI(new A.aT("Field '' has been assigned during initialization."),new Error())},
hJ(a,b){var s,r,q,p,o,n
if(b.length===0)return!1
s=b.split(".")
r=t.m.a(self)
for(q=s.length,p=t.B,o=0;o<q;++o){n=s[o]
r=p.a(r[n])
if(r==null)return!1}return a instanceof t.g.a(r)},
jR(){A.iZ()
A.j_()
A.jI()
var s=self.hljs
if(s!=null)s.highlightAll()
A.jJ()}},B={}
var w=[A,J,B]
var $={}
A.ec.prototype={}
J.bE.prototype={
E(a,b){return a===b},
gp(a){return A.bU(a)},
h(a){return"Instance of '"+A.cI(a)+"'"},
gt(a){return A.ak(A.ev(this))}}
J.bF.prototype={
h(a){return String(a)},
gp(a){return a?519018:218159},
gt(a){return A.ak(t.y)},
$ij:1}
J.aO.prototype={
E(a,b){return null==b},
h(a){return"null"},
gp(a){return 0},
$ij:1,
$iu:1}
J.aR.prototype={$in:1}
J.a2.prototype={
gp(a){return 0},
h(a){return String(a)}}
J.bT.prototype={}
J.as.prototype={}
J.a1.prototype={
h(a){var s=a[$.eJ()]
if(s==null)return this.b9(a)
return"JavaScript function for "+J.an(s)}}
J.aQ.prototype={
gp(a){return 0},
h(a){return String(a)}}
J.aS.prototype={
gp(a){return 0},
h(a){return String(a)}}
J.p.prototype={
Y(a,b){return new A.N(a,A.a7(a).j("@<1>").B(b).j("N<1,2>"))},
Z(a){a.$flags&1&&A.K(a,"clear","clear")
a.length=0},
aU(a,b){var s,r=A.eV(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)r[s]=A.i(a[s])
return r.join(b)},
bA(a,b,c){var s,r,q=a.length
for(s=b,r=0;r<q;++r){s=c.$2(s,a[r])
if(a.length!==q)throw A.a(A.aF(a))}return s},
bB(a,b,c){return this.bA(a,b,c,t.z)},
C(a,b){return a[b]},
b8(a,b,c){var s=a.length
if(b>s)throw A.a(A.F(b,0,s,"start",null))
if(c<b||c>s)throw A.a(A.F(c,b,s,"end",null))
if(b===c)return A.h([],A.a7(a))
return A.h(a.slice(b,c),A.a7(a))},
ga0(a){var s=a.length
if(s>0)return a[s-1]
throw A.a(A.hG())},
b7(a,b){var s,r,q,p,o
a.$flags&2&&A.K(a,"sort")
s=a.length
if(s<2)return
if(b==null)b=J.j5()
if(s===2){r=a[0]
q=a[1]
if(b.$2(r,q)>0){a[0]=q
a[1]=r}return}p=0
if(A.a7(a).c.b(null))for(o=0;o<a.length;++o)if(a[o]===void 0){a[o]=null;++p}a.sort(A.aC(b,2))
if(p>0)this.bo(a,p)},
bo(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
h(a){return A.eb(a,"[","]")},
gA(a){return new J.Z(a,a.length,A.a7(a).j("Z<1>"))},
gp(a){return A.bU(a)},
gl(a){return a.length},
k(a,b){if(!(b>=0&&b<a.length))throw A.a(A.eD(a,b))
return a[b]},
q(a,b,c){a.$flags&2&&A.K(a)
if(!(b>=0&&b<a.length))throw A.a(A.eD(a,b))
a[b]=c},
$ic:1,
$if:1}
J.cz.prototype={}
J.Z.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=q.length
if(r.b!==p)throw A.a(A.e6(q))
s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0}}
J.aP.prototype={
aH(a,b){var s
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gal(b)
if(this.gal(a)===s)return 0
if(this.gal(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gal(a){return a===0?1/a<0:a<0},
h(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gp(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a3(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
br(a,b){return(a|0)===a?a/b|0:this.bs(a,b)},
bs(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.a(A.bZ("Result of truncating division is "+A.i(s)+": "+A.i(a)+" ~/ "+b))},
W(a,b){var s
if(a>0)s=this.aC(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
bq(a,b){if(0>b)throw A.a(A.ju(b))
return this.aC(a,b)},
aC(a,b){return b>31?0:a>>>b},
gt(a){return A.ak(t.H)},
$it:1}
J.aN.prototype={
gt(a){return A.ak(t.S)},
$ij:1,
$ib:1}
J.bG.prototype={
gt(a){return A.ak(t.i)},
$ij:1}
J.af.prototype={
J(a,b,c,d){var s=A.b1(b,c,a.length)
return a.substring(0,b)+d+a.substring(s)},
v(a,b,c){var s
if(c<0||c>a.length)throw A.a(A.F(c,0,a.length,null,null))
s=c+b.length
if(s>a.length)return!1
return b===a.substring(c,s)},
u(a,b){return this.v(a,b,0)},
i(a,b,c){return a.substring(b,A.b1(b,c,a.length))},
L(a,b){return this.i(a,b,null)},
b4(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.a(B.C)
for(s=a,r="";!0;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
a_(a,b,c){var s
if(c<0||c>a.length)throw A.a(A.F(c,0,a.length,null,null))
s=a.indexOf(b,c)
return s},
aQ(a,b){return this.a_(a,b,0)},
O(a,b){return A.jY(a,b,0)},
aH(a,b){var s
if(a===b)s=0
else s=a<b?-1:1
return s},
h(a){return a},
gp(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gt(a){return A.ak(t.N)},
gl(a){return a.length},
$ij:1,
$id:1}
A.a5.prototype={
gA(a){return new A.bx(J.ac(this.gN()),A.E(this).j("bx<1,2>"))},
gl(a){return J.bu(this.gN())},
C(a,b){return A.E(this).y[1].a(J.e8(this.gN(),b))},
h(a){return J.an(this.gN())}}
A.bx.prototype={
m(){return this.a.m()},
gn(){return this.$ti.y[1].a(this.a.gn())}}
A.ad.prototype={
gN(){return this.a}}
A.b7.prototype={$ic:1}
A.b6.prototype={
k(a,b){return this.$ti.y[1].a(J.hj(this.a,b))},
q(a,b,c){J.hk(this.a,b,this.$ti.c.a(c))},
$ic:1,
$if:1}
A.N.prototype={
Y(a,b){return new A.N(this.a,this.$ti.j("@<1>").B(b).j("N<1,2>"))},
gN(){return this.a}}
A.aT.prototype={
h(a){return"LateInitializationError: "+this.a}}
A.by.prototype={
gl(a){return this.a.length},
k(a,b){return this.a.charCodeAt(b)}}
A.cJ.prototype={}
A.c.prototype={}
A.J.prototype={
gA(a){var s=this
return new A.ao(s,s.gl(s),A.E(s).j("ao<J.E>"))}}
A.ao.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s,r=this,q=r.a,p=J.ck(q),o=p.gl(q)
if(r.b!==o)throw A.a(A.aF(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.C(q,s);++r.c
return!0}}
A.ah.prototype={
gA(a){return new A.ap(J.ac(this.a),this.b,A.E(this).j("ap<1,2>"))},
gl(a){return J.bu(this.a)},
C(a,b){return this.b.$1(J.e8(this.a,b))}}
A.aK.prototype={$ic:1}
A.ap.prototype={
m(){var s=this,r=s.b
if(r.m()){s.a=s.c.$1(r.gn())
return!0}s.a=null
return!1},
gn(){var s=this.a
return s==null?this.$ti.y[1].a(s):s}}
A.ai.prototype={
gl(a){return J.bu(this.a)},
C(a,b){return this.b.$1(J.e8(this.a,b))}}
A.aM.prototype={}
A.bY.prototype={
q(a,b,c){throw A.a(A.bZ("Cannot modify an unmodifiable list"))}}
A.at.prototype={}
A.bm.prototype={}
A.cd.prototype={$r:"+item,matchPosition(1,2)",$s:1}
A.aG.prototype={
h(a){return A.ef(this)},
q(a,b,c){A.hx()},
$iy:1}
A.aI.prototype={
gl(a){return this.b.length},
gbl(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
P(a){if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
k(a,b){if(!this.P(b))return null
return this.b[this.a[b]]},
F(a,b){var s,r,q=this.gbl(),p=this.b
for(s=q.length,r=0;r<s;++r)b.$2(q[r],p[r])}}
A.ca.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
m(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0}}
A.aH.prototype={}
A.aJ.prototype={
gl(a){return this.b},
gA(a){var s,r=this,q=r.$keys
if(q==null){q=Object.keys(r.a)
r.$keys=q}s=q
return new A.ca(s,s.length,r.$ti.j("ca<1>"))},
O(a,b){if("__proto__"===b)return!1
return this.a.hasOwnProperty(b)}}
A.cM.prototype={
D(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.b_.prototype={
h(a){return"Null check operator used on a null value"}}
A.bH.prototype={
h(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.bX.prototype={
h(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.cH.prototype={
h(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.aL.prototype={}
A.bd.prototype={
h(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$ia3:1}
A.ae.prototype={
h(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.h1(r==null?"unknown":r)+"'"},
gbQ(){return this},
$C:"$1",
$R:1,
$D:null}
A.cn.prototype={$C:"$0",$R:0}
A.co.prototype={$C:"$2",$R:2}
A.cL.prototype={}
A.cK.prototype={
h(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.h1(s)+"'"}}
A.aE.prototype={
E(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.aE))return!1
return this.$_target===b.$_target&&this.a===b.a},
gp(a){return(A.fY(this.a)^A.bU(this.$_target))>>>0},
h(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.cI(this.a)+"'")}}
A.c4.prototype={
h(a){return"Reading static variable '"+this.a+"' during its initialization"}}
A.bV.prototype={
h(a){return"RuntimeError: "+this.a}}
A.ag.prototype={
gl(a){return this.a},
gR(){return new A.O(this,A.E(this).j("O<1>"))},
gb1(){var s=A.E(this)
return A.hQ(new A.O(this,s.j("O<1>")),new A.cA(this),s.c,s.y[1])},
P(a){var s=this.b
if(s==null)return!1
return s[a]!=null},
k(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.bF(b)},
bF(a){var s,r,q=this.d
if(q==null)return null
s=q[this.aR(a)]
r=this.aS(s,a)
if(r<0)return null
return s[r].b},
q(a,b,c){var s,r,q,p,o,n,m=this
if(typeof b=="string"){s=m.b
m.aq(s==null?m.b=m.ab():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=m.c
m.aq(r==null?m.c=m.ab():r,b,c)}else{q=m.d
if(q==null)q=m.d=m.ab()
p=m.aR(b)
o=q[p]
if(o==null)q[p]=[m.ac(b,c)]
else{n=m.aS(o,b)
if(n>=0)o[n].b=c
else o.push(m.ac(b,c))}}},
Z(a){var s=this
if(s.a>0){s.b=s.c=s.d=s.e=s.f=null
s.a=0
s.az()}},
F(a,b){var s=this,r=s.e,q=s.r
for(;r!=null;){b.$2(r.a,r.b)
if(q!==s.r)throw A.a(A.aF(s))
r=r.c}},
aq(a,b,c){var s=a[b]
if(s==null)a[b]=this.ac(b,c)
else s.b=c},
az(){this.r=this.r+1&1073741823},
ac(a,b){var s=this,r=new A.cD(a,b)
if(s.e==null)s.e=s.f=r
else s.f=s.f.c=r;++s.a
s.az()
return r},
aR(a){return J.Y(a)&1073741823},
aS(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.H(a[r].a,b))return r
return-1},
h(a){return A.ef(this)},
ab(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s}}
A.cA.prototype={
$1(a){var s=this.a,r=s.k(0,a)
return r==null?A.E(s).y[1].a(r):r},
$S(){return A.E(this.a).j("2(1)")}}
A.cD.prototype={}
A.O.prototype={
gl(a){return this.a.a},
gA(a){var s=this.a,r=new A.bI(s,s.r)
r.c=s.e
return r}}
A.bI.prototype={
gn(){return this.d},
m(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.a(A.aF(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}}}
A.dU.prototype={
$1(a){return this.a(a)},
$S:11}
A.dV.prototype={
$2(a,b){return this.a(a,b)},
$S:12}
A.dW.prototype={
$1(a){return this.a(a)},
$S:13}
A.bc.prototype={
h(a){return this.aE(!1)},
aE(a){var s,r,q,p,o,n=this.bj(),m=this.aw(),l=(a?""+"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
o=m[q]
l=a?l+A.eZ(o):l+A.i(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
bj(){var s,r=this.$s
for(;$.dg.length<=r;)$.dg.push(null)
s=$.dg[r]
if(s==null){s=this.be()
$.dg[r]=s}return s},
be(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=t.K,j=J.eS(l,k)
for(s=0;s<l;++s)j[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
j[q]=r[s]}}j=A.hP(j,!1,k)
j.$flags=3
return j}}
A.cc.prototype={
aw(){return[this.a,this.b]},
E(a,b){if(b==null)return!1
return b instanceof A.cc&&this.$s===b.$s&&J.H(this.a,b.a)&&J.H(this.b,b.b)},
gp(a){return A.hT(this.$s,this.a,this.b,B.j)}}
A.cy.prototype={
h(a){return"RegExp/"+this.a+"/"+this.b.flags},
gbm(){var s=this,r=s.c
if(r!=null)return r
r=s.b
return s.c=A.eT(s.a,r.multiline,!r.ignoreCase,r.unicode,r.dotAll,!0)},
bi(a,b){var s,r=this.gbm()
r.lastIndex=b
s=r.exec(a)
if(s==null)return null
return new A.cb(s)}}
A.cb.prototype={
gby(){var s=this.b
return s.index+s[0].length},
k(a,b){return this.b[b]},
$icF:1,
$ieh:1}
A.cW.prototype={
gn(){var s=this.d
return s==null?t.F.a(s):s},
m(){var s,r,q,p,o,n,m=this,l=m.b
if(l==null)return!1
s=m.c
r=l.length
if(s<=r){q=m.a
p=q.bi(l,s)
if(p!=null){m.d=p
o=p.gby()
if(p.b.index===o){s=!1
if(q.b.unicode){q=m.c
n=q+1
if(n<r){r=l.charCodeAt(q)
if(r>=55296&&r<=56319){s=l.charCodeAt(n)
s=s>=56320&&s<=57343}}}o=(s?o+1:o)+1}m.c=o
return!0}}m.b=m.d=null
return!1}}
A.bJ.prototype={
gt(a){return B.ab},
$ij:1}
A.aX.prototype={}
A.bK.prototype={
gt(a){return B.ac},
$ij:1}
A.aq.prototype={
gl(a){return a.length},
$iD:1}
A.aV.prototype={
k(a,b){A.U(b,a,a.length)
return a[b]},
q(a,b,c){a.$flags&2&&A.K(a)
A.U(b,a,a.length)
a[b]=c},
$ic:1,
$if:1}
A.aW.prototype={
q(a,b,c){a.$flags&2&&A.K(a)
A.U(b,a,a.length)
a[b]=c},
$ic:1,
$if:1}
A.bL.prototype={
gt(a){return B.ad},
$ij:1}
A.bM.prototype={
gt(a){return B.ae},
$ij:1}
A.bN.prototype={
gt(a){return B.af},
k(a,b){A.U(b,a,a.length)
return a[b]},
$ij:1}
A.bO.prototype={
gt(a){return B.ag},
k(a,b){A.U(b,a,a.length)
return a[b]},
$ij:1}
A.bP.prototype={
gt(a){return B.ah},
k(a,b){A.U(b,a,a.length)
return a[b]},
$ij:1}
A.bQ.prototype={
gt(a){return B.aj},
k(a,b){A.U(b,a,a.length)
return a[b]},
$ij:1}
A.bR.prototype={
gt(a){return B.ak},
k(a,b){A.U(b,a,a.length)
return a[b]},
$ij:1}
A.aY.prototype={
gt(a){return B.al},
gl(a){return a.length},
k(a,b){A.U(b,a,a.length)
return a[b]},
$ij:1}
A.aZ.prototype={
gt(a){return B.am},
gl(a){return a.length},
k(a,b){A.U(b,a,a.length)
return a[b]},
$ij:1,
$iaj:1}
A.b8.prototype={}
A.b9.prototype={}
A.ba.prototype={}
A.bb.prototype={}
A.G.prototype={
j(a){return A.bi(v.typeUniverse,this,a)},
B(a){return A.fl(v.typeUniverse,this,a)}}
A.c7.prototype={}
A.ds.prototype={
h(a){return A.C(this.a,null)}}
A.c6.prototype={
h(a){return this.a}}
A.be.prototype={$iR:1}
A.cY.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:2}
A.cX.prototype={
$1(a){var s,r
this.a.a=a
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:14}
A.cZ.prototype={
$0(){this.a.$0()},
$S:5}
A.d_.prototype={
$0(){this.a.$0()},
$S:5}
A.dq.prototype={
ba(a,b){if(self.setTimeout!=null)self.setTimeout(A.aC(new A.dr(this,b),0),a)
else throw A.a(A.bZ("`setTimeout()` not found."))}}
A.dr.prototype={
$0(){this.b.$0()},
$S:0}
A.c1.prototype={
ae(a){var s,r=this
if(a==null)a=r.$ti.c.a(a)
if(!r.b)r.a.ar(a)
else{s=r.a
if(r.$ti.j("a0<1>").b(a))s.au(a)
else s.a7(a)}},
af(a,b){var s=this.a
if(this.b)s.H(a,b)
else s.a6(a,b)}}
A.dC.prototype={
$1(a){return this.a.$2(0,a)},
$S:3}
A.dD.prototype={
$2(a,b){this.a.$2(1,new A.aL(a,b))},
$S:15}
A.dQ.prototype={
$2(a,b){this.a(a,b)},
$S:16}
A.a_.prototype={
h(a){return A.i(this.a)},
$il:1,
gK(){return this.b}}
A.c3.prototype={
af(a,b){var s,r=this.a
if((r.a&30)!==0)throw A.a(A.f3("Future already completed"))
s=A.j4(a,b)
r.a6(s.a,s.b)},
aI(a){return this.af(a,null)}}
A.b5.prototype={
ae(a){var s=this.a
if((s.a&30)!==0)throw A.a(A.f3("Future already completed"))
s.ar(a)}}
A.av.prototype={
bG(a){if((this.c&15)!==6)return!0
return this.b.b.ap(this.d,a.a)},
bC(a){var s,r=this.e,q=null,p=a.a,o=this.b.b
if(t.Q.b(r))q=o.bL(r,p,a.b)
else q=o.ap(r,p)
try{p=q
return p}catch(s){if(t.c.b(A.X(s))){if((this.c&1)!==0)throw A.a(A.M("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.a(A.M("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.v.prototype={
a2(a,b,c){var s,r,q=$.q
if(q===B.c){if(b!=null&&!t.Q.b(b)&&!t.v.b(b))throw A.a(A.eL(b,"onError",u.c))}else if(b!=null)b=A.jl(b,q)
s=new A.v(q,c.j("v<0>"))
r=b==null?1:3
this.a5(new A.av(s,r,a,b,this.$ti.j("@<1>").B(c).j("av<1,2>")))
return s},
aY(a,b){return this.a2(a,null,b)},
aD(a,b,c){var s=new A.v($.q,c.j("v<0>"))
this.a5(new A.av(s,19,a,b,this.$ti.j("@<1>").B(c).j("av<1,2>")))
return s},
bp(a){this.a=this.a&1|16
this.c=a},
T(a){this.a=a.a&30|this.a&1
this.c=a.c},
a5(a){var s=this,r=s.a
if(r<=3){a.a=s.c
s.c=a}else{if((r&4)!==0){r=s.c
if((r.a&24)===0){r.a5(a)
return}s.T(r)}A.az(null,null,s.b,new A.d2(s,a))}},
aA(a){var s,r,q,p,o,n=this,m={}
m.a=a
if(a==null)return
s=n.a
if(s<=3){r=n.c
n.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){s=n.c
if((s.a&24)===0){s.aA(a)
return}n.T(s)}m.a=n.V(a)
A.az(null,null,n.b,new A.d9(m,n))}},
U(){var s=this.c
this.c=null
return this.V(s)},
V(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
bc(a){var s,r,q,p=this
p.a^=2
try{a.a2(new A.d6(p),new A.d7(p),t.P)}catch(q){s=A.X(q)
r=A.aa(q)
A.jW(new A.d8(p,s,r))}},
a7(a){var s=this,r=s.U()
s.a=8
s.c=a
A.aw(s,r)},
bd(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.U()
q.T(a)
A.aw(q,r)},
H(a,b){var s=this.U()
this.bp(new A.a_(a,b))
A.aw(this,s)},
ar(a){if(this.$ti.j("a0<1>").b(a)){this.au(a)
return}this.bb(a)},
bb(a){this.a^=2
A.az(null,null,this.b,new A.d4(this,a))},
au(a){if(this.$ti.b(a)){A.ek(a,this,!1)
return}this.bc(a)},
a6(a,b){this.a^=2
A.az(null,null,this.b,new A.d3(this,a,b))},
$ia0:1}
A.d2.prototype={
$0(){A.aw(this.a,this.b)},
$S:0}
A.d9.prototype={
$0(){A.aw(this.b,this.a.a)},
$S:0}
A.d6.prototype={
$1(a){var s,r,q,p=this.a
p.a^=2
try{p.a7(p.$ti.c.a(a))}catch(q){s=A.X(q)
r=A.aa(q)
p.H(s,r)}},
$S:2}
A.d7.prototype={
$2(a,b){this.a.H(a,b)},
$S:6}
A.d8.prototype={
$0(){this.a.H(this.b,this.c)},
$S:0}
A.d5.prototype={
$0(){A.ek(this.a.a,this.b,!0)},
$S:0}
A.d4.prototype={
$0(){this.a.a7(this.b)},
$S:0}
A.d3.prototype={
$0(){this.a.H(this.b,this.c)},
$S:0}
A.dc.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.bJ(q.d)}catch(p){s=A.X(p)
r=A.aa(p)
if(k.c&&k.b.a.c.a===s){q=k.a
q.c=k.b.a.c}else{q=s
o=r
if(o==null)o=A.e9(q)
n=k.a
n.c=new A.a_(q,o)
q=n}q.b=!0
return}if(j instanceof A.v&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=j.c
q.b=!0}return}if(j instanceof A.v){m=k.b.a
l=new A.v(m.b,m.$ti)
j.a2(new A.dd(l,m),new A.de(l),t.n)
q=k.a
q.c=l
q.b=!1}},
$S:0}
A.dd.prototype={
$1(a){this.a.bd(this.b)},
$S:2}
A.de.prototype={
$2(a,b){this.a.H(a,b)},
$S:6}
A.db.prototype={
$0(){var s,r,q,p,o,n
try{q=this.a
p=q.a
q.c=p.b.b.ap(p.d,this.b)}catch(o){s=A.X(o)
r=A.aa(o)
q=s
p=r
if(p==null)p=A.e9(q)
n=this.a
n.c=new A.a_(q,p)
n.b=!0}},
$S:0}
A.da.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=l.a.a.c
p=l.b
if(p.a.bG(s)&&p.a.e!=null){p.c=p.a.bC(s)
p.b=!1}}catch(o){r=A.X(o)
q=A.aa(o)
p=l.a.a.c
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.e9(p)
m=l.b
m.c=new A.a_(p,n)
p=m}p.b=!0}},
$S:0}
A.c2.prototype={}
A.cf.prototype={}
A.dB.prototype={}
A.dO.prototype={
$0(){A.hz(this.a,this.b)},
$S:0}
A.dh.prototype={
bN(a){var s,r,q
try{if(B.c===$.q){a.$0()
return}A.fL(null,null,this,a)}catch(q){s=A.X(q)
r=A.aa(q)
A.ey(s,r)}},
aF(a){return new A.di(this,a)},
bK(a){if($.q===B.c)return a.$0()
return A.fL(null,null,this,a)},
bJ(a){return this.bK(a,t.z)},
bO(a,b){if($.q===B.c)return a.$1(b)
return A.jn(null,null,this,a,b)},
ap(a,b){var s=t.z
return this.bO(a,b,s,s)},
bM(a,b,c){if($.q===B.c)return a.$2(b,c)
return A.jm(null,null,this,a,b,c)},
bL(a,b,c){var s=t.z
return this.bM(a,b,c,s,s,s)},
bI(a){return a},
aX(a){var s=t.z
return this.bI(a,s,s,s)}}
A.di.prototype={
$0(){return this.a.bN(this.b)},
$S:0}
A.e.prototype={
gA(a){return new A.ao(a,this.gl(a),A.aD(a).j("ao<e.E>"))},
C(a,b){return this.k(a,b)},
Y(a,b){return new A.N(a,A.aD(a).j("@<e.E>").B(b).j("N<1,2>"))},
bz(a,b,c,d){var s
A.b1(b,c,this.gl(a))
for(s=b;s<c;++s)this.q(a,s,d)},
h(a){return A.eb(a,"[","]")},
$ic:1,
$if:1}
A.P.prototype={
F(a,b){var s,r,q,p
for(s=this.gR(),s=s.gA(s),r=A.E(this).j("P.V");s.m();){q=s.gn()
p=this.k(0,q)
b.$2(q,p==null?r.a(p):p)}},
gl(a){var s=this.gR()
return s.gl(s)},
h(a){return A.ef(this)},
$iy:1}
A.cE.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.i(a)
s=r.a+=s
r.a=s+": "
s=A.i(b)
r.a+=s},
$S:17}
A.ci.prototype={
q(a,b,c){throw A.a(A.bZ("Cannot modify unmodifiable map"))}}
A.aU.prototype={
k(a,b){return this.a.k(0,b)},
q(a,b,c){this.a.q(0,b,c)},
gl(a){var s=this.a
return s.gl(s)},
h(a){return this.a.h(0)},
$iy:1}
A.au.prototype={}
A.ar.prototype={
h(a){return A.eb(this,"{","}")},
C(a,b){var s,r
A.eg(b,"index")
s=this.gA(this)
for(r=b;s.m();){if(r===0)return s.gn();--r}throw A.a(A.ea(b,b-r,this,"index"))},
$ic:1}
A.bj.prototype={}
A.c8.prototype={
k(a,b){var s,r=this.b
if(r==null)return this.c.k(0,b)
else if(typeof b!="string")return null
else{s=r[b]
return typeof s=="undefined"?this.bn(b):s}},
gl(a){return this.b==null?this.c.a:this.M().length},
gR(){if(this.b==null){var s=this.c
return new A.O(s,A.E(s).j("O<1>"))}return new A.c9(this)},
q(a,b,c){var s,r,q=this
if(q.b==null)q.c.q(0,b,c)
else if(q.P(b)){s=q.b
s[b]=c
r=q.a
if(r==null?s!=null:r!==s)r[b]=null}else q.bt().q(0,b,c)},
P(a){if(this.b==null)return this.c.P(a)
return Object.prototype.hasOwnProperty.call(this.a,a)},
F(a,b){var s,r,q,p,o=this
if(o.b==null)return o.c.F(0,b)
s=o.M()
for(r=0;r<s.length;++r){q=s[r]
p=o.b[q]
if(typeof p=="undefined"){p=A.dE(o.a[q])
o.b[q]=p}b.$2(q,p)
if(s!==o.c)throw A.a(A.aF(o))}},
M(){var s=this.c
if(s==null)s=this.c=A.h(Object.keys(this.a),t.s)
return s},
bt(){var s,r,q,p,o,n=this
if(n.b==null)return n.c
s=A.ee(t.N,t.z)
r=n.M()
for(q=0;p=r.length,q<p;++q){o=r[q]
s.q(0,o,n.k(0,o))}if(p===0)r.push("")
else B.d.Z(r)
n.a=n.b=null
return n.c=s},
bn(a){var s
if(!Object.prototype.hasOwnProperty.call(this.a,a))return null
s=A.dE(this.a[a])
return this.b[a]=s}}
A.c9.prototype={
gl(a){return this.a.gl(0)},
C(a,b){var s=this.a
return s.b==null?s.gR().C(0,b):s.M()[b]},
gA(a){var s=this.a
if(s.b==null){s=s.gR()
s=s.gA(s)}else{s=s.M()
s=new J.Z(s,s.length,A.a7(s).j("Z<1>"))}return s}}
A.dy.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:7}
A.dx.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:7}
A.cl.prototype={
bH(a0,a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a="Invalid base64 encoding length "
a2=A.b1(a1,a2,a0.length)
s=$.hc()
for(r=a1,q=r,p=null,o=-1,n=-1,m=0;r<a2;r=l){l=r+1
k=a0.charCodeAt(r)
if(k===37){j=l+2
if(j<=a2){i=A.dT(a0.charCodeAt(l))
h=A.dT(a0.charCodeAt(l+1))
g=i*16+h-(h&256)
if(g===37)g=-1
l=j}else g=-1}else g=k
if(0<=g&&g<=127){f=s[g]
if(f>=0){g="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".charCodeAt(f)
if(g===k)continue
k=g}else{if(f===-1){if(o<0){e=p==null?null:p.a.length
if(e==null)e=0
o=e+(r-q)
n=r}++m
if(k===61)continue}k=g}if(f!==-2){if(p==null){p=new A.z("")
e=p}else e=p
e.a+=B.a.i(a0,q,r)
d=A.Q(k)
e.a+=d
q=l
continue}}throw A.a(A.x("Invalid base64 data",a0,r))}if(p!=null){e=B.a.i(a0,q,a2)
e=p.a+=e
d=e.length
if(o>=0)A.eM(a0,n,a2,o,m,d)
else{c=B.b.a3(d-1,4)+1
if(c===1)throw A.a(A.x(a,a0,a2))
for(;c<4;){e+="="
p.a=e;++c}}e=p.a
return B.a.J(a0,a1,a2,e.charCodeAt(0)==0?e:e)}b=a2-a1
if(o>=0)A.eM(a0,n,a2,o,m,b)
else{c=B.b.a3(b,4)
if(c===1)throw A.a(A.x(a,a0,a2))
if(c>1)a0=B.a.J(a0,a2,a2,c===2?"==":"=")}return a0}}
A.cm.prototype={}
A.bz.prototype={}
A.bB.prototype={}
A.cq.prototype={}
A.ct.prototype={
h(a){return"unknown"}}
A.cs.prototype={
I(a){var s=this.bg(a,0,a.length)
return s==null?a:s},
bg(a,b,c){var s,r,q,p
for(s=b,r=null;s<c;++s){switch(a[s]){case"&":q="&amp;"
break
case'"':q="&quot;"
break
case"'":q="&#39;"
break
case"<":q="&lt;"
break
case">":q="&gt;"
break
case"/":q="&#47;"
break
default:q=null}if(q!=null){if(r==null)r=new A.z("")
if(s>b)r.a+=B.a.i(a,b,s)
r.a+=q
b=s+1}}if(r==null)return null
if(c>b){p=B.a.i(a,b,c)
r.a+=p}p=r.a
return p.charCodeAt(0)==0?p:p}}
A.cB.prototype={
bv(a,b){var s=A.jj(a,this.gbx().a)
return s},
gbx(){return B.H}}
A.cC.prototype={}
A.cT.prototype={}
A.cV.prototype={
I(a){var s,r,q,p=A.b1(0,null,a.length)
if(p===0)return new Uint8Array(0)
s=p*3
r=new Uint8Array(s)
q=new A.dz(r)
if(q.bk(a,0,p)!==p)q.ad()
return new Uint8Array(r.subarray(0,A.iQ(0,q.b,s)))}}
A.dz.prototype={
ad(){var s=this,r=s.c,q=s.b,p=s.b=q+1
r.$flags&2&&A.K(r)
r[q]=239
q=s.b=p+1
r[p]=191
s.b=q+1
r[q]=189},
bu(a,b){var s,r,q,p,o=this
if((b&64512)===56320){s=65536+((a&1023)<<10)|b&1023
r=o.c
q=o.b
p=o.b=q+1
r.$flags&2&&A.K(r)
r[q]=s>>>18|240
q=o.b=p+1
r[p]=s>>>12&63|128
p=o.b=q+1
r[q]=s>>>6&63|128
o.b=p+1
r[p]=s&63|128
return!0}else{o.ad()
return!1}},
bk(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(b!==c&&(a.charCodeAt(c-1)&64512)===55296)--c
for(s=k.c,r=s.$flags|0,q=s.length,p=b;p<c;++p){o=a.charCodeAt(p)
if(o<=127){n=k.b
if(n>=q)break
k.b=n+1
r&2&&A.K(s)
s[n]=o}else{n=o&64512
if(n===55296){if(k.b+4>q)break
m=p+1
if(k.bu(o,a.charCodeAt(m)))p=m}else if(n===56320){if(k.b+3>q)break
k.ad()}else if(o<=2047){n=k.b
l=n+1
if(l>=q)break
k.b=l
r&2&&A.K(s)
s[n]=o>>>6|192
k.b=l+1
s[l]=o&63|128}else{n=k.b
if(n+2>=q)break
l=k.b=n+1
r&2&&A.K(s)
s[n]=o>>>12|224
n=k.b=l+1
s[l]=o>>>6&63|128
k.b=n+1
s[n]=o&63|128}}}return p}}
A.cU.prototype={
I(a){return new A.dw(this.a).bh(a,0,null,!0)}}
A.dw.prototype={
bh(a,b,c,d){var s,r,q,p,o,n,m=this,l=A.b1(b,c,J.bu(a))
if(b===l)return""
if(a instanceof Uint8Array){s=a
r=s
q=0}else{r=A.iJ(a,b,l)
l-=b
q=b
b=0}if(l-b>=15){p=m.a
o=A.iI(p,r,b,l)
if(o!=null){if(!p)return o
if(o.indexOf("\ufffd")<0)return o}}o=m.a8(r,b,l,!0)
p=m.b
if((p&1)!==0){n=A.iK(p)
m.b=0
throw A.a(A.x(n,a,q+m.c))}return o},
a8(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.b.br(b+c,2)
r=q.a8(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.a8(a,s,c,d)}return q.bw(a,b,c,d)},
bw(a,b,c,d){var s,r,q,p,o,n,m,l=this,k=65533,j=l.b,i=l.c,h=new A.z(""),g=b+1,f=a[b]
$label0$0:for(s=l.a;!0;){for(;!0;g=p){r="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE".charCodeAt(f)&31
i=j<=32?f&61694>>>r:(f&63|i<<6)>>>0
j=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA".charCodeAt(j+r)
if(j===0){q=A.Q(i)
h.a+=q
if(g===c)break $label0$0
break}else if((j&1)!==0){if(s)switch(j){case 69:case 67:q=A.Q(k)
h.a+=q
break
case 65:q=A.Q(k)
h.a+=q;--g
break
default:q=A.Q(k)
q=h.a+=q
h.a=q+A.Q(k)
break}else{l.b=j
l.c=g-1
return""}j=0}if(g===c)break $label0$0
p=g+1
f=a[g]}p=g+1
f=a[g]
if(f<128){while(!0){if(!(p<c)){o=c
break}n=p+1
f=a[p]
if(f>=128){o=n-1
p=n
break}p=n}if(o-g<20)for(m=g;m<o;++m){q=A.Q(a[m])
h.a+=q}else{q=A.f5(a,g,o)
h.a+=q}if(o===c)break $label0$0
g=p}else g=p}if(d&&j>32)if(s){s=A.Q(k)
h.a+=s}else{l.b=77
l.c=c
return""}l.b=j
l.c=i
s=h.a
return s.charCodeAt(0)==0?s:s}}
A.dv.prototype={
$2(a,b){var s,r
if(typeof b=="string")this.a.set(a,b)
else if(b==null)this.a.set(a,"")
else for(s=J.ac(b),r=this.a;s.m();){b=s.gn()
if(typeof b=="string")r.append(a,b)
else if(b==null)r.append(a,"")
else A.iM(b)}},
$S:8}
A.d0.prototype={
h(a){return this.av()}}
A.l.prototype={
gK(){return A.hV(this)}}
A.bv.prototype={
h(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.cr(s)
return"Assertion failed"}}
A.R.prototype={}
A.I.prototype={
gaa(){return"Invalid argument"+(!this.a?"(s)":"")},
ga9(){return""},
h(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+p,n=s.gaa()+q+o
if(!s.a)return n
return n+s.ga9()+": "+A.cr(s.gak())},
gak(){return this.b}}
A.b0.prototype={
gak(){return this.b},
gaa(){return"RangeError"},
ga9(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.i(q):""
else if(q==null)s=": Not greater than or equal to "+A.i(r)
else if(q>r)s=": Not in inclusive range "+A.i(r)+".."+A.i(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.i(r)
return s}}
A.bD.prototype={
gak(){return this.b},
gaa(){return"RangeError"},
ga9(){if(this.b<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gl(a){return this.f}}
A.b4.prototype={
h(a){return"Unsupported operation: "+this.a}}
A.bW.prototype={
h(a){return"UnimplementedError: "+this.a}}
A.b3.prototype={
h(a){return"Bad state: "+this.a}}
A.bA.prototype={
h(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.cr(s)+"."}}
A.bS.prototype={
h(a){return"Out of Memory"},
gK(){return null},
$il:1}
A.b2.prototype={
h(a){return"Stack Overflow"},
gK(){return null},
$il:1}
A.d1.prototype={
h(a){return"Exception: "+this.a}}
A.bC.prototype={
h(a){var s,r,q,p,o,n,m,l,k,j,i,h=this.a,g=""!==h?"FormatException: "+h:"FormatException",f=this.c,e=this.b
if(typeof e=="string"){if(f!=null)s=f<0||f>e.length
else s=!1
if(s)f=null
if(f==null){if(e.length>78)e=B.a.i(e,0,75)+"..."
return g+"\n"+e}for(r=1,q=0,p=!1,o=0;o<f;++o){n=e.charCodeAt(o)
if(n===10){if(q!==o||!p)++r
q=o+1
p=!1}else if(n===13){++r
q=o+1
p=!0}}g=r>1?g+(" (at line "+r+", character "+(f-q+1)+")\n"):g+(" (at character "+(f+1)+")\n")
m=e.length
for(o=f;o<m;++o){n=e.charCodeAt(o)
if(n===10||n===13){m=o
break}}l=""
if(m-q>78){k="..."
if(f-q<75){j=q+75
i=q}else{if(m-f<75){i=m-75
j=m
k=""}else{i=f-36
j=f+36}l="..."}}else{j=m
i=q
k=""}return g+l+B.a.i(e,i,j)+k+"\n"+B.a.b4(" ",f-i+l.length)+"^\n"}else return f!=null?g+(" (at offset "+A.i(f)+")"):g}}
A.o.prototype={
Y(a,b){return A.hr(this,A.E(this).j("o.E"),b)},
gl(a){var s,r=this.gA(this)
for(s=0;r.m();)++s
return s},
C(a,b){var s,r
A.eg(b,"index")
s=this.gA(this)
for(r=b;s.m();){if(r===0)return s.gn();--r}throw A.a(A.ea(b,b-r,this,"index"))},
h(a){return A.hI(this,"(",")")}}
A.u.prototype={
gp(a){return A.k.prototype.gp.call(this,0)},
h(a){return"null"}}
A.k.prototype={$ik:1,
E(a,b){return this===b},
gp(a){return A.bU(this)},
h(a){return"Instance of '"+A.cI(this)+"'"},
gt(a){return A.jG(this)},
toString(){return this.h(this)}}
A.cg.prototype={
h(a){return""},
$ia3:1}
A.z.prototype={
gl(a){return this.a.length},
h(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.cS.prototype={
$2(a,b){var s,r,q,p=B.a.aQ(b,"=")
if(p===-1){if(b!=="")a.q(0,A.et(b,0,b.length,this.a,!0),"")}else if(p!==0){s=B.a.i(b,0,p)
r=B.a.L(b,p+1)
q=this.a
a.q(0,A.et(s,0,s.length,q,!0),A.et(r,0,r.length,q,!0))}return a},
$S:18}
A.cP.prototype={
$2(a,b){throw A.a(A.x("Illegal IPv4 address, "+a,this.a,b))},
$S:19}
A.cQ.prototype={
$2(a,b){throw A.a(A.x("Illegal IPv6 address, "+a,this.a,b))},
$S:20}
A.cR.prototype={
$2(a,b){var s
if(b-a>4)this.a.$2("an IPv6 part can only contain a maximum of 4 hex digits",a)
s=A.e0(B.a.i(this.b,a,b),16)
if(s<0||s>65535)this.a.$2("each part must be in the range of `0x0..0xFFFF`",a)
return s},
$S:21}
A.bk.prototype={
gX(){var s,r,q,p,o=this,n=o.w
if(n===$){s=o.a
r=s.length!==0?""+s+":":""
q=o.c
p=q==null
if(!p||s==="file"){s=r+"//"
r=o.b
if(r.length!==0)s=s+r+"@"
if(!p)s+=q
r=o.d
if(r!=null)s=s+":"+A.i(r)}else s=r
s+=o.e
r=o.f
if(r!=null)s=s+"?"+r
r=o.r
if(r!=null)s=s+"#"+r
n!==$&&A.bs()
n=o.w=s.charCodeAt(0)==0?s:s}return n},
gp(a){var s,r=this,q=r.y
if(q===$){s=B.a.gp(r.gX())
r.y!==$&&A.bs()
r.y=s
q=s}return q},
gan(){var s,r=this,q=r.z
if(q===$){s=r.f
s=A.fa(s==null?"":s)
r.z!==$&&A.bs()
q=r.z=new A.au(s,t.h)}return q},
gb0(){return this.b},
gai(){var s=this.c
if(s==null)return""
if(B.a.u(s,"["))return B.a.i(s,1,s.length-1)
return s},
ga1(){var s=this.d
return s==null?A.fm(this.a):s},
gam(){var s=this.f
return s==null?"":s},
gaK(){var s=this.r
return s==null?"":s},
ao(a){var s,r,q,p,o=this,n=o.a,m=n==="file",l=o.b,k=o.d,j=o.c
if(!(j!=null))j=l.length!==0||k!=null||m?"":null
s=o.e
if(!m)r=j!=null&&s.length!==0
else r=!0
if(r&&!B.a.u(s,"/"))s="/"+s
q=s
p=A.er(null,0,0,a)
return A.ep(n,l,j,k,q,p,o.r)},
gaT(){if(this.a!==""){var s=this.r
s=(s==null?"":s)===""}else s=!1
return s},
gaM(){return this.c!=null},
gaP(){return this.f!=null},
gaN(){return this.r!=null},
h(a){return this.gX()},
E(a,b){var s,r,q,p=this
if(b==null)return!1
if(p===b)return!0
s=!1
if(t.R.b(b))if(p.a===b.ga4())if(p.c!=null===b.gaM())if(p.b===b.gb0())if(p.gai()===b.gai())if(p.ga1()===b.ga1())if(p.e===b.gaW()){r=p.f
q=r==null
if(!q===b.gaP()){if(q)r=""
if(r===b.gam()){r=p.r
q=r==null
if(!q===b.gaN()){s=q?"":r
s=s===b.gaK()}}}}return s},
$ic_:1,
ga4(){return this.a},
gaW(){return this.e}}
A.du.prototype={
$2(a,b){var s=this.b,r=this.a
s.a+=r.a
r.a="&"
r=A.fs(B.h,a,B.e,!0)
r=s.a+=r
if(b!=null&&b.length!==0){s.a=r+"="
r=A.fs(B.h,b,B.e,!0)
s.a+=r}},
$S:22}
A.dt.prototype={
$2(a,b){var s,r
if(b==null||typeof b=="string")this.a.$2(a,b)
else for(s=J.ac(b),r=this.a;s.m();)r.$2(a,s.gn())},
$S:8}
A.cO.prototype={
gb_(){var s,r,q,p,o=this,n=null,m=o.c
if(m==null){m=o.a
s=o.b[0]+1
r=B.a.a_(m,"?",s)
q=m.length
if(r>=0){p=A.bl(m,r+1,q,B.i,!1,!1)
q=r}else p=n
m=o.c=new A.c5("data","",n,n,A.bl(m,s,q,B.p,!1,!1),p,n)}return m},
h(a){var s=this.a
return this.b[0]===-1?"data:"+s:s}}
A.dH.prototype={
$2(a,b){var s=this.a[a]
B.a7.bz(s,0,96,b)
return s},
$S:23}
A.dI.prototype={
$3(a,b,c){var s,r,q
for(s=b.length,r=a.$flags|0,q=0;q<s;++q){r&2&&A.K(a)
a[b.charCodeAt(q)^96]=c}},
$S:9}
A.dJ.prototype={
$3(a,b,c){var s,r,q
for(s=b.charCodeAt(0),r=b.charCodeAt(1),q=a.$flags|0;s<=r;++s){q&2&&A.K(a)
a[(s^96)>>>0]=c}},
$S:9}
A.ce.prototype={
gaM(){return this.c>0},
gaO(){return this.c>0&&this.d+1<this.e},
gaP(){return this.f<this.r},
gaN(){return this.r<this.a.length},
gaT(){return this.b>0&&this.r>=this.a.length},
ga4(){var s=this.w
return s==null?this.w=this.bf():s},
bf(){var s,r=this,q=r.b
if(q<=0)return""
s=q===4
if(s&&B.a.u(r.a,"http"))return"http"
if(q===5&&B.a.u(r.a,"https"))return"https"
if(s&&B.a.u(r.a,"file"))return"file"
if(q===7&&B.a.u(r.a,"package"))return"package"
return B.a.i(r.a,0,q)},
gb0(){var s=this.c,r=this.b+3
return s>r?B.a.i(this.a,r,s-1):""},
gai(){var s=this.c
return s>0?B.a.i(this.a,s,this.d):""},
ga1(){var s,r=this
if(r.gaO())return A.e0(B.a.i(r.a,r.d+1,r.e),null)
s=r.b
if(s===4&&B.a.u(r.a,"http"))return 80
if(s===5&&B.a.u(r.a,"https"))return 443
return 0},
gaW(){return B.a.i(this.a,this.e,this.f)},
gam(){var s=this.f,r=this.r
return s<r?B.a.i(this.a,s+1,r):""},
gaK(){var s=this.r,r=this.a
return s<r.length?B.a.L(r,s+1):""},
gan(){if(this.f>=this.r)return B.a6
return new A.au(A.fa(this.gam()),t.h)},
ao(a){var s,r,q,p,o,n=this,m=null,l=n.ga4(),k=l==="file",j=n.c,i=j>0?B.a.i(n.a,n.b+3,j):"",h=n.gaO()?n.ga1():m
j=n.c
if(j>0)s=B.a.i(n.a,j,n.d)
else s=i.length!==0||h!=null||k?"":m
j=n.a
r=B.a.i(j,n.e,n.f)
if(!k)q=s!=null&&r.length!==0
else q=!0
if(q&&!B.a.u(r,"/"))r="/"+r
p=A.er(m,0,0,a)
q=n.r
o=q<j.length?B.a.L(j,q+1):m
return A.ep(l,i,s,h,r,p,o)},
gp(a){var s=this.x
return s==null?this.x=B.a.gp(this.a):s},
E(a,b){if(b==null)return!1
if(this===b)return!0
return t.R.b(b)&&this.a===b.h(0)},
h(a){return this.a},
$ic_:1}
A.c5.prototype={}
A.e4.prototype={
$1(a){return this.a.ae(a)},
$S:3}
A.e5.prototype={
$1(a){if(a==null)return this.a.aI(new A.cG(a===undefined))
return this.a.aI(a)},
$S:3}
A.cG.prototype={
h(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.m.prototype={
av(){return"Kind."+this.b},
h(a){var s
switch(this.a){case 0:s="accessor"
break
case 1:s="constant"
break
case 2:s="constructor"
break
case 3:s="class"
break
case 4:s="dynamic"
break
case 5:s="enum"
break
case 6:s="extension"
break
case 7:s="extension type"
break
case 8:s="function"
break
case 9:s="library"
break
case 10:s="method"
break
case 11:s="mixin"
break
case 12:s="Never"
break
case 13:s="package"
break
case 14:s="parameter"
break
case 15:s="prefix"
break
case 16:s="property"
break
case 17:s="SDK"
break
case 18:s="topic"
break
case 19:s="top-level constant"
break
case 20:s="top-level property"
break
case 21:s="typedef"
break
case 22:s="type parameter"
break
default:s=null}return s}}
A.A.prototype={
av(){return"_MatchPosition."+this.b}}
A.cu.prototype={
aJ(a){var s,r,q,p,o,n,m,l,k,j,i
if(a.length===0)return A.h([],t.M)
s=a.toLowerCase()
r=A.h([],t.r)
for(q=this.a,p=q.length,o=s.length>1,n="dart:"+s,m=0;m<q.length;q.length===p||(0,A.e6)(q),++m){l=q[m]
k=new A.cx(r,l)
j=l.a.toLowerCase()
i=l.b.toLowerCase()
if(j===s||i===s||j===n)k.$1(B.ao)
else if(o)if(B.a.u(j,s)||B.a.u(i,s))k.$1(B.ap)
else if(B.a.O(j,s)||B.a.O(i,s))k.$1(B.aq)}B.d.b7(r,new A.cv())
q=t.V
return A.eW(new A.ai(r,new A.cw(),q),!0,q.j("J.E"))}}
A.cx.prototype={
$1(a){this.a.push(new A.cd(this.b,a))},
$S:24}
A.cv.prototype={
$2(a,b){var s,r,q=a.b.a-b.b.a
if(q!==0)return q
s=a.a
r=b.a
q=s.c-r.c
if(q!==0)return q
q=s.gaB()-r.gaB()
if(q!==0)return q
q=s.f-r.f
if(q!==0)return q
return s.a.length-r.a.length},
$S:25}
A.cw.prototype={
$1(a){return a.a},
$S:26}
A.w.prototype={
gaB(){var s=0
switch(this.d.a){case 3:break
case 5:break
case 6:break
case 7:break
case 11:break
case 19:break
case 20:break
case 21:break
case 0:s=1
break
case 1:s=1
break
case 2:s=1
break
case 8:s=1
break
case 10:s=1
break
case 16:s=1
break
case 9:s=2
break
case 13:s=2
break
case 18:s=2
break
case 4:s=3
break
case 12:s=3
break
case 14:s=3
break
case 15:s=3
break
case 17:s=3
break
case 22:s=3
break
default:s=null}return s}}
A.cp.prototype={}
A.dL.prototype={
$0(){var s,r=self.document.body
if(r==null)return""
if(J.H(r.getAttribute("data-using-base-href"),"false")){s=r.getAttribute("data-base-href")
return s==null?"":s}else return""},
$S:27}
A.dZ.prototype={
$0(){A.jU("Could not activate search functionality.")
var s=this.a
if(s!=null)s.placeholder="Failed to initialize search"
s=this.b
if(s!=null)s.placeholder="Failed to initialize search"
s=this.c
if(s!=null)s.placeholder="Failed to initialize search"},
$S:0}
A.dY.prototype={
$1(a){return this.b3(a)},
b3(a){var s=0,r=A.fK(t.P),q,p=this,o,n,m,l,k,j,i,h,g
var $async$$1=A.fR(function(b,c){if(b===1)return A.fA(c,r)
while(true)switch(s){case 0:if(!J.H(a.status,200)){p.a.$0()
s=1
break}i=J
h=t.j
g=B.B
s=3
return A.fz(A.e3(a.text(),t.N),$async$$1)
case 3:o=i.hl(h.a(g.bv(c,null)),t.a)
n=o.$ti.j("ai<e.E,w>")
m=new A.cu(A.eW(new A.ai(o,A.jX(),n),!0,n.j("J.E")))
n=self
l=A.c0(J.an(n.window.location),0,null).gan().k(0,"search")
if(l!=null){k=A.hH(m.aJ(l))
j=k==null?null:k.e
if(j!=null){n.window.location.assign($.bt()+j)
s=1
break}}n=p.b
if(n!=null)A.el(m).aj(n)
n=p.c
if(n!=null)A.el(m).aj(n)
n=p.d
if(n!=null)A.el(m).aj(n)
case 1:return A.fB(q,r)}})
return A.fC($async$$1,r)},
$S:10}
A.dj.prototype={
gG(){var s,r=this,q=r.c
if(q===$){s=self.document.createElement("div")
s.setAttribute("role","listbox")
s.setAttribute("aria-expanded","false")
s.style.display="none"
s.classList.add("tt-menu")
s.appendChild(r.gaV())
s.appendChild(r.gS())
r.c!==$&&A.bs()
r.c=s
q=s}return q},
gaV(){var s,r=this.d
if(r===$){s=self.document.createElement("div")
s.classList.add("enter-search-message")
this.d!==$&&A.bs()
this.d=s
r=s}return r},
gS(){var s,r=this.e
if(r===$){s=self.document.createElement("div")
s.classList.add("tt-search-results")
this.e!==$&&A.bs()
this.e=s
r=s}return r},
aj(a){var s,r,q,p=this
a.disabled=!1
a.setAttribute("placeholder","Search API Docs")
s=self
s.document.addEventListener("keydown",A.a8(new A.dk(a)))
r=s.document.createElement("div")
r.classList.add("tt-wrapper")
a.replaceWith(r)
a.setAttribute("autocomplete","off")
a.setAttribute("spellcheck","false")
a.classList.add("tt-input")
r.appendChild(a)
r.appendChild(p.gG())
p.b5(a)
if(J.hn(s.window.location.href,"search.html")){q=p.b.gan().k(0,"q")
if(q==null)return
q=B.l.I(q)
$.eA=$.dP
p.bE(q,!0)
p.b6(q)
p.ah()
$.eA=10}},
b6(a){var s,r,q,p,o,n=self,m=n.document.getElementById("dartdoc-main-content")
if(m==null)return
m.textContent=""
s=n.document.createElement("section")
s.classList.add("search-summary")
m.appendChild(s)
s=n.document.createElement("h2")
s.innerHTML="Search Results"
m.appendChild(s)
s=n.document.createElement("div")
s.classList.add("search-summary")
s.innerHTML=""+$.dP+' results for "'+a+'"'
m.appendChild(s)
if($.bn.a!==0)for(n=$.bn.gb1(),r=A.E(n),n=new A.ap(J.ac(n.a),n.b,r.j("ap<1,2>")),r=r.y[1];n.m();){q=n.a
if(q==null)q=r.a(q)
m.appendChild(q)}else{s=n.document.createElement("div")
s.classList.add("search-summary")
s.innerHTML='There was not a match for "'+a+'". Want to try searching from additional Dart-related sites? '
p=A.c0("https://dart.dev/search?cx=011220921317074318178%3A_yy-tmb5t_i&ie=UTF-8&hl=en&q=",0,null).ao(A.eU(["q",a],t.N,t.z))
o=n.document.createElement("a")
o.setAttribute("href",p.gX())
o.textContent="Search on dart.dev."
s.appendChild(o)
m.appendChild(s)}},
ah(){var s=this.gG()
s.style.display="none"
s.setAttribute("aria-expanded","false")
return s},
aZ(a,b,c){var s,r,q,p,o=this
o.x=A.h([],t.M)
s=o.w
B.d.Z(s)
$.bn.Z(0)
o.gS().textContent=""
r=b.length
if(r===0){o.ah()
return}for(q=0;q<b.length;b.length===r||(0,A.e6)(b),++q)s.push(A.iR(a,b[q]))
for(r=J.ac(c?$.bn.gb1():s);r.m();){p=r.gn()
o.gS().appendChild(p)}o.x=b
o.y=-1
if(o.gS().hasChildNodes()){r=o.gG()
r.style.display="block"
r.setAttribute("aria-expanded","true")}r=$.dP
r=r>10?'Press "Enter" key to see all '+r+" results":""
o.gaV().textContent=r},
bP(a,b){return this.aZ(a,b,!1)},
ag(a,b,c){var s,r,q,p=this
if(p.r===a&&!b)return
if(a.length===0){p.bP("",A.h([],t.M))
return}s=p.a.aJ(a)
r=s.length
$.dP=r
q=$.eA
if(r>q)s=B.d.b8(s,0,q)
p.r=a
p.aZ(a,s,c)},
bE(a,b){return this.ag(a,!1,b)},
aL(a){return this.ag(a,!1,!1)},
bD(a,b){return this.ag(a,b,!1)},
aG(a){var s,r=this
r.y=-1
s=r.f
if(s!=null){a.value=s
r.f=null}r.ah()},
b5(a){var s=this
a.addEventListener("focus",A.a8(new A.dl(s,a)))
a.addEventListener("blur",A.a8(new A.dm(s,a)))
a.addEventListener("input",A.a8(new A.dn(s,a)))
a.addEventListener("keydown",A.a8(new A.dp(s,a)))}}
A.dk.prototype={
$1(a){var s
if(!J.H(a.key,"/"))return
s=self.document.activeElement
if(s==null||!B.aa.O(0,s.nodeName.toLowerCase())){a.preventDefault()
this.a.focus()}},
$S:1}
A.dl.prototype={
$1(a){this.a.bD(this.b.value,!0)},
$S:1}
A.dm.prototype={
$1(a){this.a.aG(this.b)},
$S:1}
A.dn.prototype={
$1(a){this.a.aL(this.b.value)},
$S:1}
A.dp.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(!J.H(a.type,"keydown"))return
if(J.H(a.code,"Enter")){a.preventDefault()
s=e.a
r=s.y
if(r!==-1){q=s.w[r].getAttribute("data-href")
if(q!=null)self.window.location.assign($.bt()+q)
return}else{p=B.l.I(s.r)
o=A.c0($.bt()+"search.html",0,null).ao(A.eU(["q",p],t.N,t.z))
self.window.location.assign(o.gX())
return}}s=e.a
r=s.w
n=r.length-1
m=s.y
if(J.H(a.code,"ArrowUp")){l=s.y
if(l===-1)s.y=n
else s.y=l-1}else if(J.H(a.code,"ArrowDown")){l=s.y
if(l===n)s.y=-1
else s.y=l+1}else if(J.H(a.code,"Escape"))s.aG(e.b)
else{if(s.f!=null){s.f=null
s.aL(e.b.value)}return}l=m!==-1
if(l)r[m].classList.remove("tt-cursor")
k=s.y
if(k!==-1){j=r[k]
j.classList.add("tt-cursor")
r=s.y
if(r===0)s.gG().scrollTop=0
else if(r===n)s.gG().scrollTop=s.gG().scrollHeight
else{i=j.offsetTop
h=s.gG().offsetHeight
if(i<h||h<i+j.offsetHeight)j.scrollIntoView()}if(s.f==null)s.f=e.b.value
e.b.value=s.x[s.y].a}else{g=s.f
if(g!=null){r=l
f=g}else{f=null
r=!1}if(r){e.b.value=f
s.f=null}}a.preventDefault()},
$S:1}
A.dF.prototype={
$1(a){a.preventDefault()},
$S:1}
A.dG.prototype={
$1(a){var s=this.a.e
if(s!=null){self.window.location.assign($.bt()+s)
a.preventDefault()}},
$S:1}
A.dK.prototype={
$1(a){return"<strong class='tt-highlight'>"+A.i(a.k(0,0))+"</strong>"},
$S:28}
A.dM.prototype={
$1(a){var s=this.a
if(s!=null)s.classList.toggle("active")
s=this.b
if(s!=null)s.classList.toggle("active")},
$S:1}
A.dN.prototype={
$1(a){return this.b2(a)},
b2(a){var s=0,r=A.fK(t.P),q,p=this,o,n
var $async$$1=A.fR(function(b,c){if(b===1)return A.fA(c,r)
while(true)switch(s){case 0:if(!J.H(a.status,200)){o=self.document.createElement("a")
o.href="https://dart.dev/tools/dart-doc#troubleshoot"
o.text="Failed to load sidebar. Visit dart.dev for help troubleshooting."
p.a.appendChild(o)
s=1
break}s=3
return A.fz(A.e3(a.text(),t.N),$async$$1)
case 3:n=c
o=self.document.createElement("div")
o.innerHTML=n
A.fQ(p.b,o)
p.a.appendChild(o)
case 1:return A.fB(q,r)}})
return A.fC($async$$1,r)},
$S:10}
A.e_.prototype={
$0(){var s=this.a,r=this.b
if(s.checked){r.setAttribute("class","dark-theme")
s.setAttribute("value","dark-theme")
self.window.localStorage.setItem("colorTheme","true")}else{r.setAttribute("class","light-theme")
s.setAttribute("value","light-theme")
self.window.localStorage.setItem("colorTheme","false")}},
$S:0}
A.dX.prototype={
$1(a){this.a.$0()},
$S:1};(function aliases(){var s=J.a2.prototype
s.b9=s.h})();(function installTearOffs(){var s=hunkHelpers._static_2,r=hunkHelpers._static_1,q=hunkHelpers._static_0
s(J,"j5","hN",29)
r(A,"jv","i6",4)
r(A,"jw","i7",4)
r(A,"jx","i8",4)
q(A,"fT","jp",0)
r(A,"jX","hC",30)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.k,null)
q(A.k,[A.ec,J.bE,J.Z,A.o,A.bx,A.l,A.e,A.cJ,A.ao,A.ap,A.aM,A.bY,A.bc,A.aG,A.ca,A.ar,A.cM,A.cH,A.aL,A.bd,A.ae,A.P,A.cD,A.bI,A.cy,A.cb,A.cW,A.G,A.c7,A.ds,A.dq,A.c1,A.a_,A.c3,A.av,A.v,A.c2,A.cf,A.dB,A.ci,A.aU,A.bz,A.bB,A.ct,A.dz,A.dw,A.d0,A.bS,A.b2,A.d1,A.bC,A.u,A.cg,A.z,A.bk,A.cO,A.ce,A.cG,A.cu,A.w,A.cp,A.dj])
q(J.bE,[J.bF,J.aO,J.aR,J.aQ,J.aS,J.aP,J.af])
q(J.aR,[J.a2,J.p,A.bJ,A.aX])
q(J.a2,[J.bT,J.as,J.a1])
r(J.cz,J.p)
q(J.aP,[J.aN,J.bG])
q(A.o,[A.a5,A.c,A.ah])
q(A.a5,[A.ad,A.bm])
r(A.b7,A.ad)
r(A.b6,A.bm)
r(A.N,A.b6)
q(A.l,[A.aT,A.R,A.bH,A.bX,A.c4,A.bV,A.c6,A.bv,A.I,A.b4,A.bW,A.b3,A.bA])
r(A.at,A.e)
r(A.by,A.at)
q(A.c,[A.J,A.O])
r(A.aK,A.ah)
q(A.J,[A.ai,A.c9])
r(A.cc,A.bc)
r(A.cd,A.cc)
r(A.aI,A.aG)
r(A.aH,A.ar)
r(A.aJ,A.aH)
r(A.b_,A.R)
q(A.ae,[A.cn,A.co,A.cL,A.cA,A.dU,A.dW,A.cY,A.cX,A.dC,A.d6,A.dd,A.dI,A.dJ,A.e4,A.e5,A.cx,A.cw,A.dY,A.dk,A.dl,A.dm,A.dn,A.dp,A.dF,A.dG,A.dK,A.dM,A.dN,A.dX])
q(A.cL,[A.cK,A.aE])
q(A.P,[A.ag,A.c8])
q(A.co,[A.dV,A.dD,A.dQ,A.d7,A.de,A.cE,A.dv,A.cS,A.cP,A.cQ,A.cR,A.du,A.dt,A.dH,A.cv])
q(A.aX,[A.bK,A.aq])
q(A.aq,[A.b8,A.ba])
r(A.b9,A.b8)
r(A.aV,A.b9)
r(A.bb,A.ba)
r(A.aW,A.bb)
q(A.aV,[A.bL,A.bM])
q(A.aW,[A.bN,A.bO,A.bP,A.bQ,A.bR,A.aY,A.aZ])
r(A.be,A.c6)
q(A.cn,[A.cZ,A.d_,A.dr,A.d2,A.d9,A.d8,A.d5,A.d4,A.d3,A.dc,A.db,A.da,A.dO,A.di,A.dy,A.dx,A.dL,A.dZ,A.e_])
r(A.b5,A.c3)
r(A.dh,A.dB)
r(A.bj,A.aU)
r(A.au,A.bj)
q(A.bz,[A.cl,A.cq,A.cB])
q(A.bB,[A.cm,A.cs,A.cC,A.cV,A.cU])
r(A.cT,A.cq)
q(A.I,[A.b0,A.bD])
r(A.c5,A.bk)
q(A.d0,[A.m,A.A])
s(A.at,A.bY)
s(A.bm,A.e)
s(A.b8,A.e)
s(A.b9,A.aM)
s(A.ba,A.e)
s(A.bb,A.aM)
s(A.bj,A.ci)})()
var v={typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{b:"int",t:"double",jT:"num",d:"String",jy:"bool",u:"Null",f:"List",k:"Object",y:"Map"},mangledNames:{},types:["~()","u(n)","u(@)","~(@)","~(~())","u()","u(k,a3)","@()","~(d,@)","~(aj,d,b)","a0<u>(n)","@(@)","@(@,d)","@(d)","u(~())","u(@,a3)","~(b,@)","~(k?,k?)","y<d,d>(y<d,d>,d)","~(d,b)","~(d,b?)","b(b,b)","~(d,d?)","aj(@,@)","~(A)","b(+item,matchPosition(w,A),+item,matchPosition(w,A))","w(+item,matchPosition(w,A))","d()","d(cF)","b(@,@)","w(y<d,@>)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"2;item,matchPosition":(a,b)=>c=>c instanceof A.cd&&a.b(c.a)&&b.b(c.b)}}
A.iq(v.typeUniverse,JSON.parse('{"bT":"a2","as":"a2","a1":"a2","bF":{"j":[]},"aO":{"u":[],"j":[]},"aR":{"n":[]},"a2":{"n":[]},"p":{"f":["1"],"c":["1"],"n":[]},"cz":{"p":["1"],"f":["1"],"c":["1"],"n":[]},"aP":{"t":[]},"aN":{"t":[],"b":[],"j":[]},"bG":{"t":[],"j":[]},"af":{"d":[],"j":[]},"a5":{"o":["2"]},"ad":{"a5":["1","2"],"o":["2"],"o.E":"2"},"b7":{"ad":["1","2"],"a5":["1","2"],"c":["2"],"o":["2"],"o.E":"2"},"b6":{"e":["2"],"f":["2"],"a5":["1","2"],"c":["2"],"o":["2"]},"N":{"b6":["1","2"],"e":["2"],"f":["2"],"a5":["1","2"],"c":["2"],"o":["2"],"e.E":"2","o.E":"2"},"aT":{"l":[]},"by":{"e":["b"],"f":["b"],"c":["b"],"e.E":"b"},"c":{"o":["1"]},"J":{"c":["1"],"o":["1"]},"ah":{"o":["2"],"o.E":"2"},"aK":{"ah":["1","2"],"c":["2"],"o":["2"],"o.E":"2"},"ai":{"J":["2"],"c":["2"],"o":["2"],"J.E":"2","o.E":"2"},"at":{"e":["1"],"f":["1"],"c":["1"]},"aG":{"y":["1","2"]},"aI":{"y":["1","2"]},"aH":{"ar":["1"],"c":["1"]},"aJ":{"ar":["1"],"c":["1"]},"b_":{"R":[],"l":[]},"bH":{"l":[]},"bX":{"l":[]},"bd":{"a3":[]},"c4":{"l":[]},"bV":{"l":[]},"ag":{"P":["1","2"],"y":["1","2"],"P.V":"2"},"O":{"c":["1"],"o":["1"],"o.E":"1"},"cb":{"eh":[],"cF":[]},"bJ":{"n":[],"j":[]},"aX":{"n":[]},"bK":{"n":[],"j":[]},"aq":{"D":["1"],"n":[]},"aV":{"e":["t"],"f":["t"],"D":["t"],"c":["t"],"n":[]},"aW":{"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[]},"bL":{"e":["t"],"f":["t"],"D":["t"],"c":["t"],"n":[],"j":[],"e.E":"t"},"bM":{"e":["t"],"f":["t"],"D":["t"],"c":["t"],"n":[],"j":[],"e.E":"t"},"bN":{"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[],"j":[],"e.E":"b"},"bO":{"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[],"j":[],"e.E":"b"},"bP":{"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[],"j":[],"e.E":"b"},"bQ":{"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[],"j":[],"e.E":"b"},"bR":{"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[],"j":[],"e.E":"b"},"aY":{"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[],"j":[],"e.E":"b"},"aZ":{"aj":[],"e":["b"],"f":["b"],"D":["b"],"c":["b"],"n":[],"j":[],"e.E":"b"},"c6":{"l":[]},"be":{"R":[],"l":[]},"a_":{"l":[]},"b5":{"c3":["1"]},"v":{"a0":["1"]},"e":{"f":["1"],"c":["1"]},"P":{"y":["1","2"]},"aU":{"y":["1","2"]},"au":{"y":["1","2"]},"ar":{"c":["1"]},"c8":{"P":["d","@"],"y":["d","@"],"P.V":"@"},"c9":{"J":["d"],"c":["d"],"o":["d"],"J.E":"d","o.E":"d"},"f":{"c":["1"]},"eh":{"cF":[]},"bv":{"l":[]},"R":{"l":[]},"I":{"l":[]},"b0":{"l":[]},"bD":{"l":[]},"b4":{"l":[]},"bW":{"l":[]},"b3":{"l":[]},"bA":{"l":[]},"bS":{"l":[]},"b2":{"l":[]},"cg":{"a3":[]},"bk":{"c_":[]},"ce":{"c_":[]},"c5":{"c_":[]},"hF":{"f":["b"],"c":["b"]},"aj":{"f":["b"],"c":["b"]},"i2":{"f":["b"],"c":["b"]},"hD":{"f":["b"],"c":["b"]},"i0":{"f":["b"],"c":["b"]},"hE":{"f":["b"],"c":["b"]},"i1":{"f":["b"],"c":["b"]},"hA":{"f":["t"],"c":["t"]},"hB":{"f":["t"],"c":["t"]}}'))
A.ip(v.typeUniverse,JSON.parse('{"aM":1,"bY":1,"at":1,"bm":2,"aG":2,"aH":1,"bI":1,"aq":1,"cf":1,"ci":2,"aU":2,"bj":2,"bz":2,"bB":2}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type"}
var t=(function rtii(){var s=A.bq
return{U:s("c<@>"),C:s("l"),Z:s("k4"),M:s("p<w>"),O:s("p<n>"),r:s("p<+item,matchPosition(w,A)>"),s:s("p<d>"),b:s("p<@>"),t:s("p<b>"),T:s("aO"),m:s("n"),g:s("a1"),p:s("D<@>"),j:s("f<@>"),a:s("y<d,@>"),V:s("ai<+item,matchPosition(w,A),w>"),P:s("u"),K:s("k"),L:s("k5"),d:s("+()"),F:s("eh"),l:s("a3"),N:s("d"),k:s("j"),c:s("R"),D:s("aj"),o:s("as"),h:s("au<d,d>"),R:s("c_"),e:s("v<@>"),y:s("jy"),i:s("t"),z:s("@"),v:s("@(k)"),Q:s("@(k,a3)"),S:s("b"),A:s("0&*"),_:s("k*"),W:s("a0<u>?"),B:s("n?"),X:s("k?"),H:s("jT"),n:s("~")}})();(function constants(){var s=hunkHelpers.makeConstList
B.E=J.bE.prototype
B.d=J.p.prototype
B.b=J.aN.prototype
B.a=J.af.prototype
B.F=J.a1.prototype
B.G=J.aR.prototype
B.a7=A.aZ.prototype
B.t=J.bT.prototype
B.k=J.as.prototype
B.ar=new A.cm()
B.u=new A.cl()
B.as=new A.ct()
B.l=new A.cs()
B.m=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.v=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.A=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.w=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.z=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.y=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.x=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.n=function(hooks) { return hooks; }

B.B=new A.cB()
B.C=new A.bS()
B.j=new A.cJ()
B.e=new A.cT()
B.D=new A.cV()
B.c=new A.dh()
B.f=new A.cg()
B.H=new A.cC(null)
B.o=A.h(s([0,0,26624,1023,65534,2047,65534,2047]),t.t)
B.p=A.h(s([0,0,65490,12287,65535,34815,65534,18431]),t.t)
B.q=A.h(s([0,0,32776,33792,1,10240,0,0]),t.t)
B.a4=A.h(s([0,0,32722,12287,65534,34815,65534,18431]),t.t)
B.h=A.h(s([0,0,24576,1023,65534,34815,65534,18431]),t.t)
B.I=new A.m(0,"accessor")
B.J=new A.m(1,"constant")
B.U=new A.m(2,"constructor")
B.Y=new A.m(3,"class_")
B.Z=new A.m(4,"dynamic")
B.a_=new A.m(5,"enum_")
B.a0=new A.m(6,"extension")
B.a1=new A.m(7,"extensionType")
B.a2=new A.m(8,"function")
B.a3=new A.m(9,"library")
B.K=new A.m(10,"method")
B.L=new A.m(11,"mixin")
B.M=new A.m(12,"never")
B.N=new A.m(13,"package")
B.O=new A.m(14,"parameter")
B.P=new A.m(15,"prefix")
B.Q=new A.m(16,"property")
B.R=new A.m(17,"sdk")
B.S=new A.m(18,"topic")
B.T=new A.m(19,"topLevelConstant")
B.V=new A.m(20,"topLevelProperty")
B.W=new A.m(21,"typedef")
B.X=new A.m(22,"typeParameter")
B.r=A.h(s([B.I,B.J,B.U,B.Y,B.Z,B.a_,B.a0,B.a1,B.a2,B.a3,B.K,B.L,B.M,B.N,B.O,B.P,B.Q,B.R,B.S,B.T,B.V,B.W,B.X]),A.bq("p<m>"))
B.i=A.h(s([0,0,65490,45055,65535,34815,65534,18431]),t.t)
B.a5=A.h(s([0,0,32754,11263,65534,34815,65534,18431]),t.t)
B.a8={}
B.a6=new A.aI(B.a8,[],A.bq("aI<d,d>"))
B.a9={input:0,textarea:1}
B.aa=new A.aJ(B.a9,2,A.bq("aJ<d>"))
B.ab=A.L("k1")
B.ac=A.L("k2")
B.ad=A.L("hA")
B.ae=A.L("hB")
B.af=A.L("hD")
B.ag=A.L("hE")
B.ah=A.L("hF")
B.ai=A.L("k")
B.aj=A.L("i0")
B.ak=A.L("i1")
B.al=A.L("i2")
B.am=A.L("aj")
B.an=new A.cU(!1)
B.ao=new A.A(0,"isExactly")
B.ap=new A.A(1,"startsWith")
B.aq=new A.A(2,"contains")})();(function staticFields(){$.df=null
$.am=A.h([],A.bq("p<k>"))
$.eX=null
$.eP=null
$.eO=null
$.fV=null
$.fS=null
$.h_=null
$.dR=null
$.e1=null
$.eF=null
$.dg=A.h([],A.bq("p<f<k>?>"))
$.ay=null
$.bo=null
$.bp=null
$.ex=!1
$.q=B.c
$.eA=10
$.dP=0
$.bn=A.ee(t.N,t.m)})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal
s($,"k3","eJ",()=>A.jF("_$dart_dartClosure"))
s($,"k7","h2",()=>A.S(A.cN({
toString:function(){return"$receiver$"}})))
s($,"k8","h3",()=>A.S(A.cN({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"k9","h4",()=>A.S(A.cN(null)))
s($,"ka","h5",()=>A.S(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"kd","h8",()=>A.S(A.cN(void 0)))
s($,"ke","h9",()=>A.S(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"kc","h7",()=>A.S(A.f6(null)))
s($,"kb","h6",()=>A.S(function(){try{null.$method$}catch(r){return r.message}}()))
s($,"kg","hb",()=>A.S(A.f6(void 0)))
s($,"kf","ha",()=>A.S(function(){try{(void 0).$method$}catch(r){return r.message}}()))
s($,"kh","eK",()=>A.i5())
s($,"kn","hh",()=>A.hS(4096))
s($,"kl","hf",()=>new A.dy().$0())
s($,"km","hg",()=>new A.dx().$0())
s($,"ki","hc",()=>A.hR(A.iU(A.h([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-2,-2,-2,-2,-2,62,-2,62,-2,63,52,53,54,55,56,57,58,59,60,61,-2,-2,-2,-1,-2,-2,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-2,-2,-2,-2,63,-2,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-2,-2,-2,-2,-2],t.t))))
s($,"kj","hd",()=>A.f0("^[\\-\\.0-9A-Z_a-z~]*$",!0))
s($,"kk","he",()=>typeof URLSearchParams=="function")
s($,"kz","e7",()=>A.fY(B.ai))
s($,"kB","hi",()=>A.iS())
s($,"kA","bt",()=>new A.dL().$0())})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.bJ,ArrayBufferView:A.aX,DataView:A.bK,Float32Array:A.bL,Float64Array:A.bM,Int16Array:A.bN,Int32Array:A.bO,Int8Array:A.bP,Uint16Array:A.bQ,Uint32Array:A.bR,Uint8ClampedArray:A.aY,CanvasPixelArray:A.aY,Uint8Array:A.aZ})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.aq.$nativeSuperclassTag="ArrayBufferView"
A.b8.$nativeSuperclassTag="ArrayBufferView"
A.b9.$nativeSuperclassTag="ArrayBufferView"
A.aV.$nativeSuperclassTag="ArrayBufferView"
A.ba.$nativeSuperclassTag="ArrayBufferView"
A.bb.$nativeSuperclassTag="ArrayBufferView"
A.aW.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$0=function(){return this()}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.jR
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=docs.dart.js.map
