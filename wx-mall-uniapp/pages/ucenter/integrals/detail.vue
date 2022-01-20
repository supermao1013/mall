<template>
	<view class="container position-relative">
		<view style="padding-bottom: 150rpx;">
			<view class="d-flex flex-column">
				<view class="bg-white mb-30">
					<image :src="goods.listPicUrl" class="w-100" mode="widthFix"></image>
					<view class="d-flex flex-column" style="padding: 30rpx;">
						<view class="d-flex align-items-center mb-10">
							<view class="d-flex align-items-baseline">
								<view class="font-size-extra-lg text-color-primary mr-10 font-weight-bold">
									{{ goods.retailPrice||'' }}
								</view>
								<view class="font-size-base text-color-base">积分</view>
							</view>
						</view>
						<view class="d-flex justify-content-between align-items-center">
							<view class="font-size-extra-lg text-color-base font-weight-bold">
								{{ goods.name||'' }}
							</view>
							<view class="font-size-sm text-color-base">
								剩余<text class="text-color-primary">{{ goods.goodsNumber||'' }}</text>件
							</view>
						</view>
					</view>
				</view>
				<view class="bg-white mb-20" style="padding: 30rpx;">
					<view class="d-flex align-items-center font-size-lg font-weight-bold line-height-2">商品详情</view>
					<view class="font-size-base text-color-assist">
						<uParse :content="goods.goodsDesc" noData=" " />
					</view>
				</view>
			</view>

			<view class="btn-box">
				<button type="primary" :disabled="totalPoints < goods.retailPrice" @tap="buy">
					{{ totalPoints < goods.retailPrice ? '积分不足' : '立即兑换' }}
				</button>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	import uParse from '@/components/uni/uParse/src/wxParse'
	export default {
		components: {
			uParse
		},
		data() {
			return {
				totalPoints: 0,
				goods: {},
				goodsId: ''
			}
		},
		onLoad(options) {
			this.goodsId = options.id
			this.getGoodsInfo()
			this.getUserInfo()
		},
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;

			that.getGoodsInfo()
			that.getUserInfo()
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			getUserInfo() {
				var that = this;
				util.request('user/userInfo').then(function(res) {
					if (res.code === 0) {
						that.totalPoints = res.data.integral;
					}
				});
			},
			getGoodsInfo() {
				let that = this;
				util.request('goods/integralGoodsDetail', {
					goodsId: that.goodsId
				}).then(function(res) {
					if (res.code === 0) {
						that.goods = res.data;
					}
				});
			},
			buy() {
				let that = this
				uni.navigateTo({
					url: '/pages/ucenter/integrals/checkout?goodsId=' + that.goodsId
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.btn-box {
		position: fixed;
		bottom: 0;
		left: 0;
		right: 0;
		padding: 30rpx;
		z-index: 10;
		background-color: #FFFFFF;
		box-shadow: 0 0 20rpx rgba($color: #000000, $alpha: 0.1);

		button {
			border-radius: 50rem !important;
			height: 100%;
			display: flex;
			align-items: center;
			justify-content: center;
		}
	}

	.coupon-box {
		width: 100%;
		padding: 30rpx 50rpx;

		.coupon {
			background-color: #FFFFFF;
			padding: 40rpx;
			border-radius: 10rpx;
			display: flex;
			align-items: center;
			position: relative;

			image {
				width: 180rpx;
				height: 120rpx;
				margin-right: 30rpx;
			}

			.intro {
				flex: 1;
				display: flex;
				flex-direction: column;

				.goods-name {
					font-size: 32rpx;
					color: #5A5B5C;
					margin-bottom: 10rpx;
				}

				.expire {
					font-size: 22rpx;
					color: #919293;
				}
			}

			@mixin arch {
				content: " ";
				position: absolute;
				background-color: $bg-color;
				width: 40rpx;
				height: 40rpx;
				z-index: 10;
				border-radius: 100%;
			}

			&::before {
				@include arch;
				left: -20rpx;
			}

			&::after {
				@include arch;
				right: -20rpx;
			}
		}
	}

	.points-and-stocks {
		padding: 0 50rpx;
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 30rpx;

		.points {
			display: flex;
			align-items: baseline;
		}
	}


	.container {
		width: 100%;
		height: 100%;
	}

	.position-relative {
		position: relative !important;
	}

	.d-flex {
		display: flex;
	}

	.flex-column {
		-ms-flex-direction: column !important;
		flex-direction: column !important;
	}

	.bg-white {
		background-color: #ffffff;
	}

	.mb-30 {
		margin-bottom: 30rpx;
	}

	.w-100 {
		width: 100% !important;
	}

	.align-items-center {
		align-items: center;
	}

	.mb-10 {
		margin-bottom: 10rpx;
	}

	.align-items-baseline {
		-ms-flex-align: baseline !important;
		align-items: baseline !important;
	}

	.font-size-extra-lg {
		font-size: 40rpx;
	}

	.text-color-primary {
		color: #ADB838;
	}

	.mr-10 {
		margin-right: 10rpx;
	}

	.font-weight-bold {
		font-weight: 700 !important;
	}

	.font-size-base {
		font-size: 28rpx;
	}

	.text-color-base {
		color: #5A5B5C;
	}

	.font-size-sm {
		font-size: 24rpx;
	}

	.justify-content-between {
		justify-content: space-between;
	}

	.font-size-lg {
		font-size: 32rpx;
	}

	.line-height-2 {
		line-height: 2rem !important;
	}

	.text-color-assist {
		color: #919293;
	}
</style>
