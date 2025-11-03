CXXFLAGS= -D__HIP_PLATFORM_AMD__ --offload-arch=gfx90a -x hip -DC_SERIAL_PRACTICAL -g -fgpu-rdc
CUDA_CXX=hipcc
EXTRA_FLAGS= --hip-link

hip-stream: main.cpp HIPStream.cpp
	$(CUDA_CXX) -std=c++11 $(CXXFLAGS) -DHIP $^ $(EXTRA_FLAGS) -o $@

.PHONY: clean
clean:
	rm -f hip-stream

