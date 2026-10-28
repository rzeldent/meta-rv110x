#include <ctype.h>
#include <stdint.h>
#include <stdio.h>

/* Legacy glibc symbols referenced by the prebuilt SDK libs but gone from newer glibc */
int __fgetc_unlocked(FILE *f) { return fgetc_unlocked(f); }
int __fputc_unlocked(int c, FILE *f) { return fputc_unlocked(c, f); }

const unsigned short *__ctype_b;
const int32_t *__ctype_tolower;
const int32_t *__ctype_toupper;

__attribute__((constructor)) static void compat_ctype_init(void)
{
	__ctype_b = *__ctype_b_loc();
	__ctype_tolower = *__ctype_tolower_loc();
	__ctype_toupper = *__ctype_toupper_loc();
}

/*
 * The closed rockit library calls Luckfox's mpp extensions, which public mpp lacks.
 * Map them onto the public API; the RV1106-specific attributes are ignored.
 */
#include <rockchip/rk_mpi.h>

typedef struct {
	MppCtxType type;
	MppCodingType coding;
	RK_S32 chan_id;
	RK_S32 online;
	RK_U32 buf_size;
	RK_U32 max_strm_cnt;
	RK_U32 shared_buf_en;
	RK_U32 smart_en;
	RK_U32 max_width;
	RK_U32 max_height;
	RK_U32 max_lt_cnt;
	RK_U32 qpmap_en;
	RK_U32 chan_dup;
	RK_U32 res;
	RK_U32 only_smartp;
} compat_vcodec_attr;

MPP_RET mpp_create_ext(MppCtx *ctx, MppApi **mpi, RK_U32 flag)
{
	(void)flag;
	return mpp_create(ctx, mpi);
}

MPP_RET mpp_init_ext(MppCtx ctx, compat_vcodec_attr *attr)
{
	return mpp_init(ctx, attr->type, attr->coding);
}

MPP_RET mpp_get_fd(MppCtx ctx, RK_S32 *fd)
{
	(void)ctx;
	*fd = -1;
	return MPP_NOK;
}

MPP_RET mpp_close_fd(MppCtx ctx, RK_S32 fd)
{
	(void)ctx;
	(void)fd;
	return MPP_OK;
}

/* GNU libiconv entry points used by the prebuilt libs are provided by glibc's iconv */
#include <iconv.h>

iconv_t libiconv_open(const char *to, const char *from) { return iconv_open(to, from); }
size_t libiconv(iconv_t cd, char **in, size_t *inl, char **out, size_t *outl)
{
	return iconv(cd, in, inl, out, outl);
}
int libiconv_close(iconv_t cd) { return iconv_close(cd); }
