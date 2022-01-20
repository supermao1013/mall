<template>
	<view class="pay-bg">
		<view class='title'>输入金额</view>
		<view class='input flex'>
			<input type='digit' placeholder='0.00' placeholder-class='placeholder' v-model='number'></input>
		</view>
		<view class='tip'>提示：当前余额为
			<text>￥{{nowMoney}}</text>
		</view>
		<button class='but' @tap='submitSub'>立即充值</button>
	</view>
</template>

<script>
	const app = getApp()
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				number: 0,
				nowMoney: 0,
				visible: false
			}
		},
		onLoad: function() {
			var that = this;
			if (app.globalData.rechargeStatus != 1) {
				util.toast('暂未开通');
				that.goIndex();
			} else {
				util.request('user/userInfo').then(function(res) {
					if (res.code === 0) {
						that.nowMoney = res.data.balance
					}
				});
			}
		},
		methods: {
			goIndex: function() {
				uni.switchTab({
					url: '/pages/index/index'
				})
			},
			submitSub: function() {
				var that = this;
				if (!that.number) {
					util.toast('请输入充值金额');
					return false;
				}
				if (!util.isNumber(that.number)) {
					util.toast('请输入正确的充值金额');
					return false;
				}

				let tradeType = 'JSAPI'
				// #ifdef APP-PLUS
				tradeType = 'APP'
				// #endif
				// #ifdef H5
				tradeType = 'MWEB'
				// #endif
				util.request('pay/prepayYue', {
					fromType: util.getFromType(),
					tradeType: tradeType,
					price: that.number
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						var jsConfig = res.data;
						uni.requestPayment({
							timeStamp: jsConfig.timeStamp,
							nonceStr: jsConfig.nonceStr,
							package: jsConfig.packageValue,
							signType: jsConfig.signType,
							paySign: jsConfig.paySign,
							success: function(res) {
								util.toast('充值成功');
								that.nowMoney = parseFloat(that.nowMoney) + parseFloat(that.number)
								setTimeout(function() {
									uni.reLaunch({
										url: '/pages/ucenter/yue/yue?now=' + that.nowMoney,
									})
								}, 2000)
							},
							fail: function(res) {
								util.toast('支付失败');
							},
							complete: function(res) {
								if (res.errMsg == 'requestPayment:cancel') {
									util.toast('取消支付');
								}
							},
						})
					} else {
						util.toast(res.msg);
					}
				})
			}
		}
	}
</script>

<style>
	.pay-bg {
		width: 703rpx;
		height: 470rpx;
		background-color: #fff;
		border-radius: 10rpx;
		margin: 20rpx auto 0 auto;
	}

	.pay-bg .title {
		font-size: 28rpx;
		color: #c6c6c6;
		text-align: center;
		padding-top: 60rpx;
	}

	.pay-bg .input {
		width: 552rpx;
		border-bottom: 1rpx solid #ddd;
		margin: 48rpx auto 0 auto;
		font-size: 56rpx;
		color: #333;
		justify-content: space-between;
		align-items: flex-end;
	}

	.pay-bg .input text {
		padding-left: 106rpx;
	}

	.pay-bg .input input {
		height: 94rpx;
		text-align: center;
	}

	.pay-bg .placeholder {
		font-size: 84.5rpx;
		color: #d0d0d0;
	}

	.pay-bg .tip {
		font-size: 26rpx;
		color: #888;
		text-align: center;
		padding: 0 30rpx;
		margin-top: 25rpx;
	}

	.pay-bg .tip text {
		color: #ef4a49;
	}

	.pay-bg .but {
		color: #fff;
		font-size: 30rpx;
		background-color: #e41f19;
		width: 550rpx;
		height: 86rpx;
		border-radius: 50rpx;
		margin-top: 46rpx;
	}
</style>
