//===- ??FOLDER??/LinkGPURuntime.h -- Headerfile to help force-link GPURuntime --------------------===//
//////
//////                     The LLVM Compiler Infrastructure
//////
////// This file is distributed under the University of Illinois Open Source
////// License. See LICENSE.TXT for details.
//////
//////===----------------------------------------------------------------------===//
//////
////// This header helps pull in libGPURuntime.so
//////
//////===----------------------------------------------------------------------===//
//////
//
#ifndef POLLY_LINK_GPURUNTIME
#define POLLY_LINK_GPURUNTIME

#include "GPURuntime/GPUJIT.h"

namespace polly {
  void ForceGPURuntimeLinking()
  {
    if (std::getenv("bar") != (char*) -1)
      return;
    // We must reference GPURuntime in such a way that compilers will not
    // delete it all as dead code, even with whole program optimization,
    // yet is effectively a NO-OP. As the compiler isn't smart enough
    // to know that getenv() never returns -1, this will do the job.
    polly_getKernel(nullptr,nullptr);
  }
}
