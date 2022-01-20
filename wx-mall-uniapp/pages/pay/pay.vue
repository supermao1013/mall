<template>
	<view class="container">
		<view class="total">
			<view class="label">订单金额</view>
			<view class="txt">{{actualPrice}}元</view>
		</view>
		<view class='payment-select'>
			<view class='common-title'>支付方式</view>
			<view class='warapper'>
				<view class='item '>
					<radio-group @change="radioChange">
						<label class="radio-wrapper" v-for="(item, index) in cartArr" :key="item.value">
							<view class='left-wrapper flex'>
								<image :src="'/static/images/mall/'+item.img" class="icon"></image>
								{{item.name}}
							</view>
							<radio :value="item.value" :checked="item.value === payType" />
						</label>
					</radio-group>
				</view>
			</view>
		</view>
		<view class="tips">小程序只支持微信支付，如需其它支付方式，请在网页版支付</view>

		<view class="pay-btn" @tap="requestPayParam">确定</view>
	</view>
</template>

<script>
	const app = getApp()
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				cartArr: [],
				payType: '',
				orderId: 0,
				actualPrice: 0.00
			}
		},
		onLoad: function(options) {
			// 页面初始化 options为页面跳转所带来的参数
			let that = this;
			that.orderId = options.orderId
			that.actualPrice = options.actualPrice

			util.request('order/detail', {
				orderId: that.orderId
			}).then(function(res) {
				if (res.code === 0) {
					that.orderInfo = res.orderInfo;
					that.actualPrice = res.orderInfo.actualPrice
          if (that.orderInfo.payStatus == 3) {
            uni.showModal({
              title: '温馨提示',
              content: '该订单已支付，请勿重复支付！',
              showCancel: false,
              success: function(res) {
                if (res.confirm) {
                  uni.navigateTo({
                    url: '/pages/ucenter/orderDetail/orderDetail?id=' + that.orderId
                  })
                }
              }
            });
          }
				}
			});
			// #ifdef APP-PLUS || MP-WEIXIN || H5
			that.cartArr.push({
				"name": "微信支付",
				"img": "icon_pay_weixin.png",
				value: 'weixin'
			})
			that.payType = 'weixin'
			// #endif
			// #ifdef APP-PLUS || MP-ALIPAY || H5
			that.cartArr.push({
				"name": "支付宝",
				"img": "icon_pay_zhifubao.png",
				value: 'zfb'
			})
			that.payType = 'zfb'
			// #endif
			if (app.globalData.rechargeStatus == 1) {
				that.cartArr.push({
					"name": "余额",
					"img": "icon_pay_balance.png",
					value: 'yue'
				})
			}
		},
		methods: {
			radioChange: function(e) {
				this.payType = e.detail.value
			},
			//向服务请求支付参数
			requestPayParam() {
				let that = this;
				if (that.payType == 'zfb') {
					util.payOrderAli(that.orderId).then(res => {
            let flag = false;
            // #ifdef MP-ALIPAY
            if (res.resultCode == 9000) {
              flag = true;
            }
            // #endif
            // #ifdef APP-PLUS
            if (JSON.parse(res.rawdata).resultStatus == 9000) {
              flag = true;
            }
            // #endif
            if (flag) {
							uni.redirectTo({
								url: '/pages/payResult/payResult?status=1&orderId=' +
									that.orderId
							});
						} else {
							uni.redirectTo({
								url: '/pages/payResult/payResult?status=0&orderId=' +
                    that.orderId + '&msg=支付失败，请重新支付'
							});
						}
					}).catch(res => {
						uni.redirectTo({
							url: '/pages/payResult/payResult?status=0&orderId=' +
                  that.orderId + '&msg=支付失败，请重新支付'
						});
					});
				}
				if (that.payType == 'weixin') {
					util.payOrder(that.orderId).then(res => {
						uni.redirectTo({
							url: '/pages/payResult/payResult?status=1&orderId=' + that.orderId
						});
					}).catch(res => {
						uni.redirectTo({
							url: '/pages/payResult/payResult?status=0&orderId=' + that.orderId + '&msg=' +
								res.errMsg
						});
					});
				}
				if (that.payType == 'yue') {
					util.request('pay/buyByYue', {
						fromType: util.getFromType(),
						orderId: that.orderId
					}, 'POST').then((res) => {
						if (res.code === 0) {
							util.toast('支付成功');
							setTimeout(function() {
								uni.switchTab({
									url: '/pages/ucenter/index/index'
								})
							}, 1000)
						} else {
							if (res.code === 300) {
								uni.showModal({
									title: res.msg,
									content: '是否充值？',
									success(res) {
										if (res.confirm) {
											uni.navigateTo({
												url: '/pages/ucenter/chongzhi/chongzhi'
											})
										} else if (res.cancel) {
											uni.switchTab({
												url: '/pages/ucenter/index/index'
											})
										}
									}
								})
							} else {
								util.toast(res.msg);
							}
						}
					});
				}
			}
		}
	}
</script>

<style>
	page {
		min-height: 100%;
		background: #f4f4f4;
	}

	.container {
		padding-top: 20rpx;
	}

	.total {
		height: 104rpx;
		background: #fff;
		line-height: 104rpx;
		padding-left: 30rpx;
		padding-right: 30rpx;
	}

	.total .label {
		float: left;
	}

	.total .txt {
		float: right;
	}

	.pay-list {
		margin-top: 30rpx;
		height: auto;
		overflow: hidden;
	}

	.pay-list .h {
		height: 24rpx;
		line-height: 24rpx;
		margin-left: 31.25rpx;
		margin-bottom: 31.25rpx;
	}

	.pay-list .item {
		height: 108rpx;
		padding-left: 31.25rpx;
		background: #fff;
		display: flex;
		align-items: center;
		border-bottom: 1px solid #f4f4f4;
	}

	.pay-list .checkbox {
		background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/checkbox-sed825af9d3-a6b8540d42.png) 0 -448rpx no-repeat;
		background-size: 38rpx 486rpx;
		width: 40rpx;
		height: 40rpx;
		display: inline-block;
		vertical-align: middle;
		margin-right: 30rpx;
	}

	.pay-list .checkbox.checked {
		background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/checkbox-sed825af9d3-a6b8540d42.png) 0 -192rpx no-repeat;
		background-size: 38rpx 486rpx;
	}

	.pay-list .icon-alipay {
		display: inline-block;
		vertical-align: middle;
		background-image: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/payMethod-s3c1faebee4-d754da9c65.png);
		background-repeat: no-repeat;
		background-size: 56.25rpx 189.583rpx;
		margin-right: 10.5rpx;
		width: 56.25rpx;
		height: 56.25rpx;
	}

	.pay-list .icon-net {
		display: inline-block;
		vertical-align: middle;
		background: url(http://yanxuan.nosdn.127.net/hxm/yanxuan-wap/p/20161201/style/img/sprites/payMethod-s3c1faebee4-d754da9c65.png) 0 -66.7rpx no-repeat;
		background-size: 56.25rpx 189.583rpx;
		margin-right: 10.5rpx;
		width: 56.25rpx;
		height: 56.25rpx;
	}

	.pay-list .icon {
		display: inline-block;
		vertical-align: middle;
		margin-right: 10.5rpx;
		width: 60rpx;
		height: 52rpx;
	}

	.pay-list .name {
		display: inline-block;
		vertical-align: middle;
		height: 56.25rpx;
		line-height: 56.25rpx;
	}

	.pay-btn {
		position: fixed;
		left: 0;
		bottom: 0;
		height: 100rpx;
		width: 100%;
		text-align: center;
		line-height: 100rpx;
		background: #b4282d;
		color: #fff;
		font-size: 30rpx;
	}

	.tips {
		height: 40rpx;
		font-size: 24rpx;
		color: #999;
		line-height: 40rpx;
		padding-left: 30rpx;
		padding-right: 30rpx;
	}

	.payment-select {
		margin-top: 20rpx;
		background-color: #fff;
		font-size: 26rpx;
		padding: 10px 15px;
	}

	.payment-select .warapper {
		padding: 0 20rpx;
		margin-bottom: 20rpx;
	}

	.payment-select .warapper .item .radio-wrapper {
		height: 85rpx;
		display: flex;
		justify-content: space-between;
		align-items: center;
		border-bottom: 1px solid #efefef;
	}

	.payment-select .warapper .left-wrapper {
		align-items: center;
		color: #565656;
	}

	.payment-select .warapper .left-wrapper .iconfont {
		font-size: 40rpx;
		margin-right: 15rpx;
	}

	.item .icon {
		display: inline-block;
		vertical-align: middle;
		margin-right: 10.5rpx;
		width: 45rpx;
		height: 39rpx;
	}
</style>
