<template>
	<view>
		<view class="container">
			<view class="tui-wallet__box">
				<view class="tui-content__box">
					<view class="tui-my__assets">
						<text>我的资产</text>
						<image @tap="toggle" mode="widthFix"
							:src="'/static/images/mall/'+(isShow?'img_show_3x.png':'img_hide_3x.png')"></image>
					</view>
					<view class="tui-assets__center">
						<view class="tui-item__box">
							<text>余额</text>
							<view v-if="isShow">￥<text class="tui-text__large">{{nowMoney}}</text></view>
							<view v-else><text class="tui-text__large">****</text></view>
						</view>
						<view class="tui-item__box" @tap="bankCard">
							<text>银行卡</text>
							<view v-if="isShow"><text class="tui-text__large">{{cardCount}}</text>张</view>
							<view v-else><text class="tui-text__large">****</text></view>
						</view>
						<view class="tui-item__box" @tap="coupon">
							<text>优惠券</text>
							<view v-if="isShow"><text class="tui-text__large">{{couponCount}}</text>张</view>
							<view v-else><text class="tui-text__large">****</text></view>
						</view>
					</view>
					<view class="tui-assets__bottom" v-if="chongzhi == 1">
						<view @tap='goPayment' style="color: #fff;">
							<text class='main-pic'></text>立即充值
						</view>
					</view>
					<view class="tui-tag__box" @tap="records">账单</view>
				</view>
				<view class="tui-recharge__box" v-if="payFaceToFace.length>0">
					<view class="tui-title">当面付记录</view>
					<block v-for="(item, index) in payFaceToFace" :key="index">
						<view class="tui-list-cell">
							<view class="tui-amount__box">
								<view class="tui-amount__title">支付成功：{{item.actualPrice}}元</view>
							</view>
							<view class="tui-amount__box">
								<view class="tui-amount__desc">{{item.addTime}}</view>
								<view class="tui-amount">支付成功：{{item.actualPrice}}元</view>
							</view>
							<view class="tui-badge tui-bg__appoint">
								<view class="tui-scale__text">{{item.shopsName}}</view>
							</view>
						</view>
					</block>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	const app = getApp()
	export default {
		data() {
			return {
				isShow: true,
				nowMoney: '',
				payFaceToFace: [],
				cardCount: 0,
				couponCount: 0,
				chongzhi: 2
			}
		},
		onLoad: function(options) {
			var that = this;
			that.chongzhi = app.globalData.rechargeStatus
			that.nowMoney = options.now
			that.getMy()
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getMy();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			toggle() {
				this.isShow = !this.isShow
			},
			records() {
				uni.navigateTo({
					url: '/pages/ucenter/records/records',
				})
			},
			getMy() {
				var that = this;
				util.request('coupon/userCount').then(function(res) {
					if (res.code === 0) {
						that.couponCount = res.data || 0
					}
				});
				util.request('user/payFaceToFaceList').then(function(res) {
					if (res.code === 0) {
						that.payFaceToFace = res.data
					}
				});
				util.request('user/getBankCard').then(function(res) {
					if (res.code === 0) {
						that.cardCount = res.data.length || 0
					}
				});
				util.request('coupon/userCount').then(function(res) {
					if (res.code === 0) {
						that.couponCount = res.data || 0
					}
				});
			},
			goPayment: function() {
				uni.navigateTo({
					url: '/pages/ucenter/chongzhi/chongzhi',
				})
			},
			coupon: function() {
				uni.navigateTo({
					url: '/pages/ucenter/coupon/coupon',
				})
			},
			bankCard: function() {
				uni.navigateTo({
					url: '/pages/ucenter/bankCard/bankCard',
				})
			}
		}
	}
</script>

<style>
	.container {
		padding-bottom: 48rpx;
	}

	.tui-wallet__box {
		width: 100%;
		padding: 0 30rpx;
		box-sizing: border-box;
	}

	.tui-content__box {
		width: 100%;
		height: 300rpx;
		border-radius: 24rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
		background: linear-gradient(90deg, rgb(255, 89, 38), rgb(235, 9, 9));
		position: relative;
		box-shadow: 0 3rpx 20rpx rgba(235, 9, 9, 0.2);
	}

	.tui-my__assets {
		width: 100%;
		color: #fff;
		font-size: 32rpx;
		font-weight: bold;
		padding: 30rpx 0;
		box-sizing: border-box;
		display: flex;
		align-items: center;

	}

	.tui-my__assets image {
		width: 36rpx;
		height: 28rpx;
		margin-left: 16rpx;
		display: block;
	}

	.tui-assets__center,
	.tui-assets__bottom {
		width: 100%;
		padding: 0 30rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		box-sizing: border-box;
	}

	.tui-item__box {
		width: 33.3333%;
		text-align: center;
		color: #fff;
		font-size: 26rpx;
		flex-shrink: 0;
	}

	.tui-text__large {
		font-size: 35rpx;
		font-weight: bold;
	}

	.tui-assets__bottom {
		position: absolute;
		left: 0;
		bottom: 0;
		padding-top: 16rpx;
		box-shadow: 0px -5px 10px -5px rgba(255, 255, 255, .3);
	}

	.tui-assets__bottom .tui-item__box {
		width: 25%;
		font-size: 24rpx;
		padding-bottom: 16rpx;
		opacity: 0.8;
	}

	.tui-assets__bottom .tui-text__large {
		font-size: 32rpx;
	}

	.tui-recharge__box {
		width: 100%;
		padding: 40rpx 30rpx;
		box-sizing: border-box;
		margin-top: 30rpx;
		border-radius: 24rpx;
		background-color: #fff;
	}

	.tui-title {
		font-size: 32rpx;
		font-weight: 600;
		color: #222222;
		padding-bottom: 20rpx;
	}

	.tui-list-cell {
		width: 100%;
		height: 160rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
		background: #FFF0F1;
		border-radius: 10rpx;
		margin-top: 20rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		position: relative;
	}

	.tui-amount__title {
		font-size: 36rpx;
		font-weight: bold;
		color: #333333;
	}

	.tui-amount__desc {
		font-size: 24rpx;
		font-weight: 400;
		color: #333333;
	}

	.tui-amount__box {
		width: 100%;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tui-amount {
		font-size: 26rpx;
		font-weight: 500;
		color: #333333;
		text-align: center;
		min-width: 142rpx;
		margin-left: auto;
	}

	.tui-badge {
		height: 32rpx;
		border-radius: 10rpx 0;
		font-size: 25rpx;
		font-weight: 400;
		color: #FFFFFF;
		position: absolute;
		left: 0;
		top: 0;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.tui-bg__new {
		background-color: #1BABA1;
	}

	.tui-bg__appoint {
		background: #F51414;
	}

	.tui-bg__old {
		background: #FA5A0A;
	}

	.tui-scale__text {
		width: 100%;
		text-align: center;
		transform: scale(0.8);
		transform-origin: center center;
	}

	.tui-tag__box {
		position: absolute;
		right: 0;
		top: 30rpx;
		border: 1rpx solid #fff;
		border-right: 0 !important;
		color: #fff;
		font-size: 24rpx;
		border-radius: 100rpx 0 0 100rpx;
		padding: 4rpx 16rpx;
		text-align: center;
	}

	.main-pic {
		background-repeat: no-repeat;
		background-size: 100% 100%;
		width: 50rpx;
		height: 50rpx;
		display: inline-block;
		vertical-align: middle;
		margin-right: 11rpx;
		background-image: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTQyIDc5LjE2MDkyNCwgMjAxNy8wNy8xMy0wMTowNjozOSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo3NjAyNzUyYi05NmZkLWUwNDAtYTVlMy1jY2Y2NTFlZjFkNGIiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RTNCNUIyQjk0MkFFMTFFODg3NEVDQzg3NDJGRUI4QkYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RTNCNUIyQjg0MkFFMTFFODg3NEVDQzg3NDJGRUI4QkYiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTUuNSAoV2luZG93cykiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpmODU1ZTZhNi0wNjllLTA2NDItYTc3Ni1mYzE2ZWFlMDdlZWUiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NzYwMjc1MmItOTZmZC1lMDQwLWE1ZTMtY2NmNjUxZWYxZDRi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");
	}
</style>
