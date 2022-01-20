<template>
	<view class="container">
		<tui-tabs :tabs="tabs" :isFixed="scrollTop>=0" :currentTab="currentTab" selectedColor="#E41F19" sliderBgColor="#E41F19"
		 @change="change" itemWidth="20%"></tui-tabs>

		<tui-show-empty v-if="orderList.length<=0" text="暂无订单"></tui-show-empty>
		<view :class="{'tui-order-list':scrollTop>=0}" v-else>
			<view class="tui-order-item" v-for="(order,orderIndex) in orderList" :key="orderIndex">
        <tui-list-cell :hover="false" :arrow="true" @click="switchShops(order.shopsSn)">
          <view class="tui-goods-title">
            {{order.shopsName||''}}
          </view>
        </tui-list-cell>

				<tui-list-cell :size="22" color="#888" :last="true" :hover="false" :lineLeft="false" v-if="order.totalSecond>0&&order.orderStatus === 0"
				 @click="orderDetail(order.id)">
					<view class="tui-goods-title">
						等待买家付款
						<tui-countdown :time="order.totalSecond||0" :hours="false" :isColon="false" backgroundColor="#333" borderColor="#333"
						 color="#fff" />
					</view>
				</tui-list-cell>

				<tui-list-cell :hover="false" :lineLeft="false" @click="orderDetail(order.id)">
					<view class="tui-goods-title">
						<view>订单号：{{order.orderSn}}</view>
						<view class="tui-order-status">{{order.orderStatusText}}</view>
					</view>
				</tui-list-cell>
				<block v-for="(item,index) in order.orderGoodsEntityList" :key="index">
					<tui-list-cell padding="0" @click="goodsDetail(item.goodsId)">
						<view class="tui-goods-item">
							<image :src="item.listPicUrl" class="tui-goods-img"></image>
							<view class="tui-goods-center">
								<view class="tui-goods-name">{{item.goodsName||''}}</view>
								<view class="tui-goods-attr">{{item.goodsSpecifitionNameValue||''}}</view>
							</view>
							<view class="tui-price-right">
								<view>￥{{item.retailPrice}}</view>
								<view>x{{item.number}}</view>
							</view>
						</view>
					</tui-list-cell>
				</block>
				<tui-list-cell :hover="false" unlined>
					<view class="tui-goods-price">
						<view>共{{order.goodsCount}}件商品 合计：</view>
						<view class="tui-size-24">￥</view>
						<view class="tui-price-large">{{order.actualPrice}}</view>
					</view>
				</tui-list-cell>
				<view class="tui-order-btn">
					<!-- #ifdef MP-WEIXIN -->
					<view class="tui-btn-ml" v-if="order.shippingName">
						<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="wuliu(order)">物流详情</tui-button>
					</view>
					<!-- #endif -->
					<!-- #ifndef H5 -->
					<view class="tui-btn-ml" v-if="order.shippingName">
						<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="goMiniProgram(order)">快递100</tui-button>
					</view>
					<!-- #endif -->
					<view class="tui-btn-ml">
						<tui-button @click="againBuy(order.id)" type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle">再次购买</tui-button>
					</view>
					<view class="tui-btn-ml" v-if="order.orderStatus==0">
						<tui-button @click="payOrder(order.id,order.actualPrice)" type="danger" plain width="152rpx" height="56rpx" :size="26"
						 shape="circle">立即支付</tui-button>
					</view>
					<view class="tui-btn-ml" v-if="order.orderStatus==0||order.orderStatus==201">
						<tui-button @click="cancelOrder(order.orderStatus, order.id)" type="black" plain width="152rpx" height="56rpx"
						 :size="26" shape="circle">取消订单</tui-button>
					</view>
					<view class="tui-btn-ml" v-if="order.handleOption.confirm">
						<tui-button @click="confirmOrder(order.id)" type="primary" plain width="152rpx" height="56rpx" :size="26" shape="circle">确认收货</tui-button>
					</view>
					<view class="tui-btn-ml" v-if="order.handleOption.comment===true && order.commentCount == 0">
						<tui-button @click="postComment(order.id)" type="green" plain width="152rpx" height="56rpx" :size="26" shape="circle">评价晒单</tui-button>
					</view>
					<view class="tui-btn-ml" v-if="order.commentCount > 0">
						<tui-button @click="lookComment(order.id)" type="green" plain width="152rpx" height="56rpx" :size="26" shape="circle">查看评价</tui-button>
					</view>
					<view class="tui-btn-ml" v-if="order.handleOption.comment===true||order.commentCount > 0">
						<tui-button @click="applyRefund(order.id)" type="gray" plain width="152rpx" height="56rpx" :size="26" shape="circle">申请退款</tui-button>
					</view>
				</view>
			</view>
			<tui-nomore backgroundColor="#fafafa"></tui-nomore>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				scrollTop: 0,
				orderStatus: -2,
				evaluate_status: '',
				orderList: [],
				current: 1,
				limit: 10,
				tabs: [{
					name: "全部"
				}, {
					name: "待付款"
				}, {
					name: "待发货"
				}, {
					name: "待收货"
				}, {
          name: "待评价"
        }, {
          name: "售后申请"
        }],
				currentTab: 0,
				sweixin: null
			}
		},
		onLoad: function(options) {
			let that = this;
			// 页面初始化 options为页面跳转所带来的参数
			if (options.currentTab) {
				that.currentTab = parseInt(options.currentTab)
			}

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
		methods: {
      switchShops(shopsSn) {
        uni.navigateTo({
          url: `/pages/shops/shops?shopsSn=${shopsSn}`
        })
      },
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
              '&name=' + orderInfo.shippingName + '&mobile=' +
              orderInfo.mobile
				})
			},
			change(e) {
				this.currentTab = e.index
				this.orderList = []
				this.current = 1
				this.switchOrderType(e.index);
			},
			orderDetail(id) {
				uni.navigateTo({
					url: '/pages/ucenter/orderDetail/orderDetail?id=' + id
				})
			},
			goodsDetail(goodsId) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + goodsId
				})
			},
			getOrderList() {
				let that = this;
				util.request('order/list', {
					orderStatus: that.orderStatus,
					current: that.current,
					limit: that.limit
				}).then(function(res) {
					if (res.code === 0) {
						let orderList = res.data.records;
						that.orderList = orderList;
						//获取待付款倒计时
						that.orderList.forEach((item, num) => {
							if ((item.payStatus == 1 || item.payStatus == 2) && item.orderStatus === 0) {
								item.totalSecond = util.expireTime(item.expireTime)
							}
						})
					}
				});
			},
			againBuy(orderId) {
				util.request('cart/addByOrder', {
					orderId: orderId
				}).then(function(res) {
					if (res.code === 0) {
						uni.switchTab({
							url: '/pages/cart/cart',
						});
					} else if (res.code === 300) {
						uni.navigateTo({
							url: '/pages/cartShops/cartShops?shopsId=' + res.msg,
						});
					} else {
						util.toast(res.msg)
					}
				});
			},
			cancelOrder(orderStatus, id) {
				let that = this;

				var errorMessage = '';
				switch (orderStatus) {
					case 300:
						{
							errorMessage = '订单已发货';
							break;
						}
					case 301:
						{
							errorMessage = '订单已收货';
							break;
						}
					case 100:
						{
							errorMessage = '订单已过期';
							break;
						}
					case 101:
						{
							errorMessage = '订单已取消';
							break;
						}
					case 102:
						{
							errorMessage = '订单已删除';
							break;
						}
					case 401:
						{
							errorMessage = '订单已退款';
							break;
						}
					case 402:
						{
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
												url: '/pages/ucenter/order/order?currentTab=' + that.currentTab
											});
										}
									});
								}
							});
						}
					}
				});
			},
			payOrder(orderId, actualPrice) {
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
			applyRefund(orderId) {
				let that = this;
				uni.navigateTo({
					url: '/pages/ucenter/refund/refund?orderId=' + orderId
				})
			},
			postComment(orderId) {
				let that = this;
				uni.navigateTo({
					url: '/pages/commentPost/commentPost?type=0&orderId=' + orderId
				})
			},
			lookComment(orderId) {
				uni.navigateTo({
					url: '/pages/comment/comment?type=0&from=1&orderId=' + orderId
				})
			},
			switchOrderType(currentTab) {
				let that = this;
				if (currentTab == 0) {
					that.orderStatus = -2;
				} else if (currentTab == 1) {
					that.orderStatus = 0;
				} else if (currentTab == 2) {
					that.orderStatus = 201;
				} else if (currentTab == 3) {
					that.orderStatus = 300;
				} else if (currentTab == 4) {
					that.orderStatus = 301;
				} else if (currentTab == 5) {
          that.orderStatus = 400;
        }
				that.getOrderList();
			}
		},
		onShow: function() {
			// 页面显示
			let that = this;
			that.switchOrderType(that.currentTab);
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
		onPageScroll(e) {
			this.scrollTop = e.scrollTop;
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
