<template>
	<view class="container">
		<view class="tui-order-header">
			<image src="/static/images/mall/img_detail_bg.png" mode="widthFix" class="tui-img-bg"></image>
			<view class="tui-header-content">
				<view>
          <view class="tui-status-text">
            <label v-if="orderInfo.orderType == 5">拼团订单</label>
            <label v-else>普通订单</label>
            {{orderInfo.orderStatusText||''}}
          </view>
					<view class="tui-reason">
						<text class="tui-reason-text" v-if="orderInfo.totalSecond>0&&orderInfo.orderStatus===0">等待买家付款
						</text>
						<tui-countdown v-if="orderInfo.totalSecond>0" :time="orderInfo.totalSecond||0" :hours="false" :isColon="false"
						 backgroundColor="#333" borderColor="#333" color="#fff" />
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
					<view class="tui-addr-text">{{orderInfo.province + orderInfo.city + orderInfo.district + orderInfo.address}}</view>
				</view>
			</view>
		</tui-list-cell>

		<tui-modal :show="qrcode" custom width="60%" :maskClosable="true" :fadeIn="true" @cancel="changeQrcode">
			<canvas v-show="qrcode" canvas-id="memberCode" style="width: 350rpx; height: 350rpx;"></canvas>
		</tui-modal>

		<view class="tui-order-item">
      <tui-list-cell :hover="false" :arrow="true" @click="switchShops(orderInfo.shopsSn)">
        <view class="tui-goods-title">
          {{orderInfo.shopsName||''}}
        </view>
      </tui-list-cell>
			<block v-for="(item, index) in orderGoods" :key="index">
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
			<view class="tui-goods-info">
				<view class="tui-price-flex  tui-size24">
					<view>优惠券</view>
					<view>{{orderInfo.couponName||''}} - ￥{{orderInfo.couponPrice||0}}</view>
				</view>
				<view class="tui-price-flex  tui-size24">
					<view>配送费</view>
					<view>￥{{orderInfo.shippingFee}}</view>
				</view>
				<view class="tui-price-flex tui-size32 tui-pbtm20">
					<view class="tui-flex-shrink">合计</view>
					<view class="tui-goods-price">
						<view class="tui-size-24">￥</view>
						<view class="tui-price-large">{{orderInfo.orderPrice}}</view>
					</view>
				</view>
				<view class="tui-price-flex tui-size32">
					<view class="tui-flex-shrink">实付款</view>
					<view class="tui-goods-price tui-primary-color">
						<view class="tui-size-24">￥</view>
						<view class="tui-price-large">{{orderInfo.actualPrice||0}}</view>
					</view>
				</view>
			</view>
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
				<view class="tui-order-flex" v-if="orderInfo.confirmTime">
					<view class="tui-item-title">发货时间:</view>
					<view class="tui-item-content">{{orderInfo.confirmTime||''}}</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.shippingName">
					<view class="tui-item-title">配送方式:</view>
					<view class="tui-item-content">{{orderInfo.shippingName||''}}</view>
				</view>
				<view class="tui-order-flex" v-if="orderInfo.shippingNo">
					<view class="tui-item-title">物流单号:</view>
					<view class="tui-item-content">{{orderInfo.shippingNo||''}}</view>
				</view>
        <view class="tui-order-flex" v-if="orderInfo.postscript">
					<view class="tui-item-title">订单备注:</view>
					<view class="tui-item-content">{{orderInfo.postscript || ''}}</view>
				</view>
        <view class="tui-order-flex" v-if="orderInfo.payType">
          <view class="tui-item-title">支付方式:</view>
          <view class="tui-item-content">{{getPayTypeText(orderInfo.payType)}}</view>
        </view>
        <view class="tui-order-flex" v-if="orderInfo.payTime">
          <view class="tui-item-title">支付时间:</view>
          <view class="tui-item-content">{{orderInfo.payTime}}</view>
        </view>
			</view>
		</view>
		<view class="tui-safe-area"></view>
		<view class="tui-tabbar tui-order-btn">
			<!-- #ifdef MP-WEIXIN -->
			<view class="tui-btn-mr" v-if="orderInfo.shippingName">
				<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="wuliu">物流详情</tui-button>
			</view>
			<!-- #endif -->
			<!-- #ifndef H5 -->
			<view class="tui-btn-mr" v-if="orderInfo.shippingName">
				<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="goMiniProgram">快递100</tui-button>
			</view>
			<!-- #endif -->
			<view class="tui-btn-ml">
				<tui-button type="warning" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="againBuy">再次购买</tui-button>
			</view>
			<view class="tui-btn-mr" v-if="orderInfo.totalSecond>0&&orderInfo.orderStatus==0">
				<tui-button type="danger" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="payOrder">立即支付</tui-button>
			</view>
			<view class="tui-btn-mr" v-if="orderInfo.totalSecond>0||(orderInfo.orderStatus==0||orderInfo.orderStatus==201)">
				<tui-button type="danger" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="cancelOrder">取消订单</tui-button>
			</view>
			<view class="tui-btn-mr" v-if="orderInfo.handleOption.confirm">
				<tui-button type="primary" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="confirmOrder">确认收货</tui-button>
			</view>
			<view class="tui-btn-mr" v-if="orderInfo.handleOption.comment===true && orderInfo.commentCount == 0">
				<tui-button type="green" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="postComment">评价晒单</tui-button>
			</view>
			<view class="tui-btn-mr" v-if="orderInfo.commentCount > 0">
				<tui-button type="green" plain width="152rpx" height="56rpx" :size="26" shape="circle" @click="lookComment">查看评价</tui-button>
			</view>
			<view class="tui-btn-ml" v-if="orderInfo.handleOption.comment===true||orderInfo.commentCount > 0">
				<tui-button @click="applyRefund" type="gray" plain width="152rpx" height="56rpx" :size="26" shape="circle">申请退款</tui-button>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js");
	import uQRCode from '@/libs/uqrcode'

	export default {
		data() {
			return {
				qrcode: false,
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
		methods: {
      getPayTypeText(payType) {
        if (payType == 1) {
          return '微信支付';
        }
        if (payType == 2) {
          return '余额支付';
        }
        if (payType == 3) {
          return '支付宝支付';
        }
      },
      switchShops(shopsSn) {
        uni.navigateTo({
          url: `/pages/shops/shops?shopsSn=${shopsSn}`
        })
      },
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
          url: '/pages/ucenter/wuliu/wuliu?id=' + that.orderInfo.shippingNo + '&code=' + that.orderInfo
                  .shippingCode + '&name=' + that.orderInfo.shippingName  + '&mobile=' +
              that.orderInfo.mobile
				})
			},
			changeQrcode(){
				this.qrcode = !this.qrcode
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
						if ((that.orderInfo.payStatus == 1 || that.orderInfo.payStatus == 2) && that.orderInfo.orderStatus === 0) {
							that.orderInfo.totalSecond = util.expireTime(that.orderInfo.expireTime)
						}
						uQRCode.make({
							canvasId: 'memberCode',
							componentInstance: this,
							text: res.orderInfo.orderSn,
							size: uni.upx2px(350),
							margin: 20,
							backgroundColor: '#ffffff',
							foregroundColor: '#000000',
							fileType: 'jpg',
							correctLevel: uQRCode.defaults.correctLevel,
							success: res => {
								console.log(res)
							}
						})
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
			againBuy() {
				let that = this;
				util.request('cart/addByOrder', {
					orderId: that.orderId
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
			applyRefund() {
				let that = this;
				uni.navigateTo({
					url: '/pages/ucenter/refund/refund?orderId=' + that.orderId
				})
			},
			postComment() {
				let that = this;
				uni.navigateTo({
					url: '/pages/commentPost/commentPost?type=0' + '&orderId=' + that.orderId,
				})
			},
			lookComment() {
				let that = this;
				uni.navigateTo({
					url: '/pages/comment/comment?type=0' + '&orderId=' + that.orderId,
				})
			},
			cancelOrder() {
				let that = this;
				let orderInfo = that.orderInfo;

				var orderStatus = orderInfo.orderStatus;
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
								orderId: orderInfo.id
							}, 'POST').then(function(res) {
								if (res.code === 0) {
									uni.showModal({
										title: '提示',
										content: res.msg,
										showCancel: false,
										confirmText: '继续',
										success: function(res) {
											uni.reLaunch({
												url: '/pages/ucenter/order/order',
											});
										}
									});
								}
							});

						}
					}
				});
			},
			payOrder() {
				let that = this;
        if (that.orderInfo.address) {
					uni.navigateTo({
						url: '/pages/pay/pay?orderId=' + that.orderInfo.id + '&actualPrice=' + that.orderInfo.actualPrice,
					})
				} else {
					util.toast('请选择收货地址');
				}
			},
			confirmOrder() {
				let that = this;
				util.request('order/confirmOrder', {
					orderId: that.orderId
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						util.toast('订单完成');
						setTimeout(function() {
							uni.reLaunch({
								url: '/pages/ucenter/order/order',
							});
						}, 2000);
					}
				});
			},
			goodsDetail(goodsId) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + goodsId,
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
