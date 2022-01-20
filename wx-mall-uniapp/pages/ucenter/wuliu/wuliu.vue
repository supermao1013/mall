<template>
	<view class="container">
		<tui-show-empty v-if="logistics.length<=0" text="暂无物流轨迹"></tui-show-empty>
		<view v-else>
			<view class="top-sec">
				<view class="a-row">
					<view class="wl-name">{{shippingName||''}}</view>
				</view>
				<view class="a-row">
					<view class="label">物流单号：</view>
					<view class="text">{{shippingNo||''}}</view>
				</view>
			</view>
			<view class="sec-wrap">
				<view class="details-info">
					<view class="line-box"></view>
					<view class="a-row" v-for="(item, index) in logistics" :key="index">
						<view class="dot">
							<view class="active-dot" :hidden="index== 0 ? false : true">
								<view class="yuan-red"></view>
							</view>
							<view class="default-dot" :hidden="index== 0 ? true : false"></view>
						</view>
						<view class="info">
							<view class="date-box">{{item.AcceptTime}}</view>
							<view class="text">{{item.AcceptStation}}</view>
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
				shippingNo: '',
				shippingName: '',
				shippingCode: '',
				mobile: '',
				logistics: []
			}
		},
		onLoad: function(options) {
			this.shippingNo = options.id
			this.shippingCode = options.code
			this.shippingName = options.name
			this.mobile = options.mobile
		},
		onShow: function() {
			var that = this;
			//使用插件调用物流轨迹
			var logisticsPlugin = requirePlugin("wt-logistics");
			let CustomerName = '';
			if (that.shippingCode === 'SF') {
				// 取手机号后四位
				CustomerName = that.mobile.substr(-4)
			}
			logisticsPlugin.reglogis({
				OrderCode: '',
				LogisticCode: that.shippingNo,
				ShipperCode: that.shippingCode,
				appId: util.kdnBusinessId,
				appKey: util.kdnAppKey,
				requestType: '1002',
				dataType: '2',
				CustomerName: CustomerName,
				url: 'https://api.kdniao.com/Ebusiness/EbusinessOrderHandle.aspx'
			}).then(function(response) {
				if (response.Success) {
					that.logistics = response.Traces;
				}
			})
		},
		methods: {

		}
	}
</script>

<style>
	page {
		min-height: 100%;
		background-color: #f2f2f2;
	}

	.top-sec {
		background-color: #e41f19;
		width: 100%;
		box-sizing: border-box;
		padding: 24rpx 30rpx;
	}

	.top-sec .a-row {
		display: flex;
		font-size: 28rpx;
		line-height: 54rpx;
	}

	.top-sec .a-row .label {
		color: #fff;
		margin-right: 28rpx;
	}

	.top-sec .a-row .text {
		color: #fff;
		margin-right: 28rpx;
	}

	.wl-name {
		color: #fff;
		margin-right: 28rpx;
		font-size: 35rpx;
	}

	.sec-wrap {
		width: 100%;
		background-color: #fff;
		margin-top: 20rpx;
		font-size: 20rpx;
	}

	.details-info {
		position: relative;
		width: 100%;
		overflow: hidden;
	}

	.details-info .a-row {
		margin-left: 40rpx;
		display: flex;
		margin-right: 30rpx;
		margin-bottom: 50rpx;
		position: relative;
		z-index: 4;
	}

	.details-info .a-row .info {
		width: 90%;
		font-size: 28rpx;
	}

	.date-box {
		font-size: 26rpx;
		color: #999;
		margin-bottom: 20rpx;
	}

	.info .text {
		color: #000;
		line-height: 42rpx;
	}

	.dot {
		width: 30rpx;
		height: 30rpx;
		margin-right: 30rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		box-sizing: border-box;
	}

	.default-dot {
		background: #ddd;
		width: 15rpx;
		height: 15rpx;
		border-radius: 100%;
		margin-top: 10rpx;
	}

	.active-dot {
		border: 2rpx solid #e41f19;
		width: 26rpx;
		height: 26rpx;
		border-radius: 50%;
		display: flex;
		align-items: center;
		justify-content: center;
		background-color: #fff;
		margin-top: 10rpx;
	}

	.active-dot .yuan-red {
		background: #e41f19;
		width: 15rpx;
		height: 15rpx;
		border-radius: 50%;
	}

	.line-box {
		position: absolute;
		top: -120rpx;
		left: 54rpx;
		background: #e41f19;
		width: 4rpx;
		height: 100%;
	}
</style>
