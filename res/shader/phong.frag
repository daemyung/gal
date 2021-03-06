//----------------------------------------------------------------------------------------------------------------------

precision mediump float;

//----------------------------------------------------------------------------------------------------------------------

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;

//----------------------------------------------------------------------------------------------------------------------

layout(location = 0) out vec4 fragment_color;

//----------------------------------------------------------------------------------------------------------------------

layout(binding = 0) uniform Matrix_info {
    mat4 model;
    mat4 view;
    mat4 projection;
    mat4 mv;
    mat4 mvp;
    mat4 normal;
} matrix_info;

//----------------------------------------------------------------------------------------------------------------------

layout(binding = 1) uniform Light_info {
    vec3 translation;
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
} light_info;

//----------------------------------------------------------------------------------------------------------------------

layout(binding = 2) uniform Material_info {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
} material_info;

//----------------------------------------------------------------------------------------------------------------------

void main()
{
    vec3 ambient = light_info.ambient * material_info.ambient;

    vec3 n = normalize(normal);
    vec3 s = normalize((matrix_info.view * vec4(light_info.translation, 1.0)).xyz - position);

    float n_dot_s = max(dot(n, s), 0.0);
    vec3 diffuse = n_dot_s * light_info.diffuse * material_info.diffuse;
    
    vec3 specular = vec3(0.0);

    if (n_dot_s > 0.0) {
        vec3 v = normalize(-position);
        vec3 r = reflect(-s, n);
        float v_dot_r = max(dot(v, r), 0.0);

        specular = pow(v_dot_r, material_info.shininess) * light_info.specular * material_info.specular;
    }

    fragment_color = vec4(ambient + diffuse + specular, 1.0);
}

//----------------------------------------------------------------------------------------------------------------------