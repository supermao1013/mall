<template>
	<view class="container">
		<view class="header">
			<image src="/static/images/mall/img_detail_bg.png" mode="scaleToFill"></image>
			<view class="sign-in-info">
				<view class="left">
					<view class="d-flex align-items-baseline" @tap="flow">
						<image class="integral-icon" src="/static/images/mall/icon_pay_balance.png"></image>
						<view class="number">{{ integral||'' }}</view>
						<view class="font-size-base">积分
							<tui-icon name="arrowright" :size="30" unit="rpx" color="#fff"></tui-icon>
						</view>
					</view>
				</view>
				<view class="right" @tap="dhlog">
					兑换记录
				</view>
			</view>
		</view>
		<view style="padding: 20rpx;">
			<view class="sign-in-box">
				<view class="d-flex flex-column align-items-center just-content-center" style="margin: 20rpx 0;">
					<button class="sign-in-btn" @tap="attendance">去签到</button>
				</view>
			</view>
			<view class="banner">
				<image src="/static/images/mall/integrals.png" mode="widthFix"></image>
			</view>
			<!-- 积分商品列表 begin -->
			<view clas="d-flex flex-column" v-if="integralGoods.length>0">
				<view class="d-flex flex-wrap justify-content-between">
					<block v-for="(item, cate) in integralGoods" :key="cate">
						<view class="d-flex bg-white flex-column align-items-stretch point-box" @tap="detail(item.id)">
							<image :src="item.listPicUrl" class="w-100" mode="widthFix"></image>
							<view class="d-flex flex-column overflow-hidden">
								<view class="font-size-lg text-color-base text-truncate font-weight-bold"
									style="margin-bottom: 10rpx;">{{ item.name||'' }}</view>
								<view class="d-flex align-items-center">
									<view class="d-flex align-items-baseline">
										<view class="font-size-base text-color-primary mr-10">{{ item.retailPrice||'' }}
										</view>
										<view class="font-size-sm text-color-assist">积分</view>
									</view>
								</view>
								<view class="font-size-sm text-color-assist">剩余{{ item.goodsNumber||'' }}件</view>
							</view>
						</view>
					</block>
				</view>
			</view>
			<tui-show-empty v-else text="暂未发现商品" :top="20"></tui-show-empty>
			<!-- 积分商品列表 end -->
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				integral: 0,
				integralGoods: []
			}
		},
		onShow() {
			this.getIntegralGoods()
			this.getUserInfo()
		},
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;

			that.getIntegralGoods();
			that.getUserInfo();
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
						that.integral = res.data.integral;
					}
				});
			},
			getIntegralGoods() {
				var that = this;
				util.request('goods/integralGoodsList').then(function(res) {
					if (res.code === 0) {
						that.integralGoods = res.data.records
					}
				});
			},
			// 去签到
			attendance() {
				uni.navigateTo({
					url: '/pages/ucenter/sign/sign'
				})
			},
			dhlog() {
				uni.navigateTo({
					url: '/pages/ucenter/integrals/dhlog'
				})
			},
			// 积分明细
			flow() {
				uni.navigateTo({
					url: '/pages/ucenter/integrals/flow'
				})
			},
			detail(id) {
				uni.navigateTo({
					url: '/pages/ucenter/integrals/detail?id=' + id
				})
			}
		}
	}
</script>

<style lang="scss" lang="scss">
	.header {
		position: relative;
		width: 100%;
		height: 20vh;

		image {
			width: 100%;
			height: 100%;
		}
	}

	.sign-in-info {
		position: absolute;
		width: 100%;
		height: 13vh;
		display: flex;
		align-items: center;
		top: 0;
		left: 0;

		.left {
			color: #FFFFFF;
			margin-left: 40rpx;
			flex: 1;
			display: flex;

			.integral-icon {
				width: 64rpx;
				height: 64rpx;
				margin-right: 20rpx;
			}

			.number {
				font-size: 80rpx;
				margin-right: 10rpx;
			}
		}

		.right {
			background-color: #FFFFFF;
			color: $color-primary;
			font-size: $font-size-base;
			border-radius: 50rem 0 0 50rem;
			padding: 10rpx 30rpx;
		}
	}

	.sign-in-box {
		position: relative;
		background-color: #FFFFFF;
		margin-top: -90rpx;
		margin-bottom: 30rpx;
		width: 100%;
		border-radius: 8rpx;
		box-shadow: 0 0 20rpx rgba($color: #000000, $alpha: 0.1);
		display: flex;
		flex-direction: column;

		.sign-in-btn {
			background-color: #FF781E !important;
			color: #FFFFFF;
			width: 30%;
			border-radius: 50rem !important;
		}
	}

	.banner {
		width: 100%;
		margin: 30rpx 0;
		border-radius: 8rpx;

		image {
			width: 100%;
		}
	}

	.point-box {
		width: 44%;
		margin-bottom: 30rpx;
		border-radius: 8rpx;
		padding: 20rpx;
	}

	.d-flex {
		display: flex;
	}

	.align-items-baseline {
		-ms-flex-align: baseline !important;
		align-items: baseline !important;
	}

	.flex-column {
		-ms-flex-direction: column !important;
		flex-direction: column !important;
	}

	.font-size-base {
		font-size: 28rpx;
	}

	.align-items-center {
		align-items: center;
	}

	.just-content-center {
		justify-content: center;
	}

	.justify-content-between {
		justify-content: space-between;
	}

	.mb-30 {
		margin-bottom: 30rpx;
	}

	.w-100 {
		width: 100% !important;
	}

	.font-size-lg {
		font-size: 32rpx;
	}

	.text-color-base {
		color: #5A5B5C;
	}

	.text-color-primary {
		color: #ADB838;
	}

	.flex-wrap {
		-ms-flex-wrap: wrap !important;
		flex-wrap: wrap !important;
	}

	.bg-white {
		background-color: #ffffff;
	}

	.align-items-stretch {
		align-items: stretch;
	}

	.overflow-hidden {
		overflow: hidden !important;
	}

	.text-truncate {
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.font-weight-bold {
		font-weight: 700 !important;
	}

	.mr-10 {
		margin-right: 10rpx;
	}

	.font-size-sm {
		font-size: 24rpx;
	}

	.text-color-assist {
		color: #919293;
	}
</style>
