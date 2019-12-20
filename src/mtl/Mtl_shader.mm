//
// This file is part of the "gfx" project
// See "LICENSE" for license information.
//

#include <sc/Msl_compiler.h>
#include "mtl_lib.h"
#include "Mtl_shader.h"
#include "Mtl_device.h"

using namespace std;
using namespace Sc_lib;

namespace Gfx_lib {

//----------------------------------------------------------------------------------------------------------------------

Mtl_shader::Mtl_shader(const Shader_desc& desc, Mtl_device* device) :
    Shader(),
    device_ { device },
    type_ { desc.type }
{
    init_function_(desc);
}

//----------------------------------------------------------------------------------------------------------------------

Device* Mtl_shader::device() const
{
    return device_;
}

//----------------------------------------------------------------------------------------------------------------------

Shader_type Mtl_shader::type() const noexcept
{
    return type_;
}

//----------------------------------------------------------------------------------------------------------------------

void Mtl_shader::init_function_(const Shader_desc& desc)
{
    // compile to msl from spirv.
    auto src = Msl_compiler().compile(desc.src);

    // create a library.
    NSError* err;
    auto lib = [device_->device() newLibraryWithSource:@(&src[0])
                                               options:nullptr
                                                 error:&err];

    if (err)
        throw runtime_error("fail to create shader");

    // retrieve a function from a library.
    function_ = [lib newFunctionWithName:@("main0")];
}

//----------------------------------------------------------------------------------------------------------------------

} // of namespace Gfx_lib
