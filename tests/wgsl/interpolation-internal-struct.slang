//TEST:SIMPLE(filecheck=CHECK):-target wgsl -stage fragment -entry main

struct FragmentInput
{
    float4 position : SV_Position;
    nointerpolation uint2 materialRef : TEXCOORD3;
    float2 uv : TEXCOORD2;
};

float4 shade(FragmentInput input)
{
    if (input.materialRef.x == 0u)
        return float4(input.uv, input.position.xy);
    return float4(float2(input.materialRef), input.uv);
}

float4 main(FragmentInput input) : SV_Target0
{
    return shade(input);
}

// The internal value type has no stage locations and cannot carry WGSL interpolation attributes.
//CHECK-LABEL: struct FragmentInput
//CHECK-NOT: @interpolate
//CHECK: materialRef
//CHECK-NOT: @interpolate
//CHECK: };
// The legal entry-point interface retains the flat interpolation at its literal location.
//CHECK: @interpolate(flat) @location(3)
