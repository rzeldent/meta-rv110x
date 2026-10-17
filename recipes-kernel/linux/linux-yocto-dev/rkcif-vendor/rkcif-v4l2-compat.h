/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Compatibility shim for the vendor camera stack.
 *
 * struct rkcif_mbus_config lost its flags field and the CSI-2 lane/virtual
 * channel flags were removed from v4l2-mediabus.h, along with the
 * get_mbus_config pad operation. The vendor code is built around that model,
 * so carry the equivalent description locally and fill it from the sensor's
 * device tree endpoint instead of asking the sensor.
 */

#ifndef _RKCIF_V4L2_COMPAT_H
#define _RKCIF_V4L2_COMPAT_H

#include <linux/types.h>
#include <linux/string.h>
#include <media/v4l2-fwnode.h>
#include <media/v4l2-mediabus.h>
#include <media/v4l2-subdev.h>

#define V4L2_MBUS_CSI2_1_LANE		BIT(0)
#define V4L2_MBUS_CSI2_2_LANE		BIT(1)
#define V4L2_MBUS_CSI2_3_LANE		BIT(2)
#define V4L2_MBUS_CSI2_4_LANE		BIT(3)
#define V4L2_MBUS_CSI2_CHANNEL_0	BIT(4)
#define V4L2_MBUS_CSI2_CHANNEL_1	BIT(5)
#define V4L2_MBUS_CSI2_CHANNEL_2	BIT(6)
#define V4L2_MBUS_CSI2_CHANNEL_3	BIT(7)
#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK	BIT(8)
#ifndef V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK
#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	BIT(9)
#endif

#define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | \
					 V4L2_MBUS_CSI2_2_LANE | \
					 V4L2_MBUS_CSI2_3_LANE | \
					 V4L2_MBUS_CSI2_4_LANE)

#define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | \
					 V4L2_MBUS_CSI2_CHANNEL_1 | \
					 V4L2_MBUS_CSI2_CHANNEL_2 | \
					 V4L2_MBUS_CSI2_CHANNEL_3)

struct rkcif_mbus_config {
	enum v4l2_mbus_type type;
	unsigned int flags;
	unsigned int num_data_lanes;
};

/*
 * Replaces the vendor's v4l2_subdev_call(..., pad, get_mbus_config, ...).
 * The pad operation still exists in this kernel, but reports the generic
 * v4l2_mbus_config, so translate it and fall back to the sub-device's own
 * endpoint when the driver does not implement it.
 */
static inline void rkcif_mbus_config_from_mipi_csi2(struct rkcif_mbus_config *mbus,
						    const struct v4l2_mbus_config *cfg)
{
	mbus->type = cfg->type;
	mbus->num_data_lanes = cfg->bus.mipi_csi2.num_data_lanes;

	switch (mbus->num_data_lanes) {
	case 1:
		mbus->flags |= V4L2_MBUS_CSI2_1_LANE;
		break;
	case 2:
		mbus->flags |= V4L2_MBUS_CSI2_2_LANE;
		break;
	case 3:
		mbus->flags |= V4L2_MBUS_CSI2_3_LANE;
		break;
	case 4:
		mbus->flags |= V4L2_MBUS_CSI2_4_LANE;
		break;
	default:
		break;
	}
}

static inline int rkcif_parse_mbus_config_endpoint(struct v4l2_subdev *sd,
						   struct rkcif_mbus_config *mbus)
{
	struct v4l2_fwnode_endpoint vep = {
		.bus_type = V4L2_MBUS_CSI2_DPHY,
	};
	struct v4l2_mbus_config cfg = { 0 };
	struct fwnode_handle *ep;
	int ret;

	/* Board DTS files may number the sink endpoint anything, take the first. */
	ep = fwnode_graph_get_endpoint_by_id(dev_fwnode(sd->dev), 0, 0,
					     FWNODE_GRAPH_ENDPOINT_NEXT);
	if (!ep)
		return -ENODEV;

	ret = v4l2_fwnode_endpoint_parse(ep, &vep);
	fwnode_handle_put(ep);
	if (ret)
		return ret;

	cfg.type = vep.bus_type;
	cfg.bus.mipi_csi2 = vep.bus.mipi_csi2;
	rkcif_mbus_config_from_mipi_csi2(mbus, &cfg);

	return 0;
}

static inline int rkcif_parse_mbus_config(struct v4l2_subdev *sd,
					  struct rkcif_mbus_config *mbus)
{
	struct v4l2_mbus_config cfg = { 0 };
	int ret;

	memset(mbus, 0, sizeof(*mbus));

	ret = v4l2_subdev_call(sd, pad, get_mbus_config, 0, &cfg);
	if (ret == -ENOIOCTLCMD)
		return rkcif_parse_mbus_config_endpoint(sd, mbus);
	if (ret)
		return ret;

	rkcif_mbus_config_from_mipi_csi2(mbus, &cfg);

	return 0;
}


/*
 * The pad get_frame_interval op is validated against the sub-device state: the
 * "which" field defaults to V4L2_SUBDEV_FORMAT_TRY (which is 0), and TRY
 * without a state is rejected with -EINVAL. Query the active state instead.
 */
static inline int rkcif_sensor_get_frame_interval(struct v4l2_subdev *sd,
						  struct v4l2_subdev_frame_interval *fi)
{
	if (!sd)
		return -ENODEV;

	fi->which = V4L2_SUBDEV_FORMAT_ACTIVE;

	return v4l2_subdev_call_state_active(sd, pad, get_frame_interval, fi);
}

#endif /* _RKCIF_V4L2_COMPAT_H */
