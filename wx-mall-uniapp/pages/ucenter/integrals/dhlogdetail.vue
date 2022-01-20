<template>
	<view class="container">
		<view class="tui-order-header">
			<image src="/static/images/mall/img_detail_bg.png" mode="widthFix" class="tui-img-bg"></image>
			<view class="tui-header-content">
				<view>
					<view class="tui-status-text">
						<label>积分订单</label>
						{{orderInfo.orderStatusText||''}}
					</view>
				</view>
				<image :src="getImg(orderInfo.orderStatus)" class="tui-status-img" mode="widthFix"></image>
			</view>
		</view>
		<tui-list-cell :last="true" :hover="false">
			<view class="tui-flex-box">
				<image src="/static/images/mall/icon_address.png" class="tui-icon-img"></image>
				<view class="tui-addr">
					<view class="tui-addr-userinfo">{{orderInfo.consignee||''}}
						<text class="tui-addr-tel">{{orderInfo.mobile||''}}</text>
					</view>
					<view class="tui-addr-text" v-if="orderInfo.orderType != 2">
						{{orderInfo.province + orderInfo.city + orderInfo.district + orderInfo.address}}
					</view>
				</view>
			</view>
		</tui-list-cell>

		<view class="tui-order-item">
			<tui-list-cell :last="false" :hover="false">
				<view class="tui-goods-title">
					商品信息
				</view>
			</tui-list-cell>
			<tui-list-cell padding="0" @click="goodsDetail(orderGoods.id)">
				<view class="tui-goods-item">
					<image :src="orderGoods.listPicUrl" class="tui-goods-img"></image>
					<view class="tui-goods-center">
						<view class="tui-goods-name">{{orderGoods.name||''}}</view>
					</view>
					<view class="tui-price-right">
						<view>消耗积分：{{orderGoods.retailPrice||''}}</view>
						<view>x{{1}}</view>
					</view>
				</view>
			</tui-list-cell>
		</view>
		<view class="tui-order-info">
			<tui-list-cell :hover="false">
				<view class="tui-order-title">
					订单信息
				</view>
			</tui-list-cell>
			<view class="tui-order-content">
				<view class="tui-order-flex">
					<view class="tui-item-title">订单号:</view>
					<view class="tui-item-content">{{orderInfo.orderSn||''}}</view>
				</view>
				<view class="tui-order-flex">
					<view class="tui-item-title">创建时间:</view>
					<view class="tui-item-content">{{orderInfo.addTime||''}}</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.orderType!=2&&orderInfo.confirmTime">
					<view class="tui-item-title">发货时间:</view>
					<view class="tui-item-content">{{orderInfo.confirmTime||''}}</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.orderType!=2&&orderInfo.shippingName">
					<view class="tui-item-title">配送方式:</view>
					<view class="tui-item-content">{{orderInfo.shippingName||''}}</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.orderType!=2&&orderInfo.shippingNo">
					<view class="tui-item-title">物流单号:</view>
					<view class="tui-item-content">{{orderInfo.shippingNo||''}}</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.postscript">
					<view class="tui-item-title">订单备注:</view>
					<view class="tui-item-content">{{orderInfo.postscript || ''}}</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.payType">
					<view class="tui-item-title">支付方式:</view>
					<view class="tui-item-content">积分</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.payTime">
					<view class="tui-item-title">兑换时间:</view>
					<view class="tui-item-content">{{orderInfo.payTime}}</view>
				</view>
			</view>
		</view>
		<view class="tui-safe-area"></view>
		<view class="tui-tabbar tui-order-btn">
			<!-- #ifdef MP-WEIXIN -->
			<view class="tui-btn-mr" v-if="orderInfo.shippingName">
				<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="wuliu">
					物流详情</tui-button>
			</view>
			<!-- #endif -->
			<!-- #ifndef H5 -->
			<view class="tui-btn-mr" v-if="orderInfo.shippingName">
				<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle"
					@click="goMiniProgram">快递100</tui-button>
			</view>
			<!-- #endif -->
			<view class="tui-btn-mr" v-if="orderInfo.handleOption.confirm">
				<tui-button type="primary" plain width="152rpx" height="56rpx" :size="26" shape="circle"
					@click="confirmOrder">确认收货</tui-button>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js");

	export default {
		data() {
			return {
				orderId: 0,
				orderInfo: {
					province: '',
					city: '',
					district: '',
					address: '',
					handleOption: {}
				},
				orderGoods: [],
				handleOption: {},
				sweixin: null
			}
		},
		onLoad: function(options) {
			let that = this;
			// 页面初始化 options为页面跳转所带来的参数
			that.orderId = options.id;

			// #ifdef APP-PLUS
			plus.share.getServices(function(s) {
				var shares = {};
				for (var i = 0; i < s.length; i++) {
					var t = s[i];
					shares[t.id] = t;
				}

				that.sweixin = shares['weixin']
			}, function(e) {
				console.log("获取分享服务列表失败：" + e.message);
			});
			//#endif

			this.getOrderDetail();
		},
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;

			that.getOrderDetail();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			goMiniProgram() {
				let that = this;
				// #ifdef MP-WEIXIN
				uni.navigateToMiniProgram({
					appId: 'wx6885acbedba59c14',
					path: 'pages/result/result?nu=' + that.orderInfo.shippingNo + '&uerysource=third_xcx',
					envVersion: 'release',
					success(res) {}
				})
				// #endif

				//#ifdef APP-PLUS
				that.sweixin ? that.sweixin.launchMiniProgram({
					id: 'gh_a63a83fbf60a',
					path: 'pages/result/result?nu=' + that.orderInfo.shippingNo + '&uerysource=third_xcx',
					type: 0
				}) : plus.nativeUI.alert("当前环境不支持打开'快递100'小程序!");
				//#endif
			},
			wuliu() {
				let that = this;
				uni.navigateTo({
          url: '/pages/ucenter/wuliu/wuliu?id=' + that.orderInfo.shippingNo + '&code=' +
              that.orderInfo.shippingCode + '&name=' + that.orderInfo.shippingName + '&mobile=' +
              that.orderInfo.mobile
				})
			},
			getOrderDetail() {
				let that = this;
				util.request('order/detail', {
					orderId: that.orderId
				}).then(function(res) {
					if (res.code === 0) {
						that.orderInfo = res.orderInfo;
						that.orderGoods = res.orderGoods;
						that.handleOption = res.orderInfo.handleOption;
					}
				});
			},
			getImg: function(orderStatus) {
				let base = '/static/images/mall/'
				if (orderStatus == -1 || orderStatus == 0) {
					return base + 'img_order_payment3x.png'
				}
				if (orderStatus == 100 || orderStatus == 101 || orderStatus == 102) {
					return base + 'img_order_closed3x.png'
				}
				if (orderStatus == 201) {
					return base + 'img_order_send3x.png'
				}
				if (orderStatus == 300) {
					return base + 'img_order_received3x.png'
				}
				if (orderStatus == 301) {
					return base + 'img_order_signed3x.png'
				}
			},
			confirmOrder() {
				let that = this;
				util.request('order/confirmOrder', {
					orderId: that.orderId
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						util.toast('订单完成');
						that.getOrderDetail()
					}
				});
			},
			goodsDetail(goodsId) {
				uni.navigateTo({
					url: '/pages/ucenter/integrals/detail?id=' + goodsId
				})
			}
		}
	}
</script>

<style>
	.container {
		padding-bottom: 118rpx;
	}

	.tui-order-header {
		width: 100%;
		height: 160rpx;
		position: relative;
	}

	.tui-img-bg {
		width: 100%;
		height: 160rpx;
	}

	.tui-header-content {
		width: 100%;
		height: 160rpx;
		position: absolute;
		z-index: 10;
		left: 0;
		top: 0;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 70rpx;
		box-sizing: border-box;
	}

	.tui-status-text {
		font-size: 36rpx;
		line-height: 36rpx;
		color: #FEFEFE;
	}

	.tui-reason {
		font-size: 24rpx;
		line-height: 24rpx;
		color: rgba(254, 254, 254, 0.75);
		padding-top: 15rpx;
		display: flex;
		align-items: center;
	}

	.tui-reason-text {
		padding-right: 12rpx;
	}

	.tui-status-img {
		width: 80rpx;
		height: 80rpx;
		display: block;
	}

	.tui-flex-box {
		width: 100%;
		display: flex;
		align-items: center;
	}

	.tui-icon-img {
		width: 44rpx;
		height: 44rpx;
		flex-shrink: 0;
	}

	.tui-logistics {
		display: flex;
		flex-direction: column;
		justify-content: center;
		padding: 0 24rpx 0 20rpx;
		box-sizing: border-box;
	}

	.tui-logistics-text {
		font-size: 28rpx;
		line-height: 32rpx;
	}

	.tui-logistics-time {
		font-size: 24rpx;
		line-height: 24rpx;
		padding-top: 16rpx;
		color: #666;
	}

	.tui-addr {
		display: flex;
		flex-direction: column;
		justify-content: center;
		padding-left: 20rpx;
		box-sizing: border-box;
	}

	.tui-addr-userinfo {
		font-size: 30rpx;
		line-height: 30rpx;
		font-weight: bold;
	}

	.tui-addr-text {
		font-size: 24rpx;
		line-height: 30rpx;
		padding-top: 16rpx;
	}

	.tui-addr-tel {
		padding-left: 40rpx;
	}

	.tui-order-item {
		margin-top: 20rpx;
		border-radius: 10rpx;
		overflow: hidden;
	}

	.tui-goods-title {
		width: 100%;
		font-size: 28rpx;
		line-height: 28rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}


	.tui-goods-item {
		width: 100%;
		padding: 20rpx 30rpx;
		box-sizing: border-box;
		display: flex;
		justify-content: space-between;
	}

	.tui-goods-img {
		width: 180rpx;
		height: 180rpx;
		display: block;
		flex-shrink: 0;
	}

	.tui-goods-center {
		flex: 1;
		padding: 20rpx 8rpx;
		box-sizing: border-box;
	}

	.tui-goods-name {
		max-width: 310rpx;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
		font-size: 26rpx;
		line-height: 32rpx;
	}

	.tui-goods-attr {
		font-size: 22rpx;
		color: #888888;
		line-height: 32rpx;
		padding-top: 20rpx;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
	}

	.tui-price-right {
		text-align: right;
		font-size: 24rpx;
		color: #888888;
		line-height: 30rpx;
		padding-top: 20rpx;
	}

	.tui-color-red {
		color: #E41F19;
		padding-right: 30rpx;
	}

	.tui-goods-price {
		width: 100%;
		display: flex;
		align-items: flex-end;
		justify-content: flex-end;
		font-size: 24rpx;
	}

	.tui-size-24 {
		font-size: 24rpx;
		line-height: 24rpx;
	}

	.tui-price-large {
		font-size: 32rpx;
		line-height: 30rpx;
	}

	.tui-goods-info {
		width: 100%;
		padding: 30rpx;
		box-sizing: border-box;
		background: #fff;
	}

	.tui-price-flex {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tui-size24 {
		padding-bottom: 24rpx;
		font-size: 24rpx;
		line-height: 24rpx;
		color: #888;
	}

	.tui-size32 {
		font-size: 32rpx;
		line-height: 32rpx;
		font-weight: 500;
	}

	.tui-pbtm20 {
		padding-bottom: 20rpx;
	}

	.tui-flex-shrink {
		flex-shrink: 0;
	}

	.tui-primary-color {
		color: #EB0909;
	}

	.tui-order-info {
		margin-top: 20rpx;
	}

	.tui-order-title {
		position: relative;
		font-size: 28rpx;
		line-height: 28rpx;
		padding-left: 12rpx;
		box-sizing: border-box;
	}

	.tui-order-title::before {
		content: '';
		position: absolute;
		left: 0;
		top: 0;
		border-left: 4rpx solid #EB0909;
		height: 100%;
	}

	.tui-order-content {
		width: 100%;
		padding: 30rpx;
		box-sizing: border-box;
		background: #fff;
		font-size: 24rpx;
		line-height: 30rpx;
	}

	.tui-order-flex {
		display: flex;
		padding-top: 24rpx;
	}

	.tui-order-flex:first-child {
		padding-top: 0
	}

	.tui-item-title {
		width: 132rpx;
		flex-shrink: 0;
	}

	.tui-item-content {
		color: #666;
	}

	.tui-safe-area {
		height: 1rpx;
		padding-bottom: env(safe-area-inset-bottom);
	}

	.tui-tabbar {
		width: 100%;
		height: 140rpx;
		background: #fff;
		position: fixed;
		left: 0;
		bottom: 0;
		display: flex;
		align-items: center;
		justify-content: flex-end;
		font-size: 26rpx;
		padding-bottom: env(safe-area-inset-bottom);
		z-index: 999;
	}

	.tui-btn-mr {
		margin: 10px;
	}
</style>
