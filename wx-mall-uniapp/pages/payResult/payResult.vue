<template>
	<view>
		<!-- #ifndef H5 -->
		<view class="container" v-if="status == true">
			<view class="tui-bg"></view>
			<view class="tui-content">
				<view class="tui-form">
					<image src="/static/images/mall/img_recharge_success.png" class="tui-icon"></image>
					<view class="tui-title">订单已支付成功</view>
					<view class="tui-sub-title">感谢您购买我们的产品</view>
					<view class="tui-btn-box">
						<tui-button type="danger" width="240rpx" height="70rpx" :size="28" :plain="true" shape="circle" @click="go(1)">返回首页</tui-button>
						<tui-button type="danger" :shadow="true" width="240rpx" height="70rpx" :size="28" shape="circle" @click="go(2)">查看订单</tui-button>
					</view>
				</view>
			</view>
			<view class="tui-tips">
				<view class="tui-grey">温馨提示:</view>
				<view class="tui-light-grey">
					付款成功后，商家不会以付款异常、卡单、系统升级为由联系您。请勿泄露银行卡号、手机验证码，否则会造成钱款损失！谨防电话诈骗！
				</view>
			</view>
		</view>

		<view class="container" v-if="status != true">
			<view class="tui-bg"></view>
			<view class="tui-content">
				<view class="tui-form">
					<image src="/static/images/mall/img_recharge_fail.png" class="tui-icon"></image>
					<view class="tui-title">付款失败</view>
					<view class="tui-sub-title">{{errmsg}}</view>
					<view class="tui-btn-box">
						<tui-button type="danger" width="240rpx" height="70rpx" :size="28" :plain="true" shape="circle" @click='payOrder'>重新付款</tui-button>
						<tui-button type="danger" :shadow="true" width="240rpx" height="70rpx" :size="28" shape="circle" @click="go(2)">查看订单</tui-button>
					</view>
				</view>
			</view>
			<view class="tui-tips">
				<view class="tui-grey">温馨提示:</view>
				<view class="tui-light-grey">
					<view class="p">请在
						<text class="time">30分钟</text> 内完成付款</view>
					<view class="p">否则订单将会被系统取消！</view>
				</view>
			</view>
		</view>
		<!-- #endif -->
		<!-- #ifdef H5 -->
		<tui-modal show content="请确认微信支付已经完成" color="#FC5A6F" :button="buttons" :maskClosable="false" @click="modalClick"></tui-modal>
		<!-- #endif -->
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				status: false,
				orderId: 0,
        orderInfo: {},
				errmsg: '',
				buttons: [{
					text: "重新支付",
					type: "red",
					plain: true //是否空心
				}, {
					text: "已完成支付",
					plain: false
				}]
			}
		},
		methods: {
			go(page) {
        let that = this;
				if (page == 1) {
					uni.switchTab({
						url: "/pages/index/index"
					})
				} else {
					uni.navigateTo({
            url: '/pages/ucenter/orderDetail/orderDetail?id=' + that.orderId
					})
				}
			},
			payOrder() {
        let that = this;
        uni.navigateTo({
          url: '/pages/pay/pay?orderId=' + that.orderId + '&actualPrice=' + that.orderInfo.actualPrice
        })
			},
			modalClick(e) {
        let that = this;
				if (e.index === 1) {
					this.go(2)
				} else {
          this.payOrder()
				}
			},
		},
		onLoad: function(options) {
			// 页面初始化 options为页面跳转所带来的参数
			this.orderId = options.orderId
			this.status = options.status
			this.errmsg = options.msg

      let that = this;
      util.request('order/detail', {
        orderId: that.orderId
      }).then(function(res) {
        if (res.code === 0) {
          that.orderInfo = res.orderInfo;
        }
      });
		}
	}
</script>

<style>
	.tui-bg {
		width: 100%;
		height: 260rpx;
		background: linear-gradient(20deg, #E41F19, #F34B0B);
		border-bottom-left-radius: 42rpx;
	}

	.tui-content {
		padding: 0 35rpx;
		box-sizing: border-box;
	}

	.tui-form {
		background: #fff;
		height: 500rpx;
		box-shadow: 0 10rpx 14rpx 0 rgba(0, 0, 0, 0.08);
		border-radius: 10rpx;
		margin-top: -160rpx;
		position: relative;
		z-index: 10;
		display: flex;
		align-items: center;
		flex-direction: column;
	}

	.tui-icon {
		width: 100rpx;
		height: 100rpx;
		display: block;
		margin-top: 60rpx;
	}

	.tui-title {
		font-size: 42rpx;
		line-height: 42rpx;
		padding-top: 28rpx;
	}

	.tui-sub-title {
		color: #666666;
		font-size: 28rpx;
		line-height: 28rpx;
		padding-top: 20rpx;
	}

	.tui-btn-box {
		width: 580rpx;
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding-top: 88rpx;
	}

	.tui-tips {
		font-size: 26rpx;
		padding: 48rpx 90rpx;
		box-sizing: border-box;
		text-align: justify;
		line-height: 48rpx;
	}

	.tui-grey {
		color: #666;
	}

	.tui-light-grey {
		color: #888;
	}
</style>
