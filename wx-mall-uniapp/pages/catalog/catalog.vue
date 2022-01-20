<template>
	<view class="container">
		<view class="tui-searchbox">
			<view class="tui-search-input" @tap="search">
				<icon type="search" :size="13" color="#999"></icon>
				<text class="tui-search-text">商品搜索，共款{{goodsCount}}好物</text>
			</view>
		</view>

		<scroll-view scroll-y scroll-with-animation class="tab-view" :scroll-into-view="scrollViewId"
			:style="{ height: height + 'px', top: top + 'px' }">
			<view :id="`id_${index}`" v-for="(item, index) in tabbar" :key="index" class="tab-bar-item"
				:class="[currentTab == index ? 'active' : '']" :data-current="index" :data-id="item.id"
				@tap.stop="swichNav">
				<text>{{ item.name||'' }}</text>
			</view>
		</scroll-view>
		<block>
			<scroll-view scroll-y class="right-box" :style="{ height: height + 'px', top: top + 'px' }">
				<!--内容部分 start 自定义可删除-->
				<view class="page-view">
					<swiper indicator-dots autoplay circular :interval="5000" :duration="150" class="swiper">
						<swiper-item>
							<image :src="currentCategory.imgUrl" class="slide-image" />
						</swiper-item>
					</swiper>
					<view class="class-box">
						<view class="class-item">
							<view class="class-name">{{ currentCategory.frontName||'' }}</view>
							<view class="g-container">
								<view class="g-box" @tap.stop="goCategory(item.id)"
									v-for="(item, index) in currentCategory.subCategoryList" :key="index">
									<image :src="item.iconUrl" class="g-image" />
									<view class="g-title">{{item.name||''}}</view>
								</view>
							</view>
						</view>
					</view>
				</view>
				<!--内容部分 end 自定义可删除-->
			</scroll-view>
		</block>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				goodsCount: 0,
				tabbar: [],
				currentCategory: {},
				height: 0, //scroll-view高度
				top: 0,
				currentTab: 0, //预设当前项的值
				scrollViewId: "id_0"
			};
		},
		methods: {
			getCatalog: function() {
				let that = this;
				util.request('category/categoryList', {
					level: 1
				}).then(function(res) {
          if (res.code === 0) {
            that.tabbar = res.data
            that.getCurrentCategory(res.data[that.currentTab].id)
          }
				});
				util.request('goods/count').then(function(res) {
          if (res.code === 0) {
            that.goodsCount = res.data
          }
				});
			},
			getCurrentCategory: function(id) {
				let that = this;
				util.request('category/current', {
					id: id
				}).then(function(res) {
          if (res.code === 0) {
            that.currentCategory = res.data
          }
				});
			},
			// 点击标题切换当前页时改变样式
			swichNav: function(e) {
				let cur = e.currentTarget.dataset.current;
				let id = e.currentTarget.dataset.id;
				if (this.currentTab == cur) {
					return false;
				} else {
					this.currentTab = cur;
					this.checkCor();
				}
				this.getCurrentCategory(id)
			},
			//判断当前滚动超过一屏时，设置tab标题滚动条。
			checkCor: function() {
				if (this.currentTab > 6) {
					this.scrollViewId = `id_${this.currentTab - 2}`;
				} else {
					this.scrollViewId = `id_0`;
				}
			},
			search: function() {
				uni.navigateTo({
					url: '/pages/category/category?showSearchHistory=' + true
				})
			},
			goCategory: function(id) {
				uni.navigateTo({
					url: '/pages/category/category?categoryId=' + id
				})
			}
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getCatalog();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onShow: function(options) {
			let that = this;
			that.getCatalog();
			setTimeout(() => {
				uni.getSystemInfo({
					success: res => {
						let header = 92;
						let top = 0;
						//#ifdef H5
						top = 44;
						//#endif
						that.height = res.windowHeight - uni.upx2px(header);
						that.top = top + uni.upx2px(header);
					}
				});
			}, 50);
		}
	};
</script>

<style>
	page {
		background: #fcfcfc;
	}

	/* 左侧导航布局 start*/

	/* 隐藏scroll-view滚动条*/

	::-webkit-scrollbar {
		width: 0;
		height: 0;
		color: transparent;
	}

	.tui-searchbox {
		width: 100%;
		height: 92rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
		background: #fff;
		display: flex;
		align-items: center;
		justify-content: center;
		position: fixed;
		left: 0;
		top: 0;
		/* #ifdef H5 */
		top: 44px;
		/* #endif */
		z-index: 100;
	}

	.tui-searchbox::after {
		content: '';
		position: absolute;
		border-bottom: 1rpx solid #d2d2d2;
		-webkit-transform: scaleY(0.5);
		transform: scaleY(0.5);
		bottom: 0;
		right: 0;
		left: 0;
	}

	.tui-search-input {
		width: 100%;
		height: 60rpx;
		background: #f1f1f1;
		border-radius: 30rpx;
		font-size: 26rpx;
		color: #999;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.tui-search-text {
		padding-left: 16rpx;
	}

	.tab-view {
		/* height: 100%; */
		width: 200rpx;
		position: fixed;
		left: 0;
		z-index: 10;
	}

	.tab-bar-item {
		width: 200rpx;
		height: 110rpx;
		background: #f6f6f6;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 26rpx;
		color: #444;
		font-weight: 400;
	}

	.active {
		position: relative;
		color: #000;
		font-size: 30rpx;
		font-weight: 600;
		background: #fcfcfc;
	}

	.active::before {
		content: '';
		position: absolute;
		border-left: 8rpx solid #e41f19;
		height: 30rpx;
		left: 0;
	}

	/* 左侧导航布局 end*/

	.right-box {
		width: 100%;
		position: fixed;
		padding-left: 220rpx;
		box-sizing: border-box;
		left: 0;
	}

	.page-view {
		width: 100%;
		overflow: hidden;
		padding-top: 20rpx;
		padding-right: 20rpx;
		box-sizing: border-box;
		padding-bottom: env(safe-area-inset-bottom);
	}

	.swiper {
		width: 100%;
		height: 220rpx;
		border-radius: 12rpx;
		overflow: hidden;
		transform: translateZ(0);
	}

	/* #ifdef MP-WEIXIN */
	.swiper .wx-swiper-dot {
		width: 8rpx;
		height: 8rpx;
		display: inline-flex;
		background: none;
		justify-content: space-between;
	}

	.swiper .wx-swiper-dot::before {
		content: '';
		flex-grow: 1;
		background: rgba(255, 255, 255, 0.8);
		border-radius: 16rpx;
		overflow: hidden;
	}

	.swiper .wx-swiper-dot-active::before {
		background: #fff;
	}

	.swiper .wx-swiper-dot.wx-swiper-dot-active {
		width: 16rpx;
	}

	/* #endif */

	/* #ifndef MP-WEIXIN */
	>>>.swiper .uni-swiper-dot {
		width: 8rpx;
		height: 8rpx;
		display: inline-flex;
		background: none;
		justify-content: space-between;
	}

	>>>.swiper .uni-swiper-dot::before {
		content: '';
		flex-grow: 1;
		background: rgba(255, 255, 255, 0.8);
		border-radius: 16rpx;
		overflow: hidden;
	}

	>>>.swiper .uni-swiper-dot-active::before {
		background: #fff;
	}

	>>>.swiper .uni-swiper-dot.uni-swiper-dot-active {
		width: 16rpx;
	}

	/* #endif */

	.slide-image {
		width: 100%;
		height: 220rpx;
	}

	.class-box {
		padding-top: 30rpx;
	}

	.class-item {
		background: #fff;
		width: 100%;
		box-sizing: border-box;
		padding: 20rpx;
		margin-bottom: 20rpx;
		border-radius: 12rpx;
	}

	.class-name {
		font-size: 22rpx;
	}

	.g-container {
		/* padding-top: 20rpx; */
		display: flex;
		display: -webkit-flex;
		justify-content: flex-start;
		flex-direction: row;
		flex-wrap: wrap;
	}

	.g-box {
		width: 33.3333%;
		text-align: center;
		padding-top: 40rpx;
	}

	.g-image {
		width: 120rpx;
		height: 120rpx;
	}

	.g-title {
		font-size: 22rpx;
	}
</style>
