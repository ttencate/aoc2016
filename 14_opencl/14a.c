#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#include <CL/cl.h>

char const *get_cl_error_string(cl_int err) {
  switch (err) {
    case 0: return "CL_SUCCESS";
    case -1: return "CL_DEVICE_NOT_FOUND";
    case -2: return "CL_DEVICE_NOT_AVAILABLE";
    case -3: return "CL_COMPILER_NOT_AVAILABLE";
    case -4: return "CL_MEM_OBJECT_ALLOCATION_FAILURE";
    case -5: return "CL_OUT_OF_RESOURCES";
    case -6: return "CL_OUT_OF_HOST_MEMORY";
    case -7: return "CL_PROFILING_INFO_NOT_AVAILABLE";
    case -8: return "CL_MEM_COPY_OVERLAP";
    case -9: return "CL_IMAGE_FORMAT_MISMATCH";
    case -10: return "CL_IMAGE_FORMAT_NOT_SUPPORTED";
    case -11: return "CL_BUILD_PROGRAM_FAILURE";
    case -12: return "CL_MAP_FAILURE";
    case -13: return "CL_MISALIGNED_SUB_BUFFER_OFFSET";
    case -14: return "CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST";
    case -15: return "CL_COMPILE_PROGRAM_FAILURE";
    case -16: return "CL_LINKER_NOT_AVAILABLE";
    case -17: return "CL_LINK_PROGRAM_FAILURE";
    case -18: return "CL_DEVICE_PARTITION_FAILED";
    case -19: return "CL_KERNEL_ARG_INFO_NOT_AVAILABLE";
    case -30: return "CL_INVALID_VALUE";
    case -31: return "CL_INVALID_DEVICE_TYPE";
    case -32: return "CL_INVALID_PLATFORM";
    case -33: return "CL_INVALID_DEVICE";
    case -34: return "CL_INVALID_CONTEXT";
    case -35: return "CL_INVALID_QUEUE_PROPERTIES";
    case -36: return "CL_INVALID_COMMAND_QUEUE";
    case -37: return "CL_INVALID_HOST_PTR";
    case -38: return "CL_INVALID_MEM_OBJECT";
    case -39: return "CL_INVALID_IMAGE_FORMAT_DESCRIPTOR";
    case -40: return "CL_INVALID_IMAGE_SIZE";
    case -41: return "CL_INVALID_SAMPLER";
    case -42: return "CL_INVALID_BINARY";
    case -43: return "CL_INVALID_BUILD_OPTIONS";
    case -44: return "CL_INVALID_PROGRAM";
    case -45: return "CL_INVALID_PROGRAM_EXECUTABLE";
    case -46: return "CL_INVALID_KERNEL_NAME";
    case -47: return "CL_INVALID_KERNEL_DEFINITION";
    case -48: return "CL_INVALID_KERNEL";
    case -49: return "CL_INVALID_ARG_INDEX";
    case -50: return "CL_INVALID_ARG_VALUE";
    case -51: return "CL_INVALID_ARG_SIZE";
    case -52: return "CL_INVALID_KERNEL_ARGS";
    case -53: return "CL_INVALID_WORK_DIMENSION";
    case -54: return "CL_INVALID_WORK_GROUP_SIZE";
    case -55: return "CL_INVALID_WORK_ITEM_SIZE";
    case -56: return "CL_INVALID_GLOBAL_OFFSET";
    case -57: return "CL_INVALID_EVENT_WAIT_LIST";
    case -58: return "CL_INVALID_EVENT";
    case -59: return "CL_INVALID_OPERATION";
    case -60: return "CL_INVALID_GL_OBJECT";
    case -61: return "CL_INVALID_BUFFER_SIZE";
    case -62: return "CL_INVALID_MIP_LEVEL";
    case -63: return "CL_INVALID_GLOBAL_WORK_SIZE";
    case -64: return "CL_INVALID_PROPERTY";
    case -65: return "CL_INVALID_IMAGE_DESCRIPTOR";
    case -66: return "CL_INVALID_COMPILER_OPTIONS";
    case -67: return "CL_INVALID_LINKER_OPTIONS";
    case -68: return "CL_INVALID_DEVICE_PARTITION_COUNT";
    case -1000: return "CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR";
    case -1001: return "CL_PLATFORM_NOT_FOUND_KHR";
    case -1002: return "CL_INVALID_D3D10_DEVICE_KHR";
    case -1003: return "CL_INVALID_D3D10_RESOURCE_KHR";
    case -1004: return "CL_D3D10_RESOURCE_ALREADY_ACQUIRED_KHR";
    case -1005: return "CL_D3D10_RESOURCE_NOT_ACQUIRED_KHR";
    default: return "Unknown OpenCL error";
  }
}

void exit_with_cl_error(cl_int err) {
  fprintf(stderr, "OpenCL error: %s\n", get_cl_error_string(err));
  fflush(stderr);
  exit(1);
}

void check_cl_error(cl_int err) {
  if (err != CL_SUCCESS) {
    exit_with_cl_error(err);
  }
}

cl_device_id get_opencl_device() {
  cl_platform_id platform;
  check_cl_error(clGetPlatformIDs(1, &platform, NULL));
  cl_device_id device;
  check_cl_error(clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL));
  return device;
}

char *load_program(char const *filename) {
  FILE *f = fopen(filename, "r");
  if (!f) {
    perror("failed to open program file");
    exit(1);
  }

  fseek(f, 0, SEEK_END);
  int size = ftell(f);
  rewind(f);

  char *const buffer = (char *) malloc(size + 1);
  char *const end = buffer + size;

  int bytes_read;
  char *write = buffer;
  do {
    bytes_read = fread(write, 1, end - write, f);
    write += bytes_read;
  } while (write < end && bytes_read > 0);
  fclose(f);

  *write = '\0';
  return buffer;
}

char const *get_cl_build_status_string(cl_program program, cl_device_id device) {
  cl_build_status status;
  cl_int err = clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_STATUS, sizeof(status), &status, NULL);
  check_cl_error(err);

  switch (status) {
    case CL_BUILD_NONE: return "CL_BUILD_NONE";
    case CL_BUILD_ERROR: return "CL_BUILD_ERROR";
    case CL_BUILD_SUCCESS: return "CL_BUILD_SUCCESS";
    case CL_BUILD_IN_PROGRESS: return "CL_BUILD_IN_PROGRESS";
    default: return "Unknow build status";
  }
}

void print_cl_build_log(cl_program program, cl_device_id device) {
  size_t log_size;
  cl_int err = clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size);
  check_cl_error(err);

  if (log_size > 0) {
    char *log = (char *) malloc(log_size + 1);
    err = clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG, log_size + 1, log, NULL);
    check_cl_error(err);
    fprintf(stderr, "Build log:\n%sEnd of build log\n", log);
    free(log);
  }
}

char find_triplet(char const *hash) {
  char c = '\0';
  int count = 0;
  for (int i = 0; i < 32; i++) {
    if (hash[i] != c) {
      c = hash[i];
      count = 1;
    } else {
      count++;
      if (count == 3) {
        return c;
      }
    }
  }
  return '\0';
}

bool contains_quintuplet(char const *hash, char const c) {
  int count = 0;
  for (int i = 0; i < 32; i++) {
    if (hash[i] == c) {
      count++;
      if (count == 5) {
        return true;
      }
    } else {
      count = 0;
    }
  }
  return false;
}

int main() {
  // This must be big enough so the answer is contained within one batch. Hack hack.
  const size_t batch_size = 30000;

  char *salt;
  scanf("%ms", &salt);
  size_t salt_size = strlen(salt);

  char *program_text = load_program("md5.cl");

  cl_device_id device = get_opencl_device();

  cl_int err;
  cl_context context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
  check_cl_error(err);

  cl_program program = clCreateProgramWithSource(context, 1, (char const **) &program_text, NULL, &err);
  check_cl_error(err);

  err = clBuildProgram(program, 1, &device, NULL, NULL, NULL);
  if (err != CL_SUCCESS) {
    fprintf(stderr, "Build status: %s\n", get_cl_build_status_string(program, device));
    print_cl_build_log(program, device);
  }
  check_cl_error(err);

  cl_kernel kernel = clCreateKernel(program, "compute_md5", &err);
  check_cl_error(err);

  cl_mem salt_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, salt_size + 1, salt, &err);
  check_cl_error(err);

  cl_mem hex_buffer = clCreateBuffer(context, CL_MEM_WRITE_ONLY, 32 * batch_size, NULL, &err);
  check_cl_error(err);

  err = clSetKernelArg(kernel, 0, sizeof(salt_buffer), &salt_buffer);
  check_cl_error(err);
  err = clSetKernelArg(kernel, 2, sizeof(hex_buffer), &hex_buffer);
  check_cl_error(err);

  cl_command_queue command_queue = clCreateCommandQueue(context, device, 0, &err);
  check_cl_error(err);

  size_t global_work_offset = 0;
  size_t global_work_size = batch_size;
  size_t local_work_size = 1;

  char *hex = (char *) malloc(32 * batch_size);

  uint32_t start_index = 0; 
  err = clSetKernelArg(kernel, 1, sizeof(uint32_t), &start_index);
  check_cl_error(err);

  err = clEnqueueNDRangeKernel(command_queue, kernel, 1, &global_work_offset, &global_work_size, &local_work_size, 0, NULL, NULL);
  check_cl_error(err);

  err = clEnqueueReadBuffer(command_queue, hex_buffer, CL_TRUE, 0, 32 * batch_size, hex, 0, NULL, NULL);
  check_cl_error(err);

  int keys_found = 0;
  for (int i = 0; i < batch_size - 1000; i++) {
    char triplet = find_triplet(hex + 32 * i);
    if (triplet) {
      for (int k = i + 1; k <= i + 1000; k++) {
        char const *hash = hex + 32 * k;
        if (contains_quintuplet(hash, triplet)) {
          keys_found++;
          break;
        }
      }
    }
    if (keys_found == 64) {
      printf("%d\n", i);
      break;
    }
  }

  clReleaseContext(context);

  free(program_text);
  return 0;
}
