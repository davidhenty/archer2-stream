COMPILER=CRAY
ifndef COMPILER
define compiler_help
Set COMPILER to change flags (defaulting to GNU).
Available compilers are:
  GNU NVIDIA CRAY

endef
$(info $(compiler_help))
endif

TARGET=AMD
ifndef TARGET
define target_help
Set TARGET to change device (defaulting to CPU).
Available targets are:
  CPU NVIDIA AMD

endef
$(info $(target_help))
TARGET=AMD
endif

COMPILER_GNU = g++
COMPILER_NVIDIA = nvc++
COMPILER_CRAY = CC
CXX = $(COMPILER_$(COMPILER))

FLAGS_GNU = -O3 -std=c++11
FLAGS_NVIDIA = -O3 -std=c++11
FLAGS_CRAY = -O3 -std=c++11
CXXFLAGS = $(FLAGS_$(COMPILER))



# OpenMP flags for CPUs
OMP_GNU_CPU   = -fopenmp

# OpenMP flags for NVIDIA
OMP_NVIDIA_NVIDIA  = -DOMP_TARGET_GPU -mp=gpu
OMP_GNU_NVIDIA = -DOMP_TARGET_GPU -fopenmp=libomp -fopenmp-targets=nvptx64-nvidia-cuda

# OpenMP flags for AMD
OMP_CRAY_AMD = -fopenmp -DOMP_TARGET_GPU

ifndef OMP_$(COMPILER)_$(TARGET)
$(error Targeting $(TARGET) with $(COMPILER) not supported)
endif

OMP = $(OMP_$(COMPILER)_$(TARGET))

omp-stream: main.cpp OMPStream.cpp
	$(CXX) $(CXXFLAGS) -DOMP $^ $(OMP) $(EXTRA_FLAGS) -o $@

.PHONY: clean
clean:
	rm -f omp-stream
