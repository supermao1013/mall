<template>
	<view class="container">
		<!--screen-->
		<view class="tui-header-screen">
			<view class="tui-screen-top">
				<view class="tui-top-item tui-active tui-bold" @tap="screen" data-index="1">距离
					<tui-icon :name="selectOrder ? 'arrowup' : 'arrowdown'" :size="14" color="#e41f19"></tui-icon>
				</view>
				<view class="tui-top-item" @tap="screen" data-index="2">
					<tui-icon :name="isList ? 'manage' : 'listview'" :size="isList ? 22 : 18"
						:bold="isList ? false : true" color="#333"></tui-icon>
				</view>
			</view>
		</view>
		<!--screen-->

		<!--list-->
		<view class="tui-product-list" :style="{ marginTop: px(18) }">
			<view class="tui-product-container">
				<block v-for="(item, index) in shopsList" :key="index" v-if="(index + 1) % 2 != 0 || isList">
					<!--商品列表-->
					<view class="tui-pro-item" :class="[isList ? 'tui-flex-list' : '']" hover-class="tui-hover"
						:hover-start-time="150">
						<image :src="item.imgUrl" class="tui-pro-img" :class="[isList ? 'tui-proimg-list' : '']"
							mode="widthFix" @tap="detail(item.shopsSn)" />
						<view class="tui-pro-content" @tap="detail(item.shopsSn)">
							<view class="tui-pro-tit">{{ item.name||'' }}</view>
							<view>
								<view class="tui-pro-price">
									<text class="tui-factory-price">{{ item.workTime||'' }}</text>
								</view>
								<view class="tui-pro-pay" :data-longitude="item.longitude"
									:data-latitude="item.latitude" :data-name="item.name" :data-address="item.details"
									@tap="goHere">
									<image src='/static/images/mall/icon_address.png' style="width: 24rpx; height: 24rpx;">
									</image>{{ item.details||'' }} {{ '(距您' + item.distant + '公里)'}}
								</view>
							</view>
						</view>
					</view>
					<!--商品列表-->
				</block>
			</view>
			<view class="tui-product-container" v-if="!isList">
				<block v-for="(item, index) in shopsList" :key="index" v-if="(index + 1) % 2 == 0">
					<!--商品列表-->
					<view class="tui-pro-item" :class="[isList ? 'tui-flex-list' : '']" hover-class="tui-hover"
						:hover-start-time="150">
						<image :src="item.imgUrl" class="tui-pro-img" :class="[isList ? 'tui-proimg-list' : '']"
							mode="widthFix" @tap="detail(item.shopsSn)" />
						<view class="tui-pro-content" @tap="detail(item.shopsSn)">
							<view class="tui-pro-tit">{{ item.name||'' }}</view>
							<view>
								<view class="tui-pro-price">
									<text class="tui-factory-price">{{ item.workTime||'' }}</text>
								</view>
								<view class="tui-pro-pay" :data-longitude="item.longitude"
									:data-latitude="item.latitude" :data-name="item.name" :data-address="item.details"
									@tap="goHere">
									<image src='/static/images/mall/icon_address.png' style="width: 24rpx; height: 24rpx;">
									</image>{{ item.details||'' }} {{ '(距您' + item.distant + '公里)'}}
								</view>
							</view>
						</view>
					</view>
					<!--商品列表-->
				</block>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				selectOrder: true,
				latitude: '',
				longitude: '',
				tabIndex: 0, //顶部筛选索引
				isList: false, //是否以列表展示  | 列表或大图
				shopsList: []
			};
		},
		onLoad: function(options) {
			let that = this;
			util.request('shops/shopsList').then(res => {
				if (res.code === 0) {
					that.findXy(res.data);
				}
			});
		},
		methods: {
			goHere: function(e) {
				uni.openLocation({
					name: e.currentTarget.dataset.name,
					address: e.currentTarget.dataset.address,
					latitude: parseFloat(e.currentTarget.dataset.latitude),
					longitude: parseFloat(e.currentTarget.dataset.longitude)
				})
			},
			// 获取用户的经纬度
			findXy: function(data) {
				let that = this
				uni.getLocation({
					type: 'gcj02',
					success(res) {
						that.latitude = res.latitude
						that.longitude = res.longitude

						data.forEach(function(item) {
							item.distant = util.getDistance(that.latitude, that.longitude, item
								.latitude, item.longitude)
						})
						that.shopsList = data.sort(function(a, b) {
							if (that.selectOrder) {
								return a.distant - b.distant
							} else {
								return b.distant - a.distant
							}
						})
					}
				})
			},
			screen: function(e) {
				let that = this
				let index = e.currentTarget.dataset.index;
				if (index == 1) {
					that.tabIndex = 1;
					that.selectOrder = !that.selectOrder
					that.shopsList.sort(function(a, b) {
						if (that.selectOrder) {
							return a.distant - b.distant
						} else {
							return b.distant - a.distant
						}
					})
				} else if (index == 2) {
					that.isList = !that.isList;
				}
			},
			px(num) {
				return uni.upx2px(num) + 'px';
			},
			detail: function(shopsSn) {
				uni.navigateTo({
					url: '/pages/shops/shops?shopsSn=' + shopsSn
				});
			}
		}
	};
</script>

<style>
	page {
		background-color: #f7f7f7;
	}

	.container {
		padding-bottom: env(safe-area-inset-bottom);
	}

	/* 隐藏scroll-view滚动条*/

	::-webkit-scrollbar {
		width: 0;
		height: 0;
		color: transparent;
	}

	.tui-header-box {
		width: 100%;
		background: #fff;
		position: fixed;
		z-index: 1001;
		left: 0;
		top: 0;
	}

	.tui-header-screen {
		width: 100%;
		box-sizing: border-box;
		background: #fff;
		position: fixed;
		z-index: 1000;
	}

	.tui-screen-top,
	.tui-screen-bottom {
		display: flex;
		align-items: center;
		justify-content: space-between;
		font-size: 28rpx;
		color: #333;
	}

	.tui-screen-top {
		height: 88rpx;
		position: relative;
		background: #fff;
	}

	.tui-top-item {
		height: 28rpx;
		line-height: 28rpx;
		flex: 1;
		display: flex;
		align-items: center;
		justify-content: center;
	}


	.tui-bold {
		font-weight: bold;
	}

	.tui-active {
		color: #e41f19;
	}


	.tui-product-list {
		display: flex;
		justify-content: space-between;
		flex-direction: row;
		flex-wrap: wrap;
		box-sizing: border-box;
		position: relative;
		top: 90rpx;
	}

	.tui-product-container {
		flex: 1;
		margin-right: 10rpx;
	}

	.tui-product-container:last-child {
		margin-right: 0;
	}

	.tui-pro-item {
		width: 100%;
		margin-bottom: 10rpx;
		background: #fff;
		box-sizing: border-box;
		border-radius: 12rpx;
		overflow: hidden;
		transition: all 0.15s ease-in-out;
	}

	.tui-flex-list {
		display: flex;
		margin-bottom: 1rpx !important;
	}

	.tui-pro-img {
		width: 100%;
		display: block;
	}

	.tui-proimg-list {
		width: 260rpx;
		flex-shrink: 0;
		border-radius: 12rpx;
	}

	.tui-pro-content {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		box-sizing: border-box;
		padding: 20rpx;
	}

	.tui-pro-tit {
		color: #2e2e2e;
		font-size: 34rpx;
		font-weight: bold;
		word-break: break-all;
		overflow: hidden;
		text-overflow: ellipsis;
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 2;
	}

	.tui-sale-price {
		font-size: 34rpx;
		font-weight: 500;
		color: #e41f19;
	}

	.tui-factory-price {
		font-size: 22rpx;
		color: #ADB838;
	}

	.tui-pro-pay {
		padding-top: 10rpx;
		font-size: 20rpx;
		color: #656565;
	}

	/* 商品列表*/
</style>
