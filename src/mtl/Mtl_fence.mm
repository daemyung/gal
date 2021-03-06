//
// This file is part of the "gfx" project
// See "LICENSE" for license information.
//

#include "std_lib.h"
#include "Mtl_fence.h"
#include "Mtl_device.h"

using namespace std;

namespace Gfx_lib {

//----------------------------------------------------------------------------------------------------------------------

Mtl_fence::Mtl_fence(const Fence_desc& desc, Mtl_device* device) :
    Fence {},
    device_ {device},
    signaled_ {desc.signaled},
    semaphore_ {nil}
{
    init_semaphore_();
}

//----------------------------------------------------------------------------------------------------------------------

void Mtl_fence::wait_signal()
{
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
}

//----------------------------------------------------------------------------------------------------------------------

void Mtl_fence::reset()
{
    signaled_ = false;
}

//----------------------------------------------------------------------------------------------------------------------

Device* Mtl_fence::device() const
{
    return device_;
}

//----------------------------------------------------------------------------------------------------------------------

bool Mtl_fence::signaled() const
{
    return signaled_;
}

//----------------------------------------------------------------------------------------------------------------------

void Mtl_fence::init_semaphore_()
{
    semaphore_ = dispatch_semaphore_create(0);

    if (!semaphore_)
        throw runtime_error("fail to create a fence");

    if (signaled_)
        dispatch_semaphore_signal(semaphore_);
}

//----------------------------------------------------------------------------------------------------------------------

} // of namespace Gfx_lib
