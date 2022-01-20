<template>
	<view>
		<tui-show-empty v-if="orderList.length<=0" text="暂无兑换记录"></tui-show-empty>
		<view class="container" v-else>
			<view class="orders">
				<view class="tui-order-item" v-for="(item, index) in orderList" :key="index">
					<tui-list-cell :hover="false" :lineLeft="false" @click="dhlogdetail(item.id)">
						<view class="tui-goods-title">
							<view>订单号：{{item.orderSn}}</view>
							<view class="tui-order-status">
								<label style="color: #e41f19;">{{item.orderStatusText||''}}</label>
							</view>
						</view>
					</tui-list-cell>
					<tui-list-cell padding="0" @click="detail(item.goodsId)">
						<view class="tui-goods-item">
							<image :src="item.integralGoodsEntity.listPicUrl" class="tui-goods-img"></image>
							<view class="tui-goods-center">
								<view class="tui-goods-name">{{item.integralGoodsEntity.name||''}}</view>
							</view>
							<view class="tui-price-right">
								<view>消耗积分：{{item.integralGoodsEntity.retailPrice||''}}</view>
								<view>x{{1}}</view>
							</view>
						</view>
					</tui-list-cell>
					<view class="tui-order-btn">
						<!-- #ifdef MP-WEIXIN -->
						<view class="tui-btn-ml" v-if="item.shippingName">
							<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle"
								@click="wuliu(item)">物流详情</tui-button>
						</view>
						<!-- #endif -->
						<!-- #ifndef H5 -->
						<view class="tui-btn-ml" v-if="item.shippingName">
							<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle"
								@click="goMiniProgram(item)">快递100</tui-button>
						</view>
						<!-- #endif -->
						<view class="tui-btn-mr" v-if="item.handleOption.confirm">
							<tui-button @click="confirmOrder(item.id)" type="primary" plain width="152rpx"
								height="56rpx" :size="26" shape="circle">确认收货</tui-button>
						</view>
					</view>
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
				orderList: [],
				current: 1,
				limit: 10,
				sweixin: null
			}
		},
		onShow() {
			this.getOrderList()
		},
		onLoad: function() {
			let that = this;
			// 页面初始化 options为页面跳转所带来的参数

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
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getOrderList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onReachBottom() {
			var that = this;
			that.limit = that.limit + 10;
			that.getOrderList();
		},
		methods: {
			goMiniProgram(orderInfo) {
				let that = this;
				// #ifdef MP-WEIXIN
				uni.navigateToMiniProgram({
					appId: 'wx6885acbedba59c14',
					path: 'pages/result/result?nu=' + orderInfo.shippingNo + '&uerysource=third_xcx',
					envVersion: 'release',
					success(res) {}
				})
				// #endif

				//#ifdef APP-PLUS
				that.sweixin ? that.sweixin.launchMiniProgram({
					id: 'gh_a63a83fbf60a',
					path: 'pages/result/result?nu=' + orderInfo.shippingNo + '&uerysource=third_xcx',
					type: 0
				}) : plus.nativeUI.alert("当前环境不支持打开'快递100'小程序!");
				//#endif
			},
			wuliu(orderInfo) {
				let that = this;
				uni.navigateTo({
          url: '/pages/ucenter/wuliu/wuliu?id=' + orderInfo.shippingNo + '&code=' + orderInfo
                  .shippingCode + '&name=' + orderInfo.shippingName + '&mobile=' +
              orderInfo.mobile
				})
			},
			confirmOrder(orderId) {
				let that = this;
				util.request('order/confirmOrder', {
					orderId: orderId
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						util.toast('订单完成')
						that.getOrderList()
					}
				});
			},
			detail(id) {
				uni.navigateTo({
					url: '/pages/ucenter/integrals/detail?id=' + id
				})
			},
			dhlogdetail(id) {
				uni.navigateTo({
					url: '/pages/ucenter/integrals/dhlogdetail?id=' + id
				})
			},
			getOrderList() {
				let that = this;
				util.request('order/list', {
					orderStatus: -2,
					current: that.current,
					limit: that.limit,
					orderType: 4
				}).then(function(res) {
					if (res.code === 0) {
						that.orderList = res.data.records;
					}
				});
			}
		}
	}
</script>

<style>
	.container {
		padding-bottom: env(safe-area-inset-bottom);
	}

	.tui-order-list {
		margin-top: 80rpx;
	}

	.tui-order-item {
		margin-top: 20rpx;
		border-radius: 10rpx;
		overflow: hidden;
	}

	.tui-goods-title {
		width: 100%;
		font-size: 28rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tui-order-status {
		color: #888;
		font-size: 26rpx;
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
		font-weight: 500;
	}

	.tui-order-btn {
		width: 100%;
		display: flex;
		align-items: center;
		justify-content: flex-end;
		background: #fff;
		padding: 10rpx 30rpx 20rpx;
		box-sizing: border-box;
	}

	.tui-btn-ml {
		margin-left: 20rpx;
	}
</style>
