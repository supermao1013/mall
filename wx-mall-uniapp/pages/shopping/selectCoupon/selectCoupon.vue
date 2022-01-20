<template>
	<view class="container">
		<tui-show-empty v-if="couponList.length<=0" text="没有可用的优惠券~"></tui-show-empty>
		<view v-else>
			<view class="tui-coupon-item tui-top20" v-for="(item, index) in couponList" :key="index">
				<image src="/static/images/mall/bg_coupon_3x.png" class="tui-coupon-bg" mode="widthFix"></image>
				<image src="/static/images/mall/img_coupon_beused_3x.png" class="tui-coupon-sign" mode="widthFix" v-if="item.status===1"></image>
				<image src="/static/images/mall/img_coupon_failure_3x.png" class="tui-coupon-sign" mode="widthFix" v-if="item.status===2"></image>
				<view class="tui-coupon-item-left">
					<view :class="'tui-coupon-price-box ' + (item.status!=0?'tui-color-grey':'')">
						<view class="tui-coupon-price-sign" v-if="item.couponType==1">￥</view>
						<view class="tui-coupon-price tui-price-small" v-if="item.couponType==1">{{item.subPrice}}</view>
						<view class="tui-coupon-price tui-price-small" v-if="item.couponType==2">{{item.discount}}</view>
						<view class="tui-coupon-price-sign" v-if="item.couponType==2">折</view>
					</view>
					<view class="tui-coupon-intro">满{{item.minPrice}}元可用</view>
				</view>
				<view class="tui-coupon-item-right">
					<view class="tui-coupon-content">
						<view class="tui-coupon-title-box" v-if="item.limitType===0">
							<view :class="'tui-coupon-btn ' + (item.status!=0?'tui-bg-grey':'')">全场券</view>
							<view class="tui-coupon-title">全部商品可用</view>
						</view>
						<view class="tui-coupon-title-box" v-if="item.limitType===1">
							<view :class="'tui-coupon-btn ' + (item.status!=0?'tui-bg-grey':'')">指定商品</view>
							<view class="tui-coupon-title">指定商品可用</view>
						</view>
						<view class="tui-coupon-title-box" v-if="item.limitType===2">
							<view :class="'tui-coupon-btn ' + (item.status!=0?'tui-bg-grey':'')">指定品牌</view>
							<view class="tui-coupon-title">指定品牌可用</view>
						</view>
						<view class="tui-coupon-rule">
							<view class="tui-rule-box tui-padding-btm">
								<view class="tui-coupon-circle"></view>
								<view class="tui-coupon-text">不可叠加使用</view>
							</view>
							<view class="tui-rule-box">
								<view class="tui-coupon-circle"></view>
								<view class="tui-coupon-text">{{item.beginTime}} 至 {{item.endTime}}</view>
							</view>
						</view>
					</view>
				</view>
				<view class="tui-btn-box" v-if="item.status==0">
					<tui-button type="danger" @click="selectCoupon(item.couponId)" width="146rpx" height="52rpx" :size="24" shape="circle"
					 :plain="false">立即使用</tui-button>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				couponList: [],
				checkedGoodsIdList: '',
				checkedBrandIdList: ''
			}
		},
		methods: {
			loadListData: function() {
				let that = this;
				util.request('coupon/selectCoupon', {
					status: 0,
					goodsIdList: that.checkedGoodsIdList,
					brandIdList: that.checkedBrandIdList
				}).then(function(res) {
					if (res.code === 0) {
						that.couponList = res.data
					}
				});
			},
			selectCoupon: function(id) {
				uni.setStorageSync('couponId', id)

				uni.navigateBack({
					fail() {
						uni.switchTab({
							url: '/pages/index/index',
						})
					}
				})
			}
		},
		onLoad: function(options) {
			this.checkedGoodsIdList = options.checkedGoodsIdList
			this.checkedBrandIdList = options.checkedBrandIdList

			this.loadListData()
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;
			that.loadListData();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		}
	}
</script>

<style>
	page {
		background: #f5f5f5;
	}

	.container {
		padding-bottom: env(safe-area-inset-bottom);
	}

	.tui-coupon-list {
		width: 100%;
		padding: 0 25rpx;
		box-sizing: border-box;
	}

	.tui-coupon-banner {
		width: 100%;
	}

	.tui-coupon-item {
		width: 100%;
		height: 210rpx;
		position: relative;
		display: flex;
		align-items: center;
		padding-right: 30rpx;
		box-sizing: border-box;
		overflow: hidden;
	}

	.tui-coupon-bg {
		width: 100%;
		height: 210rpx;
		position: absolute;
		left: 0;
		top: 0;
		z-index: 1;
	}

	.tui-coupon-sign {
		height: 110rpx;
		width: 110rpx;
		position: absolute;
		z-index: 9;
		top: -30rpx;
		right: 40rpx;
	}

	.tui-coupon-item-left {
		width: 218rpx;
		height: 210rpx;
		position: relative;
		z-index: 2;
		display: flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		flex-shrink: 0;
	}

	.tui-coupon-price-box {
		display: flex;
		color: #e41f19;
		align-items: flex-end;
	}

	.tui-coupon-price-sign {
		font-size: 30rpx;
	}

	.tui-coupon-price {
		font-size: 70rpx;
		line-height: 68rpx;
		font-weight: bold;
	}

	.tui-price-small {
		font-size: 58rpx !important;
		line-height: 56rpx !important;
	}

	.tui-coupon-intro {
		background: #f7f7f7;
		padding: 8rpx 10rpx;
		font-size: 26rpx;
		line-height: 26rpx;
		font-weight: 400;
		color: #666;
		margin-top: 18rpx;
	}

	.tui-coupon-item-right {
		flex: 1;
		height: 210rpx;
		position: relative;
		z-index: 2;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding-left: 24rpx;
		box-sizing: border-box;
		overflow: hidden;
	}

	.tui-coupon-content {
		width: 82%;
		display: flex;
		flex-direction: column;
		justify-content: center;
	}

	.tui-coupon-title-box {
		display: flex;
		align-items: center;
	}

	.tui-coupon-btn {
		padding: 6rpx;
		background: #ffebeb;
		color: #e41f19;
		font-size: 25rpx;
		line-height: 25rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		transform: scale(0.9);
		transform-origin: 0 center;
		border-radius: 4rpx;
		flex-shrink: 0;
	}

	.tui-color-grey {
		color: #888 !important;
	}

	.tui-bg-grey {
		background: #f0f0f0 !important;
		color: #888 !important;
	}

	.tui-coupon-title {
		width: 100%;
		font-size: 26rpx;
		color: #333;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.tui-coupon-rule {
		padding-top: 52rpx;
	}

	.tui-rule-box {
		display: flex;
		align-items: center;
		transform: scale(0.8);
		transform-origin: 0 100%;
	}

	.tui-padding-btm {
		padding-bottom: 6rpx;
	}

	.tui-coupon-circle {
		width: 8rpx;
		height: 8rpx;
		background: rgb(160, 160, 160);
		border-radius: 50%;
	}

	.tui-coupon-text {
		font-size: 28rpx;
		line-height: 28rpx;
		font-weight: 400;
		color: #666;
		padding-left: 8rpx;
		white-space: nowrap;
	}

	.tui-top20 {
		margin-top: 20rpx;
	}

	.tui-coupon-title {
		font-size: 28rpx;
		line-height: 28rpx;
	}

	.tui-coupon-radio {
		transform: scale(0.7);
		transform-origin: 100% center;
	}

	.tui-btn-box {
		position: absolute;
		width: 146rpx;
		height: 52rpx;
		right: 20rpx;
		z-index: 10;
	}

	.wx-radio-input {
		margin-right: 0 !important;
	}
</style>
