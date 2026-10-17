//TEST:SIMPLE(filecheck=CHECK): -target wgsl -stage vertex -entry vertexMain

// Vertex input locations follow the varying-input layout (declaration order, or an explicit
// `[[vk::location]]`), which is what reflection reports and what WebGPU pipelines bind as
// `shaderLocation`. They must not be derived from user semantic indices, which here would put
// `lineWidth` (TEXCOORD0) and `start` (POSITION0) on the same index.

struct VertexInput
{
    // CHECK-DAG: @location(0) start{{.*}} : vec3<f32>
    float3 start : POSITION0;
    // CHECK-DAG: @location(1) lineWidth{{.*}} : f32
    float lineWidth : TEXCOORD0;
    // CHECK-DAG: @location(2) end{{.*}} : vec3<f32>
    float3 end : TEXCOORD1;
    // CHECK-DAG: @location(3) color{{.*}} : vec4<f32>
    float4 color : COLOR0;
    // CHECK-DAG: @location(5) weight{{.*}} : f32
    [[vk::location(5)]] float weight : BLENDWEIGHT0;
};

float4 vertexMain(VertexInput input) : SV_Position
{
    return float4(input.start + input.end * input.lineWidth * input.weight, 1.0) + input.color;
}
