<template>
	<view class="container">
		<view class="address-list" v-if="addressList.length > 0">
			<view class="item" v-if="prePageType==1" v-for="(item, index) in addressList" :key="index">
				<view class="l" @tap="selectAddress" :data-address-id="item.id">
					<view class="name">{{item.userName}}</view>
					<view class="default" v-if="item.isDefault">默认</view>
				</view>
				<view class="c" @tap="selectAddress" :data-address-id="item.id">
					<view class="mobile">{{item.mobile}}</view>
					<view class="address">{{item.provinceName+item.cityName+item.countyName+item.detailInfo}}</view>
				</view>
				<view class="r">
					<image @tap="addressAddOrUpdate" :data-address-id="item.id" class="editor" src="/static/images/mall/icon_feedback.png"></image>
				</view>
			</view>

			<view class="item" v-if="prePageType==2" v-for="(item, index) in addressList" :key="index">
				<view class="l" @tap="addressAddOrUpdate" :data-address-id="item.id">
					<view class="name">{{item.userName}}</view>
					<view class="default" v-if="item.isDefault">默认</view>
				</view>
				<view class="c" @tap="addressAddOrUpdate" :data-address-id="item.id">
					<view class="mobile">{{item.mobile}}</view>
					<view class="address">{{item.provinceName+item.cityName+item.countyName+item.detailInfo}}</view>
				</view>
				<view class="r">
					<tui-icon name="delete" color="gray" :size="26" @click="deleteAddress(item.id)"></tui-icon>
				</view>
			</view>
		</view>
		<view class="empty-view" v-if="addressList.length <= 0">
			<image class="icon" src="/static/images/mall/icon_address.png"></image>
			<text class="text">收货地址在哪里</text>
		</view>
		<view class="add-address" @tap="addressAddOrUpdate" :data-address-id="0">
			<image class='address-icon' src='/static/images/mall/plus.png'></image>新建
		</view>
    <!-- #ifdef MP-WEIXIN -->
		<view class="sync-address" @tap="getWtAddress">
			<image class='address-icon' src='/static/images/mall/wx.png'></image>微信地址
		</view>
		<!-- #endif -->
		<!-- #ifdef MP-TOUTIAO -->
		<view class="tt-address" @tap="getWtAddress">
			<image class='address-icon' src='/static/images/mall/tt.png'></image>头条地址
		</view>
		<!-- #endif -->
    <!-- #ifdef MP-ALIPAY -->
    <view class="alipay-address" @tap="getWtAddress">
      <image class='address-icon' src='/static/images/mall/icon_pay_zhifubao.png'></image>支付宝地址
    </view>
    <!-- #endif -->
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				addressList: [],
				prePageType: 2
			}
		},
		methods: {
			deleteAddress(addressId) {
				let that = this;
				util.request('address/delete', {
					id: addressId
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						that.getAddressList();
					}
				});
				return false;
			},
			getAddressList() {
				let that = this;
				util.request('address/list').then(function(res) {
					if (res.code === 0) {
						that.addressList = res.data;
					}
				});
			},
			addressAddOrUpdate(event) {
				var addressId = event.currentTarget.dataset.addressId;
				try {
					uni.navigateTo({
						url: '/pages/shopping/addressAdd/addressAdd?id=' + addressId,
						success: function(res) {},
						fail: function(res) {}
					})
				} catch (e) {}
			},
			selectAddress(event) {
				var that = this;
				var addressId = event.currentTarget.dataset.addressId;

				uni.setStorageSync('addressId', addressId);
				var selectAddressVo = that.addressList.filter(function(v) {
					if (v.id == addressId) {
						return true;
					} else {
						return false;
					}
				}).map(function(v) {
					return v;
				});

				uni.setStorageSync('addressVo', selectAddressVo[0]);

				uni.navigateBack({
					fail() {
						uni.switchTab({
							url: '/pages/index/index',
						})
					}
				})
			},
			getWtAddress() {
				let that = this;
				uni.chooseAddress({
					success: function(res) {
						util.request('address/syncAddress', {
							userName: res.userName,
							mobile: res.telNumber,
							provinceName: res.provinceName,
							cityName: res.cityName,
							countyName: res.countyName,
							detailInfo: res.detailInfo,
							postalCode: res.postalCode,
							nationalCode: res.nationalCode,
							latitude: res.latitude,
							longitude: res.longitude
						}, 'POST').then(function(res) {
							if (res.code === 0) {
								that.getAddressList();
							}
						});
					}
				})
			}
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getAddressList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onShow: function() {
			// 页面显示
			this.getAddressList();
		},
		onLoad(option) {
			if (option.prePageType) {
				this.prePageType = option.prePageType
			}
		}
	}
</script>

<style>
	page {
		height: 100%;
		width: 100%;
		background: #f4f4f4;
	}

	.container {
		height: 100%;
		width: 100%;
	}

	.address-list {
		padding-left: 31.25rpx;
		background: #fff url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAKCAMAAADfAc3wAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAAAYUExURc2AgICg1v///+rw+ffq6tKMjI2p2ouo2QT3I5MAAAA9SURBVCjPpcs5EgAgCARB5ND//9jEYwlZJp1q0ZTNAS3L10OgcGlYlYZNuGoRly3guv2YsA8z9mLKHsxZ3e5sBBsNqhCTAAAAAElFTkSuQmCC) 0 0 repeat-x;
		background-size: auto 10.5rpx;
		margin-bottom: 90rpx;
	}

	.address-list .item {
		height: 156.55rpx;
		align-items: center;
		display: flex;
		border-bottom: 1rpx solid #dcd9d9;
	}

	.address-list .l {
		width: 125rpx;
		overflow: hidden;
	}

	.address-list .name {
		width: 125rpx;
		height: 43rpx;
		font-size: 29rpx;
		color: #333;
		margin-bottom: 5.2rpx;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}

	.address-list .default {
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
		margin-left: 10rpx;
	}

	.address-list .c {
		flex: 1;
		height: auto;
		overflow: hidden;
	}

	.address-list .mobile {
		height: 29rpx;
		font-size: 29rpx;
		line-height: 29rpx;
		overflow: hidden;
		color: #333;
		margin-bottom: 6.25rpx;
	}

	.address-list .address {
		height: auto;
		font-size: 25rpx;
		line-height: 37rpx;
		overflow: hidden;
		color: #666;
	}

	.address-list .r {
		width: 52rpx;
		height: auto;
		overflow: hidden;
		margin-right: 16.5rpx;
	}

	.address-list .editor {
		display: block;
		width: 52rpx;
		height: 52rpx;
	}

	.add-address {
		display: inline-block;
		background: #e41f19;
		text-align: center;
		width: 40%;
		/* #ifdef APP-PLUS || H5 */
		width: 90%;
		/* #endif */
		height: 99rpx;
		line-height: 99rpx;
		position: fixed;
		border-radius: 50rpx;
		border: none;
		color: #fff;
		font-size: 29rpx;
		bottom: 65rpx;
		left: 50rpx;
	}

	.sync-address {
		display: inline-block;
		background: #58bf38;
		text-align: center;
		width: 40%;
		height: 99rpx;
		line-height: 99rpx;
		position: fixed;
		border-radius: 50rpx;
		border: none;
		color: #fff;
		font-size: 29rpx;
		bottom: 65rpx;
		right: 50rpx;
	}

  .alipay-address {
    display: inline-block;
    background: #1890FF;
    text-align: center;
    width: 40%;
    height: 99rpx;
    line-height: 99rpx;
    position: fixed;
    border-radius: 50rpx;
    border: none;
    color: #fff;
    font-size: 29rpx;
    bottom: 65rpx;
    right: 50rpx;
  }

	.tt-address {
		display: inline-block;
		background: #000;
		text-align: center;
		width: 40%;
		height: 99rpx;
		line-height: 99rpx;
		position: fixed;
		border-radius: 50rpx;
		border: none;
		color: #fff;
		font-size: 29rpx;
		bottom: 65rpx;
		right: 50rpx;
	}

	.address-icon {
		width: 40rpx;
		height: 40rpx;
		margin-right: 25rpx;
		margin-bottom: -5rpx;
	}

	.empty-view {
		height: 100%;
		width: 100%;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}

	.empty-view .icon {
		height: 248rpx;
		width: 258rpx;
		margin-bottom: 10rpx;
	}

	.empty-view .text {
		width: auto;
		font-size: 28rpx;
		line-height: 35rpx;
		color: #999;
	}
</style>
