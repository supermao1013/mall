<template>
	<view class='no-course'>
		<image class='img' :style="{marginTop: top + 'rpx'}" src='../../../static/images/mall/my_course_empty.png'>
		</image>
		<text class='desc' v-if="showType == 'NO_COUPON'">您还没有优惠券~</text>
		<text class='desc' v-if="showType == 'NO_SUIT_COUPON'">没有可领取的优惠券~</text>
		<text class='desc' v-if="text">{{text}}~</text>
		<button class='btn' @tap='goCouponCenter' v-if="showType == 'NO_COUPON'">去获取</button>
	</view>
</template>

<script>
	export default {
		name: "tuiShowEmpty",
		props: {
			showType: {
				type: String,
				value: '',
				observer: '_courseChange'
			},
			text: {
				type: String,
				value: ''
			},
			top: {
				type: Number,
				value: 116,
				default: 116
			}
		},
		methods: {
			goCouponCenter: function(event) {
				uni.navigateTo({
					url: '/pages/shopping/couponCenter/couponCenter'
				})
			}
		}
	}
</script>

<style scoped>
	.no-course {
		display: flex;
		flex-direction: column;
		align-items: center;
		width: 100%;
		height: 100%;
	}

	.no-course .img {
		width: 597rpx;
		height: 467rpx;
		margin-bottom: 60rpx;
	}

	.no-course .desc {
		font-size: 30rpx;
		line-height: 40rpx;
		color: #333;
		font-weight: bold;
	}

	.no-course .btn {
		display: flex;
		background-color: #e41f19;
		font-size: 28rpx;
		border-radius: 30rpx;
		width: 200rpx;
		height: 60rpx;
		justify-content: center;
		align-items: center;
		color: #fff;
		margin-top: 20rpx;
	}
</style>
