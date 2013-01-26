Shader "Hidden/GlowConeTap" {

Properties {
	_Color ("Color", color) = (1,1,1,0)
	_MainTex ("", 2D) = "white" {}
}

Category {
	ZTest Always Cull Off ZWrite Off Fog { Mode Off }

	Subshader {
		Pass {
			Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 20 to 20
//   d3d9 - ALU: 21 to 21
//   d3d11 - ALU: 6 to 6, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 6 to 6, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Vector 9 [_MainTex_TexelSize]
Vector 10 [_BlurOffsets]
"!!ARBvp1.0
# 20 ALU
PARAM c[11] = { { 0 },
		state.matrix.mvp,
		state.matrix.texture[0],
		program.local[9..10] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.xy, c[9];
MUL R0.zw, R0.xyxy, c[10].xyxy;
ADD R1.xy, vertex.texcoord[0], -R0.zwzw;
MOV R1.zw, c[0].x;
DP4 R2.y, R1, c[6];
DP4 R2.x, R1, c[5];
MOV R0.xy, c[10];
MUL R1.y, R0, c[9];
MUL R1.x, R0, c[9];
MOV R0.y, R1;
MOV R0.x, -R1;
MOV R1.y, -R1;
ADD result.texcoord[0].zw, R2.xyxy, R0.xyxy;
ADD result.texcoord[0].xy, R2, R0.zwzw;
ADD result.texcoord[1].zw, R2.xyxy, -R0;
ADD result.texcoord[1].xy, R2, R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Vector 8 [_MainTex_TexelSize]
Vector 9 [_BlurOffsets]
"vs_2_0
; 21 ALU
def c10, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.xy, c9
mul r1.xy, c8, r0
mov r0.zw, c10.x
add r0.xy, v1, -r1
dp4 r1.w, r0, c5
dp4 r1.z, r0, c4
mov r0.y, c8
mul r0.y, c9, r0
mov r0.w, r0.y
mov r0.x, c8
mul r0.x, c9, r0
mov r0.z, -r0.x
mov r0.y, -r0
add oT0.zw, r1, r0
add oT0.xy, r1.zwzw, r1
add oT1.zw, r1, -r1.xyxy
add oT1.xy, r1.zwzw, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 64 // 48 used size, 4 vars
Vector 16 [_MainTex_TexelSize] 4
Vector 32 [_BlurOffsets] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
ConstBuffer "UnityPerDrawTexMatrices" 768 // 576 used size, 5 vars
Matrix 512 [glstate_matrix_texture0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
BindCB "UnityPerDrawTexMatrices" 2
// 13 instructions, 2 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedbkgibiakkbnphdafkdebngcmjafkjdaiabaaaaaadaadaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhe
gjgpgoaafeeffiedepepfceeaaklklklfdeieefcdiacaaaaeaaaabaaioaaaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fjaaaaaeegiocaaaacaaaaaaccaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaamdcaabaaaaaaaaaaaegiacaia
ebaaaaaaaaaaaaaaabaaaaaaegiacaaaaaaaaaaaacaaaaaaegbabaaaabaaaaaa
diaaaaaigcaabaaaaaaaaaaafgafbaaaaaaaaaaaagibcaaaacaaaaaacbaaaaaa
dcaaaaakdcaabaaaaaaaaaaaegiacaaaacaaaaaacaaaaaaaagaabaaaaaaaaaaa
jgafbaaaaaaaaaaadiaaaaajdcaabaaaabaaaaaaegiacaaaaaaaaaaaabaaaaaa
egiacaaaaaaaaaaaacaaaaaadgaaaaagmcaabaaaabaaaaaaagaebaiaebaaaaaa
abaaaaaaaaaaaaahpccabaaaabaaaaaaegaebaaaaaaaaaaaegagbaaaabaaaaaa
aaaaaaahdccabaaaacaaaaaaegaabaaaaaaaaaaamgaabaaaabaaaaaadcaaaaam
mccabaaaacaaaaaaagiecaiaebaaaaaaaaaaaaaaabaaaaaaagiecaaaaaaaaaaa
acaaaaaaagaebaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix0 glstate_matrix_texture0
uniform mat4 glstate_matrix_texture0;

varying mediump vec4 xlv_TEXCOORD0_1;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp vec4 _MainTex_TexelSize;
uniform highp vec4 _BlurOffsets;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  highp float tmpvar_3;
  tmpvar_3 = (_MainTex_TexelSize.x * _BlurOffsets.x);
  highp float tmpvar_4;
  tmpvar_4 = (_MainTex_TexelSize.y * _BlurOffsets.y);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_3;
  tmpvar_5.y = tmpvar_4;
  highp vec2 inUV_6;
  inUV_6 = (_glesMultiTexCoord0.xy - tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.00000, 0.00000);
  tmpvar_7.x = inUV_6.x;
  tmpvar_7.y = inUV_6.y;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_TextureMatrix0 * tmpvar_7);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_3;
  tmpvar_9.y = tmpvar_4;
  highp vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_8.xy + tmpvar_9);
  tmpvar_1.xy = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11.x = -(tmpvar_3);
  tmpvar_11.y = tmpvar_4;
  highp vec2 tmpvar_12;
  tmpvar_12 = (tmpvar_8.xy + tmpvar_11);
  tmpvar_1.zw = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_3;
  tmpvar_13.y = -(tmpvar_4);
  highp vec2 tmpvar_14;
  tmpvar_14 = (tmpvar_8.xy + tmpvar_13);
  tmpvar_2.xy = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = -(tmpvar_3);
  tmpvar_15.y = -(tmpvar_4);
  highp vec2 tmpvar_16;
  tmpvar_16 = (tmpvar_8.xy + tmpvar_15);
  tmpvar_2.zw = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD0_1 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec4 xlv_TEXCOORD0_1;
varying mediump vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (((texture2D (_MainTex, xlv_TEXCOORD0.xy) + texture2D (_MainTex, xlv_TEXCOORD0.zw)) + texture2D (_MainTex, xlv_TEXCOORD0_1.xy)) + texture2D (_MainTex, xlv_TEXCOORD0_1.zw));
  c_1.w = tmpvar_2.w;
  c_1.xyz = (tmpvar_2.xyz * _Color.xyz);
  gl_FragData[0] = (c_1 * _Color.w);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix0 glstate_matrix_texture0
uniform mat4 glstate_matrix_texture0;

varying mediump vec4 xlv_TEXCOORD0_1;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp vec4 _MainTex_TexelSize;
uniform highp vec4 _BlurOffsets;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  highp float tmpvar_3;
  tmpvar_3 = (_MainTex_TexelSize.x * _BlurOffsets.x);
  highp float tmpvar_4;
  tmpvar_4 = (_MainTex_TexelSize.y * _BlurOffsets.y);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_3;
  tmpvar_5.y = tmpvar_4;
  highp vec2 inUV_6;
  inUV_6 = (_glesMultiTexCoord0.xy - tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7.zw = vec2(0.00000, 0.00000);
  tmpvar_7.x = inUV_6.x;
  tmpvar_7.y = inUV_6.y;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_TextureMatrix0 * tmpvar_7);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_3;
  tmpvar_9.y = tmpvar_4;
  highp vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_8.xy + tmpvar_9);
  tmpvar_1.xy = tmpvar_10;
  highp vec2 tmpvar_11;
  tmpvar_11.x = -(tmpvar_3);
  tmpvar_11.y = tmpvar_4;
  highp vec2 tmpvar_12;
  tmpvar_12 = (tmpvar_8.xy + tmpvar_11);
  tmpvar_1.zw = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = tmpvar_3;
  tmpvar_13.y = -(tmpvar_4);
  highp vec2 tmpvar_14;
  tmpvar_14 = (tmpvar_8.xy + tmpvar_13);
  tmpvar_2.xy = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = -(tmpvar_3);
  tmpvar_15.y = -(tmpvar_4);
  highp vec2 tmpvar_16;
  tmpvar_16 = (tmpvar_8.xy + tmpvar_15);
  tmpvar_2.zw = tmpvar_16;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD0_1 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec4 xlv_TEXCOORD0_1;
varying mediump vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (((texture2D (_MainTex, xlv_TEXCOORD0.xy) + texture2D (_MainTex, xlv_TEXCOORD0.zw)) + texture2D (_MainTex, xlv_TEXCOORD0_1.xy)) + texture2D (_MainTex, xlv_TEXCOORD0_1.zw));
  c_1.w = tmpvar_2.w;
  c_1.xyz = (tmpvar_2.xyz * _Color.xyz);
  gl_FragData[0] = (c_1 * _Color.w);
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Vector 8 [_MainTex_TexelSize]
Vector 9 [_BlurOffsets]
"agal_vs
c10 0.0 0.0 0.0 0.0
[bc]
aaaaaaaaaaaaadacajaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, c9
adaaaaaaabaaadacaiaaaaoeabaaaaaaaaaaaafeacaaaaaa mul r1.xy, c8, r0.xyyy
aaaaaaaaaaaaamacakaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.zw, c10.x
acaaaaaaaaaaadacadaaaaoeaaaaaaaaabaaaafeacaaaaaa sub r0.xy, a3, r1.xyyy
bdaaaaaaabaaaiacaaaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 r1.w, r0, c5
bdaaaaaaabaaaeacaaaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 r1.z, r0, c4
aaaaaaaaaaaaacacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c8
adaaaaaaaaaaacacajaaaaoeabaaaaaaaaaaaaffacaaaaaa mul r0.y, c9, r0.y
aaaaaaaaaaaaaiacaaaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.w, r0.y
aaaaaaaaaaaaabacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c8
adaaaaaaaaaaabacajaaaaoeabaaaaaaaaaaaaaaacaaaaaa mul r0.x, c9, r0.x
bfaaaaaaaaaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.z, r0.x
bfaaaaaaaaaaacacaaaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r0.y
abaaaaaaaaaaamaeabaaaaopacaaaaaaaaaaaaopacaaaaaa add v0.zw, r1.wwzw, r0.wwzw
abaaaaaaaaaaadaeabaaaapoacaaaaaaabaaaafeacaaaaaa add v0.xy, r1.zwww, r1.xyyy
acaaaaaaabaaamaeabaaaaopacaaaaaaabaaaaefacaaaaaa sub v1.zw, r1.wwzw, r1.yyxy
abaaaaaaabaaadaeabaaaapoacaaaaaaaaaaaafeacaaaaaa add v1.xy, r1.zwww, r0.xyyy
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 64 // 48 used size, 4 vars
Vector 16 [_MainTex_TexelSize] 4
Vector 32 [_BlurOffsets] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
ConstBuffer "UnityPerDrawTexMatrices" 768 // 576 used size, 5 vars
Matrix 512 [glstate_matrix_texture0] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
BindCB "UnityPerDrawTexMatrices" 2
// 13 instructions, 2 temp regs, 0 temp arrays:
// ALU 6 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecednggioeldniknbcadgdcbahkbbcmamiagabaaaaaakiaeaaaaaeaaaaaa
daaaaaaakeabaaaaoeadaaaadiaeaaaaebgpgodjgmabaaaagmabaaaaaaacpopp
caabaaaaemaaaaaaadaaceaaaaaaeiaaaaaaeiaaaaaaceaaabaaeiaaaaaaabaa
acaaabaaaaaaaaaaabaaaaaaaeaaadaaaaaaaaaaacaacaaaacaaahaaaaaaaaaa
aaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
abaaaaacaaaaadiaabaaoekaaeaaaaaeaaaaamiaaaaaeeiaacaaeekbabaaeeja
afaaaaadabaaadiaaaaappiaaiaaoekaaeaaaaaeaaaaamiaahaaeekaaaaakkia
abaaeeiaafaaaaadabaaadiaaaaaoeiaacaaoekaabaaaaacabaaamiaabaaeeib
acaaaaadaaaaapoaaaaaooiaabaageiaacaaaaadabaaadoaaaaaooiaabaaomia
aeaaaaaeabaaamoaaaaaeeiaacaaeekbaaaaoeiaafaaaaadaaaaapiaaaaaffja
aeaaoekaaeaaaaaeaaaaapiaadaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
afaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaappjaaaaaoeia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
ppppaaaafdeieefcdiacaaaaeaaaabaaioaaaaaafjaaaaaeegiocaaaaaaaaaaa
adaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaafjaaaaaeegiocaaaacaaaaaa
ccaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaa
acaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaamdcaabaaaaaaaaaaaegiacaiaebaaaaaaaaaaaaaaabaaaaaa
egiacaaaaaaaaaaaacaaaaaaegbabaaaabaaaaaadiaaaaaigcaabaaaaaaaaaaa
fgafbaaaaaaaaaaaagibcaaaacaaaaaacbaaaaaadcaaaaakdcaabaaaaaaaaaaa
egiacaaaacaaaaaacaaaaaaaagaabaaaaaaaaaaajgafbaaaaaaaaaaadiaaaaaj
dcaabaaaabaaaaaaegiacaaaaaaaaaaaabaaaaaaegiacaaaaaaaaaaaacaaaaaa
dgaaaaagmcaabaaaabaaaaaaagaebaiaebaaaaaaabaaaaaaaaaaaaahpccabaaa
abaaaaaaegaebaaaaaaaaaaaegagbaaaabaaaaaaaaaaaaahdccabaaaacaaaaaa
egaabaaaaaaaaaaamgaabaaaabaaaaaadcaaaaammccabaaaacaaaaaaagiecaia
ebaaaaaaaaaaaaaaabaaaaaaagiecaaaaaaaaaaaacaaaaaaagaebaaaaaaaaaaa
doaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheogiaaaaaa
adaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaafmaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfagphdgjhegjgpgoaafeeffied
epepfceeaaklklkl"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 9 to 9, TEX: 4 to 4
//   d3d9 - ALU: 11 to 11, TEX: 4 to 4
//   d3d11 - ALU: 5 to 5, TEX: 4 to 4, FLOW: 1 to 1
//   d3d11_9x - ALU: 5 to 5, TEX: 4 to 4, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 9 ALU, 4 TEX
PARAM c[1] = { program.local[0] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3, fragment.texcoord[1].zwzw, texture[0], 2D;
TEX R2, fragment.texcoord[1], texture[0], 2D;
TEX R1, fragment.texcoord[0].zwzw, texture[0], 2D;
TEX R0, fragment.texcoord[0], texture[0], 2D;
ADD R0, R0, R1;
ADD R0, R0, R2;
ADD R0, R0, R3;
MUL R0.xyz, R0, c[0];
MUL result.color, R0, c[0].w;
END
# 9 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 11 ALU, 4 TEX
dcl_2d s0
dcl t0
dcl t1
texld r3, t0, s0
mov r1.y, t0.w
mov r1.x, t0.z
mov r2.xy, r1
mov r0.y, t1.w
mov r0.x, t1.z
texld r0, r0, s0
texld r1, t1, s0
texld r2, r2, s0
add_pp r2, r3, r2
add_pp r1, r2, r1
add_pp r0, r1, r0
mul_pp r0.xyz, r0, c0
mul_pp r0, r0, c0.w
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 64 // 64 used size, 4 vars
Vector 48 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
// 10 instructions, 2 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhjnkpodggbfpigaepahjmpghdlaonddaabaaaaaagaacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaafdfgfpfagphdgjhegjgpgoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefciiabaaaaeaaaaaaagcaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaa
aaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadiaaaaai
hcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaai
pccabaaaaaaaaaaaegaobaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"agal_ps
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r3, v0, s0 <2d wrap linear point>
aaaaaaaaabaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r1.y, v0.w
aaaaaaaaabaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r1.x, v0.z
aaaaaaaaacaaadacabaaaafeacaaaaaaaaaaaaaaaaaaaaaa mov r2.xy, r1.xyyy
aaaaaaaaaaaaacacabaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r0.y, v1.w
aaaaaaaaaaaaabacabaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r0.x, v1.z
ciaaaaaaaaaaapacaaaaaafeacaaaaaaaaaaaaaaafaababb tex r0, r0.xyyy, s0 <2d wrap linear point>
ciaaaaaaabaaapacabaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v1, s0 <2d wrap linear point>
ciaaaaaaacaaapacacaaaafeacaaaaaaaaaaaaaaafaababb tex r2, r2.xyyy, s0 <2d wrap linear point>
abaaaaaaacaaapacadaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r3, r2
abaaaaaaabaaapacacaaaaoeacaaaaaaabaaaaoeacaaaaaa add r1, r2, r1
abaaaaaaaaaaapacabaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r1, r0
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c0
adaaaaaaaaaaapacaaaaaaoeacaaaaaaaaaaaappabaaaaaa mul r0, r0, c0.w
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 64 // 64 used size, 4 vars
Vector 48 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
// 10 instructions, 2 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedecgnjkpbcaaljmnblpbdpdcinnocehcfabaaaaaaiaadaaaaaeaaaaaa
daaaaaaaemabaaaanmacaaaaemadaaaaebgpgodjbeabaaaabeabaaaaaaacpppp
oaaaaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaadaaabaaaaaaaaaaaaaaabacppppbpaaaaacaaaaaaiaaaaacplabpaaaaac
aaaaaaiaabaacplabpaaaaacaaaaaajaaaaiapkaabaaaaacaaaacdiaaaaaoola
ecaaaaadabaacpiaaaaaoelaaaaioekaecaaaaadaaaaapiaaaaaoeiaaaaioeka
acaaaaadaaaacpiaaaaaoeiaabaaoeiaabaaaaacabaacdiaabaaoolaecaaaaad
acaaapiaabaaoelaaaaioekaecaaaaadabaaapiaabaaoeiaaaaioekaacaaaaad
aaaacpiaaaaaoeiaacaaoeiaacaaaaadaaaacpiaabaaoeiaaaaaoeiaafaaaaad
aaaachiaaaaaoeiaaaaaoekaafaaaaadaaaacpiaaaaaoeiaaaaappkaabaaaaac
aaaicpiaaaaaoeiappppaaaafdeieefciiabaaaaeaaaaaaagcaaaaaafjaaaaae
egiocaaaaaaaaaaaaeaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaacaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaadiaaaaaipccabaaa
aaaaaaaaegaobaaaaaaaaaaapgipcaaaaaaaaaaaadaaaaaadoaaaaabejfdeheo
giaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaafmaaaaaa
abaaaaaaaaaaaaaaadaaaaaaacaaaaaaapapaaaafdfgfpfagphdgjhegjgpgoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

}

#LINE 57

		}
	}

	Subshader {
		Pass {
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant alpha}
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant + previous}
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant + previous}
			SetTexture [_MainTex] {constantColor [_Color] combine texture * constant + previous}		
		}

	}
}

Fallback off

}
