#pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable

#define F(x, y, z)			((z) ^ ((x) & ((y) ^ (z))))
#define G(x, y, z)			((y) ^ ((z) & ((x) ^ (y))))
#define H(x, y, z)			((x) ^ (y) ^ (z))
#define I(x, y, z)			((y) ^ ((x) | ~(z)))

#define STEP(f, a, b, c, d, x, t, s) \
    (a) += f((b), (c), (d)) + (x) + (t); \
    (a) = (((a) << (s)) | (((a) & 0xffffffff) >> (32 - (s)))); \
    (a) += (b);

#define GET(i) (key[(i)])

static void md5_round(uint* internal_state, const uint* key) {
  uint a, b, c, d;
  a = internal_state[0];
  b = internal_state[1];
  c = internal_state[2];
  d = internal_state[3];

  /* Round 1 */
  STEP(F, a, b, c, d, GET(0), 0xd76aa478, 7)
  STEP(F, d, a, b, c, GET(1), 0xe8c7b756, 12)
  STEP(F, c, d, a, b, GET(2), 0x242070db, 17)
  STEP(F, b, c, d, a, GET(3), 0xc1bdceee, 22)
  STEP(F, a, b, c, d, GET(4), 0xf57c0faf, 7)
  STEP(F, d, a, b, c, GET(5), 0x4787c62a, 12)
  STEP(F, c, d, a, b, GET(6), 0xa8304613, 17)
  STEP(F, b, c, d, a, GET(7), 0xfd469501, 22)
  STEP(F, a, b, c, d, GET(8), 0x698098d8, 7)
  STEP(F, d, a, b, c, GET(9), 0x8b44f7af, 12)
  STEP(F, c, d, a, b, GET(10), 0xffff5bb1, 17)
  STEP(F, b, c, d, a, GET(11), 0x895cd7be, 22)
  STEP(F, a, b, c, d, GET(12), 0x6b901122, 7)
  STEP(F, d, a, b, c, GET(13), 0xfd987193, 12)
  STEP(F, c, d, a, b, GET(14), 0xa679438e, 17)
  STEP(F, b, c, d, a, GET(15), 0x49b40821, 22)

  /* Round 2 */
  STEP(G, a, b, c, d, GET(1), 0xf61e2562, 5)
  STEP(G, d, a, b, c, GET(6), 0xc040b340, 9)
  STEP(G, c, d, a, b, GET(11), 0x265e5a51, 14)
  STEP(G, b, c, d, a, GET(0), 0xe9b6c7aa, 20)
  STEP(G, a, b, c, d, GET(5), 0xd62f105d, 5)
  STEP(G, d, a, b, c, GET(10), 0x02441453, 9)
  STEP(G, c, d, a, b, GET(15), 0xd8a1e681, 14)
  STEP(G, b, c, d, a, GET(4), 0xe7d3fbc8, 20)
  STEP(G, a, b, c, d, GET(9), 0x21e1cde6, 5)
  STEP(G, d, a, b, c, GET(14), 0xc33707d6, 9)
  STEP(G, c, d, a, b, GET(3), 0xf4d50d87, 14)
  STEP(G, b, c, d, a, GET(8), 0x455a14ed, 20)
  STEP(G, a, b, c, d, GET(13), 0xa9e3e905, 5)
  STEP(G, d, a, b, c, GET(2), 0xfcefa3f8, 9)
  STEP(G, c, d, a, b, GET(7), 0x676f02d9, 14)
  STEP(G, b, c, d, a, GET(12), 0x8d2a4c8a, 20)

  /* Round 3 */
  STEP(H, a, b, c, d, GET(5), 0xfffa3942, 4)
  STEP(H, d, a, b, c, GET(8), 0x8771f681, 11)
  STEP(H, c, d, a, b, GET(11), 0x6d9d6122, 16)
  STEP(H, b, c, d, a, GET(14), 0xfde5380c, 23)
  STEP(H, a, b, c, d, GET(1), 0xa4beea44, 4)
  STEP(H, d, a, b, c, GET(4), 0x4bdecfa9, 11)
  STEP(H, c, d, a, b, GET(7), 0xf6bb4b60, 16)
  STEP(H, b, c, d, a, GET(10), 0xbebfbc70, 23)
  STEP(H, a, b, c, d, GET(13), 0x289b7ec6, 4)
  STEP(H, d, a, b, c, GET(0), 0xeaa127fa, 11)
  STEP(H, c, d, a, b, GET(3), 0xd4ef3085, 16)
  STEP(H, b, c, d, a, GET(6), 0x04881d05, 23)
  STEP(H, a, b, c, d, GET(9), 0xd9d4d039, 4)
  STEP(H, d, a, b, c, GET(12), 0xe6db99e5, 11)
  STEP(H, c, d, a, b, GET(15), 0x1fa27cf8, 16)
  STEP(H, b, c, d, a, GET(2), 0xc4ac5665, 23)

  /* Round 4 */
  STEP(I, a, b, c, d, GET(0), 0xf4292244, 6)
  STEP(I, d, a, b, c, GET(7), 0x432aff97, 10)
  STEP(I, c, d, a, b, GET(14), 0xab9423a7, 15)
  STEP(I, b, c, d, a, GET(5), 0xfc93a039, 21)
  STEP(I, a, b, c, d, GET(12), 0x655b59c3, 6)
  STEP(I, d, a, b, c, GET(3), 0x8f0ccc92, 10)
  STEP(I, c, d, a, b, GET(10), 0xffeff47d, 15)
  STEP(I, b, c, d, a, GET(1), 0x85845dd1, 21)
  STEP(I, a, b, c, d, GET(8), 0x6fa87e4f, 6)
  STEP(I, d, a, b, c, GET(15), 0xfe2ce6e0, 10)
  STEP(I, c, d, a, b, GET(6), 0xa3014314, 15)
  STEP(I, b, c, d, a, GET(13), 0x4e0811a1, 21)
  STEP(I, a, b, c, d, GET(4), 0xf7537e82, 6)
  STEP(I, d, a, b, c, GET(11), 0xbd3af235, 10)
  STEP(I, c, d, a, b, GET(2), 0x2ad7d2bb, 15)
  STEP(I, b, c, d, a, GET(9), 0xeb86d391, 21)

  internal_state[0] = a + internal_state[0];
  internal_state[1] = b + internal_state[1];
  internal_state[2] = c + internal_state[2];
  internal_state[3] = d + internal_state[3];
}

void md5(const char* restrict msg, uint length_bytes, uint* restrict out) {
  uint i;
  uint bytes_left;
  char key[64];

  out[0] = 0x67452301;
  out[1] = 0xefcdab89;
  out[2] = 0x98badcfe;
  out[3] = 0x10325476;

  for (bytes_left = length_bytes;  bytes_left >= 64;
       bytes_left -= 64, msg = &msg[64]) {
    md5_round(out, (const uint*) msg);
  }

  for (i = 0; i < bytes_left; i++) {
    key[i] = msg[i];
  }
  key[bytes_left++] = 0x80;

  if (bytes_left <= 56) {
    for (i = bytes_left; i < 56; key[i++] = 0);
  } else {
    /* If we have to pad enough to roll past this round. */
    for (i = bytes_left; i < 64; key[i++] = 0);
    md5_round(out, (uint*) key);
    for (i = 0; i < 56; key[i++] = 0);
  }

  ulong* len_ptr = (ulong*) &key[56];
  *len_ptr = length_bytes * 8;
  md5_round(out, (uint*) key);
}

size_t strlen(const char *restrict message) {
  size_t len = 0;
  const char *end;
  for (end = message; *end; end++) {
  }
  return end - message;
}

void strcpy(char *dest, const char *src) {
  while (*src) {
    *dest++ = *src++;
  }
  *dest = '\0';
}

void byte_to_hex(uint byte, char *out) {
  out[0] = "0123456789abcdef"[(byte >> 4) & 0xf];
  out[1] = "0123456789abcdef"[byte & 0xf];
}

void md5_to_hex(uint binary_md5[4], char *restrict hex) {
  for (uint i = 0; i < 4; i++) {
    uint b = binary_md5[i];
    for (uint j = 0; j < 4; j++) {
      byte_to_hex(b & 0xff, hex);
      b >>= 8;
      hex += 2;
    }
  }
}

char *int_to_str(char *out, uint i) {
  char *p = out;
  do {
    *p = '0' + (i % 10);
    i /= 10;
    p++;
  } while (i > 0);
  char *end = p;
  *end = '\0';
  p--;
  while (p > out) {
    char tmp = *out;
    *out = *p;
    *p = tmp;
    p--;
    out++;
  }
  return end;
}

__kernel void compute_md5(read_only __constant char const *salt, uint start_index, write_only __global char *out) {
  uint id = get_global_id(0);
  uint index = start_index + id;

  char input[128];
  char *l = input;
  while (*salt) {
    *l++ = *salt++;
  }
  l = int_to_str(l, index);
  uint length = l - input;

  printf("Kernel % 4d running with input \"%s\" (length %d)\n", index, input, length);

  uint binary_md5[4];
  md5(input, length, binary_md5);

  char hex[33];
  hex[32] = '\0';
  md5_to_hex(binary_md5, hex);
  printf("%d %s\n", index, hex);

  char const *read = hex;
  __global char *write = out + 32 * id;
  for (uint i = 0; i < 32; i++) {
    *write++ = *read++;
  }
}
