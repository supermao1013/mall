<template>
	<view class="container">
		<view class="tui-box">
			<tui-list-cell v-if="checkedAddress" :arrow="true" :last="true" :radius="true" @click="selectAddress">
				<view class="tui-address">
					<view>
						<view class="tui-userinfo">
							<text class="tui-name">{{checkedAddress.userName||''}}</text> {{checkedAddress.mobile||''}}
						</view>
						<view class="tui-addr">
							<view class="tui-addr-tag" v-if="checkedAddress.isDefault === 1">默认</view>
							<text>{{(checkedAddress.provinceName ||'')+(checkedAddress.cityName||'')+(checkedAddress.countyName||'')+(checkedAddress.detailInfo||'')}}</text>
						</view>
					</view>
				</view>
				<view class="tui-bg-img"></view>
			</tui-list-cell>
			<tui-list-cell v-else :arrow="true" :last="true" :radius="true" @click="selectAddress">
				<view class="tui-address">
					<view class="tui-none-addr">
						<image src="/static/images/mall/icon_address.png" class="tui-addr-img" mode="widthFix"></image>
						<text>选择收货地址</text>
					</view>
				</view>
				<view class="tui-bg-img"></view>
			</tui-list-cell>
			<view class="tui-top tui-goods-info">
				<tui-list-cell :hover="false" :lineLeft="false">
					<view class="tui-goods-title">
						商品信息
					</view>
				</tui-list-cell>
				<block>
					<tui-list-cell :hover="false" padding="0">
						<view class="tui-goods-item">
							<image :src="goods.listPicUrl" class="tui-goods-img" :data-id="goods.id" @tap="goodsDetail">
							</image>
							<view class="tui-goods-center">
								<view class="tui-goods-name">{{goods.goodsName||''}}</view>
							</view>
							<view class="tui-price-right">
								<view>消耗积分：{{goods.retailPrice||''}}</view>
								<view>x{{1}}</view>
							</view>
						</view>
					</tui-list-cell>
				</block>
				<tui-list-cell :hover="false" :lineLeft="false" padding="0">
					<view class="tui-remark-box tui-padding tui-flex">
						<view>订单备注</view>
						<input type="text" class="tui-remark" v-model="postscript" placeholder="选填: 请先和商家协商一致"
							auto-focus placeholder-class="tui-phcolor"></input>
					</view>
				</tui-list-cell>
			</view>
		</view>
		<view class="tui-safe-area"></view>
		<view class="tui-tabbar">
			<view class="tui-flex-end tui-color-red tui-pr-20">
				<view class="tui-black">消耗积分: </view>
				<view class="tui-price-large">{{goods.retailPrice||''}}</view>
			</view>
			<view class="tui-pr25">
				<tui-button width="200rpx" height="70rpx" type="danger" shape="circle" @click="submitOrder">立即兑换
				</tui-button>
			</view>
		</view>
	</view>
</template>

<script>
	let app = getApp()
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				goods: {},
				addressId: '',
				checkedAddress: {},
				postscript: "",
				tmplIds: [],
				goodsId: ''
			}
		},
		methods: {
			getCheckoutInfo: function() {
				let that = this;
				util.request('cart/checkoutIntegral', {
					addressId: that.addressId,
					goodsId: that.goodsId
				}).then(function(res) {
					if (res.code === 0) {
						that.goods = res.goods
						that.checkedAddress = res.checkedAddress
					}
				});
			},
			selectAddress() {
				uni.navigateTo({
					url: '/pages/shopping/address/address?prePageType=1'
				})
			},
			goodsDetail: function(event) {
				let id = event.currentTarget.dataset.id;
				uni.navigateTo({
					url: '/pages/ucenter/integrals/detail?id=' + id
				})
			},
			submitOrder: function(e) {
				let that = this;
				if (util.isEmpty(that.checkedAddress)) {
					util.toast('请添加收货地址');
					return false;
				}
				util.request('order/submitIntegralsOrder', {
					fromType: util.getFromType(),
					checkedAddress: that.checkedAddress,
					postscript: that.postscript,
					goodsId: that.goodsId
				}, 'POST').then(res => {
					if (res.code === 0) {
						const orderId = res.data.id;
						console.log(orderId)
						uni.redirectTo({
							url: '/pages/ucenter/integrals/dhlogdetail?id=' + orderId
						})
					} else {
						util.toast(res.msg, 2000, 'none');
					}
				});
			}
		},
		onShow: function() {
			let that = this
			that.addressId = uni.getStorageSync('addressId')
			that.getCheckoutInfo();

			uni.removeStorageSync('addressId')
			uni.removeStorageSync('addressVo')
		},
		onLoad: function(options) {
			let that = this
			this.goodsId = options.goodsId
		}
	}
</script>

<style>
	.container {
		padding-bottom: 98rpx;
	}

	.tui-box {
		padding: 20rpx 0 118rpx;
		box-sizing: border-box;
	}

	.tui-address {
		min-height: 80rpx;
		padding: 10rpx 0;
		box-sizing: border-box;
		position: relative;
	}

	.tui-userinfo {
		font-size: 30rpx;
		font-weight: 500;
		line-height: 30rpx;
		padding-bottom: 12rpx;
	}

	.tui-name {
		padding-right: 40rpx;
	}

	.tui-addr {
		font-size: 24rpx;
		word-break: break-all;
		padding-right: 25rpx;
	}

	.tui-addr-tag {
		padding: 5rpx 8rpx;
		flex-shrink: 0;
		background: #EB0909;
		color: #fff;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		font-size: 25rpx;
		line-height: 25rpx;
		transform: scale(0.8);
		transform-origin: 0 center;
		border-radius: 6rpx;
	}

	.tui-bg-img {
		position: absolute;
		width: 100%;
		height: 8rpx;
		left: 0;
		bottom: 0;
		background: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAL0AAAAECAMAAADszM6/AAAAOVBMVEUAAAAVqfH/fp//vWH/vWEVqfH/fp8VqfH/fp//vWEVqfH/fp8VqfH/fp//vWH/vWEVqfH/fp//vWHpE7b6AAAAEHRSTlMA6urqqlVVFRUVq6upqVZUDT4vVAAAAEZJREFUKM/t0CcOACAQRFF6r3v/w6IQJGwyDsPT882IQzQE0E3chToByjG5LwMgLZN3TQATmdypCciBya0cgOT3/h//9PgF49kd+6lTSIIAAAAASUVORK5CYII=") repeat;
	}

	.tui-top {
		margin-top: 20rpx;
		overflow: hidden;
	}

	.tui-goods-title {
		font-size: 28rpx;
		display: flex;
		align-items: center;
	}

	.tui-padding {
		box-sizing: border-box;
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

	.tui-flex {
		width: 100%;
		display: flex;
		align-items: center;
		justify-content: space-between;
		font-size: 26rpx;
	}

	.pay-img {
		width: 40rpx;
		height: 40rpx;
		position: relative;
		top: 10rpx;
	}

	.pay-text {
		padding: 10rpx;
	}

	.tui-total-flex {
		justify-content: flex-end;
	}

	.tui-color-red,
	.tui-invoice-text {
		color: #E41F19;
		padding-right: 30rpx;
	}

	.tui-balance {
		font-size: 28rpx;
		font-weight: 500;
	}

	.tui-black {
		color: #222;
		line-height: 30rpx;
	}

	.tui-gray {
		color: #888888;
		font-weight: 400;
	}

	.tui-light-dark {
		color: #666;
	}

	.tui-goods-price {
		display: flex;
		align-items: center;
		padding-top: 20rpx;
	}

	.tui-size-26 {
		font-size: 26rpx;
		line-height: 26rpx;
	}

	.tui-price-large {
		font-size: 34rpx;
		line-height: 32rpx;
		font-weight: 600;
	}

	.tui-flex-end {
		display: flex;
		align-items: flex-end;
		padding-right: 0;
	}

	.tui-phcolor {
		color: #B3B3B3;
		font-size: 26rpx;
	}

	.tui-remark-box {
		padding: 22rpx 30rpx;
	}

	.tui-remark {
		flex: 1;
		font-size: 26rpx;
		padding-left: 64rpx;
	}

	.tui-scale-small {
		transform: scale(0.8);
		transform-origin: 100% center;
	}

	.tui-scale-small .wx-switch-input {
		margin: 0 !important;
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

	.tui-pr-30 {
		padding-right: 30rpx;
	}

	.tui-pr-20 {
		padding-right: 20rpx;
	}

	.tui-none-addr {
		height: 80rpx;
		padding-left: 5rpx;
		display: flex;
		align-items: center;
	}

	.tui-addr-img {
		width: 36rpx;
		height: 46rpx;
		display: block;
		margin-right: 15rpx;
	}


	.tui-pr25 {
		padding-right: 25rpx;
	}

	.tui-safe-area {
		height: 1rpx;
		padding-bottom: env(safe-area-inset-bottom);
	}

	.coupon {
		color: #e41f19;
	}
</style>
