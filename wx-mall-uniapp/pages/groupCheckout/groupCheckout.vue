<template>
	<view class="container">
		<view class="tui-box">
			<tui-list-cell v-if="checkedAddress" :arrow="true" :last="true" :radius="true"
				@click="selectAddress">
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
			<tui-list-cell v-if="!checkedAddress" :arrow="true" :last="true" :radius="true"
				@click="selectAddress">
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
				<block v-for="(item, index) in checkedGoodsList" :key="index">
					<tui-list-cell :hover="false" padding="0">
						<view class="tui-goods-item">
							<image :src="item.listPicUrl" class="tui-goods-img" :data-id="item.goodsId"
								@tap="goodsDetail"></image>
							<view class="tui-goods-center">
								<view class="tui-goods-name">{{item.goodsName}}</view>
								<view class="tui-goods-attr">{{item.goodsSpecifitionNameValue||''}}</view>
							</view>
							<view class="tui-price-right">
								<view>￥{{item.retailPrice}}</view>
								<view>x{{item.number}}</view>
							</view>
						</view>
					</tui-list-cell>
				</block>
				<tui-list-cell :hover="false">
					<view class="tui-padding tui-flex">
						<view>商品总额</view>
						<view>￥{{goodsTotalPrice}}</view>
					</view>
				</tui-list-cell>
				<tui-list-cell :hover="false">
					<view class="tui-padding tui-flex">
						<view>配送费</view>
						<view>￥{{shippingFee}}</view>
					</view>
				</tui-list-cell>
				<tui-list-cell :hover="false" :lineLeft="false" padding="0">
					<view class="tui-remark-box tui-padding tui-flex">
						<view>订单备注</view>
						<input type="text" class="tui-remark" v-model="postscript" placeholder="选填: 请先和商家协商一致"
							auto-focus placeholder-class="tui-phcolor"></input>
					</view>
				</tui-list-cell>
				<tui-list-cell :hover="false" :last="true">
					<view class="tui-padding tui-flex tui-total-flex">
						<view class="tui-flex-end tui-color-red">
							<view class="tui-black">合计： </view>
							<view class="tui-size-26">￥</view>
							<view class="tui-price-large">{{orderTotalPrice}}</view>
						</view>
					</view>
				</tui-list-cell>
			</view>
			<view class="tui-top">
				<tui-list-cell :hover="false" v-for="(item, index) in cartArr" :key="index"
					@click="radioChange({'index':item.value})">
					<view class="tui-padding tui-flex">
						<view>
							<image class="pay-img" :src="'/static/images/mall/'+item.img" />
							<text class="pay-text">{{item.name}}</text>
						</view>
						<radio v-if="item.value == payType" checked='checked'></radio>
						<radio v-else></radio>
					</view>
				</tui-list-cell>
			</view>
		</view>
		<view class="tui-safe-area"></view>
		<view class="tui-tabbar">
			<view class="tui-flex-end tui-color-red tui-pr-20">
				<view class="tui-black">实付金额: </view>
				<view class="tui-size-26">￥</view>
				<view class="tui-price-large">{{orderTotalPrice}}</view>
			</view>
			<view class="tui-pr25">
				<tui-button width="200rpx" height="70rpx" type="danger" shape="circle" @click="submitOrder">确认支付
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
				cartArr: [],
				checkedGoodsList: [],
				addressId: '',
				checkedAddress: {},
				goodsTotalPrice: 0.00, //商品总价
				shippingFee: 0.00, //快递费
				orderTotalPrice: 0.00, //订单总价
				checkedGoodsCount: 0,
				postscript: "",
				payType: '',
				tmplIds: [],
				groupId: '',
				promoUserId: ''
			}
		},
		methods: {
			getCheckoutInfo: function() {
				let that = this;
				util.request('group/checkout', {
					addressId: that.addressId
				}).then(function(res) {
					if (res.code === 0) {
						that.checkedAddress = res.checkedAddress
						that.shippingFee = res.shippingFee
						that.checkedGoodsList = res.checkedGoodsList
						that.goodsTotalPrice = res.goodsTotalPrice
						that.orderTotalPrice = res.orderTotalPrice
						
						that.checkedGoodsCount = res.checkedGoodsCount
					}
				});
			},
			selectAddress() {
				uni.navigateTo({
					url: '/pages/shopping/address/address?prePageType=1'
				})
			},
			goodsDetail: function(event) {
				let goodsId = event.currentTarget.dataset.id;
				uni.navigateTo({
					url: '/pages/groupDetail/groupDetail?goodsId=' + goodsId,
				})
			},
			submitOrder: function(e) {
				let that = this;
				if (util.isEmpty(that.checkedAddress)) {
					util.toast('请添加收货地址');
					return false;
				}

				if (that.payType == '') {
					util.toast('请选择支付方式');
					return false;
				}
				// #ifdef MP-WEIXIN
				uni.requestSubscribeMessage({
					tmplIds: that.tmplIds,
					success(res) {

					},
					fail(res) {

					},
					complete() {
						that.orderSubmit(e);
					}
				})
				// #endif
				// #ifndef MP-WEIXIN
				that.orderSubmit(e);
				// #endif
			},
			radioChange: function(value) {
				this.payType = value.index
			},
			/**
			 * 付款请求
			 */
			orderSubmit: function(e) {
				let that = this;
				util.request('group/submitOrder', {
					fromType: util.getFromType(),
					checkedAddress: that.checkedAddress,
					postscript: that.postscript
				}, 'POST').then(res => {
					if (res.code === 0) {
						const orderId = res.data.id;
						if (that.payType == 'zfb') {
							util.payOrderAli(orderId).then(res => {
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
											orderId
									});
								} else {
									uni.redirectTo({
										url: '/pages/payResult/payResult?status=0&orderId=' +
											orderId + '&msg=支付失败，请重新支付'
									});
								}
							}).catch(res => {
								uni.redirectTo({
									url: '/pages/payResult/payResult?status=0&orderId=' +
										orderId + '&msg=支付失败，请重新支付'
								});
							});
						}
						if (that.payType == 'weixin') {
							util.payOrder(orderId).then(res => {
								uni.redirectTo({
									url: '/pages/payResult/payResult?status=1&orderId=' +
										orderId
								});
							}).catch(res => {
								uni.redirectTo({
									url: '/pages/payResult/payResult?status=0&orderId=' +
										orderId + '&msg=' + res.errMsg
								});
							});
						}
						if (that.payType == 'yue') {
							util.request('pay/buyByYue', {
								fromType: util.getFromType(),
								orderId: orderId
							}, 'POST').then((res) => {
								if (res.code === 0) {
									util.toast('支付成功');
									setTimeout(function() {
										uni.redirectTo({
											url: '/pages/payResult/payResult?status=1&orderId=' +
												orderId
										});
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
													uni.redirectTo({
														url: '/pages/ucenter/orderDetail/orderDetail?id=' +
															orderId
													})
												}
											}
										})
									} else {
										util.toast(res.msg, 2000, 'none');
									}
								}
							});
						}
						if (that.payType == 'jifen') {
							util.request('pay/buyByJiFen', {
								fromType: util.getFromType(),
								orderId: orderId
							}, 'POST').then((res) => {
								if (res.code === 0) {
									util.toast('支付成功');
									setTimeout(function() {
										uni.redirectTo({
											url: '/pages/payResult/payResult?status=1&orderId=' +
												orderId
										});
									}, 1000)
								} else {
									if (res.code === 300) {
										uni.redirectTo({
											url: '/pages/payResult/payResult?status=0&orderId=' +
												orderId + '&msg=积分不足'
										});
									} else {
										util.toast(res.msg, 2000, 'none');
									}
								}
							});
						}
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

			// #ifdef MP-WEIXIN
			util.request('index/getTemplateId', {
				templateTypes: '0,1,5'
			}).then(res => {
				if (res.code === 0) {
					that.tmplIds = res.data
				}
			});
			// #endif

			uni.removeStorageSync('addressId')
			uni.removeStorageSync('addressVo')
		},
		onLoad: function(options) {
			let that = this
			// 页面初始化 options为页面跳转所带来的参数
			if (options.promoUserId) {
				that.promoUserId = options.promoUserId
			}
			that.groupId = options.groupId
			// #ifdef APP-PLUS || MP-WEIXIN || H5
			that.cartArr.push({
				"name": "微信",
				"img": "icon_pay_weixin.png",
				value: 'weixin'
			})
			that.cartArr.push({
				"name": "积分",
				"img": "icon_income_3x.png",
				value: 'jifen'
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

	.tui-color-red {
		color: #E41F19;
		padding-right: 30rpx;
	}

	.tui-black {
		color: #222;
		line-height: 30rpx;
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
</style>
