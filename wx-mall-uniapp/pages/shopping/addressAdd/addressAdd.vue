<template>
	<view class="add-address">
		<view class="add-form">
			<view class="form-item">
				<label>姓名</label>
				<input class="input" placeholder="姓名" v-model="address.userName" auto-focus />
			</view>
			<view class="form-item">
				<label>手机号码</label>
				<input class="input" v-model="address.mobile" placeholder="手机号码" />
			</view>
			<view class="form-item">
				<label>选择区域</label>
				<!-- APP、H5使用自定义组件，需要自己定期维护全国地市数据 region-picker.js-->
				<!-- #ifdef APP-PLUS || H5 -->
				<tui-region-picker mode="region" @change="bindRegionChange" v-model="region">
					<view class="picker">
						{{address.provinceName}}{{address.cityName}}{{address.countyName}}
					</view>
				</tui-region-picker>
				<!-- #endif -->
				<!-- 非APP、H5使用原生组件 -->
				<!-- #ifndef APP-PLUS || H5 -->
				<picker mode="region" @change="bindRegionChange" v-model="region">
					<view class="picker">
						{{address.provinceName}}{{address.cityName}}{{address.countyName}}
					</view>
				</picker>
				<!-- #endif -->
			</view>
			<view class="form-item">
				<label>详细地址</label>
				<input class="input" v-model="address.detailInfo" placeholder="详细地址, 如街道、楼盘号等" />
				<image src="/static/images/mall/icon_address.png" @tap="bingAddressTap" class="location"></image>
			</view>
			<view class="form-default">
				<text @tap="bindIsDefault"
					:class="'default-input ' + (address.isDefault == 1 ? 'selected' : '')">设为默认地址</text>
			</view>
		</view>

		<view class="btns">
			<button class="cannel" @tap="cancelAddress">取消</button>
			<button class="save" @tap="saveAddress">保存</button>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	const app = getApp();
	const QQMapWX = require('@/libs/qqmap-wx-jssdk.min.js');
	// 调用接口
	let qqMap = new QQMapWX({
		key: util.qqMapKey
	})
	export default {
		data() {
			return {
				address: {
					id: '',
					provinceName: '',
					cityName: '',
					countyName: '',
					provinceId: 0,
					cityId: 0,
					countyId: 0,
					detailInfo: '',
					userName: '',
					mobile: '',
					isDefault: 0
				},
				latLong: {},
				addressId: 0,
				region: ['安徽省', '合肥市', '蜀山区']
			}
		},
		methods: {
			saveAddress() {
				let address = this.address;

				if (address.userName.trim() == '') {
					util.toast('请输入姓名');
					return false;
				}

				if (!util.isMobile(address.mobile)) {
					util.toast('请输入正确的手机号码');
					return false;
				}


				if (address.countyName == 0) {
					util.toast('请输入省市区');
					return false;
				}

				if (address.detailInfo == '') {
					util.toast('请输入详细地址');
					return false;
				}

				let that = this;
				util.request('address/saveOrUpdate', {
					id: address.id,
					userName: address.userName.trim(),
					mobile: address.mobile,
					provinceName: address.provinceName,
					cityName: address.cityName,
					countyName: address.countyName,
					detailInfo: address.detailInfo,
					isDefault: address.isDefault,
					latitude: that.latLong.latitude,
					longitude: that.latLong.longitude,
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						uni.navigateBack({
							fail() {
								uni.switchTab({
									url: '/pages/index/index',
								})
							}
						})
					}
				});
			},
			bindRegionChange: function(e) {
				var addr = this.address
				addr.provinceName = e.detail.value[0]
				addr.cityName = e.detail.value[1]
				addr.countyName = e.detail.value[2]
				addr.detailInfo = ''
				this.address = addr;
			},
			cancelAddress() {
				uni.navigateBack({
					fail() {
						uni.switchTab({
							url: '/pages/index/index',
						})
					}
				})
			},
			bingAddressTap: function() {
				var that = this;
				uni.chooseLocation({
					latitude: that.latLong.latitude,
					longitude: that.latLong.longitude,
					success: function(res) {
						if (null == res.latitude) {
							return;
						}
						that.latLong = {
							latitude: res.latitude,
							longitude: res.longitude
						};
						qqMap.reverseGeocoder({
							location: that.latLong,
							success: function(rs) {
								var address = that.address;
								address.provinceName = rs.result.address_component.province;
								address.cityName = rs.result.address_component.city;
								address.countyName = rs.result.address_component.district;
								address.detailInfo = rs.result.address_component.street + res
									.name
								that.address = address
								if (address.provinceName && address.cityName && address
									.countyName) {
									that.region = [address.provinceName, address.cityName,
										address.countyName
									]
								}
							},
							fail: function(rs) {
								that.getLocationFail(rs)
							},
							complete: function(rs) {}
						});
					},
					fail: function(rs) {
						that.getLocationFail(rs)
					}
				})
			},
			bindIsDefault() {
				let address = this.address;
				if (address.isDefault === 1) {
					address.isDefault = 0;
				} else {
					address.isDefault = 1;
				}
				this.address = address;
			},
			getAddressDetail() {
				let that = this;
				util.request('address/addressDetail', {
					id: that.addressId
				}).then(function(res) {
					if (res.code === 0 && null != res.data) {
						that.address = res.data
						that.latLong = {
							latitude: res.data.latitude,
							longitude: res.data.longitude
						};
					}
					that.initRegion();
				});
			},
			initRegion() {
				let that = this;
				if (null == that.addressId || that.addressId == 0) {
					uni.getLocation({
						success: function(res) {
							that.latLong = {
								latitude: res.latitude,
								longitude: res.longitude
							};
							qqMap.reverseGeocoder({
								location: that.latLong,
								success: function(rs) {
									var address = that.address;
									address.provinceName = rs.result.address_component.province;
									address.cityName = rs.result.address_component.city;
									address.countyName = rs.result.address_component.district;
									address.detailInfo = rs.result.address_component.street + rs
										.result.address_reference.landmark_l2.title
									that.address = address
									if (address.provinceName && address.cityName && address
										.countyName) {
										that.region = [address.provinceName, address.cityName,
											address.countyName
										]
									}
								},
								fail: function(rs) {
									that.getLocationFail(rs)
								},
								complete: function(rs) {}
							});
						},
						fail: function(rs) {
							that.getLocationFail(rs)
						}
					})
				} else {
					if (that.address.provinceName && that.address.cityName && that.address.countyName) {
						that.region = [that.address.provinceName, that.address.cityName, that.address.countyName]
					}
				}
			},
			getLocationFail(rs) {
				let that = this;
				var address = that.address;
				address.provinceName = "安徽省";
				address.cityName = "合肥市";
				address.countyName = "蜀山区";
				that.address = address
				if (address.provinceName && address.cityName && address.countyName) {
					that.region = [address.provinceName, address.cityName, address.countyName]
				}
				util.toast(JSON.stringify(rs), 5000)
			}
		},
		onLoad: function(options) {
			let that = this;
			// 页面初始化 options为页面跳转所带来的参数
			if (options.id && options.id != "0") {
				that.addressId = options.id;
				that.getAddressDetail();
			}
			that.initRegion();
		}
	}
</script>

<style>
	page {
		height: 100%;
		background: #f4f4f4;
	}

	.add-address .add-form {
		background: #fff;
		width: 100%;
		height: auto;
		overflow: hidden;
	}

	.add-address .form-item {
		height: 116rpx;
		padding-left: 31.25rpx;
		border-bottom: 1px solid #d9d9d9;
		display: flex;
		align-items: center;
		padding-right: 31.25rpx;
	}

	.add-address .form-item .location {
		height: 60rpx;
		width: 60rpx;
	}

	.add-address label {
		width: 160rpx;
		font-weight: bold;
	}

	.add-address .input {
		flex: 1;
		height: 44rpx;
		line-height: 44rpx;
		overflow: hidden;
	}

	.add-address .form-default {
		border-bottom: 1px solid #d9d9d9;
		height: 96rpx;
		background: #fafafa;
		padding-top: 28rpx;
		font-size: 28rpx;
	}

	.default-input {
		margin: 0 auto;
		display: block;
		width: 240rpx;
		height: 40rpx;
		padding-left: 50rpx;
		line-height: 40rpx;
		background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACYAAAAmCAMAAACf4xmcAAAABGdBTUEAALGPC/xhBQAAAAFzUkdCAK7OHOkAAABCUExURUdwTMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzMzAV+Z0EAAAAVdFJOUwAJ+KUEFTPay2bzRXdZ7RkhmJ6qJOWhY+QAAAEDSURBVDjLnZTplsIgDIUNWwK2tdt9/1cdxHGmVcAc+dH25Hw0+71cvjhztDIZM4mNc4txo+BwZKxSVwbSFoMn8iFuCeDrG0RLNkc6GGK+ttCZ8gIzuJcgBgPxJ4rB4T2OkM0HjgRyq8V7Y8i/3/V06YVb/nKECa0qBYPffB1jaFd8AD8+RrBrY8R41FkQew2MkPtrR6IeRglzoW1/HrbizfZ9Pv8jCH0slOAm+D7mMeUn4PoYwegxpVNlCsqCKMurbJay9R8GyT0HSTmWeciTYsh7K+MPK1MW0H9eQOU652sqcch+15rUrFQXLpuFy7ksXLYuXDUZbBZ9v4sqiqju34jyD97JD4dkfgo1AAAAAElFTkSuQmCC) no-repeat;
		background-size: 40rpx;
		font-size: 28rpx;
	}

	.default-input.selected {
		background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAADCElEQVRYR8VX3UsUURT/nXFnlCBFsweD6OMleuypgvI/qCgwwZ07gRahItEHIhgV9EUWFkkWgUFzB9GEoOil13rpqZ4i6KHPx6xQUNyd3TlxbzsyK+vu7LLLztPO7Dm/3++ee8655xJiPn+6ulqam5oOM3AEwE4G2gnYpNwZ+E3APIAvBLxYXFl52TY3txAHmkoZpYTY3UA0BOYeBlpK2av/CVgA0XSWeaJRyk/FfIoK8IW4RsAQA81xiNfaELDIwIQp5cX1/NcV4AvxDEBXJcQFfOZMKY8XwiooICPEVwa2V4lcwxDwLSHljgJRyv/kC/ELQHs1ySNY86aUm6PYeRHwhXgD4GCNyEPYt6aUneHLqgCVcABGa0wewl8PE1ML0KUGvKs022OI/khErcy8JZcPi1lgnypRLSDjOJPM3B8DqGwTBqYtKZNZxxkImB+shp7oYcJ1B4h7ezdmfP87gNay0Us4MPDEkrJPR9m2rxhElyMufxOmuY1SyeRRwzCeV52cedLyvEGF6wuhGtHVtRxBEByjtBAzBHRXUwAzj1uedz5HPgLgZiF8BmbJF+I9gD3VEhAw32j0PF1NWdu+EBDdLoL9QUXgBwFbCxi9DpgfGURqBXtjCWS+ZHqeDnVaiLMEjBfzY+CnisASgA1rDRmYsqQ8yX19bX46fY8AUVQE0bDpunq1accZIub7MUQvrytAOTPgWFLKYomUsztjSakJs7bdHxBNxiBXJsvFtkBjMNGg5boaMOU4PQ3MdxjoCAkYOG1J+Vi9Z4Q4xYD+HecJt6B0EjKPmJ53S0fCcfYz8xgBB4j5RMLz3FzYe4l5Kg5xxEYnYawyZOCuJeU55bxk2x2NhtGZcN1ZvXLbdpjoaZnkaotny2pEBLxKSHkoSpSy7aRB5JVLrux1I6qgFX82pdylV+443cw8Uwk5gP+tOAdU/mFENAzmsQrJQeFhpLO79sdxnk41rOYdx7k6r99AEsqr60gWEVG/oTQUUdexPBKJ+l1MIiLqdzULRdT1chot3lpdz/8B8ZZpDg1sAlkAAAAASUVORK5CYII=) no-repeat;
		background-size: 40rpx;
	}

	.add-address .btns {
		position: fixed;
		bottom: 0;
		left: 0;
		overflow: hidden;
		display: flex;
		height: 100rpx;
		width: 100%;
	}

	.add-address .cannel,
	.add-address .save {
		flex: 1;
		height: 100rpx;
		text-align: center;
		line-height: 100rpx;
		font-size: 28rpx;
		color: #fff;
		border: none;
		border-radius: 0;
	}

	.add-address .cannel {
		background: #333;
	}

	.add-address .save {
		background: #e41f19;
	}

	.region-select {
		width: 100%;
		height: 600rpx;
		background: #fff;
		position: fixed;
		z-index: 10;
		left: 0;
		bottom: 0;
	}

	.region-select .hd {
		height: 108rpx;
		width: 100%;
		border-bottom: 1px solid #f4f4f4;
		padding: 46rpx 30rpx 0 30rpx;
	}

	.region-select .region-selected {
		float: left;
		height: 60rpx;
		display: flex;
	}

	.region-select .region-selected .item {
		max-width: 140rpx;
		margin-right: 30rpx;
		text-align: left;
		line-height: 60rpx;
		height: 100%;
		color: #333;
		font-size: 28rpx;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}

	.region-select .region-selected .item.disabled {
		color: #999;
	}

	.region-select .region-selected .item.selected {
		color: #b4282d;
	}

	.region-select .done {
		float: right;
		height: 60rpx;
		width: 60rpx;
		border: none;
		background: #fff;
		line-height: 60rpx;
		text-align: center;
		color: #333;
		font-size: 28rpx;
	}

	.region-select .done.disabled {
		color: #999;
	}

	.region-select .bd {
		height: 492rpx;
		width: 100%;
		padding: 0 30rpx;
	}

	.region-select .region-list {
		height: auto;
		overflow: scroll;
	}

	.region-select .region-list .item {
		width: 100%;
		height: 104rpx;
		line-height: 104rpx;
		text-align: left;
		color: #333;
		font-size: 28rpx;
	}

	.region-select .region-list .item.selected {
		color: #b4282d;
	}

	.bg-mask {
		height: 100%;
		width: 100%;
		background: rgba(0, 0, 0, 0.4);
		position: fixed;
		top: 0;
		left: 0;
		z-index: 8;
	}
</style>
