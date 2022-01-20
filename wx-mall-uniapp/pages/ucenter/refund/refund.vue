<template>
	<view class="container">
		<view class="tui-order-item">
			<tui-list-cell padding="20rpx 30rpx" :hover="false" :lineLeft="false">
				<view class="tui-goods-title">
					<view>商品信息</view>
				</view>
			</tui-list-cell>
			<block v-for="(item, index) in orderGoods" :key="index">
				<tui-list-cell padding="0" @click="goodsDetail(item.goodsId)">
					<view class="tui-goods-item">
						<image :src="item.listPicUrl" class="tui-goods-img"></image>
						<view class="tui-goods-center">
							<view class="tui-goods-name">{{item.goodsName}}</view>
							<view class="tui-goods-attr">{{item.goodsSpecifitionNameValue||''}}</view>
						</view>
						<view class="tui-price-right">
							<view>单价：￥{{item.retailPrice}}</view>
							<view>x{{item.number}}</view>
						</view>
					</view>
				</tui-list-cell>
			</block>
		</view>
		<view class="tui-refund__form">
			<tui-list-cell :hover="false" padding="0">
				<view class="tui-line-cell">
					<view class="tui-title">
						<text class="tui-color__red">*</text>
						<text>申请类型</text>
					</view>
					<input placeholder-class="tui-phcolor" class="tui-input" type="text" value="退货退款" disabled />
				</view>
			</tui-list-cell>
			<tui-list-cell padding="0">
				<view class="tui-line-cell">
					<view class="tui-title">
						<text class="tui-color__red">*</text>
						<text>申请原因</text>
					</view>
					<input placeholder-class="tui-phcolor" class="tui-input" type="text" v-model="refund.reason"
						placeholder="请填写退款原因" />
				</view>
			</tui-list-cell>
			<tui-list-cell :hover="false" padding="0">
				<view class="tui-line-cell">
					<view class="tui-title">
						<text>退款金额</text>
					</view>
					<input placeholder-class="tui-phcolor" class="tui-input" type="text" :value="orderInfo.actualPrice"
						placeholder="请填写退款原因" disabled />
				</view>
			</tui-list-cell>
			<tui-list-cell :hover="false" padding="0">
				<view class="tui-line-cell">
					<view class="tui-title">
						<text class="tui-color__red">*</text>
						<text>申请说明</text>
					</view>
					<input placeholder-class="tui-phcolor" class="tui-input" type="text" v-model="refund.remark"
						placeholder="请填写申请说明" />
				</view>
			</tui-list-cell>
		</view>
		<view class="tui-btn__box">
			<tui-button height="88rpx" type="danger" shadow shape="circle" @click="onPost">提交申请</tui-button>
		</view>
	</view>

</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				orderId: 0,
				orderInfo: {}, // 订单详情
				orderGoods: {}, // 订单商品
				refund: {
					orderSn: '',
					amount: '',
					reason: '',
					remark: ''
				}
			}
		},
		onLoad: function(options) {
			var that = this;
			that.orderId = options.orderId
			that.getOrderDetail();
		},
		methods: {
			getOrderDetail() {
				let that = this;
				util.request('order/detail', {
					orderId: that.orderId
				}).then(function(res) {
					if (res.code === 0) {
						that.orderInfo = res.orderInfo
						that.orderGoods = res.orderGoods
					}
				});
			},
			validate(refund) {
				if (!refund.amount) {
					util.toast('请填写退款金额')
					return false;
				}
				if (!refund.reason) {
					util.toast('请填写申请原因')
					return false;
				}
				if (!refund.remark) {
					util.toast('请填写申请说明')
					return false;
				}
				return true;
			},
			goodsDetail(goodsId) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + goodsId,
				})
			},
			onPost() {
				let that = this;
				that.refund.orderSn = that.orderInfo.orderSn
				that.refund.amount = that.orderInfo.actualPrice
				if (!that.validate(that.refund)) {
					return;
				}
				util.request('order/applyRefund', that.refund, 'POST').then(function(res) {
					if (res.code === 0) {
						util.toast('申请成功，等待管理员审核');
						setTimeout(function() {
							uni.navigateBack({
								delta: 2,
								fail: (res) => {
									uni.switchTab({
										url: '/pages/index/index',
									})
								}
							});
						}, 2000);
					}
				});
			}
		}
	}
</script>

<style>
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

	.tui-refund__form {
		margin-top: 20rpx;
	}

	.tui-line-cell {
		width: 100%;
		padding: 24rpx 30rpx;
		box-sizing: border-box;
		display: flex;
		align-items: center;
	}

	.tui-title {
		width: 180rpx;
		font-size: 28rpx;
		color: #666;
	}

	.tui-color__red {
		color: #EB0909;
		padding-right: 6rpx;
	}

	.tui-title-city-text {
		width: 180rpx;
		height: 40rpx;
		display: block;
		line-height: 46rpx;
	}

	.tui-input {
		width: 500rpx;
		font-size: 28rpx;
	}

	.tui-phcolor {
		color: #ccc;
		font-size: 28rpx;
	}

	.tui-btn__box {
		padding: 60rpx 30rpx;
	}
</style>
