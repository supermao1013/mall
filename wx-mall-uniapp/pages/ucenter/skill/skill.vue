<template>
	<view>
		<tui-show-empty v-if="orderList.length<=0" text="暂无秒杀订单"></tui-show-empty>
		<view class="container" v-else>
			<view class="orders">
				<view class="tui-order-item" v-for="(item, index) in orderList" :key="index">
					<tui-list-cell :hover="false" :lineLeft="false" @click="orderDetail(item.id)">
						<view class="tui-goods-title">
							<view>订单号：{{item.orderSn}}</view>
							<view class="tui-order-status">
								<label v-if="item.totalSecond>0&&item.orderStatus === -1">待付款
									<tui-countdown :time="item.totalSecond||0" :hours="false" :isColon="false"
										backgroundColor="#333" borderColor="#333" color="#fff" />
								</label>
								<label v-else style="color: #e41f19;">{{item.orderStatusText}}</label>
							</view>
						</view>
					</tui-list-cell>
					<block v-for="(cell, index2) in item.orderGoodsEntityList" :key="index2">
						<tui-list-cell padding="0" @click="orderDetail(item.id)">
							<view class="tui-goods-item">
								<image :src="cell.listPicUrl" class="tui-goods-img"></image>
								<view class="tui-goods-center">
									<view class="tui-goods-name">{{cell.goodsName}}</view>
								</view>
								<view class="tui-price-right">
									<view>￥{{cell.retailPrice}}</view>
									<view>x{{cell.number}}</view>
								</view>
							</view>
						</tui-list-cell>
					</block>
					<tui-list-cell :hover="false" :last="true">
						<view class="tui-goods-price">
							<view>共{{item.orderGoodsEntityList.length||0}}件商品 合计：</view>
							<view class="tui-size-24">￥</view>
							<view class="tui-price-large">{{item.actualPrice}}</view>
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
						<view class="tui-btn-mr" v-if="item.totalSecond>0&&item.orderStatus==-1">
							<tui-button @click="payOrder(item.id,item.actualPrice,item.mobile)" type="danger" plain
								width="152rpx" height="56rpx" :size="26" shape="circle">立即支付</tui-button>
						</view>
						<view class="tui-btn-mr" v-if="item.totalSecond>0&&item.orderStatus==-1">
							<tui-button @click="cancelOrder(item.orderStatus, item.id)" type="black" plain
								width="152rpx" height="56rpx" :size="26" shape="circle">取消订单</tui-button>
						</view>
						<view class="tui-btn-mr" v-if="item.handleOption.confirm">
							<tui-button @click="confirmOrder(item.id)" type="primary" plain width="152rpx"
								height="56rpx" :size="26" shape="circle">确认收货</tui-button>
						</view>
						<view class="tui-btn-ml">
							<tui-button v-if="item.handleOption.comment==true && item.commentCount == 0"
								@click="postComment(item.id)" type="green" plain width="152rpx" height="56rpx"
								:size="26" shape="circle">评价晒单</tui-button>
							<tui-button v-if="item.commentCount > 0" @click="lookComment(item.id)" type="green" plain
								width="152rpx" height="56rpx" :size="26" shape="circle">查看评价</tui-button>
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
				orderStatus: -2,
				evaluate_status: '',
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
          url: '/pages/ucenter/wuliu/wuliu?id=' + orderInfo.shippingNo + '&code=' + orderInfo.shippingCode +
              '&name=' + orderInfo.shippingName + '&mobile=' + orderInfo.mobile
				})
			},
			cancelOrder(orderStatus, id) {
				let that = this;

				var errorMessage = '';
				switch (orderStatus) {
					case 300: {
						errorMessage = '订单已发货';
						break;
					}
					case 301: {
						errorMessage = '订单已收货';
						break;
					}
					case 100: {
						errorMessage = '订单已过期';
						break;
					}
					case 101: {
						errorMessage = '订单已取消';
						break;
					}
					case 102: {
						errorMessage = '订单已删除';
						break;
					}
					case 401: {
						errorMessage = '订单已退款';
						break;
					}
					case 402: {
						errorMessage = '订单已退货';
						break;
					}
				}
				if (errorMessage != '') {
					util.toast(errorMessage);
					return false;
				}
				uni.showModal({
					title: '',
					content: '确定要取消此订单？',
					success: function(res) {
						if (res.confirm) {
							util.request('order/cancelOrder', {
								orderId: id
							}, 'POST').then(function(res) {
								if (res.code === 0) {
									uni.showModal({
										title: '提示',
										content: res.msg,
										showCancel: false,
										confirmText: '继续',
										success: function(res) {
											uni.redirectTo({
												url: '/pages/ucenter/skill/skill'
											});
										}
									});
								}
							});
						}
					}
				});
			},
			payOrder(orderId, actualPrice, mobile) {
				let that = this;
				if (!mobile) {
					util.toast('请选择收货地址');
					setTimeout(function() {
						that.orderDetail(orderId)
					}, 1000)
					return;
				}
				uni.navigateTo({
					url: '/pages/pay/pay?orderId=' + orderId + '&actualPrice=' + actualPrice
				})
			},
			confirmOrder(orderId) {
        let that = this;
				util.request('order/confirmOrder', {
					orderId: orderId
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						util.toast('订单完成')
						setTimeout(function() {
							uni.redirectTo({
								url: '/pages/ucenter/order/order?currentTab=' + that.currentTab
							});
						}, 2000);
					}
				});
			},
			postComment(orderId) {
				let that = this;
				uni.navigateTo({
					url: '/pages/commentPost/commentPost?type=0&orderId=' + orderId,
				})
			},
			lookComment(orderId) {
				uni.navigateTo({
					url: '/pages/comment/comment?type=0&orderId=' + orderId,
				})
			},
			orderDetail(id) {
				uni.navigateTo({
					url: '/pages/ucenter/skillDetail/skillDetail?id=' + id,
				})
			},
			getOrderList() {
				let that = this;
				util.request('order/list', {
					orderStatus: that.orderStatus,
					current: that.current,
					limit: that.limit,
					orderType: 3
				}).then(function(res) {
					if (res.code === 0) {
						let orderList = res.data.records;
						that.orderList = orderList;
						//获取待付款倒计时
						that.orderList.forEach((item, num) => {
							if ((item.payStatus == 1 || item.payStatus == 2) && item.orderStatus === -1) {
								item.totalSecond = util.expireTime(item.expireTime)
							}
						})
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
