<template>
	<view>
		<view class="container">
			<tui-show-empty v-if="brandList.length == 0" text="暂无品牌~"></tui-show-empty>
			<view class="brand-list" v-else>
				<navigator :url="'/pages/category/category?brandId='+item.id" class="item"
					v-for="(item, index) in brandList" :key="index">
					<view class="img-bg">
						<image :src="item.appListPicUrl" background-size="cover"></image>
					</view>
					<view class="txt-box">
						<view class="line">
							<text class="name">{{item.name||''}}</text>
							<text class="s">|</text>
							<text class="price">{{item.floorPrice||''}}元起</text>
						</view>
						<view class="desc">
							{{ item.simpleDesc }}
						</view>
					</view>
				</navigator>
			</view>
		</view>
		<tui-nomore bgcolor="#fff"></tui-nomore>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				brandList: [],
				current: 1,
				limit: 10,
				pages: 1
			}
		},
		methods: {
			getBrandList: function() {
				let that = this;
				util.request('brand/brandList', {
					current: 1,
					limit: that.limit * that.current
				}).then(function(res) {
					if (res.code === 0) {
						that.brandList = res.data.records,
							that.pages = res.data.pages
					}
				});
			}
		},
		onLoad: function(options) {
			// 页面初始化 options为页面跳转所带来的参数
			this.getBrandList();
		},
		onReachBottom() {
			if (this.pages > this.current) {
				this.current = this.current + 1
			} else {
				return false;
			}

			this.getBrandList();
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.current = 1;
			this.getBrandList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		}
	}
</script>

<style>
	.brand-list .item {
		display: block;
		width: 750rpx;
		height: 416rpx;
		position: relative;
		margin-bottom: 4rpx;
	}

	.brand-list .item .img-bg {
		position: absolute;
		left: 0;
		top: 0;
		z-index: 0;
		width: 750rpx;
		height: 417rpx;
		overflow: hidden;
	}

	.brand-list .item .img-bg image {
		width: 750rpx;
		height: 416rpx;
	}

	.brand-list .item .txt-box {
		position: absolute;
		left: 0;
		top: 0;
		display: grid;
		z-index: 0;
		width: 750rpx;
		height: 417rpx;
	}

	.brand-list .item .line {
		display: table-cell;
		vertical-align: middle;
		text-align: center;
		height: 63rpx;
		line-height: 63rpx;
	}

	.brand-list .item .line .name {
		font-size: 35rpx;
		font-weight: 700;
		text-shadow: 1rpx 1rpx rgba(0, 0, 0, 0.32);
		color: #e41f19;
	}

	.brand-list .item .line .s {
		font-size: 35rpx;
		font-weight: 700;
		text-shadow: 1rpx 1rpx rgba(0, 0, 0, 0.32);
		color: #e41f19;
	}

	.brand-list .item .line .price {
		font-size: 35rpx;
		font-weight: 700;
		text-shadow: 1rpx 1rpx rgba(0, 0, 0, 0.32);
		color: #e41f19;
	}

	.brand-list .item .line .no-name {
		font-size: 40rpx;
		font-weight: 700;
		text-shadow: 1rpx 1rpx rgba(0, 0, 0, 0.32);
		color: #e41f19;
	}

	.brand-list .item .line .s {
		padding: 0 10rpx;
		font-size: 40rpx;
	}

	.brand-list .item .desc {
		padding: 0 10rpx;
		display: table-cell;
		vertical-align: middle;
		text-align: center;
	}
</style>
