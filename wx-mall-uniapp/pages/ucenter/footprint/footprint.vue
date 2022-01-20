<template>
	<view class="container">
		<tui-show-empty v-if="footprintList.length<=0" text="浏览记录为空"></tui-show-empty>
		<view class="footprint" v-else>
			<view class="day-list">
				<view class="item" v-for="(item, index) in footprintList" :key="index">
					<tui-swipe-action :actions="actions" @click="deleteItem(item.id)">
						<view slot="content">
							<view @tap="goodsDetail(item.goodsId)">
								<image class="img" :src="item.listPicUrl"></image>
								<view class="info">
									<view class="name">{{item.goodsName}}</view>
									<view class="subtitle">{{item.goodsBrief}}</view>
									<view class="price">￥{{item.retailPrice}}</view>
								</view>
							</view>
						</view>
					</tui-swipe-action>
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
				footprintList: [],
				actions: [{
					name: '删除',
					color: '#fff',
					fontsize: '22',
					width: 80,
					background: '#ed3f14'
				}]
			}
		},
		methods: {
			goodsDetail: function(goodsId) {
				uni.navigateTo({
					url: '/pages/goods/goods?id=' + goodsId,
				})
			},
			getFootprintList() {
				let that = this;
				var tmpFootPrint;
				util.request('user/footprintList').then(function(res) {
					if (res.code === 0) {
						if (res.data != undefined) {
							tmpFootPrint = res.data.records;
						} else {
							tmpFootPrint = [];
						}
						that.footprintList = tmpFootPrint
					}
				});
			},
			deleteItem(id) {
				let that = this;
				util.request('user/deleteFootPrint', {
					footprintId: id
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						that.getFootprintList();
					} else {
						util.toast(res.msg);
					}
				});
			}
		},
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getFootprintList();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onLoad: function(options) {
			this.getFootprintList();
		}
	}
</script>

<style>
	page {
		background: #f4f4f4;
		min-height: 100%;
	}

	.container {
		background: #f4f4f4;
		min-height: 100%;
	}


	.day-hd {
		height: 94rpx;
		width: 100%;
		line-height: 94rpx;
		background: #fff;
		padding-left: 30rpx;
		color: #333;
		font-size: 28rpx;
	}

	.day-list {
		height: auto;
		overflow: hidden;
		border-top: 1px solid #e1e1e1;
	}

	.item {
		margin: 10rpx;
	}

	.item .img {
		float: left;
		width: 150rpx;
		height: 150rpx;
	}

	.item .info {
		display: flex;
		flex-direction: column;
		justify-content: center;
		padding-left: 20rpx;
		padding-top: 20rpx;
	}

	.item .info .name {
		font-size: 28rpx;
		color: #333;
	}

	.item .info .subtitle {
		margin-top: 8rpx;
		font-size: 24rpx;
		color: #888;
	}

	.item .info .price {
		margin-top: 8rpx;
		font-size: 28rpx;
		color: #e41f19;
	}

	/*自定义按钮*/

	.i-swipeout-demo-button-group {
		height: 100%;
		width: 100%;
	}

	.i-swipeout-demo-button {
		width: 100px;
		float: left;
		display: flex;
		height: 100%;
		justify-content: center;
		background: #e41f19;
		color: #fff;
		align-items: center;
	}
</style>
